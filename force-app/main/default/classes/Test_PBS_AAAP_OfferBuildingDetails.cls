@IsTest
public class Test_PBS_AAAP_OfferBuildingDetails {

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
            PBS_AAAP_OfferBuildingDetailsController obc = new PBS_AAAP_OfferBuildingDetailsController();
            List<SelectOption> items = obc.getItems();
            List<SelectOption> partialitems = obc.getPartialItems();
     //SGanti added 7/26/2021 
        	List<SelectOption> FireLifeMeetsItems = obc.getFireLifeMeetsItems();
            List<SelectOption> FloodPlainsItems = obc.getFloodPlainsItems(); 
            List<SelectOption> AccessibilityItems = obc.getAccessibilityItems();
 //SGanti added 08/2021
                        
   			List<SelectOption> SeismicSafetyItems = obc.getSeismicSafetyItems();


            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert rlp;
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            obc = new PBS_AAAP_OfferBuildingDetailsController();
            offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
            offer.PBS_AAAP_RLP_Number__c = rlp.id;
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            obc = new PBS_AAAP_OfferBuildingDetailsController();
            offer = PBS_AAAP_UtilityTest.createOfferInfo();
        
            insert offer;
            
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', oOther.id);
            obc = new PBS_AAAP_OfferBuildingDetailsController();
      
    //SGanti added 7/26/2021
            ApexPages.StandardController stdCtrlTest = new ApexPages.StandardController(offer);
    		PBS_AAAP_OfferBuildingDetailsController scTest = new PBS_AAAP_OfferBuildingDetailsController(stdCtrlTest);
           
