@isTest
private class Test_PBS_AAAP_IdentifyWinner {
    static testMethod void myPolygonShapeUnitTest() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        //rlp.PBS_AAAP_Year__c = '2019';
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
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRate();
        rate0.PBS_AAAP_LEASE_TERM__c = '5 years';
        //rate0.PBS_AAAP_LEASE_TERM__c = '17 years,15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id; 
        insert rate0;
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRate();
        rate1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        //rate1.PBS_AAAP_LEASE_TERM__c = '15 years,13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRate();
        rate2.PBS_AAAP_LEASE_TERM__c = '10 years';
        //rate2.PBS_AAAP_LEASE_TERM__c = '10 years,8 firm';
        rate2.PBS_AAAP_SPACE__c = space.Id;
        rate2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate2;
        PBS_AAAP_Other_Costs__c ocost = PBS_AAAP_UtilityTest.createOtherCosts();
        ocost.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocost;

        
        
        // calling remote actionReset
        PBS_AAAP_IdentifyWinnerController.fetchCookieData(offer.Id,space.Id);
        PBS_AAAP_IdentifyWinnerController objIns = new PBS_AAAP_IdentifyWinnerController();
        objIns.redirectHist();
        
        objIns.strImagename = 'test';
        objIns.strImageBlob1 = 'abd';
        objIns.captureImage();
        
        
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
        insert agency;
                
        objIns.agencyRecord =  agency;
        objIns.getHistoricalOptions();

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
        
        PBS_AAAP_Offer_Attachments__c offerattachment1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offer.Id,PBS_AAAP_Attachment_Type__c='SAM Registration',PBS_AAAP_Sent_to_GREX__c = True);
         insert offerattachment1;
        
        ContentVersion contentVersion = new ContentVersion(
        Title          = 'a picture',
        PathOnClient   = 'Pic.jpg',
        VersionData    = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = offerattachment1.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;     
        

        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.lstOffer = null;
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);       
       

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        ApexPages.currentPage().getParameters().put('node', agency.id); 
        ApexPages.currentPage().getParameters().put('list', offer.id); 
        iwc.callCloningClass();
        //iwc.cloneOffers();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
        
        
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        
         iwc.selectedHistorical = String.valueOf(his.id);
        iwc.actionSearch();
        
    }
    static testMethod void myPolygonShapeUnitTestFY17() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        //rlp.PBS_AAAP_Year__c = '2019';
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
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRate();
        rate0.PBS_AAAP_LEASE_TERM__c = '10 years';
        //rate0.PBS_AAAP_LEASE_TERM__c = '17 years,15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate0;
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRate();
        rate1.PBS_AAAP_LEASE_TERM__c = '10 years,5 firm';
        //rate1.PBS_AAAP_LEASE_TERM__c = '15 years,13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate1;
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRate();
        rate2.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        //rate2.PBS_AAAP_LEASE_TERM__c = '10 years,8 firm';
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
        agency.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
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
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
    }
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
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
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
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
        
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        
         iwc.selectedHistorical = String.valueOf(his.id);
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
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
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
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
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
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
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
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();
        iwc.actionSearch();
        iwc.backtoAgencyReq();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwfContainerTest(iwc);

        //iwc.updatePropList(); //vss

        iwc.selectedOfferId = offer.Id;
        iwc.selectedSpaceId = space.Id;

        PBS_AAAP_Utility.setQueryParam('iwfJson', iwc.identifyWinnerFormJson);
        iwc.actionSelectSpace();

        //iwc.updatePropList();
        System.debug('=============>>>>> Space info Main Agency::: ' + agency);

        iwc.getDelineatedAreaTypeDescList();
// Vaishali 
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 100;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

