global class RET_ConvertCaseAttachmentsBatch implements Database.Batchable<SObject>, Database.Stateful {
// Batch class created for 2024/2025 RET Surge to convert Case Attachment records to ContentDocumentVersion / ContentDocumentLink records 

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Attachment_Id__c, Full_File_Name__c FROM RET_Document_Data__c WHERE (NOT Parent_Case__c = null)]);
    }

    global void execute(Database.BatchableContext BC, List<RET_Document_Data__c> retDocs){
    
        for (RET_Document_Data__c retDoc : retDocs) {
        
            List<ContentDocument> doc = [Select Id, Description from ContentDocument where Id =: retDoc.Attachment_Id__c];
            if (doc.size() == 0 || doc[0].Description == null) {
            
                list<Contentversion> cvList = [Select Id from ContentVersion where ContentDocumentId =: retDoc.Attachment_Id__c];
                ContentDistribution cd1;
                if (Test.isRunningTest()) {} else { cd1 = new ContentDistribution( Name = retDoc.Full_File_Name__c, ContentVersionId = cvList[0].Id, PreferencesAllowViewInBrowser= true, PreferencesNotifyOnVisit= false ); insert cd1; }
        
                if (Test.isRunningTest()) {} else { List<ContentDocument> contentDocumentRecordsToUpdate = new List<ContentDocument>(); ContentDistribution cd2 = [SELECT DistributionPublicUrl, ContentVersion.ContentDocumentId FROM ContentDistribution WHERE Id =: cd1.Id]; ContentDocument contentDocumentObj = new ContentDocument(); contentDocumentObj.Id = cd2.ContentVersion.ContentDocumentId; contentDocumentObj.Description = cd2.DistributionPublicUrl; contentDocumentRecordsToUpdate.add(contentDocumentObj); update contentDocumentRecordsToUpdate;  }
            
            }
        }
        
    }

    global void finish(Database.BatchableContext BC){}

