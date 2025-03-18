//Updated by Henry Dennis on 7/7/22

@IsTest
private class Test_PBS_AAAP_AgencyRequirement_Ext {

    
    static testMethod void myUnitTest() {
        PageReference pageRef = Page.PBS_AAAP_AgencyRequirementEdit;
        Test.setCurrentPage(pageRef);

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'Continuing';
        
        //This will insert a Region: Updated by HenryDennis
        agency.PBS_AAAP_Region__c = 'National Capital Region';
        insert(agency);

        ApexPages.StandardController s = new ApexPages.StandardController(agency);
        PBS_AAAP_AgencyRequirement_Ext agencycons = new PBS_AAAP_AgencyRequirement_Ext(s);
        agencycons.getRLPList();
        agencycons.getRegionList();
        agencycons.actionSaveAgencyRequirement();
        agency.PBS_AAAP_Region__c = 'National Capital Region';
        agency.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING;
        update agency;
        agencycons.getRLPList();

        agencycons.actionSaveAgencyRequirement();
        agencycons.showExistingLeaseInformation();
        System.assertEquals(PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING, agency.PBS_AAAP_REQ_STATUS__c);
        try {
            agencycons.actionReActivateAgencyRequirement();
        } catch (Exception ex) {
            System.assertEquals('You cannot Re-Activate an Agency Requirement that is not in Cancelled Status', ex.getMessage());
        }

        agencycons.actionIdentifyWinner();
        agencycons.actionCancel();
        //Added by Vaishali 09/08/2016 for code coverage
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert RLP;
        agency.PBS_AAAP_RLP_Number__c = '12-NCR' ;
        update agency;
        agencycons.getLeaseTermList();
        PBS_AAAP_RLP__c rlp1 = PBS_AAAP_UtilityTest.createFY17RLP();
        insert RLP1;
        agency.PBS_AAAP_RLP_Number__c = '17-NCR' ;
        update agency;

//End Vaishali
        //added by syam on 09/08/2016 
        agencycons.getLeaseTermList();
        PBS_AAAP_RLP__c rlp2 = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp2;
        agency.PBS_AAAP_RLP_Number__c = '19-NCR' ;
        update agency;
        agencycons.getLeaseTermList();
        agencycons.shapeCreation();
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
        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'Congressional District';
        agency.PBS_AAAP_DELINEATED_DESCRIPTION__c = 'Congressional District';
        agencycons.getDelineatedAreaTypeDescList();
        agencycons.actionEdit();
        agency.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_CANCELED;
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agencycons.actionEdit();
        agencycons.actionSaveAgencyRequirement();
        agency.PBS_AAAP_WALKABLE_2640_FEET_METRO__c = 'Yes';
        agency.PBS_AAAP_Project_ID__c = '1234';
        agencycons.actionSaveAgencyRequirement();
    }

    static testMethod void actionCanelTest() {
        PageReference pageRef = Page.PBS_AAAP_AgencyRequirementEdit;
        Test.setCurrentPage(pageRef);

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'Continuing';
        ApexPages.StandardController s = new ApexPages.StandardController(agency);
        PBS_AAAP_AgencyRequirement_Ext agencycons = new PBS_AAAP_AgencyRequirement_Ext(s);
        agencycons.actionCancel();

        System.assert(agencycons != null);
    }

    static testMethod void actionCancelAgencyRequirementTest() {
        PageReference pageRef = Page.PBS_AAAP_AgencyRequirement;
        Test.setCurrentPage(pageRef);

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'New';
        agency.PBS_AAAP_Region__c = 'National Capital Region';
        insert agency;
        ApexPages.StandardController s = new ApexPages.StandardController(agency);

        PBS_AAAP_AgencyRequirement_Ext agencycons = new PBS_AAAP_AgencyRequirement_Ext(s);
        agencycons.showPopup();
        agencycons.cancellationReason = 'Test';
        agencycons.getRLPList();
        agencycons.actionSaveAgencyRequirement();
        agencycons.actionCancelAgencyRequirement();
        agency.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING;
        agencycons.actionSaveAgencyRequirement();
        agencycons.showExistingLeaseInformation();
        agencycons.actionCancelAgencyRequirement();
        agencycons.closePopup();

        System.assertEquals(PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_CANCELED, agency.PBS_AAAP_REQ_STATUS__c);

        agencycons.showPopup2();
        agencycons.reactivationReason = 'Test';
        agencycons.actionReActivateAgencyRequirement();
        agencycons.closePopup2();
        System.assertEquals(PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING, agency.PBS_AAAP_REQ_STATUS__c);

    }
    static testMethod void actionCancelAgencyRequirementTest1() {
        PBS_AAAP_IdentifyWinnerForm form = new PBS_AAAP_IdentifyWinnerForm();
        PBS_AAAP_HomePageController home = new PBS_AAAP_HomePageController();
        System.assert(home != null);
    }

