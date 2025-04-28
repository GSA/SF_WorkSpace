@isTest
public class PBS_AAAP_RelatedContentControllerTest {
    
    @testSetup
    static void createTestData() {
        ContentNote cn = new ContentNote();
        cn.Title = 'testTitle';
        cn.Content = Blob.valueOf('testContent');
        insert cn;
    }
    
    @isTest
    static void createNRecordTest() {
        PBS_AAAP_UNIT_TEST_DATA_GENERATOR dataGen1 = new PBS_AAAP_UNIT_TEST_DATA_GENERATOR();
        PBS_AAAP_Agency_Requirement__c agency = dataGen1.insertAgency();
        
        ContentNote cn = new ContentNote();
        cn.Title = 'testTitle';
        cn.Content = Blob.valueOf('testContent');
        
        Test.startTest();
        PBS_AAAP_RelatedContentController.createNRecord(cn, agency.Id);
        List<PBS_AAAP_RelatedContentController.RelatedContentWrapper> wrap = PBS_AAAP_RelatedContentController.getRelatedContent(agency.Id);
        Test.stopTest();
        List<ContentDocumentLink> cnList = [SELECT id, ContentDocumentId, ContentDocument.FileType from ContentDocumentLink where LinkedEntityId = :agency.Id];
        System.assertEquals(cnList.size(), 1);
    }
    
    @isTest
    static void updateNoteRecordTest() {
        List<ContentNote> cnList = [Select id, Title from ContentNote Limit 1];
        cnList[0].Title = 'Abc';
        Test.startTest();
        PBS_AAAP_RelatedContentController.updateNoteRecord(cnList[0], cnList[0].Id);
        Test.stopTest();
        List<ContentNote> cnList1 = [Select id, Title from ContentNote];
        system.assertNotEquals(cnList1[0].Title, 'testTitle');
    }
    
    @isTest
    static void deleteNoteRecordTest() {
        List<ContentNote> cnList = [Select id, Title from ContentNote Limit 1];
        Test.startTest();
        PBS_AAAP_RelatedContentController.deleteNoteRecord(cnList[0].Id);
        Test.stopTest();
        List<ContentNote> cnList1 = [Select id, Title from ContentNote Where id = :cnList[0].Id];
        system.assertEquals(cnList1.size(), 0);
    }
    
    @isTest
    static void getNoteRecordTest() {
        List<ContentNote> cnList = [Select id, Title from ContentNote Limit 1];
        Test.startTest();
        PBS_AAAP_RelatedContentController.ContentNoteWrapperClass wrap = PBS_AAAP_RelatedContentController.getNoteRecord(cnList[0].Id);
        Test.stopTest();
        system.assertEquals(wrap.title, cnList[0].Title);
    }
}