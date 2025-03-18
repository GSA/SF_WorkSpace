//public with sharing class PBS_AAAP_OfferForm1364Controller extends PBS_AAAP_PageBaseController {//JK removed 12.1.2020
public class PBS_AAAP_OfferForm1364Controller extends PBS_AAAP_PageBaseController {
    private static final String NOTAPPLICABLE = 'N/A';
    private static final String NOTSELECTED_INDICATOR = '  ';
    private static final String SELECTED_INDICATOR = 'X';

    public PBS_AAAP_Offer__c offer { get; set; }
    public PBS_LOP_Offer__c lopoffer { get; set; }
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

    //public integer liveFloorLoad { get; set; }
    public String liveFloorLoad { get; set; }
    public integer noOfFloors { get; set; }
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
    public string vacantPremiseAdjustment { get; set; }
    public string siteSize { get; set; }
    public string siteSizeAcres { get; set; }
    public boolean isValidUser { get; set; }
    public string CAF { get; set; }
    public string class19_21 { get; set; }
    public string ansiBomaOffered { get; set; }
    public string ansiBomaRentable { get; set; }
//************new variables to tweak form for Traditional and AAAP Begin****************
    public string Text27 { get; set; } public string Text21eNo { get; set; } public string field21eYes { get; set; } public string field21eNo { get; set; }
    public string Text21e { get; set; } public string Text27TI { get; set; } public string field12a { get; set; }
    public string field12b { get; set; } public string field12c { get; set; } public string field12d { get; set; }
    public string field12e { get; set; } public string field12f { get; set; } public string field13a { get; set; }
    public string field13b { get; set; } public string field13c { get; set; } public string field13d { get; set; }
    public string field13e { get; set; } public string field13f { get; set; } public string field14a { get; set; }
    public string field15a { get; set; } public string field16d { get; set; } public string field16e { get; set; }
    public string field16f { get; set; } public string field17d { get; set; } public string field17e { get; set; }
    public string field17f { get; set; } public string field18d { get; set; } public string field18e { get; set; }
    public string field18f { get; set; } public string field19d { get; set; } public string field19e { get; set; }
    public string field19f { get; set; } public string field20a1 { get; set; } public string field20a2 { get; set; }
    public string field20b1 { get; set; } public string field20b2 { get; set; } public string field20c1 { get; set; }
    public string field20c2 { get; set; } public string field20d1 { get; set; } public string field20d2 { get; set; }
    public string field20e1 { get; set; } public string field20e2 { get; set; } public string field20f1 { get; set; }
    public string field20f2 { get; set; } public string field22a { get; set; } public string field22b { get; set; }
    public string field22c { get; set; } public string field23a { get; set; } public string field23b { get; set; }
    public string field23c { get; set; } public string field23d { get; set; } public string field26a { get; set; }
    public string field26b { get; set; } public string field26c1 { get; set; } public string field26c2 { get; set; } public string field27a { get; set; }
    public string field27a1 { get; set; } public string field27a2 { get; set; } public string field27a3 { get; set; }
    public string field27a1v { get; set; } public string field27a2v { get; set; } public string field27a3v { get; set; }
    public string field27b { get; set; } public string field27c { get; set; } public string field28HVACRt { get; set; }
    public string field28HVACzone { get; set; } public string field28HVACfloor { get; set; } public string field28HVACspace { get; set; }
    public string field28HVACZones { get; set; } public string field28HVAC24Hr { get; set; } public string prcntGovOccupancy { get; set; }
    public string currentYrTaxes { get; set; } public string fullyAssessedYes { get; set; } public string fullyAssessedNo { get; set; }
    public string multyTaxBillYes { get; set; } public string multyTaxBillNo { get; set; } public string totalLandCost { get; set; }
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

//************new variables to tweak form for Traditional and AAAP End******************
    public PBS_AAAP_OfferForm1364Controller() {
         if(UserInfo.getUserType() == 'Guest'){ 
            if(!isValidUser()){ 
                return; 
            }   
        }
        logConstructorStart('PBS_AAAP_OfferForm1364Controller');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        Date currentDate = Date.today();
        formtype = ApexPages.currentPage().getParameters().get('formtype');
        isLOP = (formType == 'LOP') ? true : false;
//Vaishali=12/1/13        userdetail = [Select u.Title, u.Street, u.State, u.PostalCode, u.Phone, u.Name, u.Id, u.Email, u.City,u.UserRole From User u where u.id = :UserInfo.getUserId()];

        //if((UserInfo.UserRole)!='AAAP Customer Portal' )isValidUser = true;
        System.debug('UserInfo.UserInfo.getUserRoleId() is ' + UserInfo.getUserRoleId());
        System.debug('UserInfo.getUserType() is ' + UserInfo.getUserType());
        string userType = UserInfo.getUserType();
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            try {
                if (isLOP) {
                    lopoffer = PBS_AAAP_GlobalConstants.getLOPOfferDetail(offerId); offerCreatedBy = lopoffer.OwnerId;
                } else {
                    offer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);offerCreatedBy = offer.CREATEDBYID;
                }
            } catch (Exception ex) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect Offer ID. Please try again.');
                ApexPages.addMessage(myMsg);
                return;
            }
        }
        //added this condition because it is only applicable for extranet users , intranet users can see the page. extranet users always have portal in the userType
        if (userType.contains('Portal')) {
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
            sysDate = (lopoffer.LOP_Offer_Submission_Date__c != null) ? (lopoffer.LOP_Offer_Submission_Date__c.month() + '-' + lopoffer.LOP_Offer_Submission_Date__c.day() + '-' + lopoffer.LOP_Offer_Submission_Date__c.year()) : '';
            class19_21 = 'cls_019';
        } else {
            sysDate = (offer.PBS_AAAP_Offer_Submission_Date__c != null) ? (offer.PBS_AAAP_Offer_Submission_Date__c.month() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.day() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.year()) : '';
            class19_21 = 'cls_021';
        }
        RLPNumber = isLOP ? lopoffer.Project_Number__c : offer.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
        Text27 = isLOP ? '*Block 27 fees only applicable for TI subject to post-award pricing; N/A for turnkey pricing' : SEE_RATE_STRUCT;
        Text21e = isLOP ? 'e. Does the rental rate offered above include RLP-required parking costs?   [___]  Yes   [___]  No  --------- If NO,  complete the following:                   ' : 'e. What is the monthly amount ($) to be charged for?';
        Text21eNo = isLOP ? ' Annual cost per space:   $  _______________ Surface       $ ______________ Structured' : 'Monthly cost per space: $ ________ Reserved surface $ ________ Reserved structured $ ________Non-Reserved surface $ ________Non-Reserved structured';
        field12a = isLOP ? string.valueOf((lopoffer.LOP_TI_Total_Build_out_Costs__c).setScale(2)) : SEE_RATE_STRUCT;
        field12c = isLOP ? string.valueOf((lopoffer.LOP_TI_Amorti_Interest_Rate__c == null ? 0.00 : lopoffer.LOP_TI_Amorti_Interest_Rate__c).setScale(2)) : SEE_RATE_STRUCT;
        field12b = isLOP ? string.valueOf((lopoffer.LOP_TI_Amorization_in_Years__c == null ? 0.00 : lopoffer.LOP_TI_Amorization_in_Years__c).setScale(2)) : SEE_RATE_STRUCT;
        field12d = isLOP ? string.valueOf((lopoffer.LOP_TI_Annual_Rent_Per_RSF__c == null ? 0.00 : lopoffer.LOP_TI_Annual_Rent_Per_RSF__c).setScale(2)) : SEE_RATE_STRUCT;
        field12e = isLOP ? string.valueOf((lopoffer.LOP_TI_Annual_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.LOP_TI_Annual_Rent_Per_ABOA__c).setScale(2)) : SEE_RATE_STRUCT;
        field12f = isLOP ? string.valueOf((lopoffer.LOP_TI_Years_Rate_Effective__c == null ? 0 : lopoffer.LOP_TI_Years_Rate_Effective__c).setscale(2)) : SEE_RATE_STRUCT;
        field13a = isLOP ? string.valueOf((lopoffer.LOP_BSAC_Total_Build_out_Costs__c == null ? 0.00 : lopoffer.LOP_BSAC_Total_Build_out_Costs__c).setScale(2)) : SEE_RATE_STRUCT;
        field13c = isLOP ? string.valueOf((lopoffer.LOP_BSAC_Amorti_Interest_Rate__c == null ? 0.00 : lopoffer.LOP_BSAC_Amorti_Interest_Rate__c).setScale(2)) : SEE_RATE_STRUCT;
        field13b = isLOP ? string.valueOf((lopoffer.LOP_BSAC_Amorization_in_Years__c == null ? 0.00 : lopoffer.LOP_BSAC_Amorization_in_Years__c).setScale(2)) : SEE_RATE_STRUCT;
        field13d = isLOP ? string.valueOf((lopoffer.LOP_BSAC_Annual_Rent_Per_RSF__c == null ? 0.00 : lopoffer.LOP_BSAC_Annual_Rent_Per_RSF__c).setScale(2)) : SEE_RATE_STRUCT;
        field13e = isLOP ? string.valueOf((lopoffer.LOP_BSAC_Annual_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.LOP_BSAC_Annual_Rent_Per_ABOA__c).setScale(2)) : SEE_RATE_STRUCT;
        field13f = isLOP ? string.valueOf((lopoffer.LOP_BSAC_Years_Rate_Effective__c == null ? 0 : lopoffer.LOP_BSAC_Years_Rate_Effective__c).setscale(2)) : SEE_RATE_STRUCT;
        field14a = isLOP ? string.valueOf((lopoffer.LOP_SHELL_Build_out_Costs__c == null ? 0.00 : lopoffer.LOP_SHELL_Build_out_Costs__c).setScale(2)) : SEE_RATE_STRUCT;
        field15a = isLOP ? string.valueOf((lopoffer.LOP_TOTAL_Build_out_Costs__c == null ? 0.00 : lopoffer.LOP_TOTAL_Build_out_Costs__c).setScale(2)) : SEE_RATE_STRUCT;
        field16d = isLOP ? string.valueOf((lopoffer.LOP_Shell_Rent_Per_RSF__c == null ? 0.00 : lopoffer.LOP_Shell_Rent_Per_RSF__c).setScale(2)) : SEE_RATE_STRUCT;
        field16e = isLOP ? string.valueOf((lopoffer.LOP_Shell_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.LOP_Shell_Rent_Per_ABOA__c).setScale(2)) : SEE_RATE_STRUCT;
        field16f = isLOP ? string.valueOf((lopoffer.LOP_Shell_Rate_Years_Effective__c == null ? 0 : lopoffer.LOP_Shell_Rate_Years_Effective__c)) : SEE_RATE_STRUCT;
        field17d = isLOP ? string.valueOf((lopoffer.LOP_OP_COST_COST_PER_RSF__c == null ? 0.00 : lopoffer.LOP_OP_COST_COST_PER_RSF__c).setScale(2)) : SEE_RATE_STRUCT;
        field17e = isLOP ? string.valueOf((lopoffer.LOP_OP_COST_COST_PER_ABOA__c == null ? 0.00 : lopoffer.LOP_OP_COST_COST_PER_ABOA__c).setScale(2)) : SEE_RATE_STRUCT;
        field17f = isLOP ? string.valueOf((lopoffer.LOP_Op_Cost_Years_Effective__c)) : SEE_RATE_STRUCT;
        field22a = isLOP ? string.valueOf((lopoffer.LOP_INITIAL_NO_OF_YEARS__c)) : SEE_RATE_STRUCT;
        field22b = isLOP ? string.valueOf((lopoffer.LOP_Initial_YEARS_FIRM__c)) : SEE_RATE_STRUCT;
        field22c = isLOP ? string.valueOf((lopoffer.LOP_Initial_No_Of_Days_Terminate_Lease__c)) : N_A;
        field23a = isLOP ? string.valueOf((lopoffer.LOP_Renewal_Shell_Rate__c == null ? 0.00 : lopoffer.LOP_Renewal_Shell_Rate__c).setScale(2)) : N_A;
        field23b = isLOP ? string.valueOf((lopoffer.LOP_Renewal_YEARS_EACH__c)) : N_A;
        field23c = isLOP ? string.valueOf((lopoffer.LOP_Renewal_NO_OF_OPTIONS__c)) : N_A;
        field23d = isLOP ? string.valueOf((lopoffer.LOP_Renewal_No_Of_Days_Exercise_Option__c)) : N_A;
        field26a = isLOP ? string.valueOf((lopoffer.LOP_BROKER_TENANT_REP_COMM__c)) : N_A;
        field26b = isLOP ? string.valueOf((lopoffer.LOP_BROKER_OWNER_REP_COMM__c)) : N_A;
        field26c1 = isLOP ? string.valueOf((lopoffer.LOP_Schedule_Of_Commission_LeaseAward__c)) : N_A;
        field26c2 = isLOP ? string.valueOf((lopoffer.LOP_Schedule_Of_Commission_Occupancy__c)) : N_A;
        noOfMonthsFreeRentAAAP = isLOP ? NOTSELECTED_INDICATOR : SEE_RATE_STRUCT;
        noOfMonthsFreeRentLOP = isLOP ? string.valueOf(lopoffer.LOP_NO_OF_MONTHS_FREE_FIRM_TERM__c) : '';

        if (isLOP) {
            TotalRentPerRSF = lopoffer.LOP_Lease_Annual_Rent_Per_RSF__c == null ? 0.00 : lopoffer.LOP_Lease_Annual_Rent_Per_RSF__c;
            TotalRentPerABOA = lopoffer.LOP_Lease_Annual_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.LOP_Lease_Annual_Rent_Per_ABOA__c;
        }
        field18d = isLOP ? string.valueOf((TotalRentPerRSF).setScale(2)) : SEE_RATE_STRUCT;
        field18e = isLOP ? string.valueOf((TotalRentPerABOA).setScale(2)) : SEE_RATE_STRUCT;
        field18f = isLOP ? N_A : SEE_RATE_STRUCT;

        if (isLOP) {
            TotalAnnualRent = ((lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c == null ? 0.00 : lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c) * (lopOffer.LOP_Office_RSF_OFFERED__c == null ? 0.00 : lopOffer.LOP_Office_RSF_OFFERED__c));
            if (TotalAnnualRent != null) {
                TotalAnnualRent = TotalAnnualRent.setScale(2);
            }

        }
        field19d = isLOP ? string.valueOf(TotalAnnualRent) : SEE_RATE_STRUCT;

        field20a1 = isLOP ? string.valueOf((lopoffer.LOP_Step_1_Rent_Per_RSF__c == null ? 0.00 : lopoffer.LOP_Step_1_Rent_Per_RSF__c).setScale(2)) : '';
        field20a2 = isLOP ? string.valueOf((lopoffer.LOP_Step_1_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.LOP_Step_1_Rent_Per_ABOA__c).setScale(2)) : '';
        field20b1 = isLOP ? string.valueOf((lopoffer.LOP_Step_1_Start__c)) : '';
        field20b2 = isLOP ? string.valueOf((lopoffer.LOP_Step_1_End__c)) : '';
        field20c1 = isLOP ? string.valueOf((lopoffer.LOP_Step_2_Rent_Per_RSF__c == null ? 0.00 : lopoffer.LOP_Step_2_Rent_Per_RSF__c).setScale(2)) : '';
        field20c2 = isLOP ? string.valueOf((lopoffer.LOP_Step_2_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.LOP_Step_2_Rent_Per_ABOA__c).setScale(2)) : '';
        field20d1 = isLOP ? string.valueOf((lopoffer.LOP_Step_2_Start__c)) : '';
        field20d2 = isLOP ? string.valueOf((lopoffer.LOP_Step_2_End__c)) : '';
        field20e1 = isLOP ? string.valueOf((lopoffer.LOP_Step_3_Rent_Per_RSF__c == null ? 0.00 : lopoffer.LOP_Step_3_Rent_Per_RSF__c).setScale(2)) : '';
        field20e2 = isLOP ? string.valueOf((lopoffer.LOP_Step_3_Rent_Per_ABOA__c == null ? 0.00 : lopoffer.LOP_Step_3_Rent_Per_ABOA__c).setScale(2)) : '';
        field20f1 = isLOP ? string.valueOf((lopoffer.LOP_Step_3_Start__c)) : '';
        field20f2 = isLOP ? string.valueOf((lopoffer.LOP_Step_3_End__c)) : '';

        ansiBomaOffered = isLOP ? string.valueOf(lopOffer.LOP_Total_Ofc_ABOA_offered__c) : N_A;
        ansiBomaRentable = isLOP ? string.valueOf(lopOffer.LOP_Office_RSF_OFFERED__c) : N_A;

        address = (isLOP) ? lopoffer.LOP_Street_Address__c : offer.PBS_AAAP_Street_Address__c;
        city = (isLOP) ? lopoffer.LOP_City__c : offer.PBS_AAAP_City__c;
        state = (isLOP) ? lopoffer.LOP_State__c : offer.PBS_AAAP_State__c;
        zip = (isLOP) ? lopoffer.LOP_Zip__c : offer.PBS_AAAP_ZipCode__c;
        buildingName = (isLOP) ? lopoffer.LOP_Building_Name__c : offer.PBS_AAAP_Building_Name__c;
        renovationYr = (isLOP) ? lopoffer.LOP_Renovation_Year__c : offer.PBS_AAAP_Renovation_Year__c;
        reqSurface = (isLOP) ? lopoffer.LOP_Total_Surf_Park_Offered_Per_Code__c : offer.PBS_AAAP_Total_Surf_Park_Space_Offered__c;
        visitorSurface = (isLOP) ? string.valueOf(lopoffer.LOP_Emp_Visitor_Surface_Spaces__c) : N_A;
        visitorGarage = (isLOP) ? string.valueOf(lopoffer.LOP_Emp_Visitor_Structured_Spaces__c) : N_A;
        govSurface = (isLOP) ? string.valueOf(lopoffer.LOP_GOV_Surface_Spaces__c) : N_A;
        govGarage = (isLOP) ? string.valueOf(lopoffer.LOP_GOV_Structured_Spaces__c) : N_A;
        reqStructured = (isLOP) ? lopoffer.LOP_Total_Struct_Park_Offered_Per_Code__c : offer.PBS_AAAP_Total_Struct_Park_Space_Offered__c;
        HVACwkStart = (isLOP) ? lopoffer.LOP_HVAC_HRS_MON_TO_FRI_START__c : offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c;
        HVACwkEnd = (isLOP) ? lopoffer.LOP_HVAC_HRS_MON_TO_FRI_END__c : offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c;
        HVACsatStart = (isLOP) ? lopoffer.LOP_HVAC_HRS_ON_SAT_START__c : offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c;
        HVACsatEnd = (isLOP) ? lopoffer.LOP_HVAC_HRS_ON_SAT_END__c : offer.PBS_AAAP_HVAC_HRS_ON_SAT_END__c;
        HVACsunStart = (isLOP) ? lopoffer.LOP_HVAC_HRS_ON_SUN_START__c : offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c;
        HVACsunEnd = (isLOP) ? lopoffer.LOP_HVAC_HRS_ON_SUN_END__c : offer.PBS_AAAP_HVAC_HRS_ON_SUN_END__c;

        ownerName = (isLOP) ? (lopoffer.LOP_Property_Owner_Company__c) : offer.PBS_AAAP_Owner_Name__c;
        ownerAddress = (isLOP) ? lopoffer.LOP_Owner_Address__c : offer.PBS_AAAP_Owner_Address__c;
        ownerCity = (isLOP) ? lopoffer.LOP_Owner_City__c : offer.PBS_AAAP_Owner_City__c;
        ownerState = (isLOP) ? lopoffer.LOP_Owner_State__c : offer.PBS_AAAP_Owner_State__c;
        ownerZip = (isLOP) ? lopoffer.LOP_Owner_Zip__c : offer.PBS_AAAP_Owner_Zip__c;
        dunsNumber = (isLOP) ? lopoffer.LOP_DUNS_Number__c : offer.PBS_AAAP_DUNS_Number__c;


        additionalRemarks = (isLOP) ? lopoffer.LOP_Offer_Additional_Remarks__c : '';
        userdetail = [SELECT u.Title, u.Street, u.State, u.PostalCode, u.Phone, u.Name, u.Id, u.Email, u.City FROM User u WHERE u.id = :offerCreatedBy];
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
            lopOffer.LOP_Year_Built__c = (lopOffer.LOP_Year_Built__c == null) ? '0' : lopOffer.LOP_Year_Built__c;
            system.debug('lopOffer.LOP_Year_Built__c=' + lopOffer.LOP_Year_Built__c);
        } else {
            offer.PBS_AAAP_Year_Built__c = (offer.PBS_AAAP_Year_Built__c == null) ? '0' : offer.PBS_AAAP_Year_Built__c;
            system.debug('offer.PBS_AAAP_Year_Built__c=' + offer.PBS_AAAP_Year_Built__c);

        }
        yearBuilt = (isLOP) ? Integer.valueOf(lopoffer.LOP_Year_Built__c) : Integer.valueOf(offer.PBS_AAAP_Year_Built__c);
        buildingAge = (yearBuilt > 0) ? (currentDate.year() - yearBuilt) : 0;
        if (!isLOP) {

            field27a1 = ''; field27a2 = ''; field27a3 = '';
            field27a1v = ''; field27a2v = ''; field27a3v = '';
            field27b = ''; field27c = ''; field28HVACRt = SEE_RATE_STRUCT;
            field28HVACzone = ''; field28HVACfloor = ''; field28HVACspace = '';
            field28HVACZones = N_A; field28HVAC24Hr = N_A; prcntGovOccupancy = N_A;
            currentYrTaxes = N_A; fullyAssessedYes = N_A; fullyAssessedNo = '';
            multyTaxBillYes = N_A; multyTaxBillNo = ''; totalLandCost = N_A;
            field27cLine2 = '';field27cLine3 = '';

            if (offer.PBS_AAAP_OFFEROR_INTEREST__c == 'Owner') {
                propOwner = SELECTED_INDICATOR;
            }
            if (offer.PBS_AAAP_OFFEROR_INTEREST__c == 'Agent') {
                propAgent = SELECTED_INDICATOR;
            }
            if (offer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other') {
                propAgent = SELECTED_INDICATOR;
                propOther = offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
            } // Vaishali 09/21/15 Interest=Other if it is anything other than "Owner"
            // Building numeric data


            //liveFloorLoad = Integer.valueOf(offer.PBS_AAAP_LIVE_FLOOR_LOAD__c);
            liveFloorLoad = (offer.PBS_AAAP_LIVE_FLOOR_LOAD__c!= null ? offer.PBS_AAAP_LIVE_FLOOR_LOAD__c : '');
            noOfFloors = Integer.valueOf(offer.PBS_AAAP_Number_of_floors__c);
            officeSpace = Integer.valueOf(offer.PBS_AAAP_OFFICE_SPACE_RSF__c);
            warehouseSpace = Integer.valueOf(offer.PBS_AAAP_RETAIL_SPACE_RSF__c);
            otherSpace = Integer.valueOf(offer.PBS_AAAP_GARAGE_SPACE_RSF__c);
            totalParking = Integer.valueOf(offer.PBS_AAAP_Total_Parking_Spaces__c);
            structParking = Integer.valueOf(offer.PBS_AAAP_Total_Structured_Parking_Spaces__c);
            surfParking = Integer.valueOf(offer.PBS_AAAP_Total_Surface_Parking_Spaces__c);
            if (offer.PBS_AAAP_Monthly_cost_res_gar_park__c != null) monthlyCostResGar = String.valueOf((offer.PBS_AAAP_Monthly_cost_res_gar_park__c).setScale(2)) ; else {
                monthlyCostResGar = '0.00';
            }
            if (offer.PBS_AAAP_Monthly_cost_res_sur_park__c != null) monthlyCostResSurf = String.valueOf((offer.PBS_AAAP_Monthly_cost_res_sur_park__c).setScale(2)) ; else {
                monthlyCostResGar = '0.00';
            }
            if (offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c != null) monthlyCostNonResGar = String.valueOf((offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c).setScale(2)) ; else {
                monthlyCostResGar = '0.00';
            }
            if (offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c != null) monthlyCostNonResSurf = String.valueOf((offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c).setScale(2)); else {
                monthlyCostResGar = '0.00';
            }
            if (offer.PBS_AAAP_Vacant_Premise_Rate__c != null) vacantPremiseAdjustment = String.valueOf((offer.PBS_AAAP_Vacant_Premise_Rate__c).setScale(2)) ; else {
                vacantPremiseAdjustment = '0.00';
            }

            String areaType = offer.PBS_AAAP_SITE_AREA_TYPE__c;
            if (areaType != null && areaType != '') {
                if (areaType == 'Acres') {
                    if (offer.PBS_AAAP_SITE_SIZE_SQFT__c != null) {
                        siteSizeAcres = String.valueOf(offer.PBS_AAAP_SITE_SIZE_SQFT__c / 43560);
                        System.debug('*** siteSize inside is ' + siteSizeAcres);
                    }
                    siteSize = NOTAPPLICABLE;
                } else {
                    if (offer.PBS_AAAP_SITE_SIZE_SQFT__c != null) {
                        siteSize = String.valueOf(Integer.valueOf(offer.PBS_AAAP_SITE_SIZE_SQFT__c));
                    }
                    siteSizeAcres = NOTAPPLICABLE;
                }
            } else {
                siteSize = NOTAPPLICABLE;
                siteSizeAcres = NOTAPPLICABLE;
            }

            // Historic Property data

            if (offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c == 'Yes') {
                histPropHistDist = SELECTED_INDICATOR;
            }
            if (offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c == 'Yes') {
                histPropNHistDist = SELECTED_INDICATOR;
            }
            if (offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c == 'Yes') {
                NhistPropHistDist = SELECTED_INDICATOR;
            }
            if ((offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c == 'No') && (offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c == 'No') && (offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c == 'No')) {
                NhistPropNHistDist = SELECTED_INDICATOR;
            }
            // Energy data
            if (offer.PBS_AAAP_Energy_Star__c == 'Yes') {
                energyStarCerified = SELECTED_INDICATOR;
                energyStarNotCerified = NOTSELECTED_INDICATOR;
                if (offer.PBS_AAAP_CERTIFICATION_DATE__c != null) {
                    energyStarCertDt = offer.PBS_AAAP_CERTIFICATION_DATE__c.format();
                }
            } else {
                energyStarNotCerified = SELECTED_INDICATOR;
                energyStarCerified = NOTSELECTED_INDICATOR;
                if ((offer.PBS_AAAP_Energy_Star_Reason__c != null) && (offer.PBS_AAAP_Energy_Star_Reason__c.length() > 500)) {
                    energyStarExplanation = offer.PBS_AAAP_Energy_Star_Reason__c.substring(0, 500);
                } else {
                    energyStarExplanation = offer.PBS_AAAP_Energy_Star_Reason__c;
                }
            }


            //Hubzone certification     PBS_AAAP_Representation__c == 'Small Business'
            if (offer.PBS_AAAP_HUBZone_SBC_Offeror__c)
                hubZoneOfferer = SELECTED_INDICATOR; else {
                hubZoneOfferer = NOTSELECTED_INDICATOR;
            }
            //CAF
            if (offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > 0)
                CAF = String.valueOf((offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c / offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c).setScale(2)); else {
                CAF = NOTAPPLICABLE;
            }
            if (offer.PBS_AAAP_Offer_Submission_Date__c == null) {
                acceptedTerms = NOTSELECTED_INDICATOR;
            } else {
                acceptedTerms = SELECTED_INDICATOR;
            }


        } else {

            buildingAge = currentDate.year() - yearBuilt;
            if (lopoffer.LOP_OFFEROR_INTEREST__c == 'Owner') {
                propOwner = SELECTED_INDICATOR;
            }
            if (lopoffer.LOP_OFFEROR_INTEREST__c == 'Agent') {
                propAgent = SELECTED_INDICATOR;
            }
            if (lopoffer.LOP_OFFEROR_INTEREST__c == 'Other') {
                propAgent = SELECTED_INDICATOR;
                propOther = lopoffer.LOP_OFFEROR_INTEREST_OTHER__c;
            } // Vaishali 09/21/15 Interest=Other if it is anything other than "Owner"
// Building numeric data


            //liveFloorLoad = Integer.valueOf(lopoffer.LOP_LIVE_FLOOR_LOAD__c);
            liveFloorLoad = String.valueOf(lopoffer.LOP_LIVE_FLOOR_LOAD__c);
            noOfFloors = Integer.valueOf(lopoffer.LOP_Number_of_floors__c);
            officeSpace = Integer.valueOf(lopoffer.LOP_OFFICE_SPACE_RSF__c);
            warehouseSpace = Integer.valueOf(lopoffer.LOP_RETAIL_SPACE_RSF__c);
            otherSpace = Integer.valueOf(lopoffer.LOP_OTHER_SPACE_RSF__c);
            structParking = Integer.valueOf(lopoffer.LOP_Structured_Spaces_Controlled__c);
            surfParking = Integer.valueOf(lopoffer.LOP_Surface_Spaces_Controlled__c);
            structParking = (structParking == null) ? 0 : structParking;
            surfParking = (surfParking == null) ? 0 : surfParking;
            totalParking = structParking + surfParking ;
            if (lopOffer.LOP_SURFACE_PARKING_ANNUAL_COST__c != null) monthlyCostResSurf = String.valueOf((lopOffer.LOP_SURFACE_PARKING_ANNUAL_COST__c).setScale(2)) ; else {
                monthlyCostResGar = '0.00';
            }
            if (lopOffer.LOP_STRUCT_PARKING_ANNUAL_COST__c != null) monthlyCostResGar = String.valueOf((lopOffer.LOP_STRUCT_PARKING_ANNUAL_COST__c).setScale(2)) ; else {
                monthlyCostResGar = '0.00';
            }
            if (lopOffer.LOP_RLP_Parking_Cost_Incl__c == 'Yes') {
                field21eYes = SELECTED_INDICATOR;
                field21eNo = '';
            } else {
                field21eYes = '';
                field21eNo = SELECTED_INDICATOR;
            }


            if (lopoffer.LOP_Vacant_Premise_Rate__c != null) vacantPremiseAdjustment = String.valueOf((lopoffer.LOP_Vacant_Premise_Rate__c).setScale(2)) ; else {
                vacantPremiseAdjustment = '0.00';
            }

            String areaType = lopoffer.LOP_SITE_AREA_TYPE__c;
            if (areaType != null && areaType != '') {
                if (areaType == 'Acres') {
                    if (lopoffer.LOP_SITE_SIZE_SQFT__c != null) {
                        siteSizeAcres = String.valueOf(lopoffer.LOP_SITE_SIZE_SQFT__c / 43560);
                        System.debug('*** siteSize inside is ' + siteSize);
                    }
                    siteSize = NOTAPPLICABLE;
                } else {
                    if (lopoffer.LOP_SITE_SIZE_SQFT__c != null) {
                        siteSize = String.valueOf(Integer.valueOf(lopoffer.LOP_SITE_SIZE_SQFT__c));
                    }
                    siteSizeAcres = NOTAPPLICABLE;
                }
            } else {
                siteSize = NOTAPPLICABLE;
                siteSizeAcres = NOTAPPLICABLE;
            }

// Historic Property data             

            if (lopoffer.LOP_Historic_Property_Tier__c == 'Historic property within a historic district') {
                histPropHistDist = SELECTED_INDICATOR;
            }
            if (lopoffer.LOP_Historic_Property_Tier__c == 'Historic properties outside of historic district') {
                histPropNHistDist = SELECTED_INDICATOR;
            }
            if (lopoffer.LOP_Historic_Property_Tier__c == 'Non-historic property or underdeveloped site within a historic district') {
                NhistPropHistDist = SELECTED_INDICATOR;
            }
            if (lopoffer.LOP_Historic_Property_Tier__c == 'Non-historic property') {
                NhistPropNHistDist = SELECTED_INDICATOR;
            }
// Energy data                
            if (lopoffer.LOP_Energy_Star__c == 'Yes') {
                energyStarCerified = SELECTED_INDICATOR;
                energyStarNotCerified = NOTSELECTED_INDICATOR;
                if (lopoffer.LOP_CERTIFICATION_DATE__c != null) {
                    energyStarCertDt = lopoffer.LOP_CERTIFICATION_DATE__c.format();
                }
            } else {
                energyStarNotCerified = SELECTED_INDICATOR;
                energyStarCerified = NOTSELECTED_INDICATOR;
                if ((lopoffer.LOP_Energy_Star_Reason__c != null) && (lopoffer.LOP_Energy_Star_Reason__c.length() > 500)) {
                    energyStarExplanation = lopoffer.LOP_Energy_Star_Reason__c.substring(0, 500);
                } else {
                    energyStarExplanation = lopoffer.LOP_Energy_Star_Reason__c;
                }
            }


            //Hubzone certification     PBS_AAAP_Representation__c == 'Small Business'
            if (lopoffer.LOP_HUBZone_SBC_Waive_Pref__c)
                hubZoneOfferer = SELECTED_INDICATOR; else {
                hubZoneOfferer = NOTSELECTED_INDICATOR;
            }
            //FloodPlains
            floodPlain500Yrs = NOTSELECTED_INDICATOR;
            floodPlain100Yrs = NOTSELECTED_INDICATOR;
            floodPlainNot = NOTSELECTED_INDICATOR;
            if (lopoffer.LOP_Flood_Plain_Declaration__c == 'A 500-year flood plain') {
                floodPlain500Yrs = SELECTED_INDICATOR;
            } else if (lopoffer.LOP_Flood_Plain_Declaration__c == 'A base (100-year) flood plain') {
                floodPlain100Yrs = SELECTED_INDICATOR;
            } else {
                floodPlainNot = SELECTED_INDICATOR;
            }
            //Asbestos
            asbestosNot = NOTSELECTED_INDICATOR ;
            asbestosStable = NOTSELECTED_INDICATOR;
            asbestosNotStable = NOTSELECTED_INDICATOR;
            if (lopoffer.LOP_Asbestos_Declaration__c == 'Contains ACM not in a stable, solid matrix') {
                asbestosNotStable = SELECTED_INDICATOR;
            } else {
                asbestosNot = SELECTED_INDICATOR;
            }
            //RLP Seismic
            rlpSeismic = NOTSELECTED_INDICATOR;
            rlpNotSeismic = NOTSELECTED_INDICATOR;
            if (lopoffer.LOP_RLP_Contains_Seismic_Requirement__c == 'The RLP contains seismic requirements.') {
                rlpSeismic = SELECTED_INDICATOR;
            } else if (lopoffer.LOP_RLP_Contains_Seismic_Requirement__c == 'The RLP does not contain seismic requirements. No documentation required') {
                rlpNotSeismic = SELECTED_INDICATOR;
            }
            //Seismic
            seismicFull = NOTSELECTED_INDICATOR;
            seismicNot = NOTSELECTED_INDICATOR;
            seismicWill = NOTSELECTED_INDICATOR;
            seismicWillNot = NOTSELECTED_INDICATOR;
            if (lopoffer.LOP_Offeror_Seismic_Declaration__c == 'Fully meets seismic requirements or meets an exemption under the RLP') {
                seismicFull = SELECTED_INDICATOR;
            } else if (lopoffer.LOP_Offeror_Seismic_Declaration__c == 'Does not meet seismic requirements, but will be retrofitted to meet seismic requirements') {
                seismicNot = SELECTED_INDICATOR;
            } else if (lopoffer.LOP_Offeror_Seismic_Declaration__c == 'Will be constructed to meet seismic requirements') {
                seismicWill = SELECTED_INDICATOR;
            } else if (lopoffer.LOP_Offeror_Seismic_Declaration__c == 'Will not meet seismic requirements') {
                seismicWillNot = SELECTED_INDICATOR;
            }

            //Accessibility
            accessibilityMet = NOTSELECTED_INDICATOR;
            accessibilityNot = NOTSELECTED_INDICATOR;
            if (lopoffer.LOP_Accessibility_Standards_Met__c == 'Yes') {
                accessibilityMet = SELECTED_INDICATOR;
            } else {
                accessibilityNot = SELECTED_INDICATOR;
            }
            //Fire & Safety
            flsMet = NOTSELECTED_INDICATOR;
            flsNot = NOTSELECTED_INDICATOR;
            if (lopoffer.LOP_Fire_Safety_Declaration__c == 'Meets the Lease fire/life safety standards.') {
                flsMet = SELECTED_INDICATOR;
            } else if (lopoffer.LOP_Fire_Safety_Declaration__c == 'Does not meet the Lease fire/life safety standards') {
                flsNot = SELECTED_INDICATOR;
            }
            //AcceptedTerms
            if (lopoffer.LOP_ACCEPTED_TERMS_AND_COND__c == 'Yes') {
                acceptedTerms = SELECTED_INDICATOR;
            } else {
                acceptedTerms = NOTSELECTED_INDICATOR;
            }
            field27a1 = ''; field27a2 = ''; field27a3 = '';
            field27a1v = ''; field27a2v = ''; field27a3v = '';
            field27b = ''; field27c = ''; field28HVACRt = '';
            field28HVACzone = ''; field28HVACfloor = ''; field28HVACspace = '';
            fullyAssessedYes = ''; fullyAssessedNo = '';
            multyTaxBillYes = ''; multyTaxBillNo = '';
            //Section 3  Questions 27, 28
            field27b = (lopOffer.LOP_Lessor_Prj_Fees__c != null) ? String.valueOf(lopOffer.LOP_Lessor_Prj_Fees__c) : '';
            field27c = (lopOffer.LOP_Offer_Basis_Of_Fees__c != null) ? (lopOffer.LOP_Offer_Basis_Of_Fees__c).left(80) : '';
            field27cLine2 = (lopOffer.LOP_Offer_Basis_Of_Fees__c != null) ? (lopOffer.LOP_Offer_Basis_Of_Fees__c).mid(81, 80) : '';
            field27cLine3 = (lopOffer.LOP_Offer_Basis_Of_Fees__c != null) ? (lopOffer.LOP_Offer_Basis_Of_Fees__c).mid(161, 100) : '';

            if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '1. Per ABOA Square Feet ($)') {
                field27a1 = SELECTED_INDICATOR; field27a1v = String.valueOf(lopOffer.LOP_ARCH_ENG_FEES_PER_USF__c);
            } else if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '2. Percent of Total Construction Costs (%)') {
                field27a2 = SELECTED_INDICATOR; field27a2v = String.valueOf(lopOffer.LOP_Architectural_Fees_Percent__c);
            } else if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '3. Flat Fee ($)') {
                field27a3 = SELECTED_INDICATOR; field27a3v = String.valueOf(lopOffer.LOP_Architectural_Fees_Flat__c);
            }

            field28HVACZones = (lopOffer.LOP_Number_of_zones__c != null) ? String.valueOf(lopOffer.LOP_Number_of_zones__c) : '';
            field28HVAC24Hr = (lopOffer.LOP_24_HR_HVAC_Cost_Per_ABOA__c != null) ? String.valueOf(lopOffer.LOP_24_HR_HVAC_Cost_Per_ABOA__c) : '';
            field28HVACRt = (lopOffer.LOP_HVAC_OT_Rate__c != null) ? String.valueOf(lopOffer.LOP_HVAC_OT_Rate__c) : '';

            prcntGovOccupancy = (lopOffer.LOP_Government_Occupancy_Pct__c != null) ? String.valueOf((lopOffer.LOP_Government_Occupancy_Pct__c).setScale(2)) : '';
            currentYrTaxes = (lopOffer.LOP_Current_Year_Taxes_1364_28__c != null) ? String.valueOf((lopOffer.LOP_Current_Year_Taxes_1364_28__c).setScale(2)) : '';
            totalLandCost = (lopOffer.LOP_Total_Land_Cost__c != null) ? String.valueOf((lopOffer.LOP_Total_Land_Cost__c).setScale(2)) : '';

            if (lopOffer.LOP_Taxes_Based_On_Fully_Assessed_Value__c == 'Yes') {
                fullyAssessedYes = '[ x ]';
            } else if (lopOffer.LOP_Taxes_Based_On_Fully_Assessed_Value__c == 'No') {
                fullyAssessedNo = '[ x ]';
            }

            if (lopOffer.LOP_HVAC_OT_Rate_Type__c == 'Per Zone') {
                field28HVACzone = SELECTED_INDICATOR;
            } else if (lopOffer.LOP_HVAC_OT_Rate_Type__c == 'Per Floor') {
                field28HVACfloor = SELECTED_INDICATOR;
            } else if (lopOffer.LOP_HVAC_OT_Rate_Type__c == 'Per Space') {
                field28HVACspace = SELECTED_INDICATOR;
            }

            if (lopOffer.LOP_Offered_Space_Part_of_Mult_Tax_Bills__c == 'Yes') {
                multyTaxBillYes = '[ x ]';
            } else if (lopOffer.LOP_Offered_Space_Part_of_Mult_Tax_Bills__c == 'No') {
                multyTaxBillNo = '[ x ]';
            }


            //Section 3  Questions 27, 28
