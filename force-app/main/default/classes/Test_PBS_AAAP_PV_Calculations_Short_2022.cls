/*
 * 		Name		:	Test_PBS_AAAP_PV_Calculations_Short_2022
 * 		Date		:	21 June 2021
 * 		Author		:	Santhosh Kanthula Jagadeesan 
 * 		Description	:	This class is used to cover PBS_AAAP_PV_Calculations_ShortTerm_2022  
*/
@isTest
public class Test_PBS_AAAP_PV_Calculations_Short_2022 {
	//This method is used to set data in PBS_AAAP_IdentifyWinnerForm (Wrapper Class) 
    static void iwfContainerTest(PBS_AAAP_IdentifyWinnerController iwc) {
        string iwfJson;
        iwc.identifyWinnerForm = null;
        iwfJson = iwc.identifyWinnerFormJson;
        system.assertEquals(null, iwfJson);
        iwc.identifyWinnerForm = new List<PBS_AAAP_IdentifyWinnerForm>();
        PBS_AAAP_IdentifyWinnerForm iwf;
        iwf = new PBS_AAAP_IdentifyWinnerForm();
        iwf.spaceName = 'untitled';
        iwc.identifyWinnerForm.add(iwf);
        iwfJson = iwc.identifyWinnerFormJson;
        system.assertNotEquals(null, iwfJson);
        List<PBS_AAAP_IdentifyWinnerForm> des;
        des = ((PBS_AAAP_IdentifyWinnerController.IwfContainer) JSON.deserialize(iwfJson, PBS_AAAP_IdentifyWinnerController.IwfContainer.class)).winners;
        system.assertEquals(iwc.identifyWinnerForm.size(), des.size());
    }
    //This method is used to create all the required records
    @testSetup
    public static void createData(){
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        rlp.PBS_AAAP_Year__c = '2022';
        rlp.PBS_AAAP_Region__c = '10/5 Term - All Region';
        rlp.PBS_AAAP_Discount_percent_Rate__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50;
        insert rlp;
        
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 200;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 22;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 23;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 21;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 20;        
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 12.00;
		space.PBS_AAAP_ARCH_ENG_FEES__c = 0.11;
        space.PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c = 5.00;
        //space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = 'TEST';
        space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '%';
        insert space;
		
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRate();
        rate0.PBS_AAAP_LEASE_TERM__c = '10 years,5 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 12;
        rate0.PBS_AAAP_BASE_RATE__c = 14;
        rate0.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 9.00;
        rate0.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 20.00;
        rate0.PBS_AAAP_BSAC_RATE__c = 9.00;
        rate0.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 59;
        insert rate0;
        
        PBS_AAAP_Other_Costs__c ocost = PBS_AAAP_UtilityTest.createOtherCosts();
        ocost.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocost;

        PBS_AAAP_RLP_Regions_Map__c rlpReg = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg.PBS_AAAP_RLP_State__c = 'District Of Columbia';
        rlpReg.PBS_AAAP_RLP_State_Abbrevation__c = 'DC';
        rlpReg.PBS_AAAP_Region_Name__c = 'National Capital Region';
        insert rlpReg;
        
        PBS_AAAP_RLP_Regions_Map__c rlpReg1 = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg1.PBS_AAAP_RLP_State__c = 'Virginia';
        rlpReg1.PBS_AAAP_RLP_State_Abbrevation__c = 'VA';
        rlpReg1.PBS_AAAP_Region_Name__c = 'National Capital Region';
        insert rlpReg1;

        PBS_AAAP_AlternateDelineatedArea__c altD = new PBS_AAAP_AlternateDelineatedArea__c();
        altD.DilneatedAreaType__c = 'City';
        altD.State__c = 'VA';
        altD.Value__c = 'Herndon';
        insert altD;
        
        PBS_AAAP_AlternateDelineatedArea__c altD1 = new PBS_AAAP_AlternateDelineatedArea__c();
        altD1.DilneatedAreaType__c = 'Congressional District';
        altD1.State__c = 'DC';
        altD1.Value__c = 'DC01';
        insert altD1;
        
        PBS_AAAP_AlternateDelineatedArea__c altD11 = new PBS_AAAP_AlternateDelineatedArea__c();
        altD11.DilneatedAreaType__c = 'Congressional District';
        altD11.State__c = 'VA';
        altD11.Value__c = 'DC01';
        insert altD11;

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agency.PBS_AAAP_USF_REQ_MIN__c = 6000;
        agency.PBS_AAAP_USF_REQ_MAX__c = 6600;     
        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 25;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 33;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 21;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 10.52;
        agency.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 1;
        agency.PBS_AAAP_MOVE_DEFAULT__c = 2;
        agency.PBS_AAAP_TELCOMM_DEFAULT__c = 1.20;
        agency.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 31;
        agency.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 31;
        agency.PBS_AAAP_BSAC_per_ABOA__c = 22;
        agency.BSAC_for_Continuing_Space_per_ABOA_SF__c = 22;
        //agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = 'TEST';
        insert agency;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Agency_Requirement__c = agency.Id, PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'User Defined',
                PBS_AAAP_Shape_Type__c = 'Polygon');
        insert polyObj;

        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;
        insert polyPath;
    }
    //This method is used to do testing for "10 years,5 firm" lease term with 2022 year
    @isTest
	static void shortPVCalculationsFor2022Year() {
        PBS_AAAP_Agency_Requirement__c agency = [Select Id From PBS_AAAP_Agency_Requirement__c limit 1];
        PBS_AAAP_Offer__c offer  = [Select Id From PBS_AAAP_Offer__c limit 1];
        PBS_AAAP_Space__c space   = [Select Id From PBS_AAAP_Space__c limit 1];
        
        agency.PBS_AAAP_LEASE_TERM__c = '10 years,5 firm';
        agency.PBS_AAAP_Region__c = '10/5 Term - All Regions';
        update agency;
       
        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        iwc.getDelineatedAreaTypeDescList();
        
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); 
        iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        system.assert(iwc.identifyWinnerForm.size() > 0);
        system.assertEquals(10.63, Decimal.valueOf(iwc.identifyWinnerForm[0].pvCosts).setScale(2));
        
    }
}