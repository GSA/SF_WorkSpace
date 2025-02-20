// Added with sharing - Shamal -  SFWS-1695 
public with sharing class  NCMT_PLPFormulaCalculations {
    
    public static void formulaCalculation(List<project_level_parameter__c> plpList, Map<String,NCMT_Project__c> ncmtMapValues,Map<String,NCMT_Building_Height_Parameter__c> bpMap,Map<String,String> bpIdMap,Map<String,NCMT_Housing_Plan_Summary__c> hpmap,map<string,NCMT_RA_Quality_Code_Lookup__c> QualityCodeLookupMap){     
        Decimal Total_GSF = 0;
        for(project_level_parameter__c key :plpList){
            NCMT_project__c ncmtRec = new NCMT_Project__c();
            ncmtRec = ncmtMapValues.get(key.NCMT_Project__c);
            
            // getting building height parameters from ncmt project
            //NCMT_Building_Height_Parameter__c bpRec = new NCMT_Building_Height_Parameter__c();
            //bpRec = bpMap.get(bpIdMap.get(key.NCMT_Project__c));
            
            // getting building parameters from ncmt project
            /*NCMT_Building_Parameter__c bptRec = new NCMT_Building_Parameter__c();
            bptRec = bptMap.get(bptIdMap.get(key.NCMT_Project__c));*/
            
            //getting RA Quality Code Lookups
            
            NCMT_RA_Quality_Code_Lookup__c RAQCLRec = new NCMT_RA_Quality_Code_Lookup__c();
            if(ncmtrec.Project_Type__c == 'Repair & Alteration - Parametric Entry' || ncmtrec.Project_Type__c == 'Repair & Alteration - Work Item Detail'){
                string keyValue = ncmtrec.Dominant_Period__c+ncmtrec.Historic_Landmark_Status__c;
                RAQCLRec = QualityCodeLookupMap.get(keyValue);
            }
            
            // getting housing plan from ncmt project
            NCMT_Housing_Plan_Summary__c hpRec = new NCMT_Housing_Plan_Summary__c();
            hpRec = hpMap.get(key.NCMT_Project__c);
            
            if(ncmtrec.project_type__c == 'New Construction' || ncmtrec.project_type__c == 'Repair & Alteration - Work Item Detail'){
                    total_gsf = ncmtRec.Total_GSF__c;
            }else{
                    total_gsf = ncmtRec.Gross_Area_Including_Parking__c;
            }           
            
            //For parking garage record type in ncmt project
                            
            if(ncmtRec.RecordType.Name == 'Parking Garage'){
                
                Integer ncmtPG1 = Math.Round(ncmtRec.Parking_Garage_Gross_Area_SF__c /( ncmtRec.At_and_above_grade__c + ncmtRec.Below_grade__c )); 
                Integer totalfloors = Math.Round(ncmtRec.At_and_above_grade__c + ncmtRec.Below_grade__c );  
                
                // for calculating default foot print area sf
                   key.Default_Foot_Print_Area__c = ncmtPG1;
                   key.Foot_Print_Area__c = key.Default_Foot_Print_Area__c;
                   system.debug(key.Foot_Print_Area__c+'foot print area');  
                // for calculating default basement sf
                    if(ncmtRec.At_and_above_grade__c == 0) {
                        key.default_basement_sf__c =Math.Round( ncmtRec.Below_grade__c * ncmtPG1);
                    }
                    else{
                        key.default_basement_sf__c = Math.Round(key.Foot_Print_Area__c * ncmtRec.Below_grade__c);
                    }
                    key.basement_sf__c = key.default_basement_sf__c;
                    system.debug(key.Basement_SF__c+'basementSF');
                // for calculating elevated floor area af
                    key.Default_Elevated_Floor_Area_SF__c = Math.Max(Math.Round(ncmtRec.Parking_Garage_Gross_Area_SF__c -(key.Default_Foot_Print_Area__c + key.default_basement_sf__c)),0);
                    if(ncmtRec.At_and_above_grade__c == 1){
                        key.Elevated_Floor_Area_SF__c =  0;
                    }
                    else {
                        key.Elevated_Floor_Area_SF__c = (ncmtRec.Parking_Garage_Gross_Area_SF__c - (key.Foot_Print_Area__c + key.basement_sf__c));
                    }   
                
                //For assigning control ratios
                    key.above_ground__c = key.default_above_ground__c;  
                    key.below_ground__c = key.default_below_ground__c;
                    key.Average_Story_Height__c = ncmtrec.Average_Story_Height__c;
                    key.Basement_Story_Height__c = ncmtrec.Average_Story_Height__c + 3;
                    key.Water_Table_Depth__c = key.Default_Water_Table_Depth__c;
                    key.Typical_Bay_Size_A__c = 30;
                    key.Typical_Bay_Size_B__c = 30;
                    key.Average_Typical_Bay_Area__c = key.Typical_Bay_Size_A__c * key.Typical_Bay_Size_B__c; //key.Default_Typical_Bay_Area__c;
                    key.Dead_Load__c = key.Default_Dead_Load__c;            
                    key.Live_Load__c = key.Default_Live_Load__c;
                    key.Glazing_Ratio_of_above_grade_skin__c = key.Default_Glazing_Ratio__c;
                    key.Int_Const_Core_Shell_Partition_ratio__c = key.Default_Core_Shell_Partition_Ratio__c;
                    key.Vertical_Conveyance_Elevators__c = ncmtrec.Vertical_Conveyance_Elevators_Stops__c;
                    key.Vertical_Conveyance_Escalators_Pairs__c = key.Default_Vertical_Conveyance_Escalators__c;
                    key.Plumbing_Fixtures__c = ncmtrec.Plumbing_Fixtures__c;
                    key.HVAC_Heating_Load__c = key.Default_HVAC_Heating_Load__c;
                    key.HVAC_Cooling_Load__c = key.Default_HVAC_Cooling_Load__c;
                    key.HVAC_Air_Handling_Capacity__c = key.Default_Air_Handling_Capacity__c;
                    key.Electrical_Load__c = key.Default_Electrical_Load__c;

                // For calculating Cladding skin ratio for parking garage
                    //system.debug('DefaultSkinRatio'+key.Default_Skin_Ratio__c);
                    //system.debug('DefaultSkindeviationcheck'+key.Default_Skin_deviation_check__c);
                    key.Cladding_Skin_Ratio__c = Math.MAX(key.Default_Skin_Ratio__c, key.Default_Skin_deviation_check__c);
                    
                // for Calculating control ratios SF
                
                   key.Core_Shell_Partition_LF__c  = ncmtRec.Parking_Garage_Gross_Area_SF__c * key.Int_Const_Core_Shell_Partition_ratio__c;
                   key.Plumbing_Fixtures_EA__c    = Math.round(ncmtRec.Parking_Garage_Gross_Area_SF__c * key.Plumbing_Fixtures__c / 1000);  
                   key.Electrical_Load_kW__c = Math.Round(ncmtRec.Parking_Garage_Gross_Area_SF__c * key.Electrical_Load__c/1000);
                   key.Number_of_Stops__c = Math.Max(Math.ceil(ncmtRec.Parking_Garage_Gross_Area_SF__c * key.Vertical_Conveyance_Elevators__c/10000),2);
                   key.Vertical_Conveyance_Escalators_PR__c = key.Vertical_Conveyance_Escalators_Pairs__c;   
                   key.HVAC_Heating_Load_Mbtu__c = Math.Round(ncmtRec.Parking_Garage_Gross_Area_SF__c/key.HVAC_Heating_Load__c);
                   key.HVAC_Cooling_Load_Tons__c = Math.Round(ncmtRec.Parking_Garage_Gross_Area_SF__c * key.HVAC_Cooling_Load__c);
                   key.HVAC_Air_Handling_Capacity_CFM__c = Math.Round(ncmtRec.Parking_Garage_Gross_Area_SF__c * key.HVAC_Air_Handling_Capacity__c);
                    
                   decimal costimpactpercent = integer.valueof(key.Cost_Impact_Percent__c);
                   key.ParaSiteAdj__c = ((1+(key.Site_Access_Cost_Impact__c/100)) * (1+(key.SiteRemoteness_Cost_Impact__c/100)) * (1+(costimpactpercent/100))).setscale(3); 

            }
            
            // For Record type other building use in project level parameters
            
            else{
               Decimal Basementfloors = Math.Ceil(ncmtrec.Building_Height_Parameter__r.Bast_Ratio__c);
               Decimal floorsproj = (ncmtrec.Building_Height_Parameter__r.No_of_Floors__c + Math.Ceil(ncmtrec.Building_Height_Parameter__r.Bast_Ratio__c));
               Decimal usebasesf,Court1sf,smallfloor,defaultaddnlcirstair;

                //For assigning control ratios
                if(trigger.isInsert) {
                       key.above_ground__c = ncmtrec.above_ground__c;                               //key.default_above_ground__c;  
                       key.below_ground__c = ncmtrec.below_ground__c;                               //key.default_below_ground__c; 
                       key.Freeze_Depth_Footing_Depth_BG__c = key.Default_Freeze_Depth_Footing_Depth__c;
                       key.Water_Table_Depth__c = key.Default_Water_Table_Depth__c;
                       key.Default_Atrium_Phantom_Floors__c = hprec.Atrium_upper_levels_phantom_floors__c;
                       key.Atrium_Phantom_Floors__c = key.Default_Atrium_Phantom_Floors__c;
                       key.cladding_type__c = key.default_cladding_type__c;
                       key.cladding_quality__c = key.default_cladding_quality__c;
                       key.Average_Story_Height__c = key.Default_Average_Story_Height__c;
                       key.Basement_Story_Height__c = key.Default_Basement_Story_Height__c;
                       key.Typical_Bay_Size_A__c = 30;
                       key.Typical_Bay_Size_B__c = 30;
                       key.Average_Typical_Bay_Area__c = key.Default_Typical_Bay_Area__c;
                       key.Dead_Load__c = key.Default_Dead_Load__c;
                       key.Live_Load__c = key.Default_Live_Load__c;
                       key.Cladding_Skin_Ratio__c = key.Default_Skin_Ratio__c;
                       key.Glazing_Ratio_of_above_grade_skin__c = key.Default_Glazing_Ratio__c;
                       key.Int_Const_Core_Shell_Partition_ratio__c = key.Default_Core_Shell_Partition_Ratio__c;
                       key.Vertical_Conveyance_Elevators__c = ncmtrec.Vertical_Conveyance_Elevators_Stops__c;  //key.Default_Vertical_Conveyance_Elevators__c;
                       key.Vertical_Conveyance_Escalators_Pairs__c = key.Default_Vertical_Conveyance_Escalators__c;
                       key.Plumbing_Fixtures__c = ncmtrec.Plumbing_Fixtures__c;                                //key.Default_Plumbing_Fixtures__c;
                       key.HVAC_Heating_Load__c = key.Default_HVAC_Heating_Load__c;
                       key.HVAC_Cooling_Load__c = key.Default_HVAC_Cooling_Load__c;
                       key.HVAC_Air_Handling_Capacity__c = key.Default_Air_Handling_Capacity__c;
                       key.Electrical_Load__c = key.Default_Electrical_Load__c;
                       key.Atrium_Phantom_Floors__c = key.Default_Atrium_Phantom_Floors__c;
                       //key.Green_Roof_BG__c = key.Default_Green_Roof_BG__c;
                       //key.Sloped_Roof_BG__c = key.Default_Sloped_Roof_BG__c;
                       
                       if(ncmtrec.Project_Type__c == 'Repair & Alteration - Parametric Entry' || ncmtrec.Project_Type__c == 'Repair & Alteration - Work Item Detail'){
                            key.Structural_Frame__c = RAQCLRec.Dominant_structural_system__c;
                            key.Code_Seismic_Compliance__c = RAQCLRec.Seismic__c;
                            
                            key.Overall_Condition_Structural_Frame__c = ncmtrec.Overall_Condition__c;
                            key.Overall_condition__c = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_Cladding__c = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_Glazing_System__c = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_Roofing__c = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_Interiors__c  = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_Conveying__c = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_Plumbing__c = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_HVAC__c = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_Electrical__c = ncmtrec.Overall_Condition__c;
                            key.Overall_Condition_Fire_Protection__c = ncmtrec.Overall_Condition__c;
                            
                            key.Cladding_Type__c = RAQCLRec.Quality_Code_Parameter__r.Cladding_List__c;
                            key.Cladding_Quality__c = RAQCLRec.Quality_Code_Parameter__r.Cladding_Quality__c;
                            key.Cladding_Code__c = RAQCLRec.Quality_Code_Parameter__r.Name;
                            key.Dominant_Glazing_System1__c = RAQCLRec.Dominant_Glazing_System1__c;
                            key.Dominant_Glazing_System2__c = RAQCLRec.Dominant_Glazing_System2__c;
                            key.Dominant_Glazing_System3__c = RAQCLRec.Dominant_Glazing_System3__c;
                            
                            key.Primary_Roof_Type__c = RAQCLRec.Dominant_Roofing_Form__c;
                            key.Dominant_Roofing_Material__c = RAQCLRec.Dominant_Roofing_Material__c;
                            key.Character__c = RAQCLRec.Character__c;
                            key.Elevator_Type__c = RAQCLRec.Elevator_Type__c;
                            key.Primary_System__c = RAQCLRec.Primary_System__c;
                            key.Distribution_System__c = RAQCLRec.Distribution_System__c;
                            key.Special_System__c = RAQCLRec.Special_System__c;
                            
                            key.User_Power__c = RAQCLRec.User_Power__c;
                            key.Lighting__c = RAQCLRec.Lighting__c;
                            key.Telecom_IT__c = RAQCLRec.Telecom_IT__c;
                            key.Fire_Protection__c = RAQCLRec.Wet_Pipe__c;
                            
                            key.Default_Finished_Site_Area__c = Math.Max((ncmtrec.Total_Site_Area_Building_Footprint_SF__c - Math.Round(Total_GSF /(key.above_ground__c + key.below_ground__c))),0);
                            key.Finished_Site_Area__c = key.Default_Finished_Site_Area__c;
                            
                            key.Default_Area_SF__c = Total_GSF;
                            key.Override_Area_SF__c = key.Default_Area_SF__c;
                            
                            key.Default_Fire_Protection_Area_SF__c = Total_GSF;
                            key.Override_Fire_Protection_Area_SF__c = key.Default_Fire_Protection_Area_SF__c;
                            
                       }
                       
                       if(ncmtrec.Level_of_Protection__c == 'Level III - Medium' || ncmtrec.Level_of_Protection__c == 'Level IV - High'||ncmtrec.Level_of_Protection__c == 'Level V - Very High'){
                            key.Add_MailRoom_XRay__c = true;
                            key.Add_Visitor_Access_Control__c = true;
                       }else{
                            key.Add_MailRoom_XRay__c = false;
                            key.Add_Visitor_Access_Control__c = false;
                       }
                       
                       if(ncmtrec.Level_of_Protection__c == 'Level V - Very High'){
                          key.Default_Ballistic_Protection_to_windows__c = 10;
                          key.Use_Ballistic_Protection_to_windows__c = key.Default_Ballistic_Protection_to_windows__c;
                          key.Default_HEPA_Filtration_Area_served_SF__c = hprec.Main_Lobby__c + hprec.Atrium_Ground_floor_plan_area__c + hprec.Ground_floor_circulation__c + hprec.Loading_dock_Recycling_Trash__c;
                          key.DefaultChemicalFiltration_Area_served_SF__c = key.Default_HEPA_Filtration_Area_served_SF__c;
                          key.Use_HEPA_Filtration_Area_served_SF__c = key.Default_HEPA_Filtration_Area_served_SF__c;
                          key.Use_Chemical_Filtration_Area_served_SF__c = key.DefaultChemicalFiltration_Area_served_SF__c;
                       }else{
                          key.Use_Ballistic_Protection_to_windows__c = 0;
                          key.Default_Ballistic_Protection_to_windows__c = 0;
                          key.Default_HEPA_Filtration_Area_served_SF__c = 0;
                          key.DefaultChemicalFiltration_Area_served_SF__c =0;
                          key.Use_HEPA_Filtration_Area_served_SF__c = 0;
                          key.Use_Chemical_Filtration_Area_served_SF__c = 0;
                       }
                       
                     // for security paramters
                    //string strFiscalYear = String.ValueOf([SELECT MAX(Cost_Parameter_Date_FY__c) FiscalYear FROM NCMT_Project__c Where ID = :ncmtrec.id][0].get('FiscalYear'));
                    //system.debug('strFiscalYear==='+strFiscalYear);
                    Set<string> setAssign0 = new Set <string> {'CCTV Coverage'};
                    Set<string> setAssign1 = new Set <string> {'Intrusion Detection System (IDS) Coverage'};
                    String  strSOQL;
                    string  strColumnToPick = 'Level_I_Minimum__c';   
                    String strSecurityLevel = ncmtrec.Level_of_Protection__c;
                    string strFiscalYear = ncmtRec.Cost_Parameter_Date_FY__c;
                    
                    if (strSecurityLevel == 'Level II - Low'){
                        strColumnToPick = 'Level_II_Low__c';
                    } else if (strSecurityLevel == 'Level III - Medium'){
                        strColumnToPick = 'Level_III_Medium__c';
                    } else if (strSecurityLevel == 'Level IV - High'){
                        strColumnToPick = 'Level_IV_High__c';
                    } else if (strSecurityLevel == 'Level V - Very High'){
                        strColumnToPick = 'Level_V_Very_High__c';
                    }
                    
                    // Generate the security parameters for this project ...
                    strSOQL =   'Select  ID, Security_Criterion__c, ' + strColumnToPick + ' ' + 
                                'From    NCMT_Security_Parameters__c ' + ' ' +   
                                'Where   Fiscal_Year__c = :strFiscalYear ' +  
                                'And     ' + strColumnToPick + ' > 0 ' +   
                                'Order by Name ';
                                
                    List<NCMT_Security_Parameters__c> objSecurityParameters = Database.query(strSOQL); 
                    
                    for(NCMT_Security_Parameters__c objRecord: objSecurityParameters){
                                                                
                        if (setAssign0.Contains(objRecord.Security_Criterion__c)){
                            system.debug('key.Default_CCTV_System_CCTV_Allowance__c ==='+(Decimal) objRecord.get(strColumnToPick));
                            key.Default_CCTV_System_CCTV_Allowance__c = (Decimal) objRecord.get(strColumnToPick);
                            key.Use_CCTV_System_CCTV_Allowance__c = key.Default_CCTV_System_CCTV_Allowance__c;
                        } else if (setAssign1.Contains(objRecord.Security_Criterion__c)){
                            key.Default_Intrusion_Detection_System_IDS__c = (Decimal) objRecord.get(strColumnToPick);
                            key.Use_Intrusion_Detection_System_IDS__c = key.Default_Intrusion_Detection_System_IDS__c;
                        }   
                    } 
                }
                    
                // for calculating foot print area in bulding massing
                Decimal floors = (key.above_ground__c+key.below_ground__c);
                    
                if(key.Default_Foot_Print_Area__c ==key.Foot_Print_Area__c && key.Foot_Print_Area__c >= 0){
                   
                   if(key.above_ground__c == 0){
                      key.Default_Foot_Print_Area__c = Math.Round(Total_GSF/floorsproj);                          
                   }
                    else if(key.above_ground__c == 1){  
                        key.Default_Foot_Print_Area__c = Math.Round(Total_GSF /floors);
                    }
                    else if(key.above_ground__c > 1){
                        key.Default_Foot_Print_Area__c = Math.Round((Total_GSF /floors) * 1.15);
                    }
                    key.Foot_Print_Area__c = key.Default_Foot_Print_Area__c;

                    //system.debug(key.Foot_Print_Area__c+'foot print area');
                   
                }
                // for calculating basement sf in bulding massing
                if(key.default_basement_sf__c == key.basement_sf__c && key.Basement_SF__c >= 0){
                  
                     if(key.above_ground__c == 0) {
                        key.default_basement_sf__c =Math.Round(Total_GSF * basementfloors);
                     }
                     else{
                        key.default_basement_sf__c = Math.Round(key.Default_Foot_Print_Area__c * key.below_ground__c);
                     }
                     key.basement_sf__c = key.default_basement_sf__c;
                     //system.debug(key.basement_sf__c+'basementSF'); 
                }  
                // for calculating elevated floor area af
                    key.Default_Elevated_Floor_Area_SF__c = Math.Max(Math.Round(Total_GSF -(key.Default_Foot_Print_Area__c + key.default_basement_sf__c)),0);
                    if(key.Above_Ground__c == 1){
                        key.Elevated_Floor_Area_SF__c =  0;
                    }
                    else {
                        key.Elevated_Floor_Area_SF__c = (Total_GSF - (key.Foot_Print_Area__c + key.basement_sf__c));
                    }
                //for calculating smallfloor
                      if(Math.Round(Total_GSF /floors)> 30000){
                          smallfloor =1;
                       }
                       else{
                          smallfloor =0;
                       }
                       //Calculating Default_Adnl_Primary_Circulation_Stair__c
                       if(floors == 1){
                          defaultaddnlcirstair =0;
                       }
                       else if(floors == 2){
                          defaultaddnlcirstair = 1*smallfloor; 
                       }
                       else{
                          defaultaddnlcirstair = 2*smallfloor;
                       }
                       key.Default_Ad_nl_Primary_Circulation_Stair__c = defaultaddnlcirstair;
                       if(trigger.isInsert) {
                        key.Default_Ad_nl_Primary_Circulation_Stair__c = defaultaddnlcirstair;
                        key.Additional_Primary_Circulation_Stair__c = key.Default_Ad_nl_Primary_Circulation_Stair__c;
                        key.Addnl_Primary_Circulation_Stair_Flights__c = key.Additional_Primary_Circulation_Stair__c;
                       }
                       //Assigning default value for Additional Primary Circulation Stair
                       if(key.Additional_Primary_Circulation_Stair__c >= 0 && key.Default_Ad_nl_Primary_Circulation_Stair__c == key.Additional_Primary_Circulation_Stair__c){
                          key.Additional_Primary_Circulation_Stair__c = key.Default_Ad_nl_Primary_Circulation_Stair__c;
                          key.Addnl_Primary_Circulation_Stair_Flights__c = key.Additional_Primary_Circulation_Stair__c;
                       }
                       key.Addnl_Primary_Circulation_Stair_Flights__c = key.Additional_Primary_Circulation_Stair__c;
                       
                 //for calculating typical bay area
                      if((key.Typical_Bay_Size_A__c != 0 && key.Typical_Bay_Size_B__c != 0) && trigger.isUpdate){
                          key.Average_Typical_Bay_Area__c = key.Typical_Bay_Size_A__c*key.Typical_Bay_Size_B__c;
                        } 
                        
                // for Calculating control ratios SF
                
                   key.Core_Shell_Partition_LF__c  = Total_GSF * key.Int_Const_Core_Shell_Partition_ratio__c;
                   key.Plumbing_Fixtures_EA__c    = Math.round(Total_GSF*key.Plumbing_Fixtures__c/1000);  
                   key.Electrical_Load_kW__c = Math.Round(Total_GSF*key.Electrical_Load__c/1000);
                   key.Vertical_Conveyance_Escalators_PR__c = key.Vertical_Conveyance_Escalators_Pairs__c;
                   key.Number_of_Stops__c = ncmtrec.Number_of_Stops__c;
                   /*if(floors ==1){
                    key.Number_of_Stops__c = 0;
                   }
                   else{
                    key.Number_of_Stops__c = floors * Math.Max(Math.Ceil(Total_GSF*key.Vertical_Conveyance_Elevators__c/10000),2);
                   }*/
                  decimal costimpactpercent = integer.valueof(key.Cost_Impact_Percent__c); 
                  key.ParaSiteAdj__c = ((1+(key.Site_Access_Cost_Impact__c/100)) * (1+(key.SiteRemoteness_Cost_Impact__c/100)) * (1+(costimpactpercent/100))).setscale(3);
                  
                  // for Repair and alteration calculations
                  if(ncmtrec.Project_Type__c == 'Repair & Alteration - Parametric Entry' || ncmtrec.Project_Type__c == 'Repair & Alteration - Work Item Detail'){
                    key.Balance__c = key.Finished_Site_Area__c + key.Parking_SF__c + key.Plaza_SF__c;
                    key.Cladding_Code__c = RAQCLRec.Quality_Code_Parameter__r.Name;
                    if(key.Override_Finished_Wall_Area_SF__c == 0 || key.Override_Finished_Wall_Area_SF__c == null ){
                        key.Override_Finished_Wall_Area_SF__c = key.Finished_Wall_Area_SF__c;
                    }
                    if(key.Override_Glazing_Ratio_SF__c == 0 || key.Override_Glazing_Ratio_SF__c == null ){
                        key.Override_Glazing_Ratio_SF__c = key.Glazing_Ratio_SF__c;
                    }
                    if(key.Override_Total_Roof_Area_SF__c == 0 || key.Override_Total_Roof_Area_SF__c == null ){
                        key.Override_Total_Roof_Area_SF__c = key.Total_Roof_Area_SF__c;
                    }
                    if(key.Override_Plumbing_Fixtures_EA__c == 0 || key.Override_Plumbing_Fixtures_EA__c == null ){
                        key.Override_Plumbing_Fixtures_EA__c = key.Plumbing_Fixtures_EA__c;
                    }
                  } 
            }
         }
    }
        // Delete existing records from building massing by floor  
    public static void DeleteBuildingMassingByFloorRecords (set<String> plpIdSet) {
        List <NCMT_Building_Massing_By_Floor__c> lstDelete = [select ID from NCMT_Building_Massing_By_Floor__c Where Proj_Level_Parameter__c IN: plpIdSet] ;
            if(!lstDelete.isEmpty()){
                Database.delete(lstDelete,false);
            }
    } 
        
        // insert records into building massing by floor
    public static void CreateBulidingMassingByFloorrecords(List<Project_Level_Parameter__c> plpRecList,Map<String,NCMT_Project__c> ncmtMapValues,Map<String,NCMT_Housing_Plan_Summary__c> hpmap){
        
        List<FloorWrapper> floorWrapperlist = new List<FloorWrapper>();
        List<NCMT_Building_Massing_By_Floor__c> ListBuildingMassingByFloorRecords = New List<NCMT_Building_Massing_By_Floor__c>();
        set<String> plpIdSet = new set<String>();
        decimal total_gsf;
        //List<Project_Level_Parameter__c> plptoUpdList = new List<Project_Level_Parameter__c>();
        //Map<String,FloorWrapper> plpNewValues = new Map<String,FloorWrapper>();
        
            For (Project_Level_Parameter__c plp : plpRecList ){
                
                NCMT_project__c ncmtRec = new NCMT_Project__c();
                ncmtRec = ncmtMapValues.get(plp.NCMT_Project__c);
                
                NCMT_Housing_Plan_Summary__c hp = new NCMT_Housing_Plan_Summary__c();
                hp = hpmap.get(plp.NCMT_Project__c);
                
                if(ncmtrec.project_type__c == 'New Construction' || ncmtrec.project_type__c == 'Repair & Alteration - Work Item Detail'){
                    total_gsf = ncmtRec.Total_GSF__c;
                }else{
                    total_gsf = ncmtRec.Gross_Area_Including_Parking__c;
                }
                
                //system.debug(ncmtRec+'=============================================================');
                
                FloorWrapper floorWrap = new FloorWrapper();
                //For parking garage record type insert records into building massing by floor
                if(ncmtRec.RecordType.Name == 'Parking Garage'){
                    // for calculating basement2 sf in bulding massing by floor
                    if(ncmtRec.Below_grade__c == 2) {
                        floorWrap.defaultBasement2SF = Math.Round(plp.Foot_Print_Area__c);
                    }
                        floorWrap.basement2SF = floorWrap.defaultBasement2SF;
                        
                    // for calculating basement1sf in building massing by floor
                    if(floorWrap.defaultBasement2SF == 0) {
                      if(ncmtRec.Below_grade__c > 0){
                         floorWrap.defaultBasement1SF = Math.Round(plp.Foot_Print_Area__c);
                       }
                    }
                    else{
                       floorWrap.defaultBasement1SF = Math.Round(floorWrap.defaultBasement2SF);
                    }
                       floorWrap.basement1SF = floorWrap.defaultBasement1SF; 
                       
                    //for calculating groundsf in building massing by floor
                       floorWrap.defaultGroundSF = Math.Round(ncmtRec.Parking_Garage_Gross_Area_SF__c /( ncmtRec.At_and_above_grade__c + ncmtRec.Below_grade__c )) ;    
                       floorWrap.GroundSF = floorWrap.defaultGroundSF;  
                    // For calculating penthouse sf in building massing by floor
                        floorWrap.defaultpenthouseSf = Math.Round(0.5*0);  
                        floorWrap.penthouseSf = floorWrap.defaultpenthouseSf; 
                    // for calculating floorsf in building massing by floor
                       if(ncmtRec.At_and_above_grade__c > 1){
                            floorWrap.defaultFloorSf = Math.Round((ncmtRec.Parking_Garage_Gross_Area_SF__c-(floorWrap.defaultBasement2SF+floorWrap.defaultBasement1SF+floorWrap.defaultGroundSF)-floorWrap.penthouseSF)/(ncmtRec.At_and_above_grade__c-1));
                        }
                            floorWrap.floorSF = floorWrap.defaultFloorSf;     
                      //inserting records into buildingmassingbyfloor
                   ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                       Proj_Level_Parameter__c = plp.Id,
                       Building_Massing_Area__c ='Basement2 SF',
                       Default_Area_SF__c = floorWrap.defaultBasement2SF ,
                       Use_Area_SF__c = floorWrap.basement2SF,  
                       Default_Skylights_SF__c = 0                 // no default skylights for basement2 SF                     
                   ));
                
                   ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                       Proj_Level_Parameter__c = plp.Id,
                       Building_Massing_Area__c ='Basement1 SF',
                       Default_Area_SF__c = floorWrap.defaultBasement1SF ,
                       Use_Area_SF__c = floorWrap.basement1SF,  
                       Default_Skylights_SF__c = Math.Max((floorWrap.basement2SF - floorWrap.basement1SF),0)
                   ));
                
                    ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                        Proj_Level_Parameter__c = plp.Id,
                        Building_Massing_Area__c ='Ground SF',
                        Default_Area_SF__c = floorWrap.defaultGroundSF  ,
                        Use_Area_SF__c = floorWrap.GroundSF,    
                        Default_Skylights_SF__c = Math.Max((floorWrap.basement1SF - floorWrap.GroundSF),0)
                    ));
                boolean flag =false;
                 for (Integer i = 0; i <= ncmtRec.At_and_above_grade__c; i ++){
                    if(i==0) {
                      ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                          Proj_Level_Parameter__c = plp.Id,
                          Building_Massing_Area__c ='FloorSF-'+(i+2),
                          Default_Area_SF__c = floorWrap.defaultFloorSf ,
                          Use_Area_SF__c = floorWrap.floorSF,   
                          Default_Skylights_SF__c = Math.Max((floorWrap.GroundSF - floorWrap.floorSF),0)
                       ));

                    }else if((i+2) <= ncmtrec.At_and_above_grade__c )
                    {
                          ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                           Proj_Level_Parameter__c = plp.Id,
                           Building_Massing_Area__c ='FloorSF-'+(i+2),
                           Default_Area_SF__c = floorWrap.defaultFloorSf ,
                           Use_Area_SF__c = floorWrap.floorSF,
                           Default_Skylights_SF__c = Math.Max((floorWrap.floorSF - floorWrap.floorSF),0)
                         ));
                    }
                    if(!flag && (i+2)==(ncmtrec.At_and_above_grade__c+1) && ncmtrec.At_and_above_grade__c<20 && ncmtrec.At_and_above_grade__c != 1 ) {
                         integer floorNumber= integer.valueof(i+2) ;                            
                        ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                           Proj_Level_Parameter__c = plp.Id,
                           Building_Massing_Area__c ='FloorSF-'+floorNumber,
                           Default_Area_SF__c = 0 ,
                           Use_Area_SF__c = 0,
                           Default_Skylights_SF__c = Math.Max((floorWrap.floorSF - 0),0)
                         ));
                        flag=true;
                    }
                  }
               
                   if(ncmtRec.At_and_above_grade__c >=20) {
                        ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                            Proj_Level_Parameter__c = plp.Id,
                            Building_Massing_Area__c ='Penthouse SF',
                            Default_Area_SF__c = floorWrap.defaultpenthouseSF  ,
                            Use_Area_SF__c = floorWrap.penthouseSF, 
                            Default_Skylights_SF__c = Math.Max((floorWrap.floorSF - floorWrap.penthouseSF),0)
                        ));
                    }
                    else {
                        ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                            Proj_Level_Parameter__c = plp.Id,
                            Building_Massing_Area__c ='Penthouse SF',
                            Default_Area_SF__c = floorWrap.defaultpenthouseSF  ,
                            Use_Area_SF__c = floorWrap.penthouseSF, 
                            Default_Skylights_SF__c = Math.Max((0 - floorWrap.penthouseSF),0)
                        )); 
                    }
                         
                }
                //for record type other building use insert records into buildingmassingbyfloor
                else{
                
                    // for calculating basement2 sf in bulding massing by floor
                  if(plp.below_ground__c == 2) {
                     floorWrap.defaultBasement2SF = Math.Round(plp.basement_sf__c/2);
                  }
                     floorWrap.basement2SF = floorWrap.defaultBasement2SF;
                
                   // for calculating basement1sf in building massing by floor
                  if(floorWrap.defaultBasement2SF == 0) {
                      if(plp.below_ground__c > 0){
                         floorWrap.defaultBasement1SF = Math.Round(plp.Basement_SF__c);
                       }
                  }
                  else{
                       floorWrap.defaultBasement1SF = Math.Round(floorWrap.defaultBasement2SF);
                  }
                       floorWrap.basement1SF = floorWrap.defaultBasement1SF;
                       
                 // For calculating penthouse sf in building massing by floor
                  if(Total_GSF < 30000){
                     floorWrap.defaultpenthouseSf = 0;
                  }
                  else{
                     floorWrap.defaultpenthouseSf = hp.Mechanical_Electrical_IT__c * 0.5;
                     //floorWrap.defaultpenthouseSf = 2500;
                  }
                      
                     floorWrap.penthouseSf = floorWrap.defaultpenthouseSf;
                 
                  //for calculating groundsf in building massing by floor
                  if((plp.above_ground__c+plp.below_ground__c) == 1){
                       floorWrap.defaultGroundSF = Math.Round(plp.Foot_Print_Area__c- floorWrap.defaultpenthouseSF) ;    
                  }
                  else{
                         
                       floorWrap.defaultGroundSF = Math.Round(plp.Foot_Print_Area__c);
                  }
                       floorWrap.GroundSF = floorWrap.defaultGroundSF;   
                  // for calculating floorsf in building massing by floor
                  if(plp.above_ground__c > 1){
                        floorWrap.defaultFloorSf = Math.Round((Total_GSF-(floorWrap.defaultBasement2SF+floorWrap.defaultBasement1SF+floorWrap.defaultGroundSF)-floorWrap.penthouseSF)/(plp.above_ground__c-1));
                  }
                       floorWrap.floorSF = floorWrap.defaultFloorSf;
                     
                  //inserting records into buildingmassingbyfloor
                   ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                       Proj_Level_Parameter__c = plp.Id,
                       Building_Massing_Area__c ='Basement2 SF',
                       Default_Area_SF__c = floorWrap.defaultBasement2SF ,
                       Use_Area_SF__c = floorWrap.basement2SF,  
                       Default_Skylights_SF__c = 0                 // no default skylights for basement2 SF                     
                   ));
                
                   ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                       Proj_Level_Parameter__c = plp.Id,
                       Building_Massing_Area__c ='Basement1 SF',
                       Default_Area_SF__c = floorWrap.defaultBasement1SF ,
                       Use_Area_SF__c = floorWrap.basement1SF,  
                       Default_Skylights_SF__c = Math.Max((floorWrap.basement2SF - floorWrap.basement1SF),0)
                   ));
                
                    ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                        Proj_Level_Parameter__c = plp.Id,
                        Building_Massing_Area__c ='Ground SF',
                        Default_Area_SF__c = floorWrap.defaultGroundSF  ,
                        Use_Area_SF__c = floorWrap.GroundSF,    
                        Default_Skylights_SF__c = Math.Max((floorWrap.basement1SF - floorWrap.GroundSF),0)
                    ));
                boolean flag =false;
                 for (Integer i = 0; i < plp.Above_Ground__c; i ++) {
                    if(i==0 ) {
                    
                        ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                           Proj_Level_Parameter__c = plp.Id,
                           Building_Massing_Area__c ='FloorSF-'+(i+2),
                           Default_Area_SF__c = floorWrap.defaultFloorSf ,
                           Use_Area_SF__c = floorWrap.floorSF,
                           Default_Skylights_SF__c = Math.Max((floorWrap.GroundSF - floorWrap.floorSF),0)
                         ));
                    } else if((i+2) <= plp.Above_Ground__c ) 
                    {
                          ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                           Proj_Level_Parameter__c = plp.Id,
                           Building_Massing_Area__c ='FloorSF-'+(i+2),
                           Default_Area_SF__c = floorWrap.defaultFloorSf ,
                           Use_Area_SF__c = floorWrap.floorSF,
                           Default_Skylights_SF__c = Math.Max((floorWrap.floorSF - floorWrap.floorSF),0)
                         ));
                    }
                
                    if(!flag && (i+2)==(plp.Above_Ground__c+1) && plp.Above_Ground__c<20 && plp.Above_Ground__c != 1 ) {
                         integer floorNumber= integer.valueof(i+2) ;                            
                        ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                           Proj_Level_Parameter__c = plp.Id,
                           Building_Massing_Area__c ='FloorSF-'+floorNumber,
                           Default_Area_SF__c = 0 ,
                           Use_Area_SF__c = 0,
                           Default_Skylights_SF__c = Math.Max((floorWrap.floorSF - 0),0)
                         ));
                        flag=true;
                    }
                 }
                    if(plp.Above_Ground__c >=20) {
                    ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                         Proj_Level_Parameter__c = plp.Id,
                         Building_Massing_Area__c ='Penthouse SF',
                         Default_Area_SF__c = floorWrap.defaultpenthouseSF  ,
                         Use_Area_SF__c = floorWrap.penthouseSF,    
                         Default_Skylights_SF__c = Math.Max((floorWrap.floorSF - floorWrap.penthouseSF),0)
                    ));
                    }
                    else {
                    ListBuildingMassingByFloorRecords.Add(new NCMT_Building_Massing_By_Floor__c(
                         Proj_Level_Parameter__c = plp.Id,
                         Building_Massing_Area__c ='Penthouse SF',
                         Default_Area_SF__c = floorWrap.defaultpenthouseSF  ,
                         Use_Area_SF__c = floorWrap.penthouseSF,    
                         Default_Skylights_SF__c = Math.Max((0 - floorWrap.penthouseSF),0)
                    )); 
                        
                    }
               
               }
            }
        
        //insert the new building massing by floor record
        Database.Insert(ListBuildingMassingByFloorRecords,false);
    } 
        
    //Wrapper class for basement & floor calculations
    public Class FloorWrapper{
        public String plpRecId{get; set;}
        public Decimal defaultBasement2SF{get; set;}
        public Decimal basement2SF{get; set;}
        public Decimal defaultBasement1SF{get; set;}
        public Decimal basement1SF{get; set;}
        public Decimal defaultGroundSF{get; set;}
        public Decimal groundSF{get; set;}
        public Decimal defaultFloorSf{get; set;}
        public Decimal floorSF{get; set;}
        public Decimal defaultPenthouseSf{get; set;}
        public Decimal penthouseSF{get; set;}
        public Decimal claddingretainingwall{get; set;}
            
        public FloorWrapper(){
            defaultBasement2SF = 0;
            basement2SF = 0;
            defaultBasement1SF = 0;
            basement1SF = 0;
            defaultGroundSF = 0;
            groundSF = 0;
            defaultFloorSf = 0;
            floorSF = 0;
            defaultPenthouseSf =0;
            penthouseSF =0; 
            claddingretainingwall = 0;
        }
            
    }
        
}