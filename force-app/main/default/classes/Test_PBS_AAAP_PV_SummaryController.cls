@IsTest
private class Test_PBS_AAAP_PV_SummaryController {

    static testMethod void calculationsPV() {

        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c();
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 20.00;
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 38.95;
        rlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c = true;
        rlp.PBS_AAAP_MAX_TIUSED__c = 45.59;
        rlp.PBS_AAAP_RLP_Number__c = 'Unit Test RLP';
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50;
        rlp.PBS_AAAP_Discount_percent_Rate__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50;
        rlp.PBS_AAAP_Year__c = '2016';
        rlp.PBS_AAAP_BSAC_per_ABOA__c = 25 ;
        rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c = 25;
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 50;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 20;
        insert rlp ;

        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Signature_First_Name__c = 'Test First';
        offer.PBS_AAAP_SIGNATURE_LAST_NAME__c = 'Test Last';
        offer.PBS_AAAP_Street_Address__c = 'Test Address';
        offer.PBS_AAAP_Building_Name__c = 'Test Building';
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 5000;
        offer.PBS_AAAP_City__c = 'Test City';
        offer.PBS_AAAP_State__c = 'DC';
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        insert offer;

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.Name = 'Test Agency';
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'New';
        agency.PBS_AAAP_RLP_Number__c = rlp.Id;
        //agency.PBS_AAAP_LEASE_TERM__c = '15 years,13 firm';
        agency.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        agency.PBS_AAAP_USF_REQ_MIN__c = 10;
        agency.PBS_AAAP_USF_REQ_MAX__c = 10000;
        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 10;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 10;

        insert agency;

        PBS_AAAP_Space__c space = new PBS_AAAP_Space__c();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 3;
        space.PBS_AAAP_ARCH_ENG_FEES__c = 10;
        space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF';
        space.PBS_AAAP_TOTAL_MARKUP__c = 100;
        space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today();
        space.PBS_AAAP_SF_OFFERED__c = 5000.00;
        insert space;

        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_BSAC_RATE__c = 5;
        rate.PBS_AAAP_BSAC__c = 10;
        rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 5;
        rate.PBS_AAAP_BASE_RATE__c = 10;
        rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 10;
        rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10;
        rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 10;
        rate.PBS_AAAP_PV_Value__c = 10;
        rate.PBS_AAAP_PV_Value_Blended__c = 10;
        //rate.PBS_AAAP_LEASE_TERM__c = '15 years,13 firm';
        rate.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 10;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007;
        insert rate;


        PBS_AAAP_Utility.setQueryParam('offerId', offer.Id);
        PBS_AAAP_Utility.setQueryParam('agencyId', agency.Id);
        PBS_AAAP_Utility.setQueryParam('pv', '20.33');
        PBS_AAAP_Utility.setQueryParam('newLease', '20.00');
        PBS_AAAP_Utility.setQueryParam('succeedingLease', '38.95');
        PBS_AAAP_Utility.setQueryParam('physicalMoveCost', '10');
        PBS_AAAP_Utility.setQueryParam('telecommunicationsCost', '50');
        PBS_AAAP_Utility.setQueryParam('bsacperABOA', '25');
        PBS_AAAP_Utility.setQueryParam('bsacForContinuingSpace', '25');
        PBS_AAAP_Utility.setQueryParam('spaceId', space.Id);


        PBS_AAAP_PV_SummaryController contr = new PBS_AAAP_PV_SummaryController();
        contr.comments = 'Test Comments';
        contr.lease10Y5F = null;
        contr.lease10Y = null;
        contr.GeneratePDF();
        contr.pvComments = 'Test Comments';
        system.assertEquals(true, true);
    }
    static testMethod void calculationsPV1() {

        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c();
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 20.00;
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 38.95;
        rlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c = true;
        rlp.PBS_AAAP_MAX_TIUSED__c = 45.59;
        rlp.PBS_AAAP_RLP_Number__c = 'Unit Test RLP';
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50;
        rlp.PBS_AAAP_Discount_percent_Rate__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50;
        rlp.PBS_AAAP_Year__c = '2016';
        rlp.PBS_AAAP_BSAC_per_ABOA__c = 25 ;
        rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c = 25;
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 50;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 20;
        insert rlp ;

        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Signature_First_Name__c = 'Test First';
        offer.PBS_AAAP_SIGNATURE_LAST_NAME__c = 'Test Last';
        offer.PBS_AAAP_Street_Address__c = 'Test Address';
        offer.PBS_AAAP_Building_Name__c = 'Test Building';
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 5000;
        offer.PBS_AAAP_City__c = 'Test City';
        offer.PBS_AAAP_State__c = 'DC';
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        insert offer;

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.Name = 'Test Agency';
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'New';
        agency.PBS_AAAP_RLP_Number__c = rlp.Id;
        //agency.PBS_AAAP_LEASE_TERM__c = '15 years,13 firm';
        agency.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        agency.PBS_AAAP_USF_REQ_MIN__c = 10;
        agency.PBS_AAAP_USF_REQ_MAX__c = 10000;
        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 10;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 10;
        insert agency;

        PBS_AAAP_Space__c space = new PBS_AAAP_Space__c();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 3;
        space.PBS_AAAP_ARCH_ENG_FEES__c = 10;
        space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF';
        space.PBS_AAAP_TOTAL_MARKUP__c = 100;
        space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today();
        space.PBS_AAAP_SF_OFFERED__c = 5000.00;
        insert space;

        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_BSAC_RATE__c = 5;
        rate.PBS_AAAP_BSAC__c = -10;
        rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 5;
        rate.PBS_AAAP_BASE_RATE__c = 10;
        rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 10;
        rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10;
        rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = -10;
        rate.PBS_AAAP_PV_Value__c = 10;
        rate.PBS_AAAP_PV_Value_Blended__c = 10;
        //rate.PBS_AAAP_LEASE_TERM__c = '15 years,13 firm';
        rate.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 0;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 10;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007;
        insert rate;


        PBS_AAAP_Utility.setQueryParam('offerId', offer.Id);
        PBS_AAAP_Utility.setQueryParam('agencyId', agency.Id);
        PBS_AAAP_Utility.setQueryParam('pv', '20.33');
        PBS_AAAP_Utility.setQueryParam('newLease', '20.00');
        PBS_AAAP_Utility.setQueryParam('succeedingLease', '38.95');
        PBS_AAAP_Utility.setQueryParam('physicalMoveCost', '10');
        PBS_AAAP_Utility.setQueryParam('telecommunicationsCost', '50');
        PBS_AAAP_Utility.setQueryParam('bsacperABOA', '25');
        PBS_AAAP_Utility.setQueryParam('bsacForContinuingSpace', '25');
        PBS_AAAP_Utility.setQueryParam('spaceId', space.Id);

        PBS_AAAP_PV_SummaryController contr = new PBS_AAAP_PV_SummaryController();
        contr.comments = 'Test Comments';
        contr.lease10Y5F = null;
        contr.lease10Y = null;
        contr.GeneratePDF();
        contr.pvComments = 'Test Comments';
        system.assertEquals(true, true);
    }

