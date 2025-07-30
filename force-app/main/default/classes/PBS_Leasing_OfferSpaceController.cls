public with sharing class PBS_Leasing_OfferSpaceController {

    @AuraEnabled
    public static PBS_AAAP_Offer__c getOfferDetails(String offerId) { 
        return [SELECT ID,PBS_AAAP_Building_Name__c,PBS_AAAP_Street_Address__c,PBS_AAAP_City__c,PBS_AAAP_State__c,Formula_RLP_Num__c,RecordTypeId,PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c,recordtype.name,property__c,property__r.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c,property__r.PBS_AAAP_Building_Name__c,PBS_AAAP_Offer_Status__c FROM PBS_AAAP_Offer__c  WHERE Id = :offerId];
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords() {
        return [SELECT ID,PBS_AAAP_Building_Name__c,PBS_AAAP_Street_Address__c,PBS_AAAP_City__c,PBS_AAAP_State__c,Formula_RLP_Num__c,RecordTypeId,PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c,recordtype.name,property__r.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c,property__r.PBS_AAAP_Building_Name__c,PBS_AAAP_Offer_Status__c,PBS_AAAP_Is_Offer_Valid__c FROM PBS_AAAP_Offer__c WHERE (OwnerID = :userInfo.getUserId() AND PBS_AAAP_Is_Offer_Valid__c = TRUE AND Master_Offer__c = NULL AND recordtype.name ='AAAP') OR (OwnerID = :userInfo.getUserId() AND recordtype.name='RSAP')  ORDER BY LASTMODIFIEDDATE DESC];
    } 
    
}