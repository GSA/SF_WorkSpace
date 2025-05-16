/*
*********************************************************
Apex Class Name    : LMT_PermSetAssignmentHandler_Scheduler
Created Date       : February 12, 2025
@description       : This is the scheduler class to update CRM permissioning on the LMT User/LMT User License records.
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   02-12-2025   Disha Bailoor                        Create.
*********************************************************
*/

global  with sharing class LMT_PermSetAssignmentHandler_Scheduler implements schedulable{
    public static final Integer DEFAULT_BATCH_SIZE = 200; 
	Integer batch_size = DEFAULT_BATCH_SIZE; 
    global void execute(SchedulableContext sc){
        List<LMT_Configuration__mdt> LMT_Configs = [SELECT Label, Batch_Size__c 
                                                        FROM LMT_Configuration__mdt 
                                                        WHERE Label =: 'LMT_PermSetAssignmentHandler_Batch' 
                                                        LIMIT 1];
        if(LMT_Configs != null || LMT_Configs.size() > 0){
        	batch_size = LMT_Configs[0].Batch_Size__c.intValue();   
            if(batch_size == null || batch_size <= 0){ batch_size = DEFAULT_BATCH_SIZE;}
        }
		database.executebatch(new LMT_PermSetAssignmentHandler_Batch(),batch_size);
    }
}