@isTest
public class PBS_Leasing_AttachmentControllerTest {
    
    static void setupTestData() {        
        // Create a test PBS_AAAP_RLP__c record
        PBS_AAAP_RLP__c testRLP = new PBS_AAAP_RLP__c(PBS_AAAP_RLP_Number__c = 'Test AAAP', PBS_AAAP_Region__c = 'Census', PBS_AAAP_Title__c = 'TestAAAP',
                                                      PBS_AAAP_Year__c = '2023', PBS_AAAP_TELCOMM_DEFAULT__c = 50, PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 50,
                                                      PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1', PBS_AAAP_DEFAULT_MONTH_END__c ='31', PBS_AAAP_MOVE_DEFAULT__c =12.00,
                                                      PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 50000, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 50000,
                                                      PBS_AAAP_Posted_Date__c = Date.today().addDays(-10));
        insert testRLP;
        
        // Create a test PBS_AAAP_Offer__c record
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Test Building', PBS_AAAP_Street_Address__c = '123 Test St',
                                                           PBS_AAAP_Country__c = 'Test Country',PBS_AAAP_City__c = 'Test City',
                                                           PBS_AAAP_State__c = 'Test State',PBS_AAAP_ZipCode__c = '12345', PBS_AAAP_RLP_Number__c = testRLP.Id,  
                                                           PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Offer_Submission_Date__c = Date.today(),PBS_AAAP_Vacant_Premise_Rate__c = 10,
                                                           PBS_AAAP_Signature_First_Name__c = 'test', PBS_AAAP_SIGNATURE_LAST_NAME__c = 'user',PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 1000,
                                                           PBS_AAAP_OFFICE_SPACE_RSF__c = 600, PBS_AAAP_RETAIL_SPACE_RSF__c = 200, PBS_AAAP_GARAGE_SPACE_RSF__c = 200, 
                                                           PBS_AAAP_OFFEROR_INTEREST__c = 'Owner', PBS_AAAP_ACK_LTR_COMPLETED__c = 'No',PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'No',
                                                           PBS_AAAP_Owner_Name__c = 'Test User', PBS_AAAP_X_CO_ORD__c = 123.00, PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true, 
                                                           PBS_AAAP_Y_CO_ORD__c = 456.60, PBS_AAAP_Is_Offer_Valid__c = true);
        insert offerRec;
        
