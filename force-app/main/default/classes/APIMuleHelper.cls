public With Sharing class APIMuleHelper {
    
    private static Decimal TIMEOUT = 120000;
    private static String BASIC = 'Basic';
    private static String KEYS = 'Keys';
    private static String SSO = 'SSO';
    
    public static APIAttributes populateAPIAttributes(String apiModel){
        System.debug('APIMuleHelper.populateAPIAttributes begins for apiModel: ' + apiModel);
        Mule_API__mdt apiMetadata = APIMetadataModel.lookupAPICustomMetaData(apiModel);
        System.debug('APIMuleHelper.populateAPIAttributes(), attributes retrieved: ' + apiMetadata);
        
        APIAttributes attributes = new APIAttributes();
        if (apiMetadata == null) {
            System.debug('APIMuleHelper.populateAPIAttributes(), apiModel provided was not found, returning null.');
        } else {
            attributes.baseEndPoint = String.isNotBlank(apiMetadata.Base_URL__c) ? apiMetadata.Base_URL__c : null;
            attributes.vfilters = String.isNotBlank(apiMetadata.VFilters__c) ? apiMetadata.VFilters__c : null;
            attributes.timeoutValue = apiMetadata.Timeout_Value__c != null ? apiMetadata.Timeout_Value__c : TIMEOUT;
            attributes.filterType = apiMetadata.filterType__c != null ? apiMetadata.filterType__c : null;
            attributes.httpHeaders = new Map<String,String>();
            if (apiMetadata.Authentication_Type__c == BASIC) {
                attributes.httpHeaders.put('Authorization','Basic ' + EncodingUtil.base64Encode(Blob.valueOf(apiMetadata.UserName__c + ':' + apiMetadata.Password__c)));
                attributes.httpHeaders.put('Content-Type', 'application/json');
            }
            if (apiMetadata.Authentication_Type__c == KEYS) {
                attributes.httpHeaders.put('client_id', apiMetadata.Client_Id__c);
                attributes.httpHeaders.put('client_secret', apiMetadata.Client_Secret__c);
            }

            if (apiMetadata.Authentication_Type__c == SSO) {
                attributes.httpHeaders.put('client_id', apiMetadata.Client_Id__c);
                attributes.httpHeaders.put('client_secret', apiMetadata.Client_Secret__c);
            }
            attributes.additionalParams = new Map<String,String>();
            attributes.additionalParams.put('Timeout', String.valueOf(attributes.timeoutValue));
            attributes.errorEmailSubject = apiMetadata.Error_Email_Subject__c;
            attributes.errorEmailBodyPrelude = apiMetadata.Error_Email_Body_Prelude__c;
            attributes.errorEmailSenderName = apiMetadata.Error_Email_Sender_Name__c;
            attributes.errorEmailToAddress1 = apiMetadata.Error_Email_To_Address1__c;
            attributes.errorEmailToAddress2 = apiMetadata.Error_Email_To_Address2__c;
        }
        System.debug('APIMuleHelper.populateAPIAttributes ends.');
        return attributes;
    }
    
    public static HttpResponse executeAPI(String className, String endPoint, Blob bodyAsBlob, 
                                           Map<String, String> requestHeaders, String httpMethod,
                                           Map<String, String> params)
    {
        system.debug('APIMuleHelper.executeAPI begins.');    
        HttpResponse response  = null;
        HttpRequest request = null;
        
        try{
            request = prepareRequest(endPoint, bodyAsBlob, requestHeaders, httpMethod, params);
            response = getResponse(request);
        }catch(Exception e){
            system.debug('APIMuleHelper.executeAPI exception occured trace, '+e.getStackTraceString());
            system.debug('APIMuleHelper.executeAPI exception occured message, '+e.getMessage());
            system.debug('APIMuleHelper.executeAPI exception occured cause, '+e.getCause());
        }
        system.debug('APIMuleHelper.executeAPI ends, sending response.');
        return response;                                      
                                               
    }   
    
    private static HttpRequest prepareRequest(String endPoint, Blob bodyAsBlob, 
                                                  Map<String, String> httpHeaderMap, String httpMethod,
                                                  Map<String, String> params)
    { 
        
        List<Mule_API__mdt> muleApiMetadataRecords = [SELECT id, Base_URL__c FROM Mule_API__mdt];
        Set<String> allowedBaseUrls = new Set<String>();
        for (Mule_API__mdt mule : muleApiMetadataRecords) {
            allowedBaseUrls.add(mule.Base_URL__c);
        }
        
        system.debug('APIMuleHelper.prepareRequest begins.');
        system.debug('APIMuleHelper.prepareRequest httpHeaderMap : '+httpHeaderMap);
        HttpRequest request = new HttpRequest();
        
        String endPointUrl = allowedBaseUrls.contains(endpoint) ? endpoint : endpoint; 
        
        request.setEndpoint(endPointUrl);
        request.setMethod(httpMethod); 
        
        for(String p : params.keySet()){
            if(p == 'Timeout'){
                request.setTimeout(Integer.valueOf(params.get(p)));
            }
        }
        for (String key: httpHeaderMap.keySet()){
            request.setHeader(key, httpHeaderMap.get(key));
        }
        
        if (bodyAsBlob != null) {
            request.setBodyAsBlob(bodyAsBlob);
        }
        
        system.debug('APIMuleHelper.prepareRequest ends.');
        return request;
    }
    
    private static HttpResponse getResponse(HttpRequest request){
        system.debug('APIMuleHelper.getResponse begins.');
        Http http = new Http();
        HttpResponse response;
        try{
            response = http.send(request);
            system.debug('APIMuleAelper.getResponse response is : '+response);
        }catch (Exception exp){
            system.debug('APIMuleHelper.getResponse Exception occured is : '+exp.getMessage());
            system.debug('APIMuleHelper.getResponse Exception occured stacktrace is : '+exp.getStackTraceString());
            
        }
        system.debug('APIMuleHelper.getResponse ends.');
        return response;        
    }

    public static void sendIntegrationErrorEmail(APIAttributes apiAttributes, String error) {
        if(apiAttributes != null) {               
            try {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSenderDisplayName(apiAttributes.errorEmailSenderName);
                List<String> toAddresses = new List<String>();
                if (String.isNotEmpty(apiAttributes.errorEmailToAddress1)) toAddresses.add(apiAttributes.errorEmailToAddress1);
                if (String.isNotEmpty(apiAttributes.errorEmailToAddress2)) toAddresses.add(apiAttributes.errorEmailToAddress2);
                mail.setToAddresses(toAddresses);
                mail.setSubject(apiAttributes.errorEmailSubject);
                mail.setHtmlBody(apiAttributes.errorEmailBodyPrelude + error);
                if (Test.isRunningTest() == false) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            } catch(Exception e) {
                String msg = 'Unable to send error email with error message: ' + error + ', due to messaging error: ' + e.getMessage();
                System.debug('APIMuleHelper.sendIntegrationErrorEmail, ' + msg);
            }
        }
    }

    public static Boolean runningInSandbox(){
        return [Select IsSandbox from Organization limit 1].IsSandbox;
    }
    
    public class APIAttributes{

        public String baseEndPoint{get;set;}
        public String vfilters{get;set;}
        public Decimal timeoutValue{get;set;}
        public Map<String, String> httpHeaders{get;set;}
        public Map<String, String> additionalParams{get;set;}
        public String errorEmailSubject{get;set;}
        public String errorEmailBodyPrelude{get;set;}
        public String errorEmailSenderName{get;set;}
        public String errorEmailToAddress1{get;set;}
        public String errorEmailToAddress2{get;set;}
        public String filterType{get;set;} 
    }

}