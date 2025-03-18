@istest
private class RET_TaxSubmissionSummaryControllerTest {
	@testsetup
	static void createData() {
		insert new Account(Name = 'Real Estate Tax Bucket');
		RET_GREX_Integration_Settings__c cs1 = new RET_GREX_Integration_Settings__c();
		cs1.Endpoint_URL__c = 'https://test.com';
		insert cs1;
		List<RET_GREX_Integration_Email_Settings__c> intEmailList = new List<RET_GREX_Integration_Email_Settings__c>();
		RET_GREX_Integration_Email_Settings__c cs2 = new RET_GREX_Integration_Email_Settings__c();
		cs2.Name = 'Integration Failure';
		cs2.To_Address__c = 'xyz@test.com';
		cs2.Email_Subject__c = 'test email';
		cs2.Sender_Display_Name__c = 'Test Sender';
		cs2.Email_Body__c = 'Test Body';
		intEmailList.add(cs2);
		RET_GREX_Integration_Email_Settings__c cs3 = new RET_GREX_Integration_Email_Settings__c();
		cs3.Name = 'O&M Integration Failure';
		cs3.To_Address__c = 'xyz@test.com';
		cs3.Email_Subject__c = 'test email';
		cs3.Sender_Display_Name__c = 'Test Sender';
		cs3.Email_Body__c = 'Test Body';
		intEmailList.add(cs3);
		RET_GREX_Integration_Email_Settings__c cs4 = new RET_GREX_Integration_Email_Settings__c();
		cs4.Name = 'GREX Team Integration Failure';
		cs4.To_Address__c = 'xyz@test.com';
		cs4.Email_Subject__c = 'test email';
		cs4.Sender_Display_Name__c = 'Test Sender';
		cs4.Email_Body__c = 'Test Body';
		intEmailList.add(cs4);
		insert intEmailList;

		//Create Lease Record
		PBS_Lease__c leaseRec = new PBS_Lease__c(
			Name = 'Test Lease',
			Lease_Number__c = '1234',
			Lease_Effective_Date__c = date.today()
		);
		insert leaseRec;
		System.assertNotEquals(null, leaseRec.Id, 'DML - insertion issue');

		insert new PBS_Lease_Access__c(PBS_Lease__c = leaseRec.Id, Requestor__c = UserInfo.getUserId(), Status__c = 'POC');

		//create a case record
		Case tmpCase = new case(
			origin = 'Web',
			Status = 'Submitted',
			RET_Last_Submission_Date__c = datetime.now().addDays(-1),
			RET_Base_Tax_Year__c = '2017',
			PBS_Lease__c = leaseRec.id,
			RET_Tax_County__c = 'US'
		);
		insert tmpCase;

		List<Attachment> collAtt = new List<Attachment>();
		collAtt.add(
			new Attachment(parentid = tmpCase.Id, name = 'Bill desk', body = Blob.valueOf('Unit Test Attachment Body'))
		);
		collAtt.add(
			new Attachment(parentid = tmpCase.Id, name = 'Bill desk2', body = Blob.valueOf('Unit Test Attachment Body'))
		);
		collAtt.add(
			new Attachment(parentid = tmpCase.Id, name = 'Bill desk3', body = Blob.valueOf('Unit Test Attachment Body'))
		);

		insert collAtt;

		List<RET_Document_Data__c> collDocData = new List<RET_Document_Data__c>();
		collDocData.add(
			new RET_Document_Data__c(
				Attachment_ID__c = collAtt[0].Id,
				name = 'test ret',
				Full_File_Name__c = 'ret test',
				Tax_Year__c = '2017',
				Document_Type__c = 'Real Estate Tax - Bill',
				Tax_Bill_Frequency__c = 'Annual',
				Tax_Block_Number__c = '123',
				Tax_Lot_Number__c = 'ABC',
				Tax_Period_Start__c = date.today().addyears(-2),
				Tax_Period_End__c = date.today().addyears(-1)
			)
		);
		collDocData.add(
			new RET_Document_Data__c(
				Attachment_ID__c = collAtt[1].Id,
				name = 'test ret',
				Full_File_Name__c = 'ret test',
				Tax_Year__c = '2017',
				Document_Type__c = 'Real Estate Tax - Appeal Notice',
				Tax_Bill_Frequency__c = 'Annual',
				Tax_Block_Number__c = '123',
				Tax_Lot_Number__c = 'ABC',
				Tax_Period_Start__c = date.today().addyears(-3),
				Tax_Period_End__c = date.today().addyears(-2)
			)
		);
		collDocData.add(
			new RET_Document_Data__c(
				Attachment_ID__c = collAtt[2].Id,
				name = 'test ret',
				Full_File_Name__c = 'ret test',
				Tax_Year__c = '2017',
				Document_Type__c = 'Proof of Ownership',
				Tax_Bill_Frequency__c = 'Annual',
				Tax_Block_Number__c = '123',
				Tax_Lot_Number__c = 'ABC',
				Tax_Period_Start__c = date.today().addyears(-1),
				Tax_Period_End__c = date.today()
			)
		);

		insert collDocData;

		List<RET_Required_Documents__c> collReqDocs = new List<RET_Required_Documents__c>();
		collReqDocs.add(
			new RET_Required_Documents__c(
				name = 'Real Estate Tax - Bill',
				Document_Name__c = 'Real Estate Tax - Bill',
				minimum_quantity__c = 1
			)
		);
		collReqDocs.add(
			new RET_Required_Documents__c(
				name = 'Real Estate Tax - Appeal Notice',
				Document_Name__c = 'Real Estate Tax - Appeal Notice',
				minimum_quantity__c = 1
			)
		);
		collReqDocs.add(
			new RET_Required_Documents__c(
				name = 'Proof of Ownership',
				Document_Name__c = 'Proof of Ownership',
				minimum_quantity__c = 2
			)
		);
		insert collReqDocs;
	}
	@isTest
	static void SubmitCasePositiveScenario() {
		case caseRec = [
			SELECT
				id,
				RET_Last_Submission_Date__c,
				PBS_Lease__r.Lease_Number__c,
				PBS_Lease__c,
				RET_Base_Tax_Year__c,
				RET_Tax_County__c
			FROM case
			LIMIT 1
		];
		Map<String, String> tmpData = RET_TaxSubmissionSummaryController.getPageData();
		system.assertEquals(1, tmpData.values().size());
		system.assertEquals(true, tmpData.containskey('userName'));
		List<String> tmpList = RET_TaxSubmissionSummaryController.getDocumentTypes();
		set<String> tmpSet = new Set<String>(tmpList);
		Schema.DescribeFieldResult fieldResult = RET_Document_Data__c.Document_Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		system.assertEquals(ple.size(), tmpList.size());
		System.assertEquals(true, tmpSet.contains(ple[0].getLabel()));
		tmpList = RET_TaxSubmissionSummaryController.validateDocuments(caseRec);
		tmpSet = new Set<String>(tmpList);
		system.assertEquals(true, tmpSet.contains('Proof of Ownership')); //created records in this type
		case recCase = RET_TaxSubmissionSummaryController.getCase(caseRec.Id);
		system.assertEquals('1234', recCase.PBS_Lease__r.Lease_Number__c);
		recCase.RET_Base_Tax_Year__c = '2018';
		case recCase1 = RET_TaxSubmissionSummaryController.saveCase(caseRec);
		system.assertNotEquals('2018', recCase1.RET_Base_Tax_Year__c);
		test.startTest();
		test.setMock(HttpCalloutMock.class, new TaxSubmissionSummaryCalloutMockImpl());
		Boolean tmpOut;
		try {
			tmpOut = RET_TaxSubmissionSummaryController.submitTaxCase(caseRec);
		} catch (Exception e) {
			System.assertEquals(null, tmpOut);
		}
		test.stopTest();
	}
	@isTest
	static void SubmitCaseExceptions() {
		case tmpCase = [
			SELECT
				id,
				PBS_Lease__c,
				RET_Submission_Comments__c,
				PBS_Lease__r.Lease_Number__c,
				RET_Last_Submission_Date__c,
				RET_Base_Tax_Year__c
			FROM case
			LIMIT 1
		];
		RET_Document_Data__c tmpRet = [SELECT id FROM RET_Document_Data__c LIMIT 1];
		case recCase;
		try {
			//exception if no caseid
			recCase = RET_TaxSubmissionSummaryController.getCase(null);
		} catch (exception e) {
			System.assertEquals(null, recCase);
		}
		try {
			//exception if wrong ID sent as caseid
			recCase = RET_TaxSubmissionSummaryController.getCase(tmpRet.id);
		} catch (exception e) {
			System.assertEquals(null, recCase);
		}
		try {
			//exception with null
			recCase = RET_TaxSubmissionSummaryController.saveCase(null);
		} catch (exception e) {
			System.assertEquals(null, recCase);
		}
		try {
			//exception when year value not Number
			tmpCase.RET_Base_Tax_Year__c = 'abc';
			recCase = RET_TaxSubmissionSummaryController.saveCase(tmpCase);
		} catch (exception e) {
			System.assertEquals(null, recCase);
		}
		tmpCase.RET_Base_Tax_Year__c = '';
		tmpCase.RET_Last_Submission_Date__c = null;
		tmpCase.RET_Tax_County__c = '';
		update tmpCase;

		Boolean tmpout;
		try {
			tmpout = RET_TaxSubmissionSummaryController.submitTaxCase(tmpCase);
		} catch (exception e) {
			System.assertEquals(null, tmpout);
		}
	}
}