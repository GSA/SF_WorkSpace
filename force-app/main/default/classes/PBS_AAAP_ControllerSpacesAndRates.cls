public with sharing class PBS_AAAP_ControllerSpacesAndRates {

    // public String ratesQBSACPmtNew { get; set; }

    /****************************************************************************************************************
    *   Data Declaration 
    *****************************************************************************************************************/
    static final String GSADEFAULT = '';             // default value for Expiring GSA Lease Number
    private PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();   // generate an instance of the DAO class
    private PBS_AAAP_CALCULATIONS calc = new PBS_AAAP_CALCULATIONS();    // generate an instance of the Calculations class
    private Integer lrgSpaceOrdinal = 0;                  // the ordinal value of the largest space identifier
    private Map<String, List<PBS_AAAP_Rate__c>> ratesToSpace = new Map<String, List<PBS_AAAP_Rate__c>>();      // a map that relates a list of rates to a space ID

    public String offerId {get; set;}  // offer id
    public Boolean rendOuterSpace { get; set; }     // render flag for the "outer space" panel
    public Boolean rendAddSpace { get; set; }     // render flag for the new space panel
    public Boolean rendSuccSpace { get; set; }     // render flag for the succeeding space panel
    public Boolean rendRates { get; set; }     // render flag for the rates panel
    //-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
    public Boolean rendBSAC { get; set; }     // render flag for the rates panel
    //-------Vaishali Shah RLP FY14 Change-----------------------------------------------------------------------
    public Boolean allow2ndTierRate { get; set; }     // Allow 2nd Tier TI input
    //-------Vaishali Shah RLP FY15 Change-----------------------------------------------------------------------
    public Boolean isSucceeding {get;set;}
    public Boolean leaseTerm10_5 { get; set; }     // True=10,5 lease term. False=Option Term
    public Boolean rlpGT2016 { get; set; }     // True=15,10 lease term. False=5
    public String leaseTerm10_5Header { get; set; }     // leaseTerm10_5=true then 10,5; else 5+5
    public String leaseTerm15_10Header { get; set; }     // rlpGT2016=true then 15,10; else 5
    public PBS_AAAP_Offer__c offer { get; set; }     // offer
    public PBS_AAAP_Space__c space { get; set; }     // space
    public List<PBS_AAAP_Space__c> spaces { get; set; }         // spaces
    public List<PBS_AAAP_Rate__c> rates { get; set; }         // rate
    public PBS_AAAP_RLP__c rlp { get; set; }     // RLP
    public List<SpaceAndRatesDetails> details { get; set; }         // outer space screen fields
    public PBS_AAAP_QuestionLabels qLabels { get; set; }     // question labels
    public String sfOfferedType { get; set; }     // square footage offered
    public String feePrcntgOrDollar { get; set; }     // Arch/Eng UOM field
    public Double minOfferedSpace { get; set; }     // minimum offered space
    public Decimal maxOfferedSpace { get {return maxOfferedSpace.round(System.RoundingMode.HALF_EVEN);} set {maxOfferedSpace = value.round(System.RoundingMode.HALF_EVEN);} }       // maximum offered space
    public Double maxContABOA { get; set; }     // maximum contiguous space
    public RateEntry rateE { get; set; }     // rate data screen fields
    public Double totMarkup { get; }             // total markup for space
    public String pageUrl {get;set;}
    public Boolean validate {get;set;}
    public Date Spacedate {get;set;}

    public Boolean fromAddSpace { get; set; }     // render flag for the "outer space" panel
    public Boolean fromNeedSpace { get; set; }     // render flag for the new space panel

    public String newOrCont {get; set;}
    public Id savedSpace {get; set;}
    public Decimal userIputTIA {get; set;}
    public Decimal userInputBSAC {get; set;}

    public Boolean initialised {get; set;}

    public List<String> panelIds {
        get {
            List<String> returnVals = new List<String>{
                    'panel_outerspace', 'panel_NewSpace', 'panel_SuccSpace'
            };
            return returnVals;
        }
        set;
    }
    public String leaseDefault { get {return PBS_AAAP_ControllerSpacesAndRates.GSADEFAULT;} }       // default expiring lease
    //added by syam
    public Boolean isValidUser { get; set; }
    public PBS_AAAP_Offer__c spaceAndRates { get; set; }
    public String draftMsgFlag { get; set; }
    public String readOnlyScreen { get; set; }
    //added by syam ganna on 12/29/2016 for Census release
    public String regionCode { get; set; }
	public string pageURLForRedirection {get;set;}

    /*  SpaceAndRates Details   ***********************************************************
    *   
    *   This class is used to render the space and rates data "matrix" table on the "outer
    *   space" page.
    **************************************************************************************/
    public class SpaceAndRatesDetails {
        public Boolean selected { get; set; }
        public String spaceNo { get; set; }
        public String leaseType { get; set; }
        public String GSALeaseNo { get; set; }
        public String sqFtOffered { get; set; }
        public Double fiveYrFS { get; set; }
        public Double fiveYrPV { get; set; }
        public Double fiveFiveYrFS { get; set; }
        public Double fiveFiveYrPV { get; set; }
        public Double tenYrFS { get; set; }
        public Double tenYrPV { get; set; }
        public String spaceID { get; set; }

        /*  Construtor  */
        public SpaceAndRatesDetails() {
            this.selected = false;
        } // end constructor


    }  // end class SpaceAndRatesDetails


    /*  Rate Entry  **********************************************************************
    *   
    *   This class is used to render the space and rates data "matrix" table on the "outer
    *   space" page.
    **************************************************************************************/
    public class RateEntry {
        public Decimal fiveYrFS { get {return fiveYrFS.setScale(2);} set {fiveYrFS = value.setScale(2);} }
        public Decimal fiveFiveYrFS { get {return fiveFiveYrFS.setScale(2);} set {fiveFiveYrFS = value.setScale(2);} }
        public Decimal tenYrFS { get {return tenYrFS.setScale(2);} set {tenYrFS = value.setScale(2);} }
        public Double fiveYrOpCosts { get; set; }
        public Double fiveFiveYrOpCosts { get; set; }
        public Double tenYrOpCosts { get; set; }
        public Double fiveYrAPR { get; set; }
        public Double fiveFiveYrAPR { get; set; }
        public Double tenYrAPR { get; set; }
        public Double fiveYrTIAmorCosts { get; set; }
        public Double fiveFiveYrTIAmorCosts { get; set; }
        public Double tenYrTIAmorCosts { get; set; }
        public Double fiveYrFirmTerm { get; set; }
        public Double fiveFiveYrFirmTerm { get; set; }
        public Double tenYrFirmTerm { get; set; }
        public Double fiveFiveYrOptTerm { get; set; }
        public Double tenFiveYrOptTerm { get; set; }   // RLP FY17 Vaishali
        public Double tenEightYrOptTerm{get;set;}
        public Double fiveYrTIAmorCosts2 { get; set; }
        public Double fiveFiveYrTIAmorCosts2 { get; set; }
        public Double tenYrTIAmorCosts2 { get; set; }
        public Double fiveYrOTHvacCosts { get; set; }
        public Double fiveFiveYrOTHvacCosts { get; set; }
        public Double tenYrOTHvacCosts { get; set; }
        public Double fiveYrDayTimeCleanCosts { get; set; }
        public Double fiveFiveYrDayTimeCleanCosts { get; set; }
        public Double tenYrDayTimeCleanCosts { get; set; }

        public Integer fiveYrFreeRentFIRM { get; set; }
        public Integer fiveFiveYrFreeRentFIRM { get; set; }
        public Integer tenYrFreeRentFIRM { get; set; }

        public Double fiveYrFreeRentOption { get; set; }
        public Double fiveFiveYrFreeRentOption { get; set; }
        public Double tenYrFreeRentOption { get; set; }
        public Double fiveYrBrokerageComm { get; set; }
        public Double fiveFiveYrBrokerageComm { get; set; }
        public Double tenYrBrokerageComm { get; set; }
        public String spaceID { get; set; }
        public String leaseType { get; set; }
        public String GSALeaseNo { get; set; }
        public Double sqFtOffered { get; set; }
        public Double fiveYrPV { get; set; }
        public Double fiveFiveYrPV { get; set; }
        public Double tenYrPV { get; set; }
        public String fiveYrId { get; set; }
        public String fiveFiveYrId { get; set; }
        public String tenYrId { get; set; }
        //-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
        public Double fiveYrBSAC { get; set; }
        public Double fiveFiveYrBSAC { get; set; }
        public Double tenYrBSAC { get; set; }

        public Double fiveYrBSACRate { get; set; }
        public Double fiveFiveYrBSACRate { get; set; }
        public Double tenYrBSACRate { get; set; }



        //------------------------------------------------------------------------------------------------------------------

        /*  Construtor  */
        public RateEntry() {
            // set defaults for the calculation values
            this.fiveYrFS = 0.00;
            this.fiveFiveYrFS = 0.00;
            this.tenYrFS = 0.00;
            this.fiveYrOpCosts = 0.00;
            this.fiveFiveYrOpCosts = 0.00;
            this.tenYrOpCosts = 0.00;
            this.fiveYrAPR = 0.00;
            this.fiveFiveYrAPR = 0.00;
            this.tenYrAPR = 0.00;
            this.fiveYrTIAmorCosts = 0.00;
            this.fiveFiveYrTIAmorCosts = 0.00;
            this.tenYrTIAmorCosts = 0.00;
            this.fiveYrFirmTerm = 0.00;
            this.fiveFiveYrFirmTerm = 0.00;
            this.tenYrFirmTerm = 0.00;
            this.fiveFiveYrOptTerm = 0.00;
            this.tenFiveYrOptTerm = 0.00;       // RLP FY17 Vaishali
            this.tenEightYrOptTerm = 0.00;
            this.fiveYrTIAmorCosts2 = 0.00;
            this.fiveFiveYrTIAmorCosts2 = 0.00;
            this.tenYrTIAmorCosts2 = 0.00;
            this.fiveYrOTHvacCosts = 0.00;
            this.fiveFiveYrOTHvacCosts = 0.00;
            this.tenYrOTHvacCosts = 0.00;
            this.fiveYrDayTimeCleanCosts = 0.00;
            this.fiveFiveYrDayTimeCleanCosts = 0.00;
            this.tenYrDayTimeCleanCosts = 0.00;

            this.fiveYrFreeRentFIRM = 0;
            this.fiveFiveYrFreeRentFIRM = 0;
            this.tenYrFreeRentFIRM = 0;

            this.fiveYrFreeRentOption = 0.00;
            this.fiveFiveYrFreeRentOption = 0.00;
            this.tenYrFreeRentOption = 0.00;
            this.fiveYrBrokerageComm = 0.00;
            this.fiveFiveYrBrokerageComm = 0.00;
            this.tenYrBrokerageComm = 0.00;
            this.spaceID = '';
            this.leaseType = '';
            this.GSALeaseNo = '';
            this.sqFtOffered = 0.00;
            this.fiveYrPV = 0.00;
            this.fiveFiveYrPV = 0.00;
            this.tenYrPV = 0.00;
            //-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
            this.fiveYrBSAC = 0.00;
            this.fiveFiveYrBSAC = 0.00;
            this.tenYrBSAC = 0.00;

            this.fiveYrBSACRate = 0.00;
            this.fiveFiveYrBSACRate = 0.00;
            this.tenYrBSACRate = 0.00;



            //-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------


        } // end constructor


    }  // end class SpaceAndRatesDetails


    /****************************************************************************************************************
    *   End Data Declaration 
    *****************************************************************************************************************/


    /****************************************************************************************************************
    *   Constructors 
    *****************************************************************************************************************/

    public PBS_AAAP_ControllerSpacesAndRates() {

    //No Arg constructor
    //public PBS_AAAP_ControllerSpacesAndRates() {
        try {
            // prepare the render flag defaults
            offerId = ApexPages.currentPage().getParameters().get('offerId');
 
            initialised = FALSE;
            newOrCont = '';
            rendOuterSpace = true;
            rendAddSpace = false;
            rendRates = false;
            rendSuccSpace = false;
            allow2ndTierRate = true;
            leaseTerm10_5 = true;    // Vaishali RLP FY15
            rlpGT2016 = true; //Vaishali RLP FY17
            isSucceeding = false;
            leaseTerm10_5Header = '15, 13';  // Vaishali RLP FY15
            leaseTerm15_10Header = '17, 15';  // Vaishali RLP FY15
            // prepare some defaults
            sfOfferedType = 'Range of ABOA';
            feePrcntgOrDollar = '';
            rateE = new RateEntry();
            System.debug('***inside controller ***');
            draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
            //added by syam for offerId validation
            System.debug('*** offerId in PBS_AAAP_ControllerSpacesAndRates is ***' + offerId);
            
            spaceAndRates = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            validate = FALSE;
            if (spaceAndRates.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }

            // obtain data about the existing spaces, if any
            spaces = dao.getSpaces(offerId);

            // obtain data about the existing offer or offer in progress                     
            offer = dao.getOffer(offerId);

            // obtain data about the RLP used for the Offer
            rlp = dao.getRLP(offer.PBS_AAAP_RLP_Number__c);
            regionCode = rlp.PBS_AAAP_Region__c;
            //regionCode = '10/5 Term - All Regions';
            System.debug('rlp regionCode is *****' + regionCode);
            System.debug('&&&&& rlp.PBS_AAAP_DISCOUNT_RATE__c: ' + rlp.PBS_AAAP_DISCOUNT_RATE__c + ' rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c' + rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c);
            // rlp.PBS_AAAP_DISCOUNT_RATE__c = 5.0;
            // rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 2.50;

            System.debug('#### rlp: ' + rlp);
            System.debug('#### offer: ' + offer);
            //System.debug('&&&&& rlp.PBS_AAAP_DISCOUNT_RATE__c: ' + rlp.PBS_AAAP_DISCOUNT_RATE__c+' rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c'+rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c);

            //-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
            rendBSAC = false;     // render flag for the BSAC panel
            rendBSAC = (rlp.PBS_AAAP_BSAC_per_ABOA__c > 0) ? true : false;
            //-------INC0468662 Above value will always be true
            //-------Vaishali Shah RLP FY14 Changes-----------------------------------------------------------------------
            allow2ndTierRate = rlp.PBS_AAAP_ALLOW_TIER2_AMMORT__c;
            //-------Vaishali Shah RLP FY15 Changes-----------------------------------------------------------------------
            leaseTerm10_5 = rlp.PBS_AAAP_Allow_10_5_Term__c;
            rlpGT2016 = (Integer.valueOf(rlp.PBS_AAAP_Year__c) > 2016) ? true : false;
            System.debug('&&&&& rlp.PBS_AAAP_Allow_10_5_Term__c: ' + rlp.PBS_AAAP_Allow_10_5_Term__c);
            leaseTerm10_5Header = '15, 13'; // Vaishali RLP FY15
            leaseTerm15_10Header = '17, 15'; // Vaishali RLP FY17
            System.debug('&&&&& leaseTerm10_5Header: ' + leaseTerm10_5Header);
            System.debug('&&&&& leaseTerm15_10Header: ' + leaseTerm15_10Header);

            // obtain data about the existing rates or rates in progress                          
            rates = dao.getRates(offerId);

            this.ratesToSpace = this.genMapRatesToSpace(rates, spaces);

            // populate the outerspace table data
            if (spaces.size() > 0) {
                details = spaceSort(spaces, rates);
                System.debug('***** details: ' + details);
            }   // end if 

            // populate the question labels
            qLabels = new PBS_AAAP_QuestionLabels(offer.PBS_AAAP_RLP_Number__c);

            if (offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c == null) {
                offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 0;
                maxOfferedSpace = 0;
            } else {
                maxOfferedSpace = offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c.round(System.RoundingMode.HALF_EVEN);
            }

            if (offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c == null) {
                offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = 0;
                maxContABOA = 0;
            } else {
                maxContABOA = offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c;
            }

        } catch (Exception e) {
            Apexpages.addMessages(e);
        }

    }   // end constructor

    /****************************************************************************************************************
    *   End Constructors 
    *****************************************************************************************************************/


    /****************************************************************************************************************
    *   Method Definitions 
    *****************************************************************************************************************/


    /**************************************  Getters **************************************/

    // the options available for selecting spaces
    public List<SelectOption> getSpaceOpts() {
        Schema.DescribeFieldResult fldResult = PBS_AAAP_Space__c.PBS_AAAP_IDENTIFIER_TYPE__c.getDescribe();
        List<Schema.PicklistEntry> vals = fldResult.getPicklistValues();
        List<SelectOption> opts = new List<SelectOption>();

        // construct the select options from only the active picklist values.
        for (Schema.PicklistEntry val : vals) {
            if (val.isActive()) {
                opts.add(new SelectOption(String.valueOf(val.getLabel()), String.valueOf(val.getValue())));
            }   // end if
        }   // end for

        return opts;
    }   // end getSpaceOpts

    // obtain the Architectural and Engineering fee options
    public List<SelectOption> getFeeOpts() {
        Schema.DescribeFieldResult fldResult = PBS_AAAP_Space__c.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c.getDescribe();//weston found space..PBS_AAP two periods
        List<Schema.PicklistEntry> vals = fldResult.getPicklistValues();
        List<SelectOption> opts = new List<SelectOption>();

        // construct the select options from only the active picklist values.
        for (Schema.PicklistEntry val : vals) {
            if (val.isActive()) {
                opts.add(new SelectOption(String.valueOf(val.getLabel()), String.valueOf(val.getValue())));
            }   // end if
        }   // end for

        return opts;
    }   // end getFeeOpts


    /**************************************  Setters **************************************/


    /**************************************  Actions **************************************/

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('TRUE','Yes'));
        options.add(new SelectOption('FALSE','No'));
        return options;
    }

    public void setValsFor6() {
        system.debug(LoggingLevel.INFO, '*****'+space.PBS_AAAP_Offeror_Created_TI__c);
        system.debug(LoggingLevel.INFO, '*****'+space.PBS_AAAP_Offeror_Created_BSAC__c);
        system.debug(LoggingLevel.INFO, '*****'+newOrCont);
        if (space.PBS_AAAP_Offeror_Created_TI__c == NULL && space.PBS_AAAP_Offeror_Created_BSAC__c == NULL) {
            if (newOrCont == 'FALSE') {
                userIputTIA = rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c.setScale(2);
                userInputBSAC = rlp.PBS_AAAP_BSAC_per_ABOA__c.setScale(2);
            } else {
                userIputTIA = rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c.setScale(2);
                userInputBSAC = rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c.setScale(2);
            }
        }
    }
    /*  "Add" actions */
    // action to allow the entry of "new" space and rates data    
    public PageReference addNewSpace() {
        System.debug('***** addNewSpace triggered *****');
        boolean errorflag = validateOfferFormFields();
        System.debug('errorflag in addNewSpace ***' + errorFlag);
        if (errorflag == true) {
            return null;
        }
        try {

            // update the offer to include data entered on the "outer space" page
            this.saveData();
            // configure the appropriate panel rendering values
            this.rendOuterSpace = false;
            this.rendAddSpace = true;
            this.rendRates = false;
            this.rendSuccSpace = false;


            // generate new space data
            space = new PBS_AAAP_Space__c();
            System.debug('***** lrgSpaceOrdinal before gathering largest ordinal: ' + lrgSpaceOrdinal);
            System.debug('spaces before LrgOrdinal ***' + spaces);
            lrgSpaceOrdinal = getLrgOrdinal(spaces);
            System.debug('***** lrgSpaceOrdinal after gathering largest ordinal: ' + lrgSpaceOrdinal);
            space = defaultSpace(offerId);
            space.PBS_AAAP_IDENTIFIER_TYPE__c = sfOfferedType;
            space.PBS_AAAP_IDENTIFIER_ID__c = String.valueOf(++lrgSpaceOrdinal);
            //space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = !Boolean.valueOf(newOrCont);
            space.PBS_AAAP_TOTAL_MARKUP__c = 0.00;
            System.debug('***** space identifier: ' + space.PBS_AAAP_IDENTIFIER_ID__c);
            System.debug('***** (addSpace) space: ' + space);
            // logic to update field PBS_AAAP_MetroWalkableGoogle__c from propertyObject;
            PBS_AAAP_Offer__c offer = [SELECT property__r.pbs_aaap_metrowalkable__c FROM PBS_AAAP_Offer__c WHERE id = :offerId];
            if (offer.property__r.pbs_aaap_metrowalkable__c == true) {
                space.PBS_AAAP_MetroWalkableGoogle__c = true;
            } else {
                space.PBS_AAAP_MetroWalkableGoogle__c = false;
            }
            addRateneedSpace();
        } catch (Exception e) {
            Apexpages.addMessages(e);
        }

        return null;
    }   // end addNewSpace


    // action to add a "succeeding" space
    public PageReference addSucceedingSpace() {
        isSucceeding = true;
        boolean errorflag = validateOfferFormFields();

        if (errorflag == true) {
            return null;
        }
        try {

            // save the outerspace data to the backend
            this.saveData();
            this.rendOuterSpace = false;
            this.rendAddSpace = false;
            this.rendRates = false;
            this.rendSuccSpace = true;

            // insure that the succeeding space is added to the offer in context
            space = new PBS_AAAP_Space__c();
            space = defaultSpace(offerId);
            lrgSpaceOrdinal = getLrgOrdinal(spaces);
            System.debug('lrgSpaceOrdinal is ***' + lrgSpaceOrdinal);
            space.PBS_AAAP_IDENTIFIER_TYPE__c = sfOfferedType;
            space.PBS_AAAP_IDENTIFIER_ID__c = String.valueOf(++lrgSpaceOrdinal);
            space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false;                              // succeeding space
            space.PBS_AAAP_TOTAL_MARKUP__c = 0.00;
            // logic to update field PBS_AAAP_MetroWalkableGoogle__c from propertyObject;
            PBS_AAAP_Offer__c offer = [SELECT property__r.pbs_aaap_metrowalkable__c FROM PBS_AAAP_Offer__c WHERE id = :offerId];
            if (offer.property__r.pbs_aaap_metrowalkable__c == true) {
                space.PBS_AAAP_MetroWalkableGoogle__c = true;
            } else {
                space.PBS_AAAP_MetroWalkableGoogle__c = false;
            }
        } catch (Exception e) {
            Apexpages.addMessages(e);
        }

        return null;
    }   // end addSucceedingSpace    

    public PageReference addRateAddSpace() {
        this.fromAddSpace = true;
        this.fromNeedSpace = false;
        addRate();
        return null;
    }

    public void addRateneedSpace() {
        this.fromAddSpace = false;
        this.fromNeedSpace = true;
        addRate();
        //return null;
    }

	public void backToPreviousPage() {	
        PageReference pref = new PageReference('/AAAP/spacesAndRates?OfferId='+offerId);
        pref.getParameters().put('offerId', offerId);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/spacesAndRates', Label.LOP_Community_Base_URL+'AAAP-SpacesAndRates');
        pref.setRedirect(false);
        //return null;

        //pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pref.getUrl());
        //return pref;	
    }

    // action to add a rate, or to "edit" a rate from the inner space "view"
    public void addRate() {
        System.debug('##### Begin -- addRate ');
        ApexPages.getMessages().clear();

        try {
            // weston don't let the page continue:


            // show the rates portion of the page
            this.rendOuterSpace = false;
            this.rendAddSpace = true;
            this.rendRates = true;
            this.rendSuccSpace = false;

            Boolean hasNoRates = true;
            // refresh the screen fields so that the next rates are clean

            // insure that the space is added to the DB to obtain the ID for manipulation
            //this.saveSpace();
            System.debug('***** (addRate) space: ' + space);
            rateE = new RateEntry();
            // determine if this is a true "add" or an "edit" 
            System.debug('***** space.Id: ' + space.Id);
            if (this.ratesToSpace.containsKey(space.Id)) {
                List<PBS_AAAP_Rate__c> tmpRates = this.ratesToSpace.get(space.Id);
                System.debug('***** tmpRates: ' + tmpRates);
                if (tmpRates.size() > 0) {
                    hasNoRates = false;
                }   // end if
            }   // end if


            if (hasNoRates) {                                   // add rate
                System.debug('inside hasNoRates loop in addRates()');
                // populate the rate entry data with necessary operating cost totals
                rateE.fiveYrOpCosts = (offer.PBS_AAAP_COST_PER_ABOA__c > 0) ? offer.PBS_AAAP_COST_PER_ABOA__c : 0.00;
                rateE.fiveFiveYrOpCosts = (offer.PBS_AAAP_COST_PER_ABOA__c > 0) ? offer.PBS_AAAP_COST_PER_ABOA__c : 0.00;
                rateE.tenYrOpCosts = (offer.PBS_AAAP_COST_PER_ABOA__c > 0) ? offer.PBS_AAAP_COST_PER_ABOA__c : 0.00;


                // populate the amortization costs
                rateE.fiveYrTIAmorCosts = 0.00;
                rateE.fiveFiveYrTIAmorCosts = 0.00;
                rateE.tenYrTIAmorCosts = 0.00;

                // populate the Firm term fully serviced lease rate
                rateE.fiveYrFirmTerm = 0.00;
                rateE.fiveFiveYrFirmTerm = 0.00;
                rateE.tenYrFirmTerm = 0.00;

                // insure the rate contains the appropriate space ID
                rateE.spaceID = space.Id;
            } else {
                List<PBS_AAAP_Rate__c> tempRates = dao.getRatesFromSpace(space.Id);
                rateE = convertPbsAaapRate(tempRates);

                // populate the rate entry data with necessary operating cost totals (this is done for existing rates also, so to insure that any operating cost adjustments are synchronized with the rates)
                rateE.fiveYrOpCosts = (offer.PBS_AAAP_COST_PER_ABOA__c != rateE.fiveYrOpCosts) ? offer.PBS_AAAP_COST_PER_ABOA__c : rateE.fiveYrOpCosts ;
                rateE.fiveFiveYrOpCosts = (offer.PBS_AAAP_COST_PER_ABOA__c != rateE.fiveFiveYrOpCosts) ? offer.PBS_AAAP_COST_PER_ABOA__c : rateE.fiveFiveYrOpCosts;
                rateE.tenYrOpCosts = (offer.PBS_AAAP_COST_PER_ABOA__c != rateE.tenYrOpCosts) ? offer.PBS_AAAP_COST_PER_ABOA__c : rateE.tenYrOpCosts;
            } // end if

        } catch (Exception e) {
            Apexpages.addMessages(e);
        }

        System.debug('##### End -- addRate ');
        //return null;
    }   // end addRate


    /*  "Edit" actions  */

    //  action to allow the editing of a rate 
    public void editRate() {
        System.debug('##### Begin -- editRate ');
        //added by syam on 09/14/2016 to check the validation errors before saving the data
        boolean errorflag = validateOfferFormFields();
        if (errorflag == true) {
            //return null;
        }
        //added by syam to save the data on the screen before opening the editrate screen
        this.saveData();
        Map<Id, PBS_AAAP_Space__c> mapSpaces = new Map<Id, PBS_AAAP_Space__c>();
        mapSpaces.putAll(spaces);

        spaceAndRates = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);

        for (SpaceAndRatesDetails detail : details) {
            if (detail.selected) {
                space = mapSpaces.get(detail.spaceId);
                System.debug('##### arch / eng UOM: ' + space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c);
                sfOfferedType = space.PBS_AAAP_IDENTIFIER_TYPE__c;                                                  // populate the range or "all" radio option
                feePrcntgOrDollar = space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c;           // populate the "%" or "$" for arch/eng fee radio option
                addRate();      // the addRate function can distinquish between new or existing rates and spaces            
                break;  // only process one space's rate edit at a time     
            }   //  end if
        }   // end for
        System.debug('##### Begin -- editRate ');
        //return null;
    }   // end editRate  


    //  action to allow the editing of a space
    public PageReference editSpace() {
        //added by syam on 09/14/2016 to check the validation errors before saving the data
        boolean errorflag = validateOfferFormFields();
        if (errorflag == true) {
            return null;
        }
        //added by syam to save the data on the screen before opening the editspace screen
        this.saveData();
        Map<Id, PBS_AAAP_Space__c> mapSpaces = new Map<Id, PBS_AAAP_Space__c>();
        mapSpaces.putAll(spaces);
        System.debug('##### Begin editSpace');
        //added by syam for the PBS_AAAP_COST_PER_ABOA__c validation
        spaceAndRates = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);

        System.debug('***** editSpace: ' + spaces);
        for (SpaceAndRatesDetails detail : details) {
            if (detail.selected) {
                space = mapSpaces.get(detail.spaceId);
                if(detail.LeaseType == 'New'){
                    isSucceeding = FALSE;
                    newOrCont = 'FALSE';
                } else {
                    isSucceeding = TRUE;
                    newOrCont = 'TRUE';
                }
                break;  // only process one space edit at a time        
            }   //  end if
        }   // end for

        System.debug(LoggingLevel.INFO, '***** space: ' + space);
        sfOfferedType = space.PBS_AAAP_IDENTIFIER_TYPE__c;                  // populate the range or "all" radio option
        feePrcntgOrDollar = space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c;   // populate the "%" or "$" for arch/eng fee radio option

        system.debug(LoggingLevel.INFO, '********'+space.PBS_AAAP_Offeror_Created_TI__c);
        system.debug(LoggingLevel.INFO, '********'+space.PBS_AAAP_Offeror_Created_BSAC__c);
        system.debug(LoggingLevel.INFO, '********'+space.Id);

        userIputTIA = space.PBS_AAAP_Offeror_Created_TI__c;
        userInputBSAC = space.PBS_AAAP_Offeror_Created_BSAC__c;

        editRate();
        // determine how best to render the edit process for the space
        if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {
            this.rendOuterSpace = false;
            this.rendAddSpace = true;
            this.rendRates = true;
            this.rendSuccSpace = false;
        } else {
            this.rendOuterSpace = false;
            this.rendAddSpace = true;
            this.rendRates = true;
            this.rendSuccSpace = false;
        }   // end if

        //if(space.LeaseType == 'New'){}

        System.debug('##### End editSpace');
        return null;
    } // end editSpace


    /*  "Delete" Actions    */

    // delete space
    public PageReference deleteSpace() {
        System.debug('##### Begin deleteSpaces: ');
        List<PBS_AAAP_Space__c> delSpaces = new List<PBS_AAAP_Space__c>();
        Set<String> delRateIds = new Set<String>();
        Set<String> delSpaceIds = new Set<String>();
        List<PBS_AAAP_Rate__c> delRates = new List<PBS_AAAP_Rate__c>();
        Savepoint sp0 = Database.setSavepoint();      // generate a save point for rollback purposes
        try {
            System.debug('***** details: ' + details);
            for (SpaceAndRatesDetails detail : details) {
                if (detail.selected) {
                    PBS_AAAP_Space__c delSpace = new PBS_AAAP_Space__c(ID = detail.spaceId);
                    delSpaces.add(delSpace);
                    delSpaceIds.add(detail.spaceId);
                }   // end if

                // must also delete corresponding rates for spaces being deleted
                for (PBS_AAAP_Rate__c rate : rates) {
                    if (delSpaceIds.contains(rate.PBS_AAAP_SPACE__c)) {
                        System.debug('***** rate space ID: ' + rate.PBS_AAAP_SPACE__c);
                        delRateIds.add(rate.ID);
                    }   // end if
                } // end for
            }   // end for

            for (String str : delRateIds) {
                PBS_AAAP_Rate__c delR = new PBS_AAAP_Rate__c(ID = str);
                delRates.add(delR);
            }   // end for

            System.debug('***** delRateIds size: ' + delRateIds.size());
            System.debug('***** delRates size: ' + delRates.size());
            System.debug('***** delRates: ' + delRates);
            System.debug('***** delSpaces: ' + delSpaces);
            if (delRates.size() > 0) {
                delete delRates;
            }      // delete the rates that belong to the space.
            if (delSpaces.size() > 0) {
                delete delSpaces;
            } // delete the spaces

        } catch (Exception e) {
            Apexpages.addMessages(e);
            System.debug('********** save space error: ' + e.getStackTraceString());
            Database.rollback(sp0);
        }   // end try/catch

        refreshNumbers();

        //PageReference pgSpaceAndRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference pgSpaceAndRates = new PageReference('/AAAP/SpacesAndRates');
        pgSpaceAndRates.setRedirect(true);
        pgSpaceAndRates.getParameters().put('offerId', offerId);
        pageURLForRedirection = pgSpaceAndRates.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/SpacesAndRates', Label.LOP_Community_Base_URL+'AAAP-SpacesAndRates');
            
        System.debug('##### End deleteSpaces: ');
        return Null;
    }   // end deleteSpace


    /*  "Continue" Actions  */

    // "Continue" action
    public PageReference continueSave() {

        boolean errorflag = validateOfferFormFields();

        if (errorflag == true) {
            return null;
        }
        
        //PageReference pgOfferAttachments = Page.PBS_AAAP_OfferAttachments;
        PageReference pgOfferAttachments = new PageReference('/AAAP/OfferAttachments');

        try {
            // update the offer to include data entered on the "outer space" page
            this.saveData();
            pgOfferAttachments.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                pgOfferAttachments.getParameters().put('draftMsgFlag', 'true');
            }
            pageURLForRedirection = pgOfferAttachments.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferAttachments', Label.LOP_Community_Base_URL+'AAAP-OfferAttachments');
            pgOfferAttachments.setRedirect(false);
            return null;

        } catch (Exception e) {
            Apexpages.addMessages(e);
            System.debug('********** save space error: ' + e.getStackTraceString());
            pgOfferAttachments = null;
        }

        refreshNumbers();

        return pgOfferAttachments;
    }   // end continueSave


    /*  "Back" Actions  */

    // "Back" button
    public PageReference back() {
        // update the offer to include data entered on the "outer space" page
        this.saveData();

        //PageReference back = Page.PBS_AAAP_OperatingCosts;
        PageReference back = new PageReference('/AAAP/OperatingCosts');
        back.getParameters().put('offerId', offerId);
		back.setRedirect(false);
        pageURLForRedirection = back.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OperatingCosts', Label.LOP_Community_Base_URL+'AAAP-OperatingCosts');
        return null;
    }   // end back


    // "Rate Summary" button
    public PageReference rateSummary() {

        // set the render controls for the outer space view to true
        this.rendOuterSpace = true;
        this.rendAddSpace = false;
        this.rendRates = false;
        this.rendSuccSpace = false;

        //PageReference pgSpaceSummary = Page.PBS_AAAP_SpacesAndRates;
        PageReference pgSpaceSummary = new PageReference('/AAAP/SpacesAndRates');
        pgSpaceSummary.setRedirect(true);
        pgSpaceSummary.getParameters().put('offerId', offerId);
        return pgSpaceSummary;

    }   // end rateSummary

    // "Return to Space" button
    public PageReference returnToSpace() {

        if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {        // show new space view
            // set the render controls for the add new space view to true
            this.rendOuterSpace = false;
            this.rendAddSpace = true;
            this.rendRates = false;
            this.rendSuccSpace = false;
        } else {    // show succeeding space view
            // set the render controls for the succeeding  space view to true
            this.rendOuterSpace = false;
            this.rendAddSpace = false;
            this.rendRates = false;
            this.rendSuccSpace = true;
        }   // end if

        validate = TRUE;
        this.saveRates();       // save the rates
        validate = FALSE;
        return null;

    }   // end rateSummary

    // "Back to Space and Rates" button
    public void returnToSpaceRates() {
        // configure the render options to return to  the outer space page
        this.rendOuterSpace = true;
        this.rendAddSpace = false;
        this.rendRates = false;
        this.rendSuccSpace = false;

        validate = TRUE;
        this.saveRates();       // save the rates
        validate = FALSE;
        //PageReference pgSpaceRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference pgSpaceRates = new PageReference('/AAAP/SpacesAndRates');
        pgSpaceRates.getParameters().put('offerId', offerId);
        pgSpaceRates.setRedirect(true);
        pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pgSpaceRates.getUrl());
        //return null;

    }   // end rateSummary    

    //added by syam on 03/28 to redirect to attachments upon clicking on the Complete Offered Space button
    public PageReference redirectToSpaceandRates() {
        //Added by Nik for OOLOP-735

        Boolean spRtFlag = FALSE;
        if(newOrCont == '' || newOrCont == NULL){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '1. Please indicate if the space is currently leased to a Government tenant.');
            Apexpages.addMessage(myMsg);
            //return null;
            spRtFlag = TRUE;
        }


        if(newOrCont == 'TRUE' && (space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c == null || space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c == '')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '1a. An expiring lease number is required if the space you are offering is currently being leased to a Government tenant.');
            Apexpages.addMessage(myMsg);
            //return null;
            spRtFlag = TRUE;
        }

        if(space.PBS_AAAP_SF_OFFERED__c == null || space.PBS_AAAP_SF_OFFERED__c == 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '2. You must provide the total ABOA SF available for lease to the Government.');
            Apexpages.addMessage(myMsg);
            //return null;
            spRtFlag = TRUE;
        }

        if(space.PBS_AAAP_Max_Contiguous_Space__c == NULL || space.PBS_AAAP_Max_Contiguous_Space__c == 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '3. Please indicate the maximum contiguous ABOA SF of the space outlined in question #2.');
            Apexpages.addMessage(myMsg);
            //return null;
            spRtFlag = TRUE;
        }

        if(space.PBS_AAAP_MIN_OFFERABLE_SPACE__c == NULL || space.PBS_AAAP_MIN_OFFERABLE_SPACE__c == 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '4. Please indicate the minimum demisable ABOA SF of the space outlined in question #2.');
            Apexpages.addMessage(myMsg);
            //return null;
            spRtFlag = TRUE;
        }

        if(space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c == NULL){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '5. Please state the earliest date in which the space could be ready for the commencement of tenant improvement construction.');
            Apexpages.addMessage(myMsg);
            //return null;
            spRtFlag = TRUE;
        }

        if(userIputTIA == NULL || userInputBSAC == NULL){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '6.  You must input a value for \'Tenant Improvement Allowance\' and \'Building Specific Amortization\'.  You may put $0.00 as a value if you do not wish to see how the amortization or fees related to these rental components would factor into the overall lease rate.');
            Apexpages.addMessage(myMsg);
            //return null;
            spRtFlag = TRUE;
        }

        if (rateE.fiveYrFS == 0.0 && rateE.fiveFiveYrFS == 0.0 && rateE.tenYrFS == 0.0) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '7. Rates for at least one term must be submitted.');
            Apexpages.addMessage(myMsg);
            //return null;
            spRtFlag = TRUE;
        }

        //End- Nik's changes
        if (regionCode != 'Census' && ((rateE.fiveYrFS > 0.0 && (rateE.tenFiveYrOptTerm == null || rateE.tenFiveYrOptTerm <= 0.0)) || (rateE.fiveFiveYrFS > 0.0 && (rateE.fiveFiveYrOptTerm == null || rateE.fiveFiveYrOptTerm <= 0.0)) || (rateE.tenYrFS > 0.0 && (rateE.tenEightYrOptTerm == null || rateE.tenEightYrOptTerm <= 0.0)))) {
            if (rateE.fiveYrFS > 0.0) {
                if (rateE.tenFiveYrOptTerm == null || rateE.tenFiveYrOptTerm <= 0.0) {
                    if (regionCode != 'Census') {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-17. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                        Apexpages.addMessage(myMsg);
                    }
                }
            }
            if (rateE.fiveFiveYrFS > 0.0) {
                if (rateE.fiveFiveYrOptTerm == null || rateE.fiveFiveYrOptTerm <= 0.0) {
                    if (regionCode != 'Census') {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-15. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                        Apexpages.addMessage(myMsg);
                    }
                }
            }
            if (rateE.tenYrFS > 0.0) {
                if (rateE.tenEightYrOptTerm == null || rateE.tenEightYrOptTerm <= 0.0) {
                    if (regionCode != 'Census') {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-10. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                        Apexpages.addMessage(myMsg);
                    }
                }
            }
            //return null;
            spRtFlag = TRUE;
        }

        //SFWS-1126 03/30/2021 Todd Brown added the validation as stated in requirements for this story
        //SGanti commented out 8/2/2021
       /* if (space.PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '14. You must indicate the rental charge per ABOA SF to meet the "Routine Cleaning and Disinfecting Requirements for the Premises," as described in the "Janitorial Services" paragraph of the lease, sub-paragraph N.  Input must be a number.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }
		*/
       //SGanti renumbered question number on error message 8/2/2021

        if (space.PBS_AAAP_ARCH_ENG_FEES__c > 0.00) {
            if (feePrcntgOrDollar == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '15. You must select how Architectural and Engineering Fees will be structured by selecting one of the two options presented after the question.');
                Apexpages.addMessage(myMsg);
                spRtFlag = TRUE;
            }
        }
        
        if(spRtFlag){
            return null;
        }

        this.saveSpace();

        validate = TRUE;
        this.saveRates();       // save the rates
        validate = FALSE;
        refreshNumbers();
        //PageReference pgSpaceRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference pgSpaceRates = new PageReference('/AAAP/SpacesAndRates');
        pgSpaceRates.getParameters().put('offerId', offerId);
        pageURLForRedirection = pgSpaceRates.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/SpacesAndRates', Label.LOP_Community_Base_URL+'AAAP-SpacesAndRates');
        pgSpaceRates.setRedirect(false);
        return null;

    }   // end redirectToAttachment


    public PageReference redirectToSpaceandRatesOnly() {
        //Added by Nik for OOLOP-735

        system.debug('&&&&&&&PBS_AAAP_MIN_OFFERABLE_SPACE__c'+space.PBS_AAAP_Max_Contiguous_Space__c);
        system.debug('&&&&&&&PBS_AAAP_MIN_OFFERABLE_SPACE__c'+space.PBS_AAAP_MIN_OFFERABLE_SPACE__c);

        Boolean spRtFlag = FALSE;
        if(newOrCont == '' || newOrCont == NULL){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '1. Please indicate if the space is currently leased to a Government tenant.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }


        if(newOrCont == 'TRUE' && (space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c == null || space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c == '')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '1a. An expiring lease number is required if the space you are offering is currently being leased to a Government tenant.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }

        if(space.PBS_AAAP_SF_OFFERED__c == null || space.PBS_AAAP_SF_OFFERED__c == 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '2. You must provide the total ABOA SF available for lease to the Government.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }

        if(space.PBS_AAAP_Max_Contiguous_Space__c == NULL || space.PBS_AAAP_Max_Contiguous_Space__c == 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '3. Please indicate the maximum contiguous ABOA SF of the space outlined in question #2.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }

        if(space.PBS_AAAP_MIN_OFFERABLE_SPACE__c == NULL || space.PBS_AAAP_MIN_OFFERABLE_SPACE__c == 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '4. Please indicate the minimum demisable ABOA SF of the space outlined in question #2.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }

        if(space.PBS_AAAP_DATE_SPACE_AVAILABILITY__c == NULL){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '5. Please state the earliest date in which the space could be ready for the commencement of tenant improvement construction.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }

        if(userIputTIA == NULL || userInputBSAC == NULL){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '6.  You must input a value for \'Tenant Improvement Allowance\' and \'Building Specific Amortization\'.  You may put $0.00 as a value if you do not wish to see how the amortization or fees related to these rental components would factor into the overall lease rate.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }

        if (rateE.fiveYrFS == 0.0 && rateE.fiveFiveYrFS == 0.0 && rateE.tenYrFS == 0.0) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '7. Rates for at least one term must be submitted.');
            Apexpages.addMessage(myMsg);
            spRtFlag = TRUE;
        }

        //End- Nik's changes
        if (regionCode != 'Census' && ((rateE.fiveYrFS > 0.0 && (rateE.tenFiveYrOptTerm == null || rateE.tenFiveYrOptTerm <= 0.0)) || (rateE.fiveFiveYrFS > 0.0 && (rateE.fiveFiveYrOptTerm == null || rateE.fiveFiveYrOptTerm <= 0.0)) || (rateE.tenYrFS > 0.0 && (rateE.tenEightYrOptTerm == null || rateE.tenEightYrOptTerm <= 0.0)))) {
            if (rateE.fiveYrFS > 0.0) {
                if (rateE.tenFiveYrOptTerm == null || rateE.tenFiveYrOptTerm <= 0.0) {
                    if (regionCode == '10/5 Term - All Regions') {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA).');
                        Apexpages.addMessage(myMsg);
                        spRtFlag = TRUE;
                    }else if (regionCode != 'Census') {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-17. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                        Apexpages.addMessage(myMsg);
                        spRtFlag = TRUE;
                    }
                }
            }
            if (rateE.fiveFiveYrFS > 0.0) {
                if (rateE.fiveFiveYrOptTerm == null || rateE.fiveFiveYrOptTerm <= 0.0) {
                    if (regionCode != 'Census') {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-15. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                        Apexpages.addMessage(myMsg);
                        spRtFlag = TRUE;
                    }
                }
            }
            if (rateE.tenYrFS > 0.0) {
                if (rateE.tenEightYrOptTerm == null || rateE.tenEightYrOptTerm <= 0.0) {
                    if (regionCode != 'Census') {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-10. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                        Apexpages.addMessage(myMsg);
                        spRtFlag = TRUE;
                    }
                }
            }
        }

        //SFWS-1126 03/30/2021 Todd Brown added the validation as stated in requirements for this story
        //SGanti commented out on 8/2/2021
     //   if (space.PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c == null) {
       //     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '14. You must indicate the rental charge per ABOA SF to meet the "Routine Cleaning and Disinfecting Requirements for the Premises," as described in the "Janitorial Services" paragraph of the lease, sub-paragraph N.  Input must be a number.');
      //      Apexpages.addMessage(myMsg);
      //      spRtFlag = TRUE;
      //  }
    
        //SGanti renumbered on 8/2/2021

        if (space.PBS_AAAP_ARCH_ENG_FEES__c > 0.00) {
            if (feePrcntgOrDollar == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '15. You must select how Architectural and Engineering Fees will be structured by selecting one of the two options presented after the question.');
                Apexpages.addMessage(myMsg);
                spRtFlag = TRUE;
            }
        }
        //SGanti renumbered on 8/2/2021

        if (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c == 0.00 || space.PBS_AAAP_ARCH_ENG_FEES__c == 0.00) {
            if (readOnlyScreen != 'true' && regionCode != 'Census') {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        //'Warning Space Page : Data saved with "Lessor PM Fees" and / or "A&E Fees" with a ZERO value. Please make sure you intended a ZERO value. If not, return to space page and update #4 and #5. If so, proceed to Add/Edit Rates for Space.');
                        '14/15. Data was saved with "Lessor PM Fees" and/or "A&E Fees" with a ZERO value. Please make sure you intended a ZERO value.');
                Apexpages.addMessage(myMsg);
                spRtFlag = TRUE;
            }
        }
        
        if(!spRtFlag) {
            system.debug('&&&&&&&PBS_AAAP_MIN_OFFERABLE_SPACE__c'+space.PBS_AAAP_Max_Contiguous_Space__c);
            system.debug('&&&&&&&PBS_AAAP_MIN_OFFERABLE_SPACE__c'+space.PBS_AAAP_MIN_OFFERABLE_SPACE__c);
            this.saveSpace();

            validate = TRUE;
            this.saveRates(); // save the rates
            validate = FALSE;

            refreshNumbers();

            if( !(( pageUrl == null ) || ( pageUrl == '' )) )
            {
                Integer len = pageUrl.length();
                if( pageUrl.mid(len-1, 1) == '=' )
                {
                    pageUrl = pageUrl + offerId;
                }

                system.debug( 'Take away ' + pageUrl );

                PageReference p = new PageReference(pageUrl);
                //p.setRedirect(true);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                return null;
            } else {
                system.debug('null');
                return null;
            }
        }

        return null;

    }

    // "Back to Space and Rates" button for "View-Only"
    public PageReference returnToSpaceRatesViewOnly() {
        // configure the render options to return to  the outer space page
        this.rendOuterSpace = true;
        this.rendAddSpace = false;
        this.rendRates = false;
        this.rendSuccSpace = false;

        //this.saveRates();     // save the rates
        //PageReference pgSpaceRates = Page.PBS_AAAP_SpacesAndRatesView;
        PageReference pgSpaceRates = new PageReference('/AAAP/SpacesAndRatesView');
        pgSpaceRates.getParameters().put('offerId', offerId);
        pgSpaceRates.setRedirect(true);
        return pgSpaceRates;

    }   // end rateSummary

    /*  "Save" Actions  */

    // action to save the outer space information
    public PageReference saveForm() {

        system.debug('Space Rate Save');

        this.saveData();

        if( !(( pageUrl == null ) || ( pageUrl == '' )) )
        {
            Integer len = pageUrl.length();
            if( pageUrl.mid(len-1, 1) == '=' )
            {
                pageUrl = pageUrl + offerId;
            }

            PageReference p = new PageReference(pageUrl);
            return p;
        }

        //return null;
        PageReference pref = new PageReference('/AAAP/SpacesAndRates?offerId='+offerId);
        return pref;
    }   // end back

    public boolean validateOfferFormFields() {
        boolean flag;

        //added by syam on 09/14/2016 to make sure MaxOfferedSpace > detail.sqftOffered for all the spaces when altering the maxoffered space page after entering multiple spaces
        for (PBS_AAAP_Space__c space : spaces) {
            if (space.PBS_AAAP_SF_OFFERED__c != null) {

                if (space.PBS_AAAP_SF_OFFERED__c <= 0) {
                    if (!isSucceeding) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '2. Amount of offered space must be greater than 0.');
                        Apexpages.addMessage(myMsg);
                        flag = true;
                    } else {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '2. Amount of offered space must be greater than 0.');
                        Apexpages.addMessage(myMsg);
                        flag = true;
                    }

                }
            }

            if (space.PBS_AAAP_SF_OFFERED__c <= 0 && !isSucceeding) {

                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '2. Amount of offered space must be greater than 0.');
                Apexpages.addMessage(myMsg);
                flag = true;
            }
            if (space.PBS_AAAP_SF_OFFERED__c <= 0 && isSucceeding) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '2. Amount of offered space must be greater than 0.');
                Apexpages.addMessage(myMsg);
                flag = true;
            }
        }
        return flag;
    }
    
    //  action to allow the saving of rate data to the DB
    public PageReference saveRates() {
        if(newOrCont == 'TRUE' && (space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c == null || space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c == '')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '1a. An expiring lease number is required if the space you are offering is currently being leased to a Government tenant.');
            Apexpages.addMessage(myMsg);
            return null;
        }

        if(space.PBS_AAAP_SF_OFFERED__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '2. You must provide the total ABOA SF available for lease to the Government.');
            Apexpages.addMessage(myMsg);
            return null;
        }
        System.debug('##### Begin saveRates *** rlpGT2016 is ' + rlpGT2016);
        //System.debug('##### Begin saveRates *** rlpGT2016 is ' + validate);
        //added by syam to show the message when the below validation fails
        spaceAndRates = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
        if(validate){
            system.debug('$$$$---validation Starts---$$$$');

            if (rateE.fiveYrFS == 0.0 && rateE.fiveFiveYrFS == 0.0 && rateE.tenYrFS == 0.0) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Rates for at least one term must be submitted.');
                Apexpages.addMessage(myMsg);
                return null;
            }
            if (regionCode != 'Census' && ((rateE.fiveYrFS > 0.0 && (rateE.tenFiveYrOptTerm == null || rateE.tenFiveYrOptTerm <= 0.0)) || (rateE.fiveFiveYrFS > 0.0 && (rateE.fiveFiveYrOptTerm == null || rateE.fiveFiveYrOptTerm <= 0.0)) || (rateE.tenYrFS > 0.0 && (rateE.tenEightYrOptTerm == null || rateE.tenEightYrOptTerm <= 0.0)))) {
                if (rateE.fiveYrFS > 0.0) {
                    if (rateE.tenFiveYrOptTerm == null || rateE.tenFiveYrOptTerm <= 0.0) {
                        if (regionCode != 'Census') {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-17. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                            Apexpages.addMessage(myMsg);
                        }
                    }
                }
                if (rateE.fiveFiveYrFS > 0.0) {
                    if (rateE.fiveFiveYrOptTerm == null || rateE.fiveFiveYrOptTerm <= 0.0) {
                        if (regionCode != 'Census') {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-15. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                            Apexpages.addMessage(myMsg);
                        }
                    }
                }
                if (rateE.tenYrFS > 0.0) {
                    if (rateE.tenEightYrOptTerm == null || rateE.tenEightYrOptTerm <= 0.0) {
                        if (regionCode != 'Census') {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '11. Enter Shell Rate per ANSI/BOMA Office Area square foot (ABOA) for years 9-10. If Shell rate is unchanged from years 1-8, enter Shell Rate amount from #7 above.');
                            Apexpages.addMessage(myMsg);
                        }
                    }
                }
                return null;
            }

        }

        Savepoint sp0 = Database.setSavepoint();      // generate a save point for rollback purposes

        try {
            saveSpace();
            // modify the rateE structure to include the calculations
            rates = this.convertRateEntry(rateE);

            System.debug('***** rateE (at top): ' + rateE);
            double leaseFirmTermMonths;
            if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {        // new space
                if (rateE.fiveYrFS > 0) {
                    //if (rlpGT2016) {
                    if (regionCode == 'Census') {
                        leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.CENSUS_25);
                        //rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue());
                        rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());
                    } else if(regionCode == '10/5 Term - All Regions'){
                        leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.FIVEFIVEYRNEW);
                        //rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue());
                        rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());
                    } else {
                        system.debug('rateE.fiveYrFS 1-- '+rateE.fiveYrFS);
                        leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.SEVENTEENYR);
                        //rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue());
                        rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());

                    }
                } else {
                    rateE.fiveYrTIAmorCosts = 0.00;
                }

                if (rateE.fiveFiveYrFS > 0) {
                    if (regionCode == 'Census') {
                        leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.CENSUS_19);
                        //rateE.fiveFiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveFiveYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue());
                        rateE.fiveFiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveFiveYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());
                    } else {
                        leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW);
                        //rateE.fiveFiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveFiveYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue());
                        rateE.fiveFiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveFiveYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());

                    }

                } else {
                    rateE.fiveFiveYrTIAmorCosts = 0.00;   // no rate so no calculation
                }

                if (rateE.tenYrFS > 0) {
                    leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM);
                    //rateE.tenYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.tenYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_New_Space__c.doubleValue());
                    rateE.tenYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.tenYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());
                } else {
                    rateE.tenYrTIAmorCosts = 0.00;   // no rate so no calculation
                }

                rateE.fiveYrBSACRate = rateE.fiveYrAPR;
                rateE.fiveFiveYrBSACRate = rateE.fiveFiveYrAPR;
                rateE.tenYrBSACRate = rateE.tenYrAPR;
                System.debug('*****rlp.PBS_AAAP_BSAC_per_ABOA__c:  ' + rlp.PBS_AAAP_BSAC_per_ABOA__c);
                //Double BSACperABOA = (rlp.PBS_AAAP_BSAC_per_ABOA__c == null) ? 0 : rlp.PBS_AAAP_BSAC_per_ABOA__c.doubleValue();
                Double BSACperABOA = (userInputBSAC == null) ? 0 : userInputBSAC.doubleValue();
                System.debug('*****BSACperABOA :  ' + BSACperABOA);
                System.debug('*****rateE.fiveYrBSACRate:  ' + rateE.fiveYrBSACRate);
                if (rateE.fiveYrFS > 0) {
				system.debug('rateE.fiveYrFS 2-- '+rateE.fiveYrFS);
                    if(regionCode == '10/5 Term - All Regions'){
                    	leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.FIVEFIVEYRNEW);
                    	rateE.fiveYrBSAC = PBS_AAAP_CalculationHelper.AmmortizationOfBSAC(rateE.fiveYrBSACRate/100,leaseFirmTermMonths,BSACperABOA);
                    } else{
                        leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.SEVENTEENYR);
                        rateE.fiveYrBSAC = PBS_AAAP_CalculationHelper.AmmortizationOfBSAC(rateE.fiveYrBSACRate/100,leaseFirmTermMonths,BSACperABOA);
                    }

                } else {
                    rateE.fiveYrBSAC = 0.00;
                }
                System.debug('*****rateE.fiveFiveYrBSACRate:  ' + rateE.fiveFiveYrBSACRate);
                if (rateE.fiveFiveYrFS > 0) {
                    leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW);
                    rateE.fiveFiveYrBSAC = PBS_AAAP_CalculationHelper.AmmortizationOfBSAC(rateE.fiveFiveYrBSACRate/100,leaseFirmTermMonths,BSACperABOA);
                } else {
                    rateE.fiveFiveYrBSAC = 0.00;
                }
                System.debug('*****rateE.tenYrBSACRate:  ' + rateE.tenYrBSACRate);
                if (rateE.tenYrFS > 0) {
                    leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM);
                    rateE.tenYrBSAC = PBS_AAAP_CalculationHelper.AmmortizationOfBSAC(rateE.tenYrBSACRate/100,leaseFirmTermMonths,BSACperABOA);
                } else {
                    rateE.tenYrBSAC = 0.00;
                }

                System.debug('*****rateE.fiveYrBSAC:  ' + rateE.fiveYrBSAC);
                System.debug('*****rateE.fiveFiveYrBSAC:  ' + rateE.fiveFiveYrBSAC);
                System.debug('*****rateE.tenYrBSAC:  ' + rateE.tenYrBSAC);

                System.debug('*****end RITM****');

            } else {

                rateE.fiveYrBSAC = 0.00;
                rateE.fiveFiveYrBSAC = 0.00;
                rateE.tenYrBSAC = 0.00;
                rateE.fiveYrBSACRate = rateE.fiveYrAPR;
                rateE.fiveFiveYrBSACRate = rateE.fiveFiveYrAPR;
                rateE.tenYrBSACRate = rateE.tenYrAPR;
                System.debug('*****rlp.PBS_AAAP_BSAC_per_ABOA__c:  ' + rlp.PBS_AAAP_BSAC_per_ABOA__c);
                //Double BSACperABOAContinuing = (rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c == null) ? 0 : rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c.doubleValue();
                Double BSACperABOAContinuing = (userInputBSAC== null) ? 0 : userInputBSAC.doubleValue();
                System.debug('*****BSACperABOA :  ' + BSACperABOAContinuing);
                System.debug('*****rateE.fiveYrBSACRate:  ' + rateE.fiveYrBSACRate);
                if (rateE.fiveYrFS > 0) {
                    system.debug('rateE.fiveYrFS 3-- '+rateE.fiveYrFS);
                    if(regionCode == '10/5 Term - All Regions'){
                    	leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.FIVEFIVEYRNEW);
                    	rateE.fiveYrBSAC = PBS_AAAP_CalculationHelper.AmmortizationOfBSAC(rateE.fiveYrBSACRate/100,leaseFirmTermMonths,BSACperABOAContinuing);
                    } else{
                    	leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.SEVENTEENYR);
                    	rateE.fiveYrBSAC = PBS_AAAP_CalculationHelper.AmmortizationOfBSAC(rateE.fiveYrBSACRate/100,leaseFirmTermMonths,BSACperABOAContinuing);
                    }
                } else {
                    rateE.fiveYrBSAC = 0.00;
                }
                System.debug('*****rateE.fiveFiveYrBSACRate:  ' + rateE.fiveFiveYrBSACRate);
                if (rateE.fiveFiveYrFS > 0) {
                    leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW);
                    rateE.fiveFiveYrBSAC = PBS_AAAP_CalculationHelper.AmmortizationOfBSAC(rateE.fiveFiveYrBSACRate/100,leaseFirmTermMonths,BSACperABOAContinuing);
                } else {
                    rateE.fiveFiveYrBSAC = 0.00;
                }
                System.debug('*****rateE.tenYrBSACRate:  ' + rateE.tenYrBSACRate);
                if (rateE.tenYrFS > 0) {
                    leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM);
                    rateE.tenYrBSAC = PBS_AAAP_CalculationHelper.AmmortizationOfBSAC(rateE.tenYrBSACRate/100,leaseFirmTermMonths,BSACperABOAContinuing);
                } else {
                    rateE.tenYrBSAC = 0.00;
                }

                System.debug('*****rateE.fiveYrBSAC:  ' + rateE.fiveYrBSAC);
                System.debug('*****rateE.fiveFiveYrBSAC:  ' + rateE.fiveFiveYrBSAC);
                System.debug('*****rateE.tenYrBSAC:  ' + rateE.tenYrBSAC);
                System.debug('*****end RITM2****');
                // succeeding space
                if (rateE.fiveYrFS > 0) {
                    system.debug('rateE.fiveYrFS 4-- '+rateE.fiveYrFS);
                    if(regionCode == '10/5 Term - All Regions'){
                    	leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.FIVEFIVEYRNEW);
                    	rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());
                    } else{
                    	leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.SEVENTEENYR);
                    	//rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue());
                    	rateE.fiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());
                    }
                } else {
                    rateE.fiveYrTIAmorCosts = 0.00;   // no rate so no calculation
                }   // end if

                if (rateE.fiveFiveYrFS > 0) {
                    leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW);
                    //rateE.fiveFiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveFiveYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue());
                    rateE.fiveFiveYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.fiveFiveYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());
                } else {
                    rateE.fiveFiveYrTIAmorCosts = 0.00;   // no rate so no calculation
                }   // end if

                if (rateE.tenYrFS > 0) {
                    leaseFirmTermMonths = calc.getLeaseMonths(PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM);
                    //rateE.tenYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.tenYrAPR/100,leaseFirmTermMonths,offer.PBS_AAAP_RLP_TI_Additional_Space__c.doubleValue());
                    rateE.tenYrTIAmorCosts = PBS_AAAP_CalculationHelper.AmmortizationOfTI(rateE.tenYrAPR/100,leaseFirmTermMonths,userIputTIA.doubleValue());
                } else {
                    rateE.tenYrTIAmorCosts = 0.00;
                }


            }

            if (rateE.fiveYrFS > 0) {
                //    if(regionCode == 'Census') {rateE.fiveYrTIAmorCosts = 0;}
                rateE.fiveYrFirmTerm = math.abs(rateE.fiveYrFS) + math.abs(rateE.fiveYrOpCosts) + math.abs(rateE.fiveYrTIAmorCosts);
                rateE.fiveYrFirmTerm = rateE.fiveYrFirmTerm + math.abs(rateE.fiveYrBSAC);

            } else {
                rateE.fiveYrFirmTerm = 0.00;       // nothing to calculate
            }

            System.debug('***** rateE.fiveYrFS:  ' + rateE.fiveYrFS + ' ----- rateE.fiveYrOpCosts: ' + rateE.fiveYrOpCosts + ' ------ rateE.fiveYrTIAmorCosts: ' + rateE.fiveYrTIAmorCosts);

            if (rateE.fiveFiveYrFS > 0) {
                rateE.fiveFiveYrFirmTerm = math.abs(rateE.fiveFiveYrFS) + math.abs(rateE.fiveFiveYrOpCosts) + math.abs(rateE.fiveFiveYrTIAmorCosts);
                rateE.fiveFiveYrFirmTerm = rateE.fiveFiveYrFirmTerm + math.abs(rateE.fiveFiveYrBSAC);
            } else {
                rateE.fiveFiveYrFirmTerm = 0.00;       // nothing to calculate
            }

            System.debug('***** rateE.fiveFiveYrFS:  ' + rateE.fiveFiveYrFS + ' ----- rateE.fiveFiveYrOpCosts: ' + rateE.fiveFiveYrOpCosts + ' ------ rateE.fiveFiveYrTIAmorCosts: ' + rateE.fiveFiveYrTIAmorCosts);

            if (rateE.tenYrFS > 0) {
                rateE.tenYrFirmTerm = math.abs(rateE.tenYrFS) + math.abs(rateE.tenYrOpCosts) + math.abs(rateE.tenYrTIAmorCosts);
                rateE.tenYrFirmTerm = rateE.tenYrFirmTerm + math.abs(rateE.tenYrBSAC);
            } else {
                rateE.tenYrFirmTerm = 0.00;       // nothing to calculate
            }

            rateE.spaceID = savedSpace;
            System.debug('***** rateE.tenYrFS:  ' + rateE.tenYrFS + ' ----- rateE.tenYrOpCosts: ' + rateE.tenYrOpCosts + ' ------ rateE.tenYrTIAmorCosts: ' + rateE.tenYrTIAmorCosts);

            System.debug('***** rateE (at bottom before conversion): ' + rateE);
            List<PBS_AAAP_Rate__c> ratesToDB = convertRateEntry(rateE);
            System.debug('********** ratesToDB: ' + ratesToDB);
            System.debug('***** rateE (at bottom after conversion): ' + rateE);

            upsert ratesToDB;
            this.rates.addAll(ratesToDB);                                                               // add the new rates to the list of rates internally represented
            this.ratesToSpace = this.genMapRatesToSpace(rates, spaces);     // refresh the map of rates to spaces
            List<PBS_AAAP_Rate__c> rateCheck = dao.getRatesFromSpace(rateE.spaceId);
            if (rateCheck.size() > 0) {      // rates existed for this space
                List<PBS_AAAP_Rate__c> ratesToRemove = this.databaseConCheck(ratesToDB, rateCheck);    // insure that there are only 3 rates records for the space.
                if (ratesToRemove.size() > 0) {
                    delete ratesToRemove;
                } // end if
            }   // end if

            // clear the ratesToDB
            ratesToDB.clear();
            //added by syam to save offer as a draft when it is saved on submit status
            draftMsgFlag = '';
            if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }
            update offer;


        } catch (Exception e) {
            Apexpages.addMessages(e);
            System.debug('********** save rates error: ' + e.getStackTraceString());
            Database.rollback(sp0);
        }
        System.debug('##### End saveRates'+pageUrl);

        if( !(( pageUrl == null ) || ( pageUrl == '' )) )
        {
            Integer len = pageUrl.length();
            if( pageUrl.mid(len-1, 1) == '=' )
            {
                pageUrl = pageUrl + offerId;
            }

            system.debug( 'Take away ' + pageUrl );

            PageReference p = new PageReference(pageUrl);
            p.setRedirect(true);
            return p;
        } else {
            system.debug('null');
            return null;
        }
    }   // end saveRates    


    //  action to allow the saving of space data to the DB
    public void saveSpace() {
        System.debug('***** feePrcntgOrDollar: ' + feePrcntgOrDollar);
        system.debug('&&&&&&&PBS_AAAP_MIN_OFFERABLE_SPACE__c'+space.PBS_AAAP_Max_Contiguous_Space__c);
        system.debug('&&&&&&&PBS_AAAP_MIN_OFFERABLE_SPACE__c'+space.PBS_AAAP_MIN_OFFERABLE_SPACE__c);
        Set<String> spaceIds = new Set<String>();
        //Boolean errorFlag = False;

        if(newOrCont == 'TRUE' && (space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c == null || space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c == '')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '1a. An expiring lease number is required if the space you are offering is currently being leased to a Government tenant.');
            Apexpages.addMessage(myMsg);
        }

        if(space.PBS_AAAP_SF_OFFERED__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    '2. You must provide the total ABOA SF available for lease to the Government.');
            Apexpages.addMessage(myMsg);
        }

        if (space.PBS_AAAP_Max_Contiguous_Space__c == null) {
            space.PBS_AAAP_Max_Contiguous_Space__c = space.PBS_AAAP_SF_OFFERED__c ;//used to be null couldn't figure out why
        }
        if (sfOfferedType == 'All Available ABOA') {
            //space.PBS_AAAP_Max_Contiguous_Space__c = 0;
            //space.PBS_AAAP_MIN_OFFERABLE_SPACE__c = 0;
        }
        /*else if(sfOfferedType == 'Range of ABOA'){
       space.PBS_AAAP_Max_Contiguous_Space__c=     space.PBS_AAAP_SF_OFFERED__c ; //this was backwards weston so i reversed it??
        }*/ else if (sfOfferedType == 'Range of ABOA') {
            if (space.PBS_AAAP_Max_Contiguous_Space__c <= 0) { //weston
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        '2. Amount of offered space must be greater than 0.');
                Apexpages.addMessage(myMsg);
                //return null;
            }
        }
        if (space.PBS_AAAP_SF_OFFERED__c <= 0) { //weston
            if (!isSucceeding) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '2. Amount of offered space must be greater than 0.');
                Apexpages.addMessage(myMsg);
                //return null;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '2. Amount of offered space must be greater than 0.');
                Apexpages.addMessage(myMsg);
                //return null;
            }

        }

        // added validation rule for New Space Type (max value in Q4 cannot be greater than Q3)
        if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c == true) {
            if (space.PBS_AAAP_Max_Contiguous_Space__c > space.PBS_AAAP_SF_OFFERED__c) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '3. Max contiguous ABOA SF cannot be greater than the total ABOA SF being offered (Question #2).');
                Apexpages.addMessage(myMsg);
            }
        }

        //added for FY16 feePrcntgOrDollar   =   space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c; 
        if (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c == null) {
            space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 0.00;
        }
        if (space.PBS_AAAP_ARCH_ENG_FEES__c == null) {
            space.PBS_AAAP_ARCH_ENG_FEES__c = 0.00;
        }
        if (space.PBS_AAAP_ARCH_ENG_FEES__c > 0.00) {
            if (feePrcntgOrDollar == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '16. You must select how Architectural and Engineering Fees will be structured by selecting one of the two options presented after the question.');
                Apexpages.addMessage(myMsg);
                //return null;
            }
        }
        //added by syam to show the message when the below validation fails
        spaceAndRates = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);

        if (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c == 0.00 || space.PBS_AAAP_ARCH_ENG_FEES__c == 0.00) {
            if (readOnlyScreen != 'true' && regionCode != 'Census') {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        '15/16. Data was saved with "Lessor PM Fees" and/or "A&E Fees" with a ZERO value. Please make sure you intended a ZERO value.');
                Apexpages.addMessage(myMsg);
            }
        }

        for (PBS_AAAP_Space__c sp : spaces) {
            System.debug('Space Id is ***** : ' + sp.PBS_AAAP_IDENTIFIER_ID__c);
            spaceIds.add(sp.Id);
        }   // end for

        System.debug('Current Space Id is **** : ' + space.PBS_AAAP_IDENTIFIER_ID__c);

        // submit the space data to the DB 
        System.debug('********** space to update: ' + space);
        System.debug('***** sfOfferedType: ' + sfOfferedType);
        try {
            space.PBS_AAAP_IDENTIFIER_TYPE__c = sfOfferedType;
            System.debug('***** feePrcntgOrDollar: ' + feePrcntgOrDollar);
            space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = feePrcntgOrDollar;
            space.PBS_AAAP_TOTAL_MARKUP__c = calc.getTotalMarkup(space, offer,feePrcntgOrDollar, userIputTIA, userInputBSAC);
            space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = !Boolean.valueOf(newOrCont);
            if(newOrCont == 'FALSE'){
                space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = '';
            }
            space.PBS_AAAP_Offeror_Created_TI__c = userIputTIA;
            space.PBS_AAAP_Offeror_Created_BSAC__c = userInputBSAC;
            //System.debug('***** feePrcntgOrDollar: ' + feePrcntgOrDollar);
            System.debug('***** space.ID: ' + space.Id);
            System.debug('***** readOnlyScreen: in saveSpace ' + readOnlyScreen);

            // save space to DB
            upsert space;

            if (!spaceIds.contains(space.Id)) {
                spaces.add(space);      // add the new space to the list of internal representation of spaces
            }

            savedSpace = space.Id;

            // generate the necessary three rate records (5, 5+5, and 10) for the new space

        } catch (Exception e) {
            Apexpages.addMessages(e);
            System.debug('********** save space error: ' + e.getStackTraceString());
        }

    }   // end saveSpace 

    public pageReference saveOnlySpace() {
        System.debug('***** feePrcntgOrDollar: ' + feePrcntgOrDollar);
        Set<String> spaceIds = new Set<String>();
        Boolean dontSave = FALSE;
        //Boolean errorFlag = False;

        if (space.PBS_AAAP_SF_OFFERED__c <= 0) {
            dontSave = TRUE;
        }

        if (space.PBS_AAAP_Max_Contiguous_Space__c == null) {
            space.PBS_AAAP_Max_Contiguous_Space__c = space.PBS_AAAP_SF_OFFERED__c ;//used to be null couldn't figure out why
        }
        if (sfOfferedType == 'All Available ABOA') {
            space.PBS_AAAP_Max_Contiguous_Space__c = 0;
            space.PBS_AAAP_MIN_OFFERABLE_SPACE__c = 0;
        }

        if (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c == null) {
            space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 0.00;
        }
        if (space.PBS_AAAP_ARCH_ENG_FEES__c == null) {
            space.PBS_AAAP_ARCH_ENG_FEES__c = 0.00;
        }
        if (space.PBS_AAAP_ARCH_ENG_FEES__c > 0.00) {
            if (feePrcntgOrDollar == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '16. You must select how Architectural and Engineering Fees will be structured by selecting one of the two options presented after the question.');
                Apexpages.addMessage(myMsg);
                return null;
            }
        }

        spaceAndRates = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);

        //Integer increment =0;
        for (PBS_AAAP_Space__c sp : spaces) {
            System.debug('Space Id is ***** : ' + sp.PBS_AAAP_IDENTIFIER_ID__c);
            spaceIds.add(sp.Id);
        }   // end for

        try {
            space.PBS_AAAP_IDENTIFIER_TYPE__c = sfOfferedType;
            System.debug('***** feePrcntgOrDollar: ' + feePrcntgOrDollar);
            space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = feePrcntgOrDollar;
            space.PBS_AAAP_TOTAL_MARKUP__c = calc.getTotalMarkup(space, offer,feePrcntgOrDollar, userIputTIA, userInputBSAC);
            space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = !Boolean.valueOf(newOrCont);
            //System.debug('***** feePrcntgOrDollar: ' + feePrcntgOrDollar);
            System.debug('***** space.ID: ' + space.Id);
            System.debug('***** readOnlyScreen: in saveSpace ' + readOnlyScreen);

            // save space to DB
            if(!dontSave) {
                upsert space;

                if (!spaceIds.contains(space.Id)) {
                    spaces.add(space); // add the new space to the list of internal representation of spaces
                }
            }


        } catch (Exception e) {
            Apexpages.addMessages(e);
            System.debug('********** save space error: ' + e.getStackTraceString());
        }

        if( !(( pageUrl == null ) || ( pageUrl == '' )))
        {
            Integer len = pageUrl.length();
            if( pageUrl.mid(len-1, 1) == '=' )
            {
                pageUrl = pageUrl + offerId;
            }

            system.debug( 'Take away ' + pageUrl );

            PageReference p = new PageReference(pageUrl);
            return p;
        }

        return null;
    }

    public void calcTotMarkup() {
        pageURLForRedirection = '-';
        //saveSpace();
        space.PBS_AAAP_TOTAL_MARKUP__c = calc.getTotalMarkup(space, offer, feePrcntgOrDollar, userIputTIA, userInputBSAC);
        //return null;
    }

    public PageReference clearSpace() {
        space = defaultSpace(offerId);

        return null;
    }   // end clearSpace        


    /**************************************  Utilty Methods  **************************************/

    // generate default space values, passing offer ID as the single argument
    public PBS_AAAP_Space__c defaultSpace(String pId) {
        PBS_AAAP_Space__c returnVal = new PBS_AAAP_Space__c(PBS_AAAP_OFFER_NUMBER__c = pId,
                PBS_AAAP_MIN_OFFERABLE_SPACE__c = 0,
                PBS_AAAP_Max_Contiguous_Space__c = 0,
                PBS_AAAP_DATE_SPACE_AVAILABILITY__c = null,
                PBS_AAAP_SF_OFFERED__c = 0,
                PBS_AAAP_MANAGEMENT_COORD_FEES__c = 0.00,
                PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = GSADEFAULT,
                PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 0.00,
                PBS_AAAP_GC_CONDITIONS__c = 0.00,
                PBS_AAAP_ARCH_ENG_FEES__c = 0.00,
                PBS_AAAP_IDENTIFIER_TYPE__c = null,
                PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = null);

        sfOfferedType = null;
        feePrcntgOrDollar = null;

        return returnVal;
    }   // end defaultSpace

    public List<PBS_AAAP_Rate__c> databaseConCheck(List<PBS_AAAP_Rate__c> pRatesToKeep, List<PBS_AAAP_Rate__c> pTotalRatesForSpace) {
        System.debug('##### Begin databaseConCheck');

        System.debug('***** pRatesToKeep: ' + pRatesToKeep);
        System.debug('***** pTotalRatesForSpace: ' + pTotalRatesForSpace);
        Set<String> idsToKeep = new Set<String>();      // set of IDS that should be kept
        List<PBS_AAAP_Rate__c> delRates = new List<PBS_AAAP_Rate__c>();

        // populate the set with rate ids that should be kept
        for (PBS_AAAP_Rate__c rateToKeep : pRatesToKeep) {
            idsToKeep.add(rateToKeep.Id);
        }   // end for
        System.debug('***** idsToKeep: ' + idsToKeep);


        for (PBS_AAAP_Rate__c TRFS : pTotalRatesForSpace) {

            PBS_AAAP_Rate__c delRate = TRFS;

            if (!idsToKeep.contains(delRate.Id)) {
                System.debug('***** delRate.Id: ' + delRate.Id);
                delRates.add(delRate);
            }   // end if


        }   // end for

        System.debug('***** delRates: ' + delRates);
        System.debug('##### End databaseConCheck');
        return delRates;


    }   // end databaseConCheck

    // sort through the retrieved spaces and prepare the matrix table for display
    public List<SpaceAndRatesDetails> spaceSort(List<PBS_AAAP_Space__c> pSpaces, List<PBS_AAAP_Rate__c> pRates) {
        System.debug('##### Begin --spaceSort');
        List<SpaceAndRatesDetails> returnVal = new List<SpaceAndRatesDetails>();

        for (PBS_AAAP_Space__c space : pSpaces) {
            SpaceAndRatesDetails sard = new SpaceAndRatesDetails();
            System.debug('&&&&& space sort space.PBS_AAAP_IDENTIFIER_ID__c: ' + space.PBS_AAAP_IDENTIFIER_ID__c);
            sard.spaceNo = (space.PBS_AAAP_IDENTIFIER_ID__c != null) ? space.PBS_AAAP_IDENTIFIER_ID__c : String.valueOf(0);
            sard.GSALeaseNo = space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c;

            // the value for the square footage offered can be pulled from differing fields  depending upon whether the space is a new space or a succeeding space  
            if (space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c) {        // new space
                sard.sqFtOffered = space.PBS_AAAP_SF_OFFERED__c.setScale(0).format();
                sard.leaseType = 'New';
            } else {    // succeeding space
                sard.sqFtOffered = space.PBS_AAAP_SF_OFFERED__c.setScale(0).format();
                sard.leaseType = 'Continuing';
            }

            sard.spaceID = space.Id;
            System.debug('##### space.Id: ' + space.Id);
            System.debug('##### Rates: ' + pRates);
            List<PBS_AAAP_Rate__c> spaceRateSpecific = new List<PBS_AAAP_Rate__c>();   // a list of rates specific to the space
            for (PBS_AAAP_Rate__c spRate : pRates) {
                if (spRate.PBS_AAAP_SPACE__c == space.Id) {
                    spaceRateSpecific.add(spRate);
                }   // end if
            }   // end for

            for (PBS_AAAP_Rate__c rate : spaceRateSpecific) {
                System.debug('##### Rate Loop in detail table (summary): ' + rate);
                if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                    if (rate.PBS_AAAP_BASE_RATE__c > 0) {
                        sard.tenYrFS = rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c;      // the ten year FS term value needs to be put the screen structure
                    } else {
                        sard.tenYrFS = 0.00;       // display o for the amount
                    }   // end if
                    sard.tenYrPv = rate.PBS_AAAP_PV_Value__c;      // the ten year PV value

                } else if ( (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.CENSUS_25)) {         // five year rate
                    if (rate.PBS_AAAP_BASE_RATE__c > 0) {
                        sard.fiveYrFS = rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c;      // the five year FS term value needs to be put the screen structure
                    } else {
                        sard.fiveYrFS = 0.00;   // display o for the amount
                    }   // end if
                    sard.fiveYrPV = rate.PBS_AAAP_PV_Value__c;      // the five year PV value
                    

                } else if ((rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIVEFIVEYRNEW) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.CENSUS_19)) {
                    if (rate.PBS_AAAP_BASE_RATE__c > 0) {
                        sard.fiveFiveYrFS = rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c;      // the five + five year FS term value needs to be put the screen structure
                    } else {
                        sard.fiveFiveYrFS = 0.00;   // display o for the amount
                    }   // end if
                    sard.fiveFiveYrPV = rate.PBS_AAAP_PV_Value__c;              // the five + five year PV value

                }// end if
            } // end for (rates)
            returnVal.add(sard);
        } // end for (spaces)
        System.debug('##### End --spaceSort');
        return returnVal;
    }   // end spaceSort

    // sort through the retrieved spaces and generate a map of space identifiers to spaces
    public Map<String, PBS_AAAP_Space__c> makeSpaceMap(List<PBS_AAAP_Space__c> pSpaces) {
        Map<String, PBS_AAAP_Space__c> returnMap = new Map<String, PBS_AAAP_Space__c>();

        for (PBS_AAAP_Space__c space : pSpaces) {
            returnMap.put(space.PBS_AAAP_IDENTIFIER_ID__c, space);
        }   // end for

        return returnMap;
    }   // end makeSpaceMap


    // convert a rateEntry object into a list of three PBS_AAAP_Rate__c objects
    public List<PBS_AAAP_Rate__c> convertRateEntry(RateEntry pRateEntry) {
        System.debug('##### Begin convertRateEntry');
        System.debug('***** pRateEntry: ' + pRateEntry);

        List<PBS_AAAP_Rate__c> returnVals = new List<PBS_AAAP_Rate__c>();

        pRateEntry.fiveYrTIAmorCosts2 = (allow2ndTierRate) ? pRateEntry.fiveYrTIAmorCosts2 : pRateEntry.fiveYrAPR ;
        pRateEntry.fiveFiveYrTIAmorCosts2 = (allow2ndTierRate) ? pRateEntry.fiveFiveYrTIAmorCosts2 : pRateEntry.fiveFiveYrAPR ;
        pRateEntry.tenYrTIAmorCosts2 = (allow2ndTierRate) ? pRateEntry.tenYrTIAmorCosts2 : pRateEntry.tenYrAPR ;
        pRateEntry.fiveFiveYrFreeRentOption = (leaseTerm10_5) ? 0.00 : pRateEntry.fiveFiveYrFreeRentOption ;

        String leaseTerm1;
        String leaseTerm2;

        if (regionCode == 'Census') {
            leaseTerm1 = PBS_AAAP_CALCULATIONS.CENSUS_25;
            leaseTerm2 = PBS_AAAP_CALCULATIONS.CENSUS_19;
        } if (regionCode == '10/5 Term - All Regions') {
             leaseTerm1 = '10 years,5 firm';
        }else {
            leaseTerm1 = PBS_AAAP_CALCULATIONS.SEVENTEENYR;
            leaseTerm2 = PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW;
        }

        PBS_AAAP_Rate__c fiveYearRate = new PBS_AAAP_Rate__c(PBS_AAAP_SPACE__c = pRateEntry.spaceId,
                Id = pRateEntry.fiveYrId,
                PBS_AAAP_OFFER_NUMBER__c = offerId,
                PBS_AAAP_LEASE_TERM__c = leaseTerm1,
                PBS_AAAP_BASE_RATE__c = pRateEntry.fiveYrFS,
                PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = pRateEntry.fiveYrAPR,
                PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = pRateEntry.tenFiveYrOptTerm,
                PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = pRateEntry.fiveYrTIAmorCosts2,
                PBS_AAAP_OT_RATE_COOLING_HEAT__c = pRateEntry.fiveYrOTHvacCosts,
                PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = pRateEntry.fiveYrDayTimeCleanCosts,
                PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = pRateEntry.fiveYrFreeRentFIRM,
                PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = pRateEntry.fiveYrBrokerageComm,
                PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = pRateEntry.fiveYrOpCosts,
                //PBS_AAAP_COST_FOR_TI__c = pRateEntry.fiveYrTIAmorCosts,
                PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = pRateEntry.fiveYrFirmTerm,
                PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = pRateEntry.fiveYrTIAmorCosts,
                PBS_AAAP_PV_Value__c = pRateEntry.fiveYrPV,
                PBS_AAAP_BSAC__c = pRateEntry.fiveYrBSAC,
                PBS_AAAP_BSAC_RATE__c = pRateEntry.fiveYrBSACRate);
        if (regionCode != '10/5 Term - All Regions') {

        PBS_AAAP_Rate__c fiveFiveYearRate = new PBS_AAAP_Rate__c(PBS_AAAP_SPACE__c = pRateEntry.spaceId,
                Id = pRateEntry.fiveFiveYrId,
                PBS_AAAP_OFFER_NUMBER__c = offerId,
                PBS_AAAP_LEASE_TERM__c = leaseTerm2,
                PBS_AAAP_BASE_RATE__c = pRateEntry.fiveFiveYrFS,
                PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = pRateEntry.fiveFiveYrAPR,
                PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = pRateEntry.fiveFiveYrOptTerm,
                PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = pRateEntry.fiveFiveYrTIAmorCosts2,
                PBS_AAAP_OT_RATE_COOLING_HEAT__c = pRateEntry.fiveFiveYrOTHvacCosts,
                PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = pRateEntry.fiveFiveYrDayTimeCleanCosts,
                PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = pRateEntry.fiveFiveYrFreeRentFIRM,
                PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = pRateEntry.fiveFiveYrFreeRentOption,
                PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = pRateEntry.fiveFiveYrBrokerageComm,
                PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = pRateEntry.fiveFiveYrOpCosts,
                //PBS_AAAP_COST_FOR_TI__c = pRateEntry.fiveFiveYrTIAmorCosts,
                PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = pRateEntry.fiveFiveYrFirmTerm,
                PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = pRateEntry.fiveFiveYrTIAmorCosts,
                PBS_AAAP_PV_Value__c = pRateEntry.fiveFiveYrPV,
                PBS_AAAP_BSAC__c = pRateEntry.fiveFiveYrBSAC,
                PBS_AAAP_BSAC_RATE__c = pRateEntry.fiveFiveYrBSACRate);

        PBS_AAAP_Rate__c tenYearRate = new PBS_AAAP_Rate__c(PBS_AAAP_SPACE__c = pRateEntry.spaceId,
                Id = pRateEntry.tenYrId,
                PBS_AAAP_OFFER_NUMBER__c = offerId,
                PBS_AAAP_LEASE_TERM__c = PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM,
                PBS_AAAP_BASE_RATE__c = pRateEntry.tenYrFS,
                PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = pRateEntry.tenYrAPR,
                PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = pRateEntry.tenEightYrOptTerm,
                PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = pRateEntry.tenYrTIAmorCosts2,
                PBS_AAAP_OT_RATE_COOLING_HEAT__c = pRateEntry.tenYrOTHvacCosts,
                PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = pRateEntry.tenYrDayTimeCleanCosts,
                PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = pRateEntry.tenYrFreeRentFIRM,
                PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = pRateEntry.tenYrBrokerageComm,
                PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = pRateEntry.tenYrOpCosts,
                //PBS_AAAP_COST_FOR_TI__c = pRateEntry.tenYrTIAmorCosts,
                PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = pRateEntry.tenYrFirmTerm,
                PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = pRateEntry.tenYrTIAmorCosts,
                PBS_AAAP_PV_Value__c = pRateEntry.tenYrPV,
                PBS_AAAP_BSAC__c = pRateEntry.tenYrBSAC,
                PBS_AAAP_BSAC_RATE__c = pRateEntry.tenYrBSACRate);
            
             returnVals.add(fiveFiveYearRate);   // add the five + five year rate type to the return structure
            returnVals.add(tenYearRate);        // add the ten year rate type to the return structure
    }
        returnVals.add(fiveYearRate);       // add the five year rate type to the return structure
        
            System.debug('*****  returnVals: ' + returnVals);
        System.debug('##### End convertRateEntry');
        return returnVals;
    } // end convertRateEntry


    // utility method to convert data from PBS_AAAP_Rate__c format into the innerclass RateEntry format
    public RateEntry convertPbsAaapRate(List<PBS_AAAP_Rate__c> pRates) {
        System.debug('##### Begin convertPbsAaapRate');
        System.debug('***** pRates size: ' + pRates.size());
        RateEntry returnVal = new RateEntry();
        for (PBS_AAAP_Rate__c rate : pRates) {
            returnVal.spaceID = pRates[0].PBS_AAAP_SPACE__c;            // set the space ID.
            System.debug('########BEFORE IF');
            if ((rate.PBS_AAAP_LEASE_TERM__c == '10 years,5 firm') || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.SEVENTEENYR) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.CENSUS_25)) {
                System.debug('########IF1a');
                returnVal.fiveYrFS = rate.PBS_AAAP_BASE_RATE__c;
                returnVal.fiveYrAPR = rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c;
                //Vaishali RLP 14 Change
                returnVal.fiveYrTIAmorCosts2 = (allow2ndTierRate) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c : rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c ;
                returnVal.fiveYrOTHvacCosts = rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c;
                returnVal.fiveYrDayTimeCleanCosts = rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c;
                returnVal.fiveYrFreeRentFIRM = Integer.valueOf(rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                returnVal.fiveYrBrokerageComm = rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c;
                returnVal.fiveYrFirmTerm = rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c;
                returnVal.fiveYrTIAmorCosts = rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c;
                returnVal.fiveYrOpCosts = rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c;
                returnVal.fiveYrId = rate.Id;
                returnVal.tenFiveYrOptTerm = rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c;       // RLP FY17 Vaishali
                returnVal.fiveYrFreeRentOption = rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c;
                //-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
                returnVal.fiveYrBSAC = (rate.PBS_AAAP_BSAC__c == null) ? 0.00 : rate.PBS_AAAP_BSAC__c;
                returnVal.fiveYrBSACRate = (rate.PBS_AAAP_BSAC_RATE__c == null) ? 0.00 : rate.PBS_AAAP_BSAC_RATE__c;

            } else if ((rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIFTEENTENYRNEW) || (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.CENSUS_19)) {
                returnVal.fiveFiveYrFS = rate.PBS_AAAP_BASE_RATE__c;
                returnVal.fiveFiveYrAPR = rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c;
                //Vaishali RLP 14 Change
                returnVal.fiveFiveYrTIAmorCosts2 = (allow2ndTierRate) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c : rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c;
                returnVal.fiveFiveYrOTHvacCosts = rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c;
                returnVal.fiveFiveYrDayTimeCleanCosts = rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c;
                returnVal.fiveFiveYrFreeRentFIRM = Integer.valueOf(rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                returnVal.fiveFiveYrBrokerageComm = rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c;
                returnVal.fiveFiveYrFirmTerm = rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c;
                returnVal.fiveFiveYrTIAmorCosts = rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c;
                returnVal.fiveFiveYrOpCosts = rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c;
                returnVal.fiveFiveYrId = rate.Id;
                returnVal.fiveFiveYrOptTerm = rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c;
                returnVal.fiveFiveYrFreeRentOption = (leaseTerm10_5) ? 0.00 : rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c;
                //-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
                returnVal.fiveFiveYrBSAC = (rate.PBS_AAAP_BSAC__c == null) ? 0.00 : rate.PBS_AAAP_BSAC__c;
                returnVal.fiveFiveYrBSACRate = (rate.PBS_AAAP_BSAC_RATE__c == null) ? 0.00 : rate.PBS_AAAP_BSAC_RATE__c;

            } else if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYREIGHTFIRM) {
                returnVal.tenYrFS = rate.PBS_AAAP_BASE_RATE__c;
                returnVal.tenYrAPR = rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c;
                //Vaishali RLP 14 Change
                returnVal.tenYrTIAmorCosts2 = (allow2ndTierRate) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c : rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c;
                returnVal.tenYrOTHvacCosts = rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c;
                returnVal.tenYrDayTimeCleanCosts = rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c;
                returnVal.tenYrFreeRentFIRM = Integer.valueOf(rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                returnVal.tenYrBrokerageComm = rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c;
                returnVal.tenYrFirmTerm = rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c;
                returnVal.tenYrTIAmorCosts = rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c;
                returnVal.tenYrOpCosts = rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c;
                returnVal.tenYrId = rate.Id;
                returnVal.tenEightYrOptTerm = rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c;
                returnVal.tenYrFreeRentOption = rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c;
                //-------RITM0021675, RITM002167, RITM0021677-----------------------------------------------------------------------
                returnVal.tenYrBSAC = (rate.PBS_AAAP_BSAC__c == null) ? 0.00 : rate.PBS_AAAP_BSAC__c;
                returnVal.tenYrBSACRate = (rate.PBS_AAAP_BSAC_RATE__c == null) ? 0.00 : rate.PBS_AAAP_BSAC_RATE__c;
            }
        }   // end for
        System.debug('***** returnVal.fiveYrId: ' + returnVal.fiveYrId);
        System.debug('***** returnVal.fiveFiveYrId: ' + returnVal.fiveFiveYrId);
        System.debug('***** returnVal.tenYrId: ' + returnVal.tenYrId);
        System.debug('##### End convertPbsAaapRate');
        return returnVal;
    }   // end convertPbsAaapRate


    // utility method to identify and return the largest, ordinal, space, identifier (PBS_AAAP_Space__c.PBS_AAAP_IDENTIFIER_ID__c)
    public Integer getLrgOrdinal(List<PBS_AAAP_Space__c> pSpaces) {
        Integer returnVal = 0;
        System.debug('inside getLrgOrdinal, spaces size' + pSpaces.size());
        for (PBS_AAAP_Space__c space : pSpaces) {
            System.debug('inside getLrgOrdinal space.PBS_AAAP_IDENTIFIER_ID__c is : ' + space.PBS_AAAP_IDENTIFIER_ID__c);
            if (Integer.valueOf(space.PBS_AAAP_IDENTIFIER_ID__c) > returnVal) {
                returnVal = Integer.valueOf(space.PBS_AAAP_IDENTIFIER_ID__c);
            }  // end if

        }   // end for


        return returnVal;
    } // end getLrgOrdinal


    // utility method to generate the map of rates to spaces
    public Map<String, List<PBS_AAAP_Rate__c>> genMapRatesToSpace(List<PBS_AAAP_Rate__c> pRates, List<PBS_AAAP_Space__c> pSpaces) {
        System.debug('##### Begin genMapRatesToSpace');
        Map<String, List<PBS_AAAP_Rate__c>> returnVal = new Map<String, List<PBS_AAAP_Rate__c>>();

        // populate the rates to space map
        for (PBS_AAAP_Space__c sp : pSpaces) {
            System.debug('***** space: ' + sp.Id);
            // get the current record data and add to the list
            List<PBS_AAAP_Rate__c> tempRates = new List<PBS_AAAP_Rate__c>();
            for (PBS_AAAP_Rate__c rt : pRates) {
                System.debug('***** rate: ' + rt.Id + ' -- ' + rt.PBS_AAAP_SPACE__c);
                if (rt.PBS_AAAP_SPACE__c == sp.Id) {
                    tempRates.add(rt);
                } // end if
            }   // end for

            if (returnVal.containsKey(sp.Id)) {
                List<PBS_AAAP_Rate__c> tempMapRates = returnVal.get(sp.Id);
                tempMapRates.addAll(tempRates);
                returnVal.put(sp.Id, tempMapRates);
            } else {
                returnVal.put(sp.Id, tempRates);
            }   // end if

        }   // end for

        System.debug('***** returnVal: ' + returnVal);
        System.debug('##### End genMapRatesToSpace');
        return returnVal;
    }   // end genMapRatesToSpace


    // action to save the outer space information
    public void saveData() {
        try {

            system.debug( 'minOfferedSpace ' + minOfferedSpace );

            // update the offer to include data entered on the "outer space" page
            offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = minOfferedSpace;
            offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = maxOfferedSpace.round(System.RoundingMode.HALF_EVEN);
            offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = maxContABOA;
            //added by syam for submit offer to save as draft when it is saved.
            draftMsgFlag = '';
            if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED && readOnlyScreen != 'true') {
                offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }
            update offer;
        } catch (Exception ex) {

            ApexPages.addMessages(ex);
        }

    }   // end back

    // action to delete an entire offer - added by Santosh
    public PageReference actionDeleteOffer() {
        PageReference pref = null;

        System.debug('************* offer.PBS_AAAP_Offer_Status__c ::: ' + offer.PBS_AAAP_Offer_Status__c);

        if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
            delete offer;   // Cascade delete - Deletes all Spaces and Othercosts associated with it.
            //pref = Page.PBS_AAAP_PortalHome;
            pref = new PageReference('/AAAP/PortalHome');
            pref.setRedirect(true);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + offer.PBS_AAAP_Offer_Status__c +
                    ', you can only delete on Draft or Pending Modification stage');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    public PageReference actionBackSpace() {
        this.saveSpace();           // save the space data
        rendOuterSpace = true;
        rendSuccSpace = false;
        rendAddSpace = false;
        rendRates = false;
        //PageReference pgSpaceRates = Page.PBS_AAAP_SpacesAndRates;
        PageReference pgSpaceRates = new PageReference('/AAAP/SpacesAndRates');
        pgSpaceRates.getParameters().put('offerId', offerId);
        pgSpaceRates.setRedirect(true);
        return pgSpaceRates;
    }

    public PageReference actionBackSpaceView() {
        //this.saveSpace();         // save the space data
        rendOuterSpace = true;
        rendSuccSpace = false;
        rendAddSpace = false;
        rendRates = false;
        //PageReference pgSpaceRates = Page.PBS_AAAP_SpacesAndRatesView;
        PageReference pgSpaceRates = new PageReference('/AAAP/SpacesAndRatesView');
        pgSpaceRates.getParameters().put('offerId', offerId);
        pgSpaceRates.setRedirect(true);
        return pgSpaceRates;
    }

    /** added by syam 03/22 as part of the cancel operation addition */
    public void actionCancel() {
        //PageReference pref = Page.PBS_AAAP_PortalHome;
        PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(true);
        //return pref;
    }

    public void refreshNumbers(){
        //Id oId = ApexPages.currentPage().getParameters().get('offerId');

        List<PBS_AAAP_Space__c> listOfSpaces = new List<PBS_AAAP_Space__c>();
        List<PBS_AAAP_Space__c> listOfSpacesUpd = new List<PBS_AAAP_Space__c>();
        listOfSpaces = [
                            SELECT  Id,
                                    PBS_AAAP_IDENTIFIER_ID__c,
                                    CreatedDate
                            FROM PBS_AAAP_Space__c
                            WHERE PBS_AAAP_OFFER_NUMBER__c = :offerId
                            ORDER BY CreatedDate ASC
        ];

        Integer i = 0;
        Boolean isChanged = FALSE;
        for(PBS_AAAP_Space__c spc : listOfSpaces){
            i++;
            if (spc.PBS_AAAP_IDENTIFIER_ID__c != String.valueOf(i)) isChanged = TRUE;
//            if (spc.PBS_AAAP_IDENTIFIER_ID__c != String.valueOf(i)) {
//                isChanged = TRUE;
//            }
            spc.PBS_AAAP_IDENTIFIER_ID__c = String.valueOf(i);
            listOfSpacesUpd.add(spc);
        }

        if(!listOfSpacesUpd.isEmpty()){
            update listOfSpacesUpd;
        }
        initialised = TRUE;

        /**
        if(isChanged){
            PageReference pref = new PageReference(ApexPages.currentPage().getUrl());
            pref.setRedirect(true);
            return pref;
        } else {
            return null;
        }
        **/

    }

}