@IsTest public with sharing class APIArcGISHelperTest {

    @isTest static void PositiveTest(){
        
        Boolean sandbox = APIArcGISHelper.runningInSandbox();
        test.startTest();
            test.setMock(HttpCalloutMock.class, new GoodMock());
            String token = APIArcGISHelperMockConsumer.getArcGISToken('Sandbox');
            System.assertEquals(token, '1234');
        test.stopTest();
        
    }
    
    @isTest static void NegativeTest(){
        
        test.startTest();
            test.setMock(HttpCalloutMock.class, new GoodMock());
            String token = APIArcGISHelperMockConsumer.getArcGISToken2('Sandbox');
            String check = token.substring(0,18);
            System.assertEquals(check, 'There was an issue');
        test.stopTest();
        
    }   
     
    private class GoodMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"token": 1234}');
            return res;
        }
    }  
    
}