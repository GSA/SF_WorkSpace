trigger NCMT_TCO_AddtlCost_trigger on NCMT_TCO_Additional_Cost__c (before insert,after insert, after update) {

    set<id> NCMTIDs = new set<id>();
    ID addtlcostIds,projCRID ;
    
    System.debug('RUN ADDITIONAL COST TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
    if(trigger.isBefore && trigger.isInsert){
    
        for(NCMT_TCO_Additional_Cost__c obj :trigger.new){
            addtlcostIds = obj.id;
            NCMTIDs.add(obj.Project_Name__c);
        }
        List<NCMT_TCO_Additional_Cost__c> addtlLst = [Select ID
                                                            From NCMT_TCO_Additional_Cost__c 
                                                            where Project_Name__c = :NCMTIDs
                                                           ];
                                                           
        List<NCMT_Project_Cost_Rate__c> projCRList = [Select ID, Name
                                                              From NCMT_Project_Cost_Rate__c
                                                              where Project_Name__c = :NCMTIDs
                                                               ];
             if(projCRList.size()>0){
             //system.debug('projCRList ==='+projCRList);   
                 projCRID = projCRList[0].Id;
             }                                                     
                                                           
        
            for(NCMT_TCO_Additional_Cost__c iter : trigger.new){
                iter.TCO_Project_Cost_Rate__c =projCRID;
            
                if(addtlLst.size()>0){
                    iter.addError('A Project can have only one Additional Cost data record.');
                }
            }
        
                                                          
        
    }
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
    
        for(NCMT_TCO_Additional_Cost__c obj :trigger.new){
            addtlcostIds = obj.id;
            NCMTIDs.add(obj.Project_Name__c);
        }
        
        List<NCMT_TCO_Annual_Cost_Summary__c> AnnualCstUpdateLst = [Select ID, Name,TCO_Addtl_Cost__c 
                                                                    From NCMT_TCO_Annual_Cost_Summary__c
                                                                    where Project_Name__c = :NCMTIDs
                                                                   ];
                                                                   
        for(NCMT_TCO_Annual_Cost_Summary__c ACSLst :AnnualCstUpdateLst){
        
            ACSLst.TCO_Addtl_Cost__c = addtlcostIds;
        
        }                                                           
                                                                                                          
        triggervalue.isPerformanceUpdate = true;
        
        update AnnualCstUpdateLst;
    
    }
    }
}