/*
*********************************************************
Apex Class Name    : LMTMockHttpResponse
Modified Date      : April 07, 2025
@description       : This is a test callout class for LMTUserDataSenderService, LMTUserDataSenderService_Test.
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-07-2025   Disha Bailoor                        Create.
*********************************************************
*/
public class LMTMockHttpResponseSuccess implements HttpCalloutMock{
    public Integer lastStatusCode; 
    public String lastResponseBody; 
    
    public HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse(); 
        res.setStatusCode(200); 
        res.setBody('{"message": "Data processed successfully"}'); 
        
        lastStatusCode = res.getStatusCode(); 
        lastResponseBody = res.getBody(); 
        return res; 
    }
    public Integer getLastResponseStatusCode(){
        return lastStatusCode; 
    }
    public String getLastResponseBody(){
        return lastResponseBody; 
    }
}