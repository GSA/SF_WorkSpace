public with sharing class APIArcGISMetadataModel {

    private static List<ArcGIS_API__mdt> pCustomMetadataList = null;
    public static List<ArcGIS_API__mdt> customMetadataList {
        get {
            if (pCustomMetadataList == null) {
                pCustomMetadataList = [select Id, DeveloperName, Username__c, Password__c, Named_Credential__c,
                                       Token_URI__c, Token_Service_Timeout_Milliseconds__c, Token_Expiration_Minutes__c,
                                       GIS_URL_Prefix__c, GIS_Locator_URL__c, GIS_Locator__c
                                       from ArcGIS_API__mdt where Is_Active__c = true]; 
            }
            return pCustomMetadataList;
        } 
    }
    
    private static Map<String, ArcGIS_API__mdt> pCustomMetadataMap = null;
    public static Map<String, ArcGIS_API__mdt> customMetadataMap {
        get {
            if (pCustomMetadataMap == null){
                pCustomMetadataMap = new Map<String, ArcGIS_API__mdt>(); 
                for(ArcGIS_API__mdt rt : customMetadataList){
                    pCustomMetadataMap.put(rt.DeveloperName, rt);
                } 
            }
            return pCustomMetadataMap;
        }
    }
    
    public static ArcGIS_API__mdt lookupAPICustomMetaData (String keyName){
        System.Debug('APIArcGISMetadataModel.LookupCustomMetada() starting...');
        if(customMetadataMap.containsKey(keyName)){          
            return customMetadataMap.get(keyName);
        }else { 
            //unable to locate
            System.Debug('APIArcGISMetadataModel.LookupCustomMetada() unable to locate '+ keyName);
            return null;
        }  
    }
    
}