@IsTest
private class Test_PBS_LOP_OperatingCostController {

    static testMethod void testOP() {

        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        String userId = UserInfo.getUserId();
        // PBS_LOP_Offer__c oOther = [select o.Id From PBS_LOP_Offer__c o where o.ownerId != :userId limit 1];

        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();


            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();

            insert offer;
            System.assert(offer.Id != null);
            
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
            insert offernew;
            
            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOP_OperatingCostController obc = new PBS_LOP_OperatingCostController();
            obc.getFuelType();
            List<SelectOption> options = obc.getFuelTypeOpts();
            System.assert(options.size() > 0);
            PBS_AAAP_Offer__c offer1 = obc.getlopOffer();
            System.assert(offer1 != null);
            obc.addOperatingCosts();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_OperatingCostController();
            obc.addOperatingCosts();


            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_OperatingCostController();
            obc.continueSave();


            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_OperatingCostController();
            obc.back();


            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_OperatingCostController();
            obc.saveForm();


            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_OperatingCostController();
            obc.back();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_OperatingCostController();
            obc.actionCancel();


            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_OperatingCostController();
            obc.actionDeleteOffer();
            obc.checkValidations();
            Test.stopTest();
            System.assert(true);
        }
    }

}