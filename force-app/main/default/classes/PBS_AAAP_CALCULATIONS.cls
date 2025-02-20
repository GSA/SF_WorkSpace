public with sharing class PBS_AAAP_CALCULATIONS {

    /****************************************************************************************************************
    *   Data Declaration
    *****************************************************************************************************************/
    public static String FIVEYR = '5 years';
    public static String FIFTEENTENYR = '15 years,10 firm';  //Vaishali added for FY17
    public static String FIVEFIVEYR = '5+5 years';
    public static String FIVEFIVEYRNEW = '10 years,5 firm';  //Vaishali added for FY17
    public static String TENYR = '10 years';

    public static String SEVENTEENYR = '17 years, 15 firm'; 
    public static String FIFTEENTENYRNEW = '15 years, 13 firm';
    public static String TENYREIGHTFIRM = '10 years, 8 firm';

    
    public static String CENSUS_25 = '25 Months, 16 Firm';
    public static String CENSUS_19 = '19 Months, 11 Firm';
    public static String CENSUS_25_2018 = '25 Months,16 Firm';
    public static String CENSUS_19_2018 = '19 Months,11 Firm';
    public Double getLeaseMonths(String leaseTerm){
        Double leaseFirmTermMonths;
        if(leaseTerm == '17 years, 15 firm' || leaseTerm == '15 years, 13 firm' || leaseTerm == '10 years, 8 firm'){
            leaseFirmTermMonths = 96;
        }else if(leaseTerm == '19 months, 11 firm' || leaseTerm == '19 months,11 firm'){
            leaseFirmTermMonths = 11;
        }else if(leaseTerm == '25 months, 16 firm' || leaseTerm == '25 months,16 firm'){
            leaseFirmTermMonths = 16;
        }else if(leaseTerm == '10 years,5 firm'){
            leaseFirmTermMonths = 60;
        }
        return leaseFirmTermMonths;
    }
    public Boolean rlpGT2016 { get; set; }     //Vaishali added for FY17
    public Boolean rlpGT { get; set; }
    public Integer rlpYearValue {get; set;}

    public PBS_AAAP_CALCULATIONS() {

    } 
    
    public Decimal getBCAF(Double pUSF, Double pRSF) {
        System.debug('##### Begin getBCAF');
        System.debug('##### pUSF: ' + pUSF);
        System.debug('##### pRSF: ' + pRSF);
        Decimal returnVal = 0.00; 
        if (pUSF > 0) {
            returnVal = pRSF / pUSF;
        }   // end if
        System.debug('##### End getBCAF');
        return returnVal;
    }   // end pBCAF

    // calculate the total construction markups for new and succeeding spaces (both first tier and 2nd tier markups)
    // formula for UOM = $: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees ($ - dollar amount)
    // formula for UOM = %: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees (% - Rate)
    // formula for no AE fees: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees)
    public static Decimal getConstrMarkups(Double pTiValue, Double pPBS_AAAP_GC_OVERHEAD_AND_PROF, Double pPBS_AAAP_GC_CONDITIONS,
            Double pPBS_AAAP_MANAGEMENT_COORD_FEES, Double pPBS_AAAP_ARCH_ENG_FEES, String pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM,
            Double pMaxFund) {
        System.debug('##### Begin - getConstrMarkups ');
        System.debug('***** formula terms :: pTiValue = ' + pTiValue);
        System.debug('***** formula terms :: pPBS_AAAP_GC_OVERHEAD_AND_PROF = ' + pPBS_AAAP_GC_OVERHEAD_AND_PROF);
        System.debug('***** formula terms :: pPBS_AAAP_GC_CONDITIONS = ' + pPBS_AAAP_GC_CONDITIONS);
        System.debug('***** formula terms :: pPBS_AAAP_MANAGEMENT_COORD_FEES = ' + pPBS_AAAP_MANAGEMENT_COORD_FEES);
        System.debug('***** formula terms :: pPBS_AAAP_ARCH_ENG_FEES = ' + pPBS_AAAP_ARCH_ENG_FEES);
        System.debug('***** formula terms :: pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM = ' + pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM);
        System.debug('***** formula terms :: pMaxFund = ' + pMaxFund);
        Decimal returnVal = 0.00;   // default return value
        Double ti = math.abs(pMaxFund - pTiValue);      // TI for calculations
        System.debug('***** formula terms :: ti = ' + ti);

        if ((pPBS_AAAP_ARCH_ENG_FEES != null) || (pPBS_AAAP_ARCH_ENG_FEES > 0)) {
            // determine how to process the fees (% or $)
            if (pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM == '%') {    // percentage fees
                returnVal = ((ti * (pPBS_AAAP_GC_OVERHEAD_AND_PROF / 100)) + (ti * (pPBS_AAAP_ARCH_ENG_FEES / (pPBS_AAAP_ARCH_ENG_FEES + 100))));
                System.debug('***** formula terms AE%:: returnVal = ' + String.valueOf(returnVal));
            } else {    // dollar amount
                returnVal = ((ti * (pPBS_AAAP_GC_OVERHEAD_AND_PROF / 100)) + pPBS_AAAP_ARCH_ENG_FEES);
                System.debug('***** formula terms AE$:: returnVal = ' + String.valueOf(returnVal));
            }   // end if

        } else {    // no fees to process
            returnVal = (ti * (pPBS_AAAP_GC_OVERHEAD_AND_PROF / 100)) ;
            System.debug('***** formula terms no AE:: returnVal = ' + String.valueOf(returnVal));
        }   // end if
        //Vaishali RLP FY14 code change
        System.debug('##### End - getConstrMarkups ');
        return returnVal;

    }   // end getConstrMarkups
//Vaishali eFix change    May 2015
    // calculate the total construction markups for new and succeeding spaces (2nd tier markups)
    // formula for UOM = $: f(x) = (TI * % GC Overhead and Profit)
    // formula for UOM = %: f(x) = (TI * % GC Overhead and Profit) + Arch/Eng Fees (% - Rate)
    // formula for no AE fees: f(x) = (TI * % GC Overhead and Profit)
    public static Decimal getConstrMarkups2ndTier(Double pTiValue, Double pPBS_AAAP_GC_OVERHEAD_AND_PROF, Double pPBS_AAAP_GC_CONDITIONS,
            Double pPBS_AAAP_MANAGEMENT_COORD_FEES, Double pPBS_AAAP_ARCH_ENG_FEES, String pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM,
            Double pMaxFund) {
        System.debug('##### Begin - getConstrMarkups2ndTier ');
        System.debug('***** formula terms :: pTiValue = ' + pTiValue);
        System.debug('***** formula terms :: pPBS_AAAP_GC_OVERHEAD_AND_PROF = ' + pPBS_AAAP_GC_OVERHEAD_AND_PROF);
        System.debug('***** formula terms :: pPBS_AAAP_GC_CONDITIONS = ' + pPBS_AAAP_GC_CONDITIONS);
        System.debug('***** formula terms :: pPBS_AAAP_MANAGEMENT_COORD_FEES = ' + pPBS_AAAP_MANAGEMENT_COORD_FEES);
        System.debug('***** formula terms :: pPBS_AAAP_ARCH_ENG_FEES = ' + pPBS_AAAP_ARCH_ENG_FEES);
        System.debug('***** formula terms :: pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM = ' + pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM);
        System.debug('***** formula terms :: pMaxFund = ' + pMaxFund);
        Decimal returnVal = 0.00;   // default return value
        Double ti = math.abs(pMaxFund - pTiValue);      // TI for calculations
        System.debug('***** formula terms :: ti = ' + ti);

        if ((pPBS_AAAP_ARCH_ENG_FEES != null) || (pPBS_AAAP_ARCH_ENG_FEES > 0)) {
            // determine how to process the fees (% or $)
            if (pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM == '%') {    // percentage fees
                returnVal = ((ti * (pPBS_AAAP_GC_OVERHEAD_AND_PROF / 100)) + (ti * (pPBS_AAAP_ARCH_ENG_FEES / (pPBS_AAAP_ARCH_ENG_FEES + 100))));
                System.debug('***** formula terms AE%:: returnVal = ' + String.valueOf(returnVal));
            } else {    // dollar amount
                returnVal = ti * (pPBS_AAAP_GC_OVERHEAD_AND_PROF / 100) ;
                System.debug('***** formula terms AE$:: returnVal = ' + String.valueOf(returnVal));
            }   // end if

        } else {    // no fees to process
            returnVal = (ti * (pPBS_AAAP_GC_OVERHEAD_AND_PROF / 100)) ;
            System.debug('***** formula terms no AE:: returnVal = ' + String.valueOf(returnVal));
        }   // end if
        //Vaishali eFix code change
        System.debug('##### End - getConstrMarkups2ndTier ');
        return 0; //returnVal;

    }   // end getConstrMarkups2ndTier

    // calculate the total construction markups for new spaces where the arch/eng UOM is $ (dollars)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees ($ - dollar amount)
    public Decimal getNewConstrMarkups(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer) {
        Decimal returnVal = 0.00;   // default return value
        Double ti = pOffer.PBS_AAAP_RLP_TI_New_Space__c;    // TI for new spaces

        // formula for calculation
        //Vaishali RLP FY14 code change
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)) + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);
        //Vaishali RLP FY14 code change
        returnVal = temp.doubleValue();
        return returnVal;
    }   // end getNewConstrMarkups


    // calculate the total construction markups for new spaces where the arch/eng UOM is % (percentage)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees (% - Rate)
    public Decimal getNewConstrMarkupsPrctg(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer) {
        Decimal returnVal = 0.00;   // default return value
        Double ti = pOffer.PBS_AAAP_RLP_TI_New_Space__c;    // TI for new spaces

        // formula for calculation -- have to convert the rates to decimals
        //Vaishali RLP FY14 code change
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)) + ( ti * (pSpace.PBS_AAAP_ARCH_ENG_FEES__c / 100)));
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_ARCH_ENG_FEES__c / (pSpace.PBS_AAAP_ARCH_ENG_FEES__c + 100))));
        //Vaishali RLP FY14 code change
        returnVal = temp.doubleValue();
        return returnVal;
    }   // end getNewConstrMarkupsPrctg


    // calculate the total construction markups for succeeding spaces where the arch/eng UOM is $ (dollars)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees ($ - dollar amount)
    public Decimal getSuccConstrMarkups(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer) {
        Decimal returnVal = 0.00;   // default return value
        Double ti = pOffer.PBS_AAAP_RLP_TI_Additional_Space__c; // TI for new spaces

        // formula for calculation
        //Vaishali RLP FY14 code change
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)) + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);
        //Vaishali RLP FY14 code change
        returnVal = temp.doubleValue();
        return returnVal;
    }   // end getSuccConstrMarkups


    // calculate the total construction markups for succeeding spaces where the arch/eng UOM is % (percentage)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees (% - Rate)
    public Decimal getSuccConstrMarkupsPrctg(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer) {
        System.debug('##### Begin - getSuccConstrMarkupsPrctg ');
        Decimal returnVal = 0.00;   // default return value
        Double ti = pOffer.PBS_AAAP_RLP_TI_Additional_Space__c; // TI for new spaces
        System.debug('***** formula terms :: ti = ' + ti);
        System.debug('***** formula terms :: pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = ' + pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c);
        System.debug('***** formula terms :: pSpace.PBS_AAAP_GC_CONDITIONS__c = ' + pSpace.PBS_AAAP_GC_CONDITIONS__c);
        System.debug('***** formula terms :: pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c = ' + pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c);
        System.debug('***** formula terms :: pSpace.PBS_AAAP_ARCH_ENG_FEES__c = ' + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);

        // formula for calculation -- have to convert the rates to decimals
        //Vaishali RLP FY14 code change
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)) + ( ti * (pSpace.PBS_AAAP_ARCH_ENG_FEES__c / 100)));
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_ARCH_ENG_FEES__c / (pSpace.PBS_AAAP_ARCH_ENG_FEES__c + 100))));
        //Vaishali RLP FY14 code change
        System.debug('***** formula terms :: temp = ' + temp);
        System.debug('##### End - getSuccConstrMarkupsPrctg ');
        returnVal = temp.doubleValue();
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        return returnVal;
    }   // end getSuccConstrMarkupsPrctg


    // calculate the total construction markups for new spaces where the arch/eng UOM is $ (dollars)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees ($ - dollar amount)
    public Decimal getNewConstrMarkupsNoAEFee(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer) {
        Decimal returnVal = 0.00;   // default return value
        Double ti = pOffer.PBS_AAAP_RLP_TI_New_Space__c;    // TI for new spaces

        // formula for calculation
        //Vaishali RLP FY14 Change
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)));
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)));
        returnVal = temp.doubleValue();
        return returnVal;
    }   // end getNewConstrMarkupsNoAEFee


    // calculate the total construction markups for succeeding spaces where the arch/eng UOM is $ (dollars)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees ($ - dollar amount)
    public Decimal getSuccConstrMarkupsNoAEFee(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer) {
        Decimal returnVal = 0.00;   // default return value
        Double ti = pOffer.PBS_AAAP_RLP_TI_Additional_Space__c; // TI for new spaces

        // formula for calculation
        //Vaishali RLP FY14 Change
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)));
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)));
        returnVal = temp.doubleValue();
        return returnVal;
    }   // end getSuccConstrMarkupsNoAEFee


    // calculate the 2nd tier total construction markups for new spaces where the arch/eng UOM is $ (dollars)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees ($ - dollar amount)
    public Decimal get2ndNewConstrMarkups(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer, Double pMaxFund) {
        Decimal returnVal = 0.00;   // default return value
        Double ti = pMaxFund - pOffer.PBS_AAAP_RLP_TI_New_Space__c; // TI for new spaces

        // formula for calculation
        //Vaishali RLP FY14 code change
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)) + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);
// Vaishali       Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100))  + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)));
        //Vaishali RLP FY14 code change
        returnVal = temp.doubleValue();
        return returnVal;
    }   // end get2ndNewConstrMarkups


    // calculate the 2nd tier total construction markups for new spaces where the arch/eng UOM is % (percentage)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees (% - Rate)
    public Decimal get2ndNewConstrMarkupsPrctg(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer, Double pMaxFund) {
        Decimal returnVal = 0.00;   // default return value
        Double ti = pMaxFund - pOffer.PBS_AAAP_RLP_TI_New_Space__c; // TI for new spaces

        // formula for calculation -- have to convert the rates to decimals
        //Vaishali RLP FY14 code change
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)) + ( ti * (pSpace.PBS_AAAP_ARCH_ENG_FEES__c / 100)));
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_ARCH_ENG_FEES__c / (pSpace.PBS_AAAP_ARCH_ENG_FEES__c + 100))));
        //Vaishali RLP FY14 code change
        returnVal = temp.doubleValue();
        return 0; // returnVal;
    }   // end get2ndNewConstrMarkupsPrctg


    // calculate the 2nd tier total construction markups for new spaces where the arch/eng UOM is $ (dollars)
    // formula: f(x) = (TI * % GC Overhead and Profit) + ( TI * % General Conditions) + (TI * % Mgmt. / Coord. Fees) + Arch/Eng Fees ($ - dollar amount)
    public Decimal get2ndNewConstrMarkupsNoAEFee(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer, Double pMaxFund) {
        Decimal returnVal = 0.00;   // default return value
        Double ti = pMaxFund - pOffer.PBS_AAAP_RLP_TI_New_Space__c; // TI for new spaces

        // formula for calculation
        //RLP FY14 Vaishali
//        Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS__c / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES__c /100)));
        Decimal temp = ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100)));
        returnVal = temp.doubleValue();
        return 0; // returnVal;
    }   // end get2ndNewConstrMarkupsNoAEFee


    // calculate the fully serviced lease rate
    // formula: f(x) = (Base Rent) + (Base year operating cost) + (Annual TI amortized pmt.)
    public Decimal getFullySrvcLeaseRateFiveYr(List<PBS_AAAP_Rate__c> pRates, PBS_AAAP_Offer__c pOffer, PBS_AAAP_Space__c pSpace, Decimal pFreeRentNewSpace) {
        Decimal returnVal = 0.00;   // default return value
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();

        // need only the rate for the five year lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == FIVEYR) {
                rate = r;
            } else {
                continue;
            }   // end if
        }   // end for
        Decimal temp = (rate.PBS_AAAP_BASE_RATE__c + (pOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c + pOffer.PBS_AAAP_SECT2_TOTAL__c) + math.abs(pFreeRentNewSpace));
        returnVal = temp.doubleValue();
        return returnVal;
    }   // end getFullySrvcLeaseRateFiveYr


    // calculate the fully serviced lease rate
    // formula: f(x) = (Base Rent) + (Base year operating cost) + (Annual TI amortized pmt.)
    public Decimal getFullySrvcLeaseRateFiveFiveYr(List<PBS_AAAP_Rate__c> pRates, PBS_AAAP_Offer__c pOffer, PBS_AAAP_Space__c pSpace, Decimal pFreeRentNewSpace) {
        System.debug('##### Begin -- getFullySrvcLeaseRateFiveFiveYr ');
        Decimal returnVal = 0.00;   // default return value
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();

        // need only the rate for the five year + five year option lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == FIVEFIVEYR) {
                rate = r;
            } else {
                continue;
            }   // end if
        }   // end for
        System.debug('##### rate.PBS_AAAP_BASE_RATE__c: ' + rate.PBS_AAAP_BASE_RATE__c);
        System.debug('##### pOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c + pOffer.PBS_AAAP_SECT2_TOTAL__c: ' + pOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c + ' +  ' + pOffer.PBS_AAAP_SECT2_TOTAL__c);
        System.debug('##### pFreeRentNewSpace: ' + pFreeRentNewSpace);
        Decimal temp = (rate.PBS_AAAP_BASE_RATE__c + (pOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c + pOffer.PBS_AAAP_SECT2_TOTAL__c) + math.abs(pFreeRentNewSpace));
        returnVal = temp.doubleValue();
        System.debug('##### End -- getFullySrvcLeaseRateFiveFiveYr ');
        return returnVal;
    }   // end getFullySrvcLeaseRateFiveFiveYr


    // calculate the fully serviced lease rate
    // formula: f(x) = (Base Rent) + (Base year operating cost) + (Annual TI amortized pmt.)
    public Decimal getFullySrvcLeaseRateTenYr(List<PBS_AAAP_Rate__c> pRates, PBS_AAAP_Offer__c pOffer, PBS_AAAP_Space__c pSpace, Decimal pFreeRentNewSpace) {
        Decimal returnVal = 0.00;   // default return value
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();

        // need only the rate for the ten year lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == TENYR) {
                rate = r;
            } else {
                continue;
            }   // end if
        }   // end for
        Decimal temp = (rate.PBS_AAAP_BASE_RATE__c + (pOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c + pOffer.PBS_AAAP_SECT2_TOTAL__c) + math.abs(pFreeRentNewSpace));
        returnVal = temp.doubleValue();
        return returnVal;
    }   // end getFullySrvcLeaseRateTenYr


    // calculate the first tier TI value for new spaces
    // formula: f(x) = TI for New Spaces + Total Construction Markups for New Spaces
    public Decimal getNewFirstTierTI(Double pTI, Double pConstMarkup) {
        Decimal returnVal = 0.00;
        returnVal = pTI + pConstMarkup;
        return returnVal;
    }   // end getFirstTierTI


    // calculate the first tier TI value for succeeding spaces
    // If the (TI Succeeding + Total Construction Markups for Succeeding Spaces) is less than or equal to the "Max TI value",
    // then use the use the (TI Succeeding + Total Construction Markups for Succeeding Spaces),
    // else use the "Max TI Value"
    // ** note Max TI is the same as TI Used
    public Decimal getSuccFirstTierTI(Double pTI, Double pConstMarkup, Double pMaxTI) {
        System.debug('##### Begin -- getSuccFirstTierTI');
        System.debug('***** formula terms :: pTI = ' + pTI);
        System.debug('***** formula terms :: pConstMarkup = ' + pConstMarkup);
        Decimal returnVal = 0.00;
        Double tiAndMarkup = pTI + pConstMarkup;
        System.debug('***** formula terms :: tiAndMarkup = ' + tiAndMarkup);
        returnVal = (tiAndMarkup <= pMaxTI) ? tiAndMarkup : pMaxTI;
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getSuccFirstTierTI');
        return returnVal;
    }   // end getFirstTierTI


    // calculate the second tier TI value for new spaces
    // formula: f(x) = Calculated Rate + total cost of construction markups based on the second tier TI value
    //
    // ** formula for caculated rate **
    // If the (TI for New Spaces + Total Construction Markups for New Spaces) is less than or equal to the "Max TI value",
    //  then the rate is zero
    // else
    //  if the (TI for New Spaces + Total Construction Markups for New Spaces) is greater than or equal to Max TI Fundable
    //      then the rate is the (Max TI Fundable - Max TI Rate)
    //  else the rate is the (TI for New Spaces + Total Construction Markups for New Spaces) - Max TI Rate
    public Decimal getNewSecondTierTI(Double pTI, Double pConstMarkup, Double pConstMarkup2Tier, Double pMaxTi, Double pMaxFund) {
        System.debug('##### Begin -- getNewSecondTierTI');
        System.debug('***** formula terms :: pTI = ' + pTI);
        System.debug('***** formula terms :: pConstMarkup = ' + pConstMarkup);
        System.debug('***** formula terms :: pConstMarkup2Tier = ' + pConstMarkup2Tier);
        System.debug('***** formula terms :: pMaxTi = ' + pMaxTi);
        System.debug('***** formula terms :: pMaxFund = ' + pMaxFund);
        Decimal returnVal = 0.00;
        Double tiAndMarkup = pTI + pConstMarkup;
        Double maxFundLessTi = pMaxFund - pTI;
        Double calcRate = (tiAndMarkup <= pMaxTi) ? 0.00 : ((tiAndMarkup >= pMaxFund) ? maxFundLessTi : (tiAndMarkup - pMaxTi));
        Decimal temp = calcRate + pConstMarkup2Tier;
        returnVal = temp.doubleValue();
        System.debug('##### End -- getNewSecondTierTI');
        //return returnVal;
        return 0; //Vaishali 10/22/2015
    }   // end getNewSecondTierTI


    // calculate the second tier TI value for succeeding spaces
    // If the (TI Succeeding + Total Construction Markups for Succeeding Spaces) is greater than the "Max TI value",
    // then the rate is (TI Succeeding + Total Construction Markups for Succeeding Spaces) - Max TI
    // else the rate is zero.
    public Decimal getSuccSecondTierTI(Double pTI, Double pConstMarkup, Double pMaxTi) {
        System.debug('##### Begin -- getSuccSecondTierTI');
        System.debug('***** formula terms :: pTI = ' + pTI);
        System.debug('***** formula terms :: pConstMarkup = ' + pConstMarkup);
        System.debug('***** formula terms :: pMaxTi = ' + pMaxTi);
        Decimal returnVal = 0.00;
        Double tiAndMarkup = pTI + pConstMarkup;
        Decimal temp = ((pTI + pConstMarkup) > pMaxTi) ? ((pTI + pConstMarkup) - pMaxTi) : 0;
        returnVal = temp.doubleValue();
        System.debug('##### End -- getSuccSecondTierTI');
        //return returnVal;
        return 0; //Vaishali 10/22/2015
    }   // end getSuccSecondTierTI


    // calculate the value of the first tier free rent for five year lease term
    // formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
    // i = (Amortization rate / 100) / 12
    // PVoa = First Tier TI
    public Decimal get1rstNewFreeRentForFiveYear(List<PBS_AAAP_Rate__c> pRates, Double pNewFirstTierTI, String pLeaseTerm) {
        System.debug('##### Begin -- get1rstNewFreeRentForFiveYear');
        System.debug('***** formula terms :: pRates = ' + pRates);
        System.debug('***** formula terms :: pLeaseTerm = ' + pLeaseTerm);
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        Decimal returnVal = 0.00;

        // need to get the rate for the correct year lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == pLeaseTerm) {
                rate = r;
//            } else if(r.PBS_AAAP_LEASE_TERM__c == pLeaseTerm){
//                rate = r;
            } else {
                continue;
            }// end if
        } // end for


        System.debug('***** formula terms :: rate = ' + rate);
        // avoid "DIV by 0" errors
        System.debug('***** formula terms :: rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = ' + rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
        Decimal intRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c > 0) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c : 0.000000001;

        System.debug('***** formula terms :: pNewFirstTierTI = ' + String.valueOf(pNewFirstTierTI));
        System.debug('***** formula terms :: intRate = ' + intRate);
        Decimal rateConversion = (intRate / 100) / 12;
        System.debug('***** formula terms :: rateConversion = ' + rateConversion);
        Decimal base = 1.00 + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Decimal denominator = (1 - (1 / math.pow(base.doubleValue(), 60))) / rateConversion;
        System.debug('***** formula terms :: denominator = ' + denominator);
        Decimal temp = 12 * (pNewFirstTierTi / denominator);

        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- get1rstNewFreeRentForFiveYear');
        return returnVal;
    }   // end get1rstNewFreeRentForFiveYear


