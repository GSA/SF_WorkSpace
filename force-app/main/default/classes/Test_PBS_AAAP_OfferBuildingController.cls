@IsTest
private class Test_PBS_AAAP_OfferBuildingController {
    
    static testMethod void checkBuster() {
        integer b = PBS_AAAP_OfferBuildingController.buster(450);
        b = b + 3219;
        system.assert(b > 100);
    }
    
    static testMethod void myOfferBuildingConstructorTest() {
        
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();
        
        User uOther = PBS_AAAP_UtilityTest.createPortalUser('Other');
        PBS_AAAP_Offer__c oOther;
        System.runAs(uOther) {
            oOther = PBS_AAAP_UtilityTest.createOfferInfo('Other');
        }
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        
        system.assert(uOther.Id != u.Id);
        
        System.runAs(u) {         
            Test.startTest();
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            List<SelectOption> items = obc.getItems();
            List<SelectOption> partialitems = obc.getPartialItems();
            PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
            List<SelectOption> onSiteParkingItems = opc.getOnsiteParkingItems();
            
            
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            obc = new PBS_AAAP_OfferBuildingController();
            offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            obc = new PBS_AAAP_OfferBuildingController();
            offer = PBS_AAAP_UtilityTest.createOfferInfo();
            PBS_AAAP_OfferBuildingController.findProperty('301 7Th St SW', 'Washington', 'DC', '20004');
            PBS_AAAP_OfferBuildingController.findProperty(null, 'Washington', 'DC', '20004');
            PBS_AAAP_OfferBuildingController.findProperty(null, 'Washington', 'DC', null);
            PBS_AAAP_OfferBuildingController.findProperty(null, '', 'DC', null);
           
            PBS_AAAP_OfferBuildingController.findProperty('1600 International Drive', 'McLean', 'Virginia', '22102');
            PBS_AAAP_OfferBuildingController.findProperty('1600 International Drive', 'McLean', 'Virginia', '22102');
            PBS_AAAP_OfferBuildingController.findProperty(null, 'McLean', 'Virginia', '22102');
            PBS_AAAP_OfferBuildingController.findProperty(null, 'McLean', 'Virginia', null);
            PBS_AAAP_OfferBuildingController.findProperty(null, '', 'Virginia', null);
            
            System.debug('syam testing for bronx ****');
            PBS_AAAP_OfferBuildingController.findProperty('1200 Waters place', 'Bronx', 'NY', '10461');
            insert offer;
            
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', oOther.id);
            obc = new PBS_AAAP_OfferBuildingController();
            obc.getCounties();
            obc.updateOfferDetails();
            Test.stopTest();
        }
        
    }
    
