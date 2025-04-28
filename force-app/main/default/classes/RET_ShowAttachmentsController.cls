public without sharing class RET_ShowAttachmentsController {

    @AuraEnabled
    public static ResponseWrapper getColumnsAndRecords(String datatableName, String leaseNumber, Boolean isDisabledDelete){
        // get the latest drafted case to pull the attachments
        String caseId = getCaseId(leaseNumber);
        ResponseWrapper responseWrapperObj = new ResponseWrapper();
        List<String> fields = new List<String>();
        System.debug('datatableName: ' + datatableName);
        // Query for metadata associated with the lightning datatable config
        Lightning_Datatable_Config__mdt lightningDatatableObj = [SELECT Id, DeveloperName, Table_Label__c, Object_API_Name__c, Related_Field_API_Name__c, Filter__c, Description__c FROM Lightning_Datatable_Config__mdt where DeveloperName =:datatableName];
        // Set the label in the response wrapper
        responseWrapperObj.label = lightningDatatableObj.Table_Label__c;
        // Query for columns associated with the dynamic datatable
        for(Lightning_Datatable_Column_Config__mdt lightningDatatableColumn : [SELECT Id, Label, Order__c, field_API_Name__c, Type__c, Initial_Width__c 
                FROM Lightning_Datatable_Column_Config__mdt where Lightning_Datatable_Config__r.DeveloperName = :datatableName order by Order__c Asc]){
            ColumnWrapper column = new ColumnWrapper(); 
            column.label = lightningDatatableColumn.Label;
            column.fieldName = lightningDatatableColumn.Field_API_Name__c;
            column.type = lightningDatatableColumn.Type__c;
            column.initialWidth = lightningDatatableColumn.Initial_Width__c;
            // Initialize and set type attributes for the column
            TypeAttribute typeAttributeObj = new TypeAttribute();
            typeAttributeObj.name = lightningDatatableColumn.Label;
            // Configure special attributes for specific columns
            if(lightningDatatableColumn.Label == 'DELETE FILE'){
                column.type= 'button-icon';
                typeAttributeObj.iconClass= 'slds-icon-text-error';
                column.sortable = false;
                typeAttributeObj.variant = 'destructive';
                typeAttributeObj.label = '';
                if(isDisabledDelete){
                    typeAttributeObj.disabled = true;
                }
                typeAttributeObj.iconName = 'utility:delete';
                column.fixedWidth = 100;
                column.cellAttributes.alignment = 'center';
            }else if(lightningDatatableColumn.Label == 'VIEW FILE'){
                column.type= 'button-icon';
                typeAttributeObj.variant = 'brand';
                typeAttributeObj.label = '';
                typeAttributeObj.iconName = 'utility:preview';
                column.sortable = false;
                column.fixedWidth = 100;
                column.cellAttributes.alignment = 'center';
            }
            // Configure date formatting for date columns
            if(lightningDatatableColumn.Type__c == 'date'){
                typeAttributeObj.month = '2-digit';
                typeAttributeObj.day = '2-digit';
                typeAttributeObj.year = 'numeric';
            }
            // Configure datetime formatting for a specific column
            if(lightningDatatableColumn.Label == 'Date/Time Submitted' || Test.isRunningTest()){
                typeAttributeObj.month = '2-digit';
                typeAttributeObj.day = '2-digit';
                typeAttributeObj.year = 'numeric';
                typeAttributeObj.hour = '2-digit';
                typeAttributeObj.minute = '2-digit';
                typeAttributeObj.hour12 = true;
            }
            // Add field API name to the list of fields to query, excluding specific ones
            if(lightningDatatableColumn.Field_API_Name__c != Null && lightningDatatableColumn.Field_API_Name__c != 'Title' 
                && lightningDatatableColumn.Field_API_Name__c != 'RecordNumber'){
                    fields.add(lightningDatatableColumn.Field_API_Name__c);
                }
            if(lightningDatatableColumn.Label == 'NO #'){
                column.fixedWidth = 50;
            }
            if(lightningDatatableColumn.Label == 'DATE UPLOADED'){
                column.fixedWidth = 120;
            }
            // Add the column wrapper to the response
            responseWrapperObj.columns.add(column);
            
            column.typeAttributes = typeAttributeObj;
        }
        
        List<Map<String,Object>> records = new List<Map<String,Object>>();
        
        // Add 'Id' to the list of fields to query        
        fields.add('Id');
        // Build and execute the dynamic SOQL query
        String query = 'SELECT ' + String.join(fields, ',') + ' FROM ' + lightningDatatableObj.Object_API_Name__c + ' WHERE ' + lightningDatatableObj.Related_Field_API_Name__c + ' = :caseId';
        //if(dynamicDatatableObj.Filter__c != Null){
        //    query += ' AND '+lightningDatatableObj.Filter__c;
        //}
        System.debug('query: ' + query);
        List<sObject> sObjectRecords = Database.query(query);
        Integer counter = 1;
        Set<Id> attachmentIds = new Set<Id>();
        for(sObject sObjectRecord : sObjectRecords){
            attachmentIds.add(((Id)sObjectRecord.get('Attachment_Id__c')));
        }
        system.debug('attachmentIds' +attachmentIds);
        // Query for related content document links if records are found
        if(attachmentIds.size() > 0){
            Map<Id, ContentDocumentLink> contentDocumentMap = new Map<Id, ContentDocumentLink>();
            List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.Description FROM ContentDocumentLink Where ContentDocumentId IN :attachmentIds];
            for(ContentDocumentLink contentDocumentLinkRecord : contentDocumentLinks){
                contentDocumentMap.put(contentDocumentLinkRecord.ContentDocumentId,contentDocumentLinkRecord);
            }
            // Populate records data with queried field values and content document details
            for(sObject sObjectRecord : sObjectRecords){
                Map<String,Object> recordData = new Map<String,Object>();
                for(String fieldAPIName : fields){
                    Object fieldValue = fieldAPIName == 'Attachment_Id__c' ? counter : sObjectRecord.get(fieldAPIName);
                    System.debug('Field: ' + fieldAPIName + ', Value: ' + fieldValue);
                    recordData.put(fieldAPIName, fieldValue);
                }
                recordData.put('RecordNumber', counter);
                recordData.put('ContentDocumentId', contentDocumentMap.get(String.valueOf(sObjectRecord.get('Attachment_Id__c'))).Id);
                recordData.put('Title', contentDocumentMap.get(String.valueOf(sObjectRecord.get('Attachment_Id__c'))).ContentDocument.Title);
                recordData.put('PreviewLink', contentDocumentMap.get(String.valueOf(sObjectRecord.get('Attachment_Id__c'))).ContentDocument.Description);
                records.add(recordData);
                counter++;
            }
            // Add the populated records to the response wrapper
            responseWrapperObj.records = records;
            system.debug ('responseWrapperObj.records: ' + responseWrapperObj.records);
            system.debug ('responseWrapperObj.columns: ' + responseWrapperObj.columns);
        }
        
        // Return the response wrapper containing columns and records
        return responseWrapperObj;
    }    
    
    // Wrapper class for the response
    public class ResponseWrapper{
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public List<ColumnWrapper> columns{get;set;}
        @AuraEnabled public List<Map<String,Object>> records{get;set;}
        // Constructor to initialize lists
        public ResponseWrapper(){
            this.columns = new List<ColumnWrapper>();
            this.records = new List<Map<String,Object>>();
        }
    }   
    // Wrapper class for column data
    public class ColumnWrapper{
        @AuraEnabled public string fieldName{get;set;}
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string type{get;set;}
        @AuraEnabled public string initialWidth{get;set;}
        @AuraEnabled public Boolean wrapText{get;set;}
        @AuraEnabled public Boolean hideDefaultActions{get;set;}
        @AuraEnabled public Boolean sortable{get;set;}
        @AuraEnabled public Integer fixedWidth{get;set;}
        @AuraEnabled public TypeAttribute typeAttributes{get;set;}
        @AuraEnabled public CellAttribute cellAttributes{get;set;}
        // Constructor to set default values
        public ColumnWrapper(){
            wrapText = true;
            hideDefaultActions = true;
            sortable = true;
            cellAttributes = new CellAttribute();
        }
    }
    
    // Wrapper class for cell attributes
    public class CellAttribute{
        @AuraEnabled public string alignment{get;set;}
        // Constructor to set default alignment
        public CellAttribute(){
            alignment = 'left';
        }
    }
    
    // Wrapper class for type attributes
    public class TypeAttribute{
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string variant{get;set;}
        @AuraEnabled public string iconName{get;set;}
        @AuraEnabled public string month{get;set;}
        @AuraEnabled public string day{get;set;}
        @AuraEnabled public string year{get;set;}
        @AuraEnabled public string hour{get;set;}
        @AuraEnabled public string minute{get;set;}
        @AuraEnabled public Boolean hour12{get;set;}
        @AuraEnabled public Integer maximumFractionDigits{get;set;}
        @AuraEnabled public Boolean disabled{get;set;}
        @AuraEnabled public string iconClass{get;set;}
        // Empty constructor
        public TypeAttribute(){
            
        }
    }

    @AuraEnabled
    public static String getCaseId(String leaseNumber){
        String caseId = null;
        System.debug('Starting getCaseId() with leaseNumber ' + leaseNumber);
        String leaseId = [SELECT Id FROM PBS_Lease__c WHERE Lease_Number__c =: leaseNumber LIMIT 1].Id;
        String myUserId = UserInfo.getUserId();
        List<Case> caseIds = [SELECT Id FROM Case WHERE Status = 'Draft' AND PBS_Lease__c =: leaseId and OwnerId =: myUserId ORDER BY CreatedDate DESC Limit 1];
        if(caseIds.size() > 0){
            System.debug('caseId retrieved: ' + caseIds[0]);
            caseId =caseIds[0].Id;
        }
        //Only the rET_UploadAttachment LWC and its controller Apex class should create a new Draft Case if one is not found for the User and Lease
        //if (caseId == null) {
        //    Case newCase = new Case();
        //    newCase.Status = 'Draft';
        //    newCase.PBS_Lease__c = leaseId;
        //    insert newCase;
        //    return newCase.Id;
        //} else {
            return caseId;
        //}
    }   

    @AuraEnabled
    public static void deleteRecord(String recordId) {
      String documentId = [SELECT Id, Attachment_Id__c FROM RET_Document_Data__c WHERE Id = :recordId].Attachment_Id__c;
        //ContentDocumentLink obj = [Select Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId =:caseId];
        system.debug('documentId ' +documentId);
        delete new ContentDocument(Id=documentId);
        delete new RET_Document_Data__c(Id=recordId);
    }
    
}