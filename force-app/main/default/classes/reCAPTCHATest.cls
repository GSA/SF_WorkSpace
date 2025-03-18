@isTest(SeeAllData=false)
public class reCAPTCHATest {

    @isTest
    static void testCaptcha() {

        Test.startTest();
            Boolean captchaResult;

            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new reCAPTCHACalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.PBS_AAAP_UserRegistration'));
            
            // first try, no google response.
            reCAPTCHA captcha = new reCAPTCHA();
            //captchaResult = captcha.verify();
            //System.assertEquals(false, captchaResult);

            // set google response now.
            System.currentPageReference().getParameters().put('g-recaptcha-response', 'testGoogleResponse');
            captchaResult = captcha.verify();
            System.assertEquals(true, captchaResult);

            HttpResponse res = reCAPTCHA.makeRequest('http://test.mock.url', 'testString');
            
            // Verify response received contains fake values.
            String contentType = res.getHeader('Content-Type');
            System.assert(contentType == 'application/json');
            String actualValue = res.getBody();
            String expectedValue = '{"success":"true"}';
            System.assertEquals(actualValue, expectedValue);
            System.assertEquals(200, res.getStatusCode());          

        Test.stopTest();
    }


    @testSetup
    static void createTestData() {

        AAAP_Captcha_Settings__c settings = new AAAP_Captcha_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(),
                                                                     Public_Key__c = 'TestPublicKey',
                                                                     Private_Key__c = 'TestPrivateKey',
                                                                     Endpoint_URL__c = 'http://test.mock.url');
        insert settings;
        
        AAAP_Captcha_Settings__c settingcreated = [SELECT ID,Public_Key__c FROM AAAP_Captcha_Settings__c WHERE Public_Key__c = 'TestPublicKey'];
         System.assertEquals('TestPublicKey', settingcreated.Public_Key__c);


    }


}