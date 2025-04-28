@isTest
global class PBS_AAAP_CalloutMockImpl implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake HTTP response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"success":"false"}');
        res.setStatusCode(401);
         System.assertEquals(401, res.getStatusCode());    
        return res;
    }

}