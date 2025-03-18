public with sharing class PBS_LOPController {
    //TODO replace object type
    public PBS_LOP_OFFER__c lopOffer { get; set; }
    public PBS_GREX_Project_EOI__c project { get; set; }
    private PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
    public PBS_AAAP_QuestionLabels qLabels { get; set; }
    public User userDetail { get; set; }
    public String offerId { get; set; }
    public String projectId { get; set; }
    public String EOIId { get; set; }
    public String isNew { get; set; }
    public String action { get; set; }
    /*  public string selectRLP                 {get;set;}
      public string oldRLP                    {get;set;}

      public Boolean isCopy                   {get;set;}
      public Boolean isModify                 {get;set;} */
    //public Boolean isPendingModfication     {get;set;} 
    public string isEditable { get; set; }
    public Boolean viewOnly { get; set; }
    public string viewMsg { get; set; }
    public Boolean pastDueDate { get; set; }
    public Boolean isTerminated { get; set; }
    public String draftMsgFlag { get; set; }
    public boolean showSubmitMesg { get; set; }

    public boolean isValidUser { get; set; }
    public String ownerFullName { get; set; }

    public String projectEoiId { get; set; }
    /*RepsAndCerts*/
    public Boolean repsAndCertsPage1 { get; set; }
    public Boolean repsAndCertsPage2 { get; set; }
    /*RepsAndCerts*/
    public Decimal archEnggFee { get; set; }
    /** Space and Rates **/
    /* public Double govtOccupancy {get;set;}
     public Double tiAnnualRentABOASF {get;set;} */
    public Double totalAnnualRentAmt { get; set; }
    public Boolean stepRent { get; set; }

    public String buildingPage { get; set; }
    public String offerDueDate { get; set; }


    public PBS_LOPController() {

        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode FROM User u WHERE u.Id = :UserInfo.getUserId()];
        action = ApexPages.currentPage().getParameters().get('action');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        isNew = ApexPages.currentPage().getParameters().get('isNew');
        isEditable = ApexPages.currentPage().getParameters().get('edit');
        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in a View mode';
        } else {
            viewOnly = false;
        }

        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
        projectEoiId = ApexPages.currentPage().getParameters().get('projectEoiId');
        qLabels = new PBS_AAAP_QuestionLabels();

        showSubmitMesg = false;
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            lopOffer = PBS_AAAP_GlobalConstants.getLOPOfferDetail(offerId);
            String projectEOI = lopOffer.Project_EOI_ID__c;
            project = PBS_AAAP_GlobalConstants.getProjectDetails(projectEOI);
            if (project.Project_Offer_Due_Date__c != null) {
                DateTime dt = project.Project_Offer_Due_Date__c;
                // offerDueDate = dt.format('MM/dd/yyyy HH:mm:ss','America/New_York');
                offerDueDate = PBS_AAAP_GlobalConstants.convertToTimeZone(project);
            }
            System.debug('************projectEOI is::: ' + projectEOI);
            System.debug('************ Owner Info::: ' + lopOffer.OwnerId);
            System.debug('************ lop_offer_status::: ' + lopOffer.LOP_Offer_Status__c);
            System.debug('************ User Info::: ' + lopOffer.Project_Offer_Due_Date__c);
            System.debug('************ User Info::: ' + UserInfo.getUserId());


            if (lopOffer.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;

                if (lopOffer.Project_EOI_ID__r.Project_Termination_Flag__c) {
                    isTerminated = true;
                } else {
                    isTerminated = false;
                }
                System.debug('Project_Offer_Due_Date__c is ******' + lopOffer.Project_Offer_Due_Date__c);
                System.debug('datetime.now() is *****' + datetime.now());
                if (lopOffer.Project_Offer_Due_Date__c < datetime.now()) {
                    pastDueDate = true;
                } else {
                    pastDueDate = false;
                }
                System.debug('*** isEditablefirst ***' + isEditable); System.debug('*** isTerminated ***' + isTerminated);
                if (isTerminated) {
                    viewOnly = true; viewMsg = 'Project is terminated. Offer opened in a view mode';
                    System.debug('*** isEditable ***' + isEditable);
                } else if ((pastDueDate) && (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED)) {
                    viewOnly = true; viewMsg = 'Project due date has elapsed. Offer opened in a view mode';
                }
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
            //added by syam for FY16 changes
            String areaType = lopOffer.LOP_SITE_AREA_TYPE__c;
            System.debug('*** areaType in constructor is ***' + areaType);
            Decimal siteSize = lopOffer.LOP_SITE_SIZE_SQFT__c;
            System.debug('*** siteSize in constructor is ' + siteSize);
            if (areaType == 'Acres') {
                if (lopOffer.LOP_SITE_SIZE_SQFT__c != null) {
                    siteSize = siteSize / 43560;
                    System.debug('*** siteSize inside is ' + siteSize);
                    lopOffer.LOP_SITE_SIZE_SQFT__c = siteSize;
                }
            }

            //for propertowner page
            if (lopOffer.LOP_Owner_FirstName__c == null) {
                lopOffer.LOP_Owner_FirstName__c = '';
            }
            if (lopOffer.LOP_Owner_LastName__c == null) {
                lopOffer.LOP_Owner_LastName__c = '';
            }
            ownerFullName = lopOffer.LOP_Owner_FirstName__c + ' ' + lopOffer.LOP_Owner_LastName__c;
            /*RepsAndCerts*/
            repsAndCertsPage1 = true;
            repsAndCertsPage2 = false;
            /*RepsAndCerts*/
            /** Space and Rates page **/
            initializeSpaceAndRates();
            //leaseTerms and Conditions
            if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '1. Per ABOA Square Feet ($)') {
                archEnggFee = lopOffer.LOP_ARCH_ENG_FEES_PER_USF__c;
            } else if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '2. Percent of Total Construction Costs (%)') {
                archEnggFee = lopOffer.LOP_Architectural_Fees_Percent__c;
            } else if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '3. Flat Fee ($)') {
                archEnggFee = lopOffer.LOP_Architectural_Fees_Flat__c;
            }

            //added by syam on 12/08/2016 set to always 1.
            lopOffer.LOP_Step_1_Start__c = 1;
            lopOffer.LOP_Step_1_End__c = lopOffer.LOP_Shell_Rate_Years_Effective__c;
            lopOffer.LOP_Step_1_Rent_Per_RSF__c = lopOffer.LOP_Shell_Rent_Per_RSF__c;
            lopOffer.LOP_Step_1_Rent_Per_ABOA__c = lopOffer.LOP_Shell_Rent_Per_ABOA__c;
        } else {
            isValidUser = true;
            lopOffer = new PBS_LOP_OFFER__c();

        }
        System.debug('******* ShowSubmit Mesg::: ' + showSubmitMesg);

    }

    public PageReference actionDeleteOffer() {
        List<string> spaceidList;
        PageReference pref = null;

        if (lopOffer.Id != null) {
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
                delete lopOffer;   // Cascade delete - Deletes all Spaces and Othercosts associated with it.
                pref = Page.PBS_LOP_portalHome;
                pref.setRedirect(true);
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + lopOffer.LOP_Offer_Status__c +
                        ', you can only delete a Draft offer');
                ApexPages.addMessage(myMsg);
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is not yet saved to perform the delete operation');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    /*RepsAndCerts*/
    public List<SelectOption> getItemsQ9() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No, will activate registration'));
        return options;
    }

    public List<SelectOption> getStates() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        options.add(new SelectOption('Alaska', 'Alaska'));
        options.add(new SelectOption('Alabama', 'Alabama'));
        options.add(new SelectOption('Arkansas', 'Arkansas'));
        options.add(new SelectOption('Arizona', 'Arizona'));
        options.add(new SelectOption('California', 'California'));
        options.add(new SelectOption('Colorado', 'Colorado'));
        options.add(new SelectOption('Connecticut', 'Connecticut'));
        options.add(new SelectOption('Delaware', 'Delaware'));
        options.add(new SelectOption('District of Columbia', 'District of Columbia'));
        options.add(new SelectOption('Florida', 'Florida'));
        options.add(new SelectOption('Georgia', 'Georgia'));
        options.add(new SelectOption('Hawaii', 'Hawaii'));
        options.add(new SelectOption('Iowa', 'Iowa'));
        options.add(new SelectOption('Idaho', 'Idaho'));
        options.add(new SelectOption('Illinois', 'Illinois'));
        options.add(new SelectOption('Indiana', 'Indiana'));
        options.add(new SelectOption('Kansas', 'Kansas'));
        options.add(new SelectOption('Kentucky', 'Kentucky'));
        options.add(new SelectOption('Louisiana', 'Louisiana'));
        options.add(new SelectOption('Massachusetts', 'Massachusetts'));
        options.add(new SelectOption('Maryland', 'Maryland'));
        options.add(new SelectOption('Maine', 'Maine'));
        options.add(new SelectOption('Michigan', 'Michigan'));
        options.add(new SelectOption('Minnesota', 'Minnesota'));
        options.add(new SelectOption('Missouri', 'Missouri'));
        options.add(new SelectOption('Mississippi', 'Mississippi'));
        options.add(new SelectOption('Montana', 'Montana'));
        options.add(new SelectOption('North Carolina', 'North Carolina'));
        options.add(new SelectOption('North Dakota', 'North Dakota'));
        options.add(new SelectOption('Nebraska', 'Nebraska'));
        options.add(new SelectOption('New Hampshire ', 'New Hampshire'));
        options.add(new SelectOption('New Jersey', 'New Jersey'));
        options.add(new SelectOption('New Mexico', 'New Mexico'));
        options.add(new SelectOption('Nevada', 'Nevada'));
        options.add(new SelectOption('New York', 'New York'));
        options.add(new SelectOption('Ohio', 'Ohio'));
        options.add(new SelectOption('Oklahoma', 'Oklahoma'));
        options.add(new SelectOption('Oregon', 'Oregon'));
        options.add(new SelectOption('Pennsylvania', 'Pennsylvania'));
        options.add(new SelectOption('Rhode Island', 'Rhode Island'));
        options.add(new SelectOption('South Carolina', 'South Carolina'));
        options.add(new SelectOption('South Dakota', 'South Dakota'));
        options.add(new SelectOption('Tennessee ', 'Tennessee'));
        options.add(new SelectOption('Texas ', 'Texas'));
        options.add(new SelectOption('Utah', 'Utah'));
        options.add(new SelectOption('Virginia', 'Virginia'));
        options.add(new SelectOption('Vermont ', 'Vermont'));
        options.add(new SelectOption('Washington', 'Washington'));
        options.add(new SelectOption('Wisconsin ', 'Wisconsin'));
        options.add(new SelectOption('West Virginia ', 'West Virginia'));
        options.add(new SelectOption('Wyoming ', 'Wyoming'));
        options.add(new SelectOption('American Samoa', 'American Samoa'));

        options.add(new SelectOption('Federated States of Micronesia', 'Federated States of Micronesia'));
        options.add(new SelectOption('Guam', 'Guam'));
        options.add(new SelectOption('Northern Mariana Islands', 'Northern Mariana Islands'));
        options.add(new SelectOption('Puerto Rico ', 'Puerto Rico'));
        options.add(new SelectOption('Virgin Islands, U.S.', 'Virgin Islands, U.S.'));
        options.add(new SelectOption('Marshall Islands', 'Marshall Islands'));
        return options;
    }

    public List<SelectOption> getSmallBusiness() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Not a Small Business', 'Not a Small Business'));
        options.add(new SelectOption('Small Business', 'Small Business'));
        return options;
    }

    public List<SelectOption> getSAMRegistrationItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Registration Active and Copy Attached in Attachments Tab', 'Registration Active and Copy Attached in Attachments Tab'));
        options.add(new SelectOption('No, will activate registration', 'No, will activate registration'));
        return options;
    }
    /*RepsAndCerts*/
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }
    public List<SelectOption> getPartialItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        options.add(new SelectOption('Partial', 'Partial'));
        return options;
    }

    public List<SelectOption> getSiteSizeItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Square Feet', 'Square Feet'));
        options.add(new SelectOption('Acres', 'Acres'));
        return options;
    }
    public List<SelectOption> getHVACOTOptionItems() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('Per Hour','Per Hour'));
        options.add(new SelectOption('Per Zone', 'Per Zone'));
        options.add(new SelectOption('Per Floor', 'Per Floor'));
        options.add(new SelectOption('Per Space', 'Per Space'));
        return options;
    }
    public List<SelectOption> getarcenggOptionItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1. Per ABOA Square Feet ($)', '1. Per ABOA Square Feet ($)'));
        options.add(new SelectOption('2. Percent of Total Construction Costs (%)', '2. Percent of Total Construction Costs (%)'));
        options.add(new SelectOption('3. Flat Fee ($)', '3. Flat Fee ($)'));
        return options;
    }

    public Boolean showEnergyStar = false;

    public PageReference displayEnergyStarText() {

        if (lopOffer.LOP_Energy_Star__c == 'No')
            showEnergyStar = true; else {
            showEnergyStar = false;
        }

        return null;
    }

    public boolean getShowEnergyStar() {
        if (lopOffer.LOP_Energy_Star__c == 'No') {
            showEnergyStar = true;
        }
        return showEnergyStar;
    }


    public List<SelectOption> getHistoricTierOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Historic property within a historic district', 'Historic property within a historic district'));
        options.add(new SelectOption('Non-historic property or underdeveloped site within a historic district', 'Non-historic property or underdeveloped site within a historic district'));
        options.add(new SelectOption('Historic properties outside of historic district', 'Historic properties outside of historic district'));
        options.add(new SelectOption('Non-historic property', 'Non-historic property'));
        return options;
    }

    public List<SelectOption> getAsbestosItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Contains no Asbestos-Containing Materials (ACM), or', 'Contains no Asbestos-Containing Materials (ACM), or'));
        options.add(new SelectOption('Contains ACM in a stable, solid matrix that is not damaged or subject to damage', 'Contains ACM in a stable, solid matrix that is not damaged or subject to damage'));
        options.add(new SelectOption('Contains ACM not in a stable, solid matrix', 'Contains ACM not in a stable, solid matrix'));
        return options;
    }

    public List<SelectOption> getSeismicOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('The RLP does not contain seismic requirements. No documentation required', 'The RLP does not contain seismic requirements. No documentation required'));
        options.add(new SelectOption('The RLP contains seismic requirements.', 'The RLP contains seismic requirements.'));
        return options;
    }
    public List<SelectOption> getSeismicItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Fully meets seismic requirements or meets an exemption under the RLP', 'Fully meets seismic requirements or meets an exemption under the RLP'));
        options.add(new SelectOption('Does not meet seismic requirements, but will be retrofitted to meet seismic requirements', 'Does not meet seismic requirements, but will be retrofitted to meet seismic requirements'));
        options.add(new SelectOption('Will be constructed to meet seismic requirements', 'Will be constructed to meet seismic requirements'));
        options.add(new SelectOption('Will not meet seismic requirements', 'Will not meet seismic requirements'));
        return options;
    }
    public List<SelectOption> getFloodPlainItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Not in a flood plain', 'Not in a flood plain'));
        options.add(new SelectOption('A base (100-year) flood plain', 'A base (100-year) flood plain'));
        options.add(new SelectOption('A 500-year flood plain', 'A 500-year flood plain'));
        return options;
    }
    public List<SelectOption> getFireProtectionItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets the Lease fire/life safety standards.', 'Meets the Lease fire/life safety standards.'));
        options.add(new SelectOption('Does not meet the Lease fire/life safety standards', 'Does not meet the Lease fire/life safety standards'));
        return options;
    }


    public PageReference actionCancel() {
        PageReference pref = Page.PBS_LOP_PortalHome;
        pref.setRedirect(true);
        return pref;
    }

    public PageReference saveBuilding() {
        System.debug('in save method');
        //validations for Submit offer page fields
        draftMsgFlag = '';
        PageReference p = null;
        try {


            if (lopOffer.id != null) {
                if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) {
                    lopOffer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                }

                if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                    draftMsgFlag = 'true';
                }
                lopOffer.LOP_Offeror__c = userDetail.ContactId;

                //added by syam for FY16 changes
                String areaType = lopOffer.LOP_SITE_AREA_TYPE__c;
                System.debug('*** areaType is in  save ' + areaType);

                //siteSize.setScale(2, RoundingMode.HALF_UP); 

                if (lopOffer.LOP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
                    Decimal siteSize = lopOffer.LOP_SITE_SIZE_SQFT__c;
                    siteSize = siteSize * 43560;
                    //siteSize.setScale(2, RoundingMode.HALF_UP);

                    System.debug('*** siteSize inside is *** ' + siteSize);
                    lopOffer.LOP_SITE_SIZE_SQFT__c = siteSize;
                }
                if (lopOffer.LOP_Energy_Star__c == 'No') {
                    lopOffer.LOP_CERTIFICATION_DATE__c = null;
                } else {
                    lopOffer.LOP_Energy_Star_Reason__c = '';
                }
                try {

                    if (lopOffer.LOP_RLP_Contains_Seismic_Requirement__c != 'The RLP contains seismic requirements.') {
                        lopOffer.LOP_Offeror_Seismic_Declaration__c = '';
                    }
                    update lopOffer;
                    System.debug('*** after update lopOffer ***');
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));

                    return p;
                }
            } else {
                lopOffer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                //added by syam for FY16 changes
                String areaType = lopOffer.LOP_SITE_AREA_TYPE__c;
                System.debug('*** areaType is ' + areaType);
                Decimal siteSize = lopOffer.LOP_SITE_SIZE_SQFT__c;
                //siteSize.setScale(2, RoundingMode.HALF_UP);
                System.debug('*** siteSize is ' + siteSize);
                if (lopOffer.LOP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
                    siteSize = siteSize * 43560;
                    //siteSize.setScale(2, RoundingMode.HALF_UP);

                    System.debug('*** siteSize inside is ' + siteSize);
                    lopOffer.LOP_SITE_SIZE_SQFT__c = siteSize;
                }
                try {
                    insert lopOffer;
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));

                    return p;
                }
            }

        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }

        // offerBuilding = null; // clears ViewState for visual force page
        p = Page.PBS_LOP_Building;
        p.getParameters().put('offerId', offerId);
        p.getParameters().put('draftMsg', draftMsgFlag);
        p.setRedirect(true);
        return p;
    }

    public PageReference redirectToParking() {
        boolean errorflag = PBS_AAAP_GlobalConstants.checkOfferBuildingValidations(lopOffer);
        System.debug('=======>>>>>>>>> error flag for checkOfferBuildingValidations **** ::: ' + errorflag + '  offerbuilding Id is ' + lopOffer.id);
        if (errorflag == true) {
            return null;
        }

        saveBuilding();
        String offerId = lopOffer.Id;
        PageReference p = Page.PBS_LOP_Parking;
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
        return p;
    }


    public PageReference backToOfrBlding() {

        PageReference p = Page.PBS_LOP_Building;
        p.getParameters().put('offerId', offerId);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        p.setRedirect(true);
        return p;
    }
    // Save Button Logic
    public PageReference saveParkingInfo() {
        try {

            draftMsgFlag = '';
            updateAreaType(lopOffer);
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }

            update lopOffer;
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        return null;
    }
    // Continue Button Logic
    public PageReference saveParkingAndContinue() {

        //system.debug('***************offer Parking ID :'+offerParking);
        PageReference p = null;

        try {
            draftMsgFlag = '';
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            updateAreaType(lopOffer);
            update lopOffer;
            String offerId = lopOffer.Id;
            lopOffer = null; // clears ViewState for visual force page
            p = Page.PBS_LOP_PropertyOwner;
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
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }
        return p;

    }

