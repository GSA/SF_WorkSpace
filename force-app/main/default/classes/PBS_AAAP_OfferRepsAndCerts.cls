public with sharing class PBS_AAAP_OfferRepsAndCerts {

    public PBS_AAAP_Offer__c offerRepsAndCerts { get; set; }
    public ID ofrID { get; set; }

    public Boolean repsAndCertsPage1 { get; set; }
    public Boolean repsAndCertsPage2 { get; set; }
    public Boolean isValidUser { get; set; }
    public String draftMsgFlag { get; set; }
    public PBS_AAAP_OfferRepsAndCerts() {
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {

            ofrID = ApexPages.currentPage().getParameters().get('offerId');
            system.debug('***************offer Parking ID in Constructor:' + ofrID);
            repsAndCertsPage1 = true;
            repsAndCertsPage2 = false;
            offerRepsAndCerts = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
            //added by syam for offerId validation
            if (offerRepsAndCerts.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
        }

    }

    // pick list values to show them as radio buttons
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }

    public List<SelectOption> getItemsQ9() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No, will activate registration'));
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


    // back button logic
    public PageReference backToOfrPropertyOwnerTab() {

        PageReference p = Page.PBS_AAAP_OfferPropertyOwner;
        p.getParameters().put('offerId', offerRepsAndCerts.Id);
        p.setRedirect(true);
        return p;
    }

    // continue button logic
    public PageReference gotoAttachmentsTab() {
        PageReference p = null;
        boolean errorflag = checkOfferRepsAndCertsValidations();
        if (errorflag == true) {
            System.debug('inside error flag is true ***');
            return null;
        }
        try {
            draftMsgFlag = '';
            if (offerRepsAndCerts.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offerRepsAndCerts.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }
            update offerRepsAndCerts;
            System.debug('************** GPR ::: ' + offerRepsAndCerts.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);

            p = Page.PBS_AAAP_OperatingCosts;
            p.getParameters().put('offerId', offerRepsAndCerts.Id);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            p.setRedirect(true);
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }
        return p;
    }

    public boolean checkOfferRepsAndCertsValidations() {

        boolean flag;
        if (offerRepsAndCerts.PBS_AAAP_Representation__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_REPRESENTATION_REQUIRED));
            flag = true;
        }
        /* commented by syam for FY16
           if(offerRepsAndCerts.PBS_AAAP_Representation__c == PBS_AAAP_GlobalConstants.REPS_AND_CERTS_SMALL_BUSINESS && offerRepsAndCerts.PBS_AAAP_Women_Owned_Identifier__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_WOMEN_OWNED));
             flag=true;
         }*/
        //     if(offerRepsAndCerts.PBS_AAAP_Representation__c == PBS_AAAP_GlobalConstants.REPS_AND_CERTS_SMALL_BUSINESS && offerRepsAndCerts.PBS_AAAP_SMALL_DISADVANTAGED_IDENTIFIER__c != PBS_AAAP_GlobalConstants.YES
        //         && offerRepsAndCerts.PBS_AAAP_Women_Owned_Identifier__c != PBS_AAAP_GlobalConstants.YES
        //         && offerRepsAndCerts.PBS_AAAP_Veteran_Owned_Identifier__c != PBS_AAAP_GlobalConstants.YES
        //         && offerRepsAndCerts.PBS_AAAP_HUBZONE_IDENTIFIER__c != PBS_AAAP_GlobalConstants.YES){
        //         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_SMALL_BUSINESS_YES));
        //         flag=true;
        //     }
        /*if(offerRepsAndCerts.PBS_AAAP_EEO_CLAUSE__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_EEO_CLAUSE));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_AFFIRMATIVE_ACTION));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_CERTIFICATE_OF_SIGNATORY));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_Confirm_Owner_Status__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_CONFIRM_OWNER_STATUS));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_OWNER_CONVICTION__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_OWNER_CONVICTION));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_OWNER_INDICTMENT__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_OWNER_INDICTMENT));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_OWNER_CONTRACT_DEFAULT));
            flag=true;
        }*/
