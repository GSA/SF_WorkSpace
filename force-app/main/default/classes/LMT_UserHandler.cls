/**
* This class creates and updates LMT Org License records ONLY when users are created and updated in the last 24 hours.
* The parent record LMT_User__c will be created in EEO and synced to this Org. 
**/
public class LMT_UserHandler
{
    //Invoked from Lightning flow 
    @InvocableMethod(label='LMT 2.0 Userhandler')
    public static void processLMTUsers(FlowInputParameters[] input){
        //Flow parameters
        List<User> flowInputUpdatedUsers = input[0].updatedUsers;
        Organization flowInputOrgDetail = input[0].orgDetail;
 
        if (flowInputUpdatedUsers == null){
            flowInputUpdatedUsers = new List<User>();
        }
                
        //Update LMT users and org License records
        List<Id> updatedUserIds = new List<Id>();
        List<String> fedIds = new List<String>();
        
        Map<String,user> updatedUsersMap = new Map<String,user>();
        for(User u : flowInputUpdatedUsers){
           // updatedUserIds.add(u.id); 
            //if(u.FederationID__c != null && u.FederationID__c.trim() != '')
            if(u.FederationIdentifier != null && u.FederationIdentifier.trim() != '') {
                fedIds.add(u.FederationIdentifier);
                updatedUsersMap.put(u.FederationIdentifier, u);
        	}
            //updatedUsersMap.put(u.id,u);
        }
        
        //Get existing LMT users 
        List<LMT_User__c> existingLMTUsers = [select id,Federation_ID__c,User_ID__c,email__c from LMT_user__c where Federation_ID__c in :fedIds];
       	Map<String,LMT_User__c> existingLMTUsersMap = new Map<String,LMT_User__c>();
        for(LMT_User__c u : existingLMTUsers){
            existingLMTUsersMap.put(u.Federation_ID__c,u);
        }

        //Get Org License user records for updating
        List<OrgUsersLicense__c> existingLMTUserLicenseList = [Select id , LMT_User__c, OrgID__c,OrgName__c,FederationID__c,UserLicense__c,UserID__c,ActiveUser__c,OrgFedIDKey__c
                                                               from OrgUsersLicense__c where FederationID__c in :fedIds ];
        Map<String,OrgUsersLicense__c> existingLMTUserLicenseMap = new Map<String,OrgUsersLicense__c>();
        for(OrgUsersLicense__c u : existingLMTUserLicenseList){
            	existingLMTUserLicenseMap.put(u.FederationID__c,u);
        }
        system.debug('==> ' + existingLMTUsersMap.keySet().size());
        List<OrgUsersLicense__c> toUpsert = new List<OrgUsersLicense__c>();
        
        
        List<User> usersInOrder = new List<User>();
        List<String> fedIdsInOrder = new List<String>();
        Integer countInOrder = 0;
        List<User> failedUsers = new List<User>();
        
        for(String fedId : existingLMTUsersMap.keySet()){
            try { 
                User u = updatedUsersMap.get(fedId);    
                if (!u.LMT_User_Creation_IsFailed__c ) {
                    usersInOrder.add(u);
                    fedIdsInOrder.add(fedId);
                    LMT_User__c lmtUser = existingLMTUsersMap.get(fedId);
                    OrgUsersLicense__c lmtUserLicense = new OrgUsersLicense__c();
                    if(existingLMTUserLicenseMap.containsKey(fedId)) {
                        lmtUserLicense = existingLMTUserLicenseMap.get(fedId);
                    }
                    lmtUserLicense.LMT_User__c=lmtUser.id;
                    lmtUserLicense.OrgID__c=flowInputOrgDetail.id;
                    lmtUserLicense.OrgName__c=flowInputOrgDetail.name;
                    lmtUserLicense.FederationID__c=u.FederationIdentifier;
                    lmtUserLicense.UserLicense__c=u.User_License__c; 
                    lmtUserLicense.UserID__c=u.id;
                    lmtUserLicense.ActiveUser__c=u.IsActive; 
                    lmtUserLicense.Last_Login_Date__c = u.LastLoginDate;
                    lmtUserLicense.OrgFedIDKey__c=u.FederationIdentifier; 
                    toUpsert.add(lmtUserLicense);
                }
            } catch(Exception e) {}
        } 
        system.debug('==> ' + toUpsert);
        
        //upsert toUpsert;
        List<Database.upsertResult> uResults = Database.upsert(toUpsert,false);
        FlowOutput[] errors = new List<FlowOutput>();
        for(Database.upsertResult result:uResults) {
            if (!result.isSuccess()) {
                errors.add(new FlowOutput(usersInOrder.get(countInOrder)));
                failedUsers.add(usersInOrder.get(countInOrder));           
            } 
            countInOrder++;
        }
        
        if (failedUsers.size() > 0) {
            for (User failedUser : failedUsers) {
                failedUser.LMT_User_Creation_First_Fail_Date__c = DateTime.now();
                failedUser.LMT_User_Creation_IsFailed__c = true;
            }
            update failedUsers;
        }
    }    
    //Flow parameters
    public class FlowInputParameters {
        @InvocableVariable(label='Org Details' required = true )
        public Organization orgDetail;
                
        @InvocableVariable(label='Users updated in last 24 hours' required = false )
        public List<User> updatedUsers;
    }   
    
    public class FlowOutput{
        @InvocableVariable(label='List of Ids' required = false ) 
        public List<User> recordIds = new List<User>();
        
        public FlowOutput(User recordId) 
        { 
            recordIds.add(recordId);
        }
    }
}