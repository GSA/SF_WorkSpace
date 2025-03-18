@isTest
private with sharing class RET_reCAPTCHAHandlerTest {

    @isTest
    private static void testRET_reCAPTCHAHandler_InputValidCustomSettingsNameAndTestSolve_ReturnsVerifiedRecaptcha(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RET_reCAPTCHAMockCallout()); 
        RET_reCAPTCHAHandler handler = new RET_reCAPTCHAHandler(
                RET_Helper.RECAPTCHA_CUSTOM_SETTING_NAME,
                'iSolvedIt!'
        );
        Boolean result = handler.isVerifiedRecaptcha();
        System.assertEquals(true, result);
        Test.stopTest();
    }

    @testSetup
    private static void createTestData(){
        Integration_Settings__c recaptchaCS = RET_Helper.TEST_createRecaptchaCustomSettings();
        System.assertNotEquals(null, recaptchaCS.Id);
    }

}