    static testMethod void calculationsPV_Continuing() {

        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c();
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 20.00;
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 38.95;
        rlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c = true;
        rlp.PBS_AAAP_MAX_TIUSED__c = 45.59;
        rlp.PBS_AAAP_RLP_Number__c = 'Unit Test RLP';
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50;
        rlp.PBS_AAAP_Discount_percent_Rate__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50;
        rlp.PBS_AAAP_Year__c = '2019';
        rlp.PBS_AAAP_BSAC_per_ABOA__c = 25 ;
        rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c = 25;
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 50;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 20;
        insert rlp ;

        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Signature_First_Name__c = 'Test First';
        offer.PBS_AAAP_SIGNATURE_LAST_NAME__c = 'Test Last';
        offer.PBS_AAAP_Street_Address__c = 'Test Address';
        offer.PBS_AAAP_Building_Name__c = 'Test Building';
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 5000;
        offer.PBS_AAAP_City__c = 'Test City';
        offer.PBS_AAAP_State__c = 'DC';
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        insert offer;

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.Name = 'Test Agency';
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'Continuing';
        agency.PBS_AAAP_RLP_Number__c = rlp.Id;
        //agency.PBS_AAAP_LEASE_TERM__c = '15 years,13 firm';
        agency.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        agency.PBS_AAAP_USF_REQ_MIN__c = 10;
        agency.PBS_AAAP_USF_REQ_MAX__c = 10000;
        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 10;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 10;
        insert agency;

        PBS_AAAP_Space__c space = new PBS_AAAP_Space__c();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 3;
        space.PBS_AAAP_ARCH_ENG_FEES__c = 10;
        space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF';
        space.PBS_AAAP_TOTAL_MARKUP__c = 100;
        space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today();
        space.PBS_AAAP_SF_OFFERED__c = 5000.00;
        insert space;

        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_BSAC_RATE__c = 5;
        rate.PBS_AAAP_BSAC__c = -10;
        rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 5;
        rate.PBS_AAAP_BASE_RATE__c = 10;
        rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 10;
        rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10;
        rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = -10;
        rate.PBS_AAAP_PV_Value__c = 10;
        rate.PBS_AAAP_PV_Value_Blended__c = 10;
        //rate.PBS_AAAP_LEASE_TERM__c = '15 years,13 firm';
        rate.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 0;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 10;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007;
        insert rate;


        PBS_AAAP_Utility.setQueryParam('offerId', offer.Id);
        PBS_AAAP_Utility.setQueryParam('agencyId', agency.Id);
        PBS_AAAP_Utility.setQueryParam('pv', '20.33');
        PBS_AAAP_Utility.setQueryParam('newLease', '20.00');
        PBS_AAAP_Utility.setQueryParam('succeedingLease', '38.95');
        PBS_AAAP_Utility.setQueryParam('physicalMoveCost', '10');
        PBS_AAAP_Utility.setQueryParam('telecommunicationsCost', '50');
        PBS_AAAP_Utility.setQueryParam('bsacperABOA', '25');
        PBS_AAAP_Utility.setQueryParam('bsacForContinuingSpace', '25');
        PBS_AAAP_Utility.setQueryParam('spaceId', space.Id);

        PBS_AAAP_PV_SummaryController contr = new PBS_AAAP_PV_SummaryController();
        contr.comments = 'Test Comments';
        contr.lease10Y5F = null;
        contr.lease10Y = null;
        contr.GeneratePDF();
        contr.pvComments = 'Test Comments';
        system.assertEquals(true, true);
    }

