trigger NCMT_CEW_WorkItem_Trigger on NCMT_CEW_Work_Item__c (after insert, after update, after delete) {

     set<id>  AgencyIds = new set<id>();
     set<id> PCSIds = new set<id>();
     set<id> NCMTIdsset = new  set<id>();
     set<id> CEW_WI_Ids = new  set<id>();
     map<id,NCMT_Project_Cost_Summary__c> PCSmap = new map<id,NCMT_Project_Cost_Summary__c>();


    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        String strNCMTIDs, strNumber;
        map<string,decimal> totalcost6Map = new map<string,decimal>();
        map<string,decimal> totalcost7Map = new map<string,decimal>();
        map<string,decimal> totalcost8Map = new map<string,decimal>();
        
    
        for(NCMT_CEW_Work_Item__c iter:trigger.new)
        {
            CEW_WI_Ids.add(iter.Id);
            AgencyIds.add(iter.CEW_Project_Agency__c);
            NCMTIdsset.add(iter.NCMT_Project_ID__c);
        }
                
        //for updating total cost for 6,7,8 numbers
        if(AgencyIds.size()>0){
        
            NCMT_CEW_WorkItem_Details.CEWAgencyinfo(AgencyIds,NCMTIdsset,CEW_WI_Ids);
        
        }
    
    }
    
    if(trigger.isAfter && trigger.isDelete){
                   
        for(NCMT_CEW_Work_Item__c objCEWWI:trigger.old){
            CEW_WI_Ids.add(objCEWWI.id);
            AgencyIds.add(objCEWWI.CEW_Project_Agency__c);
            NCMTIdsset.add(objCEWWI.NCMT_Project_ID__c);
        }
        IF(AgencyIds.size()>0){
            
            NCMT_CEW_WorkItem_Details.CEWAgencyinfo(AgencyIds,NCMTIdsset,CEW_WI_Ids);
            
        }
        
    
    }

}