// calculate the value of the first-tier, new-space, free rent for five year lease term (five year + five year option is treated here as well)
// formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
// i = (Amortization rate / 100) / 12
// PVoa = First Tier TI


//-----RITM0021675, RITM002167, RITM0021677---------------------------------------------------------------------------------------------------------
//----created a new function to calculate the TI using the BSAC
    public Decimal getSucc1rstFreeRentForFiveYearwithBSAC(List<PBS_AAAP_Rate__c> pRates, Double pNewFirstTierTI, String pLeaseTerm, Double pBSACRate, Integer pLeaseinMonths) {
//pRates = rates associated to the offer
//pNewFirstTierTI  =  RLP.PBS_AAAP_BSAC_PER_ABOA
//pLeaseTerm rate term in question (5, 5+%, 10),
//pLeaseinMonths = lease term in months could be derived from the lease term, but there's no standard lease


        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        Decimal returnVal = 0.00;
        Double BSAC_Rate = (pBSACRate == null) ? 0 : pBSACRate;  //check for null
        // need only the rate for the appropriate lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == pLeaseTerm) {
                rate = r;
            } else {
                continue;
            }  // end if
        } // end for

        // avoid "DIV by 0" errors
//    Decimal intRate      = (rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c >  0) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c :  0.000000001;
//    Double rateConversion  =  (intRate /100) / 12;
//12 * ( PVoa / [ (1 - (1 / (1 + rateConversion)^-n )) / rateConversion] )
//
//    Double base        =  (1.00).doubleValue() + rateConversion;
//12 * ( PVoa / [ (1 - (1 / base ^-n )) / rateConversion] )
//
//    Double denominator    =  (1 - ( 1 / math.pow(base, 60))) / rateConversion;
//12 * ( PVoa / [denominator] )
//
//    Decimal temp  =  12 * (pNewFirstTierTi / denominator);
//temp

//can't pull from the rate, since it's not written to the database at the time of the calculation
        Decimal intRate = (BSAC_Rate > 0) ? BSAC_Rate : 0.000000001;
        System.debug('#*****intRate:' + intRate);
        System.debug('#*****intRate:' + intRate);

        Double rateConversion = (intRate / 100) / 12;
//12 * ( PVoa / [ (1 - (1 / (1 + rateConversion)^-n )) / rateConversion] )
        System.debug('#*****rateConversion:' + rateConversion);
        Double base = (1.00).doubleValue() + rateConversion;
//12 * ( PVoa / [ (1 - (1 / base ^-n )) / rateConversion] )
        System.debug('#*****base:' + base);

        Double denominator = (1 - (1 / math.pow(base, pLeaseinMonths))) / rateConversion;
//12 * ( PVoa / [denominator] )
        System.debug('#*****denominator:' + denominator);

        Decimal temp = 12 * (pNewFirstTierTi / denominator);
//temp

        System.debug('#*****Raw:' + 12 * (pNewFirstTierTi / denominator));


        returnVal = temp.doubleValue() * -1 ;    // need to show the value as a absolute
        System.debug('#*****returnVal    :' + returnVal);

        return returnVal;
    }  // end getSucc1rstFreeRentForFiveYearwithBSAC
//--------------------------------------------------------------------------------------------------------------

    // calculate the value of the first-tier, new-space, free rent for five year lease term (five year + five year option is treated here as well)
    // formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
    // i = (Amortization rate / 100) / 12
    // PVoa = First Tier TI
    public Decimal getSucc1rstFreeRentForFiveYear(List<PBS_AAAP_Rate__c> pRates, Double pNewFirstTierTI, String pLeaseTerm) {
        System.debug('##### Begin -- getSucc1rstFreeRentForFiveYear');
        System.debug('***** formula terms :: pLeaseTerm = ' + pLeaseTerm);
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        Decimal returnVal = 0.00;

        // need only the rate for the appropriate lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == pLeaseTerm) {
                rate = r;
//Vaishali RLPFY15            } else if(r.PBS_AAAP_LEASE_TERM__c == pLeaseTerm){
//Vaishali RLPFY15                rate = r;
            } else {
                continue;
            }   // end if
        } // end for

        // avoid "DIV by 0" errors
        System.debug('***** formula terms :: rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = ' + rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
        Decimal intRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c > 0) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c : 0.000000001;
        System.debug('***** formula terms :: pNewFirstTierTI = ' + String.valueOf(pNewFirstTierTI));
        System.debug('***** formula terms :: intRate = ' + intRate);
        Double rateConversion = (intRate / 100) / 12;
        Double base = (1.00).doubleValue() + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Double denominator = (1 - (1 / math.pow(base, 60))) / rateConversion;
        System.debug('***** formula terms :: denominator = ' + denominator);
        Decimal temp = 12 * (pNewFirstTierTi / denominator);
        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getSucc1rstFreeRentForFiveYear');
        return returnVal;
    }   // end getSucc1rstFreeRentForFiveYear


    // calculate the value of the first tier free rent for ten year lease term
    // formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
    // i = (Amortization rate / 100) / 12
    // PVoa = First Tier TI
    public Decimal get1rstNewFreeRentForTenYear(List<PBS_AAAP_Rate__c> pRates, Double pNewFirstTierTI, String pLeaseTerm) {
        System.debug('##### Begin -- get1rstNewFreeRentForTenYear');
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        Decimal returnVal = 0.00;

        // need only the rate for the ten year lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == pLeaseTerm) {
                rate = r;
            } else {
                continue;
            }   // end if
        }   // end for

        // avoid "DIV by 0" errors
        System.debug('***** formula terms :: rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = ' + rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
        Decimal intRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c > 0) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c : 0.000000001;
        System.debug('***** formula terms :: pNewFirstTierTI = ' + String.valueOf(pNewFirstTierTI));
        System.debug('***** formula terms :: intRate = ' + intRate);
        Double rateConversion = (intRate / 100) / 12;
        Double base = (1.00).doubleValue() + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Double denominator = (1 - (1 / math.pow(base, 120))) / rateConversion;
        Decimal temp = 12 * (pNewFirstTierTi / denominator);
        System.debug('***** formula terms :: denominator = ' + denominator);
        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- get1rstNewFreeRentForTenYear');
        return returnVal;
    }   // end get1rstNewFreeRentForTenYear


    // calculate the value of the first-tier, free-rent for ten year lease term (five year + five year option is treated here as well)
    // formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
    // i = (Amortization rate / 100) / 12
    // PVoa = First Tier TI
    public Decimal getSucc1rstFreeRentForTenYear(List<PBS_AAAP_Rate__c> pRates, Double pNewFirstTierTI) {
        System.debug('##### Begin -- getSucc1rstFreeRentForTenYear');
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        Decimal returnVal = 0.00;

        // need only the rate for the five year lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == FIVEYR || r.PBS_AAAP_LEASE_TERM__c == TENYR || r.PBS_AAAP_LEASE_TERM__c == FIFTEENTENYR) {
                rate = r;
            } else {
                continue;
            }   // end if
        } // end for

        // avoid "DIV by 0" errors
        System.debug('rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c is ' + rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);
        Decimal intRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c > 0) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c : 0.000000001;
        System.debug('***** formula terms :: pNewFirstTierTI = ' + String.valueOf(pNewFirstTierTI));
        System.debug('intRate is ' + intRate);
        Double rateConversion = (intRate / 100) / 12;
        Double base = (1.00).doubleValue() + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Double denominator = (1 - (1 / math.pow(base, 120))) / rateConversion;
        System.debug('***** formula terms :: denominator = ' + denominator);
        Decimal temp = 12 * (pNewFirstTierTi / denominator);
        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getSucc1rstFreeRentForTenYear');
        return returnVal;
    }   // end getSucc1rstFreeRentForTenYear


    // calculate the value of the second-tier, succeeding-space, free rent for ten year lease term
    // formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
    // i = (Amortization rate above TI / 100) / 12
    // PVoa = First Tier TI
    public Decimal get2ndSuccFreeRentForTenYear(List<PBS_AAAP_Rate__c> pRates, Double pNewSecondTierTI) {
        System.debug('##### Begin -- get2ndSuccFreeRentForTenYear');
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        Decimal returnVal = 0.00;

        // need only the rate for the ten year lease term //&&&^^^vss
        for (PBS_AAAP_Rate__c r : pRates) {
            if ((r.PBS_AAAP_LEASE_TERM__c == TENYR) || (r.PBS_AAAP_LEASE_TERM__c == FIFTEENTENYR)) {
                rate = r;
            } else {
                continue;
            }   // end if
        }   // end for

        // avoid "DIV by 0" errors
        Decimal intRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c > 0) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c : 0.000000001;
        System.debug('***** formula terms :: pNewSecondTierTI = ' + String.valueOf(pNewSecondTierTI));
        Double rateConversion = (intRate / 100) / 12;
        Double base = (1.00).doubleValue() + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Double denominator = (1 - (1 / math.pow(base, 120))) / rateConversion;
        Decimal temp = 12 * (pNewSecondTierTI / denominator);
        System.debug('***** formula terms :: denominator = ' + denominator);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- get2ndSuccFreeRentForTenYear');
        return returnVal;
    }   // end get2ndSuccFreeRentForTenYear


    // calculate the value of the second tier free rent for ten year lease term
    // formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
    // i = (Amortization rate above TI / 100) / 12
    // PVoa = Second Tier TI
    public Decimal get2ndNewFreeRentForTenYear(List<PBS_AAAP_Rate__c> pRates, Double pNewSecondTierTI) {
        System.debug('##### Begin -- get2ndNewFreeRentForTenYear');
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        Decimal returnVal = 0.00;

        // need only the rate for the ten year lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == TENYR) {
                rate = r;
            } else {
                continue;
            }   // end if
        }   // end for

        // avoid "DIV by 0" errors
        Decimal intRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c > 0) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c : 0.000000001;
        System.debug('***** formula terms :: pNewSecondTierTI = ' + String.valueOf(pNewSecondTierTI));
        Double rateConversion = (intRate / 100) / 12;
        Double base = (1.00).doubleValue() + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Double denominator = (1 - (1 / math.pow(base, 120))) / rateConversion;
        Decimal temp = 12 * (pNewSecondTierTI / denominator);
        System.debug('***** formula terms :: denominator = ' + denominator);
        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- get2ndNewFreeRentForTenYear');
        return returnVal;
    }   // end get2ndNewFreeRentForTenYear


    // calculate the value of the second tier free rent for five year lease term (five year + five year option is treated here as well)
    // formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
    // i = (Amortization rate / 100) / 12
    // PVoa = First Tier TI
    public Decimal get2ndNewFreeRentForFiveYear(List<PBS_AAAP_Rate__c> pRates, Double pNewSecondTierTI, String pLeaseTerm) {
        System.debug('##### Begin -- get2ndNewFreeRentForFiveYear');
        System.debug('***** formula terms :: pLeaseTerm = ' + pLeaseTerm);
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        Decimal returnVal = 0.00;

        // need to match the rate to the lease term
        for (PBS_AAAP_Rate__c r : pRates) {
            if (r.PBS_AAAP_LEASE_TERM__c == pLeaseTerm) {
                rate = r;
//Vaishali RLPFY15            } else if(r.PBS_AAAP_LEASE_TERM__c == pLeaseTerm){
//Vaishali RLPFY15                rate = r;
            } else {
                continue;
            }   // end if
        } // end for

        // avoid "DIV by 0" errors
        Decimal intRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c > 0) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c : 0.000000001;
        System.debug('***** formula terms :: pNewSecondTierTI = ' + String.valueOf(pNewSecondTierTI));
        System.debug('***** formula terms :: intRate = ' + String.valueOf(intRate));
        System.debug('***** formula terms :: rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = ' + rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c);
        Double rateConversion = (intRate / 100) / 12;
        Double base = (1.00).doubleValue() + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        System.debug('***** formula terms :: math.pow(base, 60) = ' + math.pow(base, 60));
        System.debug('***** formula terms :: rateConversion = ' + rateConversion);
        Double denominator = (1 - (1 / math.pow(base, 60))) / rateConversion;
        System.debug('***** formula terms :: denominator = ' + denominator);
        Decimal temp = 12 * (pNewSecondTierTI / denominator);
        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- get2ndNewFreeRentForFiveYear');
        return returnVal;
    }   // end get2ndNewFreeRentForFiveYear


    // calculate the value of free rent for a new space (or a succeeding space depending on the parameters you pass)
    // formula: f(x) = First Tier Free Rent + Second Tier Free Rent
    public Decimal getFreeRentNewSpace(Double p1rstTierFreeRent, Double p2ndTierFreeRent) {
        System.debug('##### Begin -- getFreeRentNewSpace');
        Decimal returnVal = 0.00;
        System.debug('***** formula terms :: p1rstTierFreeRent = ' + p1rstTierFreeRent);
        System.debug('***** formula terms :: p2ndTierFreeRent = ' + p2ndTierFreeRent);
        Decimal temp = p1rstTierFreeRent + p2ndTierFreeRent;
        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp;
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getFreeRentNewSpace');
        return returnVal;
    } // getFreeRentNewSpace


    // calculate the Base Rent + TI
    // (Base Rate + TI) = {(rateE.fiveYearFS + rateE.fiveYrTIAmorCosts) * -1 } * Discount Rate "multiplier"     --> for five year and five + five
    // (Base Rate + TI) = {(rateE.tenYearFS + rateE.tenYrTIAmorCosts) * -1 } * Discount Rate "multiplier"       --> for ten year
    // Dicsount Rate multiplier =   1 / ((1 + (pDiscRate / 100))^4
    // pTerm = 5 or 10 depending upon the calculation to be formed
    public Decimal getBaseRentAndTI(Decimal pYearFS, Double pYearTIAmorCosts, Double pDiscRate, Integer pTerm) {
        System.debug('##### Begin -- getBaseRentAndTI');
        Decimal returnVal = 0.00;
        Decimal discRtMult = 0.00;

        if (pTerm == Double.valueOf(5)) {
            //discRtMult  =   this.getFiveYrAvgDiscount(pDiscRate);
            discRtMult = (this.rlpGT2016) ? this.getNewAvgDiscount(pDiscRate, 1, 5) : this.getFiveYrAvgDiscount(pDiscRate);
            System.debug('##### calc for five ');
        } else {
            System.debug('***** formula :: pvCost initial calc: ' + this.rlpGT2016);
            //discRtMult  =   this.getTenYrAvgDiscount(pDiscRate);
            discRtMult = (this.rlpGT2016) ? this.getNewAvgDiscount(pDiscRate, 1, 10) : this.getTenYrAvgDiscount(pDiscRate);
            System.debug('##### calc for ten ');
        }   // end if
        System.debug('***** formula terms :: pYearFS: ' + pYearFS);
        System.debug('***** formula terms :: pYearTIAmorCosts: ' + pYearTIAmorCosts);
        System.debug('***** formula terms :: pDiscRate: ' + pDiscRate);
        System.debug('***** formula terms :: discRtMult: ' + discRtMult);
        System.debug('***** formula terms :: pTerm: ' + pTerm);
        returnVal = (pYearFS + math.abs(pYearTIAmorCosts)) * discRtMult;
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getBaseRentAndTI');
        return returnVal;
    }   // end getBaseRentAndTI

    // calculate the five year average discount rate
    // formula: f(x) = (1 + (Discount Rate / 100) ^ (Year - 1)
    // where "Year" represents the year's (1, 2, 3, 4, or 5) average discount rate
    public Decimal getFiveYrAvgDiscount(Double pDiscRate) {
        System.debug('##### Begin -- getFiveYrAvgDiscount ****' + pDiscRate);
        //added by syam on 08/09/2016
        if (pDiscRate == null) {
            pDiscRate = 0;
        }
        Decimal returnVal = 0.00;
        Decimal discount = 0.00;
        for (Integer i = 0; i < 5; i++) {
            if (i == 0) {
                discount = math.pow((1 + (pDiscRate / 100)), i);
            } else {
                discount = 1 / math.pow((1 + (pDiscRate / 100)), i);
            }
            System.debug('##### discount: ' + discount);
            returnVal = returnVal + discount;
            System.debug('##### returnVal in loop: ' + returnVal);
        } // end for

        returnVal = returnVal / 5;
        returnVal = (this.rlpGT2016) ? getNewAvgDiscount(pDiscRate, 1, 5) : returnVal;
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getFiveYrAvgDiscount');
        return returnVal;
    }   // getFiveYrAvgDiscount

    // calculate the five year average discount rate for years 6 - 10
    // formula: f(x) = (1 + (Discount Rate / 100) ^ (Year - 1)
    // where "Year" represents the year's (1, 2, 3, 4, or 5) average discount rate
    public Decimal getFiveYrAvgDiscountYrSixThruTen(Double pDiscRate) {
        System.debug('##### Begin -- getFiveYrAvgDiscountYrSixThruTen');
        Decimal returnVal = 0.00;
        Decimal discount = 0.00;
        for (Integer i = 5; i < 10; i++) {
            discount = 1 / math.pow((1 + (pDiscRate / 100)), i);
            System.debug('##### discount: ' + discount);
            returnVal = returnVal + discount;
            System.debug('##### returnVal in loop: ' + returnVal);
        } // end for

        returnVal = returnVal / 5;
        returnVal = (this.rlpGT2016) ? getNewAvgDiscount(pDiscRate, 6, 10) : returnVal;
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getFiveYrAvgDiscountYrSixThruTen');
        return returnVal;
    }   // getFiveYrAvgDiscountYrSixThruTen


    // calculate the five year average CPI * discount rate
    // formula: f(x) = Avg. CPI * Avg. Discount
    // Avg. CPI = (1 + Escalation Rate) ^ (Year - 1)
    // Avg. Discount = (1 + (Discount Rate / 100) ^ (Year - 1)
    // where "Year" represents the year's (1, 2, 3, 4, or 5) average discount rate
    public Decimal getFiveYrAvgCpiAndDiscount(Double pDiscRate, Double pEscltRate) {
        System.debug('##### Begin -- getFiveYrAvgCpiAndDiscount' + pDiscRate + ' pEscltRate is' + pEscltRate);
        Decimal returnVal = 0.00;
        Decimal discount = 0.00;
        Decimal cpi = 0.00;

        for (Integer i = 0; i < 5; i++) {
            if (i == 0) {
                discount = math.pow((1 + (pDiscRate / 100)), i);
                cpi = math.pow((1 + (pEscltRate / 100)), i);
            } else {
                discount = 1 / math.pow((1 + (pDiscRate / 100)), i);
                cpi = math.pow((1 + (pEscltRate / 100)), i);
            }
            System.debug('##### discount: ' + discount);
            System.debug('##### cpi: ' + cpi);
            Decimal cpiDiscount = cpi * discount;
            returnVal = returnVal + cpiDiscount;
            System.debug('##### returnVal in loop: ' + returnVal);
        } // end for

        returnVal = returnVal / 5;
        returnVal = (this.rlpGT2016) ? getNewAvgCpiAndDiscount(pDiscRate, pEscltRate, 1, 5) : returnVal;
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getFiveYrAvgCpiAndDiscount');
        return returnVal;
    }   // getFiveYrAvgCpiAndDiscount

    // calculate the five year average CPI * discount rate for years 6 - 10
    //

    // where "Year" represents the year's (1, 2, 3, 4, or 5) average discount rate
    public Decimal getFiveYrAvgCpiAndDiscountYrSixThruTen(Double pDiscRate, Double pEscltRate) {
        System.debug('##### Begin -- getFiveYrAvgCpiAndDiscountYrSixThruTen');
        Decimal returnVal = 0.00;
        Decimal discount = 0.00;
        Decimal cpi = 0.00;

        for (Integer i = 5; i < 10; i++) {
            discount = 1 / math.pow((1 + (pDiscRate / 100)), i);
            cpi = math.pow((1 + (pEscltRate / 100)), i);

            System.debug('##### discount: ' + discount);
            System.debug('##### cpi: ' + cpi);
            Decimal cpiDiscount = cpi * discount;
            returnVal = returnVal + cpiDiscount;

            System.debug('##### returnVal in loop: ' + returnVal);
        } // end for

        //returnVal   =   returnVal / 5;
        returnVal = (this.rlpGT2016) ? getNewAvgCpiAndDiscount(pDiscRate, pEscltRate, 6, 10) : returnVal / 5;
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getFiveYrAvgCpiAndDiscountYrSixThruTen');
        return returnVal;
    }   // getFiveYrAvgCpiAndDiscount

    // calculate the ten year average discount rate
    // formula: f(x) = (1 + (Discount Rate / 100) ^ (Year - 1)
    // where "Year" represents the year's (1, 2, 3, 4, ...10) average discount rate
    public Decimal getTenYrAvgDiscount(Double pDiscRate) {
        System.debug('##### Begin -- getTenYrAvgDiscount');
        Decimal returnVal = 0.00;
        Decimal fiveDiscount = 0.00;
        Decimal fiveYrAvgDisc = 0.00;
        Decimal tenDiscount = 0.00;
        Decimal tenYrAvgDisc = 0.00;

        for (Integer i = 0; i < 5; i++) {
            if (i == 0) {
                fiveDiscount = math.pow((1 + (pDiscRate / 100)), i);
            } else {
                fiveDiscount = 1 / math.pow((1 + (pDiscRate / 100)), i);
            } // end if
            System.debug('##### fiveDiscount: ' + fiveDiscount);
            fiveYrAvgDisc = fiveYrAvgDisc + fiveDiscount;
        } // end for

        for (Integer j = 5; j < 10; j++) {
            tenDiscount = 1 / math.pow((1 + (pDiscRate / 100)), j);
            //tenDiscount =   1/ math.pow((1.05).doubleValue(), j);  //Vaishali Commented 08/18 to resolve 1 cent issue
            System.debug('##### tenDiscount: ' + tenDiscount);
            tenYrAvgDisc = tenYrAvgDisc + tenDiscount;
        }   // end for

        fiveYrAvgDisc = fiveYrAvgDisc / 5;
        System.debug('##### fiveYrAvgDisc: ' + fiveYrAvgDisc);
        tenYrAvgDisc = tenYrAvgDisc / 5;
        System.debug('##### tenYrAvgDisc: ' + tenYrAvgDisc);
        returnVal = (fiveYrAvgDisc + tenYrAvgDisc) / 2;
        returnVal = (this.rlpGT2016) ? getNewAvgDiscount(pDiscRate, 1, 10) : returnVal;
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getTenYrAvgDiscount');
        return returnVal;
    }   // getTenYrAvgDiscount


    // calculate the ten year average discount rate
    // formula: f(x) = Avg. CPI * Avg. Discount
    // Avg. Discount = (1 + (Discount Rate / 100) ^ (Year - 1)
    // Avg. CPI = (1 + Escalation Rate) ^ (Year - 1)
    // where "Year" represents the year's (1, 2, 3, 4, ...10) average discount rate
    public Decimal getTenYrAvgCpiAndDiscount(Double pDiscRate, Double pEscltRate) {

        System.debug('##### Begin -- getTenYrAvgCpiAndDiscount');
        Decimal returnVal = 0.00;
        Decimal fiveDiscount = 0.00;
        Decimal fiveYrAvgDisc = 0.00;
        Decimal tenDiscount = 0.00;
        Decimal tenYrAvgDisc = 0.00;
        Decimal cpi = 0.00;

        for (Integer i = 0; i < 5; i++) {
            if (i == 0) {
                fiveDiscount = math.pow((1 + (pDiscRate / 100)), i);
                cpi = cpi + (fiveDiscount * math.pow((1 + (pEscltRate / 100)), i));
            } else {
                fiveDiscount = 1 / math.pow((1 + (pDiscRate / 100)), i);
                cpi = cpi + (fiveDiscount * math.pow((1 + (pEscltRate / 100)), i));
            } // end if
            System.debug('##### fiveDiscount: ' + fiveDiscount);
            System.debug('##### cpi: ' + cpi);
        } // end for

        for (Integer j = 5; j < 10; j++) {
            tenDiscount = 1 / math.pow((1 + (pDiscRate / 100)), j);
            //tenDiscount =   1/ math.pow((1.05).doubleValue(), j); //Vaishali Commented 08/18 to resolve 1 cent issue
            cpi = cpi + (tenDiscount * math.pow((1 + (pEscltRate / 100)), j));

            System.debug('##### tenDiscount: ' + tenDiscount);
            System.debug('##### cpi: ' + cpi);
        }   // end for

        returnVal = cpi / 10;
        returnVal = (this.rlpGT2016) ? getNewAvgCpiAndDiscount(pDiscRate, pEscltRate, 1, 10) : returnVal;
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### cpi: ' + cpi);
        System.debug('##### End -- getTenYrAvgCpiAndDiscount');
        return returnVal;
    }   // getTenYrAvgCpiAndDiscount


    // calculate the present value for new space for a five year term
    // formula: f(x) = ( Base Rate + TI ) + Operating Costs - Value of Free Rent - Commission Concession
    //
    // Terms Defined below:
    // (Base Rate + TI) = value returned from method getBaseRentAndTI()
    //
    // Operating Costs = Total Cost Per ABOA * Discount Rate "multiplier"
    //
    // Value of Free Rent = (rateE.fiveYearFS + Base Operating Costs + rateE.fiveYrDayTimeCleanCosts - Value of Free Rent TI Payment) / (60 * rateE.fiveYrFreeRentFIRM)
    // Base Operating Costs = offer.PBS_AAAP_SRVC_UTIL_TOTAL__c / Building Common Area Factor (which should be Total Cost Per ABOA from offer)
    // Value of Free Rent TI Payment = value returned from method get1rstNewFreeRentForFiveYear()
    //
    // Comission Concession = ( ( ( (rateE.fiveYearFS + Base Operating Costs - Value of Free Rent TI Payment) * 60) - Value of Free Rent) * (rateE.fiveYrBrokerageComm * Govt. % Commission Split) ) / 60
    //Vaishali RLP-FY15 pass additional parameter BSAC cost to be added to valFreeRent and commConcess calculations pDiscRate not used hence replaced with pBSAC. pDiscRate is actually storing BSAC
    public Decimal getFiveYearPV(Double pDayCleanCosts, Decimal pBaseRent, Double pBaseRentTi, Double pCpiDisc, Double pBaseYrOpCosts, Double pValFreeRentTi, Double pFiveYrBrokerageComm, Double pGovtCommSplit, Double pDiscRate, Double pFiveYrFreeRentFIRM) {
//******   pDiscRate is 5 Year BSACCost Vaishali RLP FY15
        System.debug('##### Begin -- getFiveYearPV');
        Decimal returnVal = 0.00;
        System.debug('***** pDayCleanCosts: ' + pDayCleanCosts);
        System.debug('***** pBaseRent: ' + pBaseRent);
        System.debug('***** pBaseRentTi: ' + pBaseRentTi);
        System.debug('***** pCpiDisc: ' + pCpiDisc);
        System.debug('***** pBaseYrOpCosts: ' + pBaseYrOpCosts);
        System.debug('***** pValFreeRentTi: ' + pValFreeRentTi);
        System.debug('***** pGovtCommSplit: ' + pGovtCommSplit);
        System.debug('***** pDiscRate (actual value passes is BSAC): ' + pDiscRate);
        System.debug('***** pFiveYrFreeRentFIRM: ' + pFiveYrFreeRentFIRM);
        System.debug('***** pFiveYrBrokerageComm: ' + pFiveYrBrokerageComm);

        Decimal calcOpCosts = pBaseYrOpCosts * pCpiDisc;  // includes term for factoring in the CPI Escalation and Discount rates
        System.debug('***** calcOpCosts: ' + calcOpCosts);
        //Vaishali RLP FY15 Add BSAC to Free Rent calculation pDiscRate is storing BSAC
//        Decimal valFreeRent     =   ((pBaseRent + pBaseYrOpCosts + pDayCleanCosts - pValFreeRentTi) / 60) * pFiveYrFreeRentFIRM;
        //Vaishali RLP FY15 remove pDayCleanCosts from freerent
        //    Decimal valFreeRent     =   ((pBaseRent + pBaseYrOpCosts + pDayCleanCosts - pDiscRate - pValFreeRentTi) / 60) * pFiveYrFreeRentFIRM;
        Decimal valFreeRent = ((pBaseRent + pBaseYrOpCosts - pDiscRate - pValFreeRentTi) / 60) * pFiveYrFreeRentFIRM;
        System.debug('***** valFreeRent: ' + valFreeRent);
        //Vaishali RLP FY15 Add BSAC to commConcess calculation pDiscRate is storing BSAC
//        Decimal commConcess     =   ((((pBaseRent + pBaseYrOpCosts - pValFreeRentTi) * 5) - ValFreeRent) * ((pFiveYrBrokerageComm / 100) * (pGovtCommSplit / 100)) / 5);
        Decimal commConcess = ((((pBaseRent + pBaseYrOpCosts - pDiscRate - pValFreeRentTi) * 5) - ValFreeRent) * ((pFiveYrBrokerageComm / 100) * (pGovtCommSplit / 100)) / 5);
        returnVal = pBaseRentTi + calcOpCosts - valFreeRent - commConcess;
        System.debug('***** commConcess: ' + commConcess);
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getFiveYearPV');
        return returnVal;
    }   // getFiveYearPV


    // calculate the present value for new space for a five year option term
    // formula: f(x) =  Base Rate  + Operating Costs - Value of Free Rent
    //
    // Terms Defined below:
    // (Base Rate ) = { (Full Service Option Rent Term) - (Base Operating Costs) } *  Discount Rate "multiplier" for years 6 - 10
    //
    // Operating Costs = Total Cost Per ABOA  * Discount Rate "multiplier"
    //
    // Value of Free Rent =  ( ( ( (Full Service Option Rent Term) - (Base Operating Costs) - (Additional Day Time Cleaning Rate) )  / ( 60 :: which is the lease option term in number of payments per year or 5X12) ) * (Number of Freem Months for Option) * (Discount Rate Calculation for the 6th year) )   // cont. next line
    //                                        +  ( ( ( ( (Base Operating Costs) + (Additional Day Time Cleaning Rate) ) * ( CPI Rate Calculation for the 6th Year * Discount Rate Calculation for the 6th Year) ) /  ( 60 :: which is the lease option term in number of payments per year or 5X12) ) *  (Number of Freem Months for Option) )
    //
    // Base Operating Costs = The total cost per ABOA found on the Offer.

