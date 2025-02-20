public with sharing class PBS_AAAP_RelatedContentController {
    
    @AuraEnabled(cacheable=true)
    public static List<RelatedContentWrapper> getRelatedContent(Id recordId) {
        List<RelatedContentWrapper> relatedContent = new List<RelatedContentWrapper>();
        
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        Set<Id> documentIds = new Set<Id>();
        for (ContentDocumentLink documentLink : documentLinks) {
            documentIds.add(documentLink.ContentDocumentId);
        }
        List<ContentNote> contentNotes = [SELECT Id, Title, FileType, LastModifiedDate,CreatedDate, CreatedBy.Name, Content FROM ContentNote WHERE Id IN :documentIds];
        
        for (ContentNote note : contentNotes) {
            relatedContent.add(new RelatedContentWrapper(note.Id, note.Title, 'Content Note', 'note', note.CreatedDate, note.Title, note.CreatedDate, note.CreatedBy.Name, note.Content.toString()));
        }
        
        return relatedContent;
    }
    
    public class RelatedContentWrapper {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public String Title { get; set; }
        @AuraEnabled public String FileType { get; set; }
        @AuraEnabled public String FileExtension { get; set; }
        @AuraEnabled public Datetime CreatedDate { get; set; }
        @AuraEnabled public String LatestVersionTitle { get; set; }
        @AuraEnabled public Datetime LatestVersionCreatedDate { get; set; }
        @AuraEnabled public String CreatedByName { get; set; }
        @AuraEnabled public String content {get;set;}
        
        public RelatedContentWrapper(Id id, String title, String fileType, String fileExtension, Datetime createdDate, String latestVersionTitle, Datetime latestVersionCreatedDate, String createdByName, String content) {
            this.Id = id;
            this.Title = title;
            this.FileType = fileType;
            this.FileExtension = fileExtension;
            this.CreatedDate = createdDate;
            this.LatestVersionTitle = latestVersionTitle;
            this.LatestVersionCreatedDate = latestVersionCreatedDate;
            this.CreatedByName = createdByName;
            this.content = content;
        }
    }
    
    @AuraEnabled
    public static void createNRecord (ContentNote nt, id PrentId){
        try{
            if(nt != null){
                insert nt;
                ContentDocument cd=[select id from ContentDocument where id=:nt.Id];
                ContentDocumentLink cdl=new ContentDocumentLink();
                cdl.ContentDocumentId=cd.id;
                cdl.LinkedEntityId=PrentId;
                cdl.ShareType='V';
                cdl.Visibility='AllUsers';
                insert cdl;
            }
        } catch (Exception ex){
            system.debug('jmd '+ex.getMessage());
        }
    }  
    
    @AuraEnabled
    public static void updateNoteRecord (ContentNote nt, Id noteId) {
        try{
            if(nt != null) { 
                nt.Id = noteId;
                update nt;
            }
        } catch (Exception ex){
            system.debug('jmd '+ex.getMessage());
        }
    } 
    
    @AuraEnabled
    public static ContentNoteWrapperClass getNoteRecord (Id noteId) {
        List<ContentNote> cn = [
            SELECT id, Title, Content
            FROM ContentNote
            WHERE id =:noteId Limit 1
        ];
        
        ContentNoteWrapperClass wrap = new ContentNoteWrapperClass();
        wrap.title = cn[0].Title;
        wrap.content = '';
        if (cn[0].Content <> null) {
            wrap.content = cn[0].Content.toString();
        }       
        return wrap;
    } 
    
    @AuraEnabled
    public static void deleteNoteRecord (Id noteId) {
        try {
            ContentNote cn = new ContentNote(Id = noteId);
            delete cn;
        } catch (Exception ex){
            system.debug('jmd '+ex.getMessage());
        }
    } 
    
    public Class ContentNoteWrapperClass {
        @AuraEnabled
        public String content {get;set;}        
        @AuraEnabled
        public String title {get;set;}
    }
}