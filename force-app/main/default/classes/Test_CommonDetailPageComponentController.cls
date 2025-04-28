@isTest
public class Test_CommonDetailPageComponentController {
    @testSetup
    public static void createData(){
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert RLP;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
    } 
    @isTest
    public static void getRecordInfoTest(){
        PBS_AAAP_Offer__c offer = [Select Id from PBS_AAAP_Offer__c limit 1];
        offer = CommonDetailPageComponentController.getRecordInfo(offer.Id);
        System.assertNotEquals(offer, Null);
    }
}