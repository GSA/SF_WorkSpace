//public with sharing class PBS_AAAP_Utility {
public class PBS_AAAP_Utility {
    public static string getQueryParamAsString(string paramName) {
        return ApexPages.currentPage().getParameters().get(paramName);
    }
    public static decimal getQueryParamAsDecimal(string paramName) {
        return getQueryParamAsDecimal(paramName, 0);
    }
    public static decimal getQueryParamAsDecimal(string paramName, decimal defaultValue) {
        try {
            return decimal.valueOf(getQueryParamAsString(paramName));
        } catch (Exception ex) {
            return defaultValue;
        }
    }
    public static void setQueryParam(string paramName, string val) {
        ApexPages.currentPage().getParameters().put(paramName, val);
    }
    public static void logMethodStart(string methodName){
        system.debug(methodName+' vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
    }
    public static  void logMethodEnd(string methodName){
        system.debug(methodName+' ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    }
    public static  void logMethodEnd(string methodName, object ret){
        logMethodEnd(methodName);
    }
    /*public static String getCommunityBaseURL(){
        Id currentNetworkId = Network.getNetworkId();
        Network n;
        if(currentNetworkId != null) {
            n = [SELECT Id, Name, UrlPathPrefix FROM Network WHERE Id = :currentNetworkId];
        }
        String relativeURL = '/' + ((currentNetworkId != null) ? n.UrlPathPrefix : '');  
        return relativeURL;  
    } */
    public static String getCommunityURL(string url){
        if(url.startsWith('/')){
            url = url.replaceFirst('/', '');
        }
        List<Site_Page_Name_With_Community_Page__mdt> allRecords = Site_Page_Name_With_Community_Page__mdt.getAll().values();
        for(Site_Page_Name_With_Community_Page__mdt mdtRecord : allRecords){
            if(url.toLowercase().contains(mdtRecord.Label.toLowercase())){
                if(url.contains('?')){
                    String urlBefore = url.substringBefore('?');
                    String urlAfter = url.substringAfter('?');
                    System.debug(urlBefore);
                    System.debug(urlBefore.replace(mdtRecord.Label, mdtRecord.Community_Page__c));
                    url = urlBefore.replace(mdtRecord.Label, mdtRecord.Community_Page__c)+'?'+urlAfter;//.toLowercase()
                }else{
                    url = url.replace(mdtRecord.Label, mdtRecord.Community_Page__c);
                }
                return url;//toLowercase().
            }
            
        }
        
        return '';
    }
}