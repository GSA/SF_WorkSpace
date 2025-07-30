@isTest
public class PBS_AAAP_OfferPreviewPageControllerTest {
    // create test data for apex Method testing
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
                                                           PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Offer_Submission_Date__c = Date.today());
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
        
        Test.setCurrentPageReference(new PageReference('/apex/PBS_AAAP_PreviewOfferPage?id=' + offerRec.Id));
    }
    
    @isTest
    static void testActionDeleteAttachment() {
        // call setupTestData method for querying required data for testing
        setupTestData();
        // Query PBS_AAAP_Offer__c Obj records 
        PBS_AAAP_Offer__c testOffer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        // Query PBS_AAAP_Offer_Attachments__c Obj records
        PBS_AAAP_Offer_Attachments__c testAttachment = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :testOffer.Id LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('id', testOffer.Id);
        // Fill the PBS_AAAP_OfferPreviewPageController class constructor values
        PBS_AAAP_OfferPreviewPageController controller = new PBS_AAAP_OfferPreviewPageController();
        controller.attachmentId = testAttachment.Id;
        controller.offerId = testOffer.Id;
        Test.startTest();
        PageReference result = controller.actionDeleteAttachment();
        Test.stopTest();
        
        try {
            testAttachment = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE Id = :testAttachment.Id];
            System.assert(false, 'Expected a QueryException to be thrown');
        } catch (QueryException e) {
            System.assertEquals('List has no rows for assignment to SObject', e.getMessage());
        }
    }
    
    @isTest
    static void testRedirectToExpectedPage() {
        // call setupTestData method for querying required data for testing
        setupTestData();
        // Query PBS_AAAP_Offer__c Obj records 
        PBS_AAAP_Offer__c testOffer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        // Query PBS_AAAP_Offer_Attachments__c Obj records according to PBS_AAAP_Offer__c obj recordId
        List<PBS_AAAP_Offer_Attachments__c> testAttachment = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :testOffer.Id LIMIT 1];
        // Query PBS_AAAP_RLP__c Obj records 
        PBS_AAAP_RLP__c testrlp = [SELECT Id, PBS_AAAP_Year__c FROM PBS_AAAP_RLP__c LIMIT 1];
        
        PBS_AAAP_OfferPreviewPageController controller = new PBS_AAAP_OfferPreviewPageController();
        controller.formName = 'OfferForm3518'; 
        controller.offerattachment = testAttachment;
        
        Test.startTest();
        PageReference result = controller.redirectToExpectedPage();
        Test.stopTest();
        // modify the PBS_AAAP_Year__c field value   
        testrlp.PBS_AAAP_Year__c = '2019';
        update testrlp;
        PBS_AAAP_OfferPreviewPageController controller1 = new PBS_AAAP_OfferPreviewPageController();
        PageReference results = controller1.redirectToExpectedPage();  
        // modify the PBS_AAAP_Year__c field value 
        testrlp.PBS_AAAP_Year__c = '2017';
        testrlp.PBS_AAAP_Region__c = '10/5 Term - All Regions';
        update testrlp;
        PBS_AAAP_OfferPreviewPageController controller2 = new PBS_AAAP_OfferPreviewPageController();
        PageReference res = controller2.redirectToExpectedPage();
    }
    
    @isTest
    static void testDownloadAllFiles() {
        // call setupTestData method for querying required data for testing
        setupTestData();
        // Query PBS_AAAP_Offer__c Obj records
        PBS_AAAP_Offer__c offer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        
        Test.startTest();
        List<PBS_AAAP_OfferPreviewPageController.AttachmentWrapper> attachments = PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        Test.stopTest();
        System.assert(attachments.size() > 0);
    }
    
    @isTest
    static void testUpdateOfferDetails() {
        // call setupTestData method for querying required data for testing
        setupTestData();
         // Query PBS_AAAP_Offer__c Obj records
        PBS_AAAP_Offer__c offer = [SELECT Id, PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c Limit 1];
        //set the offerId in PBS_AAAP_OfferPreviewPageController.remoteOfferId
        PBS_AAAP_OfferPreviewPageController.remoteOfferId =offer.Id;
        
        Test.startTest();
        PBS_AAAP_OfferPreviewPageController.updateOfferDetails();
        Test.stopTest();
        // Query the updatedOffer records
        PBS_AAAP_Offer__c updatedOffer = [SELECT id, PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id = :offer.Id];
        System.assertNotEquals(null, updatedOffer.PBS_AAAP_Session_Key__c);
    }
    
    @isTest
    static void testFetchOfferKey() {
        // call setupTestData method for querying required data for testing
        setupTestData();
         // Query the offer obj records
        PBS_AAAP_Offer__c offer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        // set the remoteOfferId from offerId
        PBS_AAAP_OfferPreviewPageController.remoteOfferId =offer.Id;
        
        Test.startTest();
        String offerKey = PBS_AAAP_OfferPreviewPageController.fetchOfferKey();
        Test.stopTest();
    }
}