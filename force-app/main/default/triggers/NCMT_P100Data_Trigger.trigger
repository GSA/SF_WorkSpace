trigger NCMT_P100Data_Trigger on NCMT_Project_P100_Data__c (after insert, after update, before delete){
 
  set<id> projectIds = new set<id>();
  list<NCMT_Project_Cost_Summary__c>  costSummaryListToUpdate= new list<NCMT_Project_Cost_Summary__c>();
  
  if(trigger.isdelete){
     for(NCMT_Project_P100_Data__c  P100Data : Trigger.old) {
         projectIds.add(P100Data.project__c);    
     } 
     for(NCMT_Project_Cost_Summary__c  costSummary : [select id,P100_Percentage__c from NCMT_Project_Cost_Summary__c  where Project_Name__c   In:projectIds]) {
         costSummary.P100_Percentage__c = 0;
         costSummaryListToUpdate.add(costSummary);
     
     }
     if(costSummaryListToUpdate.size() > 0 && costSummaryListToUpdate != null){
         update costSummaryListToUpdate;
     }
        
  }else{
     
     if(trigger.new.size() > 1){
        // Bulk inserts/updates are not supported in Release 1.0, although you could bulk load with a batch size of 1 ...
        for (NCMT_Project_P100_Data__c objProject:Trigger.new){
            objProject.adderror('Please have the administrator set the batch size to 1 if you need to bulk load records.');
        }
        
    } else {
        
        if (Trigger.isAfter){ //Inserts and Updates
            
            string txtOldCostCategory = '000000000000000000'; 
            ID idOldCostCategory = (ID) txtOldCostCategory; 
            ID idNewCostCategory;
            Double dblCostCategoryAmount = 0.00;
            boolean blnHasData = false;
            Map<ID, Double> MapCostSumByCategory = new Map<ID, Double>();
            string strFiscalYear;
            
            ID idProjectID;
            string str1, str2, str3, str4, str5, str6, str7, str8, str9, str10, str11, str12, str13, str14, str15, str16;
            
            Map<Id, String> projMap = new Map<Id, String>();
            //JG 11/6/20 Updating this to take the query out of the trigger.new loop for security scan
            //Could be done without the query by creating a formula field on the P100 object that references the
            //Cost_Parameter_Date_FY__c on the Project. Didn't want to mess with fields and security.... 
            for (NCMT_Project_P100_Data__c  objP100Data:Trigger.new)
                projMap.put(objP100Data.Project__c, null);

            for (NCMT_Project__c p : [SELECT Id, Cost_Parameter_Date_FY__c FROM NCMT_Project__c Where ID = :projMap.keySet()])
                projMap.put(p.Id, String.valueOf(p.Cost_Parameter_Date_FY__c));

            //Current Record Data
            for (NCMT_Project_P100_Data__c  objP100Data:Trigger.new){
                idProjectID = objP100Data.Project__c;
                strFiscalYear = projMap.get(idProjectID);
                str1 = (objP100Data.Electrical_overall_quality_power_quality__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str2 = (objP100Data.Enclosure_Performance__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str3 = (objP100Data.Energy_30_40_50_NZE__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str4 = (objP100Data.Flood_Resistance__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str5 = (objP100Data.Fossil_Fuel_65_80_90_NZC__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str6 = (objP100Data.Interior_Performance__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str7 = (objP100Data.Landscape_Performance__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str8 = (objP100Data.Lighting_Quality__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str9 = (objP100Data.Mechanical__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str10 = (objP100Data.Roofing__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str11 = (objP100Data.Seismic_Performance__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str12 = (objP100Data.Service_Life__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str13 = (objP100Data.Site_Neighbor_Connect_Walk_Bike__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str14 = (objP100Data.SiteTransitUseReduced_Automobile_commute__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str15 = (objP100Data.SiteUsesExistingInfrastructure_Resources__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
                str16 = (objP100Data.Wind__c).replaceAll('\\s+', '').replaceAll(':', '') + '__c';
            }
            //Current Record Data
            
            // Loop and aggregate by Ctagory
            for (NCMT_P100_Parameter__c objRecord : [Select Cost_Category__c, PI00_Category__c, Baseline__c, P100Tier1__c, P100Tier2__c, P100Tier3__c 
                                                     FROM   NCMT_P100_Parameter__c 
                                                     Where   Fiscal_Year__c = :strFiscalYear
                                                     Order by Cost_Category__c, PI00_Category__c]){
                blnHasData = true;                                      
                idNewCostCategory = objRecord.Cost_Category__c;
                
                // Id has changed, update the Map ...
                if ((idNewCostCategory <> idOldCostCategory) && (idOldCostCategory <> '000000000000000000')){
                    System.Debug('MyDebug - idOldCostCategory - ' + idOldCostCategory + '-%-' + dblCostCategoryAmount);
                    MapCostSumByCategory.Put(idOldCostCategory, dblCostCategoryAmount);
                    dblCostCategoryAmount = 0.00;
                }
                
                If (objRecord.PI00_Category__c == 'Electrical - overall quality/power quality'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str1);
                } else If (objRecord.PI00_Category__c == 'Enclosure Performance'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str2);
                } else If (objRecord.PI00_Category__c == 'Energy: 30-40-50-NZE'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str3);
                } else If (objRecord.PI00_Category__c == 'Flood Resistance'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str4);
                } else If (objRecord.PI00_Category__c == 'Fossil Fuel: -65, -80, -90, NZC (fossil Fuel)'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str5);
                } else If (objRecord.PI00_Category__c == 'Interior Performance'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str5);
                } else If (objRecord.PI00_Category__c == 'Landscape Performance'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str7);
                } else If (objRecord.PI00_Category__c == 'Lighting Quality'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str8);
                } else If (objRecord.PI00_Category__c == 'Mechanical'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str9);
                } else If (objRecord.PI00_Category__c == 'Roofing'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str10);
                } else If (objRecord.PI00_Category__c == 'Seismic Performance'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str11);
                } else If (objRecord.PI00_Category__c == 'Service Life'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str12);
                } else If (objRecord.PI00_Category__c == 'Site Supports Neighborhood Connectivity, Walkability, and Bikeability'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str1);
                } else If (objRecord.PI00_Category__c == 'Site Supports Transit-Use and Reduced Automobile Commuting'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str1);
                } else If (objRecord.PI00_Category__c == 'Site Uses Existing Infrastructure Resources and Preserves Natural Resources'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str1);
                } else If (objRecord.PI00_Category__c == 'Wind'){
                    dblCostCategoryAmount += (Decimal) objRecord.get(str1);
                } else {
                    dblCostCategoryAmount += 0.00;
                }
                // assign old as loop ends ...
                idOldCostCategory = idNewCostCategory; 
            }
            // Loop and aggregate by Category
            
            //One Last ID ...
            if (blnHasData = true){
                MapCostSumByCategory.Put(idOldCostCategory, dblCostCategoryAmount); 
            }
            
            // The Map is ready with the associated P100 Costs; loop through the cost summary for that Project and start updating the numbers ...
            List<NCMT_Project_Cost_Summary__c> objCostSummaryRecords = New List<NCMT_Project_Cost_Summary__c>();
            for (Id key : MapCostSumByCategory.keySet()) {
                System.Debug('MyDebug - Loop - ' + string.ValueOf(idProjectID).Left(15) + '||' + string.ValueOf(Key).Left(15));
                System.Debug('MyDebug - Loop - % age - ' + string.ValueOf((Decimal) MapCostSumByCategory.get(key)));
                objCostSummaryRecords.Add(new NCMT_Project_Cost_Summary__c(
                    External_Key__c = string.ValueOf(idProjectID).Left(15) + '||' + string.ValueOf(Key).Left(15),
                    P100_Percentage__c = (Decimal) MapCostSumByCategory.get(key)
                ));                                     
            }
            
            try{    
                database.UpsertResult[] results = Database.Upsert(objCostSummaryRecords, Schema.NCMT_Project_Cost_Summary__c.External_Key__c, false);
            }catch (Exception e){
                System.debug('MyDebug - Upsert error - ' + e.getMessage());
            }   
            // The Map is ready with the associated P100 Costs; loop through the cost summary for that Project and start updating the numbers ...
            
        } //Close for Inserts and Updates

     } // Close for trigger.size = 1
   }        
}