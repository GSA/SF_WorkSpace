@IsTest
private class Test_PBS_LOPController {

    static testMethod void testBuildingPage() {

        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        String userId = UserInfo.getUserId();
        // PBS_LOP_Offer__c oOther = [select o.Id From PBS_LOP_Offer__c o where o.ownerId != :userId limit 1];

        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();

            PBS_LOPController obc = new PBS_LOPController();
            List<SelectOption> items = obc.getItems();
            List<SelectOption> partialitems = obc.getPartialItems();
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            //    offer.OwnerId = '00535000000K6MuAAK';
            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            offer.LOP_SITE_AREA_TYPE__c = 'SQFT';
            offer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '2. Percent of Total Construction Costs (%)';
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.LOP_Energy_Star__c = 'No';
            upsert offer;
            obc.getStates();
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.getShowEnergyStar();
            obc.displayEnergyStarText();
            System.assert(offer.Id != null);
            offer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '3. Flat Fee ($)';
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            // offer.OwnerId = '00535000000K68YAAS';
            offer.LOP_Energy_Star__c = 'Yes';
            offer.LOP_CERTIFICATION_DATE__c = Date.today();
            offer.LOP_Historic_Property_Tier__c = 'Historic property within a historic district';
            offer.LOP_Accessibility_Standards_Met__c = 'Yes';
            offer.LOP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix';
            offer.LOP_RLP_Contains_Seismic_Requirement__c = 'The RLP contains seismic requirements.';
            offer.LOP_Offeror_Seismic_Declaration__c = 'Will be constructed to meet seismic requirements';
            offer.LOP_Flood_Plain_Declaration__c = 'A 500-year flood plain';
            offer.LOP_Fire_Safety_Declaration__c = 'Meets the Lease fire/life safety standards.';
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.getShowEnergyStar();
            obc.displayEnergyStarText();
            System.assert((obc.getItemsQ9()).size() == 2);
            System.assert((obc.getSmallBusiness()).size() == 2);
            System.assert((obc.getSAMRegistrationItems()).size() == 2);
            System.assert((obc.getSiteSizeItems()).size() == 2);
            System.assert((obc.getHVACOTOptionItems()).size() == 3);
            System.assert((obc.getarcenggOptionItems()).size() == 3);
            System.assert((obc.getHistoricTierOptions()).size() == 4);
            System.assert((obc.getAsbestosItems()).size() == 3);
            System.assert((obc.getSeismicOptions()).size() == 2);
            System.assert((obc.getSeismicItems()).size() == 4);
            System.assert((obc.getFloodPlainItems()).size() == 3);
            System.assert((obc.getFireProtectionItems()).size() == 2);

            obc.redirectToParking();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.saveBuilding();
            offer.LOP_Energy_Star__c = 'No';
            offer.LOP_Energy_Star_Reason__c = 'Testing for the energy star reason.';
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            obc = new PBS_LOPController();
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc.redirectToParking();

            offer.LOP_Energy_Star__c = 'No';
            offer.LOP_Energy_Star_Reason__c = '';
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            obc = new PBS_LOPController();
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc.redirectToParking();
            offer.LOP_Energy_Star__c = 'Yes';
            offer.LOP_CERTIFICATION_DATE__c = null;
            offer.LOP_Year_Built__c = null;
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.LOP_Historic_Property_Tier__c = null;
            offer.LOP_Accessibility_Standards_Met__c = null;
            offer.LOP_Asbestos_Declaration__c = null;
            offer.LOP_RLP_Contains_Seismic_Requirement__c = null;
            offer.LOP_Flood_Plain_Declaration__c = null;
            offer.LOP_Fire_Safety_Declaration__c = null;

            upsert offer;
            obc = new PBS_LOPController();
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc.redirectToParking();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            ApexPages.currentPage().getParameters().put('offerId', null);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.lopOffer = offer;
            obc.saveBuilding();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.lopOffer = offer;
            obc.actionDeleteOffer();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.lopOffer = offer;
            obc.actionDeleteOffer();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.lopOffer = offer;
            obc.actionDeleteOffer();


            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            PBS_GREX_Project_EOI__c grexProject = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestGREXProjectEOI();
            grexProject.Project_Termination_Flag__c = true;

            upsert grexProject;
            offer.Project_EOI_ID__c = grexProject.id;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            grexProject.Project_Termination_Flag__c = false;
            grexProject.Project_Offer_Due_Date__c = datetime.now() - 7;
            upsert grexProject;
            offer.Project_EOI_ID__c = grexProject.id;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.actionCancel();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Building_Name__c = null;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Building_Name__c = null;
            offer.LOP_Street_Address__c = null;
            offer.LOP_City__c = null;
            offer.LOP_State__c = null;
            offer.LOP_Zip__c = null;
            offer.LOP_Energy_Star__c = null;
            offer.LOP_Number_of_floors__c = null;
            offer.LOP_GEN_PURPOSE_RENTABLE__c = null;
            offer.LOP_HVAC_HRS_MON_TO_FRI_START__c = null;
            offer.LOP_HVAC_HRS_MON_TO_FRI_END__c = null;
            offer.LOP_HIST_PROP_IN_HIST_DIST__c = null;
            offer.LOP_NON_HIST_PROP_IN_HIST_DIST__c = null;
            offer.LOP_HIST_PROP_IN_NON_HIST_DIST__c = null;
            offer.LOP_SITE_AREA_TYPE__c = null;
            upsert offer;

            PBS_AAAP_GlobalConstants.checkOfferBuildingValidations(offer);
            grexProject = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestGREXProjectEOI();
            grexProject.Project_Due_Timezone__c = 'Atlantic Time';
            PBS_AAAP_GlobalConstants.convertToTimeZone(grexProject);
            grexProject.Project_Due_Timezone__c = 'Eastern Time';
            PBS_AAAP_GlobalConstants.convertToTimeZone(grexProject);
            grexProject.Project_Due_Timezone__c = 'Central Time';
            PBS_AAAP_GlobalConstants.convertToTimeZone(grexProject);
            grexProject.Project_Due_Timezone__c = 'Mountain Time';
            PBS_AAAP_GlobalConstants.convertToTimeZone(grexProject);
            grexProject.Project_Due_Timezone__c = 'Pacific Time';
            PBS_AAAP_GlobalConstants.convertToTimeZone(grexProject);
            grexProject.Project_Due_Timezone__c = 'Guam';
            PBS_AAAP_GlobalConstants.convertToTimeZone(grexProject);
            grexProject.Project_Due_Timezone__c = 'Hawaii';
            PBS_AAAP_GlobalConstants.convertToTimeZone(grexProject);
            grexProject.Project_Due_Timezone__c = null;
            PBS_AAAP_GlobalConstants.convertToTimeZone(grexProject);

            Test.stopTest();
        }

    }

    static testMethod void testParkingPage() {
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
            PBS_LOPController obc = new PBS_LOPController();
            obc.saveParkingInfo();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
            obc = new PBS_LOPController();
            obc.saveParkingAndContinue();
            obc.backToOfrBlding();
        }
    }

    static testMethod void testPropertyOwner() {
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOPController obc = new PBS_LOPController();
            obc.actionSavePropertyOwner();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.actionSavePropertyOwnerAndContinue();
            obc.backToOfrParking();
        }
    }

    static testMethod void testRepsAndCerts() {
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOPController obc = new PBS_LOPController();
            obc.saveRepsAndCertsInfo();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.showOfferorRelationShipOther();
            offer.LOP_OFFEROR_INTEREST__c = 'Other';
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.showOfferorRelationShipOther();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Representation_Business__c = 'Small Business';
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'false');
            obc = new PBS_LOPController();
            obc.getSmallBusiness();
            obc.getSmallBusinessYES();
            obc.showPropertyOwnerSmallBusiness();
            offer.LOP_Representation_Business__c = 'Not a Small Business';
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.getSmallBusinessNO();
            obc.showPropertyOwnerSmallBusiness();
            obc.getOtherRelationShip();
            obc.copyUserDetails();
            obc.saveRepsAndCertsandContinue();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Representation_Business__c = null;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.saveRepsAndCertsandContinue();

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'false');
            obc = new PBS_LOPController();
            obc.backToOfrPropertyOwnerTab();
        }
    }

    static testMethod void testCreateEditOffer() {
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOPController obc = new PBS_LOPController();
            //grexProject = [SELECT Id, name FROM PBS_GREX_Project_EOI__c p where p.Project_Number__c =:projectID and p.Project_EOI_ID__c =:EOIID  ];
            obc.EOIID = 'GIN123456666-1111';
            obc.projectID = '5VA2016';
            obc.createEditOffer();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'false');
            obc = new PBS_LOPController();
            PBS_GREX_Project_EOI__c grexProject = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestGREXProjectEOI();
            grexProject.Project_EOI_ID__c = 'GIN123456789-2458';
            grexProject.Project_Number__c = '5VA2016';
            insert grexProject;
            obc.EOIID = 'GIN123456789-2458';
            obc.projectID = '5VA2016';
            obc.createEditOffer();
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'false');
            obc = new PBS_LOPController();
            obc.EOIID = 'GIN123411119-2458';
            obc.projectID = '2MI1234';
            obc.createEditOffer();
        }
    }
    static testMethod void testSpaceAndRates() {
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOPController obc = new PBS_LOPController();
            obc.actionSaveSpaceRates();
            obc.renderStepRentSection();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.LOP_Is_Shell_Rent_Stepped__c = 'Yes';
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.actionSaveSpaceRates();
            obc.renderStepRentSection();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            // obc.saveTISection();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            //obc.saveBSACSection();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.LOP_TI_Amorization_in_Years__c = 10;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.actionSaveSpaceRatesAndContinue();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.backToLeaseTerms();


        }
    }

    static testMethod void testLeaseTerms() {
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOPController obc = new PBS_LOPController();
            obc.saveLeaseTermsandContinue();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.saveLeaseTermsInfo();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '2. Percent of Total Construction Costs (%)';
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.saveLeaseTermsInfo();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '3. Flat Fee ($)';
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.saveLeaseTermsInfo();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.backToOperatingCostTab();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '2. Percent of Total Construction Costs (%)';
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.saveLeaseTermsandContinue();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '3. Flat Fee ($)';
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOPController();
            obc.saveLeaseTermsandContinue();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            offer.LOP_INITIAL_NO_OF_YEARS__c = null;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'false');
            obc = new PBS_LOPController();
            obc.saveLeaseTermsandContinue();


        }
    }

    static testMethod void testQuestionLabels() {
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();
            PBS_AAAP_QuestionLabels question = new PBS_AAAP_QuestionLabels();

            System.assert(question.lopOpCostsSectOneHdr != null);

            System.assert(question.lopOpCostCol1 != null);
            System.assert(question.lopOpCostCol2 != null);
            System.assert(question.lopOpCostsQ5 != null);
            System.assert(question.lopOpCostsQ6 != null);
            System.assert(question.lopOpCostsQ7 != null);
            System.assert(question.lopOpCostsQ8 != null);
            System.assert(question.lopOpCostsQ9 != null);
            System.assert(question.lopOpCostsQ10 != null);
            System.assert(question.lopOpCostsQ11 != null);
            System.assert(question.lopOpCostsQ12 != null);
            System.assert(question.lopOpCostsQ13 != null);

            System.assert(question.lopOpCostsQ14 != null);
            System.assert(question.lopOpCostsQ15 != null);
            System.assert(question.lopOpCostsQ16 != null);
            System.assert(question.lopOpCostsQ17 != null);

            System.assert(question.lopOpCostsQ18 != null);
            System.assert(question.lopOpCostsQ19 != null);
            System.assert(question.lopOpCostsQ20 != null);
            System.assert(question.lopOpCostsQ21 != null);

            System.assert(question.lopOpCostsQ22 != null);
            System.assert(question.lopOpCostsQ23 != null);
            System.assert(question.lopOpCostsQ24 != null);
            System.assert(question.lopOpCostsQ25 != null);
            System.assert(question.lopOpCostsQ26 != null);
            System.assert(question.lopOpCostsQ27 != null);
            System.assert(question.lopOpCostsQ28 != null);
            System.assert(question.lopOpCostsQ29 != null);

            System.assert(question.lopOpCostsQ30 != null);
            System.assert(question.lopOpCostsQ31 != null);
            System.assert(question.lopOpCostsQ32 != null);
            System.assert(question.lopOpCostsQ33 != null);

            System.assert(question.lopSpaceQ1 != null);
            System.assert(question.lopSpaceQ1 != null);
            System.assert(question.lopSpaceQ2 != null);
            System.assert(question.lopSpaceQ2a != null);
            System.assert(question.lopSpaceQ3 != null);
            System.assert(question.lopSpaceQ4 != null);
            System.assert(question.lopSpaceQ5 != null);
            System.assert(question.lopSpaceQ6 != null);
            System.assert(question.lopSpaceQ7 != null);
            System.assert(question.lopSpaceQ8 != null);
            System.assert(question.lopSpaceQ9 != null);
            System.assert(question.lopSpaceQ10 != null);
            System.assert(question.lopSpaceQ11 != null);
            System.assert(question.lopSpaceQ12 != null);


        }
    }
    //////////////////////////////////////////////////////////////////////////////

    static testMethod void testBuildingPage2() {

        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        String userId = UserInfo.getUserId();
        // PBS_LOP_Offer__c oOther = [select o.Id From PBS_LOP_Offer__c o where o.ownerId != :userId limit 1];

        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();


            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            //         PBS_AAAP_Offer__c nonLOPoffer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestOffer();   // Wes
            ///        PBS_AAAP_Offer__c nonLOPoffer2 = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestOffer1(); // Wes

            //        insert nonLOPoffer; //Wes
            //       insert nonLOPoffer2; //Wes
            insert offer;


            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOP_AttachmentsController obc = new PBS_LOP_AttachmentsController();
            obc.refreshForms();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;

            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            obc.actionSaveAndSubmitOffer();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            obc.actionSubmitOffer();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            obc.actionCancelSubmitOffer();
            obc.getItems();
            obc.actionCancel();


            PBS_LOP_Offer__c lopOffer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            lopOffer.LOP_ACK_READ_RLP_REQ_NO_CHANGE__c = 'Yes';
            lopOffer.LOP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            lopOffer.LOP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            lopOffer.LOP_ACCEPTED_LEASE_FORM_1364__c = 'Yes';
            lopOffer.LOP_ACCEPTED_TERMS_AND_COND__c = 'Yes';
            lopOffer.LOP_Historic_Property_Tier__c = 'Historic property within a historic district';
            lopOffer.LOP_Accessibility_Standards_Met__c = 'Yes';
            lopOffer.LOP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix';
            lopOffer.LOP_RLP_Contains_Seismic_Requirement__c = 'The RLP contains seismic requirements.';
            lopOffer.LOP_Offeror_Seismic_Declaration__c = 'Will be constructed to meet seismic requirements';
            lopOffer.LOP_Flood_Plain_Declaration__c = 'A 500-year flood plain';
            lopOffer.LOP_Fire_Safety_Declaration__c = 'Meets the Lease fire/life safety standards.';
            upsert lopOffer;
            System.debug('lopOffer Id is ***' + lopOffer.id);
            ApexPages.currentPage().getParameters().put('offerId', lopOffer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            System.debug('before rlp checkbox');
            obc.rlpCheckBox = true;

            obc.actionSubmitOffer();

            obc.uploadFormsOnFinalSubmit();
            PBS_GREX_Project_EOI__c projectEOI = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestGREXProjectEOI();
            upsert projectEOI;
            lopOffer = new PBS_LOP_OFFER__c(
                    Project_EOI_ID__c = projectEOI.id
            );
            lopOffer.LOP_ACCEPTED_TERMS_AND_COND__c = 'No';

            upsert lopOffer;
            ApexPages.currentPage().getParameters().put('offerId', lopOffer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            //PBS_AAAP_GlobalConstants.checkFinalOfferBuildingValidations(lopOffer);
            obc.renderRLPSection();
            obc.actionSubmitOffer();
            obc.uploadFormsOnFinalSubmit();


        }
    }

    static testMethod void myOfferAttachmentsConstructorTestUpload() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PageReference currentPage = new PageReference('/apex/PBS_LOP_Attachments');
            Test.setCurrentPage(currentPage);
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();


            insert offer;


            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOP_AttachmentsController obc = new PBS_LOP_AttachmentsController();
            PBS_LOP_Offer_Attachment__c offeratt = new PBS_LOP_Offer_Attachment__c(PBS_LOP_Attachment_Type__c = 'Floor Plan', PBS_LOP_Offer__c = offer.id);
            insert offeratt;

            Blob b = Blob.valueOf('Test Data');

            Attachment attachment = new Attachment();
            //attachment.ParentId = parentId;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_LOP_AttachmentsController opc;
            PageReference pref = null;

            Test.startTest();
            opc = new PBS_LOP_AttachmentsController();
            PBS_LOP_Offer_Attachment__c ofratt = new PBS_LOP_Offer_Attachment__c(PBS_LOP_Offer__c = offer.id);
            opc.offerattachment = offeratt;
            Blob b1 = Blob.valueOf('Test Data');

            Attachment att = new Attachment();
            //attachment.ParentId = parentId;
            att.Name = 'Test Attachment for Parent';
            //att.Body = b1;
            opc.offerattachment = ofratt;
            opc.att = att;
            //opc.ofrID = offer.id;
            opc.upload();

            ofratt.PBS_LOP_Attachment_Type__c = 'Floor Plan';
            opc.offerattachment = ofratt;
            opc.att = att;
            //opc.ofrID = offer.id;
            opc.upload();
            att.Body = b1;
            opc.att = att;
            opc.upload();
            opc.attachmentId = att.Id;
            pref = opc.actionDeleteAttachment();

            opc.actionSubmitOffer();
            opc.redirectToHome();
            opc.actionBackToRatesAndSpaces();
            Test.stopTest();
        }
    }


    /////////////////////////////////////////////////////////////////////////////////////
    //
    //
    //
    static testMethod void myOfferAttachmentsConstructorTest() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;

            Blob b = Blob.valueOf('Test Data');

            Attachment attachment = new Attachment();
            //attachment.ParentId = parentId;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;
            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.getItems();
            opc.actionCancelSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);

            boolean flag = opc.checkOfferSubmissionValidations();
            System.assertEquals(flag, true);
            opc.actionSaveAndSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);
            opc.actionRequestPIN();
            pref = opc.actionDeleteOffer();
            System.assertEquals(pref, null);
            Test.stopTest();
        }
    }

    static testMethod void myOfferAttachmentsConstructorTest1() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;

            Blob b = Blob.valueOf('Test Data');

            Attachment attachment = new Attachment();
            //attachment.ParentId = parentId;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;

            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            pref = opc.actionDeleteOffer();
            System.assertNotEquals(pref, null);
            opc.redirectToHome();
            opc.actionBackToRatesAndSpaces();
            pref = opc.actionCancel();
            System.assert(pref != null);
            Test.stopTest();


        }
    }
    static testMethod void myOfferAttachmentsConstructorTest2() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;

            Blob b = Blob.valueOf('Test Data');

            Attachment attachment = new Attachment();
            //attachment.ParentId = parentId;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;
            System.debug('******** Hello Vaishali::: ' + offer.PBS_AAAP_Offer_Status__c);

            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            pref = opc.actionDeleteOffer();
            System.assertEquals(pref, null);
            opc.redirectToHome();
            opc.actionBackToRatesAndSpaces();
            pref = opc.actionCancel();
            System.assert(pref != null);
            Test.stopTest();

        }
    }


    static testMethod void myOfferAttachmentsConstructorTestSubmit() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            insert offer;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            opc.showMultiOwners();
            boolean flag = opc.getMultiOwners();
            System.assertEquals(flag, true);
            opc.actionSubmitOffer();


            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
            PBS_AAAP_Offer__c offerparent = PBS_AAAP_UtilityTest.createOfferInfo();
            offerparent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offerparent;
            offer.PBS_AAAP_Parent_Offer__c = offerparent.Id;
            update offer;
            opc.submitOffer = offer;

            opc.actionSubmitOffer();
            //added by syam on 09/08/2016
            opc.actionSavePage();

        }
    }

    static testMethod void myOfferSubmitCheckValidations() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;

            PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
            offer.PBS_AAAP_County__c = 'fairfax';
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 Wasser Ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            insert offer;
            
            PageReference myVfPage = Page.PBS_AAAP_OfferAttachments;
            myVfPage.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            PageReference pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);

            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 wasser ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            offer.PBS_AAAP_County__c = 'Fairfax';
            offer.PBS_AAAP_Energy_Star__c = 'Yes';
            offer.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offer.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offer.PBS_AAAP_Number_of_floors__c = 12;
            offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 400000;
            offer.PBS_AAAP_OFFICE_SPACE_RSF__c = 50000;
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 300000;
            offer.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Wood';
            offer.PBS_AAAP_Year_Built__c = '2001';
            offer.PBS_AAAP_Renovation_Year__c = '2007';
            offer.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offer.PBS_AAAP_MetroRail_Station__c = 'Metro';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '6:00 PM';
            offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c = '10:00 AM';
            offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c = '10:00 AM';
            offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';

            update offer;
            
            PageReference myVfPage1 = Page.PBS_AAAP_OfferAttachments;
            myVfPage1.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);
            offer.PBS_AAAP_Option_Parking__c = 'Yes';
            update offer;
            
            PageReference myVfPage2 = Page.PBS_AAAP_OfferAttachments;
            myVfPage2.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);

            offer.PBS_AAAP_Owner_Name__c = 'Test User';
            offer.PBS_AAAP_Owner_Address__c = '1660 International Drive';
            offer.PBS_AAAP_Owner_Country__c = 'USA';
            offer.PBS_AAAP_Owner_City__c = 'McLean';
            offer.PBS_AAAP_Owner_State__c = null;
            offer.PBS_AAAP_Owner_Zip__c = null;
            offer.PBS_AAAP_Owner_Main_Phone__c = '232-232-2332';
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Owner';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Sole Proprietorship';
            offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Fee Simple';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_PARENT_NAME__c = null;
            offer.PBS_AAAP_Common_Parent_TIN__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'Known';
            offer.PBS_AAAP_Owner_TIN_Assigned__c = null;
            update offer;
            
            PageReference myVfPage3 = Page.PBS_AAAP_OfferAttachments;
            myVfPage3.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);

            offer.PBS_AAAP_Owner_Name__c = 'Test User';
            offer.PBS_AAAP_Owner_Address__c = '1660 International Drive';
            offer.PBS_AAAP_Owner_Country__c = 'USA';
            offer.PBS_AAAP_Owner_City__c = 'McLean';
            offer.PBS_AAAP_Owner_State__c = 'VA';
            offer.PBS_AAAP_Owner_Zip__c = '22102';
            offer.PBS_AAAP_Owner_Main_Phone__c = '232-232-2332';
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Owner';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Sole Proprietorship';
            offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Fee Simple';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_PARENT_NAME__c = 'Test';
            offer.PBS_AAAP_Common_Parent_TIN__c = '999999999';
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'Known';
            offer.PBS_AAAP_Owner_TIN_Assigned__c = '999999999';
            update offer;
            
            PageReference myVfPage4 = Page.PBS_AAAP_OfferAttachments;
            myVfPage4.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);

            offer.PBS_AAAP_Owner_TIN_Status__c = 'Applied for';
            offer.PBS_AAAP_Owner_TIN_Assigned__c = null;
            update offer;
            
            PageReference myVfPage5 = Page.PBS_AAAP_OfferAttachments;
            myVfPage5.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);


            offer.PBS_AAAP_Representation__c = 'Yes';
            offer.PBS_AAAP_Women_Owned_Identifier__c = 'Yes';
            offer.PBS_AAAP_EEO_CLAUSE__c = 'Yes';
            offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes';
            offer.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = 'Yes';
            offer.PBS_AAAP_Confirm_Owner_Status__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONVICTION__c = 'Yes';
            offer.PBS_AAAP_OWNER_INDICTMENT__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = 'Yes';
            offer.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = 'Yes';
            update offer;
            
            PageReference myVfPage6 = Page.PBS_AAAP_OfferAttachments;
            myVfPage6.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);

            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            
            PageReference myVfPage7 = Page.PBS_AAAP_OfferAttachments;
            myVfPage7.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'No';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            offer.PBS_AAAP_X_CO_ORD__c = -77.00896157;
            offer.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
            update offer;
            
            PageReference myVfPage8 = Page.PBS_AAAP_OfferAttachments;
            myVfPage8.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            opc.showMultiOwners();
            pref = opc.actionSubmitOffer();
            //System.assertNotEquals(pref, null);

            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '121212';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            update offer;
            
            PageReference myVfPage9 = Page.PBS_AAAP_OfferAttachments;
            myVfPage9.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            pref = opc.actionSubmitOffer();

            /*Vaishali RLP FY15 90% coverage
            Make sure we catch pin not matching exception
            */
            System.debug('***** message component: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getComponentLabel());
            System.debug('***** message detail: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getDetail());
            System.debug('***** message summary: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary());
            System.debug('***** message: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1));
            // System.assert(ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary().equalsIgnoreCase('Signature - PIN value is incorrect.'));

            //  System.assertEquals(pref, null);
            //Vaishali RLP FY15 Multi Owner Check
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            update offer;
            
            PageReference myVfPage10 = Page.PBS_AAAP_OfferAttachments;
            myVfPage10.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.debug('***** message component: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getComponentLabel());
            System.debug('***** message detail: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getDetail());
            System.debug('***** message summary: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary());
            System.debug('***** message: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1));
            //System.assert(ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary().equalsIgnoreCase('Cannot submit the offer if you are not authorized by the owner to represent other owners.'));
            //  System.assertEquals(pref, null);

            PBS_AAAP_Offer__c offerParent = PBS_AAAP_UtilityTest.createOfferInfo();
            offerParent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offerParent;

            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
            offer.PBS_AAAP_Parent_Offer__c = offerParent.Id;
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'Yes'; //Vaishali
            update offer;
            
            PageReference myVfPage11 = Page.PBS_AAAP_OfferAttachments;
            myVfPage11.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionSubmitOffer();
            System.assertEquals(offerParent.Id, offer.PBS_AAAP_Parent_Offer__c);
            System.debug('***** message component: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getComponentLabel());
            System.debug('***** message detail: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getDetail());
            System.debug('***** message summary: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary());
            System.debug('***** HELLO VAISHALI: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1));

//Vaishali Offer delete attachment check            
            PBS_AAAP_Offer_Attachments__c offeratt1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt1;
            
            PageReference myVfPage12 = Page.PBS_AAAP_OfferAttachments;
            myVfPage12.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();            
            opc.attachmentId = offeratt1.Id;
            opc.submitOffer = offer;  //Nik - 1/29
            pref = opc.actionDeleteAttachment();
            System.assertNotEquals(pref, null);
            Test.startTest();
            
            PageReference myVfPage13 = Page.PBS_AAAP_OfferAttachments;
            myVfPage13.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.attachmentId = null;
            pref = opc.actionDeleteAttachment();
            System.assertEquals(pref, null);
            Test.stopTest();
        }
    }

    static testMethod void myOfferSubmission() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;

            PBS_AAAP_Offer__c offerParent = PBS_AAAP_UtilityTest.createOfferInfo();
            offerParent.PBS_AAAP_RLP_Number__c = rlp.Id;
            offerParent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offerParent;

            PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 Wasser Ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            offer.PBS_AAAP_Energy_Star__c = 'Yes';
            offer.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offer.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offer.PBS_AAAP_Number_of_floors__c = 12;
            offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 400000;
            offer.PBS_AAAP_OFFICE_SPACE_RSF__c = 50000;
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 300000;
            offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 200000;
            offer.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Wood';
            offer.PBS_AAAP_Year_Built__c = '2001';
            offer.PBS_AAAP_Renovation_Year__c = '2007';
            offer.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offer.PBS_AAAP_MetroRail_Station__c = 'Metro';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '6:00 PM';
            offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c = '10:00 AM';
            offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c = '10:00 AM';
            offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_Option_Parking__c = 'Yes';
            offer.PBS_AAAP_Owner_Name__c = 'Test User';
            offer.PBS_AAAP_Owner_Address__c = '1660 International Drive';
            offer.PBS_AAAP_Owner_Country__c = 'USA';
            offer.PBS_AAAP_Owner_City__c = 'McLean';
            offer.PBS_AAAP_Owner_State__c = 'VA';
            offer.PBS_AAAP_Owner_Zip__c = '22102';
            offer.PBS_AAAP_county__c = 'fairfax';
            offer.PBS_AAAP_Owner_Main_Phone__c = '232-232-2332';
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Owner';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Sole Proprietorship';
            offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Fee Simple';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_PARENT_NAME__c = null;
            offer.PBS_AAAP_Common_Parent_TIN__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'Known';
            offer.PBS_AAAP_Owner_TIN_Assigned__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Representation__c = 'Yes';
            offer.PBS_AAAP_Women_Owned_Identifier__c = 'Yes';
            offer.PBS_AAAP_EEO_CLAUSE__c = 'Yes';
            offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes';
            offer.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = 'Yes';
            offer.PBS_AAAP_Confirm_Owner_Status__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONVICTION__c = 'Yes';
            offer.PBS_AAAP_OWNER_INDICTMENT__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = 'Yes';
            offer.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = 'Yes';
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            offer.PBS_AAAP_Parent_Offer__c = offerParent.Id;
            offer.PBS_AAAP_COST_PER_ABOA__c = 10;
            insert offer;
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            
            PageReference myVfPage = Page.PBS_AAAP_OfferAttachments;
            myVfPage.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            PageReference pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);

            PBS_AAAP_Space__c sp0 = new PBS_AAAP_Space__c();
            sp0 = PBS_AAAP_UtilityTest.createSpace();
            sp0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            sp0.PBS_AAAP_SF_OFFERED__c = 200000;
            insert sp0;
            PBS_AAAP_Rate__c r0 = new PBS_AAAP_Rate__c();
            r0 = PBS_AAAP_UtilityTest.createRate();
            r0.PBS_AAAP_Space__c = sp0.Id;
            insert r0;
            pref = opc.actionCheckErrors();
            pref = opc.actionSubmitOffer();
            System.assertEquals(pref, null);
            /*Vaishali
        PBS_AAAP_RLP__c rlp1 = new PBS_AAAP_RLP__c(  PBS_AAAP_Category__c = 'Office', PBS_AAAP_DEFAULT_MONTH_END__c = '30',
                                                    PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1', PBS_AAAP_DISCOUNT_RATE__c = 12.00, 
                                                    PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00, PBS_AAAP_MOVE_DEFAULT__c = 2.00,
                                                    PBS_AAAP_TELCOMM_DEFAULT__c = 2.00, PBS_AAAP_MAX_TIUSED__c = 52.00,
                                                    PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 2.00, PBS_AAAP_Year__c = '2013',
                                                    PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/Active',
                                                    PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 20.00, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 4.00,
                                                    PBS_AAAP_Title__c = 'Washington DC', PBS_AAAP_RLP_Number__c = '13-NCR', PBS_AAAP_ALLOW_TIER2_AMMORT__c = true, PBS_AAAP_BSAC_per_ABOA__c=6);
            insert RLP1;*/
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'Yes';
            //offer.PBS_AAAP_RLP_Number__c = rlp1.Id;
            update offer;
            r0.PBS_AAAP_BSAC_RATE__c = null;
            r0.PBS_AAAP_BSAC__c = 0;
            update r0;
            
            PageReference myVfPage1 = Page.PBS_AAAP_OfferAttachments;
            myVfPage1.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionCheckErrors();
            System.assertEquals(pref, null);
            System.debug('***** HELLO VAISHALI B4: ');

            pref = opc.actionSaveAndSubmitOffer();
            System.debug('***** HELLO VAISHALI1: ');
            System.debug('***** HELLO VAISHALI2: ');
            System.assertEquals(pref, null);

            //added by syam
            /*Datetime d = Datetime.now();
           r0.LastModifiedDate = d;
           d = d.addMonths(2);
           offer.LastModifiedDate = d;*/
            r0.PBS_AAAP_LEASE_TERM__c = '5+5 Years';
            r0.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 0;
            r0.PBS_AAAP_BSAC__c = 5;
            offer.PBS_AAAP_COST_PER_ABOA__c = 0;
            offer.PBS_AAAP_Option_Parking__c = null;
            // offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
            update r0;
            update offer;
            opc.addrFlag = 'true';
            pref = opc.actionCheckErrors();
            pref = opc.actionSaveAndSubmitOffer();
        }
    }

    static testMethod void myOfferSubmitCheckErrors() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;

            PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();

            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 Wasser Ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            offer.PBS_AAAP_County__c = 'fairfax';
            offer.PBS_AAAP_Energy_Star__c = 'No';
            offer.PBS_AAAP_Energy_Star_Reason__c = '';
            offer.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offer.PBS_AAAP_MetroRail_Station__c = null;
            //offer.PBS_AAAP_Owner_Country__c = 'United States';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = null;
            offer.PBS_AAAP_Owner_TIN_Status__c = null;
            offer.PBS_AAAP_Close_To_Metro__c = null;
            insert offer;
            
            PageReference myVfPage = Page.PBS_AAAP_OfferAttachments;
            myVfPage.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            PageReference pref = opc.actionCheckErrors();
            System.assertEquals(pref, null);

            offer.PBS_AAAP_Owner_Country__c = 'United States';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'KNOWN';
            update offer;
            
            PageReference myVfPage1 = Page.PBS_AAAP_OfferAttachments;
            myVfPage1.getParameters().put('offerId', offer.id);
            //ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionCheckErrors();
            System.assertEquals(pref, null);
//Vaishali Rates date and BSAC check


//Vaishali Rates date and BSAC check            
        }
    }


}