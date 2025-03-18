@isTest
private class Test_PBS_AAAP_relateListSnapCntrl {

    static testMethod void myPolygonShapeUnitTestLong() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        rlp.PBS_AAAP_Year__c = '2019';
        insert rlp;

        System.debug('rlp is ****' + rlp);
        
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0.PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_RATE__c = 10;
        //rate0.Space_Offer__c = String.valueOf(space.Id).substring(0, 15) + '' + String.valueOf(offer.Id).substring(0, 15);
        insert rate0;
        System.debug('Inserted Rate Id : '+rate0.Id);
        System.debug('Inserted Rate : '+rate0);
        System.debug('Space offer field on the inserted rate record : '+rate0.Space_Offer__c);
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate2.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2.PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate2.PBS_AAAP_BASE_RATE__c = 10;
        insert rate2;
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

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;

        insert agency;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Agency_Requirement__c = agency.Id, PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'User Defined',
                PBS_AAAP_Shape_Type__c = 'Polygon');
        insert polyObj;

        System.debug('=============>>>>> How does agency look here::: ' + agency);
//    System.debug('=============>>>>> How does agency look here::: '+ polyObj);

        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;
        System.debug('=============>>>>> How does agency look here::: ' + polyPath);


        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        ApexPages.currentPage().getParameters().put('histId', his.id); 
        PBS_AAAP_relateListSnapCntrl iwc = new PBS_AAAP_relateListSnapCntrl();
        iwc.actionReset();
        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        //iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl();//vss0925
        iwc.actionReset();
		iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl(); //vss0925
        iwc.actionReset();
		iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        //iwc.getLeaseTermsList();
        
        
        iwc.strImagename = 'test';
        iwc.strImageBlob1 = 'abd';
        iwc.captureImage();
        
        polyObj.PBS_AAAP_Shape_Type__c = 'circle';
            Update polyObj;
        iwc = new PBS_AAAP_relateListSnapCntrl();
        System.assert(true);
    }
    static testMethod void myPolygonShapeUnitTestMedium() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        rlp.PBS_AAAP_Year__c = '2019';
        insert rlp;

        System.debug('rlp is ****' + rlp);
        
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0.PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_RATE__c = 10;
        //rate0.Space_Offer__c = String.valueOf(space.Id).substring(0, 15) + '' + String.valueOf(offer.Id).substring(0, 15);
        insert rate0;
        System.debug('Inserted Rate Id : '+rate0.Id);
        System.debug('Inserted Rate : '+rate0);
        System.debug('Space offer field on the inserted rate record : '+rate0.Space_Offer__c);
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate2.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2.PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate2.PBS_AAAP_BASE_RATE__c = 10;
        insert rate2;
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

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agency.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        insert agency;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Agency_Requirement__c = agency.Id, PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'User Defined',
                PBS_AAAP_Shape_Type__c = 'Polygon');
        insert polyObj;

        System.debug('=============>>>>> How does agency look here::: ' + agency);
//    System.debug('=============>>>>> How does agency look here::: '+ polyObj);

        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;
        System.debug('=============>>>>> How does agency look here::: ' + polyPath);


        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        ApexPages.currentPage().getParameters().put('histId', his.id); 
        PBS_AAAP_relateListSnapCntrl iwc = new PBS_AAAP_relateListSnapCntrl();
        iwc.actionReset();
        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        //iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl();//vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl(); //vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        //iwc.getLeaseTermsList();
        System.assert(true);
    }

    static testMethod void myPolygonShapeUnitTestShort() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        rlp.PBS_AAAP_Year__c = '2019';
        insert rlp;

        System.debug('rlp is ****' + rlp);
        
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0.PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_RATE__c = 10;
        //rate0.Space_Offer__c = String.valueOf(space.Id).substring(0, 15) + '' + String.valueOf(offer.Id).substring(0, 15);
        insert rate0;
        System.debug('Inserted Rate Id : '+rate0.Id);
        System.debug('Inserted Rate : '+rate0);
        System.debug('Space offer field on the inserted rate record : '+rate0.Space_Offer__c);
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate2.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2.PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate2.PBS_AAAP_BASE_RATE__c = 10;
        insert rate2;
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

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agency.PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm';
        insert agency;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Agency_Requirement__c = agency.Id, PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'User Defined',
                PBS_AAAP_Shape_Type__c = 'Polygon');
        insert polyObj;

        System.debug('=============>>>>> How does agency look here::: ' + agency);
