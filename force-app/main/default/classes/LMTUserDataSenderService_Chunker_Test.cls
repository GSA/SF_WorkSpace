@isTest
public class LMTUserDataSenderService_Chunker_Test {
    @isTest
    static void testGetNextChunk(){
     	Datetime fromDatetime = null;
		Integer chunkSize = null; 
        Integer requestTimeout = null; 
        List<LMT_Configuration__mdt> LMT_Configs; 
        Test.startTest(); 
        LMTUserDataSenderService_Chunker testChunk = new LMTUserDataSenderService_Chunker();
        List<User> users1 = testChunk.getNextChunk(fromDatetime, testChunk.getChunkSize());
        System.debug('users1: ' + users1); 
        Test.stopTest(); 
        Assert.isNotNull(users1); 
    }
    @isTest
    static void testGetNextChunkTwo(){
     	String dt = '2008-07-28T13:25:25.000+0000'; 
		DateTime fromDatetime = (DateTime)Json.deserialize('"'+dt+'"', DateTime.class);
		Integer chunkSize = null; 
        Test.startTest(); 
        LMTUserDataSenderService_Chunker testChunk = new LMTUserDataSenderService_Chunker();
        List<User> users1 = testChunk.getNextChunk(fromDatetime, testChunk.getChunkSize());
        System.debug('users1: ' + users1); 
        Test.stopTest(); 
        Assert.isNotNull(users1); 
    }
    @isTest
    static void testGetChunkSizeAndGetRequestTimeout(){
        Test.startTest(); 
        LMTUserDataSenderService_Chunker testChunk = new LMTUserDataSenderService_Chunker();
        Integer chunkSize = testChunk.getChunkSize();
        Integer requestTimeout = testChunk.getRequestTimeout();
        System.debug('chunkSize: ' + chunkSize); 
        System.debug('requestTimeout: ' + requestTimeout); 
        Test.stopTest(); 
        List<LMT_Configuration__mdt> LMT_Configs = [SELECT Label, Batch_Size__c, Batch_Request_Timeout__c 
                                                    FROM LMT_Configuration__mdt 
                                                    WHERE Label = 'LMTUserDataSenderService_Queueable' 
                                                    WITH USER_MODE LIMIT 1];
        if(LMT_Configs.size() != 0){
            Assert.areEqual(chunkSize, LMT_Configs[0].Batch_Size__c, 'Chunk Size is working!'); 
            Assert.areEqual(requestTimeout, LMT_Configs[0].Batch_Request_Timeout__c, 'Request Timeout is working!');
        }else{
            Assert.areEqual(chunkSize, 200, 'Default chunk Size is working!'); 
            Assert.areEqual(chunkSize, 120000, 'Default request timeout is working!');
        }
            
    }
    @isTest
    static void testGetOrgDetails(){
        Test.startTest();
        LMTUserDataSenderService_Chunker testChunk = new LMTUserDataSenderService_Chunker();
        Organization org = testChunk.getOrgDetails(); 
        Test.stopTest();
        Assert.isNotNull(org); 
    }
    @isTest
    static void testGetNextChunkDeltaRun(){
        String dt = '2008-07-28T13:25:25.000+0000'; 
		DateTime fromDatetime = (DateTime)Json.deserialize('"'+dt+'"', DateTime.class);
        DateTime dt1 = (DateTime)Json.deserialize('"'+dt+'"', DateTime.class);
		Integer chunkSize = null; 
        Test.startTest(); 
        LMTUserDataSenderService_Chunker testChunk = new LMTUserDataSenderService_Chunker();
        List<User> users1 = testChunk.getNextChunkDeltaRun(dt1, fromDatetime, testChunk.getChunkSize());
        System.debug('users1: ' + users1); 
        Test.stopTest(); 
        Assert.isNotNull(users1); 
    }
    @isTest
    static void testGetNextChunkDeltaRunTwo(){
        String dt = '2008-07-28T13:25:25.000+0000'; 
        DateTime dt1 = (DateTime)Json.deserialize('"'+dt+'"', DateTime.class);
		Integer chunkSize = null; 
        Test.startTest(); 
        LMTUserDataSenderService_Chunker testChunk = new LMTUserDataSenderService_Chunker();
        List<User> users1 = testChunk.getNextChunkDeltaRun(dt1, null, testChunk.getChunkSize());
        System.debug('users1: ' + users1); 
        Test.stopTest(); 
        Assert.isNotNull(users1); 
    }
}