public with sharing class NCMT_RA_WorkItems_Ctrl {

    @AuraEnabled
    public static list<NCMT_RA_Work_Items__c> saveRaWorkItems(string itemList) {
        system.debug('items list' + itemList);
        List<NCMT_RA_Work_Items__c> itemsToInsert = (List<NCMT_RA_Work_Items__c>) JSON.deserialize(itemList, List<NCMT_RA_Work_Items__c>.class);
        try{
            insert itemsToInsert;
            }catch(Exception e){
              throw new AuraHandledException('this is a thing that is happening : ' + e.getMessage());
            }
            system.debug('items'  + itemsToInsert);
            system.debug('item name'  + itemsToInsert[0].Name);
            system.debug('item cost cat *****'  + itemsToInsert[0].Work_Item_Cost_Category__c );
            system.debug('item cat /////'  + itemsToInsert[0].Work_Item_Category__c);

             return itemsToInsert;
        }
    
}