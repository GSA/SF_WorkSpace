@IsTest
private class PBS_AAAP_UNIT_TEST_AgencyReqShape {

    static testMethod void myUnitTest() {

        // test data
        PageReference pageRef = Page.PBS_AAAP_AgencyRequirementShape;
        Test.setCurrentPage(pageRef);

        // build inner test data
        PBS_AAAP_AgencyRequirementShape.PolygonPath testPolyPath = new PBS_AAAP_AgencyRequirementShape.PolygonPath(1.00, 30.30, 40.40);
        PBS_AAAP_AgencyRequirementShape.Circle testCircle = new PBS_AAAP_AgencyRequirementShape.Circle(1.00, testPolyPath);
        PBS_AAAP_AgencyRequirementShape.PolygonPath testPolyPath1 = new PBS_AAAP_AgencyRequirementShape.PolygonPath();
        PBS_AAAP_AgencyRequirementShape.Circle testCircle1 = new PBS_AAAP_AgencyRequirementShape.Circle();

        List<String> paths = new List<String>();
        paths.add('[0*39.030096065615545*-77.16544406562502]');
        paths.add('[1*38.88058724287268*-77.17093722968752]');
        paths.add('[2*38.88913909977848*-76.86881320625002]');
        paths.add('[3*39.030096065615545*-76.88529269843752]');

        List<String> paths1 = new List<String>();
        paths.add('[0*35.030096065615545*-77.16544406562502]');
        paths.add('[1*36.88058724287268*-77.17093722968752]');
        paths.add('[2*37.88913909977848*-76.86881320625002]');
        paths.add('[3*38.030096065615545*-76.88529269843752]');

        paths1.add('[0*35.030096065615545*-77.16544406562502]');
        paths1.add('[1*36.88058724287268*-77.17093722968752]');
        paths1.add('[2*37.88913909977848*-76.86881320625002]');
        paths1.add('[3*38.030096065615545*-76.88529269843752]');

        // build the test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // build the test data (agency requirement)
        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c(PBS_AAAP_Account_Name__c = testAccount.Id,
                PBS_AAAP_DATE_REQ_RECEIVED_BY_AAP__c = System.today());
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'Continuing';
        insert agency;
        //Smitha
        PBS_AAAP_PolyObject__c pObject = new PBS_AAAP_PolyObject__c();
        pObject.Polygon_Type__c = 'User Defined';
        pObject.PBS_AAAP_legacy_id__c = '';
        pObject.PBS_AAAP_Shape_Type__c = 'circle';
        pObject.PBS_AAAP_Circle_Radius__c = 26400.7786;
        pObject.PBS_AAAP_Agency_Requirement__c = agency.Id;
        pObject.Name = 'atlanta';
        insert pObject;
        pageRef.getParameters().put('polyId', pObject.Id);
        PBS_AAAP_PolyPath__c path = new PBS_AAAP_PolyPath__c();
        path.Poly_Object__c = pObject.Id;
        path.longitude__c = -84.38309570328768;
        path.latitude__c = 33.733226698921044;
        path.Path_Index__c = 0;
        insert path;
        //Smitha
        // instantiate the standard contrller
        ApexPages.StandardController std = new ApexPages.StandardController(agency);

        // instantiate the extension class (shape controller)
        PBS_AAAP_AgencyRequirementShape testAgReqShape = new PBS_AAAP_AgencyRequirementShape(std);

        System.assertEquals(agency.Id, testAgReqShape.agncyID);
        System.assertEquals(agency, testAgReqShape.currentObj);
        System.assertEquals(true, (testAgReqShape.shape != 'false'));        // at this instance, there isn't any shape data to render


        // test the backToAgncyReq method
        testAgReqShape.polyName = 'test poly name';
        String altName = 'alt test poly name';
        String agncyReqEdit = testAgReqShape.backToAgncyReq().getUrl();
        System.assertEquals(agncyReqEdit, '/apex/pbs_aaap_agencyrequirementedit?id=' + testAgReqShape.agncyID + '&polyId=' + pObject.Id + '&polyName=test%2Bpoly%2Bname');

        // test the cancelBackToAgencyReq method
        agncyReqEdit = testAgReqShape.cancelBackToAgncyReq().getUrl();
        System.assertEquals(agncyReqEdit, '/apex/pbs_aaap_agencyrequirementedit?id=' + testAgReqShape.agncyID + '&polyId=' + pObject.Id + '&polyName=test%2Bpoly%2Bname');

        // test the savePoly method (new polygon creation) will fail for no poly name
        List<String> testSave = PBS_AAAP_AgencyRequirementShape.savePoly(testAgReqShape.agncyID, '', 'polygon', '', paths, '0.00','true','false');
        System.assertEquals('failed', testSave.get(0));
        System.assertEquals('Please enter a shape name.', testSave.get(1));

        // test that the shape is saved
        testSave = PBS_AAAP_AgencyRequirementShape.savePoly(testAgReqShape.agncyID, '', 'polygon', testAgReqShape.polyName, paths, '0.00','true','false');
        System.assertEquals('success', testSave.get(0));

        // pass in the previously created ID but with modified poly paths and name
        List<String> testSave1 = PBS_AAAP_AgencyRequirementShape.savePoly(testAgReqShape.agncyID, testSave.get(1), 'polygon', altName, paths1, '0.00','true','false');
        System.assertEquals('success', testSave1.get(0));

        // test that the method fails when no name is given
        List<String> testSave2 = PBS_AAAP_AgencyRequirementShape.savePoly(testAgReqShape.agncyID, testSave.get(1), 'polygon', '', paths1, '0.00','true','false');
        System.assertEquals('failed', testSave2.get(0));
        System.assertEquals('Please enter a shape name.', testSave2.get(1));

        // create an agency requirement shape controller for pre-exsisting poly objects
        pageRef.getParameters().put('polyId', testSave.get(1));
        pageRef.getParameters().put('polyName', altName);
        Test.setCurrentPage(pageRef);
        testAgReqShape = new PBS_AAAP_AgencyRequirementShape(std);
        System.debug('%%%%% testSave: ' + testSave);
        System.debug('%%%%% testSave1: ' + testSave1);
        System.debug('%%%%% testSave2: ' + testSave2);
        System.debug('%%%%% testAgReqShape.polyShape.Id: ' + testAgReqShape.polyShape.Id);
        System.assertEquals(testSave.get(1), testAgReqShape.polyShape.Id);
        System.assertEquals(altName, testAgReqShape.polyName);

        // Test Remote method
        String retURL = PBS_AAAP_AgencyRequirementShape.backToAgncyReq('AgReq0001', 'PolyID001', 'PolyNameTest');
        
        PBS_AAAP_PolyObject__c pObject1 = new PBS_AAAP_PolyObject__c();
        pObject1.Polygon_Type__c = 'User Defined';
        pObject1.PBS_AAAP_legacy_id__c = '';
        pObject1.PBS_AAAP_Shape_Type__c = 'circle';
        pObject1.PBS_AAAP_Circle_Radius__c = 26400.7786;
        pObject1.PBS_AAAP_Agency_Requirement__c = agency.Id;
        pObject1.Name = 'atlanta1';
        insert pObject1;
        
        testAgReqShape.getFavoritePolys(); 
        testAgReqShape.pId = pObject1.id;       
        testAgReqShape.gotoFav();
        PBS_AAAP_AgencyRequirementShape.Polygon wrapperobj = new PBS_AAAP_AgencyRequirementShape.Polygon();
        testAgReqShape.selectedFavPoly = null;

    } // end myUnitTest

} // end test class