//**** Vaishali Federal Tax Delinquency Identifier code RLP FY14//        
        /*commented for FY16 syam
         *  if(offerRepsAndCerts.PBS_AAAP_FederalTax_Delinquent__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_OWNER_FEDTAX_DEFAULT));
             flag=true;
         }*/
        if (offerRepsAndCerts.PBS_AAAP_Corporation_not_tax_felon__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_CORP_FELONY_CONVICTION));
            flag = true;
        }
        if (offerRepsAndCerts.PBS_AAAP_Corp_Not_Convicted_Felon__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_CORP_FEDTAX_DEFAULT));
            flag = true;
        }
        /*commented for FY16 syam
         * if(offerRepsAndCerts.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_CCR_REGISTRATION));
            flag=true;
        }*/
        return flag;
    }

    // Re-Rendering Logic
    public Boolean smallBusinessYES = false;
    public Boolean smallBusinessNO = false;
    public PageReference showPropertyOwnerSmallBusiness() {
        System.debug('Owner representation ::::::: ' + offerRepsAndCerts.PBS_AAAP_Representation__c);
        if (offerRepsAndCerts.PBS_AAAP_Representation__c == 'Small Business') {
            smallBusinessYES = true;
            smallBusinessNO = false;
        } else if (offerRepsAndCerts.PBS_AAAP_Representation__c == 'Not a Small Business') {
            offerRepsAndCerts.PBS_AAAP_SMALL_DISADVANTAGED_IDENTIFIER__c = '';
            offerRepsAndCerts.PBS_AAAP_Women_Owned_Identifier__c = '';
            smallBusinessYES = false;
            smallBusinessNO = true;
            offerRepsAndCerts.PBS_AAAP_HUBZONE_IDENTIFIER__c = '';
            showPropertyOwnerHUBZONE();
            offerRepsAndCerts.PBS_AAAP_Veteran_Owned_Identifier__c = '';
            offerRepsAndCerts.PBS_AAAP_WOSB_Docs_Complete__c = '';
            offerRepsAndCerts.PBS_AAAP_WOSB_Joint_Venture__c = '';
            offerRepsAndCerts.PBS_AAAP_EDWOSB_Docs_Complete__c = '';
            offerRepsAndCerts.PBS_AAAP_EDWOSB_Joint_Venture__c = '';
            showPropertyOwnerVeteranOwned();
            showPropertyOwnerWOSB();
            showPropertyOwnerEDWOSB();
        }
        return null;
    }
    public boolean getSmallBusinessYES() {
        if (offerRepsAndCerts.PBS_AAAP_Representation__c == 'Small Business') {
            smallBusinessYES = true;
        }
        return smallBusinessYES;
    }
    public boolean getSmallBusinessNO() {
        if (offerRepsAndCerts.PBS_AAAP_Representation__c == 'Not a Small Business') {
            smallBusinessNO = true;
        }
        return smallBusinessNO;
    }
    // Re-rendering the veteran owned 1D
    public Boolean smallBusiness1D = false;
    public PageReference showPropertyOwnerVeteranOwned() {
        System.debug('Veteran Owned ::::::: ' + offerRepsAndCerts.PBS_AAAP_Veteran_Owned_Identifier__c);
        if (offerRepsAndCerts.PBS_AAAP_Veteran_Owned_Identifier__c == 'Yes') {
            smallBusiness1D = true;
        } else {
            smallBusiness1D = false;
        }
        offerRepsAndCerts.PBS_AAAP_SERVICE_DISABLED_IDENTIFIER__c = '';
        return null;
    }