//flsNot =lopoffer.LOP_Offeror_FLS_Declaration__c;
//CAF                
            if (lopoffer.LOP_Common_Area_Factor__c > 0)
                CAF = String.valueOf((lopoffer.LOP_Common_Area_Factor__c).setScale(2)); else {
                CAF = NOTAPPLICABLE;
            }
        }
        logConstructorEnd('PBS_AAAP_OfferForm1364Controller');
    }
    
    string fetchOfferKey(){ 
        string ofId = getQueryParamAsString('offerId'); 
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_Key__c; 
    }   
    boolean isValidUser(){  
        // getting session id   
        string paramSessionKey = getQueryParamAsString('sesid');    
        string sessionOfferKey = fetchOfferKey();   
	string isFromOfferAtt = getQueryParamAsString('isFromOfferAtt');
        if(isFromOfferAtt == 'true'){
            return true;
        }
        if(paramSessionKey != sessionOfferKey   
                || string.isBlank(sessionOfferKey)  
                || string.isBlank(paramSessionKey)){    
            return false;   
        }   
        return true;    
    }   
    public pageReference isValidUserAction(){   
        if(!isValidUser()){ 
            return new pageReference('/apex/GenricErrorPage?errormessage=Not Authorized to see this page'); 
        }   
        return null;    
    }
}