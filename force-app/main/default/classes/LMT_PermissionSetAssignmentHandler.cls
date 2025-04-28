/**
 *This class is invoked by lightning flow which runs daily. 
This class gets all the permission set assignment changes and updates the LMT org license records
**/


public class LMT_PermissionSetAssignmentHandler {
    
    //Invoked by Lightning Flow
    @InvocableMethod(label='LMT Permission Set Assignments Handler')
    public static void processPermissionSetAssignments(FlowInputParameters[] input){
        List<Id> userIdList = input[0].userIdList;
        if(userIdList==null) {
            userIdList=new List<Id>{};
        }
        List<Id> crmPS =input[0].crmPS;
        
        // Get the permission set assignment records for users whom permission set assignment changed in last 24 hours
        
        List<PermissionSetAssignment> permissionSetAssignmentlist =[Select AssigneeId,PermissionSetId 
                                                                    from PermissionSetAssignment
                                                                    Where AssigneeId in :userIdList];
        
        Map<id,List<Id>> permissionSetAssignmentMap = new Map<id,List<Id>>();
        List<Id> crmUsers = new List<Id>();
        
        
        for (PermissionSetAssignment permissionSetAssignment :permissionSetAssignmentlist){
            
            //Create a map with the user records
            if(!permissionSetAssignmentMap.containskey(permissionSetAssignment.AssigneeId)){
                permissionSetAssignmentMap.put(permissionSetAssignment.AssigneeId,new List<id>());
            }
            //If the permission sets is in LMT CRM permission sets custom metadata type , then add in CRMUsers List
            if(crmPS.contains(permissionSetAssignment.PermissionSetId)){
                permissionSetAssignmentMap.get(permissionSetAssignment.AssigneeId).add(permissionSetAssignment.PermissionSetId);
               
                if(!crmUsers.contains(permissionSetAssignment.AssigneeId)){                   
                    crmUsers.add(permissionSetAssignment.AssigneeId);
                }
            }  
            
        }
        system.debug('***useridList' + userIdList);
        //The difference between userlist and crmuser list will be non crm users.
        Set<Id> nonCrmUsersSet = new Set<Id>();
        nonCrmUsersSet.addAll(userIdList);
        nonCrmUsersSet.removeAll(crmUsers);
        List<Id> nonCrmUsers = new List<Id>(nonCrmUsersSet);
        
        system.debug('***nonCrmUsers' + nonCrmUsers);
        system.debug('***CrmUsers' + crmUsers);
        
        //Setting teh appropriate flag for CRM and non CRM users
        List<OrgUsersLicense__c> lmtOrgUsersLicenseList = new List<OrgUsersLicense__c>();
        List<OrgUsersLicense__c> lmtCrmOrgUsersLicenseList = [Select id, CRM_Permissions_Used__c from OrgUsersLicense__c where userid__c in :crmUsers];
        for (OrgUsersLicense__c crmLicense : lmtCrmOrgUsersLicenseList){ 
            crmLicense.CRM_Permissions_Used__c=true;           
        }
        List<OrgUsersLicense__c> lmtNonCrmOrgUsersLicenseList = [Select id, CRM_Permissions_Used__c from OrgUsersLicense__c where userid__c in :nonCrmUsers];
        for (OrgUsersLicense__c crmLicense : lmtNonCrmOrgUsersLicenseList){ 
            crmLicense.CRM_Permissions_Used__c=false;           
        }
        
        lmtOrgUsersLicenseList.addAll(lmtNonCrmOrgUsersLicenseList);
        lmtOrgUsersLicenseList.addAll(lmtCrmOrgUsersLicenseList);
        
        //Update the Org License records
        update lmtOrgUsersLicenseList;
    }
    
    public class FlowInputParameters{
        // @InvocableVariable(label='Org Id' required = true )
        // public string orgID;
        
        
        @InvocableVariable(label='UserId List' required = false )
        public List<Id> userIdList;
        
        @InvocableVariable(label='CRM Permission sets from custom metadata type' required = true )
        public List<Id> crmPS;
        
        
        
        
    }
    
    
}