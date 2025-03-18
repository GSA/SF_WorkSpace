@isTest
global class reCAPTCHACalloutMockImpl implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake HTTP response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"success":"true"}');
        res.setStatusCode(200);
         System.assertEquals(200, res.getStatusCode());    
        return res;
    }

}