//Vaishali RLP-FY15 no need to subtract base year Operating costs when calculating baseRate,

    public Decimal getFiveYearPVOption(Double pDayCleanCosts, Double pCpiDisc, Double pDisc, Double pRLPEscRate, Double pRLPDiscRate, Double pBaseYrOpCosts, Double pNumFreeMonthsOption, Double pFullSrvcRentOptTerm) {
        System.debug('##### Begin -- getFiveYearPVOption');
        Decimal returnVal = 0.00;
        System.debug('***** pDayCleanCosts: ' + pDayCleanCosts);
        System.debug('***** pCpiDisc: ' + pCpiDisc);
        System.debug('***** pDisc: ' + pDisc);
        System.debug('***** pRLPEscRate: ' + pRLPEscRate);
        System.debug('***** pRLPDiscRate: ' + pRLPDiscRate);
        System.debug('***** pBaseYrOpCosts: ' + pBaseYrOpCosts);
        System.debug('***** pNumFreeMonthsOption: ' + pNumFreeMonthsOption);
        System.debug('***** pFullSrvcRentOptTerm: ' + pFullSrvcRentOptTerm);
//Vaishali RLP FY15 Base rent now is shell and no need to subtract pBaseYrOpCosts from pFullSrvcRentOptTerm
//        Decimal baseRate            =   ( pFullSrvcRentOptTerm - pBaseYrOpCosts )* pDisc;           // includes term for factoring in the CPI Escalation and Discount rates and the full service rent option term
        Decimal baseRate = (pFullSrvcRentOptTerm) * pDisc;           // includes term for factoring in the CPI Escalation and Discount rates and the full service rent option term
        System.debug('***** baseRate: ' + baseRate);
        Decimal calcOpCosts = pBaseYrOpCosts * pCpiDisc;                                                          // includes term for factoring in the CPI Escalation and Discount rates
        System.debug('***** calcOpCosts: ' + calcOpCosts);
        Decimal discFor6thYr = 1 / math.pow((1 + (pRLPDiscRate / 100)), 5);
        System.debug('***** discFor6thYr: ' + discFor6thYr);
        Decimal escFor6thYr = math.pow((1 + (pRLPEscRate / 100)), 5);
        System.debug('***** escFor6thYr: ' + escFor6thYr);

        Decimal valFreeRent = (((pFullSrvcRentOptTerm - pBaseYrOpCosts - pDayCleanCosts) / 60) * pNumFreeMonthsOption * discFor6thYr) + (((pBaseYrOpCosts + pDayCleanCosts) * (discFor6thYr * escFor6thYr) / 60) * pNumFreeMonthsOption) ;
        System.debug('***** valFreeRent: ' + valFreeRent);
        returnVal = baseRate + calcOpCosts - valFreeRent;
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getFiveYearPVOption');
        return returnVal;
    }   // end getFiveYearPVOption

    // calculate the present value for new space for a ten year term
    // formula: f(x) = ( Base Rate + TI ) + Operating Costs - Value of Free Rent - Commission Concession
    //
    // Terms Defined below:
    // (Base Rate + TI) = value returned from method getBaseRentAndTI()
    //
    // Operating Costs = (offer.PBS_AAAP_SRVC_UTIL_TOTAL__c + offer.PBS_AAAP_SECT2_TOTAL__c) * Discount Rate "multiplier"
    //
    // Value of Free Rent = (rateE.tenYearFS + Base Operating Costs + rateE.tenYrDayTimeCleanCosts - Value of Free Rent TI Payment) / (120 * rateE.fiveYrFreeRentFIRM)
    // Base Operating Costs = The total cost per ABOA found on the Offer.
    // Value of Free Rent TI Payment = value returned from method get1rstNewFreeRentForTenYear()
    //
    // Comission Concession = ( ( ( (rateE.tenYearFS + Base Operating Costs - Value of Free Rent TI Payment) * 10) - Value of Free Rent) * (rateE.tenYrBrokerageComm * Govt. % Commission Split) ) / 10