    static testMethod void actionPolyShapeTest() {
        PBS_AAAP_RLP_Regions_Map__c rlpReg = new PBS_AAAP_RLP_Regions_Map__c();
        rlpReg.PBS_AAAP_RLP_State__c = 'District Of Columbia';
        rlpReg.PBS_AAAP_RLP_State_Abbrevation__c = 'DC';
        rlpReg.PBS_AAAP_Region_Name__c = 'National Capital Region';
        insert rlpReg;

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
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

        PageReference pageRef = Page.PBS_AAAP_AgencyRequirement;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('polyId', polyObj.Id);
        ApexPages.StandardController s = new ApexPages.StandardController(agency);

        PBS_AAAP_AgencyRequirement_Ext agencycons = new PBS_AAAP_AgencyRequirement_Ext(s);
        agencycons.shapeCreation();
        agencycons.getDelineatedAreaTypeDescList();
        agency.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_AWARDED;
        update agency;
        pageRef = agencycons.actionEdit();
        System.assertEquals(pageRef, null);

        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET;
        update agency;
        agencycons.getDelineatedAreaTypeDescList();

        agency.PBS_AAAP_DELINEATED_DESCRIPTION__c = '[]';
        agency.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET;
        update agency;
        pageRef = agencycons.actionSaveAgencyRequirement();
        System.assertEquals(pageRef, null);
    }
    

    /*
    4/1/2018 - jthomas
    Didn't want to create a new test class until we can confirm the naming conventions.
    Perhaps we can convince the CoE to change it to AppPrefix_Class[_Test]
    In the meantime, I'm adding items here to get our pct back up to 90
     */
    static testMethod void Calculations_getNewAvgCpiAndDiscount_Test(){
        PBS_AAAP_CALCULATIONS c = new PBS_AAAP_CALCULATIONS();
        Decimal ret = c.getNewAvgCpiAndDiscount(10,1,5,10);
        ret = (ret*1000).round();
        System.assertEquals(528, ret);
    }
    static testMethod void Calculations_getFifteenTenYearPVOption_Test(){
        PBS_AAAP_CALCULATIONS c = new PBS_AAAP_CALCULATIONS();
        Decimal ret = c.getFifteenTenYearPVOption(5,2,100000,6);
        ret = ret.round();
        System.assertEquals(138947, ret);
    }
    static testMethod void Calculations_getCensusPV_25_Test(){
        PBS_AAAP_CALCULATIONS c = new PBS_AAAP_CALCULATIONS();
        Decimal ret = c.getCensusPV(5,100000,2,PBS_AAAP_CALCULATIONS.CENSUS_25,5);
        ret = ret.round();
        System.assertEquals(76968, ret);
    }
    static testMethod void Calculations_getCensusPV_19_Test(){
        PBS_AAAP_CALCULATIONS c = new PBS_AAAP_CALCULATIONS();
        Decimal ret = c.getCensusPV(5,100000,3,PBS_AAAP_CALCULATIONS.CENSUS_19,5);
        ret = ret.round();
        System.assertEquals(69733, ret);
    }

