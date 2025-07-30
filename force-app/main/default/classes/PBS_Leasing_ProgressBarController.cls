public with sharing class PBS_Leasing_ProgressBarController {
    // Method to fetch progress bar steps based on the provided progress bar name.
    @AuraEnabled
    public static List<Progress_Bar_Step__mdt> getSteps(String progressBarName){
        // Query to retrieve progress bar steps from the metadata based on the developer name.
        // The steps are ordered by the 'Order_Number__c' field in ascending order.
        return [Select Id,Label, Progress_Bar__c, Page_URL__c, Order_Number__c,DeveloperName
                From Progress_Bar_Step__mdt where Progress_Bar__r.DeveloperName =:progressBarName order by Order_Number__c Asc];
    }
    // Method to retrieve PBS_AAAP_RLP__c records related to a given offer ID.
    @AuraEnabled(cacheable = true)
    public static PBS_AAAP_Offer__c getPBS_AAAP_RLP_ObjRecords(String offerId){
        // Query to get the offer record using the provided offer ID.
       return [Select id, PBS_AAAP_RLP_Number__c, RecordType.Name from PBS_AAAP_Offer__c Where id =: offerId];
        // Query to retrieve related PBS_AAAP_RLP__c records based on the RLP number 
        // and ensuring the solicitation status is true (active).
        
    }
    @AuraEnabled(cacheable = true)
    public static List<PBS_AAAP_Offer__c> getPBS_AAAP_Offer_ObjRecords(String offerId){
        // Query to get the offer record using the provided offer ID.
        List<PBS_AAAP_Offer__c> offerRec =[Select id, PBS_AAAP_Building_Name__c,PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                                           PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c,
                                           PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c, PBS_AAAP_Offer_Status__c from PBS_AAAP_Offer__c  Where id =: offerId];
        return offerRec;
    }
}