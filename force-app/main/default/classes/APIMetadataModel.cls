public With Sharing class APIMetadataModel {

    private static List<Mule_API__mdt> pcustomMetadataList = null;
    public static List<Mule_API__mdt> customMetadataList {
        get {
            if (pcustomMetadataList == null) {
                pcustomMetadataList = [select Id, DeveloperName, Username__c, Password__c,Base_URL__c, 
                                       Timeout_Value__c, Error_Email_Subject__c, Error_Email_Body_Prelude__c,
                                       Error_Email_Sender_Name__c, Error_Email_To_Address1__c, Authentication_Type__c,
                                       Error_Email_To_Address2__c, Client_Id__c, Client_Secret__c, VFilters__c, filterType__c
                                       from Mule_API__mdt where Is_Active__c = true]; 
            }
            return pcustomMetadataList;
        } 
    }
    
    private static Map<String,Mule_API__mdt> pcustomMetadataMap = null;
    public static Map<String,Mule_API__mdt> customMetadataMap {
        get {
            if ( pcustomMetadataMap == null){
                pcustomMetadataMap = new Map<String,Mule_API__mdt>(); 
                for(Mule_API__mdt rt : customMetadataList){
                    pcustomMetadataMap.put(rt.DeveloperName, rt);
                } 
            }
            return pcustomMetadataMap;
        }
    }
    
    public static Mule_API__mdt lookupAPICustomMetaData (String keyName){
        System.Debug('APIMetadataModel.LookupCustomMetada starting...');
        if(customMetadataMap.containsKey(keyName)){          
            return customMetadataMap.get(keyName);
        }else { 
            //unable to locate
            System.Debug('APIMetadataModel.LookupCustomMetada unable to locate '+ keyName);
            return null;
        }  
    }
    
    
    
}