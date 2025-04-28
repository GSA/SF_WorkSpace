global class PBS_AAAP_GeneratePreviewLinkBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id From PBS_AAAP_Offer_Attachments__c]);
    }
    
    global void execute(Database.BatchableContext BC, List<PBS_AAAP_Offer_Attachments__c> offerAttachments){
        Set<Id> recordIds = new Set<Id>();
        //List<PBS_AAAP_Offer_Attachments__c> offerAttachments = [Select Id From PBS_AAAP_Offer_Attachments__c where PBS_AAAP_Offer__c = 'a03t000000FHzBFAA1'];
        for(PBS_AAAP_Offer_Attachments__c record : offerAttachments){
            recordIds.add(record.Id);
        }
        system.debug(recordIds);
        List<ContentDocumentLink> contentDocumentLinkRecords = [Select ContentDocumentId,ContentDocument.Title, ContentDocument.LatestPublishedVersionId, LinkedEntityId from ContentDocumentLink Where LinkedEntityId In :recordIds];
        for(ContentDocumentLink contentDocumentLinkRecord : contentDocumentLinkRecords){
            ContentDocumentLink cDe = new ContentDocumentLink();
            contentDocumentLinkRecord.ShareType = 'V';
            contentDocumentLinkRecord.Visibility = 'AllUsers';
        }
        if(contentDocumentLinkRecords.size() > 0){
            update contentDocumentLinkRecords;
        }
        List<ContentDistribution> contentDistributionRecords = new List<ContentDistribution>();
        List<ContentDocument> contentDocumentRecords = new List<ContentDocument>();
        for(ContentDocumentLink contentDocumentLinkRecord : contentDocumentLinkRecords){
            ContentDistribution cdl = new ContentDistribution(
                Name = contentDocumentLinkRecord.ContentDocument.Title,
                ContentVersionId = contentDocumentLinkRecord.ContentDocument.LatestPublishedVersionId,
                PreferencesAllowViewInBrowser= true,
                PreferencesNotifyOnVisit= false
            );
            contentDistributionRecords.add(cdl);
        }
        if(contentDistributionRecords.size() > 0){
            insert contentDistributionRecords;
        }
        List<ContentDistribution> cdRecords = [SELECT DistributionPublicUrl, ContentVersion.ContentDocumentId FROM ContentDistribution WHERE Id In : contentDistributionRecords];
        for(ContentDistribution contentDistributionRecord : cdRecords){
            ContentDocument contentDocumentRecord = new ContentDocument();
            contentDocumentRecord.Id = contentDistributionRecord.ContentVersion.ContentDocumentId;
            contentDocumentRecord.Description  = contentDistributionRecord.DistributionPublicUrl;
            contentDocumentRecords.add(contentDocumentRecord);
        }
        if(contentDocumentRecords.size() > 0){
            update contentDocumentRecords;
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}