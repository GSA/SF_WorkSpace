public class reCAPTCHA {

    // The API endpoint for the reCAPTCHA service
    private String baseUrl; 

    // The keys you get by signing up for reCAPTCHA for your domain
    public String privateKey {get; set;}
    public String publicKey {get; set;}
    
    // Create properties for the non-VF component input fields generated
    // by the reCAPTCHA JavaScript.
    public String response  { 
        get {                
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response');}
    }
    
    // Whether the submission has passed reCAPTCHA validation or not
    public Boolean verified { get; set; }
    
    public reCAPTCHA() {
        this.verified = false;
        AAAP_Captcha_Settings__c captchaSettings = AAAP_Captcha_Settings__c.getOrgDefaults();
        publicKey = captchaSettings.Public_Key__c;
        privatekey = captchaSettings.Private_Key__c;
        baseUrl = captchaSettings.Endpoint_URL__c;
    }
    
    public Boolean verify() {
        // On first page load, form is empty, so no request to make yet           
//        if (Test.isRunningTest()) {return true;} 
//            else
//            {
                if (response == null) { return false;}
//            }

if (Test.isRunningTest()) {baseUrl='dummy';}            
                   
        HttpResponse r = makeRequest(baseUrl,
            'secret=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&response='  + response
        );
     
        
        if ( r != null ) {
            this.verified = Boolean.valueOf(getValueFromJson(r.getBody(), 'success'));
        }
        
        if(this.verified) {
            // If they pass verification, you might do something interesting here
            // Or simply return a PageReference to the "next" page
            return true;
        }
        else {
            // stay on page to re-try reCAPTCHA
            return false; 
        }
    }

    /* Private helper methods */
    @TestVisible
    private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();  
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody (body);
        try {
if (Test.isRunningTest()) {             
response = new HttpResponse();
response.setHeader('Content-Type', 'application/json');
response.setBody('{"success":"true"}');
response.setStatusCode(200);
}else{        
            Http http = new Http(); 
            response = http.send(req);
}
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
        
    private String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null) ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)  ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }

    private static string getValueFromJson ( String strJson, String field ){
        JSONParser parser = JSON.createParser(strJson);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                if(parser.getText() == field){
                    // Get the value.
                    parser.nextToken();
                    return parser.getText();
                }
            }
        }
        return null;
    }
}