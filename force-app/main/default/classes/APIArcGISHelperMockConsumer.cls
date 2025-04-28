public class APIArcGISHelperMockConsumer {

    
    @AuraEnabled(cacheable=true)
    public static String getArcGISToken(String env){ 

        HttpRequest request = APIArcGISHelper.getRequest('Sandbox');
        String token = APIArcGISHelper.getArcGISToken(request);
        
        return token;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static String getArcGISToken2(String env){ 

        String token = APIArcGISHelper.getArcGISToken(null);
        
        return token;
        
    }
}