public with sharing class NCMT_CEW_WorkItems_Ctrl {
    public class dropdownWrapper{
        @AuraEnabled public map<string, string> abCodeOptions {get; set;}
        @AuraEnabled public map<string, string> workDescOptions {get; set;}
    }

    @AuraEnabled
    public static NCMT_Project_Cost_Summary__c getPCS(string pcsId){
        NCMT_Project_Cost_Summary__c pcs = [SELECT Id,  Cost_Category_Code__c, Cost_Category_Description__c, Project_Name__c, project_name__r.name, Name 
                                            FROM NCMT_Project_Cost_Summary__c
                                            WHERE id = :pcsId];
        return pcs;
    }

    @AuraEnabled
    public static dropdownWrapper populateDropdowns(string projectId){
        dropdownWrapper dropdownOptions = new dropdownWrapper();
        dropdownOptions.workDescOptions = populateWorkDescriptions(projectId);
        dropdownOptions.abCodeOptions = populateAbCodes(projectId);
       
        return dropdownOptions;
    }
    
    public static map<string, string> populateWorkDescriptions(string projectId){
        map<string, string>workDescOptions = new map<string, string>();
        for(NCMT_Work_Description__c workDesc : [SELECT Id, Display_Name__c, Number__c 
                                                FROM NCMT_Work_Description__c
                                                WHERE NCMT_Project__c = :projectId
                                                ORDER BY number__c]){
            workDescOptions.put(workDesc.id, workDesc.Display_Name__c);
            system.debug('workDescOptions' + workDescOptions);
            }
            return workDescOptions;
    }
    public static map<string, string> populateAbCodes(string projectId){
        map<string, string>abCodeOptions = new map<string, string>();
        for(NCMT_CEW_Project_Agency__c abCode : [SELECT Id,  Display_Name__c, AB_Code__c	
                                                FROM NCMT_CEW_Project_Agency__c 
                                                WHERE NCMT_Project__c = :projectId
                                                ORDER BY AB_Code__c]){
            abCodeOptions.put(abCode.id, abCode.Display_Name__c);
            system.debug('abCodeOptions' + abCodeOptions);
            }
            return abCodeOptions;
    }
    @AuraEnabled
    public static list<NCMT_CEW_Work_Item__c> getCewItems(string pcsId){
        list<NCMT_CEW_Work_Item__c> cewItems = [SELECT id, Name, Description__c, WorkDescNumber__c, AB_Code__c, Work_Item_Code__c
                                                FROM  NCMT_CEW_Work_Item__c
                                                WHERE Project_Cost_Summary__c = :pcsId];
         return cewItems;
    }
        
    @AuraEnabled
    public static list<NCMT_CEW_Work_Item__c> saveCewItems(string itemList) {
        List<NCMT_CEW_Work_Item__c> itemsToInsert = (List<NCMT_CEW_Work_Item__c>) JSON.deserialize(itemList, List<NCMT_CEW_Work_Item__c>.class);
        
        try{
            insert itemsToInsert;
            }catch(Exception e){
              throw new AuraHandledException(e.getMessage());
            }
            return itemsToInsert;
    }
}