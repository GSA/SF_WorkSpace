/*
*********************************************************
Apex Class Name    : LMT_PermSetAssignmentSenderService
Created Date       : September 09, 2020
@description       : This handler class is called once a day from the LMT_PermSetAssignmentHandler_Batch class.  
					 It is based on the Setup Audit Trail within the past 24 hours. It updates the 
					 CRM permission set assignment checkbox on the related LMT User object. 
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   09-09-2020   SNA HKMohammed						Create.
2.0   02-12-2025   Disha Bailoor                        Updated to scheduled apex from scheduled flow and API version.
*********************************************************
*/
public class LMT_PermSetAssignmentSenderService {
    private static final String NAMED_CREDENTIAL = 'LMT_Named_Credential_Client_Creds'; 
    private static final String ENDPOINT = '/services/apexrest/LMTUserLicenseReceiver'; 
    private static final String BATCH_NAME = 'LMT_PermSetAssignmentHandler_Batch';
    private static Integer DEFAULT_REQUEST_TIMEOUT = 120000; 
    
    public void processPermissionSetAssignments(List<SetupAuditTrail> auditTrails){
        Organization org = [SELECT Id, Name FROM Organization]; 
        //prepare the request body
        Map<String, Object> payload = new Map<String, Object>();  
        List<Map<String, String>> crmUserList = new List<Map<String, String>>(); 
        List<Map<String, String>> nonCrmUserList = new List<Map<String, String>>(); 
        List<Map<String, String>> orgDetails = new List<Map<String, String>>(); 
        
        //loop through the setup audit trail entries to get display and userIds in a list
        List<Id> userIds = new List<Id>(); 
        if(auditTrails.size() > 0){
            for(SetupAuditTrail auditTrail : auditTrails){ 
                String display = auditTrail.display;
                String userId = display.substring(
                    				display.indexOf('[')+1, display.indexOf(']')
                				);
                userIds.add(userId); 
        	}
        }else{ return; }
         
        //query the org permission Ids for CRM perm sets
       	List<LMT_CRM_Permission_Sets__mdt> crmPermSets = [SELECT Id, Org_Permission_Set_Id__c FROM LMT_CRM_Permission_Sets__mdt]; 
        List<Id> crmPS = new List<Id>(); 
        for(LMT_CRM_Permission_Sets__mdt crmPermSet : crmPermSets){
            crmPS.add(crmPermSet.Org_Permission_Set_Id__c); 
        }
        // Get the permission set assignment records for users whom permission set assignment changed in last 24 hours
        List<PermissionSetAssignment> permissionSetAssignmentList =[SELECT AssigneeId,PermissionSetId 
                                                                    FROM PermissionSetAssignment
                                                                    WHERE AssigneeId in :userIds];
        
        Map<Id,List<Id>> permissionSetAssignmentMap = new Map<Id,List<Id>>();
        List<Id> crmUsers = new List<Id>();
        List<Id> nonCrmUsers = new List<Id>(); 

        for (PermissionSetAssignment permissionSetAssignment :permissionSetAssignmentList){
            //Create a map with the user records
            if(!permissionSetAssignmentMap.containsKey(permissionSetAssignment.AssigneeId)){
                permissionSetAssignmentMap.put(permissionSetAssignment.AssigneeId,new List<Id>());
            }
            //If the permission sets is in LMT CRM permission sets custom metadata type , then add in CRMUsers List
            if(crmPS.contains(permissionSetAssignment.PermissionSetId)){
                permissionSetAssignmentMap.get(permissionSetAssignment.AssigneeId).add(permissionSetAssignment.PermissionSetId);
               
                if(!crmUsers.contains(permissionSetAssignment.AssigneeId)){                   
                    crmUsers.add(permissionSetAssignment.AssigneeId);
                }
            }             
            //The difference between userlist and crmuser list will be non crm users.
        	Set<Id> nonCrmUsersSet = new Set<Id>();
        	nonCrmUsersSet.addAll(userIds);
        	nonCrmUsersSet.removeAll(crmUsers);
        	nonCrmUsers = new List<Id>(nonCrmUsersSet);            
        }
        System.debug('***UserIdList: ' + userIds);
        System.debug('***nonCrmUsers' + nonCrmUsers);
        System.debug('***CrmUsers' + crmUsers);
        for(String i : crmUsers){
            Map<String, String> crmUserMap = new Map<String, String>(); 
                crmUserMap.put('Id', i); 
                crmUserList.add(crmUserMap); 
       	}
        
        for(String i : nonCrmUsers){
            Map<String, String> nonCrmUserMap = new Map<String, String>(); 
            nonCrmUserMap.put('Id', i); 
            nonCrmUserList.add(nonCrmUserMap); 
        }
        payload.put('crmUsers', crmUserList);
        payload.put('nonCrmUsers', nonCrmUserList);
        payload.put('organization', new Map<String, String>{
            'Id' => org.Id, 
            'Name' => org.Name
        }); 
		//Convert payload to JSON
        String requestBody = JSON.serialize(payload);
        
        //Send HTTP request
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint('callout:' + NAMED_CREDENTIAL + ENDPOINT); 
        req.setMethod('POST'); 
        req.setHeader('Content-Type', 'application/json'); 
        req.setBody(requestBody);
        req.setTimeout(getRequestTimeout()); 
        
        Http http = new Http(); 
        HttpResponse res = http.send(req);
        
        //Handle response
        if(res.getStatusCode() != 200){
            String e = res.getStatusCode() + ' - ' + res.getBody();
            LMTException.throwLMTException(e);
        }
   }
    public Integer getRequestTimeout(){
    	List<LMT_Configuration__mdt> LMT_Configs = [
            			SELECT Label, Batch_Size__c, Batch_Request_Timeout__c 
                       	FROM LMT_Configuration__mdt 
                       	WHERE Label = :BATCH_NAME 
                       	WITH USER_MODE LIMIT 1]; 
        Integer requestTimeout = DEFAULT_REQUEST_TIMEOUT; 
        if(LMT_Configs.size() > 0){requestTimeout = Integer.valueOf(LMT_Configs[0].Batch_Request_Timeout__c);  
            if(requestTimeout == null || requestTimeout <= 0){ requestTimeout = DEFAULT_REQUEST_TIMEOUT;}
        }else{requestTimeout = DEFAULT_REQUEST_TIMEOUT;}   
        return requestTimeout;  
    }    
}