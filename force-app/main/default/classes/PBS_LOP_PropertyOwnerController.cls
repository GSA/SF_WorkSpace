/**
 * Created by nkopparthi on 5/21/19.
 */

public with sharing class PBS_LOP_PropertyOwnerController {
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
    public PBS_AAAP_RLP__c rlp {get; set;}
    public Boolean isTerminated { get; set; }
    public String ownerFullName { get; set; }
    public Boolean sameOwner {get; set;}
    public String pageUrl {get; set;}
    public String pageURLForRedirection{get;set;}

    public PBS_LOP_PropertyOwnerController(){

        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode FROM User u WHERE u.Id = :UserInfo.getUserId()];
        action = ApexPages.currentPage().getParameters().get('action');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        isNew = ApexPages.currentPage().getParameters().get('isNew');
        isEditable = ApexPages.currentPage().getParameters().get('edit');
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');

        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in view mode. Any changes made will not be saved.';
        } else {
            viewOnly = false;
        }

        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            lopOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            sameOwner = lopOffer.PBS_RSAP_Property_Owner_Same_as_Offeror__c;
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
    }

    public void copyUserDetails() {
        System.debug('inside copy User Details !!!');
        if(sameOwner) {
            ownerFullName = userDetail.FirstName + ' ' + userDetail.LastName;
            
            lopOffer.PBS_AAAP_Owner_Name__c = userDetail.FirstName + ' ' + userDetail.LastName;
            lopOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = userDetail.LastName;
            lopOffer.PBS_AAAP_Signature_First_Name__c = userDetail.FirstName;
            lopOffer.PBS_AAAP_Owner_Address__c = userDetail.Street;
            lopOffer.PBS_AAAP_Owner_City__c = userDetail.City;
            lopOffer.PBS_AAAP_Owner_State__c = userDetail.State;
            lopOffer.PBS_AAAP_Owner_Zip__c = userDetail.postalCode;
            lopOffer.PBS_RSAP_Property_Owner_Same_as_Offeror__c = TRUE;
            update lopOffer;
        } else {
            lopOffer.PBS_RSAP_Property_Owner_Same_as_Offeror__c = FALSE;
            update lopOffer;
        }
    }

    public Boolean otherRelationShip = false;
    public PageReference showOfferorRelationShipOther() {
        System.debug('Offeror Relation to property owner ::::::: ' + lopOffer.PBS_AAAP_OFFEROR_INTEREST__c);
        if (lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other')
            otherRelationShip = true;
        else {
            otherRelationShip = false;
            lopOffer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = '';
        }

        return null;
    }

    public boolean getOtherRelationShip() {
        if (lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other') {
            otherRelationShip = true;
        }
        return otherRelationShip;
    }

    public PageReference backToOfrParking() {

        PageReference p = new PageReference('/RSAP/Rates');
        p.getParameters().put('offerId', lopOffer.Id);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
       
        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Rates', Label.LOP_Community_Base_URL+'RSAP-Rates');
        return null;
    }

    public void actionSavePropertyOwner() {
        try {

            
            draftMsgFlag = '';
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            lopOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = userDetail.LastName;
            lopOffer.PBS_AAAP_Signature_First_Name__c = userDetail.FirstName;
            
            update lopOffer;
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }

    }

    public pageReference actionSavePropertyOwner2() {
        try {

            
            PageReference p = null;
            p = new PageReference('/RSAP/PropertyOwner');
            draftMsgFlag = '';
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            lopOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = userDetail.LastName;
            lopOffer.PBS_AAAP_Signature_First_Name__c = userDetail.FirstName;
            
            update lopOffer;
            p.getParameters().put('offerId', lopOffer.Id);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            if (isEditable == 'true') {
                p.getParameters().put('edit', 'true');
            } else {
                isEditable = 'false';
            }
            
            p.setRedirect(false);
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/RSAP/PropertyOwner', Label.LOP_Community_Base_URL+'RSAP-PropertyOwner');
 
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }
        return null;
    }

    public PageReference actionSavePropertyOwnerAndContinue() {
        PageReference p = null;
        boolean errorflag = FALSE;
        lopOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = userDetail.LastName;
        lopOffer.PBS_AAAP_Signature_First_Name__c = userDetail.FirstName;
        if(lopOffer.PBS_AAAP_Owner_Name__c == NULL || lopOffer.PBS_AAAP_Owner_Name__c == ''){
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '1. Property Owner Name is required'));
        }
        if(lopOffer.PBS_AAAP_Owner_Address__c == NULL || lopOffer.PBS_AAAP_Owner_Address__c == ''){
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '2. Property Owner Address is required'));
        }
        if(lopOffer.PBS_AAAP_Owner_City__c == NULL || lopOffer.PBS_AAAP_Owner_City__c == ''){
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '3. Property Owner City is required'));
        }
        if(lopOffer.PBS_AAAP_Owner_State__c == NULL || lopOffer.PBS_AAAP_Owner_State__c == ''){
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '4. Property Owner State is required.'));
        }
        if(lopOffer.PBS_AAAP_Owner_Zip__c == NULL || lopOffer.PBS_AAAP_Owner_Zip__c == ''){
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '5. Property Owner Zip is required.'));
        }
        if(lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == NULL || lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == ''){
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '6. Property Owner Relationship is required'));
        }

        if(lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other' && (lopOffer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c == NULL|| lopOffer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c == '')){
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '6a. Property Owner Relationship is required'));
        }
        if(lopOffer.PBS_AAAP_DUNS_Number__c == NULL || lopOffer.PBS_AAAP_DUNS_Number__c == ''){
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '7. What is the property owner’s Unique Entity Identifier (UEI)?'));
        }


        if (errorflag == true) {
            return null;
        }
        try {

            actionSavePropertyOwner();
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

        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }
          if(pageURL == NULL || pageURL == ''){
                pageURLForRedirection = p.getUrl();
                pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Attachments', Label.LOP_Community_Base_URL+'Offer-S-Attachments');
                p.setRedirect(false);
            } else {
                 p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                p.setRedirect(false);
              }  
      
        return null;
    }


    public PageReference actionCancel() {
        PageReference pref = new PageReference('/RSAP/PortalHome');
        
        pref.setRedirect(true);
        return pref;
    } 


}