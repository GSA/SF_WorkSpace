public with sharing class RET_reCAPTCHAHandler {
    private final String CAPTCHA_DIV_FOR_RESPONSE = 'g-recaptcha-response';
    private final String PARAM_SECRET = 'secret=';
    private final String PARAM_SEPARATOR = '&';
    private final String PARAM_RESPONSE = 'response=';

    public String captchaSiteKey {get; set;}
    private Map<String, Integration_Settings__c> integrationSettings = Integration_Settings__c.getAll();
    private String captchaEndpoint;
    private String captchaSecret;
    private String captchaSolve;
    private String integrationSettingsName;

    // pass null to solveString if you're planning on getting the solve from the page's parameters
    public RET_reCAPTCHAHandler(String intSettingsName, String solveString) {
        integrationSettingsName = intSettingsName;
        captchaSolve = solveString;
        setCaptchaSettings();
    }

    public boolean isVerifiedRecaptcha() {
        String captchaFromUser = getCaptchaSolveFromUser();
        String resp = getGooglesResponseToUsersCaptcha(captchaFromuser);
        return captchaPassed(resp);
    }

    private void setCaptchaSettings(){
        Integration_Settings__c recaptchaSettings = integrationSettings.get(integrationSettingsName);
        if(recaptchaSettings == null) return;
        captchaEndpoint = recaptchaSettings.Endpoint__c;
        captchaSecret = recaptchaSettings.Secret_Key__c;
        captchaSitekey = recaptchaSettings.Site_Key__c; 
    }

    private String getCaptchaSolveFromUser() {
        return ( captchaSolve != null ) ? captchaSolve : ApexPages.currentPage().getParameters().get(CAPTCHA_DIV_FOR_RESPONSE);
    }

    private String getGooglesResponseToUsersCaptcha(String captchaResponse) {
            
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        if (Test.isRunningTest()) {
            req.setEndpoint('dummy');
        }else{
        req.setEndpoint(captchaEndpoint);
        }
        req.setMethod('GET');
        req.setBody(PARAM_SECRET + captchaSecret + PARAM_SEPARATOR + PARAM_RESPONSE + captchaResponse);      
        
        
        if (Test.isRunningTest()) {             
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"success": true}');
            response.setStatusCode(200);
            String resBody = response.getBody();
            return resBody;
        }else{           
            HttpResponse res = h.send(req);
            String resBody = res.getBody();
            return resBody;
        }
    }

    private boolean captchaPassed(String resp) {
        Map<String, Object> respObject = (Map<String, Object>) JSON.deserializeUntyped(resp);
        return(respObject.get('success') == true);
    }
}