/*RepsAndCerts*/
    // Save Button Logic
    public PageReference saveRepsAndCertsInfo() {
        try {
            draftMsgFlag = '';
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            updateAreaType(lopOffer);
            update lopOffer;
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        return null;
    }


    public PageReference saveRepsAndCertsandContinue() {
        PageReference p = null;
        boolean errorflag = PBS_AAAP_GlobalConstants.checkLOPOfferRepsAndCertsValidations(lopOffer);
        if (errorflag == true) {
            System.debug('inside error flag is true ***');
            return null;
        }
        try {
            draftMsgFlag = '';
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            updateAreaType(lopOffer);
            update lopOffer;
            System.debug('************** GPR ::: ' + lopOffer.LOP_GEN_PURPOSE_RENTABLE__c);
            String offerId = lopOffer.Id;
            lopOffer = null; // clears ViewState for visual force page

            p = Page.PBS_LOP_OperatingCost;
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
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }
        return p;
    }

    public Boolean otherRelationShip = false;
    public PageReference showOfferorRelationShipOther() {
        System.debug('Offeror Relation to property owner ::::::: ' + lopOffer.LOP_OFFEROR_INTEREST__c);
        if (lopOffer.LOP_OFFEROR_INTEREST__c == 'Other')
            otherRelationShip = true; else {
            otherRelationShip = false;
        }

        return null;
    }
    public boolean getOtherRelationShip() {
        if (lopOffer.LOP_OFFEROR_INTEREST__c == 'Other') {
            otherRelationShip = true;
        }
        return otherRelationShip;
    }

    public void actionSavePropertyOwner() {
        try {

            /*  System.debug('ownerFullName is ****'+ownerFullName);
              if(ownerFullName != null || ownerFullName != '') {
              String[] names = ownerFullName.split('\\s');
              System.debug(names.size());
                 firstName = names[0];
              if(names.size() > 1)  {
               lastName = names[1];
                   }
              lopOffer.LOP_Owner_FirstName__c = firstName;
                 lopOffer.LOP_Owner_LastName__c  = lastName;

              }  */
            draftMsgFlag = '';
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            updateAreaType(lopOffer);
            update lopOffer;
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }

    }

    public PageReference actionSavePropertyOwnerAndContinue() {
        PageReference p = null;
        boolean errorflag = PBS_AAAP_GlobalConstants.checkOfferPropOwnerValidations(lopOffer);
        if (errorflag == true) {
            return null;
        }
        try {

            actionSavePropertyOwner();
            p = Page.PBS_LOP_RepsAndCerts;
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

        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }

        return p;
    }

    public PageReference backToOfrParking() {

        PageReference p = Page.PBS_LOP_Parking;
        p.getParameters().put('offerId', lopOffer.Id);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        p.setRedirect(true);
        return p;
    }

    //this method is added for offer landing page
    public PageReference createEditOffer() {
        system.debug('Create / Edit Offer : Project ' + project);
        system.debug('Create / Edit Offer : : Project ID project.Project_Number__c' + projectID);
        system.debug('Create / Edit Offer : : EOI project.Project_EOI_ID__c' + EOIID);
        string newOfferID = '';
        PBS_GREX_Project_EOI__c grexProject = new PBS_GREX_Project_EOI__c();
        try {
            grexProject = [SELECT Id, name FROM PBS_GREX_Project_EOI__c p WHERE p.Project_Number__c = :projectID AND p.Project_EOI_ID__c = :EOIID AND (p.Project_Termination_Flag__c = FALSE)];
            System.debug('grexProject is' + grexProject);
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Project number and unique offer ID do not correspond or the project is terminated.  Please try again or contact LOP.manager@gsa.gov for more help.');
            ApexPages.addMessage(myMsg);
            return ApexPages.currentPage();
        }

        system.debug('Create / Edit Offer : Tempworkclass_VSS: EOI project.name' + grexProject.Id);
        List<PBS_LOP_OFFER__c> offer1 = new List<PBS_LOP_OFFER__c>();
        PBS_LOP_OFFER__c offernew = new PBS_LOP_OFFER__c();

        offer1 = [SELECT Id,LOP_Offer_Status__c,Project_EOI_ID__c FROM PBS_LOP_OFFER__c p WHERE Project_EOI_ID__c = :grexProject.id];
        system.debug('Create / Edit Offer : Tempworkclass_VSS: I am here' + offer1.size());
        if (offer1.size() == 0) {
            offernew.Project_EOI_ID__c = grexProject.id;
            offernew.LOP_Offer_Status__c = 'Draft';
            insert offernew;
            newOfferID = offernew.id;
            system.debug('Create / Edit Offer : Tempworkclass_VSS: Offer1' + offer1);
        } else {
            newOfferID = offer1[0].Id;
        }

        PageReference p = Page.PBS_LOP_Building;
        p.getParameters().put('offerId', newOfferID);
        p.setRedirect(true);
        return p;
    }
    /**
     * this methos is added to copy the user details on the property owner page when user checks the check box "Check if Same as Offeror" */
    public void copyUserDetails() {
        System.debug('inside copy User Details !!!');
        ownerFullName = userDetail.FirstName + ' ' + userDetail.LastName;
        lopOffer.LOP_Property_Owner_Company__c = userDetail.CompanyName;
        lopOffer.LOP_Owner_LastName__c = userDetail.LastName;
        lopOffer.LOP_Owner_FirstName__c = userDetail.FirstName;
        lopOffer.LOP_Owner_Address__c = userDetail.Street;
        lopOffer.LOP_Owner_City__c = userDetail.City;
        lopOffer.LOP_Owner_State__c = userDetail.State;
        lopOffer.LOP_Owner_Zip__c = userDetail.postalCode;

    }
    /*RepsAndCerts*/
    public PageReference backToOfrPropertyOwnerTab() {

        PageReference p = Page.PBS_LOP_PropertyOwner;
        p.getParameters().put('offerId', lopOffer.Id);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        p.setRedirect(true);
        return p;
    }


    // Re-Rendering Logic
    public Boolean smallBusinessYES = false;
    public Boolean smallBusinessNO = false;
    public PageReference showPropertyOwnerSmallBusiness() {
        System.debug('Owner representation ::::::: ' + lopOffer.LOP_Representation_Business__c);
        if (lopOffer.LOP_Representation_Business__c == 'Small Business') {
            smallBusinessYES = true;
            smallBusinessNO = false;
        } else if (lopOffer.LOP_Representation_Business__c == 'Not a Small Business') {

            smallBusinessYES = false;
            smallBusinessNO = true;

        }
        return null;
    }
    public boolean getSmallBusinessYES() {
        if (lopOffer.LOP_Representation_Business__c == 'Small Business') {
            smallBusinessYES = true;
        }
        return smallBusinessYES;
    }
    public boolean getSmallBusinessNO() {
        if (lopOffer.LOP_Representation_Business__c == 'Not a Small Business') {
            smallBusinessNO = true;
        }
        return smallBusinessNO;
    }


    /** from here for Space and Rates **/

    public void initializeSpaceAndRates() {
        //System.debug('in initializeSpaceAndRates fields'+lopOffer.LOP_OP_COST_COST_PER_RSF__c);
        //System.debug('in initializeSpaceAndRates fields'+lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c);
        //System.debug(lopOffer.LOP_TI_Annual_Rent_Per_RSF__c);
        lopOffer.LOP_Step_1_Rent_Per_RSF__c = (lopOffer.LOP_Step_1_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.LOP_Step_1_Rent_Per_RSF__c).setScale(2);
        lopOffer.LOP_Step_2_Rent_Per_RSF__c = (lopOffer.LOP_Step_2_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.LOP_Step_2_Rent_Per_RSF__c).setScale(2);
        lopOffer.LOP_Step_3_Rent_Per_RSF__c = (lopOffer.LOP_Step_3_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.LOP_Step_3_Rent_Per_RSF__c).setScale(2);

        lopOffer.LOP_Step_1_Rent_Per_ABOA__c = (lopOffer.LOP_Step_1_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.LOP_Step_1_Rent_Per_ABOA__c).setScale(2);
        lopOffer.LOP_Step_2_Rent_Per_ABOA__c = (lopOffer.LOP_Step_2_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.LOP_Step_2_Rent_Per_ABOA__c).setScale(2);
        lopOffer.LOP_Step_3_Rent_Per_ABOA__c = (lopOffer.LOP_Step_3_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.LOP_Step_3_Rent_Per_ABOA__c).setScale(2);

        lopOffer.LOP_Shell_Rent_Per_RSF__c = (lopOffer.LOP_Shell_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.LOP_Shell_Rent_Per_RSF__c).setScale(2);
        lopOffer.LOP_Shell_Rent_Per_ABOA__c = (lopOffer.LOP_Shell_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.LOP_Shell_Rent_Per_ABOA__c).setScale(2);
        lopOffer.LOP_Office_RSF_OFFERED__c = (lopOffer.LOP_Office_RSF_OFFERED__c == null) ? 0.00 : (lopOffer.LOP_Office_RSF_OFFERED__c);
        lopOffer.LOP_GEN_PURPOSE_RENTABLE__c = (lopOffer.LOP_GEN_PURPOSE_RENTABLE__c == null) ? 0.00 : (lopOffer.LOP_GEN_PURPOSE_RENTABLE__c).setScale(2);
        lopOffer.LOP_OP_COST_COST_PER_RSF__c = (lopOffer.LOP_OP_COST_COST_PER_RSF__c == null) ? 0.00 : (lopOffer.LOP_OP_COST_COST_PER_RSF__c).setScale(2);
        lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c = (lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c).setScale(2);
        lopOffer.LOP_TI_Annual_Rent_Per_RSF__c = (lopOffer.LOP_TI_Annual_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.LOP_TI_Annual_Rent_Per_RSF__c).setScale(2);
        lopOffer.LOP_OP_COST_COST_PER_ABOA__c = (lopOffer.LOP_OP_COST_COST_PER_ABOA__c == null) ? 0.00 : (lopOffer.LOP_OP_COST_COST_PER_ABOA__c).setScale(2);
        lopOffer.LOP_BSAC_Annual_Rent_Per_ABOA__c = (lopOffer.LOP_BSAC_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.LOP_BSAC_Annual_Rent_Per_ABOA__c).setScale(2);
        lopOffer.LOP_TI_Annual_Rent_Per_ABOA__c = (lopOffer.LOP_TI_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.LOP_TI_Annual_Rent_Per_ABOA__c).setScale(2);
        lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c = (lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c == null) ? 0.00 : (lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c).setScale(2);
        lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c = (lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c).setScale(2);
        lopOffer.LOP_Annual_TI_Rent__c = (lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c == null) ? 0.00 : (lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c).setScale(2);
        lopOffer.LOP_Anual_BSAC_Rent__c = (lopOffer.LOP_Anual_BSAC_Rent__c == null) ? 0.00 : (lopOffer.LOP_Anual_BSAC_Rent__c).setScale(2);
        lopOffer.LOP_Common_Area_Factor__c = (lopOffer.LOP_Common_Area_Factor__c == null) ? 0.00 : (lopOffer.LOP_Common_Area_Factor__c).setScale(2);

        lopOffer.LOP_TI_Buildout_as_in_RLP__c = (lopOffer.LOP_TI_Buildout_as_in_RLP__c == null) ? 0.00 : (lopOffer.LOP_TI_Buildout_as_in_RLP__c).setScale(2);
        totalAnnualRentAmt = (lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c * lopOffer.LOP_Office_RSF_OFFERED__c).setScale(2);

/*
		lopOffer.LOP_Common_Area_Factor__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c>0)?100*(lopOffer.LOP_Office_RSF_OFFERED__c-lopOffer.LOP_Total_Ofc_ABOA_offered__c)/lopOffer.LOP_Total_Ofc_ABOA_offered__c:0.00;
        lopOffer.LOP_Common_Area_Factor__c = (lopOffer.LOP_Common_Area_Factor__c).setScale(2);
*/
        lopOffer.LOP_Op_Cost_Years_Effective__c = lopOffer.LOP_INITIAL_NO_OF_YEARS__c;
        lopOffer.LOP_BSAC_Years_Rate_Effective__c = lopOffer.LOP_BSAC_Years_Rate_Effective__c == null ? 0.00 : (lopOffer.LOP_BSAC_Years_Rate_Effective__c).setScale(2);
        lopOffer.LOP_TI_Years_Rate_Effective__c = lopOffer.LOP_TI_Years_Rate_Effective__c == null ? 0.00 : (lopOffer.LOP_TI_Years_Rate_Effective__c).setScale(2);
/*
		lopOffer.LOP_OP_COST_COST_PER_ABOA__c=(lopOffer.LOP_Total_Ofc_ABOA_offered__c>0)?(lopoffer.LOP_SRVC_UTIL_TOTAL__c/lopOffer.LOP_Total_Ofc_ABOA_offered__c):0;
		lopOffer.LOP_OP_COST_COST_PER_RSF__c=(lopOffer.LOP_Office_RSF_OFFERED__c>0)?(lopoffer.LOP_SRVC_UTIL_TOTAL__c/lopOffer.LOP_Office_RSF_OFFERED__c).setscale(2):0;

		lopOffer.LOP_Shell_Rent_Per_ABOA__c = (lopOffer.LOP_Office_RSF_OFFERED__c>0)?((lopOffer.LOP_Shell_Rent_Per_RSF__c * lopOffer.LOP_Total_Ofc_ABOA_offered__c)/lopOffer.LOP_Office_RSF_OFFERED__c).setscale(2):0;
        System.debug('lopOffer.LOP_Shell_Rent_Per_RSF__c:' + lopOffer.LOP_Shell_Rent_Per_RSF__c);
        System.debug('lopOffer.LOP_Shell_Rent_Per_ABOA__c:' + lopOffer.LOP_Shell_Rent_Per_ABOA__c); 
        
        lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c = lopOffer.LOP_OP_COST_COST_PER_RSF__c + lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c + lopOffer.LOP_TI_Annual_Rent_Per_RSF__c + lopOffer.LOP_Shell_Rent_Per_RSF__c;
     	System.debug('in lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c fields'+lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c);
        lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c = lopOffer.LOP_OP_COST_COST_PER_ABOA__c + lopOffer.LOP_BSAC_Annual_Rent_Per_ABOA__c + lopOffer.LOP_TI_Annual_Rent_Per_ABOA__c + lopOffer.LOP_Shell_Rent_Per_ABOA__c; 
        System.debug('in lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c fields'+lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c);

        lopOffer.LOP_Renewal_Shell_Rate__c = lopOffer.LOP_Renewal_Shell_Rate__c == null ? 0.00 : (lopOffer.LOP_Renewal_Shell_Rate__c).setScale(2);
        lopOffer.LOP_TI_Buildout_as_in_RLP__c = lopOffer.LOP_TI_Buildout_as_in_RLP__c == null ? 0.00 : (lopOffer.LOP_TI_Buildout_as_in_RLP__c).setScale(2);
        lopOffer.LOP_TI_Total_Build_out_Costs__c = lopOffer.LOP_TI_Total_Build_out_Costs__c == null ? 0.00 : (lopOffer.LOP_TI_Total_Build_out_Costs__c).setScale(2);
        lopOffer.LOP_TI_Amorti_Interest_Rate__c = lopOffer.LOP_TI_Amorti_Interest_Rate__c == null ? 0.00 : (lopOffer.LOP_TI_Amorti_Interest_Rate__c).setScale(2);
        lopOffer.LOP_Annual_TI_Rent__c = lopOffer.LOP_Annual_TI_Rent__c == null ? 0.00 : (lopOffer.LOP_Annual_TI_Rent__c).setScale(2);
        lopOffer.LOP_BSAC_Total_Build_out_Costs__c = lopOffer.LOP_BSAC_Total_Build_out_Costs__c == null ? 0.00 : (lopOffer.LOP_BSAC_Total_Build_out_Costs__c).setScale(2);
        lopOffer.LOP_BSAC_Amorti_Interest_Rate__c = lopOffer.LOP_BSAC_Amorti_Interest_Rate__c == null ? 0.00 : (lopOffer.LOP_BSAC_Amorti_Interest_Rate__c).setScale(2);
        
            
            
        
        System.debug('in totalAnnualRentAmt fields'+totalAnnualRentAmt);
*/
    }

    public void saveSpaceRates() {
        try {
            lopOffer.LOP_Common_Area_Factor__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c > 0) ? (100 * (lopOffer.LOP_Office_RSF_OFFERED__c - lopOffer.LOP_Total_Ofc_ABOA_offered__c) / lopOffer.LOP_Total_Ofc_ABOA_offered__c) : 0.00;
//Op Cost
            lopOffer.LOP_Op_Cost_Years_Effective__c = lopOffer.LOP_INITIAL_NO_OF_YEARS__c;
            lopOffer.LOP_OP_COST_COST_PER_ABOA__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c > 0) ? (lopoffer.LOP_SRVC_UTIL_TOTAL_GOV__c / lopOffer.LOP_Total_Ofc_ABOA_offered__c) : 0;
            lopOffer.LOP_OP_COST_COST_PER_RSF__c = (lopOffer.LOP_Office_RSF_OFFERED__c > 0) ? (lopoffer.LOP_SRVC_UTIL_TOTAL_GOV__c / lopOffer.LOP_Office_RSF_OFFERED__c) : 0;
//Shell Rent	
            lopOffer.LOP_Shell_Rent_Per_ABOA__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c > 0) ? ((lopOffer.LOP_Shell_Rent_Per_RSF__c * lopOffer.LOP_Office_RSF_OFFERED__c) / lopOffer.LOP_Total_Ofc_ABOA_offered__c) : 0;
            System.debug('lopOffer.LOP_Shell_Rent_Per_RSF__c:' + lopOffer.LOP_Shell_Rent_Per_RSF__c);
            System.debug('lopOffer.LOP_Shell_Rent_Per_ABOA__c:' + lopOffer.LOP_Shell_Rent_Per_ABOA__c);
