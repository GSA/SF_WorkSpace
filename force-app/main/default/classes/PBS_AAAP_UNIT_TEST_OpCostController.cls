@IsTest
private class PBS_AAAP_UNIT_TEST_OpCostController {
    static testMethod void myUnitTest() {
        // create the test data defaults
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(dataGen.testOffer.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        PBS_AAAP_RLP__c testRlp = dao.getRLP(dataGen.testOffer.PBS_AAAP_RLP_NUMBER__c);
        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();        // instance of calculations class

        PBS_AAAP_QuestionLabels qLables = new PBS_AAAP_QuestionLabels();
        // create page contexts for testing purposes
        PageReference operatingCosts = Page.PBS_AAAP_OperatingCosts;

        operatingCosts.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(operatingCosts);            // set the current page reference to operating costs
        PBS_AAAP_OperatingCostController opcont = new PBS_AAAP_OperatingCostController();
        opcont.pageUrl = '/test';
        System.assertEquals(opcont.offer.Id, testOffer.Id);            // validate that the controller obtains the correct offer
        System.assertEquals(opcont.isValidUser, true);
        // test the calculation for Building Common Area Factor
        Double testBcaf = calc.getBCAF(testOffer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c.doubleValue(), testOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c.doubleValue()).setScale(2);
        System.assertEquals(2.39, testBcaf);

        // validate that the fuel type and fuel type options are correctly returned
        System.assert(opcont.getFuelTypeOpts().size() > 0, 'Fuel Type select options not populating.');
        opcont.FuelType = 'Test Fuel Type';
        System.assertEquals(opcont.getFuelType(), opcont.FuelType);


        // validate that the controller obtains the correct offer data
        System.assertEquals(opcont.getOffer().Id, testOffer.Id);                    // offer is returned

        // validate the soql returns the other costs
        List<PBS_AAAP_Other_Costs__c> testOC = new List<PBS_AAAP_Other_Costs__c>();            // the data generator creates a total of four other cost records associated with the test offer
        Set<String> testOCIds = new Set<String>();                                                // the set of test OC Ids
        testOC.addAll(dataGen.testOtherCosts);                                                                                    // the test list of other costs from data generator
        testOC.add(dataGen.testOtherCost);                                                                                            // the test other costs singleton from data generator

        //  create the set of oc IDs for comparison
        for (PBS_AAAP_Other_Costs__c ocids : testOC) {
            testOCIds.add(ocids.Id);
        }    // end for

        // compare the test oc IDs with the data retruned from the soql call
        List<PBS_AAAP_Other_Costs__c> testOCFromSoql = opcont.soqlGetOtherCosts(testOffer.Id);
        for (PBS_AAAP_Other_Costs__c tocids : testOCFromSoql) {
            System.assert(testOCIds.contains(tocids.Id));
        }

        // update the other costs on the offer
        testOtherCost.PBS_AAAP_SHORT_DESC__c = 'Test Other Cost';
        testOtherCost.PBS_AAAP_COST__c = 45.00;
        opcont.OthercostAmt = String.valueOf(testOtherCost.PBS_AAAP_COST__c);
        opcont.setOtherCost(testOtherCost);
        opcont.addOtherCosts();

        // verify that the other cost data is returned when requested by the getOtherCost method
        System.assertEquals(opcont.getOtherCost().Id, testOtherCost.Id);

        // need to reload the OC ids, since the addOtherCosts() method added another cost to the mix
        testOCFromSoql = opcont.soqlGetOtherCosts(testOffer.Id);
        for (PBS_AAAP_Other_Costs__c ocids : testOCFromSoql) {
            testOCIds.add(ocids.Id);
        }    // end for

        // verify that the "costs" variable data is returned after the controller adds the other costs obtained from the soql call to the variable
        List<PBS_AAAP_Other_Costs__c> testOCFromGetCosts = opcont.getCosts();
        System.debug('***** testOCFromSoql: ' + testOCFromSoql);
        System.debug('***** testOCIds: ' + testOCIds);
        for (PBS_AAAP_Other_Costs__c testCost : testOCFromGetCosts) {
            System.assert(testOCIds.contains(testCost.Id));
        }    // end for

        System.assertEquals(opcont.getTotOtherCosts(), testOtherCost.PBS_AAAP_COST__c + 1);                                                                                    // the test offer was seeded with a 1.00 total other cost, so we must account for that with the +1
        System.assertEquals(opcont.offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c, testOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);                // USF Offered must be greater than 0 in the test data for this assertion to work
        System.assertEquals(opcont.offer.PBS_AAAP_RU_FACTOR__c, testBcaf);

        //assertQlables testing added by syam
        System.debug('opCostsPgHdr is **** ' + opcont.qLabels.opCostsPgHdr);
        //System.assertEquals(opcont.qLabels.opCostsPgHdr, 'Operating & Ownership Costs');
        testQlables(opcont);


        // verify that the other cost matrix table data is loaded
        Set<String> ocDetailsIds = new Set<String>();
        for (PBS_AAAP_OperatingCostController.OtherCostsDetails ocd : opcont.getOcDetails()) {
            ocDetailsIds.add(ocd.costId);
        }    // end for

        for (PBS_AAAP_Other_Costs__c ocids : opcont.getCosts()) {
            System.assert(ocDetailsIds.contains(ocids.id), '**** ocids.id: ' + ocids.id + ' not in the set: ' + ocDetailsIds);    // should match to what is returned from the getCosts() method
        }    // end for

        // verify that the action to remove a selected other cost from the system functions correctly
        String idToRemove = '';
        for (PBS_AAAP_OperatingCostController.OtherCostsDetails ocdRem : opcont.getOcDetails()) {
            if (ocdRem.description == testOtherCost.PBS_AAAP_SHORT_DESC__c) {
                idToRemove = testOtherCost.Id;
                ocdRem.removal = true;
            }
        }

        opcont.remSelOperCosts();        // remove the cost
        List<PBS_AAAP_Other_Costs__c> testRemOcs = opcont.getCosts();        // costs are updated by the remove action, so we can verify the action by validating that the costs no longer contain the removed cost ID
        System.debug('***** testRemOcs: ' + testRemOcs);
        for (PBS_AAAP_Other_Costs__c remCost : testRemOcs) {
            System.assertNotEquals(remCost.Id, idToRemove);        // no record in the costs should contain the ID that was removed from the system.
        }
        // verify that the fuel type can be set by the controller
        opcont.setFuelType('testomatic');
        System.assertEquals(opcont.getFuelType(), 'testomatic');

        // verify that the action to invoke the "other costs" page actually returns the other cost page
        PageReference pgOCost = Page.PBS_AAAP_OtherCosts;
        //System.assertEquals(opcont.oCosts().getUrl(), pgOCost.getUrl());

        // verify that the action to invoke the "add other costs" returns the operating costs page
        PageReference pgOpCost = Page.PBS_AAAP_OperatingCosts;
        pgOpCost.getParameters().put('offerId', testOffer.Id);                // must add the offerid to the URL
        //System.assertEquals(opcont.addOperatingCosts().getUrl(), pgOpCost.getUrl());

        // verify that the action to invoke the "continue and save" returns the spaces and rates page
        PageReference pgSpaceAndRates = Page.PBS_AAAP_SpacesAndRates;
        pgSpaceAndRates.getParameters().put('offerId', testOffer.Id);                // must add the offerid to the URL

        // verify that the action to delete the offer removes the offer
        PageReference portalHome = Page.PBS_AAAP_PortalHome;
        opcont.actionDeleteOffer();
        //System.assertEquals(opcont.actionDeleteOffer().getUrl(), portalHome.getUrl());        // action should return you to the portal home page
        try {
            PBS_AAAP_Offer__c offer = [SELECT o.Id FROM PBS_AAAP_Offer__c o WHERE o.Id = :testOffer.Id];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));            // offer shouldn't exist, so an exception should occur
        }

