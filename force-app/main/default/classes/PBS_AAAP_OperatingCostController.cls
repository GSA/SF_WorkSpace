public with sharing class PBS_AAAP_OperatingCostController extends PBS_AAAP_PageBaseController{

    /****************************************************************************************************************
    *   Data Declaration 
    *****************************************************************************************************************/
    public String offerId = ApexPages.currentPage().getParameters().get('offerId');    // offer id
    public String propId = ApexPages.currentPage().getParameters().get('propertyId'); 
    
    public PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();                                                        // offer
    public PBS_AAAP_Offer__c operatingCost = new PBS_AAAP_Offer__c();
    public PBS_AAAP_QuestionLabels qLabels { get; set; }                                                                                            // question labels
    public String fuelType = '';                                                                                                        // fuel type
    public List<PBS_AAAP_Other_Costs__c> costs = new List<PBS_AAAP_Other_Costs__c>();                                    // other costs from SFDC
    public PBS_AAAP_Other_Costs__c otherCost = new PBS_AAAP_Other_Costs__c();                                            // other cost
    public Double totOtherCosts = 0.00;                                                                                                // total of other costs
    public List<OtherCostsDetails> ocdetails = new List<OtherCostsDetails>();                                                // list of other costs for Other Costs page interaction
    public Boolean isValidUser { get; set; }
    
    private PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();                                                // generate an instance of the DAO class
    private PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();                                                // generate an instance of the Calculations class
    public String draftMsgFlag { get; set; }
    public String RegionName { get; set; } //region of RLP for census
    public Boolean RLPisCensus { get; set; }
    public String rlpType {get; set;}
    public String pageUrl{get;set;}  
    public String OthercostAmt{get;set;}    
    public string pageURLForRedirection {get;set;}
    public Boolean viewOnly { get; set; }
    public String viewMsg { get; set; }
    /*  OtherCostsDetails   ***********************************************************
    *   
    *   This class is used to render the space and rates data "matrix" table on the "outer
    *   space" page.
    **************************************************************************************/
    public class OtherCostsDetails {
        public Boolean removal { get; set; }
        public String description { get; set; }
        public Double amount { get; set; }
        public String costID { get; set; }
        public string pageURLForRedirection {get;set;}
        


        /*  Construtor  */
        public OtherCostsDetails() {
            this.removal = false;
        } // end constructor


    }    // end class SpaceAndRatesDetails

    /****************************************************************************************************************
    *   End Data Declaration 
    *****************************************************************************************************************/


    public PBS_AAAP_OperatingCostController() {
        logConstructorStart('PBS_AAAP_OperatingCostController');
        try {
            String isEditable = ApexPages.currentPage().getParameters().get('edit');
        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in view mode. Any changes made will not be saved.';
        } else {
            viewOnly = false;
        }
            draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
            
            this.offer = dao.getOffer(this.offerId);
            
            PBS_AAAP_RLP__c rlp = [SELECT id,PBS_AAAP_Region__c FROM PBS_AAAP_RLP__c WHERE Id = :offer.PBS_AAAP_RLP_Number__c];
            this.RegionName = rlp.PBS_AAAP_Region__c;   //weston: here we are extracting the rlp's region.  should save it to the offer bu
            
            RLPisCensus = (this.RegionName == 'Census') ? true : false;

            System.debug('offer.PBS_AAAP_COST_PER_ABOA__c in constructor is ****' + offer.PBS_AAAP_COST_PER_ABOA__c);
            //added by syam for offerId validation
            operatingCost = PBS_AAAP_GlobalConstants.getOfferDetail(this.offerId);
                 if(operatingCost.RecordType.Name == 'AAAP')
                    {
                        rlpType = operatingCost.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
                    }
                    else if(operatingCost.RecordType.Name == 'RSAP')
                    {
                        rlpType = operatingCost.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c;
                    }
            
            if (this.operatingCost.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }


            // generate default values should no values are present
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = (offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null) ? 0.00 : offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
            offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = (offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null) ? 0.00 : offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c;
            if (offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > 0) {
                Double usf = (offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c != null) ? offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c : 0.00;
                Double rsf = (offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c != null) ? offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c : 0.00;
                offer.PBS_AAAP_RU_FACTOR__c = calc.getBCAF(usf, rsf).setScale(2);
            }    //  end if

            offer.PBS_AAAP_COST_PER_ABOA__c = (offer.PBS_AAAP_COST_PER_ABOA__c != null) ?  offer.PBS_AAAP_COST_PER_ABOA__c : 0.00;
            System.debug('offer.PBS_AAAP_COST_PER_ABOA__c' + offer.PBS_AAAP_COST_PER_ABOA__c);
           
            offer.PBS_AAAP_CLEANING_SALARIES__c = (offer.PBS_AAAP_CLEANING_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_SALARIES__c;
            offer.PBS_AAAP_CLEANING_SUPPLIES__c = (offer.PBS_AAAP_CLEANING_SUPPLIES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_SUPPLIES__c;
            offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = (offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c;
            offer.PBS_AAAP_HEATING_SALARIES__c = (offer.PBS_AAAP_HEATING_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_SALARIES__c;
            offer.PBS_AAAP_HEATING_FUEL_COST__c = (offer.PBS_AAAP_HEATING_FUEL_COST__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_FUEL_COST__c;
            offer.PBS_AAAP_HEATING_MAINTENANCE__c = (offer.PBS_AAAP_HEATING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_MAINTENANCE__c;
            offer.PBS_AAAP_ELECTRICAL_POWER__c = (offer.PBS_AAAP_ELECTRICAL_POWER__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_POWER__c;
            offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c = (offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c;
            offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = (offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c;
            offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c = (offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c;
            offer.PBS_AAAP_PLUMBING_WATER__c = (offer.PBS_AAAP_PLUMBING_WATER__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_WATER__c;
            offer.PBS_AAAP_PLUMBING_SUPPLIES__c = (offer.PBS_AAAP_PLUMBING_SUPPLIES__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_SUPPLIES__c;
            offer.PBS_AAAP_PLUMBING_MAINTENANCE__c = (offer.PBS_AAAP_PLUMBING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_MAINTENANCE__c;
            offer.PBS_AAAP_AC_UTILITIES__c = (offer.PBS_AAAP_AC_UTILITIES__c == null) ? 0.00 : offer.PBS_AAAP_AC_UTILITIES__c;
            offer.PBS_AAAP_AC_MAINTENANCE__c = (offer.PBS_AAAP_AC_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_AC_MAINTENANCE__c;
            offer.PBS_AAAP_ELEVATOR_SALARIES__c = (offer.PBS_AAAP_ELEVATOR_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_ELEVATOR_SALARIES__c;
            offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c = (offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c;
            offer.PBS_AAAP_BLDG_ENGINEERCOST__c = (offer.PBS_AAAP_BLDG_ENGINEERCOST__c == null) ? 0.00 : offer.PBS_AAAP_BLDG_ENGINEERCOST__c;
            offer.PBS_AAAP_SECURITY__c = (offer.PBS_AAAP_SECURITY__c == null) ? 0.00 : offer.PBS_AAAP_SECURITY__c;
            offer.PBS_AAAP_SSTAX_WORKCOMP__c = (offer.PBS_AAAP_SSTAX_WORKCOMP__c == null) ? 0.00 : offer.PBS_AAAP_SSTAX_WORKCOMP__c;
            offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c = (offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c;
            offer.PBS_AAAP_TOTAL_OTHER_COSTS__c = (offer.PBS_AAAP_TOTAL_OTHER_COSTS__c == null) ? 0.00 : offer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
            offer.PBS_AAAP_SRVC_UTIL_TOTAL__c = (offer.PBS_AAAP_SRVC_UTIL_TOTAL__c == null) ? 0.00 : offer.PBS_AAAP_SRVC_UTIL_TOTAL__c;
            offer.PBS_AAAP_REAL_ESTATE_TAXES__c = (offer.PBS_AAAP_REAL_ESTATE_TAXES__c == null) ? 0.00 : offer.PBS_AAAP_REAL_ESTATE_TAXES__c;
            offer.PBS_AAAP_INSURANCE__c = (offer.PBS_AAAP_INSURANCE__c == null) ? 0.00 : offer.PBS_AAAP_INSURANCE__c;
            offer.PBS_AAAP_BUILDING_MAINTENANCE__c = (offer.PBS_AAAP_BUILDING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_BUILDING_MAINTENANCE__c;
            offer.PBS_AAAP_LEASE_COMMISSION__c = (offer.PBS_AAAP_LEASE_COMMISSION__c == null) ? 0.00 : offer.PBS_AAAP_LEASE_COMMISSION__c;
            offer.PBS_AAAP_MANAGEMENT__c = (offer.PBS_AAAP_MANAGEMENT__c == null) ? 0.00 : offer.PBS_AAAP_MANAGEMENT__c;
            offer.PBS_AAAP_SECT2_TOTAL__c = (offer.PBS_AAAP_SECT2_TOTAL__c == null) ? 0.00 : offer.PBS_AAAP_SECT2_TOTAL__c;
            
            
            
            this.costs = this.soqlGetOtherCosts(this.offerId);

            // total other costs
            if (offer.PBS_AAAP_TOTAL_OTHER_COSTS__c > 0.00) {
                this.totOtherCosts = offer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
            } //    end if

            // populate the question labels
            System.debug('##### offer.Id ' + offer.Id);
            System.debug('##### offer.PBS_AAAP_RLP_Number__c: ' + offer.PBS_AAAP_RLP_Number__c);
            this.qLabels = new PBS_AAAP_QuestionLabels(offer.PBS_AAAP_RLP_Number__c);
            
            // set the fueltype
            this.fuelType = offer.PBS_AAAP_HEATING_FUEL__c;
            
            OthercostAmt = (OthercostAmt == null) ? '0.00' : OthercostAmt;
            
        } catch (QueryException e) {
            Apexpages.addMessages(e);
        }
        System.debug('***** offer section 2 total: ' + offer.PBS_AAAP_SECT2_TOTAL__c);
        System.debug('***** costs: ' + costs);
        logConstructorEnd('PBS_AAAP_OperatingCostController');
    }   // end constructor


    // Fuel type options
    public List<SelectOption> getFuelTypeOpts() {
        logMethodStart('getFuelTypeOpts');
        Schema.DescribeFieldResult fldResult = PBS_AAAP_Offer__c.PBS_AAAP_HEATING_FUEL__c.getDescribe();
        List<Schema.PicklistEntry> vals = fldResult.getPicklistValues();
        List<SelectOption> opts = new List<SelectOption>();

        // construct the select options from only the active picklist values.
        for (Schema.PicklistEntry val : vals) {
            if (val.isActive()) {
                opts.add(new SelectOption(String.valueOf(val.getLabel()), String.valueOf(val.getValue())));
            }    // end if
        }    // end for

        logMethodEnd('getFuelTypeOpts', opts);
        return opts;
    }    // end getFuelTypeOpts


    // Fuel type selection
    public String getFuelType() {
        return this.fuelType;
    }    // end getFuelType


    // Offer
    public PBS_AAAP_Offer__c getOffer() {
        return this.offer;
    }    // end getOffer


    // Other costs
    public List<PBS_AAAP_Other_Costs__c> getCosts() {
        return this.costs;
    }    // end getCosts


    // Other cost
    public PBS_AAAP_Other_Costs__c getOtherCost() {
        return this.otherCost;
    }    // end getOtherCost


    // Total Other cost 
    public Double getTotOtherCosts() {
        return this.totOtherCosts;
    }    // end getTotOtherCosts


    // OC Details
    public List<OtherCostsDetails> getOcDetails() {
        logMethodStart('getOcDetails');
        List<OtherCostsDetails> returnVal = new List<OtherCostsDetails>();
        for (PBS_AAAP_Other_Costs__c ocs : this.costs) {
            OtherCostsDetails ocd = new OtherCostsDetails();
            ocd.costId = ocs.Id;
            ocd.description = ocs.PBS_AAAP_SHORT_DESC__c;
            ocd.amount = ocs.PBS_AAAP_COST__c;
            ocd.removal = ocs.PBS_AAAP_COST_REMOVAL__c;
            returnVal.add(ocd);
        } // end for

        this.ocdetails = returnVal;
        logMethodEnd('getOcDetails', returnVal);
        return returnVal;
    }    // end getTotOtherCosts

    /*  Setters */

    // Set fuel type selection
    public void setFuelType(String pVal) {
        this.fuelType = pVal;
    }    // end setFuelType


    // Set other cost
    public void setOtherCost(PBS_AAAP_Other_Costs__c pVal) {
        this.otherCost = pVal;
    }    // end setOtherCost


    

    // Invoke add other costs page 
    public PageReference addOtherCosts() {
        logMethodStart('addOtherCosts');
        try {
            List<Double> addtlCostToAdd = new List<Double>();
            if(OthercostAmt != null && OthercostAmt.contains(',')){
                OthercostAmt = OthercostAmt.replaceAll(',', '');
                system.debug('OthercostAmt Inside@@@'+OthercostAmt);
            }
            system.debug('OthercostAmt@@@'+OthercostAmt);
            

    if(String.isBlank(this.otherCost.PBS_AAAP_SHORT_DESC__c) || String.isBlank(OthercostAmt) || (String.isNotBlank(OthercostAmt) && Decimal.valueOf(OthercostAmt) <= 0) ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: Both fields must be filled out in order for the cost to save. Please fill in both of the requested fields.');
                    Apexpages.addMessage(myMsg);
                    
                }
    else{
    
            this.otherCost.PBS_AAAP_COST__c = Decimal.valueof(OthercostAmt);
            
            if(this.ocdetails.size()>=3){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: Only three \'Other\' Operating Costs are permitted.');
                Apexpages.addMessage(myMsg);
            }
            else{
                
                PBS_AAAP_Other_Costs__c ocToAdd = new PBS_AAAP_Other_Costs__c(PBS_AAAP_OFFER_NUMBER__c = this.offerId,
                        PBS_AAAP_COST_TYPE__c = 'Other Cost',
                        PBS_AAAP_SHORT_DESC__c = this.otherCost.PBS_AAAP_SHORT_DESC__c,
                        PBS_AAAP_COST__c = this.otherCost.PBS_AAAP_COST__c,
                        PBS_AAAP_COST_REMOVAL__c = false);
        /*
                if(this.otherCost.PBS_AAAP_COST__c <= 0 || this.otherCost.PBS_AAAP_COST__c ==null || this.otherCost.PBS_AAAP_SHORT_DESC__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Both fields must be filled out in order for the cost to save. Please fill in both of the requested fields.');
                    Apexpages.addMessage(myMsg);
                    //System.debug('Error to be captured' +myMsg);
                }
        */{
                    addtlCostToAdd.add(ocToAdd.PBS_AAAP_COST__c);                        // add new cost to list for calculation
                    addtlCostToAdd.add(this.offer.PBS_AAAP_TOTAL_OTHER_COSTS__c);        // add previous total to list for calculation
                    this.totOtherCosts = this.calculateCosts(addtlCostToAdd);        // calculate the total other costs
                    this.offer.PBS_AAAP_TOTAL_OTHER_COSTS__c = this.totOtherCosts;    // update the current, "in memory" offer data with the new total
                    //added by syam to calculate and update 27.total cost
                    this.offer.PBS_AAAP_SRVC_UTIL_TOTAL__c = this.offer.PBS_AAAP_SRVC_UTIL_TOTAL__c + ocToAdd.PBS_AAAP_COST__c;
                    //added by syam on 06/03/2017 to re calculate cost per ABOA when costs are updated
                    this.offer.PBS_AAAP_COST_PER_ABOA__c = this.offer.PBS_AAAP_SRVC_UTIL_TOTAL__c / this.offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
                    upsert ocToAdd;
                    upsert offer;
                    // other costs
                    this.costs = this.soqlGetOtherCosts(this.offerId);
                    this.otherCost = new PBS_AAAP_Other_Costs__c();
                }
            }
            
            this.OthercostAmt = '';
            system.debug('OthercostAmt@@@ '+OthercostAmt);
            }
        } catch (DMLException e) {
            Apexpages.addMessages(e);
        }
        System.debug('***** costs: ' + costs);
        System.debug('***** ocost: ' + otherCost);
        logMethodEnd('addOtherCosts');
        return null;
    }    // end addOtherCosts


    // Invoke the other costs page from operating costs page
    public PageReference oCosts() {
        
        PageReference p = new PageReference('/AAAP/OtherCosts?offerId='+offerId);
        p.getParameters().put('offerId', offerId);
        p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
       
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-OtherCosts?edit=true&propertyId='+propId+'&offerId='+offerId;
        return null;
        
    }    // end oCosts


    // Invoke operating costs page 
    public PageReference addOperatingCosts() {
        PageReference p = new PageReference('/AAAP/OperatingCosts?offerId='+offerId);
        p.getParameters().put('offerId', offerId);              
        pageURLForRedirection = p.getUrl();
        
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-Costs?edit=true&propertyId='+propId+'&offerId='+offerId;
        p.setRedirect(false);
        return null;
        
    }  


    // "Continue" action
    public PageReference continueSave() {
        logMethodStart('continueSave');
        
        PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(offer,new List<String>{'Offer-M-Costs'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }
            return null;
        }
        // TODO logic for updating operating costs
        offer.PBS_AAAP_COST_PER_ABOA__c = (offer.PBS_AAAP_COST_PER_ABOA__c == null) ? 0.00 : offer.PBS_AAAP_COST_PER_ABOA__c;
        offer.PBS_AAAP_CLEANING_SALARIES__c = (offer.PBS_AAAP_CLEANING_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_SALARIES__c;
        offer.PBS_AAAP_CLEANING_SUPPLIES__c = (offer.PBS_AAAP_CLEANING_SUPPLIES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_SUPPLIES__c;
        offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = (offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c;
        offer.PBS_AAAP_HEATING_SALARIES__c = (offer.PBS_AAAP_HEATING_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_SALARIES__c;
        offer.PBS_AAAP_HEATING_FUEL_COST__c = (offer.PBS_AAAP_HEATING_FUEL_COST__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_FUEL_COST__c;
        offer.PBS_AAAP_HEATING_MAINTENANCE__c = (offer.PBS_AAAP_HEATING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_MAINTENANCE__c;
        offer.PBS_AAAP_ELECTRICAL_POWER__c = (offer.PBS_AAAP_ELECTRICAL_POWER__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_POWER__c;
        offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c = (offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c;
        offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = (offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c;
        offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c = (offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c;
        offer.PBS_AAAP_PLUMBING_WATER__c = (offer.PBS_AAAP_PLUMBING_WATER__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_WATER__c;
        offer.PBS_AAAP_PLUMBING_SUPPLIES__c = (offer.PBS_AAAP_PLUMBING_SUPPLIES__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_SUPPLIES__c;
        offer.PBS_AAAP_PLUMBING_MAINTENANCE__c = (offer.PBS_AAAP_PLUMBING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_MAINTENANCE__c;
        offer.PBS_AAAP_AC_UTILITIES__c = (offer.PBS_AAAP_AC_UTILITIES__c == null) ? 0.00 : offer.PBS_AAAP_AC_UTILITIES__c;
        offer.PBS_AAAP_AC_MAINTENANCE__c = (offer.PBS_AAAP_AC_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_AC_MAINTENANCE__c;
        offer.PBS_AAAP_ELEVATOR_SALARIES__c = (offer.PBS_AAAP_ELEVATOR_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_ELEVATOR_SALARIES__c;
        offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c = (offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c;
        offer.PBS_AAAP_BLDG_ENGINEERCOST__c = (offer.PBS_AAAP_BLDG_ENGINEERCOST__c == null) ? 0.00 : offer.PBS_AAAP_BLDG_ENGINEERCOST__c;
        offer.PBS_AAAP_SECURITY__c = (offer.PBS_AAAP_SECURITY__c == null) ? 0.00 : offer.PBS_AAAP_SECURITY__c;
        offer.PBS_AAAP_SSTAX_WORKCOMP__c = (offer.PBS_AAAP_SSTAX_WORKCOMP__c == null) ? 0.00 : offer.PBS_AAAP_SSTAX_WORKCOMP__c;
        offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c = (offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c;
        offer.PBS_AAAP_TOTAL_OTHER_COSTS__c = (offer.PBS_AAAP_TOTAL_OTHER_COSTS__c == null) ? 0.00 : offer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
        offer.PBS_AAAP_SRVC_UTIL_TOTAL__c = (offer.PBS_AAAP_SRVC_UTIL_TOTAL__c == null) ? 0.00 : offer.PBS_AAAP_SRVC_UTIL_TOTAL__c;
        offer.PBS_AAAP_REAL_ESTATE_TAXES__c = (offer.PBS_AAAP_REAL_ESTATE_TAXES__c == null) ? 0.00 : offer.PBS_AAAP_REAL_ESTATE_TAXES__c;
        offer.PBS_AAAP_INSURANCE__c = (offer.PBS_AAAP_INSURANCE__c == null) ? 0.00 : offer.PBS_AAAP_INSURANCE__c;
        offer.PBS_AAAP_BUILDING_MAINTENANCE__c = (offer.PBS_AAAP_BUILDING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_BUILDING_MAINTENANCE__c;
        offer.PBS_AAAP_LEASE_COMMISSION__c = (offer.PBS_AAAP_LEASE_COMMISSION__c == null) ? 0.00 : offer.PBS_AAAP_LEASE_COMMISSION__c;
        offer.PBS_AAAP_MANAGEMENT__c = (offer.PBS_AAAP_MANAGEMENT__c == null) ? 0.00 : offer.PBS_AAAP_MANAGEMENT__c;
        offer.PBS_AAAP_SECT2_TOTAL__c = (offer.PBS_AAAP_SECT2_TOTAL__c == null) ? 0.00 : offer.PBS_AAAP_SECT2_TOTAL__c;
              
               

        Map<String, Schema.SObjectField> offerFields = Schema.SObjectType.PBS_AAAP_Offer__c.fields.getMap();
        List<SObjectField> offerFieldNames = offerFields.values();
        List<Double> srvcUtilVals = new List<Double>();
        List<Double> sect2Vals = new List<Double>();
        List<Double> otherCostsVals = new List<Double>();
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
                'PBS_AAAP_SSTAX_WORKCOMP__c', 'PBS_AAAP_LANDSCAPING_MAINTENANCE__c'
        };

        Set<String> sect2Fields = new Set<String>{
                'PBS_AAAP_REAL_ESTATE_TAXES__c', 'PBS_AAAP_INSURANCE__c',
                'PBS_AAAP_BUILDING_MAINTENANCE__c', 'PBS_AAAP_LEASE_COMMISSION__c',
                'PBS_AAAP_MANAGEMENT__c'
        };

        try {
            // total the other costs
            for (PBS_AAAP_Other_Costs__c oc : costs) {
                otherCostsVals.add(oc.PBS_AAAP_COST__c);
            }    // end for
            
            // assemble the various value lists
            for (SObjectField str : offerFieldNames) {
                System.debug('***** str: ' + str.getDescribe().getName());
                if (srvcUtilFields.contains(str.getDescribe().getName())) {
                    srvcUtilVals.add(Double.valueOf(offer.get(str)));    // cost value for the service and utilities section
                    System.debug('***** srvcUtilVals: ' + srvcUtilVals);
                } else if (sect2Fields.contains(str.getDescribe().getName())) {
                    sect2Vals.add(Double.valueOf(offer.get(str)));        // cost value for section two
                    System.debug('***** sect2Vals: ' + sect2Vals);
                } // end if
            }    // end for

            PBS_AAAP_Offer__c tmpOffer = offer;
            tmpOffer.PBS_AAAP_SECT2_TOTAL__c = this.calculateCosts(sect2Vals);
            tmpOffer.PBS_AAAP_TOTAL_OTHER_COSTS__c = this.calculateCosts(otherCostsVals);
            tmpOffer.PBS_AAAP_HEATING_FUEL__c = this.fuelType;
            tmpOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c = this.calculateCosts(srvcUtilVals) + tmpOffer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
            
            System.debug('***** tmpOffer: ' + tmpOffer);
            if (RLPisCensus != true)  //weston: user to directly input this value for census RLP so no need to change it here.
            {
                tmpOffer.PBS_AAAP_COST_PER_ABOA__c = tmpOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c / tmpOffer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
            }
            System.debug('*** 2PBS_AAAP_COST_PER_ABOA__c is ***** ' + tmpOffer.PBS_AAAP_COST_PER_ABOA__c);
            System.debug('*** PBS_AAAP_COST_PER_ABOA__c is ***** ' + tmpOffer.PBS_AAAP_Vacant_Premise_Rate__c);
            if(tmpOffer.PBS_AAAP_COST_PER_ABOA__c < tmpOffer.PBS_AAAP_Vacant_Premise_Rate__c){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. The Adjustment for Vacant Premises rate is a portion of the total Operating Cost rate, and therefore cannot exceed the total Operating Cost rate. Please input an amount less than the total Operating Cost rate calculated on #4.');
                Apexpages.addMessage(myMsg);
                return null;
            }
            if (RLPisCensus != true){
                
                if (tmpOffer.PBS_AAAP_COST_PER_ABOA__c < 1.0) {                    
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 4. Your proposed Operating Costs are calculated to be under $1.00 per ABOA SF. Please ensure you enter total annual values in the fields below, not per square foot rates. If you would like to propose an Operating Cost rate under $1.00 per ABOA SF, please email AAAP.Manager@gsa.gov for further instructions.');
                    Apexpages.addMessage(myMsg1);
                    if(offer.PBS_AAAP_Vacant_Premise_Rate__c == null){
                        ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. Adjustment for Vacant premises must be entered. It is the last question on this page. If you are not offering an adjustment, put $0.00.');
                        Apexpages.addMessage(myMsg2);
                        return null;
                    }
                    System.debug('***** str: I AM HERE');
                    return null;
                }
            
                if(offer.PBS_AAAP_Vacant_Premise_Rate__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. Adjustment for Vacant premises must be entered. It is the last question on this page. If you are not offering an adjustment, put $0.00.');
                    Apexpages.addMessage(myMsg);
                    return null;
                }
                
           }

           if (RLPisCensus == true){
               
                if (tmpOffer.PBS_AAAP_COST_PER_ABOA__c < 1.0) {
                    
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 4. Your proposed Operating Costs are calculated to be under $1.00 per ABOA SF. Please ensure you enter total annual values in the fields below, not per square foot rates. If you would like to propose an Operating Cost rate under $1.00 per ABOA SF, please email AAAP.Manager@gsa.gov for further instructions.');
                    Apexpages.addMessage(myMsg1);
                    if(offer.PBS_AAAP_Vacant_Premise_Rate__c == null){
                        ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. Adjustment for Vacant premises must be entered. It is the last question on this page. If you are not offering an adjustment, put $0.00.');  //updated by Nik as part of OOLOP-596
                        Apexpages.addMessage(myMsg2);
                        return null;
                    }                    
                    return null;
                }
            
                if(offer.PBS_AAAP_Vacant_Premise_Rate__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. Adjustment for Vacant premises must be entered. It is the last question on this page. If you are not offering an adjustment, put $0.00.');  //updated by Nik as part of OOLOP-596
                    Apexpages.addMessage(myMsg);
                    return null;
                }
			
           }
         
        
		
            
        } catch (DMLException e) {
            Apexpages.addMessages(e);
        }
        
        
        
        
        
        //added on 12/15/2022
            PageReference p = new PageReference('/AAAP/SpacesAndRates');
            this.saveData();
            p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            pageURLForRedirection = p.getUrl();
      
            pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-SpaceRates?edit=true&propertyId='+propId+'&offerId='+offerId;
            p.setRedirect(false);
            return null;
        
        
    }    // end continueSave


    // "Back" button
    public PageReference back() {
       
        //added by S
        PageReference back = new PageReference('/AAAP/OfferParking');
        back.getParameters().put('offerId', offerId);
        back.setRedirect(false);
        
        pageURLForRedirection = back.getUrl();
       
       pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-Parking?edit='+(viewOnly ? 'false' : 'true')+'&offerId='+offerId+'&propertyId='+propId;
        return null;
        
    }    // end back
	
    public void performCalc() {
    	//saveForm();
    	saveData();
    }

    // "Save Form" button
    public PageReference saveForm() {
        logMethodStart('saveForm');
        PageReference saveForm = Apexpages.currentPage();
     
        Boolean errorFlag = false;
        this.saveData();
        
         
            PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(offer,new List<String>{'Offer-M-Costs'});
            if (response.errorMessages.size() > 0 ) {
                for(String error : response.errorMessages){
                    errorFlag = TRUE;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }
            }
            
            if(offer.PBS_AAAP_COST_PER_ABOA__c < offer.PBS_AAAP_Vacant_Premise_Rate__c){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. The Adjustment for Vacant Premises rate is a portion of the total Operating Cost rate, and therefore cannot exceed the total Operating Cost rate. Please input an amount less than the total Operating Cost rate calculated on #4.');
                Apexpages.addMessage(myMsg);
                errorFlag = TRUE;
            }
            if (RLPisCensus != true){
                
                if (offer.PBS_AAAP_COST_PER_ABOA__c < 1.0) {                    
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 4. Your proposed Operating Costs are calculated to be under $1.00 per ABOA SF. Please ensure you enter total annual values in the fields below, not per square foot rates. If you would like to propose an Operating Cost rate under $1.00 per ABOA SF, please email AAAP.Manager@gsa.gov for further instructions.');
                    Apexpages.addMessage(myMsg1);
                    if(offer.PBS_AAAP_Vacant_Premise_Rate__c == null){
                        ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. Adjustment for Vacant premises must be entered. It is the last question on this page. If you are not offering an adjustment, put $0.00.');
                        Apexpages.addMessage(myMsg2);
                        errorFlag = TRUE;
                    }
                    System.debug('***** str: I AM HERE');
                    errorFlag = TRUE;
                }
            
                if(offer.PBS_AAAP_Vacant_Premise_Rate__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. Adjustment for Vacant premises must be entered. It is the last question on this page. If you are not offering an adjustment, put $0.00.');
                    Apexpages.addMessage(myMsg);
                    errorFlag = TRUE;
                }
                
           }

           if (RLPisCensus == true){
               
                if (offer.PBS_AAAP_COST_PER_ABOA__c < 1.0) {
                    
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 4. Your proposed Operating Costs are calculated to be under $1.00 per ABOA SF. Please ensure you enter total annual values in the fields below, not per square foot rates. If you would like to propose an Operating Cost rate under $1.00 per ABOA SF, please email AAAP.Manager@gsa.gov for further instructions.');
                    Apexpages.addMessage(myMsg1);
                    if(offer.PBS_AAAP_Vacant_Premise_Rate__c == null){
                        ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. Adjustment for Vacant premises must be entered. It is the last question on this page. If you are not offering an adjustment, put $0.00.');  //updated by Nik as part of OOLOP-596
                        Apexpages.addMessage(myMsg2);
                        errorFlag = TRUE;
                    }                    
                    errorFlag = TRUE;
                }
            
                if(offer.PBS_AAAP_Vacant_Premise_Rate__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Costs Page: 28. Adjustment for Vacant premises must be entered. It is the last question on this page. If you are not offering an adjustment, put $0.00.');  //updated by Nik as part of OOLOP-596
                    Apexpages.addMessage(myMsg);
                    errorFlag = TRUE;
                }
			
		}	
        if(errorFlag){
            return null;
        }
        
        logMethodEnd('saveForm', saveForm);

        if( !( ( pageUrl == null ) || ( pageUrl == '' ) ) )
        {
            Integer len = pageUrl.length();
            if( pageUrl.mid(len-1, 1) == '=' )
            {
                pageUrl = pageUrl + offerId;   
            }            
            system.debug('pageUrl ' + pageUrl);   
            PageReference  p = new PageReference(pageUrl);
            pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                	return null;
                    
            
        }
        
                    
        return saveForm;
    }    // end saveForm


    // Remove selected other costs
    public PageReference remSelOperCosts() {
        logMethodStart('remSelOperCosts');
       
        try {
      
            // generate the list of costs to delete
            List<PBS_AAAP_Other_Costs__c> del = new List<PBS_AAAP_Other_Costs__c>();
            List<Double> newTotalCost = new List<Double>();
            //added by syam to update the 27.Total cost on operating cost page when cost is removed
            List<Double> costTobeRemoved = new List<Double>();

            for (OtherCostsDetails oc : this.ocdetails) {
                if (oc.removal) {    // generate the list of costs to delete
                    PBS_AAAP_Other_Costs__c d = new PBS_AAAP_Other_Costs__c(id = oc.costId);
                    costTobeRemoved.add(oc.amount);
                    del.add(d);
                } else {    // accumulate the new total costs
                    newTotalCost.add(oc.amount);
                }    // end if
            }    // end for

            if (del.size() > 0) {
                delete del;
                this.offer.PBS_AAAP_TOTAL_OTHER_COSTS__c = this.calculateCosts(newTotalCost);
                this.offer.PBS_AAAP_SRVC_UTIL_TOTAL__c = this.offer.PBS_AAAP_SRVC_UTIL_TOTAL__c - this.calculateCosts(costTobeRemoved);
                //added by syam on 06/03/2017 to re calculate cost per ABOA when costs are updated
                this.offer.PBS_AAAP_COST_PER_ABOA__c = this.offer.PBS_AAAP_SRVC_UTIL_TOTAL__c / this.offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
                upsert this.offer;
            } // end if

            this.costs = this.soqlGetOtherCosts(this.offerId);
            this.totOtherCosts = this.offer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
            this.OthercostAmt = '';
            system.debug('OthercostAmt@@@ '+OthercostAmt);
        } catch (DMLException e) {
            
            Apexpages.addMessages(e);
        }
        return null;
    }    // end remSelOperCosts


    /*  Utility Methods */

    // Get other costs data
    public List<PBS_AAAP_Other_Costs__c> soqlGetOtherCosts(String pId) {
        logMethodStart('soqlGetOtherCosts');
        List<PBS_AAAP_Other_Costs__c> returnVal = new List<PBS_AAAP_Other_Costs__c>();
        try {
            returnVal = [
                    SELECT p.PBS_AAAP_SHORT_DESC__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_COST__c,
                            p.PBS_AAAP_COST_TYPE__c, PBS_AAAP_COST_REMOVAL__c
                    FROM PBS_AAAP_Other_Costs__c p
                    WHERE p.PBS_AAAP_OFFER_NUMBER__c = :pId
            ];
        } catch (QueryException e) {
            Apexpages.addMessages(e);
        }    // end try

        logMethodEnd('soqlGetOtherCosts', returnVal);
        return returnVal;
    }    // end soqlGetOtherCosts


    // Calculate the cost totals
    public Double calculateCosts(List<Double> pVals) {
        logMethodStart('calculateCosts');
        System.debug('***** calculate costs pVals: ' + pVals);
        Double returnVal = 0.00;
        for (Double val : pVals) {
            returnVal = returnVal + val;
        }    // end for
        logMethodEnd('calculateCosts', returnVal);
        return returnVal;
    }    // end calculateCosts


    // Save the operating cost data
    public void saveData() {
        logMethodStart('saveData');
        //added by syam on 09/02/2016, if the field values are blanked out on the screen going to error page. so reset to 0.00 if null
        offer.PBS_AAAP_COST_PER_ABOA__c = (offer.PBS_AAAP_COST_PER_ABOA__c == null) ? 0.00 : offer.PBS_AAAP_COST_PER_ABOA__c;
        offer.PBS_AAAP_CLEANING_SALARIES__c = (offer.PBS_AAAP_CLEANING_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_SALARIES__c;
        offer.PBS_AAAP_CLEANING_SUPPLIES__c = (offer.PBS_AAAP_CLEANING_SUPPLIES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_SUPPLIES__c;
        offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = (offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c == null) ? 0.00 : offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c;
        offer.PBS_AAAP_HEATING_SALARIES__c = (offer.PBS_AAAP_HEATING_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_SALARIES__c;
        offer.PBS_AAAP_HEATING_FUEL_COST__c = (offer.PBS_AAAP_HEATING_FUEL_COST__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_FUEL_COST__c;
        offer.PBS_AAAP_HEATING_MAINTENANCE__c = (offer.PBS_AAAP_HEATING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_HEATING_MAINTENANCE__c;
        offer.PBS_AAAP_ELECTRICAL_POWER__c = (offer.PBS_AAAP_ELECTRICAL_POWER__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_POWER__c;
        offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c = (offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c;
        offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = (offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c;
        offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c = (offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c;
        offer.PBS_AAAP_PLUMBING_WATER__c = (offer.PBS_AAAP_PLUMBING_WATER__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_WATER__c;
        offer.PBS_AAAP_PLUMBING_SUPPLIES__c = (offer.PBS_AAAP_PLUMBING_SUPPLIES__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_SUPPLIES__c;
        offer.PBS_AAAP_PLUMBING_MAINTENANCE__c = (offer.PBS_AAAP_PLUMBING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_PLUMBING_MAINTENANCE__c;
        offer.PBS_AAAP_AC_UTILITIES__c = (offer.PBS_AAAP_AC_UTILITIES__c == null) ? 0.00 : offer.PBS_AAAP_AC_UTILITIES__c;
        offer.PBS_AAAP_AC_MAINTENANCE__c = (offer.PBS_AAAP_AC_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_AC_MAINTENANCE__c;
        offer.PBS_AAAP_ELEVATOR_SALARIES__c = (offer.PBS_AAAP_ELEVATOR_SALARIES__c == null) ? 0.00 : offer.PBS_AAAP_ELEVATOR_SALARIES__c;
        offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c = (offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c;
        offer.PBS_AAAP_BLDG_ENGINEERCOST__c = (offer.PBS_AAAP_BLDG_ENGINEERCOST__c == null) ? 0.00 : offer.PBS_AAAP_BLDG_ENGINEERCOST__c;
        offer.PBS_AAAP_SECURITY__c = (offer.PBS_AAAP_SECURITY__c == null) ? 0.00 : offer.PBS_AAAP_SECURITY__c;
        offer.PBS_AAAP_SSTAX_WORKCOMP__c = (offer.PBS_AAAP_SSTAX_WORKCOMP__c == null) ? 0.00 : offer.PBS_AAAP_SSTAX_WORKCOMP__c;
        offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c = (offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c;
        offer.PBS_AAAP_TOTAL_OTHER_COSTS__c = (offer.PBS_AAAP_TOTAL_OTHER_COSTS__c == null) ? 0.00 : offer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
        offer.PBS_AAAP_SRVC_UTIL_TOTAL__c = (offer.PBS_AAAP_SRVC_UTIL_TOTAL__c == null) ? 0.00 : offer.PBS_AAAP_SRVC_UTIL_TOTAL__c;
        offer.PBS_AAAP_REAL_ESTATE_TAXES__c = (offer.PBS_AAAP_REAL_ESTATE_TAXES__c == null) ? 0.00 : offer.PBS_AAAP_REAL_ESTATE_TAXES__c;
        offer.PBS_AAAP_INSURANCE__c = (offer.PBS_AAAP_INSURANCE__c == null) ? 0.00 : offer.PBS_AAAP_INSURANCE__c;
        offer.PBS_AAAP_BUILDING_MAINTENANCE__c = (offer.PBS_AAAP_BUILDING_MAINTENANCE__c == null) ? 0.00 : offer.PBS_AAAP_BUILDING_MAINTENANCE__c;
        offer.PBS_AAAP_LEASE_COMMISSION__c = (offer.PBS_AAAP_LEASE_COMMISSION__c == null) ? 0.00 : offer.PBS_AAAP_LEASE_COMMISSION__c;
        offer.PBS_AAAP_MANAGEMENT__c = (offer.PBS_AAAP_MANAGEMENT__c == null) ? 0.00 : offer.PBS_AAAP_MANAGEMENT__c;
        offer.PBS_AAAP_SECT2_TOTAL__c = (offer.PBS_AAAP_SECT2_TOTAL__c == null) ? 0.00 : offer.PBS_AAAP_SECT2_TOTAL__c;
              
               

        Map<String, Schema.SObjectField> offerFields = Schema.SObjectType.PBS_AAAP_Offer__c.fields.getMap();
        List<SObjectField> offerFieldNames = offerFields.values();
        List<Double> srvcUtilVals = new List<Double>();
        List<Double> sect2Vals = new List<Double>();
        List<Double> otherCostsVals = new List<Double>();
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
                'PBS_AAAP_SSTAX_WORKCOMP__c', 'PBS_AAAP_LANDSCAPING_MAINTENANCE__c'
        };

        Set<String> sect2Fields = new Set<String>{
                'PBS_AAAP_REAL_ESTATE_TAXES__c', 'PBS_AAAP_INSURANCE__c',
                'PBS_AAAP_BUILDING_MAINTENANCE__c', 'PBS_AAAP_LEASE_COMMISSION__c',
                'PBS_AAAP_MANAGEMENT__c'
        };

        try {
            // total the other costs
            for (PBS_AAAP_Other_Costs__c oc : costs) {
                otherCostsVals.add(oc.PBS_AAAP_COST__c);
            }    // end for
            
            // assemble the various value lists
            for (SObjectField str : offerFieldNames) {
                System.debug('***** str: ' + str.getDescribe().getName());
                if (srvcUtilFields.contains(str.getDescribe().getName())) {
                    srvcUtilVals.add(Double.valueOf(offer.get(str)));    // cost value for the service and utilities section
                    System.debug('***** srvcUtilVals: ' + srvcUtilVals);
                } else if (sect2Fields.contains(str.getDescribe().getName())) {
                    sect2Vals.add(Double.valueOf(offer.get(str)));        // cost value for section two
                    System.debug('***** sect2Vals: ' + sect2Vals);
                } // end if
            }    // end for

            PBS_AAAP_Offer__c tmpOffer = offer;
            tmpOffer.PBS_AAAP_SECT2_TOTAL__c = this.calculateCosts(sect2Vals);
            tmpOffer.PBS_AAAP_TOTAL_OTHER_COSTS__c = this.calculateCosts(otherCostsVals);
            tmpOffer.PBS_AAAP_HEATING_FUEL__c = this.fuelType;
            tmpOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c = this.calculateCosts(srvcUtilVals) + tmpOffer.PBS_AAAP_TOTAL_OTHER_COSTS__c;
            Boolean errorFlag = FALSE;

            this.totOtherCosts = tmpOffer.PBS_AAAP_TOTAL_OTHER_COSTS__c;

            System.debug('***** tmpOffer: ' + tmpOffer);
            if (RLPisCensus != true)  //weston: user to directly input this value for census RLP so no need to change it here.
            {
                tmpOffer.PBS_AAAP_COST_PER_ABOA__c = tmpOffer.PBS_AAAP_SRVC_UTIL_TOTAL__c / tmpOffer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
            }

            draftMsgFlag = '';
            if (tmpOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                tmpOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }
            
            
            
            
            
            if(!errorFlag){
                upsert tmpOffer;
                dao.updatePVRates(offerId);
            }

        } catch (DMLException e) {
            Apexpages.addMessages(e);
        }
        logMethodEnd('saveData');
        
        
    }    // end saveData

    public PageReference actionDeleteOffer() {
        logMethodStart('actionDeleteOffer');
        PageReference pref = null;
        System.debug('************* offer ::: ' + offer);
        System.debug('************* offer.PBS_AAAP_Offer_Status__c ::: ' + offer.PBS_AAAP_Offer_Status__c);
        System.debug('************* offer.PBS_AAAP_Offer_Status__c ::: ' + PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT);
        if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
            delete offer;    // Cascade delete - Deletes all Spaces and Othercosts associated with it.
            pref = new PageReference('/AAAP/PortalHome');
            pref.setRedirect(true);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + offer.PBS_AAAP_Offer_Status__c +
                    ', you can only delete on Draft or Pending Modification stage');
            ApexPages.addMessage(myMsg);
        }

        logMethodEnd('actionDeleteOffer', pref);
        return pref;
    }

    /** added by syam 03/22 as part of the cancel operation addition */
    public PageReference actionCancel() {
        logMethodStart('actionCancel');
        PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(true);
        logMethodEnd('actionCancel', pref);
        return pref;
    }
    /****************************************************************************************************************
    *   End Method Definitions
    *****************************************************************************************************************/
}