//TI
//LOP_Annual_TI_Rent__c ,  LOP_Anual_BSAC_Rent__c , LOP_TI_Buildout_as_in_RLP__c

            lopOffer.LOP_TI_Total_Build_out_Costs__c = (lopOffer.LOP_TI_Buildout_as_in_RLP__c == null) ? 0.00 : (lopOffer.LOP_TI_Buildout_as_in_RLP__c * lopOffer.LOP_Total_Ofc_ABOA_offered__c);
            lopOffer.LOP_TI_Amorti_Interest_Rate__c = (lopOffer.LOP_TI_Amorti_Interest_Rate__c == null) ? 0 : lopOffer.LOP_TI_Amorti_Interest_Rate__c;
            lopOffer.LOP_TI_Amorization_in_Years__c = (lopOffer.LOP_TI_Amorization_in_Years__c == null) ? 0 : lopOffer.LOP_TI_Amorization_in_Years__c;

            lopOffer.LOP_Annual_TI_Rent__c = getAmortizationCost((lopOffer.LOP_TI_Amorti_Interest_Rate__c).doubleValue(), (lopOffer.LOP_TI_Total_Build_out_Costs__c).doubleValue(), (lopOffer.LOP_TI_Amorization_in_Years__c).intValue());

            lopOffer.LOP_TI_Annual_Rent_Per_RSF__c = (lopOffer.LOP_Office_RSF_OFFERED__c == 0) ? 0 : (lopOffer.LOP_Annual_TI_Rent__c / lopOffer.LOP_Office_RSF_OFFERED__c);
            lopOffer.LOP_TI_Annual_Rent_Per_ABOA__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c == 0) ? 0 : (lopOffer.LOP_Annual_TI_Rent__c / lopOffer.LOP_Total_Ofc_ABOA_offered__c);
            lopOffer.LOP_TI_Years_Rate_Effective__c = (lopOffer.LOP_TI_Amorization_in_Years__c == null) ? 0 : (lopOffer.LOP_TI_Amorization_in_Years__c / 12);
