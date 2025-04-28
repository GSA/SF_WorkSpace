public class RET_GREX_API_ServiceImpl extends RET_HttpResource_Abstract{
    
    Public Object handleGREXCall(String Body, RET_GREX_API_Integration__mdt GREXMdt){
        GREX_CreateAPIRequest(Body, GREXMdt);
        doCallout();
        return getResponseObject();
    }
    
    Private void GREX_CreateAPIRequest(String BODY, RET_GREX_API_Integration__mdt Mdt){
        request = super.createRequest(Mdt.HTTP_Method__c);
        request.setHeader(HEADER_CONTENT_TYPE, HEADER_AUTHORIZATION);
        Boolean isSandbox = [Select Id, Name, IsSandbox from Organization].IsSandbox;
        String Endpoint = isSandbox ==true? 'callout:GREX_WebApi_NonProd' +Mdt.API_Endpoint__c : 'callout:GREX_WebApi' +Mdt.API_Endpoint__c;
        request.setEndpoint(Endpoint);
        request.setTimeout(DEFAULT_TIMEOUT);
        if(BODY!=null){request.setBody(BODY);}
    } 
    
    Public override Object getResponseObject(){
        return handleResponse();
    }
    
    Private string handleResponse(){
        Integer statusCode = getResponseStatusCode();
        if(isStatusCodeOk())
            return getResponseBody();
        else
           throw new RET_HttpResourceException('Status Code ' + statusCode + ' Exception Occured : ' +getResponseBody());
    }
}