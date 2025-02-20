public with sharing class NCMT_DES_Tree_Structure_TriggerHandler {
    private final List<NCMT_Tree_structure__c> oldList { get; set; }
	private final List<NCMT_Tree_structure__c> newList { get; set; }
	private final Map<Id, NCMT_Tree_structure__c> oldMap { get; set; }
    private final Map<Id, NCMT_Tree_structure__c> newMap { get; set; }
    
    public static Boolean triggerHandlerUpdate = false;

    public NCMT_DES_Tree_Structure_TriggerHandler(List<NCMT_Tree_structure__c> oldLst, List<NCMT_Tree_structure__c> newLst, Map<Id, NCMT_Tree_structure__c> oldMp, Map<Id, NCMT_Tree_structure__c> newMp) {
		oldList = (oldLst == null ? new List<NCMT_Tree_structure__c>() : oldLst);
		newList = (newLst == null ? new List<NCMT_Tree_structure__c>() : newLst);
		oldMap = (oldMp == null ? new Map<Id, NCMT_Tree_structure__c>() : oldMp);
        newMap = (newMp == null ? new Map<Id, NCMT_Tree_structure__c>() : newMp);
        
    }

    public void includeUpdates(){
        if (!triggerHandlerUpdate){
            Set<Id> treeChanges = new Set<Id>();
            //Update Include in Estimate for child tree structures
            Boolean newVal; //Always 1 record at a time so can get away this single variable for this
            for(NCMT_Tree_Structure__c t : newList)
            {
                
                Boolean oldVal = oldMap.get(t.Id).Include_in_Estimate__c;
                newVal = newMap.get(t.Id).Include_in_Estimate__c;
                
                if(newVal != oldVal)
                {
                    treeChanges.add(t.Id);
                }
            }
            
            if (treeChanges.size() > 0)
                futureIncludeUpdate(treeChanges, newVal);
        }
    }

    @future
    public static void futureIncludeUpdate(Set<Id> treeChanges, Boolean includeEstimate){

        List<NCMT_Tree_Structure__c> children = [SELECT Id, Name, Include_in_Estimate__c, Relatedtree__r.Include_in_Estimate__c
                                                FROM NCMT_Tree_Structure__c
                                                WHERE Relatedtree__c in: treeChanges OR Relatedtree__r.Relatedtree__c in: treeChanges
                                                OR Relatedtree__r.Relatedtree__r.Relatedtree__c in: treeChanges 
                                                OR Relatedtree__r.Relatedtree__r.Relatedtree__r.Relatedtree__c in: treeChanges
                                                OR Relatedtree__r.Relatedtree__r.Relatedtree__r.Relatedtree__r.Relatedtree__c in: treeChanges
                                                
                                                ];
        Set<Id> childIds = new Set<Id>();
        for(NCMT_Tree_Structure__c child: children)
        {  
            childIds.add(child.Id);
            child.Include_In_Estimate__c = includeEstimate;
            
        }
        
        triggerHandlerUpdate = true;
        update children;

        List<NCMT_DES_Items__c> childItems = [Select Id, Include_in_Estimate__c
                                             from NCMT_DES_Items__c
                                             where Tree_structure__c IN: childIds OR Tree_structure__c IN: treeChanges];
        for (NCMT_DES_Items__c item : childItems){
            item.Include_in_Estimate__c = includeEstimate;
        }
        update childItems;

        //Can only query for 5 descendants at a time, so lets get the remaining descendants
        List<NCMT_Tree_Structure__c> grandchildren = [SELECT Id, Name, Include_in_Estimate__c
                                                FROM NCMT_Tree_Structure__c
                                                WHERE Relatedtree__c in: childIds OR Relatedtree__r.Relatedtree__c in: childIds
                                                OR Relatedtree__r.Relatedtree__r.Relatedtree__c in: childIds 
                                                OR Relatedtree__r.Relatedtree__r.Relatedtree__r.Relatedtree__c in: childIds
                                                OR Relatedtree__r.Relatedtree__r.Relatedtree__r.Relatedtree__r.Relatedtree__c in: childIds
                                                
                                                ];
        childIds = new Set<Id>();
        for(NCMT_Tree_Structure__c child: grandchildren)
        {
            childIds.add(child.Id);
            child.Include_In_Estimate__c = includeEstimate;
        }
        
        triggerHandlerUpdate = true;
        update grandchildren;

        childItems = [Select Id, Include_in_Estimate__c 
                                             from NCMT_DES_Items__c
                                             where Tree_structure__c IN: childIds OR Tree_structure__c IN: treeChanges];
        for (NCMT_DES_Items__c item : childItems){
            item.Include_in_Estimate__c = includeEstimate;
        }
        update childItems;
    }
}