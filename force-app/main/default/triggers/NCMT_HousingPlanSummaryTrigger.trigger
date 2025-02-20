trigger NCMT_HousingPlanSummaryTrigger on NCMT_Housing_Plan_Summary__c (after insert, after update, before insert, before update) {

    NCMT_UpdateHousingPlanSummary objUpdateHPSummaryData = new NCMT_UpdateHousingPlanSummary();
    Map<ID,Schema.RecordTypeInfo> rt_map = NCMT_Project__c.sObjectType.getDescribe().getRecordTypeInfosById();
    ID ProjectRecordID;
    ID HPSummaryRecordID;
    NCMT_Housing_Plan_Summary__c OldValues;
    Decimal Override_RSF;
    Boolean blnHousingPlan, blndefaultHousingPlan;
    String ProjectRecordTypeName;
    String ProjectRecordType;
    String ProjRecordTypeName;
    String ProjectType;
    String strState;
    String strCity;
    Decimal Surface_Parking;
    Decimal Stand_alone_Parking_Garage;
    Decimal dblOverride_Calculated_Site_Area;
    Decimal Total_GSF;    
    Decimal Gross_Area_Including_Parking;
    String  Building_Cost_Type;
    String strSecurityLevel;
    string  txtCostParameterDateFY, txtConstructionEndDateFY;
    Date    dtCostParameterDate, dtConstructionEndDate, Start_Construction, Mid_Construction_dt;
    Decimal dblStandardRate;
    Decimal Main_Lobby, Atrium_Ground_floor_plan_area, Enclosed_Parking, Restrooms, Ground_floor_circulation, Elevator_lobbies, Other_circulation, Mechanical_Electrical_IT, Loading_dock_Recycling_Trash, Atrium_upper_levels_phantom_floors;
       
    System.debug('RUN HP SUMMARY TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    //if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
    for (NCMT_Housing_Plan_Summary__c HP : Trigger.new) {
            ProjectRecordID = HP.Project__c;
            Total_GSF = HP.Total_GSF__c;
            System.debug('TOTAL GSF: ' + Total_GSF);
            HPSummaryRecordID = HP.ID;
            Override_RSF = HP.Override_RSF__c;
            Main_Lobby = HP.Main_Lobby__c;
            Atrium_Ground_floor_plan_area = HP.Atrium_Ground_floor_plan_area__c;
            Enclosed_Parking = HP.Enclosed_Parking__c;
            Restrooms = HP.Restrooms__c;
            Ground_floor_circulation = HP.Ground_floor_circulation__c;
            Elevator_lobbies = HP.Elevator_lobbies__c;
            Other_circulation = HP.Other_circulation__c;
            Mechanical_Electrical_IT = HP.Mechanical_Electrical_IT__c;
            Loading_dock_Recycling_Trash = HP.Loading_dock_Recycling_Trash__c;
            Atrium_upper_levels_phantom_floors = HP.Atrium_upper_levels_phantom_floors__c;
    }
    
    List <NCMT_Project__c> Projlst = [select ID, Estimate_Type_Proj__c,Location_Name__c, State__c,Project_Labor_Agreement__c, Set_Aside_100__c, Project_Seismic_Design_Category__c, Building_Quality__c,
                                                Housing_Plan__c, Standard_Esc_Rate__c,RecordTypeID, Surface_Parking__c, Stand_alone_Parking_Garage__c, Override_Calculated_Site_Area__c, Building_Cost_Type__c, Level_of_Protection__c,
                                                Cost_Parameter_Date__c, Mid_Point_of_Construction__c,End_Construction__c, Cost_Parameter_Date_FY__c, End_Construction_FY__c, Start_Construction__c, Building_Type__c,
                                                Project_Type__c, Default_Housing_Plan__c, Gross_Area_Including_Parking__c,Location_Adjustment_DC__c, PLA__c, SB_HUB__c
                                                FROM NCMT_Project__c WHERE Id = :ProjectRecordID];
                                                                                                    
    ProjRecordTypeName = rt_map.get(Projlst[0].recordTypeID).getName();
    ProjectRecordTypeName = Projlst[0].Building_Type__c;
    ProjectType = Projlst[0].Project_Type__c; 
    blndefaultHousingPlan = Projlst[0].Default_Housing_Plan__c;     
    strstate = Projlst[0].State__c;
    strcity = Projlst[0].Location_Name__c;
    Mid_Construction_dt = Projlst[0].Mid_Point_of_Construction__c; 
    //SFWS-2043 update project details for housing plan NCMT project
    if(Trigger.isBefore && Trigger.isInsert){
      //objUpdateHPSummaryData.UpdateHousingPlanSummaryData(trigger.new, ProjectRecordID, ProjectRecordTypeName);
        
        objUpdateHPSummaryData.UpdateProjectData(trigger.new, ProjectRecordID);  
    }
   if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
   if (Trigger.isBefore) {
       
        objUpdateHPSummaryData.UpdateHousingPlanSummaryData(trigger.new, ProjectRecordID, ProjectRecordTypeName);
        
        objUpdateHPSummaryData.UpdateProjectData(trigger.new, ProjectRecordID);     
    }
    
    if (Trigger.isUpdate && Trigger.isBefore) {
        
        OldValues = Trigger.oldMap.get(HPSummaryRecordID);
        
        //Update Common Area, Non-Rentable and Total calculation fields, if Override RSF field is edited        
        if (Override_RSF != OldValues.Override_RSF__c) {
            objUpdateHPSummaryData.UpdateOverrideRSFData(trigger.new, ProjectRecordID, ProjectRecordTypeName);
        }
        //Update Total calculation fields and Override RSF = 0, if Common Area fields are edited
        else if (Main_Lobby != OldValues.Main_Lobby__c || Atrium_Ground_floor_plan_area != OldValues.Atrium_Ground_floor_plan_area__c || Enclosed_Parking != OldValues.Enclosed_Parking__c
            || Restrooms != OldValues.Restrooms__c || Ground_floor_circulation != OldValues.Ground_floor_circulation__c || Elevator_lobbies != OldValues.Elevator_lobbies__c
            || Other_circulation != OldValues.Other_circulation__c || Mechanical_Electrical_IT != OldValues.Mechanical_Electrical_IT__c 
            || Loading_dock_Recycling_Trash != OldValues.Loading_dock_Recycling_Trash__c) {
                
            objUpdateHPSummaryData.UpdateCommonAreaData(trigger.new, ProjectRecordID, ProjectRecordTypeName);
        }
        //Update Conditioned Core Area, if Atrium upper levels (phantom floors) is edited
        else if (Atrium_upper_levels_phantom_floors != OldValues.Atrium_upper_levels_phantom_floors__c) {
            objUpdateHPSummaryData.UpdateConditionedCoreAreaData(trigger.new, ProjectRecordID, ProjectRecordTypeName);
        }
    }
    
    if (Trigger.isAfter) {

        blnHousingPlan = Projlst[0].Housing_Plan__c;  
        ProjRecordTypeName = rt_map.get(Projlst[0].recordTypeID).getName();
        //ProjectRecordType = Projlst[0].RecordTypeID;
        ProjectRecordType = Projlst[0].building_type__c;
        ProjectType = Projlst[0].project_type__c;
        Surface_Parking = Projlst[0].Surface_Parking__c;
        Building_Cost_Type = Projlst[0].Building_Cost_Type__c;
        Stand_alone_Parking_Garage = Projlst[0].Stand_alone_Parking_Garage__c;  
        dblOverride_Calculated_Site_Area = Projlst[0].Override_Calculated_Site_Area__c;
        strSecurityLevel = string.valueOf(Projlst[0].Level_of_Protection__c);
        
        dblStandardRate = Projlst[0].Standard_Esc_Rate__c;
        dtCostParameterDate = Projlst[0].Cost_Parameter_Date__c;
        dtConstructionEndDate = Projlst[0].End_Construction__c;
        txtCostParameterDateFY = Projlst[0].Cost_Parameter_Date_FY__c;
        txtConstructionEndDateFY = Projlst[0].End_Construction_FY__c;
        Start_Construction = Projlst[0].Start_Construction__c;
        Mid_Construction_dt = Projlst[0].Mid_Point_of_Construction__c;
        Gross_Area_Including_Parking = Projlst[0].Gross_Area_Including_Parking__c;
        
        NCMT_TCOUpdates objTCOUpdates = new NCMT_TCOUpdates();
        
        //List <NCMT_Location_Parameters__c> locrec = [Select Standard_Escalation__c from NCMT_Location_Parameters__c where Name = :strcity and state__c = :strstate and fiscal_year__c= :txtCostParameterDateFY];
                //dblStandardRate = locrec[0].Standard_Escalation__c;
               
        if (blnHousingPlan == True && Total_GSF > 0) {
            
            List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :ProjectRecordID Limit 1000];
            Map<string, String> mapCostSummary = new Map<string, String>();
            for(NCMT_Project_Cost_Summary__c objItem : listCostSummary)
                mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);

            NCMT_GenerateProjectDetails objGenerateData = new NCMT_GenerateProjectDetails(); 
            NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt();    
            // Generate Project Level Parameter Data ...
               objGenerateData.DeletePLPData(ProjectRecordID);
                
            if((ProjectType == 'Repair & Alteration - Parametric Entry' && Gross_Area_Including_Parking != 0) || ProjectType == 'New Construction' || ProjectType == 'Repair & Alteration - Work Item Detail'){ 
                 objGenerateData.GeneratePLPData(ProjectRecordID,ProjectRecordType, ProjectType,ProjRecordTypeName);
           
                //Update Project Level Parameter Data with data from Housing Plan
                //TriggerValue.isInsertPT = True;
                  objGenerateData.UpdatePLPData(ProjectRecordID);
            }

            //Generate Site Information Data for Parking Garage
            if(ProjectType =='New Construction'){
                objGenerateData.DeleteSiteInfoData(ProjectRecordID);
                objGenerateData.GenerateSiteInfoData(ProjectRecordID,ProjectRecordTypeName,Surface_Parking,Stand_alone_Parking_Garage,blnHousingPlan, 'insert', dblOverride_Calculated_Site_Area);
            }
            
            objGenerateDataExt.DeleteEstimateAdjustments(ProjectRecordID);
            objGenerateDataExt.GenerateEstimateAdjustments(Projlst);
            
            objGenerateDataExt.DeleteEscalationData(ProjectRecordID);
            objGenerateDataExt.GenerateEscalationData(ProjectRecordID, dblStandardRate, dtCostParameterDate, dtConstructionEndDate, txtCostParameterDateFY, txtConstructionEndDateFY, Start_Construction,mid_construction_dt);          
            
            objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY);
            /*objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
            objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, Total_GSF, ProjectRecordType);
            
            // Delete and Generate Core Shell Cost ...
            objGenerateData.DeleteCoreShellData(ProjectRecordID);
            objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectRecordType);*/
            
            
                if(Building_Cost_Type == 'Core/Shell with TI'){
                    if(ProjectType == 'New Construction'){
                        objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
                        objGenerateDataExt.GenerateSecurityData(ProjectRecordID, Total_GSF, strSecurityLevel, txtCostParameterDateFY, mapCostSummary);
                    }
                                
                    objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                    objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, Total_GSF, ProjectRecordType, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY, mapCostSummary);
                    
                    objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY);

                    if(ProjectType != 'Repair & Alteration - Work Item Detail'){
                        objGenerateData.DeleteCoreShellData(ProjectRecordID);
                        if((ProjectType == 'Repair & Alteration - Parametric Entry' && Gross_Area_Including_Parking != 0) || ProjectType == 'New Construction'){    
                            objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);
                        }
                    }  
                    if(ProjRecordTypeName =='New Construction - TCO'){
                          objTCOUpdates.TCOfutureupdate(ProjectRecordID);
                     }
                }
                else if(Building_Cost_Type == 'Core/Shell only'){
                    if(ProjectType != 'Repair & Alteration - Work Item Detail'){
                        if(ProjectType == 'New Construction'){
                            objGenerateDataExt.DeleteSecurityData(ProjectRecordID);
                        }
                        objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                        
                        objGenerateData.DeleteCoreShellData(ProjectRecordID);
                        objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);
                    }   
                }
                else if(Building_Cost_Type == 'TI Only'){
                    if(ProjectType != 'Repair & Alteration - Work Item Detail'){
                        if(ProjectType != 'Repair & Alteration - Parametric Entry'){
                            objGenerateDataExt.DeleteSecurityData(ProjectRecordID);
                        } 
                        
                        objGenerateData.DeleteCoreShellData(ProjectRecordID);
                        
                        objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                        objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, Total_GSF, ProjectRecordType, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY, mapCostSummary);

                        objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY);
                    }
                }
                else if(Building_Cost_Type == 'TI Including Warm Lit Shell'){
                    if(ProjectType != 'Repair & Alteration - Work Item Detail'){
                        if(ProjectType != 'Repair & Alteration - Parametric Entry'){
                            objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
                        }
                        
                        objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                        objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, Total_GSF, ProjectRecordType, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY, mapCostSummary);
                        
                        objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY);

                        objGenerateData.DeleteCoreShellData(ProjectRecordID);
                        objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);
                    }
                    //TI demolition needs to be run as well
                }
                else if(Building_Cost_Type == 'TI Retrofit'){
                    if(ProjectType != 'Repair & Alteration - Work Item Detail'){
                        if(ProjectType != 'Repair & Alteration - Parametric Entry'){
                            objGenerateDataExt.DeleteSecurityData(ProjectRecordID);
                        } 
                        
                        objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                        objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, Total_GSF, ProjectRecordType, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY, mapCostSummary);
                        
                        objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY);

                        objGenerateData.DeleteCoreShellData(ProjectRecordID);
                        objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);
                    }
                    //TI demolition should be set to 0
                }
            
            
            if((trigger.isinsert) && (ProjectType == 'Repair & Alteration - Work Item Detail' || ProjectType == 'Repair & Alteration - Parametric Entry')){
                list<NCMT_RA_Phasing__c> lstRAPhasing = [Select ID from NCMT_RA_Phasing__c where Project__c = :ProjectRecordID ];
                if(lstRAPhasing.size()== 0){
                    // Generate RA Phasing Record ...
                    objGenerateDataExt.GenerateRAPhasing(ProjectRecordID, ProjectType, dtCostParameterDate, Mid_Construction_dt, Start_Construction, dtConstructionEndDate);
                }
            }   
  
            // Update Professional Service Estimate Data for User Defined Housing Plan
            if (ProjectRecordTypeName != 'Parking Garage' && ProjectType == 'New Construction') {
                objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordTypeName,'update',0);
            }  
                        
        }
        
        else if (blnHousingPlan == false && Total_GSF > 0) {
            NCMT_GenerateProjectDetails objGenerateData = new NCMT_GenerateProjectDetails(); 
            NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt();    
            //Generate Escalation Data ...
            objGenerateDataExt.DeleteEscalationData(ProjectRecordID);
            objGenerateDataExt.GenerateEscalationData(ProjectRecordID, dblStandardRate, dtCostParameterDate, dtConstructionEndDate, txtCostParameterDateFY, txtConstructionEndDateFY, Start_Construction,mid_construction_dt);
                        
            if((trigger.isinsert) && (ProjectType == 'Repair & Alteration - Work Item Detail' || ProjectType == 'Repair & Alteration - Parametric Entry')){
                list<NCMT_RA_Phasing__c> lstRAPhasing = [Select ID from NCMT_RA_Phasing__c where Project__c = :ProjectRecordID ];
                if(lstRAPhasing.size()== 0){
                    // Generate RA Phasing Record ...
                    objGenerateDataExt.GenerateRAPhasing(ProjectRecordID, ProjectType, dtCostParameterDate, Mid_Construction_dt, Start_Construction, dtConstructionEndDate);
                }    
            }           
        }
    }
    }//END TCO IF
}