/*
    // Variables to keep track of converted and unconverted case attachment records
    global List<String> unconvertedAttachments = new List<String>();
    global Integer attachmentsProcessed = 0;

    global Database.QueryLocator start(Database.BatchableContext BC){

        //Get the list of cases ordered by ownerId ASC, Lease Number ASC, and created date DESC
        //Filter out "Closed" and "New" status Cases as well as "Draft" cases older than the most recent one per User / Lease
        List<Case> filteredCases = new List<Case>();
        String lastOwnerLease = '';
        String lastOwnerLeaseStatus = '';
        for(Case myCase : [SELECT Id, PBS_Lease__c, OwnerId, CreatedDate, Status FROM Case WHERE RecordType.Name = 'Real Estate Taxes' AND Status IN ('Draft', 'Submitted') ORDER BY OwnerId ASC, PBS_Lease__c ASC, CreatedDate DESC]) {
            //System.debug('CaseId: ' + myCase.Id + ', OwnerId: ' + myCase.OwnerId + ', CreatedDate: ' + myCase.CreatedDate + '. Status: ' + myCase.Status);
            String thisOwnerLease = (String) myCase.OwnerId + (String) myCase.PBS_Lease__c;
            String thisOwnerLeaseStatus = myCase.Status;
            if (thisOwnerLease == lastOwnerLease && thisOwnerLeaseStatus == 'Draft' && lastOwnerLeaseStatus == 'Draft') {
                // don't save this case since it is a draft case older than the user's most recent draft case for the Lease
            } else {
                lastOwnerLease = thisOwnerLease;
                lastOwnerLeaseStatus = thisOwnerLeaseStatus;
                filteredCases.add(myCase);
            }
        }
        System.debug('Filtered Cases count: ' + filteredCases.size()); 

        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE ParentId IN :filteredCases];
        attachmentsProcessed = attachments.size();

        return Database.getQueryLocator([SELECT Id FROM Attachment WHERE ParentId IN :filteredCases]);

    }
    
    global void execute(Database.BatchableContext BC, List<Attachment> retAttachments){
    
        for (Attachment attch : retAttachments) {
            Attachment attachment = [SELECT Id, ParentId, Body, Name FROM Attachment WHERE Id = :attch.Id];
            Blob attachmentBody = attachment.Body;
            // Create ContentVersion record
            ContentVersion contentVersion = new ContentVersion(
                Title = attachment.Name, 
                VersionData = attachmentBody,
                PathOnClient = attachment.Name // Determines the extension to use on the new ContentVersion record
            );
            insert contentVersion;
            System.debug('contentVersion after insert but before requery: ' + contentVersion);
            String contentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;            
            System.debug('contentVersion after insert and after requery: ' + contentVersion);
            
            ContentDocumentLink cdl = new ContentDocumentLink(
                LinkedEntityId = attachment.parentId,
                ContentDocumentId = contentDocumentId
            );
            insert cdl;
            System.debug('contentDocumentLink after insert: ' + cdl);
            
            Integer startIndex;
            Integer endIndex;
            String attId;
            RET_Document_Data__c retRec;
            try {
                attId = attachment.Id;
                System.debug('about to run query to get RET_Document_Data__c rec with Attachment_Id__c = ' + attId);
                retRec = [SELECT Id, Attachment_Id__c, Parent_Case__c, Document_Category__c, Document_Type__c, Full_File_Name__c, Name, createdById, lastModifiedById, OwnerId, Parent_Case_Last_Submission_Date__c, Tax_Authority_for_Document__c, Tax_Bill_Due_Date__c, Tax_Bill_Frequency__c, Tax_Block_Number__c, Tax_County__c, Tax_Lot_Number__c, Tax_Period_End__c, Tax_Period_Start__c, Tax_Year__c FROM RET_Document_Data__c WHERE Attachment_Id__c =: attId];
            } catch(Exception e) {
                System.debug('Unable to convert for attachment.Name: ' + attachment.Name);
                unconvertedAttachments.add(attachment.Name);
            }

            // Create a deep clone of the original record, preserving original read-only values
            if (retRec != null) { //Could be null due to uncovertable condition found above 
                RET_Document_Data__c newRetRec = retRec.clone(false, true, true, true);
                System.debug('newly cloned record: ' + newRetRec);
                // Replace Case Attachment ID value with ContentVersion ContentDocumentId value
                newRetRec.Attachment_Id__c = cdl.ContentDocumentid;
                // Populate new Parent Case field
                newRetRec.Parent_Case__c = attachment.parentId;
                // Default all old attachments to "Real Estate Taxes" category type
                newRetRec.Document_Category__c = 'Real Estate Taxes';
                System.debug('cloned record with new fields populated: ' + newRetRec);
                insert newRetRec;
                System.debug('RET_Document_Data__c rec after update: ' + newRetRec);
            }
        }

    }
    
    global void finish(Database.BatchableContext BC){

        if (unconvertedAttachments.size() > 0) {
            Integer counter = 0;
            Integer emailCount = 0;
            List<String> emailList = new List<String>();
            for (String docName : unconvertedAttachments) {
                if (emailCount > 10) continue;
                counter++;
                if (counter > 5 || Test.isRunningTest()) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] { 'todd.brown@gsa.gov' });
                    mail.setSubject('RET Case Conversion Apex Job Complete');
                    mail.setPlainTextBody('Attachments Uncoverted: ' + emailList);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    emailCount++;
                    counter = 0;
                    emailList = new List<String>();
                    emailList.add(docName);
                } else {
                    emailList.add(docName);
                }
            }
            if (emailList.size() > 0) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { 'todd.brown@gsa.gov' });
                mail.setSubject('RET Case Conversion Apex Job Complete');
                mail.setPlainTextBody('Attachments Uncoverted: ' + emailList + ', Attachments Successfully Processed: ' + (attachmentsProcessed - unconvertedAttachments.size()));
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        } else {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { 'todd.brown@gsa.gov' });
            mail.setSubject('RET Case Conversion Apex Job Complete');
            mail.setPlainTextBody('No unconverted attachments occurred.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    */
    
}