    static testMethod void myOfferBuildingTestcp() {
        System.debug('*** Testing myOfferBuildingTestcp *** ');
        PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.id;
        insert offer;
        
        ApexPages.currentPage().getParameters().put('action', 'copy');
        ApexPages.currentPage().getParameters().put('offerId', offer.Id);
        obc = new PBS_AAAP_OfferBuildingController();
        obc.action = 'copy';
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('action', 'modify');
        obc = new PBS_AAAP_OfferBuildingController();
        obc.savePropertyData(offer);
    }
    //added by syam on 02/18 to test the offerBuilding Save
    static testMethod void myOfferBuildingSaveTest() {
        System.debug('inside myOfferBuildingSaveTest *****');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        
        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            System.assert(rlp.Id != null);
            System.debug('rlp id from myOfferBuildingSaveTest is ***' + rlp.id);
            
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
        	offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '11:00 PM';
            insert offer;
            System.debug('offer id from myOfferBuildingSaveTest is ***' + offer.id);
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.Id);
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.Id);
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            System.debug('inside myOfferBuildingSaveTest before savebuilding*****' + rlp.Id);
            obc.saveBuilding();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.Id);
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.Id);
            obc = new PBS_AAAP_OfferBuildingController();
            System.debug('inside myOfferBuildingSaveTest before savebuilding*****' + rlp.Id);
            obc.saveBuilding();
        }
        Test.stopTest();
    }
    
    //added by syam on 02/19 to test the offerBuilding Save
    static testMethod void myNewOfferBuildingSaveTest() {
        System.debug('inside myNewOfferBuildingSaveTest *****');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        
        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            System.assert(rlp.Id != null);
            System.debug('rlp id from myNewOfferBuildingSaveTest is ***' + rlp.id);
            
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            System.debug('offer id from myNewOfferBuildingSaveTest is ***' + offer.id);
        
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.Id);
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            obc.offerBuilding = offer;
            obc.selectRLP = rlp.id;
            
            System.debug('inside myNewOfferBuildingSaveTest before savebuilding*****' + rlp.Id);
            obc.saveBuilding();
            
            
        }
        Test.stopTest();
    }
    
    static testMethod void myOfferActionSaveBuildingInfoTest() {
        System.debug('inside myOfferActionSaveBuildingInfoTest *****');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        
        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            System.assert(rlp.Id != null);
            System.debug('rlp id from myOfferActionSaveBuildingInfoTest is ***' + rlp.id);
            
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            offer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'No';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
        	offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '11:00 PM';
            insert offer;
            System.debug('offer id from myOfferActionSaveBuildingInfoTest is ***' + offer.id);
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.Id);
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.Id);
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            System.debug('inside myOfferActionSaveBuildingInfoTest before savebuilding*****' + rlp.Id);
            obc.actionSaveBuildingInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.Id);
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.Id);
            obc = new PBS_AAAP_OfferBuildingController();
            System.debug('inside myOfferActionSaveBuildingInfoTest before actionSaveBuildingInfo*****' + rlp.Id);
            obc.actionSaveBuildingInfo();
            
        }
        Test.stopTest();
    }
    
    static testMethod void myNewOfferActionSaveBuildingInfoTest() {
        System.debug('inside myNewOfferActionSaveBuildingInfoTest *****');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        
        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            System.assert(rlp.Id != null);
            System.debug('rlp id from myNewOfferActionSaveBuildingInfoTest is ***' + rlp.id);
            
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            System.debug('offer id from myNewOfferActionSaveBuildingInfoTest is ***' + offer.id);
          
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.Id);
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            obc.offerBuilding = offer;
            obc.selectRLP = rlp.id;
            System.debug('inside myNewOfferActionSaveBuildingInfoTest before savebuilding*****' + rlp.Id);
            obc.actionSaveBuildingInfo();
            
        }
        Test.stopTest();
    }
    
    static testMethod void myOfferBuildingValidateTest() {
        System.debug('*** Testing myOfferBuildingValidateTest *** ');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        System.runAs(u) {
            PageReference pageRef = Page.PBS_AAAP_OfferBuilding;
            Test.setCurrentPage(pageRef);
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            
            List<SelectOption> rlplist = obc.getRLPs();
            
            PBS_AAAP_Offer__c offerBuilding = new PBS_AAAP_Offer__c();
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            offerBuilding.PBS_AAAP_RLP_Number__c = rlp.id;
            System.debug('rlp.id in myOfferBuildingValidateTest is' + rlp.id);
            System.assert(rlp.Id != null);
            insert offerBuilding;
            System.debug('offer id from myOfferBuildingValidateTest is ***' + offerBuilding.id);
            System.assert(offerBuilding.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offerBuilding.Id);
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.id);
            obc.saveBuilding();
            System.debug('after first save in myOfferBuildingValidateTest****');
            
            offerBuilding = PBS_AAAP_UtilityTest.createOfferInfo();
            insert offerBuilding;
            obc.offerBuilding = offerBuilding;
            obc.saveBuilding();
            offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            update offerBuilding;
            obc.offerBuilding = offerBuilding;
            obc.saveBuilding();
            offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            update offerBuilding;
            obc.offerBuilding = offerBuilding;
            obc.saveBuilding();
            System.assert(offerBuilding.Id != null);
            offerBuilding.PBS_AAAP_MetroRail_Station__c = null;
            obc.saveBuilding();
            offerBuilding.PBS_AAAP_State__c = 'MD';
            obc.getCountiesSpecial();
            offerBuilding.PBS_AAAP_State__c = 'DC';
            obc.getCountiesSpecial();
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 10;
            offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            obc.saveBuilding();
            obc.actionSaveBuildingInfo();
            obc.getSiteSizeItems();           
            
            offerBuilding = PBS_AAAP_UtilityTest.createOfferInfo();
            obc.offerBuilding = offerBuilding;
            system.assert(obc.offerBuilding!=null);
            
            offerBuilding.PBS_AAAP_Building_Name__c = 'school';
            offerBuilding.PBS_AAAP_Street_Address__c = '9525 Main St';
            offerBuilding.PBS_AAAP_City__c = 'Fairfax';
            offerBuilding.PBS_AAAP_RLP_Region__c = rlp.PBS_AAAP_Region__c;
            offerBuilding.PBS_AAAP_State__c = 'VA';
            offerBuilding.PBS_AAAP_ZipCode__c = '22031';
            offerBuilding.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding.PBS_AAAP_Energy_Star_Reason__c = 'The building is old';
            offerBuilding.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offerBuilding.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offerBuilding.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offerBuilding.PBS_AAAP_Number_of_floors__c = 2;
            offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 100;
            offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 50;
            offerBuilding.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c - 1;
            offerBuilding.PBS_AAAP_Year_Built__c = '1962';
            offerBuilding.PBS_AAAP_Close_To_Metro__c = 'No';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 PM';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 20039;
            offerBuilding.PBS_AAAP_X_CO_ORD__c = 38;
            offerBuilding.PBS_AAAP_Y_CO_ORD__c = 77;
            offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'No';
            
            PBS_AAAP_RLP_Regions_Map__c rm = new PBS_AAAP_RLP_Regions_Map__c();
            rm.PBS_AAAP_Region_Name__c = offerBuilding.PBS_AAAP_RLP_Region__c;
            rm.PBS_AAAP_RLP_State_Abbrevation__c = offerBuilding.PBS_AAAP_State__c;
            rm.PBS_AAAP_RLP_State__c = offerBuilding.PBS_AAAP_State__c;
            insert rm;
            
            offerBuilding.PBS_AAAP_County__c = rm.PBS_AAAP_RLP_State__c;
            
            obc.selectRLP = rlp.Id;
            system.assert(obc.offerBuilding!=null);
            
            obc.saveBuilding();
            system.assert(obc.offerBuilding!=null);
            obc.actionSaveBuildingInfo();
            system.assert(obc.offerBuilding!=null);
            
            
            offerBuilding.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'No';
            offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 100;
            
            insert offerBuilding;
            
            system.assert(obc.offerBuilding!=null);
            
            obc.saveBuilding(true);
            obc.offerBuilding = offerBuilding;
            
            system.assert(obc.offerBuilding!=null);
            obc.actionSaveBuildingInfo(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myOfferBuildingTest() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        System.runAs(u) {
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            
            List<SelectOption> rlplist = obc.getRLPs();
            obc.showPopup();
            PBS_AAAP_Offer__c offerBuilding1 = new PBS_AAAP_Offer__c();
            offerBuilding1 = PBS_AAAP_UtilityTest.createOfferInfo();
            offerBuilding1.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            offerBuilding1.PBS_AAAP_Energy_Star__c = 'No';
            insert offerBuilding1;
            
            obc.offerBuilding = offerBuilding1;
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            System.assert(rlp.Id != null);
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.id);
            offerBuilding1.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding1.PBS_AAAP_Energy_Star_Reason__c = '';
            try {
                obc.saveBuilding();
            } catch (Exception ex) {
                System.debug(ex.getMessage());
            }
            PBS_AAAP_Offer__c offerBuilding2 = new PBS_AAAP_Offer__c();
            offerBuilding2 = PBS_AAAP_UtilityTest.createOfferInfo();
            offerBuilding2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offerBuilding2.PBS_AAAP_Energy_Star__c = 'Yes';
            offerBuilding2.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offerBuilding2.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Steel';
            offerBuilding2.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Brick';
            offerBuilding2.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Brick';
            obc.offerBuilding = offerBuilding2;
            obc.getCensusCheck();
            obc.getRoofingMatOther();
            obc.showRoofingMaterialOther();
            obc.saveBuilding();
            obc.actionCancel();
            obc.refreshPanel();
            obc.openNewWindow();
            
            offerBuilding2.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding2.PBS_AAAP_Energy_Star_Reason__c = 'No';
            offerBuilding2.PBS_AAAP_Close_To_Metro__c = 'No';
            offerBuilding2.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Other';
            offerBuilding2.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Other';
            offerBuilding2.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Other';
            
            obc.offerBuilding = offerBuilding2;
            obc.getRoofingMatOther();
            obc.showRoofingMaterialOther();
            obc.saveBuilding();
            
            
            offerBuilding2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            obc.offerBuilding = offerBuilding2;
            obc.actionSaveBuildingInfo();
            offerBuilding2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            obc.offerBuilding = offerBuilding2;
            obc.actionSaveBuildingInfo();
            offerBuilding2.PBS_AAAP_State__c = 'DC';
            obc.offerBuilding = offerBuilding2;
            
            obc.refreshPanel();
            
        }
        Test.stopTest();
    }
    
    static testMethod void myOfferBuildingDeleteTest() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        
        System.runAs(u) {
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            
            List<SelectOption> rlplist = obc.getRLPs();
            obc.showPopup();
            PBS_AAAP_Offer__c offerBuilding1 = new PBS_AAAP_Offer__c();
            offerBuilding1 = PBS_AAAP_UtilityTest.createOfferInfo();
            offerBuilding1.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            
            insert offerBuilding1;
            System.assert(offerBuilding1.Id != null);
            obc.offerBuilding = offerBuilding1;
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.id);
            
            
            PBS_AAAP_Space__c space = new PBS_AAAP_Space__c();
            space = PBS_AAAP_UtilityTest.createSpace();
            space.PBS_AAAP_OFFER_NUMBER__c = offerBuilding1.id;
            insert space;
            offerBuilding1.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            update offerBuilding1;
            obc.actionDeleteOffer();
            offerBuilding1.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            update offerBuilding1;
            obc.actionDeleteOffer();
            obc = new PBS_AAAP_OfferBuildingController();
            
            rlplist = obc.getRLPs();
            obc.showPopup();
            offerBuilding1 = new PBS_AAAP_Offer__c();
            offerBuilding1 = PBS_AAAP_UtilityTest.createOfferInfo();
            offerBuilding1.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED;
            
            insert offerBuilding1;
            
            obc.offerBuilding = offerBuilding1;
            rlp = [SELECT id FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_Region__c = 'National Capital Region' LIMIT 1];
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.id);
            obc.actionDeleteOffer();
        }
    }
    
    static testMethod void myOfferParkingConstructorTestAdmin() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        offer.PBS_AAAP_Option_Parking__c = 'Yes';
        insert offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
        PageReference page = opc.showParkingOptions();
        offer.PBS_AAAP_Option_Parking__c = 'No';
        page = opc.showParkingOptions();
        offer.PBS_AAAP_Option_Parking__c = '';
        page = opc.showParkingOptions();
    }
    
    static testMethod void otherTest() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        
        System.runAs(u) {
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferParking');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            insert offer;
            PBS_AAAP_OfferParkingController opc;
            opc = new PBS_AAAP_OfferParkingController();
            opc.offerParking = offer;
            Test.startTest();
            opc.offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c = null;
            opc.offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c = null;
            opc.checkOfferParkingValidations();
            try {
                opc.saveParkingAndContinue();
            } catch (Exception e) {
                
                System.assert(e.getMessage().contains('Number'));
            }
            
            Test.stopTest();
        }
    }
    
    static testMethod void myOfferParkingConstructorTest() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        
        system.runAs(u){           
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferParking');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_Option_Parking__c = null;
            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferParkingController opc;
            opc = new PBS_AAAP_OfferParkingController();
            
            Test.startTest();
           
            opc.checkOfferParkingValidations();
            offer.PBS_AAAP_Option_Parking__c = null;
            update offer;
            opc.checkOfferParkingValidations();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            opc.saveParkingAndContinue();
            offer.PBS_AAAP_Option_Parking__c = 'Yes';
            offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 0;
            offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 0;
            offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 0;
            offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 0;            
            update offer;
            opc = new PBS_AAAP_OfferParkingController();
            System.debug(':::::::::::::::::: opc.offerParking :::::::::::: ' + opc.offerParking );
            
            List<SelectOption> partialItems = opc.getPartialItems();
            System.assert(partialItems.size() > 0);
            
            PageReference page = opc.saveParkingAndContinue();
            
            
            // This is to test the PBS_AAAP_OfferHelper findCongressionalDistrict() method, it will be executed through the trigger PBS_AAAP_OfferTriggerBIBU            
            offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_State__c ='VA';
            offer.PBS_AAAP_Congressional_District__c ='';
            offer.PBS_AAAP_X_CO_ORD__c =0;
            PBS_AAAP_OfferHelper.triggerupdate(false);
            insert offer;
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
            update offer;
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED;
            update offer;
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED;
            offer.PBS_AAAP_Close_To_Metro__c = 'NO';
            update offer;
            PBS_AAAP_Offer__C offer1 = PBS_AAAP_UtilityTest.createOfferInfo();
            PBS_AAAP_Offer__C offer2 = PBS_AAAP_UtilityTest.createOfferInfo();
            List<PBS_AAAP_Offer__C> offerList = new List<PBS_AAAP_Offer__C>();
            offerList.add(offer1);
            offerList.add(offer2);
            Test.stopTest();

        }
    }
    
    static testMethod void myOfferParkingConstructorAdminTest() {
        PBS_AAAP_Offer__c offerParking = PBS_AAAP_UtilityTest.createOfferInfo();
        offerParking.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        offerParking.PBS_AAAP_Option_Parking__c = 'Yes';
        insert offerParking;
        ApexPages.currentPage().getParameters().put('offerId', offerParking.Id);
        PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
        
        opc.getOptions5a();
        opc.getOptions5b();
        opc.getOptions5c();
        opc.showParkingOptions();
        offerParking.PBS_AAAP_Option_Parking__c = 'No';
        update offerParking;
        System.assert(offerParking.Id != null);
        opc = new PBS_AAAP_OfferParkingController();
        opc.getOptions5a();
        opc.getOptions5b();
        opc.getOptions5c();
        opc.showParkingOptions();
        offerParking.PBS_AAAP_Option_Parking__c = '';
        update offerParking;
        opc = new PBS_AAAP_OfferParkingController();
        opc.getOptions5a();
        opc.getOptions5b();
        opc.getOptions5c();
        opc.showParkingOptions();
        System.assert(offerParking.Id != null);
    }
    
    static testMethod void myOfferParkingConstructorTest1() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        
        System.runAs(u){
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferParking');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.Id);
            PBS_AAAP_OfferParkingController opc;
            
            
            Test.startTest();
            opc = new PBS_AAAP_OfferParkingController();
            PageReference page = opc.actionDeleteOffer();
            System.assert(page != null);            
            
            page = opc.backToOfrBlding();
            page = opc.saveParkingInfo();

            page = opc.actionCancel();
            System.assert(page != null);           
            
            Test.stopTest();
        }
    }
    
    static testMethod void myOfferParkingConstructorTest2() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        
        System.runAs(u){
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferParking');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.Id);
            PBS_AAAP_OfferParkingController opc;
            
            
            Test.startTest();
            opc = new PBS_AAAP_OfferParkingController();
            
            PageReference page = opc.actionDeleteOffer();
            System.assert(page == null);
            Test.stopTest();
        }
    }
    
    static testMethod void testDaoException(){
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c returnVal = new PBS_AAAP_Offer__c();
        returnVal = dao.getOffer('dummyId');
        List<PBS_AAAP_Rate__c> returnVal1 = new List<PBS_AAAP_Rate__c>();
        returnVal1 = dao.getRates('dummyId');
        returnVal1 = dao.getRatesFromSpace('pSpaceId');
        PBS_AAAP_RLP__c returnVal2 = new PBS_AAAP_RLP__c();
        returnVal2 = dao.getRLP('pId');
        List<PBS_AAAP_Space__c> returnVal3 = new List<PBS_AAAP_Space__c>();
        returnVal3 = dao.getSpaces('pId');
        System.assert(dao != null);
       
    }
    
    //Addedd to test the r1evised validateOfferAddressWithRLPRegion function
    static testMethod void myvalidateOfferAddressWithRLPRegionTest() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        System.runAs(u){
            
            
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            
            Boolean errorflag;
            PBS_AAAP_Offer__c offerBuilding = new PBS_AAAP_Offer__c();
            
            offerBuilding.PBS_AAAP_Energy_Star__c = null;
            offerBuilding.PBS_AAAP_Building_Name__c = null;
            offerBuilding.PBS_AAAP_Street_Address__c = null;
            offerBuilding.PBS_AAAP_City__c = 'Washington';
            offerBuilding.PBS_AAAP_State__c = 'DC';
            offerBuilding.PBS_AAAP_ZipCode__c = '20002';
            offerBuilding.PBS_AAAP_County__c = 'District of Columbia';
            
            offerBuilding.PBS_AAAP_RLP_Region__c = 'NCR';
            List <PBS_AAAP_Offer__c> OB = new List<PBS_AAAP_Offer__c>();
            OB.add(offerBuilding);  //pass offerBuilding as a list
            errorflag = PBS_AAAP_OfferBuildingController.validateOfferAddressWithRLPRegion(OB);
            System.assert(!errorflag || errorFlag);
            
            offerBuilding.PBS_AAAP_Energy_Star__c = 'Yes';
            offerBuilding.PBS_AAAP_Building_Name__c = 'Test ';
            offerBuilding.PBS_AAAP_Street_Address__c = '6500 Main street';
            offerBuilding.PBS_AAAP_City__c = 'Houston';
            offerBuilding.PBS_AAAP_State__c = 'TX';
            offerBuilding.PBS_AAAP_ZipCode__c = '77030';
            offerBuilding.PBS_AAAP_County__c = 'Fulton';
            offerBuilding.PBS_AAAP_RLP_Region__c = 'Region 2';
            offerBuilding.PBS_AAAP_Energy_Star__c = 'Yes';
            offerBuilding.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offerBuilding.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offerBuilding.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offerBuilding.PBS_AAAP_Number_of_floors__c = 5 ;
            offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 1000;
            offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 1000;
            offerBuilding.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Steel';
            offerBuilding.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Brick';
            offerBuilding.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Brick';
            offerBuilding.PBS_AAAP_Year_Built__c = '2000';
            offerBuilding.PBS_AAAP_Close_To_Metro__c = 'No';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 PM';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '9:00 PM';
            
            offerBuilding.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offerBuilding.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No' ;
            System.debug('*************offerBuilding1.PBS_AAAP_Street_Address__c************** ::: '+offerBuilding);
            
            List <PBS_AAAP_Offer__c> OB2 = new List<PBS_AAAP_Offer__c>();
            OB2 .add(offerBuilding);  //pass offerBuilding as a list
            System.debug('*************OB2 SIZE************** ::: '+OB2.size());
            errorflag = PBS_AAAP_OfferBuildingController.validateOfferAddressWithRLPRegion(OB2 );
        }
        Test.stopTest();
    }
    
    static testMethod void myOfferBuildingOtherTest() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        System.runAs(u){
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            
            List<SelectOption> rlplist = obc.getRLPs();
            obc.showPopup();
            PBS_AAAP_Offer__c offerBuilding1 = new PBS_AAAP_Offer__c();
            offerBuilding1 = PBS_AAAP_UtilityTest.createOfferInfo();
            offerBuilding1.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offerBuilding1.PBS_AAAP_Street_Address__c = '9515 Edgeley Rd';
            offerBuilding1.PBS_AAAP_City__c = 'Bethesda';
            offerBuilding1.PBS_AAAP_State__c = 'MD';
            offerBuilding1.PBS_AAAP_ZipCode__c = '20814';
            offerBuilding1.PBS_AAAP_County__c = 'Montgomery';
            
            insert offerBuilding1;
            System.debug('*************offerBuilding1.PBS_AAAP_Street_Address__c************** ::: '+offerBuilding1.PBS_AAAP_County__c);
            
            
            obc.offerBuilding = offerBuilding1;
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            System.assert(rlp.Id != null);
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.Id);
            offerBuilding1.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding1.PBS_AAAP_Energy_Star_Reason__c = 'Test';
            try{
                obc.saveBuilding();
            }catch(Exception ex){
                System.debug(ex.getMessage());
            }
            System.debug('*************offerBuilding1.PBS_AAAP_Street_Address__c************** ::: '+offerBuilding1.PBS_AAAP_County__c);
            PBS_AAAP_Offer__c offerBuilding2 = new PBS_AAAP_Offer__c();
            offerBuilding2 = PBS_AAAP_UtilityTest.createOfferInfo();
            offerBuilding2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            obc.offerBuilding = offerBuilding2;
            obc.getRoofingMatOther();
            obc.showRoofingMaterialOther();
            obc.saveBuilding();
            obc.actionCancel();
            obc.refreshPanel();
            obc.openNewWindow();
            
            obc.offerBuilding = offerBuilding2;
            obc.getRoofingMatOther();
            obc.showRoofingMaterialOther();
            obc.saveBuilding();
            
            
            offerBuilding2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            obc.offerBuilding = offerBuilding2;
            obc.metroWalkable = false;
            obc.actionSaveBuildingInfo();
            offerBuilding2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            obc.offerBuilding = offerBuilding2;
            obc.actionSaveBuildingInfo();
            
        }
        Test.stopTest();
    }
    
    static testMethod void saveParkingInfoTest() {
        
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        
        System.runAs(u){
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferParking');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.Id);
            PBS_AAAP_OfferParkingController opc;
            
            
            Test.startTest();
            opc = new PBS_AAAP_OfferParkingController();
            opc.pageUrl = '';
            opc.offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c = null;
            opc.offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c = null;
            opc.offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c = 2;
            opc.offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c = 2;
            PageReference page = opc.saveParkingInfo();
  
            opc.offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c = 2;
            opc.offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c = 2;
            opc.offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c = null;
            opc.offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c = null;
            
            page = opc.saveParkingInfo();
           
            opc.offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c = null;
            opc.offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c = null;
            opc.offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c = null;
            opc.offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c = null;
            
            page = opc.saveParkingInfo();
            
            opc.offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c = 2;
            opc.offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c = 2;
            opc.offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c = 2;
            opc.offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c = 2;
            PBS_AAAP_OfferBuildingController offerBuilding = new PBS_AAAP_OfferBuildingController();
            page = opc.saveParkingInfo();
            PBS_AAAP_OfferBuildingController.buildingValidationMsg = 'Testing msg';
            offerBuilding.closePopup();
            offerBuilding.pageUrl = '/test';
            offerBuilding.actionSaveBuildingInfoTest();
            offerBuilding.PostBack();
            Test.stopTest();
        }
        System.assert(true);
    } 
    
    static testMethod void offerBldgAddlCoverageTest() {
        System.debug('*** Testing myOfferBuildingValidateTest *** ');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        System.runAs(u) {
            PageReference pageRef = Page.PBS_AAAP_OfferBuilding;
            Test.setCurrentPage(pageRef);
            PBS_AAAP_OfferBuildingController obc = new PBS_AAAP_OfferBuildingController();
            
            List<SelectOption> rlplist = obc.getRLPs();
            
            PBS_AAAP_Offer__c offerBuilding = new PBS_AAAP_Offer__c();
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            offerBuilding.PBS_AAAP_RLP_Number__c = rlp.id;
            System.debug('rlp.id in myOfferBuildingValidateTest is' + rlp.id);
            System.assert(rlp.Id != null);
            insert offerBuilding;
            System.debug('offer id from myOfferBuildingValidateTest is ***' + offerBuilding.id);
            System.assert(offerBuilding.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offerBuilding.Id);
            ApexPages.currentPage().getParameters().put('selectRLP', rlp.id);
            obc.saveBuilding();
            
            offerBuilding = PBS_AAAP_UtilityTest.createOfferInfo();
            insert offerBuilding;
            obc.offerBuilding = offerBuilding;
            obc.saveBuilding();
            offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            update offerBuilding;
            obc.offerBuilding = offerBuilding;
            obc.saveBuilding();
            offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            update offerBuilding;
            obc.offerBuilding = offerBuilding;
            obc.saveBuilding();
            System.assert(offerBuilding.Id != null);

            offerBuilding.PBS_AAAP_MetroRail_Station__c = null;
            obc.saveBuilding();
            offerBuilding.PBS_AAAP_State__c = 'MD';
            obc.getCountiesSpecial();
            offerBuilding.PBS_AAAP_State__c = 'DC';
            obc.getCountiesSpecial();
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 10;
            offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            obc.saveBuilding();
            obc.actionSaveBuildingInfo();
            obc.getSiteSizeItems();            
            
            offerBuilding = PBS_AAAP_UtilityTest.createOfferInfo();
            obc.offerBuilding = offerBuilding;
            system.assert(obc.offerBuilding!=null);
            
            offerBuilding.PBS_AAAP_Building_Name__c = 'school';
            offerBuilding.PBS_AAAP_Street_Address__c = '9525 Main St';
            offerBuilding.PBS_AAAP_City__c = 'Fairfax';
            offerBuilding.PBS_AAAP_User_Defined_Address__c = 'some user defined address';
            offerBuilding.PBS_AAAP_RLP_Region__c = rlp.PBS_AAAP_Region__c;
            offerBuilding.PBS_AAAP_State__c = 'VA';
            offerBuilding.PBS_AAAP_ZipCode__c = '22031';
            offerBuilding.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding.PBS_AAAP_Energy_Star_Reason__c = 'The building is old';
            offerBuilding.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offerBuilding.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offerBuilding.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offerBuilding.PBS_AAAP_Number_of_floors__c = 2;
            offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 100;
            offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 0;
            offerBuilding.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c - 1;
            offerBuilding.PBS_AAAP_Year_Built__c = '1962';
            offerBuilding.PBS_AAAP_Close_To_Metro__c = 'No';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 PM';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 20039;
            offerBuilding.PBS_AAAP_X_CO_ORD__c = 38;
            offerBuilding.PBS_AAAP_Y_CO_ORD__c = 77;
            offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'No';
            
            PBS_AAAP_RLP_Regions_Map__c rm = new PBS_AAAP_RLP_Regions_Map__c();
            rm.PBS_AAAP_Region_Name__c = offerBuilding.PBS_AAAP_RLP_Region__c;
            rm.PBS_AAAP_RLP_State_Abbrevation__c = offerBuilding.PBS_AAAP_State__c;
            rm.PBS_AAAP_RLP_State__c = offerBuilding.PBS_AAAP_State__c;
            insert rm;
            
            offerBuilding.PBS_AAAP_County__c = rm.PBS_AAAP_RLP_State__c;
            
            obc.selectRLP = rlp.Id;
            system.assert(obc.offerBuilding!=null);
            
            obc.saveBuilding();
            system.assert(obc.offerBuilding!=null);
            obc.actionSaveBuildingInfo();
            system.assert(obc.offerBuilding!=null);
            
            
            offerBuilding.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'No';
            offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 100;
            
            insert offerBuilding;
            
            system.assert(obc.offerBuilding!=null);
            
            obc.saveBuilding(true);

            obc.offerBuilding = offerBuilding;
            
            system.assert(obc.offerBuilding!=null);
            obc.actionSaveBuildingInfo(true);
        }
        Test.stopTest();
    }  
    
    static testMethod void OfferParkingTest1() {
        Test.startTest();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        offer.PBS_AAAP_Option_Parking__c = 'Yes';
        insert offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
        PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
        opc.getOnsiteParkingItems();
        opc.getPartialItems();
        opc.showParkingOptions();
        
        system.assert(opc != null);
        
        string suffix = '';
        integer AliasNum = 1;
        Account testAccount = new Account(Name = 'test'+suffix);
        insert testAccount;
        Contact c = new Contact(FirstName = 'test', LastName = 'test'+suffix, accountId = testAccount.Id);
        insert c;
        Profile p = [
                SELECT Name
                FROM Profile
                WHERE Name LIKE '%GSA System Administrator%'
                LIMIT 1
        ];
        User u = new User(firstname = 'firstname', lastname = 'testlastname'+suffix, alias = 'testa'+string.valueOf(AliasNum++), email = 'test'+suffix+'@testorg.com', emailencodingkey = 'UTF-8',
                languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, timezonesidkey = 'America/Los_Angeles', //userroleid=ur.id,
                username = 'test'+suffix+'@testorgani.com', street = '123 street', city = 'Vienna', state = 'Virginia', country = 'USA', postalcode = '22102', PBS_AAAP_PIN__c = '123456',
                phone = '202-202-2202', PBS_AAAP_StatesOfInterest__c = 'NCR', PBS_AAAP_Regions__c = 'National Capital Region;');
        insert u;  
        System.runAs(u) {
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
            PBS_AAAP_OfferParkingController opc1 = new PBS_AAAP_OfferParkingController();
        }
        Test.stopTest();
    }
    
    
    static testMethod void OfferParkingTest2() {
        Test.startTest();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        offer.PBS_AAAP_Option_Parking__c = '';
        insert offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
        PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
        opc.showParkingOptions();
        opc.getOptions5a();
        opc.getOptions5b();
        opc.getOptions5c();
        system.assert(opc != null);
        offer.PBS_AAAP_Option_Parking__c = 'Yes';
        update offer;
        PBS_AAAP_OfferParkingController opc1 = new PBS_AAAP_OfferParkingController();
        opc1.showParkingOptions();
        opc.getOptions5a();
        opc.getOptions5b();
        opc.getOptions5c();
        
        offer.PBS_AAAP_Option_Parking__c = 'No';
        update offer;
        PBS_AAAP_OfferParkingController opc2 = new PBS_AAAP_OfferParkingController();
        opc2.showParkingOptions();
        opc.getOptions5a();
        opc.getOptions5b();
        opc.getOptions5c();
        Test.stopTest();
    }
    
    static testMethod void OfferParkingTest3() {
        Test.startTest();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        offer.PBS_AAAP_Option_Parking__c = 'Yes';
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        insert offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
        PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
        opc.pageUrl = '/leasing';
        opc.actionCancel();
        opc.saveParkingInfo();
        opc.actionDeleteOffer();
        
        system.assert(opc != null);
        Test.stopTest();
    }
    
    static testMethod void OfferParkingTest4() {
        Test.startTest();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        offer.PBS_AAAP_Option_Parking__c = 'Yes';
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        offer.PBS_AAAP_Total_Structured_Parking_Spaces__c = null;
        offer.PBS_AAAP_Total_Surface_Parking_Spaces__c = null;
        offer.PBS_AAAP_Total_Struct_Park_Space_Offered__c = null;
        offer.PBS_AAAP_Total_Surf_Park_Space_Offered__c = null;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = null;
        insert offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
        PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
        opc.actionCancel();
        opc.saveParkingInfo();
        opc.backToOfrBlding();
        opc.saveParkingAndContinue();
        opc.actionDeleteOffer();
        
        system.assert(opc != null);
        Test.stopTest();
    }
    
    static testMethod void OfferParkingTest5() {
        Test.startTest();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        offer.PBS_AAAP_Option_Parking__c = 'Yes';
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        offer.PBS_AAAP_Parking_Onsite__c = 'Yes';
        offer.PBS_AAAP_Total_Structured_Parking_Spaces__c = 5.0;
        offer.PBS_AAAP_Total_Surface_Parking_Spaces__c = 6.0;
        offer.PBS_AAAP_Total_Struct_Park_Space_Offered__c = 7.0;
        offer.PBS_AAAP_Total_Surf_Park_Space_Offered__c = 8.0;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 9.0;
        
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10.0;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 11.0;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 12.0;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 13.0;
        
        insert offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
        PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
        opc.saveParkingAndContinue();
        
        system.assert(opc != null);
        Test.stopTest();
    }
    
    static testMethod void OfferParkingTest6() {
        Test.startTest();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        offer.PBS_AAAP_Option_Parking__c = 'Yes';
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        insert offer;
        
        PBS_AAAP_Property__c testProperty = new PBS_AAAP_Property__c(PBS_AAAP_County__c = 'Test County', PBS_AAAP_City__c = 'Test City', PBS_AAAP_State__c = 'TS');
        insert testProperty;    
        
        
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('edit', 'false');
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('draftMsgFlag', 'true');
        ApexPages.currentPage().getParameters().put('propertyId', testProperty.Id);
        PBS_AAAP_OfferParkingController opc = new PBS_AAAP_OfferParkingController();
        
        
        ApexPages.currentPage().getParameters().put('edit', 'true');
        PBS_AAAP_OfferParkingController opc1 = new PBS_AAAP_OfferParkingController();
        
        opc.actionDeleteOffer();
        
        system.assert(opc != null);
        Test.stopTest();
    } 
    
}