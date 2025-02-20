public with sharing class PBS_AAAP_OfferDeselectComponentContr extends PBS_AAAP_PageBaseController {

    public String targetObjId { public get; public set; }

    public PBS_AAAP_OfferDeselectComponentContr() {
        logMethodStart('PBS_AAAP_OfferDeselectComponentContr');
        logMethodEnd('PBS_AAAP_OfferDeselectComponentContr');
    }

    public List<PBS_AAAP_Offer_Deselect_Reject_Reasons__c> deselectList {
        public get {
            logMethodStart('deselectList');
            List<PBS_AAAP_Offer_Deselect_Reject_Reasons__c> deselectList = null;
//            if (targetObjId != null) {
                deselectList = [
                        SELECT a.Id, a.PBS_AAAP_Agency_Requirement__c, a.PBS_AAAP_Offer_Number__r.PBS_AAAP_Building_Name__c,
                                a.PBS_AAAP_Action_Comments__c, a.PBS_AAAP_Action_Reason__c, a.CreatedDate
                        FROM PBS_AAAP_Offer_Deselect_Reject_Reasons__c a
                        WHERE a.PBS_AAAP_Agency_Requirement__c = :targetObjId
                ];
//            }
            if (deselectList == null) {
                deselectList = new List<PBS_AAAP_Offer_Deselect_Reject_Reasons__c>();
            }
            logMethodEnd('deselectList', deselectList);
            return deselectList;
        }
        private set;
    }
}