/*
*********************************************************
Apex Class Name    : LMTUserDataSenderService_Chunker
Modified Date      : April 09, 2025
@description       : This class creates chunks of users based on the LMT_Configs custom metadata batch size
					 and sends it over to the LMTUserDataSenderService_Queueable. 
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-09-2025   Disha Bailoor                        Create.
*********************************************************
*/
public class LMTUserDataSenderService_Chunker {  
    private static String BATCH_NAME = 'LMTUserDataSenderService_Queueable'; 
    private static final Integer DEFAULT_CHUNK_SIZE = 200; 
    public static Integer chunkSize; 
    private static final Integer DEFAULT_REQUEST_TIMEOUT = 120000; 
    public static Integer requestTimeout; 
    public static List<LMT_Configuration__mdt> LMT_Configs; 
    
    public LMTUserDataSenderService_Chunker(){//constructor
        LMT_Configs = [SELECT Label, Batch_Size__c, Batch_Request_Timeout__c 
                       FROM LMT_Configuration__mdt 
                       WHERE Label = :BATCH_NAME 
                       WITH USER_MODE LIMIT 1];
        chunkSize = DEFAULT_CHUNK_SIZE; 
        requestTimeout = DEFAULT_REQUEST_TIMEOUT; 
    }
    public Integer getChunkSize(){
        if(LMT_Configs.size() > 0){
            chunkSize = Integer.valueOf(LMT_Configs[0].Batch_Size__c);  
            if(chunkSize == null || chunkSize <= 0){ chunkSize = DEFAULT_CHUNK_SIZE;}
        }
        return chunkSize; 
    }
    //set all queries to either system mode or user mode. This is for isNew
    public List<User> getNextChunk(DateTime fromDate, Integer chunkSize){
        System.debug('Test Running: ' + fromDate + ' chunkSize: ' + chunkSize); 
        if(fromDate == null){
            return [SELECT Id, FederationIdentifier, User_License__c, IsActive, Email, LastLoginDate, CreatedDate
                	FROM User 
                    WHERE IsActive = TRUE AND User_License__c != NULL 
                    WITH USER_MODE ORDER BY CreatedDate ASC LIMIT :chunkSize]; 
        }else{
            //could be returning an empty list here
            return [SELECT Id, FederationIdentifier, User_License__c, IsActive, Email, LastLoginDate, CreatedDate 
                	FROM User 
                    WHERE CreatedDate >= :fromDate AND IsActive = TRUE AND User_License__c != NULL 
                    WITH USER_MODE ORDER BY CreatedDate ASC LIMIT :chunkSize]; 
        }
    }
    //this is for the delta run
    public List<User> getNextChunkDeltaRun(Datetime lastLogCreatedDateTime, DateTime fromDate, Integer chunkSize){
        System.debug('Test Running: ' + fromDate + ' chunkSize: ' + chunkSize); 
        if(fromDate == null){//first chunk
            return [SELECT Id, FederationIdentifier, User_License__c, IsActive, Email, LastLoginDate, CreatedDate
                	FROM User 
                    WHERE (LastModifiedDate >= :lastLogCreatedDateTime OR LastLoginDate >= :lastLogCreatedDateTime)
                    AND User_License__c != NULL WITH USER_MODE ORDER BY CreatedDate ASC LIMIT :chunkSize]; 
        }else{//every other chunk
            //could be returning an empty list here
            return [SELECT Id, FederationIdentifier, User_License__c, IsActive, Email, LastLoginDate, CreatedDate
                	FROM User 
                    WHERE (LastModifiedDate >= :lastLogCreatedDateTime OR LastLoginDate >= :lastLogCreatedDateTime)
                    AND CreatedDate >= :fromDate AND User_License__c != NULL 
                    WITH USER_MODE ORDER BY CreatedDate ASC LIMIT :chunkSize]; 
        }
    }
    public Organization getOrgDetails(){
        return [SELECT Id, Name FROM Organization WITH USER_MODE LIMIT 1]; 
    }
    public Integer getRequestTimeout(){
        if(LMT_Configs.size() > 0){
            requestTimeout = Integer.valueOf(LMT_Configs[0].Batch_Request_Timeout__c);  
            if(requestTimeout == null || requestTimeout <= 0){ requestTimeout = DEFAULT_REQUEST_TIMEOUT;}
        }
        return requestTimeout; 
    }
}