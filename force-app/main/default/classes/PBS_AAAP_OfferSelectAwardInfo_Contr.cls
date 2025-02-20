public with sharing class PBS_AAAP_OfferSelectAwardInfo_Contr {

    public String targetObjId { public get; public set; }

    public string selectedSpaceId { get; set; }
    public string selectedOfferId { get; set; }
    public string agencyRequirementId { get; set; }
    public boolean showDeSelectButton { get; set; }

    public string offerSelectAwardID { get; set; }

    public PBS_AAAP_OfferSelectAwardInfo_Contr() {
    }

    public List<PBS_AAAP_Offer_Select_Award_Info__c> aphList {
        public get {
            List<PBS_AAAP_Offer_Select_Award_Info__c> aphList = new List<PBS_AAAP_Offer_Select_Award_Info__c>();
            if (targetObjId != null) {
                //String idForLike = targetObjId + '%';
                List<PBS_AAAP_Offer_Select_Award_Info__c> tmp = [
                        SELECT a.Id, a.Name, a.PBS_AAAP_AGENCY_REQUIREMENT_ID__c, a.PBS_AAAP_isSelected__c,
                                a.PBS_AAAP_Space_ID__c, a.PBS_AAAP_Offer_ID__c, PBS_AAAP_isAwarded__c, a.CreatedDate, a.PBS_AAAP_SELECTED_USF__c
                        FROM PBS_AAAP_Offer_Select_Award_Info__c a
                        WHERE a.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = :targetObjId
                        AND (a.PBS_AAAP_isSelected__c = TRUE OR a.PBS_AAAP_isAwarded__c = TRUE)
                        ORDER BY a.CreatedDate DESC
                ];
                if (tmp != null) {
                    showDeSelectButton = true;
                    return tmp;
                }
            }
            return aphList;
        }
        private set;
    }

    public PageReference actionDeSelectOfferSpace() {
        //Savepoint sp0 = Database.setSavepoint();
        PageReference pref = null;

        try {
            if (selectedSpaceId != null && selectedOfferId != null && agencyRequirementId != null) {

                pref = Page.PBS_AAAP_OfferDeselectReason;
                pref.getParameters().put('agencyRequirementId', agencyRequirementId);
                pref.getParameters().put('selectedOfferId', selectedOfferId);
                pref.getParameters().put('selectedSpaceId', selectedSpaceId);
                pref.setRedirect(true);


            }
            /*Pref = Page.PBS_AAAP_AgencyRequirement;
            Pref.getParameters().put('id', agencyRequirementId);
            Pref.setRedirect(true);*/
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            // Database.rollback(sp0);
        }
        return pref;
    }

    public PageReference actionShowOfferSelectAwardInfo() {
        PageReference pref = null;

        pref = Page.PBS_AAAP_AwardSelectedOfferInfo;
        pref.getParameters().put('id', offerSelectAwardID);
        pref.setRedirect(true);
        System.debug('*************** PageReference show ofeer id::: ' + offerSelectAwardID);

        return pref;
    }

    public PageReference actionAwardOfferSpace() {
        PageReference pref = null;

        pref = Page.PBS_AAAP_AwardSelectedOfferInfoEdit;
        pref.getParameters().put('id', offerSelectAwardID);
        pref.setRedirect(true);
        System.debug('*************** PageReference show ofeer id::: ' + offerSelectAwardID);

        return pref;
    }

    public PageReference prepareDocument() {
        PageReference pref = null;
        List<PBS_AAAP_Offer_Select_Award_Info__c> updList = new List<PBS_AAAP_Offer_Select_Award_Info__c>();
        List<PBS_AAAP_Offer_Select_Award_Info__c> targetRec = [SELECT Id,
                                                                      PBS_AAAP_Offer_ID__c,
                                                                      PBS_AAAP_AGENCY_REQUIREMENT_ID__c,
                                                                      PBS_AAAP_IsAwarded__c,
                                                                      PBS_AAAP_isSelected__c,
                                                                      PBS_AAAP_AWARDED_USF__c,
                                                                      PBS_AAAP_Total_Contract_Amount__c,
                                                                      PBS_AAAP_AWARDED_USF_Temp__c,
                                                                      PBS_AAAP_Total_Contract_Amount_Temp__c
                                                                      FROM PBS_AAAP_Offer_Select_Award_Info__c
                                                                      WHERE Id =: offerSelectAwardID];
        for(PBS_AAAP_Offer_Select_Award_Info__c rec : targetRec){
            rec.PBS_AAAP_IsAwarded__c = TRUE;
            rec.PBS_AAAP_isSelected__c = FALSE;
            rec.PBS_AAAP_AWARDED_USF__c = rec.PBS_AAAP_AWARDED_USF_Temp__c;
            rec.PBS_AAAP_Total_Contract_Amount__c = rec.PBS_AAAP_Total_Contract_Amount_Temp__c;
            updList.add(rec);
        }
        if(!updList.isEmpty()){
            update updList;
        }

        List<PBS_AAAP_Offer__c> updOffer = new List<PBS_AAAP_Offer__c>();
        List<PBS_AAAP_Offer__c> offer = new List<PBS_AAAP_Offer__c>();
        offer = [
                SELECT Id, Name, PBS_AAAP_Building_Name__c, PBS_AAAP_Street_Address__c, PBS_AAAP_City__c, PBS_AAAP_State__c, PBS_AAAP_ZipCode__c,
                        PBS_AAAP_Total_SF_Offered__c, PBS_AAAP_Total_Space_Selected__c, PBS_AAAP_Total_Withdraw_Space_Available__c, PBS_AAAP_Offer_Status__c,
                        PBS_AAAP_Monthly_cost_nonres_gar_park__c, PBS_AAAP_Monthly_cost_nonres_sur_park__c,
                        PBS_AAAP_Monthly_cost_res_gar_park__c, PBS_AAAP_Monthly_cost_res_sur_park__c,
                        PBS_AAAP_Owner_Address__c,PBS_AAAP_Owner_State__c,PBS_AAAP_Owner_City__c, PBS_AAAP_Owner_Zip__c, PBS_AAAP_Owner_Main_Phone__c,
                        PBS_AAAP_Email__c, PBS_AAAP_GEN_PURPOSE_RENTABLE__c,PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c, PBS_AAAP_Number_of_floors__c,
                        PBS_AAAP_Vacant_Premise_Rate__c, PBS_AAAP_Owner_Name__c, PBS_AAAP_Total_ABOA_Space_Available__c
                FROM PBS_AAAP_Offer__c
                WHERE id = :targetRec[0].PBS_AAAP_Offer_ID__c
        ];

        if (offer[0].PBS_AAAP_Total_ABOA_Space_Available__c < offer[0].PBS_AAAP_Total_SF_Offered__c) {
            if (offer[0].PBS_AAAP_Total_Space_Selected__c == 0) {
                offer[0].PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
            } else if (offer[0].PBS_AAAP_Total_Space_Selected__c > 0) {
                offer[0].PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
            }
            updOffer.add(offer[0]);
        } else {
            offer[0].PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED;
            updOffer.add(offer[0]);
        }

        // Changes made by sguni on 10/29/2012, to not fire the trigger while AAAP manger is Awarding offer.
        PBS_AAAP_OfferHelper.triggerupdate(true);
        //system.debug('Updated offer'+offer);
        update updOffer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        // change ends

        //List<PBS_AAAP_Agency_Requirement__c> updAgency = new List<PBS_AAAP_Agency_Requirement__c>();
        List<PBS_AAAP_Agency_Requirement__c> agency = new List<PBS_AAAP_Agency_Requirement__c>();
        agency = [SELECT Id, PBS_AAAP_REQ_STATUS__c FROM PBS_AAAP_Agency_Requirement__c WHERE Id = :targetRec[0].PBS_AAAP_AGENCY_REQUIREMENT_ID__c];
        agency[0].PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_AWARDED;
        update agency[0];

        pref = Page.PBS_AAAP_AwardSelectedOfferInfo;
        pref.getParameters().put('id', offerSelectAwardID);
        pref.setRedirect(true);
        System.debug('*************** PageReference show ofeer id::: ' + offerSelectAwardID);

        return pref;
    }

}