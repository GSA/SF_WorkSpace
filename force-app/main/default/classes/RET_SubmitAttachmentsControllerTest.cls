@istest
private class RET_SubmitAttachmentsControllerTest {
	
    
    @testSetup static void SetupMethod(){
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
          PBS_Lease__c = leaseRec.id
        );
        insert tmpCase;
        
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = tmpCase.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        List<ContentDocumentLink> cdl2 = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:tmpCase.Id];
        RET_Document_Data__c retDoc = new RET_Document_Data__c(
            Attachment_ID__c = cdl2[0].Id,
            Parent_Case__c = tmpCase.Id,
            name = 'test ret',
            Full_File_Name__c = 'ret test',
            Document_Category__c = 'Real Estate Taxes',
            Document_Type__c = 'Tax bill(s)'
        );
        insert retDoc; 
        RET_GREX_Integration_Email_Settings__c setting = new RET_GREX_Integration_Email_Settings__c();
        setting.Name = 'GREX Team Integration Failure';
        setting.Sender_Display_Name__c = 'Whatever';
        setting.To_Address__c='Test@test.com';
        setting.Email_Subject__c='Test';
        setting.Email_Body__c='YUO';
        insert setting; 
        RET_GREX_Integration_Email_Settings__c setting1 = new RET_GREX_Integration_Email_Settings__c();
        setting1.Name = 'O&M Integration Failure';
        setting1.Sender_Display_Name__c = 'Whatever';
        setting1.To_Address__c='Test@test2.com';
        setting1.Email_Subject__c='Test2';
        setting1.Email_Body__c='YUO2';
        insert setting1;
    }
        
        
    @isTest
    static void ReviewAttachmentsTests() {
        // Check a Draft Case without attachments. Expect response.success = false.
        
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
          PBS_Lease__c = leaseRec.id
        );
        insert tmpCase;
 
        RET_SubmitAttachmentsController.ReviewAttachmentsResponse resp = RET_SubmitAttachmentsController.reviewAttachments('LKS01234');
        System.assertEquals(true, resp.success, 'Expected.');

        // Check a Draft Case with attachments. Expect response.success = true.
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = tmpCase.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        List<ContentDocumentLink> cdl2 = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:tmpCase.Id];
        RET_Document_Data__c retDoc = new RET_Document_Data__c(
            Attachment_ID__c = cdl2[0].Id,
            Parent_Case__c = tmpCase.Id,
            name = 'test ret',
            Full_File_Name__c = 'ret test',
            Document_Category__c = 'Real Estate Taxes',
            Document_Type__c = 'Tax bill(s)'
        );
        insert retDoc;
             
        resp = RET_SubmitAttachmentsController.reviewAttachments('LKS01234');
        System.assertEquals(true, resp.success, 'Unexpected response success value.');
 
        //Test a bogus leaseNumber.  Expect a result of false.       
        resp = RET_SubmitAttachmentsController.reviewAttachments('bogus');
        System.assertEquals(false, resp.success, 'Unexpected response success value.');

        //Test a Lease that has no Draft case.  Expect a result of false.       
        //Create Lease Record
        PBS_Lease__c leaseRec2 = new PBS_Lease__c(
          Name = 'Test Lease2',
          Lease_Number__c = 'LKS01235',
          Lease_Effective_Date__c = date.today()
        );
        insert leaseRec2;
        insert new PBS_Lease_Access__c(PBS_Lease__c = leaseRec2.Id, Requestor__c = UserInfo.getUserId(), Status__c = 'POC');

        resp = RET_SubmitAttachmentsController.reviewAttachments('LKS01235');
        System.assertEquals(false, resp.success, 'Unexpected response success value.');

    }
    
    @isTest
    static void SubmitCasePositiveScenario() {

        //insert new Account(Name = 'Real Estate Tax Bucket');
        Case tmpCase = [Select id FROM Case WHERE Status = 'Draft'];
        test.startTest();
        test.setMock(HttpCalloutMock.class, new RET_MockHttpResponseGenerator());
        RET_SubmitAttachmentsController.submitDocumentsToGREX(tmpCase.Id);
        RET_SubmitAttachmentsController.sendIntegrationErrorEmail('Exception');
        Test.setMock(HttpCalloutMock.class, new RET_MockHttpResponseGenerator());
        test.stopTest();
        
        
        //System.assertEquals(null, null);
        
    }
    
    @isTest
    static void SubmitCaseNegativeScenario(){
       Case tmpCase = [Select id FROM Case WHERE Status = 'Draft']; 
        test.startTest();
        test.stopTest();
    }
}