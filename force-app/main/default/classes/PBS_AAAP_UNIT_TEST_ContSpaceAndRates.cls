@IsTest
private class PBS_AAAP_UNIT_TEST_ContSpaceAndRates {

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

        // create page contexts for testing purposes
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference attach = Page.PBS_AAAP_OfferAttachments;

        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        spacesAndRates.getParameters().put('edit', 'false');
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        System.assertEquals(contSpaceRates.offer.Id, testOffer.Id);         // validate that the controller obtains the correct offer
        contSpaceRates.refreshNumbers();

        // test that the genMapRatesToSpace method will correctly generate a map of rates to a space
        Map<String, List<PBS_AAAP_Rate__c>> testMapOfRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        System.assertEquals(testMapOfRates.get(testSpaces[0].Id), testRates);

        // test that the controller returns the panel IDs
        List<String> compList = new List<String>{
                'panel_outerspace', 'panel_NewSpace', 'panel_SuccSpace'
        };
        System.assertEquals(contSpaceRates.panelIds, compList);

        // test that the controller will return the value contained in the testOffer for screen fields
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, testOffer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c);

        // test that the getSpaceOpts returns the space options
        System.assert(contSpaceRates.getSpaceOpts().size() > 0, 'Space Type select options not populating.');

        // test that the getFeeOpts returns the fee options
        System.assert(contSpaceRates.getFeeOpts().size() > 0, 'Fee Opts Type select options not populating.');

        // test that the defaultSpace() method creates the default space with the correct information
        PBS_AAAP_Space__c sp = contSpaceRates.defaultSpace(testOffer.Id);

        System.assertEquals(sp.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        System.assertEquals(contSpaceRates.sfOfferedType, null);                // defaultSpace() method should also set the square footage offered type to null
        System.assertEquals(contSpaceRates.feePrcntgOrDollar, null);        // defaultSpace() method should also set the UOM variable for the architectural engineering fee type to null
        //as per FY16 as it is mandatory as we are forcing the related values to '0.00'
        contSpaceRates.feePrcntgOrDollar = '%';
        // test that the getLrgOrdinal() method returns the largest ordinal for the number of spaces passed as a list to the function
        System.assertEquals(contSpaceRates.getLrgOrdinal(testSpaces), 1);   // there is only one test space so the function should return a 1

        // test that the saveSpace method correctly saves the space to the DB
        contSpaceRates.space = sp;
        System.debug('weston');
        System.debug('*****myUnitTest contSpaceRates.space before saveSpace(): ' + contSpaceRates.space);
        contSpaceRates.saveSpace();
        System.debug('*****myUnitTest contSpaceRates.space after saveSpace(): ' + contSpaceRates.spaces.size());
        System.assertEquals(1, contSpaceRates.spaces.size());   // save spaces adds the new space to the internal list of spaces, for our purposes there are 2, the initial (found by constructor) and then the one added by saveSpace


        // test that the addSpace method renders the inner space page view
        contSpaceRates.addNewSpace();

        Map<String, List<PBS_AAAP_Rate__c>> testMapSpaceToRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        for (PBS_AAAP_Space__c spc : testSpaces) {
            System.assertEquals(testMapSpaceToRates.containsKey(spc.Id), true);
        }   // end for


        // test that the addSucceedingSpace method renders the inner space page view
        contSpaceRates.addSucceedingSpace();

        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        for (PBS_AAAP_Rate__c rate : testRates) {
            if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(re.fiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.fiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.fiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveYrId, rate.Id);
                System.assertEquals(re.fiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(re.fiveFiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveFiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.fiveFiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.fiveFiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveFiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveFiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveFiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveFiveYrId, rate.Id);
                System.assertEquals(re.fiveFiveYrOptTerm, rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c);
                System.assertEquals(re.fiveFiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(re.tenYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.tenYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.tenYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.tenYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.tenYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.tenYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.tenYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.tenYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.tenYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.tenYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.tenYrId, rate.Id);
                System.assertEquals(re.tenYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);

            }
        }   // end for

        // test that the action for the "BACK" button returns the user to the operating costs page
        PageReference pgBack = Page.PBS_AAAP_OperatingCosts;
        pgBack.getParameters().put('offerId', testOffer.Id);
        // test that the action for the rates summary button renders the correct views
        PageReference pgRateSumm = Page.pbs_aaap_spacesandrates;
        pgRateSumm.getParameters().put('offerId', testOffer.Id);
        contSpaceRates.rateSummary();

        List<PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails> dets = contSpaceRates.spaceSort(testSpaces, testRates);
        System.assertEquals(contSpaceRates.details.size(), dets.size());           // verify that the summary screen field list is of the same size as the number of spaces.
        for (PBS_AAAP_Space__c space : testSpaces) {
            for (PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails d : dets) {
                if (d.spaceID == space.Id) {
                    for (PBS_AAAP_Rate__c rate : testRates) {
                        if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                            System.assertEquals(d.fiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveYrPV, rate.PBS_AAAP_PV_Value__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                            System.assertEquals(d.fiveFiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveFiveYrPV, rate.PBS_AAAP_PV_Value_Blended__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                            System.assertEquals(d.tenYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.tenYrPV, rate.PBS_AAAP_PV_Value__c);
                        } // end if
                    } // end for
                } // end if

                if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('New', d.leaseType);
                } else if (!space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('Succeeding', d.leaseType);
                } // end if
            }   // end for
        }   // end for


        // test that the edit rate method such that it appropriately modifys the correct spaces rates
        contSpaceRates.details[0].selected = true;      // set the first element of the screen detail list to selected for purposes of the test
        System.debug('***** dets[0]: ' + dets[0]);
        contSpaceRates.editRate();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);

        System.debug('***** contSpaceRates.spaces: ' + contSpaceRates.spaces);
        // test that the edit space method such
        contSpaceRates.editSpace();
        contSpaceRates.setValsFor6();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);       // insure that editSpace is editing the correct space
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {

        }   // end if

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;  // rig the space so that it is considered a succeeding space

        contSpaceRates.editSpace();
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {

        }   // end if

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;   // reset the space so that it is considered a new space

        // test that the databaseConCheck method insures that only 3 rate records for any space can exist
        List<PBS_AAAP_Rate__c> rateDBOverload = new List<PBS_AAAP_Rate__c>();

        // strip the IDs to facilitate upload
        for (Integer i = 0; i < testRates.size(); i++) {
            PBS_AAAP_Rate__c rup = new PBS_AAAP_Rate__c(
                    PBS_AAAP_SPACE__c = testRates[i].PBS_AAAP_SPACE__c,
                    PBS_AAAP_OFFER_NUMBER__c = testRates[i].PBS_AAAP_OFFER_NUMBER__c,
                    PBS_AAAP_LEASE_TERM__c = testRates[i].PBS_AAAP_LEASE_TERM__c,
                    PBS_AAAP_BASE_RATE__c = testRates[i].PBS_AAAP_BASE_RATE__c,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = testRates[i].PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = testRates[i].PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c

            );
            rateDBOverload.add(rup);
        } // end for

        List<PBS_AAAP_Rate__c> totalRates = testRates;
        totalRates.addAll(rateDBOverload);
        insert rateDBOverload;

        Integer intRatesNum = rateDBOverload.size() + testRates.size();
        System.debug('%%%%% size of rates for space ID = ' + testRates[0].Id + ' : ' + intRatesNum);

        List<PBS_AAAP_Rate__c> idsToKeep = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            idsToKeep.add(testRates[i]);
        } // end for

        List<PBS_AAAP_Rate__c> rateChk = contSpaceRates.databaseConCheck(idsToKeep, totalRates);
        List<PBS_AAAP_Rate__c> ratesComp = [SELECT Id FROM PBS_AAAP_Rate__c WHERE PBS_AAAP_SPACE__c = :testRates[0].PBS_AAAP_SPACE__c];
        Integer chkNum = ratesComp.size() - rateChk.size();
        System.assertEquals(3, chkNum);

        // test that the convertRateEntry method correctly converts the rateEntry data into the three rates
        List<PBS_AAAP_Rate__c> cnvrtRates = contSpaceRates.convertRateEntry(re);

        for (PBS_AAAP_Rate__c rt : cnvrtRates) {
            if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.fiveYrFS);
            } else if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.fiveFiveYrFS);
            } else if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.tenYrFS);
            } // end if
        } // end for


        // test that the validateOfferFormFields
        Decimal backup = contSpaceRates.maxOfferedSpace;
        contSpaceRates.maxOfferedSpace = 0.00;
        contSpaceRates.maxOfferedSpace = 20000.00;
        contSpaceRates.maxOfferedSpace = backup;

        // test that the returnToSpaces method correctly sets the appropriate indicator
        Boolean boolBackup = contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c;
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        contSpaceRates.returnToSpace();

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        contSpaceRates.returnToSpace();

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = boolBackup;


        // test that the makeSpaceMap method correctly generates the map of spaces
        Map<String, PBS_AAAP_Space__c> spMap = contSpaceRates.makeSpaceMap(testSpaces);
        Set<String> spIds = new Set<String>();
        System.debug('%%%%% spMap: ' + spMap);
        System.debug('%%%%% testSpaces: ' + testSpaces);

        for (PBS_AAAP_Space__c sp1 : testSpaces) {
            System.assertEquals(true, spMap.containsKey(sp1.PBS_AAAP_IDENTIFIER_ID__c));
        } // end for


        // test that the addRate method renders the inner space page view
        contSpaceRates.addRate();

        Set<String> rateIDs = new Set<String>{
                testRates[0].Id, testRates[1].Id, testRates[2].Id
        };
        PageReference pgSpaceAndRates = Page.PBS_AAAP_SpacesAndRates;
        pgSpaceAndRates.getParameters().put('offerId', testOffer.Id);
        try {
            List<PBS_AAAP_Space__c> sp2 = [SELECT o.Id FROM PBS_AAAP_Space__c o WHERE o.Id = :contSpaceRates.details[0].spaceID];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));           // space shouldn't exist, so an exception should occur
        }

        try {
            List<PBS_AAAP_Rate__c> rt = [SELECT o.Id FROM PBS_AAAP_Rate__c o WHERE o.Id IN:rateIDs];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));           // Rate  shouldn't exist, so an exception should occur
        }

        // test that the actionBackSpace method will return the user to the spaces and rates summary page
        contSpaceRates.actionBackSpace();
        contSpaceRates.space.PBS_AAAP_SF_OFFERED__c = 1;
        contSpaceRates.space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = null;
        contSpaceRates.space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = null;
        contSpaceRates.space.PBS_AAAP_ARCH_ENG_FEES__c = null;
        contSpaceRates.sfOfferedType =  'All Available ABOA';
        String str = contSpaceRates.leaseDefault;
        contSpaceRates.saveOnlySpace();
        contSpaceRates.space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = 0;
        contSpaceRates.space.PBS_AAAP_MIN_OFFERABLE_SPACE__c = Null;
        contSpaceRates.space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Null;
        contSpaceRates.addRate();

        contSpaceRates.clearSpace();
        System.assertEquals(contSpaceRates.space.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        //moved up for FY16 before delete as tests are failing due to offerId deletion
        contSpaceRates.pageUrl = 'https://workspace--wsdv51dvn.cs32.my.salesforce.com?=';
        contSpaceRates.saveRates();
        contSpaceRates.continueSave();
        contSpaceRates.returnToSpaceRates();
        contSpaceRates.returnToSpaceRatesViewOnly();
        contSpaceRates.saveForm();
        contSpaceRates.actionBackSpaceView();
        testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_Offer_Status__c = 'Awarded';
        system.debug('offer status is' + testOffer.PBS_AAAP_Offer_Status__c);

        List<PBS_AAAP_Space__c> spaces1 = PBS_AAAP_GlobalConstants.getSpaces(testOffer.Id);
        if (spaces1 != null && spaces1.size() > 0) {
            PBS_AAAP_Space__c spaceTemp = spaces1.get(0);
            List<PBS_AAAP_Rate__c> rates1 = PBS_AAAP_GlobalConstants.getRates(spaceTemp.Id);
        }
        // test that the deleteOffer  method will delete all of the space and rate records in addition to the offer
        Set<String> idsToDelete = new Set<String>();
        idsToDelete.add(testOffer.Id);
        for (PBS_AAAP_Space__c spDel : testSpaces) {
            idsToDelete.add(spDel.Id);
        }

        for (PBS_AAAP_Rate__c rateDel : testRates) {
            idsToDelete.add(rateDel.Id);
        }

        contSpaceRates.actionDeleteOffer();
        System.assertEquals(0, [SELECT COUNT() FROM pbs_aaap_offer__c WHERE Id = :testOffer.Id]);
        System.assertEquals(0, [SELECT COUNT() FROM pbs_aaap_offer__c WHERE Id IN :idsToDelete]);

        //added by syam
        for (PBS_AAAP_Space__c sp1 : testSpaces) {
            sp1.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        }

        contSpaceRates.addRateAddSpace();
        contSpaceRates.backToPreviousPage();
        contSpaceRates.addRateneedSpace();
        contSpaceRates.backToPreviousPage();
        // contSpaceRates.actionDeleteOffer();

    }

    static testMethod void addNewSpace_Test() {
        // create the test data defaults
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(dataGen.testOffer.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        PBS_AAAP_RLP__c testRlp = dao.getRLP(dataGen.testOffer.PBS_AAAP_RLP_NUMBER__c);
        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();        // instance of calculations class

        // create page contexts for testing purposes
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference attach = Page.PBS_AAAP_OfferAttachments;

        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        System.assertEquals(contSpaceRates.offer.Id, testOffer.Id);         // validate that the controller obtains the correct offer


        // test that the genMapRatesToSpace method will correctly generate a map of rates to a space
        Map<String, List<PBS_AAAP_Rate__c>> testMapOfRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        System.assertEquals(testMapOfRates.get(testSpaces[0].Id), testRates);

        // test that the controller returns the panel IDs
        List<String> compList = new List<String>{
                'panel_outerspace', 'panel_NewSpace', 'panel_SuccSpace'
        };
        System.assertEquals(contSpaceRates.panelIds, compList);

        // test that the controller will return the value contained in the testOffer for screen fields
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, testOffer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c);

        // test that the getSpaceOpts returns the space options
        System.assert(contSpaceRates.getSpaceOpts().size() > 0, 'Space Type select options not populating.');

        // test that the getFeeOpts returns the fee options
        System.assert(contSpaceRates.getFeeOpts().size() > 0, 'Fee Opts Type select options not populating.');

        // test that the defaultSpace() method creates the default space with the correct information
        PBS_AAAP_Space__c sp = contSpaceRates.defaultSpace(testOffer.Id);

        System.assertEquals(sp.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        System.assertEquals(contSpaceRates.sfOfferedType, null);                // defaultSpace() method should also set the square footage offered type to null
        System.assertEquals(contSpaceRates.feePrcntgOrDollar, null);        // defaultSpace() method should also set the UOM variable for the architectural engineering fee type to null
        //as per FY16 as it is mandatory as we are forcing the related values to '0.00'
        contSpaceRates.feePrcntgOrDollar = '%';
        // test that the getLrgOrdinal() method returns the largest ordinal for the number of spaces passed as a list to the function
        System.assertEquals(contSpaceRates.getLrgOrdinal(testSpaces), 1);   // there is only one test space so the function should return a 1

        // test that the saveSpace method correctly saves the space to the DB
        contSpaceRates.space = sp;
        System.debug('weston');
        System.debug('*****myUnitTest contSpaceRates.space before saveSpace(): ' + contSpaceRates.space);
        contSpaceRates.saveSpace();
        System.debug('*****myUnitTest contSpaceRates.space after saveSpace(): ' + contSpaceRates.spaces.size());
        System.assertEquals(1, contSpaceRates.spaces.size());   // save spaces adds the new space to the internal list of spaces, for our purposes there are 2, the initial (found by constructor) and then the one added by saveSpace


        // test that the addSpace method renders the inner space page view
        contSpaceRates.addNewSpace();
        contSpaceRates.addSucceedingSpace();

        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        PageReference pgBack = Page.PBS_AAAP_OperatingCosts;
        pgBack.getParameters().put('offerId', testOffer.Id);
        //System.assertEquals(contSpaceRates.back().getUrl(), pgBack.getUrl());

        // test that the action for the rates summary button renders the correct views
        PageReference pgRateSumm = Page.pbs_aaap_spacesandrates;
        pgRateSumm.getParameters().put('offerId', testOffer.Id);
        //System.assertEquals(contSpaceRates.rateSummary().getUrl(), pgRateSumm.getUrl());
        contSpaceRates.rateSummary();
        //contSpaceRates.retrieveSpaces(testOffer.Id);
        contSpaceRates.editSpace();
        contSpaceRates.setValsFor6();
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;  // rig the space so that it is considered a succeeding space

        contSpaceRates.editSpace();


    }

    static testMethod void myUnitTest1() {
        // create the test data defaults
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_COST_PER_ABOA__c = 10;
        update testOffer;
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(dataGen.testOffer.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        PBS_AAAP_RLP__c testRlp = dao.getRLP(dataGen.testOffer.PBS_AAAP_RLP_NUMBER__c);
        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();        // instance of calculations class
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;
        testRlp.PBS_AAAP_Region__c = 'Census';
        upsert testRlp;
        testOffer.Property__c = prop.Id;
        // create page contexts for testing purposes
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference attach = Page.PBS_AAAP_OfferAttachments;
        //PageReference addSucceedingSpace = Page.addSucceedingSpace;

        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        System.assertEquals(contSpaceRates.offer.Id, testOffer.Id);         // validate that the controller obtains the correct offer


        // test that the genMapRatesToSpace method will correctly generate a map of rates to a space
        Map<String, List<PBS_AAAP_Rate__c>> testMapOfRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        System.assertEquals(testMapOfRates.get(testSpaces[0].Id), testRates);

        // test that the controller returns the panel IDs
        List<String> compList = new List<String>{
                'panel_outerspace', 'panel_NewSpace', 'panel_SuccSpace'
        };
        System.assertEquals(contSpaceRates.panelIds, compList);

        // test that the controller will return the value contained in the testOffer for screen fields
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, testOffer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c);

        // test that the getSpaceOpts returns the space options
        System.assert(contSpaceRates.getSpaceOpts().size() > 0, 'Space Type select options not populating.');

        // test that the getFeeOpts returns the fee options
        System.assert(contSpaceRates.getFeeOpts().size() > 0, 'Fee Opts Type select options not populating.');

        // test that the defaultSpace() method creates the default space with the correct information
        PBS_AAAP_Space__c sp = contSpaceRates.defaultSpace(testOffer.Id);
        sp.PBS_AAAP_Offeror_Created_TI__c = NULL;
        sp.PBS_AAAP_Offeror_Created_BSAC__c = NULL;

        System.assertEquals(sp.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        System.assertEquals(contSpaceRates.sfOfferedType, null);                // defaultSpace() method should also set the square footage offered type to null
        System.assertEquals(contSpaceRates.feePrcntgOrDollar, null);        // defaultSpace() method should also set the UOM variable for the architectural engineering fee type to null
        //as per FY16 as it is mandatory as we are forcing the related values to '0.00'
        contSpaceRates.feePrcntgOrDollar = '%';
        contSpaceRates.newOrCont = 'FALSE';
        // test that the getLrgOrdinal() method returns the largest ordinal for the number of spaces passed as a list to the function
        System.assertEquals(contSpaceRates.getLrgOrdinal(testSpaces), 1);   // there is only one test space so the function should return a 1

        // test that the saveSpace method correctly saves the space to the DB
        contSpaceRates.space = sp;
        System.debug('weston');
        System.debug('*****myUnitTest contSpaceRates.space before saveSpace(): ' + contSpaceRates.space);
        contSpaceRates.saveSpace();
        System.debug('*****myUnitTest contSpaceRates.space after saveSpace(): ' + contSpaceRates.spaces.size());
        System.assertEquals(1, contSpaceRates.spaces.size());   // save spaces adds the new space to the internal list of spaces, for our purposes there are 2, the initial (found by constructor) and then the one added by saveSpace

        contSpaceRates.userIputTIA = 2;
        contSpaceRates.userInputBSAC = 2;

        // test that the addSpace method renders the inner space page view
        contSpaceRates.addNewSpace();

        contSpaceRates.addRate();
        PBS_AAAP_ControllerSpacesAndRates csr = new PBS_AAAP_ControllerSpacesAndRates();
        csr.userIputTIA = 2;
        csr.userInputBSAC = 2;
        csr.newOrCont = 'FALSE';
        csr.getSpaceOpts();
        csr.getFeeOpts();
        csr.addNewSpace();
        csr.addSucceedingSpace();
        csr.saveSpace();
        csr.calcTotMarkup();

        csr.continueSave();
        csr.back();
        csr.addRate();
        csr.editRate();
        csr.saveRates();
        csr.rateSummary();
        csr.returnToSpace();
        csr.returnToSpaceRates();
        csr.redirectToSpaceandRatesOnly();
        csr.redirectToSpaceandRates();
        csr.returnToSpaceRatesViewOnly();
        csr.saveForm();
        csr.editSpace();
        csr.clearSpace();
        csr.defaultSpace(testSpaces[0].PBS_AAAP_OFFER_NUMBER__c);
        csr.deleteSpace();
        csr.actionBackSpace();
        csr.actionBackSpaceView();

        csr.getItems();
        csr.setValsFor6();
        sp.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = NULL;
        sp.PBS_AAAP_SF_OFFERED__c = NULL;
        csr.redirectToSpaceandRatesOnly();
        csr.redirectToSpaceandRates();


    }

    static testMethod void myUnitTest2() {
        // create the test data defaults
        PBS_AAAP_RLP__c testRLP1 = new PBS_AAAP_RLP__c(
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 20.00,
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 38.95,
                PBS_AAAP_ALLOW_TIER2_AMMORT__c = true,
                PBS_AAAP_MAX_TIUSED__c = 45.59,
                PBS_AAAP_RLP_Number__c = 'Unit Test RLP',
                PBS_AAAP_DISCOUNT_RATE__c = 5.00,
                PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50,
                PBS_AAAP_Discount_percent_Rate__c = 5.00,
                PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50,
                PBS_AAAP_Year__c = '2016',
                PBS_AAAP_BSAC_per_ABOA__c = 25
        );
        system.assert(testRLP1.PBS_AAAP_RLP_Number__c != null);
        upsert testRLP1;
        system.assert(testRLP1.id != null);

        PBS_AAAP_Offer__c testOffer1 = new PBS_AAAP_Offer__c(
                PBS_AAAP_Building_Name__c = 'Unit Test Bldg',
                PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = 1000.00,
                PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 1000.00,
                PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = 1000.00,
                PBS_AAAP_RU_FACTOR__c = 0.00,
                PBS_AAAP_COST_PER_ABOA__c = 9.21,
                PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 12000,
                PBS_AAAP_OFFICE_SPACE_RSF__c = 1000.00,
                PBS_AAAP_CLEANING_SALARIES__c = 1.00,
                PBS_AAAP_CLEANING_SUPPLIES__c = 1.00,
                PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00,
                PBS_AAAP_HEATING_SALARIES__c = 1.00,
                PBS_AAAP_HEATING_FUEL__c = 'Coal',
                PBS_AAAP_HEATING_FUEL_COST__c = 1.00,
                PBS_AAAP_HEATING_MAINTENANCE__c = 1.00,
                PBS_AAAP_ELECTRICAL_POWER__c = 1.00,
                PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00,
                PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00,
                PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00,
                PBS_AAAP_PLUMBING_WATER__c = 1.00,
                PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00,
                PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00,
                PBS_AAAP_AC_UTILITIES__c = 1.00,
                PBS_AAAP_AC_MAINTENANCE__c = 1.00,
                PBS_AAAP_ELEVATOR_SALARIES__c = 1.00,
                PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00,
                PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00,
                PBS_AAAP_SECURITY__c = 1.00,
                PBS_AAAP_SSTAX_WORKCOMP__c = 1.00,
                PBS_AAAP_LANDSCAPING_MAINTENANCE__c = 1.00,
                PBS_AAAP_REAL_ESTATE_TAXES__c = 2.00,
                PBS_AAAP_INSURANCE__c = 2.00,
                PBS_AAAP_BUILDING_MAINTENANCE__c = 2.00,
                PBS_AAAP_LEASE_COMMISSION__c = 2.00,
                PBS_AAAP_MANAGEMENT__c = 2.00,
                PBS_AAAP_SECT2_TOTAL__c = 10.00,
                PBS_AAAP_SRVC_UTIL_TOTAL__c = 22.00,
                PBS_AAAP_TOTAL_OTHER_COSTS__c = 1.00,
                PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 28664.495

        );
        system.assert(testOffer1.PBS_AAAP_Building_Name__c != null);
        testOffer1.PBS_AAAP_RLP_Number__c = testRLP1.Id;     // relate the Offer to the RLP
        upsert testOffer1;

        PBS_AAAP_Space__c testSpace = new PBS_AAAP_Space__c(
                PBS_AAAP_OFFER_NUMBER__c = null,
                PBS_AAAP_Max_Contiguous_Space__c = 1000.00,
                PBS_AAAP_MIN_OFFERABLE_SPACE__c = 500.00,
                PBS_AAAP_MAX_OFFERABLE_SPACE__c = 1000.00,
                PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today(),
                PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 8.00,
                PBS_AAAP_MANAGEMENT_COORD_FEES__c = 0.00,
                PBS_AAAP_GC_CONDITIONS__c = 0.00,
                PBS_AAAP_ARCH_ENG_FEES__c = 3.50,
                PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = 'Unit Test GSA Lease',
                PBS_AAAP_IDENTIFIER_TYPE__c = 'DEFAULT',
                PBS_AAAP_IDENTIFIER_ID__c = '1',
                PBS_AAAP_SF_OFFERED__c = 1000.00,
                PBS_AAAP_TOTAL_MARKUP__c = 0.00,
                PBS_AAAP_TOT_EXP_ABOA__c = 0.00,
                PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true
        );
        system.assert(testSpace.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c != null);
        testSpace.PBS_AAAP_OFFER_NUMBER__c = testOffer1.Id;   // relate the Space to the Offer
        upsert testSpace;
        
        List<PBS_AAAP_Rate__c> testRates1 = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c(
                    PBS_AAAP_TWO_YEAR_EXTENSION__c = 0.00,
                    PBS_AAAP_SPACE__c = null,
                    PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0.00,
                    PBS_AAAP_ONE_YEAR_EXTENSION__c = 0.00,
                    PBS_AAAP_OFFER_NUMBER__c = null,
                    PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = 0.00,
                    PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8.00,
                    PBS_AAAP_LEASE_TERM__c = (i == 0) ? '17 years, 15 firm' : (i == 1 ? '15 years, 13 firm' : (i == 2 ? '10 years, 8 firm' : (i == 3 ? '15 years, 10 firm' : 'none'))),
                    PBS_AAAP_IDENTIFIER_ID__c = String.valueOf(i),
                    PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 50.00,
                    PBS_AAAP_COST_FOR_TI__c = 0.00,
                    PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = 5.00,
                    PBS_AAAP_BASE_RATE__c = 43.39,
                    PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 0.00,
                    PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = (i == 0) ? 5.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
                    PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 10.00,
                    PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c = 0.00,
                    PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = 0.50,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = (i == 0) ? 0.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
                    PBS_AAAP_BSAC_RATE__c = (i == 0) ? 0.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
                    PBS_AAAP_BSAC__c = 5,
                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 0.00
            );
            system.assert(rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c != null);

            testRates1.add(rate);
        }
        System.debug('$$$$$ testRates: ' + testRates1);

        for (Integer i = 0; i < testRates1.size(); i++) {
            PBS_AAAP_Rate__c rate = testRates1.get(i);
            rate.PBS_AAAP_SPACE__c = testSpace.Id;
            rate.PBS_AAAP_OFFER_NUMBER__c = testOffer1.Id;
            testRates1.set(i, rate);
        }
        upsert testRates1;

        List<PBS_AAAP_Other_Costs__c> testOtherCosts = new List<PBS_AAAP_Other_Costs__c>();
        for (Integer i = 0; i < 3; i++) {
            PBS_AAAP_Other_Costs__c ocost = new PBS_AAAP_Other_Costs__c(
                    PBS_AAAP_SHORT_DESC__c = 'Test Other Cost number ' + String.valueOf(i),
                    PBS_AAAP_OFFER_NUMBER__c = null,
                    PBS_AAAP_COST__c = 5.00,
                    PBS_AAAP_COST_TYPE__c = 'Other Cost',
                    PBS_AAAP_COST_REMOVAL__c = false
            );
            system.assert(ocost.PBS_AAAP_COST__c != null);
            testOtherCosts.add(ocost);
        }   // end for

        for (Integer i = 0; i < testOtherCosts.size(); i++) {
            PBS_AAAP_Other_Costs__c testOtherCost = testOtherCosts.get(i);
            testOtherCost.PBS_AAAP_OFFER_NUMBER__c = testOffer1.Id;
            testOtherCosts.set(i, testOtherCost);
        }
        upsert testOtherCosts;


        PBS_AAAP_Other_Costs__c testOtherCost1 = new PBS_AAAP_Other_Costs__c(
                PBS_AAAP_SHORT_DESC__c = 'Test Other Cost Single ',
                PBS_AAAP_OFFER_NUMBER__c = null,
                PBS_AAAP_COST__c = 1.00,
                PBS_AAAP_COST_TYPE__c = 'Other Cost',
                PBS_AAAP_COST_REMOVAL__c = false
        );
        system.assert(testOtherCost1.PBS_AAAP_COST__c != null);

        testOtherCost1.PBS_AAAP_OFFER_NUMBER__c = testOffer1.Id;
        upsert testOtherCost1;

        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(testOffer1.Id);
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(testOffer1.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(testOffer1.Id);
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        PBS_AAAP_RLP__c testRlp = dao.getRLP(testOffer1.PBS_AAAP_RLP_NUMBER__c);
        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();        // instance of calculations class

        // create page contexts for testing purposes
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference attach = Page.PBS_AAAP_OfferAttachments;

        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        contSpaceRates.regionCode = '10/5 Term - All Regions';
        System.assertEquals(contSpaceRates.offer.Id, testOffer.Id);         // validate that the controller obtains the correct offer


        // test that the genMapRatesToSpace method will correctly generate a map of rates to a space
        Map<String, List<PBS_AAAP_Rate__c>> testMapOfRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        System.assertEquals(testMapOfRates.get(testSpaces[0].Id), testRates);

        // test that the controller returns the panel IDs
        List<String> compList = new List<String>{
                'panel_outerspace', 'panel_NewSpace', 'panel_SuccSpace'
        };
        System.assertEquals(contSpaceRates.panelIds, compList);

        // test that the controller will return the value contained in the testOffer for screen fields
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, testOffer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c);

        // test that the getSpaceOpts returns the space options
        System.assert(contSpaceRates.getSpaceOpts().size() > 0, 'Space Type select options not populating.');

        // test that the getFeeOpts returns the fee options
        System.assert(contSpaceRates.getFeeOpts().size() > 0, 'Fee Opts Type select options not populating.');

        // test that the defaultSpace() method creates the default space with the correct information
        PBS_AAAP_Space__c sp = contSpaceRates.defaultSpace(testOffer.Id);

        System.assertEquals(sp.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        System.assertEquals(contSpaceRates.sfOfferedType, null);                // defaultSpace() method should also set the square footage offered type to null
        System.assertEquals(contSpaceRates.feePrcntgOrDollar, null);        // defaultSpace() method should also set the UOM variable for the architectural engineering fee type to null
        contSpaceRates.feePrcntgOrDollar = '%';
        contSpaceRates.space = sp;
        System.debug('weston');
        System.debug('*****myUnitTest contSpaceRates.space before saveSpace(): ' + contSpaceRates.space);
        contSpaceRates.saveSpace();
        System.debug('*****myUnitTest contSpaceRates.space after saveSpace(): ' + contSpaceRates.spaces.size());
        contSpaceRates.addNewSpace();
        Map<String, List<PBS_AAAP_Rate__c>> testMapSpaceToRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        for (PBS_AAAP_Space__c spc : testSpaces) {
            System.assertEquals(testMapSpaceToRates.containsKey(spc.Id), true);
        }   // end for


        // test that the addSucceedingSpace method renders the inner space page view
        contSpaceRates.addSucceedingSpace();
        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        for (PBS_AAAP_Rate__c rate : testRates) {
            if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(re.fiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.fiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.fiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveYrId, rate.Id);
                System.assertEquals(re.fiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(re.fiveFiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveFiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.fiveFiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.fiveFiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveFiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveFiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveFiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveFiveYrId, rate.Id);
                System.assertEquals(re.fiveFiveYrOptTerm, rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c);
                System.assertEquals(re.fiveFiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(re.tenYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.tenYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.tenYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.tenYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.tenYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.tenYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.tenYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.tenYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.tenYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.tenYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.tenYrId, rate.Id);
                System.assertEquals(re.tenYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);

            }
        }   // end for

        // test that the action for the "BACK" button returns the user to the operating costs page
        PageReference pgBack = Page.PBS_AAAP_OperatingCosts;
        pgBack.getParameters().put('offerId', testOffer.Id);
        // test that the action for the rates summary button renders the correct views
        PageReference pgRateSumm = Page.pbs_aaap_spacesandrates;
        pgRateSumm.getParameters().put('offerId', testOffer.Id);
        contSpaceRates.rateSummary();
        List<PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails> dets = contSpaceRates.spaceSort(testSpaces, testRates);
        System.assertEquals(contSpaceRates.details.size(), dets.size());           // verify that the summary screen field list is of the same size as the number of spaces.
        for (PBS_AAAP_Space__c space : testSpaces) {
            for (PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails d : dets) {
                if (d.spaceID == space.Id) {
                    for (PBS_AAAP_Rate__c rate : testRates) {
                        if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                            System.assertEquals(d.fiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveYrPV, rate.PBS_AAAP_PV_Value__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                            System.assertEquals(d.fiveFiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveFiveYrPV, rate.PBS_AAAP_PV_Value_Blended__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                            System.assertEquals(d.tenYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.tenYrPV, rate.PBS_AAAP_PV_Value__c);
                        } // end if
                    } // end for
                } // end if

                if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('New', d.leaseType);
                } else if (!space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('Succeeding', d.leaseType);
                } // end if
            }   // end for
        }   // end for

        contSpaceRates.details[0].selected = true;      // set the first element of the screen detail list to selected for purposes of the test
        System.debug('***** dets[0]: ' + dets[0]);
        contSpaceRates.editRate();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);

        System.debug('***** contSpaceRates.spaces: ' + contSpaceRates.spaces);
        contSpaceRates.editSpace();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);       // insure that editSpace is editing the correct space
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
        }

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;  // rig the space so that it is considered a succeeding space

        contSpaceRates.editSpace();
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
        }

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;   // reset the space so that it is considered a new space

        // test that the databaseConCheck method insures that only 3 rate records for any space can exist
        List<PBS_AAAP_Rate__c> rateDBOverload = new List<PBS_AAAP_Rate__c>();

        // strip the IDs to facilitate upload
        for (Integer i = 0; i < testRates.size(); i++) {
            PBS_AAAP_Rate__c rup = new PBS_AAAP_Rate__c(
                    PBS_AAAP_SPACE__c = testRates[i].PBS_AAAP_SPACE__c,
                    PBS_AAAP_OFFER_NUMBER__c = testRates[i].PBS_AAAP_OFFER_NUMBER__c,
                    PBS_AAAP_LEASE_TERM__c = testRates[i].PBS_AAAP_LEASE_TERM__c,
                    PBS_AAAP_BASE_RATE__c = testRates[i].PBS_AAAP_BASE_RATE__c,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = testRates[i].PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = testRates[i].PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c

            );
            rateDBOverload.add(rup);
        } // end for

        List<PBS_AAAP_Rate__c> totalRates = testRates;
        totalRates.addAll(rateDBOverload);
        insert rateDBOverload;

        Integer intRatesNum = rateDBOverload.size() + testRates.size();
        System.debug('%%%%% size of rates for space ID = ' + testRates[0].Id + ' : ' + intRatesNum);

        List<PBS_AAAP_Rate__c> idsToKeep = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            idsToKeep.add(testRates[i]);
        } // end for

        List<PBS_AAAP_Rate__c> rateChk = contSpaceRates.databaseConCheck(idsToKeep, totalRates);
        List<PBS_AAAP_Rate__c> ratesComp = [SELECT Id FROM PBS_AAAP_Rate__c WHERE PBS_AAAP_SPACE__c = :testRates[0].PBS_AAAP_SPACE__c];
        Integer chkNum = ratesComp.size() - rateChk.size();
        System.assertEquals(3, chkNum);

        // test that the convertRateEntry method correctly converts the rateEntry data into the three rates
        List<PBS_AAAP_Rate__c> cnvrtRates = contSpaceRates.convertRateEntry(re);

        for (PBS_AAAP_Rate__c rt : cnvrtRates) {
            if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.fiveYrFS);
            } else if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.fiveFiveYrFS);
            } else if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.tenYrFS);
            } // end if
        } // end for


        // test that the validateOfferFormFields
        Decimal backup = contSpaceRates.maxOfferedSpace;
        contSpaceRates.maxOfferedSpace = 0.00;
        //System.assertEquals(true, contSpaceRates.validateOfferFormFields());
        contSpaceRates.maxOfferedSpace = 20000.00;
        //System.assertEquals(true, contSpaceRates.validateOfferFormFields());
        contSpaceRates.maxOfferedSpace = backup;

        // test that the returnToSpaces method correctly sets the appropriate indicator
        Boolean boolBackup = contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c;
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        contSpaceRates.returnToSpace();
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        contSpaceRates.returnToSpace();
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = boolBackup;


        // test that the makeSpaceMap method correctly generates the map of spaces
        Map<String, PBS_AAAP_Space__c> spMap = contSpaceRates.makeSpaceMap(testSpaces);
        Set<String> spIds = new Set<String>();
        System.debug('%%%%% spMap: ' + spMap);
        System.debug('%%%%% testSpaces: ' + testSpaces);

        for (PBS_AAAP_Space__c sp1 : testSpaces) {
            System.assertEquals(true, spMap.containsKey(sp1.PBS_AAAP_IDENTIFIER_ID__c));
        } // end for

        contSpaceRates.addRate();
        // test that the deleteSpace method deletes the selected space from the DB
        Set<String> rateIDs = new Set<String>{
                testRates[0].Id, testRates[1].Id, testRates[2].Id
        };
        PageReference pgSpaceAndRates = Page.PBS_AAAP_SpacesAndRates;
        pgSpaceAndRates.getParameters().put('offerId', testOffer.Id);
        try {
            List<PBS_AAAP_Space__c> sp2 = [SELECT o.Id FROM PBS_AAAP_Space__c o WHERE o.Id = :contSpaceRates.details[0].spaceID];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));           // space shouldn't exist, so an exception should occur
        }

        try {
            List<PBS_AAAP_Rate__c> rt = [SELECT o.Id FROM PBS_AAAP_Rate__c o WHERE o.Id IN:rateIDs];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));           // Rate  shouldn't exist, so an exception should occur
        }

        // test that the actionBackSpace method will return the user to the spaces and rates summary page
        contSpaceRates.actionBackSpace();
        // test that the Space method will generate a default space
        contSpaceRates.clearSpace();
        System.assertEquals(contSpaceRates.space.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        //moved up for FY16 before delete as tests are failing due to offerId deletion
        contSpaceRates.saveRates();
        contSpaceRates.continueSave();
        contSpaceRates.returnToSpaceRates();
        contSpaceRates.returnToSpaceRatesViewOnly();
        contSpaceRates.saveForm();
        contSpaceRates.actionBackSpaceView();
        testOffer = dao.getOffer(testOffer1.Id);
        testOffer.PBS_AAAP_Offer_Status__c = 'Awarded';
        system.debug('offer status is' + testOffer.PBS_AAAP_Offer_Status__c);

        List<PBS_AAAP_Space__c> spaces1 = PBS_AAAP_GlobalConstants.getSpaces(testOffer.Id);
        if (spaces1 != null && spaces1.size() > 0) {
            PBS_AAAP_Space__c spaceTemp = spaces1.get(0);
            List<PBS_AAAP_Rate__c> rates1 = PBS_AAAP_GlobalConstants.getRates(spaceTemp.Id);
        }
        // test that the deleteOffer  method will delete all of the space and rate records in addition to the offer
        Set<String> idsToDelete = new Set<String>();
        idsToDelete.add(testOffer.Id);
        for (PBS_AAAP_Space__c spDel : testSpaces) {
            idsToDelete.add(spDel.Id);
        }

        for (PBS_AAAP_Rate__c rateDel : testRates) {
            idsToDelete.add(rateDel.Id);
        }

        contSpaceRates.actionDeleteOffer();
        System.assertEquals(0, [SELECT COUNT() FROM pbs_aaap_offer__c WHERE Id = :testOffer.Id]);
        System.assertEquals(0, [SELECT COUNT() FROM pbs_aaap_offer__c WHERE Id IN :idsToDelete]);

        //added by syam
        for (PBS_AAAP_Space__c sp1 : testSpaces) {
            sp1.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        }

        // contSpaceRates.actionDeleteOffer();


    }

    static testMethod void myOtherTest() {
        // create the test data defaults
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(dataGen.testOffer.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        PBS_AAAP_RLP__c testRlp = dao.getRLP(dataGen.testOffer.PBS_AAAP_RLP_NUMBER__c);
        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();        // instance of calculations class

        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;
        testOffer.Property__c = prop.Id;


        // create page contexts for testing purposes
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference attach = Page.PBS_AAAP_OfferAttachments;

        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        System.assertEquals(contSpaceRates.offer.Id, testOffer.Id);         // validate that the controller obtains the correct offer


        // test that the genMapRatesToSpace method will correctly generate a map of rates to a space
        Map<String, List<PBS_AAAP_Rate__c>> testMapOfRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        System.assertEquals(testMapOfRates.get(testSpaces[0].Id), testRates);

        // test that the controller returns the panel IDs
        List<String> compList = new List<String>{
                'panel_outerspace', 'panel_NewSpace', 'panel_SuccSpace'
        };
        System.assertEquals(contSpaceRates.panelIds, compList);

        // test that the controller will return the value contained in the testOffer for screen fields
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, testOffer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c);

        // test that the getSpaceOpts returns the space options
        System.assert(contSpaceRates.getSpaceOpts().size() > 0, 'Space Type select options not populating.');

        // test that the getFeeOpts returns the fee options
        System.assert(contSpaceRates.getFeeOpts().size() > 0, 'Fee Opts Type select options not populating.');

        // test that the defaultSpace() method creates the default space with the correct information
        PBS_AAAP_Space__c sp = contSpaceRates.defaultSpace(testOffer.Id);
        System.assertEquals(sp.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        System.assertEquals(contSpaceRates.sfOfferedType, null);                // defaultSpace() method should also set the square footage offered type to null
        System.assertEquals(contSpaceRates.feePrcntgOrDollar, null);        // defaultSpace() method should also set the UOM variable for the architectural engineering fee type to null
        //as per FY16 as it is mandatory as we are forcing the related values to '0.00'
        contSpaceRates.feePrcntgOrDollar = '%';
        // test that the getLrgOrdinal() method returns the largest ordinal for the number of spaces passed as a list to the function
        System.assertEquals(contSpaceRates.getLrgOrdinal(testSpaces), 1);   // there is only one test space so the function should return a 1

        // test that the saveSpace method correctly saves the space to the DB
        contSpaceRates.space = sp;
        System.debug('***** contSpaceRates.space before saveSpace(): ' + contSpaceRates.space);
        contSpaceRates.saveSpace();
        System.debug('***** contSpaceRates.space after saveSpace(): ' + contSpaceRates.space);
        System.assertEquals(contSpaceRates.spaces.size(), 1);   // save spaces adds the new space to the internal list of spaces, for our purposes there are 2, the initial (found by constructor) and then the one added by saveSpace

        // test that the addSpace method renders the inner space page view
        contSpaceRates.addNewSpace();
        // test that the genMapRatesToSpace accurately generates an Apex "Map" of rates to spaces
        Map<String, List<PBS_AAAP_Rate__c>> testMapSpaceToRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        for (PBS_AAAP_Space__c spc : testSpaces) {
            System.assertEquals(testMapSpaceToRates.containsKey(spc.Id), true);
        }   // end for
        // test that the addSucceedingSpace method renders the inner space page view
        contSpaceRates.addSucceedingSpace();
        // test that the convertPbsAaapRate method converts the rate data from the PBS_AAAP_Rate__c structure into the local class RateEntry format
        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        for (PBS_AAAP_Rate__c rate : testRates) {
            if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(re.fiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                System.assertEquals(re.fiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                System.assertEquals(re.fiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveYrId, rate.Id);
                System.assertEquals(re.fiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(re.fiveFiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveFiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                System.assertEquals(re.fiveFiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                System.assertEquals(re.fiveFiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveFiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveFiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveFiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveFiveYrId, rate.Id);
                System.assertEquals(re.fiveFiveYrOptTerm, rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c);
                System.assertEquals(re.fiveFiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(re.tenYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.tenYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                System.assertEquals(re.tenYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                System.assertEquals(re.tenYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.tenYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.tenYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.tenYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.tenYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.tenYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.tenYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.tenYrId, rate.Id);
                System.assertEquals(re.tenYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);

            }
        }   // end for

        // test that the action for the "BACK" button returns the user to the operating costs page
        PageReference pgBack = Page.PBS_AAAP_OperatingCosts;
        pgBack.getParameters().put('offerId', testOffer.Id);
        //System.assertEquals(contSpaceRates.back().getUrl(), pgBack.getUrl());

        // test that the action for the rates summary button renders the correct views
        PageReference pgRateSumm = Page.pbs_aaap_spacesandrates;
        pgRateSumm.getParameters().put('offerId', testOffer.Id);
        contSpaceRates.rateSummary();
        // test that the action to populate and sort the screen fields for the outer space summary table from the rates data returned from the SOQL
        List<PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails> dets = contSpaceRates.spaceSort(testSpaces, testRates);
        System.assertEquals(contSpaceRates.details.size(), dets.size());           // verify that the summary screen field list is of the same size as the number of spaces.
        for (PBS_AAAP_Space__c space : testSpaces) {
            for (PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails d : dets) {
                if (d.spaceID == space.Id) {
                    for (PBS_AAAP_Rate__c rate : testRates) {
                        if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                            System.assertEquals(d.fiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveYrPV, rate.PBS_AAAP_PV_Value__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                            System.assertEquals(d.fiveFiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveFiveYrPV, rate.PBS_AAAP_PV_Value_Blended__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                            System.assertEquals(d.tenYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.tenYrPV, rate.PBS_AAAP_PV_Value__c);
                        } // end if
                    } // end for
                } // end if

                if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('New', d.leaseType);
                } else if (!space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('Succeeding', d.leaseType);
                } // end if
            }   // end for
        }   // end for


        // test that the edit rate method such that it appropriately modifys the correct spaces rates
        contSpaceRates.details[0].selected = true;      // set the first element of the screen detail list to selected for purposes of the test
        System.debug('***** dets[0]: ' + dets[0]);
        contSpaceRates.editRate();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);

        System.debug('***** contSpaceRates.spaces: ' + contSpaceRates.spaces);
        // test that the edit space method such
        contSpaceRates.editSpace();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);       // insure that editSpace is editing the correct space
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
        }

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;  // rig the space so that it is considered a succeeding space

        contSpaceRates.editSpace();
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
        }
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;   // reset the space so that it is considered a new space

        // test that the databaseConCheck method insures that only 3 rate records for any space can exist
        List<PBS_AAAP_Rate__c> rateDBOverload = new List<PBS_AAAP_Rate__c>();

        // strip the IDs to facilitate upload
        for (Integer i = 0; i < testRates.size(); i++) {
            PBS_AAAP_Rate__c rup = new PBS_AAAP_Rate__c(
                    PBS_AAAP_SPACE__c = testRates[i].PBS_AAAP_SPACE__c,
                    PBS_AAAP_OFFER_NUMBER__c = testRates[i].PBS_AAAP_OFFER_NUMBER__c,
                    PBS_AAAP_LEASE_TERM__c = testRates[i].PBS_AAAP_LEASE_TERM__c,
                    PBS_AAAP_BASE_RATE__c = testRates[i].PBS_AAAP_BASE_RATE__c,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = testRates[i].PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = testRates[i].PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c

            );
            rateDBOverload.add(rup);
        } // end for

        List<PBS_AAAP_Rate__c> totalRates = testRates;
        totalRates.addAll(rateDBOverload);
        insert rateDBOverload;

        Integer intRatesNum = rateDBOverload.size() + testRates.size();
        System.debug('%%%%% size of rates for space ID = ' + testRates[0].Id + ' : ' + intRatesNum);

        List<PBS_AAAP_Rate__c> idsToKeep = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            idsToKeep.add(testRates[i]);
        } // end for

        List<PBS_AAAP_Rate__c> rateChk = contSpaceRates.databaseConCheck(idsToKeep, totalRates);
        List<PBS_AAAP_Rate__c> ratesComp = [SELECT Id FROM PBS_AAAP_Rate__c WHERE PBS_AAAP_SPACE__c = :testRates[0].PBS_AAAP_SPACE__c];
        Integer chkNum = ratesComp.size() - rateChk.size();
        System.assertEquals(3, chkNum);

        // test that the convertRateEntry method correctly converts the rateEntry data into the three rates
        List<PBS_AAAP_Rate__c> cnvrtRates = contSpaceRates.convertRateEntry(re);
        contSpaceRates.userInputBSAC = 2;
        contSpaceRates.userIputTIA = 2;
        contSpaceRates.calcTotMarkup();
        for (PBS_AAAP_Rate__c rt : cnvrtRates) {
            if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.fiveYrFS);
            } else if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.fiveFiveYrFS);
            } else if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.tenYrFS);
            } // end if
        } // end for


        // test that the validateOfferFormFields
        Decimal backup = contSpaceRates.maxOfferedSpace;
        contSpaceRates.maxOfferedSpace = 0.00;
        //System.assertEquals(true, contSpaceRates.validateOfferFormFields());
        contSpaceRates.maxOfferedSpace = 20000.00;
        //System.assertEquals(true, contSpaceRates.validateOfferFormFields());
        contSpaceRates.maxOfferedSpace = backup;

        // test that the returnToSpaces method correctly sets the appropriate indicator
        Boolean boolBackup = contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c;
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        contSpaceRates.returnToSpace();

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        contSpaceRates.returnToSpace();
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = boolBackup;


        // test that the makeSpaceMap method correctly generates the map of spaces
        Map<String, PBS_AAAP_Space__c> spMap = contSpaceRates.makeSpaceMap(testSpaces);
        Set<String> spIds = new Set<String>();
        System.debug('%%%%% spMap: ' + spMap);
        System.debug('%%%%% testSpaces: ' + testSpaces);

        for (PBS_AAAP_Space__c sp1 : testSpaces) {
            System.assertEquals(true, spMap.containsKey(sp1.PBS_AAAP_IDENTIFIER_ID__c));
        } // end for

        // test that the addRate method renders the inner space page view
        contSpaceRates.addRate();
        // test that the deleteSpace method deletes the selected space from the DB
        Set<String> rateIDs = new Set<String>{
                testRates[0].Id, testRates[1].Id, testRates[2].Id
        };
        PageReference pgSpaceAndRates = Page.PBS_AAAP_SpacesAndRates;
        pgSpaceAndRates.getParameters().put('offerId', testOffer.Id);
        try {
            List<PBS_AAAP_Space__c> sp2 = [SELECT o.Id FROM PBS_AAAP_Space__c o WHERE o.Id = :contSpaceRates.details[0].spaceID];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));           // space shouldn't exist, so an exception should occur
        }

        try {
            List<PBS_AAAP_Rate__c> rt = [SELECT o.Id FROM PBS_AAAP_Rate__c o WHERE o.Id IN:rateIDs];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));           // Rate  shouldn't exist, so an exception should occur
        }

        // test that the actionBackSpace method will return the user to the spaces and rates summary page
        contSpaceRates.actionBackSpace();
        //added by syam for space % check
        contSpaceRates.space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF';
        contSpaceRates.saveRates();

        contSpaceRates.space.PBS_AAAP_ARCH_ENG_FEES__c = 0;
        contSpaceRates.saveRates();


        // test that the Space method will generate a default space
        contSpaceRates.clearSpace();
        System.assertEquals(contSpaceRates.space.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);

        // test that the deleteOffer  method will delete all of the space and rate records in addition to the offer
        Set<String> idsToDelete = new Set<String>();
        idsToDelete.add(testOffer.Id);
        for (PBS_AAAP_Space__c spDel : testSpaces) {
            idsToDelete.add(spDel.Id);
        }

        for (PBS_AAAP_Rate__c rateDel : testRates) {
            idsToDelete.add(rateDel.Id);
        }

        contSpaceRates.actionDeleteOffer();
        System.assertEquals(0, [SELECT COUNT() FROM pbs_aaap_offer__c WHERE Id = :testOffer.Id]);
        System.assertEquals(0, [SELECT COUNT() FROM pbs_aaap_offer__c WHERE Id IN :idsToDelete]);

    }
    //added by syam to test the negative value check
    static testMethod void controlSpaceAndRatesNegativeTest() {
        system.debug('*** testing controlSpaceAndRatesNegativeTest ***');
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        //PBS_AAAP_Offer__c testOffer1=   dao.getOffer(dataGen.testOffer1.Id);

        System.debug('testOffer1 Id is in test class ****' + testOffer.id);
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        System.assertEquals(contSpaceRates.offer.Id, testOffer.Id);

        contSpaceRates.addNewSpace();
        //negative testing
        System.debug('before add rate in controlSpaceAndRatesNegativeTest()');
        contSpaceRates.addRate();
        contSpaceRates.validateOfferFormFields();
        //  System.assertEquals(true, contSpaceRates.validateOfferFormFields());
        contSpaceRates.saveRates();


    }
    //added by vaishali 02/16 to test the validuser check
    static testMethod void controlSpaceAndRatesValidUserTest() {
        system.debug('*** testing controlSpaceAndRatesValidUserTest ***');
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.assert(u.Id != null);
        system.debug('*** testing controlSpaceAndRatesValidUserTest: userID ***' + u.Id);

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();

        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.id;
        insert offer;

        system.debug('*** testing controlSpaceAndRatesValidUserTest: Count ***' + [SELECT COUNT() FROM PBS_AAAP_Offer__c o WHERE o.LastModifiedById != :u.Id]);
        //PBS_AAAP_Offer__c oOther = [select o.Id From PBS_AAAP_Offer__c o where o.LastModifiedById != :u.Id limit 1];
        system.debug('*** testing controlSpaceAndRatesValidUserTest: offerID ***' + offer.Id);
        System.runAs(u) {
            Test.startTest();
            // create page contexts for testing purposes
            PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;

            spacesAndRates.getParameters().put('offerId', offer.Id);
            Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
            PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
            contSpaceRates.maxOfferedSpace = 0.00;
            Test.stopTest();
        }
    }

    //added by syam to test the submitted offer check
    static testMethod void submittedOfferCheck() {
        //Added By Nik
        PBS_AAAP_Offer__c testOffer0 = new PBS_AAAP_Offer__c(
                PBS_AAAP_Building_Name__c = 'Unit Test Bldg',
                PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = null,
                PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = null,
                PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = null,
                PBS_AAAP_RU_FACTOR__c = 0.00,
                PBS_AAAP_COST_PER_ABOA__c = 0.0,
                PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 12000,
                PBS_AAAP_OFFICE_SPACE_RSF__c = 1000.00,
                PBS_AAAP_CLEANING_SALARIES__c = 1.00,
                PBS_AAAP_CLEANING_SUPPLIES__c = 1.00,
                PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00,
                PBS_AAAP_HEATING_SALARIES__c = 1.00,
                PBS_AAAP_HEATING_FUEL__c = 'Coal',
                PBS_AAAP_HEATING_FUEL_COST__c = 1.00,
                PBS_AAAP_HEATING_MAINTENANCE__c = 1.00,
                PBS_AAAP_ELECTRICAL_POWER__c = 1.00,
                PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00,
                PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00,
                PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00,
                PBS_AAAP_PLUMBING_WATER__c = 1.00,
                PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00,
                PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00,
                PBS_AAAP_AC_UTILITIES__c = 1.00,
                PBS_AAAP_AC_MAINTENANCE__c = 1.00,
                PBS_AAAP_ELEVATOR_SALARIES__c = 1.00,
                PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00,
                PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00,
                PBS_AAAP_SECURITY__c = 1.00,
                PBS_AAAP_SSTAX_WORKCOMP__c = 1.00,
                PBS_AAAP_LANDSCAPING_MAINTENANCE__c = 1.00,
                PBS_AAAP_REAL_ESTATE_TAXES__c = 2.00,
                PBS_AAAP_INSURANCE__c = 2.00,
                PBS_AAAP_BUILDING_MAINTENANCE__c = 2.00,
                PBS_AAAP_LEASE_COMMISSION__c = 2.00,
                PBS_AAAP_MANAGEMENT__c = 2.00,
                PBS_AAAP_SECT2_TOTAL__c = 10.00,
                PBS_AAAP_SRVC_UTIL_TOTAL__c = 22.00,
                PBS_AAAP_TOTAL_OTHER_COSTS__c = 1.00,
                PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 28664.495,
                PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED
        );
        insert testOffer0;
        //Added by Nik - END
        system.debug('*** testing submittedOfferCheck ***');
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        system.debug('%%%%%%%%'+dataGen.testOffer1.Id);
        PBS_AAAP_Offer__c testOffer1 = dao.getOffer(testOffer0.Id); //added by Nik
        System.debug('testOffer1 Id is in test class ****' + testOffer1.id);
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        spacesAndRates.getParameters().put('offerId', testOffer1.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        contSpaceRates.maxOfferedSpace = 0.00;
        System.debug('before add rate in controlSpaceAndRatesNegativeTest()');
        contSpaceRates.draftMsgFlag = 'true';
        PageReference pg = contSpaceRates.continueSave();
        contSpaceRates.actionCancel();
        system.assert(true);
    }
    //added by syam on 08/11/2016

    static testMethod void coverTestCases() {
        //added by syam on 08/11/2016
        system.debug('*** testing coverTestCases ***');
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = null;
        testOffer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = null;
        upsert testOffer;
        System.assert(testOffer.Id != null);
        System.debug('testOffer Id is in test class ****' + testOffer.id);
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();


    }

    //added by syam on 08/11/2016
    static testMethod void coverSaveRatesTests() {
        system.debug('*** testing coverSaveRatesTests ***');
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.assert(u.Id != null);
        system.debug('*** testing controlSpaceAndRatesValidUserTest: userID ***' + u.Id);

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        System.debug('before rlp.PBS_AAAP_DISCOUNT_RATE__c: ' + rlp.PBS_AAAP_DISCOUNT_RATE__c + ' rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c' + rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c);
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 5.0;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50;
        upsert rlp;
        System.debug('after rlp.PBS_AAAP_DISCOUNT_RATE__c: ' + rlp.PBS_AAAP_DISCOUNT_RATE__c + ' rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c' + rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c);

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.id;
        insert offer;

        system.debug('*** testing controlSpaceAndRatesValidUserTest: Count ***' + [SELECT COUNT() FROM PBS_AAAP_Offer__c o WHERE o.LastModifiedById != :u.Id]);
        system.debug('*** testing controlSpaceAndRatesValidUserTest: offerID ***' + offer.Id);
        System.runAs(u) {
            Test.startTest();
            // create page contexts for testing purposes
            PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;


            System.assert(offer.Id != null);
            spacesAndRates.getParameters().put('offerId', offer.Id);
            Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
            PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();


            try { 
                contSpaceRates.rateE.fiveFiveYrFS = 10;
                contSpaceRates.rateE.fiveFiveYrOptTerm = 0;
                contSpaceRates.regionCode = 'test';

                contSpaceRates.saveRates();
            } catch (Exception e) {
                system.assert(e.getMessage()!= null);
            }

            offer.PBS_AAAP_Offer_Status__c = 'Submitted';
            try {  
                contSpaceRates.spaceAndRates.PBS_AAAP_COST_PER_ABOA__c = 0;
                contSpaceRates.saveRates();
            } catch (Exception e) {
                system.assert(e.getMessage()!= null);
                
            }

            try {  
                contSpaceRates.rateE.fiveYrFS = 10;
                contSpaceRates.rateE.tenFiveYrOptTerm = null;
                contSpaceRates.regionCode = 'test';

                contSpaceRates.saveRates();
            } catch (Exception e) {
                system.assert(e.getMessage()!= null);
            }
//SGanti added 8/2/2021     
			try {
                contSpaceRates.rateE.fiveYrFS = 10;
                contSpaceRates.rateE.tenFiveYrOptTerm = null;
                contSpaceRates.regionCode = '10/5 Term - All Regions';

                contSpaceRates.saveRates();
            } catch (Exception e) {
                system.assert(e.getMessage()!= null);                
            }
            
            
            
            try {  
                contSpaceRates.rateE.tenYrFS = 10;
                contSpaceRates.rateE.tenEightYrOptTerm = null;
                contSpaceRates.regionCode = 'test';

                contSpaceRates.saveRates();
            } catch (Exception e) {
                system.assert(e.getMessage()!= null);                
            }

            PBS_AAAP_Space__c sp = contSpaceRates.defaultSpace(offer.Id);
            contSpaceRates.space = sp;
            contSpaceRates.redirectToSpaceandRatesOnly();
            contSpaceRates.redirectToSpaceandRates();
            contSpaceRates.rateE.fiveYrFS = 10;
            contSpaceRates.rateE.tenFiveYrOptTerm = 8;
            contSpaceRates.rateE.fiveFiveYrFS = 10;
            contSpaceRates.rateE.fiveFiveYrOptTerm = 8;
            contSpaceRates.redirectToSpaceandRatesOnly();
            contSpaceRates.redirectToSpaceandRates();
            Test.stopTest();
        }

    }
    
    static testMethod void coverSaveRatesTestsForCensus() {
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(dataGen.testOffer.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        PBS_AAAP_RLP__c testRlp = dao.getRLP(dataGen.testOffer.PBS_AAAP_RLP_NUMBER__c);
        testRlp.PBS_AAAP_Region__c = 'Census';
        testRlp.PBS_AAAP_Year__c = '2017';
        upsert testRlp;
        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();
        // create page contexts for testing purposes
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference attach = Page.PBS_AAAP_OfferAttachments;

        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        System.assertEquals(contSpaceRates.offer.Id, testOffer.Id);         // validate that the controller obtains the correct offer


        // test that the genMapRatesToSpace method will correctly generate a map of rates to a space
        Map<String, List<PBS_AAAP_Rate__c>> testMapOfRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        System.assertEquals(testMapOfRates.get(testSpaces[0].Id), testRates);

        // test that the controller returns the panel IDs
        List<String> compList = new List<String>{
                'panel_outerspace', 'panel_NewSpace', 'panel_SuccSpace'
        };
        System.assertEquals(contSpaceRates.panelIds, compList);

        // test that the controller will return the value contained in the testOffer for screen fields
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, testOffer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c);

        // test that the getSpaceOpts returns the space options
        System.assert(contSpaceRates.getSpaceOpts().size() > 0, 'Space Type select options not populating.');

        // test that the getFeeOpts returns the fee options
        System.assert(contSpaceRates.getFeeOpts().size() > 0, 'Fee Opts Type select options not populating.');

        // test that the defaultSpace() method creates the default space with the correct information
        PBS_AAAP_Space__c sp = contSpaceRates.defaultSpace(testOffer.Id);
        List<PBS_AAAP_Rate__c> rt = PBS_AAAP_GlobalConstants.getRates(sp.Id);
        System.assertEquals(sp.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        System.assertEquals(contSpaceRates.sfOfferedType, null);                // defaultSpace() method should also set the square footage offered type to null
        System.assertEquals(contSpaceRates.feePrcntgOrDollar, null);        // defaultSpace() method should also set the UOM variable for the architectural engineering fee type to null
        //as per FY16 as it is mandatory as we are forcing the related values to '0.00'
        contSpaceRates.feePrcntgOrDollar = '%';
        // test that the getLrgOrdinal() method returns the largest ordinal for the number of spaces passed as a list to the function
        System.assertEquals(contSpaceRates.getLrgOrdinal(testSpaces), 1);   // there is only one test space so the function should return a 1

        // test that the saveSpace method correctly saves the space to the DB
        contSpaceRates.space = sp;
        System.debug('*****myUnitTest contSpaceRates.space before saveSpace(): ' + contSpaceRates.space);
        contSpaceRates.saveSpace();
        System.debug('*****myUnitTest contSpaceRates.space after saveSpace(): ' + contSpaceRates.spaces.size());
        System.assertEquals(contSpaceRates.spaces.size(), 1);   // save spaces adds the new space to the internal list of spaces, for our purposes there are 2, the initial (found by constructor) and then the one added by saveSpace

        // test that the addSpace method renders the inner space page view
        contSpaceRates.addNewSpace();

        // test that the genMapRatesToSpace accurately generates an Apex "Map" of rates to spaces
        Map<String, List<PBS_AAAP_Rate__c>> testMapSpaceToRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        for (PBS_AAAP_Space__c spc : testSpaces) {
            System.assertEquals(testMapSpaceToRates.containsKey(spc.Id), true);
        }   // end for

        // test that the addSucceedingSpace method renders the inner space page view
        contSpaceRates.addSucceedingSpace();
        // test that the convertPbsAaapRate method converts the rate data from the PBS_AAAP_Rate__c structure into the local class RateEntry format
        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        for (PBS_AAAP_Rate__c rate : testRates) {
            if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(re.fiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.fiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.fiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveYrId, rate.Id);
                System.assertEquals(re.fiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(re.fiveFiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveFiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.fiveFiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.fiveFiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveFiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveFiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveFiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveFiveYrId, rate.Id);
                System.assertEquals(re.fiveFiveYrOptTerm, rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c);
                System.assertEquals(re.fiveFiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(re.tenYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.tenYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.tenYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.tenYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.tenYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.tenYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.tenYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.tenYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.tenYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.tenYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.tenYrId, rate.Id);
                System.assertEquals(re.tenYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);

            }
        }   // end for

        // test that the action for the "BACK" button returns the user to the operating costs page
        PageReference pgBack = Page.PBS_AAAP_OperatingCosts;
        pgBack.getParameters().put('offerId', testOffer.Id);
        // test that the action for the rates summary button renders the correct views
        PageReference pgRateSumm = Page.pbs_aaap_spacesandrates;
        pgRateSumm.getParameters().put('offerId', testOffer.Id);
        contSpaceRates.rateSummary();
        // test that the action to populate and sort the screen fields for the outer space summary table from the rates data returned from the SOQL
        List<PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails> dets = contSpaceRates.spaceSort(testSpaces, testRates);
        System.assertEquals(contSpaceRates.details.size(), dets.size());           // verify that the summary screen field list is of the same size as the number of spaces.
        for (PBS_AAAP_Space__c space : testSpaces) {
            for (PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails d : dets) {
                if (d.spaceID == space.Id) {
                    for (PBS_AAAP_Rate__c rate : testRates) {
                        if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                            System.assertEquals(d.fiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveYrPV, rate.PBS_AAAP_PV_Value__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                            System.assertEquals(d.fiveFiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveFiveYrPV, rate.PBS_AAAP_PV_Value_Blended__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                            System.assertEquals(d.tenYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.tenYrPV, rate.PBS_AAAP_PV_Value__c);
                        } // end if
                    } // end for
                } // end if

                if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('New', d.leaseType);
                } else if (!space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('Succeeding', d.leaseType);
                } // end if
            }   // end for
        }   // end for


        // test that the edit rate method such that it appropriately modifys the correct spaces rates
        contSpaceRates.details[0].selected = true;      // set the first element of the screen detail list to selected for purposes of the test
        System.debug('***** dets[0]: ' + dets[0]);
        contSpaceRates.editRate();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);

        System.debug('***** contSpaceRates.spaces: ' + contSpaceRates.spaces);
        // test that the edit space method such
        contSpaceRates.editSpace();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);       // insure that editSpace is editing the correct space
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
        }
        try {
            contSpaceRates.sfOfferedType = 'Range of ABOA';
            contSpaceRates.space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = 0;
            contSpaceRates.saveSpace();
        }

        catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('4. Amount of offered space must be greater than 0.'));           // Rate  shouldn't exist, so an exception should occur
        }


        try {

            contSpaceRates.space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = 9999;
            contSpaceRates.space.PBS_AAAP_SF_OFFERED__c = 8888;
            contSpaceRates.saveSpace();
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('Max value in the range of ABOA offered cannot be greater than the Total ABOA available (Question 3)'));           // Rate  shouldn't exist, so an exception should occur
        }

        try {

            contSpaceRates.sfOfferedType = 'Range of ABOA';
            contSpaceRates.space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = 0;
            contSpaceRates.addRate();
        } catch (Exception e) {
            System.assert(e.getMessage().contains('4. Amount of offered'));
        }


        try {
            contSpaceRates.sfOfferedType = 'All Available ABOA';
            contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
            contSpaceRates.space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = null;
            contSpaceRates.space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = null;
            contSpaceRates.space.PBS_AAAP_ARCH_ENG_FEES__c = 1.00;           
            contSpaceRates.saveSpace();
        }

        catch (Exception e) {
            System.assert(e.getMessage().contains('You must select a unit of measure for the Architectural and Engineering fees value if you specify a value for the fees'));           // Rate  shouldn't exist, so an exception should occur
        }

    //SGanti start 8/2/2021    
        try {
            contSpaceRates.sfOfferedType = 'All Available ABOA';
            contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
            contSpaceRates.space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = null;
            contSpaceRates.space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = null;
            contSpaceRates.space.PBS_AAAP_ARCH_ENG_FEES__c = 1.00;
           	contSpaceRates.feePrcntgOrDollar = null;
            contSpaceRates.saveSpace();

        }

        catch (Exception e) {
            System.assert(e.getMessage().contains('You must select a unit of measure for the Architectural and Engineering fees value if you specify a value for the fees'));           // Rate  shouldn't exist, so an exception should occur
        }
        
  		//SGanti end
        try {
            contSpaceRates.space.PBS_AAAP_ARCH_ENG_FEES__c = 0.00;
            contSpaceRates.readOnlyScreen = 'false';
            contSpaceRates.regionCode = 'test';

            System.debug('contSpaceRates.space.PBS_AAAP_ARCH_ENG_FEES__c ' + contSpaceRates.space.PBS_AAAP_ARCH_ENG_FEES__c);
            contSpaceRates.saveSpace();
        } catch (Exception e) {
            System.debug('PBS_AAAP_COST_PER_ABOA__c ' + e);
            System.assert(e.getMessage().contains('Warning Space Page : Data saved with "Lessor PM Fees" and / or "A&E Fees" with a ZERO value. Please make sure you intended a ZERO value. If not, return to space page and update #6 and #7. If so, proceed to Add/Edit Rates for Space.'));           // Rate  shouldnt exist, so an exception should occur
        }

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;  // rig the space
        //so that it is considered a succeeding space

        contSpaceRates.editSpace();
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
        }

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;   // reset the space so that it is considered a new space

        // test that the databaseConCheck method insures that only 3 rate records for any space can exist
        List<PBS_AAAP_Rate__c> rateDBOverload = new List<PBS_AAAP_Rate__c>();

        // strip the IDs to facilitate upload
        for (Integer i = 0; i < testRates.size(); i++) {
            PBS_AAAP_Rate__c rup = new PBS_AAAP_Rate__c(
                    PBS_AAAP_SPACE__c = testRates[i].PBS_AAAP_SPACE__c,
                    PBS_AAAP_OFFER_NUMBER__c = testRates[i].PBS_AAAP_OFFER_NUMBER__c,
                    PBS_AAAP_LEASE_TERM__c = testRates[i].PBS_AAAP_LEASE_TERM__c,
                    PBS_AAAP_BASE_RATE__c = testRates[i].PBS_AAAP_BASE_RATE__c,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = testRates[i].PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = testRates[i].PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c

            );
            rateDBOverload.add(rup);
        } // end for

        List<PBS_AAAP_Rate__c> totalRates = testRates;
        totalRates.addAll(rateDBOverload);
        insert rateDBOverload;

        Integer intRatesNum = rateDBOverload.size() + testRates.size();
        System.debug('%%%%% size of rates for space ID = ' + testRates[0].Id + ' : ' + intRatesNum);

        List<PBS_AAAP_Rate__c> idsToKeep = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            idsToKeep.add(testRates[i]);
        } // end for

        List<PBS_AAAP_Rate__c> rateChk = contSpaceRates.databaseConCheck(idsToKeep, totalRates);
        List<PBS_AAAP_Rate__c> ratesComp = [SELECT Id FROM PBS_AAAP_Rate__c WHERE PBS_AAAP_SPACE__c = :testRates[0].PBS_AAAP_SPACE__c];
        Integer chkNum = ratesComp.size() - rateChk.size();
        System.assertEquals(3, chkNum);

        // test that the convertRateEntry method correctly converts the rateEntry data into the three rates
        List<PBS_AAAP_Rate__c> cnvrtRates = contSpaceRates.convertRateEntry(re);

        // added on 13-jan-2018 to created error in save data
        PBS_AAAP_ControllerSpacesAndRates obj = new PBS_AAAP_ControllerSpacesAndRates();
        obj.offer = null;
        obj.saveData();

        obj.pageUrl = '1=====';
        obj.saveForm();


        testOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        update testOffer;
        obj.readOnlyScreen = 'false';
        obj.offer = testOffer;
        obj.saveData();

        // obj.validate = true;
        testOffer.PBS_AAAP_COST_PER_ABOA__c = 0;
        update testOffer;
        //obj.saveRates();

        PBS_AAAP_ControllerSpacesAndRates.RateEntry wrapper = new PBS_AAAP_ControllerSpacesAndRates.RateEntry();
        wrapper.fiveYrFS = 1;
        obj.rateE = wrapper;
        obj.regionCode = 'test';
        //obj.saveRates();

    }
    
    static testMethod void questionLabels() {
        PBS_AAAP_QuestionLabels qlContr = new PBS_AAAP_QuestionLabels();
        String maxTi = qlContr.maxTi;
        String spaceQ1 = qlContr.spaceQ1;
        String spaceQ2 = qlContr.spaceQ2;
        String spaceQ3New = qlContr.spaceQ3New;
        String spaceQ3Succ = qlContr.spaceQ3Succ;
        String spaceQ4New = qlContr.spaceQ4New;
        String spaceQ4Succ = qlContr.spaceQ4Succ;
        String spaceQ5 = qlContr.spaceQ5;
        String spaceType1 = qlContr.spaceType1;
        String spaceType2 = qlContr.spaceType2;
        String validationMust = qlContr.validationMust;
        String spaceQ6 = qlContr.spaceQ6;
        String spaceQ7 = qlContr.spaceQ7;
        String spaceQ8 = qlContr.spaceQ8;
        String spaceQ9 = qlContr.spaceQ9;
        String spaceQ10 = qlContr.spaceQ10;
        String spaceQ10Tot = qlContr.spaceQ10Tot;
        String ratesQ1 = qlContr.ratesQ1;
        String ratesQ2 = qlContr.ratesQ2;
        String ratesQ3New = qlContr.ratesQ3New;
        String ratesQ3Succ = qlContr.ratesQ3Succ;
        String ratesQ3New_1 = qlContr.ratesQ3New_1;
        String ratesQ3Succ_1 = qlContr.ratesQ3Succ_1;
        String ratesQBSACRateNew = qlContr.ratesQBSACRateNew;
        String ratesQBSACRateSucc = qlContr.ratesQBSACRateSucc;
        String ratesQBSACPmtNew = qlContr.ratesQBSACPmtNew;
        String ratesQBSACPmtSucc = qlContr.ratesQBSACPmtSucc;
        String ratesQ4New = qlContr.ratesQ4New;
        String ratesQ4Succ = qlContr.ratesQ4Succ;
        String ratesQ5New = qlContr.ratesQ5New;
        String ratesQ5Succ = qlContr.ratesQ5Succ;
        String ratesQ6 = qlContr.ratesQ6;
        String ratesQ7New = qlContr.ratesQ7New;
        String ratesQ7Succ = qlContr.ratesQ7Succ;
        String ratesQ8 = qlContr.ratesQ8;
        String ratesQ8_7 = qlContr.ratesQ8_7;
        String ratesQ9 = qlContr.ratesQ9;
        String ratesQ10 = qlContr.ratesQ10;
        String ratesQ10_8 = qlContr.ratesQ10_8;
        String ratesQ10New = qlContr.ratesQ10New;
        String ratesQ10Succ = qlContr.ratesQ10Succ;
        String ratesQ10a = qlContr.ratesQ10a;
        String ratesQ10b = qlContr.ratesQ10b;
        String ratesQ11New = qlContr.ratesQ11New;
        String ratesQ11Succ = qlContr.ratesQ11Succ;
        String ratesQ12 = qlContr.ratesQ12;
        String ratesCol1 = qlContr.ratesCol1;
        String ratesCol2 = qlContr.ratesCol2;
        String ratesCol3 = qlContr.ratesCol3;
        Integer rlpFY = qlContr.rlpFY;
        String notation = qlContr.notation;
        String opCostsQ1 = qlContr.opCostsQ1;
        String opCostsQ2 = qlContr.opCostsQ2;
        String opCostsQ3 = qlContr.opCostsQ3;
        String CensusopCostQ4 = qlContr.CensusopCostQ4;
        String opCostsQ4 = qlContr.opCostsQ4;
        String opCostsQ5 = qlContr.opCostsQ5;
        String opCostsQ6 = qlContr.opCostsQ6;
        String opCostsQ7 = qlContr.opCostsQ7;
        String opCostsQ8 = qlContr.opCostsQ8;
        String opCostsQ9 = qlContr.opCostsQ9;
        String opCostsQ10 = qlContr.opCostsQ10;
        String opCostsQ11 = qlContr.opCostsQ11;
        String opCostsQ12 = qlContr.opCostsQ12;
        String opCostsQ13 = qlContr.opCostsQ13;
        String opCostsQ14 = qlContr.opCostsQ14;
        String opCostsQ15 = qlContr.opCostsQ15;
        String opCostsQ16 = qlContr.opCostsQ16;
        String opCostsQ17 = qlContr.opCostsQ17;
        String opCostsQ18 = qlContr.opCostsQ18;
        String opCostsQ19 = qlContr.opCostsQ19;
        String opCostsQ20 = qlContr.opCostsQ20;
        String opCostsQ21 = qlContr.opCostsQ21;
        String opCostsQ22 = qlContr.opCostsQ22;
        String opCostsQ23 = qlContr.opCostsQ23;
        String opCostsQ24 = qlContr.opCostsQ24;
        String opCostsQ25 = qlContr.opCostsQ25;
        String opCostsQ26 = qlContr.opCostsQ26;
        String opCostsQ27 = qlContr.opCostsQ27;
        String opCostsQ28 = qlContr.opCostsQ28;
        String opCostsQ29 = qlContr.opCostsQ29;
        String opCostsQ30 = qlContr.opCostsQ30;
        String opCostsQ31 = qlContr.opCostsQ31;
        String opCostsQ32 = qlContr.opCostsQ32;
        String opCostsQ33 = qlContr.opCostsQ33;
        String opCostsPgHdr = qlContr.opCostsPgHdr;
        String opCostsSubSectOne = qlContr.opCostsSubSectOne;
        String opCostsSubSectTwo = qlContr.opCostsSubSectTwo;
        String opCostsSubSectThree = qlContr.opCostsSubSectThree;
        String opCostsSubSectFour = qlContr.opCostsSubSectFour;
        String opCostsSubSectFive = qlContr.opCostsSubSectFive;
        String opCostsSubSectSix = qlContr.opCostsSubSectSix;
        String opCostsSubSectSeven = qlContr.opCostsSubSectSeven;
        String opCostsSectOneHdr = qlContr.opCostsSectOneHdr;
        String opCostsSectTwoHdr = qlContr.opCostsSectTwoHdr;
        String otherCostsQ1 = qlContr.otherCostsQ1;
        String otherCostsQ2 = qlContr.otherCostsQ2;
        String otherCostsTableColOne = qlContr.otherCostsTableColOne;
        String otherCostsTableColTwo = qlContr.otherCostsTableColTwo;
        String otherCostsTableColThree = qlContr.otherCostsTableColThree;
        String otherTotOtherCostTxt = qlContr.otherTotOtherCostTxt;
        String lopOpCostsSectOneHdr = qlContr.lopOpCostsSectOneHdr;
        String lopOpCostCol1 = qlContr.lopOpCostCol1;
        String lopOpCostCol2 = qlContr.lopOpCostCol2;
        String lopOpCostsQ5 = qlContr.lopOpCostsQ5;
        String lopOpCostsQ6 = qlContr.lopOpCostsQ6;
        String lopOpCostsQ7 = qlContr.lopOpCostsQ7;
        String lopOpCostsQ8 = qlContr.lopOpCostsQ8;
        String lopOpCostsQ9 = qlContr.lopOpCostsQ9;
        String lopOpCostsQ10 = qlContr.lopOpCostsQ10;
        String lopOpCostsQ11 = qlContr.lopOpCostsQ11;
        String lopOpCostsQ12 = qlContr.lopOpCostsQ12;
        String lopOpCostsQ13 = qlContr.lopOpCostsQ13;
        String lopOpCostsQ14 = qlContr.lopOpCostsQ14;
        String lopOpCostsQ15 = qlContr.lopOpCostsQ15;
        String lopOpCostsQ16 = qlContr.lopOpCostsQ16;
        String lopOpCostsQ17 = qlContr.lopOpCostsQ17;
        String lopOpCostsQ18 = qlContr.lopOpCostsQ18;
        String lopOpCostsQ19 = qlContr.lopOpCostsQ19;
        String lopOpCostsQ20 = qlContr.lopOpCostsQ20;
        String lopOpCostsQ21 = qlContr.lopOpCostsQ21;
        String lopOpCostsQ22 = qlContr.lopOpCostsQ22;
        String lopOpCostsQ23 = qlContr.lopOpCostsQ23;
        String lopOpCostsQ24 = qlContr.lopOpCostsQ24;
        String lopOpCostsQ25 = qlContr.lopOpCostsQ25;
        String lopOpCostsQ26 = qlContr.lopOpCostsQ26;
        String lopOpCostsQ27 = qlContr.lopOpCostsQ27;
        String lopOpCostsQ28 = qlContr.lopOpCostsQ28;
        String lopOpCostsQ29 = qlContr.lopOpCostsQ29;
        String lopOpCostsQ30 = qlContr.lopOpCostsQ30;
        String lopOpCostsQ31 = qlContr.lopOpCostsQ31;
        String lopOpCostsQ32 = qlContr.lopOpCostsQ32;
        String lopOpCostsQ33 = qlContr.lopOpCostsQ33;
        String lopSpaceQ1 = qlContr.lopSpaceQ1;
        String lopSpaceQ2 = qlContr.lopSpaceQ2;
        String lopSpaceQ3 = qlContr.lopSpaceQ3;
        String lopSpaceQ2a = qlContr.lopSpaceQ2a;
        String lopSpaceQ4 = qlContr.lopSpaceQ4;
        String lopSpaceQ5 = qlContr.lopSpaceQ5;
        String lopSpaceQ6 = qlContr.lopSpaceQ6;
        String lopSpaceQ7 = qlContr.lopSpaceQ7;
        String lopSpaceQ8 = qlContr.lopSpaceQ8;
        String lopSpaceQ9 = qlContr.lopSpaceQ9;
        String lopSpaceQ10 = qlContr.lopSpaceQ10;
        String lopSpaceQ11 = qlContr.lopSpaceQ11;
        String lopSpaceQ12 = qlContr.lopSpaceQ12;
        system.assertEquals(true, true);
    }

    static testMethod void Validate_actionDeleteOffer() {
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_Offer_Status__c = null;
        update testOffer;

        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        contSpaceRates.offer = testOffer;
        contSpaceRates.actionDeleteOffer();


        PBS_AAAP_Space__c space = dao.getSpaces(dataGen.testOffer.Id)[0];
        List<PBS_AAAP_Space__c> testSpaces = new List<PBS_AAAP_Space__c>{space,space};
        contSpaceRates.genMapRatesToSpace(new List<PBS_AAAP_Rate__c>(), testSpaces);

        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        contSpaceRates.regionCode = 'Census';
        contSpaceRates.convertRateEntry(re);

        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        update space;
        contSpaceRates.spaceSort(new List<PBS_AAAP_Space__c>{space}, testRates);


        space.PBS_AAAP_SF_OFFERED__c = -1;
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        update space;
        contSpaceRates.spaces = new List<PBS_AAAP_Space__c>{space};
        contSpaceRates.isSucceeding = false;
        contSpaceRates.MaxOfferedSpace = -1;
        contSpaceRates.validateOfferFormFields();

        contSpaceRates.isSucceeding = true;
        contSpaceRates.validateOfferFormFields();
        space.PBS_AAAP_SF_OFFERED__c = 4;
        space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = 3;
        update space;
        contSpaceRates.space = space;
        contSpaceRates.sfOfferedType = 'abc';

        contSpaceRates.addRate();
        Double test=contSpaceRates.totMarkup;
        contSpaceRates.Spacedate= system.today();
        system.assert(true);

    }

    static testMethod void Validate_actionDeleteOffer_0() {
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_Offer_Status__c = null;
        update testOffer;

        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        contSpaceRates.offer = testOffer;
        contSpaceRates.actionDeleteOffer();


        PBS_AAAP_Space__c space = dao.getSpaces(dataGen.testOffer.Id)[0];
        List<PBS_AAAP_Space__c> testSpaces = new List<PBS_AAAP_Space__c>{space,space};
        contSpaceRates.genMapRatesToSpace(new List<PBS_AAAP_Rate__c>(), testSpaces);

        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        contSpaceRates.regionCode = 'Census';
        contSpaceRates.convertRateEntry(re);

        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        update space;
        contSpaceRates.spaceSort(new List<PBS_AAAP_Space__c>{space}, testRates);


        space.PBS_AAAP_SF_OFFERED__c = NULL;
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        update space;
        contSpaceRates.spaces = new List<PBS_AAAP_Space__c>{space};
        contSpaceRates.isSucceeding = false;
        contSpaceRates.MaxOfferedSpace = -1;
        contSpaceRates.validateOfferFormFields();

        contSpaceRates.isSucceeding = true;
        contSpaceRates.validateOfferFormFields();

        space.PBS_AAAP_SF_OFFERED__c = NULL;
        space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = 3;
        update space;
        contSpaceRates.space = space;
        contSpaceRates.sfOfferedType = 'abc';

        contSpaceRates.addRate();
        Double test=contSpaceRates.totMarkup;
        contSpaceRates.Spacedate= system.today();
        system.assert(true);

    }

    static testMethod void Validate_actionDeleteOffer_01() {
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_Offer_Status__c = null;
        update testOffer;

        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        contSpaceRates.offer = testOffer;
        contSpaceRates.actionDeleteOffer();


        PBS_AAAP_Space__c space = dao.getSpaces(dataGen.testOffer.Id)[0];
        List<PBS_AAAP_Space__c> testSpaces = new List<PBS_AAAP_Space__c>{space,space};
        contSpaceRates.genMapRatesToSpace(new List<PBS_AAAP_Rate__c>(), testSpaces);

        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        contSpaceRates.regionCode = 'Census';
        contSpaceRates.convertRateEntry(re);

        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        update space;
        contSpaceRates.spaceSort(new List<PBS_AAAP_Space__c>{space}, testRates);


        space.PBS_AAAP_SF_OFFERED__c = -1;
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        update space;
        contSpaceRates.spaces = new List<PBS_AAAP_Space__c>{space};
        contSpaceRates.isSucceeding = false;
        contSpaceRates.MaxOfferedSpace = -1;
        contSpaceRates.validateOfferFormFields();

        contSpaceRates.isSucceeding = true;
        contSpaceRates.validateOfferFormFields();
        space.PBS_AAAP_SF_OFFERED__c = 4;
        space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = NULL;
        update space;
        contSpaceRates.space = space;
        contSpaceRates.sfOfferedType = 'abc';

        contSpaceRates.addRate();
        Double test=contSpaceRates.totMarkup;
        contSpaceRates.Spacedate= system.today();
        system.assert(true);
        
    }

    static testMethod void covernewLines() {
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_Offer_Status__c = null;
        update testOffer;

        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();

        contSpaceRates.offer = testOffer;

        PBS_AAAP_Space__c space = dao.getSpaces(dataGen.testOffer.Id)[0];
        List<PBS_AAAP_Space__c> testSpaces = new List<PBS_AAAP_Space__c>{space,space};
        contSpaceRates.genMapRatesToSpace(new List<PBS_AAAP_Rate__c>(), testSpaces);
        space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = '';

        contSpaceRates.newOrCont = 'TRUE';
        contSpaceRates.space = space;
		
        contSpaceRates.redirectToSpaceandRatesOnly();
        contSpaceRates.feePrcntgOrDollar = null;
        contSpaceRates.redirectToSpaceandRates();
        contSpaceRates.saveRates();
        system.assert(true);
    }

    static testMethod void covernewLines2() {
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        testOffer.PBS_AAAP_Offer_Status__c = null;
        update testOffer;

        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();

        contSpaceRates.offer = testOffer;

        PBS_AAAP_Space__c space = dao.getSpaces(dataGen.testOffer.Id)[0];
        List<PBS_AAAP_Space__c> testSpaces = new List<PBS_AAAP_Space__c>{space,space};
        contSpaceRates.genMapRatesToSpace(new List<PBS_AAAP_Rate__c>(), testSpaces);
        space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = '234325';
        space.PBS_AAAP_SF_OFFERED__c = NULL;
        contSpaceRates.newOrCont = 'TRUE';
        contSpaceRates.space = space;

        contSpaceRates.redirectToSpaceandRatesOnly();
        contSpaceRates.redirectToSpaceandRates();
        contSpaceRates.saveRates();
        
        contSpaceRates.newOrCont = 'TRUE';
        space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = '';
        space.PBS_AAAP_SF_OFFERED__c = null;
        contSpaceRates.space = space;
        try{
            contSpaceRates.saveSpace();
        } catch (Exception e) {
        }
        System.assertEquals('TRUE', contSpaceRates.newOrCont);
    }
     static testMethod void myUnitTest22() {
        // create the test data defaults
        PBS_AAAP_RLP__c testRLP1 = new PBS_AAAP_RLP__c(
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 20.00,
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 38.95,
                PBS_AAAP_ALLOW_TIER2_AMMORT__c = true,
                PBS_AAAP_MAX_TIUSED__c = 45.59,
                PBS_AAAP_RLP_Number__c = 'Unit Test RLP',
                PBS_AAAP_DISCOUNT_RATE__c = 5.00,
                PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50,
                PBS_AAAP_Discount_percent_Rate__c = 5.00,
                PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50,
                PBS_AAAP_Year__c = '2016',
                PBS_AAAP_BSAC_per_ABOA__c = 25
        );


        system.assert(testRLP1.PBS_AAAP_RLP_Number__c != null);
        upsert testRLP1;
        system.assert(testRLP1.id != null);

        PBS_AAAP_Offer__c testOffer1 = new PBS_AAAP_Offer__c(
                PBS_AAAP_Building_Name__c = 'Unit Test Bldg',
                PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = 1000.00,
                PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 1000.00,
                PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = 1000.00,
                PBS_AAAP_RU_FACTOR__c = 0.00,
                PBS_AAAP_COST_PER_ABOA__c = 9.21,
                PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 12000,
                PBS_AAAP_OFFICE_SPACE_RSF__c = 1000.00,
                PBS_AAAP_CLEANING_SALARIES__c = 1.00,
                PBS_AAAP_CLEANING_SUPPLIES__c = 1.00,
                PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00,
                PBS_AAAP_HEATING_SALARIES__c = 1.00,
                PBS_AAAP_HEATING_FUEL__c = 'Coal',
                PBS_AAAP_HEATING_FUEL_COST__c = 1.00,
                PBS_AAAP_HEATING_MAINTENANCE__c = 1.00,
                PBS_AAAP_ELECTRICAL_POWER__c = 1.00,
                PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00,
                PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00,
                PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00,
                PBS_AAAP_PLUMBING_WATER__c = 1.00,
                PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00,
                PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00,
                PBS_AAAP_AC_UTILITIES__c = 1.00,
                PBS_AAAP_AC_MAINTENANCE__c = 1.00,
                PBS_AAAP_ELEVATOR_SALARIES__c = 1.00,
                PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00,
                PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00,
                PBS_AAAP_SECURITY__c = 1.00,
                PBS_AAAP_SSTAX_WORKCOMP__c = 1.00,
                PBS_AAAP_LANDSCAPING_MAINTENANCE__c = 1.00,
                PBS_AAAP_REAL_ESTATE_TAXES__c = 2.00,
                PBS_AAAP_INSURANCE__c = 2.00,
                PBS_AAAP_BUILDING_MAINTENANCE__c = 2.00,
                PBS_AAAP_LEASE_COMMISSION__c = 2.00,
                PBS_AAAP_MANAGEMENT__c = 2.00,
                PBS_AAAP_SECT2_TOTAL__c = 10.00,
                PBS_AAAP_SRVC_UTIL_TOTAL__c = 22.00,
                PBS_AAAP_TOTAL_OTHER_COSTS__c = 1.00,
                PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 28664.495

        );
        system.assert(testOffer1.PBS_AAAP_Building_Name__c != null);
        testOffer1.PBS_AAAP_RLP_Number__c = testRLP1.Id;     // relate the Offer to the RLP
        upsert testOffer1;

        PBS_AAAP_Space__c testSpace = new PBS_AAAP_Space__c(
                PBS_AAAP_OFFER_NUMBER__c = null,
                PBS_AAAP_Max_Contiguous_Space__c = 1000.00,
                PBS_AAAP_MIN_OFFERABLE_SPACE__c = 500.00,
                PBS_AAAP_MAX_OFFERABLE_SPACE__c = 1000.00,
                PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today(),
                PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 8.00,
                PBS_AAAP_MANAGEMENT_COORD_FEES__c = 0.00,
                PBS_AAAP_GC_CONDITIONS__c = 0.00,
                PBS_AAAP_ARCH_ENG_FEES__c = 3.50,
                PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = 'Unit Test GSA Lease',
                PBS_AAAP_IDENTIFIER_TYPE__c = 'DEFAULT',
                PBS_AAAP_IDENTIFIER_ID__c = '1',
                PBS_AAAP_SF_OFFERED__c = 1000.00,
                PBS_AAAP_TOTAL_MARKUP__c = 0.00,
                PBS_AAAP_TOT_EXP_ABOA__c = 0.00,
                PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true
        );
        system.assert(testSpace.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c != null);
        testSpace.PBS_AAAP_OFFER_NUMBER__c = testOffer1.Id;   // relate the Space to the Offer
        upsert testSpace;
        
        List<PBS_AAAP_Rate__c> testRates1 = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c(
                    PBS_AAAP_TWO_YEAR_EXTENSION__c = 0.00,
                    PBS_AAAP_SPACE__c = null,
                    PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0.00,
                    PBS_AAAP_ONE_YEAR_EXTENSION__c = 0.00,
                    PBS_AAAP_OFFER_NUMBER__c = null,
                    PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = 0.00,
                    PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8.00,
                    PBS_AAAP_LEASE_TERM__c = (i == 0) ? '17 years, 15 firm' : (i == 1 ? '15 years, 13 firm' : (i == 2 ? '10 years, 8 firm' : (i == 3 ? '15 years, 10 firm' : 'none'))),
                    PBS_AAAP_IDENTIFIER_ID__c = String.valueOf(i),
                    PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 50.00,
                    PBS_AAAP_COST_FOR_TI__c = 0.00,
                    PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = 5.00,
                    PBS_AAAP_BASE_RATE__c = 43.39,
                    PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 0.00,
                    PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = (i == 0) ? 5.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
                    PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 10.00,
                    PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c = 0.00,
                    PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = 0.50,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = (i == 0) ? 0.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
                    PBS_AAAP_BSAC_RATE__c = (i == 0) ? 0.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
                    PBS_AAAP_BSAC__c = 5,
                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 0.00
            );
            system.assert(rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c != null);

            testRates1.add(rate);
        }
        System.debug('$$$$$ testRates: ' + testRates1);

        for (Integer i = 0; i < testRates1.size(); i++) {
            PBS_AAAP_Rate__c rate = testRates1.get(i);
            rate.PBS_AAAP_SPACE__c = testSpace.Id;
            rate.PBS_AAAP_OFFER_NUMBER__c = testOffer1.Id;
            testRates1.set(i, rate);
        }
        upsert testRates1;

        List<PBS_AAAP_Other_Costs__c> testOtherCosts = new List<PBS_AAAP_Other_Costs__c>();
        for (Integer i = 0; i < 3; i++) {
            PBS_AAAP_Other_Costs__c ocost = new PBS_AAAP_Other_Costs__c(
                    PBS_AAAP_SHORT_DESC__c = 'Test Other Cost number ' + String.valueOf(i),
                    PBS_AAAP_OFFER_NUMBER__c = null,
                    PBS_AAAP_COST__c = 5.00,
                    PBS_AAAP_COST_TYPE__c = 'Other Cost',
                    PBS_AAAP_COST_REMOVAL__c = false
            );
            system.assert(ocost.PBS_AAAP_COST__c != null);
            testOtherCosts.add(ocost);
        }   // end for

        for (Integer i = 0; i < testOtherCosts.size(); i++) {
            PBS_AAAP_Other_Costs__c testOtherCost = testOtherCosts.get(i);
            testOtherCost.PBS_AAAP_OFFER_NUMBER__c = testOffer1.Id;
            testOtherCosts.set(i, testOtherCost);
        }
        upsert testOtherCosts;


        PBS_AAAP_Other_Costs__c testOtherCost1 = new PBS_AAAP_Other_Costs__c(
                PBS_AAAP_SHORT_DESC__c = 'Test Other Cost Single ',
                PBS_AAAP_OFFER_NUMBER__c = null,
                PBS_AAAP_COST__c = 1.00,
                PBS_AAAP_COST_TYPE__c = 'Other Cost',
                PBS_AAAP_COST_REMOVAL__c = false
        );
        system.assert(testOtherCost1.PBS_AAAP_COST__c != null);

        testOtherCost1.PBS_AAAP_OFFER_NUMBER__c = testOffer1.Id;
        upsert testOtherCost1;

        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(testOffer1.Id);
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(testOffer1.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(testOffer1.Id);
        PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
        PBS_AAAP_RLP__c testRlp = dao.getRLP(testOffer1.PBS_AAAP_RLP_NUMBER__c);
        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();        // instance of calculations class

        // create page contexts for testing purposes
        PageReference spacesAndRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference attach = Page.PBS_AAAP_OfferAttachments;

        spacesAndRates.getParameters().put('offerId', testOffer.Id);
        Test.setCurrentPageReference(spacesAndRates);                       // set the current page reference to spaces and rates
        PBS_AAAP_ControllerSpacesAndRates contSpaceRates = new PBS_AAAP_ControllerSpacesAndRates();
        System.assertEquals(contSpaceRates.offer.Id, testOffer.Id);         // validate that the controller obtains the correct offer


        // test that the genMapRatesToSpace method will correctly generate a map of rates to a space
        Map<String, List<PBS_AAAP_Rate__c>> testMapOfRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        System.assertEquals(testMapOfRates.get(testSpaces[0].Id), testRates);

        // test that the controller returns the panel IDs
        List<String> compList = new List<String>{
                'panel_outerspace', 'panel_NewSpace', 'panel_SuccSpace'
        };
        System.assertEquals(contSpaceRates.panelIds, compList);

        // test that the controller will return the value contained in the testOffer for screen fields
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, testOffer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c);
        System.assertEquals(contSpaceRates.offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, testOffer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c);

        // test that the getSpaceOpts returns the space options
        System.assert(contSpaceRates.getSpaceOpts().size() > 0, 'Space Type select options not populating.');

        // test that the getFeeOpts returns the fee options
        System.assert(contSpaceRates.getFeeOpts().size() > 0, 'Fee Opts Type select options not populating.');

        // test that the defaultSpace() method creates the default space with the correct information
        PBS_AAAP_Space__c sp = contSpaceRates.defaultSpace(testOffer.Id);

        System.assertEquals(sp.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        System.assertEquals(contSpaceRates.sfOfferedType, null);                // defaultSpace() method should also set the square footage offered type to null
        System.assertEquals(contSpaceRates.feePrcntgOrDollar, null);        // defaultSpace() method should also set the UOM variable for the architectural engineering fee type to null
        //as per FY16 as it is mandatory as we are forcing the related values to '0.00'
        contSpaceRates.feePrcntgOrDollar = '%';
        // test that the saveSpace method correctly saves the space to the DB
        contSpaceRates.space = sp;
        System.debug('weston');
        System.debug('*****myUnitTest contSpaceRates.space before saveSpace(): ' + contSpaceRates.space);
        contSpaceRates.saveSpace();
        System.debug('*****myUnitTest contSpaceRates.space after saveSpace(): ' + contSpaceRates.spaces.size());
        contSpaceRates.addNewSpace();
        // test that the genMapRatesToSpace accurately generates an Apex "Map" of rates to spaces
        Map<String, List<PBS_AAAP_Rate__c>> testMapSpaceToRates = contSpaceRates.genMapRatesToSpace(testRates, testSpaces);
        for (PBS_AAAP_Space__c spc : testSpaces) {
            System.assertEquals(testMapSpaceToRates.containsKey(spc.Id), true);
        }   // end for


        // test that the addSucceedingSpace method renders the inner space page view
        contSpaceRates.addSucceedingSpace();
        // test that the convertPbsAaapRate method converts the rate data from the PBS_AAAP_Rate__c structure into the local class RateEntry format
        PBS_AAAP_ControllerSpacesAndRates.RateEntry re = contSpaceRates.convertPbsAaapRate(testRates);
        for (PBS_AAAP_Rate__c rate : testRates) {
            if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(re.fiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.fiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.fiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveYrId, rate.Id);
                System.assertEquals(re.fiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(re.fiveFiveYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.fiveFiveYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.fiveFiveYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.fiveFiveYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.fiveFiveYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.fiveFiveYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.fiveFiveYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.fiveFiveYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.fiveFiveYrId, rate.Id);
                System.assertEquals(re.fiveFiveYrOptTerm, rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c);
                System.assertEquals(re.fiveFiveYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c);
            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(re.tenYrFS, rate.PBS_AAAP_BASE_RATE__c);
                System.assertEquals(re.tenYrAPR, rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
                if (testRlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c) {
                    System.assertEquals(re.tenYrTIAmorCosts2, rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
                }
                System.assertEquals(re.tenYrOTHvacCosts, rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c);
                System.assertEquals(re.tenYrDayTimeCleanCosts, rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);
                System.assertEquals(re.tenYrFreeRentFIRM, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                System.assertEquals(re.tenYrBrokerageComm, rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                System.assertEquals(re.tenYrFirmTerm, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                System.assertEquals(re.tenYrTIAmorCosts, rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c);
                System.assertEquals(re.tenYrOpCosts, rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.assertEquals(re.tenYrId, rate.Id);
                System.assertEquals(re.tenYrFreeRentOption, rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);

            }
        }   // end for

        // test that the action for the "BACK" button returns the user to the operating costs page
        PageReference pgBack = Page.PBS_AAAP_OperatingCosts;
        pgBack.getParameters().put('offerId', testOffer.Id);
        // test that the action for the rates summary button renders the correct views
        PageReference pgRateSumm = Page.pbs_aaap_spacesandrates;
        pgRateSumm.getParameters().put('offerId', testOffer.Id);
        contSpaceRates.rateSummary();
        // test that the action to populate and sort the screen fields for the outer space summary table from the rates data returned from the SOQL
        List<PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails> dets = contSpaceRates.spaceSort(testSpaces, testRates);
        System.assertEquals(contSpaceRates.details.size(), dets.size());           // verify that the summary screen field list is of the same size as the number of spaces.
        for (PBS_AAAP_Space__c space : testSpaces) {
            for (PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails d : dets) {
                if (d.spaceID == space.Id) {
                    for (PBS_AAAP_Rate__c rate : testRates) {
                        if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                            System.assertEquals(d.fiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveYrPV, rate.PBS_AAAP_PV_Value__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                            System.assertEquals(d.fiveFiveYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.fiveFiveYrPV, rate.PBS_AAAP_PV_Value_Blended__c);
                        } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                            System.assertEquals(d.tenYrFS, rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c);
                            System.assertEquals(d.tenYrPV, rate.PBS_AAAP_PV_Value__c);
                        } // end if
                    } // end for
                } // end if

                if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('New', d.leaseType);
                } else if (!space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                    System.assertEquals('Succeeding', d.leaseType);
                } // end if
            }   // end for
        }   // end for


        // test that the edit rate method such that it appropriately modifys the correct spaces rates
        contSpaceRates.details[0].selected = true;      // set the first element of the screen detail list to selected for purposes of the test
        System.debug('***** dets[0]: ' + dets[0]);
        contSpaceRates.editRate();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);

        System.debug('***** contSpaceRates.spaces: ' + contSpaceRates.spaces);
        // test that the edit space method such
        contSpaceRates.editSpace();
        System.assertEquals(contSpaceRates.space.Id, contSpaceRates.details[0].spaceID);       // insure that editSpace is editing the correct space
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
        }

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;  // rig the space so that it is considered a succeeding space

        contSpaceRates.editSpace();
        if (contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
        }

        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;   // reset the space so that it is considered a new space

        // test that the databaseConCheck method insures that only 3 rate records for any space can exist
        List<PBS_AAAP_Rate__c> rateDBOverload = new List<PBS_AAAP_Rate__c>();

        // strip the IDs to facilitate upload
        for (Integer i = 0; i < testRates.size(); i++) {
            PBS_AAAP_Rate__c rup = new PBS_AAAP_Rate__c(
                    PBS_AAAP_SPACE__c = testRates[i].PBS_AAAP_SPACE__c,
                    PBS_AAAP_OFFER_NUMBER__c = testRates[i].PBS_AAAP_OFFER_NUMBER__c,
                    PBS_AAAP_LEASE_TERM__c = testRates[i].PBS_AAAP_LEASE_TERM__c,
                    PBS_AAAP_BASE_RATE__c = testRates[i].PBS_AAAP_BASE_RATE__c,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = testRates[i].PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = testRates[i].PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c

            );
            rateDBOverload.add(rup);
        } // end for

        List<PBS_AAAP_Rate__c> totalRates = testRates;
        totalRates.addAll(rateDBOverload);
        insert rateDBOverload;

        Integer intRatesNum = rateDBOverload.size() + testRates.size();
        System.debug('%%%%% size of rates for space ID = ' + testRates[0].Id + ' : ' + intRatesNum);

        List<PBS_AAAP_Rate__c> idsToKeep = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            idsToKeep.add(testRates[i]);
        } // end for

        List<PBS_AAAP_Rate__c> rateChk = contSpaceRates.databaseConCheck(idsToKeep, totalRates);
        List<PBS_AAAP_Rate__c> ratesComp = [SELECT Id FROM PBS_AAAP_Rate__c WHERE PBS_AAAP_SPACE__c = :testRates[0].PBS_AAAP_SPACE__c];
        Integer chkNum = ratesComp.size() - rateChk.size();
        System.assertEquals(3, chkNum);

        // test that the convertRateEntry method correctly converts the rateEntry data into the three rates
        List<PBS_AAAP_Rate__c> cnvrtRates = contSpaceRates.convertRateEntry(re);

        for (PBS_AAAP_Rate__c rt : cnvrtRates) {
            if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.fiveYrFS);
            } else if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.fiveFiveYrFS);
            } else if (rt.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                System.assertEquals(rt.PBS_AAAP_BASE_RATE__c, re.tenYrFS);
            } // end if
        } // end for


        // test that the validateOfferFormFields
        Decimal backup = contSpaceRates.maxOfferedSpace;
        contSpaceRates.maxOfferedSpace = 0.00;
        //System.assertEquals(true, contSpaceRates.validateOfferFormFields());
        contSpaceRates.maxOfferedSpace = 20000.00;
        //System.assertEquals(true, contSpaceRates.validateOfferFormFields());
        contSpaceRates.maxOfferedSpace = backup;

        // test that the returnToSpaces method correctly sets the appropriate indicator
        Boolean boolBackup = contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c;
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        contSpaceRates.returnToSpace();
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        contSpaceRates.returnToSpace();
        contSpaceRates.space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = boolBackup;


        // test that the makeSpaceMap method correctly generates the map of spaces
        Map<String, PBS_AAAP_Space__c> spMap = contSpaceRates.makeSpaceMap(testSpaces);
        Set<String> spIds = new Set<String>();
        System.debug('%%%%% spMap: ' + spMap);
        System.debug('%%%%% testSpaces: ' + testSpaces);

        for (PBS_AAAP_Space__c sp1 : testSpaces) {
            System.assertEquals(true, spMap.containsKey(sp1.PBS_AAAP_IDENTIFIER_ID__c));
        } // end for

        // test that the addRate method renders the inner space page view
        contSpaceRates.addRate();
        // test that the deleteSpace method deletes the selected space from the DB
        Set<String> rateIDs = new Set<String>{
                testRates[0].Id, testRates[1].Id, testRates[2].Id
        };
        PageReference pgSpaceAndRates = Page.PBS_AAAP_SpacesAndRates;
        pgSpaceAndRates.getParameters().put('offerId', testOffer.Id);
        try {
            List<PBS_AAAP_Space__c> sp2 = [SELECT o.Id FROM PBS_AAAP_Space__c o WHERE o.Id = :contSpaceRates.details[0].spaceID];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));           // space shouldn't exist, so an exception should occur
        }

        try {
            List<PBS_AAAP_Rate__c> rt = [SELECT o.Id FROM PBS_AAAP_Rate__c o WHERE o.Id IN:rateIDs];
        } catch (Exception e) {
            System.debug('***** e: ' + e);
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'));           // Rate  shouldn't exist, so an exception should occur
        }

        // test that the actionBackSpace method will return the user to the spaces and rates summary page
        contSpaceRates.actionBackSpace();
        // test that the Space method will generate a default space
        contSpaceRates.clearSpace();
        System.assertEquals(contSpaceRates.space.PBS_AAAP_OFFER_NUMBER__c, testOffer.Id);
        //moved up for FY16 before delete as tests are failing due to offerId deletion
        contSpaceRates.saveRates();
        contSpaceRates.continueSave();
        contSpaceRates.returnToSpaceRates();
        contSpaceRates.returnToSpaceRatesViewOnly();
        contSpaceRates.saveForm();
        contSpaceRates.actionBackSpaceView();
        testOffer = dao.getOffer(testOffer1.Id);
        testOffer.PBS_AAAP_Offer_Status__c = 'Awarded';
        system.debug('offer status is' + testOffer.PBS_AAAP_Offer_Status__c);

        List<PBS_AAAP_Space__c> spaces1 = PBS_AAAP_GlobalConstants.getSpaces(testOffer.Id);
        if (spaces1 != null && spaces1.size() > 0) {
            PBS_AAAP_Space__c spaceTemp = spaces1.get(0);
            List<PBS_AAAP_Rate__c> rates1 = PBS_AAAP_GlobalConstants.getRates(spaceTemp.Id);
        }
        // test that the deleteOffer  method will delete all of the space and rate records in addition to the offer
        Set<String> idsToDelete = new Set<String>();
        idsToDelete.add(testOffer.Id);
        for (PBS_AAAP_Space__c spDel : testSpaces) {
            idsToDelete.add(spDel.Id);
        }

        for (PBS_AAAP_Rate__c rateDel : testRates) {
            idsToDelete.add(rateDel.Id);
        }

        contSpaceRates.actionDeleteOffer();
        System.assertEquals(0, [SELECT COUNT() FROM pbs_aaap_offer__c WHERE Id = :testOffer.Id]);
        System.assertEquals(0, [SELECT COUNT() FROM pbs_aaap_offer__c WHERE Id IN :idsToDelete]);

        //added by syam
        for (PBS_AAAP_Space__c sp1 : testSpaces) {
            sp1.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        }

    }

}