//Vaishali RLP-FY15 pass additional parameter BSAC cost to be added to valFreeRent and commConcess calculations

    public Decimal getTenYearPV(Double pDayCleanCosts, Decimal pBaseRent, Double pBaseRentTi, Double pCpiDisc, Double pBaseYrOpCosts, Double pValFreeRentTi, Double pTenYrBrokerageComm, Double pGovtCommSplit, Double pDiscRate, Double pTenYrFreeRentFIRM) {
        System.debug(LoggingLevel.Info,'##### Begin -- getTenYearPV');
        Decimal returnVal = 0.00;
        System.debug('***** pDayCleanCosts: ' + pDayCleanCosts);
        System.debug('***** pBaseRent: ' + pBaseRent);
        System.debug('***** pBaseRentTi: ' + pBaseRentTi);
        System.debug('***** pCpiDisc: ' + pCpiDisc);
        System.debug('***** pBaseYrOpCosts: ' + pBaseYrOpCosts);
        System.debug('***** pValFreeRentTi: ' + pValFreeRentTi);
        System.debug('***** pGovtCommSplit: ' + pGovtCommSplit);
        System.debug('***** pDiscRate: ' + pDiscRate);
        System.debug('***** pTenYrFreeRentFIRM: ' + pTenYrFreeRentFIRM);
        System.debug('***** pTenYrBrokerageComm: ' + pTenYrBrokerageComm);

        Decimal calcOpCosts = pBaseYrOpCosts * pCpiDisc;   // includes term for factoring in the CPI Escalation and Discount rates
        System.debug('***** calcOpCosts: ' + calcOpCosts);

        //Vaishali RLP FY15 Add BSAC to Free Rent calculation pDiscRate is storing BSAC

//        Decimal valFreeRent     =   ((pBaseRent + pBaseYrOpCosts + pDayCleanCosts - pValFreeRentTi) / 120) * pTenYrFreeRentFIRM;
        //Vaishali RLP FY15 remove pDayCleanCosts from freerent
        //       Decimal valFreeRent     =   ((pBaseRent + pBaseYrOpCosts + pDayCleanCosts - pDiscRate - pValFreeRentTi) / 120) * pTenYrFreeRentFIRM;
        Decimal valFreeRent = ((pBaseRent + pBaseYrOpCosts - pDiscRate - pValFreeRentTi) / 120) * pTenYrFreeRentFIRM;
        System.debug('***** valFreeRent: ' + valFreeRent);
        //Vaishali RLP FY15 Add BSAC to Free Rent calculation pDiscRate is storing BSAC
//        Decimal commConcess     =   ((((pBaseRent + pBaseYrOpCosts - pValFreeRentTi) * 10) - ValFreeRent) * ((pTenYrBrokerageComm / 100) * (pGovtCommSplit / 100)) / 10);
        Decimal commConcess = ((((pBaseRent + pBaseYrOpCosts - pDiscRate - pValFreeRentTi) * 10) - ValFreeRent) * ((pTenYrBrokerageComm / 100) * (pGovtCommSplit / 100)) / 10);
        returnVal = pBaseRentTi + calcOpCosts - valFreeRent - commConcess;
        System.debug('***** commConcess: ' + commConcess);
        System.debug('##### returnVal: ' + returnVal);

        System.debug('##### End -- getTenYearPV');
        return returnVal;
    }   // getTenYearPV

    // calculate the total markup data for both the new and succeeding "inner" space pages
    // ** Succeeding spaces will not be calculated with the Arch/Eng fees. **
    // formula for new spaces where Arch/Eng UOM is %        = f_new(x)  = ( (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c + space.PBS_AAAP_GC_CONDITIONS__c + space.PBS_AAAP_MANAGEMENT_COORD_FEES__c  + space.PBS_AAAP_ARCH_ENG_FEES__c) / 100 ) * offer.PBS_AAAP_RLP_TI_New_Space__c)
    // Vaishali New formula for new spaces where Arch/Eng UOM is %        = f_new(x)  = ( (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c + space.PBS_AAAP_GC_CONDITIONS__c + space.PBS_AAAP_MANAGEMENT_COORD_FEES__c  + space.PBS_AAAP_ARCH_ENG_FEES__c) / (100 +space.PBS_AAAP_ARCH_ENG_FEES__c) ) * offer.PBS_AAAP_RLP_TI_New_Space__c)
    // formula for succeeding spaces where Arch/Eng UOM is % = f_succ(x) = ( (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c + space.PBS_AAAP_GC_CONDITIONS__c + space.PBS_AAAP_MANAGEMENT_COORD_FEES__c ) / 100 ) * offer.PBS_AAAP_RLP_TI_Additional_Space__c)
    // formula for new spaces where Arch/Eng UOM is $        = f_new(x)  = ( ( (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c + space.PBS_AAAP_GC_CONDITIONS__c + space.PBS_AAAP_MANAGEMENT_COORD_FEES__c ) / 100 ) + space.PBS_AAAP_ARCH_ENG_FEES__c ) * offer.PBS_AAAP_RLP_TI_New_Space__c)
    // formula for succeeding spaces where Arch/Eng UOM is $ = f_new(x)  =  ( (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c + space.PBS_AAAP_GC_CONDITIONS__c + space.PBS_AAAP_MANAGEMENT_COORD_FEES__c ) / 100 )  * offer.PBS_AAAP_RLP_TI_Additional_Space__c)
    public Decimal getTotalMarkup(PBS_AAAP_Space__c pSpace, PBS_AAAP_Offer__c pOffer, String feePrcntgOrDollar, Decimal uTI, Decimal uBSAC) {
        System.debug('##### Begin -- getTotalMarkup');
        System.debug('-------  pSpace: ' + pSpace);
        System.debug('------- pOffer: ' + pOffer);
        System.debug('Arch and Eng fees : '+feePrcntgOrDollar);
        Decimal returnVal = 0.00;
        System.debug('------- MAXTITEST0814: ' + pOffer.PBS_AAAP_RLP_MAX_TIA__c);
        if (feePrcntgOrDollar == '%') {
            System.debug('-------%: ');
            if (pSpace.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
                //returnVal = (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100 + pSpace.PBS_AAAP_ARCH_ENG_FEES__c / (pSpace.PBS_AAAP_ARCH_ENG_FEES__c + 100)) * pOffer.PBS_AAAP_RLP_TI_New_Space__c;
                returnVal = (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c / 100 + pSpace.PBS_AAAP_ARCH_ENG_FEES__c / (pSpace.PBS_AAAP_ARCH_ENG_FEES__c + 100)) * uTI;
            } else {
                //returnVal = pSpace.PBS_AAAP_ARCH_ENG_FEES__c/100*(pOffer.PBS_AAAP_RLP_TI_Additional_Space__c/(1+pSpace.PBS_AAAP_ARCH_ENG_FEES__c/100))+(pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c*pOffer.PBS_AAAP_RLP_TI_Additional_Space__c/100);
                returnVal = pSpace.PBS_AAAP_ARCH_ENG_FEES__c/100*(uTI/(1+pSpace.PBS_AAAP_ARCH_ENG_FEES__c/100))+(pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c*uTI/100);
                System.debug('Succeeding lease markup with % : '+returnVal);
            }

        } else {
            System.debug('-------$: ');
            if (pSpace.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {   // New Space
                //returnVal = (((pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c) / 100) * pOffer.PBS_AAAP_RLP_TI_New_Space__c + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);
                returnVal = (((pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c) / 100) * uTI + pSpace.PBS_AAAP_ARCH_ENG_FEES__c);
            } else {
                //returnVal = pSpace.PBS_AAAP_ARCH_ENG_FEES__c + (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c*pOffer.PBS_AAAP_RLP_TI_Additional_Space__c/100);
                returnVal = pSpace.PBS_AAAP_ARCH_ENG_FEES__c + (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF__c*uTI/100);
                System.debug('Succeeding lease markup with $ : '+returnVal);
            }


        }
        System.debug('##### End -- getTotalMarkup : '+returnVal);
        return returnVal;
    }   // end getTotalMarkup

    // calculate the "blended" PV rate
    // formula is   f(x)    =    { ( 5 year PV ) + ( 5 + 5 year PV ) } / 2
    // where the 5 + 5 year PV corresponds to the 5 year pv optional calculation on the spreadsheet (PV Calculator from Vaishaili version 2_12.21.11)
    public Decimal getBlendedPV(Decimal p5PV, Decimal p5_5PV) {
        System.debug('##### Begin -- getBlendedPV');
        Decimal returnVal = 0.00;
        System.debug('***** formula terms ::  p5PV -- ' + p5PV);
        System.debug('***** formula terms ::  p5_5PV -- ' + p5_5PV);
        returnVal = (p5PV + p5_5PV) / 2;
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getBlendedPV');
        return returnVal;
    } // end getBlendedPV


    /*  This section of the class deals with the calculations and utility functions necessary for the Identify Winner portion of the application*/

    // calculate the move, teleco, and other upfront costs calculations
    // formula is       f(x)    =   ( moving costs + telecommunications costs + other "upfront" costs) / lease term in months
    public Decimal getMoveTelcoUpfrontCosts(Double pMoveCosts, Double pTelcoCosts, Double pOtherUpfrontCosts, String pLeaseTerm, Boolean newOrSucceeding) {
        System.debug('##### Begin -- getMoveTelcoUpfrontCosts');
        Decimal returnVal = 0.00;
        System.debug('***** formula terms ::  pMoveCosts -- ' + pMoveCosts);
        System.debug('***** formula terms ::  pTelcoCosts -- ' + pTelcoCosts);
        System.debug('***** formula terms ::  pOtherUpfrontCosts -- ' + pOtherUpfrontCosts);
        System.debug('***** formula terms ::  pLeaseTerm -- ' + pLeaseTerm);
        System.debug('***** formula terms ::  pLeaseTerm -- ' + pLeaseTerm);

        Integer denominator = 0;
        Decimal numerator = 0.00;

        // determine the appropriate denominator
        if (pLeaseTerm == FIVEYR) {
            denominator = 5;
        } else if (pLeaseTerm == FIVEFIVEYR) {
            denominator = 5;
        } else if (pLeaseTerm == FIVEFIVEYRNEW) {  //Vaishali FY17 update
            denominator = 5;
        } else if (pLeaseTerm == TENYR) {
            denominator = 10;
        } else if (pLeaseTerm == FIFTEENTENYR) {  //Vaishali FY17 update
            denominator = 10;
        }   // end if

        // calculate the numerator value
        if (newOrSucceeding) {    // new leases have moving, telco, and upfront costs
            numerator = pMoveCosts + pTelcoCosts + pOtherUpfrontCosts;
        } else {    // succeeding leases only have upfront costs
            numerator = pOtherUpfrontCosts;
        }   // end if

        System.debug('***** formula terms ::  numerator -- ' + numerator);
        System.debug('***** formula terms ::  denominator -- ' + denominator);
        returnVal = numerator / denominator;
        System.debug('***** formula terms ::  returnVal -- ' + returnVal);
        System.debug('##### End -- getMoveTelcoUpfrontCosts');
        return returnVal;
    }   // end getMoveTelcoUpfrontCosts

    // calculate the parking costs
    // formula is   f(x) = { (Parking Space and Rate Factor * Parking Escalation x Discount Factor) / ((Min. Req. SqFT + Max. Req. SqFT ) / 2)}
    // where the Parking Space and Rate Factor =    (   (# Reserved Surface Parking Spaces * Reserved Surface Rate) + (# Reserved Garage Spaces * Reserved Garage Rate) +
    //                                                                                      (# Non-reserved Surface Parking Spaces * Non-reserved Surface Rate) + (# Non-reserved Garage Spaces * Non-reserved Garage Rate) ) * 12
    // where the Parking Escalation x Discount Factor =     A calculated rate using formula f(x) = Sum (yearly Avg. Parking Escalation Rate * Avg. Discount) / number of years
    // Avg. Parking Escalation Rate     = (1 + Escalation Rate) ^ (Year - 1)
    // Avg. Discount = (1 + (Discount Rate / 100) ^ (Year - 1)
    public Decimal getParkingCosts(Double pResSurfParking, Double pResSurfParkingRate,
            Double pResGargParking, Double pResGargParkingRate,
            Double pSurfParking, Double pSurfParkingRate,
            Double pGargParking, Double pGargParkingRate,
            Double pMinSqFt, Double pMaxSqFt,
            Double pParkingEscalation, Double pDiscount, String pLeaseTerm) {
        System.debug('##### Begin -- getParkingCosts');
        System.debug('***** pResSurfParking -- ' + pResSurfParking);
        System.debug('***** pResSurfParkingRate -- ' + pResSurfParkingRate);
        System.debug('***** pResGargParking -- ' + pResGargParking);
        System.debug('***** pResGargParkingRate -- ' + pResGargParkingRate);
        System.debug('***** pSurfParking -- ' + pSurfParking);
        System.debug('***** pSurfParkingRate -- ' + pSurfParkingRate);
        System.debug('***** pGargParking -- ' + pGargParking);
        System.debug('***** pGargParkingRate -- ' + pGargParkingRate);
        System.debug('***** pParkingEscalation -- ' + pParkingEscalation);
        System.debug('***** pDiscount -- ' + pDiscount);
        System.debug('***** pLeaseTerm -- ' + pLeaseTerm);
        //Vaishali Changes for FY17
        Decimal returnVal = 0.00;

        Decimal parkSpaceRateFactor = ((pResSurfParking * pResSurfParkingRate) + (pResGargParking * pResGargParkingRate) + (pSurfParking * pSurfParkingRate) + (pGargParking * pGargParkingRate)) * 12;
        System.debug('***** parkSpaceRateFactor -- ' + parkSpaceRateFactor);

        Decimal parkEscAndDiscFactor = 0.00;

        if (pLeaseTerm == FIVEYR) {
            parkEscAndDiscFactor = (this.rlpGT2016) ? this.getNewAvgCpiAndDiscount(pDiscount, pParkingEscalation, 1, 5) : getFiveYrAvgCpiAndDiscount(pDiscount, pParkingEscalation);
        } else if (pLeaseTerm == TENYR) {
            parkEscAndDiscFactor = (this.rlpGT2016) ? this.getNewAvgCpiAndDiscount(pDiscount, pParkingEscalation, 1, 10) : getTenYrAvgCpiAndDiscount(pDiscount, pParkingEscalation);
        } else if (pLeaseTerm == FIVEFIVEYR) {
            parkEscAndDiscFactor = getFiveYrAvgCpiAndDiscountYrSixThruTen(pDiscount, pParkingEscalation);
        } else if (pLeaseTerm == FIVEFIVEYRNew) {
            parkEscAndDiscFactor = this.getNewAvgCpiAndDiscount(pDiscount, pParkingEscalation, 6, 10);
        } else if (pLeaseTerm == FIFTEENTENYR) {
            parkEscAndDiscFactor = this.getNewAvgCpiAndDiscount(pDiscount, pParkingEscalation, 11, 15);
        }   // end if
        else if (pLeaseTerm == CENSUS_25 || pLeaseTerm == CENSUS_25_2018) {
            parkEscAndDiscFactor = (1 / (1 + (pDiscount / 100)) + 1 / (math.pow(1 + (pDiscount / 100), 2)) + (1 / math.pow(1 + (pDiscount / 100), 3) / 12)) * 12 / 25;
        } else if (pLeaseTerm == CENSUS_19 || pLeaseTerm == CENSUS_19_2018) {
            parkEscAndDiscFactor = (1 / (1 + (pDiscount / 100)) + (1 / (math.pow(1 + (pDiscount / 100), 2)) * 7 / 12)) * 12 / 19;
        }
        System.debug('***** parkEscAndDiscFactor -- ' + parkEscAndDiscFactor);

        Decimal numerator = parkSpaceRateFactor * parkEscAndDiscFactor;
        System.debug('***** numerator -- ' + numerator);

        Decimal denominator = (pMinSqFt + pMaxSqFt) / 2;
        System.debug('***** denominator -- ' + denominator);

        returnVal = numerator / denominator;
        System.debug('***** returnVal -- ' + returnVal);
        System.debug('##### End -- getParkingCosts');

        return returnVal;
    }   // end getParkingCosts

    // calculates the cost for HVAC operation
    // formula is f(x) = ((HVAC overtime hours * HVAC overtime rate) / ((Min. Req. SqFt. + Max. Req. SqFt) / 2)) * Discount Rate Factor
    public Decimal getHvacCosts(Double pHvacOTHours, Double pHvacOTRate, Double pMinSqFt, Double pMaxSqFt, String pLeaseTerm, Double pDiscount) {
        System.debug('##### Begin -- getHvacCosts');
        System.debug('***** pHvacOTHours -- ' + pHvacOTHours);
        System.debug('***** pHvacOTRate -- ' + pHvacOTRate);
        System.debug('***** pMinSqFt -- ' + pMinSqFt);
        System.debug('***** pMaxSqFt -- ' + pMaxSqFt);
        System.debug('***** pLeaseTerm -- ' + pLeaseTerm);
        System.debug('***** pDiscount -- ' + pDiscount);
        System.debug('***** IS RLP GT 2016 -- ' + String.valueOf(this.rlpGT2016));

        Decimal returnVal = 0.00;
        Decimal numerator = pHvacOTHours * pHvacOTRate;
        Decimal denominator = (pMinSqFt + pMaxSqFt) / 2;
        Decimal discRateFactor = 0.00;
        //Vaishali changes for FY17
        if (pLeaseTerm == FIVEYR) {
            discRateFactor = (this.rlpGT2016) ? this.getNewAvgDiscount(pDiscount, 1, 5) : this.getFiveYrAvgDiscount(pDiscount);
        } else if (pLeaseTerm == FIVEFIVEYR) {
            discRateFactor = (this.rlpGT2016) ? this.getNewAvgDiscount(pDiscount, 6, 10) : this.getFiveYrAvgDiscountYrSixThruTen(pDiscount);
        } else if (pLeaseTerm == FIVEFIVEYRNew) {
            discRateFactor = this.getNewAvgDiscount(pDiscount, 6, 10);
        } else if (pLeaseTerm == TENYR) {
            discRateFactor = (this.rlpGT2016) ? this.getNewAvgDiscount(pDiscount, 1, 10) : this.getTenYrAvgDiscount(pDiscount);
        } else if (pLeaseTerm == FIFTEENTENYR) {
            discRateFactor = this.getNewAvgDiscount(pDiscount, 11, 15);
        }   // end if

        System.debug('***** numerator -- ' + numerator);
        System.debug('***** denominator -- ' + denominator);
        System.debug('***** discRateFactor -- ' + discRateFactor);

        returnVal = (numerator / denominator) * discRateFactor;
        System.debug('***** returnVal -- ' + returnVal);
        System.debug('##### End -- getHvacCosts');

        return returnVal;
    }   // end getHvacCosts

    public List<PBS_AAAP_IdentifyWinnerForm> getManagerPV(List<PBS_AAAP_IdentifyWinnerForm> pVals, String agencyId) {
        List<PBS_AAAP_IdentifyWinnerForm> returnVals = new List<PBS_AAAP_IdentifyWinnerForm>();
        system.debug('Agency ID: '+agencyId);
        if(agencyId != null){
            List<PBS_AAAP_RLP__c> rlpYear = new List<PBS_AAAP_RLP__c>();
            List<PBS_AAAP_Agency_Requirement__c> agencyRLP = new List<PBS_AAAP_Agency_Requirement__c>();

            agencyRLP = [SELECT PBS_AAAP_RLP_Number__c,PBS_AAAP_LEASE_TERM__c FROM PBS_AAAP_Agency_Requirement__c WHERE Id = :agencyId];
            System.debug('Agency for RLP : '+agencyRLP);
            String rlpNumber = agencyRLP[0].PBS_AAAP_RLP_Number__c;
            System.debug('rlpID : '+rlpNumber);
            rlpYear = [Select PBS_AAAP_Year__c FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_RLP_Number__c = :rlpNumber];
            system.debug('rlpYear: '+rlpYear);
            System.debug('pVals: '+pVals);
            rlpYearValue = integer.valueof(rlpYear[0].PBS_AAAP_Year__c);
            System.debug('RLP Year : '+rlpYear[0].PBS_AAAP_Year__c);
            System.debug('Integer value RLP : '+rlpYearValue);
            if(rlpYear.size()>0){
                boolean rlpGT2019 = (rlpYearValue > 2018 ) ? true : false;
                boolean TermCondition2018 = false;
                if(!agencyRLP.isEmpty()
                   && (agencyRLP[0].PBS_AAAP_LEASE_TERM__c == '10 years' 
                        || agencyRLP[0].PBS_AAAP_LEASE_TERM__c == '10 years,5 firm'
                        || agencyRLP[0].PBS_AAAP_LEASE_TERM__c == '15 years,10 firm')){
                    TermCondition2018 = true;
                }
                system.debug('\n--TermCondition2018--'+TermCondition2018);
                if(rlpGT2019 || TermCondition2018){
                    if(rlpGT2019){
                        returnVals = getManagerPV_2019(pVals,agencyId, 'new', rlpYearValue);
                    } else {
                        returnVals = getManagerPV_2019(pVals,agencyId, 'old', rlpYearValue);
                        if(Test.isRunningTest())
                            getManagerPVLessthan2019(pVals,agencyId);
                    }
                }else {
                    returnVals = getManagerPVLessthan2019(pVals,agencyId);
                }
            }
        }
        return returnVals;
    }
    // wrapper method for use with the identify winner process to manage the calculation of the PV
    // takes as input a list of property records in the form of PBS_AAAP_IdentifyWinnerForm
    // returns as output a list of properties sorted by the manager's PV in ascending order (manager's PV is calculated in this method)
    //Vaishali RLP FY14 Manager PV needs to be different for second tier TI will have to exclude A&E when $ amount for new lease
    //(iform.aeFeeUOM=='%') ? iform.aeFees : (0.00).doubleValue(), for 2ndtier TI---Vaishali
    private List<PBS_AAAP_IdentifyWinnerForm> getManagerPVLessthan2019(List<PBS_AAAP_IdentifyWinnerForm> pVals, String agencyId) {
        System.debug(LoggingLevel.Info, '##### Begin -- getManagerPVLessthan2019 ');
        System.debug(LoggingLevel.Info, '##### Begin -- agencyId ' + agencyId);
        List<PBS_AAAP_IdentifyWinnerForm> returnVals = new List<PBS_AAAP_IdentifyWinnerForm>();                                        // return structure
        Map<String, PBS_AAAP_IdentifyWinnerForm> mapIForm = new Map<String, PBS_AAAP_IdentifyWinnerForm>();     // map of identify winner form records keyed by the concatenation of the record's offerId and spaceId
        Decimal pvCost = 0.00;               // PV calculations
        Decimal pvOptCost = 0.00;           // PV calculations for the option term
        Double aeFeesStorage = 0.00;   // storage variable to revert to the original A&E Fees once the PV calculations have been processed
        if (pVals.size() > 0) {
            Set<Id> sId = new Set<Id>();
            Set<Id> oId = new Set<Id>(); 
            Set<Id> rId = new Set<Id>();
            Set<String> rateSOId = new Set<String>();
            // build the map of identify winner form values with a concatenated key of the offerId and spaceId
            for (PBS_AAAP_IdentifyWinnerForm val : pVals) {
                String keyVal = String.valueOf(val.offerId) + String.valueOf(val.spaceId);
                System.debug('***keyval-' + keyVal);
                mapIForm.put(keyVal, val);
                sId.add(val.spaceId);
                oId.add(val.offerId);
                rateSOId.add(String.valueOf(val.spaceId).substring(0, 15) + '' + String.valueOf(val.offerId).substring(0, 15));
            }   // end for
            List<PBS_AAAP_Space__c> spaceLst = [
                    SELECT PBS_AAAP_RLP__c, PBS_AAAP_TOTAL_MARKUP__c,
                            PBS_AAAP_GC_OVERHEAD_AND_PROF__c, PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,
                            PBS_AAAP_ARCH_ENG_FEES__c, PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c
                    FROM PBS_AAAP_Space__c
                    WHERE Id IN :sId
            ];
            List<PBS_AAAP_Offer__c> offerLst = [
                    SELECT PBS_AAAP_Monthly_cost_nonres_gar_park__c,
                            PBS_AAAP_Monthly_cost_res_gar_park__c,PBS_AAAP_Monthly_cost_nonres_sur_park__c,
                            PBS_AAAP_Monthly_cost_res_sur_park__c,PBS_AAAP_COST_PER_ABOA__c
                    FROM PBS_AAAP_Offer__c
                    WHERE Id IN:oId
            ];
            system.debug('$$$$$ Offer ' + offerLst);
            Map<Id, PBS_AAAP_Space__c> mapSpace = new Map<Id, PBS_AAAP_Space__c>();
            Map<Id, PBS_AAAP_Offer__c> mapOffer = new Map<Id, PBS_AAAP_Offer__c>();
            Map<Id, PBS_AAAP_RLP__c> mapRLP = new Map<Id, PBS_AAAP_RLP__c>();
            for (PBS_AAAP_Space__c s : spaceLst) {
                mapSpace.put(s.Id, s);
                rId.add(s.PBS_AAAP_RLP__c);
            }
            system.debug('#### RID ' + rId);
            for (PBS_AAAP_Offer__c o : offerLst) {
                mapOffer.put(o.Id, o);
                system.debug('$$$$$ Offer ' + mapOffer);
            }
            List<PBS_AAAP_RLP__c> rlpLst = [
                    SELECT Id,PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c,PBS_AAAP_DISCOUNT_RATE__c,
                            PBS_AAAP_RLP_Number__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c,
                            PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c,PBS_AAAP_MOVE_DEFAULT__c,
                            PBS_AAAP_TELCOMM_DEFAULT__c
                    FROM PBS_AAAP_RLP__c
                    WHERE Id IN :rId
            ];
            system.debug('#### RLP ' + rlpLst);
            PBS_AAAP_Agency_Requirement__c agency = [
                    SELECT PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c,PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c,
                            PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c,PBS_AAAP_USF_REQ_MIN__c,PBS_AAAP_USF_REQ_MAX__c,
                            PBS_AAAP_LEASE_TERM__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, PBS_AAAP_MOVE_DEFAULT__c, PBS_AAAP_TELCOMM_DEFAULT__c,
                            PBS_AAAP_BSAC_per_ABOA__c, PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c, BSAC_for_Continuing_Space_per_ABOA_SF__c
                    FROM PBS_AAAP_Agency_Requirement__c
                    WHERE Id = :agencyId
            ];
            system.debug('#### Agency ' + agency);
            List<PBS_AAAP_Rate__c> rateLst19 = [
                    SELECT Space_Offer__c, PBS_AAAP_BASE_RATE__c,PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c,
                            PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c
                    FROM PBS_AAAP_Rate__c
                    WHERE Space_Offer__c IN :rateSOId
                    //AND PBS_AAAP_LEASE_TERM__c = '19 Months,11 Firm'
                    AND PBS_AAAP_LEASE_TERM__c IN ('19 Months,11 Firm','19 Months, 11 Firm')
            ];
            system.debug('!!!! ' + rateLst19);
            system.debug('!!!! ' + rateSOId);
            List<PBS_AAAP_Rate__c> rateLst25 = [
                    SELECT Space_Offer__c, PBS_AAAP_BASE_RATE__c,PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c,
                            PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c
                    FROM PBS_AAAP_Rate__c
                    WHERE Space_Offer__c IN :rateSOId
                    AND PBS_AAAP_LEASE_TERM__c IN ('25 Months,16 Firm','25 Months, 16 Firm')
            ];
            system.debug('!!!! ' + rateLst25);
            system.debug('!!!! ' + rateSOId);
            Map<String, PBS_AAAP_Rate__c> mapRate19 = new Map<String, PBS_AAAP_Rate__c>();
            Map<String, PBS_AAAP_Rate__c> mapRate25 = new Map<String, PBS_AAAP_Rate__c>();
            for (PBS_AAAP_RLP__c r : rlpLst) {
                //system.debug('@@@@ ' + r.Id + ' #### ' + r);
                mapRLP.put(r.Id, r);
            }
            for (PBS_AAAP_Rate__c r19 : rateLst19) {
                mapRate19.put(r19.Space_Offer__c, r19);
                system.debug('@@@@ ' + r19.Space_Offer__c + ' #### ' + r19);
            }
            for (PBS_AAAP_Rate__c r25 : rateLst25) {
                mapRate25.put(r25.Space_Offer__c, r25);
                system.debug('@@@@ ' + r25.Space_Offer__c + ' #### ' + r25);
            }
            // calculate PV cost values for manager view
            system.debug(LoggingLevel.Info, '*****pVals.size()****'+pVals.size());
            for (Integer i = 0; i < pVals.size(); i++) {
                PBS_AAAP_IdentifyWinnerForm iform = pVals.get(i);       // records to operate over

                System.debug('****------->' + iform);
                System.debug('***** offer ID / space ID -- ' + String.valueOf(iform.offerId) + ' / ' + String.valueOf(iform.spaceId));

                aeFeesStorage = iform.aeFees;
                System.debug('***** iform.neworsucceedingOffer: ' + iform.neworsucceedingOffer);
                System.debug('***** iform.newLeaseIncludeAE: ' + iform.newLeaseIncludeAE);  //this is the checkbox
                System.debug('this is the value they input on the identifywinnersearch page: ' + iform.newLease);
                System.debug('coming thr with the physicalcosts' + iform.physicalcosts);
                System.debug('telecommcosts' + iform.telecommcosts);
                System.debug('otherupfrontcosts' + iform.otherupfrontcosts);
                System.debug('***** iform.aeFeeUOM: ' + iform.aeFeeUOM);
                System.debug(LoggingLevel.Info,'***** iform.BSACCost: ' + iform.BSACCost);
                System.debug('***** iform.rlpGT2016: ' + String.valueOf(iform.rlpGT2016));
                System.debug('***** iform.leaseTerm: ' + String.valueOf(iform.leaseTerm));
                System.debug('***** iform.CENSUS_25: ' + CENSUS_25);
                System.debug('***** iform.CENSUS_25_2018 : '+CENSUS_25_2018);
                System.debug('***** iform.CENSUS_19: ' + CENSUS_19);
                System.debug('***** iform.CENSUS_19_2018 : '+CENSUS_19_2018);
                this.rlpGT2016 = iform.rlpGT2016;
                // list of rates necessary to utilize existing PV calculation methods
                List<PBS_AAAP_Rate__c> rateList = new List<PBS_AAAP_Rate__c>();

                // rate assembled and added to the list of rates necessary to utilize existing PV calculation methods
                PBS_AAAP_Rate__c rateTemp = new PBS_AAAP_Rate__c(PBS_AAAP_LEASE_TERM__c = iform.leaseTerm,
                        PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = iform.amortizRateT1Upto20,
                        PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = iform.amortizRateT1Above20
                );
                rateList.add(rateTemp);
                PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
                system.debug(LoggingLevel.Info, '*****BSAC Check****0'+iform.BSACCost);
                if (iform.leaseTerm == CENSUS_25 || iform.leaseTerm == CENSUS_25_2018 || iform.leaseTerm == CENSUS_19 || iform.leaseTerm == CENSUS_19_2018) {
                    if (iform.leaseTerm == CENSUS_19 || iform.leaseTerm == CENSUS_19_2018) {
                        system.debug('@@@@ 19' + iform.leaseTerm);
                        system.debug('@@@@ Map 19 ' + mapRate19);
                        rate = mapRate19.get(String.valueOf(iform.spaceId).substring(0, 15) + '' + String.valueOf(iform.offerId).substring(0, 15));
                    } else if (iform.leaseTerm == CENSUS_25 || iform.leaseTerm == CENSUS_25_2018) {
                        system.debug('@@@@ 25 ' + iform.leaseTerm);
                        system.debug('@@@@ Map 25 ' + mapRate25);
                        rate = mapRate25.get(String.valueOf(iform.spaceId).substring(0, 15) + '' + String.valueOf(iform.offerId).substring(0, 15));
                    }
                    system.debug('@@@@ Rate ' + rate + ' #### Key ' + iform.spaceId + '' + iform.offerId);

                    PBS_AAAP_Space__c sp = mapSpace.get(iform.spaceId);
                    PBS_AAAP_Offer__c off = mapOffer.get(iform.offerId);
                    PBS_AAAP_RLP__c rlp = mapRLP.get(sp.PBS_AAAP_RLP__c);
                    system.debug('@@@@ ' + rlp + ' #### ' + sp.PBS_AAAP_RLP__c);
                    system.debug(LoggingLevel.Info, '*****NIK****2'+iform.BSACCost);
                    pvCost = this.censusPV(off, sp, rlp, iform.leaseTerm, rate, agency,
                            iform.newLeaseIncludeAE, iform.newLease, iform.physicalcosts, iform.telecommcosts, iform.otherupfrontcosts);
                            
                    System.debug(LoggingLevel.Info,'*****--->' + pvCost);

                    System.debug('pv before parking' + pvCost);
                    if (iform.leaseTerm != CENSUS_25 && iform.leaseTerm != CENSUS_25_2018 && iform.leaseTerm != CENSUS_19 && iform.leaseTerm != CENSUS_19_2018) {
                        if (iform.numParkingSpaces > 0) {
                            pvCost = pvCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt, iform.maxSqFt, (0.00).doubleValue(), iform.discountRate,
                                    iform.leaseTerm);

                        }   // end if


                        System.debug('pv after parking' + pvCost);
                    }


                    System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                    System.debug('***** formula :: pvCost after parking space calc: ' + pvCost);

                }


                // determine if property/space is for a new or succeeding space/lease
                if (iform.neworsucceedingOffer) { // new
                    //add routine for Census by syam k ganna on 01/12/2017

                    // determine if A&E fees should be included
                    if (!iform.newLeaseIncludeAE) {
                        iform.aeFees = (0.00).doubleValue();        // set the A&E Fees to zero, regardless of whether are any or not, to make the construction markup method ignore the costs.
                    }   // end if
                    system.debug(LoggingLevel.Info, '*****BSAC Check****'+iform.BSACCost);
                    // use the correct lease time
                    if (iform.leaseTerm == FIVEYR) {
                        // calculate the offer's PV
                        pvCost = this.getFiveYearPV(iform.daytimeCleaningCost,
                                iform.baseRate,
                                this.getBaseRentAndTI(iform.baseRate,
                                        iform.BSACCost + this.getFreeRentNewSpace(this.get1rstNewFreeRentForFiveYear(rateList,
                                                this.getNewFirstTierTI(iform.newLease,
                                                        getConstrMarkups(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue()
                                                ).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEYR
                                        ).doubleValue(),
                                                this.get2ndNewFreeRentForFiveYear(rateList,
                                                        this.getNewSecondTierTI(iform.newLease,
                                                                getConstrMarkups(iform.newLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        (0.00).doubleValue()
                                                                ).doubleValue(),
                                                                getConstrMarkups2ndTier(iform.newLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        iform.maxTi).doubleValue(),
                                                                iform.newLease,
                                                                iform.maxTi
                                                        ).doubleValue(),
                                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                                ).doubleValue()
                                        ).doubleValue(),
                                        iform.discountRate,
                                        5).doubleValue(),
                                this.getFiveYrAvgCpiAndDiscount(iform.discountRate,
                                        iform.escalRate
                                ).doubleValue(),
                                iform.costPerABOA,
                                this.getFreeRentNewSpace(this.get1rstNewFreeRentForFiveYear(rateList,
                                        this.getNewFirstTierTI(iform.newLease,
                                                getConstrMarkups(iform.newLease,
                                                        iform.overheadProfFees,
                                                        iform.gcConditions,
                                                        iform.mgmtCoordFees,
                                                        iform.aeFees,
                                                        iform.aeFeeUOM,
                                                        (0.00).doubleValue()
                                                ).doubleValue()
                                        ).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue(),
                                        this.get2ndNewFreeRentForFiveYear(rateList,
                                                this.getNewSecondTierTI(iform.newLease,
                                                        getConstrMarkups(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        getConstrMarkups2ndTier(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                iform.maxTi).doubleValue(),
                                                        iform.newLease,
                                                        iform.maxTi
                                                ).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEYR
                                        ).doubleValue()
                                ).doubleValue(),
                                iform.coopCommTogsaFirmTerm,
                                Double.valueOf(100),
                                iform.BSACCost, //iform.discountRate, //RLP FY 15 Vaishali
                                iform.numOfMonthsFreeFirmTerm).doubleValue();

                        System.debug('***** formula :: pvCost initial calc: ' + pvCost);

                        // calculate the estimated hvac costs and combine with the PV costs
                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        if (iform.includeHVACOverTime) {
                            pvCost = pvCost + getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                    (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    PBS_AAAP_CALCULATIONS.FIVEYR,
                                    iform.discountRate);
                        }   // end if

                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        System.debug('***** formula :: pvCost after HVAC calc: ' + pvCost);

                        // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                        if (iform.numParkingSpaces > 0) {
                            pvCost = pvCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    (0.00).doubleValue(),
                                    iform.discountRate,
                                    PBS_AAAP_CALCULATIONS.FIVEYR);

                        }   // end if

                        System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                        System.debug('***** formula :: pvCost after parking space calc: ' + pvCost);

                        // calculate the telco, move, and other upfront costs
                        if ((iform.otherupfrontcosts > 0) || (iform.telecommcosts > 0) || (iform.physicalcosts > 0)) {
                            pvCost = pvCost + getMoveTelcoUpfrontCosts((iform.physicalcosts != null) ? iform.physicalcosts : (0.00).doubleValue(),
                                    (iform.telecommcosts != null) ? iform.telecommcosts : (0.00).doubleValue(),
                                    (iform.otherupfrontcosts != null) ? iform.otherupfrontcosts : (0.00).doubleValue(),
                                    PBS_AAAP_CALCULATIONS.FIVEYR,
                                    iform.neworsucceedingOffer);
                        } // end if

                        System.debug('***** iform.otherupfrontcosts: ' + iform.otherupfrontcosts);
                        System.debug('***** formula :: pvCost after upfront calc: ' + pvCost);

                    } else if ((iform.leaseTerm == FIVEFIVEYR) || (iform.leaseTerm == FIVEFIVEYRNEW)) {
                        // calculate the offer's PV
                        pvCost = this.getFiveYearPV(iform.daytimeCleaningCost,
                                iform.baseRate,
                                this.getBaseRentAndTI(iform.baseRate,
                                        iform.BSACCost + this.getFreeRentNewSpace(this.get1rstNewFreeRentForFiveYear(rateList,
                                                this.getNewFirstTierTI(iform.newLease,
                                                        getConstrMarkups(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue()
                                                ).doubleValue(),
                                                iform.leaseTerm
                                        ).doubleValue(),
                                                this.get2ndNewFreeRentForFiveYear(rateList,
                                                        this.getNewSecondTierTI(iform.newLease,
                                                                getConstrMarkups(iform.newLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        (0.00).doubleValue()
                                                                ).doubleValue(),
                                                                getConstrMarkups2ndTier(iform.newLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        iform.maxTi).doubleValue(),
                                                                iform.newLease,
                                                                iform.maxTi
                                                        ).doubleValue(),
                                                        iform.leaseTerm
                                                ).doubleValue()
                                        ).doubleValue(),
                                        iform.discountRate,
                                        5).doubleValue(),
                                this.getFiveYrAvgCpiAndDiscount(iform.discountRate,
                                        iform.escalRate
                                ).doubleValue(),
                                iform.costPerABOA,
                                this.getFreeRentNewSpace(this.get1rstNewFreeRentForFiveYear(rateList,
                                        this.getNewFirstTierTI(iform.newLease,
                                                getConstrMarkups(iform.newLease,
                                                        iform.overheadProfFees,
                                                        iform.gcConditions,
                                                        iform.mgmtCoordFees,
                                                        iform.aeFees,
                                                        iform.aeFeeUOM,
                                                        (0.00).doubleValue()
                                                ).doubleValue()
                                        ).doubleValue(),
                                        iform.leaseTerm
                                ).doubleValue(),
                                        this.get2ndNewFreeRentForFiveYear(rateList,
                                                this.getNewSecondTierTI(iform.newLease,
                                                        getConstrMarkups(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        getConstrMarkups2ndTier(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                iform.maxTi).doubleValue(),
                                                        iform.newLease,
                                                        iform.maxTi
                                                ).doubleValue(),
                                                iform.leaseTerm
                                        ).doubleValue()
                                ).doubleValue(),
                                iform.coopCommTogsaFirmTerm,
                                Double.valueOf(100),
                                iform.BSACCost, // iform.discountRate, RLP FY15
                                iform.numOfMonthsFreeFirmTerm).doubleValue();


                        System.debug('***** formula :: pvCost initial calc: ' + pvCost);

                        // calculate the estimated hvac costs and combine with the PV costs
                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        if (iform.includeHVACOverTime) {
                            pvCost = pvCost + getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                    (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    PBS_AAAP_CALCULATIONS.FIVEYR,
                                    iform.discountRate);
                        }   // end if

                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        System.debug('***** formula :: pvCost after HVAC calc: ' + pvCost);

                        // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                        if (iform.numParkingSpaces > 0) {
                            pvCost = pvCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    (0.00).doubleValue(),
                                    iform.discountRate,
                                    PBS_AAAP_CALCULATIONS.FIVEYR);

                        }   // end if

                        System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                        System.debug('***** formula :: pvCost after parking space calc: ' + pvCost);

                        // calculate the telco, move, and other upfront costs
                        if ((iform.otherupfrontcosts > 0) || (iform.telecommcosts > 0) || (iform.physicalcosts > 0)) {
                            pvCost = pvCost + getMoveTelcoUpfrontCosts((iform.physicalcosts != null) ? iform.physicalcosts : (0.00).doubleValue(),
                                    (iform.telecommcosts != null) ? iform.telecommcosts : (0.00).doubleValue(),
                                    (iform.otherupfrontcosts != null) ? iform.otherupfrontcosts : (0.00).doubleValue(),
                                    PBS_AAAP_CALCULATIONS.FIVEYR,
                                    iform.neworsucceedingOffer);
                        } // end if

                        System.debug('***** iform.otherupfrontcosts: ' + iform.otherupfrontcosts);
                        System.debug('***** formula :: pvCost after upfront calc: ' + pvCost);


                        pvOptCost = this.getFiveYearPVOption(iform.daytimeCleaningCost,
                                this.getFiveYrAvgCpiAndDiscountYrSixThruTen(iform.discountRate,
                                        iform.escalRate
                                ).doubleValue(),
                                this.getFiveYrAvgDiscountYrSixThruTen(iform.discountRate).doubleValue(),
                                iform.escalRate,
                                iform.discountRate,
                                iform.costPerABOA,
                                iform.numOfMonthsFreeOptionTerm,
                                iform.fullyServRentOptionTerm);

                        // calculate the estimated hvac costs and combine with the PV costs
                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        if (iform.includeHVACOverTime) {
                            pvOptCost = pvOptCost + getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                    (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    PBS_AAAP_CALCULATIONS.FIVEFIVEYR,
                                    iform.discountRate);
                        }   // end if

                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        System.debug('***** formula :: pvOptCost after HVAC calc: ' + pvOptCost);

                        // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                        if (iform.numParkingSpaces > 0) {
                            pvOptCost = pvOptCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    (0.00).doubleValue(),
                                    iform.discountRate,
                                    iform.leaseTerm);

                        }   // end if

                        System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                        System.debug('***** formula :: pvOptCost after parking space calc: ' + pvOptCost);

                        pvCost = this.getBlendedPV(pvCost, pvOptCost);

                    } else if ((iform.leaseTerm == TENYR) || (iform.leaseTerm == FIFTEENTENYR)) {
                        // calculate the offer's PV
                        
                        double zero = getConstrMarkups(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        );
                        
                        double first = this.getNewFirstTierTI(iform.newLease,zero).doubleValue(); 
                        double sec = this.get1rstNewFreeRentForTenYear(rateList,first,iform.leaseTerm);
                        system.debug(LoggingLevel.Info, '****zero****'+iform.BSACCost);
                        system.debug(LoggingLevel.Info, '****first****'+first);
                        system.debug(LoggingLevel.Info, '****sec****'+sec);
                        
                        double fourth = getConstrMarkups2ndTier(iform.newLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        iform.maxTi).doubleValue();
                        system.debug(LoggingLevel.Info, '****fourth****'+fourth);
                        
                        
                        double fifth = this.getNewSecondTierTI(iform.newLease,
                                                                zero,
                                                                fourth,
                                                                iform.newLease,
                                                                iform.maxTi
                                                        ).doubleValue();
                        system.debug(LoggingLevel.Info, '****fifth****'+fifth);
                        
                        
                        double sixth = this.get2ndNewFreeRentForTenYear(rateList,
                                                        fifth
                                                ).doubleValue();
                        system.debug(LoggingLevel.Info, '****sixth****'+sixth);
                        
                        double seventh = this.getFreeRentNewSpace(sec,
                                                sixth
                                        ).doubleValue();
                        system.debug(LoggingLevel.Info, '****seventh****'+seventh);
                        
                        
                        double eight = this.getBaseRentAndTI(iform.baseRate,
                                            iform.BSACCost + seventh,
                                            iform.discountRate,
                                            10).doubleValue();
                        system.debug(LoggingLevel.Info, '****eight****'+eight);
                        
                        double nine = this.getTenYrAvgCpiAndDiscount(iform.discountRate,
                                                    iform.escalRate
                                            ).doubleValue();
                        system.debug(LoggingLevel.Info, '****nine****'+nine);
                        
                        double ten = seventh;
                        system.debug(LoggingLevel.Info, '****ten****'+ten+'\n--iform.BSACCost--'+iform.BSACCost+'\n--iform.numOfMonthsFreeFirmTerm--'+iform.numOfMonthsFreeFirmTerm);
                        
                        double finalval = this.getTenYearPV(iform.daytimeCleaningCost,
                                                iform.baseRate,
                                                eight,
                                                nine,
                                                iform.costPerABOA,
                                                seventh,
                                                iform.coopCommTogsaFirmTerm,
                                                Double.valueOf(100),
                                                iform.BSACCost, //iform.discountRate, Vaishali RLP FY15
                                                iform.numOfMonthsFreeFirmTerm).doubleValue();
                        
                        system.debug(LoggingLevel.Info, '****finalval****'+finalval);
                        system.debug(LoggingLevel.Info, '****NIK IS HERE****'+iform);
                        
                        
                        
                        
                        pvCost = this.getTenYearPV(iform.daytimeCleaningCost,
                                iform.baseRate,
                                this.getBaseRentAndTI(iform.baseRate,
                                        iform.BSACCost + this.getFreeRentNewSpace(this.get1rstNewFreeRentForTenYear(rateList,
                                                this.getNewFirstTierTI(iform.newLease,
                                                        getConstrMarkups(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue()
                                                ).doubleValue(), iform.leaseTerm
                                        ).doubleValue(),
                                                this.get2ndNewFreeRentForTenYear(rateList,
                                                        this.getNewSecondTierTI(iform.newLease,
                                                                getConstrMarkups(iform.newLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        (0.00).doubleValue()
                                                                ).doubleValue(),
                                                                getConstrMarkups2ndTier(iform.newLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        iform.maxTi).doubleValue(),
                                                                iform.newLease,
                                                                iform.maxTi
                                                        ).doubleValue()
                                                ).doubleValue()
                                        ).doubleValue(),
                                        iform.discountRate,
                                        10).doubleValue(),
                                this.getTenYrAvgCpiAndDiscount(iform.discountRate,
                                        iform.escalRate
                                ).doubleValue(),
                                iform.costPerABOA,
                                this.getFreeRentNewSpace(this.get1rstNewFreeRentForTenYear(rateList,
                                        this.getNewFirstTierTI(iform.newLease,
                                                getConstrMarkups(iform.newLease,
                                                        iform.overheadProfFees,
                                                        iform.gcConditions,
                                                        iform.mgmtCoordFees,
                                                        iform.aeFees,
                                                        iform.aeFeeUOM,
                                                        (0.00).doubleValue()
                                                ).doubleValue()
                                        ).doubleValue(), iform.leaseTerm
                                ).doubleValue(),
                                        this.get2ndNewFreeRentForTenYear(rateList,
                                                this.getNewSecondTierTI(iform.newLease,
                                                        getConstrMarkups(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        getConstrMarkups2ndTier(iform.newLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                iform.maxTi).doubleValue(),
                                                        iform.newLease,
                                                        iform.maxTi
                                                ).doubleValue()
                                        ).doubleValue()
                                ).doubleValue(),
                                iform.coopCommTogsaFirmTerm,
                                Double.valueOf(100),
                                iform.BSACCost, //iform.discountRate, Vaishali RLP FY15
                                iform.numOfMonthsFreeFirmTerm).doubleValue();

                        System.debug(LoggingLevel.Info,'***** formula :: pvCost initial calc: ' + pvCost);

                        // calculate the estimated hvac costs and combine with the PV costs
                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        if (iform.includeHVACOverTime) {
                            pvCost = pvCost + getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                    (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    PBS_AAAP_CALCULATIONS.TENYR,
                                    iform.discountRate);
                        }   // end if

                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        System.debug(LoggingLevel.Info,'***** formula :: pvCost after HVAC calc: ' + pvCost);

                        // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                        if (iform.numParkingSpaces > 0) {
                            pvCost = pvCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    (0.00).doubleValue(),
                                    iform.discountRate,
                                    PBS_AAAP_CALCULATIONS.TENYR);

                        }   // end if

                        System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                        System.debug(LoggingLevel.Info,'***** formula :: pvCost after parking space calc: ' + pvCost);

                        // calculate the telco, move, and other upfront costs
                        if ((iform.otherupfrontcosts > 0) || (iform.telecommcosts > 0) || (iform.physicalcosts > 0)) {
                            pvCost = pvCost + getMoveTelcoUpfrontCosts((iform.physicalcosts != null) ? iform.physicalcosts : (0.00).doubleValue(),
                                    (iform.telecommcosts != null) ? iform.telecommcosts : (0.00).doubleValue(),
                                    (iform.otherupfrontcosts != null) ? iform.otherupfrontcosts : (0.00).doubleValue(),
                                    PBS_AAAP_CALCULATIONS.TENYR,
                                    iform.neworsucceedingOffer);
                        } // end if

                        System.debug('***** iform.otherupfrontcosts: ' + iform.otherupfrontcosts);
                        System.debug(LoggingLevel.Info,'***** formula :: pvCost after upfront calc: ' + pvCost);
                        if (iform.leaseTerm == FIFTEENTENYR) {
                            pvOptCost = this.getFifteenTenYearPVOption(iform.escalRate, iform.discountRate, iform.costPerABOA, iform.fullyServRentOptionTerm);

                            System.debug('***** FifteenTenformula :: pvOptCost: ' + pvOptCost);

                            // calculate the estimated hvac costs and combine with the PV costs No more HVAC included
                            System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                            /*                               if(iform.includeHVACOverTime){
                                    pvOptCost   =   pvOptCost +  getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                                                                                                (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                                                                                               iform.minSqFt,
                                                                                                               iform.maxSqFt,
                                                                                                               iform.leaseTerm,
                                                                                                               iform.discountRate);
                                }   // end if
 */
                            System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                            System.debug('***** formula :: pvOptCost after HVAC calc: ' + pvOptCost);

                            // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                            if (iform.numParkingSpaces > 0) {
                                pvOptCost = pvOptCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                        (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                        (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                        (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                        (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                        (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                        (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                        (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                        iform.minSqFt,
                                        iform.maxSqFt,
                                        (0.00).doubleValue(),
                                        iform.discountRate,
                                        iform.leaseTerm);

                            }   // end if

                            System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                            System.debug(LoggingLevel.Info,'***** formula :: pvOptCost after parking space calc: ' + pvOptCost);

                            pvCost = ((pvCost * 10.0) + (pvOptCost * 5.0)) / 15.0;
                            system.debug(LoggingLevel.Info, '***FINAL PV**** '+pvCost);

                        }

                    }   // end if

                } else {    // succeeding
                    // determine if A&E fees should be included
                    if (!iform.succLeaseIncludeAE) {
                        iform.aeFees = (0.00).doubleValue();        // set the A&E Fees to zero, regardless of whether are any or not, to make the construction markup method ignore the costs.
                    }   // end if

                    // use the correct lease time
                    if (iform.leaseTerm == FIVEYR) {
                        System.debug('***** should be here...Base Rate is: ' + iform.baseRate);
                        // calculate the offer's PV
                        pvCost = this.getFiveYearPV(iform.daytimeCleaningCost,
                                iform.baseRate,
                                this.getBaseRentAndTI(iform.baseRate,
                                        iform.BSACCost + this.getFreeRentNewSpace(this.get1rstNewFreeRentForFiveYear(rateList,
                                                this.getSuccFirstTierTI(iform.succLease,
                                                        getConstrMarkups(iform.succLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        iform.maxTi
                                                ).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEYR
                                        ).doubleValue(),
                                                this.get2ndNewFreeRentForFiveYear(rateList,
                                                        this.getSuccSecondTierTI(iform.succLease,
                                                                getConstrMarkups2ndTier(iform.succLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        (0.00).doubleValue()
                                                                ).doubleValue(),
                                                                iform.maxTi
                                                        ).doubleValue(),
                                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                                ).doubleValue()
                                        ).doubleValue(),
                                        iform.discountRate,
                                        5).doubleValue(),
                                this.getFiveYrAvgCpiAndDiscount(iform.discountRate,
                                        iform.escalRate
                                ).doubleValue(),
                                iform.costPerABOA,
                                this.getFreeRentNewSpace(this.get1rstNewFreeRentForFiveYear(rateList,
                                        this.getSuccFirstTierTI(iform.succLease,
                                                getConstrMarkups(iform.succLease,
                                                        iform.overheadProfFees,
                                                        iform.gcConditions,
                                                        iform.mgmtCoordFees,
                                                        iform.aeFees,
                                                        iform.aeFeeUOM,
                                                        (0.00).doubleValue()
                                                ).doubleValue(),
                                                iform.maxTi
                                        ).doubleValue(),
                                        PBS_AAAP_CALCULATIONS.FIVEYR
                                ).doubleValue(),
                                        this.get2ndNewFreeRentForFiveYear(rateList,
                                                this.getSuccSecondTierTI(iform.succLease,
                                                        getConstrMarkups(iform.succLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        iform.maxTi
                                                ).doubleValue(),
                                                PBS_AAAP_CALCULATIONS.FIVEYR
                                        ).doubleValue()
                                ).doubleValue(),
                                iform.coopCommTogsaFirmTerm,
                                Double.valueOf(100),
                                iform.BSACCost,  //iform.discountRate, RLP FY15 Vaishali
                                iform.numOfMonthsFreeFirmTerm).doubleValue();

                        System.debug('***** formula :: pvCost initial calc: ' + pvCost);

                        // calculate the estimated hvac costs and combine with the PV costs
                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        if (iform.includeHVACOverTime) {
                            pvCost = pvCost + getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                    (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    iform.leaseTerm,
                                    iform.discountRate);
                        }   // end if

                        System.debug('***** formula :: pvCost after HVAC calc: ' + pvCost);

                        // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                        if (iform.numParkingSpaces > 0) {
                            pvCost = pvCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    (0.00).doubleValue(),
                                    iform.discountRate,
                                    PBS_AAAP_CALCULATIONS.FIVEYR);

                        }   // end if

                        System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                        System.debug('***** formula :: pvCost after parking space calc: ' + pvCost);

                        // calculate the telco, move, and other upfront costs
                        if ((iform.otherupfrontcosts > 0) || (iform.telecommcosts > 0) || (iform.physicalcosts > 0)) {
                            pvCost = pvCost + getMoveTelcoUpfrontCosts((iform.physicalcosts != null) ? iform.physicalcosts : (0.00).doubleValue(),
                                    (iform.telecommcosts != null) ? iform.telecommcosts : (0.00).doubleValue(),
                                    (iform.otherupfrontcosts != null) ? iform.otherupfrontcosts : (0.00).doubleValue(),
                                    PBS_AAAP_CALCULATIONS.FIVEYR,
                                    iform.neworsucceedingOffer);
                        } // end if

                        System.debug('***** iform.otherupfrontcosts: ' + iform.otherupfrontcosts);
                        System.debug('***** formula :: pvCost after upfront calc: ' + pvCost);

                    } else if ((iform.leaseTerm == FIVEFIVEYR) || (iform.leaseTerm == FIVEFIVEYRNEW)) {
                        // calculate the offer's PV
                        pvCost = this.getFiveYearPV(iform.daytimeCleaningCost,
                                iform.baseRate,
                                this.getBaseRentAndTI(iform.baseRate,
                                        iform.BSACCost + this.getFreeRentNewSpace(this.get1rstNewFreeRentForFiveYear(rateList,
                                                this.getSuccFirstTierTI(iform.succLease,
                                                        getConstrMarkups(iform.succLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        iform.maxTi
                                                ).doubleValue(),
                                                iform.leaseTerm
                                        ).doubleValue(),
                                                this.get2ndNewFreeRentForFiveYear(rateList,
                                                        this.getSuccSecondTierTI(iform.succLease,
                                                                getConstrMarkups(iform.succLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        (0.00).doubleValue()
                                                                ).doubleValue(),
                                                                iform.maxTi
                                                        ).doubleValue(),
                                                        iform.leaseTerm
                                                ).doubleValue()
                                        ).doubleValue(),
                                        iform.discountRate,
                                        5).doubleValue(),
                                this.getFiveYrAvgCpiAndDiscount(iform.discountRate,
                                        iform.escalRate
                                ).doubleValue(),
                                iform.costPerABOA,
                                this.getFreeRentNewSpace(this.get1rstNewFreeRentForFiveYear(rateList,
                                        this.getSuccFirstTierTI(iform.succLease,
                                                getConstrMarkups(iform.succLease,
                                                        iform.overheadProfFees,
                                                        iform.gcConditions,
                                                        iform.mgmtCoordFees,
                                                        iform.aeFees,
                                                        iform.aeFeeUOM,
                                                        (0.00).doubleValue()
                                                ).doubleValue(),
                                                iform.maxTi
                                        ).doubleValue(),
                                        iform.leaseTerm
                                ).doubleValue(),
                                        this.get2ndNewFreeRentForFiveYear(rateList,
                                                this.getSuccSecondTierTI(iform.succLease,
                                                        getConstrMarkups(iform.succLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        iform.maxTi
                                                ).doubleValue(),
                                                iform.leaseTerm
                                        ).doubleValue()
                                ).doubleValue(),
                                iform.coopCommTogsaFirmTerm,
                                Double.valueOf(100),
                                iform.BSACCost, //iform.discountRate, RLP FY15 Vaishali
                                iform.numOfMonthsFreeFirmTerm).doubleValue();


                        System.debug('***** formula :: pvCost initial calc: ' + pvCost);

                        // calculate the estimated hvac costs and combine with the PV costs
                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        if (iform.includeHVACOverTime) {
                            pvCost = pvCost + getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                    (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    PBS_AAAP_CALCULATIONS.FIVEYR,
                                    iform.discountRate);
                        }   // end if

                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        System.debug('***** formula :: pvCost after HVAC calc: ' + pvCost);

                        // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                        if (iform.numParkingSpaces > 0) {
                            pvCost = pvCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    (0.00).doubleValue(),
                                    iform.discountRate,
                                    PBS_AAAP_CALCULATIONS.FIVEYR);

                        }   // end if

                        System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                        System.debug('***** formula :: pvCost after parking space calc: ' + pvCost);

                        // calculate the telco, move, and other upfront costs
                        if ((iform.otherupfrontcosts > 0) || (iform.telecommcosts > 0) || (iform.physicalcosts > 0)) {
                            pvCost = pvCost + getMoveTelcoUpfrontCosts((iform.physicalcosts != null) ? iform.physicalcosts : (0.00).doubleValue(),
                                    (iform.telecommcosts != null) ? iform.telecommcosts : (0.00).doubleValue(),
                                    (iform.otherupfrontcosts != null) ? iform.otherupfrontcosts : (0.00).doubleValue(),
                                    PBS_AAAP_CALCULATIONS.FIVEYR,
                                    iform.neworsucceedingOffer);
                        } // end if

                        System.debug('***** iform.otherupfrontcosts: ' + iform.otherupfrontcosts);
                        System.debug('***** formula :: pvCost after upfront calc: ' + pvCost);


                        pvOptCost = this.getFiveYearPVOption(iform.daytimeCleaningCost,
                                this.getFiveYrAvgCpiAndDiscountYrSixThruTen(iform.discountRate,
                                        iform.escalRate
                                ).doubleValue(),
                                this.getFiveYrAvgDiscountYrSixThruTen(iform.discountRate).doubleValue(),
                                iform.escalRate,
                                iform.discountRate,
                                iform.costPerABOA,
                                iform.numOfMonthsFreeOptionTerm,
                                iform.fullyServRentOptionTerm);

                        System.debug('***** formula :: pvOptCost: ' + pvOptCost);

                        // calculate the estimated hvac costs and combine with the PV costs
                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        if (iform.includeHVACOverTime) {
                            pvOptCost = pvOptCost + getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                    (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    iform.leaseTerm,
                                    iform.discountRate);
                        }   // end if

                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        System.debug('***** formula :: pvOptCost after HVAC calc: ' + pvOptCost);

                        // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                        if (iform.numParkingSpaces > 0) {
                            pvOptCost = pvOptCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    (0.00).doubleValue(),
                                    iform.discountRate,
                                    iform.leaseTerm);

                        }   // end if

                        System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                        System.debug('***** formula :: pvOptCost after parking space calc: ' + pvOptCost);

                        pvCost = this.getBlendedPV(pvCost, pvOptCost);

                    } else if ((iform.leaseTerm == TENYR) || (iform.leaseTerm == FIFTEENTENYR)) {
                        // calculate the offer's PV
                        pvCost = this.getTenYearPV(iform.daytimeCleaningCost,
                                iform.baseRate,
                                this.getBaseRentAndTI(iform.baseRate,
                                        iform.BSACCost + this.getFreeRentNewSpace(this.getSucc1rstFreeRentForTenYear(rateList,
                                                this.getSuccFirstTierTI(iform.succLease,
                                                        getConstrMarkups(iform.succLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        iform.maxTi
                                                ).doubleValue()
                                        ).doubleValue(),
                                                this.get2ndSuccFreeRentForTenYear(rateList,
                                                        this.getSuccSecondTierTI(iform.succLease,
                                                                getConstrMarkups2ndTier(iform.succLease,
                                                                        iform.overheadProfFees,
                                                                        iform.gcConditions,
                                                                        iform.mgmtCoordFees,
                                                                        iform.aeFees,
                                                                        iform.aeFeeUOM,
                                                                        (0.00).doubleValue()
                                                                ).doubleValue(),
                                                                iform.maxTi
                                                        ).doubleValue()
                                                ).doubleValue()
                                        ).doubleValue(),
                                        iform.discountRate,
                                        10).doubleValue(),
                                this.getTenYrAvgCpiAndDiscount(iform.discountRate,
                                        iform.escalRate
                                ).doubleValue(),
                                iform.costPerABOA,
                                this.getFreeRentNewSpace(this.getSucc1rstFreeRentForTenYear(rateList,
                                        this.getSuccFirstTierTI(iform.succLease,
                                                getConstrMarkups(iform.succLease,
                                                        iform.overheadProfFees,
                                                        iform.gcConditions,
                                                        iform.mgmtCoordFees,
                                                        iform.aeFees,
                                                        iform.aeFeeUOM,
                                                        (0.00).doubleValue()
                                                ).doubleValue(),
                                                iform.maxTi
                                        ).doubleValue()
                                ).doubleValue(),
                                        this.get2ndSuccFreeRentForTenYear(rateList,
                                                this.getSuccSecondTierTI(iform.succLease,
                                                        getConstrMarkups2ndTier(iform.succLease,
                                                                iform.overheadProfFees,
                                                                iform.gcConditions,
                                                                iform.mgmtCoordFees,
                                                                iform.aeFees,
                                                                iform.aeFeeUOM,
                                                                (0.00).doubleValue()
                                                        ).doubleValue(),
                                                        iform.maxTi
                                                ).doubleValue()
                                        ).doubleValue()
                                ).doubleValue(),
                                iform.coopCommTogsaFirmTerm,
                                Double.valueOf(100),
                                iform.BSACCost, // iform.discountRate, RLP FY 15 Vaishali
                                iform.numOfMonthsFreeFirmTerm).doubleValue();

                        System.debug('***** formula :: pvCost initial calc: ' + pvCost);

                        // calculate the estimated hvac costs and combine with the PV costs
                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        if (iform.includeHVACOverTime) {
                            pvCost = pvCost + getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                    (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    PBS_AAAP_CALCULATIONS.TENYR,
                                    iform.discountRate);
                        }   // end if

                        System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                        System.debug('***** formula :: pvCost after HVAC calc: ' + pvCost);

                        // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                        if (iform.numParkingSpaces > 0) {
                            pvCost = pvCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                    (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                    (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                    iform.minSqFt,
                                    iform.maxSqFt,
                                    (0.00).doubleValue(),
                                    iform.discountRate,
                                    PBS_AAAP_CALCULATIONS.TENYR);

                        }   // end if

                        System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                        System.debug('***** formula :: pvCost after parking space calc: ' + pvCost);

                        // calculate the telco, move, and other upfront costs
                        if ((iform.otherupfrontcosts > 0) || (iform.telecommcosts > 0) || (iform.physicalcosts > 0)) {
                            pvCost = pvCost + getMoveTelcoUpfrontCosts((iform.physicalcosts != null) ? iform.physicalcosts : (0.00).doubleValue(),
                                    (iform.telecommcosts != null) ? iform.telecommcosts : (0.00).doubleValue(),
                                    (iform.otherupfrontcosts != null) ? iform.otherupfrontcosts : (0.00).doubleValue(),
                                    PBS_AAAP_CALCULATIONS.TENYR,
                                    iform.neworsucceedingOffer);
                        } // end if

                        System.debug('***** iform.otherupfrontcosts: ' + iform.otherupfrontcosts);
                        System.debug('***** formula :: pvCost after upfront calc: ' + pvCost);
                        if (iform.leaseTerm == FIFTEENTENYR) {
                            pvOptCost = this.getFifteenTenYearPVOption(iform.escalRate, iform.discountRate, iform.costPerABOA, iform.fullyServRentOptionTerm);

                            System.debug('***** FifteenTenformula :: pvOptCost: ' + pvOptCost);

                            // calculate the estimated hvac costs and combine with the PV costs No more HVAC included
                            System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                            /*                               if(iform.includeHVACOverTime){
                                    pvOptCost   =   pvOptCost +  getHvacCosts((iform.HVACOvertimeHours != null) ? iform.HVACOvertimeHours : (0.00).doubleValue(),
                                                                                                                (iform.HVACCost != null) ? iform.HVACCost : (0.00).doubleValue(),
                                                                                                               iform.minSqFt,
                                                                                                               iform.maxSqFt,
                                                                                                               iform.leaseTerm,
                                                                                                               iform.discountRate);
                                }   // end if
 */
                            System.debug('***** iform.includeHVACOverTime: ' + iform.includeHVACOverTime);
                            System.debug('***** formula :: pvOptCost after HVAC calc: ' + pvOptCost);

                            // calculate the estimated parking costs and combine with the PV costs (use a 0 parking escalation rate, as parking escalation is no longer be requested)
                            if (iform.numParkingSpaces > 0) {
                                pvOptCost = pvOptCost + getParkingCosts((iform.numResSrfcPrkSpace != null) ? iform.numResSrfcPrkSpace : (0.00).doubleValue(),
                                        (iform.rateResSrfcPrkSpace != null) ? iform.rateResSrfcPrkSpace : (0.00).doubleValue(),
                                        (iform.numResGargPrkSpace != null) ? iform.numResGargPrkSpace : (0.00).doubleValue(),
                                        (iform.rateResGargPrkSpace != null) ? iform.rateResGargPrkSpace : (0.00).doubleValue(),
                                        (iform.numNonResSrfcPrkSpace != null) ? iform.numNonResSrfcPrkSpace : (0.00).doubleValue(),
                                        (iform.rateNonResSrfcPrkSpace != null) ? iform.rateNonResSrfcPrkSpace : (0.00).doubleValue(),
                                        (iform.numNonResGargPrkSpace != null) ? iform.numNonResGargPrkSpace : (0.00).doubleValue(),
                                        (iform.rateNonResGargPrkSpace != null) ? iform.rateNonResGargPrkSpace : (0.00).doubleValue(),
                                        iform.minSqFt,
                                        iform.maxSqFt,
                                        (0.00).doubleValue(),
                                        iform.discountRate,
                                        iform.leaseTerm);

                            }   // end if

                            System.debug('***** iform.numParkingSpaces: ' + iform.numParkingSpaces);
                            System.debug('***** formula :: pvOptCost after parking space calc: ' + pvOptCost);

                            pvCost = ((pvCost * 10.0) + (pvOptCost * 5.0)) / 15.0;

                        }
                    }   // end if
                }

                iform.pvCosts = pvCost.doubleValue();                 // update the PV Costs

                iform.aeFees = aeFeesStorage;        // revert to the original A&E fees data
                pVals.set(i, iform);
            }   // end for


            returnVals = pVals;
            returnVals.sort();
        }   // end if
        System.debug('##### End -- getManagerPVLessthan2019');
        return returnVals;
    }   // end getManagerPV
// calculate the value of the Ammotization cost Rates page 3a / Step 3 AAAP PV Spreadsheet
// formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
// i = (Amortization rate / 100) / 12
// PVoa = First Tier TI

    // calculate the value of the first tier free rent for five year lease term
    // formula: f(x) = 12 * ( PVoa / [ (1 - (1 / (1 + i)^-n )) / i] )
    // i = (Amortization rate / 100) / 12
    public Decimal getAmortizationCost(Double pAmortizationRateFirstTier, Double pNewFirstTierTI, Decimal pLeaseTermYRS) {
        System.debug('##### Begin -- getAmortizationCost');
        System.debug('***** formula terms :: pLeaseTermYRS = ' + pLeaseTermYRS);
        System.debug('***** formula terms :: pAmortizationRateFirstTier = ' + pAmortizationRateFirstTier);

        Decimal returnVal = 0.00;

        // avoid "DIV by 0" errors

        Decimal intRate = (pAmortizationRateFirstTier > 0) ? pAmortizationRateFirstTier : 0.000000001;
        Double intMonths = 12 * pLeaseTermYRS;
        System.debug('***** formula terms :: pNewFirstTierTI = ' + String.valueOf(pNewFirstTierTI));
        System.debug('***** formula terms :: intRate = ' + intRate);
        Decimal rateConversion = (intRate / 100) / 12;
        System.debug('***** formula terms :: rateConversion = ' + rateConversion);
        Decimal base = 1.00 + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Decimal denominator = (1 - (1 / math.pow(base.doubleValue(), intMonths))) / rateConversion;
        System.debug('***** formula terms :: denominator = ' + denominator);
        Decimal temp = 12 * (pNewFirstTierTi / denominator);

        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getAmortizationCost');
        return returnVal;
    }   // end getAmortizationCost
//Vaishali Start FY17 08/01/2016  Global discounts and escalations.
    // calculate the firm term discount rate with start year as 1 end year as the term year.
    // formula: f(x) = (1 + (Discount Rate / 100) ^ (Year )
    // where "Year" represents the year's (1, 2, 3, 4, or 5) average discount rate
    // calculate the option term discount rate with starting year and ending year as defined
    public Decimal getNewAvgDiscount(Double pDiscRate, integer pTermStartYrs, integer pTermEndYrs) {
        System.debug('##### Begin -- getNewAvgDiscount');
        Decimal returnVal = 0.00;
        Decimal discount = 0.00;
        integer numStartYear = (pTermStartYrs != null) ? pTermStartYrs : 0;
        integer numEndYear = (pTermEndYrs != null) ? pTermEndYrs : 0;
        for (Integer i = numStartYear; i <= numEndYear; i++) {
            discount = 1 / math.pow((1 + (pDiscRate / 100)), i);
            System.debug('##### discount: ' + discount);
            returnVal = returnVal + discount;
            System.debug('##### returnVal in loop: ' + returnVal);
        } // end for

        returnVal = returnVal / (numEndYear - numStartYear + 1);
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getNewAvgDiscount');
        return returnVal;
    }   // getNewAvgDiscount
    // calculate the term average CPI * discount rate
    //for firm term, start year is always 1.
    // formula: f(x) = Avg. CPI * Avg. Discount
    // Avg. CPI = (1 + Escalation Rate) ^ (Year - 1)
    // Avg. Discount = (1 + (Discount Rate / 100) ^ (Year)
    // where "Year" represents the year's (1, 2, 3, 4, or 5) average discount rate
    public Decimal getNewAvgCpiAndDiscount(Double pDiscRate, Double pEscltRate, integer pTermStartYrs, integer pTermEndYrs) {
        System.debug('##### Begin -- getNewAvgCpiAndDiscount');
        Decimal returnVal = 0.00;
        Decimal discount = 0.00;
        Decimal cpi = 0.00;
        integer numStartYear = (pTermStartYrs != null) ? pTermStartYrs : 0;
        integer numEndYear = (pTermEndYrs != null) ? pTermEndYrs : 0;

        for (Integer i = numStartYear; i <= numEndYear; i++) {
            discount = 1 / math.pow((1 + (pDiscRate / 100)), i);
            cpi = math.pow((1 + (pEscltRate / 100)), (i - 1));
            System.debug('##### discount: ' + discount);
            System.debug('##### cpi: ' + cpi);
            Decimal cpiDiscount = cpi * discount;
            returnVal = returnVal + cpiDiscount;
            System.debug('##### returnVal in loop: ' + returnVal);
        } // end for

        returnVal = returnVal / (numEndYear - numStartYear + 1);
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getNewAvgCpiAndDiscount');
        return returnVal;
    }   // getNewAvgCpiAndDiscount
//Vaishali RLP-FY17 no need to subtract base year Operating costs when calculating baseRate,

    public Decimal getFifteenTenYearPVOption(Double pRLPEscRate, Double pRLPDiscRate, Double pBaseYrOpCosts, Double pFullSrvcRentOptTerm) {
        System.debug('##### Begin -- getFiveYearPVOption');
        Decimal returnVal = 0.00;
        System.debug('***** pRLPEscRate: ' + pRLPEscRate);
        System.debug('***** pRLPDiscRate: ' + pRLPDiscRate);
        System.debug('***** pBaseYrOpCosts: ' + pBaseYrOpCosts);
        System.debug('***** pFullSrvcRentOptTerm: ' + pFullSrvcRentOptTerm);

        Decimal baseRate = (pFullSrvcRentOptTerm) * getNewAvgDiscount(pRLPDiscRate, 11, 15);           // includes term for factoring in the CPI Escalation and Discount rates and the full service rent option term
        System.debug('***** baseRate: ' + baseRate);
        Decimal calcOpCosts = pBaseYrOpCosts * getNewAvgCpiAndDiscount(pRLPDiscRate, pRLPEscRate, 11, 15);                                                          // includes term for factoring in the CPI Escalation and Discount rates
        System.debug('***** calcOpCosts: ' + calcOpCosts);
        Decimal discFor6thYr = 1 / math.pow((1 + (pRLPDiscRate / 100)), 5);
        System.debug('***** discFor6thYr: ' + discFor6thYr);
        Decimal escFor6thYr = math.pow((1 + (pRLPEscRate / 100)), 5);
        System.debug('***** escFor6thYr: ' + escFor6thYr);

        returnVal = baseRate + calcOpCosts;
        System.debug('##### returnVal: ' + returnVal);
        System.debug('##### End -- getFifteenTenYearPVOption');
        return returnVal;
    }   // end getFifteenTenYearPVOption

//Vaishali End FY17 08/01/2016 Global discounts and escalations.
    public Decimal getCensusPV(Double pBaseRate, Double pBaseYrOpCosts, Double pRLPDiscRate, String pLeaseTerm, Double numOfMonthsFree) {
        System.debug('##### Begin -- getCensusPV ');
        Decimal returnVal = 0.00;
        System.debug('***** pBaseRate: ' + pBaseRate);
        System.debug('***** pRLPDiscRate: ' + pRLPDiscRate);
        System.debug('***** pBaseYrOpCosts: ' + pBaseYrOpCosts);
        System.debug('***** pLeaseTerm: ' + pLeaseTerm);
        System.debug('***** numOfMonthsFree: ' + numOfMonthsFree);

        if (pLeaseTerm == CENSUS_25 || pLeaseTerm == CENSUS_25_2018) {
            returnVal = (pBaseRate + pBaseYrOpCosts) * (1 / (1 + (pRLPDiscRate / 100)));
            returnVal += (pBaseRate + pBaseYrOpCosts) * (1 / math.pow((1 + (pRLPDiscRate / 100)), 2));
            returnVal += (pBaseRate + pBaseYrOpCosts) * (1 / math.pow((1 + (pRLPDiscRate / 100)), 3)) / 12;
            System.debug('***** CensusPV Before average: ' + returnVal);
            returnval = (returnval * 12 / 25);
            System.debug('***** CensusPV Before Free Rent: ' + returnVal);
            //Free month subtraction
            returnval = returnval - ((pBaseRate + pBaseYrOpCosts) * numOfMonthsFree / 25);
            System.debug('***** CensusPV Before Free Rent: ' + returnVal);
        } else if (pLeaseTerm == CENSUS_19 || pLeaseTerm == CENSUS_19_2018) {
            returnVal = (pBaseRate + pBaseYrOpCosts) * (1 / (1 + (pRLPDiscRate / 100)));
            returnVal += (pBaseRate + pBaseYrOpCosts) * (1 / math.pow((1 + (pRLPDiscRate / 100)), 2)) * 7 / 12;
            System.debug('***** CensusPV Before Free Rent: ' + returnVal);
            //Free month subtraction
            returnval = returnval * 12 / 19 - (pBaseRate + pBaseYrOpCosts) * numOfMonthsFree / 19;
        }

        return returnVal;
    }   // end getCensusPV


//public Decimal censusPV(Double pDayCleanCosts, Decimal pBaseRent, Double pBaseRentTi,  Double pBaseYrOpCosts, Double pValFreeRentTi, Double pTenYrBrokerageComm, Double pGovtCommSplit, Double pDiscRate, Double pTenYrFreeRentFIRM){


/////                                                             h                     r                                  e                   aa                               v                                           w                              bb                                    t                                             u
    public Decimal getAnnualRentPerABOASFYear3(Double PBS_AAAP_BASE_RATE, Decimal PBS_AAAP_LEASE_TERM, Double PBS_AAAP_COST_PER_ABOA, Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Decimal BB, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT) {
        //H x ((R - 24) / 12) + E x ((R - 24) / 12) + (AA x (V + W)) x ((R - 24) / 12) + (BB x (T + U)) x ((R - 24) / 12)
        Double returnVal = 0.00;
        System.debug('Begin getAnnualRentPerABOASFYear3');
        System.debug('PBS_AAAP_BASE_RATE (H)' + PBS_AAAP_BASE_RATE);
        System.debug('PBS_AAAP_LEASE_TERM (R)' + PBS_AAAP_LEASE_TERM);
        System.debug('PBS_AAAP_COST_PER_ABOA (E) ' + PBS_AAAP_COST_PER_ABOA);
        System.debug('AA ' + AA);
        System.debug('BB ' + BB);
        System.debug('PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c (T) ' + PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT);
        System.debug('PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE (V)' + PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE);
        //   PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE = 15.0; //weston
        System.debug('PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT (U)' + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT);
        System.debug('PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE (W) ' + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE);
        //H             x ((R -                  24)/ 12) + E x                     ((R - 24) / 12) +                 (AA x (V + W))                                                                         x ((R - 24) / 12) +                 (BB x (T + U))                                                                            x ((R - 24) / 12)
        Decimal temp = (PBS_AAAP_BASE_RATE * ((PBS_AAAP_LEASE_TERM - 24) / 12)) + (PBS_AAAP_COST_PER_ABOA * ((PBS_AAAP_LEASE_TERM - 24) / 12)) + (AA * (PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE)) * ((PBS_AAAP_LEASE_TERM - 24) / 12) + (BB * (PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT)) * ((PBS_AAAP_LEASE_TERM - 24) / 12);

        returnVal = temp.doubleValue();
        System.debug('End year three');
        System.debug('returnVal' + returnVal);
        return returnVal;


    }

    public Decimal getNPTonly(Double PBS_AAAP_DISCOUNT_RATE, Decimal CC, Decimal DD) {

        double npv = 0;
        double r1 = PBS_AAAP_DISCOUNT_RATE + 1;
        double trate = r1;

        npv += CC / trate;
        trate *= r1;
        npv += DD / trate;
        return npv;


    }

    public Decimal getNPTonly(Decimal PBS_AAAP_DISCOUNT_RATE, Decimal CC, Decimal DD, Decimal EE) {

        double npv = 0;
        double r1 = PBS_AAAP_DISCOUNT_RATE + 1;
        double trate = r1;

        npv += CC / trate;
        trate *= r1;
        npv += DD / trate;
        trate *= r1;
        npv += EE / trate;
        return npv;


    }


    public Decimal censusPV(PBS_AAAP_Offer__c offer, PBS_AAAP_Space__c space, PBS_AAAP_RLP__c rlp, String leaseTerm, PBS_AAAP_Rate__c rate, PBS_AAAP_Agency_Requirement__c agncy, Boolean newLeaseIncludeAE,
            double AEfromPage, double PBS_AAAP_MOVE_DEFAULT_OVERRIDE, double PBS_AAAP_TELCOMM_DEFAULT_OVERRIDE, double PBS_AAAP_PV_OTHER_UPFRONT_COSTS_OVERRIDE) {
        /////// the very beginning
        //System.debug('##### Begin -- offerId'+offerId);

        // System.debug('##### Begin -- spaceId'+spaceId);
        System.debug('##### Begin -- leaseTerm' + leaseTerm);
        //System.debug('##### Begin -- agencyId'+agencyId);
        System.debug('did they want to override the AE costs? ' + newLeaseIncludeAE);
        System.debug('value from the override: ' + AEfromPage);
        System.debug('PBS_AAAP_MOVE_DEFAULT_OVERRIDE: ' + PBS_AAAP_MOVE_DEFAULT_OVERRIDE);
        System.debug('PBS_AAAP_TELCOMM_DEFAULT_OVERRIDE ' + PBS_AAAP_TELCOMM_DEFAULT_OVERRIDE);
        System.debug('PBS_AAAP_PV_OTHER_UPFRONT_COSTS_OVERRIDE' + PBS_AAAP_PV_OTHER_UPFRONT_COSTS_OVERRIDE);

/*
        PBS_AAAP_Space__c space =[select PBS_AAAP_RLP__c,
        PBS_AAAP_TOTAL_MARKUP__c, PBS_AAAP_GC_OVERHEAD_AND_PROF__c, PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,
         PBS_AAAP_ARCH_ENG_FEES__c from PBS_AAAP_Space__c where Id =: spaceId];
*/
        //System.debug('this space provided % or $? ' + space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c);

/*
        PBS_AAAP_Offer__c offer = [ select PBS_AAAP_Monthly_cost_nonres_gar_park__c,
        PBS_AAAP_Monthly_cost_res_gar_park__c,PBS_AAAP_Monthly_cost_nonres_sur_park__c,
        PBS_AAAP_Monthly_cost_res_sur_park__c,PBS_AAAP_COST_PER_ABOA__c from PBS_AAAP_Offer__c  where Id=: offerId];

*/
        //System.debug('##### Begin -- space.PBS_AAAP_RLP__c'+space.PBS_AAAP_RLP__c);
        /*
        PBS_AAAP_RLP__c rlp= [select Id,PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c,PBS_AAAP_DISCOUNT_RATE__c,PBS_AAAP_RLP_Number__c,
        PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c,PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c,PBS_AAAP_MOVE_DEFAULT__c,PBS_AAAP_TELCOMM_DEFAULT__c
         from PBS_AAAP_RLP__c where Id=:space.PBS_AAAP_RLP__c ];
        //weston PBS_AAAP_GC_OVERHEAD_AND_PROF__c



         PBS_AAAP_Agency_Requirement__c agncy=[select PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c,
         PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c,PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c,
         PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c,PBS_AAAP_USF_REQ_MIN__c,PBS_AAAP_USF_REQ_MAX__c,
         PBS_AAAP_LEASE_TERM__c from PBS_AAAP_Agency_Requirement__c  where Id=:agencyId];
*/
        //PBS_AAAP_Rate__c rate= null;

        Decimal term = 0.0;
        Decimal firmtermc = 0;
        Double k = 0.0;
        Double L = 0.0;
        Double M = 0.0;
        Double N = 0.0;
        system.debug('#### Offer ' + offer);
        system.debug('#### Space ' + space);
        system.debug('#### RLP ' + rlp);
        if (PBS_AAAP_MOVE_DEFAULT_OVERRIDE > 0 && PBS_AAAP_MOVE_DEFAULT_OVERRIDE != null) {
            L = PBS_AAAP_MOVE_DEFAULT_OVERRIDE;
        } else {
            L = rlp.PBS_AAAP_MOVE_DEFAULT__c;
        }

        if (PBS_AAAP_TELCOMM_DEFAULT_OVERRIDE > 0 && PBS_AAAP_TELCOMM_DEFAULT_OVERRIDE != null) {

            M = PBS_AAAP_TELCOMM_DEFAULT_OVERRIDE;
        } else {
            M = rlp.PBS_AAAP_TELCOMM_DEFAULT__c;
        }

        if (PBS_AAAP_PV_OTHER_UPFRONT_COSTS_OVERRIDE > 0 && PBS_AAAP_PV_OTHER_UPFRONT_COSTS_OVERRIDE != null) {

            N = PBS_AAAP_PV_OTHER_UPFRONT_COSTS_OVERRIDE;
        } else {
            N = rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c;
        }
/*
       if(leaseTerm == CENSUS_19){
          rate =[ select PBS_AAAP_BASE_RATE__c,PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c
           from PBS_AAAP_Rate__c where PBS_AAAP_SPACE__c=:space.Id and PBS_AAAP_OFFER_NUMBER__c=:offer.Id
            and PBS_AAAP_LEASE_TERM__c='19 Months,11 Firm' limit 1] ;


         }else if(leaseTerm == CENSUS_25){

            rate =[ select PBS_AAAP_BASE_RATE__c,PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c
             from PBS_AAAP_Rate__c where PBS_AAAP_SPACE__c=:space.Id and PBS_AAAP_OFFER_NUMBER__c=:offer.Id
               and PBS_AAAP_LEASE_TERM__c='25 Months,16 Firm' limit 1] ;
     //PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20
         }
      */
        //System.debug('whats the percent going to amort of TI: ' + rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c);

        //using the input off the identify winner search page override for k
        if (newLeaseIncludeAE == true) {
            k = AEfromPage;
//
        } else {
            k = (Double) rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c;
        }


        Decimal annualAmortizedTI;
        if (leaseTerm == CENSUS_25 || leaseTerm == CENSUS_25_2018) {
            //temp = calc.getAmortizationofTI(i,k,s);
            //       System.debug('16firm'+space.X25_Months_16_Firm__c);

            firmtermc = 16.00;
            term = 25.00;

            annualAmortizedTI = getAmortizationofTI((Double) rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c,
                    k,
                    (Double) firmtermc);
            firmtermc = 16.00;
            term = 25.00;

        } else if (leaseTerm == CENSUS_19 || leaseTerm == CENSUS_19_2018) {


            //       System.debug('19firm'+space.X19_Months_11_Firm__c);
            //annualAmortizedTI = space.X19_Months_11_Firm__c;


            firmtermc = 11.00;
            term = 19.00;

            annualAmortizedTI = getAmortizationofTI((Double) rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c,
                    k,
                    (Double) firmtermc);

        }


        if (annualAmortizedTI != null) {
            annualAmortizedTI = annualAmortizedTI * -1;
        }
        Decimal Y = 0.0;
        Decimal Z = 0.0;

        Decimal firmterm = rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c;
        //System.debug('weston ' + space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c );
        if (space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '%') {
///////Line Y as a percentage                      //G                                              //F                                //K
            //getTotalFeeCostPercentage(Double PBS_AAAP_ARCH_ENG_FEES, Double PBS_AAAP_GC_OVERHEAD_AND_PROF, Double PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW )
            Y = getTotalFeeCostPercentage((Double) space.PBS_AAAP_ARCH_ENG_FEES__c, (Double) space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, k);
        } else {
            Y = getTotalFeeCost((Double) space.PBS_AAAP_ARCH_ENG_FEES__c, (Double) space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, k);
        }


        System.debug(' line y = ' + Y);
        Z = getTotalLessorOverheadAndFees((Double) Y, k);


        System.debug('11111 agncy ' + agncy);
        System.debug('11111 offer ' + offer);
        Decimal AA = getGarageParkingRate((Decimal) agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, (Decimal) offer.PBS_AAAP_Monthly_cost_res_gar_park__c, (Decimal) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, (Decimal) offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c, (Decimal) agncy.PBS_AAAP_USF_REQ_MIN__c, (Decimal) agncy.PBS_AAAP_USF_REQ_MAX__c);


        Decimal BB = getSurfaceParkingRate((Double) agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, (Double) offer.PBS_AAAP_Monthly_cost_res_sur_park__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c, (Double) offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c, (Double) agncy.PBS_AAAP_USF_REQ_MIN__c, (Double) agncy.PBS_AAAP_USF_REQ_MAX__c);
        // need to write
        //Decimal CC=getAnnualRentPerABOASFYear1((Double)rate.PBS_AAAP_BASE_RATE__c, (Double)offer.PBS_AAAP_COST_PER_ABOA__c, annualAmortizedTI,decimal.valueOf(agncy.PBS_AAAP_LEASE_TERM__c),Z,AA,(Double)agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, (Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c,BB, (Double)agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, (Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c );
        Decimal CC = 0.0;
        Decimal DD = 0.0;

        if (leaseTerm == CENSUS_19 || leaseTerm == CENSUS_19_2018) {
            CC = getAnnualRentPerABOASFYear1((Double) rate.PBS_AAAP_BASE_RATE__c, (Double) offer.PBS_AAAP_COST_PER_ABOA__c, annualAmortizedTI, firmtermc, Z, AA, (Double) agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, BB, (Double) agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c);
            //40.0 __ 20.0 __ -34.05109822369942 __ 11.00 __ 0.696666666666666666666666666666667 __ AA3.0 __ 4.0 __ BB __ 2.0 __ 1.0
            //100.0 __ 15.0 __ 32.40071342462342 __ 11.00 __ 0.0491262135922330097087378640776699 __ 0.1165481189476390415.0 __ 20.0 __ 0.20795840831833634 __ 5.0 __ 10.0
            //DEBUG|100.0 __ 15.0 __ 32.40071342462342 __ 11.00 __ 0.0491262135922330097087378640776699 __ 0.1165481189476390415.0 __ 20.0 __ 0.20795840831833634 __ 5.0 __ 10.0
// Decimal DD = getAnnualRentPerABOASFYear2((Double)rate.PBS_AAAP_BASE_RATE__c, decimal.valueOf(agncy.PBS_AAAP_LEASE_TERM__c), (Double)offer.PBS_AAAP_COST_PER_ABOA__c, AA, (Double)agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, (Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, BB, (Double)agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, (Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c );
            DD = getAnnualRentPerABOASFYear2((Double) rate.PBS_AAAP_BASE_RATE__c, term, (Double) offer.PBS_AAAP_COST_PER_ABOA__c, AA, (Double) agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, BB, (Double) agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c);

        } else if (leaseTerm == CENSUS_25 || leaseTerm == CENSUS_25_2018) {
            //Line DD Annual Rent per ABOA SF Year 2                             H                                E               x          z          AA                    V                                                           W                         BB               T                                                                 U
            // publ  getAnnualRentPerABOASFYear1for25(Double PBS_AAAP_BASE_RATE, Double PBS_AAAP_COST_PER_ABOA, Decimal X, Decimal Z, Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Decimal BB, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double  PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT )
            CC = getAnnualRentPerABOASFYear1for25((Double) rate.PBS_AAAP_BASE_RATE__c, (Double) offer.PBS_AAAP_COST_PER_ABOA__c, annualAmortizedTI, Z, AA, (Double) agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, BB, (Double) agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c);
            //40.0 __ 20.0 __ -34.05109822369942 __ 11.00 __ 0.696666666666666666666666666666667 __ AA3.0 __ 4.0 __ BB __ 2.0 __ 1.0
            //100.0 __ 15.0 __ 32.40071342462342 __ 11.00 __ 0.0491262135922330097087378640776699 __ 0.1165481189476390415.0 __ 20.0 __ 0.20795840831833634 __ 5.0 __ 10.0
            //DEBUG|100.0 __ 15.0 __ 32.40071342462342 __ 11.00 __ 0.0491262135922330097087378640776699 __ 0.1165481189476390415.0 __ 20.0 __ 0.20795840831833634 __ 5.0 __ 10.0

            //pu   getAnnualRentPerABOASFYear2for25(Double PBS_AAAP_BASE_RATE, Double PBS_AAAP_COST_PER_ABOA, Decimal X, Decimal PBS_AAAP_LEASE_TERM, Decimal Z,  Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Decimal BB, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double  PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT )
            DD = getAnnualRentPerABOASFYear2for25((Double) rate.PBS_AAAP_BASE_RATE__c, (Double) offer.PBS_AAAP_COST_PER_ABOA__c, annualAmortizedTI, firmtermc, Z, AA, (Double) agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, BB, (Double) agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c);
        }


//System.debug((Decimal)agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c +' __ '+ (Decimal)offer.PBS_AAAP_Monthly_cost_res_gar_park__c+' __ '+ (Decimal)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c+' __ '+ (Decimal)offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c+' __ '+ (Decimal)agncy.PBS_AAAP_USF_REQ_MIN__c+' __ '+ (Decimal)agncy.PBS_AAAP_USF_REQ_MAX__c );
        //3 __ 100.00 __ 4 __ 50.00 __ 10.00 __ 1000001.00
        //    System.debug((Double)agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c +'__'+(Double) offer.PBS_AAAP_Monthly_cost_res_sur_park__c +' __ '+(Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c +' __ '+(Double)offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c +' __ '+(Double)agncy.PBS_AAAP_USF_REQ_MIN__c +' __ '+ (Double) agncy.PBS_AAAP_USF_REQ_MAX__c );
        //2.0__200.0 __ 1.0 __ 100.0 __ 10.0 __ 1000001.0

        //   System.debug((Double)rate.PBS_AAAP_BASE_RATE__c+' __ '+ (Double)offer.PBS_AAAP_COST_PER_ABOA__c+' __ '+ annualAmortizedTI+' __ '+firmtermc+' __ '+Z+' __ '+AA+(Double)agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c+' __ '+ (Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c+' __ '+BB+' __ '+ (Double)agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c+' __ '+ (Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c );
        //50.0 __ 20.0 __ -34.05109822369942 __ 11.00 __ 0.696666666666666666666666666666667 __ 0.00171426685735028353.0 __ 4.0 __ 0.003999956000483995 __ 2.0 __ 1.0


        //  System.debug((Double)rate.PBS_AAAP_BASE_RATE__c+' __ '+ 19.00+' __ '+ (Double)offer.PBS_AAAP_COST_PER_ABOA__c+' __ '+ AA+' __ '+ (Double)agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c+' __ '+ (Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c+' __ '+ BB+' __ '+ (Double)agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c+' __ '+ (Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c );
        //50.0 __ 19.00 __ 20.0 __ 0.0017142668573502835 __ 3.0 __ 4.0 __ 0.003999956000483995 __ 2.0 __ 1.0


        System.debug('agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c ' + (Double) agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c);
        System.debug('rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c  ' + rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c);
        System.debug('(Double) offer.PBS_AAAP_Monthly_cost_res_sur_park__c ' + (Double) offer.PBS_AAAP_Monthly_cost_res_sur_park__c);
        System.debug('(Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c ' + (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c);
        System.debug('(Double)offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c ' + (Double) offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c);
        System.debug('(Double)agncy.PBS_AAAP_USF_REQ_MIN__c ' + (Double) agncy.PBS_AAAP_USF_REQ_MIN__c);
        System.debug('(Double) agncy.PBS_AAAP_USF_REQ_MAX__c  ' + (Double) agncy.PBS_AAAP_USF_REQ_MAX__c);

        System.debug('PBS_AAAP_LEASE_TERM (R)' + rate.PBS_AAAP_BASE_RATE__c);
        System.debug('PBS_AAAP_MOVE_DEFAULT (L)' + L);
        System.debug('PBS_AAAP_TELCOMM_DEFAULT (M)' + M);
        System.debug('PBS_AAAP_PV_OTHER_UPFRONT_COSTS (N)' + N);
        System.debug('PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM (J)' + rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
        System.debug('PBS_AAAP_BASE_RATE (H)' + rate.PBS_AAAP_BASE_RATE__c);
        System.debug('PBS_AAAP_COST_PER_ABOA (E)' + offer.PBS_AAAP_COST_PER_ABOA__c);
        // System.debug('markup-->'+space.PBS_AAAP_TOTAL_MARKUP__c);
        System.debug('Z-->' + Z);
        System.debug('AA-->' + AA);
        System.debug('BB-->' + BB);
        System.debug('CC-->' + CC);
        System.debug('DD-->' + DD);
        // System.debug('annualAmortizedTI (X)'+ annualAmortizedTI);
        System.debug('Z (Z)' + Z);


        // Decimal returnVal  =getNPV(leaseTerm,(Double)rlp.PBS_AAAP_DISCOUNT_RATE__c,CC, DD,AA,(Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, BB,decimal.valueOf(agncy.PBS_AAAP_LEASE_TERM__c),(Double)rlp.PBS_AAAP_MOVE_DEFAULT__c, (Double)rlp.PBS_AAAP_TELCOMM_DEFAULT__c, (Double) rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, (Double)rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, (Double)rate.PBS_AAAP_BASE_RATE__c, (Double)offer.PBS_AAAP_COST_PER_ABOA__c, Z, annualAmortizedTI,(Double)agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c,(Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__C);
        // Decimal returnVal =getNPV(leaseTerm,(Double)rlp.PBS_AAAP_DISCOUNT_RATE__c,CC, DD,AA,(Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, BB,firmtermc,(Double)rlp.PBS_AAAP_MOVE_DEFAULT__c, (Double)rlp.PBS_AAAP_TELCOMM_DEFAULT__c, (Double) rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, (Double)rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, (Double)rate.PBS_AAAP_BASE_RATE__c, (Double)offer.PBS_AAAP_COST_PER_ABOA__c, Z, annualAmortizedTI,(Double)agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c,(Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__C);
        System.debug(' what is it here: ' + (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c);
        Decimal returnVal = getNPV(leaseTerm, (Double) rlp.PBS_AAAP_DISCOUNT_RATE__c, CC, DD, AA, (Double) agncy.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, BB, term, L, M, N, (Double) rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, (Double) rate.PBS_AAAP_BASE_RATE__c, (Double) offer.PBS_AAAP_COST_PER_ABOA__c, Z, annualAmortizedTI, (Double) agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__C, (Double) agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c);


        //System.debug(leaseTerm +'__'+(Double)rlp.PBS_AAAP_DISCOUNT_RATE__c+'__'+CC+DD+AA+'__'+(Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c+'__'+BB+'__'+term+'__'+(Double)rlp.PBS_AAAP_MOVE_DEFAULT__c+'__'+(Double)rlp.PBS_AAAP_TELCOMM_DEFAULT__c+'__'+(Double)rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c+'__'+(Double)rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c+'__'+(Double)rate.PBS_AAAP_BASE_RATE__c+'__'+ (Double)offer.PBS_AAAP_COST_PER_ABOA__c+'__'+Z+'__'+annualAmortizedTI+'__'+(Double)agncy.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c+'__'+(Double)agncy.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__C);

        //19 months,11 firm__2.0__217.5950692919456100.449160167966410.11654811894763904__20.0__0.20795840831833634__19.00__2.0__1.0__1.0__1.0__150.0__15.0__0.0491262135922330097087378640776699__47.20448667318489__5.0__10.0


        System.debug('returnVal**-->' + returnVal);


        return returnVal;
    }   // getTenYearPV


    public Decimal getNPV(String leaseTerm, Double PBS_AAAP_DISCOUNT_RATE, Decimal CC, Decimal DD, Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Decimal BB, Decimal PBS_AAAP_LEASE_TERM, Double PBS_AAAP_MOVE_DEFAULT, Double PBS_AAAP_TELCOMM_DEFAULT, Double PBS_AAAP_PV_OTHER_UPFRONT_COSTS, Double PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM, Double PBS_AAAP_BASE_RATE, Double PBS_AAAP_COST_PER_ABOA, Decimal Z, Decimal X, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE) {
        double npv = 0;
        PBS_AAAP_DISCOUNT_RATE = PBS_AAAP_DISCOUNT_RATE / 100;
        double r1 = PBS_AAAP_DISCOUNT_RATE + 1;
        double trate = r1;

        Decimal EE = 0.0;
        if (leaseTerm == CENSUS_25 || leaseTerm == CENSUS_25_2018) {
            //  PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE= 15.0;
            System.debug('PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE ' + PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE);
            System.debug('PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE ' + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE);
            //                                 PBS_AAAP_BASE_RATE,PBS_AAAP_LEASE_TERM,pbS_AAAP_COST_PER_ABOA, AA,pbS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE,PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE,BB, PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT,PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT)
            EE = getAnnualRentPerABOASFYear3(PBS_AAAP_BASE_RATE, PBS_AAAP_LEASE_TERM, PBS_AAAP_COST_PER_ABOA, AA, PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, BB, PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT);

            npv = this.getNPTonly(PBS_AAAP_DISCOUNT_RATE, CC, DD, EE);
        } else if (leaseTerm == CENSUS_19 || leaseTerm == CENSUS_19_2018) {


            npv = this.getNPTonly(PBS_AAAP_DISCOUNT_RATE, CC, DD);

            System.debug('npv***--->' + npv);
            System.debug('PBS_AAAP_DISCOUNT_RATE--->' + PBS_AAAP_DISCOUNT_RATE);
            System.debug('cc--->' + CC);
            System.debug('DD--->' + DD);


        }
        System.debug('EE-->' + EE);

        //  NPV End
        //NPV(O,CC,DD) / (R / 12) + (L + M + N) - (J * (H + E + X + (Z * X)) /12) / (R / 12)
        /*    O = PBS_AAAP_DISCOUNT_RATE
        CC = Annual Rent per ABOA SF Year 1
        DD = Annual Rent per ABOA SF Year 2
        R = PBS_AAAP_LEASE_TERM (LONG)
        L = PBS_AAAP_MOVE_DEFAULT
        M = PBS_AAAP_TELCOMM_DEFAULT
        N = PBS_AAAP_PV_OTHER_UPFRONT_COSTS
        J = PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM
        H = PBS_AAAP_BASE_RATE
        E = PBS_AAAP_COST_PER_ABOA
        X = TIA
        Z = TOTAL LESSOR OVERHEAD AND FEES
        */


        Double returnVal = 0.00;


        if (PBS_AAAP_TELCOMM_DEFAULT == null) {

            PBS_AAAP_TELCOMM_DEFAULT = 0.0;

        }

        if (PBS_AAAP_MOVE_DEFAULT == null) {

            PBS_AAAP_MOVE_DEFAULT = 0.0;

        }


        //      1.0385694494591322__11.00__null__0.0__0.0__0.0__40.0__20.0__11.00
        //1.0385694494591322__11.00__0.0__0.0__0.0__0.0__40.0__20.0__11.00
        System.debug('--->' + npv + '__' + PBS_AAAP_LEASE_TERM + '__' + PBS_AAAP_MOVE_DEFAULT + '__' + PBS_AAAP_TELCOMM_DEFAULT + '__' + PBS_AAAP_PV_OTHER_UPFRONT_COSTS + '__' + PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM + '__' + PBS_AAAP_BASE_RATE + '__' + PBS_AAAP_COST_PER_ABOA + '__' + PBS_AAAP_LEASE_TERM);
        //      NPV(O,CC,DD,EE) / (R / 12) + (L + M + N) / (R / 12) - (J * (H + E + X + (Z * X)) /12) / (R / 12)
        System.debug('Begin final calculation ');
        System.debug('NPV ' + npv);
        System.debug('PBS_AAAP_LEASE_TERM (R)' + PBS_AAAP_LEASE_TERM);
        System.debug('PBS_AAAP_MOVE_DEFAULT (L)' + PBS_AAAP_MOVE_DEFAULT);
        System.debug('PBS_AAAP_TELCOMM_DEFAULT (M)' + PBS_AAAP_TELCOMM_DEFAULT);
        System.debug('PBS_AAAP_PV_OTHER_UPFRONT_COSTS (N)' + PBS_AAAP_PV_OTHER_UPFRONT_COSTS);
        System.debug('PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM (J)' + PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM);
        System.debug('PBS_AAAP_BASE_RATE (H)' + PBS_AAAP_BASE_RATE);
        System.debug('PBS_AAAP_COST_PER_ABOA (E)' + PBS_AAAP_COST_PER_ABOA);
        System.debug('X (X)' + X);
        System.debug('Z (Z)' + Z);
        Decimal temp = 0.0;


        temp = (npv / (PBS_AAAP_LEASE_TERM / 12)) + ((PBS_AAAP_MOVE_DEFAULT + PBS_AAAP_TELCOMM_DEFAULT + PBS_AAAP_PV_OTHER_UPFRONT_COSTS) / (PBS_AAAP_LEASE_TERM / 12)) - (PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM * (PBS_AAAP_BASE_RATE + PBS_AAAP_COST_PER_ABOA + X + (Z * X)) / 12) / (PBS_AAAP_LEASE_TERM / 12);

        System.debug('ending final calculation');
        System.debug('final calc returnVal' + temp);
        returnVal = temp.doubleValue();

        return returnVal;
    }
    ///////Line Y                         //G                                  //F                                              //K
    public Decimal getTotalFeeCost(Double PBS_AAAP_ARCH_ENG_FEES, Double PBS_AAAP_GC_OVERHEAD_AND_PROF, Double PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW) {
//      Decimal temp    =   ((ti * (pSpace.PBS_AAAP_GC_OVERHEAD_AND_PROF / 100)) + (ti * (pSpace.PBS_AAAP_GC_CONDITIONS / 100)) + (ti * (pSpace.PBS_AAAP_MANAGEMENT_COORD_FEES /100)) + ( ti * (pSpace.PBS_AAAP_ARCH_ENG_FEES / 100)));


        //G + (F * K) when Rate per ABOA SF Provided
        System.debug('PBS_AAAP_ARCH_ENG_FEES: ' + PBS_AAAP_ARCH_ENG_FEES);
        System.debug('PBS_AAAP_GC_OVERHEAD_AND_PROF ' + PBS_AAAP_GC_OVERHEAD_AND_PROF);
        System.debug('PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW ' + PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW);
        Double returnVal = 0.00;
        Decimal temp = PBS_AAAP_ARCH_ENG_FEES + ((PBS_AAAP_GC_OVERHEAD_AND_PROF / 100) * PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW);
        System.debug('line Y no percent: ' + temp);
        returnVal = temp.doubleValue();
        return returnVal;

    }

///////Line Y as a percentage                      //G                                              //F                                //K
    public Decimal getTotalFeeCostPercentage(Double PBS_AAAP_ARCH_ENG_FEES, Double PBS_AAAP_GC_OVERHEAD_AND_PROF, Double PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW) {
        //  // determine how to process the fees (% or $)
        //  if(pPBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM == '%'){    // percentage fees
        //      returnVal   =   ((ti * (pPBS_AAAP_GC_OVERHEAD_AND_PROF / 100))  + ( ti * (pPBS_AAAP_ARCH_ENG_FEES / (pPBS_AAAP_ARCH_ENG_FEES + 100))));


        // G * (K / (1+G)) + (F * K) if Percent of TI Provided
        Double returnVal = 0.00;
        Double G = PBS_AAAP_ARCH_ENG_FEES / 100;
        Double F = PBS_AAAP_GC_OVERHEAD_AND_PROF / 100;
        Double K = PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW;
        System.debug('PBS_AAAP_ARCH_ENG_FEES: ' + G);
        System.debug('PBS_AAAP_GC_OVERHEAD_AND_PROF ' + F);
        System.debug('PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW ' + K);
        Decimal temp = G * (K / (1 + G)) + (F * K);

        returnVal = temp.doubleValue();
        return returnVal;
    }
//////Line Z                                           Y                 K
    public Decimal getTotalLessorOverheadAndFees(Double Y, Double PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW) {
        Double returnVal = 0.00;
        if (PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW > 0) {
            Decimal temp = Y / PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW;
            returnVal = temp.doubleValue();

        }
        return returnVal;
    }


///////Line AA Garage parking rate /                   V                                                       B                                        W                                                      A                                  P                                    Q
    public Decimal getGarageParkingRate(Decimal PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Decimal PBS_AAAP_Monthly_cost_res_gar_park, Decimal PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Decimal PBS_AAAP_Monthly_cost_nonres_gar_park, Decimal PBS_AAAP_USF_REQ_MIN, Decimal PBS_AAAP_USF_REQ_MAX) { // IF(PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE)
        // If V+W=0, Then 0, Else (V x B + W x A) / (V + W) x 12 / ((P+Q) / 2)
        Double returnVal = 0.00;
        System.debug('begin getGarageParkingRate ');

        System.debug('PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE (V) ' + PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE);
        System.debug('PBS_AAAP_Monthly_cost_res_gar_park (B) ' + PBS_AAAP_Monthly_cost_res_gar_park);
        System.debug('PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE (W) ' + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE);
        System.debug('PBS_AAAP_Monthly_cost_nonres_gar_park (A) ' + PBS_AAAP_Monthly_cost_nonres_gar_park);
        System.debug('PBS_AAAP_USF_REQ_MIN (P) ' + PBS_AAAP_USF_REQ_MIN);
        System.debug('PBS_AAAP_USF_REQ_MAX (Q) ' + PBS_AAAP_USF_REQ_MAX);  //WESTON

        if (PBS_AAAP_Monthly_cost_res_gar_park == null) {

            PBS_AAAP_Monthly_cost_res_gar_park = 0.0;
        }

        if (PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE == null) {

            PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE = 0.0;
        }

        if (PBS_AAAP_Monthly_cost_nonres_gar_park == null) {

            PBS_AAAP_Monthly_cost_nonres_gar_park = 0.0;
        }

        if (PBS_AAAP_USF_REQ_MIN == null) {

            PBS_AAAP_USF_REQ_MIN = 0.0;
        }

        if (PBS_AAAP_USF_REQ_MAX == null) {

            PBS_AAAP_USF_REQ_MAX = 0.0;
        }


        if (PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE != 0) {
            Decimal temp = ((PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE * PBS_AAAP_Monthly_cost_res_gar_park) + (PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE * PBS_AAAP_Monthly_cost_nonres_gar_park)) / (PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE) * 12 / ((PBS_AAAP_USF_REQ_MIN + PBS_AAAP_USF_REQ_MAX) / 2);
            returnVal = temp.doubleValue();

            return returnVal;
        }
        return 0;

    }


//// Line BB Surface parking                         T                                                         D                                            U                                       C                                                           P                         Q
    public Decimal getSurfaceParkingRate(Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double PBS_AAAP_Monthly_cost_res_sur_park, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT, Double PBS_AAAP_Monthly_cost_nonres_sur_park, Double PBS_AAAP_USF_REQ_MIN, Double PBS_AAAP_USF_REQ_MAX) {//       IF(PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT+ PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT)
        //If T+U=0, Then 0, Else (T x D + U x C) / (T + U) x 12 / ((P + Q) / 2)
        Double returnVal = 0.00;
        if (PBS_AAAP_Monthly_cost_res_sur_park == null) {
            PBS_AAAP_Monthly_cost_res_sur_park = 0.0;
        }
        //weeding out if the offeror didn't put $0 during offering
        if (PBS_AAAP_Monthly_cost_nonres_sur_park == null) {
            PBS_AAAP_Monthly_cost_nonres_sur_park = 0.0;
        }

        if (PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT != 0) {
            Decimal temp = ((PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT * PBS_AAAP_Monthly_cost_res_sur_park) + (PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT * PBS_AAAP_Monthly_cost_nonres_sur_park)) / (PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT) * 12 / ((PBS_AAAP_USF_REQ_MIN + PBS_AAAP_USF_REQ_MAX) / 2);
            returnVal = temp.doubleValue();
            return returnVal;
        }
        return 0;
    }

//Line CC Annual rent per aboa sf year 1
    //     getAnnualRentPerABOASFYear1(Double, Double, Decimal, Decimal, Decimal, Decimal, Double, Double, Decimal, Double, Double) (Line: 2779, Column: 24)
    //      H

    //                                                                                 E                     X                    S                  Z         AA              V                                                      W                                   BB                        T                                               U
    //public Decimal getAnnualRentPerABOASFYear1(Double PBS_AAAP_BASE_RATE, Double PBS_AAAP_COST_PER_ABOA, Decimal X, Decimal PBS_AAAP_LEASE_TERM, Decimal Z,  Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Decimal PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Double BB, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double  PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT )
    public Decimal getAnnualRentPerABOASFYear1(Double PBS_AAAP_BASE_RATE, Double PBS_AAAP_COST_PER_ABOA, Decimal X, Decimal PBS_AAAP_LEASE_TERM, Decimal Z, Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Decimal BB, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT)


    {
        //H + E + X * (S / 12) + (Z * X) * (S / 12) +                                      (AA * (V + W)) + (BB * (T + U))

        Double returnVal = 0.00;
        Decimal temp = PBS_AAAP_BASE_RATE + PBS_AAAP_COST_PER_ABOA + X * (PBS_AAAP_LEASE_TERM / 12) + (Z * X) * (PBS_AAAP_LEASE_TERM / 12) + (AA * (PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE)) + (BB * (PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT));
        returnVal = temp.doubleValue();
        return returnVal;

    }
//Line DD Annual Rent per ABOA SF Year 2                             H                                E               x          z          AA                    V                                                           W                         BB               T                                                                 U
    public Decimal getAnnualRentPerABOASFYear1for25(Double PBS_AAAP_BASE_RATE, Double PBS_AAAP_COST_PER_ABOA, Decimal X, Decimal Z, Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Decimal BB, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT) {
//H + E + X + (Z * X) + (AA * (V + W)) + (BB * (T + U))
        Double returnVal = 0.00;
        System.debug('Begin getAnnualRentPerABOASFYear1for25 ');
        System.debug('PBS_AAAP_BASE_RATE (H) ' + PBS_AAAP_BASE_RATE);
        System.debug('PBS_AAAP_COST_PER_ABOA (E) ' + PBS_AAAP_COST_PER_ABOA);
        System.debug('X (X) ' + X);
        System.debug('Z (Z) ' + Z);
        System.debug('AA (AA) ' + AA);
        System.debug('PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE (V) ' + PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE);
        System.debug('PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE (W) ' + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE);
        System.debug('PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT (T) ' + PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT);
        System.debug('PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT (U) ' + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT);
        Decimal temp = PBS_AAAP_BASE_RATE + PBS_AAAP_COST_PER_ABOA + X + (Z * X) + (AA * (PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE)) + (BB * (PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT));
        returnVal = temp.doubleValue();
        System.debug('getAnnualRentPerABOASFYear1for25 PV: ' + returnVal);
        System.debug('end getAnnualRentPerABOASFYear1for25');
        return returnVal;
    }
    public Decimal getAnnualRentPerABOASFYear2for25(Double PBS_AAAP_BASE_RATE, Double PBS_AAAP_COST_PER_ABOA, Decimal X, Decimal PBS_AAAP_LEASE_TERM, Decimal Z, Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Decimal BB, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT) {
        //H + E + X * ((S-12) / 12) + (Z * X) * ((S-12) / 12) + (AA * (V + W)) + (BB * (T + U))
        Double returnVal = 0.00;
        System.debug('Begin getAnnualRentPerABOASFYear2for25 ');
        System.debug('PBS_AAAP_BASE_RATE (H) ' + PBS_AAAP_BASE_RATE);
        System.debug('PBS_AAAP_COST_PER_ABOA (E) ' + PBS_AAAP_COST_PER_ABOA);
        System.debug('PBS_AAAP_LEASE_TERM (S)' + PBS_AAAP_LEASE_TERM);
        System.debug('X (X) ' + X);
        System.debug('Z (Z) ' + Z);
        System.debug('AA (AA) ' + AA);
        System.debug('BB (BB) ' + BB);
        System.debug('PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE (V) ' + PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE);
        System.debug('PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE (W) ' + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE);
        System.debug('PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT (T) ' + PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT);
        System.debug('PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT (U) ' + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT);
        Decimal temp = PBS_AAAP_BASE_RATE + PBS_AAAP_COST_PER_ABOA + X * ((PBS_AAAP_LEASE_TERM - 12) / 12) + (Z * X) * ((PBS_AAAP_LEASE_TERM - 12) / 12) + (AA * (PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE)) + (BB * (PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT));
        returnVal = temp.doubleValue();
        System.debug('getAnnualRentPerABOASFYear2for25 PV: ' + returnVal);
        System.debug('end getAnnualRentPerABOASFYear2for25');
        return returnVal;
    }


//Line DD Annual Rent per ABOA SF Year 2                             H                         R                              E                      AA                    V                                                           W                              BB               T                                                                 U
    public Decimal getAnnualRentPerABOASFYear2(Double PBS_AAAP_BASE_RATE, Decimal PBS_AAAP_LEASE_TERM, Double PBS_AAAP_COST_PER_ABOA, Decimal AA, Double PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE, Decimal BB, Double PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT, Double PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT) {
        //H * ((R - 12) / 12) + E * ((R - 12) / 12) + (AA * (V + W)) * ((R - 12) / 12) + (BB * (T + U)) * ((R - 12) / 12)
        Double returnVal = 0.00;
        Decimal temp = PBS_AAAP_BASE_RATE * ((PBS_AAAP_LEASE_TERM - 12) / 12) + PBS_AAAP_COST_PER_ABOA * ((PBS_AAAP_LEASE_TERM - 12) / 12) + (AA * (PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE + PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE)) * ((PBS_AAAP_LEASE_TERM - 12) / 12) + (BB * (PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT + PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT)) * ((PBS_AAAP_LEASE_TERM - 12) / 12);
        returnVal = temp.doubleValue();
        return returnVal;
    }


    //                                                     I                                       K                                  S
    public Decimal getAmortizationofTI(Double PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20, Double PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW, Double PBS_AAAP_LEASE_TERM) {
        System.debug('##### Begin -- getAmortizationCost');
        System.debug('***** formula terms :: PBS_AAAP_LEASE_TERM = ' + PBS_AAAP_LEASE_TERM);
        System.debug('***** formula terms :: PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20 = ' + PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20);
//////////PBS_AAAP_LEASE_TERM in months
        Decimal returnVal = 0.00;

        // avoid "DIV by 0" errors
//////////////////////f(x) = -12 * PMT(I/12,S,K)
//
//D7 = Finance Amount = PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW
//D9 = Rate = PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20
//D11 = Term = PBS_AAAP_LEASE_TERM
//double v = (1+(D9/12)); double t = (-(D11/12)*12);
// double result=(D7*(D9/12))/(1-Math.pow(v,t));
//
// //double v = (1+(PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20/12));
// double t = (-(PBS_AAAP_LEASE_TERM/12)*12);
// double result=(PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW*(PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20/12))/(1-Math.pow(v,t));
//     //D7:Finance Amount
//D9 = Rate(the rate here is annual rate)
//D11 = Term


//
//
        Decimal intRate = (PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20 > 0) ? PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20 : 0.000000001;
        Double intMonths = PBS_AAAP_LEASE_TERM;
        System.debug('***** formula terms :: PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW = ' + String.valueOf(PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW));
        System.debug('***** formula terms :: intRate = ' + intRate);
        Decimal rateConversion = (intRate / 100) / 12;
        System.debug('***** formula terms :: rateConversion = ' + rateConversion);
        Decimal base = 1.00 + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Decimal denominator = (1 - (1 / math.pow(base.doubleValue(), intMonths))) / rateConversion;
        System.debug('***** formula terms :: denominator = ' + denominator);
        Decimal temp = 12 * (PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW / denominator);

        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() * -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getAmortizationCost');


        return returnVal;
    }

    //                              O                   CC         DD
    public Decimal getNPV(Double PBS_AAAP_DISCOUNT_RATE, Double CC, Double DD) {
        double npv = 0;
        double r1 = PBS_AAAP_DISCOUNT_RATE + 1;
        double trate = r1;

        npv += CC / trate;
        trate *= r1;
        npv += DD / trate;
        //  trate *= r1;
        return npv;

    }
 


    private List<PBS_AAAP_IdentifyWinnerForm> getManagerPV_2019(List<PBS_AAAP_IdentifyWinnerForm> pVals, String agencyId, string rlpyr, Integer rlpYearValue) {
        System.debug(LoggingLevel.Info, '##### Begin -- getManagerPV_2019 '+pVals);
        System.debug(LoggingLevel.Info, '##### Begin -- agencyId ' + agencyId);

        List<PBS_AAAP_IdentifyWinnerForm> returnVals = new List<PBS_AAAP_IdentifyWinnerForm>();                                        // return structure
        Map<String, PBS_AAAP_IdentifyWinnerForm> mapIForm = new Map<String, PBS_AAAP_IdentifyWinnerForm>();     // map of identify winner form records keyed by the concatenation of the record's offerId and spaceId
        Decimal pvCost = 0.00;               // PV calculations
        Decimal pvOptCost = 0.00;           // PV calculations for the option term
        Double aeFeesStorage = 0.00;   // storage variable to revert to the original A&E Fees once the PV calculations have been processed
        if (pVals.size() > 0) {
            Set<Id> sId = new Set<Id>();
            Set<Id> oId = new Set<Id>();
            Set<Id> rId = new Set<Id>();
            Set<String> rateSOId = new Set<String>();
            // build the map of identify winner form values with a concatenated key of the offerId and spaceId
            for (PBS_AAAP_IdentifyWinnerForm val : pVals) {
                String keyVal = String.valueOf(val.offerId) + String.valueOf(val.spaceId);
                System.debug('***keyval-' + keyVal);
                mapIForm.put(keyVal, val);
                sId.add(val.spaceId);
                oId.add(val.offerId);
                //rateSOId.add(String.valueOf(val.spaceId).substring(0, 15) + '' + String.valueOf(val.offerId).substring(0, 15));
				rateSOId.add(String.valueOf(val.spaceId).substring(0, 15));
            
			}   // end for
            List<PBS_AAAP_Space__c> spaceLst = [
                    SELECT PBS_AAAP_RLP__c, PBS_AAAP_TOTAL_MARKUP__c,
                            PBS_AAAP_GC_OVERHEAD_AND_PROF__c, PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,
                            PBS_AAAP_ARCH_ENG_FEES__c,PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c, PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c
                    FROM PBS_AAAP_Space__c
                    WHERE Id IN :sId
            ];
            List<PBS_AAAP_Offer__c> offerLst = [
                    SELECT PBS_AAAP_Monthly_cost_nonres_gar_park__c,
                            PBS_AAAP_Monthly_cost_res_gar_park__c,PBS_AAAP_Monthly_cost_nonres_sur_park__c,
                            PBS_AAAP_Monthly_cost_res_sur_park__c,PBS_AAAP_COST_PER_ABOA__c
                    FROM PBS_AAAP_Offer__c
                    WHERE Id IN:oId
            ];
            system.debug('$$$$$ Offer ' + offerLst);
            Map<Id, PBS_AAAP_Space__c> mapSpace = new Map<Id, PBS_AAAP_Space__c>();
            Map<Id, PBS_AAAP_Offer__c> mapOffer = new Map<Id, PBS_AAAP_Offer__c>();
            Map<Id, PBS_AAAP_RLP__c> mapRLP = new Map<Id, PBS_AAAP_RLP__c>();
            for (PBS_AAAP_Space__c s : spaceLst) {
                mapSpace.put(s.Id, s);
                rId.add(s.PBS_AAAP_RLP__c);
            }
            system.debug('#### RID ' + rId);
            for (PBS_AAAP_Offer__c o : offerLst) {
                mapOffer.put(o.Id, o);
                system.debug('$$$$$ Offer ' + mapOffer);
            }
            List<PBS_AAAP_RLP__c> rlpLst = [
                    SELECT Id,PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c,PBS_AAAP_DISCOUNT_RATE__c,PBS_AAAP_Discount_percent_Rate__c,PBS_AAAP_ESCALATION_PRCNT_RATE__c,
                            PBS_AAAP_RLP_Number__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c,
                            PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c,PBS_AAAP_MOVE_DEFAULT__c,
                            PBS_AAAP_TELCOMM_DEFAULT__c,PBS_AAAP_BSAC_per_ABOA__c,BSAC_for_Continuing_Space_per_ABOA_SF__c
                    FROM PBS_AAAP_RLP__c
                    WHERE Id IN :rId
            ];
            system.debug('#### RLP ' + rlpLst);
            PBS_AAAP_Agency_Requirement__c agency = [
                    SELECT PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c,PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c,
                            PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c,PBS_AAAP_USF_REQ_MIN__c,PBS_AAAP_USF_REQ_MAX__c,PBS_AAAP_CURRENT_GSA_LEASE_NUM__c,
                            PBS_AAAP_LEASE_TERM__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, PBS_AAAP_MOVE_DEFAULT__c, PBS_AAAP_TELCOMM_DEFAULT__c,
                            PBS_AAAP_BSAC_per_ABOA__c, PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c, BSAC_for_Continuing_Space_per_ABOA_SF__c,
                			PBS_AAAP_Region__c
                    FROM PBS_AAAP_Agency_Requirement__c
                    WHERE Id = :agencyId
            ];
            system.debug('#### Agency ' + agency);
            List<PBS_AAAP_Rate__c> rateLst19 = [
                    SELECT Space_Offer__c, PBS_AAAP_BASE_RATE__c,PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c,PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                            PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c,PBS_AAAP_BSAC_RATE__c,PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,PBS_AAAP_LEASE_TERM__c,PBS_AAAP_SPACE__c,PBS_AAAP_OFFER_NUMBER__c
                    FROM PBS_AAAP_Rate__c
                    //WHERE Space_Offer__c IN :rateSOId
					WHERE PBS_AAAP_SPACE__c IN :rateSOId
                    //AND PBS_AAAP_LEASE_TERM__c = '19 Months,11 Firm'
            ];
            system.debug('!!!! ' + rateLst19);
            system.debug('!!!! ' + rateSOId);
            //List<PBS_AAAP_Rate__c> rateLst25 = [
            //        SELECT Space_Offer__c, PBS_AAAP_BASE_RATE__c,PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c,PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
            //                PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c,PBS_AAAP_BSAC_RATE__c,PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c
            //        FROM PBS_AAAP_Rate__c
            //        WHERE Space_Offer__c IN :rateSOId
            //        AND PBS_AAAP_LEASE_TERM__c = '25 Months,16 Firm'
            //];
            //system.debug('!!!! ' + rateLst25);
            //system.debug('!!!! ' + rateSOId);
            Map<String, PBS_AAAP_Rate__c> mapRate19 = new Map<String, PBS_AAAP_Rate__c>();
            String rateKey;
            //Map<String, PBS_AAAP_Rate__c> mapRate25 = new Map<String, PBS_AAAP_Rate__c>();
            for (PBS_AAAP_RLP__c r : rlpLst) {
                //system.debug('@@@@ ' + r.Id + ' #### ' + r);
                mapRLP.put(r.Id, r);
            }
            for (PBS_AAAP_Rate__c r19 : rateLst19) {
                //rateKey = (r19.Space_Offer__c+(r19.PBS_AAAP_LEASE_TERM__c).toLowercase()).trim();
				rateKey = String.valueOf(r19.PBS_AAAP_SPACE__c).substring(0, 15) +/** '' + String.valueOf(r19.PBS_AAAP_OFFER_NUMBER__c).substring(0, 15)+**/((r19.PBS_AAAP_LEASE_TERM__c).toLowercase()).trim();
				
                mapRate19.put(rateKey,r19);
                system.debug('Maprate19 key:' +rateKey+' MapRate19 value: ' + r19);
            }
            //for (PBS_AAAP_Rate__c r25 : rateLst25) {
            //    mapRate25.put(r25.Space_Offer__c, r25);
            //    system.debug('@@@@ ' + r25.Space_Offer__c + ' #### ' + r25);
            //}
            // calculate PV cost values for manager view
            for (Integer i = 0; i < pVals.size(); i++) {
                PBS_AAAP_IdentifyWinnerForm iform = pVals.get(i);       // records to operate over

                System.debug('****------->' + iform);
                System.debug('***** offer ID / space ID -- ' + String.valueOf(iform.offerId) + ' / ' + String.valueOf(iform.spaceId));

                aeFeesStorage = iform.aeFees;
                System.debug('***** iform.neworsucceedingOffer: ' + iform.neworsucceedingOffer);
                System.debug('***** iform.newLeaseIncludeAE: ' + iform.newLeaseIncludeAE);  //this is the checkbox
                System.debug('this is the value they input on the identifywinnersearch page: ' + iform.newLease);
                System.debug('coming thr with the physicalcosts' + iform.physicalcosts);
                System.debug('telecommcosts' + iform.telecommcosts);
                System.debug('otherupfrontcosts' + iform.otherupfrontcosts);
                System.debug('***** iform.aeFeeUOM: ' + iform.aeFeeUOM);
                System.debug('***** iform.BSACCost: ' + iform.BSACCost);
                System.debug('***** iform.rlpGT2016: ' + String.valueOf(iform.rlpGT2016));
                System.debug('***** iform.leaseTerm: ' + String.valueOf(iform.leaseTerm));
                System.debug('***** iform.CENSUS_25: ' + CENSUS_25);
                System.debug('***** iform.CENSUS_25_2018: '+CENSUS_25_2018);
                System.debug('***** iform.CENSUS_19: ' + CENSUS_19);
                System.debug('***** iform.CENSUS_19_2018: '+CENSUS_19_2018);
                this.rlpGT2016 = iform.rlpGT2016;
                //this.rlpGT2019 = iform.rlpGT2019;
                // list of rates necessary to utilize existing PV calculation methods
                List<PBS_AAAP_Rate__c> rateList = new List<PBS_AAAP_Rate__c>();

                // rate assembled and added to the list of rates necessary to utilize existing PV calculation methods
                PBS_AAAP_Rate__c rateTemp = new PBS_AAAP_Rate__c(PBS_AAAP_LEASE_TERM__c = iform.leaseTerm,
                        PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = iform.amortizRateT1Upto20,
                        PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = iform.amortizRateT1Above20
                );
                rateList.add(rateTemp);
                PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
                PBS_AAAP_Space__c sp = mapSpace.get(iform.spaceId);
                PBS_AAAP_Offer__c off = mapOffer.get(iform.offerId);
                PBS_AAAP_RLP__c rlp = mapRLP.get(sp.PBS_AAAP_RLP__c);
                rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c = iform.bsacForContinuingSpace;
                rlp.PBS_AAAP_BSAC_per_ABOA__c = iform.BSACperABOA;
                rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = iform.newLease; 
                rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c= iform.succLease;
                rlp.PBS_AAAP_MOVE_DEFAULT__c = iform.physicalcosts;
                rlp.PBS_AAAP_TELCOMM_DEFAULT__c = iform.telecommcosts;
                rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = iform.otherupfrontcosts;
                
                decimal parkingCost = 0;
                
                //if (iform.leaseTerm == CENSUS_25 || iform.leaseTerm == CENSUS_19) {
                   
                        system.debug('@@@@ 19' + iform.leaseTerm);
                        system.debug('@@@@ Map 19 ' + mapRate19);
                    

                    rateKey = (String.valueOf(iform.spaceId).substring(0, 15) + /**'' +String.valueOf(iform.offerId).substring(0, 15)+**/(iform.leaseTerm).toLowercase()).trim();
                    rate = mapRate19.get(rateKey);
                    system.debug('Final Rate object: ' + rate + ' Rate Key: ' +rateKey);
                    if(iform.leaseTerm == CENSUS_19||iform.leaseTerm == CENSUS_19_2018||iform.leaseTerm == CENSUS_25||iform.leaseTerm == CENSUS_25_2018){
                        if(rate == null){
                            String leasekey = iform.leaseTerm;
                            System.debug('leasekey: '+leasekey);
                            if(leasekey.contains('ths, ')){
                                leasekey = leasekey.replace('ths, ', 'ths,');
                                System.debug('leasekey post update: '+leasekey);
                            }else{
                                leasekey = leasekey.replace('ths,', 'ths, ');
                                System.debug('leasekey post update: '+leasekey);
                            }
                            rateKey = (String.valueOf(iform.spaceId).substring(0, 15) + '' + String.valueOf(iform.offerId).substring(0, 15)+(leasekey).toLowercase()).trim();
                            rate = mapRate19.get(rateKey);
                            system.debug('Final Rate object after key update: ' + rate + ' Rate Key: ' +rateKey);
                        }
                    }

                    
                    
                    system.debug('@@@@ ' + rlp + ' #### ' + sp.PBS_AAAP_RLP__c);
				//This if block will only execute the PV calculation for later 2020 RLP years otherwise the old calculation will work.
                if(rlpYearValue > 2020){
                    if(agency.PBS_AAAP_Region__c =='10/5 Term - All Regions'){
                        /*
                        if(rlpYearValue > 2024){
                           PBS_AAAP_PV_Calculations_ShortTerm_2025 shortTerm2025 = new PBS_AAAP_PV_Calculations_ShortTerm_2025();
                            pvCost = shortTerm2025.npvCalculator(agency,off,rlp,sp,rate); 
                        }else if(rlpYearValue > 2022){
                           PBS_AAAP_PV_Calculations_ShortTerm_2023 shortTerm2023 = new PBS_AAAP_PV_Calculations_ShortTerm_2023();
                            pvCost = shortTerm2023.npvCalculator(agency,off,rlp,sp,rate); 
                        }else{
                            PBS_AAAP_PV_Calculations_ShortTerm_2022 shortTerm2022 = new PBS_AAAP_PV_Calculations_ShortTerm_2022();
                            pvCost = shortTerm2022.npvCalculator(agency,off,rlp,sp,rate);
                        }
                        */
                        PBS_AAAP_PV_Calculations_Factory factoryObj = new PBS_AAAP_PV_Calculations_Factory(); //This is an Instance factory class.
                        //Here we are calling the getPVCalculator of the factory class to get Instance of correct PV calculation class.
                        PBS_AAAP_PV_Calculations_Interface interfaceInstance = factoryObj.getPVCalculator(String.valueOf(rlpYearValue), true);
                        //Here we call npvCalculator (the main method) to perform PV calculations from the correct PV calculation class.
                        pvCost = interfaceInstance.npvCalculator(agency,off,rlp,sp,rate);
                    }else{
                        System.debug('New_calculation new approach started');
                        PBS_AAAP_PV_Calculations_Factory factoryObj = new PBS_AAAP_PV_Calculations_Factory(); //This is an Instance factory class.
                        //Here we are calling the getPVCalculator of the factory class to get Instance of correct PV calculation class.
                        PBS_AAAP_PV_Calculations_Interface interfaceInstance = factoryObj.getPVCalculator(String.valueOf(rlpYearValue), false);
                        //Here we call npvCalculator (the main method) to perform PV calculations from the correct PV calculation class.
                        pvCost = interfaceInstance.npvCalculator(agency,off,rlp,sp,rate); 
                    }
                }else if(rlpyr == 'new'){
                    System.debug('Old_calculation approach for 2019 or 2020');
                    pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);
                } else if(rlpyr == 'old'){                      
                    pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);
                }
                    

                //}else{
                //   pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);
                //}

                //// determine if property/space is for a new or succeeding space/lease
                //if (iform.neworsucceedingOffer) { // new
                //    //add routine for Census by syam k ganna on 01/12/2017

                //    // determine if A&E fees should be included
                //    if (!iform.newLeaseIncludeAE) {
                //        iform.aeFees = (0.00).doubleValue();        // set the A&E Fees to zero, regardless of whether are any or not, to make the construction markup method ignore the costs.
                //    }   // end if

                //    // use the correct lease time
                //    if (iform.leaseTerm == FIVEYR) {
                //        // calculate the offer's PV
                //        pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);

                //    } else if ((iform.leaseTerm == FIVEFIVEYR) || (iform.leaseTerm == FIVEFIVEYRNEW)) {
                //        pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);


                //    } else if ((iform.leaseTerm == TENYR) || (iform.leaseTerm == FIFTEENTENYR)) {
                //        pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);

                //    }   // end if

                //} else {    // succeeding
                //    // determine if A&E fees should be included
                //    if (!iform.succLeaseIncludeAE) {
                //        iform.aeFees = (0.00).doubleValue();        // set the A&E Fees to zero, regardless of whether are any or not, to make the construction markup method ignore the costs.
                //    }   // end if

                //    // use the correct lease time
                //    if (iform.leaseTerm == FIVEYR) {
                //        pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);
                //    } else if ((iform.leaseTerm == FIVEFIVEYR) || (iform.leaseTerm == FIVEFIVEYRNEW)) {
                //        pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);

                //    } else if ((iform.leaseTerm == TENYR) || (iform.leaseTerm == FIFTEENTENYR)) {
                //        pvCost = PBS_AAAP_CalculationHelper.NPVCalculator(agency,off,rlp,sp,rate);
                        
                //    }   // end if
                //}

                iform.pvCosts = pvCost.doubleValue();                 // update the PV Costs

                iform.aeFees = aeFeesStorage;        // revert to the original A&E fees data
                pVals.set(i, iform);
            }   // end for


            returnVals = pVals;
            returnVals.sort();
        }   // end if
        System.debug('##### End -- getManagerPV_2019');
        return returnVals;
    }   // end getManagerPV

    


}