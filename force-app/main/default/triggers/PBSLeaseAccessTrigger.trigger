trigger PBSLeaseAccessTrigger on PBS_Lease_Access__c (before insert, before update, before delete, after insert, after update, after delete) {
    PBSLeaseAccessTriggerHelper helper = new PBSLeaseAccessTriggerHelper();
    if (Trigger.isBefore && Trigger.isinsert){
        //Before insert trigger logic goes here
        helper.OnBeforeInsert(trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate){
        //Before update trigger logic goes here
        helper.OnBeforeUpdate(trigger.new, Trigger.oldMap);
    }
    if (Trigger.isBefore && Trigger.isDelete){
        helper.OnBeforeDelete(trigger.old);
    }
}