            Test.stopTest();
        }

    }
    static testMethod void myOfferBuildingTest() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        //PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        //insert rlp;
        System.runAs(u) {
            PBS_AAAP_OfferBuildingDetailsController obc = new PBS_AAAP_OfferBuildingDetailsController();
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
     //SGanti added 7/26/2021
            ApexPages.StandardController stdCtrlTest1 = new ApexPages.StandardController(offerBuilding1);
    		PBS_AAAP_OfferBuildingDetailsController scTest1 = new PBS_AAAP_OfferBuildingDetailsController(stdCtrlTest1);  
          
            offerBuilding1.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding1.PBS_AAAP_Energy_Star_Reason__c = null;
            offerBuilding1.PBS_AAAP_Building_Sprinklered__c = null;
            offerBuilding1.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = null;
            offerBuilding1.PBS_AAAP_BLDG_Wide_Alarm_System__c = null;
            offerBuilding1.PBS_AAAP_Close_To_Metro__c = null;
            offerBuilding1.PBS_AAAP_Energy_Star__c = null;
            //offerBuilding1.PBS_AAAP_Asbestos__c = 'Undamaged_nonfriable;thermal;ACM_other;ACM_abatement';
            //offerBuilding1.PBS_AAAP_CERTIFICATION_DATE__c = null;

            try {
                obc.saveBuilding();
            } catch (Exception ex) {
                System.debug(ex.getMessage());
            }
            offerBuilding1.PBS_AAAP_Energy_Star__c = 'Yes';
            offerBuilding1.PBS_AAAP_CERTIFICATION_DATE__c = null;
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
            offerBuilding2.PBS_AAAP_Reconstruction__c = 'Yes';
            offerBuilding2.PBS_AAAP_HubZone_SBC__c = 'Yes';
            offerBuilding2.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'Yes';
//SGanti added 08/2021

 			offerBuilding2.PBS_AAAP_Seismic_Statement__c = 'Yes';
            
            
            obc.offerBuilding = offerBuilding2;
            obc.displayEnergyStarText();
            //obc.getCensusCheck();
            obc.displayMetroStation();
            obc.getMetroStation();
         	 obc.getPartialItems();
            obc.getItems();
       //SGanti added 7/26/2021
         	obc.getFireLifeMeetsItems();
            obc.getFloodPlainsItems();
            obc.getAccessibilityItems();
            obc.getAsbestosItems = new List<String>{'Undamaged_nonfriable','thermal','ACM_abatement'};
            List<SelectOption> testAsbestos = obc.getAsbestos;
            List<String> testAsbestosItems = obc.getAsbestosItems;
 //SGanti added 08/2021
  
			obc.getSeismicSafetyItems();
   
            
            obc.getStairwellItems();
            obc.displayBuildingTypeCodeyear();
            obc.getBuildingLocated();
            obc.displayreconstructionAcknowledgement();
            obc.getreconstructionAcknowledgement();
            obc.displayhzone();
            obc.gethzone(); 
            obc.saveBuilding();
            obc.actionCancel();
            
            offerBuilding2.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding2.PBS_AAAP_Energy_Star_Reason__c = 'No';
            offerBuilding2.PBS_AAAP_Close_To_Metro__c = 'No';
            offerBuilding2.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Other';
            offerBuilding2.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Other';
            offerBuilding2.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Other';
            offerBuilding2.PBS_AAAP_HubZone_SBC__c = 'Yes';
            offerBuilding2.PBS_AAAP_Reconstruction__c = 'Yes';
            offerBuilding2.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'Yes';

            obc.offerBuilding = offerBuilding2;
            obc.getShowEnergyStar();
            obc.displayEnergyStarText();
            obc.displayMetroStation();
            obc.getMetroStation();
            obc.saveBuilding();
            obc.backToOfrBlding();


            offerBuilding2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            obc.offerBuilding = offerBuilding2;
            obc.actionSaveBuildingInfo();
            offerBuilding2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            obc.offerBuilding = offerBuilding2;
            obc.actionSaveBuildingInfo();

            //added by syam on 10/10/2016 
            offerBuilding2.PBS_AAAP_State__c = 'DC';
            obc.offerBuilding = offerBuilding2;

            //obc.refreshPanel();

        }
        Test.stopTest();
    }


    static testMethod void myOfferBuildingValidateTest() {
        System.debug('*** Testing myOfferBuildingValidateTest *** ');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        //PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        //insert rlp;
        System.runAs(u) {
            PageReference pageRef = Page.PBS_AAAP_OfferBuildingDetails;
            Test.setCurrentPage(pageRef);
            PBS_AAAP_OfferBuildingDetailsController obc = new PBS_AAAP_OfferBuildingDetailsController();
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
            //ApexPages.currentPage().getParameters().put('selectRLP', rlp.id);
            //obc.saveBuilding();
            System.debug('after first save in myOfferBuildingValidateTest****');

            offerBuilding = PBS_AAAP_UtilityTest.createOfferInfo();
            insert offerBuilding;
            obc.offerBuilding = offerBuilding;
            //obc.saveBuilding();
            offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            update offerBuilding;
            obc.offerBuilding = offerBuilding;
            //obc.saveBuilding();
            offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            update offerBuilding;
            obc.offerBuilding = offerBuilding;
            obc.saveBuilding();
            System.assert(offerBuilding.Id != null);

            //added by syam 

            offerBuilding.PBS_AAAP_MetroRail_Station__c = null;
            obc.saveBuilding();
            
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 10;
            offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            obc.saveBuilding();
            obc.actionSaveBuildingInfo();
            
            offerBuilding = PBS_AAAP_UtilityTest.createOfferInfo();
            obc.offerBuilding = offerBuilding;
            system.assert(obc.offerBuilding!=null);

            offerBuilding.PBS_AAAP_Building_Name__c = 'school';
            offerBuilding.PBS_AAAP_Street_Address__c = '9525 Main St';//, Fairfax, VA 22031'
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
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '1:00 AM';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '2:00 AM';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 20039;
            offerBuilding.PBS_AAAP_X_CO_ORD__c = 38;
            offerBuilding.PBS_AAAP_Y_CO_ORD__c = 77;
            offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'No';


            system.assert(obc.offerBuilding!=null);

            obc.saveBuilding();
            system.assert(obc.offerBuilding!=null);
            obc.actionSaveBuildingInfo();
            system.assert(obc.offerBuilding!=null);


            offerBuilding.PBS_AAAP_Energy_Star__c = 'No';
            offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'No';
            offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 100;
            offerBuilding.PBS_AAAP_HubZone_SBC__c = 'No';
            //offerBuilding.PBS_AAAP_Energy_Star__c = 'Yes';

            insert offerBuilding;
            
            system.assert(obc.offerBuilding!=null);
            
            obc.saveBuilding(true);
            obc.offerBuilding = offerBuilding;

            system.assert(obc.offerBuilding!=null);
            obc.actionSaveBuildingInfo(true);
            obc.actionDeleteOffer();
        }
        Test.stopTest();
    }

    static testMethod void myOfferBuildingValidateTest1() {
        System.debug('*** Testing myOfferBuildingValidateTest *** ');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Test.startTest();
        
        System.runAs(u) {
            PageReference pageRef = Page.PBS_AAAP_OfferBuildingDetails;
            Test.setCurrentPage(pageRef);
            PBS_AAAP_OfferBuildingDetailsController obc = new PBS_AAAP_OfferBuildingDetailsController();
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
            System.debug('after first save in myOfferBuildingValidateTest****');

            offerBuilding = PBS_AAAP_UtilityTest.createOfferInfo();
            insert offerBuilding;
            obc.offerBuilding = offerBuilding;
            //obc.saveBuilding();
            offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            update offerBuilding;
            obc.offerBuilding = offerBuilding;
            //obc.saveBuilding();
            offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            update offerBuilding;
            obc.offerBuilding = offerBuilding;
            obc.saveBuilding();
            System.assert(offerBuilding.Id != null);

            //added by syam 

            offerBuilding.PBS_AAAP_MetroRail_Station__c = null;
            obc.saveBuilding();
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 10;
            offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            obc.saveBuilding();
            obc.actionSaveBuildingInfo();
            //obc.getSiteSizeItems();


            offerBuilding = PBS_AAAP_UtilityTest.createOfferInfo();
            obc.offerBuilding = offerBuilding;
            system.assert(obc.offerBuilding!=null);

            offerBuilding.PBS_AAAP_Building_Name__c = 'school';
            offerBuilding.PBS_AAAP_Street_Address__c = '9525 Main St';//, Fairfax, VA 22031'
            offerBuilding.PBS_AAAP_City__c = 'Fairfax';
            offerBuilding.PBS_AAAP_RLP_Region__c = rlp.PBS_AAAP_Region__c;
            offerBuilding.PBS_AAAP_State__c = 'VA';
            offerBuilding.PBS_AAAP_ZipCode__c = '22031';
            offerBuilding.PBS_AAAP_Energy_Star__c = 'Yes';
            offerBuilding.PBS_AAAP_Energy_Star_Reason__c = 'The building is old';
            //offerBuilding.
            offerBuilding.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offerBuilding.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offerBuilding.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offerBuilding.PBS_AAAP_Number_of_floors__c = 2;
            offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 100;
            offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 50;
            offerBuilding.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c - 1;
            offerBuilding.PBS_AAAP_Year_Built__c = '1962';
            offerBuilding.PBS_AAAP_Close_To_Metro__c = 'No';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '1:00 AM';
            offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '2:00 AM';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 20039;
            offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            offerBuilding.PBS_AAAP_HubZone_SBC__c = 'No';
            offerBuilding.PBS_AAAP_X_CO_ORD__c = 38;
            offerBuilding.PBS_AAAP_Y_CO_ORD__c = 77;
            offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'Yes';

            
            system.assert(obc.offerBuilding!=null);

            obc.saveBuilding(true);
            system.assert(obc.offerBuilding!=null);
            obc.actionSaveBuildingInfo(true);
            system.assert(obc.offerBuilding!=null);

            insert offerBuilding;
            
            system.assert(obc.offerBuilding!=null);
            
            obc.saveBuilding(true);
            obc.offerBuilding = offerBuilding;

            system.assert(obc.offerBuilding!=null);
            obc.actionSaveBuildingInfo(true);
            obc.actionDeleteOffer();
        }
        Test.stopTest();
    }


}