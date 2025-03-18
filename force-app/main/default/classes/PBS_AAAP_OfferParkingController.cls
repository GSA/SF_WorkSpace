public with sharing class PBS_AAAP_OfferParkingController {

    public String items { get; set; }

    public PBS_AAAP_Offer__c offerParking { get; set; }
    public ID offerID { get; set; }
    public boolean isValidUser { get; set; }
    public String pageUrl{get;set;} 
    public string pageURLForRedirection {get;set;}   
    //public boolean showerror { get; set; }
    //public boolean checkerror { get; set; }
    public String draftMsgFlag { get; set; }
    public PBS_AAAP_OfferParkingController() {
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            offerID = ApexPages.currentPage().getParameters().get('offerId');
            system.debug('***************offer Parking ID in Constructor:' + offerID);
            offerParking = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
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

        //system.debug('***************offer Parking ID :'+offerParking);
        PageReference p = null;
        boolean errorflag = checkOfferParkingValidations();        
        if (errorflag == true) {
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
            //p = Page.PBS_AAAP_OfferPropertyOwner;
            
            
            p = new PageReference('/AAAP/OfferPropertyOwner');
            p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferPropertyOwner', Label.LOP_Community_Base_URL+'AAAP-OfferPropertyOwner');
            
            
            
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

        if (offerParking.PBS_AAAP_Parking_Onsite__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '2. Onsite parking response is required.'));
            flag = true;
        }        

        if (offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c == null ||
                offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c == null ||
                offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c == null ||
                offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    'Number of parking spaces is a required field.'));
            flag = true;

        }

        if (offerParking.PBS_AAAP_Monthly_cost_res_gar_park__c == null ||
                offerParking.PBS_AAAP_Monthly_cost_nonres_gar_park__c == null ||
                offerParking.PBS_AAAP_Monthly_cost_res_sur_park__c == null ||
                offerParking.PBS_AAAP_Monthly_cost_nonres_sur_park__c == null) {
                    //JK changed from 3 to 4 below 7/2021
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    '4. Please enter rates for all types of parking. Please put $0.00 if you are either not charging for, or not offering, that type of parking space. You may not leave any fields blank.'));
            flag = true;

        }
        
        return flag;
    }

    // Back button logic
    public PageReference backToOfrBlding() {

        //PageReference p = Page.PBS_AAAP_OfferBuildingDetails;
        PageReference p = new PageReference('/AAAP/OfferBuildingDetails');
        p.getParameters().put('offerId', offerId);
        p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuildingDetails', Label.LOP_Community_Base_URL+'AAAP-OfferBuildingDetails');
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
            //JK removing the following logic because the field is being set directly by the user in question #3
            /*if (offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c != null && offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c != null) {
                offerParking.PBS_AAAP_Total_Park_Spaces_Offered__c = offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c + offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c;
            } else if (offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c != null && offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c == null) {
                offerParking.PBS_AAAP_Total_Park_Spaces_Offered__c = offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c;
            } else if (offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c == null && offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c != null) {
                offerParking.PBS_AAAP_Total_Park_Spaces_Offered__c = offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c;
            } else {
                offerParking.PBS_AAAP_Total_Park_Spaces_Offered__c = null;
            }*/
            System.debug('*** inside saveParking info ***');
            draftMsgFlag = '';
            if (offerParking.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offerParking.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
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
                
        //        p.getParameters().put('offerId', offerId);
        //        p.getParameters().put('draftMsg', draftMsgFlag);
        //        pageURLForRedirection = p.getUrl();
         //      p = new PageReference(pageUrl);
                 pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                 return null;        
                
               // return p;
            }

        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        //return null;
        PageReference pref = new PageReference('/AAAP/OfferParking?offerId='+offerId);
        pref.getParameters().put('offerId', offerId);
        pref.getParameters().put('draftMsg', draftMsgFlag);
            
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferParking', Label.LOP_Community_Base_URL+'AAAP-OfferParking');

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