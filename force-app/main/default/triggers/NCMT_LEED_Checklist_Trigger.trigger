trigger NCMT_LEED_Checklist_Trigger on NCMT_LEED_Checklist__c (before insert, before update, after update, before delete) {
    set<id> ncmtleedIDs = new set<id>();
    set<id> projectIds = new set<id>();
    list<NCMT_Project_Cost_Summary__c>  costSummaryListToUpdate= new list<NCMT_Project_Cost_Summary__c>();
  if(trigger.isdelete){
     for(NCMT_LEED_Checklist__c  leedCheck : Trigger.old) {
         projectIds.add(leedCheck.project__c);    
     } 
     for(NCMT_Project_Cost_Summary__c  costSummary : [select id,Leed_Percentage__c   from NCMT_Project_Cost_Summary__c  where Project_Name__c   In:projectIds]) {
         costSummary.Leed_Percentage__c = 0;
         costSummaryListToUpdate.add(costSummary);
     
     }
     if(costSummaryListToUpdate.size() > 0 && costSummaryListToUpdate != null){
         update costSummaryListToUpdate;
     }
        
  }else{  
    if(trigger.new.size() > 1){
        // Bulk inserts/updates are not supported in Release 1.0, although you could bulk load with a batch size of 1 ...
        for (NCMT_LEED_Checklist__c objProject:Trigger.new) { objProject.adderror('Please have the administrator set the batch size to 1 if you need to bulk load records.'); }
    } else {
        
        string  LeedRecordTypeName;
        Boolean flag = false;
        Map<ID,Schema.RecordTypeInfo> rt_Map = NCMT_LEED_Checklist__c.sObjectType.getDescribe().getRecordTypeInfosById();
        ID LeedRecordTypeID  = Schema.SObjectType.NCMT_LEED_Checklist__c.getRecordTypeInfosByName().get('LEED Checklist').getRecordTypeId();
    
        /*if((trigger.isInsert && trigger.isBefore) || (trigger.isUpdate && trigger.IsBefore)) {
        
            for(NCMT_LEED_Checklist__c NCMTLeed: trigger.new){
        
                if(NCMTLeed.Prerequisite_1__c && NCMTLeed.Prerequisite_2__c && NCMTLeed.Prerequisite_3__c && NCMTLeed.Prerequisite_4__c &&
                    NCMTLeed.Prerequisite_5__c && NCMTLeed.Prerequisite_6__c && NCMTLeed.Prerequisite_7__c && NCMTLeed.Prerequisite_8__c &&
                    NCMTLeed.Prerequisite_9__c && NCMTLeed.Prerequisite_10__c && NCMTLeed.Prerequisite_11__c && NCMTLeed.Prerequisite_12__c){
                    
                        NCMTLeed.RecordTypeID = LeedRecordTypeID;
                }
                
                if((trigger.isupdate && NCMTLEED.Building_Quality__c != trigger.oldmap.get(NCMTLEED.id).building_quality__c) || trigger.isinsert) {
                    
                        if(NCMTLEED.Building_Quality__c == 'Class A'){
                            
                            NCMTLEED.LEED_USR_Mod_IP_1__c = 0; NCMTLEED.LEED_USR_Mod_LT_1__c = 0; NCMTLEED.LEED_USR_Mod_LT_2__c = 0; NCMTLEED.LEED_USR_Mod_LT_3__c = 0; 
                            NCMTLEED.LEED_USR_Mod_LT_4__c = 0; NCMTLEED.LEED_USR_Mod_LT_5__c =5; NCMTLEED.LEED_USR_Mod_LT_6__c =2; NCMTLEED.LEED_USR_Mod_LT_7__c =1; 
                            NCMTLEED.LEED_USR_Mod_LT_8__c =0; NCMTLEED.LEED_USR_Mod_SS_1__c =0; NCMTLEED.LEED_USR_Mod_SS_2__c =1; NCMTLEED.LEED_USR_Mod_SS_3__c =1; 
                            NCMTLEED.LEED_USR_Mod_SS_4__c =0; NCMTLEED.LEED_USR_Mod_SS_5__c =1; NCMTLEED.LEED_USR_Mod_SS_6__c =1; NCMTLEED.LEED_USR_Mod_WE_1__c =1; 
                            NCMTLEED.LEED_USR_Mod_WE_2__c =3; NCMTLEED.LEED_USR_Mod_WE_3__c =1; NCMTLEED.LEED_USR_Mod_WE_4__c =0; NCMTLEED.LEED_USR_Mod_EA_1__c =3; 
                            NCMTLEED.LEED_USR_Mod_EA_2__c =6; NCMTLEED.LEED_USR_Mod_EA_3__c =0; NCMTLEED.LEED_USR_Mod_EA_4__c =1; NCMTLEED.LEED_USR_Mod_EA_5__c =0; 
                            NCMTLEED.LEED_USR_Mod_EA_6__c =1; NCMTLEED.LEED_USR_Mod_EA_7__c =0; NCMTLEED.LEED_USR_Mod_MR_1__c =0; NCMTLEED.LEED_USR_Mod_MR_2__c =0; 
                            NCMTLEED.LEED_USR_Mod_MR_3__c =0;  NCMTLEED.LEED_USR_Mod_MR_4__c =0; NCMTLEED.LEED_USR_Mod_MR_5__c =2; NCMTLEED.LEED_USR_Mod_IEQ_1__c =1; 
                            NCMTLEED.LEED_USR_Mod_IEQ_2__c =3; NCMTLEED.LEED_USR_Mod_IEQ_3__c =1; NCMTLEED.LEED_USR_Mod_IEQ_4__c =1; NCMTLEED.LEED_USR_Mod_IEQ_5__c =0; 
                            NCMTLEED.LEED_USR_Mod_IEQ_6__c =0; NCMTLEED.LEED_USR_Mod_IEQ_7__c =0; NCMTLEED.LEED_USR_Mod_IEQ_8__c = 0;NCMTLEED.LEED_USR_Mod_IEQ_9__c =0; 
                            NCMTLEED.LEED_USR_Mod_Innovation_1__c =2;NCMTLEED.LEED_USR_Mod_Innovation_2__c =1; NCMTLEED.LEED_USR_Mod_RP_1__c =2;
                            
                        }else if(NCMTLEED.Building_Quality__c.contains( 'P100')){
                            NCMTLEED.LEED_USR_Mod_IP_1__c = 1; NCMTLEED.LEED_USR_Mod_LT_1__c = 0; NCMTLEED.LEED_USR_Mod_LT_2__c = 1;NCMTLEED.LEED_USR_Mod_LT_3__c = 0;
                            NCMTLEED.LEED_USR_Mod_LT_4__c=5; NCMTLEED.LEED_USR_Mod_LT_5__c=2;NCMTLEED.LEED_USR_Mod_LT_6__c=1; NCMTLEED.LEED_USR_Mod_LT_7__c=1; 
                            NCMTLEED.LEED_USR_Mod_LT_8__c=0; NCMTLEED.LEED_USR_Mod_SS_1__c=1; NCMTLEED.LEED_USR_Mod_SS_2__c=2; NCMTLEED.LEED_USR_Mod_SS_3__c=1;
                            NCMTLEED.LEED_USR_Mod_SS_4__c=2;NCMTLEED.LEED_USR_Mod_SS_5__c =1; NCMTLEED.LEED_USR_Mod_SS_6__c=1; NCMTLEED.LEED_USR_Mod_WE_1__c=1;
                            NCMTLEED.LEED_USR_Mod_WE_2__c=3;NCMTLEED.LEED_USR_Mod_WE_3__c=1;NCMTLEED.LEED_USR_Mod_WE_4__c=1;NCMTLEED.LEED_USR_Mod_EA_1__c=6;
                            NCMTLEED.LEED_USR_Mod_EA_2__c=12;  NCMTLEED.LEED_USR_Mod_EA_3__c=1;NCMTLEED.LEED_USR_Mod_EA_4__c=1;NCMTLEED.LEED_USR_Mod_EA_5__c=3;
                            NCMTLEED.LEED_USR_Mod_EA_6__c=1;NCMTLEED.LEED_USR_Mod_EA_7__c=0;NCMTLEED.LEED_USR_Mod_MR_1__c=3;
                            NCMTLEED.LEED_USR_Mod_MR_2__c=1;NCMTLEED.LEED_USR_Mod_MR_3__c=1;NCMTLEED.LEED_USR_Mod_MR_4__c=1;NCMTLEED.LEED_USR_Mod_MR_5__c=2;
                            NCMTLEED.LEED_USR_Mod_IEQ_1__c =1;NCMTLEED.LEED_USR_Mod_IEQ_2__c=3;NCMTLEED.LEED_USR_Mod_IEQ_3__c=1;NCMTLEED.LEED_USR_Mod_IEQ_4__c=1;
                            NCMTLEED.LEED_USR_Mod_IEQ_5__c=0;NCMTLEED.LEED_USR_Mod_IEQ_6__c=1;NCMTLEED.LEED_USR_Mod_IEQ_7__c=0;NCMTLEED.LEED_USR_Mod_IEQ_8__c = 0;
                            NCMTLEED.LEED_USR_Mod_IEQ_9__c=1;NCMTLEED.LEED_USR_Mod_Innovation_1__c=3; NCMTLEED.LEED_USR_Mod_Innovation_2__c=1;NCMTLEED.LEED_USR_Mod_RP_1__c=4;
                        }else if(NCMTLEED.Building_Quality__c == 'Code Minimum'){
                            NCMTLEED.LEED_USR_Mod_IP_1__c = 0; NCMTLEED.LEED_USR_Mod_LT_1__c = 0; NCMTLEED.LEED_USR_Mod_LT_2__c = 0;NCMTLEED.LEED_USR_Mod_LT_3__c = 0;
                            NCMTLEED.LEED_USR_Mod_LT_4__c=0; NCMTLEED.LEED_USR_Mod_LT_5__c=0;NCMTLEED.LEED_USR_Mod_LT_6__c=0; NCMTLEED.LEED_USR_Mod_LT_7__c=0; 
                            NCMTLEED.LEED_USR_Mod_LT_8__c=0; NCMTLEED.LEED_USR_Mod_SS_1__c=0; NCMTLEED.LEED_USR_Mod_SS_2__c=0; NCMTLEED.LEED_USR_Mod_SS_3__c=0;
                            NCMTLEED.LEED_USR_Mod_SS_4__c=0;NCMTLEED.LEED_USR_Mod_SS_5__c =0; NCMTLEED.LEED_USR_Mod_SS_6__c=0; NCMTLEED.LEED_USR_Mod_WE_1__c=0;
                            NCMTLEED.LEED_USR_Mod_WE_2__c=0;NCMTLEED.LEED_USR_Mod_WE_3__c=0;NCMTLEED.LEED_USR_Mod_WE_4__c=0;NCMTLEED.LEED_USR_Mod_EA_1__c=0;
                            NCMTLEED.LEED_USR_Mod_EA_2__c=0;  NCMTLEED.LEED_USR_Mod_EA_3__c=0;NCMTLEED.LEED_USR_Mod_EA_4__c=0;NCMTLEED.LEED_USR_Mod_EA_5__c=0;
                            NCMTLEED.LEED_USR_Mod_EA_6__c=0;NCMTLEED.LEED_USR_Mod_EA_7__c=0;NCMTLEED.LEED_USR_Mod_MR_1__c=0; NCMTLEED.LEED_USR_Mod_MR_2__c=0;
                            NCMTLEED.LEED_USR_Mod_MR_3__c=0;NCMTLEED.LEED_USR_Mod_MR_4__c=0;NCMTLEED.LEED_USR_Mod_MR_5__c=0; NCMTLEED.LEED_USR_Mod_IEQ_1__c =0;
                            NCMTLEED.LEED_USR_Mod_IEQ_2__c=0;NCMTLEED.LEED_USR_Mod_IEQ_3__c=0;NCMTLEED.LEED_USR_Mod_IEQ_4__c=0; NCMTLEED.LEED_USR_Mod_IEQ_5__c=0;
                            NCMTLEED.LEED_USR_Mod_IEQ_6__c=0;NCMTLEED.LEED_USR_Mod_IEQ_7__c=0;NCMTLEED.LEED_USR_Mod_IEQ_8__c =  0; NCMTLEED.LEED_USR_Mod_IEQ_9__c=0;
                            NCMTLEED.LEED_USR_Mod_Innovation_1__c=0; NCMTLEED.LEED_USR_Mod_Innovation_2__c=0;NCMTLEED.LEED_USR_Mod_RP_1__c=0;
                        }
                }
            }
        }*/
    
        for (NCMT_LEED_Checklist__c objLeed:Trigger.new){
            LeedRecordTypeName = rt_map.get(objLeed.recordTypeID).getName();
        }
    
        if(LeedRecordTypeName == 'LEED Checklist'){
            if((trigger.isUpdate && trigger.isAfter)){
            
                NCMT_GenerateProjectDetailsExt.Update_Leed_Checklist(trigger.new);
            }   
        }
    }
  }
}