//BSAC
            lopOffer.LOP_BSAC_Total_Build_out_Costs__c = (lopOffer.LOP_BSAC_Total_Build_out_Costs__c == null) ? 0.00 : (lopOffer.LOP_BSAC_Total_Build_out_Costs__c);
            lopOffer.LOP_BSAC_Amorti_Interest_Rate__c = (lopOffer.LOP_BSAC_Amorti_Interest_Rate__c == null) ? 0 : lopOffer.LOP_BSAC_Amorti_Interest_Rate__c;
            lopOffer.LOP_BSAC_Amorization_in_Years__c = (lopOffer.LOP_BSAC_Amorization_in_Years__c == null) ? 0 : lopOffer.LOP_BSAC_Amorization_in_Years__c;

            lopOffer.LOP_Anual_BSAC_Rent__c = getAmortizationCost((lopOffer.LOP_BSAC_Amorti_Interest_Rate__c).doubleValue(), (lopOffer.LOP_BSAC_Total_Build_out_Costs__c).doubleValue(), (lopOffer.LOP_BSAC_Amorization_in_Years__c).intValue());
            //added by syam on 11/25/2016 for setting to 2 decimals
            lopOffer.LOP_Anual_BSAC_Rent__c = (lopOffer.LOP_Anual_BSAC_Rent__c == null) ? 0.00 : (lopOffer.LOP_Anual_BSAC_Rent__c);

            lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c = (lopOffer.LOP_Office_RSF_OFFERED__c == 0) ? 0 : (lopOffer.LOP_Anual_BSAC_Rent__c / lopOffer.LOP_Office_RSF_OFFERED__c);
            lopOffer.LOP_BSAC_Annual_Rent_Per_ABOA__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c == 0) ? 0 : (lopOffer.LOP_Anual_BSAC_Rent__c / lopOffer.LOP_Total_Ofc_ABOA_offered__c);
            lopOffer.LOP_BSAC_Years_Rate_Effective__c = (lopOffer.LOP_BSAC_Amorization_in_Years__c == null) ? 0 : (lopOffer.LOP_BSAC_Amorization_in_Years__c / 12);

