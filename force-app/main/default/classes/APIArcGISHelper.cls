public with sharing class APIArcGISHelper {
    
    private static Integer DEFAULT_TIMEOUT = 60000; // one minute in milliseconds
    public static String GIS_URL_PREFIX;
    public static String GIS_LOCATOR_URL;
    public static String GIS_LOCATOR;
 
    public static HttpRequest getRequest(String apiModel) {

        ArcGIS_API__mdt apiMetadata = APIArcGISMetadataModel.lookupAPICustomMetaData(apiModel);
        if (apiMetadata == null) {
            System.debug('APIArcGISHelper.getRequest(), apiModel provided was not found, returning null.');
            return null;
        }

        GIS_URL_PREFIX = apiMetadata.GIS_URL_Prefix__c;
        GIS_LOCATOR_URL = apiMetadata.GIS_Locator_URL__c;
        GIS_LOCATOR = apiMetadata.GIS_Locator__c;
        HttpRequest req = new HttpRequest();
        String username = apiMetadata.Username__c;
        String password = apiMetadata.Password__c;
        String expiration = String.valueOf(apiMetadata.Token_Expiration_Minutes__c);
        req.setEndpoint('callout:' + apiMetadata.Named_Credential__c + apiMetadata.Token_URI__c);
        req.setMethod('POST');
        req.setTimeout(Integer.valueOf(apiMetadata.Token_Service_Timeout_Milliseconds__c != null ? apiMetadata.Token_Service_Timeout_Milliseconds__c : DEFAULT_TIMEOUT));
        req.setBody('username='+EncodingUtil.urlEncode(username,'UTF-8') + '&password='+EncodingUtil.urlEncode(password,'UTF-8') + '&referer='+EncodingUtil.urlEncode('N/A','UTF-8') + '&expiration='+EncodingUtil.urlEncode(expiration,'UTF-8') + '&f='+EncodingUtil.urlEncode('pjson','UTF-8'));    
        
        return req;
        
    }
          
    public static String getArcGISToken(HttpRequest req) {

        Http http = new Http();
        String errMsg = '';
        String aToken = '';
        HTTPResponse res = null;
        try {
            res = http.send(req);
            System.debug('res.getBody() ' + res.getBody());
            System.debug('res.getStatusCode() ' + res.getStatusCode());
            System.debug('res.getStatus() ' + res.getStatus());
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'token')) {
                    // Get the value.
                    parser.nextToken();
                    // grab the GIS token value.
                    aToken = parser.getText();
                    break;
                }
            }
            return aToken;
        } catch (Exception e) {
            System.debug(e.getMessage() + ' caught trying to retrieve token from GSA GIS REST Service.');
            errMsg = e.getMessage();
        }
        //if (response.getStatusCode() != 200) {
        //    System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        // } else {
        //    System.debug(response.getBody());
        //}
        return 'There was an issue retrieving a token from GSA GIS REST Service. ' + errMsg;
        //return 'Did not call for token';        
                                   
    }  

    public static Boolean runningInSandbox(){
        return [Select IsSandbox from Organization limit 1].IsSandbox;
    }
    
}