@IsTest(SeeAllData=false)
public class RET_DocumentsListControllerTest {
    @testSetup static void createTestData() {
        PBS_Lease__c newPBS = new PBS_Lease__c(Lease_Number__c='98462383', Name ='98462383Test', Lease_Effective_Date__c = date.today(), Lease_Expiration_Date__c = date.today().adddays(365));
        Insert newPBS;
    
        Case recCase = new case(origin='Web',Status='Submitted',PBS_Lease__c =newPBS.ID);
        Insert recCase;
        
        List<Attachment> collAtt = new List<Attachment>();
        collAtt.add(new Attachment(parentid=recCase.Id,name='98462383 - Real Estate Tax - Bill(2017)_1.pdf',body=Blob.valueOf('Unit Test Attachment Body')));
        collAtt.add(new Attachment(parentid=recCase.Id,name='98462383 - Proof of Ownership(2016)_1.pdf',body=Blob.valueOf('Unit Test Attachment Body1')));
        collAtt.add(new Attachment(parentid=recCase.Id,name='98462383 - Proof of Ownership(2016)_2.pdf',body=Blob.valueOf('Unit Test Attachment Body2')));
        Insert collAtt;
        
        List<RET_Document_Data__c> collRet = new List<RET_Document_Data__c>();
        collRet.add(new RET_Document_Data__c(Attachment_ID__c =collAtt[0].Id,name ='test ret', Full_File_Name__c='98462383 - Real Estate Tax - Bill(2017)_1.pdf',Tax_Year__c ='2017',Document_Type__c ='Real Estate Tax - Bill'));
        collRet.add(new RET_Document_Data__c(Attachment_ID__c =collAtt[1].Id,name ='test ret1', Full_File_Name__c='98462383 - Proof of Ownership(2016)_1.pdf',Tax_Year__c ='2016',Document_Type__c ='Proof of Ownership'));
        collRet.add(new RET_Document_Data__c(Attachment_ID__c =collAtt[2].Id,name ='test ret2', Full_File_Name__c='98462383 - Proof of Ownership(2016)_2.pdf',Tax_Year__c ='2016',Document_Type__c ='Proof of Ownership'));
        Insert collRet;

        List<RET_Document_Data__c> collRetlst = [Select id from RET_Document_Data__c];
        system.assertEquals(3,collRetlst.size());

    }

    @isTest static void testgeturls(){
        List<case> collCase = [select id from case];
        Map<String,String> url = RET_DocumentsListController.getUrls(collCase[0].id);
        System.assertEquals(3, url.size());
    }
    
    @isTest static void testPositiveDelete(){
        List<case> collCase = [select id from case];
        System.assertNotEquals(null, collCase);
        System.assertEquals(1, collCase.size());
        List<RET_Document_Data__c> collRet = [select id from RET_Document_Data__c];
        System.assertNotEquals(null, collRet);
        System.assertEquals(3, collRet.size());
        List<Attachment> collAtt = [select id from Attachment];
        System.assertNotEquals(null, collAtt);
        System.assertEquals(3, collAtt.size());
        RET_DocumentsListController.deleteSelectedDocument(collAtt[0].Id,collCase[0].Id);
        collCase = [select id from case];
        System.assertEquals(1, collCase.size());
        collRet = [select id from RET_Document_Data__c];
        System.assertEquals(2, collRet.size());
        collAtt = [select id from Attachment];
        System.assertEquals(2, collAtt.size());
        System.debug(RET_DocumentsListController.getHostName());
    }
    @isTest static void testNegativeDelete(){
        List<case> collCase = [select id from case];
        System.assertEquals(1, collCase.size());
        Try{
            RET_DocumentsListController.deleteSelectedDocument(collCase[0].Id,collCase[0].Id);
        }catch(exception e){
            System.assertEquals('Script-thrown exception', e.getMessage(),e.getMessage());
        }
    }


}