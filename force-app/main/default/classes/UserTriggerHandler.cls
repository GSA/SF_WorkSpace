public with sharing class UserTriggerHandler {

    public static void assignDefaultPermissions(Map<Id, User> newUsers) 
    {
        PermissionSetUtil.assignDefaultPermissionSetsToUsers(newUsers);
    }

    public static void assignSPHDPermissions(Map<Id, User> newUsers) 
    {
        PermissionSetUtil.assignSPHDPermissionSetsToUsers(newUsers);
    }

    public static void syncForCastIronUser(User[]updatedUsers, Map<Id,User> oldMap) 
    {
        for(User updatedUser : updatedUsers)
        {
            User oldUser = oldMap.get(updatedUser.Id);
            if(UserInfo.getUserName() == LABEL.Cast_Iron_User && updatedUser.ProfileId != oldUser.ProfileId)
            {
                updatedUser.ProfileId = oldUser.ProfileId;
            }
            if(UserInfo.getUserName() == LABEL.Cast_Iron_User && updatedUser.CommunityNickname != oldUser.CommunityNickname)
            {
                updatedUser.CommunityNickname = oldUser.CommunityNickname;
            }
            if(UserInfo.getUserName() == LABEL.Cast_Iron_User && updatedUser.Username != oldUser.Username)
            {
                updatedUser.Username = oldUser.Username;
            }
        }
    }
    
    public static void syncForSPHDUser(User[] updatedUsers, Map<Id,User> oldMap) 
    {
        System.debug('UserTriggerHandler.syncForSPHDUser() starting...');
        List<String> sphdLicenseList = getSPHDLicenseList();
        Map<Id, User> addAccessMap = new Map<Id, User>();
        Map<Id, User> removeAccessMap = new Map<Id, User>();
        for(User updatedUser : updatedUsers) {
            User oldUser = oldMap.get(updatedUser.Id);
            //Only perform sync up for SPHD permissions and group membership if Major_Org__c changed 
            if(updatedUser.Major_Org__c == oldUser.Major_Org__c)
            {
                //Nothing to sync up for this user so skip this user
            }
            else
            {
                //If changedUser has Major_Org__c = 'P' then assign SPHD permissions and group membership
                if(updatedUser.Major_Org__c == 'P') {
                    addAccessMap.put(updatedUser.Id, updatedUser);
                } else{
                    removeAccessMap.put(updatedUser.Id, updatedUser);
                }
            }
        }
        if (addAccessMap.size() > 0) {
            System.debug('addAccessMap: ' + addAccessMap);
            assignSPHDPermissions(addAccessMap);
            insertSPHDGroupMembers(addAccessMap);
        }
        if (removeAccessMap.size() > 0) {
            System.debug('removeAccessMap:' + removeAccessMap);
            removeSPHDPermissions(removeAccessMap);
            removeSPHDGroupMembers(removeAccessMap.KeySet());
        }
    }
    
    public static void insertSPHDGroupMembers(Map<Id,User> userMap) 
    {
        List<String> sphdLicenseList = getSPHDLicenseList();
        List<String> listGrpMembersToInsert = new List<String>();
        Group SPHDManagerGroup = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName = 'SPHD_Manager' LIMIT 1];
        for(Id userId :userMap.KeySet()) 
        {
            User user = userMap.get(userId);
            if( user.IsActive && user.MAJOR_ORG__c == 'P' && sphdLicenseList.contains(user.User_License__c) )
            {
                listGrpMembersToInsert.add(JSON.serialize(new GRPMemberHelper(SPHDManagerGroup.Id, user.Id)));
            }
        }
        if(listGrpMembersToInsert.size() > 0)  
        {      
            createGroupMembers(listGrpMembersToInsert);
        }

    }        

    public static List<String> getSPHDLicenseList()
    {
        List<String> sphdLicenses = getUserProvisioningUtilValuesByType('SPHDUserLicense');
        System.debug('UserTriggerHandler.getSPHDLicenseList(), SPHD user license list: ' + sphdLicenses);
        return sphdLicenses;
    }

    public static List<String> getUserProvisioningUtilValuesByType(String type)
    {
        List<String> values = new List<String>();
        if(PublicGroupUserSyncHelper.isTestMethod)
        {
            List<UserTestProvisioningUtil__c> userProvisioningValues = [select Name from UserTestProvisioningUtil__c where type__c = :type];
            for(UserTestProvisioningUtil__c value: userProvisioningValues )
            {
                values.add(value.Name);
            }
        }
        else
        {
            List<UserProvisioningUtil__c> userProvisioningValues = [select Name from UserProvisioningUtil__c where type__c = :type];
            for(UserProvisioningUtil__c value: userProvisioningValues )
            {
                values.add(value.Name);
            }
        }
        return values;
    } 
    
    public static void createGroupMembers(List<String> membersSer) 
    {
        GrpMemberhelper gm = null;
        List<GroupMember> grpList = new List<GroupMember>();
        for (String ser : membersSer) {
            gm = (GrpMemberhelper) JSON.deserialize(ser, GrpMemberhelper.class);
            System.debug('Deserialized group Id: '+gm.grpId+', userId: '+gm.userId);
            grpList.add(new GroupMember(GroupId=gm.grpId,UserOrGroupId=gm.userId));
        }
        if(grpList.size() > 0)
            insert grpList;
    }
    
    private class GrpMemberHelper 
    {
        public String grpId { get; set; }
        public String userId { get; set; }
        
        public GrpMemberHelper(String g, String u) {
            grpId = g;
            userId = u;    
        }
    }

    public static void removeSPHDPermissions(Map<Id, User> users) 
    {
        PermissionSetUtil.removeSPHDPermissionSetsFromUsers(users);
    }
    
    public static void removeSPHDGroupMembers(Set<Id> userIds) 
    {
        String grpId = [SELECT Id FROM Group WHERE DeveloperName = 'SPHD_Manager' LIMIT 1].Id;
        if( userIds.size() > 0 )
        {
            List<GroupMember> gmList = [SELECT Id from GroupMember WHERE UserOrGroupId IN :userIds AND GroupId = :grpId];
            if(gmList.size() > 0 )
            {
                delete gmList;
            }
            
        }
    } 
    
}