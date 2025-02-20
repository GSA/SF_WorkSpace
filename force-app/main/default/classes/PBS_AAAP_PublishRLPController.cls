public with sharing class PBS_AAAP_PublishRLPController {
	@AuraEnabled
    public static List<PBS_AAAP_RLP_Attachments__c> getAttachments(String recordId){
        return [Select Id from PBS_AAAP_RLP_Attachments__c where PBS_AAAP_RLP__c =:recordId];
    }
}