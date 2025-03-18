//public with sharing class PBS_LOP_OfferForm1364Controller extends PBS_AAAP_PageBaseController {
public class PBS_LOP_OfferForm1364Controller extends PBS_AAAP_PageBaseController {
    private static final String NOTAPPLICABLE = 'N/A';
    private static final String NOTSELECTED_INDICATOR = '  ';
    private static final String SELECTED_INDICATOR = 'X';

    public PBS_AAAP_Offer__c offer { get; set; }
    public PBS_AAAP_Offer__c lopoffer { get; set; }
    public PBS_AAAP_RLP__c rlp { get; set; }
    public User userdetail { get; set; }
    public static final String SEE_RATE_STRUCT = 'See Rate Structure';
    public static final String N_A = NOTAPPLICABLE;

    //public List<PBS_AAAP_Other_Costs__c> othercosts {get;set;}
    public ID offerId { get; set; }
    public integer yearBuilt { get; set; }
    public string formtype { get; set; }
    public boolean isLOP { get; set; }
    public string RLPNumber { get; set; }
    public String sysDate { get; set; }
    public string xownerType { get; set; }
    public string legalAgentType { get; set; }
    public string userName { get; set; }
    public string offerCreatedBy { get; set; }

    public string ANSIBOMA { get; set; }
    public integer buildingAge { get; set; }
    public string address { get; set; }
    public string city { get; set; }
    public string state { get; set; }
    public string zip { get; set; }
    public string buildingName { get; set; }
    public string renovationYr { get; set; }
    public decimal reqSurface { get; set; }
    public decimal reqStructured { get; set; }
    public string visitorSurface { get; set; }
    public string visitorGarage { get; set; }
    public string govSurface { get; set; }
    public string govGarage { get; set; }
    public string HVACwkStart { get; set; }
    public string HVACwkEnd { get; set; }
    public string HVACsatStart { get; set; }
    public string HVACsatEnd { get; set; }
    public string HVACsunStart { get; set; }
    public string HVACsunEnd { get; set; }

    public string ownerName { get; set; }
    public string ownerAddress { get; set; }
    public string ownerCity { get; set; }
    public string ownerState { get; set; }
    public string ownerZip { get; set; }
    public string dunsNumber { get; set; }

    public string propAgent { get; set; }
    public string propOwner { get; set; }
    public string propOther { get; set; }

    public string histPropHistDist { get; set; }
    public string histPropNHistDist { get; set; }
    public string NhistPropHistDist { get; set; }
    public string NhistPropNHistDist { get; set; }

    public string hubZoneOfferer { get; set; }
    public string energyStarCerified { get; set; }
    public string energyStarNotCerified { get; set; }
    public string energyStarCertDt { get; set; }
    public string energyStarExplanation { get; set; }

    //public integer siteSize { get; set; }
    public decimal liveFloorLoad { get; set; }
    public string liveFloorLoadStr { get; set; }
    public integer noOfFloors { get; set; }
    public String floorsDesc { get; set; }
    public Integer totalSpace { get; set; }
    public integer officeSpace { get; set; }
    public integer warehouseSpace { get; set; }
    public integer otherSpace { get; set; }
    public integer totalParking { get; set; }
    public integer surfParking { get; set; }
    public integer structParking { get; set; }
    public decimal totalRentPerRSF { get; set; }
    public decimal totalRentPerABOA { get; set; }
    public decimal TotalAnnualRent { get; set; }