//**** Vaishali WOSB and EDWOSB code RLP FY14//    
    // Re-rendering the Women owned Small Business i and ii
    public Boolean WOSB1 = false;
    public PageReference showPropertyOwnerWOSB() {
        System.debug('Veteran Owned ::::::: ' + offerRepsAndCerts.PBS_AAAP_Veteran_Owned_Identifier__c);
        if ((offerRepsAndCerts.PBS_AAAP_Women_Owned_Identifier__c == 'Yes') && (offerRepsAndCerts.PBS_AAAP_Representation__c == 'Small Business')) {
            WOSB1 = true;
            if (offerRepsAndCerts.PBS_AAAP_SMALL_DISADVANTAGED_IDENTIFIER__c == 'Yes') {
                EDWOSB1 = true;
            } else {
                EDWOSB1 = false;
            }
        } else {
            WOSB1 = false;
            EDWOSB1 = false;
            WOSBJointNames = false;
            EDWOSBJointNames = false;
        }
        offerRepsAndCerts.PBS_AAAP_WOSB_Docs_Complete__c = '';
        offerRepsAndCerts.PBS_AAAP_WOSB_Joint_Venture__c = '';
        offerRepsAndCerts.PBS_AAAP_EDWOSB_Docs_Complete__c = '';
        offerRepsAndCerts.PBS_AAAP_EDWOSB_Joint_Venture__c = '';
        offerRepsAndCerts.WOSB_Joint_Venture_Names__c = '';
        offerRepsAndCerts.EDWOSB_Joint_Venture_Names__c = '';
        showPropertyOwnerEDWOSBNames();
        showPropertyOwnerWOSBNames();
        return null;
    }

    // Re-rendering the Eco Disadvantaged Women owned Small Business i and ii

    public Boolean EDWOSB1 = false;
    public PageReference showPropertyOwnerEDWOSB() {
        System.debug('Veteran Owned ::::::: ' + offerRepsAndCerts.PBS_AAAP_Veteran_Owned_Identifier__c);
        if (offerRepsAndCerts.PBS_AAAP_WOSB_Docs_Complete__c == 'Yes') {
            EDWOSB1 = true;
        } else {
            EDWOSB1 = false;
        }
        offerRepsAndCerts.PBS_AAAP_EDWOSB_Docs_Complete__c = '';
        offerRepsAndCerts.PBS_AAAP_EDWOSB_Joint_Venture__c = '';
        showPropertyOwnerEDWOSBNames();
        return null;
    }

    public Boolean EDWOSBJointNames = false;

    public PageReference showPropertyOwnerEDWOSBNames() {
        System.debug('EDWOSB Joint Venture ::::::: ' + offerRepsAndCerts.PBS_AAAP_EDWOSB_Joint_Venture__c);
        if (offerRepsAndCerts.PBS_AAAP_EDWOSB_Joint_Venture__c == 'Yes') {
            EDWOSBJointNames = true;
        } else {
            EDWOSBJointNames = false;
        }
        offerRepsAndCerts.EDWOSB_Joint_Venture_Names__c = '';
        return null;
    }

    public Boolean WOSBJointNames = false;

    public PageReference showPropertyOwnerWOSBNames() {
        System.debug('WOSB Joint Venture ::::::: ' + offerRepsAndCerts.PBS_AAAP_WOSB_Joint_Venture__c);
        System.debug('WOSB Joint Venture ::::::: ' + offerRepsAndCerts.PBS_AAAP_EDWOSB_Joint_Venture__c);
        System.debug('WOSBJointNames Joint Venture ::::::: ' + WOSBJointNames);
        System.debug('EDWOSBJointNames Joint Venture ::::::: ' + EDWOSBJointNames);
        if (offerRepsAndCerts.PBS_AAAP_WOSB_Joint_Venture__c == 'Yes') {
            WOSBJointNames = true;
        } else {
            WOSBJointNames = false;
        }
        offerRepsAndCerts.WOSB_Joint_Venture_Names__c = '';
        return null;
    }