        // Create a test PBS_AAAP_Offer_Attachments__c record
        PBS_AAAP_Offer_Attachments__c offerAttRecords = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offerRec.Id, PBS_AAAP_Attachment_Type__c = 'Floor Plan',PBS_AAAP_Sent_to_GREX__c = TRUE);
        insert offerAttRecords;
        
        // Create a test ContentVersion record        
        ContentVersion cv = new ContentVersion(Title = 'Test Document', PathOnClient = 'TestDocument.pdf',
                                               VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        Insert cv;
        
        // Query ContentVersion Obj records for ContentDocumentId
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData FROM ContentVersion WHERE Id = :cv.Id];
        
        //check ContentVersion List is empty or Not
        System.assertEquals(cvList.size(), 1);
        
        // Create a test contentDocumentLink record 
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(ContentDocumentId = cvList[0].ContentDocumentId, LinkedEntityId = offerAttRecords.Id, Visibility = 'AllUsers');
        insert contentDocumentLink;
        
        PBS_AAAP_Property__c property = new PBS_AAAP_Property__c(Name = 'test property', PBS_AAAP_Street_Address__c = 'test Address 123',
                                                                 PBS_AAAP_Parking_Onsite__c = 'Yes',
                                                                 PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 16);
        insert property;
        
        PBS_Leasing_AttachmentController.getOfferAttachmentData(offerAttRecords.Id);
        
    }
    @isTest static void testGetColumnsAndRecords() {
        // call the setupTestData method for testing Data
        setupTestData();
        // Query PBS_AAAP_Offer__c Obj records 
        PBS_AAAP_Offer__c offerRec = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        // Query PBS_AAAP_Offer_Attachments__c Obj records
        PBS_AAAP_Offer_Attachments__c offerAttRecords = [SELECT Id, PBS_AAAP_Offer__c FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :offerRec.Id LIMIT 1];
        
        // call the apex method and tested according to the scenario 
        Test.startTest();  
        PBS_Leasing_AttachmentController.ResponseWrapper response2 = PBS_Leasing_AttachmentController.getColumnsAndRecords('Attachments_Already_Submitted', offerAttRecords.PBS_AAAP_Offer__c,true);
        
        // update the PBS_AAAP_Offer_Attachments__c object records value accordinng to scenario
        offerAttRecords.PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217 attachment)';
        update offerAttRecords;
        PBS_Leasing_AttachmentController.ResponseWrapper response = PBS_Leasing_AttachmentController.getColumnsAndRecords('Auto_Generated_Forms', offerAttRecords.PBS_AAAP_Offer__c,true);
        
        // update the PBS_AAAP_Offer_Attachments__c object records value accordinng to scenario
        offerAttRecords.PBS_AAAP_Attachment_Type__c = 'Seismic Certificate';
        offerAttRecords.PBS_AAAP_Sent_to_GREX__c = FALSE;
        update offerAttRecords;
        PBS_Leasing_AttachmentController.ResponseWrapper response1 = PBS_Leasing_AttachmentController.getColumnsAndRecords('Attachments_List', offerAttRecords.PBS_AAAP_Offer__c,true);
        Test.stopTest();
        // Verify the Ensure that the response is not null
        System.assertNotEquals(null, response, 'Response should not be null.');
    }
    
    
    @isTest static void testPBSLeasingUploadAttMethod(){
        // call the setupTestData method for testing Data
        setupTestData();
        // Query PBS_AAAP_Offer__c Obj records 
        PBS_AAAP_Offer__c offerRec = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        // Query PBS_AAAP_Offer_Attachments__c Obj records
        PBS_AAAP_Offer_Attachments__c offerAttRecords = [SELECT Id, PBS_AAAP_Offer__c FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :offerRec.Id LIMIT 1];
        // Query ContentVersion Obj Data for ContentDocumentId
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData FROM ContentVersion limit 1];
        // Query ContentDocument Obj Data for fill the contentDocumentId in wrapper class
        ContentDocument contentdoc = [SELECT Id FROM ContentDocument where id =: cvList[0].ContentDocumentId];
        //Create a list of DocumentWrapper for testing 
        List<PBS_Leasing_AttachmentController.DocumentWrapper> contentDocumentRecords = new List<PBS_Leasing_AttachmentController.DocumentWrapper>(); 
        // fill values in wrapper class
        PBS_Leasing_AttachmentController.DocumentWrapper contDocRecords = new PBS_Leasing_AttachmentController.DocumentWrapper(); 
        contDocRecords.name = 'Ant Command.txt';
        contDocRecords.contentDocumentId = contentdoc.Id;
        contDocRecords.offerAttachmentId = null;
        contDocRecords.isShowOthers = true;
        contDocRecords.attachmentType = 'text/plain';
        contDocRecords.attachmentDescription = 'test';
        contentDocumentRecords.add(contDocRecords);
        Test.startTest(); 
        // call apex method insertDocumentLinkRecord 
        List<PBS_Leasing_AttachmentController.DocumentWrapper> result = PBS_Leasing_AttachmentController.insertDocumentLinkRecord(offerRec.Id, contentDocumentRecords);
        // call apex method updateContentDocumentRecords 
        PBS_Leasing_AttachmentController.updateContentDocumentRecords(contentDocumentRecords);
        // call apex method deleteTheUploadedDocuments 
        PBS_Leasing_AttachmentController.deleteTheUploadedDocuments(contentDocumentRecords);
        Test.stopTest();
        //check assertion for result
        System.assertEquals(1, result.size(), 'Result size dose not match expceted size');
    }	
    
    
    @isTest static void testUpdateContentDocumentRecords() { 
        // call the setupTestData method for testing Data
        setupTestData();
        // Query PBS_AAAP_Offer__c Obj records 
        PBS_AAAP_Offer__c offerRec = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        // Query PBS_AAAP_Offer_Attachments__c Obj records
        PBS_AAAP_Offer_Attachments__c offerAttRecords = [SELECT Id, PBS_AAAP_Offer__c FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :offerRec.Id LIMIT 1];
        //Create a list of updateContentDocumentRecords Method  wrappers for testing 
        List<PBS_Leasing_AttachmentController.DocumentWrapper> documentWrappers = new List<PBS_Leasing_AttachmentController.DocumentWrapper>();
        // fill the value in wrapper class obj.
        PBS_Leasing_AttachmentController.DocumentWrapper docWrapper = new PBS_Leasing_AttachmentController.DocumentWrapper();
        docWrapper.offerAttachmentId = offerAttRecords.Id;
        docWrapper.attachmentType = 'Type';
        docWrapper.attachmentDescription = 'Description';
        documentWrappers.add(docWrapper);
        Test.startTest();
        //Call apex method
        PBS_Leasing_AttachmentController.updateContentDocumentRecords(documentWrappers);
        Test.stopTest();
    }
    
    
    @isTest
    static void testUnSavedOfferAttRecords() {
        // call the setupTestData method for testing Data
        setupTestData();
        // Query PBS_AAAP_Offer__c Obj records 
        PBS_AAAP_Offer__c offerRec = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        // Query PBS_AAAP_Offer_Attachments__c Obj records according offerId
        PBS_AAAP_Offer_Attachments__c offerAttRecords = [SELECT Id, PBS_AAAP_Offer__c FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :offerRec.Id LIMIT 1];
        offerAttRecords.PBS_AAAP_Attachment_Type__c = Null;
        update offerAttRecords;
        // call apex method 
        Test.startTest();
        List<PBS_Leasing_AttachmentController.DocumentWrapper> result = PBS_Leasing_AttachmentController.unSavedOfferAttRecords(offerRec.Id);
        // check result 
        System.assertNotEquals(null, result, 'Result should not be null');
        Test.stopTest();
    }
    
    @isTest static void testValidateOffer() {
        Id devRecordTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
        //call the setupTestData method for testing Data
        setupTestData();
        // query PBS_AAAP_Offer__c obj records for testing 
        PBS_AAAP_Offer__c testOffer = [SELECT Id, RecordTypeId FROM PBS_AAAP_Offer__c LIMIT 1];
        
        PBS_AAAP_Property__c testProperty = [SELECT Id FROM PBS_AAAP_Property__c LIMIT 1];
        
        // insert the PBS_AAAP_Offer_Attachments__c obj records
        PBS_AAAP_Offer_Attachments__c testAttachment = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = testOffer.Id, PBS_AAAP_Attachment_Type__c = 'Authorization to Represent Ownership Entity');
        insert testAttachment;
        // insert the PBS_AAAP_Space__c obj records
        PBS_AAAP_Space__c testSpace = new PBS_AAAP_Space__c(PBS_AAAP_OFFER_NUMBER__c = testOffer.Id, PBS_AAAP_IDENTIFIER_ID__c = '5');
        insert testSpace;
        // insert the PBS_AAAP_Rate__c obj records
        PBS_AAAP_Rate__c testRate = new PBS_AAAP_Rate__c(PBS_AAAP_SPACE__c = testSpace.Id, PBS_AAAP_BSAC__c = Null, PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 11.322740186406596,
                                                         PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 100, PBS_AAAP_BASE_RATE__c = 50, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 13.37397261940202,
                                                         PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 0, PBS_AAAP_LEASE_TERM__c = '5+5 Years');//, LASTMODIFIEDDATE = Date.today().addDays(-5));//DateTime.newInstance(2024, 5, 20, 21, 25, 58));
        insert testRate;
        // call the apex method for the test
        Test.startTest();
        PBS_Leasing_AttachmentController.OfferValidationResponse response = PBS_Leasing_AttachmentController.validateOffer(testOffer.Id, testProperty.Id, '');
        
        // update PBS_AAAP_Offer__c obj fields value according to scenario 
        testOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 1200;
        testOffer.PBS_AAAP_OFFEROR_INTEREST__c = '';
        update testOffer;
        PBS_Leasing_AttachmentController.OfferValidationResponse response1 = PBS_Leasing_AttachmentController.validateOffer(testOffer.Id, testProperty.Id, ''); 
        testOffer.RecordTypeId = devRecordTypeId;
        testOffer.PBS_AAAP_Office_RSF_OFFERED__c = 5;
        testOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 10;
        testOffer.PBS_AAAP_Office_RSF_OFFERED__c = 0;
        testOffer.PBS_AAAP_COST_PER_ABOA__c = 0;
        update testOffer;
        PBS_Leasing_AttachmentController.OfferValidationResponse response2 = PBS_Leasing_AttachmentController.validateOffer(testOffer.Id, testProperty.Id, ''); 
        Test.stopTest();  
    }
    
    
    @isTest static void testdeleteRecord(){
        // call the setupTestData method for testing Data
        setupTestData();
        // query the PBS_AAAP_Offer_Attachments__c obj records
        PBS_AAAP_Offer_Attachments__c testAttachment = [select id from PBS_AAAP_Offer_Attachments__c limit 1];
        // call the apex method for testing
        Test.startTest();
        PBS_Leasing_AttachmentController.deleteRecord(testAttachment.Id);
        Test.stopTest();
    }
    
    
    @isTest static void testActionSavePage(){
        //call the setupTestData method for testing Data
        setupTestData();
        // query the PBS_AAAP_Offer_Attachments__c obj records
        PBS_AAAP_Offer__c offerRec = [select id, PBS_AAAP_Offer_Status__c from PBS_AAAP_Offer__c limit 1];
        // create PBS_AAAP_Offer__c records for testing
        offerRec.PBS_AAAP_Offer_Status__c = 'SUBMITTED'; 
        update offerRec;
        String modifiedPageUrl = 'https://www.test.com/';
        
        //call apex method actionSavePage and callGetCommunityURL
        Test.startTest();
        PBS_Leasing_AttachmentController.actionSavePage(offerRec.Id); 
        PBS_Leasing_AttachmentController.callGetCommunityURL(modifiedPageUrl);
        Test.stopTest();
    }
    
    @isTest static void testgetSubmitOfferInfo(){
        //call the setupTestData method for testing Data
        setupTestData();
        // query the PBS_AAAP_RLP__c obj records 
        PBS_AAAP_RLP__c rlp = [select id, PBS_AAAP_Region__c from  PBS_AAAP_RLP__c limit 1];
        // query the PBS_AAAP_Offer__c obj records 
        PBS_AAAP_Offer__c offerRec = [select id from  PBS_AAAP_Offer__c limit 1];
        
        // insert PBS_AAAP_Space__c obj record accrodinng to offerId
        PBS_AAAP_Space__c testSpace = new PBS_AAAP_Space__c(PBS_AAAP_OFFER_NUMBER__c = offerRec.Id, PBS_AAAP_IDENTIFIER_ID__c = '5',PBS_AAAP_SF_OFFERED__c = 6000);
        insert testSpace;
        System.assertNotEquals(null, testSpace.Id, 'Space record ID should not be null.');
        // insert PBS_AAAP_Rate__c obj record accrodinng to SPACE id
        PBS_AAAP_Rate__c testRate = new PBS_AAAP_Rate__c(PBS_AAAP_SPACE__c = testSpace.Id, PBS_AAAP_BSAC__c = Null, PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 11.322740186406596,
                                                         PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 100, PBS_AAAP_BASE_RATE__c = 50, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 13.37397261940202,
                                                         PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 2, PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm');
        insert testRate;
        System.assertNotEquals(null, testRate.Id, 'Rate record ID should not be null.');
        // call the apex method
        Test.startTest();
        PBS_Leasing_AttachmentController.getSubmitOfferInfo(offerRec.Id);
        
        // update PBS_AAAP_RLP__c object records 
        rlp.PBS_AAAP_Region__c = '10/5 Term - All Regions';
        update rlp;
        PBS_Leasing_AttachmentController.getSubmitOfferInfo(offerRec.Id);
        
        // update PBS_AAAP_RLP__c object records
        rlp.PBS_AAAP_Region__c = '';
        update rlp;
        PBS_Leasing_AttachmentController.getSubmitOfferInfo(offerRec.Id);
        Test.stopTest();
    }
    
    
    @isTest static void testSubmitOffer() {
        //query User records
        User testUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        //call the setupTestData method for testing Data
        setupTestData();
        // query the PBS_AAAP_RLP__c obj records 
        PBS_AAAP_RLP__c rlp = [select id, PBS_AAAP_Region__c from  PBS_AAAP_RLP__c limit 1];
        // query the PBS_AAAP_Offer__c obj records 
        PBS_AAAP_Offer__c offerRec = [select id from  PBS_AAAP_Offer__c limit 1];
        
        //insert PBS_AAAP_Offer__c obj records for parent offer
        PBS_AAAP_Offer__c ParentOffer = new PBS_AAAP_Offer__c(PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Is_Offer_Valid__c = false);
        insert ParentOffer;
        offerRec.PBS_AAAP_Parent_Offer__c = ParentOffer.Id;
        update offerRec;
        
        Test.startTest();
        PBS_Leasing_AttachmentController.OfferValidationResponse response = PBS_Leasing_AttachmentController.submitOffer(offerRec.Id, 'Yes', 'Yes', 'Yes');
        // Assert the results
        System.assertEquals(true, response.success, 'The offer should be successfully submitted.');
        System.assertEquals(0, response.errorMessages.size(), 'There should be no error messages.');
        // update offer obj PBS_AAAP_Offer_Status__c  and PBS_AAAP_Is_Offer_Valid__c field value 
        offerRec.PBS_AAAP_Offer_Status__c = 'Submitted';
        offerRec.PBS_AAAP_Is_Offer_Valid__c = true;
        update offerRec;
        PBS_Leasing_AttachmentController.OfferValidationResponse response1 = PBS_Leasing_AttachmentController.submitOffer(offerRec.Id, 'Yes', 'Yes', 'Yes');
        // update offer obj PBS_AAAP_Offer_Status__c field value 
        offerRec.PBS_AAAP_Offer_Status__c = 'Pending Modification';
        update offerRec;
        PBS_Leasing_AttachmentController.OfferValidationResponse response2 = PBS_Leasing_AttachmentController.submitOffer(offerRec.Id, 'Yes', 'Yes', 'Yes');
        Test.stopTest();
    }
    
    
    @isTest static void testSubmitOfferWithErrors() {
        setupTestData();
        // query the PBS_AAAP_Offer__c obj records 
        PBS_AAAP_Offer__c offerRec = [select id from  PBS_AAAP_Offer__c limit 1];
        
        //insert PBS_AAAP_Offer__c obj records for parent offer
        PBS_AAAP_Offer__c ParentOffer = new PBS_AAAP_Offer__c(PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Is_Offer_Valid__c = false);
        insert ParentOffer;
        offerRec.PBS_AAAP_Parent_Offer__c = ParentOffer.Id;
        update offerRec;
        Test.startTest();
        // Call the method with test data
        PBS_Leasing_AttachmentController.OfferValidationResponse response = PBS_Leasing_AttachmentController.submitOffer(offerRec.Id, 'No', 'No', 'No');
        Test.stopTest();
        // Assert the results
        System.assertEquals(false, response.success, 'The offer should not be successfully submitted.');
        System.assert(response.errorMessages.size() > 0, 'There should be error messages.');
    }
    
    @isTest static void testActionOfferDocuments() {
        setupTestData();
        // query the PBS_AAAP_Offer__c obj records 
        PBS_AAAP_Offer__c offerRec = [select id from  PBS_AAAP_Offer__c limit 1];
        PBS_AAAP_Offer__c masterOffer = new PBS_AAAP_Offer__c(PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Is_Offer_Valid__c = false);
        insert masterOffer;
        offerRec.Master_Offer__c = masterOffer.Id;
        update offerRec;
        PBS_AAAP_Agency_Requirement__c agencyReq = new PBS_AAAP_Agency_Requirement__c(Name = 'Test');
        insert agencyReq;
        
        PBS_AAAP_Offer_Select_Award_Info__c offSelectAwardInfo = new PBS_AAAP_Offer_Select_Award_Info__c(PBS_AAAP_isSelected__c = true, PBS_AAAP_Submission_DateTime__c = System.Today(), 
                                                                                                         PBS_AAAP_Offer_ID__c = offerRec.Id, PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agencyReq.Id);
        insert offSelectAwardInfo;
        
        //call method for testing 
        Test.startTest();
        PBS_Leasing_AttachmentController.actionOfferDocuments(offerRec.Id); 
        Test.stopTest();
    }
    
    @isTest static void testUpdateAutoGeneratedFormsDocuments() {
        //call the setupTestData method for testing Data
        setupTestData();
        // query PBS_AAAP_RLP__c obj records
        PBS_AAAP_RLP__c testRLP = [SELECT id, PBS_AAAP_Year__c, PBS_AAAP_Region__c from PBS_AAAP_RLP__c limit 1];
        // query PBS_AAAP_Offer__c obj records
        PBS_AAAP_Offer__c testOffer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        // Create test PBS_AAAP_Offer_Attachments__c records
        PBS_AAAP_Offer_Attachments__c testAttachment1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = testOffer.Id, PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217)');
        insert testAttachment1;
        
        PBS_AAAP_Offer_Attachments__c testAttachment2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = testOffer.Id, PBS_AAAP_Attachment_Type__c = 'Form 1364 AAAP');
        insert testAttachment2;
        
        // Call the method to test
        Test.startTest();
        PBS_Leasing_AttachmentController.updateAutoGeneratedFormsDocuments(testOffer.Id);
        // Check that the attachments were deleted
        List<PBS_AAAP_Offer_Attachments__c> remainingAttachments = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :testOffer.Id];
        System.assertNotEquals(null, remainingAttachments.size(), 'Attachments should have been deleted.');
        
        //update PBS_AAAP_RLP__c Object record for PBS_AAAP_Year__c 2017 
        testRLP.PBS_AAAP_Year__c = '2017';
        testRLP.PBS_AAAP_Region__c = '';
        update testRLP;
        //testing method according to PBS_AAAP_Year__c 2017
        PBS_Leasing_AttachmentController.updateAutoGeneratedFormsDocuments(testOffer.Id);
        // Add assertion to verify expected outcome for 2017
        remainingAttachments = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :testOffer.Id];
        System.assertNotEquals(null, remainingAttachments.size(), 'Attachments should have been deleted for 2017.');
        
        //update PBS_AAAP_RLP__c Object record for PBS_AAAP_Year__c 2019 
        testRLP.PBS_AAAP_Year__c = '2019';
        testRLP.PBS_AAAP_Region__c = 'Census';
        update testRLP;
        //testing method according to PBS_AAAP_Year__c 2019
        PBS_Leasing_AttachmentController.updateAutoGeneratedFormsDocuments(testOffer.Id);
        PBS_Leasing_AttachmentController.submitDocuments(testOffer.Id);
        PBS_Leasing_AttachmentController.getLabel('AAAP-OfferAttachments');
        PBS_Leasing_AttachmentController.getAllOfferAttachments(testOffer.Id);
        
        // Add assertion to verify expected outcome for 2019
        remainingAttachments = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :testOffer.Id];
        System.assertNotEquals(null, remainingAttachments.size(), 'Attachments should have been deleted for 2019.');
        Test.stopTest();
    }
}