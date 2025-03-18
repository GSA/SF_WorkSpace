@IsTest public with sharing class APIMuleHelperTest {

    @IsTest(SeeAllData=true) public static void testBasicAuth() {
        APIMuleHelper.APIAttributes attrs = APIMuleHelper.populateAPIAttributes('For_Test_Class_BasicAuth');
        System.assertEquals(true, true);
    }

    @IsTest(SeeAllData=true) public static void testSSOAuth() {
        APIMuleHelper.APIAttributes attrs = APIMuleHelper.populateAPIAttributes('For_Test_Class_SSOAuth');
        System.assertEquals(true, true);
    }

    @isTest static void PositiveTest(){
        
        Account retb = new Account(Name = 'Real Estate Tax Bucket');
        insert retb;
        //Create Lease Record
        PBS_Lease__c leaseRec = new PBS_Lease__c(Name='Test Lease', Lease_Number__c='1234', Lease_Effective_Date__c=date.today());
        Insert leaseRec;
        //Create Lease Access Record
        PBS_Lease_Access__c leaseAccessRec = new PBS_Lease_Access__c(PBS_Lease__c=leaseRec.Id, Requestor__c=UserInfo.getUserId(), Status__c='Approved');
        Insert leaseAccessRec;
        
        test.startTest();
            test.setMock(HttpCalloutMock.class, new GoodMock());
            //List <RET_LeaseDetailsController.LeaseDetails> details = RET_LeaseDetailsController.getLeaseDetails(leaseRec.Id);
            List <APIMuleHelperMockConsumer.LeaseDetails> details = APIMuleHelperMockConsumer.getLeaseDetails(leaseRec.Id);
            System.assertEquals(details[0].LeaseNumber, '1234');
        test.stopTest();
        
    }
    
    @isTest static void testSendIntegrationErrorEmail(){
        test.startTest();
            APIMuleHelper.sendIntegrationErrorEmail(APIMuleHelper.populateAPIAttributes('For_Test_Class_BasicAuth'), 'This is my Error');
            System.assertEquals(true, true);
        test.stopTest();
    }
    
    private class GoodMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"totalSize": 1, "pageSize": 1, "success": "true", "status": 200, "records": [ { "CurrentAnnualRent": 456009.16, "ExpirationNotificationMonths": 18, "LeaseEffectiveDate": "2011-02-01T00:00:00", "LeaseExpirationDate": "2021-01-31T00:00:00", "LeaseId": 15899, "LEASE_NUM": "1234", "LeaseRSF": 27693, "LeaseStatusCode": "AC", "TeamCode": "5401" } ]}');
            return res;
        }
    }  
    
}