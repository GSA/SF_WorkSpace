/*
*********************************************************
Apex Class Name    : LMT_PermSetInitialSync_Batch
Created Date       : February 12, 2025
@description       : This batch class calls the LMT_PermSetInitialSyncHandler to 
					 update the modified LMT User License records based on related User record. 
                     It updates the CRM permission set assignment checkbox on the related LMT User License object. 
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-15-2025   Disha Bailoor                        Create.
*********************************************************
*/

global  with sharing class LMT_PermSetInitialSync_Batch implements Database.batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    global  String query;
    Datetime daysAgo; 
    public Batch_Process_Log__c log; 
    String BATCH_NAME = 'LMT_PermSetInitialSync_Batch'; 
     
    //Constructor which will be invoked by the scheduler
    global LMT_PermSetInitialSync_Batch(){  
		List<Batch_Process_Log__c> batchLogs = [
            SELECT Id, Batch_Name__c, Start_Date_Time__c, CreatedDate 
            FROM Batch_Process_Log__c 
            WHERE Batch_Name__c = :BATCH_NAME 
            	AND Status__c = 'Completed' 
            WITH USER_MODE
            ORDER BY CreatedDate DESC NULLS LAST 
            LIMIT 1];
        System.debug(batchLogs); 
        query = 'SELECT Id, FederationIdentifier, User_License__c, IsActive, Email, LastLoginDate, CreatedDate FROM User WHERE isActive = TRUE AND User_License__c != NULL ORDER BY CreatedDate ASC';  
       	if(Test.isRunningTest()){
            query += ' Limit 10';
        } 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        log = BatchProcessLogHandler.logBatchCreate(BATCH_NAME);
        log = BatchProcessLogHandler.logBatchStart(log); 
        return Database.getQueryLocator(query);
    }
    
    global  void execute(Database.BatchableContext BC, List<User> users){
        try{
            LMT_PermSetInitialSyncSenderService permSetHandler = new LMT_PermSetInitialSyncSenderService(); 
        	permSetHandler.processCRMAssignments(users);    
        }catch(Exception e){BatchProcessLogHandler.logBatchFailure(log, e.getMessage()); throw e;}   
    }
    
    global  void finish(Database.BatchableContext BC){
         if(log != null){
            BatchProcessLogHandler.logBatchSuccess(log); 
        }
    }
    
}