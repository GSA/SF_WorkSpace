trigger NCMT_OtherCostTrigger on NCMT_Other_Cost__c (after insert, after update,after delete) {
    
    Map<ID,Schema.RecordTypeInfo> rt_Map = NCMT_Other_Cost__c.sObjectType.getDescribe().getRecordTypeInfosById();
    set<id> projectIds = new set<id>();
    list<NCMT_Project__c>  ProjListToUpdate= new list<NCMT_Project__c>();

    System.debug('RUN OTHER COST TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
    //TCO Lifecycle update
    if(trigger.isAfter &&(trigger.isUpdate || trigger.isInsert))
    {
    
            //For TCO Only logic
            Id tcoRecordTypeId = NCMT_Utilities.getProjectRecordTypeId('New_Construction_TCO');
            Set<Id> tcoProjIds = new Set<Id>();    
            for(NCMT_Other_Cost__c other:trigger.new)
            {
                    if (other.Project_Record_Type_Id__c == tcoRecordTypeId)
                        tcoProjIds.add(other.NCMT_Project__c);
            }
            if (tcoProjIds.size() > 0) NCMT_TCO_Lifecycle_Input_TriggerHandler.futureUpdateByProject(tcoProjIds);

    }

  if(trigger.isAfter && trigger.isDelete){
        
        Decimal subtotalDirectCosts;
        Decimal TotalProjectCosts = 0;
        Decimal TotalSiteCost = 0;
        Decimal UserDefinedSpaces;
        String CostType, OtherCostRecordTypeName;
        subtotalDirectCosts = 0;
        
        for(NCMT_Other_Cost__c  OthCstLst : Trigger.old) {
             projectIds.add(OthCstLst.NCMT_Project__c); 
             OtherCostRecordTypeName = rt_map.get(OthCstLst.recordTypeID).getName();   
         } 
        
        if (OtherCostRecordTypeName == 'Other Facilities - Other Cost') {
            
            AggregateResult[] SumCosts = [ SELECT   Cost_Type__c, SUM(Total1__c) Total
                                                     FROM     NCMT_Other_Cost__c 
                                                     WHERE    NCMT_Project__c in :projectIds
                                                     Group By Cost_Type__c];                                                        
            for (AggregateResult RowData : SumCosts) { 
                CostType = (String) RowData.get('Cost_Type__c');
                IF (CostType == 'Direct Costs') {
                    subtotalDirectCosts = (Decimal) RowData.get('Total');
                }
                ELSE if (CostType == 'Project Costs') {
                    TotalProjectCosts = (Decimal) RowData.get('Total');
                }
                else {
                    TotalSiteCost = (Decimal) RowData.get('Total');
                }
            }
            
         NCMT_Project__c Proj = [select id,Total_Other_Direct_Costs__c, Total_Other_Project_Costs__c
                                                , Design_and_Site_Contingency__c, General_Contractor_Overhead_Profit_Bonds__c, Construction_Contingency__c, Art_In_Architecture__c
                                                , Override_Calculated_Site_Area__c, Calculated_Site_Area__c, Site_Acquisition_Cost_per_acre__c 
                                      from NCMT_Project__c  
                                      where Id In:projectIds];
            Decimal Design_and_Site_Contingency;
            Decimal General_Contractor_Overhead_Profit_Bonds;
            Decimal Construction_Contingency;
            Decimal Art_In_Architecture;
            
            Design_and_Site_Contingency = Proj.Design_and_Site_Contingency__c / 100;
            General_Contractor_Overhead_Profit_Bonds = Proj.General_Contractor_Overhead_Profit_Bonds__c / 100;
            Construction_Contingency = Proj.Construction_Contingency__c / 100;
            Art_In_Architecture = Proj.Art_In_Architecture__c / 100;
            
            if (subtotalDirectCosts <> 0) {
                Design_and_Site_Contingency = Design_and_Site_Contingency * subtotalDirectCosts;
            }
            General_Contractor_Overhead_Profit_Bonds = (subtotalDirectCosts + Design_and_Site_Contingency) * General_Contractor_Overhead_Profit_Bonds;
            Construction_Contingency = (subtotalDirectCosts + Design_and_Site_Contingency + General_Contractor_Overhead_Profit_Bonds) * Construction_Contingency;
            Art_In_Architecture = (subtotalDirectCosts + Design_and_Site_Contingency + General_Contractor_Overhead_Profit_Bonds + Construction_Contingency) * Art_In_Architecture;
                                                     
            Proj.Total_Other_Project_Costs__c = TotalProjectCosts + TotalSiteCost;
            //Proj.Total_Other_Direct_Costs__c = subtotalDirectCosts + Design_and_Site_Contingency + General_Contractor_Overhead_Profit_Bonds + Construction_Contingency + Art_In_Architecture;
                                       
             ProjListToUpdate.add(Proj);         
     
             if(ProjListToUpdate.size() > 0 && ProjListToUpdate != null){
                 update ProjListToUpdate;
             }
        }
        
  }else{  
    if (Trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        
        Decimal subtotalDirectCosts;
        Decimal TotalProjectCosts = 0;
        Decimal TotalSiteCost = 0;
        Decimal UserDefinedSpaces;
        String CostType, OtherCostRecordTypeName;
        subtotalDirectCosts = 0;
        ID      OtherCostID;

        Set<string> MasterIDs = new Set<string>();
        List<NCMT_Other_Cost__c> ListOfMaster = new list<NCMT_Other_Cost__c>();
        
        for (NCMT_Other_Cost__c objRecord: Trigger.new) {
                OtherCostID = objRecord.ID;
                MasterIDs.add(objRecord.NCMT_Project__c);
                OtherCostRecordTypeName = rt_map.get(objRecord.recordTypeID).getName();
        }
        
        if (OtherCostRecordTypeName == 'Other Facilities - Other Cost') {
            
            AggregateResult[] SumCosts = [ SELECT   Cost_Type__c, SUM(Total1__c) Total
                                                     FROM     NCMT_Other_Cost__c 
                                                     WHERE    NCMT_Project__c in :MasterIDs
                                                     Group By Cost_Type__c];                                                        
            for (AggregateResult RowData : SumCosts) { 
                CostType = (String) RowData.get('Cost_Type__c');
                IF (CostType == 'Direct Costs') {
                    subtotalDirectCosts = (Decimal) RowData.get('Total');
                }
                ELSE if (CostType == 'Project Costs') {
                    TotalProjectCosts = (Decimal) RowData.get('Total');
                }
                else {
                    TotalSiteCost = (Decimal) RowData.get('Total');
                }
            }
    
            NCMT_Project__c Proj = [SELECT Total_Other_Direct_Costs__c, Total_Other_Project_Costs__c, Other_Direct_Cost_Core_Shell__c
                                            , Design_and_Site_Contingency__c, General_Contractor_Overhead_Profit_Bonds__c, Construction_Contingency__c, Art_In_Architecture__c
                                            , Override_Calculated_Site_Area__c, Calculated_Site_Area__c, Site_Acquisition_Cost_per_acre__c 
                                            FROM NCMT_Project__c WHERE Id = :MasterIDs ];
            Decimal Design_and_Site_Contingency;
            Decimal General_Contractor_Overhead_Profit_Bonds;
            Decimal Construction_Contingency;
            Decimal Art_In_Architecture;
            
            Design_and_Site_Contingency = Proj.Design_and_Site_Contingency__c / 100;
            General_Contractor_Overhead_Profit_Bonds = Proj.General_Contractor_Overhead_Profit_Bonds__c / 100;
            Construction_Contingency = Proj.Construction_Contingency__c / 100;
            Art_In_Architecture = Proj.Art_In_Architecture__c / 100;
            
            if (subtotalDirectCosts <> 0) {
                Design_and_Site_Contingency = Design_and_Site_Contingency * subtotalDirectCosts;
            }
            General_Contractor_Overhead_Profit_Bonds = (subtotalDirectCosts + Design_and_Site_Contingency) * General_Contractor_Overhead_Profit_Bonds;
            Construction_Contingency = (subtotalDirectCosts + Design_and_Site_Contingency + General_Contractor_Overhead_Profit_Bonds) * Construction_Contingency;
            Art_In_Architecture = (subtotalDirectCosts + Design_and_Site_Contingency + General_Contractor_Overhead_Profit_Bonds + Construction_Contingency) * Art_In_Architecture;
                                                     
            Proj.Total_Other_Project_Costs__c = TotalProjectCosts + TotalSiteCost;
            //Proj.Total_Other_Direct_Costs__c = subtotalDirectCosts + Design_and_Site_Contingency + General_Contractor_Overhead_Profit_Bonds + Construction_Contingency + Art_In_Architecture;
            
            try {
                if (TotalSiteCost > 0 ) {
                    if (Proj.Override_Calculated_Site_Area__c > 0) {
                        Proj.Site_Acquisition_Cost_per_acre__c = TotalSiteCost * 4840 * 9 / Proj.Override_Calculated_Site_Area__c;
                    }
                    else {
                        Proj.Site_Acquisition_Cost_per_acre__c = TotalSiteCost * 4840 * 9 / Proj.Calculated_Site_Area__c;
                    }       
                }
            }
            catch (exception e) {
                Proj.Site_Acquisition_Cost_per_acre__c = 0;
            }       
            upsert Proj;
        }     
        
        if ((Trigger.isAfter && trigger.isInsert) && (OtherCostRecordTypeName == 'Other Facilities - Other Direct Cost' || OtherCostRecordTypeName == 'Other Capital Cost')) {
            
            List<NCMT_Other_Direct_Cost__c> objOtherDirectCostRecords = New List<NCMT_Other_Direct_Cost__c>();
            
            for (NCMT_Project_Cost_Summary__c objCostSummary : [Select ID, Cost_Category_Code__c, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c 
                                                               Where Project_Name__c = :MasterIDs Limit 1000]){
                                                                
                objOtherDirectCostRecords.Add(new NCMT_Other_Direct_Cost__c(
                        NCMT_Other_Cost__c = OtherCostID,
                        Project_Cost_Summary__c = objCostSummary.ID,
                        Cost_Category__c = objCostSummary.Cost_Category_Code__c,
                        Cost_Category_Description__c = objCostSummary.Cost_Category_Description__c
                        ));                                                
                                                               
            }
        
            insert objOtherDirectCostRecords;
            
        }                    
    }
  }
    }
}