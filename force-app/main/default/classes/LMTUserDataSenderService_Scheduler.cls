/*
*********************************************************
Apex Class Name    : LMTUserDataSenderService_Scheduler
Modified Date      : April 15, 2025
@description       : This schedules the LMTUserDataSenderService_Queueable to run.
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-15-2025   Disha Bailoor                        Create.
*********************************************************
*/
global  with sharing class LMTUserDataSenderService_Scheduler implements Schedulable{
    public List<Batch_Process_Log__c> log; 
    private static final String QUEUEABLE_NAME = 'LMTUserDataSenderService_Queueable'; 
    global void execute(SchedulableContext sc){	
        System.enqueueJob(new LMTUserDataSenderService_Queueable()); 
    }
}