@isTest
public class Test_PBS_LOP_BuildingController {
    @isTest
    private static void testMethodWithOfferId(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');
            
        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = false;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)';
            offernew.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
            insert offernew;
            
            PBS_LOP_BuildingController objOld = new PBS_LOP_BuildingController();
            objOld.hisString = 'Historic property within a historic district';
            objOld.hubZoneStr = 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference.';
            objOld.saveBuilding();
            
            PBS_LOP_BuildingController objOld1 = new PBS_LOP_BuildingController();
            objOld1.hisString = 'Non-historic property or underdeveloped site within a historic district';
            objOld1.hubZoneStr = 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.';
            objOld1.saveBuilding();
            
            PBS_LOP_BuildingController objOld2 = new PBS_LOP_BuildingController();
            objOld2.hisString = 'Historic properties outside of historic district';
            objOld2.hubZoneStr = 'I am not a HUBZone SBC Offeror. This question does not apply to me';
            objOld2.saveBuilding();
            
            objOld2.hubZoneStr = 'I am not a HUBZone small business concern offeror.';
            objOld2.saveBuilding();
            
            objOld2.hubZoneStr = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
            objOld2.saveBuilding();
            
            
            PBS_LOP_BuildingController objOld3 = new PBS_LOP_BuildingController();
            objOld3.hisString = 'Non-historic property';
            objOld3.saveBuilding();

                                   
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_BuildingController obj = new PBS_LOP_BuildingController();
            obj.saveBuilding();
            obj.redirectToParking(); 
            
            obj.hisString = 'Historic properties outside of historic district';
            obj.saveBuilding();
            
            obj.hisString = 'Non-historic property';
            obj.saveBuilding();
            
            obj.hubZoneStr = 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference';
            obj.saveBuilding();
            
            obj.hubZoneStr = 'I am a HUBZone SBC Offeror and do not waive the price evaluation preference';
            obj.saveBuilding();
            
