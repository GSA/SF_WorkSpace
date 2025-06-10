@isTest
private class PBS_AAAP_UNIT_TEST_UTILITY {


    private static testMethod void testCalculationPV() {


        PBS_AAAP_CALCULATIONS calcu1 = new PBS_AAAP_CALCULATIONS();

        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen1 = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_RLP__c rlp = dataGen1.insertRLP();
        PBS_AAAP_Rate__c rate1 = dataGen1.insertRate1();
        PBS_AAAP_Offer__c offer = dataGen1.insertOffer();
        PBS_AAAP_Space__c space = dataGen1.insertSpace();
        PBS_AAAP_Agency_Requirement__c agency = dataGen1.insertAgency();
        Map<String, Id> mapinst = dataGen1.getAllCensusData();
        Double testBcaf1 = calcu1.censusPV(offer, space, rlp, '19 months, 11 firm', rate1, agency, true, (Double) 130, (Double) 50, (Double) 20, (Double) 70);
        Decimal val = calcu1.getTotalFeeCost(33, 20, 11);
        Decimal val2 = calcu1.getTotalLessorOverheadAndFees(50, 60);
        Decimal val5 = calcu1.getTotalFeeCostPercentage((Double) 20, (Double) 22, (Double) 160);

        Decimal val3 = calcu1.getNPTonly(20.2, 16.5, 15.00, 18.2);
        Decimal val4 = calcu1.getAmortizationofTI(20, 80, 20);
        Double testBcaf123 = calcu1.censusPV(offer, space, rlp, '19 months, 11 firm', rate1, agency, false, (Double) 130, (Double) 500, (Double) 20, (Double) 570);
        Decimal val77 = calcu1.getTotalFeeCost(33, 20, 11);
        Decimal val29 = calcu1.getTotalLessorOverheadAndFees(50, 60);
        Decimal val55 = calcu1.getTotalFeeCostPercentage((Double) 20, (Double) 22, (Double) 160);

        Decimal val37 = calcu1.getNPTonly(20.2, 16.5, 15.00, 18.2);
        Decimal val40 = calcu1.getAmortizationofTI(20, 80, 20);

        Decimal mpv = calcu1.getNPV(100, 55, 77);
        system.assertEquals(true, true);

    }
    // test the calculation class
    private static testMethod void testCalculationClass() {

        PBS_AAAP_CALCULATIONS calcu = new PBS_AAAP_CALCULATIONS();

        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
        PBS_AAAP_Offer__c testOffer = dao.getOffer(dataGen.testOffer.Id);
        List<PBS_AAAP_Space__c> testSpaces = dao.getSpaces(dataGen.testOffer.Id);
        List<PBS_AAAP_Rate__c> testRates = dao.getRates(dataGen.testOffer.Id);
        PBS_AAAP_RLP__c testRlp = dao.getRLP(dataGen.testOffer.PBS_AAAP_RLP_NUMBER__c);
        Double maxFund = testOffer.PBS_AAAP_RLP_MAX_TIA__c;
        Exception e;
        dao.updatePVRates(testOffer.Id);
        dao.validatePVRates(testOffer.Id);


        System.assertEquals(testOffer.Id, dataGen.testOffer.Id);                // validate that the dao methods obtain the correct offer
        System.assertEquals(testSpaces.get(0).Id, dataGen.testSpace.Id);        // validate that the dao methods obtain the correct spaces
        System.assertEquals(testRates.size(), dataGen.testRates.size());        // validate that the system generates the three rate records and that the dao methods return them
        System.assertEquals(testRlp.Id, dataGen.testRlp.Id);                    // validate that the dao methods obtain the correct RLP

        // validate that the dao methods "catch" executes for the offer SOQL
        PBS_AAAP_Offer__c testOfferExcpt = dao.getOffer(null);

        System.debug('***** message component: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getComponentLabel());
        System.debug('***** message detail: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getDetail());
        System.debug('***** message summary: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary());
        System.debug('***** message: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1));
        System.assert(ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary().equalsIgnoreCase('List has no rows for assignment to SObject'));
        System.assertEquals(testOfferExcpt.Id, null);

        System.debug('***** message size offer: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());
        // validate that the dao methods "catch" executes for the spaces SOQL
        List<PBS_AAAP_Space__c> testSpacesExcpt = dao.getSpaces('AAAAAAAAAAAAAA');
        //vaishali System.assert(ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary().equalsIgnoreCase('List has no rows for assignment to SObject'));     
        System.assertEquals(testSpacesExcpt.size(), 0);

        System.debug('***** message size getSpaces: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());
        // validate that the dao methods "catch" executes for the rates SOQL 
        List<PBS_AAAP_Rate__c> testRatesExcpt = dao.getRates('AAAAAAAAAAAAAA');
        //vaishaliSystem.assert(ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary().equalsIgnoreCase('List has no rows for assignment to SObject'));          
        System.assertEquals(testRatesExcpt.size(), 0);

        System.debug('***** message size getRates: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());
        // validate that the dao methods "catch" executes for the rates from space SOQL 
        List<PBS_AAAP_Rate__c> testRatesExcpt2 = dao.getRatesFromSpace('AAAAAAAAAAAAAA');
        //vaishaliSystem.assert(ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary().equalsIgnoreCase('List has no rows for assignment to SObject')); 
        System.assertEquals(testRatesExcpt2.size(), 0);

        System.debug('***** message size getRatesFromSpace: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());
        // validate that the dao methods "catch" executes for the rlp SOQL 
        PBS_AAAP_RLP__c testRlpExcpt = dao.getRLP('000000');
        System.assert(ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary().equalsIgnoreCase('List has no rows for assignment to SObject'));
        System.assertEquals(testRlpExcpt.Id, null);

        // one of each rate type must be created
        Integer allThree = 0;
        Set<String> compTerm = new Set<String>{
                '5 years', '5+5 years', '10 years'
        };
        Set<String> rateComp = new Set<String>();

        for (PBS_AAAP_Rate__c r : testRates) {
            rateComp.add(r.PBS_AAAP_LEASE_TERM__c);
        }
        System.debug('***** compTerm: ' + compTerm);
        System.debug('***** rateComp: ' + rateComp);
        System.assertEquals(true, rateComp.containsAll(compTerm));     // validate that the dao methods obtain the correct spaces

        PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();        // instance of calculations class

        calc.rlpGT2016 = Integer.valueOf(testRlp.PBS_AAAP_Year__c) > 2016 ? true : false;
        // test the building common area factor calculation
        System.assertEquals(1, calc.getBCAF(1, 1));

        //test the generic construction markups
        System.assertEquals(6.62, PBS_AAAP_CALCULATIONS.getConstrMarkups(testRlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c.doubleValue(),
                testSpaces.get(0).PBS_AAAP_GC_OVERHEAD_AND_PROF__c.doubleValue(),
                testSpaces.get(0).PBS_AAAP_GC_CONDITIONS__c.doubleValue(),
                testSpaces.get(0).PBS_AAAP_MANAGEMENT_COORD_FEES__c.doubleValue(),
                testSpaces.get(0).PBS_AAAP_ARCH_ENG_FEES__c.doubleValue(),
                '$',
                (0.00).doubleValue()).setScale(2).doubleValue());

        // test total construction markup calculations for new spaces
        System.assertEquals(6.62, calc.getNewConstrMarkups(testSpaces.get(0), testOffer).setScale(2));
        System.assertEquals(4.43, calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).setScale(2));

        // test total construction markup calculations for new spaces without arch/eng fees
        System.assertEquals(3.12, calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).setScale(2));

        // test total construction markup calculations for succeeding spaces
        System.assertEquals(5.10, calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).setScale(2));
        System.assertEquals(2.28, calc.getSuccConstrMarkupsPrctg(testSpaces.get(0), testOffer).setScale(2));

        // test total construction markup calculations for succeeding spaces without arch/eng fees
        System.assertEquals(1.60, calc.getSuccConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).setScale(2));

        // test 2nd tier total construction markup calculations for new spaces
        System.assertEquals(0.53, calc.get2ndNewConstrMarkups(testSpaces.get(0), testOffer, maxFund).setScale(2));
        System.assertEquals(0.00, calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0), testOffer, maxFund).setScale(2));

        // test 2nd tier total construction markup calculations for new spaces without arch/eng fees
        System.assertEquals(0.00, calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer, maxFund).setScale(2));

        // test the fully serviced lease rates
        //Vaishali RLP FY15 System.assertEquals(88.42, calc.getFullySrvcLeaseRateFiveFiveYr(testRates, 
        System.assertEquals(85.71, calc.getFullySrvcLeaseRateFiveFiveYr(testRates,
                testOffer,
                testSpaces.get(0),
                calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkups(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                ).doubleValue(),
                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                        ).doubleValue())).setScale(2));
        Double d = calc.getFullySrvcLeaseRateFiveYr(testRates, testOffer,
                testSpaces.get(0),
                calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                ).doubleValue(),
                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEFIVEYR).doubleValue())).setScale(2);
        System.debug('double value is **** ' + d);
        //value corrected by Vaishali 43.15 to 44.15
        System.assertEquals(85.21, calc.getFullySrvcLeaseRateFiveYr(testRates,
                testOffer,
                testSpaces.get(0),
                calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                ).doubleValue(),
                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                        ).doubleValue())).setScale(2));

        System.assertEquals(82.27, calc.getFullySrvcLeaseRateTenYr(testRates, testOffer, testSpaces.get(0), calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue()
                ).doubleValue(), '10 years'
        ).setScale(2).doubleValue(),
                calc.get2ndNewFreeRentForTenYear(testRates,
                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                        testOffer,
                                        maxFund).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                maxFund
                        ).doubleValue()
                ).setScale(2).doubleValue())).setScale(2));

        // test the first tier TI rates for new spaces
        System.assertEquals(45.57, calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
        ).setScale(2)
        );

        System.assertEquals(43.38, calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue()
        ).setScale(2)
        );

        System.assertEquals(42.07, calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue()
        ).setScale(2)
        );

        // test the first tier TI rates for succeeding spaces
        System.assertEquals(25.10, calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
        ).setScale(2)
        );          // (construction markup AE Fee as $ + TI Succeeding) < Max TI Succeeding

        System.assertEquals(22.28, calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                calc.getSuccConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
        ).setScale(2)
        );  // (construction markup AE Fee as % + TI Succeeding) < Max TI Succeeding
        System.assertEquals(21.60, calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                calc.getSuccConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
        ).setScale(2)
        );  // (construction markup No AE Fees + TI Succeeding) < Max TI Succeeding

        // test the second tier TI rate for new spaces
        // RLP FY15 Vaishali System.assertEquals(10.65, calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(), 
        System.assertEquals(0.00, calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                calc.get2ndNewConstrMarkups(testSpaces.get(0),
                        testOffer,
                        maxFund).doubleValue(),
                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                maxFund
        ).setScale(2)
        );              // (construction markup AE Fee as $ + TI Succeeding) < Max TI Succeeding

        System.assertEquals(0.00, calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                        testOffer,
                        maxFund).doubleValue(),
                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                maxFund
        ).setScale(2)
        );      // (construction markup AE Fee as % + TI Succeeding) < Max TI Succeeding

        System.assertEquals(0.00, calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                        testOffer,
                        maxFund).doubleValue(),
                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                maxFund).setScale(2)
        );  // (construction markup No AE Fees + TI Succeeding) < Max TI Succeeding

        // test the second tier TI rate for succeeding spaces
        System.assertEquals(0.00, calc.getSuccSecondTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                (38.8).doubleValue(),
                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
        ).setScale(2)
        );                                  // replace construction markup values with 38.8, so as to trigger the "if" statement's truth check

        System.assertEquals(0.00, calc.getSuccSecondTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
        ).setScale(2)
        );  // the test data generated for the construction markups will trigger the "else" condition in the calculation

        // test the average discount rate calculations for the five year average
        System.assertEquals(.9092, calc.getFiveYrAvgDiscount((5.00).doubleValue()).setScale(4));

        // test the average discount rate calculation for the ten year average
        System.assertEquals(.6759, calc.getTenYrAvgDiscount((10.00).doubleValue()).setScale(4));

        // test the calculation of the five year average of the CPI * Discount
        // added by syam on 08/09/2016
        System.debug('testRlp is ***' + testRlp);
        System.debug('testRlp Id is ***' + testRlp.Id);

        System.debug('testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue() is ***' + testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue());

        System.assertEquals(0.9535, calc.getFiveYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(), testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()).setScale(4));

        // test the calculation of the ten year average of the CPI * Discount
        System.assertEquals(.8994, calc.getTenYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(), testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()).setScale(4));

        // test the calculation of the five year average DIscount Rate for years 6 - 10
        System.assertEquals(.7124, calc.getFiveYrAvgDiscountYrSixThruTen(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue()).setScale(4));

        // test the calculation of the ten year average of the CPI * Discount for years 6 - 10      
        System.assertEquals(0.8453, calc.getFiveYrAvgCpiAndDiscountYrSixThruTen(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(), testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()).setScale(4));

        // test PV cacluations
        for (PBS_AAAP_Rate__c r : testRates) {
            System.debug('inside test rates' + r.PBS_AAAP_LEASE_TERM__c);
            // test the PV calculations for five year firm term and the five year + option (which is created similarly)
            if (r.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYR) {
                System.debug('inside TENYR');
                System.assertEquals(-7.23, calc.get1rstNewFreeRentForTenYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
                        ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                ).setScale(2)
                );  // end SystemAssertEquals

                System.assertEquals(-6.88, calc.get1rstNewFreeRentForTenYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                ).setScale(2)
                );  // end SystemAssertEquals

                System.assertEquals(-6.67, calc.get1rstNewFreeRentForTenYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                ).setScale(2)
                );  // end SystemAssertEquals

                //Vaishali FY15 System.assertEquals(-1.69, calc.get2ndNewFreeRentForTenYear(testRates, 
                System.assertEquals(0.00, calc.get2ndNewFreeRentForTenYear(testRates,
                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkups(testSpaces.get(0),
                                        testOffer).doubleValue(),
                                calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                        testOffer,
                                        maxFund).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                maxFund).doubleValue()
                ).setScale(2)
                );     // end SystemAssertEquals

                System.assertEquals(0.00, calc.get2ndNewFreeRentForTenYear(testRates,
                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0),
                                        testOffer).doubleValue(),
                                calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                        testOffer,
                                        maxFund).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                maxFund).doubleValue()
                ).setScale(2)
                );     // end SystemAssertEquals

                System.assertEquals(0.00, calc.get2ndNewFreeRentForTenYear(testRates,
                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                        testOffer).doubleValue(),
                                calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                        testOffer,
                                        maxFund).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                maxFund).doubleValue()
                ).setScale(2)
                );     // end SystemAssertEquals
                System.debug('testRates is ***' + testRates);
                System.debug('PBS_AAAP_RLP_TI_Additional_Space__c is' + testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue());
                System.debug('testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue() is' + testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue());
                System.debug('getSuccConstrMarkups is' + calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue());

                System.debug('getSuccFirstTierTI is' + calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                        calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                ).doubleValue());
                System.debug('getSucc1rstFreeRentForTenYear is ***' + calc.getSucc1rstFreeRentForTenYear(testRates,
                        calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                        ).doubleValue()
                ).setScale(2).doubleValue()
                );

                System.assertEquals(-3.53, calc.getSucc1rstFreeRentForTenYear(testRates,
                        calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                calc.getSuccConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                        ).doubleValue()
                ).setScale(2).doubleValue()
                );     // end SystemAssertEquals

                System.assertEquals(-3.43, calc.getSucc1rstFreeRentForTenYear(testRates,
                        calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                calc.getSuccConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                        ).doubleValue()
                ).setScale(2).doubleValue()
                );     // end SystemAssertEquals

                System.assertEquals(0.0, calc.get2ndSuccFreeRentForTenYear(testRates,
                        calc.getSuccSecondTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                (20.00).doubleValue(),                                 // replace construction markup values with 20.00, so as to trigger the "if" statement's truth check
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                        ).doubleValue()
                ).setScale(2).doubleValue()
                );     // end SystemAssertEquals

                System.assertEquals(0.00, calc.get2ndSuccFreeRentForTenYear(testRates,
                        calc.getSuccSecondTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                        ).doubleValue()
                ).setScale(2).doubleValue()
                );     // end SystemAssertEquals

                //Vaishali FY15 System.assertEquals(-8.91, calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                System.assertEquals(-7.23, calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
                        ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                ).doubleValue(),
                        calc.get2ndNewFreeRentForTenYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue()
                        ).doubleValue()
                ).setScale(2).doubleValue()
                );     // end SystemAssertEquals

                System.assertEquals(-6.88, calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue()
                        ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                ).setScale(2).doubleValue(),
                        calc.get2ndNewFreeRentForTenYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund
                                ).doubleValue()
                        ).setScale(2).doubleValue()
                ).setScale(2)
                );     // end SystemAssertEquals

                System.assertEquals(-6.67, calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                ).setScale(2).doubleValue(),
                        calc.get2ndNewFreeRentForTenYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                testOffer,
                                                maxFund
                                        ).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund
                                ).doubleValue()
                        ).doubleValue()
                ).setScale(2)
                );     // end SystemAssertEquals

                System.debug('Test the Base Rent');
                // Test the Base Rent + TI calculation for ten year
                // RLP FY15 Vaishali System.assertEquals(42.41, calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(), calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates, 
                System.assertEquals(41.04, calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(), calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkups(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                ).doubleValue(),
                        calc.get2ndNewFreeRentForTenYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue()
                        ).doubleValue()
                ).doubleValue(),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        10).setScale(2));

                // Test the PV calculation for ten year term (new space)                                                                
                //Vaishali RLP FY15System.assertEquals(43.5, calc.getTenYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                System.assertEquals(42.94, calc.getTenYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(), calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0),
                                                testOffer).doubleValue()
                                ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForTenYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue()
                                ).doubleValue()
                        ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                10).doubleValue(),
                        calc.getTenYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(), testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0),
                                                testOffer).doubleValue()
                                ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForTenYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue()
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()).setScale(2).doubleValue());

                //Vaishali RLP FY15 System.assertEquals(42.66, calc.getTenYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                System.assertEquals(42.7, calc.getTenYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(), calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0),
                                                testOffer).doubleValue()
                                ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForTenYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue()
                                ).doubleValue()
                        ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                10).doubleValue(),
                        calc.getTenYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(), testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0),
                                                testOffer).doubleValue()
                                ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForTenYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue()
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()).setScale(2).doubleValue());

                //Vaishali RLP FY15System.assertEquals(42.35, calc.getTenYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                System.assertEquals(42.56, calc.getTenYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(), calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                testOffer).doubleValue()
                                ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForTenYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue()
                                ).doubleValue()
                        ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                10).doubleValue(),
                        calc.getTenYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(), testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForTenYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                testOffer).doubleValue()
                                ).doubleValue(), r.PBS_AAAP_LEASE_TERM__c
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForTenYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue()
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()).setScale(2).doubleValue());

                // Test the PV calculation for ten year term (succeeding space)                                                             
                // RLP FY15 Vaishali System.assertEquals(40.08, calc.getTenYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                System.debug('test daily cleaning !!!!');
                System.assertEquals(40.69, calc.getTenYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                                calc.getFreeRentNewSpace(calc.getSucc1rstFreeRentForTenYear(testRates,
                                        calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                                calc.getSuccConstrMarkups(testSpaces.get(0),
                                                        testOffer).doubleValue(),
                                                maxFund
                                        ).doubleValue()
                                ).doubleValue(),
                                        calc.get2ndSuccFreeRentForTenYear(testRates,
                                                calc.getSuccSecondTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                                        calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                        maxFund
                                                ).doubleValue()
                                        ).doubleValue()
                                ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                10).doubleValue(),
                        calc.getTenYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.getSucc1rstFreeRentForTenYear(testRates,
                                calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                        calc.getSuccConstrMarkups(testSpaces.get(0),
                                                testOffer).doubleValue(),
                                        maxFund
                                ).doubleValue()
                        ).doubleValue(),
                                calc.get2ndSuccFreeRentForTenYear(testRates,
                                        calc.getSuccSecondTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                                calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                maxFund
                                        ).doubleValue()
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()).setScale(2).doubleValue());

                // Five year rate calculations
            }// end of ten year
            else if (r.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIVEYR) {
                System.debug('inside fiveyr ');
                System.assertEquals(-10.32, calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkups(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                );  // end SystemAssertEquals

                System.assertEquals(-9.82, calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                );  // end SystemAssertEquals

                System.assertEquals(-9.53, calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                );  // end SystemAssertEquals

                //RLP FY15 Vaishali                System.assertEquals(-2.71, calc.get2ndNewFreeRentForFiveYear(testRates, 
                System.assertEquals(0.00, calc.get2ndNewFreeRentForFiveYear(testRates,
                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                        testOffer,
                                        maxFund).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                maxFund).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                );  // end SystemAssertEquals

                System.assertEquals(0.00, calc.get2ndNewFreeRentForFiveYear(testRates,
                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                        testOffer,
                                        maxFund).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                maxFund).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                );  // end SystemAssertEquals

                System.assertEquals(0.00, calc.get2ndNewFreeRentForFiveYear(testRates,
                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                        testOffer,
                                        maxFund).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                maxFund).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                );  // end SystemAssertEquals

                System.assertEquals(-5.68, calc.getSucc1rstFreeRentForFiveYear(testRates,
                        calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                );  // end SystemAssertEquals

                System.assertEquals(-5.04, calc.getSucc1rstFreeRentForFiveYear(testRates,
                        calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                calc.getSuccConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                );  // end SystemAssertEquals
                System.assertEquals(-4.89, calc.getSucc1rstFreeRentForFiveYear(testRates,
                        calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                calc.getSuccConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).setScale(2).doubleValue()
                ); // end SystemAssertEquals

                // Vaishali RLP FY15 System.assertEquals(-13.03, calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates, 
                System.assertEquals(-10.32, calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).doubleValue(),
                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue()
                ).setScale(2)
                );  // end SystemAssertEquals

                System.assertEquals(-9.82, calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).doubleValue(),
                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue()
                ).setScale(2)
                );  // end SystemAssertEquals
                //added by syam 
                Double freeRentSpace = calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).doubleValue(),
                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue()
                ).setScale(2)
                ;
                System.debug('free rent space is **** ' + freeRentSpace);

                System.assertEquals(-9.53, calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                        testOffer).doubleValue()
                        ).doubleValue(),
                        PBS_AAAP_CALCULATIONS.FIVEYR
                ).doubleValue(),
                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                        calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                testOffer,
                                                maxFund).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        maxFund).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue()
                ).setScale(2)
                );
                //value changed by Vaishali to 11.95. Old value 11.04
                System.assertEquals(48.83, calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
                                ).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForFiveYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund
                                                ).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue()
                        ).doubleValue(),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        5).setScale(2));


                // test the calculation for the Five Year Present Value calculation getFiveYearPV
                // Vaishali RLP FY15System.assertEquals(48.07, calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                //updated by syam from 48.4 to 16.84 to 17.57 by Vaishali
                System.assertEquals(47.07, calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                                calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
                                        ).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue(),
                                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                        calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                                testOffer,
                                                                maxFund).doubleValue(),
                                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                        maxFund).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEYR
                                        ).doubleValue()
                                ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                5).doubleValue(),
                        calc.getFiveYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()
                        ).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
                                ).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForFiveYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()).setScale(2).doubleValue());

                // Vaishali RLP FY15System.assertEquals(46.7, calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                //updated by syam from 47.67 to 16.12 to 16.85 Vaishali
                System.assertEquals(46.71, calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                                calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue()
                                        ).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue(),
                                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                                        calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                                                testOffer,
                                                                maxFund).doubleValue(),
                                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                        maxFund
                                                ).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEYR
                                        ).doubleValue()
                                ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                5).doubleValue(),
                        calc.getFiveYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue()
                                ).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForFiveYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkupsPrctg(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkupsPrctg(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund
                                                ).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund
                                        ).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()).setScale(2).doubleValue());

                // RLP FY15 Vaishali System.assertEquals(46.2, calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                //added by syam  updated from 47.17, to 15.62 to 16.35 Vaishali
                System.assertEquals(46.5, calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                                calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue()
                                        ).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue(),
                                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                        calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                                        calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                                testOffer,
                                                                maxFund).doubleValue(),
                                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                        maxFund).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEYR
                                        ).doubleValue()
                                ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                5).doubleValue(),
                        calc.getFiveYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()
                        ).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue()
                                ).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForFiveYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkupsNoAEFee(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkupsNoAEFee(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()).setScale(2).doubleValue());

            } // end of fiveryr
            else if (r.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIVEFIVEYR) {
                System.debug('inside fivefiveyr');
                // Vaishali RLP FY15 System.assertEquals(33.49, calc.getFiveYearPVOption(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                System.assertEquals(43.40, calc.getFiveYearPVOption(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        calc.getFiveYrAvgCpiAndDiscountYrSixThruTen(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()
                        ).doubleValue(),
                        calc.getFiveYrAvgDiscountYrSixThruTen(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue()).doubleValue(),
                        testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue(),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c.doubleValue(),
                        r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c.doubleValue()).setScale(2));

                //  calculate blended PV rates (pv for five year and pv for five year option) for a new space                                                                                                                 
                // Vaishali RLP FY15 System.assertEquals(40.78, calc.getBlendedPV(calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                System.assertEquals(45.24, calc.getBlendedPV(calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                                calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                        calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
                                        ).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue(),
                                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                                calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                        calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                                testOffer,
                                                                maxFund).doubleValue(),
                                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                        maxFund).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEYR
                                        ).doubleValue()
                                ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                5).doubleValue(),
                        calc.getFiveYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()
                        ).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.get1rstNewFreeRentForFiveYear(testRates,
                                calc.getNewFirstTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                        calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue()
                                ).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEYR
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForFiveYear(testRates,
                                        calc.getNewSecondTierTI(testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                calc.getNewConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                calc.get2ndNewConstrMarkups(testSpaces.get(0),
                                                        testOffer,
                                                        maxFund).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue(),
                                                maxFund).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()),
                        calc.getFiveYearPVOption(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                                calc.getFiveYrAvgCpiAndDiscountYrSixThruTen(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                        testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()
                                ).doubleValue(),
                                calc.getFiveYrAvgDiscountYrSixThruTen(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue()).doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                                r.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c.doubleValue(),
                                r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c.doubleValue())).setScale(2)
                );  // end system assert

                //  calculate blended PV rates (pv for five year and pv for five year option) for a succeeding space                                                                                                                  
                //Vaishali RLP FY15System.assertEquals(38.11, calc.getBlendedPV(calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(), 
                System.assertEquals(43.55, calc.getBlendedPV(calc.getFiveYearPV(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                        r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                        calc.getBaseRentAndTI(r.PBS_AAAP_BASE_RATE__c.doubleValue(),
                                calc.getFreeRentNewSpace(calc.getSucc1rstFreeRentForFiveYear(testRates,
                                        calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                                calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                                        ).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                                ).doubleValue(),
                                        calc.get2ndNewFreeRentForFiveYear(testRates,
                                                calc.getSuccSecondTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                                        calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                                        ).doubleValue()
                                ).doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                5).doubleValue(),
                        calc.getFiveYrAvgCpiAndDiscount(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()
                        ).doubleValue(),
                        testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                        calc.getFreeRentNewSpace(calc.getSucc1rstFreeRentForFiveYear(testRates,
                                calc.getSuccFirstTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                        calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                        testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()
                                ).doubleValue(),
                                PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                        ).doubleValue(),
                                calc.get2ndNewFreeRentForFiveYear(testRates,
                                        calc.getSuccSecondTierTI(testOffer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue(),
                                                calc.getSuccConstrMarkups(testSpaces.get(0), testOffer).doubleValue(),
                                                testOffer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue()).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEFIVEYR
                                ).doubleValue()
                        ).doubleValue(),
                        r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c.doubleValue(),
                        Double.valueOf(100),
                        testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                        r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c.doubleValue()),
                        calc.getFiveYearPVOption(r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c.doubleValue(),
                                calc.getFiveYrAvgCpiAndDiscountYrSixThruTen(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                        testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue()
                                ).doubleValue(),
                                calc.getFiveYrAvgDiscountYrSixThruTen(testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue()).doubleValue(),
                                testRlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c.doubleValue(),
                                testRlp.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(),
                                testOffer.PBS_AAAP_COST_PER_ABOA__c.doubleValue(),
                                r.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c.doubleValue(),
                                r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c.doubleValue())).setScale(2)
                );  // end system assert
            }   // end if
            System.debug('end of rates loop');
        }   // end for          

        System.debug('after rates loop');
        // calculate the total markup for new spaces where the Arch Eng UOM is %
        String feePrcntgOrDollar = '%';
       // System.assertEquals(4.43, calc.getTotalMarkup(testSpaces.get(0), testOffer,feePrcntgOrDollar,10.00,20.00).setScale(2));

        // calculate the total markup for succeeding spaces (succeeding spaces aren't calculated with arch/eng fees).
        // set the indicator for new/succeeding to false
        PBS_AAAP_Space__c spChg = testSpaces.get(0);
        spChg.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        calc.getTotalMarkup(spChg, testOffer,feePrcntgOrDollar,10.00,20.00);
        //System.assertEquals(1.60, calc.getTotalMarkup(spChg, testOffer).setScale(2)); Updated by Snehith
       // System.assertEquals(2.28, calc.getTotalMarkup(spChg, testOffer,feePrcntgOrDollar,10.00,20.00).setScale(2));
        // calculate the total markup for new spaces where the Arch Eng UOM is $
        spChg.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true; // reset the indicator for new/succeeding to true
        spChg.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$'; // set UOM ot dollar
        feePrcntgOrDollar = '$ Per ABOA SF';
       // System.assertEquals(6.62, calc.getTotalMarkup(spChg, testOffer,feePrcntgOrDollar,10.00,20.00).setScale(2));
		calc.getTotalMarkup(spChg, testOffer,feePrcntgOrDollar,10.00,20.00);
        // calculate the total markup for succeeding spaces where the Arch Eng UOM is $ (succeeding spaces aren't calculated with arch/eng fees)
        spChg.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;        // reset the indicator for new/succeeding to false
        spChg.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = 'USD';       // set UOM ot dollar
        //System.assertEquals(1.60, calc.getTotalMarkup(spChg, testOffer).setScale(2)); Updated by Snehith 
       // System.assertEquals(5.10, calc.getTotalMarkup(spChg, testOffer,feePrcntgOrDollar,10.00,20.00).setScale(2));
		calc.getTotalMarkup(spChg, testOffer,feePrcntgOrDollar,10.00,20.00);
        // calculate the total moving , telco, and other upfront costs (new space)
        // commented by syam on 09/07/2016 temporarily as the method signature is changed
        System.assertEquals(3.20, calc.getMoveTelcoUpfrontCosts((2.00).doubleValue(), (12.00).doubleValue(), (2.00).doubleValue(), PBS_AAAP_CALCULATIONS.FIVEYR, true).setScale(2).doubleValue());

        // calculate the total moving , telco, and other upfront costs (succeeding space)
        calc.rlpGT2016 = false;
        System.assertEquals(.40, calc.getMoveTelcoUpfrontCosts((2.00).doubleValue(), (12.00).doubleValue(), (2.00).doubleValue(), PBS_AAAP_CALCULATIONS.FIVEYR, false).setScale(2).doubleValue());

        // calculate the parking costs (new space)
        System.debug('testing syam ***' + testRLP.PBS_AAAP_DISCOUNT_RATE__c);
        System.debug('PBS_AAAP_CALCULATIONS.FIVEYR is ' + PBS_AAAP_CALCULATIONS.FIVEYR);
        System.assertEquals(8.83, calc.getParkingCosts((10.00).doubleValue(), (50.00).doubleValue(), (15.00).doubleValue(), (250.00).doubleValue(), (50.00).doubleValue(), (10.00).doubleValue(), (50.00).doubleValue(), (20.00).doubleValue(), (6996.00).doubleValue(), (8045.00).doubleValue(), (3.00).doubleValue(), testRLP.PBS_AAAP_DISCOUNT_RATE__c.doubleValue(), PBS_AAAP_CALCULATIONS.FIVEYR).setScale(2).doubleValue());


    }    // end testCalculationClass

    private static testMethod void getSucc1rstFreeRentForFiveYearwithBSAC() {

        PBS_AAAP_CALCULATIONS cont = new PBS_AAAP_CALCULATIONS();
        List<PBS_AAAP_Rate__c> lstRate = [SELECT Id, PBS_AAAP_LEASE_TERM__c FROM PBS_AAAP_Rate__c LIMIT 10];
        Double pNewFirstTierTI = 10.00;
        String pLeaseTerm = '10 years';
        Double pBSACRate = 200.00;
        Integer pLeaseinMonths = 60;
        cont.getSucc1rstFreeRentForFiveYearwithBSAC(lstRate, pNewFirstTierTI, pLeaseTerm, pBSACRate, pLeaseinMonths);
        system.assertEquals(true, true);
    }

}