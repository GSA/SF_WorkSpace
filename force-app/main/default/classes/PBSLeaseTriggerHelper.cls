public without sharing class PBSLeaseTriggerHelper {
    @testVisible public String RET_Lease_Access_Requestor_Comments_POC = 'Auto creaing Lease Access records for POC user';
    @testVisible public boolean isSandboxEnv = RET_LeaseShareUtility.isSandboxEnv;
    @testVisible public boolean isMaskPOCEmails = RET_LeaseShareUtility.getIsMaskPOCEmails();
    @testVisible public String RET_Email_Append = '.invalid';
    public void OnBeforeInsert(List<PBS_Lease__c> newList){
        List<PBS_Lease__c> newPOCLeaseList = new List<PBS_Lease__c>();
        
        for(PBS_Lease__c newLs : newList){
            validateLSREmail(newLs);
            if(newLs.LSR_Contact_Email__c == null) { // No POC information on new Lease, Do nothing
                continue;
            } else if(newLs.LSR_Contact_Email__c != null) { // New Lease has POC information, find and update owner.
                newPOCLeaseList.add(newLs);
            } 
        }
        if(newPOCLeaseList != null && newPOCLeaseList.size() > 0){
            updateLeaseWithPOC(newPOCLeaseList, false, false);
        } 
    }
    
    public void OnAfterInsert(List<PBS_Lease__c> newList){
        List<PBS_Lease__c> newPOCLeaseList = new List<PBS_Lease__c>();
        
        for(PBS_Lease__c newLs : newList){
            if(newLs.LSR_Contact_Email__c == null) { // No POC information on new Lease, Do nothing
                continue;
            } else if(newLs.LSR_Contact_Email__c != null) { // New Lease has POC information, find and update owner.
                newPOCLeaseList.add(newLs);
            } 
        }
        if(newPOCLeaseList != null && newPOCLeaseList.size() > 0){
            updateLeaseWithPOC(newPOCLeaseList, true, false);
        }
    }
    
    public void OnBeforeUpdate(List<PBS_Lease__c> newList, Map<Id, PBS_Lease__c> oldMap){
        List<PBS_Lease__c> removedPOCLeaseList = new List<PBS_Lease__c>();
        List<PBS_Lease__c> newPOCLeaseList = new List<PBS_Lease__c>();
        List<PBS_Lease__c> changedPOCLeaseList = new List<PBS_Lease__c>();
        Id castIronUserId = RET_LeaseShareUtility.getCastIronUserId(); //Cast IronPrd user ID
        
        for(PBS_Lease__c newLs : newList){
            validateLSREmail(newLs);
            PBS_Lease__c oldLS = oldMap.get(newLs.Id);
            if(newLs.LSR_Contact_Email__c == null && oldLs.LSR_Contact_Email__c == null) { //No POC before/after update, Do nothing
                continue;
            }else if(newLs.LSR_Contact_Email__c == null && oldLs.LSR_Contact_Email__c != null) { //POC got removed on lease, Revoke access to old POC and update owner of lease as 'Cast IronPrd' user
                removedPOCLeaseList.add(newLs);
            } else if(newLs.LSR_Contact_Email__c != null && oldLs.LSR_Contact_Email__c == null) { //POC email field is populated with new email address, find and update owner with new POC user
                newPOCLeaseList.add(newLs);
            } else if(newLs.LSR_Contact_Email__c != null && oldLs.LSR_Contact_Email__c != null && oldLs.OwnerId == castIronUserId ) { //POC user registered since last update, update owner of lease as this POC user
                newPOCLeaseList.add(newLs);
            } else if(newLs.LSR_Contact_Email__c != null && oldLs.LSR_Contact_Email__c != null && newLs.LSR_Contact_Email__c  != oldLs.LSR_Contact_Email__c) { // POC on this Lease got changed, Find new POC user and assign him as owern and revoke access from old POC
                changedPOCLeaseList.add(newLs);
            } else if(newLs.LSR_Contact_Email__c != null && oldLs.LSR_Contact_Email__c != null && newLs.LSR_Contact_Email__c  == oldLs.LSR_Contact_Email__c) { // No Change to POC, do Nothing.
                continue;
            }
        }
        if(removedPOCLeaseList != null && removedPOCLeaseList.size() > 0){
            RET_LeaseShareUtility.revokeRETLeaseAccess(removedPOCLeaseList); //Remove access for leases from RET users
            RET_LeaseShareUtility.revokePOCLeaseAccess(removedPOCLeaseList); //Updating status of POC Lease Access to 'Access Revoked'
            for(PBS_Lease__c ls : removedPOCLeaseList){
                if(castIronUserId != null){ ls.OwnerId = castIronUserId;}
            }
        }
        if(newPOCLeaseList != null && newPOCLeaseList.size() > 0){
            updateLeaseWithPOC(newPOCLeaseList, false,true  );
        }
        if(changedPOCLeaseList != null && changedPOCLeaseList.size() > 0){
            RET_LeaseShareUtility.revokeRETLeaseAccess(changedPOCLeaseList); //Remove access for leases from RET users
            RET_LeaseShareUtility.revokePOCLeaseAccess(changedPOCLeaseList); //Updating status of POC Lease Access to 'Access Revoked'
            updateLeaseWithPOC(changedPOCLeaseList, false,false);
        }
    }
    
    public void updateLeaseWithPOC(List<PBS_Lease__c> newList, Boolean isAfterInsert, Boolean newUserFlag){
        Map<string, string> leasePOCMap = new Map<string, string>();
        Map<string, Id> leaseNameExistingPOCIdMap = new Map<string, Id>();
        List<PBS_Lease__c> createNewPOCList = new List<PBS_Lease__c>();
        Map<Id, Id> leaseIdOwnerIdMap = new Map<Id, Id>();
        Map<String, Id> leaseNameNewPOCIdMap = new Map<String, Id>();
        List<PBS_Lease_Access__c> pocLeaseAccessList = new List<PBS_Lease_Access__c>();
        
        for(PBS_Lease__c ls : newList){
            if(ls.LSR_Contact_Email__c != null && ls.LSR_Contact_Email__c != ''){
                leasePOCMap.put(ls.Name, ls.LSR_Contact_Email__c);
            }
        }
        //Search for community users if they existed in the system
        leaseNameExistingPOCIdMap = searchUsersByEmail(leasePOCMap);
        for(PBS_Lease__c ls : newList){
            if(leaseNameExistingPOCIdMap.containsKey(ls.Name)){
                system.debug('leaseNameExistingPOCIdMap.get(ls.Name) **** '+leaseNameExistingPOCIdMap.get(ls.Name) );
                // POC User existed for the lease poc email. Check if he/she is the owner of that lease, and if not, update owner
                if(ls.ownerId != leaseNameExistingPOCIdMap.get(ls.Name) && !isAfterInsert){
                    //Check if the user is a POC user, if not update user record make him/her POC user
                    ls.ownerId = leaseNameExistingPOCIdMap.get(ls.Name);
                    leaseIdOwnerIdMap.put(ls.Id, ls.ownerId);
                    System.debug('ls.ownerId **** '+ls.ownerId );
                } if(isAfterInsert){
                    system.debug('isAfterInsert*** '+ls.Id);
                    leaseIdOwnerIdMap.put(ls.Id, ls.ownerId);
                }
            } else if(!isAfterInsert){
                // POC user does not exist, create new RET POC user with CCP lincese
                createNewPOCList.add(ls);
            }
        }
        List<PBS_Lease_Access__c> updatePOCLsacList = new List<PBS_Lease_Access__c>();
        List<PBS_Lease_Access__c> existingLeaseAccessList = [select Id, PBS_Lease__c, Requestor__c, Status__c from PBS_Lease_Access__c where PBS_Lease__c IN :leaseIdOwnerIdMap.keySet() and Requestor__c IN :leaseIdOwnerIdMap.values()];
        if(leaseIdOwnerIdMap.size() > 0 && existingLeaseAccessList != null && existingLeaseAccessList.size() > 0){ //Loop through existing poc LeaseAccess records to update them.
            for(Id lsID : leaseIdOwnerIdMap.keySet()){
                for(PBS_Lease_Access__c existingLsac : existingLeaseAccessList){
                    if(lsId == existingLsac.PBS_Lease__c && leaseIdOwnerIdMap.get(lsId) == existingLsac.Requestor__c){ //There is a LeaseAccess record for this POC to this lease, update status to 'POC'
                        existingLsac.Status__c = RET_LeaseShareUtility.RET_UserType_POC;
                        updatePOCLsacList.add(existingLsac);
                        leaseIdOwnerIdMap.remove(lsID); //removing from map, so that for remaining lease/poc's, we can create new lease acecss records
                    }
                }
            }
        }
        if(leaseIdOwnerIdMap.size() > 0){ //Create new Lease Access record for POC user with status = 'POC'
            system.debug('leaseIdOwnerIdMap.keyset() **** '+leaseIdOwnerIdMap.keyset());
            for(Id lsID : leaseIdOwnerIdMap.keySet()){
                PBS_Lease_Access__c leaseAccess = new PBS_Lease_Access__c(
                    PBS_Lease__c = lsID,
                    Requestor__c = leaseIdOwnerIdMap.get(lsId),
                    Requestor_Comments__c = RET_Lease_Access_Requestor_Comments_POC,
                    Status__c = RET_LeaseShareUtility.RET_Access_Status_POC);
                pocLeaseAccessList.add(leaseAccess); 
            }
        }
        
        if(pocLeaseAccessList != null && pocLeaseAccessList.size() > 0){
            insert pocLeaseAccessList;
        }
        if(updatePOCLsacList != null && updatePOCLsacList.size() > 0){
            update updatePOCLsacList;
        }
        
        if(createNewPOCList.size() > 0){
            Id castIronUserId = RET_LeaseShareUtility.getCastIronUserId(); //Cast IronPrd user ID
            for(PBS_Lease__c ls : createNewPOCList){
                if(castIronUserId != null){ ls.OwnerId = castIronUserId;}
            }
            // Send email to LSR_Contact_Email__c to ask them to register(WF/PB)
        }
        
        //New functionality to add Users
        System.debug('New User');
        if(newUserFlag == true){
            System.debug('newUserFlag'+newUserFlag);
            Map<string, Id> leaseNameExistingAaapRetPOCIdMap = new Map<string, Id>();
            List<User> newUsersList = new List<User>();
            List<User> updateUserList  = new List<User>();
            List<Contact> contactList = new List<Contact>();
            
            //Search for community users if they existed in the system
            leaseNameExistingAaapRetPOCIdMap = searchAaapRetUsersByEmail(leasePOCMap);
            Map<Id, User> userList = new Map<Id,User>([SELECT Id, Name, profile.name FROM User WHERE Id IN :leaseNameExistingAaapRetPOCIdMap.values()]);
            Map<String, Contact> existingContacts = searchContactsWithEmail(leasePOCMap);
            for(PBS_Lease__c ls : newList){
                if(!leaseNameExistingAaapRetPOCIdMap.containsKey(ls.Name)){
                    System.debug('New User');
                    //Create new user functionality here
                    if((ls.LSR_Last_Name__c != Null && ls.LSR_Last_Name__c != '')){
                    if(!existingContacts.containsKey(ls.LSR_Contact_Email__c)){
                    	Contact con = createContact(ls);
                    	contactList.add(con);    
                    }else{
                        contactList.add(existingContacts.get(ls.LSR_Contact_Email__c));
                    }
                    
                    //contactMap.put(ls.LSR_Email_Text__c, con);
                    
                    	newUsersList.add(createUser(ls));    
                    }
                    
                }else  {
                    User usr = userList.get(leaseNameExistingAaapRetPOCIdMap.get(ls.Name));
                    if(usr.Profile.Name == RET_LeaseShareUtility.AAAP_Customer_Profile){
                        updateUserList.add(usr);
                    }
                }
            }
            
            Map<string, Contact> contactMap = new Map<string, Contact>();
            if(!contactList.isEmpty()){
                try{
                    //insert contactList;
                    upsert contactList;
                }catch(Exception e){
                    System.debug('Error occurred while inserting contacts '+ e);
                }
                for(Contact c: contactList)
                    contactMap.put(c.email,c);
            }
            if(!newUsersList.isEmpty()){
                
                for(User ul : newUsersList){
                    ul.ContactId = contactMap.get(ul.Email).Id;
                }
                try{
                    insert newUsersList;
                }catch(Exception e){
                    System.debug('Error occurred while inserting users '+ e);
                }
                
            }
            
            if(!updateUserList.isEmpty()){
                Set<Id> userIdSet = new Set<Id>();
                for(User u : updateUserList){
                    userIdSet.add(u.Id);
                }
                updateUsersProfile(userIdSet);
                updateUsersPermission(userIdSet);
            }
            
        }
    } 
    
    public static Map<String,Contact> searchContactsWithEmail(Map<string, string> leasePOCMap){
        System.debug('Contact: ' + leasePOCMap);
        Map<String,Contact> contactsEmail = new Map<String,Contact>();
        for(Contact c : [Select Id,Email from Contact where Email IN :leasePOCMap.values()
                         AND AccountId =: RET_LeaseShareUtility.RET_Account_Id]){
         	contactsEmail.put(c.Email,c);	                    
        }
        System.debug('Number Con: ' + contactsEmail.size()); 
        return contactsEmail;
    }
    
        public static Map<string, Id> searchAaapRetUsersByEmail(Map<string, string> leasePOCMap){
        Map<String, Id> leaseNameExistingPOCIdMap = new Map<String, Id>();
        for(User u : [select id, Name, Email, UserName, profile.Name, profileId from user where Email IN :leasePOCMap.values() and (profile.Name = :RET_LeaseShareUtility.RET_CCP_Profile OR profile.name= :RET_LeaseShareUtility.AAAP_Customer_Profile) and isActive = true]) {
            for(string leaseName : leasePOCMap.keyset()){
                if(leasePOCMap.get(leaseName) == u.Email){
                    leaseNameExistingPOCIdMap.put(leaseName, u.Id);
                }
            }
         }
        system.debug('leaseNameExistingPOCIdMap.keyset() ***** *'+ leaseNameExistingPOCIdMap.keyset());
        return leaseNameExistingPOCIdMap;
    }
        public static Map<string, Id> searchUsersByEmail(Map<string, string> leasePOCMap){
            Map<String, Id> leaseNameExistingPOCIdMap = new Map<String, Id>();
            for(User u : [select id, Name, Email, UserName from user where Email IN :leasePOCMap.values() and profile.Name = :RET_LeaseShareUtility.RET_CCP_Profile and isActive = true]) {
                for(string leaseName : leasePOCMap.keyset()){
                    if(leasePOCMap.get(leaseName) == u.Email){
                        leaseNameExistingPOCIdMap.put(leaseName, u.Id);
                    }
                }
            }
            system.debug('leaseNameExistingPOCIdMap.keyset() ***** *'+ leaseNameExistingPOCIdMap.keyset());
            return leaseNameExistingPOCIdMap;
        }
        
        public void validateLSREmail(PBS_Lease__c lease){
            if(lease.LSR_Email_Text__c != null && lease.LSR_Email_Text__c != ''){
                String emailRegex = '([a-zA-Z0-9_\\-\\.\\+]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,8}|[0-9]{1,3})';
                Pattern MyPattern = Pattern.compile(emailRegex);
                Matcher match = MyPattern.matcher(lease.LSR_Email_Text__c);
                
                if (match.matches()){
                    if(isSandboxEnv && isMaskPOCEmails && !Test.isRunningTest()){lease.LSR_Contact_Email__c = lease.LSR_Email_Text__c+RET_Email_Append;}
                    else{lease.LSR_Contact_Email__c = lease.LSR_Email_Text__c;}
                }else {
                    lease.LSR_Contact_Email__c = null;
                }
            } else if(lease.LSR_Email_Text__c == null || lease.LSR_Email_Text__c == ''){
                lease.LSR_Contact_Email__c = null;
            }
        }
        
        public static Contact createContact(PBS_Lease__c ls){
            //return new Contact(lastName= ls.LSR_Last_Name__c, firstName = ls.LSR_First_Name__c, email = ls.LSR_Email_Text__c, accountId = RET_LeaseShareUtility.RET_Account_Id);
        	return new Contact(lastName= ls.LSR_Last_Name__c, firstName = ls.LSR_First_Name__c, email = ls.LSR_Contact_Email__c, accountId = RET_LeaseShareUtility.RET_Account_Id);
        }
        
        public static User createUser(PBS_Lease__c ls){
            User newUser = new User();
            newUser.FirstName = ls.LSR_First_Name__c;
            newUser.lastName = ls.LSR_Last_Name__c;
            newUser.email = ls.LSR_Contact_Email__c;
            if(ls.LSR_First_Name__c != null && ls.LSR_First_Name__c != '' && ls.LSR_Last_Name__c != null && ls.LSR_Last_Name__c != ''){
                newUser.Alias =  ls.LSR_First_Name__c.substring(0,1) + ls.LSR_Last_Name__c.substring(0,1) + Math.round((Math.random()*10000));  
            } else {
                newUser.Alias =  ls.LSR_Last_Name__c.substring(0,1) + Math.round((Math.random()*10000));  
            }
            System.debug('newUser.Alias: ' + newUser.Alias);
            newUser.emailencodingkey = 'UTF-8';
            newUser.LanguageLocaleKey = 'en_US';
            newUser.localesidkey = 'en_US';
            newUser.ProfileId= RET_LeaseShareUtility.RET_CCP_Profile_Id;
            newUser.Country ='United States';
            newUser.IsActive = true;
            newUser.Username = ls.LSR_Contact_Email__c;
            newUser.TimeZoneSidKey = 'America/New_York';
            
            return newUser;
        }
        
        @future
        public static void updateUsersProfile(Set<Id> updateUserProfileSet){
            List<User> userList = new List<User>([SELECT Id,profileId FROM User WHERE Id IN :updateUserProfileSet]);
            for(User usr : userList){
                usr.ProfileId = RET_LeaseShareUtility.RET_CCP_Profile_Id;
            }
            try{
                update userList;  
            }catch(Exception e){
                System.debug('Error occurred while updating user profile in future method ' + e);
            }
        }
        
        @future
        public static void updateUsersPermission(Set<Id> updateUserProfileSet){
            List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
            //PermissionSet GSArETcOMMPermissionSetId = RET_LeaseShareUtility.RET_AAAP_PemissionSet_Id;
            
            if(!updateUserProfileSet.isEmpty()){
                for(Id eachUserId : updateUserProfileSet){
                    PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = RET_LeaseShareUtility.RET_AAAP_PemissionSet_Id, AssigneeId = eachUserId);
                    permissionSetList.add(psa);
                }
            }
            try{
                insert permissionSetList;  
            } catch(Exception e){
                System.debug('Error occurred in permission set future method '+ e);
            }
        }
    }