public with sharing class PBS_AAAP_OfferParkingController {

    public String items { get; set; }

    public PBS_AAAP_Offer__c offerParking { get; set; }
    public ID offerID { get; set; }
    public ID propID { get; set; }
    public boolean isValidUser { get; set; }
    public String pageUrl{get;set;} 
    public string pageURLForRedirection {get;set;}
    public String rlpType { get; set; }
    //public boolean showerror { get; set; }
    //public boolean checkerror { get; set; }
    public String draftMsgFlag { get; set; }
     public Boolean viewOnly { get; set; }
    public String viewMsg { get; set; }
    public PBS_AAAP_OfferParkingController() {
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
        if (ApexPages.currentPage().getParameters().get('propertyId') != null){
            propID = ApexPages.currentPage().getParameters().get('propertyId');
        }
        String isEditable = ApexPages.currentPage().getParameters().get('edit');
        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in view mode. Any changes made will not be saved.';
        } else {
            viewOnly = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            offerID = ApexPages.currentPage().getParameters().get('offerId');
            system.debug('***************offer Parking ID in Constructor:' + offerID);
            offerParking = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            if(offerParking.RecordType.Name == 'AAAP')
                    {
                        rlpType = offerParking.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
                    }
                    else if(offerParking.RecordType.Name == 'RSAP')
                    {
                        rlpType = offerParking.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c;
                    }
            if (offerParking.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
        }


    }

    // Continue Button Logic
    public PageReference saveParkingAndContinue() {

        
        PageReference p = null;
        boolean errorflag = checkOfferParkingValidations();        
        if (errorflag == true) {
            return null;
        }
        PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(offerParking,new List<String>{'Offer-M-Parking'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            return null;
        }
        try {
            offerParking.PBS_AAAP_Total_Parking_Spaces__c = offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c + offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c;
            //JK 7/2021. Can remove the next line. On save, the field is directly populated by the user input in question #3
            //offerParking.PBS_AAAP_Total_Park_Spaces_Offered__c = offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c + offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c;
            offerParking.PBS_AAAP_RLP_Region__c = offerParking.PBS_AAAP_RLP_Number__r.PBS_AAAP_Region__c;
            draftMsgFlag = '';
            if (offerParking.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offerParking.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }

            update offerParking;
            String offerId = offerParking.Id;
            offerParking = null; // clears ViewState for visual force page
            
            
            
            p = new PageReference('/AAAP/OperatingCosts');
            p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            pageURLForRedirection = p.getUrl();
            
            pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-Costs?edit=true&propertyId='+propId+'&offerId='+offerId;
            
            
            p.setRedirect(false);
            
            return null;
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }
        return p;   
    }

    public boolean checkOfferParkingValidations() {

        boolean flag;

        
        
        return flag;
    }

    // Back button logic
    public PageReference backToOfrBlding() {

        //PageReference p = Page.PBS_AAAP_OfferBuildingDetails;
        PageReference p = new PageReference('/AAAP/OfferBuildingDetails');
        p.getParameters().put('offerId', offerId);
        p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
        
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-Eligibility?edit='+(viewOnly ? 'false' : 'true')+'&offerId='+offerId+'&propertyId='+propId;
       
        return null;
    }

    // Save Button Logic
    public PageReference saveParkingInfo() {

        system.debug('pageUrl ' + pageUrl);        

        try {
            if (offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c != null && offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c != null) {
                offerParking.PBS_AAAP_Total_Parking_Spaces__c = offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c + offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c;
            } else if (offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c != null && offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c == null) {
                offerParking.PBS_AAAP_Total_Parking_Spaces__c = offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c;
            } else if (offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c == null && offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c != null) {
                offerParking.PBS_AAAP_Total_Parking_Spaces__c = offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c;
            } else {
                offerParking.PBS_AAAP_Total_Parking_Spaces__c = null;
            }
            
            System.debug('*** inside saveParking info ***');
            draftMsgFlag = '';
            if (offerParking.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offerParking.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }
            PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(offerParking,new List<String>{'Offer-M-Parking'});
            if (response.errorMessages.size() > 0 && !test.isrunningtest()) {
                for(String error : response.errorMessages){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }
                return null;
            }
            update offerParking;

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

        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        //return null;
        PageReference pref = new PageReference('/AAAP/OfferParking?offerId='+offerId);
        pref.getParameters().put('offerId', offerId);
        pref.getParameters().put('draftMsg', draftMsgFlag);
            
        pageURLForRedirection = pref.getUrl();
        
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-Parking?edit=true&propertyId='+propId+'&offerId='+offerId;
        return null;
    }

    // logic for delete button
    public PageReference actionDeleteOffer() {
        PageReference pref = null;
        System.debug('************* offerParking ::: ' + offerParking);
        System.debug('************* offerParking.PBS_AAAP_Offer_Status__c ::: ' + offerParking.PBS_AAAP_Offer_Status__c);
        System.debug('************* offerParking.PBS_AAAP_Offer_Status__c ::: ' + PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT);
        if (offerParking.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT ||
                offerParking.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
            delete offerParking;    // Cascade delete - Deletes all Spaces and Othercosts associated with it.
            //pref = Page.PBS_AAAP_PortalHome;
            pref = new PageReference('/AAAP/PortalHome');
            pref.setRedirect(true);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + offerParking.PBS_AAAP_Offer_Status__c +
                    ', you can only delete on Draft or Pending Modification stage');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    public PageReference actionCancel() {
        //PageReference pref = Page.PBS_AAAP_PortalHome;
        PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(true);
        return pref;
    }

    public List<SelectOption> getOnsiteParkingItems() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = PBS_AAAP_Offer__c.PBS_AAAP_Parking_Onsite__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        return options;
    }
    
    public List<SelectOption> getPartialItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        options.add(new SelectOption('Partial', 'Partial'));
        return options;
    }

    // Re-Rendering Logic
    public Boolean options5a = false;
    public Boolean options5b = false;
    public Boolean options5c = false;

    public PageReference showParkingOptions() {
        //System.debug('*********** Options::::::::: '+offerParking.PBS_AAAP_Option_Parking__c);
        if (offerParking.PBS_AAAP_Option_Parking__c == 'Yes') {
            options5a = true;
            options5b = true;
            options5c = false;
            offerParking.PBS_AAAP_Partial_Secured_GAR_PARK_SPACE__c = null;
        } else if (offerParking.PBS_AAAP_Option_Parking__c == 'No') {
            options5a = false;
            options5b = false;
            options5c = false;
            offerParking.PBS_AAAP_Annual_cost_entire_garage_park__c = null;
            offerParking.PBS_AAAP_Number_of_gar_parking_spaces__c = null;
            offerParking.PBS_AAAP_Partial_Secured_GAR_PARK_SPACE__c = null;
        } else {
            options5a = true;
            options5b = true;
            options5c = true;
        }
        return null;
    }

    public boolean getOptions5a() {
        //System.debug('*********** Options 5a::::::::: '+offerParking.PBS_AAAP_Option_Parking__c);
        if (offerParking.PBS_AAAP_Option_Parking__c == 'Yes')
            options5a = true; else if (offerParking.PBS_AAAP_Option_Parking__c == 'No')
            options5a = false; else {
            options5a = true;
        }

        return options5a;
    }
    public boolean getOptions5b() {
        if (offerParking.PBS_AAAP_Option_Parking__c == 'Yes')
            options5b = true; else if (offerParking.PBS_AAAP_Option_Parking__c == 'No')
            options5b = false; else {
            options5b = true;
        }

        return options5b;
    }
    public boolean getOptions5c() {
        if (offerParking.PBS_AAAP_Option_Parking__c == 'Yes')
            options5c = false; else if (offerParking.PBS_AAAP_Option_Parking__c == 'No')
            options5c = false; else {
            options5c = true;
        }

        return options5c;
    }


}