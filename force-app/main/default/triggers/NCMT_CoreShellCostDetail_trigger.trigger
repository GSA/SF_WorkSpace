trigger NCMT_CoreShellCostDetail_trigger on NCMT_Core_Shell_Cost_Detail__c (after insert, after update) {
    
       set<id> coreShellIds = new set<id>();
       set<id> PCSIds = new set<id>();
       set<id> NCMTIdsset = new  set<id>();
       //set<id> NPVSummaryIds = new  set<id>();
       map<id,NCMT_Project_Cost_Summary__c> PCSmap = new map<id,NCMT_Project_Cost_Summary__c>();
       String strNCMTIDs,strCostType,strNCMTID,strProjID,strProjIDs ;
       map<string,decimal> totalJanCostMap = new map<string,decimal>();
       decimal totalJanCost =0.00,totalRepairCost=0.0,totalMaintCost=0.0,totalWaterCost=0.0,totalControlsCost=0.0,totcount =0.0;
       
    System.debug('RUN CORE SHELL TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
       //TCO Lifecycle update
       if(trigger.isAfter &&trigger.isUpdate)
       {
              if(triggervalue.isCostUpdate == false){
                     //For TCO Only logic
                     Id tcoRecordTypeId = NCMT_Utilities.getProjectRecordTypeId('New_Construction_TCO');
                     Set<Id> tcoProjIds = new Set<Id>();    
                     for(NCMT_Core_Shell_Cost_Detail__c iter:trigger.new)
                     {
                            if (iter.Project_Record_Type_Id__c == tcoRecordTypeId)
                                   tcoProjIds.add(iter.NCMT_Project_ID__c);
                     }
                     if (tcoProjIds.size() > 0) NCMT_TCO_Lifecycle_Input_TriggerHandler.futureUpdateByProject(tcoProjIds);

              }
       }
      if(trigger.isAfter && trigger.isUpdate)
     {
         //triggervalue.isPerformanceUpdate = true;
        if(triggervalue.isCostUpdate == false){
         for(NCMT_Core_Shell_Cost_Detail__c iter:trigger.new)
            {
                coreShellIds.add(iter.id);
                strProjID = iter.NCMT_Project_ID__c;
                //PCSIds.add(iter.Project_Cost_Summary__c);
            }
            
           /* for(NCMT_Project_Cost_Summary__c ncmtprojcostsummary : [Select id, Project_Name__c From NCMT_Project_Cost_Summary__c where id in :PCSIds]){
                PCSmap.put(ncmtprojcostsummary.Id,ncmtprojcostsummary);
                strNCMTIDs = (ncmtprojcostsummary.Project_Name__c);
                strNCMTID = strNCMTIDs.substring(0,strNCMTIDs.length()-3); 
                NCMTIdsset.add(strNCMTIDs);
            }  */
            
             strProjIDs = strProjID.substring(0,strProjID.length()-3); 
            //system.debug('strProjIDs==='+strProjIDs ); 
            
            AggregateResult[] aggResult = [SELECT count(id) totcount,sum(Maintenance_Cost__c) totmaintcost,Core_Shell_Cost_Parameter__r.Type__c type
                                             FROM NCMT_Core_Shell_Cost_Detail__c 
                                            WHERE NCMT_Project_ID__c =:strProjID
                                          GROUP BY Core_Shell_Cost_Parameter__r.Type__c];
            
            for (AggregateResult ar : aggResult) {
                                         
                if((Decimal) ar.get('totcount')>1){                       
                     strCostType = (string) ar.get('type'); 
                        
                     if(strCostType == 'Janitorial'){
                             //totalJanCostMap.put(string.valueof(ar.get('npvsummary')),(Decimal) ar.get('totmaintcost'));
                             totalJanCost = (Decimal) ar.get('totmaintcost');
                     }else if(strCostType =='Repair'){
                            totalRepairCost = (Decimal) ar.get('totmaintcost');
                     }else if(strCostType =='Maintenance'){
                            totalMaintCost = (Decimal) ar.get('totmaintcost');
                     }else if(strCostType =='Water'){
                            totalWaterCost = (Decimal) ar.get('totmaintcost');
                     }else if(strCostType =='Controls/IT'){
                            totalControlsCost = (Decimal) ar.get('totmaintcost');
                     }
                    triggervalue.isCostUpdate = true;
                //}
                 //system.debug('inside loop'+totalJanCostMap);     
            } 
            
         }
            list<NCMT_TCO_Annual_Cost_Summary__c > npvsummaryList = [SELECT Building_shell_cleaning__c,Core_Shell_Maintenance_Cost__c,Core_Shell_Minor_Repair_Cost__c,
                                                               Core_Shell_Water_Cost__c,Core_Shell_Controls_IT_Cost__c
                                                               FROM NCMT_TCO_Annual_Cost_Summary__c 
                                                                WHERE Project_Name__c = :strProjID ];
            
            system.debug('strProjID==='+strProjID );                                                    
                                                              
            list<NCMT_TCO_Annual_Cost_Summary__c > npvsumUpdateList = new list<NCMT_TCO_Annual_Cost_Summary__c >();
            System.debug('totalJanCost====='+totalJanCost);
           
            for(NCMT_TCO_Annual_Cost_Summary__c  NPVSumlst : npvsummaryList){
                    System.debug('buildingShellCleaning====='+NPVSumlst.Building_shell_cleaning__c);
                    NPVSumlst.Building_shell_cleaning__c = totalJanCost ; 
                    NPVSumlst.Core_Shell_Maintenance_Cost__c = totalMaintCost;
                    NPVSumlst.Core_Shell_Minor_Repair_Cost__c = totalRepairCost;
                    NPVSumlst.Core_Shell_Water_Cost__c = totalWaterCost;
                    NPVSumlst.Core_Shell_Controls_IT_Cost__c = totalControlsCost;
                    
                    npvsumUpdateList.add(NPVSumlst);
            }
            //system.debug('triggervalue.isCostUpdate=='+triggervalue.isCostUpdate);
            
                update npvsumUpdateList ;
                //triggervalue.isCostUpdate = true;
                
           }
     }
    }
}