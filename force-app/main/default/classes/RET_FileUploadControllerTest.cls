@isTest(SeeAllData=false)
public class RET_FileUploadControllerTest {
    @testsetup static void createData(){
        PBS_Lease__c newPBS = new PBS_Lease__c(Lease_Number__c='62383', Name ='98462383Test', Lease_Effective_Date__c = date.today(), Lease_Expiration_Date__c = date.today().adddays(365));
        Insert newPBS;
    
        Case recCase = new case(origin='Web',Status='Submitted',PBS_Lease__c =newPBS.ID);
        Insert recCase;
        
        Attachment recAtt =new Attachment(parentid=recCase.Id,name='Bill desk',body=Blob.valueOf('Unit Test Attachment Body'));
        Insert recAtt;
        
        RET_Document_Data__c recRET = new RET_Document_Data__c(Attachment_ID__c =recAtt.Id,name ='test ret', Full_File_Name__c= 'ret test', Tax_Year__c ='2017',Document_Type__c ='Real Estate Tax - Bill');
        Insert recRET;

        List<RET_Document_Data__c> RETdoclst = [select id from RET_Document_Data__c];
        system.assertEquals(1,RETdoclst.size());
    }
    @isTest static void testNewAttachmentCreationWithNoExisting(){
        PageReference pageRef = Page.RET_FileUpload;
        Test.setCurrentPage(pageRef);
        RET_FileUploadController controller = new RET_FileUploadController();
        System.assertNotEquals(false,controller.showUpload);
        System.assertEquals('{}',controller.docMapValues);
        System.assertEquals(false,controller.docMapValues.containsignorecase('Real Estate Tax - Bill'));
        System.assertEquals(null,controller.leaseNumber);
        System.assertEquals(null,controller.attID);
        System.assertEquals('',controller.caseId);
    }
    @istest static void testEditExitingAtt(){
        PageReference pageRef = Page.RET_FileUpload;
        Test.setCurrentPage(pageRef);
        Attachment recAtt = [select Id,ParentId from Attachment limit 1];
        ApexPages.currentPage().getParameters().put('caseId', recAtt.parentId);
        ApexPages.currentPage().getParameters().put('attachmentId', recAtt.Id);
        RET_FileUploadController controller = new RET_FileUploadController();
        System.assertEquals(false,controller.showUpload);
        System.assertEquals('{"Real Estate Tax - Bill":1}',controller.docMapValues);
        System.assertEquals(true,controller.docMapValues.containsignorecase('Real Estate Tax - Bill'));
        System.assertEquals('62383',controller.leaseNumber);
        System.assertEquals(recAtt.Id,controller.attID);
        System.assertEquals(recAtt.ParentId,controller.caseId);
    }
}