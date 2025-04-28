trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete) {
    CaseTriggerHelper helper = new CaseTriggerHelper();
    
    if (Trigger.isafter && Trigger.isinsert){
        helper.OnAfterInsertRETCases(trigger.new);
        
    }
    if (Trigger.isafter && Trigger.isUpdate){
        
    }
    if (Trigger.isafter && Trigger.isDelete){
        
    }
    if (Trigger.isBefore && Trigger.isinsert){
      
    }
    if (Trigger.isBefore && Trigger.isUpdate){
        
    }
    if (Trigger.isbefore && Trigger.isDelete){
        
    }

}