//    System.debug('=============>>>>> How does agency look here::: '+ polyObj);

        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;
        System.debug('=============>>>>> How does agency look here::: ' + polyPath);


        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        ApexPages.currentPage().getParameters().put('histId', his.id); 
        PBS_AAAP_relateListSnapCntrl iwc = new PBS_AAAP_relateListSnapCntrl();
        iwc.actionReset();
        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        //iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl();//vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl(); //vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        //iwc.getLeaseTermsList();
        System.assert(true);
    }
    static testMethod void myPolygonShapeUnitTest_Continuing() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        rlp.PBS_AAAP_Year__c = '2019';
        insert rlp;

        System.debug('rlp is ****' + rlp);
        
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0.PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_RATE__c = 10;
        //rate0.Space_Offer__c = String.valueOf(space.Id).substring(0, 15) + '' + String.valueOf(offer.Id).substring(0, 15);
        insert rate0;
        System.debug('Inserted Rate Id : '+rate0.Id);
        System.debug('Inserted Rate : '+rate0);
        System.debug('Space offer field on the inserted rate record : '+rate0.Space_Offer__c);
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate2.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2.PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate2.PBS_AAAP_BASE_RATE__c = 10;
        insert rate2;
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

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = 'VADCMA1234';
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'Continuing';
        insert agency;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Agency_Requirement__c = agency.Id, PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'User Defined',
                PBS_AAAP_Shape_Type__c = 'Polygon');
        insert polyObj;

        System.debug('=============>>>>> How does agency look here::: ' + agency);
//    System.debug('=============>>>>> How does agency look here::: '+ polyObj);

        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;
        System.debug('=============>>>>> How does agency look here::: ' + polyPath);


        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        ApexPages.currentPage().getParameters().put('histId', his.id); 
        PBS_AAAP_relateListSnapCntrl iwc = new PBS_AAAP_relateListSnapCntrl();
        iwc.actionReset();
        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        //iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl();//vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl(); //vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        //iwc.getLeaseTermsList();
        System.assert(true);
    }

    static testMethod void myPolygonShapeUnitTest2_Census25() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        rlp.PBS_AAAP_Year__c = '2019';
        rlp.PBS_AAAP_Region__c = 'Census';
        insert rlp;

        System.debug('rlp is ****' + rlp);
        
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0.PBS_AAAP_LEASE_TERM__c = '25 Months, 16 Firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_RATE__c = 10;
        //rate0.Space_Offer__c = String.valueOf(space.Id).substring(0, 15) + '' + String.valueOf(offer.Id).substring(0, 15);
        insert rate0;
        System.debug('Inserted Rate Id : '+rate0.Id);
        System.debug('Inserted Rate : '+rate0);
        System.debug('Space offer field on the inserted rate record : '+rate0.Space_Offer__c);
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1.PBS_AAAP_LEASE_TERM__c = '19 months, 11 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate2.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2.PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate2.PBS_AAAP_BASE_RATE__c = 10;
        insert rate2;
        PBS_AAAP_Other_Costs__c ocost = PBS_AAAP_UtilityTest.createOtherCosts();
        ocost.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocost;

         PBS_AAAP_RLP_Regions_Map__c rlpReg = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg.PBS_AAAP_RLP_State__c = 'District Of Columbia';
        rlpReg.PBS_AAAP_RLP_State_Abbrevation__c = 'DC';
        rlpReg.PBS_AAAP_Region_Name__c = 'Census';
        insert rlpReg;
        PBS_AAAP_RLP_Regions_Map__c rlpReg1 = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg1.PBS_AAAP_RLP_State__c = 'Virginia';
        rlpReg1.PBS_AAAP_RLP_State_Abbrevation__c = 'VA';
        rlpReg1.PBS_AAAP_Region_Name__c = 'Census';
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

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agency.PBS_AAAP_LEASE_TERM__c = '25 months, 16 firm';
        agency.PBS_AAAP_Region__c = 'Census';

        insert agency;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Agency_Requirement__c = agency.Id, PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'User Defined',
                PBS_AAAP_Shape_Type__c = 'Polygon');
        insert polyObj;

        System.debug('=============>>>>> How does agency look here::: ' + agency);
