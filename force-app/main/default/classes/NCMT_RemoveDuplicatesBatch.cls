public with sharing class NCMT_RemoveDuplicatesBatch implements Database.Batchable<sObject>, Database.Stateful{
    public final String sObjectType;
    public final String fiscalYear;
    public List<String> assDupes;
    public List<String> desDupes;
    public List<String> assList;
    public List<String> desList;
    public Map<String, Integer> itemDupes;
    public Integer totalCount = 0 ;
    public Map<String, Id> des_toDelete = new Map<String, Id>();
    public List<AggregateResult> aggregateResultRecords;
    
    public NCMT_RemoveDuplicatesBatch( String sObjectType, String fiscalYear, List<AggregateResult> aggregateResultRecords){
        this.sObjectType=sObjectType;
        this.fiscalYear=fiscalYear;
        this.aggregateResultRecords=aggregateResultRecords;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        if(sObjectType == 'NCMT_Assembly_Lookup_detail__c'){
            assDupes = new List<String>();
            for(AggregateResult ar: aggregateResultRecords){
                assDupes.add((String)ar.get('Name'));
            }
            query = 'SELECT Id, Name, File_Type__c FROM NCMT_Assembly_Lookup_detail__c WHERE Fiscal_Year__c = : fiscalYear AND Name IN: assDupes AND GSAAssemblies_Lookup_Items__c = 0 ORDER BY Name DESC';
        }else if(sObjectType == 'NCMT_DES_Lookup_details__c'){
            //Delete outstanding DES Lookup Master duplicates
            desDupes = new List<String>();
            totalCount = aggregateResultRecords.size();
            for(AggregateResult ar: aggregateResultRecords)
            {
                //System.debug(ar.get('Name') + '===' + ar.get('expr0'));
                desDupes.add((String)ar.get('Name'));
            }
            
            System.debug('desDupes: ' + desDupes.size());
            //changing const Fiscal_Year__c - 2021 yr to get it from custom settings 
            List<Id> desWithChild = new List<Id>();
            List<NCMT_Assembly_Lookup_Item__c> hasChild = [SELECT NCMT_Master_Format_Lookup__c, Master_Format_Line_Item_Number__c FROM NCMT_Assembly_Lookup_Item__c WHERE Fiscal_Year__C = : fiscalYear AND Master_Format_Line_Item_Number__c IN : desDupes Limit 50000];
            
            for(NCMT_Assembly_Lookup_Item__c a: hasChild)
            {
                //Create List of DES Master Ids NOT to delete
                //System.debug(a.NCMT_Master_Format_Lookup__c);
                desWithChild.add(a.NCMT_Master_Format_Lookup__c);
            }
            //System.debug('hasChild size: ' + hasChild.size());
            System.debug('des w/ Children: ' + desWithChild.size());
            
            //De-dupe list of Ids
            Set<Id> myset = new Set<Id>();
            List<Id> des_noDelete = new List<Id>();
            myset.addAll(desWithChild);
            des_noDelete.addAll(myset);
            
            System.debug(des_noDelete.size());
            query = 'SELECT Id, Name FROM NCMT_DES_Lookup_details__c WHERE Fiscal_Year__c = : fiscalYear AND Name IN: desDupes AND Id NOT IN: des_noDelete';
        }else if(sObjectType == 'NCMT_Assembly_Lookup_Item__c'){
            itemDupes = new Map<String, Integer>();
            assList = new List<String>();
            desList = new List<String>();
            
            String assNum, desNum;
            Integer count = 0;
            for (AggregateResult ar : aggregateResultRecords)
            {
                assNum = (String)ar.get('ass');
                desNum = (String)ar.get('Master_Format_Line_Item_Number__c');
                count = (Integer)ar.get('expr0');
                
                //System.debug('Ass: ' + ar.get('ass'));
                //System.debug('DES: ' + ar.get('Master_Format_Line_Item_Number__c'));
                //System.debug('Count: ' + ar.get('expr0'));
                
                assList.add(assNum);
                desList.add(desNum);
                itemDupes.put(assNum + '-' + desNum, count);
            }
            query = 'SELECT Id, Total_Cost_OP__c, Assembly_Lookup_Detail__r.Name, Master_Format_Line_Item_Number__c FROM NCMT_Assembly_Lookup_Item__c WHERE Fiscal_Year__c = : fiscalYear AND Assembly_Lookup_Detail__r.Name IN: assList AND Master_Format_Line_Item_Number__c IN: desList ORDER BY Assembly_Lookup_Detail__r.Name, Total_Cost_OP__c';
        }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('scope size '+scope.size());
        if(sObjectType == 'NCMT_Assembly_Lookup_detail__c'){
            //Delete outstanding Assembly Master duplicates
            List<NCMT_Assembly_Lookup_detail__c> assemblyLookupDetailRecords = (List<NCMT_Assembly_Lookup_detail__c>) scope;
            if(assemblyLookupDetailRecords.size() > 0){
                delete assemblyLookupDetailRecords;
            }
        }else if(sObjectType == 'NCMT_DES_Lookup_details__c'){
            //Finally, get Ids of DES masters that are duplicates and do NOT have children
            List<NCMT_DES_Lookup_details__c> toDelete = (List<NCMT_DES_Lookup_details__c>) scope;
            
            //This is the list of DES Items without children
            
            System.debug('toDelete: ' + toDelete.size());
        for(NCMT_DES_Lookup_details__c d : toDelete)
        {
            if(des_toDelete.containsKey(d.Name) == false)
            {
                des_toDelete.put(d.Name, d.Id);
                //System.debug(d.Name);
            }
            //else
                //System.debug('Duplicate! ' + d.Name);
        }
        
        system.debug('FINAL to delete: ' + des_ToDelete.size());
        
        List<NCMT_DES_Lookup_details__C> x = [SELECT Id FROM NCMT_DES_Lookup_details__C
                                             WHERE Id IN: des_toDelete.values()];
        System.debug(x.size());
        
            if(x.size() > 0){
                delete x;
            }
        }else if(sObjectType == 'NCMT_Assembly_Lookup_Item__c'){
            List<NCMT_Assembly_Lookup_Item__c> items = (List<NCMT_Assembly_Lookup_Item__c>) scope;
            
            
            System.debug(itemDupes.size());
            //changing const Fiscal_Year__c - 2021 yr to get it from custom settings 
            System.debug('Assembly Items: ' + items.size());
            
            List<NCMT_Assembly_Lookup_Item__c> itemsToDelete = new List<NCMT_Assembly_Lookup_Item__c>();
            Map<String,Decimal> totalCheck = new Map<String,Decimal>();
            String itemKey = '';
            
            //Loop through items, find ones with Ass/DES combos that are in assDupe
            for(NCMT_Assembly_Lookup_Item__c i : items)
            {
                itemKey = i.Assembly_Lookup_Detail__r.Name + '-' + i.Master_Format_Line_Item_Number__c;
                //System.debug(itemKey);
                
                if(itemDupes.containsKey(itemKey))
                {
                    //System.debug('In duplicate map!');
                    if(!totalCheck.containsKey(itemKey) || totalCheck.get(itemKey) != i.Total_Cost_OP__c)
                    {
                        totalCheck.put(itemKey, i.Total_Cost_OP__c);
                        //itemsToDelete.add(i);
                    }
                    else
                        itemsToDelete.add(i);
                }
                
            }
            System.debug('totalCheck: ' + totalCheck.size());
            SYstem.debug('itemsToDelete: ' + itemsToDelete.size());
            if(itemsToDelete.size() > 0){
            	delete itemsToDelete;
            }
        }
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
}