//***End *** Vaishali WOSB and EDWOSB code RLP FY14//

    public boolean getSmallBusiness1D() {
        if (offerRepsAndCerts.PBS_AAAP_Veteran_Owned_Identifier__c == 'Yes') {
            smallBusiness1D = true;
        }
        return smallBusiness1D;
    }

    // Re-rendering the HUB ZONE 1F, Only visible if user selects "YES" on 1E.
    public Boolean smallBusinessHUBZONE = false;
    public PageReference showPropertyOwnerHUBZONE() {
        System.debug('HUB ZONE ::::::: ' + offerRepsAndCerts.PBS_AAAP_HUBZONE_IDENTIFIER__c);
        if (offerRepsAndCerts.PBS_AAAP_HUBZONE_IDENTIFIER__c == 'Yes') {
            smallBusinessHUBZONE = true;
        } else {
            smallBusinessHUBZONE = false;
            offerRepsAndCerts.PBS_AAAP_HUBZONE_JOINT_VENTURE__c = '';
            showPropertyOwnerHUBZONEJointVentureNames();
        }
        return null;
    }
    public boolean getSmallBusinessHUBZONE() {
        if (offerRepsAndCerts.PBS_AAAP_HUBZONE_IDENTIFIER__c == 'Yes') {
            smallBusinessHUBZONE = true;
        }
        return smallBusinessHUBZONE;
    }
//*** Vaishali RLP-FY14    
    public boolean getWOSB1() {
        if ((offerRepsAndCerts.PBS_AAAP_Women_Owned_Identifier__c == 'Yes') && (offerRepsAndCerts.PBS_AAAP_Representation__c == 'Small Business')) {
            WOSB1 = true;
        }
        return WOSB1;
    }
    public boolean getEDWOSB1() {
        if (offerRepsAndCerts.PBS_AAAP_EDWOSB_Docs_Complete__c == 'Yes') {
            EDWOSB1 = true;
        }
        return EDWOSB1;
    }
    public boolean getWOSBJointNames() {
        if (offerRepsAndCerts.PBS_AAAP_WOSB_Joint_Venture__c == 'Yes') {
            WOSBJointNames = true;
        }
        return WOSBJointNames;
    }
    public boolean getEDWOSBJointNames() {
        if (offerRepsAndCerts.PBS_AAAP_EDWOSB_Joint_Venture__c == 'Yes') {
            EDWOSBJointNames = true;
        }
        return EDWOSBJointNames;
    }
