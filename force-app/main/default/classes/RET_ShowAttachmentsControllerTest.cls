@istest
private class RET_ShowAttachmentsControllerTest {

    @isTest
    static void Tests() {

        //insert new Account(Name = 'Real Estate Tax Bucket');
        Id acctOwnerId = [Select Id From User where isActive = true and UserRoleId != null Limit 1].id;
        Account acct = new Account(name ='Real Estate Tax Bucket', ownerid = acctOwnerId) ;
        insert acct; 
        
        //Create Lease Record
        PBS_Lease__c leaseRec = new PBS_Lease__c(
          Name = 'Test Lease',
          Lease_Number__c = 'LKS01234',
          Lease_Effective_Date__c = date.today()
        );
        insert leaseRec;
    
        //Create POC Lease Access Record
        insert new PBS_Lease_Access__c(PBS_Lease__c = leaseRec.Id, Requestor__c = UserInfo.getUserId(), Status__c = 'POC');
    
        //create a draft case record with no attachments
        Case tmpCase = new case(
          origin = 'Web',
          Status = 'Draft',
          RET_Initial_Submission_Date__c = Datetime.now(),
          RET_Last_Submission_Date__c = Datetime.now(),
          PBS_Lease__c = leaseRec.id
        );
        insert tmpCase;
        
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert contentVersion;
        String contentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;            
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = tmpCase.Id;
        cdl.ContentDocumentId = contentDocumentId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        RET_Document_Data__c retDoc = new RET_Document_Data__c(
            Attachment_ID__c = cdl.ContentDocumentId,
            Parent_Case__c = tmpCase.Id,
            name = 'test ret',
            Full_File_Name__c = 'ret test',
            Document_Category__c = 'Real Estate Taxes',
            Document_Type__c = 'Tax bill(s)'
        );
        insert retDoc;
        
        String datatableName = 'RET_Show_Draft_Attachments';
        String leaseNumber = 'LKS01234';
        RET_ShowAttachmentsController.ResponseWrapper resp = RET_ShowAttachmentsController.getColumnsAndRecords(datatableName, leaseNumber, true);

    }

}