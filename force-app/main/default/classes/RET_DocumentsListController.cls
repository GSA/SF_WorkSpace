public without sharing class RET_DocumentsListController {

    @AuraEnabled
    public static String getHostName() {
        System.debug(' **** System.Url.getSalesforceBaseUrl(): ' + System.Url.getSalesforceBaseUrl());
        return System.Url.getSalesforceBaseUrl().getHost().replace('https://', '');
    }

    @AuraEnabled
    public static List<AttachmentListWrapper> deleteSelectedDocument(String docToDelete, String caseId) {
        try {
            Attachment attachToDelete = new Attachment(Id = docToDelete);
            delete attachToDelete;
            RET_Document_Data__c rec = [select id,Document_Type__c from RET_Document_Data__c where Attachment_ID__c = :docToDelete limit 1];
            String docType = rec.Document_Type__c;
            delete rec;  
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return getCaseDocuments(caseId);
    }

    @AuraEnabled
    public static List<AttachmentListWrapper> getUpdatedCaseDocuments(String caseId) {
        return getCaseDocuments(caseId);
    }
    
    @AuraEnabled
    public static List<AttachmentListWrapper> getCaseDocuments(String caseId) {
        
        List<AttachmentListWrapper> wrapperList = new List<AttachmentListWrapper>();
        Map<String, List<Attachment>> wrapperMap = new Map<String, List<Attachment>>();             

        Map<Id, Attachment> attachmentMap = new Map<Id, Attachment>();
        for(Attachment attach : [select Id, Name from Attachment where parentId = :caseId]) {
            attachmentMap.put(attach.Id, attach);
        }  
        if(!attachmentMap.isEmpty()) {
            for(RET_Document_Data__c docData : [select Id, Name, Attachment_ID__c, Tax_Year__c, Document_Type__c, 
                                           Tax_County__c from RET_Document_Data__c where Attachment_ID__c in :attachmentMap.keySet() order by Name asc]) {
                if(wrapperMap.containsKey(docData.Document_Type__c)) {
                    wrapperMap.get(docData.Document_Type__c).add(attachmentMap.get(docData.Attachment_ID__c));
                } else {
                    wrapperMap.put(docData.Document_Type__c, new List<Attachment>{attachmentMap.get(docData.Attachment_ID__c)});
                }
            }
            if(!wrapperMap.isEmpty()) {
                // Add our documents to the list in the same order as the document type picklist.
                List<String> docTypes = new List<String>();
                Schema.DescribeFieldResult fieldResult = RET_Document_Data__c.Document_Type__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();                
                for( Schema.PicklistEntry pickListVal : ple) {
                    String docType = pickListVal.getLabel();
                    if(wrapperMap.containsKey(docType)) {
                        List<Attachment> listToSort = wrapperMap.get(docType);
                        listToSort.sort();
                        wrapperList.add(new AttachmentListWrapper(listToSort, docType));
                    }
                }               
            }
        }
        return wrapperList;
    }

    public class AttachmentListWrapper {
        @AuraEnabled public String documentType {get;set;}
        @AuraEnabled public List<Attachment> attachList {get;set;}

        public AttachmentListWrapper(List<Attachment> attList, String docType) {
            documentType = docType;
            attachList = attList;
        }
    }

    @AuraEnabled
    Public static Map<String,String> getUrls(String caseId ){
        Map<String,String> urls = new Map<String,String>();
        string tempurl;
        String hostlink = Url.getSalesforceBaseUrl().toExternalForm()+'/realestatetaxes/servlet/servlet.FileDownload?file=';
        
        for(Attachment att :  [SELECT Id, Name, Body, ContentType FROM Attachment WHERE ParentId =: caseId] ){
                tempurl = hostlink+att.id;
                urls.put(att.Name,tempurl);
                tempurl = '';
            }
        if(urls.size()>0){
            return urls;
        }else{
            throw new AuraHandledException('No attachments found for this tax submission.');
        }
    }

}