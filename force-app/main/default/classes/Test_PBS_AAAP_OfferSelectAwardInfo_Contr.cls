@IsTest
private class Test_PBS_AAAP_OfferSelectAwardInfo_Contr {


    public static testMethod void constructorTest() {
        PBS_AAAP_OfferSelectAwardInfo_Contr aphc = new PBS_AAAP_OfferSelectAwardInfo_Contr();
        System.assert(aphc != null);
    }

    public static testMethod void getAphListTest() {
        PBS_AAAP_OfferSelectAwardInfo_Contr aphc = new PBS_AAAP_OfferSelectAwardInfo_Contr();
        PBS_AAAP_Offer_Select_Award_Info__c[] aph = [SELECT a.PBS_AAAP_AGENCY_REQUIREMENT_ID__c FROM PBS_AAAP_Offer_Select_Award_Info__c a LIMIT 1];
        List<PBS_AAAP_Offer_Select_Award_Info__c> aphList = new List<PBS_AAAP_Offer_Select_Award_Info__c>();

        // Test getting an empty list of PBS_AAAP_Offer_Select_Award_Info__c objects
        aphList = aphc.aphList;
        System.assert(aphList != null);

        // Test getting a populated list of PBS_AAAP_Offer_Select_Award_Info__c objects
        if (aph != null && !aph.isEmpty()) {
            aphc.targetObjId = aph[0].Id;
            aphList = aphc.aphList;
        }
    }

    public static testMethod void actionDeselectOfferTest() {
        test.startTest();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        System.assert(agency.id != null);
        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        insert osai;


        PBS_AAAP_OfferSelectAwardInfo_Contr aphc = new PBS_AAAP_OfferSelectAwardInfo_Contr();
        aphc.selectedOfferId = offer.Id;
        aphc.selectedSpaceId = space.Id;
        aphc.agencyRequirementId = agency.Id;
        PageReference pref = aphc.actionDeSelectOfferSpace();

        System.assertNotEquals(pref, null);

        aphc.offerSelectAwardID = osai.Id;

        pref = aphc.actionShowOfferSelectAwardInfo();
        System.assertNotEquals(pref, null);

        pref = aphc.actionAwardOfferSpace();
        System.assertNotEquals(pref, null);

        aphc.prepareDocument();
        test.stopTest();
    }
    
    
}