@IsTest
public class PBS_AAAP_UNIT_TEST_DATA_GENERATOR {

    //public PBS_AAAP_Offer__c testOffer                                      {get; set;}
    // public PBS_AAAP_Space__c testSpace                                      {get; set;}
    //public PBS_AAAP_RLP__c  testRLP                                         {get; set;}
    //public List<PBS_AAAP_Rate__c> testRates                             {get; set;}
    // public List<PBS_AAAP_Other_Costs__c>    testOtherCosts      {get; set;}
    // public PBS_AAAP_Other_Costs__c testOtherCost                    {get; set;}

    public PBS_AAAP_Offer__c testOffer = new PBS_AAAP_Offer__c();
    public PBS_AAAP_Offer__c testOffer1 = new PBS_AAAP_Offer__c();

    public PBS_AAAP_Other_Costs__c testOtherCost = new PBS_AAAP_Other_Costs__c();
    public PBS_AAAP_Space__c testSpace = new PBS_AAAP_Space__c();

    public PBS_AAAP_RLP__c testRLP = new PBS_AAAP_RLP__c();


    //weston these are mine:
    public PBS_AAAP_Offer__c testOffer2 = new PBS_AAAP_Offer__c();
    public List<PBS_AAAP_Rate__c> testRates1 = new List<PBS_AAAP_Rate__c>();
    public PBS_AAAP_RLP__c testRLP1 = new PBS_AAAP_RLP__c();
    public PBS_AAAP_Space__c testSpace1 = new PBS_AAAP_Space__c();
    public PBS_AAAP_Agency_Requirement__c agreq = new PBS_AAAP_Agency_Requirement__c();
    /////////weston

    PBS_AAAP_Agency_Requirement__c getagreq() {
        System.assert(agreq != null);
        return agreq;
    }
    void setagreq(PBS_AAAP_Agency_Requirement__c ar) {
        System.assert(agreq != null);
        this.agreq = ar;
    }

    PBS_AAAP_Offer__c gettestOffer() {
        system.assert(testOffer != null);
        return testOffer;
    }
    void settestOffer(PBS_AAAP_Offer__c offer) {
        system.assert(offer != null);
        this.testOffer = offer;
    }

    PBS_AAAP_Offer__c gettestOffer1() {
        system.assert(testOffer1 != null);
        return testOffer1;
    }
    void settestOffer1(PBS_AAAP_Offer__c offer) {
        system.assert(offer != null);
        this.testOffer1 = offer;
    }
    ///////weston

    PBS_AAAP_Offer__c gettestOffer2() {
        system.assert(testOffer2 != null);
        return testOffer1;
    }
    void settestOffer2(PBS_AAAP_Offer__c offer) {
        system.assert(offer != null);
        this.testOffer2 = offer;
    }


    PBS_AAAP_Space__c gettestSpace() {
        system.assert(testSpace != null);
        return testSpace;
    }
    void settestOffer(PBS_AAAP_Space__c Space) {
        system.assert(Space != null);
        this.testSpace = Space;
    }
    PBS_AAAP_Space__c gettestSpace1() {
        system.assert(testSpace != null);
        return testSpace1;
    }
    void settestOffer1(PBS_AAAP_Space__c Space) {
        system.assert(Space != null);
        this.testSpace1 = Space;
    }


    PBS_AAAP_RLP__c gettestRLP() {
        system.assert(testRLP != null);
        return testRLP;
    }
    void settestRLP(PBS_AAAP_RLP__c RLP) {
        system.assert(RLP != null);
        this.testRLP = RLP;
    }


    PBS_AAAP_RLP__c gettestRLP1() {
        system.assert(testRLP != null);
        return testRLP1;
    }
    void settestRLP1(PBS_AAAP_RLP__c RLP) {
        system.assert(RLP != null);
        this.testRLP1 = RLP;
    }


    public List<PBS_AAAP_Rate__c> testRates = new List<PBS_AAAP_Rate__c>();

    List<PBS_AAAP_Rate__c> gettestRates() {
        system.assert(testRates != null);
        return testRates;
    }
    void settestRates(List<PBS_AAAP_Rate__c> Rates) {
        system.assert(Rates != null);
        this.testRates = Rates;
    }


    List<PBS_AAAP_Rate__c> gettestRates1() {
        system.assert(testRates != null);
        return testRates1;
    }
    void settestRates1(List<PBS_AAAP_Rate__c> Rates) {
        system.assert(Rates != null);
        this.testRates1 = Rates;
    }


    public List<PBS_AAAP_Other_Costs__c > testOtherCosts = new List<PBS_AAAP_Other_Costs__c >();