//*** Vaishali   
    // Re-rendering the HUB ZONE Names Joint Venture 1G, Only visible if user selects "YES" on 1F.
    public Boolean smallBusinessHUBZONENames = false;
    public PageReference showPropertyOwnerHUBZONEJointVentureNames() {
        System.debug('HUB ZONE Names::::::: ' + offerRepsAndCerts.PBS_AAAP_HUBZONE_JOINT_VENTURE__c);
        if (offerRepsAndCerts.PBS_AAAP_HUBZONE_JOINT_VENTURE__c == 'Yes') {
            smallBusinessHUBZONENames = true;
        } else {
            smallBusinessHUBZONENames = false;
        }
        return null;
    }
    public boolean getSmallBusinessHUBZONENames() {
        if (offerRepsAndCerts.PBS_AAAP_HUBZONE_JOINT_VENTURE__c == 'Yes') {
            smallBusinessHUBZONENames = true;
        }
        return smallBusinessHUBZONENames;
    }

    // Re-rendering the Question 2a, Only visible if user selects "YES" on Question 2.
    public Boolean complianceReport = false;
    public PageReference showPropertyOwnerComplianceReport() {
        System.debug('Equal Opp Solicitation ::::::: ' + offerRepsAndCerts.PBS_AAAP_EEO_CLAUSE__c);
        if (offerRepsAndCerts.PBS_AAAP_EEO_CLAUSE__c == 'Yes') {
            complianceReport = true;
        } else {
            complianceReport = false;
            offerRepsAndCerts.PBS_AAAP_COMPLIANCE_REPORT__c = '';
        }
        return null;
    }
    public boolean getComplianceReport() {
        if (offerRepsAndCerts.PBS_AAAP_EEO_CLAUSE__c == 'Yes') {
            complianceReport = true;
        }
        return complianceReport;
    }

    // Re-rendering the Question 3a, Only visible if user selects "YES" on Question 3.
    public Boolean secretaryLabor = false;
    public PageReference showPropertyOwnerSecretaryLabor3a() {
        System.debug('Action Programs ::::::: ' + offerRepsAndCerts.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c);
        if (offerRepsAndCerts.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c == 'No') {
            secretaryLabor = true;
        } else {
            secretaryLabor = false;
            offerRepsAndCerts.PBS_AAAP_AFFIRMATIVE_ACTION_CONTRACTS__c = '';
        }
        return null;
    }
    public boolean getSecretaryLabor() {
        if (offerRepsAndCerts.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c == 'No') {
            secretaryLabor = true;
        }
        return secretaryLabor;
    }

    // Re-rendering the Question 4a, Only visible if user selects "NO" on Question 4.
    public Boolean authorizedSignature = false;
    public PageReference showPropertyOwnerSecretaryAcknowledge4a() {
        System.debug('Authorized signature ::::::: ' + offerRepsAndCerts.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c);
        if (offerRepsAndCerts.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c == 'No') {
            authorizedSignature = true;
        } else {
            authorizedSignature = false;
            offerRepsAndCerts.PBS_AAAP_AUTHORIZED_SIGNATORY__c = '';
            showPropertyOwnerPersonFullName4b();
        }
        return null;
    }
    public boolean getAuthorizedSignature() {
        if (offerRepsAndCerts.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c == 'No') {
            authorizedSignature = true;
        }
        return authorizedSignature;
    }

    // Re-rendering the Question 4b, Only visible if user selects "NO" on Question 4a.
    public Boolean authorizedNames = false;
    public PageReference showPropertyOwnerPersonFullName4b() {
        System.debug('Authorized signature 4a ::::::: ' + offerRepsAndCerts.PBS_AAAP_AUTHORIZED_SIGNATORY__c);
        if (offerRepsAndCerts.PBS_AAAP_AUTHORIZED_SIGNATORY__c == 'Yes') {
            authorizedNames = true;
        } else {
            authorizedNames = false;
            offerRepsAndCerts.PBS_AAAP_NAMES_RESP_FOR_DET_PRICES__c = '';
        }
        return null;
    }
    public boolean getAuthorizedNames() {
        if (offerRepsAndCerts.PBS_AAAP_AUTHORIZED_SIGNATORY__c == 'Yes') {
            authorizedNames = true;
        }
        return authorizedNames;
    }

    // Save Button Logic
    public PageReference saveRepsAndCertsInfo() {
        try {
            draftMsgFlag = '';
            if (offerRepsAndCerts.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offerRepsAndCerts.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }
            update offerRepsAndCerts;
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        return null;
    }

    // logic for delete button
    public PageReference actionDeleteOffer() {
        PageReference pref = null;
        System.debug('************* offerRepsAndCerts ::: ' + offerRepsAndCerts);
        System.debug('************* offerRepsAndCerts.PBS_AAAP_Offer_Status__c ::: ' + offerRepsAndCerts.PBS_AAAP_Offer_Status__c);
        System.debug('************* offerRepsAndCerts.PBS_AAAP_Offer_Status__c ::: ' + PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT);
        if (offerRepsAndCerts.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || offerRepsAndCerts.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
            delete offerRepsAndCerts;   // Cascade delete - Deletes all Spaces and Othercosts associated with it.
            pref = Page.PBS_AAAP_PortalHome;
            pref.setRedirect(true);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + offerRepsAndCerts.PBS_AAAP_Offer_Status__c +
                    ', you can only delete on Draft or Pending Modification stage');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    public PageReference actionCancel() {
        PageReference pref = Page.PBS_AAAP_PortalHome;
        pref.setRedirect(true);
        return pref;
    }

}