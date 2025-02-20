trigger NCMT_TCO_Lifecycle_Input_trigger on NCMT_TCO_Lifecycle_Input__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    System.debug('RUN LIFECYCLE INPUT TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
if (!NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate){  
        NCMT_TCO_Lifecycle_Input_TriggerHandler handler = new NCMT_TCO_Lifecycle_Input_TriggerHandler(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        
        if (Trigger.isBefore &&(Trigger.isInsert || Trigger.isUpdate))
            handler.beforeLogic();    

        if (Trigger.isAfter &&(Trigger.isInsert || Trigger.isUpdate))
            handler.manageLCC();    
    }   
}
}