//Annual Rent	        
            lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c = lopOffer.LOP_OP_COST_COST_PER_RSF__c + lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c + lopOffer.LOP_TI_Annual_Rent_Per_RSF__c + lopOffer.LOP_Shell_Rent_Per_RSF__c;
            System.debug('in lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c fields' + lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c);
            lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c = lopOffer.LOP_OP_COST_COST_PER_ABOA__c + lopOffer.LOP_BSAC_Annual_Rent_Per_ABOA__c + lopOffer.LOP_TI_Annual_Rent_Per_ABOA__c + lopOffer.LOP_Shell_Rent_Per_ABOA__c;
            System.debug('in lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c fields' + lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c);
//Total Annual Rent

            lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c = lopOffer.LOP_OP_COST_COST_PER_RSF__c + lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c + lopOffer.LOP_TI_Annual_Rent_Per_RSF__c + lopOffer.LOP_Shell_Rent_Per_RSF__c;
            System.debug('in lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c fields' + lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c);
            lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c = lopOffer.LOP_OP_COST_COST_PER_ABOA__c + lopOffer.LOP_BSAC_Annual_Rent_Per_ABOA__c + lopOffer.LOP_TI_Annual_Rent_Per_ABOA__c + lopOffer.LOP_Shell_Rent_Per_ABOA__c;
            System.debug('in lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c fields' + lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c);

            totalAnnualRentAmt = lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c * lopOffer.LOP_Office_RSF_OFFERED__c;
            System.debug('in totalAnnualRentAmt fields' + totalAnnualRentAmt);
