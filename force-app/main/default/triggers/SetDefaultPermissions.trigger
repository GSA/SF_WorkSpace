trigger SetDefaultPermissions on User (after insert, after update, after delete, before update) {
    Map<Id,User> newUserMap = Trigger.newMap;
    List<String> serializedNewUsers = new List<String>();

    for(id userId : newUserMap.keySet()){
        User processUser = newUserMap.get(userId);
        String serializedNewUser = JSON.serialize(processUser);
        serializedNewUsers.add(serializedNewUser);
    }

    Map<Id,User> oldUserMap;
    if(Trigger.oldMap != NULL){
        oldUserMap = Trigger.oldMap;    
    } else{
        oldUserMap = new Map<Id,User>();
    }
    List<String> serializedOldUsers = new List<String>();
    
    for(id userId : oldUserMap.keySet()){
        User processUser = oldUserMap.get(userId);
        String serializedOldUser = JSON.serialize(processUser);
        serializedOldUsers.add(serializedOldUser);
    }
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        PermissionSetUtil.assignPermissionSetsToUsers(Trigger.newMap);
        /*
        //LMT Code
        Set<Id> userIds = new Set<Id>();
        for (User curr: trigger.new){
            if (curr.Profile.UserLicense.Name == 'Salesforce' ||  curr.Profile.UserLicense.Name == 'Salesforce Platform' ||  curr.Profile.UserLicense.Name == 'Chatter Free'){
                userIds.add(curr.Id);
            }
        }
        if (userIds.size() > 1){
            UserTriggerHandler.UpdateLicenseInformationObject(userIds);
        }
    }
    else if(Trigger.isUpdate && Trigger.isAfter)
    {   
        if(!system.isFuture()){
            PermissionSetUtil.updatePermissionSetsToUsers(serializedNewUsers,serializedOldUsers);
            //LMT Code
            Set<Id> userIds = new Set<Id>();
            for (User curr: trigger.new){
                if(UserInfo.getUserName() != LABEL.Cast_Iron_User){
                    userIds.add(curr.Id);
                }
            }
            UserTriggerHandler.UpdateLicenseInformationObject(userIds);
        }
    */
    }
        else if(Trigger.isUpdate && Trigger.isBefore){
        userTriggerHandler handler = new userTriggerHandler();
        handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
    /* Delete is not allowed on user object so this has been commented
        else if(Trigger.isDelete)
        {
            PermissionSetUtil.removePermissionSetsToUsers(Trigger.oldMap);
        }
    */    
}