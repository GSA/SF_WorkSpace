public with sharing class PBS_AAAP_DAO_Utilities {


    /****************************************************************************************************************
    *   Constructors 
    *****************************************************************************************************************/

    public PBS_AAAP_DAO_Utilities() {

    } // end constructor


    /****************************************************************************************************************
    *   Method Definitions 
    *****************************************************************************************************************/

    // method to obtain the offer
    public PBS_AAAP_Offer__c getOffer(String pId) {
        PBS_AAAP_Offer__c returnVal = new PBS_AAAP_Offer__c();
        try {
            returnVal = [
                    SELECT p.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c, p.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c,
                            p.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, p.Id, PBS_AAAP_Offer_Status__c,
                            p.PBS_AAAP_RU_FACTOR__c, p.PBS_AAAP_COST_PER_ABOA__c,
                            p.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c, p.PBS_AAAP_OFFICE_SPACE_RSF__c,
                            p.PBS_AAAP_CLEANING_SALARIES__c, p.PBS_AAAP_CLEANING_SUPPLIES__c,
                            p.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c, p.PBS_AAAP_HEATING_SALARIES__c,
                            p.PBS_AAAP_HEATING_FUEL__c, p.PBS_AAAP_HEATING_FUEL_COST__c,
                            p.PBS_AAAP_HEATING_MAINTENANCE__c, p.PBS_AAAP_ELECTRICAL_POWER__c,
                            p.PBS_AAAP_ELECTRICAL_REPLACEMENT__c, p.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c,
                            p.PBS_AAAP_ELECTRICAL_MAINTENANCE__c, p.PBS_AAAP_PLUMBING_WATER__c,
                            p.PBS_AAAP_PLUMBING_SUPPLIES__c, p.PBS_AAAP_PLUMBING_MAINTENANCE__c,
                            p.PBS_AAAP_AC_UTILITIES__c, p.PBS_AAAP_AC_MAINTENANCE__c,
                            p.PBS_AAAP_ELEVATOR_SALARIES__c, p.PBS_AAAP_ELEVATOR_MAINTENANCE__c,
                            p.PBS_AAAP_BLDG_ENGINEERCOST__c, p.PBS_AAAP_SECURITY__c,
                            p.PBS_AAAP_SSTAX_WORKCOMP__c, p.PBS_AAAP_LANDSCAPING_MAINTENANCE__c,
                            p.PBS_AAAP_REAL_ESTATE_TAXES__c, p.PBS_AAAP_INSURANCE__c,
                            p.PBS_AAAP_BUILDING_MAINTENANCE__c, p.PBS_AAAP_LEASE_COMMISSION__c,
                            p.PBS_AAAP_MANAGEMENT__c, p.PBS_AAAP_SECT2_TOTAL__c,
                            p.PBS_AAAP_SRVC_UTIL_TOTAL__c, PBS_AAAP_TOTAL_OTHER_COSTS__c,
                            p.PBS_AAAP_RLP_TI_New_Space__c, p.PBS_AAAP_RLP_TI_Additional_Space__c,
                            p.PBS_AAAP_RLP_MAX_TIA__c, p.PBS_AAAP_RLP_Number__c,
                            PBS_AAAP_GEN_PURPOSE_RENTABLE__c,PBS_AAAP_Vacant_Premise_Rate__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.Id = :pId
                    LIMIT 1
            ];
        } catch (QueryException e) {
            Apexpages.addMessages(e);
            System.debug('##### getOffer Error: ' + e);
        }   // end try  

        return returnVal;
    }   // end getOffer


    // method to obtain the Rates with an Offer Id
    public List<PBS_AAAP_Rate__c> getRates(String pOfferId) {
        List<PBS_AAAP_Rate__c> returnVal = new List<PBS_AAAP_Rate__c>();
        try {
//-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
// added a new field PBS_AAAP_BSAC__c to the return Query        
//             returnVal  =   [Select p.PBS_AAAP_TWO_YEAR_EXTENSION__c, p.PBS_AAAP_SPACE__c,
//                                    p.PBS_AAAP_OT_RATE_COOLING_HEAT__c, p.PBS_AAAP_ONE_YEAR_EXTENSION__c, 
//                                    p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c, 
//                                    p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, p.PBS_AAAP_LEASE_TERM__c, 
//                                    p.PBS_AAAP_IDENTIFIER_ID__c, p.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, 
//                                    p.PBS_AAAP_COST_FOR_TI__c, p.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, 
//                                    p.PBS_AAAP_BASE_RATE__c, p.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, 
//                                    p.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, p.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c, 
//                                    p.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, p.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c, 
//                                    p.Id,  p.PBS_AAAP_SPACE__r.PBS_AAAP_OFFER_NUMBER__c, 
//                                    p.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, p.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
//                                    p.PBS_AAAP_PV_Value__c, p.PBS_AAAP_PV_Value_Blended__c
//                             From PBS_AAAP_Rate__c p
//                             Where p.PBS_AAAP_SPACE__r.PBS_AAAP_OFFER_NUMBER__c =: pOfferId ];
            returnVal = [
                    SELECT p.PBS_AAAP_TWO_YEAR_EXTENSION__c, p.PBS_AAAP_SPACE__c,
                            p.PBS_AAAP_OT_RATE_COOLING_HEAT__c, p.PBS_AAAP_ONE_YEAR_EXTENSION__c,
                            p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                            p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, p.PBS_AAAP_LEASE_TERM__c,
                            p.PBS_AAAP_IDENTIFIER_ID__c, p.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                            p.PBS_AAAP_COST_FOR_TI__c, p.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c,
                            p.PBS_AAAP_BASE_RATE__c, p.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,
                            p.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, p.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,
                            p.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, p.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                            p.Id, p.PBS_AAAP_SPACE__r.PBS_AAAP_OFFER_NUMBER__c,
                            p.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, p.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                            p.PBS_AAAP_PV_Value__c, p.PBS_AAAP_PV_Value_Blended__c,
                            p.PBS_AAAP_BSAC__c,
                            p.PBS_AAAP_BSAC_RATE__c
                    FROM PBS_AAAP_Rate__c p
                    WHERE p.PBS_AAAP_SPACE__r.PBS_AAAP_OFFER_NUMBER__c = :pOfferId
            ];


        } catch (QueryException e) {
//            Apexpages.addMessages(e);
            System.debug('##### getRates Error: ' + e);
            //return returnVal;
        }   // end try  

        return returnVal;
    }   // end getRate  


    // method to obtain the Rates with a Space ID
    public List<PBS_AAAP_Rate__c> getRatesFromSpace(String pSpaceId) {
        List<PBS_AAAP_Rate__c> returnVal = new List<PBS_AAAP_Rate__c>();
//-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
// added BSAC to the query
//             returnVal  =   [Select p.PBS_AAAP_TWO_YEAR_EXTENSION__c, p.PBS_AAAP_SPACE__c,
//                                    p.PBS_AAAP_OT_RATE_COOLING_HEAT__c, p.PBS_AAAP_ONE_YEAR_EXTENSION__c, 
//                                    p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c, 
//                                    p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, p.PBS_AAAP_LEASE_TERM__c, 
//                                    p.PBS_AAAP_IDENTIFIER_ID__c, p.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, 
//                                    p.PBS_AAAP_COST_FOR_TI__c, p.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, 
//                                    p.PBS_AAAP_BASE_RATE__c, p.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, 
//                                    p.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, p.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c, 
//                                    p.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, p.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c, 
//                                    p.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, p.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
//                                    p.PBS_AAAP_PV_Value__c, p.PBS_AAAP_PV_Value_Blended__c,
//                                    p.Id
//                            From PBS_AAAP_Rate__c p
//                             Where p.PBS_AAAP_SPACE__c =: pSpaceId ];
        returnVal = [
                SELECT p.PBS_AAAP_TWO_YEAR_EXTENSION__c, p.PBS_AAAP_SPACE__c,
                        p.PBS_AAAP_OT_RATE_COOLING_HEAT__c, p.PBS_AAAP_ONE_YEAR_EXTENSION__c,
                        p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                        p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, p.PBS_AAAP_LEASE_TERM__c,
                        p.PBS_AAAP_IDENTIFIER_ID__c, p.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                        p.PBS_AAAP_COST_FOR_TI__c, p.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c,
                        p.PBS_AAAP_BASE_RATE__c, p.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,
                        p.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, p.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,
                        p.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, p.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                        p.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, p.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                        p.PBS_AAAP_PV_Value__c, p.PBS_AAAP_PV_Value_Blended__c,
                        p.Id,
                        p.PBS_AAAP_BSAC__c,
                        p.PBS_AAAP_BSAC_RATE__c
                FROM PBS_AAAP_Rate__c p
                WHERE p.PBS_AAAP_SPACE__c = :pSpaceId
        ];


        return returnVal;
    }   // end getRatesFromSpace        


    // method to obtain the Spaces
    public List<PBS_AAAP_Space__c> getSpaces(String pId) {
        List<PBS_AAAP_Space__c> returnVal = new List<PBS_AAAP_Space__c>();
        try {
            returnVal = [
                    SELECT s.PBS_AAAP_OFFER_NUMBER__c, s.PBS_AAAP_Max_Contiguous_Space__c,
                            s.PBS_AAAP_MIN_OFFERABLE_SPACE__c, s.PBS_AAAP_MAX_OFFERABLE_SPACE__c,
                            s.PBS_AAAP_DATE_SPACE_AVAILABILITY__c, s.PBS_AAAP_GC_OVERHEAD_AND_PROF__c,
                            s.PBS_AAAP_MANAGEMENT_COORD_FEES__c, s.PBS_AAAP_GC_CONDITIONS__c,
                            s.PBS_AAAP_ARCH_ENG_FEES__c, s.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c,
                            s.PBS_AAAP_IDENTIFIER_TYPE__c, s.PBS_AAAP_IDENTIFIER_ID__c,
                            s.PBS_AAAP_SF_OFFERED__c, s.PBS_AAAP_TOTAL_MARKUP__c,
                            s.PBS_AAAP_TOT_EXP_ABOA__c, s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c,
                            s.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, s.PBS_AAAP_Offeror_Created_BSAC__c,
                            s.PBS_AAAP_Offeror_Created_TI__c, s.PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c
                    FROM PBS_AAAP_Space__c s
                    WHERE s.PBS_AAAP_OFFER_NUMBER__c = :pId
                    ORDER BY s.PBS_AAAP_IDENTIFIER_ID__c ASC
            ];

        } catch (QueryException e) {
//            Apexpages.addMessages(e);
            System.debug('##### getSpaces Error: ' + e);
            //return returnVal;
        }   // end try  

        return returnVal;
    }   // end getRate  


    // method to obtain the RLP
    public PBS_AAAP_RLP__c getRLP(String pId) {
        PBS_AAAP_RLP__c returnVal = new PBS_AAAP_RLP__c();
        try {
//-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
// added a new field PBS_AAAP_BSAC_per_ABOA__c to the return Query        
//            returnVal   =   [Select p.PBS_AAAP_RLP_Number__c, p.PBS_AAAP_ESCALATION_RATE_PERCENT__c, 
//                                    p.PBS_AAAP_DISCOUNT_RATE__c, p.PBS_AAAP_MAX_TIUSED__c, 
//                                    p.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, p.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c  
//                               From PBS_AAAP_RLP__c p
//                              Where p.Id =: pId];
//Vaishali RLP FY 14 Change Added PBS_AAAP_ALLOW_TIER2_AMMORT__c to the selection
//Vaishali RLP FY 15 Change Added PBS_AAAP_Allow_10_5_Term__c to the selection
            returnVal = [
                    SELECT p.PBS_AAAP_RLP_Number__c, p.PBS_AAAP_ESCALATION_RATE_PERCENT__c,
                            p.PBS_AAAP_DISCOUNT_RATE__c, p.PBS_AAAP_MAX_TIUSED__c, p.PBS_AAAP_Region__c,
                            p.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, p.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c,BSAC_for_Continuing_Space_per_ABOA_SF__c,
                            p.PBS_AAAP_BSAC_per_ABOA__c, p.PBS_AAAP_ALLOW_TIER2_AMMORT__c,p.PBS_AAAP_Allow_10_5_Term__c,PBS_AAAP_Year__c
                    FROM PBS_AAAP_RLP__c p
                    WHERE p.Id = :pId
            ];
//-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------        

        } catch (QueryException e) {
            Apexpages.addMessages(e);
            System.debug('##### getRLP Error: ' + e);
        }   // end try

        return returnVal;
    }   // end getRLP

    /** added by syam on 07/15 to update PV values
    This will update when we save operating cost and when we click on the submit offer
    */

    public void updatePVRates(String offerId) {
        PBS_AAAP_Offer__c offer = getOffer(offerId);
        String spaceId = '';
        Double costPerABOA = 0.00;
        Double baseCostSrvcUtilABOA = 0.00;
        List<PBS_AAAP_Space__c> spaces = getSpaces(offerId);
        System.debug('spaces size is ****' + spaces.size());
        for (PBS_AAAP_Space__c space : spaces) {
            spaceId = space.Id;
            System.debug('inside spaces loop space Id : ' + space.Id);
            List<PBS_AAAP_Rate__c> rates = getRatesFromSpace(spaceId);
            System.debug('rates size is ****' + rates.size());
            for (PBS_AAAP_RATE__c rate : rates) {
                System.debug('inside rates loop rate Id : ' + rate.Id);
                if (offer.PBS_AAAP_COST_PER_ABOA__c != null) {
                    costPerABOA = (offer.PBS_AAAP_COST_PER_ABOA__c).setScale(5);
                }
                if (rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c != null) {
                    baseCostSrvcUtilABOA = (rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c).setScale(5);
                }
                if (rate.PBS_AAAP_BASE_RATE__c > 0.00 && (costPerABOA != baseCostSrvcUtilABOA)) {
                    System.debug('inside rates base rate');
                    rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c - rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c + offer.PBS_AAAP_COST_PER_ABOA__c;
                    rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = offer.PBS_AAAP_COST_PER_ABOA__c;
                    update rate;
                }
            }

        }

    }


    public boolean validatePVRates(String offerId) {
        PBS_AAAP_Offer__c offer = getOffer(offerId);
        String spaceId = '';
        Double costPerABOA = 0.00;
        Double baseCostSrvcUtilABOA = 0.00;
        List<PBS_AAAP_Space__c> spaces = getSpaces(offerId);
        System.debug('spaces size is ****' + spaces.size());
        boolean flag = false;
        for (PBS_AAAP_Space__c space : spaces) {
            spaceId = space.Id;
            System.debug('inside spaces loop space Id : ' + space.Id);
            List<PBS_AAAP_Rate__c> rates = getRatesFromSpace(spaceId);
            System.debug('rates size is ****' + rates.size());
            for (PBS_AAAP_RATE__c rate : rates) {
                System.debug('inside rates loop rate Id : ' + rate.Id);
                if (offer.PBS_AAAP_COST_PER_ABOA__c != null) {
                    costPerABOA = (offer.PBS_AAAP_COST_PER_ABOA__c).setScale(5);
                }
                if (rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c != null) {
                    baseCostSrvcUtilABOA = (rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c).setScale(5);
                }
                System.debug('inside rates base rate' + rate.PBS_AAAP_BASE_RATE__c);
                System.debug('offer.PBS_AAAP_COST_PER_ABOA__c is' + offer.PBS_AAAP_COST_PER_ABOA__c);
                System.debug('rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c is ' + rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c);
                System.debug('costPerABOA after scaling' + costPerABOA);
                System.debug('baseCostSrvcUtilABOA after scaling ' + baseCostSrvcUtilABOA);
                if ((rate.PBS_AAAP_BASE_RATE__c > 0.00) && (costPerABOA != baseCostSrvcUtilABOA)) {
                    //update rate;
                    flag = true;
                    return flag;
                } else {
                    flag = false;
                }
            }

        }
        return flag;
    }

}   // end class PBS_AAAP_DAO_Utilities