//Step Rent
            lopOffer.LOP_Step_1_Rent_Per_ABOA__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c == 0) ? 0 : (lopOffer.LOP_Office_RSF_OFFERED__c * lopOffer.LOP_Step_1_Rent_Per_RSF__c / lopOffer.LOP_Total_Ofc_ABOA_offered__c);
            lopOffer.LOP_Step_2_Rent_Per_ABOA__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c == 0) ? 0 : (lopOffer.LOP_Office_RSF_OFFERED__c * lopOffer.LOP_Step_2_Rent_Per_RSF__c / lopOffer.LOP_Total_Ofc_ABOA_offered__c);
            lopOffer.LOP_Step_3_Rent_Per_ABOA__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c == 0) ? 0 : (lopOffer.LOP_Office_RSF_OFFERED__c * lopOffer.LOP_Step_3_Rent_Per_RSF__c / lopOffer.LOP_Total_Ofc_ABOA_offered__c);
            draftMsgFlag = '';
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }

            if (lopOffer.LOP_Renewal_Shell_Rate__c > 0)
                lopOffer.LOP_Lease_Has_Renewal_Options__c = 'Yes'; else {
                lopOffer.LOP_Lease_Has_Renewal_Options__c = 'No';
            }

            lopOffer.LOP_Num_Years_Annual_Rate_is_Effective__c = getMinimum(
                    lopOffer.LOP_BSAC_Years_Rate_Effective__c, lopOffer.LOP_TI_Years_Rate_Effective__c, lopOffer.LOP_Shell_Rate_Years_Effective__c);
            System.debug('lopOffer.LOP_Num_Years_Annual_Rate_is_Effective__c is *** ' + lopOffer.LOP_Num_Years_Annual_Rate_is_Effective__c);

            //added by syam on 12/08/2016 for steprent changes
            if (lopOffer.LOP_Is_Shell_Rent_Stepped__c == 'Yes') {
                lopOffer.LOP_Step_1_Start__c = 1;
                lopOffer.LOP_Step_1_End__c = lopOffer.LOP_Shell_Rate_Years_Effective__c;
                lopOffer.LOP_Step_1_Rent_Per_RSF__c = lopOffer.LOP_Shell_Rent_Per_RSF__c;
                lopOffer.LOP_Step_1_Rent_Per_ABOA__c = lopOffer.LOP_Shell_Rent_Per_ABOA__c;
            } else {
                lopOffer.LOP_Step_1_Start__c = 0;
                lopOffer.LOP_Step_1_End__c = 0;
                lopOffer.LOP_Step_1_Rent_Per_RSF__c = 0;
                lopOffer.LOP_Step_1_Rent_Per_ABOA__c = 0;

                lopOffer.LOP_Step_2_Start__c = 0;
                lopOffer.LOP_Step_2_End__c = 0;
                lopOffer.LOP_Step_2_Rent_Per_RSF__c = 0;
                lopOffer.LOP_Step_2_Rent_Per_ABOA__c = 0;

                lopOffer.LOP_Step_3_Start__c = 0;
                lopOffer.LOP_Step_3_End__c = 0;
                lopOffer.LOP_Step_3_Rent_Per_RSF__c = 0;
                lopOffer.LOP_Step_3_Rent_Per_ABOA__c = 0;


            }
            updateAreaType(lopOffer);
            update lopOffer;
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }

    }

    public Decimal getMinimum(Decimal dec1, Decimal dec2, Decimal dec3) {
        Decimal returnVal = 0;
        dec1 = (dec1 == null) ? 0 : dec1;
        dec2 = (dec2 == null) ? 0 : dec2;
        dec3 = (dec3 == null) ? 0 : dec3;
        returnVal = Math.min(dec1, Math.min(dec2, dec3));
        System.debug('returnVal is ***' + returnVal);
        return returnVal;

    }
    public PageReference actionSaveSpaceRates() {

        saveSpaceRates();
        PageReference p = Page.pbs_lop_SpacesAndRates;
        p.getParameters().put('offerId', lopOffer.Id);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        p.setRedirect(true);
        return p;
    }
    public void renderStepRentSection() {
        if (lopOffer.LOP_Is_Shell_Rent_Stepped__c == 'Yes')
            stepRent = true; else {
            stepRent = true;
        }

    }
    //tosave TISection
