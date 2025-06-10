@isTest
public class PBS_Leasing_OfferSpaceController_Test {
   
    @testSetup
    static void setupTestData() {
        RecordType offerRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'PBS_AAAP_Offer__c' AND Name = 'AAAP' LIMIT 1];
        
        // Create a test offer record
        PBS_AAAP_Offer__c testOffer = new PBS_AAAP_Offer__c(
            PBS_AAAP_Building_Name__c = 'Test Building',
            PBS_AAAP_Street_Address__c = '123 Test St',
            PBS_AAAP_City__c = 'Test City',
            PBS_AAAP_State__c = 'Test State',
            PBS_AAAP_Offer_Status__c = 'Active',
            PBS_AAAP_Is_Offer_Valid__c = true,
            OwnerId = UserInfo.getUserId(),
            RecordTypeId = offerRecordType.Id
        );
        insert testOffer;
    }
    
    @isTest
    static void testGetOfferDetails() {
        // Get the inserted offer
        PBS_AAAP_Offer__c insertedOffer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        
        // Call the method and verify the result
        Test.startTest();
        PBS_AAAP_Offer__c result = PBS_Leasing_OfferSpaceController.getOfferDetails(insertedOffer.Id);
        Test.stopTest();
        
        System.assertNotEquals(result, null, 'Offer details should not be null');
        System.assertEquals(result.Id, insertedOffer.Id, 'Offer IDs should match');
    }
    
    @isTest
    static void testGetRecords() {
        // Call the method and verify the result
        Test.startTest();
        List<SObject> offers = PBS_Leasing_OfferSpaceController.getRecords();
        Test.stopTest();
        
        System.assert(offers.size() > 0, 'There should be at least one record returned');
    }

}