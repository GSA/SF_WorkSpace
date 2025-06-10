public with sharing class PBS_LOP_SpacesAndRatesController {

    public boolean isValidUser { get; set; }
    public String offerId { get; set; }
    public String propId { get; set; }
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
    public PBS_AAAP_QuestionLabels qLabels { get; set; }
    public Double totalAnnualRentAmt { get; set; }
    public String pageUrl {get; set;}
    //Rental Concessions changes start here
    public String rentalConcessions {get; set;} 
    //Rental Concessions changes end here
    public Boolean ShellCheck { get; set; }
    public Boolean OperatingCheck { get; set; }
    public Boolean TICheck { get; set; }
    public Boolean BSACCheck { get; set; }
    public Boolean ParkingCheck { get; set; }
    public List<PBS_RSAP_Step_Rent__c> stepFreeRentRecords { get; set; }
    public List<PBS_RSAP_Renewal_Options__c> renewalOptionsRecords { get; set; }
    private Integer currentIndexForFreeRent = 0;
    private Integer currentIndexForRenewalOptions = 0;
    public Integer freeRentLimits{ get; set; }
    public Integer renewalOptionsLimits{ get; set; }
    public boolean isRendered { get; set; }
    public String freeRentIndexNumber{ get; set; }
    private boolean isFromOnLoad;
    public String pageURLForRedirection{get;set;}
 
    public PBS_LOP_SpacesAndRatesController() {
        freeRentLimits = 0;
        isFromOnLoad = true;
        if(Label.PBS_LOP_StepRent_Row_Limits != ''){
            freeRentLimits = Integer.valueOf(Label.PBS_LOP_StepRent_Row_Limits);
        }
        renewalOptionsLimits = 0;
        if(Label.PBS_LOP_RenewalOptions_Row_Limits != ''){
            renewalOptionsLimits = Integer.valueOf(Label.PBS_LOP_RenewalOptions_Row_Limits);
        }
        renewalOptionsRecords = new List<PBS_RSAP_Renewal_Options__c>();
        stepFreeRentRecords = new List<PBS_RSAP_Step_Rent__c>();
        //Rental Concessions change start here
        rentalConcessions = null;
        //Rental Concessions change end here
        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode FROM User u WHERE u.Id = :UserInfo.getUserId()];
        action = ApexPages.currentPage().getParameters().get('action');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        propId = ApexPages.currentPage().getParameters().get('propertyId');
        if(validateId(offerId)){
        isNew = ApexPages.currentPage().getParameters().get('isNew');
        isEditable = ApexPages.currentPage().getParameters().get('edit');
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');

        qLabels = new PBS_AAAP_QuestionLabels();

        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in view mode. Any changes made will not be saved.';
        } else {
            viewOnly = false;
        }

        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            renewalOptionsRecords = [SELECT Id,PBS_RSAP_Option_Duration__c, PBS_RSAP_Option_RSF_Rate__c, PBS_RSAP_Option_Days_Notice_to_Exercise__c, PBS_RSAP_Option_Number__c FROM PBS_RSAP_Renewal_Options__c Where PBS_AAAP_Offer__c =:string.escapeSingleQuotes(offerId) order by PBS_RSAP_Option_Number__c];
            if(renewalOptionsRecords.size() == 0){
                addRenewalRow();
            }else{
                currentIndexForRenewalOptions = renewalOptionsRecords.size();
            }
            
            stepFreeRentRecords = [SELECT Id, PBS_RSAP_Step_Annual_Rent__c, PBS_RSAP_Step_End__c, PBS_RSAP_Step_Payment_Basis__c, PBS_RSAP_Step_Rent_Type__c, PBS_RSAP_Step_Start__c, PBS_AAAP_Offer__c, PBS_RSAP_Rent_Number__c FROM PBS_RSAP_Step_Rent__c Where PBS_AAAP_Offer__c =:string.escapeSingleQuotes(offerId) order by PBS_RSAP_Rent_Number__c];
            if(stepFreeRentRecords.size() == 0){
                addRow();
            }else{
                currentIndexForFreeRent = stepFreeRentRecords.size();
            }
            
            lopOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            //here debug the new field for rental concessions on page load. then set rentalConcessions to lopOffer.TBDfield
            System.debug('JK rentalConcessions field ' + lopOffer.PBS_AAAP_Rental_Concessions__c);
            rentalConcessions = lopOffer.PBS_AAAP_Rental_Concessions__c;
            
            system.debug('**NIK**'+lopOffer);
            system.debug('**NIK**'+lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c);
            system.debug('**NIK**'+lopOffer.PBS_AAAP_Office_RSF_OFFERED__c);
            if(lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c != NULL){
                lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c = lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c.setScale(2);
            }
            if(lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c != NULL){
                lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c = lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c.setScale(2);
            }
            if(lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c != NULL){
                lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c = lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c.setScale(2);
            }
            if(lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c != NULL){
                lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c = lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c.setScale(2);
            }
            
            if(lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c != NULL && lopOffer.PBS_AAAP_Office_RSF_OFFERED__c != NULL){
                totalAnnualRentAmt = lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c * lopOffer.PBS_AAAP_Office_RSF_OFFERED__c;
            } else {
                totalAnnualRentAmt = 0;
            }
            String rlpId = lopOffer.PBS_AAAP_RLP_Number__c;
            rlp = [
                    SELECT PBS_RSAP_Solicitation_G_REX_ID__c,PBS_RSAP_Solicitation_Number__c,PBS_RSAP_Solicitation_Status__c,PBS_RSAP_State__c,PBS_RSAP_Broker__c, PBS_RSAP_Lease_Contracting_Officer__c, PBS_RSAP_Leasing_Specialist__c,  //JK 2.9.21 added 3 new GREX contact email fields on RLP here
                            PBS_RSAP_Project_Number__c,PBS_RSAP_City__c
                    FROM PBS_AAAP_RLP__c
                    WHERE Id = :rlpId
                    LIMIT 1
            ];
            ShellCheck = lopOffer.PBS_RSAP_Free_Shell_Is_Offered__c == 'Yes' ? true : false;
            OperatingCheck = lopOffer.PBS_RSAP_Free_Operating_Is_Offered__c == 'Yes' ? true : false;
            TICheck = lopOffer.PBS_RSAP_Free_TI_Is_Offered__c == 'Yes' ? true : false;
            BSACCheck = lopOffer.PBS_RSAP_Free_BSAC_Is_Offered__c == 'Yes' ? true : false;
            ParkingCheck = lopOffer.PBS_RSAP_Free_Parking_Is_Offered__c == 'Yes' ? true : false;
            if (this.lopoffer.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
                if (lopOffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                    isTerminated = false;
                } else {
                    isTerminated = true;
                }
                if (isTerminated) {
                    viewOnly = true;
                    viewMsg = 'Project is terminated. Offer opened in view mode. Any changes made will not be saved.';
                    System.debug('*** isEditable ***' + isEditable);
                } else if (lopOffer.PBS_AAAP_Offer_Status__c == 'Closed') {
                    viewOnly = true;
                    viewMsg = 'Project due date has elapsed. Offer opened in view mode. Any changes made will not be saved.';
                }
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
        } else {
            isValidUser = true;
            lopOffer = new PBS_AAAP_Offer__c();
        }


        isRendered = false;
        isFromOnLoad = false;
        }
    }

    public PageReference actionSaveSpaceRates() {
        PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(lopOffer,new List<String>{'Offer-S-Rent'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            return null;
        }
        saveSpaceRates();
        PageReference p = new PageReference('/RSAP/Rates');
        
        //addeds
        p.getParameters().put('offerId', offerId);
        p.getParameters().put('draftMsg', draftMsgFlag);
             

        pageURLForRedirection = p.getUrl();
        
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-Rent?edit=true&offerId='+offerId+'&propertyId='+propId;   
        return null;
        //addeds
    }

    public void saveSpaceRates() {
    //Added by ramya
        try {
           lopOffer.PBS_AAAP_Is_Shell_Rent_Stepped__c = 'No';
            for(PBS_RSAP_Step_Rent__c step :stepFreeRentRecords ){
                if(step.PBS_RSAP_Step_Rent_Type__c == 'Shell' && step.PBS_RSAP_Step_Annual_Rent__c > 0 ){
                     lopOffer.PBS_AAAP_Is_Shell_Rent_Stepped__c = 'Yes';
                     break;   
                }
            
            }
            if(lopOffer.PBS_RSAP_TIA_Or_Turnkey__c == 'Tenant Improvement Allowance (TIA)'){
                lopOffer.PBS_AAAP_TI_Total_Build_out_Costs__c = (lopOffer.PBS_AAAP_TI_Buildout_as_in_RLP__c * lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(3);
            }
            lopOffer.PBS_AAAP_TI_Years_Rate_Effective__c = (lopOffer.PBS_AAAP_TI_Amorization_in_Years__c / 12).setScale(3);
            
            if(lopOffer.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c == 'Rate per ABOA SF specified in RLP'){
                lopOffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c = (lopOffer.PBS_RSAP_BSAC_Rate_from_RLP__c * lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(3);
            }
            lopOffer.PBS_AAAP_BSAC_Years_Rate_Effective__c = (lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c / 12).setScale(3);
            
            //Rental Concession save
            System.debug('JK rentalConcession on save ' + this.rentalConcessions);
            lopOffer.PBS_AAAP_Rental_Concessions__c = this.rentalConcessions;
            lopOffer.PBS_AAAP_Common_Area_Factor__c = (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c > 0) ? (100 * (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c - lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) / lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(2) : 0.00;
//Op Cost
            
            lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c = (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c > 0) ? (lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(2) : 0;
            lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c = (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c > 0) ? (lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / lopOffer.PBS_AAAP_Office_RSF_OFFERED__c).setScale(2) : 0;
//Shell Rent

            lopOffer.PBS_RSAP_Total_Parking_Annual_Amount__c = (((lopOffer.PBS_AAAP_Monthly_cost_res_gar_park__c*lopOffer.PBS_RSAP_Struct_Resv_Parking__c)
                                                                 +(lopOffer.PBS_AAAP_Monthly_cost_res_sur_park__c*lopOffer.PBS_RSAP_Surf_Resv_Parking__c)
                                                                 +(lopOffer.PBS_AAAP_Monthly_cost_nonres_gar_park__c*lopOffer.PBS_RSAP_Struct_NonResv_Parking__c)
                                                                 +(lopOffer.PBS_AAAP_Monthly_cost_nonres_sur_park__c*lopOffer.PBS_RSAP_Surf_NonResv_Parking__c))*12).setScale(2);
            
            
            
            lopOffer.PBS_AAAP_TI_Total_Build_out_Costs__c = (lopOffer.PBS_AAAP_TI_Buildout_as_in_RLP__c == null) ? 0.00 : (lopOffer.PBS_AAAP_TI_Buildout_as_in_RLP__c * lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(2);
            lopOffer.PBS_AAAP_TI_Amorti_Interest_Rate__c = (lopOffer.PBS_AAAP_TI_Amorti_Interest_Rate__c == null) ? 0 : lopOffer.PBS_AAAP_TI_Amorti_Interest_Rate__c;
            lopOffer.PBS_AAAP_TI_Amorization_in_Years__c = (lopOffer.PBS_AAAP_TI_Amorization_in_Years__c == null) ? 0 : lopOffer.PBS_AAAP_TI_Amorization_in_Years__c;
            if(lopOffer.PBS_RSAP_TIA_Or_Turnkey__c == 'Turnkey'){
                if(lopOffer.PBS_AAAP_TI_Amorti_Interest_Rate__c == 0.00){
                    if(lopOffer.PBS_AAAP_TI_Amorization_in_Years__c != 0){
                        lopOffer.PBS_AAAP_Annual_TI_Rent__c = (lopOffer.PBS_RSAP_Total_TI_Turnkey__c / (lopOffer.PBS_AAAP_TI_Amorization_in_Years__c / 12)).setScale(2);
                    }
                    else{
                        lopOffer.PBS_AAAP_Annual_TI_Rent__c = 0;
                    }
                }
                else{
                    lopOffer.PBS_AAAP_Annual_TI_Rent__c = getAmortizationCost((lopOffer.PBS_AAAP_TI_Amorti_Interest_Rate__c).doubleValue(), (lopOffer.PBS_RSAP_Total_TI_Turnkey__c).doubleValue(), (lopOffer.PBS_AAAP_TI_Amorization_in_Years__c).intValue()).setScale(2);
                } 
            }
            else{
                if(lopOffer.PBS_AAAP_TI_Amorti_Interest_Rate__c == 0.00){
                    if(lopOffer.PBS_AAAP_TI_Amorization_in_Years__c != 0){
                        lopOffer.PBS_AAAP_Annual_TI_Rent__c = (lopOffer.PBS_AAAP_TI_Total_Build_out_Costs__c / (lopOffer.PBS_AAAP_TI_Amorization_in_Years__c / 12)).setScale(2);
                    }
                    else{
                        lopOffer.PBS_AAAP_Annual_TI_Rent__c = 0;
                    }
                }else{
                    lopOffer.PBS_AAAP_Annual_TI_Rent__c = getAmortizationCost((lopOffer.PBS_AAAP_TI_Amorti_Interest_Rate__c).doubleValue(), (lopOffer.PBS_AAAP_TI_Total_Build_out_Costs__c).doubleValue(), (lopOffer.PBS_AAAP_TI_Amorization_in_Years__c).intValue()).setScale(2);
                } 
            }
            lopOffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == 0) ? 0 : (lopOffer.PBS_AAAP_Annual_TI_Rent__c / lopOffer.PBS_AAAP_Office_RSF_OFFERED__c).setScale(2);
            lopOffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == 0) ? 0 : (lopOffer.PBS_AAAP_Annual_TI_Rent__c / lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(2);
           
            lopOffer.PBS_AAAP_TI_Years_Rate_Effective__c = (lopOffer.PBS_AAAP_TI_Amorization_in_Years__c == null) ? 0 : (lopOffer.PBS_AAAP_TI_Amorization_in_Years__c / 12).setScale(2);
            
            //BSAC
            lopOffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c = (lopOffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c == null) ? 0.00 : (lopOffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c).setScale(2);
            lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c = (lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c == null) ? 0 : lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c.setScale(2);
            lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c = (lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c == null) ? 0 : lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c.setScale(2);
        
               if(lopOffer.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c == 'Total BSAC buildout cost itemized on the Security Unit Price List'){ 
                if(lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c == 0.00){
                    if(lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c != 0){
                        lopOffer.PBS_AAAP_Anual_BSAC_Rent__c = (lopOffer.PBS_RSAP_BSAC_Calc_from_Rate__c / (lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c / 12)).setScale(2);
                    }
                    else{
                        lopOffer.PBS_AAAP_Anual_BSAC_Rent__c = 0;
                    }
                }else{
                    lopOffer.PBS_AAAP_Anual_BSAC_Rent__c = getAmortizationCost((lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c).doubleValue(), (lopOffer.PBS_RSAP_BSAC_Calc_from_Rate__c).doubleValue(), (lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c).intValue()).setScale(2);
                } 
            }
            else{
                if(lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c == 0.00){
                    if(lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c != 0){
                        lopOffer.PBS_AAAP_Anual_BSAC_Rent__c = (lopOffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c / (lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c / 12)).setScale(2);
                    }
                    else{
                        lopOffer.PBS_AAAP_Anual_BSAC_Rent__c = 0;
                    }
                }else{
                    lopOffer.PBS_AAAP_Anual_BSAC_Rent__c = getAmortizationCost((lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c).doubleValue(), (lopOffer.PBS_AAAP_BSAC_Total_Build_out_Costs__c).doubleValue(), (lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c).intValue()).setScale(2); 
                }
            }
                //added by syam on 11/25/2016 for setting to 2 decimals
            lopOffer.PBS_AAAP_Anual_BSAC_Rent__c = (lopOffer.PBS_AAAP_Anual_BSAC_Rent__c == null) ? 0.00 : (lopOffer.PBS_AAAP_Anual_BSAC_Rent__c).setScale(2);
            lopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c = (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == 0) ? 0 : (lopOffer.PBS_AAAP_Anual_BSAC_Rent__c / lopOffer.PBS_AAAP_Office_RSF_OFFERED__c).setScale(2);
            lopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c = (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == 0) ? 0 : (lopOffer.PBS_AAAP_Anual_BSAC_Rent__c / lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(2);
            
            lopOffer.PBS_AAAP_BSAC_Years_Rate_Effective__c = (lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c == null) ? 0 : (lopOffer.PBS_AAAP_BSAC_Amorization_in_Years__c / 12).setScale(2);


            
            //Total Initial Rent
            lopOffer.PBS_RSAP_Lease_Annual_Rent__c = (lopOffer.PBS_RSAP_Total_Parking_Annual_Amount__c + lopOffer.PBS_RSAP_Shell_Initial_Annual__c + lopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c + lopOffer.PBS_AAAP_Annual_TI_Rent__c+lopOffer.PBS_AAAP_Anual_BSAC_Rent__c).setScale(2);
            lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c = (lopOffer.PBS_RSAP_Lease_Annual_Rent__c / lopOffer.PBS_AAAP_Office_RSF_OFFERED__c).setScale(2);
            lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c = (lopOffer.PBS_RSAP_Lease_Annual_Rent__c / lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(2);

            
            totalAnnualRentAmt = lopOffer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c * lopOffer.PBS_AAAP_Office_RSF_OFFERED__c;
            System.debug('in totalAnnualRentAmt fields' + totalAnnualRentAmt);
//Step Rent

            draftMsgFlag = '';
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            
            lopOffer.PBS_RSAP_Free_Shell_Is_Offered__c = ShellCheck ? 'Yes' : 'No';
            lopOffer.PBS_RSAP_Free_Operating_Is_Offered__c = OperatingCheck ? 'Yes' : 'No';
            lopOffer.PBS_RSAP_Free_TI_Is_Offered__c = TICheck ? 'Yes' : 'No';
            lopOffer.PBS_RSAP_Free_BSAC_Is_Offered__c = BSACCheck ? 'Yes' : 'No';
            lopOffer.PBS_RSAP_Free_Parking_Is_Offered__c = ParkingCheck ? 'Yes' : 'No';
            
            
            System.debug(stepFreeRentRecords);
            if(stepFreeRentRecords.size() > 0){
                upsert stepFreeRentRecords;
            }
            System.debug('test '+lopOffer.PBS_RSAP_Are_you_offering_renewal_option__c);
            System.debug('test '+renewalOptionsRecords
                        );
            if(lopOffer.PBS_RSAP_Are_you_offering_renewal_option__c == 'No'){            
                renewalOptionsRecords = [SELECT Id,PBS_RSAP_Option_Duration__c, PBS_RSAP_Option_RSF_Rate__c, PBS_RSAP_Option_Days_Notice_to_Exercise__c, PBS_RSAP_Option_Number__c FROM PBS_RSAP_Renewal_Options__c Where PBS_AAAP_Offer__c =:string.escapeSingleQuotes(offerId) order by PBS_RSAP_Option_Number__c];
                for(PBS_RSAP_Renewal_Options__c record : renewalOptionsRecords){
                    record.PBS_RSAP_Option_Duration__c = null;
                    record.PBS_RSAP_Option_RSF_Rate__c = null;
                    record.PBS_RSAP_Option_Days_Notice_to_Exercise__c = null;
                }
             }
            if(lopOffer.PBS_RSAP_Are_you_offering_renewal_option__c == 'Yes'){
                if(renewalOptionsRecords.size() > 0){
                    upsert renewalOptionsRecords;
                }
            }else{
                List<PBS_RSAP_Renewal_Options__c> renewalOptionsRecordsToDelete = [Select Id From PBS_RSAP_Renewal_Options__c Where PBS_AAAP_Offer__c=:offerId];
                if(renewalOptionsRecordsToDelete.size() > 0){
                    delete renewalOptionsRecordsToDelete;
                }
            }
            update lopOffer;
            lopOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }

    }

    public Decimal getAmortizationCost(double pAmortizationRate, Double pPrincipal, Integer pLeaseTermMonths) {
        System.debug('##### Begin -- getAmortizationCost');
        System.debug('***** formula terms :: pLeaseTermMonths = ' + pLeaseTermMonths);
        System.debug('***** formula terms :: pAmortizationRate = ' + pAmortizationRate);
        System.debug('***** formula terms :: pPrincipal = ' + pPrincipal);

        Decimal returnVal = 0.00;

        // avoid "DIV by 0" errors

        Decimal intRate = (pAmortizationRate > 0) ? pAmortizationRate / 100 : 0.000000001;
        Integer intMonths = pLeaseTermMonths;
        if (pLeaseTermMonths == 0) {
            return 0;
        }
        System.debug('***** formula terms :: intRate = ' + intRate);
        Decimal rateConversion = (intRate) / 12;
        System.debug('***** formula terms :: rateConversion = ' + rateConversion);
        Decimal base = 1.00 + rateConversion;
        System.debug('***** formula terms :: base = ' + base);
        Decimal denominator = (1 - (1 / math.pow(base.doubleValue(), intMonths))) / rateConversion;
        System.debug('***** formula terms :: denominator = ' + denominator);
        Decimal temp = 12 * (pPrincipal / denominator);

        System.debug('***** formula terms :: temp = ' + temp);
        returnVal = temp.doubleValue() ;//* -1;        // need to show the value as a negative
        System.debug('***** formula terms :: returnVal = ' + returnVal);
        System.debug('##### End -- getAmortizationCost');
        return returnVal;
    }   // end getAmortizationCost

    public Decimal getMinimum(Decimal dec1, Decimal dec2, Decimal dec3) {
        Decimal returnVal = 0;
        dec1 = (dec1 == null) ? 0 : dec1;
        dec2 = (dec2 == null) ? 0 : dec2;
        dec3 = (dec3 == null) ? 0 : dec3;
        returnVal = Math.min(dec1, Math.min(dec2, dec3));
        System.debug('returnVal is ***' + returnVal);
        return returnVal;

    }

    public PageReference backToLeaseTerms() {

        
        PageReference p = new PageReference('/RSAP/LeaseTerms');
        
        p.getParameters().put('offerId', offerId);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        
          p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
      
         pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-TermsFinancials?edit='+(viewOnly ? 'false' : 'true')+'&offerId='+offerId+'&propertyId='+propId;
        return null;
        
    }
    

    public PageReference actionSaveSpaceRatesAndContinue() {
        PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(lopOffer,new List<String>{'Offer-S-Rent'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            return null;
        }
        PageReference p = null;
    
        try {
            boolean flag = FALSE;
            flag = PBS_AAAP_GlobalConstants.checkLOPOfferSpaceRates(lopOffer);
            if (flag == true) {
                return null;
            }
            draftMsgFlag = '';
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            saveSpaceRates();
            p = new PageReference('/RSAP/Attachments');
            p.getParameters().put('offerId', lopOffer.Id);
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

                pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-Attachments?edit=true&offerId='+offerId+'&propertyId='+propId;
                p.setRedirect(false);
            } else {
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
        
        PageReference pref = new PageReference('/RSAP/PortalHome');
        pref.setRedirect(true);
        return pref;
        
        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }
    
    //Rental Concession Changes from here
     
    public PageReference rentalConcessionsRerender() {
        return null;
    }
    
    public List<SelectOption> getRentalItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }
    public void addRow() {

        
        currentIndexForFreeRent++;
        stepFreeRentRecords.add(new PBS_RSAP_Step_Rent__c(PBS_RSAP_Rent_Number__c=currentIndexForFreeRent,PBS_AAAP_Offer__c=offerId));
        if(stepFreeRentRecords.size() > 0 && !isFromOnLoad){
            upsert stepFreeRentRecords;
        }
        if(currentIndexForFreeRent != 1){
            stepFreeRentRecords = [SELECT Id, PBS_RSAP_Step_Annual_Rent__c, PBS_RSAP_Step_End__c, PBS_RSAP_Step_Payment_Basis__c, PBS_RSAP_Step_Rent_Type__c, PBS_RSAP_Step_Start__c, PBS_AAAP_Offer__c, PBS_RSAP_Rent_Number__c FROM PBS_RSAP_Step_Rent__c Where PBS_AAAP_Offer__c =:string.escapeSingleQuotes(offerId) order by PBS_RSAP_Rent_Number__c];
        
        }
        isRendered = true;
    }
    public void addRenewalRow() {

        
        currentIndexForRenewalOptions++;
        renewalOptionsRecords.add(new PBS_RSAP_Renewal_Options__c(PBS_RSAP_Option_Number__c=currentIndexForRenewalOptions,PBS_AAAP_Offer__c=offerId));
        if(renewalOptionsRecords.size() > 0 && !isFromOnLoad){
            upsert renewalOptionsRecords;
        }
        isRendered = true;
    }
    public void deleteTheRow() {
        isRendered = true;
        System.debug('******* freeRentIndexNumber::::::::::::::' + freeRentIndexNumber);
        Integer integerBuildingIndexNumber = Integer.valueOf(freeRentIndexNumber);
        PBS_RSAP_Step_Rent__c stepRentRecordToDelete = stepFreeRentRecords[integerBuildingIndexNumber-1];
        if(stepRentRecordToDelete.Id != null){
            Delete stepRentRecordToDelete;
        }
        stepFreeRentRecords.remove(integerBuildingIndexNumber-1);
        resetOrder();
        if(renewalOptionsRecords.size() > 0){
            upsert stepFreeRentRecords;
        }
    }
    public void deleteTheRenewalRow() {
        isRendered = true;
        System.debug('******* freeRentIndexNumber::::::::::::::' + freeRentIndexNumber);
        Integer integerBuildingIndexNumber = Integer.valueOf(freeRentIndexNumber);
        PBS_RSAP_Renewal_Options__c stepRentRecordToDelete = renewalOptionsRecords[integerBuildingIndexNumber-1];
        if(stepRentRecordToDelete.Id != null){
            Delete stepRentRecordToDelete;
        }
        renewalOptionsRecords.remove(integerBuildingIndexNumber-1);
        resetRenewalOrder();
        if(renewalOptionsRecords.size() > 0){
            upsert renewalOptionsRecords;
        }
    }
    public void resetOrder(){
        currentIndexForFreeRent = 0;
        for(PBS_RSAP_Step_Rent__c additionalTaxParcelInfoRecord : stepFreeRentRecords){
            currentIndexForFreeRent++;
            additionalTaxParcelInfoRecord.PBS_RSAP_Rent_Number__c = currentIndexForFreeRent;
        }
    }
    public void resetRenewalOrder(){
        currentIndexForRenewalOptions = 0;
        for(PBS_RSAP_Renewal_Options__c additionalTaxParcelInfoRecord : renewalOptionsRecords){
            currentIndexForRenewalOptions++;
            additionalTaxParcelInfoRecord.PBS_RSAP_Option_Number__c = currentIndexForRenewalOptions;
        }
    }
    
    public String getRentalConcession() {
        return rentalConcessions;
    }
                    
    public void setRentalConcession(String rentalConcessions) { 
        this.rentalConcessions = rentalConcessions; 
    }
    
    
    //to here

    @TestVisible private void updateAreaType(PBS_AAAP_OFFER__C lopOffer) {
        //added by syam for FY16 changes
        String areaType = lopOffer.PBS_AAAP_SITE_AREA_TYPE__c;
        System.debug('*** areaType is ' + areaType);
        Decimal siteSize = lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c;
        
        System.debug('*** siteSize is ' + siteSize);
        if (lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
            siteSize = siteSize * 43560;
            

            System.debug('*** siteSize inside is ' + siteSize);
            lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
        }

    }

    public void updateStepRents(){
        
    }
    static public Boolean validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        return ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id));

    }
}