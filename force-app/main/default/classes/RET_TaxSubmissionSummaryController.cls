public without sharing class RET_TaxSubmissionSummaryController {
	@AuraEnabled
	public static Map<String, String> getPageData() {
		Map<String, String> pageData = new Map<String, String>();
		pageData.put('userName', userinfo.getName());
		return pageData;
	}

	@AuraEnabled
	public static List<String> getDocumentTypes() {
		List<String> docTypes = new List<String>();
		Schema.DescribeFieldResult fieldResult = RET_Document_Data__c.Document_Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry pickListVal : ple) {
			docTypes.add(pickListVal.getLabel());
		}
		return docTypes;
	}

	@AuraEnabled
	public static Case getCase(String caseId) {
		if (String.isBlank(caseId)) {
			throw new AuraHandledException(System.Label.RET_Case_Not_Found);
		} else {
			// Check that the User has been approved to view the Lease with the Case:
			try {
				final Case[] caseList = [
					SELECT
						(
							SELECT
								Id,
								Account.Name,
								PBS_Lease__r.Lessor__c,
								PBS_Lease__r.PBS_Building__c,
								PBS_Lease__r.Lease_Number__c,
								PBS_Lease__r.Building_Street_Address__c,
								PBS_Lease__r.Building_City__c,
								PBS_Lease__r.Short_Lease_Number__c,
								PBS_Lease__r.Building_State_Code__c,
								PBS_Lease__r.Building_Zip_Code__c,
								Status,
								Owner.Name,
								RET_Base_Tax_Year__c,
								RET_Tax_County__c,
								RET_Editable_by_Submitter__c,
								RET_Last_Submission_Date__c,
								RET_Initial_Submission_Date__c,
								RET_Submission_Comments__c
							FROM Cases__r
							WHERE Id = :caseId
							LIMIT 1
						)
					FROM PBS_Lease__c
					WHERE
						Id IN (
							SELECT PBS_Lease__c
							FROM PBS_Lease_Access__c
							WHERE Requestor__c = :UserInfo.getUserId() AND Status__c IN ('Approved', 'POC')
						)
						AND Id IN (SELECT PBS_Lease__c FROM Case WHERE Id = :caseId)
					LIMIT 1
				]
				.Cases__r;
				return caseList[0];
			} catch (QueryException qe) {
				throw new AuraHandledException(System.Label.RET_Case_Not_Found);
			}
		}
	}

	@AuraEnabled
	public static Case saveCase(Case caseToSave) {
		try {
			update caseToSave;
		} catch (DmlException dmle) {
			throw new AuraHandledException(dmle.getDmlMessage(0));
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
		return caseToSave;
	}

	@AuraEnabled
	public static List<String> validateDocuments(Case caseToSubmit) {
		List<String> missingDocList = new List<String>();
		Set<Id> allAttachmentsIdsToThisCase = new Set<id>();
		Map<String, Integer> mapCasetoDoctypes = new Map<String, Integer>();
		if (caseToSubmit != null) {
			for (Attachment att : [SELECT Id, Name FROM Attachment WHERE parentId = :caseToSubmit.Id]) {
				allAttachmentsIdsToThisCase.add(att.Id);
			}
			for (RET_Document_Data__c ret : [
				SELECT Id, Document_Type__c
				FROM RET_Document_Data__c
				WHERE Attachment_ID__c IN :allAttachmentsIdsToThisCase
			]) {
				if (!mapCasetoDoctypes.containskey(ret.Document_Type__c)) {
					mapCasetoDoctypes.put(ret.Document_Type__c, 0);
				}
				mapCasetoDoctypes.put(ret.Document_Type__c, mapCasetoDoctypes.get(ret.Document_Type__c) + 1);
			}
			for (RET_Required_Documents__c retDoc : RET_Required_Documents__c.getAll().values()) {
				if (!mapCasetoDoctypes.containskey(retDoc.Document_Name__c)) {
					missingDocList.add(retDoc.Document_Name__c);
				} else if ((retdoc.Minimum_Quantity__c > mapCasetoDoctypes.get(retDoc.Document_Name__c))) {
					missingDocList.add(retDoc.Document_Name__c);
				}
			}
		}
		return missingDocList;
	}

	@AuraEnabled
	public static Boolean submitTaxCase(Case caseToSubmit) {
		Datetime caseLastSubmitted = caseToSubmit.RET_Last_Submission_Date__c;
		if (caseLastSubmitted == null) {
			caseLastSubmitted = caseToSubmit.createdDate;
		}
		caseToSubmit.Status = 'Submitted';
		if (caseToSubmit.RET_Initial_Submission_Date__c == null) {
			caseToSubmit.RET_Initial_Submission_Date__c = Datetime.now();
		}
		caseToSubmit.RET_Last_Submission_Date__c = Datetime.now();

		String integrationException;
		try {
			submitCaseToGREX(getTaxSubmissionJson(caseToSubmit, caseLastSubmitted));
		} catch (Exception e) {
			integrationException = e.getMessage();
		}

		try {
			update caseToSubmit;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
		if (!String.isBlank(integrationException)) {
			throw new AuraHandledException(System.Label.RET_Integration_Error);
		}
		return true;
	}

	private static String getTaxSubmissionJson(Case caseToSubmit, Datetime caseLastSubmitted) {
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();

		Map<Id, Attachment> attachmentMap = new Map<Id, Attachment>();
		for (Attachment attach : [SELECT Id, Name, LastModifiedDate FROM Attachment WHERE parentId = :caseToSubmit.Id]) {
			attachmentMap.put(attach.Id, attach);
		}
		gen.writeIdField('caseId', caseToSubmit.Id);
		gen.writeStringField('leaseNumber', caseToSubmit.PBS_Lease__r.Lease_Number__c);

		if (String.isBlank(caseToSubmit.RET_Base_Tax_Year__c)) {
			gen.writeNullField('leaseBaseTaxYear');
		} else {
			gen.writeStringField('leaseBaseTaxYear', caseToSubmit.RET_Base_Tax_Year__c);
		}
		if (String.isBlank(caseToSubmit.RET_Tax_County__c)) {
			gen.writeNullField('leaseTaxCounty');
		} else {
			gen.writeStringField('leaseTaxCounty', caseToSubmit.RET_Tax_County__c);
		}
		gen.writeDatetimeField('initialSubmissionDate', caseToSubmit.RET_Initial_Submission_Date__c);

		gen.writeFieldName('documents');
		gen.writeStartArray();
		if (!attachmentMap.isEmpty()) {
			for (RET_Document_Data__c docData : [
				SELECT
					Id,
					Name,
					Attachment_ID__c,
					Tax_Year__c,
					Document_Type__c,
					Tax_County__c,
					Tax_Bill_Frequency__c,
					Tax_Block_Number__c,
					Tax_Lot_Number__c,
					Tax_Period_End__c,
					Tax_Period_Start__c,
					Tax_Authority_for_Document__c,
					Tax_Bill_Due_Date__c,
					LastModifiedDate,
					Full_File_Name__c
				FROM RET_Document_Data__c
				WHERE Attachment_ID__c IN :attachmentMap.keySet() AND LastModifiedDate > :caseLastSubmitted
			]) {
				gen.writeStartObject();
				gen.writeIdField('attachmentId', docData.Attachment_ID__c);
				gen.writeStringField('fileName', docData.Full_File_Name__c);
				gen.writeStringField('documentType', docData.Document_Type__c);
				gen.writeStringField('taxBillFrequency', docData.Tax_Bill_Frequency__c);
				gen.writeStringField('taxBlockNumer', docData.Tax_Block_Number__c != null ? docData.Tax_Block_Number__c : '');
				gen.writeStringField('taxLotNumber', docData.Tax_Lot_Number__c != null ? docData.Tax_Lot_Number__c : '');
				gen.writeDateField('taxPeriodStart', docData.Tax_Period_Start__c);
				gen.writeDateField('taxPeriodEnd', docData.Tax_Period_End__c);
				gen.writeStringField('taxYear', docData.Tax_Year__c);
				gen.writeDateTimeField('lastModifiedDate', docData.LastModifiedDate);
				gen.writeEndObject();
			}
		}
		gen.writeEndArray();
		gen.writeEndObject();
		system.debug('**' + gen.getAsString());
		return gen.getAsString();
	}

	private static void submitCaseToGREX(String reqStr) {
		RET_GREX_Integration_Settings__c settings = RET_GREX_Integration_Settings__c.getOrgDefaults();
		if (settings == null || settings.Endpoint_URL__c == null) {
			sendIntegrationErrorEmail('GREX Integration endpoint not defined.');
			throw new AuraHandledException(System.Label.RET_Integration_Error);
		}

		HttpResponse response = null;
		HttpRequest req = new HttpRequest();
		req.setTimeout(120000); //ticket# RITM0646135
		req.setEndpoint(settings.Endpoint_URL__c);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		Blob headerValue = Blob.valueOf(settings.Username__c + ':' + settings.Password__c);
		String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
		req.setHeader('Authorization', authorizationHeader);
		req.setBody(reqStr);

		Http http = new Http();
		try {
			response = http.send(req);
		} catch (Exception e) {
		}
		system.debug('response: ' + response);
		if (response == null || response.getStatusCode() != 200) {
			sendIntegrationErrorEmail('GREX integration response unsuccessful: ' + response);
			throw new AuraHandledException(System.Label.RET_Integration_Error);
		} else {
			// May also want to parse response, ensure request was successful....
			System.debug(' *** responseBody: ' + response.getBody());
		}
	}

	private static void sendIntegrationErrorEmail(String error) {
		RET_GREX_Integration_Email_Settings__c emailSettings1 = RET_GREX_Integration_Email_Settings__c.getInstance(
			'O&M Integration Failure'
		);
		RET_GREX_Integration_Email_Settings__c emailSettings2 = RET_GREX_Integration_Email_Settings__c.getInstance(
			'GREX Team Integration Failure'
		);
		if (emailSettings1 != null || emailSettings2 != null) {
			try {
				//Messaging.reserveSingleEmailCapacity(2);
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setSenderDisplayName(emailSettings1.Sender_Display_Name__c);
				mail.setToAddresses(new List<String>{ emailSettings1.To_Address__c, emailSettings2.To_Address__c });
				mail.setSubject(emailSettings1.Email_Subject__c);
				mail.setHtmlBody(emailSettings1.Email_Body__c + error);
				Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
				system.debug('**' + mail);
			} catch (Exception e) {
				System.debug(' *** email error: ' + e.getMessage());
				throw new AuraHandledException(e.getMessage());
			}
		}
	}
}