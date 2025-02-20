trigger PBS_Project_Trigger on PBS_Project__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    public Trigger_Settings__mdt triggerMeta = new Trigger_Settings__mdt();
    Boolean isTriggerActive = false;
    
    try { 
            triggerMeta = [Select DeveloperName, isActive__c, ObjectName__c, Recursion_Check__c, Max_Loop_Count__c 
                           from Trigger_Settings__mdt where DeveloperName='PBS_Project' LIMIT 1];
             isTriggerActive = triggerMeta.isActive__c; }     catch (Exception e) { isTriggerActive = true; }

        if ( !isTriggerActive ) { return; }
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            PBS_Project_TriggerHandler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
        }        
}