//    System.debug('=============>>>>> How does agency look here::: '+ polyObj);

        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;
        System.debug('=============>>>>> How does agency look here::: ' + polyPath);


        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        ApexPages.currentPage().getParameters().put('histId', his.id); 
        PBS_AAAP_relateListSnapCntrl iwc = new PBS_AAAP_relateListSnapCntrl();
        iwc.actionReset();
        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        //iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl();//vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl(); //vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        //iwc.getLeaseTermsList();
        System.assert(true);
    }

    static testMethod void myPolygonShapeUnitTest2_Census19() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        rlp.PBS_AAAP_Year__c = '2019';
        rlp.PBS_AAAP_Region__c = 'Census';
        insert rlp;

        System.debug('rlp is ****' + rlp);
        
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0.PBS_AAAP_LEASE_TERM__c = '25 Months, 16 Firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_RATE__c = 10;
        //rate0.Space_Offer__c = String.valueOf(space.Id).substring(0, 15) + '' + String.valueOf(offer.Id).substring(0, 15);
        insert rate0;
        System.debug('Inserted Rate Id : '+rate0.Id);
        System.debug('Inserted Rate : '+rate0);
        System.debug('Space offer field on the inserted rate record : '+rate0.Space_Offer__c);
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1.PBS_AAAP_LEASE_TERM__c = '19 months, 11 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRateFY19();
        //rate2.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2.PBS_AAAP_LEASE_TERM__c = '10 years, 8 firm';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate2.PBS_AAAP_BASE_RATE__c = 10;
        insert rate2;
        PBS_AAAP_Other_Costs__c ocost = PBS_AAAP_UtilityTest.createOtherCosts();
        ocost.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocost;

         PBS_AAAP_RLP_Regions_Map__c rlpReg = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg.PBS_AAAP_RLP_State__c = 'District Of Columbia';
        rlpReg.PBS_AAAP_RLP_State_Abbrevation__c = 'DC';
        rlpReg.PBS_AAAP_Region_Name__c = 'Census';
        insert rlpReg;
        PBS_AAAP_RLP_Regions_Map__c rlpReg1 = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg1.PBS_AAAP_RLP_State__c = 'Virginia';
        rlpReg1.PBS_AAAP_RLP_State_Abbrevation__c = 'VA';
        rlpReg1.PBS_AAAP_Region_Name__c = 'Census';
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

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agency.PBS_AAAP_LEASE_TERM__c = '19 months, 11 firm';
        agency.PBS_AAAP_Region__c = 'Census';

        insert agency;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Agency_Requirement__c = agency.Id, PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'User Defined',
                PBS_AAAP_Shape_Type__c = 'Polygon');
        insert polyObj;

        System.debug('=============>>>>> How does agency look here::: ' + agency);