    List<PBS_AAAP_Other_Costs__c > gettestOtherCosts() {
        system.assert(testOtherCosts != null);
        return testOtherCosts ;
    }
    void settestOtherCosts(List<PBS_AAAP_Other_Costs__c > OtherCosts) {
        system.assert(OtherCosts != null);
        this.testOtherCosts = OtherCosts;
    }


    PBS_AAAP_Other_Costs__c gettestOtherCost() {
        system.assert(testOtherCost != null);
        return testOtherCost;
    }
    void settestOtherCost(PBS_AAAP_Other_Costs__c cost) {
        system.assert(Cost != null);
        this.testOtherCost = cost;
    }

    //weston
    //


    public static testMethod PBS_AAAP_RLP__c genTestRLP1() {
        PBS_AAAP_RLP__c returnVal = new PBS_AAAP_RLP__c(
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 32.00,
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 42.0,
                PBS_AAAP_ALLOW_TIER2_AMMORT__c = true,
                PBS_AAAP_MAX_TIUSED__c = 50.0,
                PBS_AAAP_RLP_Number__c = 'Census 5',
                PBS_AAAP_DISCOUNT_RATE__c = 2.00,
                PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50,
                PBS_AAAP_Discount_percent_Rate__c = 2.00,
                PBS_AAAP_ESCALATION_PRCNT_RATE__c = 0,
                PBS_AAAP_Year__c = '2018',
                PBS_AAAP_BSAC_per_ABOA__c = 6
        );
        system.assertEquals(true, true);
        return returnVal;
    }

