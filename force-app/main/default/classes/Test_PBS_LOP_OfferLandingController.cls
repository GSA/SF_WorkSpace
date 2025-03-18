@isTest
public class Test_PBS_LOP_OfferLandingController{
   
    @isTest
    private static void testMethodPositive(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');
            
        System.runAs(u) {
            PBS_LOP_OfferLandingController obj = new PBS_LOP_OfferLandingController();
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = true;
            rlp.PBS_AAAP_Region__c = 'test region';
            rlp.recordTypeId = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            insert RLP;
            obj.solicitationId = '123';
            obj.showPopup();
            obj.closePopup();
            obj.createEditOffer();
        }
    }
    
    @isTest
    private static void testMethodNegative(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');
            
        System.runAs(u) {
            PBS_LOP_OfferLandingController obj = new PBS_LOP_OfferLandingController();
            obj.showPopup();
            obj.closePopup();
            obj.createEditOffer();
        }
    }
    
    @isTest
    private static void testMethodWithOffer(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');
            
        System.runAs(u) {
            PBS_LOP_OfferLandingController obj = new PBS_LOP_OfferLandingController();
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = true;
            rlp.PBS_AAAP_Region__c = 'test region';
            rlp.recordTypeId = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            insert RLP;
            
            obj.solicitationId = '123';
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = 'Draft';
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            insert offernew;
            obj.showPopup();
            obj.closePopup();
            obj.createEditOffer();
        }
    }
}