/*      public PageReference saveTISection(){
         lopOffer.LOP_Common_Area_Factor__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c / lopOffer.LOP_Office_RSF_OFFERED__c).setScale(2);
         lopOffer.LOP_TI_Annual_Rent_Per_ABOA__c =  (lopOffer.LOP_Common_Area_Factor__c==null ||lopOffer.LOP_Common_Area_Factor__c==0)? lopOffer.LOP_TI_Annual_Rent_Per_RSF__c:(lopOffer.LOP_TI_Annual_Rent_Per_RSF__c/lopOffer.LOP_Common_Area_Factor__c).setScale(2);
        lopOffer.LOP_Lease_Annual_Rent_Per_ABOA__c = (lopOffer.LOP_Common_Area_Factor__c==null ||lopOffer.LOP_Common_Area_Factor__c==0)? lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c:(lopOffer.LOP_Lease_Annual_Rent_Per_RSF__c/lopOffer.LOP_Common_Area_Factor__c).setScale(2);
          update lopOffer;
         PageReference p = Page.pbs_lop_SpacesAndRates;
        p.getParameters().put('offerId', lopOffer.Id);
        if(isEditable == 'true') { 
        p.getParameters().put('edit', 'true');
            }
            else{ isEditable='false';}
        p.setRedirect(true);
        return p;
    }
 */
    //tosave BSACSection
    /*    public PageReference saveBSACSection(){
           lopOffer.LOP_Common_Area_Factor__c = (lopOffer.LOP_Total_Ofc_ABOA_offered__c / lopOffer.LOP_Office_RSF_OFFERED__c).setScale(2);
            lopOffer.LOP_BSAC_Annual_Rent_Per_ABOA__c = (lopOffer.LOP_Common_Area_Factor__c==null ||lopOffer.LOP_Common_Area_Factor__c==0)? lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c:(lopOffer.LOP_BSAC_Annual_Rent_Per_RSF__c/lopOffer.LOP_Common_Area_Factor__c).setScale(2);
          update lopOffer;

           PageReference p = Page.pbs_lop_SpacesAndRates;
           p.getParameters().put('offerId', lopOffer.Id);
           if(isEditable == 'true') {
           p.getParameters().put('edit', 'true');
               }
               else{ isEditable='false';}
           p.setRedirect(true);
           return p;
       }
    */
    public PageReference actionSaveSpaceRatesAndContinue() {
        PageReference p = null;

        try {
            boolean flag = PBS_AAAP_GlobalConstants.checkLOPOfferSpaceRates(lopOffer);
            if (flag == true) {
                return null;
            }
            draftMsgFlag = '';
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            saveSpaceRates();
            p = Page.PBS_LOP_Attachments;
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

        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }

        return p;
    }

    public PageReference backToLeaseTerms() {

        PageReference p = Page.PBS_LOP_LeaseTerms;
        p.getParameters().put('offerId', lopOffer.Id);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        p.setRedirect(true);
        return p;
    }


    //Lease Terms section
    public PageReference backToOperatingCostTab() {

        PageReference p = Page.PBS_LOP_OperatingCost;
        p.getParameters().put('offerId', lopOffer.Id);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
        p.setRedirect(true);
        return p;
    }
    public PageReference saveLeaseTermsandContinue() {
        PageReference p = null;
        boolean errorflag = PBS_AAAP_GlobalConstants.checkLOPOfferLeaseTerms(lopOffer);
        if (errorflag == true) {
            System.debug('inside error flag is true ***');
            return null;
        }
        try {
            //conditioning for arch engg fee
            if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '1. Per ABOA Square Feet ($)') {
                lopOffer.LOP_Architectural_Fees_Percent__c = archEnggFee;
                //lopOffer.
            }
            if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '1. Per ABOA Square Feet ($)') {
                lopOffer.LOP_ARCH_ENG_FEES_PER_USF__c = archEnggFee;
                lopOffer.LOP_Architectural_Fees_Percent__c = null;
                lopOffer.LOP_Architectural_Fees_Flat__c = null;
            } else if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '2. Percent of Total Construction Costs (%)') {
                lopOffer.LOP_Architectural_Fees_Percent__c = archEnggFee;
                lopOffer.LOP_ARCH_ENG_FEES_PER_USF__c = null;
                lopOffer.LOP_Architectural_Fees_Flat__c = null;
            } else if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '3. Flat Fee ($)') {
                lopOffer.LOP_Architectural_Fees_Flat__c = archEnggFee;
                lopOffer.LOP_ARCH_ENG_FEES_PER_USF__c = null;
                lopOffer.LOP_Architectural_Fees_Percent__c = null;
            }
            draftMsgFlag = '';
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            updateAreaType(lopOffer);
            update lopOffer;
            System.debug('************** GPR ::: ' + lopOffer.LOP_GEN_PURPOSE_RENTABLE__c);
            String offerId = lopOffer.Id;
            lopOffer = null; // clears ViewState for visual force page

            p = Page.pbs_lop_SpacesAndRates;
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
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }
        return p;
    }
    public PageReference saveLeaseTermsInfo() {
        PageReference p = null;

        try {
            draftMsgFlag = '';
            if (lopOffer.LOP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '1. Per ABOA Square Feet ($)') {
                lopOffer.LOP_Architectural_Fees_Percent__c = archEnggFee;
                //lopOffer.
            }
            if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '1. Per ABOA Square Feet ($)') {
                lopOffer.LOP_ARCH_ENG_FEES_PER_USF__c = archEnggFee;
                lopOffer.LOP_Architectural_Fees_Percent__c = null;
                lopOffer.LOP_Architectural_Fees_Flat__c = null;
            } else if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '2. Percent of Total Construction Costs (%)') {
                lopOffer.LOP_Architectural_Fees_Percent__c = archEnggFee;
                lopOffer.LOP_ARCH_ENG_FEES_PER_USF__c = null;
                lopOffer.LOP_Architectural_Fees_Flat__c = null;
            } else if (lopOffer.LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == '3. Flat Fee ($)') {
                lopOffer.LOP_Architectural_Fees_Flat__c = archEnggFee;
                lopOffer.LOP_ARCH_ENG_FEES_PER_USF__c = null;
                lopOffer.LOP_Architectural_Fees_Percent__c = null;
            }
            updateAreaType(lopOffer);
            update lopOffer;
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        return null;
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

    private void updateAreaType(PBS_LOP_OFFER__C lopOffer) {
        //added by syam for FY16 changes
        String areaType = lopOffer.LOP_SITE_AREA_TYPE__c;
        System.debug('*** areaType is ' + areaType);
        Decimal siteSize = lopOffer.LOP_SITE_SIZE_SQFT__c;
        //siteSize.setScale(2, RoundingMode.HALF_UP);
        System.debug('*** siteSize is ' + siteSize);
        if (lopOffer.LOP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
            siteSize = siteSize * 43560;
            //siteSize.setScale(2, RoundingMode.HALF_UP);

            System.debug('*** siteSize inside is ' + siteSize);
            lopOffer.LOP_SITE_SIZE_SQFT__c = siteSize;
        }

    }

}