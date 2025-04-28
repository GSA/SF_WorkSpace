public with sharing class CommonDetailPageComponentController {
    @AuraEnabled
    public static PBS_AAAP_Offer__c getRecordInfo(Id recordId){
       return [Select Id, RecordType.Name from PBS_AAAP_Offer__c Where Id =:recordId];
    }
}