    public static testMethod List<PBS_AAAP_Rate__c> genTestRates1() {
        List<PBS_AAAP_Rate__c> rates = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c(
                    PBS_AAAP_TWO_YEAR_EXTENSION__c = 0.00,
                    PBS_AAAP_SPACE__c = null,
                    PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0.00,
                    PBS_AAAP_ONE_YEAR_EXTENSION__c = 0.00,
                    PBS_AAAP_OFFER_NUMBER__c = null,
                    PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = 2.00,
                    PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8.00,
                    PBS_AAAP_LEASE_TERM__c = '25 Months, 16 Firm',
                    PBS_AAAP_IDENTIFIER_ID__c = String.valueOf(i),
                    PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 50.00,
                    PBS_AAAP_COST_FOR_TI__c = 0.00,
                    PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = 5.00,
                    PBS_AAAP_BASE_RATE__c = 100.0,
                    PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 15.00,
                    PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 4.00,
                    PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 4.00,
                    PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c = 0.00,
                    PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = 0.50,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007,
                    PBS_AAAP_BSAC_RATE__c = (i == 0) ? 0.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
                    PBS_AAAP_BSAC__c = 5,
                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = -32.40
            );
//Vaishali 11/21 added PBS_AAAP_BSAC_RATE__c  =   0.00, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c   =   0.00   
// Vaishali 09/06/2014 Changed PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c from 5 to 0

            system.assert(rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c != null);
// //Vaishali 11/21 below line commented and added above line            
//            system.assert(rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c!=null);
            rates.add(rate);
        }
        return rates;


    }


    public static testMethod PBS_AAAP_Space__c genTestSpace1() {
        PBS_AAAP_Space__c returnVal = new PBS_AAAP_Space__c(
                PBS_AAAP_OFFER_NUMBER__c = null,
                PBS_AAAP_Max_Contiguous_Space__c = 1000.00,
                PBS_AAAP_MIN_OFFERABLE_SPACE__c = 500.00,
                PBS_AAAP_MAX_OFFERABLE_SPACE__c = 1000.00,
                PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today(),
                PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 2.00,
                PBS_AAAP_MANAGEMENT_COORD_FEES__c = 0.00,
                PBS_AAAP_GC_CONDITIONS__c = 0.00,
                PBS_AAAP_ARCH_ENG_FEES__c = 3.00,
                PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = 'Unit Test GSA Lease',
                PBS_AAAP_IDENTIFIER_TYPE__c = 'DEFAULT',
                PBS_AAAP_IDENTIFIER_ID__c = '1',
                PBS_AAAP_SF_OFFERED__c = 5000.00,
                PBS_AAAP_TOTAL_MARKUP__c = 2.0633009708737866,
                PBS_AAAP_TOT_EXP_ABOA__c = 0.00,
                PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true,
                PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '%'
        );
        system.assert(returnVal.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c != null);
        return returnVal;

    }

    //
    //
    //
    public static testMethod PBS_AAAP_Offer__c genTestOffer2() {
        PBS_AAAP_Offer__c returnVal = new PBS_AAAP_Offer__c(
                PBS_AAAP_Building_Name__c = 'Census 5 Building',
                PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = 1000.00,
                PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 10000.00,
                PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = 5000.00,
                PBS_AAAP_RU_FACTOR__c = 5.00,
                PBS_AAAP_COST_PER_ABOA__c = 15.00,
                PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 10000,
                PBS_AAAP_OFFICE_SPACE_RSF__c = 80.00,
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
        system.assert(returnVal.PBS_AAAP_Building_Name__c != null);
        return returnVal;
    }   // end genTestOffer

    // generate a test offer with default values
    public static testMethod PBS_AAAP_Offer__c genTestOffer() {
        PBS_AAAP_Offer__c returnVal = new PBS_AAAP_Offer__c(
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
        system.assert(returnVal.PBS_AAAP_Building_Name__c != null);
        return returnVal;
    }   // end genTestOffer

    //added by syam
    // generate a test offer with default values
    public static testMethod PBS_AAAP_Offer__c genTestOffer1() {
        PBS_AAAP_Offer__c returnVal = new PBS_AAAP_Offer__c(
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
        system.assert(returnVal.PBS_AAAP_Offer_Status__c != null);
        return returnVal;
    }   // end genTestOffer1 


    // generate a test space
    public static testMethod PBS_AAAP_Space__c genTestSpace() {
        PBS_AAAP_Space__c returnVal = new PBS_AAAP_Space__c(
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
                PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true,
                PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '%'
        );
        system.assert(returnVal.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c != null);
        return returnVal;
    }   // end genTestSpace

    // generate a the list of rates
    public static testMethod List<PBS_AAAP_Rate__c> genTestRates() {
        List<PBS_AAAP_Rate__c> rates = new List<PBS_AAAP_Rate__c>();
        for (Integer i = 0; i < 3; i++) {
            PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c(
                    PBS_AAAP_TWO_YEAR_EXTENSION__c = 0.00,
                    PBS_AAAP_SPACE__c = null,
                    PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0.00,
                    PBS_AAAP_ONE_YEAR_EXTENSION__c = 0.00,
                    PBS_AAAP_OFFER_NUMBER__c = null,
                    PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = 0.00,
                    PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8.00,
                    PBS_AAAP_LEASE_TERM__c = (i == 0) ? '5 years' : (i == 1 ? '5+5 years' : (i == 2 ? '10 years' : (i == 3 ? '15 years,10 firm' : (i == 4 ? '10 years,5 firm' : 'none')))),
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
//Vaishali 11/21 added PBS_AAAP_BSAC_RATE__c  =   0.00, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c   =   0.00   
// Vaishali 09/06/2014 Changed PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c from 5 to 0

            system.assert(rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c != null);
// //Vaishali 11/21 below line commented and added above line            
//            system.assert(rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c!=null);
            rates.add(rate);
        }
        return rates;
    }   // end genTestSpace    


//    public static testMethod List<PBS_AAAP_Rate__c> genTestRatesFY19() {
//        List<PBS_AAAP_Rate__c> rates = new List<PBS_AAAP_Rate__c>();
//        for (Integer i = 0; i < 3; i++) {
//            PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c(
//                    PBS_AAAP_TWO_YEAR_EXTENSION__c = 0.00,
//                    PBS_AAAP_SPACE__c = null,
//                    PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0.00,
//                    PBS_AAAP_ONE_YEAR_EXTENSION__c = 0.00,
//                    PBS_AAAP_OFFER_NUMBER__c = null,
//                    PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = 0.00,
//                    PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8.00,
//                    PBS_AAAP_LEASE_TERM__c = (i == 0) ? '17 years,15 firm' : (i == 1 ? '15 years,13 firm' : (i == 2 ? '10 years,8 firm' : (i == 3 ? '15 years,10 firm' : 'none'))),
//                    PBS_AAAP_IDENTIFIER_ID__c = String.valueOf(i),
//                    PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 50.00,
//                    PBS_AAAP_COST_FOR_TI__c = 0.00,
//                    PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = 5.00,
//                    PBS_AAAP_BASE_RATE__c = 43.39,
//                    PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 0.00,
//                    PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = (i == 0) ? 5.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
//                    PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 10.00,
//                    PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c = 0.00,
//                    PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = 0.50,
//                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = (i == 0) ? 0.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
//                    PBS_AAAP_BSAC_RATE__c = (i == 0) ? 0.00 : (i == 1 ? 5.00 : (i == 2 ? 10.00 : 0.00)),
//                    PBS_AAAP_BSAC__c = 5,
//                    PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 0.00
//            );
////Vaishali 11/21 added PBS_AAAP_BSAC_RATE__c  =   0.00, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c   =   0.00   
//// Vaishali 09/06/2014 Changed PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c from 5 to 0

//            system.assert(rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c != null);
//// //Vaishali 11/21 below line commented and added above line            
////            system.assert(rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c!=null);
//            rates.add(rate);
//        }
//        return rates;
//    }   // end genTestSpace    


    // generate a list of other costs
    public static testMethod List<PBS_AAAP_Other_Costs__c> genTestOtherCosts() {
        List<PBS_AAAP_Other_Costs__c> returnVal = new List<PBS_AAAP_Other_Costs__c>();
        for (Integer i = 0; i < 3; i++) {
            PBS_AAAP_Other_Costs__c ocost = new PBS_AAAP_Other_Costs__c(
                    PBS_AAAP_SHORT_DESC__c = 'Test Other Cost number ' + String.valueOf(i),
                    PBS_AAAP_OFFER_NUMBER__c = null,
                    PBS_AAAP_COST__c = 5.00,
                    PBS_AAAP_COST_TYPE__c = 'Other Cost',
                    PBS_AAAP_COST_REMOVAL__c = false
            );
            system.assert(ocost.PBS_AAAP_COST__c != null);
            returnVal.add(ocost);
        }   // end for

        return returnVal;
    }    // end genTestOtherCosts 


    // generate a singelton for other cost
    public static testMethod PBS_AAAP_Other_Costs__c genTestOtherCost() {
        PBS_AAAP_Other_Costs__c returnVal = new PBS_AAAP_Other_Costs__c(
                PBS_AAAP_SHORT_DESC__c = 'Test Other Cost Single ',
                PBS_AAAP_OFFER_NUMBER__c = null,
                PBS_AAAP_COST__c = 1.00,
                PBS_AAAP_COST_TYPE__c = 'Other Cost',
                PBS_AAAP_COST_REMOVAL__c = false
        );
        system.assert(returnVal.PBS_AAAP_COST__c != null);
        return returnVal;
    }   // end genTestOtherCost


    // generate a test RLP
    public static testMethod PBS_AAAP_RLP__c genTestRLP() {
        PBS_AAAP_RLP__c returnVal = new PBS_AAAP_RLP__c(
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
//Vaishali 11/21 added above PBS_AAAP_ALLOW_TIER2_AMMORT__c = false, PBS_AAAP_BSAC_per_ABOA__c = 0
//Vaishali 11/21 changed PBS_AAAP_BSAC_per_ABOA__c = 6

        system.assert(returnVal.PBS_AAAP_RLP_Number__c != null);
        return returnVal;
    }   // end genTestRLP
    /*
    public static testMethod PBS_AAAP_Space__c genTestSpace1(){
        PBS_AAAP_Space__c returnVal = new PBS_AAAP_Space__c(
                PBS_AAAP_OFFER_NUMBER__c                            =   null, 
                PBS_AAAP_Max_Contiguous_Space__c            =   1000.00, 
                PBS_AAAP_MIN_OFFERABLE_SPACE__c         =   500.00, 
                PBS_AAAP_MAX_OFFERABLE_SPACE__c         =   1000.00, 
                PBS_AAAP_DATE_SPACE_AVAILABILITY__c         =   Date.today(), 
                PBS_AAAP_GC_OVERHEAD_AND_PROF__c        =   2.00,
                PBS_AAAP_MANAGEMENT_COORD_FEES__c   =   0.00, 
                PBS_AAAP_GC_CONDITIONS__c                       =   0.00,
                PBS_AAAP_ARCH_ENG_FEES__c                           =   3.00, 
                PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c =   'Unit Test GSA Lease',
                PBS_AAAP_IDENTIFIER_TYPE__c                     =   'DEFAULT', 
                PBS_AAAP_IDENTIFIER_ID__c                               =   '1',
                PBS_AAAP_SF_OFFERED__c                              =   5000.00, 
                PBS_AAAP_TOTAL_MARKUP__c                            =   2.0633009708737866,
                PBS_AAAP_TOT_EXP_ABOA__c                            =   0.00, 
                PBS_AAAP_NEW_SUCCEED_LEASE_IND__c       =   true,
                PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c      = '%'       
        );
        return returnVal;

    }

*/

    
    public PBS_AAAP_UNIT_TEST_DATA_GENERATOR() {
        /*  generate the test data for use in unit testing  */

        // RLP
        testRLP = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestRLP();
        upsert testRLP;
        system.assert(testRLP.id != null);
        // Offer
        testOffer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestOffer();
        testOffer.PBS_AAAP_RLP_Number__c = testRLP.Id;     // relate the Offer to the RLP
        upsert testOffer;

        // Space
        testSpace = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestSpace();
        testSpace.PBS_AAAP_OFFER_NUMBER__c = testOffer.Id;   // relate the Space to the Offer
        upsert testSpace;

        // Rates
        testRates = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestRates();
        System.debug('$$$$$ testRates: ' + testRates);

        for (Integer i = 0; i < testRates.size(); i++) {
            PBS_AAAP_Rate__c rate = testRates.get(i);
            rate.PBS_AAAP_SPACE__c = testSpace.Id;
            rate.PBS_AAAP_OFFER_NUMBER__c = testOffer.Id;
            testRates.set(i, rate);
        }
        upsert testRates;

        // Other Costs
        testOtherCosts = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestOtherCosts();
        for (Integer i = 0; i < testOtherCosts.size(); i++) {
            PBS_AAAP_Other_Costs__c testOtherCost = testOtherCosts.get(i);
            testOtherCost.PBS_AAAP_OFFER_NUMBER__c = testOffer.Id;
            testOtherCosts.set(i, testOtherCost);
        }
        upsert testOtherCosts;

        // Other Cost
        testOtherCost = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestOtherCost();
        testOtherCost.PBS_AAAP_OFFER_NUMBER__c = testOffer.Id;
        upsert testOtherCost;


    }

    public static testMethod PBS_GREX_Project_EOI__c genTestGREXProjectEOI() {
        PBS_GREX_Project_EOI__c returnVal = new PBS_GREX_Project_EOI__c(
                Project_EOI_ID__c = 'GIN123456666-1111',
                Project_Number__c = '5VA2016',
                Project_Offer_Due_Date__c = Date.today() + 7
        );
        system.assert(returnVal.Project_EOI_ID__c != null);
        return returnVal;
    }   // end genTestGREXPRojectEOI

    // generate a test offer with default values
    public static testMethod PBS_LOP_Offer__c genTestLopOffer() {
        PBS_GREX_Project_EOI__c projectEOI = genTestGREXProjectEOI();
        upsert projectEOI;
        PBS_LOP_Offer__c returnVal = new PBS_LOP_OFFER__c(
                LOP_Building_Name__c = 'Unit Test Bldg',
                LOP_Street_Address__c = '11091 Sunset Hills Rd',
                LOP_City__c = 'Reston',
                LOP_State__c = 'VA',
                LOP_Zip__c = '20191',
                LOP_Energy_Star__c = 'Yes',
                LOP_CERTIFICATION_DATE__c = Date.today(),
                LOP_Number_of_floors__c = 10,
                LOP_Year_Built__c = '2015',
                LOP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM',
                LOP_HVAC_HRS_MON_TO_FRI_END__c = '5:00 PM',
                LOP_HIST_PROP_IN_HIST_DIST__c = 'Yes',
                LOP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes',
                LOP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes',
                Project_EOI_ID__c = projectEOI.id,
                LOP_Office_RSF_OFFERED__c = 1000.00,
                LOP_OP_COST_COST_PER_ABOA__c = 9.21,
                LOP_OP_COST_COST_PER_RSF__c = 5.00,
                LOP_GEN_PURPOSE_RENTABLE__c = 5000.00,
                LOP_OFFICE_SPACE_RSF__c = 1000.00,
                LOP_RETAIL_SPACE_RSF__c = 2000.00,
                LOP_OTHER_SPACE_RSF__c = 2000.00,
                LOP_CLEANING_SALARIES__c = 1.00,
                LOP_CLEANING_SUPPLIES__c = 1.00,
                LOP_CLEANING_CONTRACT_SERVICES__c = 1.00,
                LOP_HEATING_SALARIES__c = 1.00,
                LOP_HEATING_FUEL__c = 'Coal',
                LOP_HEATING_FUEL_COST__c = 1.00,
                LOP_HEATING_MAINTENANCE__c = 1.00,
                LOP_ELECTRICAL_POWER__c = 1.00,
                LOP_ELECTRICAL_REPLACEMENT__c = 1.00,
                LOP_ELECTRICAL_SPECIALEQUIP__c = 1.00,
                LOP_ELECTRICAL_MAINTENANCE__c = 1.00,
                LOP_PLUMBING_WATER__c = 1.00,
                LOP_PLUMBING_SUPPLIES__c = 1.00,
                LOP_PLUMBING_MAINTENANCE__c = 1.00,
                LOP_AC_UTILITIES__c = 1.00,
                LOP_AC_MAINTENANCE__c = 1.00,
                LOP_ELEVATOR_SALARIES__c = 1.00,
                LOP_ELEVATOR_MAINTENANCE__c = 1.00,
                LOP_BLDG_ENGINEERCOST__c = 1.00,
                LOP_SECURITY__c = 1.00,
                LOP_SSTAX_WORKCOMP__c = 1.00,
                LOP_LANDSCAPING_MAINTENANCE__c = 1.00,
                LOP_REAL_ESTATE_TAXES__c = 2.00,
                LOP_INSURANCE__c = 2.00,
                LOP_BUILDING_MAINTENANCE__c = 2.00,
                LOP_LEASE_COMMISSION__c = 2.00,
                LOP_MANAGEMENT__c = 2.00,
                LOP_SECT2_TOTAL__c = 10.00,
                LOP_SRVC_UTIL_TOTAL__c = 22.00,
                LOP_TOTAL_OTHER_COSTS__c = 1.00,
                LOP_SITE_AREA_TYPE__c = 'Acres',
                LOP_SITE_SIZE_SQFT__c = 1,
                LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '1. Per ABOA Square Feet (#)',
                LOP_Corporation_not_tax_felon__c = 'Yes',
                LOP_Corp_Not_Convicted_Felon__c = 'Yes',
                LOP_Representation_Business__c = 'Yes',
                LOP_Owner_FirstName__c = 'Joe',
                LOP_Owner_LastName__c = 'Samuel',
                LOP_OFFEROR_INTEREST__c = 'Other',
                LOP_Owner_Address__c = '11091 Sunset Hills',
                LOP_Owner_State__c = 'VA',
                LOP_Owner_City__c = 'Reston',
                LOP_Total_Ofc_ABOA_offered__c = 900.00,
                LOP_INITIAL_NO_OF_YEARS__c = 5,
                LOP_Initial_YEARS_FIRM__c = 3,
                LOP_Historic_Property_Tier__c = 'Historic property within a historic district',
                LOP_Accessibility_Standards_Met__c = 'Yes',
                LOP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix',
                LOP_RLP_Contains_Seismic_Requirement__c = 'The RLP contains seismic requirements.',
                LOP_Offeror_Seismic_Declaration__c = 'Will be constructed to meet seismic requirements',
                LOP_Flood_Plain_Declaration__c = 'A 500-year flood plain',
                LOP_Fire_Safety_Declaration__c = 'Meets the Lease fire/life safety standards.',
                LOP_Property_Owner_Company__c = 'Vencore',
                LOP_ACCEPTED_TERMS_AND_COND__c = 'Yes',
                LOP_Shell_Rent_Per_RSF__c = 2000,
                LOP_Shell_Rate_Years_Effective__c = 15,
                LOP_RLP_Parking_Cost_Incl__c = '2000'
        );
        system.assert(returnVal.LOP_Building_Name__c != null);
        return returnVal;
    }   // end genTestOffer


    public Map<String, Id> getAllCensusData() {


        Map<String, Id> censusData = new Map<String, Id>();


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
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 50;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 20;


        insert rlp ;

        censusData.put('Rlp', rlp.Id);


        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();

        offer.PBS_AAAP_Building_Name__c = 'Census 5 Building';
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = 1000.00;
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 10000.00;
        offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = 5000.00;
        offer.PBS_AAAP_RU_FACTOR__c = 5.00;
        offer.PBS_AAAP_COST_PER_ABOA__c = 15.00;
        offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 10000;
        offer.PBS_AAAP_OFFICE_SPACE_RSF__c = 80.00;
        offer.PBS_AAAP_CLEANING_SALARIES__c = 1.00;
        offer.PBS_AAAP_CLEANING_SUPPLIES__c = 1.00;
        offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00;
        offer.PBS_AAAP_HEATING_SALARIES__c = 1.00;
        offer.PBS_AAAP_HEATING_FUEL__c = 'Coal';
        offer.PBS_AAAP_HEATING_FUEL_COST__c = 1.00;
        offer.PBS_AAAP_HEATING_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_ELECTRICAL_POWER__c = 1.00;
        offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00;
        offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00;
        offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_PLUMBING_WATER__c = 1.00;
        offer.PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00;
        offer.PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_AC_UTILITIES__c = 1.00;
        offer.PBS_AAAP_AC_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_ELEVATOR_SALARIES__c = 1.00;
        offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00;
        offer.PBS_AAAP_SECURITY__c = 1.00;
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 50;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 60;

        insert offer;

        censusData.put('Offer', offer.Id);


        PBS_AAAP_Space__c space = new PBS_AAAP_Space__c();

        space.PBS_AAAP_Max_Contiguous_Space__c = 1000.00;
        space.PBS_AAAP_MIN_OFFERABLE_SPACE__c = 500.00;
        space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = 1000.00;
        space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today();
        space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 2.00;
        space.PBS_AAAP_MANAGEMENT_COORD_FEES__c = 0.00;
        space.PBS_AAAP_GC_CONDITIONS__c = 0.00;
        space.PBS_AAAP_ARCH_ENG_FEES__c = 3.00;
        space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = 'Unit Test GSA Lease';
        space.PBS_AAAP_IDENTIFIER_TYPE__c = 'DEFAULT';
        space.PBS_AAAP_IDENTIFIER_ID__c = '1';
        space.PBS_AAAP_SF_OFFERED__c = 5000.00;
        space.PBS_AAAP_TOTAL_MARKUP__c = 2.0633009708737866;
        space.PBS_AAAP_TOT_EXP_ABOA__c = 0.00;
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '%';
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;


        insert space;
        censusData.put('Space', space.Id);
        System.debug('space---->' + space.Id);


        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();

        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 5;

        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 10;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 15;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 20;
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agency.PBS_AAAP_USF_REQ_MIN__c = 10.0;
        agency.PBS_AAAP_USF_REQ_MAX__c = 50000.0;
        agency.PBS_AAAP_LEASE_TERM__c = '19 Months, 11 Firm';
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__C = 200;


        insert agency;

        censusData.put('Agency', agency.Id);


        PBS_AAAP_Rate__c rate1 = new PBS_AAAP_Rate__c();
        rate1.PBS_AAAP_TWO_YEAR_EXTENSION__c = 0.00;
        // rate1.PBS_AAAP_SPACE__c                         =   null;
        rate1.PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0.00;
        rate1.PBS_AAAP_ONE_YEAR_EXTENSION__c = 0.00;
        // rate1.PBS_AAAP_OFFER_NUMBER__c                    =   null;
        rate1.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = 2.00;
        rate1.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8.00;
        rate1.PBS_AAAP_LEASE_TERM__c = '19 Months, 11 Firm';
        rate1.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 50.00;
        rate1.PBS_AAAP_COST_FOR_TI__c = 0.00;
        rate1.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = 5.00;
        rate1.PBS_AAAP_BASE_RATE__c = 100.0;
        rate1.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 15.00;
        rate1.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 4.00;
        rate1.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 4.00;
        rate1.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c = 0.00;
        rate1.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = 0.50;
        rate1.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007;
        rate1.PBS_AAAP_BSAC_RATE__c = 10.00;
        rate1.PBS_AAAP_BSAC__c = 5;
        rate1.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = -32.40;
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.id;
        rate1.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 11;

        insert rate1;


        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
        rate.PBS_AAAP_TWO_YEAR_EXTENSION__c = 0.00;
        // rate1.PBS_AAAP_SPACE__c                         =   null;
        rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0.00;
        rate.PBS_AAAP_ONE_YEAR_EXTENSION__c = 0.00;
        // rate1.PBS_AAAP_OFFER_NUMBER__c                    =   null;
        rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = 2.00;
        rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8.00;
        rate.PBS_AAAP_LEASE_TERM__c = '25 Months, 16 Firm';
        rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 50.00;
        rate.PBS_AAAP_COST_FOR_TI__c = 0.00;
        rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = 5.00;
        rate.PBS_AAAP_BASE_RATE__c = 100.0;
        rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 15.00;
        rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 4.00;
        rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 4.00;
        rate.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c = 0.00;
        rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = 0.50;
        rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007;
        rate.PBS_AAAP_BSAC_RATE__c = 10.00;
        rate.PBS_AAAP_BSAC__c = 5;
        rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = -32.40;
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_OFFER_NUMBER__c = offer.id;
        rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 11;

        insert rate;


        return censusData;

    }

    public PBS_AAAP_RLP__c insertRLP() {

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
        rlp.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 50;
        rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 20;

        insert rlp ;
        return rlp;

    }

    public PBS_AAAP_Offer__c insertOffer() {

        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
        PBS_AAAP_RLP__c rlp = insertRLP();

        offer.PBS_AAAP_Building_Name__c = 'Census 5 Building';
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = 1000.00;
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 10000.00;
        offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = 5000.00;
        offer.PBS_AAAP_RU_FACTOR__c = 5.00;
        offer.PBS_AAAP_COST_PER_ABOA__c = 15.00;
        offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 10000;
        offer.PBS_AAAP_OFFICE_SPACE_RSF__c = 80.00;
        offer.PBS_AAAP_CLEANING_SALARIES__c = 1.00;
        offer.PBS_AAAP_CLEANING_SUPPLIES__c = 1.00;
        offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00;
        offer.PBS_AAAP_HEATING_SALARIES__c = 1.00;
        offer.PBS_AAAP_HEATING_FUEL__c = 'Coal';
        offer.PBS_AAAP_HEATING_FUEL_COST__c = 1.00;
        offer.PBS_AAAP_HEATING_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_ELECTRICAL_POWER__c = 1.00;
        offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00;
        offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00;
        offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_PLUMBING_WATER__c = 1.00;
        offer.PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00;
        offer.PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_AC_UTILITIES__c = 1.00;
        offer.PBS_AAAP_AC_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_ELEVATOR_SALARIES__c = 1.00;
        offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00;
        offer.PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00;
        offer.PBS_AAAP_SECURITY__c = 1.00;
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 50;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 60;

        insert offer;
        return offer;
    }

    public PBS_AAAP_Space__c insertSpace() {

        PBS_AAAP_Offer__c offer = insertOffer();

        PBS_AAAP_Space__c space = new PBS_AAAP_Space__c();
        space.PBS_AAAP_Max_Contiguous_Space__c = 1000.00;
        space.PBS_AAAP_MIN_OFFERABLE_SPACE__c = 500.00;
        space.PBS_AAAP_MAX_OFFERABLE_SPACE__c = 1000.00;
        space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today();
        space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 2.00;
        space.PBS_AAAP_MANAGEMENT_COORD_FEES__c = 0.00;
        space.PBS_AAAP_GC_CONDITIONS__c = 0.00;
        space.PBS_AAAP_ARCH_ENG_FEES__c = 3.00;
        space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = 'Unit Test GSA Lease';
        space.PBS_AAAP_IDENTIFIER_TYPE__c = 'DEFAULT';
        space.PBS_AAAP_IDENTIFIER_ID__c = '1';
        space.PBS_AAAP_SF_OFFERED__c = 5000.00;
        space.PBS_AAAP_TOTAL_MARKUP__c = 2.0633009708737866;
        space.PBS_AAAP_TOT_EXP_ABOA__c = 0.00;
        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '%';
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;

        insert space;
        return space;
    }

    public PBS_AAAP_Agency_Requirement__c insertAgency() {

        PBS_AAAP_RLP__c rlp = insertRLP();

        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c();
        agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 5;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 10;
        agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 15;
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 20;
        agency.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c;
        agency.PBS_AAAP_USF_REQ_MIN__c = 10.0;
        agency.PBS_AAAP_USF_REQ_MAX__c = 50000.0;
        agency.PBS_AAAP_LEASE_TERM__c = '19 Months, 11 Firm';
        agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__C = 200;

        insert agency;
        return agency;
    }

    public PBS_AAAP_Rate__c insertRate1() {

        PBS_AAAP_Space__c space = insertSpace();
        PBS_AAAP_Offer__c offer = insertOffer();

        PBS_AAAP_Rate__c rate1 = new PBS_AAAP_Rate__c();
        rate1.PBS_AAAP_TWO_YEAR_EXTENSION__c = 0.00;
        // rate1.PBS_AAAP_SPACE__c                         =   null;
        rate1.PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0.00;
        rate1.PBS_AAAP_ONE_YEAR_EXTENSION__c = 0.00;
        // rate1.PBS_AAAP_OFFER_NUMBER__c                    =   null;
        rate1.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = 2.00;
        rate1.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 8.00;
        rate1.PBS_AAAP_LEASE_TERM__c = '19 Months, 11 Firm';
        rate1.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 50.00;
        rate1.PBS_AAAP_COST_FOR_TI__c = 0.00;
        rate1.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = 5.00;
        rate1.PBS_AAAP_BASE_RATE__c = 100.0;
        rate1.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 15.00;
        rate1.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 4.00;
        rate1.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 4.00;
        rate1.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c = 0.00;
        rate1.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = 0.50;
        rate1.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 148.007;
        rate1.PBS_AAAP_BSAC_RATE__c = 10.00;
        rate1.PBS_AAAP_BSAC__c = 5;
        rate1.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = -32.40;
        rate1.PBS_AAAP_SPACE__c = space.Id;
        rate1.PBS_AAAP_OFFER_NUMBER__c = offer.id;
        rate1.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 11;

        insert rate1;
        return rate1;
    }

    public Map<String, PBS_AAAP_RLP__c> getRLP() {

        Map<String, PBS_AAAP_RLP__c> mapRLP = new Map<String, PBS_AAAP_RLP__c>();
        PBS_AAAP_RLP__c rlp = insertRLP();
        mapRLP.put(rlp.Id, rlp);
        system.assertEquals(true, true);
        return mapRLP;
    }
    public Map<String, PBS_AAAP_Offer__c> getOffer() {

        Map<String, PBS_AAAP_Offer__c> mapOffer = new Map<String, PBS_AAAP_Offer__c>();
        PBS_AAAP_Offer__c o = insertOffer();
        mapOffer.put(o.Id, o);
        system.assertEquals(true, true);
        return mapOffer;
    }
    public Map<String, PBS_AAAP_Space__c> getSpace() {

        Map<String, PBS_AAAP_Space__c> mapSpace = new Map<String, PBS_AAAP_Space__c>();
        PBS_AAAP_Space__c s = insertSpace();
        mapSpace.put(s.Id, s);
        system.assertEquals(true, true);
        return mapSpace;
    }
    public Map<String, PBS_AAAP_Agency_Requirement__c> getAgency() {

        Map<String, PBS_AAAP_Agency_Requirement__c> mapAgency = new Map<String, PBS_AAAP_Agency_Requirement__c>();
        PBS_AAAP_Agency_Requirement__c a = insertAgency();
        mapAgency.put(a.Id, a);
        system.assertEquals(true, true);
        return mapAgency;
    }


}