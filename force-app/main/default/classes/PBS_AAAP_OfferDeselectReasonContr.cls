public with sharing class PBS_AAAP_OfferDeselectReasonContr {

    public PBS_AAAP_Offer_Deselect_Reject_Reasons__c offerDeselect { get; set; }
    public string agencyRequirementId { get; set; }
    public string selectedOfferId { get; set; }
    public string selectedSpaceId { get; set; }
    public PBS_AAAP_Offer__c offerspace { get; set; }
    public PBS_AAAP_Agency_Requirement__c agency { get; set; }

    public PBS_AAAP_OfferDeselectReasonContr() {
        offerDeselect = new PBS_AAAP_Offer_Deselect_Reject_Reasons__c();
        agencyRequirementId = ApexPages.currentPage().getParameters().get('agencyRequirementId');
        selectedOfferId = ApexPages.currentPage().getParameters().get('selectedOfferId');
        selectedSpaceId = ApexPages.currentPage().getParameters().get('selectedSpaceId');

        offerspace = [SELECT Id, Name, PBS_AAAP_Building_Name__c FROM PBS_AAAP_Offer__c WHERE id = :selectedOfferId];
        agency = [SELECT Id, PBS_AAAP_REQ_STATUS__c, Name FROM PBS_AAAP_Agency_Requirement__c WHERE id = :agencyRequirementId];
    }

    public PageReference actionSaveDeselectReason() {
        Savepoint sp0 = Database.setSavepoint();
        PageReference pref = null;
        PBS_AAAP_Space__c space;
        PBS_AAAP_Offer__c offer;
        PBS_AAAP_Agency_Requirement__c agencyRequirement;
        PBS_AAAP_Offer_Select_Award_Info__c osai = null;

        boolean errorflag = checkValidations();
        if (errorflag == true) {
            return null;
        }
        //added by syam 03/14 to check if there any already existing submitted offers, if so just return the screen back to agency
        /* boolean alreadySubmitedOffer = checkSubmittedOffer();
         system.debug('already submitted offer flag is '+alreadySubmitedOffer);
         if(alreadySubmitedOffer == true)
         {
          Pref = Page.PBS_AAAP_AgencyRequirement;
         pref.getParameters().put('id',agencyRequirementId);
         pref.setRedirect(true);
         }
         else {
         */
        try {
            // TODO Logic

            offerDeselect.PBS_AAAP_Agency_Requirement__c = agencyRequirementId;
            offerDeselect.PBS_AAAP_Offer_Number__c = selectedOfferId;
            insert offerDeselect;

            osai = [
                    SELECT id, PBS_AAAP_isSelected__c, PBS_AAAP_SELECTED_USF__c
                    FROM PBS_AAAP_Offer_Select_Award_Info__c
                    WHERE PBS_AAAP_AGENCY_REQUIREMENT_ID__c = :agencyRequirementId
                    AND PBS_AAAP_isSelected__c = TRUE
                    LIMIT 1
            ];
            if (osai.Id != null) {
                //for(PBS_AAAP_Offer_Select_Award_Info__c s:osai){
                if (osai.PBS_AAAP_isSelected__c == true) {
                    osai.PBS_AAAP_isSelected__c = false;
                }
                //}
                update osai;
            }

            space = [
                    SELECT id, name, PBS_AAAP_Total_Actual_Space_Available__c, PBS_AAAP_SF_Offered__c, PBS_AAAP_OFFER_NUMBER__c, PBS_AAAP_Total_ABOA_Selected__c
                    FROM PBS_AAAP_Space__c
                    WHERE id = :selectedSpaceId
            ];
            System.debug('*******Space Record:::: ' + selectedSpaceId);
            system.debug('=========> space.PBS_AAAP_Total_ABOA_Selected__c  : ' + space.PBS_AAAP_Total_ABOA_Selected__c);
            if (space.id != null && space.PBS_AAAP_Total_ABOA_Selected__c > 0) {
                space.PBS_AAAP_Total_ABOA_Selected__c = space.PBS_AAAP_Total_ABOA_Selected__c - osai.PBS_AAAP_SELECTED_USF__c;
                // Changes made by sguni on 10/29/2012, to not fire the trigger while AAAP manger is performing the Identity winner
                PBS_AAAP_OfferHelper.triggerupdate(true);
                update space;
                PBS_AAAP_OfferHelper.triggerupdate(false);
                // change ends
            }
/*            offer = [Select id, PBS_AAAP_Offer_Status__c 
                        from PBS_AAAP_Offer__c 
                        where id=:selectedOfferId]; */ //old code Vaishali 10062015 added lines 67 through 81 and added criteria && (offeralreadyexists.size() == 0) thereafter 
            offer = [
                    SELECT id, PBS_AAAP_Offer_Status__c,PBS_AAAP_RLP_Number__c,PBS_AAAP_Owner_Name__c,PBS_AAAP_X_CO_ORD__c,PBS_AAAP_Y_CO_ORD__c,CreatedById
                    FROM PBS_AAAP_Offer__c
                    WHERE id = :selectedOfferId
            ];
            String[] offerstatuscriteria = new String[]{
                    PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED, PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED
            };
            PBS_AAAP_Offer__c[] offeralreadyexists = null;
            offeralreadyexists = [
                    SELECT id, PBS_AAAP_Offer_Status__c, PBS_AAAP_RLP_Number__c
                    FROM PBS_AAAP_Offer__c
                    WHERE PBS_AAAP_Offer_Status__c IN :offerstatuscriteria
                    AND PBS_AAAP_RLP_Number__c = :offer.PBS_AAAP_RLP_Number__c
                    AND PBS_AAAP_Owner_Name__c = :offer.PBS_AAAP_Owner_Name__c
                    AND PBS_AAAP_X_CO_ORD__c = :offer.PBS_AAAP_X_CO_ORD__c
                    AND PBS_AAAP_Y_CO_ORD__c = :offer.PBS_AAAP_Y_CO_ORD__c
                    AND PBS_AAAP_Is_Offer_Valid__c = TRUE
                    AND Ownerid = :offer.CreatedById
                    AND Master_Offer__c = NULL
                    LIMIT 1
            ];
            System.debug('offeralreadyexists.size() is' + offeralreadyexists.size() + ' offer id is' + offer.Id + ' ownerId is ' + offer.CreatedById + ' owner name is' + offer.PBS_AAAP_Owner_Name__c + ' rlp number' + offer.PBS_AAAP_RLP_Number__c + ' x coord' + offer.PBS_AAAP_X_CO_ORD__c + ' Y coord' + offer.PBS_AAAP_Y_CO_ORD__c);
            if (offer.Id != null && (offeralreadyexists.size() == 0)) {
                if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED) {
                    System.debug('before updating status to submitted ');
                    offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
                    PBS_AAAP_OfferHelper.triggerupdate(true);  // Vaishali added next 3 lines 06/01/2015
                    update offer;
                    PBS_AAAP_OfferHelper.triggerupdate(false);
                    System.debug('after updating status to submitted ');

                }
                if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED) {
                    offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
                    PBS_AAAP_OfferHelper.triggerupdate(true);  // Vaishali added next 3 lines 06/01/2015
                    update offer;
                    PBS_AAAP_OfferHelper.triggerupdate(false);
                }
                /*if(offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED ||
                    offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED){
                    // Changes made by sguni on 10/29/2012, to not fire the trigger while AAAP manger is performing the Identity winner
                    PBS_AAAP_OfferHelper.triggerupdate(true);
                    update offer;
                    PBS_AAAP_OfferHelper.triggerupdate(false); 
                    // change ends. 
                }*/ //Vaishali  commented out above block 06/01/2015
            }

            agencyRequirement = [SELECT Id, PBS_AAAP_REQ_STATUS__c FROM PBS_AAAP_Agency_Requirement__c WHERE id = :agencyRequirementId];
            if (agencyRequirement.Id != null) {
                agencyRequirement.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING;
                update agencyRequirement;
            }


            // TODO logic for creating a case


            // TODO Redirect to Agency Requirement Page -- Done
            Pref = Page.PBS_AAAP_AgencyRequirement;
            pref.getParameters().put('id', agencyRequirement.Id);
            pref.setRedirect(true);

        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            Database.rollback(sp0);
        }
        //  }
        return pref;
    }

    public boolean checkValidations() {

        boolean flag;
        if (offerDeselect.PBS_AAAP_Action_Reason__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.DESELECT_REASON_REQUIRED));
            flag = true;
        }
        if (offerDeselect.PBS_AAAP_Action_Reason__c != null) {

            if (offerDeselect.PBS_AAAP_Action_Comments__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.DESELECT_COMMENTS_REQUIRED));
                flag = true;
            }
        }


        return flag;
    }

    public PageReference actionCancelDeselect() {

        PageReference Pref = Page.PBS_AAAP_AgencyRequirement;
        pref.getParameters().put('id', agencyRequirementId);
        pref.setRedirect(true);

        return pref;
    }

    //added by syam to check the validation to see if any other offer already submitted for same address by same user and rlp.
    public boolean checkSubmittedOffer() {
        boolean flag;
        PBS_AAAP_Offer__c offer = [
                SELECT id, PBS_AAAP_Offer_Status__c,PBS_AAAP_RLP_Number__c,PBS_AAAP_Owner_Name__c,PBS_AAAP_X_CO_ORD__c,PBS_AAAP_Y_CO_ORD__c,CreatedById
                FROM PBS_AAAP_Offer__c
                WHERE id = :selectedOfferId
        ];
        String[] offerstatuscriteria = new String[]{
                PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED, PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED
        };
        PBS_AAAP_Offer__c[] offeralreadyexists = null;
        offeralreadyexists = [
                SELECT id, PBS_AAAP_Offer_Status__c, PBS_AAAP_RLP_Number__c
                FROM PBS_AAAP_Offer__c
                WHERE PBS_AAAP_Offer_Status__c IN :offerstatuscriteria
                AND PBS_AAAP_RLP_Number__c = :offer.PBS_AAAP_RLP_Number__c
                AND PBS_AAAP_Owner_Name__c = :offer.PBS_AAAP_Owner_Name__c
                AND PBS_AAAP_X_CO_ORD__c = :offer.PBS_AAAP_X_CO_ORD__c
                AND PBS_AAAP_Y_CO_ORD__c = :offer.PBS_AAAP_Y_CO_ORD__c
                AND PBS_AAAP_Is_Offer_Valid__c = TRUE
                AND Ownerid = :offer.CreatedById
                LIMIT 1
        ];
        System.debug('offeralreadyexists.size() is' + offeralreadyexists.size() + ' offer id is' + offer.Id + ' ownerId is ' + offer.CreatedById + ' owner name is' + offer.PBS_AAAP_Owner_Name__c + ' rlp number' + offer.PBS_AAAP_RLP_Number__c + ' x coord' + offer.PBS_AAAP_X_CO_ORD__c + ' Y coord' + offer.PBS_AAAP_Y_CO_ORD__c);
        if (offer.Id != null && (offeralreadyexists.size() > 0)) {
            if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED) {
                System.debug('there is already offer in the submitted status we cant set this to Submitted');
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'AAAP user already has an existing offer in the system in Submitted status. In order to submit the current offer the user should either modify the current offer or withdraw the originally submitted offer from the system.'));
                flag = true;
            }
        }
        return flag;
    }

}