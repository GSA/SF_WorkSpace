@isTest
public class Test_PBS_AAAP_insideHeaderController {
    @testSetup
    static void setup () {
        PBS_AAAP_Offer__c offer1 = new PBS_AAAP_Offer__c();
        offer1.PBS_AAAP_Offer_Status__c = 'Draft';
        insert offer1;
        
        PBS_AAAP_Offer__c offer2 = new PBS_AAAP_Offer__c();
        offer2.PBS_AAAP_Offer_Status__c = 'Submitted';
        insert offer2;
    }

	@isTest
    static void updateOfferStatusTest () {
        List<PBS_AAAP_Offer__c> offers = [SELECT Id FROM PBS_AAAP_Offer__c WHERE PBS_AAAP_Offer_Status__c = 'Submitted'];
        System.assertEquals(1, offers.size());
        
        PageReference pg = Page.PBS_AAAP_IdentifyWinnerSearch;
        System.Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('offerId', offers[0].Id);
        
        PBS_AAAP_insideHeaderController controller = new PBS_AAAP_insideHeaderController();
        
        System.Test.startTest();
        	controller.updateOfferStatus();
        System.Test.stopTest();
        
        offers = [SELECT Id, PBS_AAAP_Offer_Status__c FROM PBS_AAAP_Offer__c WHERE Id = :offers[0].Id];
        System.assertEquals(1, offers.size());
        System.assertEquals('Pending Modification', offers[0].PBS_AAAP_Offer_Status__c);
    }
}