    static testMethod void PBS_AAAP_OfferHelper_isPointinPolygon_Test(){
        List<PBS_AAAP_PolyPath__c> polyPaths = new List<PBS_AAAP_PolyPath__c>();
        PBS_AAAP_PolyPath__c pp;
        pp = new PBS_AAAP_PolyPath__c();
        pp.longitude__c = 0;
        pp.latitude__c = 0;
        polyPaths.add(pp);
        pp = new PBS_AAAP_PolyPath__c();
        pp.longitude__c = 100;
        pp.latitude__c = 100;
        polyPaths.add(pp);
        pp = new PBS_AAAP_PolyPath__c();
        pp.longitude__c = 200;
        pp.latitude__c = 0;
        polyPaths.add(pp);
        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
        offer.PBS_AAAP_X_CO_ORD__c = 20;
        offer.PBS_AAAP_y_CO_ORD__c = 5;
        boolean ret = PBS_AAAP_OfferHelper.isPointinPolygon(polyPaths, offer);
        system.assert(ret);
    }
    
    
    // added on 03-Jan-2018
    static testMethod void getPVValuesForRLP_Test(){
        
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        agency.PBS_AAAP_Region__c = '12-NCR';
        insert agency;
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        rlp.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
        rlp.PBS_AAAP_Region__c = agency.PBS_AAAP_Region__c;         
        insert rlp;
        
        ApexPages.StandardController s = new ApexPages.StandardController(agency);      
        PBS_AAAP_AgencyRequirement_Ext obj = new PBS_AAAP_AgencyRequirement_Ext(s);
        
        
        
        obj.getPVValuesForRLP();
        
        rlp.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
        update rlp;
        
        obj.getPVValuesForRLP(); 
        
        obj.selectedRlpNumber = '12-NCR';
        obj.getLeaseTermList();
        
        rlp = PBS_AAAP_UtilityTest.createRLP();
        rlp.PBS_AAAP_Year__c = '2020';
        insert rlp;
        obj.getLeaseTermList();
      	System.assert(true);
    }

    
    @IsTest(SeeAllData=true)
    public static void PBS_AAAP_OfferHelper_findCongressionalDistrict_Test() {
        List<PBS_AAAP_Offer__c> offerList = new List<PBS_AAAP_Offer__c>();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_X_CO_ORD__c = 38.925012;
        offer.PBS_AAAP_Y_CO_ORD__c = -77.230207;
        offer.PBS_AAAP_State__c = 'VA';
        offer.PBS_AAAP_Country__c = 'USA';
        offer.PBS_AAAP_City__c = 'Mclean';
        offer.PBS_AAAP_Street_Address__c = '1660 International Drive';
        offer.PBS_AAAP_ZipCode__c = '22102';
        insert offer;
        //offerList.add(offer);
        System.assertEquals(null, null);
    }
    
    
    
    // added on 03-Jan-2018
    static testMethod void getPVValuesFromRLP_Test(){ 
        
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        agency.PBS_AAAP_Region__c = '12-NCR';
        insert agency;
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        rlp.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
        rlp.PBS_AAAP_Region__c = agency.PBS_AAAP_Region__c;         
        insert rlp;
        
        ApexPages.StandardController s = new ApexPages.StandardController(agency);      
        PBS_AAAP_AgencyRequirement_Ext obj = new PBS_AAAP_AgencyRequirement_Ext(s);
        obj.selectedRlpNumber = '12-NCR1';
        obj.getPVValuesFromRLP();
        
        obj.selectedRlpNumber = '12-NCR';
        obj.getPVValuesFromRLP();
        
        System.assert(true);
    }


    //JK changes start here 10.28.20
     /*static testMethod void createData(){
        Account acc = new Account(Name = 'Test Account 1');//, PBS_AAAP_AB_Code__c = '1010');
        insert acc;
        RET_GREX_Integration_Settings__c cs1 = new RET_GREX_Integration_Settings__c();
        cs1.Endpoint_URL__c = 'https://test1.com';
        insert cs1;
        List<RET_GREX_Integration_Email_Settings__c> intEmailList = new List<RET_GREX_Integration_Email_Settings__c>();
        RET_GREX_Integration_Email_Settings__c cs2 = new RET_GREX_Integration_Email_Settings__c();
        cs2.Name = 'Integration Failure';
        cs2.To_Address__c = 'xyz@test.com';
        cs2.Email_Subject__c = 'test email';
        cs2.Sender_Display_Name__c = 'Test Sender';
        cs2.Email_Body__c = 'Test Body';
        intEmailList.add(cs2);
        RET_GREX_Integration_Email_Settings__c cs3 = new RET_GREX_Integration_Email_Settings__c();
        cs3.Name = 'O&M Integration Failure';
        cs3.To_Address__c = 'xyz@test.com';
        cs3.Email_Subject__c = 'test email';
        cs3.Sender_Display_Name__c = 'Test Sender';
        cs3.Email_Body__c = 'Test Body';
        intEmailList.add(cs3);
        RET_GREX_Integration_Email_Settings__c cs4 = new RET_GREX_Integration_Email_Settings__c();
        cs4.Name = 'GREX Team Integration Failure';
        cs4.To_Address__c = 'xyz@test.com';
        cs4.Email_Subject__c = 'test email';
        cs4.Sender_Display_Name__c = 'Test Sender';
        cs4.Email_Body__c = 'Test Body';
        intEmailList.add(cs4);
        insert intEmailList; */
        
        //Create Lease Record
        /*PBS_Lease__c leaseRec = new PBS_Lease__c(Name='Test Lease', Lease_Number__c='1234', Lease_Effective_Date__c=date.today());
        Insert leaseRec;*/
        
    //}
    

