trigger NCMT_TCO_ProjCostRate_trigger on NCMT_Project_Cost_Rate__c (after update) {

    set<id> NCMTIDs = new set<id>();
    
    System.debug('RUN PROJ COST RATE TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
    if(trigger.isAfter && trigger.isUpdate){
        
        for(NCMT_Project_Cost_Rate__c obj :trigger.new){
            NCMTIDs.add(obj.Project_Name__c);
        }
        
        List<NCMT_TCO_HP_Level_of_Service__c> HPLosUpdateList = [Select ID, Name
                                                                    From NCMT_TCO_HP_Level_of_Service__c 
                                                                    where Project_Name__c = :NCMTIDs
                                                                   ];

        update HPLosUpdateList;
            
        
    }
    }
}