public with sharing class PBS_Project_TriggerHandler {     
    public static void OnAfterUpdate(list<PBS_Project__c> updObjects, Map<Id, PBS_Project__c> triggerOldMap) {
        Set<ID> projName = new Set<ID>();
        List<PBS_Project__c> lstRecs = new List<PBS_Project__c>();
        List<PBS_Small_Projects_Historical_Database__c> lstSPHD = new List<PBS_Small_Projects_Historical_Database__c>();
        map<String,String> gtMap =new map<String,String>();      
        
        try{
            for(PBS_Project__c obj:updObjects){
                if (obj.txtProjectDescription__c <> triggerOldMap.get(obj.ID).txtProjectDescription__c){        
                    projName.add(obj.ID);
                    gtMap.put(obj.ID, obj.txtProjectDescription__c);
                }                   
            }
            
            if (projName != null && projName.size() > 0){
                List<PBS_Small_Projects_Historical_Database__c> gtList = [SELECT ID, PBS_Project_Name__c
                                                                        FROM PBS_Small_Projects_Historical_Database__c 
                                                                        WHERE PBS_Project_Name__c IN :projName];
                                                               
                if(gtList != null && gtList.size() > 0){ 
                    for(PBS_Small_Projects_Historical_Database__c sphd:gtList){
                        sphd.Scope_Description__c = gtMap.get(sphd.PBS_Project_Name__c); 
                        lstSPHD.add(sphd);                 
                    }
                    update lstSPHD;
                }
            }
        }         
        catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            }    
     }     
}