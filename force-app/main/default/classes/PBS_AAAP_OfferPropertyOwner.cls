public with sharing class PBS_AAAP_OfferPropertyOwner {

    public PBS_AAAP_Offer__c offerPropOwner { get; set; }
    public ID offerId { get; set; }

    public Boolean propOwnerPage1 { get; set; }
    public Boolean propOwnerPage2 { get; set; }
    public boolean isValidUser { get; set; }
    public String draftMsgFlag { get; set; }
    public String pageUrl{get;set;}
    public String pageURLForRedirection{get;set;}    // j.rogers 12/21/2022  SFWS-2100
    public Boolean sameOwner {get; set;}
    public String ownerFullName { get; set; }
    public User userDetail { get; set; }

    public PBS_AAAP_OfferPropertyOwner() {
        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode, u.Country FROM User u WHERE u.Id = :UserInfo.getUserId()];
        propOwnerPage1 = true;
        propOwnerPage2 = false;
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');

        if (ApexPages.currentPage().getParameters().get('offerId') != null) {

            offerId = ApexPages.currentPage().getParameters().get('offerId');
            // system.debug('***************offer Parking ID in Constructor:'+offerId);
            offerPropOwner = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            //added by syam for offerId validation
            if (offerPropOwner.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
        }
        sameOwner = offerPropOwner.PBS_RSAP_Property_Owner_Same_as_Offeror__c;
    }

    public void copyUserDetails() {
        System.debug('inside copy User Details !!!');
        if(sameOwner) {
            ownerFullName = userDetail.FirstName + ' ' + userDetail.LastName;
            //lopOffer.PBS_AAAP_Owner_Name__c = userDetail.CompanyName;
            offerPropOwner.PBS_AAAP_Owner_Name__c = userDetail.FirstName + ' ' + userDetail.LastName;
            offerPropOwner.PBS_AAAP_SIGNATURE_LAST_NAME__c = userDetail.LastName;
            offerPropOwner.PBS_AAAP_Signature_First_Name__c = userDetail.FirstName;
            offerPropOwner.PBS_AAAP_Owner_Address__c = userDetail.Street;
            offerPropOwner.PBS_AAAP_Owner_City__c = userDetail.City;
            offerPropOwner.PBS_AAAP_Owner_State__c = userDetail.State;
            offerPropOwner.PBS_AAAP_Owner_Zip__c = userDetail.postalCode;
            offerPropOwner.PBS_AAAP_Owner_Country__c = userDetail.Country;
            offerPropOwner.PBS_RSAP_Property_Owner_Same_as_Offeror__c = TRUE;
            offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c = 'Owner';
            update offerPropOwner;
        } else {
            offerPropOwner.PBS_RSAP_Property_Owner_Same_as_Offeror__c = FALSE;
            update offerPropOwner;
        }
    }

    public List<SelectOption> getTINNotRequiredReasonItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Property Owner is a nonresident alien, foreign corporation, or foreign partnership that does not have income', 'Property owner is a nonresident alien, foreign corporation, or foreign partnership that does not have income effectively connected with the conduct of a trade or business in the United States and does not have an office or place of business or a fiscal paying agent in the United States'));
        options.add(new SelectOption('Property owner is an agency or instrumentality of a foreign government', 'Property owner is an agency or instrumentality of a foreign government'));
        options.add(new SelectOption('Property Owner is an agency or instrumentality of the federal government', 'Property Owner is an agency or instrumentality of the federal government'));
        options.add(new SelectOption('Property is owned or controlled by a common parent', 'Property is owned or controlled by a common parent'));
        return options;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }

    public PageReference backToOfrParking() {

  /***** j.rogers  12/22/2022  SFWS-2100  
        //PageReference p = Page.PBS_AAAP_OfferParking;
        PageReference p = new PageReference('/AAAP/OfferParking');
        p.getParameters().put('offerId', offerPropOwner.Id);
        p.setRedirect(true);
        return p;
  *****************************/      
  
        PageReference p = new PageReference('/AAAP/OfferParking');
        p.getParameters().put('offerId', offerId);
        p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferParking', Label.LOP_Community_Base_URL+'AAAP-OfferParking');
        return null;
    }

    public Boolean parentName;
    public PageReference showPropertyOwnerCommonParentSection() {
        if (offerPropOwner.PBS_AAAP_CONTROLLED_BY_PARENT__c == 'Yes') {
            parentName = true;
            //parentTIN = true;
        } else {
            parentName = false;
            //parentTIN = false;
            offerPropOwner.PBS_AAAP_PARENT_NAME__c = '';
        }
        return null;
    }

    public boolean getParentName() {
        if (offerPropOwner.PBS_AAAP_CONTROLLED_BY_PARENT__c == 'Yes') {
            parentName = true;
        }
        return parentName;
    }


    /*public void backToOfrPropOwnerPage1(){
        propOwnerPage1 = true;
        propOwnerPage2 = false;       
    }*/

    public PageReference actionSavePropertyOwnerAndContinue() {   
        
        PageReference p = null;
        //boolean errorflag = checkOfferPropOwnerValidations();
        boolean flag;
        if (offerPropOwner.PBS_AAAP_Owner_Name__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '1. Property owner name field is required'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Address__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '2. Property owner address field is required'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Country__c == null || offerPropOwner.PBS_AAAP_Owner_Country__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '3. Property Owner Country is required'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_City__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '4. Property Owner City is required'));
            flag = true;
        }
        if ((offerPropOwner.PBS_AAAP_Owner_Country__c == 'United States' || offerPropOwner.PBS_AAAP_Owner_Country__c == '') && (offerPropOwner.PBS_AAAP_Owner_State__c == null || offerPropOwner.PBS_AAAP_Owner_State__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '5. Property Owner State is required'));
            flag = true;
        }
       /* SGanti reworded error message on 7/14/2021 */

        if ((offerPropOwner.PBS_AAAP_Owner_Country__c == 'United States' || offerPropOwner.PBS_AAAP_Owner_Country__c == '') && (offerPropOwner.PBS_AAAP_Owner_Zip__c == null || offerPropOwner.PBS_AAAP_Owner_Zip__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '6. Property Owner 9-Digit Zip Code is required'));
            flag = true;
        }
        /*SGanti commented out on 7/14/2021 
        if (offerPropOwner.PBS_AAAP_Owner_Main_Phone__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '7. Property owner main phone number field is required'));
            flag = true;
        } */ 
        /* SGanti renumbered error message on 7/14/2021 */
        if (offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '7. Property owner relationship to Offeror field is required'));
            flag = true;
        }
      /* SGanti reworded error message on 7/14/2021 */

        if(offerPropOwner.PBS_AAAP_DUNS_Number__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '8. Property owner Unique Entity Identifier (UEI) field is required'));
            flag = true;
            //return null;
        }
        if (flag == true) {
            return null;
        }
        try {
            draftMsgFlag = '';
            if (offerPropOwner.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offerPropOwner.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }
            
            if(sameOwner) {
                ownerFullName = userDetail.FirstName + ' ' + userDetail.LastName;
                //lopOffer.PBS_AAAP_Owner_Name__c = userDetail.CompaPBS_AAAP_OfferBuildingDetailsnyName;
                offerPropOwner.PBS_AAAP_Owner_Name__c = userDetail.FirstName + ' ' + userDetail.LastName;
                offerPropOwner.PBS_AAAP_SIGNATURE_LAST_NAME__c = userDetail.LastName;
                offerPropOwner.PBS_AAAP_Signature_First_Name__c = userDetail.FirstName;
                offerPropOwner.PBS_AAAP_Owner_Address__c = userDetail.Street;
                offerPropOwner.PBS_AAAP_Owner_City__c = userDetail.City;
                offerPropOwner.PBS_AAAP_Owner_State__c = userDetail.State;
                offerPropOwner.PBS_AAAP_Owner_Zip__c = userDetail.postalCode;
                offerPropOwner.PBS_AAAP_Owner_Country__c = userDetail.Country;
                offerPropOwner.PBS_RSAP_Property_Owner_Same_as_Offeror__c = TRUE;
                offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c = 'Owner';
                //update offerPropOwner;
            } else {
                offerPropOwner.PBS_RSAP_Property_Owner_Same_as_Offeror__c = FALSE;
                //update offerPropOwner;
            }
            
            update offerPropOwner;
            //p = Page.PBS_AAAP_OperatingCosts;
            p = new PageReference('/AAAP/OperatingCosts');
            p.getParameters().put('offerId', offerPropOwner.Id);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }

            // j.rogers 12/22/2022 SFWS-2100
             //p.setRedirect(true);
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OperatingCosts', Label.LOP_Community_Base_URL+'AAAP-OperatingCosts');
            p.setRedirect(false);
            return null;
            // end SFWS-2011

        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }

        return p;
    }

    /**
    public boolean checkOfferPropOwnerValidations() {

        boolean flag;
        if (offerPropOwner.PBS_AAAP_Owner_Name__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_NAME_REQUIRED));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Address__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_ADDRESS));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Country__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_COUNTRY));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_City__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_CITY));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Country__c == 'United States' && offerPropOwner.PBS_AAAP_Owner_State__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_STATE));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Country__c == 'United States' && offerPropOwner.PBS_AAAP_Owner_Zip__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_ZIP));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Main_Phone__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_PHONE));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_TYPE));
            flag = true;
        }

        if (offerPropOwner.PBS_AAAP_CONTROLLED_BY_PARENT__c == 'Yes' && offerPropOwner.PBS_AAAP_Common_Parent_TIN__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_PARENT_TIN));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_CONTROLLED_BY_PARENT__c == 'Yes' && offerPropOwner.PBS_AAAP_PARENT_NAME__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_COMMON_PARENT));
            flag = true;
        }


        if (offerPropOwner.PBS_AAAP_Owner_TIN_Status__c == PBS_AAAP_GlobalConstants.TIN_KNOWN && offerPropOwner.PBS_AAAP_Owner_TIN_Assigned__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_TIN_NUM));
            flag = true;
        }
        if(offerPropOwner.PBS_AAAP_DUNS_Number__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '9. Property owner DUNS number field is required');
            Apexpages.addMessage(myMsg);
            flag = true;
            //return null;
        }
        return flag;
    }
    **/


    public PageReference actionSavePropertyOwner() {
        /**
        if(offerPropOwner.PBS_AAAP_DUNS_Number__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '9. Property owner DUNS number field is required');
            Apexpages.addMessage(myMsg);
        }
        **/
        try {
            draftMsgFlag = '';
            if (offerPropOwner.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offerPropOwner.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                draftMsgFlag = 'true';
            }
            
            if(sameOwner) {
                ownerFullName = userDetail.FirstName + ' ' + userDetail.LastName;
                //lopOffer.PBS_AAAP_Owner_Name__c = userDetail.CompanyName;
                offerPropOwner.PBS_AAAP_Owner_Name__c = userDetail.FirstName + ' ' + userDetail.LastName;
                offerPropOwner.PBS_AAAP_SIGNATURE_LAST_NAME__c = userDetail.LastName;
                offerPropOwner.PBS_AAAP_Signature_First_Name__c = userDetail.FirstName;
                offerPropOwner.PBS_AAAP_Owner_Address__c = userDetail.Street;
                offerPropOwner.PBS_AAAP_Owner_City__c = userDetail.City;
                offerPropOwner.PBS_AAAP_Owner_State__c = userDetail.State;
                offerPropOwner.PBS_AAAP_Owner_Zip__c = userDetail.postalCode;
                offerPropOwner.PBS_AAAP_Owner_Country__c = userDetail.Country;
                offerPropOwner.PBS_RSAP_Property_Owner_Same_as_Offeror__c = TRUE;
                offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c = 'Owner';
                //update offerPropOwner;
            } else {
                offerPropOwner.PBS_RSAP_Property_Owner_Same_as_Offeror__c = FALSE;
                //update offerPropOwner;
            }
            
            update offerPropOwner;

            if( !(( pageUrl == null ) || ( pageUrl == '' )) )   
            {
                Integer len = pageUrl.length();
                if( pageUrl.mid(len-1, 1) == '=' )
                {
                    pageUrl = pageUrl + offerId;   
                }                
                PageReference p = new PageReference(pageUrl); 
                // j.rogers 12/21/2022 SFWS-2100     
                // return p;
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                return null;  
                // end SFWS-2100
            }

        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        //return null;

        // J.Rogers 12/22/2022  SFWS-2100
        //PageReference pref = new PageReference('/AAAP/OfferPropertyOwner?offerId='+offerId);
        //return pref;
        PageReference pref = new PageReference('/AAAP/OfferPropertyOwner?offerId='+offerId);
        pref.getParameters().put('offerId', offerId);
        pref.getParameters().put('draftMsg', draftMsgFlag);
            
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferPropertyOwner', Label.LOP_Community_Base_URL+'AAAP-OfferPropertyOwner');

        return null;
        // SfWS-2100 end
    }

    public PageReference actionDeleteOffer() {
        PageReference pref = null;

        if (offerPropOwner.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || offerPropOwner.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
            delete offerPropOwner;    // Cascade delete - Deletes all Spaces and Othercosts associated with it.
            //pref = Page.PBS_AAAP_PortalHome;
            pref = new PageReference('/AAAP/PortalHome');
            pref.setRedirect(true);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + offerPropOwner.PBS_AAAP_Offer_Status__c +
                    ', you can only delete on Draft or Pending Modification stage');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    // rerender logic
    public Boolean otherRelationShip = false;
    public PageReference showOfferorRelationShipOther() {
        System.debug('Offeror Relation to property owner ::::::: ' + offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c);
        if (offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c == 'Other')
            otherRelationShip = true; else {
            otherRelationShip = false;
        }

        return null;
    }
    public boolean getOtherRelationShip() {
        if (offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c == 'Other') {
            otherRelationShip = true;
        }
        return otherRelationShip;
    }

    public Boolean recordOwnershipOther = false;
    public PageReference showRecordOwnershipOther() {
        System.debug('Offeror Relation to property owner ::::::: ' + offerPropOwner.PBS_AAAP_TYPE_OF_ORG__c);
        if (offerPropOwner.PBS_AAAP_TYPE_OF_ORG__c == 'Other')
            recordOwnershipOther = true; else {
            recordOwnershipOther = false;
        }

        return null;
    }
    public boolean getRecordOwnershipOther() {
        if (offerPropOwner.PBS_AAAP_TYPE_OF_ORG__c == 'Other') {
            recordOwnershipOther = true;
        }
        return recordOwnershipOther;
    }

    public Boolean tinStatusNotRequired = false;
    public Boolean tinStatusKnown = false;

    public PageReference showTINStatus() {
        System.debug('TIN Status ::::::: ' + offerPropOwner.PBS_AAAP_Owner_TIN_Status__c);
        if (offerPropOwner.PBS_AAAP_Owner_TIN_Status__c == 'KNOWN') {
            tinStatusKnown = true;
            tinStatusNotRequired = false;
        } else if (offerPropOwner.PBS_AAAP_Owner_TIN_Status__c == 'Not required') {
            tinStatusKnown = false;
            tinStatusNotRequired = true;
        } else {
            tinStatusKnown = false;
            tinStatusNotRequired = false;
        }
        return null;
    }
    public boolean getTinStatusKnown() {
        if (offerPropOwner.PBS_AAAP_Owner_TIN_Status__c == 'KNOWN') {
            tinStatusKnown = true;
        }
        return tinStatusKnown;
    }
    public boolean getTinStatusNotRequired() {
        if (offerPropOwner.PBS_AAAP_Owner_TIN_Status__c == 'Not required') {
            tinStatusNotRequired = true;
        }
        return tinStatusNotRequired;
    }

    public PageReference actionCancel() {
        //PageReference pref = Page.PBS_AAAP_PortalHome;
        PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(true);
        return pref;
    }

}