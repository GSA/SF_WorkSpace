trigger UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    public Trigger_Settings__mdt triggerMeta = new Trigger_Settings__mdt();
    Boolean isSetDefaultUserPermissionsActive = true;
    Boolean isSetSPHDUserPermissionsActive = true;
    
    try { 
        for (Trigger_Settings__mdt triggerMeta : [Select DeveloperName, isActive__c, ObjectName__c, Recursion_Check__c, Max_Loop_Count__c 
                                                  from Trigger_Settings__mdt 
                                                  where DeveloperName IN ('Set_Default_User_Permissions', 'Set_SPHD_User_Permissions') LIMIT 2]) {
            if (triggerMeta.DeveloperName == 'Set_Default_User_Permissions') {
                isSetDefaultUserPermissionsActive = triggerMeta.isActive__c;
            }
            if (triggerMeta.DeveloperName == 'Set_SPHD_User_Permissions') {
                isSetSPHDUserPermissionsActive = triggerMeta.isActive__c;
            }
        }
    } catch (Exception e) { 
        //User Trigger methods below will run by default (booleans are defaulted TRUE above) if Trigger Framework MDT retrieve failed for some reason here
    }

    if(Trigger.isAfter && Trigger.isInsert) {
        if (isSetDefaultUserPermissionsActive) {
            UserTriggerHandler.assignDefaultPermissions(Trigger.newMap);
        }
        if (isSetSPHDUserPermissionsActive) {
            UserTriggerHandler.assignSPHDPermissions(Trigger.newMap);
            UserTriggerHandler.insertSPHDGroupMembers(Trigger.newMap);
        }
    }
        
    if(Trigger.isBefore && Trigger.isUpdate) {
        if (isSetDefaultUserPermissionsActive) {
            UserTriggerHandler.syncForCastIronUser(Trigger.new, Trigger.oldMap);
        }
        if (isSetSPHDUserPermissionsActive) {
            UserTriggerHandler.syncForSPHDUser(Trigger.new, Trigger.oldMap);
        }
    }        
    
}