/*
*********************************************************
Apex Class Name    : LMTMockHttpResponse
Modified Date      : April 14, 2025
@description       : This is a test callout class for LMTUserDataSenderService, LMTUserDataSenderService_Test.
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-07-2025   Disha Bailoor                        Create.
*********************************************************
*/
public class LMTMockHttpResponseFailure implements HttpCalloutMock{
    
    public HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse(); 
        res.setStatusCode(500); 
        res.setBody('{"message": "Data process failed."}');  
        return res; 
    }
}