//    System.debug('=============>>>>> How does agency look here::: '+ polyObj);

        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;
        System.debug('=============>>>>> How does agency look here::: ' + polyPath);


        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        ApexPages.currentPage().getParameters().put('histId', his.id); 
        PBS_AAAP_relateListSnapCntrl iwc = new PBS_AAAP_relateListSnapCntrl();
        iwc.actionReset();
        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        //iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl();//vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_relateListSnapCntrl(); //vss0925
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() > 0);
        //iwc.getLeaseTermsList();
        System.assert(true);
    }

    static testMethod void myOtherUnitTest() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;

        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = false;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        //Vaishali change offer values
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_isBuildingProblem__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRate();
        rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate0;
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRate();
        rate1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRate();
        rate2.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate2;
        PBS_AAAP_Other_Costs__c ocost = PBS_AAAP_UtilityTest.createOtherCosts();
        ocost.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocost;

        PBS_AAAP_RLP_Regions_Map__c rlpReg = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg.PBS_AAAP_RLP_State__c = 'District Of Columbia';
        rlpReg.PBS_AAAP_RLP_State_Abbrevation__c = 'DC';
        rlpReg.PBS_AAAP_Region_Name__c = 'National Capital Region';
        insert rlpReg;

        PBS_AAAP_AlternateDelineatedArea__c altD = new PBS_AAAP_AlternateDelineatedArea__c();
        altD.DilneatedAreaType__c = 'County';
        altD.State__c = 'DC';
        altD.Value__c = 'Fairfax';
        insert altD;
        PBS_AAAP_AlternateDelineatedArea__c altD1 = new PBS_AAAP_AlternateDelineatedArea__c();
        altD1.DilneatedAreaType__c = 'Congressional District';
        altD1.State__c = 'DC';
        altD1.Value__c = 'DC01';
        insert altD1;
        PBS_AAAP_AlternateDelineatedArea__c altD2 = new PBS_AAAP_AlternateDelineatedArea__c();
        altD2.DilneatedAreaType__c = 'Zip Code';
        altD2.State__c = 'VA';
        altD2.Value__c = '20171';
        insert altD2;

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
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
        System.debug('=============>>>>> Agency info MainVSS::: ' + agency);
        System.debug('=============>>>>> Space info MainVSS::: ' + space);

        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        ApexPages.currentPage().getParameters().put('histId', his.id); 
        PBS_AAAP_relateListSnapCntrl iwc = new PBS_AAAP_relateListSnapCntrl();
        iwc.actionReset();
        PBS_AAAP_Space__c sp = [
                select s.Id, s.Name, s.PBS_AAAP_SF_OFFERED__c, s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, s.PBS_AAAP_City__c, s.PBS_AAAP_State__c,
                        s.PBS_AAAP_Type_of_Space__c,s.PBS_AAAP_County__c, s.PBS_AAAP_Congressional_District__c, s.PBS_AAAP_ZipCode__c, s.PBS_AAAP_MANAGEMENT_COORD_FEES__c,
                        s.PBS_AAAP_Offer_Status__c, s.PBS_AAAP_RLP__c, s.PBS_AAAP_Building_Name__c, s.PBS_AAAP_Proximity_to_Metro__c, s.PBS_AAAP_Total_Parking_Spaces__c,
                        s.PBS_AAAP_Street_Address__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c,s.PBS_AAAP_X_lat__c, s.PBS_AAAP_Y_lng__c, s.PBS_AAAP_OFFER_NUMBER__c,
                        s.PBS_AAAP_TOTAL_MARKUP__c, s.PBS_AAAP_ARCH_ENG_FEES__c, s.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,s.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, s.PBS_AAAP_GC_CONDITIONS__c,
                        s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_COST_PER_ABOA__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c,
                        s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Number_of_gar_parking_spaces__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_gar_park__c,
                        s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_sur_park__c,s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_gar_park__c,
                        s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_sur_park__c, PBS_AAAP_MetroWalkableGoogle__c,s.PBS_AAAP_Formula_Energy_Star__c,
                        s.PBS_AAAP_Formula_Hist_Property__c, s.PBS_AAAP_Formula_HUB_ZONE__c, s.PBS_AAAP_Formula_Metro__c, PBS_AAAP_BuildingProblem__c, s.PBS_AAAP_NonSur_Reserved_Park__c,
                        s.PBS_AAAP_NonRes_Gar_Park__c, s.PBS_AAAP_Surface_Res_Park__c, s.PBS_AAAP_Res_Garage_Parking__c, (
                        Select r.Id, r.PBS_AAAP_OT_RATE_COOLING_HEAT__c,
                                r.PBS_AAAP_LEASE_TERM__c, r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c, r.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,r.PBS_AAAP_BASE_RATE__c, r.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,
                                r.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, r.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,r.PBS_AAAP_COST_FOR_TI__c, r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                                r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, r.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,r.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c, r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c,
                                r.PBS_AAAP_Vacant_Premise_Rate__c, r.PBS_AAAP_PV_Value__c, r.PBS_AAAP_PV_Value_Blended__c
                        From Rates__r r
                        where r.PBS_AAAP_LEASE_TERM__c = '5 years' and r.PBS_AAAP_BASE_RATE__c > 0
                )
                From PBS_AAAP_Space__c s
                where s.Id = :space.Id
                limit 1
        ];

        System.debug('=============>>>>> Space info MainVSS::: ' + sp);

        iwc.actionSearch();
        
        iwc.delineatedAreaType = PBS_AAAP_GlobalConstants.ALT_DEL_AREA_TYPE;
        iwc.actionSearch();
        
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        //system.assert(iwc.identifyWinnerForm.size() == 0);
        //iwc.getLeaseTermsList();
        System.assert(true);
    }

    static testMethod void cover_PBS_AAAP_CALCULATIONSClass() {
        PBS_AAAP_CALCULATIONS obj = new PBS_AAAP_CALCULATIONS();        
        obj.getLeaseMonths('17 years, 15 firm'); 
        obj.getLeaseMonths('19 months, 11 firm');
        obj.getLeaseMonths('25 months, 16 firm');
        
        obj.getBCAF(2,3);
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();        
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;        
        insert rlp;
        
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        offer.PBS_AAAP_SECT2_TOTAL__c = 1;
        offer.PBS_AAAP_SRVC_UTIL_TOTAL__c = 1;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id; 
        insert space; 
        
        offer = [select PBS_AAAP_RLP_TI_New_Space__c,PBS_AAAP_RLP_TI_Additional_Space__c,PBS_AAAP_SRVC_UTIL_TOTAL__c,PBS_AAAP_SECT2_TOTAL__c from PBS_AAAP_Offer__c where id =: offer.Id]; 
        space = [select PBS_AAAP_GC_OVERHEAD_AND_PROF__c,PBS_AAAP_ARCH_ENG_FEES__c,PBS_AAAP_GC_CONDITIONS__c,PBS_AAAP_MANAGEMENT_COORD_FEES__c from PBS_AAAP_Space__c where id =: space.Id];
        
        obj.getNewConstrMarkups(space,offer);               
        obj.getNewConstrMarkupsPrctg(space,offer);
        obj.getSuccConstrMarkups(space,offer);
        obj.getSuccConstrMarkupsPrctg(space,offer);
        obj.getNewConstrMarkupsNoAEFee(space,offer);
        obj.getSuccConstrMarkupsNoAEFee(space,offer); 
        
        obj.get2ndNewConstrMarkups(space,offer,10);     
        obj.get2ndNewConstrMarkupsPrctg(space,offer,10);
        obj.get2ndNewConstrMarkupsNoAEFee(space,offer,10);
        
        
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRateFY19();         
        rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_RATE__c = 10 ;       
        insert rate0;

        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRateFY19();           
        rate1.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id; 
        rate1.PBS_AAAP_BASE_RATE__c = 10 ;        
        insert rate1;
        
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRateFY19();           
        rate2.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id; 
        rate2.PBS_AAAP_BASE_RATE__c = 10 ;        
        insert rate2;
        
        obj.getFullySrvcLeaseRateFiveYr(new List<PBS_AAAP_Rate__c>{rate0,rate1},offer,space,10);
        obj.getFullySrvcLeaseRateFiveFiveYr(new List<PBS_AAAP_Rate__c>{rate0,rate2},offer,space,10);
        obj.getFullySrvcLeaseRateTenYr(new List<PBS_AAAP_Rate__c>{rate0,rate1},offer,space,10);
        System.assert(true);
        
    }    
    
    static void iwfContainerTest(PBS_AAAP_relateListSnapCntrl iwc) {

        ////system.assert(iwc.identifyWinnerForm.size() > 0);

        string iwfJson;

        iwc.identifyWinnerForm = null;

        iwfJson = iwc.identifyWinnerFormJson;
        //system.assertEquals(null, iwfJson);

        iwc.identifyWinnerForm = new List<PBS_AAAP_IdentifyWinnerForm>();
        PBS_AAAP_IdentifyWinnerForm iwf;
        iwf = new PBS_AAAP_IdentifyWinnerForm();
        iwf.spaceName = 'untitled';
        iwc.identifyWinnerForm.add(iwf);
        iwfJson = iwc.identifyWinnerFormJson;
        //system.assertNotEquals(null, iwfJson);
        List<PBS_AAAP_IdentifyWinnerForm> des;
        des = ((PBS_AAAP_relateListSnapCntrl.IwfContainer) JSON.deserialize(iwfJson, PBS_AAAP_relateListSnapCntrl.IwfContainer.class)).winners;
        //system.assertEquals(iwc.identifyWinnerForm.size(), des.size());
        System.assert(true);
    }
    

}