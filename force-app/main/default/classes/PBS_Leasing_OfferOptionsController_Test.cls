@isTest
public class PBS_Leasing_OfferOptionsController_Test {
    @testSetup static void setupTestData()  {
        RecordType offerRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'PBS_AAAP_Offer__c' AND Name = 'AAAP' LIMIT 1];
        
        PBS_AAAP_RLP__c testRLP = new PBS_AAAP_RLP__c(PBS_AAAP_RLP_Number__c = 'Region1', PBS_AAAP_STATUS__c = 'Posted/Active', PBS_AAAP_isActive__c = true,
                                                      PBS_RSAP_Solicitation_Status__c = true, PBS_RSAP_Solicitation_Number__c = '12345', PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '5',
                                                      PBS_AAAP_DEFAULT_MONTH_END__c = '20');
        insert testRLP;
        
        PBS_AAAP_Offer__c parentOfferRecord = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Building A',PBS_AAAP_Street_Address__c = '111 Test Ave',PBS_AAAP_City__c = 'City A',
                                                                    PBS_AAAP_State__c = 'State A', PBS_AAAP_Offer_Status__c = 'Draft',PBS_AAAP_RLP_Number__c = testRLP.Id,PBS_AAAP_Offer_Submission_Date__c = System.today());
        insert parentOfferRecord;
        
        PBS_AAAP_Offer__c offerRecord = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Building A',PBS_AAAP_Street_Address__c = '111 Test Ave',PBS_AAAP_City__c = 'City A',
                                                              PBS_AAAP_State__c = 'State A',RecordTypeId = offerRecordType.Id,PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Offer_Submission_Date__c = System.today(),
                                                              PBS_AAAP_Signature_First_Name__c = 'test1', PBS_AAAP_SIGNATURE_PIN__c = '34544', PBS_AAAP_SIGNATURE_MIDDLE_NAME__c = 't',
                                                              PBS_AAAP_SIGNATURE_LAST_NAME__c = 'test3', PBS_AAAP_RLP_Region__c = 'Region1',PBS_AAAP_RLP_Number__c = testRLP.Id, PBS_AAAP_Parent_Offer__c = parentOfferRecord.Id, 
                                                              PBS_AAAP_PARENT_NAME__c = 'test-parent-offer', PBS_AAAP_Owner_Zip__c = '12345', PBS_AAAP_Owner_State__c = 'test', PBS_AAAP_Owner_State_Reg__c = 'test');
        insert offerRecord;
        
        PBS_AAAP_Property__c testProperty = new PBS_AAAP_Property__c(PBS_AAAP_County__c = 'Test County', PBS_AAAP_City__c = 'Test City', PBS_AAAP_State__c = 'TS');
        insert testProperty;        
        
        PBS_AAAP_Offer_Attachments__c offerAttRecords = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offerRecord.Id, PBS_AAAP_Attachment_Type__c = 'Floor Plan',PBS_AAAP_Sent_to_GREX__c = TRUE);
        insert offerAttRecords;
        
        
        ContentVersion cv = new ContentVersion(Title = 'Test Document', PathOnClient = 'TestDocument.pdf',
                                               VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        Insert cv;
        
    }   
    
    @isTest static void testGetOfferRecord() {
        PBS_AAAP_Offer__c offerRecord = [Select id, PBS_AAAP_Offer_Status__c from PBS_AAAP_Offer__c limit 1];
        PBS_AAAP_Property__c testProperty = [Select id from PBS_AAAP_Property__c limit 1];
        PBS_Leasing_OfferOptionsController.ResponseWrapper response = PBS_Leasing_OfferOptionsController.getOffer(offerRecord.Id);
        System.assertEquals('Building A', response.offer.PBS_AAAP_Building_Name__c, 'The incorrect data is being returned.');
        response = PBS_Leasing_OfferOptionsController.getOffer('bogus');
        System.assertEquals(false, response.isSuccess, 'We expected an unsuccessful call.');
        response = PBS_Leasing_OfferOptionsController.getOffer('');
        System.assertEquals(false, response.isSuccess, 'We expected an unsuccessful call.');
        PBS_Leasing_OfferOptionsController.updateLOPToWithdrawnStatus(offerRecord.Id);
        PBS_Leasing_OfferOptionsController.offerClone(offerRecord.Id, 'insert');
        PBS_Leasing_OfferOptionsController.getRegions();
        PBS_Leasing_OfferOptionsController.actionShowRLPs('Region 1');
        PBS_Leasing_OfferOptionsController.actionSearchRLPSite('Region 1');
    }
    
    @isTest static void testDeleteOfferRecord() {
        PBS_AAAP_Offer__c offerRecord = [Select id, PBS_AAAP_Offer_Status__c from PBS_AAAP_Offer__c limit 1];
        Test.startTest();
        offerRecord.PBS_AAAP_Offer_Status__c = 'Pending Modification';
        update offerRecord;
        PBS_Leasing_OfferOptionsController.ResponseWrapper response = PBS_Leasing_OfferOptionsController.deleteOffer(offerRecord.Id);
        
        Test.stopTest();
    }
    
    @isTest static void testActionOfferEdit() {
        PBS_AAAP_Offer__c offerRecord = [Select id, PBS_AAAP_Offer_Status__c, PBS_AAAP_Parent_Offer__c from PBS_AAAP_Offer__c where PBS_AAAP_Offer_Status__c = 'Draft' limit 1];
        PBS_AAAP_Property__c testProperty = [Select id from PBS_AAAP_Property__c limit 1];
        offerRecord.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        update offerRecord;
        PBS_Leasing_OfferOptionsController.actionOfferEdit(offerRecord.Id, testProperty.Id);
        
    }
    @isTest static void testActionOfferEditSubmit() {
        
        PBS_AAAP_Offer__c offerRecord = [Select id, PBS_AAAP_Offer_Status__c, PBS_AAAP_Parent_Offer__c from PBS_AAAP_Offer__c where PBS_AAAP_Offer_Status__c = 'Draft' limit 1];
        
        PBS_AAAP_Other_Costs__c otherCosts = new PBS_AAAP_Other_Costs__c(PBS_AAAP_SHORT_DESC__c = '100', PBS_AAAP_OFFER_NUMBER__c = offerRecord.Id, PBS_AAAP_COST__c = 100, 
                                                                         PBS_AAAP_COST_TYPE__c = 'Other Cost', PBS_AAAP_COST_REMOVAL__c = false, Name = 'other-cost'
                                                                         //PBS_AAAP_LEGACY_EXTERNAL_ID__c = 'test-legacy-ext.id'
                                                                         ); 
        insert otherCosts; 
        
        PBS_AAAP_Offer_Attachments__c offerAttRecords = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offerRecord.Id, PBS_AAAP_Attachment_Type__c = 'Floor Plan',PBS_AAAP_Sent_to_GREX__c = TRUE);
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
        
        PBS_AAAP_Space__c testSpace = new PBS_AAAP_Space__c(PBS_AAAP_OFFER_NUMBER__c = offerRecord.Id, PBS_AAAP_IDENTIFIER_ID__c = '5',
                                                            PBS_AAAP_Total_ABOA_Awarded__c = 10, PBS_AAAP_Total_ABOA_Selected__c = 10,
                                                            PBS_AAAP_Total_ABOA_Withdrawn__c = 10, PBS_AAAP_Total_ABOA_Edited__c = 10, PBS_AAAP_SF_OFFERED__c = 50);
        insert testSpace;
        
        PBS_AAAP_Rate__c testRate = new PBS_AAAP_Rate__c(PBS_AAAP_SPACE__c = testSpace.Id, PBS_AAAP_BSAC__c = Null, PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 11.322740186406596,
                                                         PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 100, PBS_AAAP_BASE_RATE__c = 50, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 13.37397261940202,
                                                         PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 2, PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm');
        insert testRate;
        
        PBS_AAAP_Property__c testProperty = [Select id from PBS_AAAP_Property__c limit 1];
        
        PBS_AAAP_RLP__c testrlp = [select id, PBS_AAAP_DEFAULT_MONTH_BEGIN__c, PBS_AAAP_DEFAULT_MONTH_END__c from PBS_AAAP_RLP__c limit 1]; 
        
        PBS_AAAP_Other_Costs__c otherCost = [Select id, PBS_AAAP_OFFER_NUMBER__c from PBS_AAAP_Other_Costs__c limit 1];
        
        offerRecord.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        update offerRecord;
        
        PBS_Leasing_OfferOptionsController.actionOfferEdit(offerRecord.Id, testProperty.Id);
        testrlp.PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '8';
        testrlp.PBS_AAAP_DEFAULT_MONTH_END__c = '7';
        update testrlp;
        PBS_AAAP_Other_Costs__c testClone = otherCost.clone(false, true);
        
        PBS_Leasing_OfferOptionsController.actionOfferEdit(offerRecord.Id, testProperty.Id);
        
        offerRecord.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
        update offerRecord;
        
        PBS_Leasing_OfferOptionsController.actionOfferEdit(offerRecord.Id, testProperty.Id);
        
    }
    
     @isTest static void testActionOfferEditSubmit1() {
        
        PBS_AAAP_Offer__c offerRecord = [Select id, PBS_AAAP_Offer_Status__c, PBS_AAAP_Parent_Offer__c from PBS_AAAP_Offer__c where PBS_AAAP_Offer_Status__c = 'Draft' limit 1];
         
        offerRecord.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
         
        update offerRecord;
         
        PBS_AAAP_Other_Costs__c otherCosts = new PBS_AAAP_Other_Costs__c(PBS_AAAP_SHORT_DESC__c = '100', PBS_AAAP_OFFER_NUMBER__c = offerRecord.Id, PBS_AAAP_COST__c = 100, 
                                                                         PBS_AAAP_COST_TYPE__c = 'Other Cost', PBS_AAAP_COST_REMOVAL__c = false, Name = 'other-cost'
                                                                         //PBS_AAAP_LEGACY_EXTERNAL_ID__c = 'test-legacy-ext.id'
                                                                         ); 
        insert otherCosts; 
        
        PBS_AAAP_Offer_Attachments__c offerAttRecords = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offerRecord.Id, PBS_AAAP_Attachment_Type__c = 'Floor Plan',PBS_AAAP_Sent_to_GREX__c = TRUE);
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
        
        PBS_AAAP_Space__c testSpace = new PBS_AAAP_Space__c(PBS_AAAP_OFFER_NUMBER__c = offerRecord.Id, PBS_AAAP_IDENTIFIER_ID__c = '5',
                                                            PBS_AAAP_Total_ABOA_Awarded__c = 10, PBS_AAAP_Total_ABOA_Selected__c = 10,
                                                            PBS_AAAP_Total_ABOA_Withdrawn__c = 10, PBS_AAAP_Total_ABOA_Edited__c = 10, PBS_AAAP_SF_OFFERED__c = 50);
        insert testSpace;
        
        PBS_AAAP_Rate__c testRate = new PBS_AAAP_Rate__c(PBS_AAAP_SPACE__c = testSpace.Id, PBS_AAAP_BSAC__c = Null, PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 11.322740186406596,
                                                         PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 100, PBS_AAAP_BASE_RATE__c = 50, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 13.37397261940202,
                                                         PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 2, PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm');
        insert testRate;
        
        PBS_AAAP_Property__c testProperty = [Select id from PBS_AAAP_Property__c limit 1];
   
        PBS_Leasing_OfferOptionsController.actionOfferEdit(offerRecord.Id, testProperty.Id);
        
    }
    
    @isTest
    static void testActionLopOfferEdit_DraftStatus() {
        PBS_AAAP_Offer__c offerRecord = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        PBS_AAAP_Property__c testProperty = [Select id from PBS_AAAP_Property__c limit 1];
        Test.startTest();
        offerRecord.Property__c = testProperty.Id;
        update offerRecord;
        String result = PBS_Leasing_OfferOptionsController.actionLopOfferEdit(offerRecord.Id, testProperty.Id);
        String result3 = PBS_Leasing_OfferOptionsController.actionLopOfferEdit(offerRecord.Id, null);
        offerRecord.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        update offerRecord;
        String result1 = PBS_Leasing_OfferOptionsController.actionLopOfferEdit(offerRecord.Id, testProperty.Id);
        String result2 = PBS_Leasing_OfferOptionsController.actionLopOfferEdit(null, 'testPropertyId');
        Test.stopTest();  
        System.assert(result1.contains('/leasing/s/Offer-Location'), 'Redirect URL is incorrect for draft status.');
    }
    
}