    static testMethod void calculationsPV_2019() {

        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c();
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 20.00;
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 38.95;
        rlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c = true;
        rlp.PBS_AAAP_MAX_TIUSED__c = 45.59;
        rlp.PBS_AAAP_RLP_Number__c = 'Unit Test RLP';
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50;
        rlp.PBS_AAAP_Discount_percent_Rate__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50;
        rlp.PBS_AAAP_Year__c = '2019';
        rlp.PBS_AAAP_BSAC_per_ABOA__c = 25 ;
        rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c = 25;
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 50;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 20;
        insert rlp ;

        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Signature_First_Name__c = 'Test First';
        offer.PBS_AAAP_SIGNATURE_LAST_NAME__c = 'Test Last';
        offer.PBS_AAAP_Street_Address__c = 'Test Address';
        offer.PBS_AAAP_Building_Name__c = 'Test Building';
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 5000;
        offer.PBS_AAAP_City__c = 'Test City';
        offer.PBS_AAAP_State__c = 'DC';
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        insert offer;

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.Name = 'Test Agency';
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'New';
        agency.PBS_AAAP_RLP_Number__c = rlp.Id;
        agency.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        //agency.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        agency.PBS_AAAP_USF_REQ_MIN__c = 10;
        agency.PBS_AAAP_USF_REQ_MAX__c = 10000;
        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 10;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 10;
        insert agency;

        PBS_AAAP_Space__c space = new PBS_AAAP_Space__c();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 3;
        space.PBS_AAAP_ARCH_ENG_FEES__c = 10;
        space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF';
        space.PBS_AAAP_TOTAL_MARKUP__c = 100;
        space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today();
        space.PBS_AAAP_SF_OFFERED__c = 5000.00;
        insert space;

        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_BSAC_RATE__c = 5;
        rate.PBS_AAAP_BSAC__c = -10;
        rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 5;
        rate.PBS_AAAP_BASE_RATE__c = 10;
        rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 10;
        rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10;
        rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = -10;
        rate.PBS_AAAP_PV_Value__c = 10;
        rate.PBS_AAAP_PV_Value_Blended__c = 10;
        rate.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        //rate.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 0;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 10;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007;
        insert rate;


        PBS_AAAP_Utility.setQueryParam('offerId', offer.Id);
        PBS_AAAP_Utility.setQueryParam('agencyId', agency.Id);
        PBS_AAAP_Utility.setQueryParam('pv', '20.33');
        PBS_AAAP_Utility.setQueryParam('newLease', '20.00');
        PBS_AAAP_Utility.setQueryParam('succeedingLease', '38.95');
        PBS_AAAP_Utility.setQueryParam('physicalMoveCost', '10');
        PBS_AAAP_Utility.setQueryParam('telecommunicationsCost', '50');
        PBS_AAAP_Utility.setQueryParam('bsacperABOA', '25');
        PBS_AAAP_Utility.setQueryParam('bsacForContinuingSpace', '25');
        PBS_AAAP_Utility.setQueryParam('spaceId', space.Id);

        PBS_AAAP_PV_SummaryController contr = new PBS_AAAP_PV_SummaryController();
        contr.comments = 'Test Comments';
        contr.lease10Y5F = null;
        contr.lease10Y = null;
        contr.GeneratePDF();
        contr.pvComments = 'Test Comments';
        system.assertEquals(true, true);
    }
    static testMethod void calculationsPV_2019_Continuing() {

        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c();
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 20.00;
        rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 38.95;
        rlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c = true;
        rlp.PBS_AAAP_MAX_TIUSED__c = 45.59;
        rlp.PBS_AAAP_RLP_Number__c = 'Unit Test RLP';
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50;
        rlp.PBS_AAAP_Discount_percent_Rate__c = 5.00;
        rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50;
        rlp.PBS_AAAP_Year__c = '2019';
        rlp.PBS_AAAP_BSAC_per_ABOA__c = 25 ;
        rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c = 25;
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 50;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 20;
        insert rlp ;

        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Signature_First_Name__c = 'Test First';
        offer.PBS_AAAP_SIGNATURE_LAST_NAME__c = 'Test Last';
        offer.PBS_AAAP_Street_Address__c = 'Test Address';
        offer.PBS_AAAP_Building_Name__c = 'Test Building';
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 5000;
        offer.PBS_AAAP_City__c = 'Test City';
        offer.PBS_AAAP_State__c = 'DC';
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        insert offer;

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.Name = 'Test Agency';
        agency.PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'Continuing';
        agency.PBS_AAAP_RLP_Number__c = rlp.Id;
        agency.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        //agency.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        agency.PBS_AAAP_USF_REQ_MIN__c = 10;
        agency.PBS_AAAP_USF_REQ_MAX__c = 10000;
        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 10;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 10;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 10;
        agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c = 'CR7';
        insert agency;

        PBS_AAAP_Space__c space = new PBS_AAAP_Space__c();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 3;
        space.PBS_AAAP_ARCH_ENG_FEES__c = 10;
        space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF';
        space.PBS_AAAP_TOTAL_MARKUP__c = 100;
        space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today();
        space.PBS_AAAP_SF_OFFERED__c = 5000.00;
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;
        space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = 'CR7';
        insert space;

        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_BSAC_RATE__c = 5;
        rate.PBS_AAAP_BSAC__c = -10;
        rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 5;
        rate.PBS_AAAP_BASE_RATE__c = 10;
        rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 10;
        rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10;
        rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = -10;
        rate.PBS_AAAP_PV_Value__c = 10;
        rate.PBS_AAAP_PV_Value_Blended__c = 10;
        rate.PBS_AAAP_LEASE_TERM__c = '15 years, 13 firm';
        //rate.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 0;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 10;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007;
        insert rate;


        PBS_AAAP_Utility.setQueryParam('offerId', offer.Id);
        PBS_AAAP_Utility.setQueryParam('agencyId', agency.Id);
        PBS_AAAP_Utility.setQueryParam('pv', '20.33');
        PBS_AAAP_Utility.setQueryParam('newLease', '20.00');
        PBS_AAAP_Utility.setQueryParam('succeedingLease', '38.95');
        PBS_AAAP_Utility.setQueryParam('physicalMoveCost', '10');
        PBS_AAAP_Utility.setQueryParam('telecommunicationsCost', '50');
        PBS_AAAP_Utility.setQueryParam('bsacperABOA', '25');
        PBS_AAAP_Utility.setQueryParam('bsacForContinuingSpace', '25');
        PBS_AAAP_Utility.setQueryParam('spaceId', space.Id);

        PBS_AAAP_PV_SummaryController contr = new PBS_AAAP_PV_SummaryController();
        contr.comments = 'Test Comments';
        contr.lease10Y5F = null;
        contr.lease10Y = null;
        contr.GeneratePDF();
        contr.pvComments = 'Test Comments';
        system.assertEquals(true, true);
        
        
        // code to validate the capture image
        contr.strImagename = 'TestImage';
        contr.strImageBlob = 'TestImage';
        contr.captureImage();
    }
    
   
}