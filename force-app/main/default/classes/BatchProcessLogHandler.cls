/*
*********************************************************
Apex Class Name    : BatchProcessLogHandler
Modified Date      : April 07, 2025
@description       : This is the handler class for the Batch Process Log object. 
					 A record is created when an apex batch process is kicked off.  
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-07-2025   Disha Bailoor                        Create.
*********************************************************
*/
public class BatchProcessLogHandler {
    //create an intial log
    public static Batch_Process_Log__c logBatchCreate(String jobName){
        Batch_Process_Log__c log = new Batch_Process_Log__c(); 
        log.Batch_Name__c = jobName; 
        log.Status__c = 'Not Started'; 
        insert log; 
        return log;    
    }
    
    //update the log with 'Running' status
    public static Batch_Process_Log__c logBatchStart(Batch_Process_Log__c log){
        log.Status__c = 'Running';
        log.Start_Date_Time__c = System.now(); 
        update log; 
        return log; 
    }
    
    //update the log when success
    public static Batch_Process_Log__c logBatchSuccess(Batch_Process_Log__c log){
        log.Status__c = 'Completed';
        log.End_Date_Time__c = System.now();
        update log; 
        return log; 
    }
    
    //update the log when failure
    public static Batch_Process_Log__c logBatchFailure(Batch_Process_Log__c log, String errorMessage){
        log.Status__c = 'Failed';
        log.End_Date_Time__c = System.now();
        log.Error__c = errorMessage;  
        update log; 
        return log; 
    }
    //update the log when paused 
    public static Batch_Process_Log__c logBatchPaused(Batch_Process_Log__c log, String jsonStr){
        log.Status__c = 'Paused';
        log.Last_Processed_Iterator__c = jsonStr; 
        update log; 
        return log; 
    }
    //get last paused log
    public static List<Batch_Process_Log__c> getPausedLog(String jobName){
        return [SELECT Id, Batch_Name__c, Error__c, Last_Processed_Iterator__c, Status__c, CreatedDate
                FROM Batch_Process_Log__c
                WHERE Batch_Name__c = :jobName AND Status__c = 'Paused' 
                WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1
               ]; 
    }
    //get last failed log
    public static List<Batch_Process_Log__c> getFailedLog(String jobName){
        return [SELECT Id, Batch_Name__c, Error__c, Last_Processed_Iterator__c, Status__c, CreatedDate
                FROM Batch_Process_Log__c
                WHERE Batch_Name__c = :jobName AND Status__c = 'Failed' 
                WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1
               ]; 
    }
    //get last successful log
    public static List<Batch_Process_Log__c> getCompleteLog(String jobName){
        return [SELECT Id, Batch_Name__c, Error__c, Last_Processed_Iterator__c, Status__c, CreatedDate
                FROM Batch_Process_Log__c
                WHERE Batch_Name__c = :jobName AND Status__c = 'Completed' 
                WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 1]; 
    }
}