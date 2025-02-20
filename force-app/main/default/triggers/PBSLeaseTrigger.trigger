trigger PBSLeaseTrigger on PBS_Lease__c (before insert, before update, before delete, after insert, after update, after delete) {
    PBSLeaseTriggerHelper helper = new PBSLeaseTriggerHelper();
    if (Trigger.isBefore && Trigger.isinsert){
        helper.OnBeforeInsert(trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate){
        helper.OnBeforeUpdate(trigger.new, trigger.oldMap);
    }
    if (Trigger.isbefore && Trigger.isDelete){
        
    }
    if (Trigger.isafter && Trigger.isinsert){
        helper.OnAfterInsert(trigger.new);
    }
    if (Trigger.isafter && Trigger.isUpdate){
        
    }
    if (Trigger.isafter && Trigger.isDelete){
        
    }

}