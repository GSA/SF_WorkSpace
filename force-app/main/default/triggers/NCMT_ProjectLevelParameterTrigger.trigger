trigger NCMT_ProjectLevelParameterTrigger on Project_Level_Parameter__c (before insert,before update,after update) {
    
    System.debug('RUN PLP TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
    set<String> ncmtIdSet = new set<String>();                                           
    Map<String,String> ncmtMap = new Map<String,String>();                                
    Map<String,NCMT_Project__c> ncmtMapValues = new Map<String,NCMT_Project__c>();       
    Map<String,String> ncmtMap1 = new Map<String,String>();                              
    Map<String,Decimal> sysLvlMap = new Map<String,Decimal>();                           
    set<String> categorySet = new set<String>();                                         
    set<String> prRfTypeSet = new set<String>();
    Map<String,NCMT_Building_Height_Parameter__c> bpMap = new Map<String,NCMT_Building_Height_Parameter__c>();
    Map<String,String> bpIdMap = new Map<String,String>();    
    //Map<String,NCMT_Building_Parameter__c> bptMap = new Map<String,NCMT_Building_Parameter__c>();             
    //Map<String,String> bptIdMap = new Map<String,String>(); 
    Map<String,NCMT_Housing_Plan_Summary__c> hpMap = new Map<String,NCMT_Housing_Plan_Summary__c>();                          
    Map<String,Decimal> multiCategoryMap = new Map<String,Decimal>();
    set<String> plpIdSet = new set<String>(); 
    map<string,NCMT_RA_Quality_Code_Lookup__c> QualityCodeLookupMap = new map<string,NCMT_RA_Quality_Code_Lookup__c>();
    set<String> DominantPeriodSet = new set<String>();
    set<String> HistoricLandmarkSet = new set<String>();
    String strProjectType;
    ID     ProjectRecordID;
    Project_Level_Parameter__c OldValues;
    NCMT_TCOFLOWController objTCOProjData = new NCMT_TCOFLOWController();
    
    if(trigger.isinsert) {
    //system.debug('trigger.isinsert=='+trigger.isinsert);
    TriggerValue.isinsert=true;
    }
    
    for(Project_Level_Parameter__c iter :trigger.new){
            ncmtIdSet.add(iter.NCMT_Project__c);
    }        

        List <NCMT_Project__c> ncmtrec = [select ID, Location_Name__c, Estimate_Type_Proj__c,State__c,Project_Labor_Agreement__c, Set_Aside_100__c, Project_Seismic_Design_Category__c, Building_Quality__c,
                                                 RecordTypeID, Project_Status__c, Surface_Parking__c, Stand_alone_Parking_Garage__c, Housing_Plan__c, Override_Calculated_Site_Area__c, Building_Cost_Type__c,
                                                 Level_of_Protection__c, Cost_Parameter_Date_FY__c,Total_GSF__c, building_type__c, project_type__c, Gross_Area_Including_Parking__c , 
                                                 Historic_Landmark_Status__c, Dominant_Period__c,Location_Adjustment_DC__c, PLA__c, SB_HUB__c,Building_Height_Parameter__c,Building_Parameter__c,
                                                  RecordType.Name,Remoteness__c,Parking_Garage_Gross_Area_SF__c, At_and_above_grade__c,Building_Height_Parameter__r.No_of_Floors__c,Building_Height_Parameter__r.Bast_Ratio__c,
                                                  Below_grade__c, Above_Ground__c, Below_Ground__c, Average_Story_Height__c, Plumbing_Fixtures__c, Vertical_Conveyance_Elevators_Stops__c, 
                                                  Total_Site_Area_Building_Footprint_SF__c,Overall_Condition__c,Number_of_Stops__c
                                            FROM NCMT_Project__c WHERE Id IN :ncmtIdSet] ;
    
        List <NCMT_Housing_Plan_Summary__c> lstHP = [SELECT Project__c, Mechanical_Electrical_IT__c, Atrium_Ground_floor_plan_area__c,Atrium_upper_levels_phantom_floors__c, Total_GSF__c,
                                                         Main_Lobby__c, Ground_floor_circulation__c,Loading_dock_Recycling_Trash__c                               
                                                       FROM NCMT_Housing_Plan_Summary__c 
                                                      where Project__c IN :ncmtIdSet];


    if((trigger.isInsert && trigger.isBefore) || (trigger.isUpdate && trigger.IsBefore)) {
            
        for(Project_Level_Parameter__c iter :trigger.new){
                       
               /* if(iter.NCMT_Project__c!= null)
                {
                    ncmtIdSet.add(iter.NCMT_Project__c);
                }*/
                categorySet.add(iter.Use_Level_of_Protection__c);
                prRfTypeSet.add(iter.Primary_Roof_Type__c);
        } 

        /*List <NCMT_Project__c> Projlst1 = [SELECT Id,Building_Height_Parameter__c,Building_Parameter__c,RecordType.Name,Level_of_Protection__c,Remoteness__c,Parking_Garage_Gross_Area_SF__c,Total_GSF__c, At_and_above_grade__c, 
                                                  Below_grade__c, Above_Ground__c, Below_Ground__c, Average_Story_Height__c, Plumbing_Fixtures__c, Vertical_Conveyance_Elevators_Stops__c, Total_Site_Area_Building_Footprint_SF__c, Gross_Area_Including_Parking__c,
                                                  project_type__c , Number_of_Stops__c,Historic_Landmark_Status__c, Dominant_Period__c, Overall_Condition__c
                                             FROM NCMT_Project__c 
                                            WHERE Id IN :ncmtIdSet];*/
        
        for (NCMT_Project__c iter: ncmtrec) {  
            ncmtMap.put(iter.Id,iter.Level_of_Protection__c);
            ncmtMapValues.put(iter.Id,iter);
            strProjectType = string.valueof(iter.project_type__c);
            if(iter.Remoteness__c != null){
                ncmtMap1.put(iter.Id,iter.Remoteness__c); 
            }
            bpIdMap.put(iter.Id,iter.Building_Height_Parameter__c);
            //bptIdMap.put(iter.Id,iter.Building_Parameter__c);
            DominantPeriodSet.add(iter.Dominant_Period__c);
            HistoricLandmarkSet.add(iter.Historic_Landmark_Status__c);
            
        }               

        /*for(NCMT_Building_Height_Parameter__c iter :[SELECT Id,No_of_Floors__c, Bast_Ratio__c FROM NCMT_Building_Height_Parameter__c WHERE Id IN:bpIdMap.Values()]){
            bpMap.put(iter.Id,iter);
        }*/
        
        /*for(NCMT_Building_Parameter__c iter :[SELECT Id FROM NCMT_Building_Parameter__c WHERE Id IN:bptIdMap.Values()]){
            bptMap.put(iter.Id,iter);
        }*/
        
        if(strProjectType == 'Repair & Alteration - Parametric Entry' || strProjectType == 'Repair & Alteration - Work Item Detail'){
            for(NCMT_RA_Quality_Code_Lookup__c RAQCL : [SELECT ID,Historic_Landmark_Status__c, Dominant_Period__c, Dominant_structural_system__c, Seismic__c, Quality_Code_Parameter__r.Cladding_Quality__c, Quality_Code_Parameter__r.Cladding_List__c,
                                                               Dominant_Glazing_System1__c, Dominant_Glazing_System2__c, Dominant_Glazing_System3__c , Dominant_Roofing_Form__c, Dominant_Roofing_Material__c, Character__c, Elevator_Type__c,Primary_System__c,
                                                               Distribution_System__c,Special_System__c, User_Power__c,Lighting__c,Telecom_IT__c,Wet_Pipe__c, Quality_Code_Parameter__r.Name
                                                         FROM  NCMT_RA_Quality_Code_Lookup__c 
                                                         WHERE Dominant_Period__c IN :DominantPeriodSet
                                                          AND  Historic_Landmark_Status__c IN :HistoricLandmarkSet])
            {
                  string keyValue = RAQCL.Dominant_Period__c+RAQCL.Historic_Landmark_Status__c;
                  QualityCodeLookupMap.put(keyValue,RAQCL);                                         
                                                            
            }
            
        } 
        
       /* List <NCMT_Housing_Plan_Summary__c> lstHP = [SELECT Project__c, Mechanical_Electrical_IT__c, Atrium_Ground_floor_plan_area__c,Atrium_upper_levels_phantom_floors__c, Total_GSF__c,
                                                            Main_Lobby__c, Ground_floor_circulation__c,Loading_dock_Recycling_Trash__c                              
                                                       FROM NCMT_Housing_Plan_Summary__c 
                                                      where Project__c IN :ncmtIdSet];*/
        for (NCMT_Housing_Plan_Summary__c iter: lstHP) {
            hpMap.put(iter.Project__c,iter);
        }                                               

        //from system level parameters
        categorySet.addAll(ncmtmap.Values());
        categorySet.addAll(ncmtmap1.Values()); 
        
        List <System_Level_Parameter__c> SLPlstCS = [SELECT Id,Name,Category__c,Value__c FROM System_Level_Parameter__c 
                                                      where Category__c IN :categorySet] ;
        
        for (System_Level_Parameter__c iter: SLPlstCS) {      
            //system.debug('iter1=='+iter.name);    
            sysLvlMap.put(iter.Category__c,iter.Value__c);
            sysLvlMap.put(iter.Name,iter.Value__c);
        }
        system.debug('SLPlstCS=='+SLPlstCS);

        List <System_Level_Parameter__c> SLPlstTS = [SELECT Id,Name,Category__c,Value__c FROM System_Level_Parameter__c 
                                                      where Category__c IN :prRfTypeSet];
                                                    
        for (System_Level_Parameter__c iter: SLPlstTS) {    
            multiCategoryMap.put(iter.Name,iter.Value__c);          
        }                                             
        
        for(Project_Level_Parameter__c iter :trigger.new){
            if(iter.NCMT_Project__c != null)
            {
                if(sysLvlMap.containsKey(ncmtMap.get(iter.NCMT_Project__c))) // for assigning change setback 100percent from ncmtproject.Level of protection
                {
                    
                    if(trigger.isinsert){
                       iter.Change_Setback_100__c = sysLvlMap.get(ncmtMap.get(iter.NCMT_Project__c));
                       iter.Default_Setback_100_FT__c = iter.Change_Setback_100__c;
                       iter.Adj_LOP_Setback__c = iter.Change_Setback_100__c;
                       iter.Use_Level_of_Protection__c = iter.Level_of_Protection__c;
                       iter.Use_Blast_Resistance__c = iter.Level_of_Protection__c;
                    }
                }
                if(sysLvlMap.containsKey(ncmtMap1.get(iter.NCMT_Project__c))){
                     
                     //system.debug('ncmtMap1.get(iter.NCMT_Project__c==='+ncmtMap1.get(iter.NCMT_Project__c));
                     iter.SiteRemoteness_Cost_Impact__c = sysLvlMap.get('Site Remoteness Cost Impact'+'  '+ncmtMap1.get(iter.NCMT_Project__c));
                     iter.excavation_percentage_shored_BG__c = sysLvlMap.get('Excavation: Percentage Shored-'+ncmtMap1.get(iter.NCMT_Project__c));
                     if(trigger.isinsert){
                       iter.Excavation_Percent_Shored_BG__c = iter.excavation_percentage_shored_BG__c;
                      //system.debug('excavation percentage shored BG ='+iter.excavation_percentage_shored_BG__c);
                     }
                }
            }
            
            // For assigning ADJ LOP SetBack from Use Level of Protection
            if(iter.Use_Level_of_Protection__c != null) {
                
                iter.Default_Adj_LOP_Setback_FT__c = sysLvlMap.get(iter.Use_Level_of_Protection__c);
               if(trigger.isinsert || (trigger.isupdate && trigger.oldmap.get(iter.id).Use_Level_of_Protection__c != iter.Use_Level_of_Protection__c )){ 
               iter.Adj_LOP_Setback__c = iter.Default_Adj_LOP_Setback_FT__c;   
               }
            }
            
            // For assigning Sloped roof Bg, Green roof Bg and flat roof Bg from Primary roof type
            if(iter.Primary_Roof_Type__c != null)
            {
                //system.debug('Primary Roof Type='+iter.Primary_Roof_Type__c);
                                
                for(String key :multiCategoryMap.KeySet()){                    
                    if(key.contains('Ft')){
                        iter.Default_Flat_Roof_BG__c = multiCategoryMap.get(key);
                        iter.Flat_Roof_BG__c = iter.Default_Flat_Roof_BG__c;
                    }
                    if(key.contains('Gn')){
                        iter.Default_Green_Roof_BG__c = multiCategoryMap.get(key);
                        if(trigger.isinsert || (trigger.isupdate && trigger.oldmap.get(iter.id).Primary_Roof_Type__c != iter.Primary_Roof_Type__c )){
                            iter.Green_Roof_BG__c = iter.Default_Green_Roof_BG__c;
                        //system.debug('oldval=='+trigger.oldmap.get(iter.id).Primary_Roof_Type__c);
                        //system.debug('iter.Green_Roof_BG__=='+iter.Primary_Roof_Type__c);
                        }
                    }
                    if(key.contains('Sd')){
                        iter.Default_Sloped_Roof_BG__c = multiCategoryMap.get(key);
                        if(trigger.isinsert || (trigger.isupdate && trigger.oldmap.get(iter.id).Primary_Roof_Type__c != iter.Primary_Roof_Type__c )){
                            iter.Sloped_Roof_BG__c = iter.Default_Sloped_Roof_BG__c;
                        }
                    }
                }
            }
        }
        NCMT_PLPFormulaCalculations.FormulaCalculation(trigger.new,ncmtMapValues,bpMap,bpIdMap,hpmap,QualityCodeLookupMap);
    }
    
    if(((trigger.isUpdate && trigger.isAfter) || (trigger.isInsert && trigger.isAfter)) && triggervalue.isTCOPLPUpdate == false){
        
        
        for(Project_Level_Parameter__c iter :trigger.new){
            plpIdSet.add(iter.Id);
            
           /* if(iter.NCMT_Project__c!= null)
            {
                ncmtIdSet.add(iter.NCMT_Project__c);
            }*/
        } 
        
        /*List <NCMT_Project__c> Projlst2 = [SELECT Id,RecordType.Name,Parking_Garage_Gross_Area_SF__c,Total_GSF__c, At_and_above_grade__c, Below_grade__c, building_type__c,
                                                  project_type__c, Number_of_Stops__c,Gross_Area_Including_Parking__c, Historic_Landmark_Status__c, Dominant_Period__c, Cost_Parameter_Date_FY__c
                                            FROM  NCMT_Project__c 
                                            WHERE Id IN :ncmtIdSet];*/
        
        for (NCMT_Project__c iter1: ncmtrec) {
            ncmtMapValues.put(iter1.Id,iter1);
        }         

        /*List <NCMT_Housing_Plan_Summary__c> lstHP2 = [SELECT Project__c, Mechanical_Electrical_IT__c,Atrium_Ground_floor_plan_area__c,Atrium_upper_levels_phantom_floors__c                         
                                                        FROM NCMT_Housing_Plan_Summary__c where Project__c IN :ncmtIdSet];*/
        for (NCMT_Housing_Plan_Summary__c iter2: lstHP) {
            hpMap.put(iter2.Project__c,iter2);
        }   
        
                // for deleting exisitng building masssing by floor records  
                if(TriggerValue.isupdate1 )   {         
                NCMT_PLPFormulaCalculations.DeleteBuildingMassingByFloorRecords(plpIdSet);
                
                //for inserting new records in building massing by floor
                NCMT_PLPFormulaCalculations.CreateBulidingMassingByFloorrecords(trigger.new,ncmtMapValues,hpmap);
                }
            
            
    }
        
    if(trigger.isUpdate && trigger.isBefore && TriggerValue.isupdate){
        
        for(Project_Level_Parameter__c iter :trigger.new){

            // validation for override comments
            /*if(String.isblank(iter.Roofing_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Sloped_Roof_BG__c != iter.Sloped_Roof_BG__c ) {            
                iter.addError('Control Ratios Roofing Override Comments Required');
            } else if(String.isblank(iter.Roofing_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Green_Roof_BG__c != iter.Green_Roof_BG__c ){
                iter.addError('Control Ratios Roofing Override Comments Required');
            } else if(String.isblank(iter.Roofing_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Roofing_Skylights__c != iter.Roofing_Skylights__c ){
                iter.addError('Control Ratios Roofing Override Comments Required');
            }*/
            if(String.isblank(iter.Structure_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Typical_Bay_Size_A__c != iter.Typical_Bay_Size_A__c ) {            
                iter.addError('Control Ratios Structure Override Comments Required');
            } else if(String.isblank(iter.Structure_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Typical_Bay_Size_B__c != iter.Typical_Bay_Size_B__c ){
                iter.addError('Control Ratios Structure Override Comments Required');
            } else if(String.isblank(iter.Structure_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Dead_Load__c != iter.Dead_Load__c ){
                iter.addError('Control Ratios Structure Override Comments Required');
            } else if(String.isblank(iter.Structure_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Live_Load__c != iter.Live_Load__c ){
                iter.addError('Control Ratios Structure Override Comments Required');
            }
            if(String.isblank(iter.Interior_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Int_Const_Core_Shell_Partition_ratio__c != iter.Int_Const_Core_Shell_Partition_ratio__c ) {         
                iter.addError('Control Ratios Interior Override Comments Required');
            }
            if(String.isblank(iter.MEP_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Electrical_Load__c != iter.Electrical_Load__c ) {            
                iter.addError('Control Ratios MEP Override Comments Required');
            }
            if(String.isblank(iter.Vertical_Transportation_Override_Comment__c)== true && trigger.oldmap.get(iter.id).Vertical_Conveyance_Escalators_Pairs__c != iter.Vertical_Conveyance_Escalators_Pairs__c ){
                iter.addError('Control Ratios Vertical Transportation Override Comments Required');
            } else if(String.isblank(iter.Vertical_Transportation_Override_Comment__c)== true && trigger.oldmap.get(iter.id).Additional_Primary_Circulation_Stair__c != iter.Additional_Primary_Circulation_Stair__c ){
                iter.addError('Control Ratios Vertical Transportation Override Comments Required');
            }
            if(String.isblank(iter.Cladding_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Cladding_Skin_Ratio__c != iter.Cladding_Skin_Ratio__c ) {           
                iter.addError('Control Ratios Cladding Override Comments Required');
            } else if(String.isblank(iter.Cladding_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Cladding_Retaining_Wall__c != iter.Cladding_Retaining_Wall__c ){
                iter.addError('Control Ratios Cladding Override Comments Required');
            } else if(String.isblank(iter.Cladding_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Glazing_Ratio_of_above_grade_skin__c != iter.Glazing_Ratio_of_above_grade_skin__c ){
                iter.addError('Control Ratios Cladding Override Comments Required');
            } else if(String.isblank(iter.Cladding_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Curtain_Wall_Percentage_Total_Window__c != iter.Curtain_Wall_Percentage_Total_Window__c ){
                iter.addError('Control Ratios Cladding Override Comments Required');
            }
            if(String.isblank(iter.Massing_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Foot_Print_Area__c != iter.Foot_Print_Area__c ) {            
                iter.addError('Control Ratios Massing Override Comments Required');
            } else if(String.isblank(iter.Massing_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Basement_SF__c != iter.Basement_SF__c ){
                iter.addError('Control Ratios Massing Override Comments Required');
            } else if(String.isblank(iter.Massing_Override_Comments__c)== true && trigger.oldmap.get(iter.id).Atrium_Phantom_Floors__c != iter.Atrium_Phantom_Floors__c ){
                iter.addError('Control Ratios Massing Override Comments Required');
            }
        }
    }
    //system.debug('TriggerValue.isupdate==PLP'+TriggerValue.isupdate);
    if(trigger.isUpdate && trigger.isAfter && TriggerValue.isupdate){
        
        ID PlpRecordID;
        string  ProjectRecordType,strProjRecordType;
        string  ProjectRecordTypeName;
        Decimal Surface_Parking;
        Decimal Stand_alone_Parking_Garage;
        Boolean blnHousingPlan;
        Decimal dblGrossSqFt,dblParaSiteAdj=0.0;
        Decimal dblOverride_Calculated_Site_Area;
        string  strProjectStatus;
        string strSecurityLevel;
        String  Building_Cost_Type;
        string  txtCostParameterDateFY;
        //Map<ID,Schema.RecordTypeInfo> rt_Map = NCMT_Project__c.sObjectType.getDescribe().getRecordTypeInfosById();
        //string  RecordTypeParkingGarage = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId();
        
        for(Project_Level_Parameter__c iter :trigger.new){
            PlpRecordID = iter.ID;
            ProjectRecordID = iter.NCMT_Project__c;
            strProjRecordType = iter.RecordType__c;
        }      
        OldValues = Trigger.oldMap.get(PlpRecordID);

        /*List <NCMT_Project__c> ncmtrec = [select ID, Location_Name__c, Estimate_Type_Proj__c,State__c,Project_Labor_Agreement__c, Set_Aside_100__c, Project_Seismic_Design_Category__c, Building_Quality__c,
                                                 RecordTypeID, Project_Status__c, Surface_Parking__c, Stand_alone_Parking_Garage__c, Housing_Plan__c, Override_Calculated_Site_Area__c, Building_Cost_Type__c,
                                                 Level_of_Protection__c, Cost_Parameter_Date_FY__c, Number_of_Stops__c,Total_GSF__c, building_type__c, project_type__c, Gross_Area_Including_Parking__c , 
                                                 Historic_Landmark_Status__c, Dominant_Period__c,Location_Adjustment_DC__c, PLA__c, SB_HUB__c
                                            FROM NCMT_Project__c WHERE Id = :ProjectRecordID] ;*/         
        
            ProjectRecordTypeName = ncmtrec[0].building_type__c;
            ProjectRecordType = ncmtrec[0].RecordType.Name;
            Surface_Parking = ncmtrec[0].Surface_Parking__c;
            Building_Cost_Type = ncmtrec[0].Building_Cost_Type__c;
            Stand_alone_Parking_Garage = ncmtrec[0].Stand_alone_Parking_Garage__c;
            blnHousingPlan = ncmtrec[0].Housing_Plan__c;
            txtCostParameterDateFY = ncmtrec[0].Cost_Parameter_Date_FY__c;
            strSecurityLevel = string.valueof(ncmtrec[0].Level_of_Protection__c);
            strProjectType = ncmtrec[0].project_type__c;
            if((ncmtrec[0].project_type__c == 'New Construction' && ncmtrec[0].building_type__c != 'Parking Garage') || (ncmtrec[0].project_type__c == 'Repair & Alteration - Work Item Detail')){
                dblGrossSqFt = ncmtrec[0].Total_GSF__c;
            }else{
                dblGrossSqFt = ncmtrec[0].Gross_Area_Including_Parking__c;
            }
            dblOverride_Calculated_Site_Area = ncmtrec[0].Override_Calculated_Site_Area__c;
            strProjectStatus = string.valueof(ncmtrec[0].Project_Status__c) ;
        
        List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :ProjectRecordID Limit 1000];
            Map<string, String> mapCostSummary = new Map<string, String>();
            for(NCMT_Project_Cost_Summary__c objItem : listCostSummary)
                mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
        
        NCMT_GenerateProjectDetails objGenerateData = new NCMT_GenerateProjectDetails();
        //NCMT_GenerateProjectDetailsCoreShellPG objGenerateDataCoreShellPG = new NCMT_GenerateProjectDetailsCoreShellPG();
        NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt();
        
        // Delete and Generate Cost Estimate Adjustment Data ...
            If (strProjectStatus == 'Draft'){
                 objGenerateDataExt.DeleteEstimateAdjustments(ProjectRecordID);
                 objGenerateDataExt.GenerateEstimateAdjustments(ncmtrec);
            }
        //Generate Site Information Data
        if(strProjectType =='New Construction'){
            objGenerateData.DeleteSiteInfoData(ProjectRecordID);
            objGenerateData.GenerateSiteInfoData(ProjectRecordID,ProjectRecordTypeName,Surface_Parking,Stand_alone_Parking_Garage,blnHousingPlan, 'insert', dblOverride_Calculated_Site_Area);
        }
        // Delete and Generate Core Shell Cost ...
            
            if (ProjectRecordTypeName != 'Parking Garage' && strProjectType != 'Repair & Alteration - Work Item Detail'){
                if(Building_Cost_Type == 'Core/Shell with TI'){
                    if(strProjectType != 'Repair & Alteration - Parametric Entry'){
                        objGenerateDataExt.DeleteSecurityData(ProjectRecordID); 
                        objGenerateDataExt.GenerateSecurityData(ProjectRecordID, dblGrossSqFt, strSecurityLevel, txtCostParameterDateFY, mapCostSummary);
                    }
                    
                    objGenerateData.DeleteCoreShellData(ProjectRecordID);            
                    objGenerateData.GenerateCoreShellData(ProjectRecordID, strProjectType, txtCostParameterDateFY, mapCostSummary);
                    
                    if(ProjectRecordType =='New Construction - TCO' || strProjRecordType =='New Construction - TCO'){
                                         
                     objTCOProjData.GenerateTCOCoreShellData(ProjectRecordID);
                     //objTCOProjData.UpdateTCOCoreShellData(ProjectRecordID);
                    }
                }
                
                if(Building_Cost_Type == 'Core/Shell only' || Building_Cost_Type == 'TI Including Warm Lit Shell' || Building_Cost_Type == 'TI Retrofit'){
                                
                    objGenerateData.GenerateCoreShellData(ProjectRecordID, strProjectType, txtCostParameterDateFY, mapCostSummary);  
                }
            }
    }
    }
}