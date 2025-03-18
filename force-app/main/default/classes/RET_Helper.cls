public with sharing class RET_Helper {
    public static final String COUNTRY_USA = 'United States';
    public static final String RECAPTCHA_CUSTOM_SETTING_NAME = 'RET ReCAPTCHA';

    public static final String VALID_PHONE_REGEX = '^(?:(?:\\+?1\\s*(?:[.-]\\s*)?)?(?:\\(\\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\s*\\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\\s*(?:[.-]\\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})(?:\\s*(?:#|X\\.?|x\\.?|EXT\\.?|ext\\.?|extension)\\s*(\\d+))?$';
    public static final String VALID_EMAIL_REGEX = '[a-zA-Z0-9._+-]+@[a-zA-Z\\.]+.[a-zA-Z]{2,4}';
    public static final String VALID_GOV_EMAIL_REGEX = '(^([\\w-\\._+]+@([\\w]+\\.)+)?(gov|mil|us)$)|(^([\\w-\\._+]+@(salesforce+\\.)+)?(com)$)';

    public static final String ERROR_RECAPTCHA_NOT_CONFIGURED = 'reCaptcha is not configured properly';
    public static final String ERROR_RECAPTCHA_INCOMPLETE = 'Please complete the reCaptcha';
    public static final String ERROR_FIRST_NAME_REQUIRED = 'First Name is required';
    public static final String ERROR_LAST_NAME_REQUIRED = 'Last Name is required';
    public static final String ERROR_EMAIL_REQUIRED = 'Email is required';
    public static final String ERROR_EMAIL_INVALID = 'Email is not valid';
    public static final String ERROR_EMAIL_NOT_GOVERNMENT = 'A ".gov" or ".mil" or ".us" or "salesforce.com" e-mail address is required to register';
    public static final String ERROR_PHONE_INVALID = 'Please enter a valid Phone Number in +1 999-999-9999 or +1 999-999-9999 x999 format';
    public static final String ERROR_AGENCY_REQUIRED = 'Government Agency is required';



    public static Integration_Settings__c TEST_createRecaptchaCustomSettings(){
        Integration_Settings__c recaptchaCS = new Integration_Settings__c(
                Name = RECAPTCHA_CUSTOM_SETTING_NAME,
                Endpoint__c = 'https://www.fakeendpoint.com/',
                Secret_Key__c = '123shhhhItsASecret',
                Site_Key__c = 'mysite!'
        );
        insert recaptchaCS;
        return recaptchaCS;
    }
}