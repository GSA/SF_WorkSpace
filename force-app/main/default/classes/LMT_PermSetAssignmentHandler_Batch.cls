/*
*********************************************************
Apex Class Name    : LMT_PermSetAssignmentHandler_Batch
Created Date       : February 12, 2025
@description       : This batch class calls the LMT_PermissionSetAssignmentHandler to 
					 update the modified LMT User License records based on the Setup Audit Trail within the 
					 past 24 hours. It updates the CRM permission set assignment checkbox on the related LMT User object. 
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   02-12-2025   Disha Bailoor                        Create.
*********************************************************
*/

global  with sharing class LMT_PermSetAssignmentHandler_Batch implements Database.batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    global  String query;
    Integer numberOfDays = 180;
    String psAssign = 'PermSetAssign'; 
    String psUnassign = 'PermSetUnassign'; 
    Datetime daysAgo;
    public Batch_Process_Log__c log; 
    String BATCH_NAME = 'LMT_PermSetAssignmentHandler_Batch'; 
     
    //Constructor which will be invoked by the scheduler
    global LMT_PermSetAssignmentHandler_Batch(){  
        List<Batch_Process_Log__c> batchLogs = [SELECT Id, Batch_Name__c, Start_Date_Time__c, CreatedDate
                                                  FROM Batch_Process_Log__c 
                                                  WHERE Batch_Name__c = :BATCH_NAME 
                                                        AND Status__c = 'Completed'
                                                        ORDER BY Start_Date_Time__c DESC NULLS LAST LIMIT 1];
        if(batchLogs == null || batchLogs.size() == 0){//max set up audit trail
            daysAgo = System.Now()-numberOfDays;
        }else{
            daysAgo = batchLogs[0].CreatedDate;
        }

        query = 'SELECT Id, Display FROM SetupAuditTrail WHERE (Action =: psAssign OR Action =: psUnassign) AND CreatedDate > :daysAgo WITH USER_MODE';  
        
        if(Test.isRunningTest()){
            query += ' Limit 10';
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC){  
        log = BatchProcessLogHandler.logBatchCreate(BATCH_NAME);
        log = BatchProcessLogHandler.logBatchStart(log);
        return Database.getQueryLocator(query);
    }
    
    global  void execute(Database.BatchableContext BC, List<SetupAuditTrail> auditTrails){
        try{ 
            LMT_PermSetAssignmentSenderService permSetHandler = new LMT_PermSetAssignmentSenderService();
        	permSetHandler.processPermissionSetAssignments(auditTrails);
            
        }catch(Exception e){BatchProcessLogHandler.logBatchFailure(log, e.getMessage()); throw e;}  
    }
    
    
    global  void finish(Database.BatchableContext BC){
        if(log != null){
            BatchProcessLogHandler.logBatchSuccess(log); 
        }
    }
    
}