public with sharing class PermissionSetUtil
{ 
    
    public static void assignDefaultPermissionSetsToUsers(Map<Id,User> newUserMap)
    {
        
        List<PermissionSet> permissionSets = getPermissionSetList();
        Set<Id> profileIds = getChatterProfileIds();
        Set<Id> exclusionProfileIds = getExclusionProfileIds(); 
        List<User> listAllUsers = new List<User>();
        List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
        System.debug('Default PermissionSets: ' + permissionSets);
        for(Id userId :newUserMap.KeySet()) 
        {
            User user = newUserMap.get(userId);
            if( user.IsActive && ! ( profileIds.contains(user.ProfileId) || isUserInProfile(user,exclusionProfileIds)) 
               && user.MAJOR_ORG__c == 'P')
            {
                for(PermissionSet permissionSet : permissionSets)
                {
                    psAssignments.add( new PermissionSetAssignment(AssigneeId = user.Id,PermissionSetId = permissionSet.Id ) );                    
                    //System.debug('psAssignments: ' + psAssignments);
                }
            }
        }
        
        if(psAssignments != null && psAssignments.size() > 0)  
        {      
            insert psAssignments ;
        }

    }    
    
    public static void assignSPHDPermissionSetsToUsers(Map<Id,User> newUserMap)
    {
        List<String> sphdLicenseList = getSPHDLicenseList();
        List<PermissionSet> permissionSets = getSPHDPermissionSetList();
         System.debug('sphdLicenseList ' + sphdLicenseList);
        System.debug('PermissionSetUtil.assignSPHDPermissionSetsToUsers(), SPHD PermissionSets: ' + permissionSets);
        List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
        for(Id userId :newUserMap.KeySet()) 
        {
            User user = newUserMap.get(userId);
            System.debug('PermissionSetUtil.assignSPHDPermissionSetToUsers(), user: ' + user);
            if( user.IsActive && user.MAJOR_ORG__c == 'P' && sphdLicenseList.contains(user.User_License__c) )
            {
                for(PermissionSet permissionSet : permissionSets)
                {
                    psAssignments.add( new PermissionSetAssignment(AssigneeId = user.Id,PermissionSetId = permissionSet.Id ) );                    
                }
            }
        }
        
        if(psAssignments.size() > 0)  
        {      
            insert psAssignments;
        }
    }     
    
    /*
    @future
    public static  void updatePermissionSetsToUsers(List<String> serializedNewUsers,List<String> serializedOldUsers)  
    {
        Map<Id,User> newUserMap = new Map<Id,User>();
        for(String serializedNewUser: serializedNewUsers){
            User eachUser = new User();
            eachUser = (User) JSON.deserialize(serializedNewUser, User.class);
            newUserMap.put(eachUser.Id,eachUser);
            }
         Map<Id,User> oldUserMap = new Map<Id,User>();
         if(!serializedOldUsers.isEmpty()){
            for(String serializedOldUser : serializedOldUsers){
                User oldUser = (User) JSON.deserialize(serializedOldUser, User.class);
                oldUserMap.put(oldUser.Id, oldUser);
            }
        }
        
        Set<Id> exclusionProfileIds = getExclusionProfileIds();
        Set<Id> profileIds = getChatterProfileIds();
        List<PermissionSet> permissionSets = getPermissionSetList();
        List<PermissionSetAssignment> psNewAssignments = new List<PermissionSetAssignment>();
        Map<Id,Set<PermissionSetAssignment>> userExistingPermissionSetMap = getUserPermissionSetAssignmentMap(permissionSets);

        for(Id userId : newUserMap.KeySet())
        {   
            User afterUpdateUser = newUserMap.get(userId);
            User beforeUpdateUser = oldUserMap.get(userId);
            if(isUserInProfile(beforeUpdateUser ,exclusionProfileIds) || !(afterUpdateUser.IsActive))
            {   
                continue;
            }
            if((beforeUpdateUser.MAJOR_ORG__c != 'P' && afterUpdateUser.MAJOR_ORG__c == 'P') &&
               !( profileIds.contains(afterUpdateUser.ProfileId) || isUserInProfile(afterUpdateUser,exclusionProfileIds)))
            {   
                for(PermissionSet permissionSet : permissionSets)
                {
                    Set<PermissionSetAssignment> existingUsers = (Set<PermissionSetAssignment>)userExistingPermissionSetMap.get(permissionSet.Id);

                    Set<Id> existingUserIds = new Set<Id>();
                    if (existingUsers !=null){
                      for(PermissionSetAssignment psAssignment : existingUsers)
                        {
                            if(!existingUserIds.contains(psAssignment.AssigneeId))
                            {
                                existingUserIds.add(psAssignment.AssigneeId);
                            }
                        }
                    }
                    
                    if(existingUsers != null && !existingUserIds.contains(afterUpdateUser.Id))
                    {
                        psNewAssignments.add(new PermissionSetAssignment(AssigneeId = afterUpdateUser.Id,PermissionSetId = permissionSet.Id ) ); 
                        
                    }
                }
            }
          
        }

        if(psNewAssignments != null && psNewAssignments.size() > 0)  
        {      
            insert psNewAssignments;
        }
        
    } 
    */
    public static void removeSPHDPermissionSetsFromUsers(Map<Id,User> userMap)        
    {
        List<Id> psIds = new List<Id>();
        for (PermissionSet ps : getSPHDPermissionSetList()) {
            psIds.add(ps.Id);
        }
        List<PermissionSetAssignment> psaList = [SELECT Id from PermissionSetAssignment WHERE AssigneeId IN :userMap.KeySet() AND PermissionSetId IN :psIds];
        
        if(psaList.size() > 0)  
        {      
            delete psaList;
        }        
    }

    //Gets chatter profile and also exclusion list
    public static Set<Id> getChatterProfileIds()
    {
        Set<Id> profileIds = new Set<Id>();
        //Getting exclusion UserLicense from Custom settings.
        List<String> exclusionUserLicense = getUserProvisioningUtilValuesByType('ExclusionUserLicense');
        List<Profile> profileList = [Select p.Id From Profile p where p.UserLicenseId IN (Select  u.Id From UserLicense u where u.Name IN :exclusionUserLicense)];
        for(Profile profile:profileList)
        {
            profileIds.add(profile.Id);
        }
        return profileIds;
    }
    
    public static Set<Id> getExclusionProfileIds()
    {
        Set<Id> profileIds = new Set<Id>();
        //Getting exclusion profile from Custom settings.
        List<String> exclusionProfiles = getUserProvisioningUtilValuesByType('ExclusionProfile');
        List<Profile> profileExclList = [Select p.Id,p.Name From Profile p where p.Name IN :exclusionProfiles];
        for(Profile profile1:profileExclList)
        {
            profileIds.add(profile1.Id);
        }
        return profileIds;
    }
    
    public static boolean isUserInProfile(User user,Set<Id> profileIds)
    {
        boolean result = false;
        for(Id profileId:profileIds)
        {   system.debug('exclusion: ' + profileId + ' :: ' + 'user profile: ' + user.ProfileId);
            system.debug('exclusion: ' + profileId + ' :: ' + 'user profile: ' + user.ProfileId);        
            if(profileId == user.ProfileId)
            {
                result = true;
                break;
            }
        }
        return result;
    }
    
    public static List<PermissionSet> getPermissionSetList()
    {
        //Getting Permissionset Name from Custom settings.
        List<String> psList = getUserProvisioningUtilValuesByType('UserDefaultPermissionSet');
        system.debug('psList'+psList);
        List<PermissionSet> permissionSets = [SELECT Id,IsOwnedByProfile,Label,Name FROM PermissionSet where Name in :psList];
        return permissionSets;
    }

    public static List<String> getSPHDLicenseList()
    {
        return getUserProvisioningUtilValuesByType('SPHDUserLicense');
    }

    public static List<PermissionSet> getSPHDPermissionSetList()
    {
        System.debug('PermissionSetUtil.getPermissionSetList(), querying SPHD PermissionSet type: "UserSPHDPermissionSet"');
        List<String> psList = getUserProvisioningUtilValuesByType('UserSPHDPermissionSet');
        System.debug('PermissionSetUtil.getPermissionSetList(), queryed SPHD PermissionSet types: ' + psList);
        List<PermissionSet> permissionSets = [SELECT Id,IsOwnedByProfile,Label,Name FROM PermissionSet where Name in :psList];
        return permissionSets;
    }

    public static List<String> getUserProvisioningUtilValuesByType(String type)
    {
        List<String> values = new List<String>();
        system.debug('type:'+type);
      
        if(PublicGroupUserSyncHelper.isTestMethod)
        {
            List<UserTestProvisioningUtil__c> userProvisioningValues = [select Name from UserTestProvisioningUtil__c where type__c = :type];
           system.debug('userProvisioningValues='+userProvisioningValues);
            for(UserTestProvisioningUtil__c value: userProvisioningValues )
            {
                values.add(value.Name);
            }
        }
        else
        {
            System.debug('PermissionSetUtil.getUserProvisioningUtilValuesByType(), querying UserProvisioningUtil__c table for type: ' + type + '...');
            List<UserProvisioningUtil__c> userProvisioningValues = [select Name from UserProvisioningUtil__c where type__c = :type];
            for(UserProvisioningUtil__c value: userProvisioningValues )
            {
                values.add(value.Name);
            }
        }
        
        return values;
    }
    
    //GENERIC METHOD - Getting list of users for a permission set or Permission Set List 
    public static Map<Id,Set<PermissionSetAssignment>> getUserPermissionSetAssignmentMap(List<PermissionSet> psList)
    {
        //List<PermissionSet> psList = getPermissionSetList();
        List<Id> ids = new List<Id>();
        for(PermissionSet ps : psList)
        {
            ids.add(ps.Id);
        }
        List<PermissionSetAssignment> psAssignmentList = [Select PermissionSetId,Id,AssigneeId from PermissionSetAssignment where PermissionSetId in :ids];
        Map<Id,Set<PermissionSetAssignment>> userPermissionSetMap = new Map<Id,Set<PermissionSetAssignment>>();
        for(PermissionSetAssignment psAssignment : psAssignmentList)
        {
            if(userPermissionSetMap.containsKey(psAssignment.PermissionSetId))
            {
                Set<PermissionSetAssignment> assigneeIds = userPermissionSetMap.get(psAssignment.PermissionSetId);
                assigneeIds.add(psAssignment);
                userPermissionSetMap.put(psAssignment.PermissionSetId,assigneeIds); 
            }
            else
            {
                Set<PermissionSetAssignment> assigneeIds = new Set<PermissionSetAssignment>();
                assigneeIds.add(psAssignment);
                userPermissionSetMap.put(psAssignment.PermissionSetId,assigneeIds); 
            }
        }
        return userPermissionSetMap;
    }
}