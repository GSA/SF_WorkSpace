@isTest
public class Test_PBS_AAAP_GeneratePreviewLinkBatch {
	@isTest
    public static void doTest(){
        PBS_LOP_OFFER__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            insert offer;
        
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = true;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = 'Draft';
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
            offernew.PBS_AAAP_Building_Name__c = 'Test';
            offernew.PBS_AAAP_Street_Address__c = 'test addr';
            offernew.PBS_AAAP_City__c = 'test city';
            offernew.PBS_AAAP_State__c = 'test state';
            offernew.PBS_AAAP_ZipCode__c = '12345';
            offernew.PBS_AAAP_Energy_Star__c = 'No';
            offernew.PBS_AAAP_Energy_Star_Reason__c = 'Test Reason';
            offernew.PBS_AAAP_floors_Suites_in_Offered_Space__c = 2;
            offernew.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 3;
            insert offernew;
        PBS_AAAP_Offer_Attachments__c offerattachment1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='SAM Registration',PBS_AAAP_Sent_to_GREX__c = True);
         insert offerattachment1;
        
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'a picture',
                    PathOnClient   = 'Pic.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;

            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = offerattachment1.Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.ShareType = 'I';
            cdl.Visibility = 'AllUsers';
            insert cdl;
        
        Test.startTest();
        Database.executeBatch(new PBS_AAAP_GeneratePreviewLinkBatch());
        Test.stopTest();
        System.Assert(true);
    }
}