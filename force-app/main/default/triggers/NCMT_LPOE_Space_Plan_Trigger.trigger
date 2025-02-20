trigger NCMT_LPOE_Space_Plan_Trigger on LPOE_Space_Plan__c (before insert, before update, after insert, after update) {
	
	set<String> ncmtIdSet = new set<String>();                               
    Map<String,NCMT_Project__c> ncmtMap = new Map<String,NCMT_Project__c>(); 
	Map<String,NCMT_LPOE_Parametric_Default_SpaceLookup__c> Parammap = new Map<String,NCMT_LPOE_Parametric_Default_SpaceLookup__c>();
	string  txtCostParameterDateFY, txtConstructionEndDateFY,strCity,strState;
    Date    dtCostParameterDate, dtConstructionEndDate, Start_Construction, mid_construction_dt;
    Decimal dblStandardRate;
    ID ProjectRecordID;
	
		for(LPOE_Space_Plan__c iter :trigger.new){
                ncmtIdSet.add(iter.Project_Name__c);
                ProjectRecordID = iter.Project_Name__c;
        }
        
        List <NCMT_Project__c> Projlst = [SELECT Id, Project_type__c , Border__c, Commercial_Port_Size__c, POV_Port_Size__c,
                                                 Building_Height_Parameter__r.GSF_10000__c, Building_Height_Parameter__r.GSF_25000__c, Building_Height_Parameter__r.GSF_50000__c, 
			                                     Building_Height_Parameter__r.GSF_100000__c, Building_Height_Parameter__r.GSF_150000__c, Building_Height_Parameter__r.GSF_250000__c, 
			                                     Building_Height_Parameter__r.GSF_500000__c, Building_Height_Parameter__r.GSF_GT_500000__c,
			                                     Start_Construction__c, End_Construction__c, Cost_Parameter_Date__c,Mid_Point_of_Construction__c, 
			                                     Cost_Parameter_Date_FY__c, Standard_Esc_Rate__c,End_Construction_FY__c,location_name__c,State__c
                                             FROM NCMT_Project__c 
                                            WHERE Id IN :ncmtIdSet]; 
                                            
        for (NCMT_Project__c Proj: Projlst) { 
        	ncmtMap.put(Proj.Id,Proj);
        }  
        
        for(NCMT_LPOE_Parametric_Default_SpaceLookup__c LPOEParam :[SELECT Id,LPOE_Line_Item__c, LPOE_Type__c, GSF_MX__c, GSF_C__c, Site_Ped__c, Site_Veh__c FROM NCMT_LPOE_Parametric_Default_SpaceLookup__c limit 1000]){
            string keyValue = LPOEParam.LPOE_Line_Item__c+LPOEParam.LPOE_Type__c;
            Parammap.put(keyValue,LPOEParam);
        }
        
        if((trigger.isInsert && trigger.isBefore) || (trigger.isUpdate && trigger.IsBefore)) {  
        	
        	NCMT_LPOEFormulaCalculations.FormulaCalculation(ProjectRecordID,trigger.oldmap,trigger.new,ncmtMap,Parammap);	
        	
        	NCMT_LPOEFormulaCalculations.UpdateProjectData(trigger.new, ncmtMap);	
        }
        
        if (Trigger.isAfter) {
        	
	        dblStandardRate = Projlst[0].Standard_Esc_Rate__c;
	        dtCostParameterDate = Projlst[0].Cost_Parameter_Date__c;
	        dtConstructionEndDate = Projlst[0].End_Construction__c;
	        txtCostParameterDateFY = Projlst[0].Cost_Parameter_Date_FY__c;
	        txtConstructionEndDateFY = Projlst[0].End_Construction_FY__c;
	        Start_Construction = Projlst[0].Start_Construction__c;
	        strState = Projlst[0].State__c;
	        strCity = Projlst[0].Location_Name__c;
	        mid_construction_dt = Projlst[0].Mid_Point_of_Construction__c;
	        
	        //List <NCMT_Location_Parameters__c> locrec = [Select Standard_Escalation__c from NCMT_Location_Parameters__c where Name = :strcity and state__c = :strstate and fiscal_year__c= :txtCostParameterDateFY];
               // dblStandardRate = locrec[0].Standard_Escalation__c;
        	
        	NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt(); 
        	      	
        	objGenerateDataExt.DeleteEscalationData(ProjectRecordID);
            objGenerateDataExt.GenerateEscalationData(ProjectRecordID, dblStandardRate, dtCostParameterDate, dtConstructionEndDate, txtCostParameterDateFY, txtConstructionEndDateFY, Start_Construction,mid_construction_dt);
        }                                
}