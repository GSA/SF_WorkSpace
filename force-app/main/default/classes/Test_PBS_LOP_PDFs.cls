@IsTest
private class Test_PBS_LOP_PDFs {

    
    static testMethod void offerLOPForm1217_LOP() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        insert offer;
        System.assert(offer.Id != null);
        PageReference pref = null;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        LOP_PBS_AAAP_OfferForm1217 form1217 = new LOP_PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Lease Hold Interest';
        offer.PBS_AAAP_HEATING_FUEL__c = 'Natural Gas';
        update offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new LOP_PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_HEATING_FUEL__c = 'Oil';
        update offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new LOP_PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_HEATING_FUEL__c = 'Coal';
        update offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new LOP_PBS_AAAP_OfferForm1217();
        
        //form1217.strImagename = 'test';
        //form1217.strImageBlob = 'abd';
        //form1217.captureImage();
    }

    
    
    static testMethod void offerForm1364_LOP() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_LIVE_FLOOR_LOAD__c = '100';
        offer.PBS_RSAP_Year_Built__c = '2000';
        offer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = 40;
        offer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c = 40;
        offer.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
        offer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference';
        offer.PBS_RSAP_Flood_Plain_Declaration__c = 'in a 500-year flood plain';
        offer.PBS_RSAP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix';
        offer.PBS_RSAP_Offeror_Seismic_Declaration__c = 'Fully meets seismic requirements or meets an exemption under the RLP';
        offer.PBS_RSAP_Accessibility_Standards_Met__c = 'Yes';
        offer.PBS_AAAP_Taxes_Fully_Assessed_Value__c = 'Yes';
        offer.PBS_AAAP_HVAC_OT_Rate_Type__c = 'Per Zone';
        offer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c = 'Yes';
        offer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 10000;
        offer.PBS_AAAP_Office_RSF_OFFERED__c = 10000;
        //Julia added from here 8.28.2020. This covers Matrix Row #1 scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = null;
        offer.PBS_AAAP_Rental_Concessions__c = null;
        //to here
        insert offer;

        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate;
        System.assert(offer.Id != null);


        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364RateStructure');

        PBS_LOP_OfferForm1364Controller form1364 = new PBS_LOP_OfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        offer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = null;
        offer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c = null;
        offer.PBS_RSAP_Historical_Property_Description__c = 'Historic properties outside of historic district';
        offer.PBS_RSAP_HubZone_Waiver__c = '';
        offer.PBS_RSAP_Flood_Plain_Declaration__c = 'in a base (100-year) flood plain';
        offer.PBS_RSAP_Asbestos_Declaration__c = '';
        offer.PBS_RSAP_Offeror_Seismic_Declaration__c = 'Does not meet seismic requirements, but will be retrofitted to meet seismic requirements';
        offer.PBS_RSAP_Accessibility_Standards_Met__c = 'No';
        offer.PBS_AAAP_Taxes_Fully_Assessed_Value__c = 'No';
        offer.PBS_AAAP_HVAC_OT_Rate_Type__c = 'Per Floor';
        offer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c = 'No';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
		//JK added here 9.30.2020
		offer.PBS_AAAP_HVAC_OT_Rate_Type__c = 'Per Space';
        //to here
        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
        offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_Energy_Star__c = 'No';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_HUBZone_SBC_Offeror__c = true;
        offer.PBS_AAAP_Energy_Star__c = 'No';
       // offer.PBS_AAAP_Energy_Star_Reason__c = 'Testing for 500 charactor limit for the offeror energy star reason comments,Testing for 500 charactor limit for the offeror energy star reason comments,Testing for 500 charactor limit for the offeror energy star reason comments,Testing for 500 charactor limit for the offeror energy star reason comments,Testing for 500 charactor limit for the offeror energy star reason comments,Testing for 500 charactor limit for the offeror energy star reason comments,Testing for 500 charactor limit for the offeror energy star reason comments,Testing for 500 charactor limit for the offeror';
        //offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 0.0;
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        System.debug(form1364.legalAgentType);
        System.debug(form1364.xownerType);
        System.debug(form1364.monthlyCostResSurf);
        System.debug(form1364.monthlyCostNonResSurf);
        System.debug(form1364.monthlyCostNonResGar);
        System.assert(offer.Id != null);
        //Julia rental concessions matrix changes from here 8.28.2020
        //Matrix Row #2 Scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 0;
        offer.PBS_AAAP_Rental_Concessions__c = null;
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        //Matrix Row #3 Scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 1;
        offer.PBS_AAAP_Rental_Concessions__c = null;
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
         //Matrix Row #4 Scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = null;
        offer.PBS_AAAP_Rental_Concessions__c = 'Yes';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
         //Matrix Row #5 Scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 0;
        offer.PBS_AAAP_Rental_Concessions__c = 'Yes';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
         //Matrix Row #6 Scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 1;
        offer.PBS_AAAP_Rental_Concessions__c = 'Yes';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
         //Matrix Row #7 Scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = null;
        offer.PBS_AAAP_Rental_Concessions__c = 'No';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        //Matrix Row #8 Scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 0;
        offer.PBS_AAAP_Rental_Concessions__c = 'No';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
         //Matrix Row #9 Scenario
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 1;
        offer.PBS_AAAP_Rental_Concessions__c = 'No';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        //further coverage
        offer.PBS_AAAP_LIVE_FLOOR_LOAD__c = null;
       	offer.PBS_AAAP_RLP_Parking_Cost_Incl__c = 'Yes';
        offer.PBS_RSAP_Offeror_Seismic_Declaration__c = 'Will be constructed to meet seismic requirements';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        //further coverage
        offer.PBS_RSAP_Offeror_Seismic_Declaration__c = 'Will not meet seismic requirements';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        //to here

    }
  
    /* added by J. Rogers 8/24/22 */
    static testMethod void newOfferForm1364_LOP() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        //to here
        insert offer;

        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate;
        System.assert(offer.Id != null);


        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364RateStructure');

        PBS_LOP_NewOfferForm1364Controller form1364 = new PBS_LOP_NewOfferForm1364Controller();


    }
    static testMethod void newOfferForm1364_LOP_noOfferId() {
      PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
      //to here
      insert offer;

      PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
      space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
      insert space;

      PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
      rate.PBS_AAAP_SPACE__c = space.Id;
      rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
      insert rate;
      PBS_LOP_NewOfferForm1364Controller form1364 = new PBS_LOP_NewOfferForm1364Controller();

		System.assertEquals(rate.PBS_AAAP_OFFER_NUMBER__c, offer.Id, 'This should be equalts');
  }  
    
}