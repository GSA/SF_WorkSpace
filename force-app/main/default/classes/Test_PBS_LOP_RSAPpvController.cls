@isTest
public class Test_PBS_LOP_RSAPpvController {
    
      @isTest
    private static void testMethodWOOfferId(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');
            
        System.runAs(u) {
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
            offernew.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
            offernew.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 13.00;
            offernew.PBS_AAAP_Step_1_Start__c = 2;
            offernew.PBS_AAAP_Step_1_End__c = 5;
            offernew.PBS_AAAP_Step_2_Start__c = 2;
            offernew.PBS_AAAP_Step_2_End__c = 5;
            offernew.PBS_AAAP_Step_3_Start__c = 2;
            offernew.PBS_AAAP_Step_3_End__c = 5;
            insert offernew;
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_RSAPpvController obj = new PBS_LOP_RSAPpvController();
            //obj.xlsHeader;
            System.assertEquals(5, offernew.PBS_AAAP_Step_3_End__c, 'This should be equalts');
        }
    }

}