        PageReference pref = opcont.back();
        system.assertEquals(null, pref);
        pref = opcont.actionCancel();
        system.assertNotEquals(null, pref);
    }

    private static void testQlables(PBS_AAAP_OperatingCostController opcont) {
        System.debug('opCostsPgHdr is **** ' + opcont.qLabels.opCostsPgHdr);
        System.assert(opcont.qLabels.opCostsQ1.length() > 0);
        System.assert(opcont.qLabels.opCostsQ2.length() > 0);
        System.assert(opcont.qLabels.opCostsQ3.length() > 0);
        System.assert(opcont.qLabels.opCostsQ4.length() > 0);
        System.assert(opcont.qLabels.opCostsQ5.length() > 0);
        System.assert(opcont.qLabels.opCostsQ6.length() > 0);
        System.assert(opcont.qLabels.opCostsQ7.length() > 0);
        System.assert(opcont.qLabels.opCostsQ8.length() > 0);
        System.assert(opcont.qLabels.opCostsQ9.length() > 0);
        System.assert(opcont.qLabels.opCostsQ10.length() > 0);
        System.assert(opcont.qLabels.opCostsQ11.length() > 0);
        System.assert(opcont.qLabels.opCostsQ12.length() > 0);
        System.assert(opcont.qLabels.opCostsQ13.length() > 0);
        System.assert(opcont.qLabels.opCostsQ14.length() > 0);
        System.assert(opcont.qLabels.opCostsQ15.length() > 0);
        System.assert(opcont.qLabels.opCostsQ16.length() > 0);
        System.assert(opcont.qLabels.opCostsQ17.length() > 0);
        System.assert(opcont.qLabels.opCostsQ18.length() > 0);
        System.assert(opcont.qLabels.opCostsQ19.length() > 0);
        System.assert(opcont.qLabels.opCostsQ20.length() > 0);
        System.assert(opcont.qLabels.opCostsQ21.length() > 0);
        System.assert(opcont.qLabels.opCostsQ22.length() > 0);
        System.assert(opcont.qLabels.opCostsQ23.length() > 0);
        System.assert(opcont.qLabels.opCostsQ24.length() > 0);
        System.assert(opcont.qLabels.opCostsQ25.length() > 0);
        System.assert(opcont.qLabels.opCostsQ26.length() > 0);
        System.assert(opcont.qLabels.opCostsQ27.length() > 0);
        System.assert(opcont.qLabels.opCostsQ28.length() > 0);
        System.assert(opcont.qLabels.opCostsQ29.length() > 0);
        System.assert(opcont.qLabels.opCostsQ30.length() > 0);
        System.assert(opcont.qLabels.opCostsQ31.length() > 0);
        System.assert(opcont.qLabels.opCostsQ32.length() > 0);
        System.assert(opcont.qLabels.opCostsQ33.length() > 0);

        System.assert(opcont.qLabels.spaceQ1.length() > 0);
        System.assert(opcont.qLabels.spaceQ2.length() > 0);
        System.assert(opcont.qLabels.spaceQ3New.length() > 0);
        System.assert(opcont.qLabels.spaceQ3Succ.length() > 0);
        System.assert(opcont.qLabels.spaceQ4New.length() > 0);
        System.assert(opcont.qLabels.spaceQ4Succ.length() > 0);
        System.assert(opcont.qLabels.spaceQ5.length() > 0);
        System.assert(opcont.qLabels.spaceQ6.length() > 0);
        System.assert(opcont.qLabels.spaceQ7.length() > 0);
        System.assert(opcont.qLabels.spaceQ8.length() > 0);
        System.assert(opcont.qLabels.spaceQ9.length() > 0);
        System.assert(opcont.qLabels.spaceQ10.length() > 0);
        System.assert(opcont.qLabels.spaceQ10Tot.length() > 0);

        System.assert(opcont.qLabels.ratesQ1.length() > 0);
        System.assert(opcont.qLabels.ratesQ2.length() > 0);
        System.assert(opcont.qLabels.ratesQ3New.length() > 0);
        System.assert(opcont.qLabels.ratesQ3Succ.length() > 0);
        System.assert(opcont.qLabels.ratesQBSACRateNew.length() > 0);
        System.assert(opcont.qLabels.ratesQBSACRateSucc.length() > 0);
        System.assert(opcont.qLabels.ratesQBSACPmtNew.length() > 0);
        System.assert(opcont.qLabels.ratesQBSACPmtSucc.length() > 0);
        System.assert(opcont.qLabels.ratesQ4New.length() > 0);
        System.assert(opcont.qLabels.ratesQ4Succ.length() > 0);
        System.assert(opcont.qLabels.ratesQ5New.length() > 0);
        System.assert(opcont.qLabels.ratesQ5Succ.length() > 0);
        System.assert(opcont.qLabels.ratesQ6.length() > 0);
        System.assert(opcont.qLabels.ratesQ7New.length() > 0);
        System.assert(opcont.qLabels.ratesQ7Succ.length() > 0);
        System.assert(opcont.qLabels.ratesQ8.length() > 0);
        System.assert(opcont.qLabels.ratesQ9.length() > 0);
        System.assert(opcont.qLabels.ratesQ10New.length() > 0);
        System.assert(opcont.qLabels.ratesQ10Succ.length() > 0);
        System.assert(opcont.qLabels.ratesQ10a.length() > 0);
        System.assert(opcont.qLabels.ratesQ10b.length() > 0);
        System.assert(opcont.qLabels.ratesQ11New.length() > 0);
        System.assert(opcont.qLabels.ratesQ11Succ.length() > 0);
        System.assert(opcont.qLabels.ratesQ12.length() > 0);
        System.assert(opcont.qLabels.ratesCol1.length() > 0);
        System.assert(opcont.qLabels.ratesCol2.length() > 0);
        System.assert(opcont.qLabels.ratesCol3.length() > 0);
        System.assert(opcont.qLabels.notation.length() > 0);
        System.assert(opcont.qLabels.validationMust.length() > 0);
        System.assert(opcont.qLabels.opCostsSubSectOne.length() > 0);
        System.assert(opcont.qLabels.opCostsSubSectTwo.length() > 0);
        System.assert(opcont.qLabels.opCostsSubSectThree.length() > 0);
        System.assert(opcont.qLabels.opCostsSubSectFour.length() > 0);
        System.assert(opcont.qLabels.opCostsSubSectFive.length() > 0);
        System.assert(opcont.qLabels.opCostsSubSectSix.length() > 0);
        System.assert(opcont.qLabels.opCostsSubSectSeven.length() > 0);
        System.assert(opcont.qLabels.opCostsSectOneHdr.length() > 0);
        System.assert(opcont.qLabels.opCostsSectTwoHdr.length() > 0);
        System.assert(opcont.qLabels.otherCostsQ1.length() > 0);
        System.assert(opcont.qLabels.otherCostsQ2.length() > 0);
        System.assert(opcont.qLabels.otherCostsTableColOne.length() > 0);
        System.assert(opcont.qLabels.otherCostsTableColTwo.length() > 0);
        System.assert(opcont.qLabels.otherCostsTableColThree.length() > 0);
        System.assert(opcont.qLabels.otherTotOtherCostTxt.length() > 0);

    }
    
    static testMethod void myUnitTest1() {
         
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id); 
               
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();      
        testOtherCost.PBS_AAAP_SHORT_DESC__c = 'Test Other Cost';
        testOtherCost.PBS_AAAP_COST__c = 0;
        
        testOtherCost.PBS_AAAP_COST_TYPE__c = 'rr';
        testOtherCost.PBS_AAAP_OFFER_NUMBER__c = testOffer.id;
        insert testOtherCost;
        
        PBS_AAAP_OperatingCostController opcont = new PBS_AAAP_OperatingCostController();
        opcont.otherCost = testOtherCost;

        opcont.offer = testOffer;
        opcont.offer.PBS_AAAP_Offer_Status__c =PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        testOffer.PBS_AAAP_Vacant_Premise_Rate__c = null;
        opcont.continueSave();
        opcont.saveForm();
     }
     
    static testMethod void myUnitTest2() {
        // create the test data defaults
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(dataGen.testOffer.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        PBS_AAAP_RLP__c testRlp = dao.getRLP(dataGen.testOffer.PBS_AAAP_RLP_NUMBER__c);
        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();        // instance of calculations class

        PBS_AAAP_QuestionLabels qLables = new PBS_AAAP_QuestionLabels();
        // create page contexts for testing purposes
        PageReference operatingCosts = Page.PBS_AAAP_OperatingCosts;

        operatingCosts.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(operatingCosts);            // set the current page reference to operating costs
        PBS_AAAP_OperatingCostController opcont = new PBS_AAAP_OperatingCostController();
        System.assertEquals(opcont.offer.Id, testOffer.Id);            // validate that the controller obtains the correct offer
        System.assertEquals(opcont.isValidUser, true);
        // test the calculation for Building Common Area Factor
        Double testBcaf = calc.getBCAF(testOffer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c.doubleValue(), testOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c.doubleValue()).setScale(2);
        System.assertEquals(2.39, testBcaf);

        opcont.OthercostAmt = '10,222';

        // validate that the fuel type and fuel type options are correctly returned
        System.assert(opcont.getFuelTypeOpts().size() > 0, 'Fuel Type select options not populating.');
        opcont.FuelType = 'Test Fuel Type';
        System.assertEquals(opcont.getFuelType(), opcont.FuelType);

                
        // validate that the controller obtains the correct offer data
        System.assertEquals(opcont.getOffer().Id, testOffer.Id);                    // offer is returned

        // validate the soql returns the other costs
        List<PBS_AAAP_Other_Costs__c> testOC = new List<PBS_AAAP_Other_Costs__c>();            // the data generator creates a total of four other cost records associated with the test offer
        Set<String> testOCIds = new Set<String>();                                                // the set of test OC Ids
        testOC.addAll(dataGen.testOtherCosts);                                                                                    // the test list of other costs from data generator
        testOC.add(dataGen.testOtherCost);                                                                                            // the test other costs singleton from data generator
        
        opcont.costs = testOC;
        
        //  create the set of oc IDs for comparison
        for (PBS_AAAP_Other_Costs__c ocids : testOC) {
            testOCIds.add(ocids.Id);
        }    // end for

        // compare the test oc IDs with the data retruned from the soql call
        List<PBS_AAAP_Other_Costs__c> testOCFromSoql = opcont.soqlGetOtherCosts(testOffer.Id);
        for (PBS_AAAP_Other_Costs__c tocids : testOCFromSoql) {
            System.assert(testOCIds.contains(tocids.Id));
        }    // end for

        // update the other costs on the offer
        testOtherCost.PBS_AAAP_SHORT_DESC__c = 'Test Other Cost';
        testOtherCost.PBS_AAAP_COST__c = 45.00;
        opcont.setOtherCost(testOtherCost);
        opcont.addOtherCosts();
        opcont.otherCost.PBS_AAAP_SHORT_DESC__c = '';
        opcont.addOtherCosts();
		
        // verify that the other cost data is returned when requested by the getOtherCost method
        System.assertEquals(opcont.getOtherCost().Id, testOtherCost.Id);

        // need to reload the OC ids, since the addOtherCosts() method added another cost to the mix
        testOCFromSoql = opcont.soqlGetOtherCosts(testOffer.Id);
        for (PBS_AAAP_Other_Costs__c ocids : testOCFromSoql) {
            testOCIds.add(ocids.Id);
        }    // end for

        // verify that the "costs" variable data is returned after the controller adds the other costs obtained from the soql call to the variable
        List<PBS_AAAP_Other_Costs__c> testOCFromGetCosts = opcont.getCosts();
        System.debug('***** testOCFromSoql: ' + testOCFromSoql);
        System.debug('***** testOCIds: ' + testOCIds);
        for (PBS_AAAP_Other_Costs__c testCost : testOCFromGetCosts) {
            System.assert(testOCIds.contains(testCost.Id));
        }    // end for

        System.assertEquals(opcont.getTotOtherCosts(), testOtherCost.PBS_AAAP_COST__c + 1);                                                                                    // the test offer was seeded with a 1.00 total other cost, so we must account for that with the +1
        System.assertEquals(opcont.offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c, testOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);                // USF Offered must be greater than 0 in the test data for this assertion to work
        System.assertEquals(opcont.offer.PBS_AAAP_RU_FACTOR__c, testBcaf);
        System.debug('opCostsPgHdr is **** ' + opcont.qLabels.opCostsPgHdr);
        testQlables(opcont);


        // verify that the other cost matrix table data is loaded
        Set<String> ocDetailsIds = new Set<String>();
        for (PBS_AAAP_OperatingCostController.OtherCostsDetails ocd : opcont.getOcDetails()) {
            ocDetailsIds.add(ocd.costId);
        }    // end for

        for (PBS_AAAP_Other_Costs__c ocids : opcont.getCosts()) {
            System.assert(ocDetailsIds.contains(ocids.id), '**** ocids.id: ' + ocids.id + ' not in the set: ' + ocDetailsIds);    // should match to what is returned from the getCosts() method
        }    // end for

        // verify that the action to remove a selected other cost from the system functions correctly
        String idToRemove = '';
        for (PBS_AAAP_OperatingCostController.OtherCostsDetails ocdRem : opcont.getOcDetails()) {
            if (ocdRem.description == testOtherCost.PBS_AAAP_SHORT_DESC__c) {
                idToRemove = testOtherCost.Id;
                ocdRem.removal = true;
            }
        }

        opcont.remSelOperCosts();        // remove the cost
        List<PBS_AAAP_Other_Costs__c> testRemOcs = opcont.getCosts();        // costs are updated by the remove action, so we can verify the action by validating that the costs no longer contain the removed cost ID
        System.debug('***** testRemOcs: ' + testRemOcs);
        for (PBS_AAAP_Other_Costs__c remCost : testRemOcs) {
            System.assertNotEquals(remCost.Id, idToRemove);        // no record in the costs should contain the ID that was removed from the system.
        }
        // verify that the fuel type can be set by the controller
        opcont.setFuelType('testomatic');
        System.assertEquals(opcont.getFuelType(), 'testomatic');

        // verify that the action to invoke the "other costs" page actually returns the other cost page
        PageReference pgOCost = Page.PBS_AAAP_OtherCosts;
        //System.assertEquals(opcont.oCosts().getUrl(), pgOCost.getUrl());

        // verify that the action to invoke the "add other costs" returns the operating costs page
        PageReference pgOpCost = Page.PBS_AAAP_OperatingCosts;
        pgOpCost.getParameters().put('offerId', testOffer.Id);                // must add the offerid to the URL
        //System.assertEquals(opcont.addOperatingCosts().getUrl(), pgOpCost.getUrl());

        // verify that the action to invoke the "continue and save" returns the spaces and rates page
        PageReference pgSpaceAndRates = Page.PBS_AAAP_SpacesAndRates;
        pgSpaceAndRates.getParameters().put('offerId', testOffer.Id);                // must add the offerid to the URL
        // verify that the action to delete the offer removes the offer
        PageReference portalHome = Page.PBS_AAAP_PortalHome;
            
         opcont.actionDeleteOffer();
        opcont.offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        opcont.actionDeleteOffer();
        //System.assertEquals(opcont.actionDeleteOffer().getUrl(), portalHome.getUrl());        // action should return you to the portal home page
        try {
            PBS_AAAP_Offer__c offer = [SELECT o.Id FROM PBS_AAAP_Offer__c o WHERE o.Id = :testOffer.Id];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));            // offer shouldn't exist, so an exception should occur
        }

        PageReference pref = opcont.back();
        system.assertEquals(null, pref);
        pref = opcont.actionCancel();
        system.assertNotEquals(null, pref);
    }
    
    static testMethod void myUnitTest3() {
         
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id); 
        PBS_AAAP_RLP__c testRlp = dao.getRLP(dataGen.testOffer.PBS_AAAP_RLP_NUMBER__c);
        testOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c = 100;
        testOffer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 10;
        
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();      
        testOtherCost.PBS_AAAP_SHORT_DESC__c = 'Test Other Cost';
        testOtherCost.PBS_AAAP_COST__c = 0;
        
        testOtherCost.PBS_AAAP_COST_TYPE__c = 'rr';
        testOtherCost.PBS_AAAP_OFFER_NUMBER__c = testOffer.id;
        insert testOtherCost;
        
        PBS_AAAP_OperatingCostController opcont = new PBS_AAAP_OperatingCostController();
        opcont.otherCost = testOtherCost;
        opcont.offer = testOffer;
        
        testOffer.PBS_AAAP_Vacant_Premise_Rate__c = null;
        opcont.continueSave();

        testOffer.PBS_AAAP_Vacant_Premise_Rate__c = 5;
        opcont.continueSave();

        opcont.oCosts();
        opcont.addOperatingCosts();
        opcont.saveForm();
        System.assertEquals(testOffer.PBS_AAAP_Vacant_Premise_Rate__c, 5);
    }

    static testMethod void myUnitTest4() {
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c = 100;
        testOffer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 10;

        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        testOtherCost.PBS_AAAP_SHORT_DESC__c = 'Test Other Cost';
        testOtherCost.PBS_AAAP_COST__c = 0;

        testOtherCost.PBS_AAAP_COST_TYPE__c = 'rr';
        testOtherCost.PBS_AAAP_OFFER_NUMBER__c = testOffer.id;
        insert testOtherCost;

        PBS_AAAP_OperatingCostController opcont = new PBS_AAAP_OperatingCostController();
        opcont.otherCost = testOtherCost;
        opcont.offer = testOffer;
        testOffer.PBS_AAAP_Vacant_Premise_Rate__c = null;
        opcont.RLPisCensus = true;
        opcont.saveForm();
        opcont.continueSave();
        opcont.getOcDetails();

        testOffer.PBS_AAAP_Vacant_Premise_Rate__c = 5;
        opcont.continueSave();

        opcont.oCosts();
        opcont.addOperatingCosts();
        
        opcont.offer.PBS_AAAP_COST_PER_ABOA__c = 0.50;
        opcont.offer.PBS_AAAP_Vacant_Premise_Rate__c = null;
        opcont.saveForm();
        opcont.continueSave();
    }
    
    @isTest static void setupTestData() {
        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c(PBS_AAAP_TOTAL_OTHER_COSTS__c = 1000.00,PBS_AAAP_SRVC_UTIL_TOTAL__c = 5000.00,PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 2000.00);
        insert offer;
        
        List<PBS_AAAP_Other_Costs__c> otherCosts = new List<PBS_AAAP_Other_Costs__c>();
        for (Integer i = 0; i < 3; i++) {
            otherCosts.add(new PBS_AAAP_Other_Costs__c(Name = 'Test Cost ' + i,PBS_AAAP_COST__c = 100.00, PBS_AAAP_OFFER_NUMBER__c  = offer.Id, PBS_AAAP_COST_TYPE__c = 'rr', PBS_AAAP_SHORT_DESC__c = 'Test Other Cost'));
        }
        insert otherCosts;
        
        ApexPages.currentPage().getParameters().put('edit','false');
        PBS_AAAP_OperatingCostController opcont = new PBS_AAAP_OperatingCostController();
        opcont.offer = offer;
        opcont.offerId = offer.Id;
        Test.startTest();
        opcont.remSelOperCosts();
        opcont.performCalc();
        Test.stopTest();
    }

}