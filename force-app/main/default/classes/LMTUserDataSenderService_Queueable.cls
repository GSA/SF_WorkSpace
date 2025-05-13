/*
*********************************************************
Apex Class Name    : LMTUserDataSenderService_Queueable
Modified Date      : April 15, 2025
@description       : Enqueued to run the LMTUserDataSenderService class with the help of LMTUserDataSenderService_Chunker class
					 It sends the list of users in chunks to EEO for LMT User and LMT User License create/update.
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-15-2025   Disha Bailoor                        Create.
*********************************************************
*/
public class LMTUserDataSenderService_Queueable implements Queueable, Database.AllowsCallouts {
    
    private String jsonDatetime; 
    private String jsonString; 
    private Batch_Process_Log__c log;
    private String QUEUEABLE_NAME = 'LMTUserDataSenderService_Queueable'; 
    private List<Batch_Process_Log__c> completeLog = BatchProcessLogHandler.getCompleteLog(QUEUEABLE_NAME); 
    private Boolean isNewRun = true; 

    public LMTUserDataSenderService_Queueable(){
        this(null, null); 
    }
    
    public LMTUserDataSenderService_Queueable(String jsonDatetime, Batch_Process_Log__c log){
        this.jsonDatetime = jsonDatetime; 
        if(completeLog != null && completeLog.size() > 0){isNewRun = false;}
        if(log == null){
            this.log = BatchProcessLogHandler.logBatchCreate(QUEUEABLE_NAME); 
        }else{
            this.log = log; 
        }  
    }
    
    public void execute(QueueableContext context){ 
        try{
            List<User> userChunk = new List<User>(); 
            Datetime lastLogCreatedDateTime = null; 
            Datetime fromDatetime = null; 
            
            if(String.isNotBlank(jsonDatetime)){fromDatetime = jsonToDatetime(jsonDatetime);}
            
            LMTUserDataSenderService_Chunker chunker = new LMTUserDataSenderService_Chunker(); 
            Integer chunkSize = chunker.getChunkSize();
            Organization org = chunker.getOrgDetails();
            
            if(isNewRun){
                userChunk = chunker.getNextChunk(fromDatetime, chunkSize);
            }else{
                lastLogCreatedDateTime = completeLog[0].CreatedDate; 
                userChunk = chunker.getNextChunkDeltaRun(lastLogCreatedDateTime, fromDatetime, chunkSize); 
            }
            if(userChunk.size() > 0){//any records
                jsonString = datetimeToJson(userChunk[0].CreatedDate);
                LMTUserDataSenderService.sendUserAndOrgData(userChunk, org); //one api call to the service
                log = BatchProcessLogHandler.logBatchStart(log); //log is updated     
            }
            if(userChunk.size() < chunkSize){
                //last run
                log = BatchProcessLogHandler.logBatchSuccess(log); return; 
            }else{
                //chain next job
                //get last user from the created date 
                Datetime dt = userChunk[userChunk.size()-1].CreatedDate; 
                jsonString = datetimeToJson(dt); 
                System.enqueueJob(new LMTUserDataSenderService_Queueable(jsonString, log)); 
            }
        }catch(Exception e){
            String error = e.getMessage() + ' ' + e.getStackTraceString(); 
            if(error.length() >=255){error.substring(0,255); }
            log = BatchProcessLogHandler.logBatchFailure(log, error);
            log.Last_Processed_Iterator__c = jsonString; 
            update log; 
        }        
        
	}
    public static Datetime jsonToDatetime(String jsonStr){
        return (Datetime) JSON.deserialize(jsonStr, Datetime.class); 
    }
    public static String datetimeToJson(Datetime dt){
        return JSON.serialize(dt);
    }
}