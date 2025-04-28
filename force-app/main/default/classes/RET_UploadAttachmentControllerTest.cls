@isTest
public class RET_UploadAttachmentControllerTest {

    @testsetup static void createData(){

        //insert new Account(Name = 'Real Estate Tax Bucket');
        Id acctOwnerId = [Select Id From User where isActive = true and UserRoleId != null Limit 1].id;
        Account acct = new Account(name ='Real Estate Tax Bucket', ownerid = acctOwnerId) ;
        insert acct; 
        
        //Create Lease Record
        PBS_Lease__c newLease = new PBS_Lease__c(
          Name = 'Test Lease',
          Lease_Number__c = 'LKS01234',
          Lease_Effective_Date__c = date.today()
        );
        insert newLease;
    
        //Create POC Lease Access Record
        insert new PBS_Lease_Access__c(PBS_Lease__c = newLease.Id, Requestor__c = UserInfo.getUserId(), Status__c = 'POC');
    
        //create a draft case record with no attachments
        Case newCase = new case(
          origin = 'Web',
          Status = 'Draft',
          PBS_Lease__c = newLease.id
        );
        insert newCase;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Bill1', 
            VersionData = Blob.valueOf('Unit Test Attachment Body'),
            PathOnClient = 'bill1.txt'
        );
        insert contentVersion;
        String contentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;            
            
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = newCase.Id,
            ContentDocumentId = contentDocumentId
        );
        insert cdl;
            
        RET_Document_Data__c retRec = new RET_Document_Data__c();
        retRec.Name = 'test ret';
        retRec.Attachment_Id__c = cdl.ContentDocumentid;
        retRec.Parent_Case__c = newCase.Id;
        retRec.Full_File_Name__c = 'ret test';
        retRec.Document_Category__c = 'Real Estate Taxes';
        retRec.Document_Type__c = 'Tax bill(s)';
        insert retRec;
        
    }
    
    @isTest static void testInsertDocument() {
        List<RET_UploadAttachmentController.DocumentWrapper> docWrapper = new List<RET_UploadAttachmentController.DocumentWrapper>();
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Bill2', 
            VersionData = Blob.valueOf('Another Unit Test Attachment Body'),
            PathOnClient = 'bill2.txt'
        );
        insert contentVersion;
        String contentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;            
        RET_UploadAttachmentController.DocumentWrapper doc = new RET_UploadAttachmentController.DocumentWrapper();
        doc.name = 'bill2.txt';
        doc.contentDocumentId = contentDocumentId;
        doc.documentCategory = 'Real Estate Taxes';
        doc.documentType = 'Tax bill(s)';
        docWrapper.add(doc);
        
        List<RET_UploadAttachmentController.DocumentWrapper> documentLinkRecords = RET_UploadAttachmentController.insertDocumentLinkRecords('LKS01234', docWrapper);
        List<Case> cases = [SELECT Id, Status FROM Case WHERE PBS_Lease__r.Lease_Number__c = 'LKS01234' LIMIT 1];
        System.assertEquals(cases[0].Id, documentLinkRecords[0].caseId);
        cases[0].Status = 'Submitted';
        update cases[0];

        RET_UploadAttachmentController.deleteTheUploadedDocuments(docWrapper);
        List<ContentVersion> versions = [SELECT Id FROM ContentVersion WHERE Id = :contentVersion.Id];
        System.assertEquals(0, versions.size());

        docWrapper = new List<RET_UploadAttachmentController.DocumentWrapper>();
        contentVersion = new ContentVersion(
            Title = 'Bill3', 
            VersionData = Blob.valueOf('Yet Another Unit Test Attachment Body'),
            PathOnClient = 'bill3.txt'
        );
        insert contentVersion;
        contentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;            
        doc = new RET_UploadAttachmentController.DocumentWrapper();
        doc.name = 'bill3.txt';
        doc.contentDocumentId = contentDocumentId;
        doc.documentCategory = 'Real Estate Taxes';
        doc.documentType = 'Tax bill(s)';
        docWrapper.add(doc);
        
        documentLinkRecords = RET_UploadAttachmentController.insertDocumentLinkRecords('LKS01234', docWrapper);
        String caseId = [SELECT Id FROM Case WHERE PBS_Lease__r.Lease_Number__c = 'LKS01234' and Status = 'Draft' LIMIT 1].Id;
        System.assertEquals(caseId, documentLinkRecords[0].caseId);
        
    }
   
}