    public string monthlyCostResSurf { get; set; }
    public string monthlyCostResGar { get; set; }
    public string monthlyCostNonResSurf { get; set; }
    public string monthlyCostNonResGar { get; set; }
    public decimal vacantPremiseAdjustment { get; set; }
    public decimal siteSize { get; set; }
    public decimal siteSizeAcres { get; set; }
    public boolean isValidUser { get; set; }
    public string CAF { get; set; }
    public string class19_21 { get; set; }
    public decimal ansiBomaOffered { get; set; }
    public decimal ansiBomaRentable { get; set; }
//************new variables to tweak form for Traditional and AAAP Begin****************
    public string Text27 { get; set; } public string Text21eNo { get; set; } public string field21eYes { get; set; } public string field21eNo { get; set; }
    public string Text21e { get; set; } public string Text27TI { get; set; } public decimal field12a { get; set; }
    public string field12b { get; set; } public string field12c { get; set; } public string field12d { get; set; }
    public string field12e { get; set; } public string field12f { get; set; } public decimal field13a { get; set; }
    public string field13b { get; set; } public string field13c { get; set; } public string field13d { get; set; }
    public string field13e { get; set; } public string field13f { get; set; } public decimal field14a { get; set; }
    public decimal field15a { get; set; } public decimal field16d { get; set; } public decimal field16e { get; set; }
    public string field16f { get; set; } public decimal field17d { get; set; } public decimal field17e { get; set; }
    public string field17f { get; set; } public decimal field18d { get; set; } public decimal field18e { get; set; }
    public string field18f { get; set; } public decimal field19d { get; set; } public string field19e { get; set; }
    public string field19f { get; set; } public decimal field20a1 { get; set; } public decimal field20a2 { get; set; }
    public string field20b1 { get; set; } public string field20b2 { get; set; } public decimal field20c1 { get; set; }
    public decimal field20c2 { get; set; } public string field20d1 { get; set; } public string field20d2 { get; set; }
    public decimal field20e1 { get; set; } public decimal field20e2 { get; set; } public string field20f1 { get; set; }
    public string field20f2 { get; set; } public string field22a { get; set; } public string field22b { get; set; }
    public string field22c { get; set; } public string field23a { get; set; } public string field23b { get; set; }
    public string field23c { get; set; } public string field23d { get; set; } public string field26a { get; set; }
    public string field26b { get; set; } public string field26c1 { get; set; } public string field26c2 { get; set; } public string field27a { get; set; }
    public string field27a1 { get; set; } public string field27a2 { get; set; } public string field27a3 { get; set; }
    public decimal field27a1v { get; set; } public string field27a2v { get; set; } public decimal field27a3v { get; set; }
    public string field27b { get; set; } public string field27c { get; set; } public decimal field28HVACRt { get; set; }
    public string field28HVACzone { get; set; } public string field28HVACfloor { get; set; } public string field28HVACspace { get; set; }
    public string field28HVACZones { get; set; } public string field28HVAC24Hr { get; set; } public string prcntGovOccupancy { get; set; }
    public decimal currentYrTaxes { get; set; } public string fullyAssessedYes { get; set; } public string fullyAssessedNo { get; set; }
    public string multyTaxBillYes { get; set; } public string multyTaxBillNo { get; set; } public decimal totalLandCost { get; set; }
    public string noOfMonthsFreeRentLOP { get; set; } public string noOfMonthsFreeRentAAAP { get; set; } public string additionalRemarks { get; set; }
    public string floodPlainsTitle { get; set; } public string seismicTitle { get; set; } public string seismicFooter { get; set; }
    public string historicFooter { get; set; } public string asbestosFooter { get; set; } public string fireLifeFooter { get; set; }
    public string accessibilityFooter { get; set; } public string floodPlain100Yrs { get; set; } public string floodPlain500Yrs { get; set; }
    public string floodPlainNot { get; set; } public string rlpSeismic { get; set; } public string rlpNotSeismic { get; set; }
    public string asbestosNot { get; set; } public string asbestosStable { get; set; } public string asbestosNotStable { get; set; }
    public string seismicNot { get; set; } public string seismicWill { get; set; } public string seismicWillNot { get; set; }
    public string seismicFull { get; set; } public string accessibilityMet { get; set; } public string accessibilityNot { get; set; }
    public string flsMet { get; set; } public string flsNot { get; set; } public string acceptedTerms { get; set; }
    public string field27cLine2 { get; set; } public string field27cLine3 { get; set; }
    public String surfParkingCost {get; set;}
    public String structParkingCost {get; set;}
    public decimal reducedAdjustment {get; set;}
    public String interestFlag1 {get; set;}
    public String interestFlag2 {get; set;}
    public String interestFlag3 {get; set;}
    public String interestFlag4 {get; set;}
    public String freeRent1 {get;set;}
    public String freeRent2 {get;set;}
    public String freeRent3 {get;set;}
    public String energyNo1 {get;set;}
    public String energyNo2 {get;set;}
    //Rental Concessions changes Julia Kantarovsky 8.27.2020
    public String formField1 {get;set;}
    public String formField2 {get;set;}
    //Rental Concessions changes to here


//************new variables to tweak form for Traditional and AAAP End******************
    public PBS_LOP_OfferForm1364Controller() {
        System.debug('JK running user ' + UserInfo.getUserId());//this is currently guest user


        logConstructorStart('PBS_LOP_OfferForm1364Controller');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        if(!isValidUser()){
            System.debug('JK is not valid user,return');
            return;
        }
        Date currentDate = Date.today();
        formtype = ApexPages.currentPage().getParameters().get('formtype');
        isLOP = true;

        System.debug('UserInfo.UserInfo.getUserRoleId() is ' + UserInfo.getUserRoleId());
        System.debug('UserInfo.getUserType() is ' + UserInfo.getUserType());
        string userType = UserInfo.getUserType();
        List<String> args = new String[]{
                '0', 'number', '<span>#,###.0</span>'
        };
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            
            try {
                if (isLOP) {
                    System.debug('Jk isLOP');
                    lopoffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId); offerCreatedBy = lopoffer.OwnerId;
                } else {
                    System.debug('JK is not LOP');
                    offer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);offerCreatedBy = offer.CREATEDBYID;
                }
            } catch (Exception ex) {
                System.debug('JK exception in 1364');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect Offer ID. Please try again.');
                ApexPages.addMessage(myMsg);
                return;
            }
        }
        //added this condition because it is only applicable for extranet users , intranet users can see the page. extranet users always have portal in the userType
        if (userType.contains('Portal') || test.isRunningTest()) {
            if (offerCreatedBy == UserInfo.getUserId()) {
                isValidUser = true;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
                return;
            }
        } else {
            isValidUser = true;
        }
        if (isLOP) {
            sysDate = (lopoffer.PBS_AAAP_Offer_Submission_Date__c != null) ? (lopoffer.PBS_AAAP_Offer_Submission_Date__c.month() + '-' + lopoffer.PBS_AAAP_Offer_Submission_Date__c.day() + '-' + lopoffer.PBS_AAAP_Offer_Submission_Date__c.year()) : '';
            class19_21 = 'cls_019';
        } else {
            //sysDate = (offer.PBS_AAAP_Offer_Submission_Date__c != null) ? (offer.PBS_AAAP_Offer_Submission_Date__c.month() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.day() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.year()) : '';
            //class19_21 = 'cls_021';
        }
        RLPNumber = isLOP ? lopoffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Project_Number__c : offer.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
        Text27 = isLOP ? '*Block 27 fees only applicable for TI subject to post-award pricing; N/A for turnkey pricing' : SEE_RATE_STRUCT;
        Text21e = isLOP ? 'e. Does the rental rate offered above include RLP-required parking costs?' : 'e. Does the rental rate offered above include RLP-required parking costs?';
        Text21eNo = isLOP ? ' Annual cost per space:   $  _______________ Surface       $ ______________ Structured' : 'Monthly cost per space: $ ________ Reserved surface $ ________ Reserved structured $ ________Non-Reserved surface $ ________Non-Reserved structured';

        field12a = (lopoffer.PBS_AAAP_TI_Total_Build_out_Costs__c).setScale(2);
        field13a = (lopoffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c == null ? 0.00 : lopoffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c).setScale(2);
        field14a = (lopoffer.PBS_AAAP_SHELL_Build_out_Costs__c == null ? 0.00 : lopoffer.PBS_AAAP_SHELL_Build_out_Costs__c).setScale(2);
        field15a = field14a + field13a + field12a;


        //field12a = isLOP ? string.valueOf((lopoffer.PBS_AAAP_TI_Total_Build_out_Costs__c).setScale(2)) : SEE_RATE_STRUCT;
        field12c = isLOP ? string.valueOf((lopoffer.PBS_AAAP_TI_Amorti_Interest_Rate__c == null ? 0.00 : lopoffer.PBS_AAAP_TI_Amorti_Interest_Rate__c).setScale(2)) : SEE_RATE_STRUCT;
        field12b = isLOP ? string.valueOf((lopoffer.PBS_AAAP_TI_Amorization_in_Years__c == null ? 0 : lopoffer.PBS_AAAP_TI_Amorization_in_Years__c)) : SEE_RATE_STRUCT;
        field12d = isLOP ? string.valueOf((lopoffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c).setScale(2)) : SEE_RATE_STRUCT;
        field12e = isLOP ? string.valueOf((lopoffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c).setScale(2)) : SEE_RATE_STRUCT;
        field12f = isLOP ? string.valueOf((lopoffer.PBS_AAAP_TI_Years_Rate_Effective__c == null ? 0 : lopoffer.PBS_AAAP_TI_Years_Rate_Effective__c).setscale(2)) : SEE_RATE_STRUCT;
        //field13a = isLOP ? string.valueOf((lopoffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c == null ? 0.00 : lopoffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c).setScale(2)) : SEE_RATE_STRUCT;
        field13c = isLOP ? string.valueOf((lopoffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c == null ? 0.00 : lopoffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c).setScale(2)) : SEE_RATE_STRUCT;
        field13b = isLOP ? string.valueOf((lopoffer.PBS_AAAP_BSAC_Amorization_in_Years__c == null ? 0 : lopoffer.PBS_AAAP_BSAC_Amorization_in_Years__c)) : SEE_RATE_STRUCT;
        field13d = isLOP ? string.valueOf((lopoffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c).setScale(2)) : SEE_RATE_STRUCT;
        field13e = isLOP ? string.valueOf((lopoffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c).setScale(2)) : SEE_RATE_STRUCT;
        field13f = isLOP ? string.valueOf((lopoffer.PBS_AAAP_BSAC_Years_Rate_Effective__c == null ? 0 : lopoffer.PBS_AAAP_BSAC_Years_Rate_Effective__c).setscale(2)) : SEE_RATE_STRUCT;
        //field14a = isLOP ? string.valueOf((lopoffer.PBS_AAAP_SHELL_Build_out_Costs__c == null ? 0.00 : lopoffer.PBS_AAAP_SHELL_Build_out_Costs__c).setScale(2)) : SEE_RATE_STRUCT;
        //field15a = String.valueOf(Decimal.valueOf(field14a) + Decimal.valueOf(field13a) + Decimal.valueOf(field12a));

        field16d = (lopoffer.PBS_AAAP_Shell_Rent_Per_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_Shell_Rent_Per_RSF__c).setScale(2);
        field16e = (lopoffer.PBS_AAAP_Shell_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_Shell_Rent_Per_ABOA__c).setScale(2);
        field17d = (lopoffer.PBS_AAAP_OP_COST_COST_PER_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_OP_COST_COST_PER_RSF__c).setScale(2);
        field17e = (lopoffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c).setScale(2);

        //field16d = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Shell_Rent_Per_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_Shell_Rent_Per_RSF__c).setScale(2)) : SEE_RATE_STRUCT;
        //field16e = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Shell_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_Shell_Rent_Per_ABOA__c).setScale(2)) : SEE_RATE_STRUCT;
        field16f = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Shell_Rate_Years_Effective__c == null ? 0 : lopoffer.PBS_AAAP_Shell_Rate_Years_Effective__c)) : SEE_RATE_STRUCT;
        //field17d = isLOP ? string.valueOf((lopoffer.PBS_AAAP_OP_COST_COST_PER_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_OP_COST_COST_PER_RSF__c).setScale(2)) : SEE_RATE_STRUCT;
        //field17e = isLOP ? string.valueOf((lopoffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c).setScale(2)) : SEE_RATE_STRUCT;
        //field17f = isLOP ? string.valueOf((lopoffer.LOP_Op_Cost_Years_Effective__c)) : SEE_RATE_STRUCT;
        field22a = isLOP ? string.valueOf((lopoffer.PBS_AAAP_INITIAL_NO_OF_YEARS__c)) : SEE_RATE_STRUCT;
        field22b = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Initial_YEARS_FIRM__c)) : SEE_RATE_STRUCT;
        field22c = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Initial_Day_Terminate_Lease__c)) : N_A;
        field23a = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Renewal_Shell_Rate__c == null ? 0.00 : lopoffer.PBS_AAAP_Renewal_Shell_Rate__c).setScale(2)) : N_A;
        field23b = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Renewal_YEARS_EACH__c)) : N_A;
        field23c = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Renewal_NO_OF_OPTIONS__c)) : N_A;
        field23d = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Renewal_Days_Exercise_Option__c)) : N_A;
        field26a = isLOP ? string.valueOf((lopoffer.PBS_AAAP_BROKER_TENANT_REP_COMM__c)) : N_A;
        field26b = isLOP ? string.valueOf((lopoffer.PBS_AAAP_BROKER_OWNER_REP_COMM__c)) : N_A;
        field26c1 = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Schedule_Commission_LeaseAward__c)) : N_A;
        field26c2 = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Schedule_Commission_Occupancy__c)) : N_A;
        //List<Integer> tempList = new List<Integer>();
        //tempList.add((lopoffer.LOP_TI_Years_Rate_Effective__c == null ? 0 : lopoffer.LOP_TI_Years_Rate_Effective__c).setscale(2));

        surfParkingCost = String.valueOf(lopOffer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c);
        structParkingCost = String.valueOf(lopOffer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c);
        //field19f =
        noOfMonthsFreeRentAAAP = isLOP ? NOTSELECTED_INDICATOR : SEE_RATE_STRUCT;
        noOfMonthsFreeRentLOP = isLOP ? string.valueOf(lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c) : '';
        
        //Rental Concessions changes from here Julia Kantarovsky 8.27.2020: 
        //Previous code below I am commenting out for now in lieu of new field and new logic
        /*if (lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == 0 || lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == null) {
            freeRent3 = 'X';
            freeRent2 = ' ';
            freeRent1 = ' ';
        } else {
            freeRent1 = 'X';
            freeRent3 = ' ';
            freeRent2 = ' ';
        }*/
        
        System.debug('JK monthsfreefirmterm ' + lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c + ' rentalConcessions ' + lopoffer.PBS_AAAP_Rental_Concessions__c);
         //Row 1 from Matrix. Cannot test because first condition is never null once the user has saved the Rates page, it gets set to zero
        //Removed Rows 1,4, and 7 from the logic. Added firm_term == null to Rows 2,5, and 8 in the condition
        /*if (lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == null && lopoffer.PBS_AAAP_Rental_Concessions__c == null) {
          freeRent1 = ' ';
          freeRent2 = ' ';
          freeRent3 = ' ';
          formField1 = ' ';
          formField2 = ' ';
      }*/
        //Row 2 from Matrix. Passed Dev Test.
        if ((lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == 0 || lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == null) && lopoffer.PBS_AAAP_Rental_Concessions__c == null) {
          freeRent1 = ' ';
          freeRent2 = ' ';
          freeRent3 = 'X';
          formField1 = '0';
          formField2 = ' ';
      }
        //Row 3 from Matrix. Passed Dev Test.
        if (lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c > 0 && lopoffer.PBS_AAAP_Rental_Concessions__c == null) {
          freeRent1 = 'X';
          freeRent2 = ' ';
          freeRent3 = ' ';
          formField1 = noOfMonthsFreeRentLOP;
          formField2 = ' ';
      }
        //Row 4 from Matrix. Cannot test because first condition is never null once the user has saved the Rates page, it gets set to zero
        /*if (lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == null && lopoffer.PBS_AAAP_Rental_Concessions__c == 'Yes') {
            freeRent1 = ' ';
            freeRent2 = 'X';
            freeRent3 = ' ';
            formField1 = ' ';
            formField2 = 'on notes or attachments';
        }*/
        //Row 5 from Matrix. Passed Dev Test.
        if ((lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == 0 || lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == null) && lopoffer.PBS_AAAP_Rental_Concessions__c == 'Yes') {
            freeRent1 = ' ';
            freeRent2 = 'X';
            freeRent3 = ' ';
            formField1 = '0';
            formField2 = 'on notes or attachments.';
        }
        //Row 6 from Matrix. Passed Dev Test.
        if (lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c > 0 && lopoffer.PBS_AAAP_Rental_Concessions__c == 'Yes') {
            freeRent1 = 'X';
            freeRent2 = 'X';
            freeRent3 = ' ';
            formField1 = noOfMonthsFreeRentLOP;
            formField2 = 'on notes or attachments.';
        }
          //Row 7 from Matrix. Cannot test because first condition is never null once the user has saved the Rates page, it gets set to zero
          /*if (lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == null && lopoffer.PBS_AAAP_Rental_Concessions__c == 'No') {
            freeRent1 = ' ';
            freeRent2 = ' ';
            freeRent3 = ' ';
            formField1 = '0';
            formField2 = ' ';
        }*/
          //Row 8 from Matrix. Passed Dev Test.
          if ((lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == 0 || lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == null) && lopoffer.PBS_AAAP_Rental_Concessions__c == 'No') {
            freeRent1 = ' ';
            freeRent2 = ' ';
            freeRent3 = 'X';
            formField1 = '0';
            formField2 = ' ';
        }
          //Row 9 from Matrix. Passed Dev Test.
          if (lopoffer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c > 0 && lopoffer.PBS_AAAP_Rental_Concessions__c == 'No') {
            freeRent1 = 'X';
            freeRent2 = ' ';
            freeRent3 = ' ';
            formField1 = noOfMonthsFreeRentLOP;
            formField2 = ' ';
        }

        
        //Rental Concessions changes to here

        if (isLOP) {
            TotalRentPerRSF = lopoffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c;
            TotalRentPerABOA = lopoffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c;
        }
        field18d = (TotalRentPerRSF).setScale(2);
        field18e = (TotalRentPerABOA).setScale(2);
        Decimal[] myList = new List<Decimal>{
                decimal.valueOf(field12f), decimal.valueOf(field13f), decimal.valueOf(field16f)
        };
        myList.sort();
        field18f = isLOP ? String.valueOf(myList[0]) : SEE_RATE_STRUCT;
        field19f = field18f;
        if (isLOP) {
            TotalAnnualRent = ((lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c) * (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == null ? 0.00 : lopOffer.PBS_AAAP_Office_RSF_OFFERED__c));
            if (TotalAnnualRent != null) {
                TotalAnnualRent = TotalAnnualRent.setScale(2);
            }

        }
        field19d = TotalAnnualRent;

        field20a1 = isLOP ? (lopoffer.PBS_AAAP_Step_1_Rent_Per_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_Step_1_Rent_Per_RSF__c).setScale(2) : null;
        field20a2 = isLOP ? (lopoffer.PBS_AAAP_Step_1_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_Step_1_Rent_Per_ABOA__c).setScale(2) : null;
        field20b1 = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Step_1_Start__c)) : '';
        field20b2 = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Step_1_End__c)) : '';
        field20c1 = isLOP ? (lopoffer.PBS_AAAP_Step_2_Rent_Per_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_Step_2_Rent_Per_RSF__c).setScale(2) : null;
        field20c2 = isLOP ? (lopoffer.PBS_AAAP_Step_2_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_Step_2_Rent_Per_ABOA__c).setScale(2) : null;
        field20d1 = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Step_2_Start__c)) : '';
        field20d2 = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Step_2_End__c)) : '';
        field20e1 = isLOP ? (lopoffer.PBS_AAAP_Step_3_Rent_Per_RSF__c == null ? 0.00 : lopoffer.PBS_AAAP_Step_3_Rent_Per_RSF__c).setScale(2) : null;
        field20e2 = isLOP ? (lopoffer.PBS_AAAP_Step_3_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.PBS_AAAP_Step_3_Rent_Per_ABOA__c).setScale(2) : null;
        field20f1 = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Step_3_Start__c)) : '';
        field20f2 = isLOP ? string.valueOf((lopoffer.PBS_AAAP_Step_3_End__c)) : '';

        ansiBomaOffered = lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c.setScale(2);
        ansiBomaRentable = lopOffer.PBS_AAAP_Office_RSF_OFFERED__c.setScale(2);

        //ansiBomaOffered = isLOP ? string.valueOf(lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) : N_A;
        //ansiBomaRentable = isLOP ? string.valueOf(lopOffer.PBS_AAAP_Office_RSF_OFFERED__c) : N_A;

        address = (isLOP) ? lopoffer.PBS_AAAP_Street_Address__c : offer.PBS_AAAP_Street_Address__c;
        city = (isLOP) ? lopoffer.PBS_AAAP_City__c : offer.PBS_AAAP_City__c;
        state = (isLOP) ? lopoffer.PBS_AAAP_State__c : offer.PBS_AAAP_State__c;
        zip = (isLOP) ? lopoffer.PBS_AAAP_ZipCode__c : offer.PBS_AAAP_ZipCode__c;
        buildingName = (isLOP) ? lopoffer.PBS_AAAP_Building_Name__c : offer.PBS_AAAP_Building_Name__c;
        renovationYr = (isLOP) ? lopoffer.PBS_AAAP_Renovation_Year__c : offer.PBS_AAAP_Renovation_Year__c;
        reqSurface = (isLOP) ? lopoffer.PBS_AAAP_Total_Surf_Park_Space_Offered__c : offer.PBS_AAAP_Total_Surf_Park_Space_Offered__c;
        visitorSurface = (isLOP) ? string.valueOf(lopoffer.PBS_RSAP_Emp_Visitor_Surface_Spaces__c) : N_A;
        visitorGarage = (isLOP) ? string.valueOf(lopoffer.PBS_RSAP_Emp_Visitor_Structured_Spaces__c) : N_A;
        govSurface = (isLOP) ? string.valueOf(lopoffer.PBS_RSAP_GOV_Surface_Spaces__c) : N_A;
        govGarage = (isLOP) ? string.valueOf(lopoffer.PBS_RSAP_GOV_Structured_Spaces__c) : N_A;
        reqStructured = (isLOP) ? lopoffer.PBS_AAAP_Total_Struct_Park_Space_Offered__c : offer.PBS_AAAP_Total_Struct_Park_Space_Offered__c;
        HVACwkStart = (isLOP) ? lopoffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c : offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c;
        HVACwkEnd = (isLOP) ? lopoffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c : offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c;
        HVACsatStart = (isLOP) ? lopoffer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c : offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c;
        HVACsatEnd = (isLOP) ? lopoffer.PBS_AAAP_HVAC_HRS_ON_SAT_END__c : offer.PBS_AAAP_HVAC_HRS_ON_SAT_END__c;
        HVACsunStart = (isLOP) ? lopoffer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c : offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c;
        HVACsunEnd = (isLOP) ? lopoffer.PBS_AAAP_HVAC_HRS_ON_SUN_END__c : offer.PBS_AAAP_HVAC_HRS_ON_SUN_END__c;

        ownerName = (isLOP) ? (lopoffer.PBS_AAAP_Owner_Name__c) : offer.PBS_AAAP_Owner_Name__c;
        ownerAddress = (isLOP) ? lopoffer.PBS_AAAP_Owner_Address__c : offer.PBS_AAAP_Owner_Address__c;
        ownerCity = (isLOP) ? lopoffer.PBS_AAAP_Owner_City__c : offer.PBS_AAAP_Owner_City__c;
        ownerState = (isLOP) ? lopoffer.PBS_AAAP_Owner_State__c : offer.PBS_AAAP_Owner_State__c;
        ownerZip = (isLOP) ? lopoffer.PBS_AAAP_Owner_Zip__c : offer.PBS_AAAP_Owner_Zip__c;
        dunsNumber = (isLOP) ? lopoffer.PBS_AAAP_DUNS_Number__c : offer.PBS_AAAP_DUNS_Number__c;

        interestFlag1 = lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Owner' ? 'X' : '';
        interestFlag2 = lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Agent' ? 'X' : '';
        interestFlag3 = lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other' ? 'X' : '';
        interestFlag4 = lopoffer.PBS_RSAP_Property_Owner_Same_as_Offeror__c == TRUE ? 'X' : '';


        additionalRemarks = (isLOP) ? lopoffer.PBS_AAAP_Offer_Additional_Remarks__c : '';
        //JK before userdetail
        userdetail = [SELECT u.Title, u.Street, u.State, u.PostalCode, u.Phone, u.Name, u.Id, u.Email, u.City, u.Contact.Phone, u.Contact.PBS_AAAP_Alternate_Phone__c FROM User u WHERE u.id = :offerCreatedBy];
        //JK after userdetail
        userName = UserInfo.getName();

        ANSIBOMA = SELECTED_INDICATOR;
        propOwner = NOTSELECTED_INDICATOR;
        propAgent = NOTSELECTED_INDICATOR;
        propOther = NOTSELECTED_INDICATOR;
        histPropHistDist = NOTSELECTED_INDICATOR;
        histPropNHistDist = NOTSELECTED_INDICATOR;
        NhistPropHistDist = NOTSELECTED_INDICATOR;
        NhistPropNHistDist = NOTSELECTED_INDICATOR;
        energyStarCerified = NOTSELECTED_INDICATOR;
        energyStarNotCerified = NOTSELECTED_INDICATOR;
        if (isLOP) {
            lopOffer.PBS_AAAP_Year_Built__c = (lopOffer.PBS_AAAP_Year_Built__c == null) ? '0' : lopOffer.PBS_AAAP_Year_Built__c;
            system.debug('lopOffer.LOP_Year_Built__c=' + lopOffer.PBS_AAAP_Year_Built__c);
        } else {
            //offer.PBS_AAAP_Year_Built__c = (offer.PBS_AAAP_Year_Built__c == null) ? '0' : offer.PBS_AAAP_Year_Built__c;
            system.debug('offer.PBS_AAAP_Year_Built__c=' + offer.PBS_AAAP_Year_Built__c);

        }
        //yearBuilt = (isLOP) ? Integer.valueOf(lopoffer.PBS_RSAP_Year_Built__c) : Integer.valueOf(offer.PBS_AAAP_Year_Built__c);
        //buildingAge = (yearBuilt > 0) ? (currentDate.year() - yearBuilt) : 0;
        buildingAge = (isLOP) ? Integer.valueOf(lopoffer.PBS_RSAP_Year_Built__c) : Integer.valueOf(offer.PBS_AAAP_Year_Built__c);
        if (!isLOP) {
            
        } else {

            //buildingAge = currentDate.year() - yearBuilt;
            if (lopoffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Owner') {
                propOwner = SELECTED_INDICATOR;
            }
            if (lopoffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Agent') {
                propAgent = SELECTED_INDICATOR;
            }
            if (lopoffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other') {
                //propAgent = SELECTED_INDICATOR;
                propOther = lopoffer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
            } // Vaishali 09/21/15 Interest=Other if it is anything other than "Owner"
            // Building numeric data


            //liveFloorLoad = Integer.valueOf(lopoffer.LOP_LIVE_FLOOR_LOAD__c);
            if(lopoffer.PBS_AAAP_LIVE_FLOOR_LOAD__c == NULL || lopoffer.PBS_AAAP_LIVE_FLOOR_LOAD__c == ''){
                liveFloorLoad = null;
            } else if(lopoffer.PBS_AAAP_LIVE_FLOOR_LOAD__c.isNumeric()) {
                liveFloorLoad = Decimal.valueOf(lopoffer.PBS_AAAP_LIVE_FLOOR_LOAD__c);
            } else {
                liveFloorLoadStr = String.valueOf(lopoffer.PBS_AAAP_LIVE_FLOOR_LOAD__c);
            }
            noOfFloors = Integer.valueOf(lopoffer.PBS_AAAP_floors_Suites_in_Offered_Space__c);
            floorsDesc = lopoffer.PBS_AAAP_floors_and_suites_offered__c;
            totalSpace = Integer.valueOf(lopoffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);
            officeSpace = Integer.valueOf(lopoffer.PBS_AAAP_OFFICE_SPACE_RSF__c);
            warehouseSpace = Integer.valueOf(lopoffer.PBS_AAAP_RETAIL_SPACE_RSF__c);
            otherSpace = Integer.valueOf(lopoffer.PBS_AAAP_GARAGE_SPACE_RSF__c);
            structParking = Integer.valueOf(lopoffer.PBS_AAAP_Total_Structured_Parking_Spaces__c);
            surfParking = Integer.valueOf(lopoffer.PBS_AAAP_Total_Surface_Parking_Spaces__c);
            structParking = (structParking == null) ? 0 : structParking;
            surfParking = (surfParking == null) ? 0 : surfParking;
            totalParking = structParking + surfParking ;
            if (lopOffer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c != null) monthlyCostResSurf = String.valueOf((lopOffer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c).setScale(2)) ; else {
                monthlyCostResGar = '0.00';
            }
            if (lopOffer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c != null) monthlyCostResGar = String.valueOf((lopOffer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c).setScale(2)) ; else {
                monthlyCostResGar = '0.00';
            }
            if (lopOffer.PBS_AAAP_RLP_Parking_Cost_Incl__c == 'Yes') {
                field21eYes = SELECTED_INDICATOR;
                field21eNo = '';
            } else {
                field21eYes = '';
                field21eNo = SELECTED_INDICATOR;
            }


            if (lopoffer.PBS_AAAP_Vacant_Premise_Rate__c != null) vacantPremiseAdjustment = (lopoffer.PBS_AAAP_Vacant_Premise_Rate__c).setScale(2) ; else {
                vacantPremiseAdjustment = 0.00;
            }
            if (lopoffer.PBS_AAAP_Adj_for_Reduced_Services_Rate__c != null) reducedAdjustment = (lopoffer.PBS_AAAP_Adj_for_Reduced_Services_Rate__c).setScale(2) ; else {
                reducedAdjustment = 0.00;
            }


            String areaType = lopoffer.PBS_AAAP_SITE_AREA_TYPE__c;
            if (areaType != null && areaType != '') {
                if (areaType == 'Acres') {
                    if (lopoffer.PBS_AAAP_SITE_SIZE_SQFT__c != null) {
                        siteSizeAcres = lopoffer.PBS_AAAP_SITE_SIZE_SQFT__c; // / 43560);
                        System.debug('*** siteSize inside is ' + siteSize);
                    }
                    siteSize = null;
                } else {
                    if (lopoffer.PBS_AAAP_SITE_SIZE_SQFT__c != null) {
                        siteSize = lopoffer.PBS_AAAP_SITE_SIZE_SQFT__c;
                    }
                    siteSizeAcres = null;
                }
            } else {
                //siteSize = NOTAPPLICABLE;
                //siteSizeAcres = NOTAPPLICABLE;
            }

            // Historic Property data

            if (lopoffer.PBS_RSAP_Historical_Property_Description__c == 'Historic property within a historic district') {
                histPropHistDist = SELECTED_INDICATOR;
            }
            if (lopoffer.PBS_RSAP_Historical_Property_Description__c == 'Historic properties outside of historic district') {
                histPropNHistDist = SELECTED_INDICATOR;
            }
            if (lopoffer.PBS_RSAP_Historical_Property_Description__c == 'Non-historic property or underdeveloped site within a historic district') {
                NhistPropHistDist = SELECTED_INDICATOR;
            }
            if (lopoffer.PBS_RSAP_Historical_Property_Description__c == 'Non-historic property') {
                NhistPropNHistDist = SELECTED_INDICATOR;
            }
            // Energy data
            if (lopoffer.PBS_AAAP_Energy_Star__c == 'Yes') {
                energyStarCerified = SELECTED_INDICATOR;
                energyStarNotCerified = NOTSELECTED_INDICATOR;
                if (lopoffer.PBS_AAAP_CERTIFICATION_DATE__c != null) {
                    energyStarCertDt = lopoffer.PBS_AAAP_CERTIFICATION_DATE__c.format();
                }
            } else {
                energyStarNotCerified = SELECTED_INDICATOR;
                energyStarCerified = NOTSELECTED_INDICATOR;
                if ((lopoffer.PBS_AAAP_Energy_Star_Evaluation__c != null) && (lopoffer.PBS_AAAP_Energy_Star_Evaluation__c == 'Yes')) {
                    energyNo2 = SELECTED_INDICATOR;
                    energyNo1 = NOTSELECTED_INDICATOR;
                } else if ((lopoffer.PBS_AAAP_Energy_Star_Evaluation__c != null) && (lopoffer.PBS_AAAP_Energy_Star_Evaluation__c == 'No')) {
                    energyNo1 = SELECTED_INDICATOR;
                    energyNo2 = NOTSELECTED_INDICATOR;
                }
            }


            //Hubzone certification     PBS_AAAP_Representation__c == 'Small Business'
            if (lopoffer.PBS_RSAP_HubZone_Waiver__c == 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference')
                hubZoneOfferer = SELECTED_INDICATOR; else {
                hubZoneOfferer = NOTSELECTED_INDICATOR;
            }
            //FloodPlains
            floodPlain500Yrs = NOTSELECTED_INDICATOR;
            floodPlain100Yrs = NOTSELECTED_INDICATOR;
            floodPlainNot = NOTSELECTED_INDICATOR;
            if (lopoffer.PBS_RSAP_Flood_Plain_Declaration__c == 'in a 500-year flood plain') {
                floodPlain500Yrs = SELECTED_INDICATOR;
            } else if (lopoffer.PBS_RSAP_Flood_Plain_Declaration__c == 'in a base (100-year) flood plain') {
                floodPlain100Yrs = SELECTED_INDICATOR;
            } else {
                floodPlainNot = SELECTED_INDICATOR;
            }
            //Asbestos
            asbestosNot = NOTSELECTED_INDICATOR ;
            asbestosStable = NOTSELECTED_INDICATOR;
            asbestosNotStable = NOTSELECTED_INDICATOR;
            if (lopoffer.PBS_RSAP_Asbestos_Declaration__c == 'Contains ACM not in a stable, solid matrix') {
                asbestosNotStable = SELECTED_INDICATOR;
            } else {
                asbestosNot = SELECTED_INDICATOR;
            }
            //RLP Seismic
            rlpSeismic = NOTSELECTED_INDICATOR;
            rlpNotSeismic = NOTSELECTED_INDICATOR;
            if (lopoffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'Yes') {
                rlpSeismic = SELECTED_INDICATOR;
            } else if (lopoffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'No') {
                rlpNotSeismic = SELECTED_INDICATOR;
            }
            //Seismic
            seismicFull = NOTSELECTED_INDICATOR;
            seismicNot = NOTSELECTED_INDICATOR;
            seismicWill = NOTSELECTED_INDICATOR;
            seismicWillNot = NOTSELECTED_INDICATOR;
            if (lopoffer.PBS_RSAP_Offeror_Seismic_Declaration__c == 'Fully meets seismic requirements or meets an exemption under the RLP') {
                seismicFull = SELECTED_INDICATOR;
            } else if (lopoffer.PBS_RSAP_Offeror_Seismic_Declaration__c == 'Does not meet seismic requirements, but will be retrofitted to meet seismic requirements') {
                seismicNot = SELECTED_INDICATOR;
            } else if (lopoffer.PBS_RSAP_Offeror_Seismic_Declaration__c == 'Will be constructed to meet seismic requirements') {
                seismicWill = SELECTED_INDICATOR;
            } else if (lopoffer.PBS_RSAP_Offeror_Seismic_Declaration__c == 'Will not meet seismic requirements') {
                seismicWillNot = SELECTED_INDICATOR;
            }

            //Accessibility
            accessibilityMet = NOTSELECTED_INDICATOR;
            accessibilityNot = NOTSELECTED_INDICATOR;
            if (lopoffer.PBS_RSAP_Accessibility_Standards_Met__c == 'Yes') {
                accessibilityMet = SELECTED_INDICATOR;
            } else {
                accessibilityNot = SELECTED_INDICATOR;
            }
            //Fire & Safety
            flsMet = NOTSELECTED_INDICATOR;
            flsNot = NOTSELECTED_INDICATOR;
            if (lopoffer.PBS_AAAP_FIRE_SAFETY_CERT__c == 'Yes') {
                flsMet = SELECTED_INDICATOR;
            } else if (lopoffer.PBS_AAAP_FIRE_SAFETY_CERT__c == 'No') {
                flsNot = SELECTED_INDICATOR;
            }
            //AcceptedTerms
            if (lopoffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == true) {
                acceptedTerms = SELECTED_INDICATOR;
            } else {
                acceptedTerms = NOTSELECTED_INDICATOR;
            }
            field27a1 = ''; field27a2 = ''; field27a3 = '';
            field27a1v = null; field27a2v = ''; field27a3v = null;
            field27b = ''; field27c = ''; field28HVACRt = null;
            field28HVACzone = ''; field28HVACfloor = ''; field28HVACspace = '';
            fullyAssessedYes = ''; fullyAssessedNo = '';
            multyTaxBillYes = ''; multyTaxBillNo = '';
            //Section 3  Questions 27, 28
            field27b = (lopOffer.PBS_AAAP_Lessor_Prj_Fees__c != null) ? String.valueOf(lopOffer.PBS_AAAP_Lessor_Prj_Fees__c) : '';

            //field27c = (lopOffer.PBS_AAAP_Offer_Basis_Of_Fees__c != null) ? (lopOffer.PBS_AAAP_Offer_Basis_Of_Fees__c).left(80) : '';
            //field27cLine2 = (lopOffer.PBS_AAAP_Offer_Basis_Of_Fees__c != null) ? (lopOffer.PBS_AAAP_Offer_Basis_Of_Fees__c).mid(81, 80) : '';
            //field27cLine3 = (lopOffer.PBS_AAAP_Offer_Basis_Of_Fees__c != null) ? (lopOffer.PBS_AAAP_Offer_Basis_Of_Fees__c).mid(161, 100) : '';

            field27c = (lopOffer.PBS_AAAP_Offer_Basis_Of_Fees__c != null) ? (lopOffer.PBS_AAAP_Offer_Basis_Of_Fees__c) : '';

            system.debug('**1364**' + lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c);

            if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == '1. Per ABOA Square Feet ($)') {
                field27a1 = SELECTED_INDICATOR; field27a1v = lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c;
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == '2. Percent of Total Construction Costs (%)') {
                field27a2 = SELECTED_INDICATOR; field27a2v = String.valueOf(lopOffer.PBS_AAAP_Architectural_Fees_Percent__c);
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == '3. Flat Fee ($)') {
                field27a3 = SELECTED_INDICATOR; field27a3v = lopOffer.PBS_AAAP_Architectural_Fees_Flat__c;
            }

            system.debug('**1364**' + field27a1);
            system.debug('**1364**' + field27a1v);
            system.debug('**1364**' + field27a2);
            system.debug('**1364**' + field27a2v);
            system.debug('**1364**' + field27a3);
            system.debug('**1364**' + field27a3v);

            field28HVACZones = (lopOffer.PBS_AAAP_Number_of_zones__c != null) ? String.valueOf(lopOffer.PBS_AAAP_Number_of_zones__c) : '';
            field28HVAC24Hr = (lopOffer.PBS_AAAP_24_HR_HVAC_Cost_Per_ABOA__c != null) ? String.valueOf(lopOffer.PBS_AAAP_24_HR_HVAC_Cost_Per_ABOA__c) : '';
            field28HVACRt = (lopOffer.PBS_AAAP_HVAC_OT_Rate__c != null) ? lopOffer.PBS_AAAP_HVAC_OT_Rate__c : null;

            prcntGovOccupancy = (lopOffer.PBS_AAAP_Government_Occupancy_Percentage__c != null) ? String.valueOf((lopOffer.PBS_AAAP_Government_Occupancy_Percentage__c).setScale(2)) : '';
            currentYrTaxes = (lopOffer.PBS_AAAP_Current_Year_Taxes_1364_28__c != null) ? lopOffer.PBS_AAAP_Current_Year_Taxes_1364_28__c.setScale(2) : 0.00;
            totalLandCost = (lopOffer.PBS_AAAP_Total_Land_Cost__c != null) ? (lopOffer.PBS_AAAP_Total_Land_Cost__c).setScale(2) : null;

            if (lopOffer.PBS_AAAP_Taxes_Fully_Assessed_Value__c == 'Yes') {
                fullyAssessedYes = 'X';
            } else if (lopOffer.PBS_AAAP_Taxes_Fully_Assessed_Value__c == 'No') {
                fullyAssessedNo = 'X';
            }

            if (lopOffer.PBS_AAAP_HVAC_OT_Rate_Type__c == 'Per Zone') {
                field28HVACzone = SELECTED_INDICATOR;
            } else if (lopOffer.PBS_AAAP_HVAC_OT_Rate_Type__c == 'Per Floor') {
                field28HVACfloor = SELECTED_INDICATOR;
            } else if (lopOffer.PBS_AAAP_HVAC_OT_Rate_Type__c == 'Per Space') {
                field28HVACspace = SELECTED_INDICATOR;
            }

            if (lopOffer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c == 'Yes') {
                multyTaxBillYes = 'X';
            } else if (lopOffer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c == 'No') {
                multyTaxBillNo = 'X';
            }


            //Section 3  Questions 27, 28
            //flsNot =lopoffer.LOP_Offeror_FLS_Declaration__c;
            //CAF
            if (lopoffer.PBS_AAAP_Common_Area_Factor__c > 0)
                CAF = String.valueOf((lopoffer.PBS_AAAP_Common_Area_Factor__c).setScale(2)); else {
                CAF = NOTAPPLICABLE;
            }
        }
        logConstructorEnd('PBS_LOP_OfferForm1364Controller');

    }
    
    string fetchOfferKey(){
        string ofId = getQueryParamAsString('offerId');
        System.debug('JK ofId ' + ofId);
        System.debug('JK current user ' + UserInfo.getUserId());
        //JK added try catch block. needs to just return the query.
        //try{
        List<PBS_AAAP_Offer__c> test = [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId];
        System.debug('JK test ' + test.size());
        //return 'teststring';
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_Key__c;
        /*} catch(exception e) {
            return 'teststring';
        }*/
    }
    
    boolean isValidUser(){
        //return true;
        // getting session id
        string paramSessionKey = getQueryParamAsString('sesid');
        System.debug('JK paramSessionKey browser ' + paramSessionKey);
        string sessionOfferKey = fetchOfferKey();
        //System.debug('JK sessionOfferKey ' + sessionOfferKey);
        if(UserInfo.getUserType() == 'Standard'){
            System.debug('JK is true');
            return true;
        }
        else if(paramSessionKey != sessionOfferKey
                || string.isBlank(sessionOfferKey)
                || string.isBlank(paramSessionKey))
        {
            System.debug('JK is false');
            return false;
        } else {
            System.debug('JK final else');
            return true;
        }
    }
    
    public pageReference isValidUserAction(){
        if(!isValidUser()){
            return new pageReference('/apex/GenricErrorPage?errormessage=Not Authorized to see this page');
        }
        return null;
    }
}