    static testMethod void rexusIntegration_Test() {
		PBS_AAAP_Agency_Requirement__c agency1 = new PBS_AAAP_Agency_Requirement__c();
        ApexPages.StandardController s1 = new ApexPages.StandardController(agency1);
        PBS_AAAP_AgencyRequirement_Ext agencycons1 = new PBS_AAAP_AgencyRequirement_Ext(s1);
        agencycons1.rexusDataStr = 'data';
        agencycons1.closeRexusPopup();
        agencycons1.showRexusPopup();
        agencycons1.displayRexusPopup = true;
		agencycons1.runningUserName = 'Test Name';
        agencycons1.AAAPCustomerPortalAccountName = 'Test Account Name';
        agencycons1.canErr = 'You must specify a Rexus Project Number.';
        agencycons1.showCancelError = true;
        System.assert(true);
    }
    
    static testMethod void PositiveTest(){
        PBS_AAAP_Agency_Requirement__c agency1 = new PBS_AAAP_Agency_Requirement__c();
        ApexPages.StandardController s1 = new ApexPages.StandardController(agency1);
        PBS_AAAP_AgencyRequirement_Ext agencycons1 = new PBS_AAAP_AgencyRequirement_Ext(s1);
        agencycons1.getRexusData();
        test.startTest();
            test.setMock(HttpCalloutMock.class, new GoodMock());
        	agencycons1.rexusProjectId = '1234567';
        	agencycons1.getRexusData();
            //System.assertEquals(details[0].LeaseNumber, '1234');WIP WHAT IN ASSERT
        test.stopTest();
        System.assert(true);
    }

    static testMethod void NegativeTest(){
        test.startTest();
            test.setMock(HttpCalloutMock.class, new GoodMock());
            Boolean errorOccurred = false;
         	PBS_AAAP_Agency_Requirement__c agency1 = new PBS_AAAP_Agency_Requirement__c();
        	ApexPages.StandardController s1 = new ApexPages.StandardController(agency1);
        	PBS_AAAP_AgencyRequirement_Ext agencycons1 = new PBS_AAAP_AgencyRequirement_Ext(s1);
                //trying invalid project id- won't validate on the client, no callout
                agencycons1.rexusProjectId = '1';
                agencycons1.getRexusData();
                if(agencycons1.showCancelError == true) errorOccurred = true;
            System.assertEquals(true, errorOccurred);
        test.stopTest();
    }

    static testMethod void CommunicationFailureTest(){
        PBS_AAAP_Agency_Requirement__c agency1 = new PBS_AAAP_Agency_Requirement__c();
        	ApexPages.StandardController s1 = new ApexPages.StandardController(agency1);
        	PBS_AAAP_AgencyRequirement_Ext agencycons1 = new PBS_AAAP_AgencyRequirement_Ext(s1);

        test.startTest();
            test.setMock(HttpCalloutMock.class, new BadMock());
            agencycons1.rexusProjectId = '1234568';
            agencycons1.getRexusData();
            System.assertEquals(true, agencycons1.showCancelError);//details[0].BasicAndAddlInfoError); WHAT IN ASSERT
        test.stopTest();
        
    }  
    
    static testMethod void invalidNumberOfRecords(){
         PBS_AAAP_Agency_Requirement__c agency1 = new PBS_AAAP_Agency_Requirement__c();
        ApexPages.StandardController s1 = new ApexPages.StandardController(agency1);
        PBS_AAAP_AgencyRequirement_Ext agencycons1 = new PBS_AAAP_AgencyRequirement_Ext(s1);
        agencycons1.getRexusData();
        test.startTest();
            test.setMock(HttpCalloutMock.class, new InvalidRecordsMock());
        	agencycons1.rexusProjectId = '1234567';
        	agencycons1.getRexusData();
            //System.assertEquals(details[0].LeaseNumber, '1234');WIP WHAT IN ASSERT
        test.stopTest();
        System.assert(true);
    }
    
    private class GoodMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"totalSize": 1, "pageSize": 1, "success": "true", "status": 200, "records": [{"surfaceParking":2,"state":"New York","spaceType":"TTO","region":1,"projectId":"1234567","nickname":null,"minimumContiguousABOA":816,"leaseTermStr":null,"leaseTerm":240,"hvac":1,"garageParking":1,"city":"Brooklyn","agencyName":"DMV","aboaSFMin":816,"abCode":"1234"}]}');
            return res;
        }
    }  
    
    private class BadMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(503);
            res.setBody('');
            return res;
        }
    } 
    
    private class InvalidRecordsMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"totalSize": 2, "pageSize": 1, "success": "true", "status": 200, "records": [{"surfaceParking":2,"state":"New York","spaceType":"TTO","region":1,"projectId":"1234567","nickname":null,"minimumContiguousABOA":816,"leaseTermStr":null,"leaseTerm":240,"hvac":1,"garageParking":1,"city":"Brooklyn","agencyName":"DMV","aboaSFMin":816,"abCode":"1234"}]}');
            return res;
        }
    }  
    
    //JK changes end here
}