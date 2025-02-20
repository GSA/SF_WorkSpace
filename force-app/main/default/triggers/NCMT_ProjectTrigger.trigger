trigger NCMT_ProjectTrigger on NCMT_Project__c (after insert, after update, before insert, before update, before delete) {
    
    if (Trigger.isDelete) {
        list <Professional_Service_Estimate__c> lstProfServEst = [select id from Professional_Service_Estimate__c where NCMT_Project__c in :trigger.oldmap.keyset()];
        delete lstProfServEst;
    }
    else {        
        if(trigger.new.size() > 1){
            // Bulk project inserts/updates are not supported in Release 1.0, although you could bulk load with a batch size of 1 ...
            for (NCMT_Project__c objProject:Trigger.new) {
                objProject.adderror('Please have an administrator set the batch size to 1 if you need to bulk load records.');
            }
        } else {            
            Boolean blnGrossArea, blnUseableArea, blnHousingPlan, blndefaultHousingPlan;
            ID      ProjectRecordID;
            Decimal  ProjectArea;
            Decimal dblGrossSqFt = 0; 
            string  strSecurityLevel;
            string  ProjectRecordType;
            string  strProjectRecordID;
            string  txtCostParameterDateFY, txtConstructionEndDateFY;
            Date    dtCostParameterDate, dtConstructionEndDate;
            Decimal dblStandardRate;
            Decimal dbllocationmultiplier;
            String  strProjectDeliveryMethod;
            string  ProjectRecordTypeName,ProjRecordTypeName;
            string  ProjectBldgHeight;
            string  strDominantPeriod;
            string  strHistoricLandmark;
            string  strOverallCondition;
            string  ProjectType;
            string  EstimateType;
            //string  EstimateFormat;
            String  strDefault_Housing_Plan_Entry_Type;
            string  RAEstimateType;
            string  RASecurity;
            Decimal RASecurityCost;
            string  ProjectBuilding_Parameter;
            Decimal ProjectAt_and_above_grade;
            Decimal ProjectBelow_Grade;
            String  strRemoteness;
            String  strBuilding_Quality;
            String  strBuildingSelection;
            Decimal Below_grade;
            String  Location;
            Decimal Total_GSF;
            String strstate;
            String strcity;
            String strcitytext;
            String strProjectName;
            Decimal dblSalestax=0.00;
            string strCommercial_Port_Size, strPOV_Port_Size;
            decimal dblTotal_ECC;
            decimal dblCEW_ECC;
            decimal dblTotal_Project_Cost;
            
            Boolean ProjectParking_Structure;
            Boolean ProjectParking_Deck;
            Boolean ProjectBelow_Grade_Structure;
            Boolean ProjectSloped_Parking_Deck;
            Boolean ProjectSpeed_Ramp;
            Boolean ProjectOptimized_for_Parking;
            Boolean ProjectMedium_Efficiency;
            Boolean ProjectLow_Efficiency;
            Boolean ProjectUtilitarian;
            Boolean ProjectMedium;
            Boolean ProjectHigh;
            Decimal ProjectNumber_of_Spaces;
            Decimal Surface_Parking;
            Decimal Stand_alone_Parking_Garage;
            Boolean ProjectSet_Aside_100;
            Boolean ProjectProject_Labor_Agreement;
            Boolean Include_Exclude_AIA;
            
            String  Building_Cost_Type;
            String  Building_Heigtht;
            String  Border;
            Decimal Total_Area_Including_Parking;
            Decimal Affected_Tenant_Area_USF;
            Decimal Gross_Area_Including_Parking;
            Decimal Total_Site_Area_Building_Footprint_SF;
            Decimal Percentage_of_Tenant_Area_Unfinished;
            string  strProjectStatus;
            string  strProjectSpecificAdjustment;
            Date    Start_Construction;
            Date    End_Construction;
            Date    Mid_Construction_dt;
            Date    Anticipated_Design_Date;
            Decimal Above_Ground;
            Decimal Below_Ground; 
            Decimal Average_Story_Height;
            Decimal Plumbing_Fixtures;
            Decimal Vertical_Conveyance_Elevators_Stops;
            String strParkingAreaType;
            Decimal dblParking_Within_Building_Structure;
            Decimal dblOverride_Calculated_Site_Area;
            Decimal UserDefinedHousingPlan_Record_Count;
            Decimal OtherCosts_RecordCount;
            Decimal dblParking_Garage_Gross_Area_SF;
            String strBuilding_Height_Parameter;
            String strMarkupMethod;
            String ProjPhases;
            String ProjSubPhases;
            String CEWCostLevel;
            String OccupancyStatus;
            String PhaseLevel;
            Decimal dblETPC;
            Decimal dbltotalcost1;
            Decimal dbltotalcost2;
            string txtRecordId ;
            
            NCMT_Project__c OldValues;
            NCMT_GenerateProjectDetails objGenerateData = new NCMT_GenerateProjectDetails(); 
            NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt(); 
            NCMT_TCOUpdates objTCOUpdates = new NCMT_TCOUpdates();
            NCMT_TCOFLOWController objTCOinsertflow = new NCMT_TCOFLOWController();
            NCMT_GenerateProjectDetailsCoreShellPG objGenerateDataCoreShellPG = new NCMT_GenerateProjectDetailsCoreShellPG();
            NCMT_GenerateDESProjectDetailsExt objGenerateDESProjectDetailsExt = new NCMT_GenerateDESProjectDetailsExt();
            NCMT_GenerateCEWProjectDetailsExt objGenerateCEWProjectDetailsExt = new NCMT_GenerateCEWProjectDetailsExt();  
            NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
            Map<ID,Schema.RecordTypeInfo> rt_Map = NCMT_Project__c.sObjectType.getDescribe().getRecordTypeInfosById();
            
            string  strRecordTypeDESOP = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction DES O&P').getRecordTypeId();
            string  strRecordTypeDES = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction - DES').getRecordTypeId();
            
            if (Trigger.isInsert && Trigger.isBefore) {
                
                
                
                system.debug('Trigger Insert & Before');
                System.debug(trigger.new);
                //NCMT_ProjectTriggerValue.firstRun = true;
                String strUserLevel = [Select NCMT_User_Level__c from User where id = :UserInfo.getUserId()].NCMT_User_Level__c;
                
                NCMT_Project__c current;
                for (NCMT_Project__c  objProject:Trigger.new){
                    //ProjectRecordTypeName = rt_map.get(objProject.recordTypeID).getName();
                    ProjectRecordTypeName = objProject.Building_Type__c;
                    ProjectType = objProject.Project_Type__c;
                    EstimateType = objProject.Estimate_Type_Proj__c;
                    RAEstimateType = objProject.RA_Estimate_Type__c;
                    ProjectBldgHeight = objProject.Building_Heigtht__c;
                    ProjectAt_and_above_grade = objProject.At_and_above_grade__c; 
                    strBuilding_Quality = objProject.Building_Quality__c;
                    strRemoteness = objProject.Remoteness__c; 
                    Building_Cost_Type = objProject.Building_Cost_Type__c;
                    strBuildingSelection = objProject.Building_Selection__c;               
                    strstate = objProject.State__c;
                    strcity = objProject.Location_Name__c;
                    objProject.Project_Status__c='Draft';
                    objProject.Regional_Portfolio__c=null;
                    objProject.Regional_Office_Cost_Mgt_QC__c=null;
                    objProject.Central_Office_Cost_Mgt_QA__c=null;
                    objProject.Central_Office_Portfolio__c=null;
                    objProject.Total_Other_Direct_Costs__c = 0;
                    objProject.Total_Other_Project_Costs__c = 0;
                    dblETPC = objProject.ETPC__c;                   
                    if(ProjectType == 'Repair & Alteration - Work Item Detail'){
                        objProject.Housing_Plan__c=true;
                        
                    }
                    
                    strProjectRecordId = objProject.Project_Record_Id__c;
                    current = objProject;
                    
                    if(objProject.Estimate_Type_Proj__c =='Definitive Estimating' || objProject.Estimate_Type_Proj__c =='Cost Estimating Workbook'){
                        
                        
                        objProject.Cost_Parameter_Date__c = ncmt_customsettings.Cost_Parameter_Date__c;
                        objProject.Include_Exclude_AIA__c = false;
                        objProject.Special_Use_Gross_Receipts_Tax__c =5;
                        
                        //If Project is not a clone, apply default Construction Contingency values
                        if(objProject.Project_Record_ID__c == null) {
                            IF(objProject.Project_Type__c =='New Construction - DES' || objProject.Project_Type__c =='New Construction - CEW'){
                                objProject.Construction_Contingency__c = 7;
                                
                            }else{
                                objProject.Construction_Contingency__c = 10;
                                
                            }
                        }
                        /*else if(objProject.Project_Record_Id__c != null)
{
NCMT_Project__c orig = [SELECT Construction_Contingency__c, Art_in_Architecture__c, Sales_Tax__c, Design_and_Site_Contingency__c FROM NCMT_Project__C WHERE Id =: objProject.Project_Record_ID__c];
//System.debug('Original: ' + orig);
if(objProject.Construction_Contingency__c == 0)
objProject.Construction_Contingency__c = orig.Construction_Contingency__c;
if(objProject.Art_in_Architecture__c == 0)
objProject.Art_In_Architecture__c = orig.Art_In_Architecture__c;
}*/
                    }
                    if(objProject.Estimate_Type_Proj__c =='Definitive Estimating'){
                        //objProject.Include_Exclude_AIA__c = false;
                        //objProject.Cost_Parameter_Date__c = ncmt_customsettings.Cost_Parameter_Date__c;
                        
                        strProjectDeliveryMethod = objProject.Project_Delivery_Method__c; 
                        strMarkupMethod = objProject.Markup_Method__c;
                        IF(strProjectDeliveryMethod =='IDIQ-JOC' && strMarkupMethod=='RSMeans - O&P'){
                            objProject.RecordTypeID = strRecordTypeDESOP;
                            
                        }
                        
                        if(objProject.Project_Phases__c == 'Design' && objProject.Project_Record_Id__c == null){
                            
                            if(objProject.Project_SubPhases__c=='Final Concept'){
                                
                                objProject.Design_and_Site_Contingency__c = 7.50;
                            }else if(objProject.Project_SubPhases__c.contains('Design')){
                                
                                objProject.Design_and_Site_Contingency__c =5.00;
                            }else if(objProject.Project_SubPhases__c=='75% Construction Documents' || objProject.Project_SubPhases__c=='90% Construction Documents'){
                                objProject.Design_and_Site_Contingency__c =2.50;
                                
                            }else{
                                
                                
                                objProject.Design_and_Site_Contingency__c =0;
                            }
                        }
                    }
                    Include_Exclude_AIA = objProject.Include_Exclude_AIA__c;
                    
                    if(objProject.Default_Housing_Plan__c == True){
                        
                        objProject.Gross_Area__c = True;
                        objProject.Total_Area_Including_Parking__c = objProject.Gross_Area_Including_Parking__c;
                    }
                    
                    objProject.Project_Level__c = objGenerateDataExt.fnUserLevel(strUserLevel); //Assign Project Level
                    if (objProject.Parking_Structure__c == True) {
                        strParkingAreaType = 'Parking Structure';
                        
                    }
                    else if (objProject.Parking_Deck__c == True) {
                        strParkingAreaType = 'Parking Deck';
                    }
                    else if (objProject.Below_Grade_Structure__c == True) {
                        strParkingAreaType = 'Below Grade Structure';
                    }
                    ProjPhases = objProject.Project_Phases__c;
                    ProjSubPhases = objProject.Project_SubPhases__c;
                    OccupancyStatus = objProject.CEW_Occupancy_Status__c;
                    PhaseLevel  = objProject.Phasing_Plan_Construction__c; 
                    
                }
                
                //Clone Markup values if record is a clone
                System.debug('strProjectRecordId====='+strProjectRecordId);
                if(strProjectRecordId != null)
                {
                    
                    
                    NCMT_Project__c orig = [SELECT Construction_Contingency__c, Art_in_Architecture__c, Sales_Tax__c, Design_and_Site_Contingency__c FROM NCMT_Project__C WHERE Id =: strProjectRecordId];
                    System.debug('Original: ' + orig);
                    if(current.Construction_Contingency__c == 0)
                        
                        current.Construction_Contingency__c = orig.Construction_Contingency__c;
                    if(current.Art_in_Architecture__c == 0)
                        
                        current.Art_In_Architecture__c = orig.Art_In_Architecture__c;
                }
                
                if(EstimateType !='Definitive Estimating' && EstimateType !='Cost Estimating Workbook'){
                    //update project with Markup data
                    
                    objGenerateData.UpdateProjectMarkup(trigger.new, ProjectType, Building_Cost_Type, strBuildingSelection, Include_Exclude_AIA, ProjectRecordTypeName);
                }else if(EstimateType =='Cost Estimating Workbook'){
                    //update CEW project with Markup data [objGenerateCEWProjectDetailsExt]
                    NCMT_GenerateCEWProjectDetailsExt.UpdateCEWProjectMarkup(trigger.new, ProjectType,ProjPhases,ProjSubPhases,Include_Exclude_AIA,ProjectRecordTypeName,OccupancyStatus,PhaseLevel,dblETPC);
                }
                //update project with Building Parameter code, Building Height Parameter code, Location code and Start or End Construction dates
                objGenerateData.UpdateProjectData(trigger.new, ProjectRecordTypeName, ProjectType, ProjectBldgHeight, ProjectAt_and_above_grade, strBuilding_Quality, strRemoteness, strstate, strcity, strParkingAreaType); 
                
            }   
            
            if (Trigger.isInsert && Trigger.isAfter) {
                
                NCMT_ProjectTriggerValue.firstRun = false;
                Boolean isTCOClone = false;
                
                system.debug('Trigger Insert & After');
                //system.debug('NCMT_ProjectTriggerValue.firstRun Insert===='+NCMT_ProjectTriggerValue.firstRun);
                
                // Get data for the record that was updated ...
                NCMT_Project__c proj;
                for (NCMT_Project__c  objProject:Trigger.new){ //See validation/note above, we should have 1 project only at this point ...
                    ProjectRecordID = objProject.ID;
                    //dblStandardRate = objProject.Standard_Esc_Rate__c;
                    dtCostParameterDate = objProject.Cost_Parameter_Date__c;
                    dtConstructionEndDate = objProject.End_Construction__c;
                    Mid_Construction_dt = objProject.Mid_Point_of_Construction__c;
                    txtCostParameterDateFY = objProject.Cost_Parameter_Date_FY__c;
                    txtConstructionEndDateFY = objProject.End_Construction_FY__c;
                    blnGrossArea = objProject.Gross_Area__c;
                    blnUseableArea = objProject.Useable_Area__c;
                    blnHousingPlan = objProject.Housing_Plan__c;
                    blndefaultHousingPlan = objProject.Default_Housing_Plan__c;
                    RAEstimateType = objProject.RA_Estimate_Type__c;
                    RASecurity = objProject.RA_Security__c;
                    RASecurityCost = objProject.RA_Security_Cost__c;
                    //ProjectRecordType = objProject.RecordTypeID;
                    ProjRecordTypeName = rt_map.get(objProject.recordTypeID).getName();
                    ProjectRecordTypeName = objProject.Building_Type__c;
                    System.debug('ProjectRecordTypeName: ' + ProjectRecordTypeName);
                    ProjectType = objProject.Project_Type__c;
                    EstimateType = objProject.Estimate_Type_Proj__c;
                    //EstimateFormat = objProject.Estimate_Format__c;
                    Surface_Parking = objProject.Surface_Parking__c;
                    Stand_alone_Parking_Garage = objProject.Stand_alone_Parking_Garage__c;
                    dblGrossSqFt = objProject.Total_GSF__c;
                    strSecurityLevel = string.valueOf(objProject.Level_of_Protection__c); 
                    strstate = objProject.State__c;
                    Border = objProject.Border__c;
                    strcity = objProject.Location_Name__c;
                    //dblSalestax = objProject.Location_Based_Sales_Tax__c;
                    Building_Cost_Type = objProject.Building_Cost_Type__c;
                    dblOverride_Calculated_Site_Area = objProject.Override_Calculated_Site_Area__c;
                    Start_Construction = objProject.Start_Construction__c;
                    strProjectName = objProject.Name;
                    strProjectRecordID = objProject.Project_Record_ID__c; 
                    System.debug('ProjRecordId === ' + strProjectRecordId);
                    strProjectDeliveryMethod = objProject.Project_Delivery_Method__c; 
                    strMarkupMethod = objProject.Markup_Method__c;
                    dblSalesTax = objProject.Sales_Tax__c;
                    System.debug(objProject.Sales_Tax__c);
                    proj = objProject;
                }
                
                if(ProjRecordTypeName == 'New Construction - TCO' && (strProjectRecordId != ProjectRecordId) && strProjectRecordId != null){
                    isTCOClone = true;
                    System.debug('IS TCO CLONE');}
                List <NCMT_Location_Parameters__c> locrec = [Select Standard_Escalation__c, Location_Adjustment_DC__c,National_Average__c, Sales_Tax__c
                                                             from NCMT_Location_Parameters__c 
                                                             where Name = :strcity and state__c = :strstate and fiscal_year__c= :txtCostParameterDateFY];
                
                if (locrec.size()>0){
                    dblStandardRate  = locrec[0].Standard_Escalation__c;
                    if(EstimateType =='Definitive Estimating'){
                        //Only copy sales tax from location param if not a clone //--COMMENTED OUT 8/11/21
                        //if(strProjectRecordId == ProjectRecordId) {
                        dblSalesTax = locrec[0].Sales_Tax__c;
                        //}
                        if(strProjectDeliveryMethod =='IDIQ-JOC'){
                            dbllocationmultiplier = 1;
                        }else{
                            dbllocationmultiplier = locrec[0].National_Average__c;
                        }
                    }
                }
                System.debug('dbllocationmultiplier ===== ' +dbllocationmultiplier);
                
                /*4.2, replaces lines 276 through 291
Map<String, Double> paramValues = NCMT_ProjectCalculations.locationParameterValues(proj);
dblStandardRate  = paramValues.get('standardRate');                        
if(EstimateType =='Definitive Estimating'){
//Only copy sales tax from location param if not a clone
if(strProjectRecordId == ProjectRecordId) 
dblSalesTax = paramValues.get('salesTax');
dbllocationmultiplier = paramValues.get('locationMultiplier');

}
*/
                
                //Generate Escalation Data ...it is moved to housing plan
                //objGenerateDataExt.GenerateEscalationData(ProjectRecordID, dblStandardRate, dtCostParameterDate, dtConstructionEndDate, txtCostParameterDateFY, txtConstructionEndDateFY, Start_Construction); // Generate Security Data ...
                if(EstimateType != 'Definitive Estimating' && EstimateType != 'Cost Estimating Workbook'){
                    if(ProjectRecordTypeName != 'LPOE'){
                        if (blnHousingPlan == false && isTCOClone == false) {
                            // Generate HousingPlan Data ...
                            objGenerateData.GenerateHousingPlanData(ProjectRecordID, blnGrossArea, blnUseableArea, ProjectType, blndefaultHousingPlan);
                            
                            // Generate Project Level Parameter Data ...
                            objGenerateData.GeneratePLPData(ProjectRecordID,ProjectRecordTypeName, ProjectType, ProjRecordTypeName);
                            //TriggerValue.isInsertPT = True;
                            //Update Project Level Parameter Data with data from Housing Plan
                            objGenerateData.UpdatePLPData(ProjectRecordID);
                            
                            // Generate Cost Estimate Adjustment Data ...
                            objGenerateDataExt.GenerateEstimateAdjustments(trigger.new); 
                            
                            //Generate Site Information Data for Parking Garage
                            if(ProjectType == 'New Construction'){
                                objGenerateData.GenerateSiteInfoData(ProjectRecordID,ProjectRecordTypeName,Surface_Parking,Stand_alone_Parking_Garage,blnHousingPlan, 'insert', dblOverride_Calculated_Site_Area);
                            }
                        }
                        
                        // Generate Project Summary Costs ...
                        //if(isTCOClone == false)
                        objGenerateDataExt.GenerateCostSummary(ProjectRecordID,ProjectType,RAEstimateType,RASecurity,RASecurityCost); 
                        
                        if (blnHousingPlan == false && isTCOClone == false) {
                            
                            List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :ProjectRecordID Limit 1000];
                            Map<string, String> mapCostSummary = new Map<string, String>();
                            for(NCMT_Project_Cost_Summary__c objItem : listCostSummary)
                                mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
                            
                            
                            if (ProjectRecordTypeName != 'Parking Garage'){
                                if( ProjectType != 'Repair & Alteration - Work Item Detail'){
                                    
                                    objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY);
                                    
                                    if(Building_Cost_Type == 'Core/Shell with TI'){
                                        if( ProjectType != 'Repair & Alteration - Parametric Entry'){
                                            objGenerateDataExt.GenerateSecurityData(ProjectRecordID, dblGrossSqFt, strSecurityLevel, txtCostParameterDateFY, mapCostSummary);
                                        }
                                        
                                        objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, blnHousingPlan, blndefaultHousingPlan,txtCostParameterDateFY, mapCostSummary);
                                        objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary); 
                                    }
                                    else if(Building_Cost_Type == 'Core/Shell only'){
                                        objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);  
                                    }
                                    else if(Building_Cost_Type == 'TI Only'){
                                        objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, blnHousingPlan, blndefaultHousingPlan,txtCostParameterDateFY, mapCostSummary);
                                    }
                                    else if(Building_Cost_Type == 'TI Including Warm Lit Shell'){
                                        objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, blnHousingPlan, blndefaultHousingPlan,txtCostParameterDateFY, mapCostSummary);
                                        objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);
                                        //TI demolition needs to be run as well
                                    }
                                    else if(Building_Cost_Type == 'TI Retrofit'){
                                        objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, blnHousingPlan, blndefaultHousingPlan,txtCostParameterDateFY, mapCostSummary);
                                        objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY,mapCostSummary);
                                        //TI demolition should be set to 0
                                    }
                                }
                            }
                            else{
                                system.debug('ProjectRecordTypeName1===' + ProjectRecordTypeName);
                                objGenerateDataCoreShellPG.GenerateCoreShellDataPG(ProjectRecordID, ProjectRecordTypeName);
                            }   
                        }
                    } 
                } 
                
                if(ProjectRecordTypeName == 'LPOE' && EstimateType != 'Definitive Estimating' && EstimateType != 'Cost Estimating Workbook'){
                    
                    //Generate LPOE Cost Summary costs
                    objGenerateDataExt.GenerateLPOECostSummary(ProjectRecordID,ProjectType, Border, txtCostParameterDateFY);
                    
                    //Generate LPOE Space Plan
                    objGenerateData.GenerateLPOESpacePlanData(ProjectRecordID,ProjectRecordTypeName, ProjectType);
                    
                    // Generate Cost Estimate Adjustment Data ...
                    objGenerateDataExt.GenerateEstimateAdjustments(trigger.new); 
                    
                }
                
                if(EstimateType == 'Definitive Estimating' || EstimateType == 'Cost Estimating Workbook'){               
                    // Generate Project Summary Costs ...
                    objGenerateDataExt.GenerateCostSummary(ProjectRecordID, ProjectType, RAEstimateType, RASecurity,RASecurityCost); 
                    
                    //Generate project phasing
                    objGenerateDataExt.GenerateRAPhasing(ProjectRecordID, ProjectType, dtCostParameterDate , Mid_Construction_dt, Start_Construction, dtConstructionEndDate);
                    
                    //Generate Escalation Data
                    objGenerateDataExt.GenerateEscalationData(ProjectRecordID, dblStandardRate, dtCostParameterDate, dtConstructionEndDate, txtCostParameterDateFY, txtConstructionEndDateFY, Start_Construction, Mid_Construction_dt);   
                    
                    if(EstimateType == 'Definitive Estimating'){
                        //Generate Markup Data
                        dblSalesTax = objGenerateDESProjectDetailsExt.GenerateDESMarkups(ProjectRecordID,ProjectType,strProjectDeliveryMethod,strMarkupMethod);
                        //Generate Tree Structure for new project record
                        System.debug('Sales Tax = ' + dblSalesTax);
                        objGenerateDESProjectDetailsExt.GenerateDESTreeStr(ProjectRecordID,ProjectType, strProjectName, strProjectRecordID,dblSalesTax,dbllocationmultiplier,strMarkupMethod,strstate);
                    }else if(EstimateType == 'Cost Estimating Workbook'){
                        // Generate Cost Estimate Adjustment Data ...
                        objGenerateDataExt.GenerateEstimateAdjustments(trigger.new); 
                        
                        //----------CEW CLONE
                        NCMT_GenerateCEWProjectDetailsExt.insertCloneDetails(strProjectRecordId, ProjectRecordId);
                        //----------END CEW CLONE
                    }
                }
                
                if ((ProjectType == 'New Construction' || ProjectType == 'New Construction - CEW' || ProjectType == 'New Construction - TCO') && isTCOClone ==false) {                
                   /* SFWS-2040 starts here: if statement excluding Utility removed.
                    if (ProjectRecordTypeName != 'Utility') {
                        System.debug('CALLING PROF SERV');
                        objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordTypeName,'insert', 0);
                    }
					*/
                  
                        System.debug('CALLING PROF SERV');
                        objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordTypeName,'insert', 0);
                    //SFWS-2040 ends here
                }
                //COMMENTING OUT BECAUSE THESE PROJECT TYPES HAVE BEEN DEACTIVATED
                /*else if (ProjectType == 'Repair & Alteration - Parametric Entry' || ProjectType == 'Repair & Alteration - Work Item Detail' || ProjectType == 'Repair & Alteration - CEW') {
if (ProjectRecordTypeName != 'Utility' && ProjectRecordTypeName != 'Childcare Center' && ProjectRecordTypeName != 'Parking Garage' && ProjectRecordTypeName != 'LPOE') {
objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordTypeName,'insert', 0);
}
}*/
                
                //Clone Housing Plan if Housing Plan is checked
                if((ProjectType == 'New Construction' && ProjRecordTypeName != 'New Construction - TCO')) 
                { 
                    objGenerateData.generateHousingPlanCloneData(strProjectRecordId, ProjectRecordId, blnHousingPlan);
                }
                
                //-----TCO CLONE
                if(ProjRecordTypeName == 'New Construction - TCO' && (strProjectRecordId != ProjectRecordId) && strProjectRecordId != null)
                {
                    System.debug('TCO CLONE');
                    
                    //Clone all Housing Plan details
                    NCMT_HousingPlanClone hpc = new NCMT_HousingPlanClone(strProjectRecordId, ProjectRecordId);
                    hpc.cloneHousingPlanSync(proj);
                    
                    //Clone remaining child objects
                    NCMT_GenerateTCOProjectDetailsExt tcoDetails = new NCMT_GenerateTCOProjectDetailsExt();
                    tcoDetails.cloneTCODetails(strProjectRecordId, ProjectRecordId, trigger.new);
                }
                
            } 
            
            if (Trigger.isUpdate && Trigger.isBefore && NCMT_ProjectTriggerValue.firstRun == true) {
                system.debug('Trigger Update & Before');
                //system.debug('NCMT_ProjectTriggerValue.firstRun Update===='+NCMT_ProjectTriggerValue.firstRun);
                
                Boolean getLocRec = false;
                
                for (NCMT_Project__c objProject:Trigger.new){
                    strstate = objProject.State__c;
                    strcity = objProject.Location_Name__c;
                    txtCostParameterDateFY = objProject.Cost_Parameter_Date_FY__c;
                    
                    //----Added 10/1/20 to avoid query limits in NCMT_TestValidateClass
                    if(objProject.Estimate_Type_Proj__c =='Definitive Estimating'
                       &&(objProject.Location__c != Trigger.oldMap.get(objProject.Id).Location__c
                          || objProject.Project_Delivery_Method__c != Trigger.oldMap.get(objProject.Id).Project_Delivery_Method__c)
                      ){
                          getLocRec = true;}
                }
                
                List <NCMT_Location_Parameters__c> locrec = new List<NCMT_Location_Parameters__C>();
                
                if(getLocRec == true){
                    locrec = [Select Standard_Escalation__c, Location_Adjustment_DC__c,National_Average__c, Sales_Tax__c
                              from NCMT_Location_Parameters__c 
                              where Name = :strcity and state__c = :strstate and fiscal_year__c= :txtCostParameterDateFY];
                } 
                //-----End 10/1/20 change
                
                for (NCMT_Project__c objProject:Trigger.new){
                    ProjectRecordID = objProject.ID;
                    ProjectParking_Structure = objProject.Parking_Structure__c;
                    ProjectParking_Deck = objProject.Parking_Deck__c;
                    ProjectBelow_Grade_Structure = objProject.Below_Grade_Structure__c;
                    ProjectSloped_Parking_Deck = objProject.Sloped_Parking_Deck__c;
                    ProjectSpeed_Ramp = objProject.Speed_Ramp__c;
                    ProjectOptimized_for_Parking = objProject.Optimized_for_Parking__c;
                    ProjectMedium_Efficiency = objProject.Medium_Efficiency__c;
                    ProjectLow_Efficiency = objProject.Low_Efficiency__c;
                    ProjectUtilitarian = objProject.Utilitarian__c;
                    ProjectMedium = objProject.Medium__c;
                    ProjectHigh = objProject.High__c;
                    ProjectNumber_of_Spaces = objProject.Number_of_Spaces__c;
                    ProjectAt_and_above_grade = objProject.At_and_above_grade__c; 
                    strstate = objProject.State__c;
                    strcity = objProject.Location_Name__c;
                    Building_Cost_Type = objProject.Building_Cost_Type__c;
                    strBuildingSelection = objProject.Building_Selection__c;
                    Building_Heigtht = objProject.Building_Heigtht__c;
                    Include_Exclude_AIA = objProject.Include_Exclude_AIA__c;
                    blnGrossArea = objProject.Gross_Area__c;
                    blnUseableArea = objProject.Useable_Area__c;
                    blnHousingPlan = objProject.Housing_Plan__c;
                    blndefaultHousingPlan = objProject.Default_Housing_Plan__c;
                    Total_Area_Including_Parking = objProject.Total_Area_Including_Parking__c;
                    System.debug('Total_Area_Including_Parking__c====='+Total_Area_Including_Parking);
                    Gross_Area_Including_Parking = objProject.Gross_Area_Including_Parking__c;
                    Affected_Tenant_Area_USF = objProject.Affected_Tenant_Area_USF__c;
                    Percentage_of_Tenant_Area_Unfinished = objProject.Percentage_of_Tenant_Area_Unfinished__c;
                    strBuilding_Quality = objProject.Building_Quality__c;                
                    strRemoteness = objProject.Remoteness__c;
                    ProjRecordTypeName = rt_map.get(objProject.recordTypeID).getName();
                    ProjectRecordTypeName = objProject.Building_Type__c;
                    ProjectType = objProject.Project_Type__c;
                    EstimateType = objProject.Estimate_Type_Proj__c;
                    strSecurityLevel = string.valueOf(objProject.Level_of_Protection__c);
                    Start_Construction = objProject.Start_Construction__c;
                    End_Construction = objProject.End_Construction__c;
                    dblParking_Garage_Gross_Area_SF = objProject.Parking_Garage_Gross_Area_SF__c;
                    dblGrossSqFt = objProject.Total_GSF__c;
                    strBuilding_Height_Parameter = objProject.Building_Height_Parameter__c;
                    strProjectDeliveryMethod = objProject.Project_Delivery_Method__c; 
                    strMarkupMethod = objProject.Markup_Method__c;
                    txtCostParameterDateFY = objProject.Cost_Parameter_Date_FY__c;
                    
                    if(objProject.Estimate_Type_Proj__c =='Definitive Estimating' || objProject.Estimate_Type_Proj__c =='Cost Estimating Workbook'){
                        IF(trigger.oldmap.get(objProject.id).Include_Exclude_AIA__c != objProject.Include_Exclude_AIA__c){
                            if(objProject.Include_Exclude_AIA__c){
                                objProject.Art_In_Architecture__c = 0.50;
                            }else{
                                objProject.Art_In_Architecture__c =0.00;
                            }
                        }                    
                    }
                    system.debug('jmd objProject.Estimate_Type_Proj__c '+objProject.Estimate_Type_Proj__c);
                    system.debug('jmd strProjectDeliveryMethod');
                    system.debug('jmd dbllocationmultiplier '+dbllocationmultiplier);
                    if(objProject.Estimate_Type_Proj__c =='Definitive Estimating'
                       && (objProject.Location__c != Trigger.oldMap.get(objProject.Id).Location__c
                          || objProject.Project_Delivery_Method__c != Trigger.oldMap.get(objProject.Id).Project_Delivery_Method__c)
                      ){
                          
                          if (locrec.size()>0){
                              dblStandardRate  = locrec[0].Standard_Escalation__c; 
                              if(EstimateType =='Definitive Estimating'){
                                  //Only copy sales tax from location param if not a clone
                                  if(strProjectRecordId == ProjectRecordId) {
                                      dblSalesTax = locrec[0].Sales_Tax__c;}
                                  if(strProjectDeliveryMethod =='IDIQ-JOC'){
                                      dbllocationmultiplier = 1;
                                  }else{
                                      dbllocationmultiplier = locrec[0].National_Average__c;
                                  }
                              }
                          }
                          
                          objProject.Location_Multiplier__c=dbllocationmultiplier;
                      }
                    System.debug(objProject.Estimate_Type_Proj__c);
                    if(objProject.Estimate_Type_Proj__c == 'Definitive Estimating'){
                        IF(strProjectDeliveryMethod =='IDIQ-JOC' && strMarkupMethod=='RSMeans - O&P'){
                            objProject.RecordTypeID = strRecordTypeDESOP;
                            objProject.sales_tax__c=0;
                        }
                        if(strProjectDeliveryMethod =='IDIQ-JOC'){
                            objProject.Location_Multiplier__c = 1;
                        }
                        System.debug(trigger.oldmap.get(objProject.id).Project_SubPhases__c);
                        System.debug(objProject.Project_SubPhases__c);
                        IF((trigger.oldmap.get(objProject.id).Project_Phases__c != objProject.Project_Phases__c) || (trigger.oldmap.get(objProject.id).Project_SubPhases__c != objProject.Project_SubPhases__c)){
                            
                            if(objProject.Project_Phases__c == 'Design'){
                                if(objProject.Project_SubPhases__c=='Final Concept'){
                                    objProject.Design_and_Site_Contingency__c = 7.50;
                                }else if(objProject.Project_SubPhases__c.contains('Design')){
                                    objProject.Design_and_Site_Contingency__c =5.00;
                                }else if(objProject.Project_SubPhases__c=='75% Construction Documents' || objProject.Project_SubPhases__c=='90% Construction Documents'){
                                    objProject.Design_and_Site_Contingency__c =2.50;
                                }else{
                                    objProject.Design_and_Site_Contingency__c =0;
                                }
                            }else{
                                objProject.Design_and_Site_Contingency__c =0;
                            }
                        }
                        
                    }
                    
                    if(objProject.Default_Housing_Plan__c == True){
                        objProject.Gross_Area__c = True;
                        objProject.Total_Area_Including_Parking__c = objProject.Gross_Area_Including_Parking__c;
                        System.debug('Total Area Including Parking changed to: ' + objProject.Gross_Area_Including_Parking__c);
                    }
                    
                    if (ProjectParking_Structure == True) {
                        strParkingAreaType = 'Parking Structure';
                    }
                    else if (ProjectParking_Deck == True) {
                        strParkingAreaType = 'Parking Deck';
                    }
                    else if (ProjectBelow_Grade_Structure == True) {
                        strParkingAreaType = 'Below Grade Structure';
                    }
                    ProjPhases = objProject.Project_Phases__c;
                    ProjSubPhases = objProject.Project_SubPhases__c;
                    OccupancyStatus = objProject.CEW_Occupancy_Status__c;
                    PhaseLevel  = objProject.Phasing_Plan_Construction__c;
                    dblETPC = objProject.ETPC__c;
                    dbltotalcost1 = objProject.CEW_Total_Direct_Cost_1__c;
                    dbltotalcost2 = objProject.CEW_Total_Direct_Cost_2__c;
                    txtRecordId = objProject.Project_Record_ID__c;
                }
                OldValues = Trigger.oldMap.get(ProjectRecordID);
                System.debug('');
                
                
                if (ProjectRecordTypeName == 'Parking Garage'){
                    if (ProjectParking_Structure != OldValues.Parking_Structure__c || ProjectParking_Deck != OldValues.Parking_Deck__c || ProjectBelow_Grade_Structure != OldValues.Below_Grade_Structure__c
                        || ProjectSloped_Parking_Deck != OldValues.Sloped_Parking_Deck__c || ProjectSpeed_Ramp != OldValues.Speed_Ramp__c || ProjectOptimized_for_Parking != OldValues.Optimized_for_Parking__c
                        || ProjectMedium_Efficiency != OldValues.Medium_Efficiency__c || ProjectLow_Efficiency != OldValues.Low_Efficiency__c || ProjectUtilitarian != OldValues.Utilitarian__c
                        || ProjectMedium != OldValues.Medium__c || ProjectHigh != OldValues.High__c || ProjectNumber_of_Spaces != OldValues.Number_of_Spaces__c 
                        || ProjectAt_and_above_grade != OldValues.At_and_above_grade__c || strstate != OldValues.State__c || strcity != OldValues.Location_Name__c 
                        || strBuilding_Quality != OldValues.Building_Quality__c || strRemoteness!= OldValues.Remoteness__c ) {
                            //update project with Building Parameter code, Building Height Parameter code, Location code and Start or End Construction dates
                            objGenerateData.UpdateProjectData(trigger.new, ProjectRecordTypeName, ProjectType, Building_Heigtht, ProjectAt_and_above_grade, strBuilding_Quality, strRemoteness, strstate, strcity, strParkingAreaType);
                        }
                    else if (Start_Construction != OldValues.Start_Construction__c || End_Construction != OldValues.End_Construction__c) {
                        //update start or end construction
                        objGenerateData.updateProjStartEndConstruction(trigger.new, strBuilding_Height_Parameter, dblParking_Garage_Gross_Area_SF, Building_Cost_Type);
                    }
                }
                else {
                    System.debug('before if: ' );
                    if (Building_Cost_Type != OldValues.Building_Cost_Type__c || Building_Heigtht != OldValues.Building_Heigtht__c || blnGrossArea != OldValues.Gross_Area__c
                        || blnUseableArea != OldValues.Useable_Area__c || blnHousingPlan != OldValues.Housing_Plan__c || Total_Area_Including_Parking != OldValues.Total_Area_Including_Parking__c
                        || Percentage_of_Tenant_Area_Unfinished != OldValues.Percentage_of_Tenant_Area_Unfinished__c 
                        || strstate != OldValues.State__c || strcity != OldValues.Location_Name__c || strBuildingSelection != OldValues.Building_Selection__c || Include_Exclude_AIA != OldValues.Include_Exclude_AIA__c
                        || strBuilding_Quality != OldValues.Building_Quality__c || strRemoteness!= OldValues.Remoteness__c || Gross_Area_Including_Parking != OldValues.Gross_Area_Including_Parking__c
                        || Affected_Tenant_Area_USF != OldValues.Affected_Tenant_Area_USF__c || blnDefaultHousingPlan != OldValues.Default_Housing_Plan__c
                        || ProjPhases !=OldValues.Project_Phases__c || ProjSubPhases != OldValues.Project_SubPhases__c ||OccupancyStatus!=OldValues.CEW_Occupancy_Status__c ||PhaseLevel!=OldValues.Phasing_Plan_Construction__c
                        || dblETPC != OldValues.ETPC__c || txtRecordId != OldValues.Project_Record_ID__c) {
                            //update project with Building Parameter code, Building Height Parameter code, Location code and Start or End Construction dates
                            objGenerateData.UpdateProjectData(trigger.new, ProjectRecordTypeName, ProjectType, Building_Heigtht, ProjectAt_and_above_grade, strBuilding_Quality, strRemoteness, strstate, strcity, strParkingAreaType);
                            
                            IF(EstimateType !='Definitive Estimating' && EstimateType !='Cost Estimating Workbook'){
                                //update project with Markup data
                                objGenerateData.UpdateProjectMarkup(trigger.new, ProjectType, Building_Cost_Type, strBuildingSelection, Include_Exclude_AIA, ProjectRecordTypeName);
                            }else if(EstimateType =='Cost Estimating Workbook'){
                                //update CEW project with Markup data [objGenerateCEWProjectDetailsExt]
                                NCMT_GenerateCEWProjectDetailsExt.UpdateCEWProjectMarkup(trigger.new, ProjectType,ProjPhases,ProjSubPhases,Include_Exclude_AIA,ProjectRecordTypeName,OccupancyStatus,PhaseLevel,dblETPC);
                            }
                        }
                    else if (Start_Construction != OldValues.Start_Construction__c || End_Construction != OldValues.End_Construction__c) {
                        //update start or end construction
                        objGenerateData.updateProjStartEndConstruction(trigger.new, strBuilding_Height_Parameter, dblGrossSqFt, Building_Cost_Type);
                    }
                    
                }
                System.debug('Total_Area_Including_Parking__c===='+Total_Area_Including_Parking);
            }
           
            // for project level parameters to do recalculation after user update
            if(trigger.isupdate){
                TriggerValue.isupdate = false;   
                //system.debug('TriggerValue.isupdate==NCMT'+TriggerValue.isupdate); 
            }       
            
            if (Trigger.isUpdate && Trigger.isAfter && NCMT_ProjectTriggerValue.firstRun == true) {
                
                //For TCO Only logic
                Id tcoRecordTypeId = NCMT_Utilities.getProjectRecordTypeId('New_Construction_TCO');
                Set<Id> tcoDateChange = new Set<id>();
                
                system.debug('Trigger Update & After');
                NCMT_ProjectTriggerValue.firstRun = false;              
                NCMT_Project__c proj;
                for (NCMT_Project__c  objProject:Trigger.new){
                    System.debug('objProject: ' + objProject);
                    if (objProject.RecordTypeId == tcoRecordTypeId
                        &&(objProject.End_Construction__c != Trigger.oldMap.get(objProject.Id).End_Construction__c
                           || objProject.Start_Construction__c != Trigger.oldMap.get(objProject.Id).Start_Construction__c)
                       ){
                           System.debug('ADDING PROJ TO LIFECYCLE UPDATE: ' + objProject.Id);
                           System.debug(objProject.Project_Record_ID__c);
                           tcoDateChange.add(objProject.Id);
                       }
                    
                    ProjectRecordID = objProject.ID;
                    ProjectRecordType = objProject.RecordTypeID;
                    ProjRecordTypeName = rt_map.get(objProject.recordTypeID).getName();
                    ProjectRecordTypeName = objProject.Building_Type__c;
                    ProjectType = objProject.Project_Type__c;
                    ProjectBldgHeight = objProject.Building_Heigtht__c;
                    strPOV_Port_Size = objProject.POV_Port_Size__c;
                    strCommercial_Port_Size = objProject.Commercial_Port_Size__c;
                    strProjectStatus = string.valueof(objProject.Project_Status__c) ;
                    strProjectSpecificAdjustment = String.valueof(objProject.Project_Specific_Adjustment__c);
                    
                    ProjectParking_Structure = objProject.Parking_Structure__c;
                    ProjectParking_Deck = objProject.Parking_Deck__c;
                    ProjectBelow_Grade_Structure = objProject.Below_Grade_Structure__c;
                    ProjectSloped_Parking_Deck = objProject.Sloped_Parking_Deck__c;
                    ProjectSpeed_Ramp = objProject.Speed_Ramp__c;
                    ProjectOptimized_for_Parking = objProject.Optimized_for_Parking__c;
                    ProjectMedium_Efficiency = objProject.Medium_Efficiency__c;
                    ProjectLow_Efficiency = objProject.Low_Efficiency__c;
                    ProjectUtilitarian = objProject.Utilitarian__c;
                    ProjectMedium = objProject.Medium__c;
                    ProjectHigh = objProject.High__c;
                    ProjectNumber_of_Spaces = objProject.Number_of_Spaces__c;
                    ProjectAt_and_above_grade = objProject.At_and_above_grade__c; 
                    ProjectBelow_grade = objProject.Below_grade__c;
                    Surface_Parking = objProject.Surface_Parking__c;
                    Stand_alone_Parking_Garage = objProject.Stand_alone_Parking_Garage__c;
                    
                    Building_Cost_Type = objProject.Building_Cost_Type__c;
                    Building_Heigtht = objProject.Building_Heigtht__c;
                    blnGrossArea = objProject.Gross_Area__c;
                    blnUseableArea = objProject.Useable_Area__c;
                    blnHousingPlan = objProject.Housing_Plan__c;
                    blndefaultHousingPlan = objProject.Default_Housing_Plan__c;
                    RAEstimateType = objProject.RA_Estimate_Type__c;
                    Total_Area_Including_Parking = objProject.Total_Area_Including_Parking__c;
                    System.debug('Total_Area_Including_Parking__c====='+Total_Area_Including_Parking);
                    Affected_Tenant_Area_USF = objProject.Affected_Tenant_Area_USF__c;
                    Gross_Area_Including_Parking = objProject.Gross_Area_Including_Parking__c;
                    Total_Site_Area_Building_Footprint_SF = objProject.Total_Site_Area_Building_Footprint_SF__c;
                    Percentage_of_Tenant_Area_Unfinished = objProject.Percentage_of_Tenant_Area_Unfinished__c;
                    Start_Construction = objProject.Start_Construction__c;
                    End_Construction = objProject.End_Construction__c;
                    
                    strRemoteness = objProject.Remoteness__c;
                    strBuilding_Quality = objProject.Building_Quality__c;
                    strDominantPeriod = objProject.Dominant_Period__c;
                    strHistoricLandmark  = objProject.Historic_Landmark_Status__c;
                    strOverallCondition  = objProject.Overall_Condition__c;
                    strDefault_Housing_Plan_Entry_Type = objProject.Default_Housing_Plan_Entry_Type__c;
                    RASecurity = objProject.RA_Security__c;
                    strstate = objProject.State__c;
                    strcity = objProject.Location_Name__c;
                    ProjectSet_Aside_100 = objProject.Set_Aside_100__c;
                    ProjectProject_Labor_Agreement = objProject.Project_Labor_Agreement__c;     
                    
                    //dblStandardRate = objProject.Standard_Esc_Rate__c;
                    dtCostParameterDate = objProject.Cost_Parameter_Date__c;
                    dtConstructionEndDate = objProject.End_Construction__c;
                    txtCostParameterDateFY = objProject.Cost_Parameter_Date_FY__c;
                    txtConstructionEndDateFY = objProject.End_Construction_FY__c;  
                    dblGrossSqFt = objProject.Total_GSF__c;  
                    Above_Ground = objProject.Above_Ground__c;   
                    Below_Ground = objProject.Below_Ground__c;                
                    Average_Story_Height = objProject.Average_Story_Height__c;
                    Plumbing_Fixtures = objProject.Plumbing_Fixtures__c;
                    Vertical_Conveyance_Elevators_Stops = objProject.Vertical_Conveyance_Elevators_Stops__c;
                    strSecurityLevel = string.valueOf(objProject.Level_of_Protection__c);
                    dblTotal_ECC = objProject.Total_ECC__c;
                    dblCEW_ECC = objProject.CEW_ECC1__c;
                    dblParking_Within_Building_Structure = objProject.Parking_Within_Building_Structure__c;
                    dblOverride_Calculated_Site_Area = objProject.Override_Calculated_Site_Area__c;
                    UserDefinedHousingPlan_Record_Count = objProject.UserDefinedHousingPlan_Record_Count__c;
                    OtherCosts_RecordCount = objProject.OtherCosts_RecordCount__c;
                    Start_Construction = objProject.Start_Construction__c;
                    strcitytext = objProject.City__c; 
                    Mid_Construction_dt = objProject.Mid_Point_of_Construction__c;
                    strProjectName = objProject.Name;
                    dblParking_Garage_Gross_Area_SF = objProject.Parking_Garage_Gross_Area_SF__c;
                    strBuilding_Height_Parameter = objProject.Building_Height_Parameter__c;
                    dblTotal_Project_Cost = objProject.Total_Project_Cost__c;
                    dblSalestax = objProject.Sales_Tax__c;
                    strProjectRecordID = objProject.Project_Record_ID__c;
                    //dblTotalDirectCost = objProject.Total_Direct_Cost__c;
                    strProjectDeliveryMethod = objProject.Project_Delivery_Method__c; 
                    strMarkupMethod = objProject.Markup_Method__c;
                    dbllocationmultiplier = objProject.Location_Multiplier__c;
                    EstimateType = objProject.Estimate_Type_Proj__c;
                    ProjectArea = objProject.Project_Area_GSF__c;
                    Anticipated_Design_Date = objProject.Anticipated_Date_of_Design_Award__c;
                    
                    proj = objProject;
                    
                }
                
                if (tcoDateChange.size() > 0) NCMT_TCO_Lifecycle_Input_TriggerHandler.futureUpdateByProject(tcoDateChange);
                
                OldValues = Trigger.oldMap.get(ProjectRecordID);
                System.debug('Old Values: ' + OldValues);
                
                if(ProjectRecordType != OldValues.RecordTypeID && ProjRecordTypeName == 'New Construction - TCO'){
                    objTCOinsertflow.insertTCOFlow(ProjectRecordID);
                }
                
                List <NCMT_Location_Parameters__c> locrec = [Select Standard_Escalation__c
                                                             from NCMT_Location_Parameters__c 
                                                             where Name = :strcity 
                                                             and state__c = :strstate 
                                                             and fiscal_year__c= :txtCostParameterDateFY];
                if (locrec.size()>0){                                              
                    dblStandardRate  = locrec[0].Standard_Escalation__c;
                }
                
                
                
                Map<string, String> mapCostSummary = new Map<string, String>();
                Set<Id> existingCats = new Set<Id>();
                for(NCMT_Project_Cost_Summary__c objItem : [Select ID, Cost_Category_Description__c, Cost_Category_ID__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :ProjectRecordID Limit 1000]){
                    mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
                    existingCats.add(objItem.Cost_Category_ID__c);
                }
                
                Boolean newCats = objGenerateDataExt.GenerateCostSummaries(ProjectRecordID,ProjectType,RAEstimateType,RASecurity,RASecurityCost, existingCats); 
                if (newCats){
                    for(NCMT_Project_Cost_Summary__c objItem : [Select ID, Cost_Category_Description__c, Cost_Category_ID__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :ProjectRecordID Limit 1000]){
                        mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
                    }
                }
                //dbllocationmultiplier  = locrec[0].Location_Adjustment_DC__c;
                // Delete and Generate Escalation Data ... removed location since escalation gets generated on housing plan //strcity!= OldValues.Location__c ||
                //if(ProjectRecordTypeName != 'LPOE' && ProjectType != 'New Construction'){ --Commented for Release 6.0
                if(ProjectRecordTypeName != 'LPOE'){
                    if (Mid_Construction_dt != OldValues.Mid_Point_of_Construction__c || dtCostParameterDate != OldValues.Cost_Parameter_Date__c || dtConstructionEndDate != OldValues.End_Construction__c || Start_Construction != OldValues.Start_Construction__c){
                        objGenerateDataExt.DeleteEscalationData(ProjectRecordID);
                        objGenerateDataExt.GenerateEscalationData(ProjectRecordID, dblStandardRate, dtCostParameterDate, dtConstructionEndDate, txtCostParameterDateFY, txtConstructionEndDateFY, Start_Construction, Mid_construction_dt); // Generate Security Data ...   
                    }
                }
                
                if(EstimateType == 'Definitive Estimating'){
                    if(strstate != OldValues.State__c || strcity != OldValues.Location_Name__c || dblSalestax != OldValues.Sales_Tax__c || dbllocationmultiplier!=OldValues.Location_Multiplier__c || strMarkupMethod != OldValues.Markup_Method__c){
                        
                        if(strMarkupMethod =='RSMeans - O&P'){
                            objGenerateDESProjectDetailsExt.UpdateDESTreeStruc(ProjectRecordID,ProjectType,strProjectRecordID,strMarkupMethod);
                        }
                        
                        //for updating DES Items salestax, state
                        objGenerateDESProjectDetailsExt.UpdateDESItemsTax(ProjectRecordID,ProjectType,strProjectRecordID,strProjectDeliveryMethod,dblSalestax,dbllocationmultiplier,strMarkupMethod,strstate);
                        
                    }
                    
                    IF(strProjectDeliveryMethod != OldValues.Project_Delivery_Method__c || strMarkupMethod != OldValues.Markup_Method__c){
                        System.debug('PROJECT DELIVERY METHOD CHANGED! ' +  OldValues.Project_Delivery_Method__c + ' ---> ' + strProjectDeliveryMethod);
                        objGenerateDESProjectDetailsExt.UpdateDESMarkups(ProjectRecordID,ProjectType,strProjectDeliveryMethod,strMarkupMethod);
                        
                    }
                    
                }
                
                IF(EstimateType == 'Cost Estimating Workbook'){
                    if(strstate != OldValues.State__c || strcity != OldValues.Location_Name__c){
                        // Delete and Generate Cost Estimate Adjustment Data ...
                        If (strProjectStatus == 'Draft'){
                            objGenerateDataExt.DeleteEstimateAdjustments(ProjectRecordID);
                            objGenerateDataExt.GenerateEstimateAdjustments(trigger.new);
                        }
                    }
                    if(strstate != OldValues.State__c || strcity != OldValues.Location_Name__c 
                       || ProjectArea != OldValues.Project_Area_GSF__c 
                       || dblCEW_ECC != OldValues.CEW_ECC1__c
                       || strcitytext != OldValues.City__c || strProjectName != OldValues.Name
                       || Mid_Construction_dt != OldValues.Mid_Point_of_Construction__c
                      ){
                          //update professional service estimate with project related data
                          objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordTypeName,'update',0);
                      }
                }
                
                // Generate HousingPlan Data ...
                if (ProjectRecordTypeName == 'Parking Garage') {
                    if (ProjectParking_Structure != OldValues.Parking_Structure__c || ProjectParking_Deck != OldValues.Parking_Deck__c || ProjectBelow_Grade_Structure != OldValues.Below_Grade_Structure__c
                        || ProjectSloped_Parking_Deck != OldValues.Sloped_Parking_Deck__c || ProjectSpeed_Ramp != OldValues.Speed_Ramp__c || ProjectOptimized_for_Parking != OldValues.Optimized_for_Parking__c
                        || ProjectMedium_Efficiency != OldValues.Medium_Efficiency__c || ProjectLow_Efficiency != OldValues.Low_Efficiency__c || ProjectUtilitarian != OldValues.Utilitarian__c
                        || ProjectMedium != OldValues.Medium__c || ProjectHigh != OldValues.High__c || ProjectNumber_of_Spaces != OldValues.Number_of_Spaces__c 
                        || ProjectAt_and_above_grade != OldValues.At_and_above_grade__c || ProjectBelow_grade != OldValues.Below_grade__c || strRemoteness!= OldValues.Remoteness__c 
                        || strstate != OldValues.State__c || strcity != OldValues.Location_Name__c
                        || Anticipated_Design_Date != OldValues.Anticipated_Date_of_Design_Award__c) {
                            
                            //objGenerateData.DeleteHousingPlanData(ProjectRecordID);
                            //delete Housing Plan Summary record
                            objGenerateData.DeleteHousingPlanSummaryData(ProjectRecordID);
                            objGenerateData.GenerateHousingPlanData(ProjectRecordID, blnGrossArea, blnUseableArea, ProjectType, blndefaultHousingPlan);
                            
                            objGenerateData.DeletePLPData(ProjectRecordID);     
                            objGenerateData.GeneratePLPData(ProjectRecordID,ProjectRecordTypeName, ProjectType,ProjRecordTypeName);
                            
                            //Update Project Level Parameter Data with data from Housing Plan
                            objGenerateData.UpdatePLPData(ProjectRecordID);
                            
                            // Delete and Generate Cost Estimate Adjustment Data ...
                            If (strProjectStatus == 'Draft'){
                                objGenerateDataExt.DeleteEstimateAdjustments(ProjectRecordID);
                                objGenerateDataExt.GenerateEstimateAdjustments(trigger.new);
                            }
                            
                            //Generate Site Information Data
                            objGenerateData.DeleteSiteInfoData(ProjectRecordID);
                            objGenerateData.GenerateSiteInfoData(ProjectRecordID,ProjectRecordTypeName,Surface_Parking,Stand_alone_Parking_Garage,blnHousingPlan, 'insert', dblOverride_Calculated_Site_Area);
                            
                            objGenerateData.DeleteCoreShellData(ProjectRecordID);
                            objGenerateDataCoreShellPG.GenerateCoreShellDataPG(ProjectRecordID, ProjectRecordTypeName);
                        }
                    else if (dblOverride_Calculated_Site_Area != OldValues.Override_Calculated_Site_Area__c) {
                        //Generate Site Information Data
                        //objGenerateData.DeleteSiteInfoData(ProjectRecordID);
                        //objGenerateData.GenerateSiteInfoData(ProjectRecordID,ProjectRecordTypeName,Surface_Parking,Stand_alone_Parking_Garage,blnHousingPlan, 'Override', dblOverride_Calculated_Site_Area);
                        
                        objGenerateData.DeleteCoreShellData(ProjectRecordID);
                        objGenerateDataCoreShellPG.GenerateCoreShellDataPG(ProjectRecordID, ProjectRecordTypeName);
                    }
                    
                    // Delete and Generate Cost Estimate Adjustment Data ...
                    if (ProjectSet_Aside_100 != OldValues.Set_Aside_100__c || ProjectProject_Labor_Agreement != Oldvalues.Project_Labor_Agreement__c || StrProjectSpecificAdjustment != Oldvalues.Project_Specific_Adjustment__c){
                        objGenerateDataExt.DeleteEstimateAdjustments(ProjectRecordID);
                        objGenerateDataExt.GenerateEstimateAdjustments(trigger.new);
                    }
                    
                }
                else {
                    if(ProjectRecordTypeName != 'LPOE' && EstimateType !='Definitive Estimating' && EstimateType != 'Cost Estimating Workbook'){
                        if (Building_Cost_Type != OldValues.Building_Cost_Type__c || Building_Heigtht != OldValues.Building_Heigtht__c || blnGrossArea != OldValues.Gross_Area__c
                            || blnUseableArea != OldValues.Useable_Area__c || blnHousingPlan != OldValues.Housing_Plan__c || Total_Area_Including_Parking != OldValues.Total_Area_Including_Parking__c
                            || Percentage_of_Tenant_Area_Unfinished != OldValues.Percentage_of_Tenant_Area_Unfinished__c 
                            || strSecurityLevel != OldValues.Level_of_Protection__c || strRemoteness != OldValues.Remoteness__c
                            || Above_Ground != OldValues.Above_Ground__c || Below_Ground != OldValues.Below_Ground__c
                            || Average_Story_Height != OldValues.Average_Story_Height__c || Plumbing_Fixtures != OldValues.Plumbing_Fixtures__c || strBuilding_Quality != OldValues.Building_Quality__c 
                            || Vertical_Conveyance_Elevators_Stops != OldValues.Vertical_Conveyance_Elevators_Stops__c
                            || dblParking_Within_Building_Structure != OldValues.Parking_Within_Building_Structure__c || strDefault_Housing_Plan_Entry_Type != OldValues.Default_Housing_Plan_Entry_Type__c
                            || Stand_alone_Parking_Garage != OldValues.Stand_alone_Parking_Garage__c || Surface_Parking != OldValues.Surface_Parking__c
                            || strstate != OldValues.State__c || strcity != OldValues.Location_Name__c || strDominantPeriod != OldValues.Dominant_Period__c || strHistoricLandmark != OldValues.Historic_Landmark_Status__c 
                            || strOverallCondition != OldValues.Overall_Condition__c || Gross_Area_Including_Parking != OldValues.Gross_Area_Including_Parking__c || Affected_Tenant_Area_USF != OldValues.Affected_Tenant_Area_USF__c 
                            || blnDefaultHousingPlan != OldValues.Default_Housing_Plan__c || Total_Site_Area_Building_Footprint_SF != OldValues.Total_Site_Area_Building_Footprint_SF__c
                            || Anticipated_Design_Date != OldValues.Anticipated_Date_of_Design_Award__c) {
                                
                                
                                System.debug(blnHousingPlan);
                                if (blnHousingPlan == false) {
                                    
                                    //Generate Site Information Data
                                    if( ProjectType == 'New Construction'){
                                        objGenerateData.DeleteSiteInfoData(ProjectRecordID);
                                        objGenerateData.GenerateSiteInfoData(ProjectRecordID,ProjectRecordTypeName,Surface_Parking,Stand_alone_Parking_Garage,blnHousingPlan, 'insert', dblOverride_Calculated_Site_Area);
                                    }
                                    
                                    //objGenerateData.DeleteHousingPlanData(ProjectRecordID);
                                    //delete Housing Plan Summary record
                                    objGenerateData.DeleteHousingPlanSummaryData(ProjectRecordID);
                                    objGenerateData.GenerateHousingPlanData(ProjectRecordID, blnGrossArea, blnUseableArea, ProjectType, blndefaultHousingPlan);
                                    
                                    objGenerateData.DeletePLPData(ProjectRecordID);     
                                    objGenerateData.GeneratePLPData(ProjectRecordID,ProjectRecordTypeName, ProjectType,ProjRecordTypeName);
                                    //TriggerValue.isInsertPT = True;
                                    //Update Project Level Parameter Data with data from Housing Plan
                                    objGenerateData.UpdatePLPData(ProjectRecordID);
                                    
                                    // Delete and Generate Cost Estimate Adjustment Data ...
                                    If (strProjectStatus == 'Draft'){
                                        objGenerateDataExt.DeleteEstimateAdjustments(ProjectRecordID);
                                        objGenerateDataExt.GenerateEstimateAdjustments(trigger.new);
                                    }
                                    
                                    
                                    
                                    if(ProjectType != 'Repair & Alteration - Work Item Detail'){
                                        
                                        objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY);
                                        
                                        if(Building_Cost_Type == 'Core/Shell with TI'){
                                            if( ProjectType != 'Repair & Alteration - Parametric Entry'){
                                                objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
                                                objGenerateDataExt.GenerateSecurityData(ProjectRecordID, dblGrossSqFt, strSecurityLevel, txtCostParameterDateFY, mapCostSummary);
                                            }
                                            
                                            objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                                            objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY, mapCostSummary);
                                            
                                            objGenerateData.DeleteCoreShellData(ProjectRecordID);
                                            objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary); 
                                            
                                            if (ProjRecordTypeName == 'New Construction - TCO'){
                                                objTCOUpdates.TCOfutureupdate(ProjectRecordID);
                                            }  
                                        }
                                        else if(Building_Cost_Type == 'Core/Shell only'){
                                            
                                            objGenerateDataExt.DeleteSecurityData(ProjectRecordID);
                                            objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                                            
                                            objGenerateData.DeleteCoreShellData(ProjectRecordID);
                                            objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);  
                                        }
                                        else if(Building_Cost_Type == 'TI Only'){
                                            
                                            objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
                                            
                                            objGenerateData.DeleteCoreShellData(ProjectRecordID);
                                            
                                            objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                                            objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY, mapCostSummary);
                                        }
                                        else if(Building_Cost_Type == 'TI Including Warm Lit Shell'){
                                            objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
                                            
                                            objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                                            objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, blnHousingPlan, blndefaultHousingPlan, txtCostParameterDateFY, mapCostSummary);
                                            
                                            objGenerateData.DeleteCoreShellData(ProjectRecordID);
                                            objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);
                                            //TI demolition needs to be run as well
                                        }
                                        else if(Building_Cost_Type == 'TI Retrofit'){
                                            
                                            objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
                                            
                                            objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                                            objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, blnHousingPlan, blndefaultHousingPlan,txtCostParameterDateFY, mapCostSummary);
                                            
                                            objGenerateData.DeleteCoreShellData(ProjectRecordID);
                                            objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY,mapCostSummary);
                                            //TI demolition should be set to 0
                                        }
                                        
                                    }
                                    if (OtherCosts_RecordCount >= 1) {
                                        objGenerateData.UpdateOtherCosts(ProjectRecordID,ProjectRecordTypeName);
                                    }                                  
                                    
                                }
                                
                                //update Common Area section in user defined housing plan if project info changes
                                else {
                                    System.debug(UserDefinedHousingPlan_Record_Count);
                                    if (UserDefinedHousingPlan_Record_Count >= 1){
                                        IF( Building_Cost_Type != OldValues.Building_Cost_Type__c || Building_Heigtht != OldValues.Building_Heigtht__c
                                           || strSecurityLevel != OldValues.Level_of_Protection__c || strRemoteness != OldValues.Remoteness__c || strBuilding_Quality != OldValues.Building_Quality__c 
                                           || dblParking_Within_Building_Structure != OldValues.Parking_Within_Building_Structure__c || Gross_Area_Including_Parking != OldValues.Gross_Area_Including_Parking__c
                                           || Stand_alone_Parking_Garage != OldValues.Stand_alone_Parking_Garage__c || Surface_Parking != OldValues.Surface_Parking__c
                                           || strDominantPeriod != OldValues.Dominant_Period__c || strHistoricLandmark != OldValues.Historic_Landmark_Status__c 
                                           || strOverallCondition != OldValues.Overall_Condition__c || Affected_Tenant_Area_USF != OldValues.Affected_Tenant_Area_USF__c 
                                           || Total_Site_Area_Building_Footprint_SF != OldValues.Total_Site_Area_Building_Footprint_SF__c || Above_Ground != OldValues.Above_Ground__c || Below_Ground != OldValues.Below_Ground__c
                                           || Average_Story_Height != OldValues.Average_Story_Height__c || Plumbing_Fixtures != OldValues.Plumbing_Fixtures__c 
                                           || Vertical_Conveyance_Elevators_Stops != OldValues.Vertical_Conveyance_Elevators_Stops__c
                                           //|| strstate != OldValues.State__c || strcity != OldValues.Location_Name__c
                                          ){
                                              objGenerateData.UpdateHPData(ProjectRecordID,ProjectRecordTypeName);
                                          }else if (ProjRecordTypeName == 'New Construction - TCO' && (strstate != OldValues.State__c || strcity != OldValues.Location_Name__c) && UserDefinedHousingPlan_Record_Count >= 1){                      
                                              //NCMT_TCOUpdates objTCOUpdates = new NCMT_TCOUpdates();
                                              objTCOUpdates.UpdatePerfInput(ProjectRecordID);          
                                          }
                                    }
                                }  
                                
                                // Delete and Generate Security Data ...
                                /* if (strSecurityLevel != OldValues.Level_of_Protection__c && ProjectRecordTypeName != 'Parking Garage' && Building_Cost_Type == 'Core/Shell with TI' && UserDefinedHousingPlan_Record_Count >= 1){
if(ProjectType == 'New Construction'){
objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
objGenerateDataExt.GenerateSecurityData(ProjectRecordID, dblGrossSqFt, strSecurityLevel, txtCostParameterDateFY, mapCostSummary);
}
} */ 
                            }
                        
                        //If Housing Plan record is deleted for custom Housing Plan
                        else if (UserDefinedHousingPlan_Record_Count != OldValues.UserDefinedHousingPlan_Record_Count__c && blnHousingPlan == true) {
                            //system.debug('UserDefinedHousingPlan_Record_Count2==='+ UserDefinedHousingPlan_Record_Count);
                            if (UserDefinedHousingPlan_Record_Count == 0) {
                                //If all Housing Plan records are deleted, then delete Housing Plan Summary record
                                objGenerateData.DeleteHousingPlanSummaryData(ProjectRecordID);
                                
                                //delete security data
                                objGenerateDataExt.DeleteSecurityData(ProjectRecordID);
                                
                                //delete coreshell data
                                objGenerateData.DeleteCoreShellData(ProjectRecordID);
                                
                                //delete TITRCS data
                                objGenerateDataExt.DeleteTIandTRCSData(ProjectRecordID);
                                
                            }
                            else {
                                //If one or more Housing Plan record exists after delete, then delete existing Housing Plan Summary record and create new Housing Plan Summary record
                                list<NCMT_Housing_Plan__c> HPList = [select id from NCMT_Housing_Plan__c where Project__c = :ProjectRecordID ];
                                
                                NCMT_UpdateHousingPlanSummary objinsertHPSummaryData = new NCMT_UpdateHousingPlanSummary();
                                objinsertHPSummaryData.insertHousingPlanSummary(HPList, ProjectRecordID, ProjectRecordTypeName);
                            }
                        }
                        
                        else if (dblOverride_Calculated_Site_Area != OldValues.Override_Calculated_Site_Area__c) {
                            system.debug('inside overide site area==='+dblOverride_Calculated_Site_Area);
                            /*Generate Site Information Data
if( ProjectType == 'New Construction'){
objGenerateData.DeleteSiteInfoData(ProjectRecordID);
objGenerateData.GenerateSiteInfoData(ProjectRecordID,ProjectRecordTypeName,Surface_Parking,Stand_alone_Parking_Garage,blnHousingPlan, 'Override', dblOverride_Calculated_Site_Area);
}*/
                            if(Building_Cost_Type == 'Core/Shell with TI' && ProjectType != 'Repair & Alteration - Work Item Detail'){
                                if( ProjectType != 'Repair & Alteration - Parametric Entry'){
                                    objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
                                    objGenerateDataExt.GenerateSecurityData(ProjectRecordID, dblGrossSqFt, strSecurityLevel, txtCostParameterDateFY, mapCostSummary);
                                }
                            }
                            
                            if(ProjectType != 'Repair & Alteration - Work Item Detail'){
                                objGenerateData.DeleteCoreShellData(ProjectRecordID);
                                objGenerateData.GenerateCoreShellData(ProjectRecordID, ProjectType, txtCostParameterDateFY, mapCostSummary);
                                
                                
                                if (ProjRecordTypeName == 'New Construction - TCO'){
                                    objTCOinsertflow.GenerateTCOCoreShellData(ProjectRecordID);
                                    objTCOinsertflow.UpdateTCOCoreShellData(ProjectRecordID);
                                }  
                            }
                            
                        }   
                        
                        // Delete and Generate Cost Estimate Adjustment Data ...
                        if (ProjectSet_Aside_100 != OldValues.Set_Aside_100__c || ProjectProject_Labor_Agreement != Oldvalues.Project_Labor_Agreement__c || StrProjectSpecificAdjustment != Oldvalues.Project_Specific_Adjustment__c 
                            || strstate != OldValues.State__c || strcity != OldValues.Location_Name__c){
                                if (UserDefinedHousingPlan_Record_Count >= 1 || blnHousingPlan == false) {
                                    objGenerateDataExt.DeleteEstimateAdjustments(ProjectRecordID);
                                    objGenerateDataExt.GenerateEstimateAdjustments(trigger.new);
                                }
                            }   
                        
                    } 
                }   
                
                if (ProjectType == 'New Construction') {
                    if (ProjectRecordTypeName != 'Utility' ) {
                        if (strstate != OldValues.State__c || strcity != OldValues.Location_Name__c 
                            || dblParking_Garage_Gross_Area_SF != OldValues.Parking_Garage_Gross_Area_SF__c 
                            || dblTotal_ECC != OldValues.Total_ECC__c
                            || strcitytext != OldValues.City__c || strProjectName != OldValues.Name
                            || Start_Construction != OldValues.Start_Construction__c
                            //|| ProjectRecordType != OldValues.RecordTypeID 
                            || Total_Area_Including_Parking != OldValues.Total_Area_Including_Parking__c
                            || strRemoteness != OldValues.Remoteness__c 
                            || strBuilding_Quality != OldValues.Building_Quality__c 
                            || strCommercial_Port_Size != OldValues.Commercial_Port_Size__c || strPOV_Port_Size != OldValues.POV_Port_Size__c
                            || Anticipated_Design_Date != OldValues.Anticipated_Date_of_Design_Award__c) {
                                
                                if(ProjectRecordTypeName == 'LPOE'){
                                    //Delete and Generate LPOE Space Plan
                                    objGenerateData.DeleteLPOESpacePlanData(ProjectRecordID);
                                    objGenerateData.GenerateLPOESpacePlanData(ProjectRecordID,ProjectRecordTypeName, ProjectType);
                                    
                                    // Delete and Generate Cost Estimate Adjustment Data ...
                                    If (strProjectStatus == 'Draft'){
                                        objGenerateDataExt.DeleteEstimateAdjustments(ProjectRecordID);
                                        objGenerateDataExt.GenerateEstimateAdjustments(trigger.new);
                                    }
                                }
                                
                                // Update Professional Service Estimate Data with only Project related data
                                if (ProjectRecordTypeName == 'Parking Garage') {
                                    objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordTypeName,'update',0);
                                }
                                else if (ProjectRecordTypeName != 'Parking Garage' && blnHousingPlan == false) {
                                    system.debug('inside else anticipated design ===');
                                    objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordTypeName,'update',0);
                                }
                            }
                    }        
                } 
                else if (ProjectType == 'Repair & Alteration - Parametric Entry' || ProjectType == 'Repair & Alteration - Work Item Detail') {
                    if (ProjectRecordTypeName != 'Utility' && ProjectRecordTypeName != 'Childcare Center' && ProjectRecordTypeName != 'Parking Garage' && ProjectRecordTypeName != 'LPOE') {
                        if (strstate != OldValues.State__c || strcity != OldValues.Location_Name__c 
                            || dblParking_Garage_Gross_Area_SF != OldValues.Parking_Garage_Gross_Area_SF__c 
                            || dblTotal_ECC != OldValues.Total_ECC__c
                            || strcitytext != OldValues.City__c || strProjectName != OldValues.Name
                            || Start_Construction != OldValues.Start_Construction__c
                            //|| ProjectRecordType != OldValues.RecordTypeID 
                            || Total_Area_Including_Parking != OldValues.Total_Area_Including_Parking__c) {
                                
                                // Update Professional Service Estimate Data with only Project related data
                                objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordTypeName,'update',0);
                            }
                    }
                }
                
                if(ProjectType == 'Repair & Alteration - Parametric Entry'){
                    if(RASecurity != OldValues.RA_Security__c){
                        
                        list<NCMT_Project_Cost_Summary__c> ProjCostSummarylist = [Select id, RA_Security__c from NCMT_Project_Cost_Summary__c where Project_Name__c = :ProjectRecordID];
                        update ProjCostSummarylist;
                    }
                }
            }   
        }       
    }  
    
}