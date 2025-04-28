@isTest
global class TaxSubmissionSummaryCalloutMockImpl implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake HTTP response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('');
        res.setStatusCode(201);
        return res;
    }

}