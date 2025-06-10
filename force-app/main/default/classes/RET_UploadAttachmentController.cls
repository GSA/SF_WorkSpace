public without sharing class RET_UploadAttachmentController {

    @AuraEnabled
    public static List<DocumentWrapper> insertDocumentLinkRecords(String leaseNumber, List<DocumentWrapper> contentdocumentRecords){
        List<RET_Document_Data__c> RET_DocumentList = new List<RET_Document_Data__c>();
        Map<Id,ContentDocument> contentDocumentMap = new Map<Id,ContentDocument>();
        String caseId = getCaseId(leaseNumber);
        for(integer i=0; i< contentdocumentRecords.Size(); i++){
            RET_Document_Data__c Documents = new RET_Document_Data__c();
            Documents.Attachment_ID__c = contentdocumentRecords[i].contentDocumentId;
            Documents.Full_File_Name__c =contentdocumentRecords[i].name;
            Documents.Parent_Case__c = caseId;
            Documents.Document_Type__c = contentdocumentRecords[i].documentType;
            Documents.Document_Category__c = contentdocumentRecords[i].documentCategory;
            RET_DocumentList.add(Documents);
            contentDocumentMap.put(contentdocumentRecords[i].contentDocumentId,new ContentDocument());
        }
        if(RET_DocumentList.Size()>0){
            insert RET_DocumentList;
        }
        
        List<ContentDocumentLink> contentDocumentLinkRecords = new List<ContentDocumentLink>();
        for(integer i=0; i< contentdocumentRecords.Size(); i++){
            ContentDocumentLink obj = new ContentDocumentLink();
            obj.ContentDocumentId = contentdocumentRecords[i].contentDocumentId;
            obj.LinkedEntityId = caseId;
            obj.ShareType = 'V';
            obj.Visibility = 'AllUsers';
            contentDocumentLinkRecords.add(obj);
            contentdocumentRecords[i].caseId =caseId;
        }
        
        if(contentDocumentLinkRecords.Size()>0){
            insert contentDocumentLinkRecords;
            contentDocumentMap = new Map<Id,ContentDocument>([SELECT Id, LatestPublishedVersion.Title, LatestPublishedVersionId FROM ContentDocument Where Id=:contentDocumentMap.keyset()]);
            List<ContentDistribution> contentDistributionRecords = new List<ContentDistribution>();
            for(ContentDocument contentDocumentRecord : contentDocumentMap.values()){
                ContentDistribution cdl = new ContentDistribution(
                    Name = contentDocumentRecord.LatestPublishedVersion.Title,
                    ContentVersionId = contentDocumentRecord.LatestPublishedVersionId,
                    PreferencesAllowViewInBrowser= true,
                    PreferencesNotifyOnVisit= false
                );
                contentDistributionRecords.add(cdl);
            }
            insert contentDistributionRecords;
            List<ContentDocument> contentDocumentRecordsToUpdate = new List<ContentDocument>();
            for(ContentDistribution cd : [SELECT DistributionPublicUrl, ContentVersion.ContentDocumentId FROM ContentDistribution WHERE Id In: contentDistributionRecords]){
                ContentDocument contentDocumentObj = new ContentDocument();
                contentDocumentObj.Id = cd.ContentVersion.ContentDocumentId;
                contentDocumentObj.Description  = cd.DistributionPublicUrl;
                contentDocumentRecordsToUpdate.add(contentDocumentObj);
            }
            update contentDocumentRecordsToUpdate;
        }
        return contentdocumentRecords;
    }
    
    @AuraEnabled
    public static String getCaseId(String leaseNumber){
        System.debug('getCaseId() leaseNumber: ' + leaseNumber);
        List<PBS_Lease__c> leaseList = [SELECT Id, Region_Code__c FROM PBS_Lease__c WHERE Lease_Number__c =: leaseNumber LIMIT 1];
        String leaseId = leaseList[0].Id;
        System.debug('leaseId: ' + leaseId);
        String myUserId = UserInfo.getUserId();
        List<Case> caseList = [SELECT Id FROM Case WHERE Status = 'Draft' AND PBS_Lease__c =: leaseId and OwnerId =: myUserId ORDER BY CreatedDate DESC Limit 1];
        //If no case is found then create a new Case for this Lease and signed-on-user
        if (caseList.size() == 0) {
            Map<String,String> regionEmailmap = new Map<String,String>();
            for(RET_RegionalEmail__mdt  regCst : [select RegionalEmail__c,RegionCode__c  from RET_RegionalEmail__mdt]){
                regionEmailmap.put(regCst.RegionCode__c,regCst.RegionalEmail__c);
            }
            Case newCase = new Case();
            newCase.Origin = 'Web';
            newCase.OwnerId = myUserId;
            newCase.Status = 'Draft';
            newCase.PBS_Lease__c = leaseId;
            newCase.Subject = 'Real Estate Tax Submission';
            newCase.Region_Code__c = leaseList[0].Region_Code__c;
            if(String.isNotBlank(leaseList[0].Region_Code__c) && !regionEmailmap.isEmpty() && regionEmailmap.containsKey(leaseList[0].Region_Code__c)) newCase.GSA_Inbox__c  = regionEmailmap.get(leaseList[0].Region_Code__c);
            insert newCase;
            return newCase.Id;
        } else {
            return caseList[0].Id;
        }
    }
    
    @AuraEnabled
    public static void deleteTheUploadedDocuments(List<DocumentWrapper> contentdocumentRecords){
        List<ContentDocument> contentRecords = new List<ContentDocument>();
        for(DocumentWrapper contentdocumentRecord : contentdocumentRecords){
            contentRecords.add(new ContentDocument(Id=contentdocumentRecord.contentDocumentId));
            //offerAttachments.add(new PBS_AAAP_Offer_Attachments__c(Id=contentdocumentRecord.offerAttachmentId));
        }
        if(contentRecords.size() >0){
            delete contentRecords;
        }
    }
 
    public class DocumentWrapper{
        @AuraEnabled Public Boolean isShowOthers{get;set;}
        @AuraEnabled Public String contentDocumentId{get;set;}
        @AuraEnabled Public String name{get;set;}
        @AuraEnabled Public String caseId{get;set;}
        @AuraEnabled Public String documentCategory{get;set;}
        @AuraEnabled Public String documentType{get;set;}
        public DocumentWrapper(){
            this.isShowOthers = false;
            this.documentCategory = '';
            this.documentType = '';
        }
    }
}