            obj.hubZoneStr = 'I am not a HUBZone SBC Offeror. This question does not apply to me';
            obj.saveBuilding();
            
            
            PBS_AAAP_RLP__c rlp1 = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp1.PBS_RSAP_Solicitation_Number__c = '123';
            rlp1.PBS_RSAP_Solicitation_Status__c = true;
            rlp1.PBS_AAAP_Region__c = 'test region';
            insert rlp1;
            System.assertNotEquals(rlp1.Id, null, 'This should not equals');
            PBS_AAAP_Offer__c offernew1 = new PBS_AAAP_Offer__c();
            offernew1.PBS_AAAP_RLP_Number__c = rlp1.id;
            offernew1.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew1.RecordTypeId = RSAPRecTypeId;
            offernew1.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew1.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew1.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)';
            offernew1.PBS_RSAP_Historical_Property_Description__c = 'Non-historic property or underdeveloped site within a historic district';
            offernew1.PBS_RSAP_HubZone_Waiver__c = 'I am not a HUBZone small business concern offeror.';
            offernew1.PBS_AAAP_Energy_Star__c = 'No';
      
            insert offernew1;    

            ApexPages.currentPage().getParameters().put('offerId',offernew1.Id);
            ApexPages.currentPage().getParameters().put('edit','false');
            
            PBS_LOP_BuildingController obj1 = new PBS_LOP_BuildingController();
    
            List<SelectOption> FireLifeMeetsItems = obj1.getFireProtectionItems();
            List<SelectOption> FloodPlainsItems = obj1.getFloodPlainItems(); 
            List<SelectOption> AccessibilityItems = obj1.getAccessibilityItems();                     
            List<SelectOption> SeismicSafetyItems = obj1.getSeismicOptions();
            
            List<SelectOption> EnergyStarResponseNo = obj1.getEnergyStarResponseNo();
            List<SelectOption> EnergyStarMeetsExceptions = obj1.getEnergyStarMeetsExceptions();
            List<SelectOption> EnergyStarCost = obj1.getEnergyStarCost();

            obj1.updateOfferDetails();
            obj1.saveBuilding(); 
            
            obj1.hubZoneStr = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
            obj1.saveBuilding(); 
            
            obj1.hubZoneStr = 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.';
            obj1.saveBuilding(); 
            
            obj1.lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            obj1.lopOffer.PBS_AAAP_Energy_Star__c = 'No';
            obj1.saveBuilding();
            
            obj1.redirectToParking(); 
            obj1.getSeismicSafetyItems();
            obj1.back();
            obj1.getEnergyStarResponseNo();
            obj1.getEnergyStarMeetsExceptions();
            obj1.getEnergyStarCost();
            
            obj1.getStates();
            obj1.getItems();
            obj1.getItems2();
            obj1.getSiteSizeItems();
            obj1.getSeismicOptions();
            obj1.getSeismicItems();
            obj1.getFloodPlainItems();
            obj1.getFireProtectionItems();
            obj1.getAccessibilityItems();
            obj1.getHubZoneItems();
            obj1.getAsbestosItems = new List<String>{'Undamaged_nonfriable','thermal','ACM_abatement'};
            List<SelectOption> testAsbestos = obj1.getAsbestos;
            List<String> testAsbestosItems = obj1.getAsbestosItems;
            
            PBS_AAAP_Offer__c offernew2 = new PBS_AAAP_Offer__c();
            offernew2.PBS_AAAP_RLP_Number__c = rlp1.id;
            offernew2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew2.RecordTypeId = RSAPRecTypeId;
            offernew2.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew2.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew2.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)';
            offernew2.PBS_RSAP_Historical_Property_Description__c = 'Historic properties outside of historic district';
            offernew2.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
            insert offernew2;
            ApexPages.currentPage().getParameters().put('offerId',offernew2.Id);
            PBS_LOP_BuildingController obj2 = new PBS_LOP_BuildingController();
            
            PBS_AAAP_Offer__c offernew3 = new PBS_AAAP_Offer__c();
            offernew3.PBS_AAAP_RLP_Number__c = rlp1.id;
            offernew3.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew3.RecordTypeId = RSAPRecTypeId;
            offernew3.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew3.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew3.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)';
            offernew3.PBS_RSAP_Historical_Property_Description__c = 'Non-historic property';
            offernew3.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.';
            insert offernew3;
            ApexPages.currentPage().getParameters().put('offerId',offernew3.Id);
            PBS_LOP_BuildingController obj3 = new PBS_LOP_BuildingController();
            
            offernew1.PBS_AAAP_Building_Name__c = 'Test';
            offernew1.PBS_AAAP_Street_Address__c = 'Test';
            offernew1.PBS_AAAP_City__c = 'Test';
            offernew1.PBS_AAAP_State__c = 'Test';
            offernew1.PBS_AAAP_ZipCode__c = 'Test';
            offernew1.PBS_AAAP_Energy_Star__c = 'Yes';
            offernew1.PBS_AAAP_CERTIFICATION_DATE__c = system.today();
            offernew1.PBS_AAAP_floors_Suites_in_Offered_Space__c = 3;
            offernew1.PBS_RSAP_Year_Built__c = '33';
            offernew1.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 33;
            offernew1.PBS_AAAP_OFFICE_SPACE_RSF__c = 33;
            offernew1.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '5:00 AM';
            offernew1.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '6:00 AM';
            offernew1.PBS_RSAP_Accessibility_Standards_Met__c = 'yes';
            offernew1.PBS_RSAP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix';
            offernew1.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'no';
            offernew1.PBS_RSAP_Flood_Plain_Declaration__c = 'Not in a flood plain';
            offernew1.PBS_AAAP_FIRE_SAFETY_CERT__c = 'yes';
            obj1.lopOffer = offernew1;
            obj1.redirectToParking();
            
            obj1.lopOffer = new PBS_AAAP_Offer__c();
            obj1.updateOfferDetails();
            PBS_AAAP_Offer__c offernew4 = new PBS_AAAP_Offer__c();
            offernew4.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew4.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew4.RecordTypeId = RSAPRecTypeId;
            offernew4.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew4.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew4.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)';
            offernew4.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
            offernew4.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Meets';
            offernew4.PBS_RSAP_Accessibility_Standards_Met__c = 'Will meet';
            offernew4.PBS_AAAP_Asbestos__c = 'None'; 
            offernew4.PBS_RSAP_Flood_Plain_Declaration__c = 'Not in a flood plain'; 
            offernew4.PBS_AAAP_Seismic_Statement__c = 'Will meet';
            offernew4.PBS_AAAP_BUILDING_TYPE__c = 'Unknown/Not Listed';
            offernew4.PBS_AAAP_BUILDING_CODE__c = 'Unknown/Not Listed'; 
            offernew4.PBS_AAAP_BUILDING_CODE_YEAR__c = '2023';
            offernew4.PBS_AAAP_Energy_Star__c = 'No';
            offernew4.PBS_RSAP_Building_is_a_historic_property__c = 'Yes';
            offernew4.PBS_RSAP_Bldg_within_a_historic_district__c = 'Yes';
            offernew4.PBS_RSAP_HubZone_Waiver__c = 'I am not a HUBZone small business concern offeror.';
            offernew4.PBS_AAAP_Approximate_Construction_Level__c ='New Construction';
            offernew4.PBS_AAAP_Total_Land_Cost__c = 1000;
            offernew4.PBS_RSAP_Energy_Star_Response_No__c = 'Insufficient Occupancy';
            insert offernew4;
            
            obj1.lopOffer = offernew4;
           	obj1.redirectToParking();
            obj1.saveBuilding();
            
        
            
        }
        PBS_LOP_BuildingController obj1 = new PBS_LOP_BuildingController();
    }
    
