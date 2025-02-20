public with sharing class PBS_AAAP_SelectedOfferSpace_Contr {

    public PBS_AAAP_Offer_Select_Award_Info__c currentObj { get; set; }
    public string offerspaceID { get; set; }
    public string agencyId { get; set; }
    public PBS_AAAP_Space__c space { get; set; }
    public PBS_AAAP_Offer__c offer { get; set; }
    public PBS_AAAP_Agency_Requirement__c agency { get; set; }
    public decimal availableUSF { get; set; }
    //public Double TIAmount {get;set;}
    //public Double BSACAmount {get;set;}
    public PBS_AAAP_SelectedOfferSpace_Contr() {

        offerspaceID = ApexPages.currentPage().getParameters().get('selectedOfferSpaceId');
        agencyId = ApexPages.currentPage().getParameters().get('agencyId');
        currentObj = [
                SELECT p.PBS_AAAP_BSAC_Placeholder__c,p.PBS_AAAP_TI_Allowance__c,p.PBS_AAAP_isSelected__c, p.PBS_AAAP_VACANT_PREMISE_RATE_ADJ__c, p.PBS_AAAP_TOTAL_MARKUP__c, p.PBS_AAAP_TI_PAID_VIA_RWA__c,
                        p.PBS_AAAP_Space_ID__c, p.PBS_AAAP_SELECTED_USF__c, p.PBS_AAAP_Offer_ID__c, p.PBS_AAAP_OT_RATE_COOLING_HEAT__c,
                        p.PBS_AAAP_OFFER_SELECTION_DATE__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                        p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, p.PBS_AAAP_NEW_GSA_LEASE_NUM__c, p.PBS_AAAP_MONTHLY_COST_RESV_PARK_SUR_LOT__c,
                        p.PBS_AAAP_MONTHLY_COST_RESV_PARK_GARAGE__c, p.PBS_AAAP_MONTHLY_COST_NONRES_PARK_GARAGE__c, p.PBS_AAAP_MONTHLY_COST_NONRESPARK_SURLOT__c,
                        p.PBS_AAAP_Legacy_ID__c, p.PBS_AAAP_LEASE_EXPIRATION_DATE__c, p.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, p.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                        p.PBS_AAAP_COST_FOR_TI__c, p.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, p.PBS_AAAP_CONTRACT_AWARD_DATE__c, p.PBS_AAAP_BASE_RATE__c,
                        p.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, p.PBS_AAAP_AWARD_TOT_CONS_MARKUP__c, p.PBS_AAAP_AWARDED_USF__c, p.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                        p.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, p.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c, p.PBS_AAAP_AGENCY_REQUIREMENT_ID__c,
                        p.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c, p.PBS_AAAP_ACTUAL_TI_AMORTIZED_INTO_RENT__c, p.Name, p.Id
                FROM PBS_AAAP_Offer_Select_Award_Info__c p
                WHERE p.Id = :offerspaceID.trim()
        ];

        agency = [SELECT Id, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c ,PBS_AAAP_BSAC_per_ABOA__c , PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c , BSAC_for_Continuing_Space_per_ABOA_SF__c ,

        PBS_AAAP_REQ_STATUS__c, Name FROM PBS_AAAP_Agency_Requirement__c WHERE id = :agencyId.trim()];

        space = [
                SELECT id, name, PBS_AAAP_NEW_SUCCEED_LEASE_IND__c ,

                PBS_AAAP_Total_Actual_Space_Available__c, PBS_AAAP_Total_ABOA_Available__c, PBS_AAAP_SF_Offered__c, PBS_AAAP_OFFER_NUMBER__c, PBS_AAAP_Total_ABOA_Selected__c
                FROM PBS_AAAP_Space__c
                WHERE id = :currentObj.PBS_AAAP_Space_ID__c
        ];

        if(space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c){
            if(currentObj.PBS_AAAP_TI_Allowance__c == null){
                currentObj.PBS_AAAP_TI_Allowance__c = agency.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c;
            }
            if(currentObj.PBS_AAAP_BSAC_Placeholder__c == null){
                currentObj.PBS_AAAP_BSAC_Placeholder__c = agency.PBS_AAAP_BSAC_per_ABOA__c;
            }
             
         }else{
            if(currentObj.PBS_AAAP_TI_Allowance__c == null){
                currentObj.PBS_AAAP_TI_Allowance__c = agency.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c;
            }
            if(currentObj.PBS_AAAP_BSAC_Placeholder__c == null){
                currentObj.PBS_AAAP_BSAC_Placeholder__c = agency.BSAC_for_Continuing_Space_per_ABOA_SF__c;
            }
             
         }
         
         System.debug('TIAmount@@@@@@: '+ currentObj.PBS_AAAP_TI_Allowance__c);
         System.debug('BSACAmount@@@@@@: '+ currentObj.PBS_AAAP_BSAC_Placeholder__c);
         

        availableUSF = space.PBS_AAAP_Total_Actual_Space_Available__c;

    }

    public PageReference actionSave() {
        Savepoint sp0 = Database.setSavepoint();
       
        PageReference pref = null;
         //Commented the below  lines in order to by pass the error - Rakesh 4/21/19
        /*if (currentObj.PBS_AAAP_SELECTED_USF__c == null || currentObj.PBS_AAAP_SELECTED_USF__c == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter the selected USF for the space.');
            ApexPages.addMessage(msg);
            return null;
        }*/
        try {
            //Added by Rakes on 4/21/19 
            currentObj.PBS_AAAP_SELECTED_USF__c = 0;
            //added by syam on 04/21 to update the flag. moved update flag logic from identifywinner controller to here
            currentObj.PBS_AAAP_isSelected__c = true;
            update currentObj;
            //Commented the below lines by Rakesh on 4/21/19 as its no longer needed to update the space object
            //space.PBS_AAAP_Total_ABOA_Available__c = space.PBS_AAAP_SF_OFFERED__c;
            /*System.debug('******space.PBS_AAAP_Total_ABOA_Selected__c::: ' + space.PBS_AAAP_Total_ABOA_Selected__c);
            System.debug('******currentObj.PBS_AAAP_SELECTED_USF__c::: ' + currentObj.PBS_AAAP_SELECTED_USF__c);
            if (space.PBS_AAAP_Total_ABOA_Selected__c == null) {
                space.PBS_AAAP_Total_ABOA_Selected__c = 0;
            }
            space.PBS_AAAP_Total_ABOA_Selected__c = space.PBS_AAAP_Total_ABOA_Selected__c + currentObj.PBS_AAAP_SELECTED_USF__c;
            // Changes made by sguni on 10/29/2012, to not fire the trigger while AAAP manger is performing the Identity winner
            PBS_AAAP_OfferHelper.triggerupdate(true);
            update space;
            PBS_AAAP_OfferHelper.triggerupdate(false);*/
            // Change ends
            offer = [SELECT id, PBS_AAAP_Offer_Status__c FROM PBS_AAAP_Offer__c WHERE id = :space.PBS_AAAP_OFFER_NUMBER__c];
            if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED;
            }
            if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED) {
                offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
            }

            // Changes made by sguni on 10/29/2012, to not fire the trigger while AAAP manger is performing the Identity winner
            PBS_AAAP_OfferHelper.triggerupdate(true);
            update offer;
            PBS_AAAP_OfferHelper.triggerupdate(false);

            agency.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDINGSELECTED;
            update agency;
            // Change ends

            /*pref = Page.PBS_AAAP_AgencyRequirement;
            pref.getParameters().put('id', currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__c);*/

            pref = Page.PBS_AAAP_AwardSelectedOfferInfoEdit;
            pref.getParameters().put('id', currentObj.Id);

            pref.setRedirect(true);
        } catch (Exception ex) {
            ApexPages.addMessages(ex); Database.rollback(sp0); pref = null;
        }

        //currentObj.PBS_AAAP_TI_Allowance__c = currentObj.PBS_AAAP_TI_Allowance__c;
        //currentObj.PBS_AAAP_BSAC_Placeholder__c = currentObj.PBS_AAAP_BSAC_Placeholder__c ;


        return pref;
    }

    public PageReference actionCancel() {

        if (currentObj.id != null) {
            currentObj.PBS_AAAP_isSelected__c = false;
            update currentObj;
        }
        if (agency.PBS_AAAP_REQ_STATUS__c != PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING) {
            agency.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING;
            update agency;
        }
        
        PageReference pref = Page.PBS_AAAP_AgencyRequirement;
        pref.getParameters().put('id', currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__c);

        pref.setRedirect(true);
        return pref;
    }

}