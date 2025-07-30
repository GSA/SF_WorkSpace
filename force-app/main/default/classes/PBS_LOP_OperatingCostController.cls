public with sharing class PBS_LOP_OperatingCostController {

    public String lopofferId = ApexPages.currentPage().getParameters().get('offerId');    // offer id
    public String propId = ApexPages.currentPage().getParameters().get('propertyId');
    public PBS_AAAP_Offer__c lopoffer = new PBS_AAAP_Offer__c();                                                        // offer
    public PBS_AAAP_QuestionLabels qLabels { get; set; }                                                                                            // question labels
    public String fuelType = '';                                                                                                        // fuel type
    public Boolean isValidUser { get; set; }
    private PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();                                                // generate an instance of the DAO class
    public String draftMsgFlag { get; set; }
    public PBS_AAAP_RLP__c rlp { get; set; }
    public string isEditable { get; set; }
    public Boolean viewOnly { get; set; }
    public string viewMsg { get; set; }
    public String offerDueDate { get; set; }
    public String pageUrl {get; set;}
    //Prorate change start
    private Map<String, String> fieldsMap;
    //Prorate change end
    //Julia change start
    public String selectedOption { get; set; }
    public Boolean isShowError {get; set; }
    public String prorateOption {get; set;} {prorateOption = 'No';}
    public String pageURLForRedirection{get;set;}    // j.rogers 2/14/2023  SFWS-2105
    public Boolean isTerminated { get; set; }

    //Julia change end

    /****************************************************************************************************************
    *   Constructors 
    *****************************************************************************************************************/

    //  No Arg constructor
    public PBS_LOP_OperatingCostController() {
        try {
            draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
            this.lopoffer = PBS_AAAP_GlobalConstants.getOfferDetail(this.lopofferId);
            String rlpId = lopoffer.PBS_AAAP_RLP_Number__c;
            rlp = [
                    SELECT PBS_RSAP_Solicitation_G_REX_ID__c,PBS_RSAP_Solicitation_Number__c,PBS_RSAP_Solicitation_Status__c,PBS_RSAP_State__c,PBS_RSAP_Broker__c, PBS_RSAP_Lease_Contracting_Officer__c, PBS_RSAP_Leasing_Specialist__c,  //JK 2.9.21 added 3 new GREX contact email fields on RLP here
                            PBS_RSAP_Project_Number__c,PBS_RSAP_City__c
                    FROM PBS_AAAP_RLP__c
                    WHERE Id = :rlpId
                    LIMIT 1
            ];
            isEditable = ApexPages.currentPage().getParameters().get('edit');
            
            if (isEditable == 'false') {
                viewOnly = true;
                viewMsg = 'Offer opened in view mode. Any changes made will not be saved.';
            } else {
                viewOnly = false;
            }
            if (!lopOffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                viewOnly = true;
            }
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                viewOnly = true;
            }
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

            //Prorate changes start
            fieldsMap = new Map<String, String>();
            fieldsMap.put('PBS_AAAP_CLEANING_SALARIES__c','PBS_AAAP_CLEANING_SALARIES_GOV__c');
            fieldsMap.put('PBS_AAAP_CLEANING_SUPPLIES__c','PBS_AAAP_CLEANING_SUPPLIES_GOV__c');
            fieldsMap.put('PBS_AAAP_CLEANING_CONTRACT_SERVICES__c','PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c');
            fieldsMap.put('PBS_AAAP_HEATING_SALARIES__c','PBS_AAAP_HEATING_SALARIES_GOV__c');
            fieldsMap.put('PBS_AAAP_HEATING_FUEL_COST__c','PBS_AAAP_HEATING_FUEL_COST_GOV__c');
            fieldsMap.put('PBS_AAAP_HEATING_MAINTENANCE__c','PBS_AAAP_HEATING_MAINTENANCE_GOV__c');
            fieldsMap.put('PBS_AAAP_ELECTRICAL_POWER__c','PBS_AAAP_ELECTRICAL_POWER_GOV__c');
            fieldsMap.put('PBS_AAAP_ELECTRICAL_REPLACEMENT__c','PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c');
            fieldsMap.put('PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c','PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c');
            fieldsMap.put('PBS_AAAP_ELECTRICAL_MAINTENANCE__c','PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c');
            fieldsMap.put('PBS_AAAP_PLUMBING_WATER__c','PBS_AAAP_PLUMBING_WATER_GOV__c');
            fieldsMap.put('PBS_AAAP_PLUMBING_SUPPLIES__c','PBS_AAAP_PLUMBING_SUPPLIES_GOV__c');
            fieldsMap.put('PBS_AAAP_PLUMBING_MAINTENANCE__c','PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c');
            fieldsMap.put('PBS_AAAP_AC_UTILITIES__c','PBS_AAAP_AC_UTILITIES_GOV__c');
            fieldsMap.put('PBS_AAAP_AC_MAINTENANCE__c','PBS_AAAP_AC_MAINTENANCE_GOV__c');
            fieldsMap.put('PBS_AAAP_ELEVATOR_SALARIES__c','PBS_AAAP_ELEVATOR_SALARIES_GOV__c');
            fieldsMap.put('PBS_AAAP_ELEVATOR_MAINTENANCE__c','PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c');
            fieldsMap.put('PBS_AAAP_BLDG_ENGINEERCOST__c','PBS_AAAP_BLDG_ENGINEERCOST_GOV__c');
            fieldsMap.put('PBS_AAAP_SECURITY__c','PBS_AAAP_SECURITY_GOV__c');
            fieldsMap.put('PBS_AAAP_SSTAX_WORKCOMP__c','PBS_AAAP_SSTAX_WORKCOMP_GOV__c');
            fieldsMap.put('PBS_AAAP_LANDSCAPING_MAINTENANCE__c','PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c');
            fieldsMap.put('PBS_AAAP_TOTAL_OTHER_COSTS__c','PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c');
            fieldsMap.put('PBS_AAAP_SRVC_UTIL_TOTAL__c','PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c');
            fieldsMap.put('PBS_AAAP_REAL_ESTATE_TAXES__c','PBS_AAAP_REAL_ESTATE_TAXES_GOV__c');
            fieldsMap.put('PBS_AAAP_INSURANCE__c','PBS_AAAP_INSURANCE_GOV__c');
            fieldsMap.put('PBS_AAAP_BUILDING_MAINTENANCE__c','PBS_AAAP_BUILDING_MAINTENANCE_GOV__c');
            fieldsMap.put('PBS_AAAP_LEASE_COMMISSION__c','PBS_AAAP_LEASE_COMMISSION_GOV__c');
            fieldsMap.put('PBS_AAAP_MANAGEMENT__c','PBS_AAAP_MANAGEMENT_GOV__c');
            fieldsMap.put('PBS_AAAP_SECT2_TOTAL__c','PBS_AAAP_SECT2_TOTAL_GOV__c');
            //Prorate changes end

            // generate default values should no values are present

            lopoffer.PBS_AAAP_CLEANING_SALARIES__c = (lopoffer.PBS_AAAP_CLEANING_SALARIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_SALARIES__c;
            lopoffer.PBS_AAAP_CLEANING_SUPPLIES__c = (lopoffer.PBS_AAAP_CLEANING_SUPPLIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_SUPPLIES__c;
            lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = (lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c;
            lopoffer.PBS_AAAP_HEATING_SALARIES__c = (lopoffer.PBS_AAAP_HEATING_SALARIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_SALARIES__c;
            lopoffer.PBS_AAAP_HEATING_FUEL_COST__c = (lopoffer.PBS_AAAP_HEATING_FUEL_COST__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_FUEL_COST__c;
            lopoffer.PBS_AAAP_HEATING_MAINTENANCE__c = (lopoffer.PBS_AAAP_HEATING_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_MAINTENANCE__c;
            lopoffer.PBS_AAAP_ELECTRICAL_POWER__c = (lopoffer.PBS_AAAP_ELECTRICAL_POWER__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_POWER__c;
            lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c = (lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c;
            lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = (lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c;
            lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c = (lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c;
            lopoffer.PBS_AAAP_PLUMBING_WATER__c = (lopoffer.PBS_AAAP_PLUMBING_WATER__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_WATER__c;
            lopoffer.PBS_AAAP_PLUMBING_SUPPLIES__c = (lopoffer.PBS_AAAP_PLUMBING_SUPPLIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_SUPPLIES__c;
            lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE__c = (lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE__c;
            lopoffer.PBS_AAAP_AC_UTILITIES__c = (lopoffer.PBS_AAAP_AC_UTILITIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_AC_UTILITIES__c;
            lopoffer.PBS_AAAP_AC_MAINTENANCE__c = (lopoffer.PBS_AAAP_AC_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_AC_MAINTENANCE__c;
            lopoffer.PBS_AAAP_ELEVATOR_SALARIES__c = (lopoffer.PBS_AAAP_ELEVATOR_SALARIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELEVATOR_SALARIES__c;
            lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE__c = (lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE__c;
            lopoffer.PBS_AAAP_BLDG_ENGINEERCOST__c = (lopoffer.PBS_AAAP_BLDG_ENGINEERCOST__c == null) ? 0.00 : lopoffer.PBS_AAAP_BLDG_ENGINEERCOST__c;
            lopoffer.PBS_AAAP_SECURITY__c = (lopoffer.PBS_AAAP_SECURITY__c == null) ? 0.00 : lopoffer.PBS_AAAP_SECURITY__c;
            lopoffer.PBS_AAAP_SSTAX_WORKCOMP__c = (lopoffer.PBS_AAAP_SSTAX_WORKCOMP__c == null) ? 0.00 : lopoffer.PBS_AAAP_SSTAX_WORKCOMP__c;
            lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c = (lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c;
            lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS__c = (lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS__c == null) ? 0.00 : lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
            lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL__c = (lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL__c == null) ? 0.00 : lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL__c;
            lopoffer.PBS_AAAP_REAL_ESTATE_TAXES__c = (lopoffer.PBS_AAAP_REAL_ESTATE_TAXES__c == null) ? 0.00 : lopoffer.PBS_AAAP_REAL_ESTATE_TAXES__c;
            lopoffer.PBS_AAAP_INSURANCE__c = (lopoffer.PBS_AAAP_INSURANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_INSURANCE__c;
            lopoffer.PBS_AAAP_BUILDING_MAINTENANCE__c = (lopoffer.PBS_AAAP_BUILDING_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_BUILDING_MAINTENANCE__c;
            lopoffer.PBS_AAAP_LEASE_COMMISSION__c = (lopoffer.PBS_AAAP_LEASE_COMMISSION__c == null) ? 0.00 : lopoffer.PBS_AAAP_LEASE_COMMISSION__c;
            lopoffer.PBS_AAAP_MANAGEMENT__c = (lopoffer.PBS_AAAP_MANAGEMENT__c == null) ? 0.00 : lopoffer.PBS_AAAP_MANAGEMENT__c;
            lopoffer.PBS_AAAP_SECT2_TOTAL__c = (lopoffer.PBS_AAAP_SECT2_TOTAL__c == null) ? 0.00 : lopoffer.PBS_AAAP_SECT2_TOTAL__c;

            lopoffer.PBS_AAAP_CLEANING_SALARIES_GOV__c = (lopoffer.PBS_AAAP_CLEANING_SALARIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_SALARIES_GOV__c;
            lopoffer.PBS_AAAP_CLEANING_SUPPLIES_GOV__c = (lopoffer.PBS_AAAP_CLEANING_SUPPLIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_SUPPLIES_GOV__c;
            lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c = (lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c;
            lopoffer.PBS_AAAP_HEATING_SALARIES_GOV__c = (lopoffer.PBS_AAAP_HEATING_SALARIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_SALARIES_GOV__c;
            lopoffer.PBS_AAAP_HEATING_FUEL_COST_GOV__c = (lopoffer.PBS_AAAP_HEATING_FUEL_COST_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_FUEL_COST_GOV__c;
            lopoffer.PBS_AAAP_HEATING_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_HEATING_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_MAINTENANCE_GOV__c;
            lopoffer.PBS_AAAP_ELECTRICAL_POWER_GOV__c = (lopoffer.PBS_AAAP_ELECTRICAL_POWER_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_POWER_GOV__c;
            lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c = (lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c;
            lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c = (lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c;
            lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c;
            lopoffer.PBS_AAAP_PLUMBING_WATER_GOV__c = (lopoffer.PBS_AAAP_PLUMBING_WATER_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_WATER_GOV__c;
            lopoffer.PBS_AAAP_PLUMBING_SUPPLIES_GOV__c = (lopoffer.PBS_AAAP_PLUMBING_SUPPLIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_SUPPLIES_GOV__c;
            lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c;
            lopoffer.PBS_AAAP_AC_UTILITIES_GOV__c = (lopoffer.PBS_AAAP_AC_UTILITIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_AC_UTILITIES_GOV__c;
            lopoffer.PBS_AAAP_AC_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_AC_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_AC_MAINTENANCE_GOV__c;
            lopoffer.PBS_AAAP_ELEVATOR_SALARIES_GOV__c = (lopoffer.PBS_AAAP_ELEVATOR_SALARIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELEVATOR_SALARIES_GOV__c;
            lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c;
            lopoffer.PBS_AAAP_BLDG_ENGINEERCOST_GOV__c = (lopoffer.PBS_AAAP_BLDG_ENGINEERCOST_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_BLDG_ENGINEERCOST_GOV__c;
            lopoffer.PBS_AAAP_SECURITY_GOV__c = (lopoffer.PBS_AAAP_SECURITY_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_SECURITY_GOV__c;
            lopoffer.PBS_AAAP_SSTAX_WORKCOMP_GOV__c = (lopoffer.PBS_AAAP_SSTAX_WORKCOMP_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_SSTAX_WORKCOMP_GOV__c;
            lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c;
            lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c = (lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c;
            lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c = (lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c;
            lopoffer.PBS_AAAP_REAL_ESTATE_TAXES_GOV__c = (lopoffer.PBS_AAAP_REAL_ESTATE_TAXES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_REAL_ESTATE_TAXES_GOV__c;
            lopoffer.PBS_AAAP_INSURANCE_GOV__c = (lopoffer.PBS_AAAP_INSURANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_INSURANCE_GOV__c;
            lopoffer.PBS_AAAP_BUILDING_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_BUILDING_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_BUILDING_MAINTENANCE_GOV__c;
            lopoffer.PBS_AAAP_LEASE_COMMISSION_GOV__c = (lopoffer.PBS_AAAP_LEASE_COMMISSION_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_LEASE_COMMISSION_GOV__c;
            lopoffer.PBS_AAAP_MANAGEMENT_GOV__c = (lopoffer.PBS_AAAP_MANAGEMENT_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_MANAGEMENT_GOV__c;
            lopoffer.PBS_AAAP_SECT2_TOTAL_GOV__c = (lopoffer.PBS_AAAP_SECT2_TOTAL_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_SECT2_TOTAL_GOV__c;


            System.debug('##### lopoffer.Id ' + lopoffer.Id);
            System.debug('##### lopoffer.Project_Number__c: ' + lopoffer.PBS_AAAP_RLP_Number__c);
            this.qLabels = new PBS_AAAP_QuestionLabels();

            // set the fueltype
            this.fuelType = lopoffer.PBS_AAAP_HEATING_FUEL__c;
        } catch (QueryException e) {
            Apexpages.addMessages(e);
        }
        System.debug('***** offer section 2 total: ' + lopoffer.PBS_AAAP_SECT2_TOTAL__c);
        
        //Julia change start
        selectedOption = 'No';
        //Julia change end
    }   // end constructor

    /****************************************************************************************************************
    *   End Constructors 
    *****************************************************************************************************************/


    /****************************************************************************************************************
    *   Method Definitions 
    *****************************************************************************************************************/

    /*  Getters */

    // Fuel type options
    public List<SelectOption> getFuelTypeOpts() {
        Schema.DescribeFieldResult fldResult = PBS_AAAP_Offer__c.PBS_AAAP_HEATING_FUEL__c.getDescribe();
        List<Schema.PicklistEntry> vals = fldResult.getPicklistValues();
        List<SelectOption> opts = new List<SelectOption>();

        // construct the select options from only the active picklist values.
        for (Schema.PicklistEntry val : vals) {
            if (val.isActive()) {
                opts.add(new SelectOption(String.valueOf(val.getLabel()), String.valueOf(val.getValue())));
            }    // end if
        }    // end for

        return opts;
    }    // end getFuelTypeOpts


    // Fuel type selection
    public String getFuelType() {
        return this.fuelType;
    }    // end getFuelType


    // Offer
    public PBS_AAAP_Offer__c getlopOffer() {
        return this.lopoffer;
    }    // end getlopOffer


    /*  Setters */

    // Set fuel type selection
    public void setFuelType(String pVal) {
        this.fuelType = pVal;
    }    // end setFuelType


    // Invoke operating costs page 
    public PageReference addOperatingCosts() {
        
        PageReference pgOperatingCosts = new PageReference('/RSAP/OperatingCost');
        pgOperatingCosts.getParameters().put('offerId', lopoffer.Id);
        pgOperatingCosts.setRedirect(true);
        return pgOperatingCosts;
    }    // end addOperatingCosts


    // "Continue" action
    public PageReference continueSave() {
        // TODO logic for updating operating costs
		PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(lopoffer,new List<String>{'Offer-S-Costs'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            return null;
        }
        
        PageReference p = new PageReference('/RSAP/LeaseTerms');
                this.saveData();    // save the page data
        p.getParameters().put('offerId', lopofferId);
        if (draftMsgFlag == 'true') {
            p.getParameters().put('draftMsgFlag', 'true');
        }


        //J.Rogers 2/14/2023 -= Communities Upgrade
        // Don't see any way pageURL is not null.
        // Modifying code accordingly
        
        p.setRedirect(false);
           if(pageURL == NULL || pageURL == ''){
                pageURLForRedirection = p.getUrl();
                
                pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-TermsFinancials?edit=true&offerId='+lopofferId+'&propertyId='+propId;
               p.setRedirect(false);
            } else {
                p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pageURL);
                System.debug('*****'+pageURLForRedirection);
              } 
              return null; 

     
       
       

    }    // end continueSave


    // "Back" button
    public PageReference back() {
        PageReference back = new PageReference('/RSAP/SpacesAndParking');
        
        back.getParameters().put('offerId', lopofferId);
        //J. Rogers   2/14/2023 - Communities Upgrade
       
        this.saveData();    // save the page data
       

        pageURLForRedirection = back.getUrl();

         pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-SpaceParking?edit='+(viewOnly ? 'false' : 'true')+'&offerId='+lopofferId+'&propertyId='+propId;
        
        return null;
    }    // end back


    // "Save Form" button
    public PageReference saveForm() {
        
        PageReference saveForm = new PageReference('/RSAP/OperatingCost');
        saveForm.getParameters().put('offerId', lopofferId);
        
        PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(lopoffer,new List<String>{'Offer-S-Costs'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            return null;
        }
        
        this.saveData();

        
        //J. Rogers   2/14/2023 - Communities Upgrade
       
        pageURLForRedirection = saveForm.getUrl();
       
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-Costs?edit=true&offerId='+lopofferId+'&propertyId='+propId;
        return null;

    }    // end saveForm


    // Calculate the cost totals
    public Double calculateCosts(List<Double> pVals) {
        System.debug('***** calculate costs pVals: ' + pVals);
        Double returnVal = 0.00;
        for (Double val : pVals) {
            returnVal = returnVal + val;
        }    // end for
        return returnVal;
    }    // end calculateCosts


    // Save the operating cost data
    public void saveData() {

        lopoffer.PBS_AAAP_CLEANING_SALARIES__c = (lopoffer.PBS_AAAP_CLEANING_SALARIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_SALARIES__c;
        lopoffer.PBS_AAAP_CLEANING_SUPPLIES__c = (lopoffer.PBS_AAAP_CLEANING_SUPPLIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_SUPPLIES__c;
        lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = (lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c;
        lopoffer.PBS_AAAP_HEATING_SALARIES__c = (lopoffer.PBS_AAAP_HEATING_SALARIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_SALARIES__c;
        lopoffer.PBS_AAAP_HEATING_FUEL_COST__c = (lopoffer.PBS_AAAP_HEATING_FUEL_COST__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_FUEL_COST__c;
        lopoffer.PBS_AAAP_HEATING_MAINTENANCE__c = (lopoffer.PBS_AAAP_HEATING_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_MAINTENANCE__c;
        lopoffer.PBS_AAAP_ELECTRICAL_POWER__c = (lopoffer.PBS_AAAP_ELECTRICAL_POWER__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_POWER__c;
        lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c = (lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c;
        lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = (lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c;
        lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c = (lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c;
        lopoffer.PBS_AAAP_PLUMBING_WATER__c = (lopoffer.PBS_AAAP_PLUMBING_WATER__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_WATER__c;
        lopoffer.PBS_AAAP_PLUMBING_SUPPLIES__c = (lopoffer.PBS_AAAP_PLUMBING_SUPPLIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_SUPPLIES__c;
        lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE__c = (lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE__c;
        lopoffer.PBS_AAAP_AC_UTILITIES__c = (lopoffer.PBS_AAAP_AC_UTILITIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_AC_UTILITIES__c;
        lopoffer.PBS_AAAP_AC_MAINTENANCE__c = (lopoffer.PBS_AAAP_AC_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_AC_MAINTENANCE__c;
        lopoffer.PBS_AAAP_ELEVATOR_SALARIES__c = (lopoffer.PBS_AAAP_ELEVATOR_SALARIES__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELEVATOR_SALARIES__c;
        lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE__c = (lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE__c;
        lopoffer.PBS_AAAP_BLDG_ENGINEERCOST__c = (lopoffer.PBS_AAAP_BLDG_ENGINEERCOST__c == null) ? 0.00 : lopoffer.PBS_AAAP_BLDG_ENGINEERCOST__c;
        lopoffer.PBS_AAAP_SECURITY__c = (lopoffer.PBS_AAAP_SECURITY__c == null) ? 0.00 : lopoffer.PBS_AAAP_SECURITY__c;
        lopoffer.PBS_AAAP_SSTAX_WORKCOMP__c = (lopoffer.PBS_AAAP_SSTAX_WORKCOMP__c == null) ? 0.00 : lopoffer.PBS_AAAP_SSTAX_WORKCOMP__c;
        lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c = (lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c;
        lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS__c = (lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS__c == null) ? 0.00 : lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
        lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL__c = (lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL__c == null) ? 0.00 : lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL__c;
        lopoffer.PBS_AAAP_REAL_ESTATE_TAXES__c = (lopoffer.PBS_AAAP_REAL_ESTATE_TAXES__c == null) ? 0.00 : lopoffer.PBS_AAAP_REAL_ESTATE_TAXES__c;
        lopoffer.PBS_AAAP_INSURANCE__c = (lopoffer.PBS_AAAP_INSURANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_INSURANCE__c;
        lopoffer.PBS_AAAP_BUILDING_MAINTENANCE__c = (lopoffer.PBS_AAAP_BUILDING_MAINTENANCE__c == null) ? 0.00 : lopoffer.PBS_AAAP_BUILDING_MAINTENANCE__c;
        lopoffer.PBS_AAAP_LEASE_COMMISSION__c = (lopoffer.PBS_AAAP_LEASE_COMMISSION__c == null) ? 0.00 : lopoffer.PBS_AAAP_LEASE_COMMISSION__c;
        lopoffer.PBS_AAAP_MANAGEMENT__c = (lopoffer.PBS_AAAP_MANAGEMENT__c == null) ? 0.00 : lopoffer.PBS_AAAP_MANAGEMENT__c;
        lopoffer.PBS_AAAP_SECT2_TOTAL__c = (lopoffer.PBS_AAAP_SECT2_TOTAL__c == null) ? 0.00 : lopoffer.PBS_AAAP_SECT2_TOTAL__c;

        lopoffer.PBS_AAAP_CLEANING_SALARIES_GOV__c = (lopoffer.PBS_AAAP_CLEANING_SALARIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_SALARIES_GOV__c;
        lopoffer.PBS_AAAP_CLEANING_SUPPLIES_GOV__c = (lopoffer.PBS_AAAP_CLEANING_SUPPLIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_SUPPLIES_GOV__c;
        lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c = (lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c;
        lopoffer.PBS_AAAP_HEATING_SALARIES_GOV__c = (lopoffer.PBS_AAAP_HEATING_SALARIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_SALARIES_GOV__c;
        lopoffer.PBS_AAAP_HEATING_FUEL_COST_GOV__c = (lopoffer.PBS_AAAP_HEATING_FUEL_COST_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_FUEL_COST_GOV__c;
        lopoffer.PBS_AAAP_HEATING_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_HEATING_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_HEATING_MAINTENANCE_GOV__c;
        lopoffer.PBS_AAAP_ELECTRICAL_POWER_GOV__c = (lopoffer.PBS_AAAP_ELECTRICAL_POWER_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_POWER_GOV__c;
        lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c = (lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c;
        lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c = (lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c;
        lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c;
        lopoffer.PBS_AAAP_PLUMBING_WATER_GOV__c = (lopoffer.PBS_AAAP_PLUMBING_WATER_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_WATER_GOV__c;
        lopoffer.PBS_AAAP_PLUMBING_SUPPLIES_GOV__c = (lopoffer.PBS_AAAP_PLUMBING_SUPPLIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_SUPPLIES_GOV__c;
        lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c;
        lopoffer.PBS_AAAP_AC_UTILITIES_GOV__c = (lopoffer.PBS_AAAP_AC_UTILITIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_AC_UTILITIES_GOV__c;
        lopoffer.PBS_AAAP_AC_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_AC_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_AC_MAINTENANCE_GOV__c;
        lopoffer.PBS_AAAP_ELEVATOR_SALARIES_GOV__c = (lopoffer.PBS_AAAP_ELEVATOR_SALARIES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELEVATOR_SALARIES_GOV__c;
        lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c;
        lopoffer.PBS_AAAP_BLDG_ENGINEERCOST_GOV__c = (lopoffer.PBS_AAAP_BLDG_ENGINEERCOST_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_BLDG_ENGINEERCOST_GOV__c;
        lopoffer.PBS_AAAP_SECURITY_GOV__c = (lopoffer.PBS_AAAP_SECURITY_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_SECURITY_GOV__c;
        lopoffer.PBS_AAAP_SSTAX_WORKCOMP_GOV__c = (lopoffer.PBS_AAAP_SSTAX_WORKCOMP_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_SSTAX_WORKCOMP_GOV__c;
        lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c;
        lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c = (lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c;
        lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c = (lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c;
        lopoffer.PBS_AAAP_REAL_ESTATE_TAXES_GOV__c = (lopoffer.PBS_AAAP_REAL_ESTATE_TAXES_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_REAL_ESTATE_TAXES_GOV__c;
        lopoffer.PBS_AAAP_INSURANCE_GOV__c = (lopoffer.PBS_AAAP_INSURANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_INSURANCE_GOV__c;
        lopoffer.PBS_AAAP_BUILDING_MAINTENANCE_GOV__c = (lopoffer.PBS_AAAP_BUILDING_MAINTENANCE_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_BUILDING_MAINTENANCE_GOV__c;
        lopoffer.PBS_AAAP_LEASE_COMMISSION_GOV__c = (lopoffer.PBS_AAAP_LEASE_COMMISSION_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_LEASE_COMMISSION_GOV__c;
        lopoffer.PBS_AAAP_MANAGEMENT_GOV__c = (lopoffer.PBS_AAAP_MANAGEMENT_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_MANAGEMENT_GOV__c;
        lopoffer.PBS_AAAP_SECT2_TOTAL_GOV__c = (lopoffer.PBS_AAAP_SECT2_TOTAL_GOV__c == null) ? 0.00 : lopoffer.PBS_AAAP_SECT2_TOTAL_GOV__c;
        
        
        
        Map<String, Schema.SObjectField> offerFields = Schema.SObjectType.PBS_AAAP_Offer__c.fields.getMap();
        List<SObjectField> offerFieldNames = offerFields.values();
        List<Double> srvcUtilVals = new List<Double>();
        List<Double> sect2Vals = new List<Double>();

        List<Double> srvcUtilGovVals = new List<Double>();
        List<Double> sect2GovVals = new List<Double>();
        Set<String> srvcUtilFields = new Set<String>{
                'PBS_AAAP_CLEANING_SALARIES__c', 'PBS_AAAP_CLEANING_SUPPLIES__c',
                'PBS_AAAP_CLEANING_CONTRACT_SERVICES__c', 'PBS_AAAP_HEATING_SALARIES__c',
                'PBS_AAAP_HEATING_FUEL_COST__c',
                'PBS_AAAP_HEATING_MAINTENANCE__c', 'PBS_AAAP_ELECTRICAL_POWER__c',
                'PBS_AAAP_ELECTRICAL_REPLACEMENT__c', 'PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c',
                'PBS_AAAP_ELECTRICAL_MAINTENANCE__c', 'PBS_AAAP_PLUMBING_WATER__c',
                'PBS_AAAP_PLUMBING_SUPPLIES__c', 'PBS_AAAP_PLUMBING_MAINTENANCE__c',
                'PBS_AAAP_AC_UTILITIES__c', 'PBS_AAAP_AC_MAINTENANCE__c',
                'PBS_AAAP_ELEVATOR_SALARIES__c', 'PBS_AAAP_ELEVATOR_MAINTENANCE__c',
                'PBS_AAAP_BLDG_ENGINEERCOST__c', 'PBS_AAAP_SECURITY__c',
                'PBS_AAAP_SSTAX_WORKCOMP__c', 'PBS_AAAP_LANDSCAPING_MAINTENANCE__c', 'PBS_AAAP_TOTAL_OTHER_COSTS__c'
        };

        Set<String> sect2Fields = new Set<String>{
                'PBS_AAAP_REAL_ESTATE_TAXES__c', 'PBS_AAAP_INSURANCE__c',
                'PBS_AAAP_BUILDING_MAINTENANCE__c', 'PBS_AAAP_LEASE_COMMISSION__c',
                'PBS_AAAP_MANAGEMENT__c'
        };
        Set<String> srvcUtilGovFields = new Set<String>{
                'PBS_AAAP_CLEANING_SALARIES_GOV__c', 'PBS_AAAP_CLEANING_SUPPLIES_GOV__c',
                'PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c', 'PBS_AAAP_HEATING_SALARIES_GOV__c',
                'PBS_AAAP_HEATING_FUEL_COST_GOV__c',
                'PBS_AAAP_HEATING_MAINTENANCE_GOV__c', 'PBS_AAAP_ELECTRICAL_POWER_GOV__c',
                'PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c', 'PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c',
                'PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c', 'PBS_AAAP_PLUMBING_WATER_GOV__c',
                'PBS_AAAP_PLUMBING_SUPPLIES_GOV__c', 'PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c',
                'PBS_AAAP_AC_UTILITIES_GOV__c', 'PBS_AAAP_AC_MAINTENANCE_GOV__c',
                'PBS_AAAP_ELEVATOR_SALARIES_GOV__c', 'PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c',
                'PBS_AAAP_BLDG_ENGINEERCOST_GOV__c', 'PBS_AAAP_SECURITY_GOV__c',
                'PBS_AAAP_SSTAX_WORKCOMP_GOV__c', 'PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c', 'PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c'
        };

        Set<String> sect2GovFields = new Set<String>{
                'PBS_AAAP_REAL_ESTATE_TAXES_GOV__c', 'PBS_AAAP_INSURANCE_GOV__c',
                'PBS_AAAP_BUILDING_MAINTENANCE_GOV__c', 'PBS_AAAP_LEASE_COMMISSION_GOV__c',
                'PBS_AAAP_MANAGEMENT_GOV__c'
        };

        try {

            // assemble the various value lists
            for (SObjectField str : offerFieldNames) {
                System.debug('***** str: ' + str.getDescribe().getName());
                if (srvcUtilFields.contains(str.getDescribe().getName())) {
                    srvcUtilVals.add(Double.valueOf(lopoffer.get(str)));    // cost value for the service and utilities section
                    System.debug('***** srvcUtilVals: ' + srvcUtilVals);
                } else if (sect2Fields.contains(str.getDescribe().getName())) {
                    sect2Vals.add(Double.valueOf(lopoffer.get(str)));        // cost value for section two
                    System.debug('***** sect2Vals: ' + sect2Vals);
                } // end if
                if (srvcUtilGovFields.contains(str.getDescribe().getName())) {
                    srvcUtilGovVals.add(Double.valueOf(lopoffer.get(str)));    // cost value for the service and utilities section
                    System.debug('***** srvcUtilGovVals: ' + srvcUtilVals);
                } else if (sect2GovFields.contains(str.getDescribe().getName())) {
                    sect2GovVals.add(Double.valueOf(lopoffer.get(str)));        // cost value for section two
                    System.debug('***** sect2GovVals: ' + sect2Vals);
                } // end if
            }    // end for

            PBS_AAAP_Offer__c tmplopOffer = lopoffer;
            tmplopoffer.PBS_AAAP_SECT2_TOTAL__c = this.calculateCosts(sect2Vals);
            tmplopoffer.PBS_AAAP_HEATING_FUEL__c = this.fuelType;
            tmplopoffer.PBS_AAAP_SRVC_UTIL_TOTAL__c = this.calculateCosts(srvcUtilVals);

            tmplopoffer.PBS_AAAP_SECT2_TOTAL_GOV__c = this.calculateCosts(sect2GovVals);
            tmplopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c = this.calculateCosts(srvcUtilGovVals);
            tmplopoffer.PBS_AAAP_Op_Cost_Years_Effective__c = tmplopoffer.PBS_AAAP_INITIAL_NO_OF_YEARS__c;
            tmplopoffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c = (tmplopoffer.PBS_AAAP_Total_Ofc_ABOA_offered__c > 0) ? (tmplopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / tmplopoffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) : 0;
            tmplopoffer.PBS_AAAP_OP_COST_COST_PER_RSF__c = (tmplopoffer.PBS_AAAP_Office_RSF_OFFERED__c > 0) ? (tmplopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / tmplopoffer.PBS_AAAP_Office_RSF_OFFERED__c) : 0;

            System.debug('***** tmpOffer: ' + tmplopOffer);

            //added by syam for submit offer to save as draft when it is saved.
            draftMsgFlag = '';
            if (tmplopoffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                
                draftMsgFlag = 'true';
            }

            //update space and rates fields 
            //added by syam on 12/21/2016
            tmplopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c = (tmplopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(2);
            tmplopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c = (tmplopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c).setScale(2);
            tmplopOffer.PBS_AAAP_Office_RSF_OFFERED__c = (tmplopOffer.PBS_AAAP_Office_RSF_OFFERED__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_Office_RSF_OFFERED__c).setScale(2);
            tmplopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c = (tmplopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c).setScale(2);
            tmplopOffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c = (tmplopOffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c).setScale(2);
            tmplopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c = (tmplopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c).setScale(2);
            tmplopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c = (tmplopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c).setScale(2);
            tmplopOffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c = (tmplopOffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c).setScale(2);
            tmplopOffer.PBS_AAAP_Shell_Rent_Per_ABOA__c = (tmplopOffer.PBS_AAAP_Shell_Rent_Per_ABOA__c == null) ? 0.00 : (tmplopOffer.PBS_AAAP_Shell_Rent_Per_ABOA__c).setScale(2);
            //SFWS-847
            tmplopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c = (tmplopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c > 0) ? (tmplopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / tmplopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) : 0;
            tmplopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c = (tmplopOffer.PBS_AAAP_Office_RSF_OFFERED__c > 0) ? (tmplopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / tmplopOffer.PBS_AAAP_Office_RSF_OFFERED__c) : 0;
            //SFWS-847
            
           
            
            upsert tmplopOffer;
        } catch (DMLException e) {
            Apexpages.addMessages(e);
        }
    }    // end saveData

    // logic for delete button - added by Santosh
    public PageReference actionDeleteOffer() {
        PageReference pref = null;
        System.debug('************* offer ::: ' + lopoffer);
        System.debug('************* lopoffer.LOP_Offer_Status__c ::: ' + lopoffer.PBS_AAAP_Offer_Status__c);
        System.debug('************* lopoffer.LOP_Offer_Status__c ::: ' + PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT);
        if (lopoffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT) {
            delete lopoffer;    // Cascade delete - Deletes all Spaces and Othercosts associated with it.
            
            pref = new PageReference('/RSAP/PortalHome');
            pref.setRedirect(true);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + lopoffer.PBS_AAAP_Offer_Status__c +
                    ', you can only delete an offer that is Draft');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    /** added by syam 03/22 as part of the cancel operation addition */
    public PageReference actionCancel() {
        PageReference pref = new PageReference('/RSAP/PortalHome');
        
        pref.setRedirect(true);
        return pref;
    }
    //Prorate change start
    public void checkValidations() {
        isShowError = false;
        if(lopoffer.PBS_AAAP_Office_RSF_OFFERED__c == Null || lopoffer.PBS_AAAP_Office_RSF_OFFERED__c == 0
          || lopoffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == Null || lopoffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == 0){
            isShowError = true;
              System.debug('JK a field is null or 0');
        }
        if(isShowError){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '2d. Total rentable square feet (RSF) in Building on the Property overview page and 2. What is the amount of Rentable Square Feet (RSF) offered on the Space and parking page must be populated for the Prorate function to work.'));
        }else{
            //Prorate modal only opens if visualforce page flag is false
        }
     
    }
    //Prorate change end
    
    public void Prorate() {
        Double percentage = (lopoffer.PBS_AAAP_Office_RSF_OFFERED__c / lopoffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c)* 100;
        for(String fieldName : fieldsMap.keySet()){
            if(lopoffer.get(fieldName) != null){
                lopoffer.put(fieldsMap.get(fieldName),Double.valueOf(lopoffer.get(fieldName)) * (percentage/100) );
            }else{
                 //handles if left column field is null/blank, then sets the right column field to 0
                 lopoffer.put(fieldsMap.get(fieldName),0);
            }
        }
        //SFWS-847
        lopoffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c = (lopoffer.PBS_AAAP_Total_Ofc_ABOA_offered__c > 0) ? (lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / lopoffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) : 0;
        lopoffer.PBS_AAAP_OP_COST_COST_PER_RSF__c = (lopoffer.PBS_AAAP_Office_RSF_OFFERED__c > 0) ? (lopoffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / lopoffer.PBS_AAAP_Office_RSF_OFFERED__c) : 0;
        //SFWS-847
    }
 
    /****************************************************************************************************************
    *   End Method Definitions
    *****************************************************************************************************************/
}