//SGanti added 11/2021
    static testMethod void myOfferBuildingValidateTest1() {
            
            Account testAccount = new Account(Name = 'testAccount');
            insert testAccount;
            Contact c = new Contact(FirstName = 'test', LastName = 'test', accountId = testAccount.Id, phone = '202-202-2202');
            insert c;
    
			User u = PBS_AAAP_UtilityTest.createPortalUser();
            u.contactId = c.Id;
            System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = false;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew0 = new PBS_AAAP_Offer__c();
            
            offernew0.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew0.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew0.RecordTypeId = RSAPRecTypeId;
            offernew0.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew0.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew0.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)';
            offernew0.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
            offernew0.PBS_RSAP_HubZone_Waiver__c = 'I am not a HUBZone small business concern offeror.';
            offernew0.PBS_AAAP_Energy_Star__c = 'Yes';
            offernew0.PBS_AAAP_CERTIFICATION_DATE__c = NULL;
            offernew0.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'yes';
            offernew0.PBS_RSAP_Offeror_Seismic_Declaration__c = '';
                      
            insert offernew0;
            
                                      
            ApexPages.currentPage().getParameters().put('offerId',offernew0.Id);
            ApexPages.currentPage().getParameters().put('edit','true');
                        
            PBS_LOP_BuildingController obj0 = new PBS_LOP_BuildingController();
            obj0.lopOffer = offernew0;
            obj0.saveBuilding();
            obj0.redirectToParking();            
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)';
            offernew.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
            offernew.PBS_RSAP_HubZone_Waiver__c = 'I am not a HUBZone small business concern offeror.';
            offernew.PBS_AAAP_Energy_Star__c = 'No';
            offernew.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'yes';
            offernew.PBS_RSAP_Offeror_Seismic_Declaration__c = '';
            offernew.PBS_RSAP_Energy_Star_Response_No__c = 'Insufficient Occupancy';
            offernew.PBS_RSAP_Energy_Star_Meets_Exceptions__c = null;
            offernew.PBS_RSAP_Energy_Star_Cost_Effective__c = null;
            
            insert offernew;
            
                                      
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            ApexPages.currentPage().getParameters().put('edit','true');
                        
            PBS_LOP_BuildingController obj1 = new PBS_LOP_BuildingController();
            obj1.lopOffer = offernew;
            obj1.saveBuilding();
            obj1.redirectToParking(); 
            obj1.lopOffer.PBS_AAAP_Energy_Star__c = 'No';
            obj1.lopOffer.PBS_RSAP_Energy_Star_Response_No__c = 'Insufficient Occupancy';
            obj1.saveBuilding();
            obj1.lopOffer.PBS_AAAP_Energy_Star__c = 'Yes';
            obj1.saveBuilding();
            obj1.lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c = 'No';
            obj1.saveBuilding();
            obj1.hubZoneStr = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
            obj1.saveBuilding();
            obj1.lopOffer.PBS_RSAP_Energy_Star_Meets_Exceptions__c = NULL;
            
            List<SelectOption> FireLifeMeetsItems = obj1.getFireProtectionItems();
            List<SelectOption> FloodPlainsItems = obj1.getFloodPlainItems(); 
            List<SelectOption> AccessibilityItems = obj1.getAccessibilityItems();                     
            List<SelectOption> SeismicSafetyItems = obj1.getSeismicOptions();
            
            List<SelectOption> EnergyStarResponseNo = obj1.getEnergyStarResponseNo();
            List<SelectOption> EnergyStarMeetsExceptions = obj1.getEnergyStarMeetsExceptions();
            List<SelectOption> EnergyStarCost = obj1.getEnergyStarCost();
            update offernew;
            obj1.saveBuilding();
            
            obj1.lopOffer.PBS_AAAP_Energy_Star__c = 'No';
            obj1.lopOffer.PBS_RSAP_Energy_Star_Response_No__c = 'New construction';
            obj1.saveBuilding();
            
            obj1.updateOfferDetails();
            obj1.redirectToParking();
            
            obj1.lopOffer = new PBS_AAAP_Offer__c();
            offernew.PBS_RSAP_Energy_Star_Meets_Exceptions__c = null;
            obj1.saveBuilding();
            obj1.updateOfferDetails();
           
        	obj1.areaTypeAction();
            obj1.aslToggleAction();
            obj1.getConstructionLevelItems();
            obj1.actionDeleteOffer();
            obj1.pageURL = 'test.com';
            System.assertEquals('test.com', obj1.pageURL, 'This should be equalts');
    } 
        
  }  
    
}