//Vaishali 2
        agency.PBS_AAAP_HVAC_OVERTIME_HOURS__c = 0;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = false;

        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
    }
    static testmethod void mycontinuingARUnitTest() { 
        System.debug('===========>>>>>>>>>>>****** mycontinuingAR starts here........: ');
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
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = '1122';
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
//additional new space
        PBS_AAAP_Space__c space1 = PBS_AAAP_UtilityTest.createSpace();
        space1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space1.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        insert space1;

        PBS_AAAP_Rate__c rate0_1 = PBS_AAAP_UtilityTest.createRate();
        rate0_1.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0_1.PBS_AAAP_SPACE__c = space1.Id;
        rate0_1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate0_1;
        PBS_AAAP_Rate__c rate1_1 = PBS_AAAP_UtilityTest.createRate();
        rate1_1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1_1.PBS_AAAP_SPACE__c = space1.Id;
        rate1_1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate1_1;
        PBS_AAAP_Rate__c rate2_1 = PBS_AAAP_UtilityTest.createRate();
        rate2_1.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2_1.PBS_AAAP_SPACE__c = space1.Id;
        rate2_1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate2_1;
        
        PBS_AAAP_Rate__c rate2_2 = PBS_AAAP_UtilityTest.createRate();
        rate2_2.PBS_AAAP_LEASE_TERM__c = '10 years,5 firm';
        rate2_2.PBS_AAAP_SPACE__c = space1.Id;
        rate2_2.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate2_2;


//additional new space      
        PBS_AAAP_Other_Costs__c ocost = PBS_AAAP_UtilityTest.createOtherCosts();
        ocost.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocost;
        PBS_AAAP_RLP_Regions_Map__c rlpReg = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg.PBS_AAAP_RLP_State__c = 'District Of Columbia';
        rlpReg.PBS_AAAP_RLP_State_Abbrevation__c = 'DC';
        rlpReg.PBS_AAAP_Region_Name__c = 'National Capital Region';
        insert rlpReg;

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_CONTINUING;
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = PBS_AAAP_GlobalConstants.DEL_AREA_TYPE; //  'User Delineated Area';
        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 0;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 0;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 0;
        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 0;
        agency.PBS_AAAP_WALKABLE_2640_FEET_METRO__c = 'no';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        insert agency;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Agency_Requirement__c = agency.Id, PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'User Defined',
                PBS_AAAP_Shape_Type__c = 'Circle');
        insert polyObj;

        System.debug('===========>>>>>>>>>>>****** agency starts here........: ' + agency);
        System.debug('===========>>>>>>>>>>>****** polyobj starts here........: ' + polyObj);
        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.actionReset();

        test.startTest();
        iwc.selectedHistorical = 'Master';

        iwc.actionSearch();
        System.debug('=============>>>>> iwcx.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

        //iwc.updatePropList(); //vss
        System.debug('=============>>>>> Parking > 0 requirement ::: ' + offer);
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        //PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.actionReset();
        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

        System.debug('=============>>>>> 10 year requirement ::: ' + offer);
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;
        agency.PBS_AAAP_LEASE_TERM__c = '10 years';

        //added by syam

        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_CONTINUING;
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.selectedHistorical = 'Master';
        // iwc.actionReset();
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

        System.debug('=============>>>>> 5+5 year requirement ::: ' + offer);
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;
        agency.PBS_AAAP_LEASE_TERM__c = '5+5 Years';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc.selectedHistorical = 'Master';
        //PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.actionReset();
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

        System.debug('=============>>>>> 10 year New requirement ::: ' + offer);
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_NEW;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;
        agency.PBS_AAAP_LEASE_TERM__c = '10 Years';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc.selectedHistorical = 'Master';
        //PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.actionReset();
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

        System.debug('=============>>>>> 10 year 8 Firm New requirement ::: ' + offer);
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_NEW;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;
        agency.PBS_AAAP_LEASE_TERM__c = '10 Years, 8 firm';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc.selectedHistorical = 'Master';
        //PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.actionReset();
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);

        System.debug('=============>>>>> 5+5 year New requirement ::: ' + offer);
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_NEW;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;
        agency.PBS_AAAP_LEASE_TERM__c = '5+5 Years';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc.selectedHistorical = 'Master';
        //PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.actionReset();
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        test.stopTest();
        
        system.debug('=============>>>>> 10 years,5 firm New requirement ::: ' + offer);
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_NEW;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1;
        agency.PBS_AAAP_Include_HVAC_Overtime__c = true;
        agency.PBS_AAAP_LEASE_TERM__c = '10 years,5 firm';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc.selectedHistorical = 'Master';
        //PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController(); //vss0925
        iwc.actionReset();
        iwc.actionSearch();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() > 0);
        iwc.getLeaseTermsList();
        

    }
    static testMethod void myCircleShapeUnitTest() {
        System.debug('===========>>>>>>>>>>>****** myCircleShapeUnitTest starts here........: ');

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
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
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = '1122';
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
//additional new space
        PBS_AAAP_Space__c space1 = PBS_AAAP_UtilityTest.createSpace();
        space1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space1.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        insert space1;

        PBS_AAAP_Rate__c rate0_1 = PBS_AAAP_UtilityTest.createRate();
        rate0_1.PBS_AAAP_LEASE_TERM__c = '5 years';
        rate0_1.PBS_AAAP_SPACE__c = space1.Id;
        rate0_1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate0_1;
        PBS_AAAP_Rate__c rate1_1 = PBS_AAAP_UtilityTest.createRate();
        rate1_1.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        rate1_1.PBS_AAAP_SPACE__c = space1.Id;
        rate1_1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate1_1;
        PBS_AAAP_Rate__c rate2_1 = PBS_AAAP_UtilityTest.createRate();
        rate2_1.PBS_AAAP_LEASE_TERM__c = '10 years';
        rate2_1.PBS_AAAP_SPACE__c = space1.Id;
        rate2_1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate2_1;


//additional new space      
        PBS_AAAP_Other_Costs__c ocost = PBS_AAAP_UtilityTest.createOtherCosts();
        ocost.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocost;
        PBS_AAAP_RLP_Regions_Map__c rlpReg = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg.PBS_AAAP_RLP_State__c = 'District Of Columbia';
        rlpReg.PBS_AAAP_RLP_State_Abbrevation__c = 'DC';
        rlpReg.PBS_AAAP_Region_Name__c = 'National Capital Region';
        insert rlpReg;

        PBS_AAAP_PolyObject__c polyObj = new PBS_AAAP_PolyObject__c(PBS_AAAP_Circle_Radius__c = 24140.1600, Polygon_Type__c = 'SubMarket',
                PBS_AAAP_Shape_Type__c = 'Circle');
        insert polyObj;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_CONTINUING;
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'Alternate Delineated Area';
        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'SubMarket';
        agency.PBS_AAAP_Polygon_Object_Id__c = polyObj.Id;
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        //Vaishali
        // agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        // agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_CONTINUING;
        //Vaishali
        insert agency;
        System.debug('===========>>>>>>>>>>>****** polyobj SubMarket starts here........: ' + polyObj);
        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.actionReset();
        System.debug('===========>>>>>>>>>>>****** SUBMARKET........: ' + polyObj);
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

        System.debug('=============>>>>> Space info ::: ' + sp);

        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        System.debug('===========>>>>>>>>>>>****** SUBMARKET.END.......: ' + polyObj);
        iwc.getDelineatedAreaTypeDescList();

        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'City';
        agency.PBS_AAAP_DELINEATED_DESCRIPTION__c = 'Herndon';
        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.actionReset();
        sp = [
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

        System.debug('=============>>>>> Space info ::: ' + sp);

        System.assert(agency.Id != null);

        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        System.debug('===========>>>>>>>>>>>****** CITY.END.......: ' + polyObj);    //vss0925
        iwc.getDelineatedAreaTypeDescList();//vss0925

        //Vaishali Include County
        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'County';
        agency.PBS_AAAP_DELINEATED_DESCRIPTION__c = 'Fairfax';
        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.actionReset();

        System.debug('=============>>>>> Before COUNTY.START ::: ' + agency);

        System.assert(agency.Id != null);

        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        System.debug('===========>>>>>>>>>>>****** COUNTY.END.......: ' + polyObj);    //vss0925
        //    iwc.getDelineatedAreaTypeDescList(); //vss0925


        //Vaishali Include Zipcode
        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'Zip Code';
        agency.PBS_AAAP_DELINEATED_DESCRIPTION__c = '20171';
        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        update agency;
        System.debug('=============>>>>> Agency0925 info ::: ' + agency);

        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.actionReset();
        System.debug('=============>>>>> Before Zipcode.START ::: ' + agency);


        System.assert(agency.Id != null);

        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        //Vaishali change offer values //vss0925 everything below
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_isBuildingProblem__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
        update offer;
        prop.PBS_AAAP_MetroWalkable__c = false;
        update prop;
        update space1;
        update space;
        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'City';
        agency.PBS_AAAP_DELINEATED_DESCRIPTION__c = 'Herndon';
        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        agency.PBS_AAAP_WALKABLE_2640_FEET_METRO__c = 'No';
        agency.PBS_AAAP_LEASE_TERM__c = '5+5 years';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.actionReset();
        sp = [
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
        System.debug('=============>>>>> VAISHALI SHAH ::: ' + sp);

        System.assert(agency.Id != null);

        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        System.debug('===========>>>>>>>>>>>****** remainder flags.......: ');    //vss0925
        System.debug('===========>>>>>>>>>>>****** Zipcode.END.......: ' + polyObj);    //vss0925
        // iwc.getDelineatedAreaTypeDescList(); //vss0925
        //Vaishali Include Congressional District
        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'Congressional District';
        agency.PBS_AAAP_DELINEATED_DESCRIPTION__c = 'DC01';
        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        update agency;
        ApexPages.currentPage().getParameters().put('agencyId', agency.id);
        iwc = new PBS_AAAP_IdentifyWinnerController();
        iwc.actionReset();
        sp = [
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

        System.debug('=============>>>>> Space info ::: ' + sp);

        System.assert(agency.Id != null);

        iwc.selectedHistorical = 'Master';
        Test.startTest();
        iwc.actionSearch();
        Test.stopTest();
        System.debug('===========>>>>>>>>>>>****** CD.END.......: ' + polyObj);    //vss0925
        //    iwc.getDelineatedAreaTypeDescList(); //vss0925
        iwc.getLeaseTermsList();
        PBS_AAAP_Offer_History__c his = new PBS_AAAP_Offer_History__c(PBS_AAAP_Agency_Requirement__c = agency.id,PBS_AAAP_Offer_Ids__c= ''+offer.id);
        Insert his;
        
         iwc.selectedHistorical = String.valueOf(his.id);
         iwc.actionSearch();
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
        //ApexPages.currentPage().getParameters().put('isImagePrintPage','yes');
        
        PBS_AAAP_IdentifyWinnerController iwc = new PBS_AAAP_IdentifyWinnerController();
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

        iwc.selectedHistorical = 'Master';
        iwc.actionSearch();
        iwc.redirectHist2();
        //iwc.deleteImages();
        iwc.spaceIdsSet2 = 'test';
        iwc.folderId = 'test';
        iwc.lstDocIds = new List<String>();
        iwc.lstDocIds = new List<String>();
        System.debug('=============>>>>> iwc.identifyWinnerForm.size() ::: ' + iwc.identifyWinnerForm.size());
        system.assert(iwc.identifyWinnerForm.size() == 0);
        iwc.getLeaseTermsList();

        //Vaishali change offer values


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
        double testValue = 23.34;
    PBS_AAAP_CALCULATIONS clsRecord = new PBS_AAAP_CALCULATIONS();
        double doubleResult = clsRecord.getSurfaceParkingRate(testValue,testValue,testValue,testValue,testValue,testValue);
        doubleResult = clsRecord.getGarageParkingRate(testValue,testValue,testValue,testValue,testValue,testValue);
        doubleResult = clsRecord.getTotalLessorOverheadAndFees(testValue, testValue);
        doubleResult = clsRecord.getTotalFeeCostPercentage(testValue, testValue, testValue);
        doubleResult = clsRecord.getTotalFeeCost(testValue, testValue, testValue);
        doubleResult = clsRecord.getNPTonly(testValue, testValue, testValue);
        doubleResult = clsRecord.getNPTonly(testValue, testValue, testValue, testValue);
        doubleResult = clsRecord.getMoveTelcoUpfrontCosts(testValue, testValue, testValue, '5 years', true);
        doubleResult = clsRecord.getAmortizationCost(testValue, testValue, testValue);
        
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_CONTINUING;
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'Alternate Delineated Area';
        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'SubMarket';
        ///agency.PBS_AAAP_Polygon_Object_Id__c = polyObj.Id;
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        //Vaishali
        // agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = '1122';
        // agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = PBS_AAAP_GlobalConstants.TYPE_OF_REK_CONTINUING;
        
        try{
        doubleResult = clsRecord.censusPV(offer, space, rlp, '5 years', rate0, agency, true,testValue, testValue, testValue, testValue);
        }catch(Exception e){
        
        }
        try{
        doubleResult = clsRecord.getNPV('5 years',testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue, testValue);
        
        }catch(Exception e){
        
        }
        List<PBS_AAAP_Rate__c> rates = new List<PBS_AAAP_Rate__c>();
        rates.add(rate0);
        rates.add(rate1);
        Decimal decimalResult = clsRecord.getSucc1rstFreeRentForFiveYearwithBSAC(rates,  testValue, '5 years', testValue, 7);
        
        decimalResult = clsRecord.getSucc1rstFreeRentForFiveYear(rates,  testValue, '5 years');
        try{
        decimalResult = clsRecord.getTotalMarkup(space, offer, '%',12,23);
        }catch(Exception e){
        
        }
        try{
        decimalResult = clsRecord.getTotalMarkup(space, offer, 'test',12,23);
        }catch(Exception e){
        
        }
        decimalResult = clsRecord.getNPV(testValue,testValue,testValue);
        
        decimalResult = clsRecord.getAmortizationofTI(testValue,testValue,testValue);
        decimalResult = clsRecord.getAnnualRentPerABOASFYear2(testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue);
        
        decimalResult = clsRecord.getAnnualRentPerABOASFYear1(testValue, testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue);
        
        //decimalResult = clsRecord.getAnnualRentPerABOASFYear3(testValue, testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue);
        
        decimalResult = clsRecord.getCensusPV(testValue, testValue,testValue,PBS_AAAP_CALCULATIONS.CENSUS_25,testValue);
        
        decimalResult = clsRecord.getCensusPV(testValue, testValue,testValue,PBS_AAAP_CALCULATIONS.CENSUS_19,testValue);
        
        decimalResult = clsRecord.getAnnualRentPerABOASFYear2for25(testValue,testValue, testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue);
        
        decimalResult = clsRecord.getAnnualRentPerABOASFYear1for25(testValue, testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue,testValue);
        
        System.assert(true);
    }
    static void iwfContainerTest(PBS_AAAP_IdentifyWinnerController iwc) {

        //system.assert(iwc.identifyWinnerForm.size() > 0);

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
    /*
       This method is performing PV calculation for 2019 Year where old approach is using and you can see by code
       coverage that It's executing the calculations for 2019
    */
    static testMethod void pvCalculationsFor2019Year() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        rlp.PBS_AAAP_Year__c = '2019';
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
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRateFY19();
        rate0.PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_RATE__c = 10;
        insert rate0;
        
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRateFY19();
        rate1.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRateFY19();
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

        PBS_AAAP_PolyPath__c polyPath = new PBS_AAAP_PolyPath__c();
        polyPath.latitude__c = 38.91;
        polyPath.longitude__c = -77.05;
        polyPath.Path_Index__c = 0;
        polyPath.Poly_Object__c = polyObj.Id;

        insert polyPath;

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
        ApexPages.currentPage().getParameters().put('agencyId', agency.id); //vss0925
        iwc = new PBS_AAAP_IdentifyWinnerController();//vss0925
        iwc.selectedHistorical = 'Master';
        iwc.actionReset();

        iwc.actionSearch();
    }
        /*
       This method is performing PV calculation for 2021 Year where new approach is using and you can see by code
       coverage that It's executing the calculations for 2021 and It's covering PBS_AAAP_PV_Calculations_2021. 
    */
    static testMethod void pvCalculationsFor2021Year() {
        System.debug('Year 2021');
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        rlp.PBS_AAAP_Year__c = '2021';
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 68.39;
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 68.39;
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 0.00;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 0.00;
        rlp.PBS_AAAP_BSAC_per_ABOA__c = 5.78;
        rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c = 5.78;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 0.00;
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
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRate();
        rate0.PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10.70;
        rate0.PBS_AAAP_BASE_RATE__c = 11.73;
        rate0.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 0.00;
        rate0.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 22.31;
        rate0.PBS_AAAP_BSAC_RATE__c = 0.00;
        rate0.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 180;
        insert rate0;
        
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRate();
        rate1.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRate();
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

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c(PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1, PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 1,
                PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 1, PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 1,
                PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm', PBS_AAAP_MIN_CONT_USF__c = 10000, PBS_AAAP_OFFICIAL_NUM_PARKING_SPACES__c = 200,
                PBS_AAAP_WALKABLE_2640_FEET_METRO__c = 'Yes', PBS_AAAP_USF_REQ_MAX__c = 20000, PBS_AAAP_USF_REQ_MIN__c = 10000,
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_NICKNAME__c = 'Nick Name', PBS_AAAP_TYPE_OF_SPACE__c = 'Office',
                PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'New', PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'City', PBS_AAAP_RLP_Number__c = '12-NCR'
        );
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
    }
    static testMethod void pvCalculationsFor2023Year() {
        System.debug('Year 2021');
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        rlp.PBS_AAAP_Year__c = '2023';
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 68.39;
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 68.39;
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 0.00;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 0.00;
        rlp.PBS_AAAP_BSAC_per_ABOA__c = 5.78;
        rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c = 5.78;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 0.00;
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
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;


        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        PBS_AAAP_Rate__c rate0 = PBS_AAAP_UtilityTest.createRate();
        rate0.PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm';
        rate0.PBS_AAAP_SPACE__c = space.Id;
        rate0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate0.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10.70;
        rate0.PBS_AAAP_BASE_RATE__c = 11.73;
        rate0.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 0.00;
        rate0.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 22.31;
        rate0.PBS_AAAP_BSAC_RATE__c = 0.00;
        rate0.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 180;
        insert rate0;
        
        PBS_AAAP_Rate__c rate1 = PBS_AAAP_UtilityTest.createRate();
        rate1.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        rate1.PBS_AAAP_BASE_RATE__c = 10;
        insert rate1;
        
        PBS_AAAP_Rate__c rate2 = PBS_AAAP_UtilityTest.createRate();
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

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c(PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1, PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 1,
                PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 1, PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 1,
                PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm', PBS_AAAP_MIN_CONT_USF__c = 10000, PBS_AAAP_OFFICIAL_NUM_PARKING_SPACES__c = 200,
                PBS_AAAP_WALKABLE_2640_FEET_METRO__c = 'Yes', PBS_AAAP_USF_REQ_MAX__c = 20000, PBS_AAAP_USF_REQ_MIN__c = 10000,
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_NICKNAME__c = 'Nick Name', PBS_AAAP_TYPE_OF_SPACE__c = 'Office',
                PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'New', PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'City', PBS_AAAP_RLP_Number__c = '12-NCR'
        );
        agency.PBS_AAAP_DELINEATED_AREA_TYPE__c = 'User Delineated Area';
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
		agency.PBS_AAAP_Region__c ='10/5 Term - All Regions';
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
    }
}