/*
*********************************************************
Apex Class Name    : LMTUserDataSenderService
Modified Date      : April 07, 2025
@description       : This class is connected through the External Client App in EEO. 
					 It sends user and org data to the LMTUserReceiverService class in EEO 
					 for LMT User creation and LMT License creation and updates.
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-07-2025   Disha Bailoor                        Create.
*********************************************************
*/
public class LMTUserDataSenderService {
    private static final String NAMED_CREDENTIAL = 'LMT_Named_Credential_Client_Creds'; 
    private static final String ENDPOINT = '/services/apexrest/LMTCustomUserReceiver'; 
    private static final String QUEUEABLE_NAME = 'LMTUserDataSenderService_Queueable';
    private static Integer DEFAULT_REQUEST_TIMEOUT = 120000; 
    private static Integer requestTimeout; 
    
    public static void sendUserAndOrgData(List<User> users, Organization org){
        //get the user list and organization information from LMT_UserHandler non-EEO orgs
        //prepare the request body
        Map<String, Object> payload = new Map<String, Object>(); 
        List<Map<String, String>> userList = new List<Map<String, String>>(); 
        
        if(Test.isRunningTest()){ requestTimeout = DEFAULT_REQUEST_TIMEOUT; 
        }else{LMTUserDataSenderService_Chunker chunker = new LMTUserDataSenderService_Chunker(); 
            requestTimeout = chunker.getRequestTimeout();}
                           
        for(User u : users){
            Map<String, String> userMap = new Map<String, String>(); 
            userMap.put('Id', u.Id); 
            userMap.put('Email', u.Email); 
            userMap.put('FederationIdentifier', safeToString(u.FederationIdentifier));
            userMap.put('IsActive', u.IsActive.toString()); 
            userMap.put('User_License__c', safeToString(u.User_License__c));
            userMap.put('LastLoginDate', safeToString(u.LastLoginDate)); 
            userList.add(userMap); 
        }
        
        payload.put('users', userList); 
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
		req.setTimeout(requestTimeout); 
        
        Http http = new Http(); 
        HttpResponse res = http.send(req);
        
        //Handle response
        if(res.getStatusCode() != 200){
            String e = res.getStatusCode() + ' - ' + res.getBody();
            LMTException.throwLMTException(e);
        }
    }
    public static String safeToString(Object input){
        String str = input != null ? String.valueOf(input) : ''; 
        return str; 
    }

}