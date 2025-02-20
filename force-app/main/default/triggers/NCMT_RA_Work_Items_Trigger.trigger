trigger NCMT_RA_Work_Items_Trigger on NCMT_RA_Work_Items__c (before insert, before update, after insert,after update, before delete, after delete) {

        set<id> PCSIds = new set<id>();
        set<id> WorkItemIds = new set<id>();
        set<id> NCMTIdsset = new  set<id>();
        map<id,NCMT_Project_Cost_Summary__c> PCSmap = new map<id,NCMT_Project_Cost_Summary__c>();
        map<id,NCMT_RA_Work_Items__c> NCMTRAWImap = new map<id,NCMT_RA_Work_Items__c>();
        map<id,NCMT_Project__c > ncmtmap = new map<id,NCMT_Project__c >();
        map<id,Project_Level_Parameter__c> plpmap = new map<id,Project_Level_Parameter__c>();
        map<string,string> plpProjMap = new map<string ,string>();
        list<NCMT_RA_Work_Items__c> workItemToUpdate = new list<NCMT_RA_Work_Items__c>();
        string  WIRecordTypeName;  
        ID NCMTWorkItemRecordTypeID;     
        Map<ID,Schema.RecordTypeInfo> rt_Map = NCMT_RA_Work_Items__c.sObjectType.getDescribe().getRecordTypeInfosById();
        ID WorkItemTypeID  = Schema.SObjectType.NCMT_RA_Work_Items__c.getRecordTypeInfosByName().get('RA Work Items').getRecordTypeId();
        ID WorkItemTypeID1  = Schema.SObjectType.NCMT_RA_Work_Items__c.getRecordTypeInfosByName().get('RA Work Items Initial Setup').getRecordTypeId();
        ID WorkItemTypeID3  = Schema.SObjectType.NCMT_RA_Work_Items__c.getRecordTypeInfosByName().get('RA Work Items Space Plan').getRecordTypeId();
       if(!trigger.isdelete){
        if((trigger.isInsert && trigger.isBefore) || (trigger.isUpdate && trigger.IsBefore)) {
        
            for(NCMT_RA_Work_Items__c NCMTWorkItem: trigger.new){
                 
                if(NCMTWorkItem.RecordTypeID == WorkItemTypeID1){                         
                    NCMTWorkItem.RecordTypeID = WorkItemTypeID;
                }
                
            } 
        }
        
        for(NCMT_RA_Work_Items__c objRAWorkItem :Trigger.new) {
            PCSIds.add(objRAWorkItem.Work_Item_Type_ID__c);
            WorkItemIds.add(objRAWorkItem.id);
        }
        
        for(NCMT_Project_Cost_Summary__c ncmtprojcostsummary : [Select id, Project_Name__c From NCMT_Project_Cost_Summary__c where id in :PCSIds]){
            PCSmap.put(ncmtprojcostsummary.Id,ncmtprojcostsummary);
            NCMTIdsset.add(ncmtprojcostsummary.Project_Name__c);
            plpProjMap.put(ncmtprojcostsummary.id,ncmtprojcostsummary.Project_Name__c);
        }
        
        for(Project_Level_Parameter__c PLP :[SELECT id,NCMT_Project__c, Override_Total_Roof_Area_SF__c, Override_Plumbing_Fixtures_EA__c, Override_Glazing_Ratio_SF__c, Override_Finished_Wall_Area_SF__c,
                                                    Roofing_Skylights__c, Default_Area_SF__c, NCMT_Project__r.Location_Adjustment_DC__c, Finished_Site_Area__c, Parking_SF__c, Plaza_SF__c,
                                                    Balance__c
                                               FROM Project_Level_Parameter__c 
                                              WHERE NCMT_Project__c IN :NCMTIdsset]) {
            plpmap.put(PLP.NCMT_Project__c,PLP);
        }        
        
        if((trigger.isInsert && trigger.isBefore)){
                
            for (NCMT_RA_Work_Items__c objRAWorkitem :Trigger.new){
                
                if(rt_map.get(objRAWorkitem.recordTypeID).getName() == 'RA Work Items') {
                    
                    string projectId = plpProjMap.get(objRAWorkItem.Work_Item_Type_ID__c);  
                    Project_Level_Parameter__c KeyPLP = plpmap.get(projectId);
                    
                    if(objRAWorkItem.Work_Item_Category__c == 'Roofing'){
                        
                        if(objRAWorkItem.Work_Item_Category_Type__c == 'Skylights' &&
                           (objRAWorkItem.Work_Item_Category_Code__c == '320.51' || objRAWorkItem.Work_Item_Category_Code__c == '520.51')){
                        
                            objRAWorkitem.Default_Quantity_SF__c = keyPLP.Roofing_Skylights__c;
                        
                        }else if(objRAWorkItem.Work_Item_Category_Code__c != '520.12' && objRAWorkItem.Work_Item_Category_Code__c != '520.22' && objRAWorkItem.Work_Item_Category_Code__c != '520.41' && objRAWorkItem.Work_Item_Category_Code__c != '520.42' && objRAWorkItem.Work_Item_Category_Code__c != '520.52' && objRAWorkItem.Work_Item_Category_Code__c != '520.53'){
                            
                            objRAWorkitem.Default_Quantity_SF__c = keyPLP.Override_Total_Roof_Area_SF__c;
                        }else{
                            objRAWorkitem.Default_Quantity_SF__c = 0;
                        }
                    }else if(objRAWorkItem.Work_Item_Category__c == 'Plumbing'){
                        
                        if(objRAWorkItem.Work_Item_Category_Type__c == 'Piping Systems'){
                            objRAWorkitem.Default_Quantity_SF__c = keyPLP.Default_Area_SF__c;
                        }else if(objRAWorkItem.Work_Item_Category_Type__c == 'Fixtures' && objRAWorkItem.Work_Item_Category_Sub_Type__c == 'Repair Fixtures'){
                            objRAWorkitem.Default_Quantity_SF__c = keyPLP.Override_Plumbing_Fixtures_EA__c;
                        }else if((objRAWorkItem.Work_Item_Category_Code__c == '565.31') || (objRAWorkItem.Work_Item_Category_Code__c == '565.51')){
                            objRAWorkitem.Default_Quantity_SF__c = objRAWorkitem.Default_Lookup_Quantity_SF__c;
                        }else{
                            objRAWorkitem.Default_Quantity_SF__c = 0;
                        }
                    }else if (objRAWorkItem.Work_Item_Category__c == 'Exterior Closure'){
                        if((objRAWorkItem.Work_Item_Category_Code__c == '370.11') || (objRAWorkItem.Work_Item_Category_Code__c == '570.11') || (objRAWorkItem.Work_Item_Category_Code__c == '370.21')){
                            objRAWorkitem.Default_Quantity_SF__c = keyPLP.Override_Finished_Wall_Area_SF__c;
                        }else{
                            objRAWorkitem.Default_Quantity_SF__c = 0;
                        }
                    }else if (objRAWorkItem.Work_Item_Category__c == 'Land Improvements'){
                        if(objRAWorkItem.Work_Item_Category_Code__c == '310.12' || objRAWorkItem.Work_Item_Category_Code__c == '310.13' || objRAWorkItem.Work_Item_Category_Code__c == '410.11b' || objRAWorkItem.Work_Item_Category_Code__c == '410.32'){
                            objRAWorkitem.Default_Quantity_SF__c = keyPLP.Parking_SF__c;
                        }else if (objRAWorkItem.Work_Item_Category_Code__c == '410.22b'){
                            objRAWorkitem.Default_Quantity_SF__c = keyPLP.Plaza_SF__c;
                        }else if(objRAWorkItem.Work_Item_Category_Code__c == '310.61'){
                            objRAWorkitem.Default_Quantity_SF__c = keyPLP.Balance__c;
                        }else{
                            objRAWorkitem.Default_Quantity_SF__c = 0;
                        }
                        
                    }
                            if(objRAWorkitem.Quantity_SF__c == 0 ){
                                objRAWorkitem.Quantity_SF__c = objRAWorkitem.Default_Quantity_SF__c;
                            }
                            else if(objRAWorkitem.Rate__c == 0){
                                objRAWorkitem.Rate__c = objRAWorkitem.Default_Rate__c * keyPLP.NCMT_Project__r.Location_Adjustment_DC__c;
                            }
                }
            }
            
        } 
     }
     /*
     if(trigger.isdelete && Trigger.isafter){
        
        for(NCMT_RA_Work_Items__c NCMTWorkItem :trigger.old){
            NCMTWorkItemRecordTypeID = NCMTWorkItem.RecordTypeID;   
        }
        
        if(NCMTWorkItemRecordTypeID == WorkItemTypeID3){
            for(NCMT_RA_Work_Items__c NCMTWI : Trigger.old) {
                NCMTWI.addError('This Work Item cannot be deleted because it is related to user defined housing Plan. Inorder to delete this work item then make sure to delete userdefined housing plan');
            }   
        }
     }
     */
}