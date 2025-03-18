@IsTest
private class Test_PBS_AAAP_OfferDeselectComponContr {

    public static testMethod void constructorTest() {
        PBS_AAAP_OfferDeselectComponentContr aphc = new PBS_AAAP_OfferDeselectComponentContr();
        System.assert(aphc != null);
    }

    public static testMethod void getAphListTest() {
        PBS_AAAP_OfferDeselectComponentContr aphc = new PBS_AAAP_OfferDeselectComponentContr();
        PBS_AAAP_Offer_Deselect_Reject_Reasons__c[] aph = [SELECT a.PBS_AAAP_Agency_Requirement__c FROM PBS_AAAP_Offer_Deselect_Reject_Reasons__c a LIMIT 1];
        List<PBS_AAAP_Offer_Deselect_Reject_Reasons__c> aphList = new List<PBS_AAAP_Offer_Deselect_Reject_Reasons__c>();

        // Test getting an empty list of PBS_AAAP_Offer_Select_Award_Info__c objects
        aphList = aphc.deselectList;
        System.assert(aphList != null);
        // Test getting a populated list of PBS_AAAP_Offer_Select_Award_Info__c objects
        if (aph != null && !aph.isEmpty()) {
            aphc.targetObjId = aph[0].Id;
            aphList = aphc.deselectList;
        }
    }
}