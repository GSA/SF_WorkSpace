/**
 * Created by nkopparthi on 5/21/19.
 */

public with sharing class PBS_LOP_LeaseTermsController {

    public boolean isValidUser { get; set; }
    public String offerId { get; set; }
    public String isNew { get; set; }
    public String action { get; set; }
    public string isEditable { get; set; }
    public User userDetail { get; set; }
    public String draftMsgFlag { get; set; }
    public Boolean viewOnly { get; set; }
    public string viewMsg { get; set; }
    public PBS_AAAP_Offer__c lopOffer { get; set; }
    public PBS_AAAP_RLP__c rlp { get; set; }
    public Boolean isTerminated { get; set; }
    public String archEnggFee { get; set; }
    public Double totalAnnualRentAmt { get; set; }
    public String pageUrl { get; set; }
    public String buildingIndexNumber{ get; set; }
    public List<PBS_RSAP_Additional_Tax_Parcel_Info__c> additionalTaxParcelInfoRecords { get; set; }
    private Integer currentIndex = 0;
    public Integer buildingLimits{ get; set; }
    public boolean isRendered { get; set; }
    public String pageURLForRedirection{get;set;}
    
    public PBS_LOP_LeaseTermsController() {
        buildingLimits = 0;
        if(Label.PBS_LOP_AdditionalTaxParcelInfo_Row_Limits != ''){
            buildingLimits = Integer.valueOf(Label.PBS_LOP_AdditionalTaxParcelInfo_Row_Limits);
        }
        additionalTaxParcelInfoRecords = new List<PBS_RSAP_Additional_Tax_Parcel_Info__c>();
        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode FROM User u WHERE u.Id = :UserInfo.getUserId()];
        action = ApexPages.currentPage().getParameters().get('action');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        if(validateId(offerId)){
        isNew = ApexPages.currentPage().getParameters().get('isNew');
        isEditable = ApexPages.currentPage().getParameters().get('edit');
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');

        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in a View mode';
        } else {
            viewOnly = false;
        }

        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            additionalTaxParcelInfoRecords = [SELECT Id, PBS_RSAP_Sub_Tax_Parcel_Building_ID__c, PBS_RSAP_Sub_Tax_Parcel_Building_RSF__c, PBS_RSAP_Sub_Tax_Parcel_ID__c, PBS_RSAP_Sub_Tax_Parcel_ID_Number__c, PBS_AAAP_Offer__c, PBS_RSAP_Building_Number__c FROM PBS_RSAP_Additional_Tax_Parcel_Info__c Where PBS_AAAP_Offer__c =:string.escapeSingleQuotes(offerId) order by PBS_RSAP_Building_Number__c];
            if(additionalTaxParcelInfoRecords.size() == 0){
                addRow();
            }else{
                currentIndex = additionalTaxParcelInfoRecords.size();
            }
            lopOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            String rlpId = lopOffer.PBS_AAAP_RLP_Number__c;
            rlp = [
                    SELECT PBS_RSAP_Solicitation_G_REX_ID__c,PBS_RSAP_Solicitation_Number__c,PBS_RSAP_Solicitation_Status__c,PBS_RSAP_State__c,PBS_RSAP_Broker__c, PBS_RSAP_Lease_Contracting_Officer__c, PBS_RSAP_Leasing_Specialist__c,  //JK 2.9.21 added 3 new GREX contact email fields on RLP here
                            PBS_RSAP_Project_Number__c,PBS_RSAP_City__c
                    FROM PBS_AAAP_RLP__c
                    WHERE Id = :rlpId
                    LIMIT 1
            ];

            if (lopOffer.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
                if (lopOffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                    isTerminated = false;
                } else {
                    isTerminated = true;
                }
                if (isTerminated) {
                    viewOnly = true;
                    viewMsg = 'Project is terminated. Offer opened in a view mode';
                    System.debug('*** isEditable ***' + isEditable);
                } else if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    viewOnly = true;
                    viewMsg = 'Project due date has elapsed. Offer opened in a view mode';
                }
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
            initializeSpaceAndRates();
            //leaseTerms and Conditions
            if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Per ABOA Square Feet ($)') {
                archEnggFee = String.valueOf(getCents(lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c));
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Percent of Total Construction Costs (%)') {
                archEnggFee = String.valueOf(lopOffer.PBS_AAAP_Architectural_Fees_Percent__c);
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Flat Fee ($)') {
                archEnggFee = String.valueOf(getCents(lopOffer.PBS_AAAP_Architectural_Fees_Flat__c));
            }
        } else {
            isValidUser = true;
            lopOffer = new PBS_AAAP_Offer__c();
        }
        isRendered = false;
    	}
    }

    private String getCents(Decimal x){
        String y = String.valueOf(x);
        String z = '.';
        if(y.contains(',')) z = ',';
        y = y.substring(0, y.indexOf(z));
        if(x - Decimal.valueOf(y) == 0)
            return String.valueOf(x.format()) + z + '00';
        else return String.valueOf(x.format());
    }

    public List<SelectOption> getarcenggOptionItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Per ABOA Square Feet ($)', 'Per ABOA SF ($)'));
        options.add(new SelectOption('Percent of Total Construction Costs (%)', 'Percent of Total Construction Costs (%)'));
        options.add(new SelectOption('Flat Fee ($)', 'Flat Fee ($)'));
        return options;
    }

    public void initializeSpaceAndRates() {

        lopOffer.PBS_AAAP_Step_1_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_Step_1_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Step_1_Rent_Per_RSF__c).setScale(2);
        lopOffer.PBS_AAAP_Step_2_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_Step_2_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Step_2_Rent_Per_RSF__c).setScale(2);
        lopOffer.PBS_AAAP_Step_3_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_Step_3_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Step_3_Rent_Per_RSF__c).setScale(2);

        lopOffer.PBS_AAAP_Step_1_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_Step_1_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Step_1_Rent_Per_ABOA__c).setScale(2);
        lopOffer.PBS_AAAP_Step_2_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_Step_2_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Step_2_Rent_Per_ABOA__c).setScale(2);
        lopOffer.PBS_AAAP_Step_3_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_Step_3_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Step_3_Rent_Per_ABOA__c).setScale(2);

        lopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c).setScale(2);
        lopOffer.PBS_AAAP_Shell_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_Shell_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Shell_Rent_Per_ABOA__c).setScale(2);
        lopOffer.PBS_AAAP_Office_RSF_OFFERED__c = (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c);
        lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = (lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null) ? 0.00 : (lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c).setScale(2);
        lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c = (lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c == null) ? 0.00 : (lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c).setScale(2);
        lopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c).setScale(2);
        lopOffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c).setScale(2);
        lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c = (lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c == null) ? 0.00 : (lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c).setScale(2);
        lopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c).setScale(2);
        lopOffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c).setScale(2);
        lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c).setScale(2);
        lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c).setScale(2);
        lopOffer.PBS_AAAP_Annual_TI_Rent__c = (lopOffer.PBS_AAAP_Annual_TI_Rent__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Annual_TI_Rent__c).setScale(2);
        lopOffer.PBS_AAAP_Anual_BSAC_Rent__c = (lopOffer.PBS_AAAP_Anual_BSAC_Rent__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Anual_BSAC_Rent__c).setScale(2);
        lopOffer.PBS_AAAP_Common_Area_Factor__c = (lopOffer.PBS_AAAP_Common_Area_Factor__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Common_Area_Factor__c).setScale(2);

        lopOffer.PBS_AAAP_TI_Buildout_as_in_RLP__c = (lopOffer.PBS_AAAP_TI_Buildout_as_in_RLP__c == null) ? 0.00 : (lopOffer.PBS_AAAP_TI_Buildout_as_in_RLP__c).setScale(2);
        totalAnnualRentAmt = (lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c * lopOffer.PBS_AAAP_Office_RSF_OFFERED__c).setScale(2);

        lopOffer.PBS_AAAP_Op_Cost_Years_Effective__c = lopOffer.PBS_AAAP_INITIAL_NO_OF_YEARS__c;
        lopOffer.PBS_AAAP_BSAC_Years_Rate_Effective__c = lopOffer.PBS_AAAP_BSAC_Years_Rate_Effective__c == null ? 0.00 : (lopOffer.PBS_AAAP_BSAC_Years_Rate_Effective__c).setScale(2);
        lopOffer.PBS_AAAP_TI_Years_Rate_Effective__c = lopOffer.PBS_AAAP_TI_Years_Rate_Effective__c == null ? 0.00 : (lopOffer.PBS_AAAP_TI_Years_Rate_Effective__c).setScale(2);
        
        
    }

    public List<SelectOption> getHVACOTOptionItems() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('Per Hour','Per Hour'));
        options.add(new SelectOption('Per Zone', 'Per Zone'));
        options.add(new SelectOption('Per Floor', 'Per Floor'));
        options.add(new SelectOption('Per Space', 'Per Space'));
        return options;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }

    public PageReference backToOperatingCostTab() {

        //PageReference p = Page.PBS_LOP_OperatingCost;
        PageReference p = new PageReference('/RSAP/OperatingCost');
       // p.getParameters().put('offerId', lopOffer.Id);
        p.getParameters().put('offerId', offerId);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        //p.setRedirect(true);
        //return p;
         p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/OperatingCost', Label.LOP_Community_Base_URL+'RSAP-OperatingCost');
        return null;
    }
    public static Boolean isNumeric(String s){
        Boolean ReturnValue;
        try{
            Decimal.valueOf(s);
            ReturnValue = TRUE; 
        } catch (Exception e) {
            ReturnValue = FALSE;
        }
        return ReturnValue;
    }
    public PageReference saveLeaseTermsInfo() {
        PageReference p = null;

        try {
            draftMsgFlag = '';
            System.debug('PBS_LOP_LeaseTermsController.saveLeaseTermsInfo(), validating Confirm_Full_Term_Lease_Months__c value of ' + lopOffer.Confirm_Full_Term_Lease_Months__c + '...');
            if (lopOffer.Confirm_Full_Term_Lease_Months__c == null || lopOffer.Confirm_Full_Term_Lease_Months__c == 0) {
                System.debug('...value was null or 0 so setting error message...');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Initial Lease Term section is incomplete.  1. Confirm the full term of the lease, in months.');
                Apexpages.addMessage(myMsg);
            }
            System.debug('PBS_LOP_LeaseTermsController.saveLeaseTermsInfo(), validating Confirm_Firm_Term_Lease_Months__c value of ' + lopOffer.Confirm_Firm_Term_Lease_Months__c + '...');
            if (lopOffer.Confirm_Firm_Term_Lease_Months__c == null || lopOffer.Confirm_Firm_Term_Lease_Months__c == 0) {
                System.debug('...value was null or 0 so setting error message...');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Initial Lease Term section is incomplete.  2. Confirm the firm term of the lease, in months.');
                Apexpages.addMessage(myMsg);
            }
            archEnggFee = archEnggFee.replace(',','');
            if(lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == NULL || archEnggFee == NULL || archEnggFee == ''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Offeror\'s Fee Schedule section is incomplete.  1. Make sure an Architectural/Engineering Unit of Measure is selected and if there are no A/E Fees put 0 for the amount.');
                Apexpages.addMessage(myMsg);
            }
            if(lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Percent of Total Construction Costs (%)' && archEnggFee != null && archEnggFee != '' && Decimal.valueOf(archEnggFee) > 100){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Offeror\'s Fee Schedule section is incomplete.  1. Offeror\'s Tenant Improvement Fee Schedule #1: Percent of Total TI Construction Costs (%) cannot be over 100%');
                Apexpages.addMessage(myMsg);
            }
            if (archEnggFee != null && archEnggFee != '' && !isNumeric(archEnggFee.replaceAll(',', ''))) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Offeror\'s Fee Schedule section is incomplete. 1. Architectural/Engineering Fees: is Invalid number');
                Apexpages.addMessage(myMsg);
            }
            if (lopOffer.PBS_AAAP_Lessor_Prj_Fees__c == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Offeror\'s Fee Schedule section is incomplete. 2. Lessor\'s Project Management Fee is required.');
                Apexpages.addMessage(myMsg);
            }
            if (Apexpages.hasMessages(ApexPages.Severity.ERROR)) return null;
            
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Per ABOA Square Feet ($)') {
                lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = Decimal.valueOf(archEnggFee);
            }
            if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Per ABOA Square Feet ($)') {
                lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = Decimal.valueOf(archEnggFee);
                lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = null;
                lopOffer.PBS_AAAP_Architectural_Fees_Flat__c = null;
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Percent of Total Construction Costs (%)') {
                lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = Decimal.valueOf(archEnggFee);
                if(!string.isBlank(archEnggFee)){
                    lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = Decimal.valueOf(archEnggFee);
                }
                else{ 
                    lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = null;
                }
                lopOffer.PBS_AAAP_Architectural_Fees_Flat__c = null;
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Flat Fee ($)') {
                lopOffer.PBS_AAAP_Architectural_Fees_Flat__c = Decimal.valueOf(archEnggFee);
                if(!string.isBlank(archEnggFee)){
                    lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = Decimal.valueOf(archEnggFee);
                }
                else{ 
                    lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = null;
                }
                lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = null;
            }
            //updateAreaType(lopOffer);
            resetOrder();
            if(lopOffer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c == 'Yes'){
                if(additionalTaxParcelInfoRecords.size() > 0){
                    upsert additionalTaxParcelInfoRecords;
                }
            }else{
                List<PBS_RSAP_Additional_Tax_Parcel_Info__c> additionalTaxParcelInfoRecordsToDelete = [Select Id From PBS_RSAP_Additional_Tax_Parcel_Info__c Where PBS_AAAP_Offer__c=:offerId];
                if(additionalTaxParcelInfoRecordsToDelete.size() > 0){
                    delete additionalTaxParcelInfoRecordsToDelete;
                }
            }
            System.debug('testadditionalTaxParcelInfoRecords '+additionalTaxParcelInfoRecords);
            update lopOffer;
             p = new PageReference('/RSAP/LeaseTerms');
        /*p.getParameters().put('offerId', offerId);
        if (draftMsgFlag == 'true') {
            p.getParameters().put('draftMsgFlag', 'true');
        }
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        p.setRedirect(true);
        return p;*/
        p.getParameters().put('offerId', offerId);
        p.getParameters().put('draftMsg', draftMsgFlag);
         pageURLForRedirection = p.getUrl();
         pageURLForRedirection = pageURLForRedirection.replace('/RSAP/LeaseTerms', Label.LOP_Community_Base_URL+'RSAP-LeaseTerms');
        
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        /*p = new PageReference('/RSAP/LeaseTerms');
        /*p.getParameters().put('offerId', offerId);
        if (draftMsgFlag == 'true') {
            p.getParameters().put('draftMsgFlag', 'true');
        }
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        p.setRedirect(true);
        return p;
        p.getParameters().put('offerId', offerId);
        p.getParameters().put('draftMsg', draftMsgFlag);
         pageURLForRedirection = p.getUrl();
         pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Rates', Label.LOP_Community_Base_URL+'RSAP-LeaseTerms');
        return null;*/
      return null;
    }

    public PageReference saveLeaseTermsandContinue() {
        PageReference p = null;
        if (lopOffer.Confirm_Full_Term_Lease_Months__c == null || lopOffer.Confirm_Full_Term_Lease_Months__c == 0) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Initial Lease Term section is incomplete.  1. Confirm Full Term Lease Months.');
            Apexpages.addMessage(myMsg);
        }
        if (lopOffer.Confirm_Firm_Term_Lease_Months__c == null || lopOffer.Confirm_Firm_Term_Lease_Months__c == 0) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Initial Lease Term section is incomplete.  2. Confirm Firm Term Lease Months.');
            Apexpages.addMessage(myMsg);
        }
        if(lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == NULL || archEnggFee == NULL || archEnggFee == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Offeror\'s Fee Schedule section is incomplete.  1. Make sure an Architectural/Engineering Unit of Measure is selected and if there are no A/E Fees put 0 for the amount.');
            Apexpages.addMessage(myMsg);
        }
        if(lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Percent of Total Construction Costs (%)' && archEnggFee != null && archEnggFee != '' && Decimal.valueOf(archEnggFee) > 100){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Offeror\'s Fee Schedule section is incomplete.  1. Offeror\'s Tenant Improvement Fee Schedule #1: Percent of Total TI Construction Costs (%) cannot be over 100%');
            Apexpages.addMessage(myMsg);
        }
        if (archEnggFee != null && archEnggFee != '' && !isNumeric(archEnggFee.replaceAll(',', ''))) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Offeror\'s Fee Schedule section is incomplete. 1. Architectural/Engineering Fees: is Invalid number');
                Apexpages.addMessage(myMsg);
        }
        if (lopOffer.PBS_AAAP_Lessor_Prj_Fees__c == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Offeror\'s Fee Schedule section is incomplete. 2. Lessor\'s Project Management Fee is required.');
            Apexpages.addMessage(myMsg);
        }
        if ( Apexpages.hasMessages(ApexPages.Severity.ERROR)) {
            return null;
        }
        
        try {
             archEnggFee = archEnggFee.replace(',','');
            if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Per ABOA Square Feet ($)') {
                lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = Decimal.valueOf(archEnggFee);
            }
            if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Per ABOA Square Feet ($)') {
                lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = Decimal.valueOf(archEnggFee);
                lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = null;
                lopOffer.PBS_AAAP_Architectural_Fees_Flat__c = null;
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Percent of Total Construction Costs (%)') {
                lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = Decimal.valueOf(archEnggFee);
                if(!string.isBlank(archEnggFee)){
                    lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = Decimal.valueOf(archEnggFee);
                }
                else{ 
                    lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = null;
                }
                lopOffer.PBS_AAAP_Architectural_Fees_Flat__c = null;
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Flat Fee ($)') {
                lopOffer.PBS_AAAP_Architectural_Fees_Flat__c = Decimal.valueOf(archEnggFee);
                if(!string.isBlank(archEnggFee)){
                    lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = Decimal.valueOf(archEnggFee);
                }
                else{ 
                    lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = null;
                }
                lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = null;
            }
            draftMsgFlag = '';
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            //updateAreaType(lopOffer);
            resetOrder();
            if(additionalTaxParcelInfoRecords.size() > 0){
                upsert additionalTaxParcelInfoRecords;
            }
            update lopOffer;
            System.debug('************** GPR ::: ' + lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);
            String offerId = lopOffer.Id;
            lopOffer = null; // clears ViewState for visual force page
            
            p = new PageReference('/RSAP/Rates');
            p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            if (isEditable == 'true') {
                p.getParameters().put('edit', 'true');
            } else {
                isEditable = 'false';
            }
            p.setRedirect(true);
            if(pageURL == NULL || pageURL == ''){
                pageURLForRedirection = p.getUrl();
                pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Rates', Label.LOP_Community_Base_URL+'RSAP-Rates');
                p.setRedirect(false);
            }
            else {
                 p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
               
            }
            return null;
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }
        if(pageURL == NULL || pageURL == ''){
            return p;
        } else {
             p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                return null;
        }
    }

    public PageReference actionCancel() {
        //PageReference pref = Page.PBS_LOP_PortalHome;
        PageReference pref = new PageReference('/RSAP/PortalHome');
        pref.setRedirect(true);
        return pref;
    }
    public void addRow() {
        isRendered = true;
        currentIndex++;
        additionalTaxParcelInfoRecords.add(new PBS_RSAP_Additional_Tax_Parcel_Info__c(PBS_RSAP_Building_Number__c=currentIndex,PBS_AAAP_Offer__c=offerId));
        if(additionalTaxParcelInfoRecords.size() > 1){
            upsert additionalTaxParcelInfoRecords;
        }       
    }
    public void deleteTheRow() {
        isRendered = true;
        System.debug('******* buildingIndexNumber::::::::::::::' + buildingIndexNumber);
        Integer integerBuildingIndexNumber = Integer.valueOf(buildingIndexNumber);
        PBS_RSAP_Additional_Tax_Parcel_Info__c additionalTaxParcelInfoRecordToDelete = additionalTaxParcelInfoRecords[integerBuildingIndexNumber-1];
        if(additionalTaxParcelInfoRecordToDelete.Id != null){
            Delete additionalTaxParcelInfoRecordToDelete;
        }
        additionalTaxParcelInfoRecords.remove(integerBuildingIndexNumber-1);
        resetOrder();
    }
    public void resetOrder(){
        currentIndex = 0;
        for(PBS_RSAP_Additional_Tax_Parcel_Info__c additionalTaxParcelInfoRecord : additionalTaxParcelInfoRecords){
            currentIndex++;
            additionalTaxParcelInfoRecord.PBS_RSAP_Building_Number__c = currentIndex;
        }
    }
    
    @TestVisible
    private void updateAreaType(PBS_AAAP_OFFER__C lopOffer) {
        //added by syam for FY16 changes
        String areaType = lopOffer.PBS_AAAP_SITE_AREA_TYPE__c;
        System.debug('*** areaType is ' + areaType);
        Decimal siteSize = lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c;
        //siteSize.setScale(2, RoundingMode.HALF_UP);
        System.debug('*** siteSize is ' + siteSize);
        if (lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
            siteSize = siteSize * 43560;
            //siteSize.setScale(2, RoundingMode.HALF_UP);

            System.debug('*** siteSize inside is ' + siteSize);
            lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
        }
    }
    static public Boolean validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        return ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id));

    }
}