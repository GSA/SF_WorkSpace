/*
*********************************************************
Apex Class Name    : LMT_PermSetInitialSyncSenderService
Created Date       : April 14, 2025
@description       : This handler class is from the LMT_PermSetInitialSync_Batch class for the first sync.  
					 It is based on the current existing LMT User License records. It updates the 
					 CRM permission set assignment checkbox on the related LMT User License object. 
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-14-2025   Disha Bailoor						Create.
*********************************************************
*/
public class LMT_PermSetInitialSyncSenderService {
    private static final String NAMED_CREDENTIAL = 'LMT_Named_Credential_Client_Creds'; 
    private static final String ENDPOINT = '/services/apexrest/LMTUserLicenseReceiver'; 
    private static final String BATCH_NAME = 'LMT_PermSetInitialSync_Batch';
    private static Integer DEFAULT_REQUEST_TIMEOUT = 120000; 
    
    public void processCRMAssignments(List<User> users){
        Organization org = [SELECT Id, Name FROM Organization]; 
        //prepare the request body
        Map<String, Object> payload = new Map<String, Object>(); 
        List<Map<String, String>> crmUserList = new List<Map<String, String>>(); 
        List<Map<String, String>> nonCrmUserList = new List<Map<String, String>>(); 
        List<Map<String, String>> orgDetails = new List<Map<String, String>>(); 
        
        List<Id> userIds = new List<Id>();
        for(User u : users){
            userIds.add(u.Id); 
        }
        System.debug('userIds: ' + userIds); 
        List<LMT_CRM_Permission_Sets__mdt> crmPermSets = [SELECT Id, DeveloperName FROM LMT_CRM_Permission_Sets__mdt]; 
        System.debug('crmPermSets: ' + crmPermSets); 
        List<String> crmPermSetDeveloperNames = new List<String>(); 
        for(LMT_CRM_Permission_Sets__mdt permSet : crmPermSets){
            crmPermSetDeveloperNames.add(permSet.DeveloperName); 
        }
        System.debug('crmPermSetDeveloperNames: ' + crmPermSetDeveloperNames);
        //get all the perm set assignments that matter
        List<PermissionSetAssignment> permSetAssignments = [SELECT AssigneeId,PermissionSetId,PermissionSet.Name 
                                                            FROM PermissionSetAssignment 
                                                            WHERE AssigneeId IN:userIds 
                                                            	AND PermissionSet.Name IN:crmPermSetDeveloperNames
                                                            	ORDER BY AssigneeId]; 
        Set<Id> crmUsers = new Set<Id>(); 
        Set<Id> nonCrmUsers = new Set<Id>();
        Set<Id> allUsers = new Set<Id>(); 
        allUsers.addAll(userIds); 
        nonCrmUsers = allUsers; 
         
        for(PermissionSetAssignment assignment : permSetAssignments){
            if(!crmUsers.contains(assignment.AssigneeId)){crmUsers.add(assignment.AssigneeId); }
        }
        nonCrmUsers.removeAll(crmUsers); 
        System.debug('allUsers: ' + allUsers);
        System.debug('crmUsers: ' + crmUsers);
        System.debug('nonCrmUsers: ' + nonCrmUsers);
        
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