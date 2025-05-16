/*
*********************************************************
Apex Class Name    : LMT_PermSetInitialSync_Scheduler
Created Date       : April 14, 2025
@description       : This is the scheduler class for the initial sync to update
					 CRM permissioning on the LMT User/LMT User License records.
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-14-2025   Disha Bailoor                        Create.
*********************************************************
*/

global  with sharing class LMT_PermSetInitialSync_Scheduler implements Schedulable{
    private static final Integer DEFAULT_BATCH_SIZE = 200; 
    Integer batch_size = DEFAULT_BATCH_SIZE; 
    global void execute(SchedulableContext sc){
        List<LMT_Configuration__mdt> LMT_Configs = [SELECT Label, Batch_Size__c 
                                                        FROM LMT_Configuration__mdt 
                                                        WHERE Label =: 'LMT_PermSetInitialSync_Batch' 
                                                        LIMIT 1];
        if(LMT_Configs != null || LMT_Configs.size() == 0){
        	batch_size = LMT_Configs[0].Batch_Size__c.intValue();  
            if(batch_size == null || batch_size <= 0){ batch_size = DEFAULT_BATCH_SIZE; }
        }
		database.executebatch(new LMT_PermSetInitialSync_Batch(),batch_size);
    }
}