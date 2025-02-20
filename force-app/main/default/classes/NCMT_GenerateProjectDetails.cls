public with sharing class NCMT_GenerateProjectDetails {
    
    public void GenerateCoreShellData(ID ProjectID, String strProjectType, string txtCostParameterDateFY, Map<String,String> mapCostSummary){
                
        String  strSOQL;
        string  strColumnToPick = 'Other_Space_Unit_Cost__c';
        Decimal ItemSqFt = 0.0;
        Decimal RAModsPercent = 100;
         triggervalue.isPerformanceUpdate= true;
        triggervalue.isCostUpdate = true; 
                
        Set<string> setAssign1 = new Set <string> {'CC26','CC172','CC380','CC381','CC382','CC383'};
        Set<string> setAssignCustom1 = new Set <string> {'CC160','CC222','CC305','CC309','CC333','CC343','CC367','CC368','CC369','CC370','CC117','CC-00461','CC-00462'};
        Set<string> setAssignCustom4 = new Set <string> {'CC291','CC298'};
        Set<string> setAssignCustom5 = new Set <string> {'CC21','CC23','CC377','CC378'};
        Set<string> setAssignCustom6 = new Set <string> {'CC57','CC58','CC61','CC92','CC93','CC94','CC95','CC122','CC123','CC124','CC125','CC136','CC137','CC138','CC139'};
        Set<string> setAssignCustom7 = new Set <string> {'CC189','CC190','CC191','CC105','CC107','CC149','CC151','CC72','CC74'};
        Set<string> setAssignCustom8 = new Set <string> {'CC193','CC194','CC195','CC196','CC197','CC198','CC199'};
        Set<string> setAssignCustom9 = new Set <string> {'CC108','CC111','CC112','CC113','CC114','CC130','CC152','CC155','CC156','CC157','CC158','CC75','CC80','CC81','CC84'};
        Set<string> setAssignCustom10 = new Set <string> {'CC100','CC101','CC102','CC103','CC126','CC141','CC144','CC145','CC146','CC147','CC62','CC67','CC68','CC71','CC97','CC200','CC201','CC202'};
        Set<string> setAssignCustom12 = new Set <string> {'CC185','CC186','CC187','CC188'};
        Set<string> setAssignCustom16 = new Set <string> {'CC225','CC226','CC228'};
        Set<string> setAssignCustom19 = new Set <string> {'CC229','CC230','CC232'};
        Set<string> setAssignCustom24 = new Set <string> {'CC132','CC162','CC163','CC167','CC168','CC253'};
        Set<string> setAssignCustom29 = new Set <string> {'CC265','CC273'};
        Set<string> setAssignCustom33 = new Set <string> {'CC203','CC204'};
        Set<string> setAssignCustom42 = new Set <string> {'CC335','CC336','CC339'};
        Set<string> setAssignCustom49 = new Set <string> {'CC220','CC221'};
        Set<string> setAssignCustom54 = new Set <string> {'CC30','CC32'};
        Set<string> setAssignCustom55 = new Set <string> {'CC34','CC38','CC39'};
        Set<string> setAssignCustom70 = new Set <string> {'CC216','CC356'};
        Set<string> setAssignCustom72 = new Set <string> {'CC217','CC357'};
        Set<string> setAssignCustom74 = new Set <string> {'CC218','CC358'};
        Set<string> setAssignCustom76 = new Set <string> {'CC219','CC236','CC257','CC359'};
        Set<string> setAssignCustom78 = new Set <string> {'CC223','CC239','CC260','CC362'};
        Set<string> setAssignCustom80 = new Set <string> {'CC224','CC240','CC261','CC363'};
        Set<string> setAssignCustom82 = new Set <string> {'CC237','CC258','CC360'};
        Set<string> setAssignCustom84 = new Set <string> {'CC241','CC262','CC364'};
        Set<string> setAssignCustom90 = new Set <string> {'CC303','CC306'};
        Set<string> setAssignCustom93 = new Set <string> {'CC329','CC332'};
        Set<string> setAssignCustom94 = new Set <string> {'CC328','CC330'};
        Set<string> setAssignCustom98 = new Set <string> {'CC179','CC209'};
        Set<string> setAssignCustom104 = new Set <string> {'CC308','CC215','CC238','CC259','CC361'};
        Set<string> setAssignCustom106 = new Set <string> {'CC304','CC307','CC365'};
        Set<string> setAssignCustom113 = new Set <string> {'CC44','CC85','CC131'};
        Set<string> setAssignCustom115 = new Set <string> {'CC1','CC9'};
        Set<string> setAssignCustom123 = new Set <string> {'CC12','CC13'};
        Set<string> setAssignCustom133 = new Set <string> {'CC29','CC31'};
        Set<string> setAssignCustom134 = new Set <string> {'CC45','CC86','CC119'};
        Set<string> setAssignCustom151 = new Set <string> {'CC87','CC120'};
        Set<string> setAssignCustom154 = new Set <string> {'CC90','CC121','CC134'};
        Set<string> setAssignCustom156 = new Set <string> {'CC96','CC140'};
        Set<string> setAssignCustom157 = new Set <string> {'CC98','CC142'};
        Set<string> setAssignCustom159 = new Set <string> {'CC104','CC148'};
        Set<string> setAssignCustom161 = new Set <string> {'CC109','CC153'};
        Set<string> setAssignCustom163 = new Set <string> {'CC115','CC159'};
        Set<string> setAssignCustom165 = new Set <string> {'CC127','CC129'};
        Set<string> setAssignCustom172 = new Set <string> {'CC269','CC271'};
        Set<string> setAssignCustom175 = new Set <string> {'CC278','CC279','CC319'};
        Set<string> setAssignCustom176 = new Set <string> {'CC280','CC286'};
        Set<string> setAssignCustom182 = new Set <string> {'CC313','CC314'};
        // for other space unit adding records for unit cost(getting from lookup)
        Set<string> setAssignCustom266 = new Set <string> {'CC233','CC254'};
        Set<string> setAssignCustom267 = new Set <string> {'CC-00420','CC-00441'};
        Set<string> setAssignCustom268 = new Set <string> {'CC-00421','CC-00442'};
        Set<string> setAssignCustom269 = new Set <string> {'CC-00422','CC-00443'};  
        Set<string> setAssignCustom270 = new Set <string> {'CC234','CC255'};
        Set<string> setAssignCustom271 = new Set <string> {'CC-00423','CC-00444'};
        Set<string> setAssignCustom272 = new Set <string> {'CC-00424','CC-00445'};
        Set<string> setAssignCustom273 = new Set <string> {'CC-00425','CC-00446'};      
        Set<string> setAssignCustom274 = new Set <string> {'CC235','CC256'};
        Set<string> setAssignCustom275 = new Set <string> {'CC-00426','CC-00447'};
        Set<string> setAssignCustom276 = new Set <string> {'CC-00427','CC-00448'};
        Set<string> setAssignCustom277 = new Set <string> {'CC-00428','CC-00449'};
        Set<string> setAssignCustom278 = new Set <string> {'CC-00452','CC-00453','CC-00454','CC-00455','CC-00456','CC-00457','CC-00458','CC-00459','CC-00460'};  
        Set<string> setAssignCustom279 = new Set <string> {'CC-00473','CC-00482'};  
        Set<string> setAssignCustom280 = new Set <string> {'CC-00470','CC-00471','CC-00472','CC-00475','CC-00476','CC-00478','CC-00479','CC-00480','CC-00481'}; 
        Set<string> setAssignCustom281 = new Set <string> {'CC-00461','CC-00462','CC117','CC160'};  
        Set<string> setAssignCustom282 = new Set <string> {'CC344','CC345','CC346','CC347','CC348','CC349','CC350','CC351','CC352','CC353','CC354','CC-00397','CC-00398','CC-00399','CC-00400','CC-00401','CC-00402','CC-00403','CC-00404','CC-00405','CC-00406','CC-00407','CC-00408',
                                                            'CC-00409','CC-00410','CC-00411','CC-00412'}; 
        Set<string> setAssignCustom283 = new Set <string> {'CC355','CC356','CC357','CC358','CC359','CC360','CC361','CC362','CC363','CC364','CC365','CC366'} ; 
        Set<string> setAssignCustom284 = new Set <string> {'CC367','CC368','CC369','CC370','CC371','CC-00480','CC-00481'};                                                   
        
        integer btypenum =0, totalcolumnsareaanalysis = 0;
        ID PLPID, projCRID,PerfIpID ;
       
        string structuralFrame, PLPCladdingType , PLPCladdingQuality, ProjectRecordTypeName;
        
        decimal dblGrossSqFt = 0, powerrevolvingdoors = 0, mainentrydoors = 0, BuildingPerimeter = 0, AreaColumnCount = 0, Add50percentofperimeter = 0,
                totalcolumncount = 0, averagecolumnarea = 0, Weightperfooting = 0, Soilcapacity = 0, areaofcolumnbase = 0, squaredimension = 0, depth = 0,
                Overexcavateforlayback = 0, OverexcavationforFtgdepth = 0, Exceedingspreads = 0, piledemand = 0, typicalpilelength = 0, Overexcavateforlayback1 = 0,
                OverexcavationforFtgdepth1 = 0, dblSumDefault_Area_SF, dblMaxUse_Area_SF, dblFootPrint_Area = 0, dblFinished_Site = 0;
         List<NCMT_TCO_Annual_Cost_Summary__c> NPVSummaryList = [Select ID, Name,Performance_Input__c,TCO_Project_Cost_Rate__c
                                                              From NCMT_TCO_Annual_Cost_Summary__c
                                                              where Project_Name__c = :ProjectID
                                                               ];
        if (NPVSummaryList.size()>0){
             system.debug('NPVSummaryList ==='+NPVSummaryList );   
                 //NPVSummaryID = NPVSummaryList[0].Id;
                 PerfIpID = NPVSummaryList[0].Performance_Input__c;
                 projCRID = NPVSummaryList[0].TCO_Project_Cost_Rate__c;
         }

                                 
              
        List<Project_Level_Parameter__c> ListPLP = [Select ID,Above_Ground__c,Below_Ground__c,Sloped_Roof_SF__c,Green_Roof_SF__c,Flat_Roof_SF__c,Number_of_Stops__c,Base_SF__c,Mid_SF__c,Top_SF__c,
                                                           Basement_Roof_SF__c,Window_Percentage_SF__c,Curtain_Wall_Percentage_SF__c,Stair_Analysis_Total_Flights__c,Addnl_Primary_Circulation_Stair_Flights__c,
                                                           Atrium_Phantom_Floors__c,Roofing_Skylights_SF__c,Core_Shell_Partition_LF__c,Average_Story_Height__c,HVAC_Heating_Load_Mbtu__c,HVAC_Cooling_Load_Tons__c,
                                                           HVAC_Air_Handling_Capacity_CFM__c,Electrical_Load_kW__c,Vertical_Conveyance_Escalators_PR__c,Plumbing_Fixtures_EA__c,Upper_Roof_SF__c,Cladding_Retaining_Wall_SF__c,
                                                           Total_Roof_Area_SF__c,Atrium_Area_SF__c,Excavation_Percent_Shored_BG__c,Basement_Story_Height__c,Default_Water_Table_Depth__c,Average_Typical_Bay_Area__c,
                                                           Cladding_Skin_Ratio__c,Typical_Bay_Size_A__c,Typical_Bay_Size_B__c,Dead_Load__c,Live_Load__c,Soil_Bearing_Strength__c,Cladding_Skin_Ratio_SF__c,
                                                           Default_Freeze_Depth_Footing_Depth__c,Foot_Print_Area__c,Freeze_Depth_Footing_Depth__c,Water_Table_Depth__c,Excavation_Percentage_Shored__c,
                                                           Finished_Wall_Area_SF__c,Cladding_Quality__c, Primary_Roof_Type__c, Cladding_Type__c, Structural_Frame__c, Freeze_Depth_Footing_Depth_BG__c,
                                                           RA_Str_Mod__c, RA_Seis_Mod__c, RA_Clad_Mod__c, RA_Glaz_Mod__c, RA_Roof_Mod__c, RA_Int_Mod__c, RA_Elev_Mod__c, RA_Plum_Mod__c, RA_HVAC_Mod__c, RA_Elec_Mod__c,
                                                           RA_FP_Mod__c, RA_UP_Mod__c, RA_LTG_Mod__c, RA_TLC_Mod__c, RA_SITE_Mod__c, RA_UTIL_Mod__c, Default_Finished_Site_Area__c, Finished_Site_Area__c
                                                      From Project_Level_Parameter__c 
                                                     Where NCMT_Project__c = :ProjectID];
        system.debug('listPLP'+ listPLP);
        For (Project_Level_Parameter__c objplp: ListPLP) {
                 PLPID = objplp.ID;
                 structuralFrame = objplp.Structural_Frame__c;
                 PLPCladdingType = objplp.Cladding_Type__c;
                 PLPCladdingQuality = objplp.Cladding_Quality__c;
        }                                                    
                                                
        List<NCMT_Housing_Plan_Summary__c> ListHP = [Select Ground_floor_circulation__c,Atrium_Ground_floor_plan_area__c,Main_Lobby__c,Elevator_lobbies__c,Other_circulation__c,Mechanical_Electrical_IT__c,Loading_dock_Recycling_Trash__c,
                                                            Restrooms__c,Stair_shafts__c,Conditioned_Core_Area__c,Total_USF__c,Enclosed_Parking__c,Total_GSF__c 
                                                       From NCMT_Housing_Plan_Summary__c 
                                                      Where Project__c = :ProjectID];
        
        NCMT_Project__c NCMTRec = [Select ID, Building_Height_Parameter__r.Pile_Y_N__c,Building_Height_Parameter__r.Col_fmk__c,Building_Height_Parameter__r.Col_C_S__c,Building_Height_Parameter__r.SW_thickness__c,
                                          Building_Height_Parameter__r.Slab_Thickness__c,Building_Height_Parameter__r.Beam_fmk__c,Building_Height_Parameter__r.Beam_C_S__c,Building_Height_Parameter__r.Columns__c,
                                          Building_Height_Parameter__r.Bracing__c,Building_Height_Parameter__r.Horiz_Steel__c,Building_Height_Parameter__r.Steel_FP__c,Building_Height_Parameter__r.Deck_FP__c,
                                          Gross_Area_w_o_parking_BGSF__c,Parking_Garage_Gross_Area_SF__c,below_grade__c,At_and_above_grade__c,Below_Grade_Structure__c,High__c,Number_of_Spaces__c,
                                          Building_Quality__c,Building_Height_Parameter__r.Anchor_Bolts__c,Building_Height_Parameter__r.Large_Canopy__c,Building_Height_Parameter__r.Small_Canopy__c,Building_Height_Parameter__r.Mid_Canopy__c,
                                          Building_Cost_Type__c,Building_Type__c, Project_Type__c, Gross_Area_Including_Parking__c 
                                   From NCMT_Project__c
                                   Where ID = :ProjectID];
        ProjectRecordTypeName = NCMTRec.Building_Type__c;                           
                                   
        AggregateResult[] arSumDefaultAreaSF = [SELECT SUM (Default_Area_SF__c ) SumDefaultAreaSF
                                                  FROM NCMT_Building_Massing_By_Floor__c 
                                                 WHERE Proj_Level_Parameter__c = :PLPID
                                                   AND Building_Massing_Area__c in ('Basement2 SF','Basement1 SF') ]; 
        For (AggregateResult ar : arSumDefaultAreaSF) {
            dblSumDefault_Area_SF = (Decimal) ar.get('SumDefaultAreaSF');
        }                                           
        
        if(strProjectType != 'New Construction'){                                           
            AggregateResult[] arMaxUseAreaSF = [SELECT MAX (Default_Area_SF__c ) MaxUseAreaSF
                                                                    FROM NCMT_Building_Massing_By_Floor__c 
                                                                    WHERE Proj_Level_Parameter__c = :PLPID
                                                                    and Building_Massing_Area__c in ('Basement2 SF','Basement1 SF','Ground SF') ];                                            
            For (AggregateResult ar : arMaxUseAreaSF) {
                    dblMaxUse_Area_SF = (Decimal) ar.get('MaxUseAreaSF');
            }
        }
        
        List<NCMT_Quality_Code_Parameter__c> listQcp = [Select Name, Base__c, Mid__c, Top__c 
                                                          From NCMT_Quality_Code_Parameter__c
                                                         Where Cladding_List__c = :PLPCladdingType
                                                           And Cladding_Quality__c = :PLPCladdingQuality];                                                  

        if(strProjectType == 'New Construction'){       
            List<Site_Information__c> ListSiteinfo = [Select Footprint_Area__c,Finished_Site__c 
                                                        From Site_Information__c 
                                                        Where Project__c = :ProjectID];
            dblFootprint_Area = listsiteinfo[0].Footprint_Area__c;
            dblFinished_Site  = listsiteinfo[0].Finished_Site__c ;                                          
        }else{
            //system.debug('strProjectType:---'+strProjectType);
            dblFootprint_Area = dblMaxUse_Area_SF;
            dblFinished_Site = ListPLP[0].Finished_Site_Area__c;
        }
                                                                                                                                                                  
        /*List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c 
                                                                From NCMT_Project_Cost_Summary__c 
                                                               Where Project_Name__c = :ProjectID];
                                                               
        Map<string, String> mapCostSummary = new Map<string, String>();
        for(NCMT_Project_Cost_Summary__c objItem : listCostSummary){
            mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
        }*/
        Map<string,Decimal> SLPMap = new Map<string,decimal>(); 
        for(System_Level_Parameter__c SLP : [SELECT Name, Value__c FROM System_Level_Parameter__c where Category__c = 'Core Shell Cost Parameters' ]) {
            SLPMap.put(SLP.Name,SLP.Value__c);  
        }

                
        //string strFiscalYear = String.ValueOf([SELECT MAX(Fiscal_Year__c) FiscalYear FROM NCMT_Core_Shell_Cost_Parameter__c][0].get('FiscalYear'));
        //string strFiscalYear = String.ValueOf([SELECT MAX(Cost_Parameter_Date_FY__c) FiscalYear FROM NCMT_Project__c Where ID = :ProjectID][0].get('FiscalYear'));
          string strFiscalYear = txtCostParameterDateFY;
        List<NCMT_Core_Shell_Cost_Detail__c> objProjectCoreShellDetailRecords = New List<NCMT_Core_Shell_Cost_Detail__c>();
         
        // Pick the Security Parameters that affect this project ...
        //if (strProjectType == Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId()){
        //    strColumnToPick = 'Parking_Space_Unit_Cost__c';
        //} 
        
        // Generate the security parameters for this project ...
        strSOQL =   'Select  ID, Core_Shell_Cost_Parameter_Identifier__c, Cost_Type__c, Cost_Sub_Type__c, ' + strColumnToPick + ' ' + 
                    'From    NCMT_Core_Shell_Cost_Parameter__c ' + ' ' +   
                    'Where   Fiscal_Year__c = :strFiscalYear ' + 
                    'And     Repair_Related__c = false ' +  
                    'And     ' + strColumnToPick + ' > 0 ' +   
                    'Order by Core_Shell_Cost_Parameter_Identifier__c ';
        List<NCMT_Core_Shell_Cost_Parameter__c> objCoreShellParameters = Database.query(strSOQL); 
        
        if(ProjectRecordTypeName == 'Office'){
            btypenum = 1;
        }
        else if (ProjectRecordTypeName == 'Childcare Center'){
            btypenum = 4;
        }
        else if(ProjectRecordTypeName == 'Courthouse'){
            btypenum = 3;
        }
        else if (ProjectRecordTypeName == 'Laboratory: Dry' || ProjectRecordTypeName == 'Laboratory: Wet' || ProjectRecordTypeName == 'Data Center' || ProjectRecordTypeName == 'Medical Clinic' || ProjectRecordTypeName == 'Medical Office') {
            btypenum = 2;
        }
        else if (ProjectRecordTypeName == 'Utility'){
            btypenum = 6;
        }
        else if (ProjectRecordTypeName == 'Parking Garage'){
            btypenum = 5;
        }
            if(NCMTRec.Project_Type__c == 'New Construction'){                
                dblGrossSqFt = ListHp[0].Total_GSF__c;
                System.debug('gross229---  ' +dblGrossSqFt);
            }else{
                dblGrossSqFt = NCMTRec.Gross_Area_Including_Parking__c;
            }
            // for calculating foundations parameters
            try {
                BuildingPerimeter = (dblFootprint_Area * listplp[0].Cladding_Skin_Ratio__c/(listplp[0].Average_Story_Height__c+3));
                AreaColumnCount = dblFootprint_Area/Listplp[0].Average_Typical_Bay_Area__c;
                Add50percentofperimeter = ((dblFootprint_Area * listplp[0].Cladding_Skin_Ratio__c/listplp[0].Average_Story_Height__c)/((listplp[0].Typical_Bay_Size_A__c+listplp[0].Typical_Bay_Size_B__c)/2))/2;
                totalcolumncount = Math.Round(AreaColumnCount+Add50percentofperimeter);
                averagecolumnarea = dblFootprint_Area/totalcolumncount;
                Weightperfooting = (listplp[0].above_ground__c + listplp[0].below_ground__c)* averagecolumnarea * (listplp[0].Dead_Load__c+listplp[0].Live_Load__c) * 0.5;
                Soilcapacity = listplp[0].Soil_Bearing_Strength__c;
                areaofcolumnbase = Weightperfooting/Soilcapacity ;
                squaredimension = Math.Min((Math.Sqrt(areaofcolumnbase)).setscale(1),10);
                
            }
            catch (Exception e) {
                BuildingPerimeter = 0;
            }
            
            // for calculating depth
              if(listplp[0].below_ground__c > 0) {
                depth = 3;
              }
              else{
                depth = Math.Max(3, listplp[0].Freeze_Depth_Footing_Depth_BG__c);
              }
            Overexcavateforlayback = Math.Round((depth.pow(2)/2)*(6*squaredimension));
            OverexcavationforFtgdepth = Overexcavateforlayback;
            // for calculating Exceedingspreads
              if(squaredimension == 10){
                 Exceedingspreads = 1;
              }
              else{
                 Exceedingspreads = 0;
              }
            piledemand = (areaofcolumnbase - 100)* Soilcapacity; 
            typicalpilelength = Math.Max(piledemand/4500,75) * Exceedingspreads;
            Overexcavateforlayback1 = Math.Round(Math.Round(BuildingPerimeter)*2*3*4*0.5/27);
            //for calculating OverexcavationforFtgdepth1
              if(listplp[0].below_ground__c == 0){
                 OverexcavationforFtgdepth1 = Math.round(Math.round(BuildingPerimeter)*2*Math.max((listplp[0].Freeze_Depth_Footing_Depth_BG__c - 4),0)/27);
              }
              else {
                 OverexcavationforFtgdepth1 = 0;
              }
              // for calculating column area analysis from parametric entry
              decimal corecolumns = dblGrossSqFt/Listplp[0].Average_Typical_Bay_Area__c;
              decimal basedoncladdingratio = listplp[0].Cladding_Skin_Ratio_SF__c/listplp[0].Average_Story_Height__c;
              decimal pericolumns = (basedoncladdingratio/((listplp[0].Typical_Bay_Size_A__c+listplp[0].Typical_Bay_Size_B__c)/2))/2;
              
              totalcolumnsareaanalysis = Math.Round(corecolumns+pericolumns);
         
        for(NCMT_Core_Shell_Cost_Parameter__c objRecord: objCoreShellParameters) {
        try {    
            if(ncmtrec.Building_Cost_Type__c == 'Core/Shell only' || ncmtrec.Building_Cost_Type__c == 'Core/Shell with TI' || ncmtrec.Building_Cost_Type__c == 'TI Only'){
                
                if(ncmtRec.Project_Type__c == 'Repair & Alteration - Parametric Entry' || ncmtRec.Project_Type__c == 'Repair & Alteration - Work Item Detail'){
                    if(objRecord.Cost_type__c == 'Foundations' && objRecord.Cost_Sub_Type__c != 'Slab on Grade' && objRecord.Cost_Sub_Type__c != 'Dewatering'){
                        RAModsPercent = listPLP[0].RA_Str_Mod__c + listPLP[0].RA_Seis_Mod__c;
                    }else if(objRecord.Cost_type__c == 'Basement Construction' && (setAssignCustom55.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c))){
                        RAModsPercent = listPLP[0].RA_Str_Mod__c + listPLP[0].RA_Seis_Mod__c;
                    }else if(objRecord.Cost_type__c == 'Superstructure'){
                        if(!(setAssignCustom281.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c))){
                            RAModsPercent = listPLP[0].RA_Str_Mod__c + listPLP[0].RA_Seis_Mod__c;
                        }else{
                            RAModsPercent = 0;
                        }
                    }else if(objRecord.Cost_type__c == 'Exterior Closure'){
                        if(objRecord.Cost_Sub_Type__c != 'Curtainwall' && objRecord.Cost_Sub_Type__c != 'Windows'  && objRecord.Cost_Sub_Type__c != 'Doors, frames & hardware'){
                            RAModsPercent = listPLP[0].RA_Clad_Mod__c;
                        }else{
                            RAModsPercent = listPLP[0].RA_Glaz_Mod__c;
                        }
                    }else if(objRecord.Cost_type__c == 'Roofing'){
                            RAModsPercent = listPLP[0].RA_Roof_Mod__c;
                    }else if(objRecord.Cost_type__c == 'Interior Construction' || objRecord.Cost_type__c == 'Interior Finishes'){
                        if(objRecord.Cost_type__c == 'Interior Construction'  && objRecord.Cost_Sub_Type__c == 'Partitions'){
                            RAModsPercent = listPLP[0].RA_Int_Mod__c * 0.5;
                        }else{
                            RAModsPercent = listPLP[0].RA_Int_Mod__c;
                        }       
                    }else if(objRecord.Cost_type__c == 'Stairs' ){
                        if(objRecord.Cost_Sub_Type__c != 'Egress Stairs'){
                            RAModsPercent = listPLP[0].RA_Int_Mod__c * 0.25;
                        }else{
                            RAModsPercent = 0;
                        }
                    }else if(objRecord.Cost_type__c == 'Conveyance Systems' ){
                            RAModsPercent = listPLP[0].RA_Elev_Mod__c;
                    }else if(objRecord.Cost_type__c == 'Plumbing' ){
                            RAModsPercent = listPLP[0].RA_Plum_Mod__c;  
                    }else if(objRecord.Cost_type__c == 'HVAC' ){
                            RAModsPercent = listPLP[0].RA_HVAC_Mod__c;
                    }else if(objRecord.Cost_type__c == 'Fire Protection' ){
                            RAModsPercent = listPLP[0].RA_FP_Mod__c;
                    }else if(objRecord.Cost_type__c == 'Electrical Systems'){
                          if(setAssignCustom282.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                                RAModsPercent = listPLP[0].RA_LTG_Mod__c;   
                          }else if(setAssignCustom283.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                                RAModsPercent = listPLP[0].RA_UP_Mod__c;
                          }else if(setAssignCustom284.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                                RAModsPercent = listPLP[0].RA_TLC_Mod__c;
                          }else{
                            RAModsPercent = listPLP[0].RA_ELEC_Mod__c;
                          }
                    }else if(objRecord.Cost_type__c == 'Sitework - Building Related' || objRecord.Cost_type__c == 'Other Sitework - Project Related' ){
                        if(objRecord.Cost_Sub_Type__c.contains('Site Utilities')){
                            RAModsPercent = listPLP[0].RA_UTIL_Mod__c;
                        }else{
                            RAModsPercent = listPLP[0].RA_SITE_Mod__c;
                        }               
                    }else{
                        RAModsPercent = 0;
                    }
                }
 
            if(objRecord.Cost_type__c == 'Superstructure' && objRecord.Cost_Sub_Type__c != structuralFrame) {
                ItemSqFt = 0;
            }else if (setAssign1.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = 1.0;
            } else if (setAssignCustom1.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = dblGrossSqFt; 
            } else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC341'){
                ItemSqFt = 300; 
            } else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC295'){
                ItemSqFt = Math.round(dblGrossSqFt*0.3);
            } else if (setAssignCustom4.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && (dblGrossSqFt > 30000)){
                ItemSqFt = dblGrossSqFt;    
            }else if (setAssignCustom5.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = dblFootprint_Area;
            }else if (setAssignCustom6.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = dblGrossSqFt-dblFootprint_Area;
            }else if (setAssignCustom7.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Sloped_Roof_SF__c;    
            }else if (setAssignCustom8.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Green_Roof_SF__c; 
            }else if (setAssignCustom9.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = (listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c);
            }else if (setAssignCustom10.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Flat_Roof_SF__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC170'){
                ItemSqFt = roundofneg(dblGrossSqFt/150,-1) ;
            }else if (setAssignCustom12.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Basement_Roof_SF__c ; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC174'){
                ItemSqFt = listPLP[0].Curtain_Wall_Percentage_SF__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC176'){
                ItemSqFt = listPLP[0].Window_Percentage_SF__c ; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC171'){
                 if ((listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c) < 2){
                    ItemSqFt = 0; 
                 }
                 else{
                    ItemSqFt = Math.Round((listPLP[0].Window_Percentage_SF__c + listPLP[0].Curtain_Wall_Percentage_SF__c)/8);  
                 }
            }else if (setAssignCustom16.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Stair_Analysis_Total_Flights__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC227'){
                ItemSqFt = (listPLP[0].Stair_Analysis_Total_Flights__c)*26 ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC266' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 2){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00388' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 1 ){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00389' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 3){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00390' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 4){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00391' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 5 ){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00392' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 6){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00393' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 7 ){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00394' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 8){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00395' && (listplp[0].above_ground__c + listplp[0].below_ground__c)== 9){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00396' && (listplp[0].above_ground__c + listplp[0].below_ground__c)>= 10){
                    ItemSqFt = listPLP[0].Number_of_Stops__c ;                                                                                                                                  
            }else if (setAssignCustom19.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Addnl_Primary_Circulation_Stair_Flights__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC231'){
                ItemSqFt = (listPLP[0].Addnl_Primary_Circulation_Stair_Flights__c) * 26 ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC164'){
                ItemSqFt = listPLP[0].Base_SF__c ;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC165'){
                ItemSqFt = listPLP[0].Mid_SF__c;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC166'){
                ItemSqFt = listPLP[0].Top_SF__c ;   
            }else if (setAssignCustom24.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Base_SF__c + listPLP[0].Mid_SF__c + listPLP[0].Top_SF__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC211'){
                  if(dblGrossSqFt < 20000){
                     ItemSqFt = 2;  
                  }
                  else{
                     ItemSqFt = 4 * (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c);
                  }     
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC212'){
                  if(dblGrossSqFt < 20000){
                     ItemSqFt = 4;  
                  }
                  else{
                     ItemSqFt = 6 * (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c);
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC213' && (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c) > 4){
                    ItemSqFt = 2 * (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c);   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC214' && listPLP[0].Atrium_Phantom_Floors__c > 3){
                    ItemSqFt = 3 * (listPLP[0].Atrium_Phantom_Floors__c);   
            }else if (setAssignCustom29.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC272'){
                  ItemSqFt = (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c)* 2;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC210'){
                  if(dblGrossSqFt > 50000){
                     ItemSqFt = 0;
                  }
                  else if(dblFootprint_Area < 100000){
                     ItemSqFt = 2 * (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c);
                  }
                  else {
                    try {
                        ItemSqFt = Math.Ceil(dblFootprint_Area/100000) * 2 * (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c); 
                    }
                    catch (exception e) {
                        ItemSqFt = 0;
                    }     
                  } 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC180'){
                  if((listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c) < 4){
                      ItemSqFt = Math.Max(3, Math.Ceil(dblGrossSqFt/40000));    
                  }
                  else{
                      ItemSqFt = Math.Max(3, Math.Ceil(dblGrossSqFt/80000));    
                  } 
            }else if (setAssignCustom33.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = Math.round(listPLP[0].Roofing_Skylights_SF__c);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC207'){
                  ItemSqFt = Math.Round((listPLP[0].Core_Shell_Partition_LF__c * listPLP[0].Average_Story_Height__c) * 0.4);    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC206'){
                  ItemSqFt = (listPLP[0].Core_Shell_Partition_LF__c * listPLP[0].Average_Story_Height__c) - (Math.Round((listPLP[0].Core_Shell_Partition_LF__c * listPLP[0].Average_Story_Height__c) * 0.4));   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC133'){
                  ItemSqFt = Math.Round(((listPLP[0].Core_Shell_Partition_LF__c * listPLP[0].Average_Story_Height__c) - (Math.Round((listPLP[0].Core_Shell_Partition_LF__c * listPLP[0].Average_Story_Height__c) * 0.4)))*0.3);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC289' && dblGrossSqFt > 30000){
                     ItemSqFt = listPLP[0].HVAC_Heating_Load_Mbtu__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC290' && dblGrossSqFt > 30000){
                    ItemSqFt = listPLP[0].HVAC_Cooling_Load_Tons__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC293'){
                  ItemSqFt = listPLP[0].HVAC_Air_Handling_Capacity_CFM__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC292'){
                  ItemSqFt = Math.Round(listPLP[0].HVAC_Air_Handling_Capacity_CFM__c * 0.3);    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC294' && dblGrossSqFt < 30000){
                   ItemSqFt = Math.Round(listPLP[0].HVAC_Air_Handling_Capacity_CFM__c * 0.3) + listPLP[0].HVAC_Air_Handling_Capacity_CFM__c ;   
            }else if (setAssignCustom42.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listPLP[0].Electrical_Load_kW__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC337'){
                  ItemSqFt = Math.Round(listPLP[0].Electrical_Load_kW__c * 1.25);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC338'){
                  ItemSqFt = Math.Round((Math.Round(listPLP[0].Electrical_Load_kW__c * 1.25))/4);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC342'){
                  ItemSqFt = Math.Round(listPLP[0].Electrical_Load_kW__c * 0.25);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC340'){
                  ItemSqFt = Math.Round(((listPLP[0].Electrical_Load_kW__c * 1.25)-((listPLP[0].Electrical_Load_kW__c * 1.25)/4))* 2);  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC268'){
                  ItemSqFt = listPLP[0].Vertical_Conveyance_Escalators_PR__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC334' && (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c) > 6){
                  ItemSqFt = dblGrossSqFt;          
            }else if (setAssignCustom49.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listPLP[0].Plumbing_Fixtures_EA__c / 2;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC323' && btypenum == 6){
                  ItemSqFt = - (Math.Round(dblGrossSqFt * 0.3));        
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC321' && btypenum == 6){
                     ItemSqFt = 1;   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC275'){
                  ItemSqFt = Math.Round(listPLP[0].Upper_Roof_SF__c / 400); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC276'){
                  ItemSqFt = Math.Round((listPLP[0].Upper_Roof_SF__c / 400)/10) * (listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c) * listPLP[0].Average_Story_Height__c ;
            }else if (setAssignCustom54.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = roundofneg(listPLP[0].Cladding_Retaining_Wall_SF__c * (listPLP[0].Average_Story_Height__c + 2)*0.5/27,-2);
            }else if (setAssignCustom55.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listPLP[0].Cladding_Retaining_Wall_SF__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC35'){
                  ItemSqFt = listPLP[0].Cladding_Retaining_Wall_SF__c * 2;      
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC36'){
                  ItemSqFt = roundofneg(listPLP[0].Cladding_Retaining_Wall_SF__c * (SLPMap.get('Ret_wall_thick')/12) / 27,-1) * SLPMap.get('Ret_wall_rebar') ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC37'){
                  ItemSqFt = roundofneg(listPLP[0].Cladding_Retaining_Wall_SF__c * (SLPMap.get('Ret_wall_thick')/12) / 27,-1);  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC371'){
                  ItemSqFt = listPLP[0].Total_Roof_Area_SF__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC208'){
                  ItemSqFt = Math.sqrt(listPLP[0].Atrium_Area_SF__c) * 2.5 * listPLP[0].Atrium_Phantom_Floors__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC33'){
                  ItemSqFt = listPLP[0].Cladding_Retaining_Wall_SF__c * listPLP[0].Excavation_Percent_Shored_BG__c/100; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC40' ){
                  if (listPLP[0].Default_Water_Table_Depth__c  < ((listPLP[0].Below_Ground__c * listPLP[0].Basement_Story_Height__c) + 6)){
                     ItemSqFt = dblFootprint_Area;  
                  }else{
                     ItemSqFt = 0;
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC20'){
                  if(listPLP[0].Default_Water_Table_Depth__c < 6){
                     ItemSqFt = dblFootprint_Area;  
                  }else{
                    ItemSqFt = 0;
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC69'){
                  ItemSqFt = Math.Round(listPLP[0].Flat_Roof_SF__c *  SLPMap.get('Slab_reinf')) ;   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC70'){
                  ItemSqFt = roundofneg(listPLP[0].Flat_Roof_SF__c * ((ncmtrec.Building_Height_Parameter__r.Slab_Thickness__c-1)/12)/27,-1) ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC63'){
                  ItemSqFt = Math.Round((listPLP[0].Flat_Roof_SF__c/listPLP[0].Average_Typical_Bay_Area__c) * 2 * Math.sqrt(listPLP[0].Average_Typical_Bay_Area__c) * 1.1); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC64'){
                  ItemSqFt = Math.Round((listPLP[0].Flat_Roof_SF__c/listPLP[0].Average_Typical_Bay_Area__c) * 2 * Math.sqrt(listPLP[0].Average_Typical_Bay_Area__c) * 1.1 * ncmtrec.Building_Height_Parameter__r.Beam_fmk__c);  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC66'){
                  ItemSqFt = Math.Round((listPLP[0].Flat_Roof_SF__c/listPLP[0].Average_Typical_Bay_Area__c) * 2 * Math.sqrt(listPLP[0].Average_Typical_Bay_Area__c) * 1.1 * ncmtrec.Building_Height_Parameter__r.Beam_C_S__c/27);   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC65'){
                  ItemSqFt = Math.Round((listPLP[0].Flat_Roof_SF__c/listPLP[0].Average_Typical_Bay_Area__c) * 2 * Math.sqrt(listPLP[0].Average_Typical_Bay_Area__c) * 1.1 * ncmtrec.Building_Height_Parameter__r.Beam_C_S__c/27) * SLPMap.get('Beam_reinf');
            }else if (setAssignCustom70.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC242' && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = Math.round((listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c) * 0.75); 
            }else if (setAssignCustom72.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC244' && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = Math.Round(listHP[0].Ground_floor_circulation__c * 2);
            }else if (setAssignCustom74.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC245' && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = Math.Round(listHP[0].Elevator_lobbies__c * 2); 
            }else if (setAssignCustom76.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listHP[0].Other_circulation__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC348' && (ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){   
                    ItemSqFt = listHP[0].Other_circulation__c ; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00397' && (ncmtrec.Building_Quality__c == 'Class A' || ncmtrec.Building_Quality__c == 'Code Minimum')){
                    ItemSqFt = listHP[0].Other_circulation__c ;               
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC246'){
                  ItemSqFt = Math.Round(listHP[0].Other_circulation__c * 2);
            }else if (setAssignCustom78.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listHP[0].Mechanical_Electrical_IT__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC249'){
                  ItemSqFt = Math.Round(listHP[0].Mechanical_Electrical_IT__c * 0.5);   
            }else if (setAssignCustom80.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listHP[0].Loading_dock_Recycling_Trash__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC250'){
                  ItemSqFt = Math.Round(listHP[0].Loading_dock_Recycling_Trash__c * 0.5);   
            }else if (setAssignCustom82.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listHP[0].Restrooms__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC349' && (ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){    
                     ItemSqFt = listHP[0].Restrooms__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00398' && (ncmtrec.Building_Quality__c == 'Class A' || ncmtrec.Building_Quality__c == 'Code Minimum')){
                     ItemSqFt = listHP[0].Restrooms__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC247'){
                  ItemSqFt = Math.Round(listHP[0].Restrooms__c * 1.5);  
            }else if (setAssignCustom84.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listHP[0].Stair_shafts__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC251'){
                  ItemSqFt = Math.Round(listHP[0].Stair_shafts__c * 1.5);   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC384'){
                  ItemSqFt = dblFinished_Site ; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC385'){
                  ItemSqFt = Math.Min((dblFootprint_Area * 0.5),dblFinished_Site);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC386'){
                  ItemSqFt = Math.Min(dblFootprint_Area,(dblFinished_Site - (Math.Min((dblFootprint_Area * 0.5),dblFinished_Site)))); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC387'){
                  ItemSqFt = Math.Max((dblFinished_Site - Math.Min((dblFootprint_Area * 0.5),dblFinished_Site) - Math.Min(dblFootprint_Area,(dblFinished_Site - Math.Min((dblFootprint_Area * 0.5),dblFinished_Site)))),0);
            }else if (setAssignCustom90.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  ItemSqFt = listhp[0].Conditioned_Core_Area__c ;   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC301'){
                  ItemSqFt = Math.Round(listhp[0].Conditioned_Core_Area__c/500);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC299' && dblGrossSqFt > 30000){
                    ItemSqFt = listhp[0].Conditioned_Core_Area__c;
            }else if (setAssignCustom93.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && btypenum == 6){
                  ItemSqFt = - dblGrossSqFt;        
            }else if (setAssignCustom94.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && btypenum == 6){
                  ItemSqFt = -(listhp[0].Total_USF__c);     
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC263' && btypenum != 0){
                    ItemSqFt = listhp[0].Total_USF__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC354' && btypenum != 6 && (ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){
                    ItemSqFt = Math.Round(listhp[0].Total_USF__c/80);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00403' && btypenum != 6 && (ncmtrec.Building_Quality__c == 'Class A' || ncmtrec.Building_Quality__c == 'Code Minimum')){
                    ItemSqFt = Math.Round(listhp[0].Total_USF__c/80);                   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC178' && btypenum < 3){
                    ItemSqFt = Math.Min((Math.Ceil(dblGrossSqFt/100000)+1),4);
            }else if (setAssignCustom98.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  if(btypenum == 6){
                       mainentrydoors = (dblGrossSqFt/250000);   
                  }     
                  else if ((listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c)< 4){
                      mainentrydoors = (dblGrossSqFt/40000);
                  } 
                  else{
                      mainentrydoors = (dblGrossSqFt/80000);
                  } 
                  if(btypenum > 3){
                    powerrevolvingdoors = 0;     
                  }     
                  else{
                    powerrevolvingdoors = Math.Min(Math.Round(dblGrossSqFt/100000)+1,4);
                  } 
                  ItemSqFt= Math.Max(2,Math.Ceil(mainentrydoors)) - powerrevolvingdoors;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC181'){
                  if(btypenum == 6){
                    ItemSqFt = Math.ceil(dblGrossSqFt/50000);    
                  }     
                  else if(dblGrossSqFt < 50000){
                    ItemSqFt = 0;
                  } 
                  else{
                    ItemSqFt = Math.ceil(dblGrossSqFt/200000);
                  } 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC325' && btypenum == 6 && dblGrossSqFt > 30000){
                      ItemSqFt = - dblGrossSqFt; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC326' && btypenum == 6 && dblGrossSqFt > 30000){
                      ItemSqFt = - (listhp[0].Total_USF__c); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC327' && btypenum == 6){
                      ItemSqFt = - (Math.Round(listhp[0].Total_USF__c/600)); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC331' && btypenum == 6){
                        ItemSqFt = -listhp[0].Enclosed_Parking__c; 
            }else if (setAssignCustom104.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = listhp[0].Enclosed_Parking__c;   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC248'){
                    ItemSqFt = Math.Round(listhp[0].Enclosed_Parking__c * 0.3); 
            }else if (setAssignCustom106.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = listhp[0].Total_USF__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC300' && dblGrossSqFt > 30000){
                    ItemSqFt = listhp[0].Total_USF__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC302'){
                    ItemSqFt = Math.Round(listhp[0].Total_USF__c/600);      
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC49'){
                    ItemSqFt = Math.Round(dblGrossSqFt * SLPMap.get('Shearwall_factor'));   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC50'){
                    ItemSqFt = Math.Round(dblGrossSqFt * SLPMap.get('Shearwall_factor')) * 2;   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC52'){
                    ItemSqFt = roundofneg((Math.Round(dblGrossSqFt * SLPMap.get('Shearwall_factor'))) * (ncmtrec.Building_Height_Parameter__r.SW_thickness__c/12)/27,-1);       
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC51'){
                    ItemSqFt = roundofneg((Math.Round(dblGrossSqFt * SLPMap.get('Shearwall_factor'))) * (ncmtrec.Building_Height_Parameter__r.SW_thickness__c/12)/27,-1) * SLPMap.get('Shearwall_reinf');   
            }else if (setAssignCustom113.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = Math.Round(dblGrossSqFt * SLPMap.get('Misc_steel')); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC10'){
                    ItemSqFt = Math.Round(BuildingPerimeter);   
            }else if (setAssignCustom115.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = totalcolumncount;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC3'){
                    ItemSqFt = roundofneg(totalcolumncount * Overexcavateforlayback/27,-2); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC5'){
                    ItemSqFt = roundofneg(totalcolumncount * OverexcavationforFtgdepth/27,-2);  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC8'){
                    ItemSqFt = roundofneg(totalcolumncount * ((areaofcolumnbase * 3)+(OverexcavationforFtgdepth*0.33))/27,-2);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC2'){
                    ItemSqFt = roundofneg(totalcolumncount * Overexcavateforlayback/27,-2) + roundofneg(totalcolumncount * OverexcavationforFtgdepth/27,-2) + roundofneg(totalcolumncount * ((areaofcolumnbase * 3)+(OverexcavationforFtgdepth*0.33))/27,-2);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC4'){
                    ItemSqFt = roundofneg(totalcolumncount * OverexcavationforFtgdepth/27,-2) + roundofneg(totalcolumncount * ((areaofcolumnbase * 3)+(OverexcavationforFtgdepth*0.33))/27,-2);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC6'){
                    ItemSqFt = Math.Round(totalcolumncount * 3 * 4 *squaredimension* 1.25); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC7'){
                    ItemSqFt = roundofneg(totalcolumncount * ((areaofcolumnbase * 3)+(OverexcavationforFtgdepth*0.33))/27,-2) * SLPMap.get('Fnd_Rebar');    
            }else if (setAssignCustom123.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = roundofneg((Overexcavateforlayback1+OverexcavationforFtgdepth1),-2); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC16'){
                    ItemSqFt = roundofneg(Math.Round(BuildingPerimeter)*4*2/27,-1); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC11'){
                     ItemSqFt = roundofneg((Overexcavateforlayback1+OverexcavationforFtgdepth1),-2) + roundofneg(Math.Round(BuildingPerimeter)*4*2/27,-1);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC14'){
                    ItemSqFt = Math.Round(BuildingPerimeter) *2*3;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC15'){
                    ItemSqFt = roundofneg(Math.Round(BuildingPerimeter)*4*2/27,-1) * SLPMap.get('Foundation Rebar');    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC19' && ncmtrec.Building_Height_Parameter__r.Pile_Y_N__c == True){
                     ItemSqFt = totalcolumncount*typicalpilelength;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC22'){
                    ItemSqFt = roundofneg(dblFootprint_Area * (SLPMap.get('SOG_subbase')/12)/27,-1);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC24'){
                    ItemSqFt = dblFootprint_Area * SLPMap.get('SOG_reinf');
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC25'){
                    ItemSqFt = roundofneg(dblFootprint_Area * (SLPMap.get('SOG_thick')/12)/27,-1); 
             }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC28'){
                    ItemSqFt = dblSumDefault_Area_SF;   
            }else if (setAssignCustom133.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = Math.round(dblSumDefault_Area_SF * (listplp[0].Average_Story_Height__c+2)/27);   
            }else if (setAssignCustom134.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = Math.round(dblGrossSqFt/averagecolumnarea) * listplp[0].Average_Story_Height__c; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC46'){
                    ItemSqFt = Math.round(dblGrossSqFt/averagecolumnarea) * listplp[0].Average_Story_Height__c * ncmtrec.Building_Height_Parameter__r.Col_fmk__c;       
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC48'){
                    ItemSqFt = Math.round(Math.round(dblGrossSqFt/averagecolumnarea) * listplp[0].Average_Story_Height__c * ncmtrec.Building_Height_Parameter__r.Col_C_S__c/27);    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC47'){
                    ItemSqFt = Math.round(Math.round(dblGrossSqFt/averagecolumnarea) * listplp[0].Average_Story_Height__c * ncmtrec.Building_Height_Parameter__r.Col_C_S__c/27) * SLPMap.get('Col_reinf');
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC53'){
                    ItemSqFt = Math.Round(((dblGrossSqFt - dblFootprint_Area)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1);   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC54'){
                    ItemSqFt = Math.Round(((dblGrossSqFt - dblFootprint_Area)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1) * ncmtrec.Building_Height_Parameter__r.Beam_fmk__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC56'){
                    ItemSqFt = Math.Round(((dblGrossSqFt - dblFootprint_Area)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1 * ncmtrec.Building_Height_Parameter__r.Beam_C_S__c/27);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC55'){
                    ItemSqFt = Math.Round(((dblGrossSqFt - dblFootprint_Area)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1 * ncmtrec.Building_Height_Parameter__r.Beam_C_S__c/27) * SLPMap.get('Beam_reinf');
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC59'){
                ItemSqFt = (dblGrossSqFt-dblFootprint_Area) * SLPMap.get('Slab_reinf'); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC60'){
                ItemSqFt = roundofneg((dblGrossSqFt-dblFootprint_Area) * (ncmtrec.Building_Height_Parameter__r.Slab_Thickness__c/12)/27,-1);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC73'){
                ItemSqFt = Math.Round(listPLP[0].Sloped_Roof_SF__c * 12/2000) ;         
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC76'){
                ItemSqFt = Math.Round(((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1);   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC77'){
                ItemSqFt = Math.Round(((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1) * ncmtrec.Building_Height_Parameter__r.Beam_fmk__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC79'){
                ItemSqFt = Math.Round(((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1 * ncmtrec.Building_Height_Parameter__r.Beam_C_S__c/27);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC78'){
                ItemSqFt = Math.Round(((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1 * ncmtrec.Building_Height_Parameter__r.Beam_C_S__c/27)* SLPMap.get('Beam_reinf');
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC82'){
                ItemSqFt = (listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c) * SLPMap.get('Slab_reinf');
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC83'){
                ItemSqFt = roundofneg((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c) * (ncmtrec.Building_Height_Parameter__r.Slab_Thickness__c/12)/27,-1);  
            }else if (setAssignCustom151.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt =Math.Round(dblGrossSqFt*ncmtrec.Building_Height_Parameter__r.Columns__c/2000);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC88'){
                ItemSqFt =Math.Round(dblGrossSqFt*ncmtrec.Building_Height_Parameter__r.Bracing__c/2000);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC89'){
                ItemSqFt =Math.Round(dblGrossSqFt*ncmtrec.Building_Height_Parameter__r.Columns__c/2000) * ncmtrec.Building_Height_Parameter__r.Steel_FP__c * 80;
            }else if (setAssignCustom154.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = Math.Round((dblGrossSqFt-dblFootprint_Area)*ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC91'){
                ItemSqFt = Math.Round((dblGrossSqFt-dblFootprint_Area)*ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000)* ncmtrec.Building_Height_Parameter__r.Steel_FP__c * 90;
            }else if (setAssignCustom156.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = (dblGrossSqFt-dblFootprint_Area)* ncmtrec.Building_Height_Parameter__r.Deck_FP__c;   
            }else if (setAssignCustom157.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = Math.Round(listPLP[0].Flat_Roof_SF__c * (ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c-1)/2000);   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC99'){
                ItemSqFt = Math.Round(listPLP[0].Flat_Roof_SF__c * (ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c-1)/2000) * ncmtrec.Building_Height_Parameter__r.Steel_FP__c * 120;
            }else if (setAssignCustom159.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Flat_Roof_SF__c * ncmtrec.Building_Height_Parameter__r.Deck_FP__c;        
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC106'){
                ItemSqFt = Math.Round(listPLP[0].Sloped_Roof_SF__c * SLPMap.get('Steel_sloprf')/2000);  
            }else if (setAssignCustom161.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = Math.Round((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)*ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC110'){
                ItemSqFt = Math.Round((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)*ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000) * ncmtrec.Building_Height_Parameter__r.Steel_FP__c * 120;
            }else if (setAssignCustom163.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = (listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)* ncmtrec.Building_Height_Parameter__r.Deck_FP__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC118'){
                ItemSqFt =  Math.Round(dblGrossSqFt * 1); 
            }else if (setAssignCustom165.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                ItemSqFt = listPLP[0].Sloped_Roof_SF__c + listPLP[0].Green_Roof_SF__c + listPLP[0].Flat_Roof_SF__c+listPLP[0].Basement_Roof_SF__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC128'){
                ItemSqFt = Math.Round((listPLP[0].Sloped_Roof_SF__c + listPLP[0].Green_Roof_SF__c + listPLP[0].Flat_Roof_SF__c+listPLP[0].Basement_Roof_SF__c)*6/2000);             
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC135'){
                ItemSqFt = Math.Round((dblGrossSqFt-dblFootprint_Area)*ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000) * 0 * 90;          
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC143'){
                ItemSqFt = Math.Round(listPLP[0].Flat_Roof_SF__c * (ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c-1)/2000) * 0 * 120; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC150'){
                ItemSqFt = Math.Round(listPLP[0].Sloped_Roof_SF__c * 6/2000);   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC154'){
                ItemSqFt = Math.Round((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)*ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000) * 0 * 120;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC169'){
                    ItemSqFt = BuildingPerimeter * 2;
            }else if (setAssignCustom172.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = Math.Round((listPLP[0].Plumbing_Fixtures_EA__c - ((listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c)* 3))*0.45);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC270'){
                    ItemSqFt =  listPLP[0].Plumbing_Fixtures_EA__c  - ((listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c)*3) - (Math.Round((listPLP[0].Plumbing_Fixtures_EA__c - ((listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c)* 3))*0.45)* 2);
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC277' && (ProjectRecordTypeName == 'Laboratory: Dry'  || ProjectRecordTypeName == 'Laboratory: Wet')){
                    ItemSqFt = Math.Round(ncmtrec.Gross_Area_w_o_parking_BGSF__c * 0.005)*1;
            }else if (setAssignCustom175.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && (ProjectRecordTypeName == 'Laboratory: Dry'  || ProjectRecordTypeName == 'Laboratory: Wet')){
                    ItemSqFt = ncmtrec.Gross_Area_w_o_parking_BGSF__c*1;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC320' && (ProjectRecordTypeName == 'Laboratory: Dry' || ProjectRecordTypeName == 'Laboratory: Wet')){
                    ItemSqFt = ncmtrec.Gross_Area_w_o_parking_BGSF__c * 1;    
            }else if (setAssignCustom176.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                  if(ProjectRecordTypeName == 'Laboratory: Dry'){
                    ItemSqFt = ncmtrec.Gross_Area_w_o_parking_BGSF__c * 1 * 0.3;
                  }
                  else if(ProjectRecordTypeName == 'Laboratory: Wet'){
                    ItemSqFt = ncmtrec.Gross_Area_w_o_parking_BGSF__c * 1 * 1;
                  } 
                  else{
                    ItemSqFt = 0;
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC282'){
                if(ProjectRecordTypeName == 'Laboratory: Dry')
                    ItemSqFt = Math.Round(ncmtrec.Gross_Area_w_o_parking_BGSF__c * 0.1)*1*0.3;  
                else if(ProjectRecordTypeName == 'Laboratory: Wet')  
                    ItemSqFt = Math.Round(ncmtrec.Gross_Area_w_o_parking_BGSF__c * 0.1)*1*1;  
                else{
                    ItemSqFt = 0;
                  }                     
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC284'){
                if(ProjectRecordTypeName == 'Laboratory: Dry')
                    ItemSqFt = Math.Round(ncmtrec.Gross_Area_w_o_parking_BGSF__c * 0.02)*1*0.3;
                else if(ProjectRecordTypeName == 'Laboratory: Wet')  
                    ItemSqFt = Math.Round(ncmtrec.Gross_Area_w_o_parking_BGSF__c * 0.02)*1*1;
                else{
                    ItemSqFt = 0;
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC288'){
                  if(ProjectRecordTypeName == 'Laboratory: Dry'){
                    ItemSqFt = Math.Round(ncmtrec.Gross_Area_w_o_parking_BGSF__c * 0.02)*1*0.3*0.3;
                  }
                  else if(ProjectRecordTypeName == 'Laboratory: Wet'){  
                    ItemSqFt = Math.Round(ncmtrec.Gross_Area_w_o_parking_BGSF__c * 0.02)*1*1*1;
                  }
                  else{
                    ItemSqFt = 0;
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC310' && (ProjectRecordTypeName == 'Laboratory: Dry'  || ProjectRecordTypeName == 'Laboratory: Wet')){
                    ItemSqFt = - Math.Round(listplp[0].HVAC_Air_Handling_Capacity_CFM__c *0.3)*1;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC311' && (ProjectRecordTypeName == 'Laboratory: Dry'  || ProjectRecordTypeName == 'Laboratory: Wet')){
                    ItemSqFt = - listplp[0].HVAC_Air_Handling_Capacity_CFM__c*1;    
            }else if ((objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC312') && (ProjectRecordTypeName == 'Laboratory: Dry'  || ProjectRecordTypeName == 'Laboratory: Wet')){
                    ItemSqFt =  listplp[0].HVAC_Air_Handling_Capacity_CFM__c*1;                     
            }else if (setAssignCustom182.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && (ProjectRecordTypeName == 'Laboratory: Dry'  || ProjectRecordTypeName == 'Laboratory: Wet')){
                    ItemSqFt = listplp[0].HVAC_Air_Handling_Capacity_CFM__c*1*1;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC366' && (ProjectRecordTypeName == 'Laboratory: Dry'  || ProjectRecordTypeName == 'Laboratory: Wet')){
                    ItemSqFt = ncmtrec.Gross_Area_w_o_parking_BGSF__c*1/900;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC296'){
                  if(ProjectRecordTypeName == 'Laboratory: Dry'){
                        ItemSqFt = Math.Round(listhp[0].Conditioned_Core_Area__c * (0.5+0.7));
                  } 
                  else if(ProjectRecordTypeName == 'Laboratory: Wet'){
                        ItemSqFt = Math.Round(listhp[0].Conditioned_Core_Area__c * (1+0.7));
                  } 
                  else{
                        ItemSqFt = Math.Round(listhp[0].Conditioned_Core_Area__c * (0+0.7));
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC297'){
                  if(ProjectRecordTypeName == 'Laboratory: Dry'){
                        ItemSqFt = Math.Round(listhp[0].Total_USF__c * (0.5+0.7));  
                  } 
                  else if(ProjectRecordTypeName == 'Laboratory: Wet'){  
                        ItemSqFt = Math.Round(listhp[0].Total_USF__c * (1+0.7));
                  } 
                  else{
                        ItemSqFt = Math.Round(listhp[0].Total_USF__c * (0+0.7));
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00464' && (ProjectRecordTypeName == 'Medical Clinic' || ProjectRecordTypeName == 'Medical Office')){
                 /* if(ProjectRecordTypeName == 'Laboratory: Dry'){
                        ItemSqFt = (Math.round(dblGrossSqFt*0.3) + Math.Round(listhp[0].Conditioned_Core_Area__c * (0.5+0.7)) + Math.Round(listhp[0].Total_USF__c * (0.5+0.7))) * 0.5;
                  } 
                  else if(ProjectRecordTypeName == 'Laboratory: Wet'){
                        ItemSqFt = (Math.round(dblGrossSqFt*0.3) + Math.Round(listhp[0].Conditioned_Core_Area__c * (1+0.7)) + Math.Round(listhp[0].Total_USF__c * (1+0.7))) * 0.5;
                  } 
                  else{*/
                        ItemSqFt = (Math.round(dblGrossSqFt*0.3) + Math.Round(listhp[0].Conditioned_Core_Area__c * (0+0.7)) + Math.Round(listhp[0].Total_USF__c * (0+0.7))) * 0.5;
                  //}             
            }else if ((objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC315') && (ProjectRecordTypeName == 'Laboratory: Dry'  || ProjectRecordTypeName == 'Laboratory: Wet')){
                        ItemSqFt = - Math.Round(listhp[0].Total_USF__c/600) * 1;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC316'){
                  if(ProjectRecordTypeName == 'Laboratory: Dry'){
                        ItemSqFt = Math.Ceil(listhp[0].Total_USF__c * 3/1000) * 1;  
                  } 
                  else if(ProjectRecordTypeName == 'Laboratory: Wet'){  
                        ItemSqFt = Math.Ceil(listhp[0].Total_USF__c * 5/1000) * 1;
                  } 
                  else{
                     ItemSqFt = 0;
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC317'){
                  if(ProjectRecordTypeName == 'Laboratory: Dry'){
                        ItemSqFt = Math.Ceil(listhp[0].Total_USF__c * 3/1000) * 2 / 3;  
                  } 
                  else if(ProjectRecordTypeName == 'Laboratory: Wet'){  
                        ItemSqFt = Math.Ceil(listhp[0].Total_USF__c * 5/1000) * 2 / 5;
                  } 
                  else{
                     ItemSqFt = 0;
                  }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC318'){
                  if(ProjectRecordTypeName == 'Laboratory: Dry'){   
                        ItemSqFt = Math.Round((Math.round(dblGrossSqFt*0.3)+ Math.Round(listhp[0].Conditioned_Core_Area__c * (0.5+0.7))+Math.Round(listhp[0].Total_USF__c * (0.5+0.7)))*0.5) * 1* 0.3;
                  } 
                  else if (ProjectRecordTypeName == 'Laboratory: Wet'){
                        ItemSqFt = Math.Round((Math.round(dblGrossSqFt*0.3)+ Math.Round(listhp[0].Conditioned_Core_Area__c * (1+0.7))+Math.Round(listhp[0].Conditioned_Core_Area__c * (1+0.7)))*0.5) *1 * 1;
                  }
                  else{
                     ItemSqFt = 0;
                  }  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC324' && btypenum == 6){ 
                     ItemSqFt = - (Math.Round(listhp[0].Total_USF__c * 0.7));
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC344'){  
                    ItemSqFt = Math.Max((listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c+1),Math.Ceil(dblGrossSqFt/25000));  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC355'){  
                    ItemSqFt = Math.Max(((listPLP[0].Above_Ground__c + listPLP[0].Below_Ground__c)*2),Math.Ceil(dblGrossSqFt/15000));   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC252'){  
                    ItemSqFt =  totalcolumnsareaanalysis * listplp[0].Average_Story_Height__c * 8;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC350' && (ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){
                    ItemSqFt = listhp[0].Enclosed_Parking__c;   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00399' && (ncmtrec.Building_Quality__c == 'Class A' || ncmtrec.Building_Quality__c == 'Code Minimum')){
                    ItemSqFt = listhp[0].Enclosed_Parking__c;   
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC351' && (ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){
                  ItemSqFt = listHP[0].Mechanical_Electrical_IT__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00400'  && (ncmtrec.Building_Quality__c == 'Class A' || ncmtrec.Building_Quality__c == 'Code Minimum')){
                  ItemSqFt = listHP[0].Mechanical_Electrical_IT__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC352' && (ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){
                  ItemSqFt = listHP[0].Loading_dock_Recycling_Trash__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00401'  && (ncmtrec.Building_Quality__c == 'Class A' || ncmtrec.Building_Quality__c == 'Code Minimum')){
                  ItemSqFt = listHP[0].Loading_dock_Recycling_Trash__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC353' && (ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){
                  ItemSqFt = listHP[0].Stair_shafts__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00402' && (ncmtrec.Building_Quality__c == 'Class A' || ncmtrec.Building_Quality__c == 'Code Minimum')){
                  ItemSqFt = listHP[0].Stair_shafts__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC345' && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00404' && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00405' && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00406' && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC346' && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00407' && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00408' && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00409' && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC347' && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00410' && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00411' && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00412' && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC192' && (listplp[0].Primary_Roof_Type__c == 'Flat' || listplp[0].Primary_Roof_Type__c == 'Mansard' || listplp[0].Primary_Roof_Type__c == 'Green' ||listplp[0].Primary_Roof_Type__c == 'Sloped, Metal')){
                ItemSqFt = listPLP[0].Sloped_Roof_SF__c;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00413' && listplp[0].Primary_Roof_Type__c == 'Sloped, Tile'){
                ItemSqFt = listPLP[0].Sloped_Roof_SF__c;            
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC175'){
                if(listplp[0].Cladding_Quality__c == 'High'){
                    ItemSqFt = listPLP[0].Curtain_Wall_Percentage_SF__c ;
                }else{
                    ItemSqFt = 0;
                }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00414'){
                if( listplp[0].Cladding_Quality__c == 'Very High'){
                    ItemSqFt = listPLP[0].Curtain_Wall_Percentage_SF__c ;
                }else{
                    ItemSqFt = 0;
                }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00415'){
                if(listplp[0].Cladding_Quality__c == 'Mid-Level'){
                     ItemSqFt = listPLP[0].Curtain_Wall_Percentage_SF__c ;
                }else{
                     ItemSqFt =0;
                }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00416'){ 
                if(listplp[0].Cladding_Quality__c == 'Basic'){
                    ItemSqFt = listPLP[0].Curtain_Wall_Percentage_SF__c ;
                }else{
                    ItemSqFt = 0;
                }
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC177' && (listplp[0].Cladding_Quality__c == 'High')){
                    ItemSqFt = listPLP[0].Window_Percentage_SF__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00417' && (listplp[0].Cladding_Quality__c == 'Very High')){
                    ItemSqFt = listPLP[0].Window_Percentage_SF__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00418' && (listplp[0].Cladding_Quality__c == 'Mid-Level')){
                    ItemSqFt = listPLP[0].Window_Percentage_SF__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00419' && (listplp[0].Cladding_Quality__c == 'Basic')){
                    ItemSqFt = listPLP[0].Window_Percentage_SF__c ; 
            }else if (setAssignCustom266.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c;  
            }else if (setAssignCustom267.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c;  
            }else if (setAssignCustom268.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c;  
            }else if (setAssignCustom269.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c;  
            }else if (setAssignCustom270.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c; 
            }else if (setAssignCustom271.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c; 
            }else if (setAssignCustom272.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c; 
            }else if (setAssignCustom273.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = listHP[0].Ground_floor_circulation__c; 
            }else if (setAssignCustom274.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;    
            }else if (setAssignCustom275.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;    
            }else if (setAssignCustom276.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;    
            }else if (setAssignCustom277.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = listHP[0].Elevator_lobbies__c ;
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00429' && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = Math.round((listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c) * 0.75); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00430' && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = Math.round((listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c) * 0.75); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00431' && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = Math.round((listHP[0].Main_Lobby__c + listHP[0].Atrium_Ground_floor_plan_area__c) * 0.75); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC243' && listplp[0].Cladding_Quality__c == 'High'){
                  ItemSqFt = 4 * Math.Sqrt(listHP[0].Atrium_Ground_floor_plan_area__c) * listplp[0].Atrium_Phantom_Floors__c * listplp[0].Average_Story_Height__c; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00432' && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = 4 * Math.Sqrt(listHP[0].Atrium_Ground_floor_plan_area__c) * listplp[0].Atrium_Phantom_Floors__c * listplp[0].Average_Story_Height__c; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00433' && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = 4 * Math.Sqrt(listHP[0].Atrium_Ground_floor_plan_area__c) * listplp[0].Atrium_Phantom_Floors__c * listplp[0].Average_Story_Height__c; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00434' && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = 4 * Math.Sqrt(listHP[0].Atrium_Ground_floor_plan_area__c) * listplp[0].Atrium_Phantom_Floors__c * listplp[0].Average_Story_Height__c;  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00435' && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = Math.Round(listHP[0].Ground_floor_circulation__c * 2); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00436' && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = Math.Round(listHP[0].Ground_floor_circulation__c * 2); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00437' && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = Math.Round(listHP[0].Ground_floor_circulation__c * 2);     
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00438' && listplp[0].Cladding_Quality__c == 'Very High'){
                  ItemSqFt = Math.Round(listHP[0].Elevator_lobbies__c * 2); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00439' && listplp[0].Cladding_Quality__c == 'Mid-Level'){
                  ItemSqFt = Math.Round(listHP[0].Elevator_lobbies__c * 2); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00440' && listplp[0].Cladding_Quality__c == 'Basic'){
                  ItemSqFt = Math.Round(listHP[0].Elevator_lobbies__c * 2); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00463' && (ProjectRecordTypeName == 'Medical Clinic' || ProjectRecordTypeName == 'Medical Office')){
                  ItemSqFt = Math.Round(listPLP[0].HVAC_Air_Handling_Capacity_CFM__c * 0.3); 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00465' && (ProjectRecordTypeName == 'Medical Clinic' || ProjectRecordTypeName == 'Medical Office')){
                ItemSqFt = dblGrossSqFt;     
            } else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00466' && (dblGrossSqFt > 30000) && (ProjectRecordTypeName == 'Data Center')){
                ItemSqFt = dblGrossSqFt;        
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00467' && (ProjectRecordTypeName == 'Data Center')){
                  ItemSqFt = - Math.Round(listPLP[0].HVAC_Air_Handling_Capacity_CFM__c * 0.3);  
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00468' && (ProjectRecordTypeName == 'Data Center')){
                  ItemSqFt = - listPLP[0].HVAC_Air_Handling_Capacity_CFM__c; 
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00469' && (ProjectRecordTypeName == 'Data Center')){
                  ItemSqFt = listPLP[0].HVAC_Air_Handling_Capacity_CFM__c;          
            }else if (setAssignCustom279.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && (ProjectRecordTypeName == 'Data Center') ){
                  ItemSqFt = Math.Round(listPLP[0].Electrical_Load_kW__c * 0.25) * 3;     
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00474' && (ProjectRecordTypeName == 'Data Center')){
                  ItemSqFt = Math.Round(listPLP[0].Electrical_Load_kW__c * 0.25) * 3 * 0.25;
            } else if (setAssignCustom280.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && (ProjectRecordTypeName == 'Data Center')){
                ItemSqFt = dblGrossSqFt;    
            }else if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00477' && (ProjectRecordTypeName == 'Data Center')){
                  ItemSqFt = listPLP[0].Electrical_Load_kW__c;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
            }else { 
                ItemSqFt = 0;
            }
            
         
            if (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC9'){
                
                objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                    Core_Shell_Cost_Parameter__c = objRecord.ID,
                    Total_Units__c = ItemSqFt,
                    Applicable_Cost__c = RAModsPercent,
                    Unit_Cost__c = ncmtrec.Building_Height_Parameter__r.Anchor_Bolts__c,
                    TCO_Project_Cost_Rate__c = projCRID,
                    TCO_Performance_Input__c = PerfIpID
                ));
            }
            else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC172'){
                
                integer buildingsizefactor= Math.Min(Math.Round(dblGrossSqFt/100000)+1,4);
                if (buildingsizefactor == 2)
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                    Core_Shell_Cost_Parameter__c = objRecord.ID,
                    Total_Units__c = ItemSqFt,
                    Applicable_Cost__c = RAModsPercent,
                    Unit_Cost__c = ncmtrec.Building_Height_Parameter__r.Small_Canopy__c,
                    TCO_Project_Cost_Rate__c = projCRID,
                    TCO_Performance_Input__c = PerfIpID
                ));
                else if(buildingsizefactor == 3){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                    Core_Shell_Cost_Parameter__c = objRecord.ID,
                    Total_Units__c = ItemSqFt,
                    Applicable_Cost__c = RAModsPercent,
                    Unit_Cost__c = ncmtrec.Building_Height_Parameter__r.Mid_Canopy__c,
                    TCO_Project_Cost_Rate__c = projCRID,
                    TCO_Performance_Input__c = PerfIpID
                ));
                }
                else if(buildingsizefactor == 4){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                    Core_Shell_Cost_Parameter__c = objRecord.ID,
                    Total_Units__c = ItemSqFt,
                    Applicable_Cost__c = RAModsPercent,
                    Unit_Cost__c = ncmtrec.Building_Height_Parameter__r.Large_Canopy__c,
                    TCO_Project_Cost_Rate__c = projCRID,
                    TCO_Performance_Input__c = PerfIpID
                ));
                }
            } 
            else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC164'){
                if((ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = listQcp[0].Base__c,
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
                }
                else{
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = listQcp[0].Base__c * 0.85,
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
                }
            }
            else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC165'){
                if((ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = listQcp[0].Mid__c,
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
                }
                else{
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = listQcp[0].Mid__c * 0.85,
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
                }
            }
            else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC166'){
                if((ncmtrec.Building_Quality__c == 'P100: Monumental' || ncmtrec.Building_Quality__c == 'P100: Landmark' || ncmtrec.Building_Quality__c == 'P100: Baseline' )){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = listQcp[0].Top__c,
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
                }
                else{
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = listQcp[0].Top__c * 0.85,
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
                }
            }
            else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC169'){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = Math.Round(listQcp[0].Mid__c/2),
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
            }
            else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC170'){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = Math.Round(listQcp[0].Mid__c * 1.2),
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
            }
            else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC171'){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = Math.Round(listQcp[0].Base__c * 1.75),
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
            }
            else if((objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC345' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00404' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00405' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00406')
                     || (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC346' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00407' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00408' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00409') 
                     || (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC347' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00410' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00411' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00412') 
                     || (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC305')
                     || (objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-00465')
                     && (ncmtrec.Building_Quality__c == 'Class A' || ncmtrec.Building_Quality__c == 'Code Minimum')){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick) * 0.85,
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
            }   
            else if((objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC278' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC279' || objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC280') && (dblGrossSqFt > 100000)){
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick) / 2,
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
            }                                       
            else{
        
                objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                    Core_Shell_Cost_Parameter__c = objRecord.ID,
                    Total_Units__c = ItemSqFt,
                    Applicable_Cost__c = RAModsPercent,
                    Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick),
                    TCO_Project_Cost_Rate__c = projCRID,
                    TCO_Performance_Input__c = PerfIpID
                ));
                
            }
        }
            else if(ncmtrec.Building_Cost_Type__c == 'TI Including Warm Lit Shell' || ncmtrec.Building_Cost_Type__c == 'TI Retrofit'){
                if(setAssignCustom278.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                    ItemSqFt = listhp[0].Total_USF__c;
                }else{
                    ItemSqFt = 0;
                }
                    objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                        Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                        Core_Shell_Cost_Parameter__c = objRecord.ID,
                        Total_Units__c = ItemSqFt,
                        Applicable_Cost__c = RAModsPercent,
                        Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick),
                        TCO_Project_Cost_Rate__c = projCRID,
                        TCO_Performance_Input__c = PerfIpID
                    ));
            }
                }
            catch (Exception e) {
                ItemSqFt = 0;
                
                objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                    Core_Shell_Cost_Parameter__c = objRecord.ID,
                    Total_Units__c = ItemSqFt,
                    Applicable_Cost__c = RAModsPercent,
                    Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick),
                    TCO_Project_Cost_Rate__c = projCRID,
                    TCO_Performance_Input__c = PerfIpID
                ));
            }    
         }
        
        insert objProjectCoreShellDetailRecords;
    }
    
    
    
    public void DeleteCoreShellData (ID ProjectID) {
        List <NCMT_Core_Shell_Cost_Detail__c> lstDelete = [select ID from NCMT_Core_Shell_Cost_Detail__c Where Project_Cost_Summary__r.Project_Name__r.Id = :ProjectID limit 50000] ;
        if(lstDelete.size() > 0) Delete lstDelete;
    }
    
    
    

    public void GenerateHousingPlanData (ID ProjectID, Boolean blnGrossArea, Boolean blnUseableArea, String strProjectType, Boolean blndefaultHousingPlan){
        String  strRecordTypeID;
        IF (blnGrossArea == True || blnUseableArea == True || blndefaultHousingPlan == True ) {
            strRecordTypeID = Schema.SObjectType.NCMT_Housing_Plan__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        }
        ELSE {
            strRecordTypeID = Schema.SObjectType.NCMT_Housing_Plan__c.getRecordTypeInfosByName().get('User Defined').getRecordTypeId();
        }
        /*
        //insert Housing Plan to be removed/commented
        List<NCMT_Housing_Plan__c> objHousingPlanRecords = New List<NCMT_Housing_Plan__c>();

        objHousingPlanRecords.Add(new NCMT_Housing_Plan__c(
            Project__c = ProjectID,
            RecordTypeID = strRecordTypeID
        ));
        
        insert objHousingPlanRecords;
        */
        //insert Housing Plan Summary record
        List<NCMT_Housing_Plan_Summary__c> objHousingPlanSummaryRecords = New List<NCMT_Housing_Plan_Summary__c>();

        objHousingPlanSummaryRecords.Add(new NCMT_Housing_Plan_Summary__c(
            Project__c = ProjectID
        ));
        
        insert objHousingPlanSummaryRecords;
        
    }
    public static Boolean plpGenerated = false; 

    public void GeneratePLPData (ID ProjectID, String strProjectRecordTypeName, String strProjectType, String ProjRecordTypeName){
        String  strRecordTypeID;
        //if (!plpGenerated){
            plpGenerated = true;
            //if (strProjectRecordType == Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId()){
            if (strProjectRecordTypeName == 'Parking Garage' && strProjectType == 'New Construction'){
                strRecordTypeID = Schema.SObjectType.Project_Level_Parameter__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId();
            } 
            else if (strProjectType == 'New Construction' && strProjectRecordTypeName != 'Parking Garage'){
                strRecordTypeID = Schema.SObjectType.Project_Level_Parameter__c.getRecordTypeInfosByName().get('Other Building Use').getRecordTypeId();
            }
            else if(strProjectType == 'Repair & Alteration - Parametric Entry' || strProjectType == 'Repair & Alteration - Work Item Detail'){
                strRecordTypeID = Schema.SObjectType.Project_Level_Parameter__c.getRecordTypeInfosByName().get('Repair & Alteration').getRecordTypeId();
            }
            if(ProjRecordTypeName == 'New Construction - TCO'){
                //system.debug('ProjRecordTypeName==='+ProjRecordTypeName);
                strRecordTypeID = Schema.SObjectType.Project_Level_Parameter__c.getRecordTypeInfosByName().get('New Construction - TCO').getRecordTypeId();
            }
            //system.debug('ProjRecordTypeName==='+ProjRecordTypeName);
            
            projParam = new Project_Level_Parameter__c(
                NCMT_Project__c = ProjectID,
                RecordTypeID = strRecordTypeID
            );
            
            insert projParam;
        //}
    }   
    public static Project_Level_Parameter__c projParam;
    
    public void UpdatePLPData(ID ProjectID) {
        
        if (projParam == null) 
            projParam = [SELECT Id FROM Project_Level_Parameter__c WHERE NCMT_Project__c = :ProjectID ];
        
        update projParam;
    
    }
    
    public void GenerateLPOESpacePlanData (ID ProjectID, String strProjectRecordTypeName, String strProjectType){
        
        List<LPOE_Space_Plan__c> objLPOESpacePlanRecords = New List<LPOE_Space_Plan__c>();

        objLPOESpacePlanRecords.Add(new LPOE_Space_Plan__c(
            Project_Name__c = ProjectID
        ));
        
        insert objLPOESpacePlanRecords;
        
    }

    public void GenerateSiteInfoData(ID ProjectID, String strProjectRecordTypeName, Decimal SurfaceParking, Decimal StandaloneParking, boolean Housing_Plan, String stroverride, Decimal dblOverride_Calculated_Site_Area) {
        Decimal Parking_Garage_Gross_Area_SF;
        Decimal At_and_above_grade;
        Decimal Below_grade;
        Decimal Gross_Building_Area;
        Decimal Footprint_Area;
        Decimal GF_Perimeter;
        Decimal Perimeter_LF;
        Decimal Perimeter_area_SF;
        Decimal Total_Minimum_Overall_Site_Area_demand;
        Decimal FAR;
        Decimal Offset; 
        Integer Level_of_Protection;
        Decimal Site_Area_based_on_FAR;
        Decimal Site_Area_for_Default_Value;
        Decimal Finished_Site;
        
        ID PLPID;       
        Decimal Total_GSF;  
        Decimal Based_on_damped_Cladding_Ratio; 
        Decimal Change_Setback_100;
        Decimal Adj_LOP_Setback;    
        Decimal Over_percentage_of_Perimeter;
        Decimal Adjusted_Area_required; 
        Decimal Base_Area_required; 
        Decimal Corners_Area_Required;
        Adjusted_Area_required = 0;
        Base_Area_required = 0;
        Corners_Area_Required = 0;
        
        List <NCMT_Project__c> ProjList = [SELECT Parking_Garage_Gross_Area_SF__c, At_and_above_grade__c, Below_grade__c, Level_of_Protection__c, Remoteness__c 
                                            ,Building_Height_Parameter__r.CBD__c, Building_Height_Parameter__r.Urban__c ,Building_Height_Parameter__r.Suburban__c 
                                            ,Building_Height_Parameter__r.Rural__c, Building_Height_Parameter__r.Remote__c, Building_Height_Parameter__r.Very_Remote__c                                          
                                            FROM NCMT_Project__c where Id = :ProjectID ];
        
        For (NCMT_Project__c objProj : ProjList ){
            Parking_Garage_Gross_Area_SF = objProj.Parking_Garage_Gross_Area_SF__c;
            At_and_above_grade = objProj.At_and_above_grade__c;
            Below_grade = objProj.Below_grade__c;
            //Offset
            IF (objProj.Remoteness__c == 'Central Business District') {
                Offset = 3;
            }
            ELSE IF (objProj.Remoteness__c == 'Urban') {
                Offset = 7;
            }
            ELSE IF (objProj.Remoteness__c == 'Suburban') {
                Offset = 5;
            }
            ELSE IF (objProj.Remoteness__c == 'Rural') {
                Offset = 3;
            }
            ELSE IF (objProj.Remoteness__c == 'Remote') {
                Offset = 3;
            }
            ELSE IF (objProj.Remoteness__c == 'Very Remote') {
                Offset = 8;
            }
            IF (Offset == 3) {
                FAR = objProj.Building_Height_Parameter__r.CBD__c;
            }   
            ELSE IF (Offset == 7) {
                FAR = objProj.Building_Height_Parameter__r.Remote__c;
            }   
            ELSE IF (Offset == 5) {
                FAR = objProj.Building_Height_Parameter__r.Suburban__c;
            }   
            ELSE IF (Offset == 8) {
                FAR = objProj.Building_Height_Parameter__r.Very_Remote__c;
            }   
            
            IF (objProj.Level_of_Protection__c == 'Level I - Minimum') {
                Level_of_Protection = 1;
            }
            ELSE IF (objProj.Level_of_Protection__c == 'Level II - Low') {
                Level_of_Protection = 2;
            }
            ELSE IF (objProj.Level_of_Protection__c == 'Level III - Medium') {
                Level_of_Protection = 3;
            }
            ELSE IF (objProj.Level_of_Protection__c == 'Level IV - High') {
                Level_of_Protection = 4;
            }
            ELSE IF (objProj.Level_of_Protection__c == 'Level V - Very High') {
                Level_of_Protection = 5;
            }
        }
            
        IF (strProjectRecordTypeName == 'Parking Garage') {         
            
            Gross_Building_Area = Parking_Garage_Gross_Area_SF;
            Footprint_Area = Gross_Building_Area / ( At_and_above_grade + Below_grade );
            GF_Perimeter = 0;
            //pending Perimeter LF to be round(-1)
            Perimeter_LF =  roundofneg(6 * ( MATH.SQRT ( Footprint_Area / 2 ) ),-1);             
            
            IF ( Perimeter_LF <> 0 ) { 
                Perimeter_area_SF = 8 * Perimeter_LF;   
            }
            ELSE {
                Perimeter_area_SF = 0;
            }
            Total_Minimum_Overall_Site_Area_demand = Footprint_Area + Perimeter_area_SF;
            IF (Gross_Building_Area <> 0 && FAR <> 0 ) {
                Site_Area_based_on_FAR = Gross_Building_Area / FAR;
            }
            //ELSE {
            //    Site_Area_based_on_FAR = 0;
            //} 
            Site_Area_for_Default_Value = MATH.MAX( Total_Minimum_Overall_Site_Area_demand , MATH.MAX( Footprint_Area , Site_Area_based_on_FAR ) ); 
            Finished_Site = Site_Area_for_Default_Value - Footprint_Area;
            if (dblOverride_Calculated_Site_Area > Footprint_Area ) {
                Finished_Site = dblOverride_Calculated_Site_Area - Footprint_Area;
            }
            
            List<Site_Information__c> objSiteInfoRecords = New List<Site_Information__c>();

            objSiteInfoRecords.Add(new Site_Information__c(
            Project__c = ProjectID,
            Gross_Building_Area__c = Gross_Building_Area,
            Footprint_Area__c = Footprint_Area,
            GF_Perimeter__c = GF_Perimeter,
            Total_Direct_Site_Area__c = Footprint_Area,
            Perimeter_LF__c = Perimeter_LF,
            Perimeter_area_SF__c = Perimeter_area_SF,
            Total_Minimum_Overall_Site_Area_demand__c = Total_Minimum_Overall_Site_Area_demand,
            FAR__c = FAR,
            Site_Area_based_on_FAR__c = Site_Area_based_on_FAR,
            Site_Area_for_Default_Value__c = Site_Area_for_Default_Value,
            Finished_Site__c = Finished_Site
            ));

            insert objSiteInfoRecords;
                    
        } 
        ELSE {
            /*
            List <NCMT_Housing_Plan__c> HPList = [SELECT Total_GSF__c, Based_on_damped_Cladding_Ratio__c                                             
                                            FROM NCMT_Housing_Plan__c where Project__c = :ProjectID ];
                                                  
            For (NCMT_Housing_Plan__c objHP : HPList ){
                Total_GSF = objHP.Total_GSF__c;
                Based_on_damped_Cladding_Ratio = objHP.Based_on_damped_Cladding_Ratio__c;
            }
            */
            List <NCMT_Housing_Plan_Summary__c> HPList = [SELECT Total_GSF__c, Based_on_damped_Cladding_Ratio__c                                             
                                            FROM NCMT_Housing_Plan_Summary__c where Project__c = :ProjectID ];
                                                  
            For (NCMT_Housing_Plan_Summary__c objHP : HPList ){
                Total_GSF = objHP.Total_GSF__c;
                Based_on_damped_Cladding_Ratio = objHP.Based_on_damped_Cladding_Ratio__c;
            }
            Project_Level_Parameter__c PLP = [SELECT Id, Change_Setback_100__c, Adj_LOP_Setback__c, Over_percentage_of_Perimeter__c 
                                                FROM Project_Level_Parameter__c WHERE NCMT_Project__c = :ProjectID ];
            PLPID = ID.valueof(PLP.Id); 
            Change_Setback_100 = PLP.Change_Setback_100__c;
            Adj_LOP_Setback = PLP.Adj_LOP_Setback__c;
            Over_percentage_of_Perimeter = PLP.Over_percentage_of_Perimeter__c / 100;                   
            
            AggregateResult[] arMaxUseAreaSF = [SELECT MAX (Use_Area_SF__c ) MaxUseAreaSF
                                                                FROM NCMT_Building_Massing_By_Floor__c 
                                                                WHERE Proj_Level_Parameter__c = :PLPID
                                                                and Building_Massing_Area__c in ('Basement2 SF','Basement1 SF','Ground SF') ];
            Decimal dblMaxUse_Area_SF;
            Decimal Number_of_Stories_max;
            Decimal Optimize_stories;
            Decimal Floorplate;
            Decimal Add_perimeter_site;
            Decimal Structured_parking_Area_required;
            Decimal Total_Direct_Site_Area;
            Decimal Larger_of_FAR_or_Footprint;
            Decimal Total_Minimum_Overall_Site_Area_FAR;
            Decimal Add_Structured_parking;
            Add_Structured_parking = 0;
            For (AggregateResult ar : arMaxUseAreaSF) {
                dblMaxUse_Area_SF = (Decimal) ar.get('MaxUseAreaSF');
            }

            //IF (Housing_Plan != True) {
                //pending round of ROUND(G15*F15*E5,-2); also change Change_Setback_100 to adjusted setback 
                system.debug('Adj_LOP_Setback==='+ Adj_LOP_Setback);
                system.debug('Over_percentage_of_Perimeter==='+ Over_percentage_of_Perimeter);
                system.debug('Based_on_damped_Cladding_Ratio==='+ Based_on_damped_Cladding_Ratio);
                system.debug('dblMaxUse_Area_SF==='+ dblMaxUse_Area_SF);
                system.debug('Total_GSF2==='+ Total_GSF);
                try {
                    Adjusted_Area_required = roundofneg(Adj_LOP_Setback * Over_percentage_of_Perimeter * (Based_on_damped_Cladding_Ratio * (dblMaxUse_Area_SF / Total_GSF)),-2);
                }
                catch (Exception e) {
                    Adjusted_Area_required = 0; 
                }   
                //pending round of ROUND(G14*F14*E5,-2)
                Base_Area_required = roundofneg(Level_of_Protection * Change_Setback_100 * ((1 - Over_percentage_of_Perimeter)/100),-2);
                //Change_Setback_100 to adjusted setback 
                Corners_Area_Required = ((Adj_LOP_Setback + Change_Setback_100) / 2) * ((Adj_LOP_Setback + Change_Setback_100) / 2) * 4;
            /*}
            ELSE {
                Adjusted_Area_required = 0;
                Base_Area_required = 0;
                Corners_Area_Required = 0;
                Based_on_damped_Cladding_Ratio = 0;
            }*/                     
            
            List<Site_Information__c> objSiteInfoRecords = New List<Site_Information__c>();
            
            IF (StandaloneParking * 400 < 800) {
                Number_of_Stories_max = MATH.MIN((StandaloneParking * 400) / (250 * 120), 4 );
            }
            ELSE IF (StandaloneParking * 400 < 1200) {
                Number_of_Stories_max = MATH.MIN((StandaloneParking * 400) / (250 * 120), 5 );
            }
            ELSE {
                Number_of_Stories_max = MATH.MIN((StandaloneParking * 400) / (250 * 120), 6 );
            }
            Optimize_stories = MATH.MAX((MATH.FLOOR(Number_of_Stories_max/0.25))/4, 1);
            IF (StandaloneParking == 0) {
                Floorplate = 0;
            }
            ELSE {
                //pending round in ROUND(E29/E35,-2)
                Floorplate = roundofneg((StandaloneParking * 400) / Optimize_stories,-2);
            }
            IF (StandaloneParking == 0) {
                Add_perimeter_site = 0;
            }
            ELSE {
                //pending round in ROUND(25000+((E37-30000)*0.2),-2)
                Add_perimeter_site = roundofneg(25000 + ((Floorplate - 30000) * 0.2 ),-2);
            }
            IF (StandaloneParking < 100) {
                Structured_parking_Area_required = 0;
            }
            ELSE {
                Structured_parking_Area_required = Floorplate + Add_perimeter_site;
            }

            //Total_Direct_Site_Area = Adjusted_Area_required + Base_Area_required + Corners_Area_Required + (SurfaceParking * 350) + Structured_parking_Area_required + dblMaxUse_Area_SF;
            try {
                if (StandaloneParking >= 100) {
                    Total_Direct_Site_Area = Adjusted_Area_required + Base_Area_required + Corners_Area_Required + Floorplate + Add_perimeter_site + (SurfaceParking * 350) + dblMaxUse_Area_SF;
                }   
                else {
                    Total_Direct_Site_Area = Adjusted_Area_required + Base_Area_required + Corners_Area_Required + (SurfaceParking * 350) + dblMaxUse_Area_SF;
                }
            }
            catch (Exception e) {
                Total_Direct_Site_Area = 0;
            }
            //pending Perimeter LF to be round(-1)
            Perimeter_LF =  roundofneg(6 * ( MATH.SQRT ( Total_Direct_Site_Area / 2 ) ), -1);   
            
            IF ( Perimeter_LF <> 0 ) { 
                Perimeter_area_SF = 8 * Perimeter_LF;   
            }
            ELSE {
                Perimeter_area_SF = 0;
            }
            Total_Minimum_Overall_Site_Area_demand = Total_Direct_Site_Area + Perimeter_area_SF;
            system.debug('Total_GSF==='+ Total_GSF);
            system.debug('FAR==='+ FAR);

            IF (Gross_Building_Area <> 0 && FAR <> 0 && Housing_Plan != True) {
                Site_Area_based_on_FAR = Total_GSF / FAR;
            }
            ELSE {
                Site_Area_based_on_FAR = 0;
            }
            
            //IF (Housing_Plan != True) {
            try {
                GF_Perimeter = Based_on_damped_Cladding_Ratio * (dblMaxUse_Area_SF / Total_GSF);
            }
            catch (Exception e) {
                GF_Perimeter = 0;
            }    
            /*}
            //ELSE {
            //  GF_Perimeter = 0;
            }*/
            Footprint_Area = dblMaxUse_Area_SF;
            try {
                Larger_of_FAR_or_Footprint = MATH.MAX(Site_Area_based_on_FAR, dblMaxUse_Area_SF + (GF_Perimeter *10) );
            }   
            catch (Exception e) {
                Larger_of_FAR_or_Footprint = 0;
            }
            if (StandaloneParking >= 100) {
                Add_Structured_parking = Floorplate + Add_perimeter_site;
            }
            Total_Minimum_Overall_Site_Area_FAR = Larger_of_FAR_or_Footprint + Add_Structured_parking;
            //Site_Area_for_Default_Value = MATH.MAX( Total_Minimum_Overall_Site_Area_demand , MATH.MAX( dblMaxUse_Area_SF , Site_Area_based_on_FAR ) );
            Site_Area_for_Default_Value = MATH.MAX( Total_Minimum_Overall_Site_Area_demand, Total_Minimum_Overall_Site_Area_FAR);
            
            try {
                if (dblOverride_Calculated_Site_Area > dblMaxUse_Area_SF ) {
                    Finished_Site = dblOverride_Calculated_Site_Area - dblMaxUse_Area_SF - (SurfaceParking * 350) - Floorplate;
                    system.debug('dblOverride_Calculated_Site_Area ****=='+ dblOverride_Calculated_Site_Area );
                    system.debug('dblMaxUse_Area_SF ****=='+ dblMaxUse_Area_SF );
                } 
                else {
                    Finished_Site = Site_Area_for_Default_Value - dblMaxUse_Area_SF - (SurfaceParking * 350) - Floorplate;
                    system.debug('Site_Area_for_Default_Value =='+ Site_Area_for_Default_Value );
                    system.debug('else-dblMaxUse_Area_SF ****=='+ dblMaxUse_Area_SF );
                }
            }
            catch (Exception e) {
                Finished_Site = 0;
            }
            
            objSiteInfoRecords.Add(new Site_Information__c(
            Project__c = ProjectID,
            Gross_Building_Area__c = Total_GSF,
            Footprint_Area__c = dblMaxUse_Area_SF,
            GF_Perimeter__c = GF_Perimeter,
            Adjusted_Area_required__c = Adjusted_Area_required,
            Base_Area_required__c = Base_Area_required,
            Corners_Area_Required__c = Corners_Area_Required,
            Total_Site_required_by_setbacks__c = Base_Area_required + Adjusted_Area_required + Corners_Area_Required,
            Surface_parking_Area_required__c = SurfaceParking * 350,
            Total_Area__c = StandaloneParking * 400,
            Number_of_Stories_max__c = Number_of_Stories_max,
            Optimize_stories__c = Optimize_stories,
            Floorplate__c = Floorplate,
            Add_perimeter_site__c = Add_perimeter_site,
            Structured_parking_Area_required__c = Structured_parking_Area_required,
            Perimeter_LF__c = Perimeter_LF,
            Perimeter_area_SF__c = Perimeter_area_SF,
            Total_Minimum_Overall_Site_Area_demand__c = Total_Minimum_Overall_Site_Area_demand,
            FAR__c = FAR,
            Site_Area_based_on_FAR__c = Site_Area_based_on_FAR,
            Larger_of_FAR_or_Footprint__c = Larger_of_FAR_or_Footprint,
            Total_Minimum_Overall_Site_Area_FAR__c = Total_Minimum_Overall_Site_Area_FAR,
            Add_Structured_parking__c = Add_Structured_parking,
            Total_Direct_Site_Area__c = Total_Direct_Site_Area,
            Site_Area_for_Default_Value__c = Site_Area_for_Default_Value + SurfaceParking * 350,
            Finished_Site__c = Finished_Site            
            ));

            insert objSiteInfoRecords;
            
        }
        
    }

    public void GenerateProfServEstData(ID ProjectID, String strProjectRecordTypeName, String strinsup, integer intcountRA) {
        
        String strRecordTypeID, strBuilding_Type, strDelivery_Method, strCM_Role, strDesign_Build_Leased_Delivery_Only, strFor_Design_Build_Owned_Stipend_Detail, strFor_Design_Build_Owned_Stipend_Compl, strProject_Type, strScope, strPhases;
        Decimal Project_GSF, Total_ECC, CEW_ECC;
        integer RAcount = 0;
        Date Start_Construction;

        NCMT_Project__c NCMTRec = [Select Name, Total_ECC__c, CEW_ECC1__C, Total_GSF__c, Project_Area_GSF__c,State__c, City__c, Location__c, RegionCode__c, 
                                    Start_Construction__c, Parking_Garage_Gross_Area_SF__c, Cost_Parameter_Date__c,Estimate_Type_Proj__c,
                                    Project_type__c, Building_Type__c,Mid_Point_of_Construction__c,Anticipated_Date_of_Design_Award__c
                                   From NCMT_Project__c
                                   Where ID = :ProjectID];      

        if (strProjectRecordTypeName == 'Office') {
            strBuilding_Type = 'Federal Office Building';
            strDelivery_Method = 'Design-Bid-Build';
            strCM_Role = 'CM as Agent';
            strDesign_Build_Leased_Delivery_Only = '';
         }
         else if (strProjectRecordTypeName == 'Medical Clinic' || strProjectRecordTypeName == 'Medical Office') {
            strBuilding_Type = strProjectRecordTypeName;
            strDelivery_Method = 'Design Build - Leased';
            strCM_Role = 'N/A';
            strDesign_Build_Leased_Delivery_Only = 'Build to Suit';
         }
        //SFWS-2040 starts here
        else if (strProjectRecordTypeName == 'Utility') {
            strBuilding_Type = 'Warehouse';
            strDelivery_Method = 'Design-Bid-Build';
            strCM_Role = 'CM as Agent';
            strDesign_Build_Leased_Delivery_Only = '';
         }
        //SFWS-2040 ends here
         else {
            strBuilding_Type = strProjectRecordTypeName;
            strDelivery_Method = 'Design-Bid-Build';
            strCM_Role = 'CM as Agent';
            strDesign_Build_Leased_Delivery_Only = '';
         }
         if (strProjectRecordTypeName == 'Parking Garage') {
            Project_GSF = NCMTRec.Parking_Garage_Gross_Area_SF__c;
         }else if(NCMTRec.Estimate_Type_Proj__c =='Cost Estimating Workbook'){
            Project_GSF = NCMTRec.Project_Area_GSF__c;
         }else{
            Project_GSF = NCMTRec.Total_GSF__c;
             System.debug('NCMTRec.gsf--- '+Project_GSF);
         }
            if(NCMTRec.Estimate_Type_Proj__c =='Cost Estimating Workbook'){
                  Total_ECC =NCMTRec.CEW_ECC1__c;
                  Start_Construction = NCMTRec.Mid_Point_of_Construction__c;
            }else{
                  Total_ECC = NCMTRec.Total_ECC__c;
                  Start_Construction =NCMTRec.Start_Construction__c;
            }
         
         //system.debug('Total_ECC===' + Total_ECC);
        system.debug('Anticipated Design date===' + NCMTRec.Anticipated_Date_of_Design_Award__c);
        if (strDelivery_Method <> 'Design Build - Owned') {
            strFor_Design_Build_Owned_Stipend_Detail = '';
            strFor_Design_Build_Owned_Stipend_Compl = '';
        }
        else {
            strFor_Design_Build_Owned_Stipend_Detail = 'Low';
            strFor_Design_Build_Owned_Stipend_Compl = 'Low';
        }
        
        if (NCMTRec.Project_type__c == 'New Construction' || NCMTRec.Project_type__c == 'New Construction - CEW') {
            strRecordTypeID = Schema.SObjectType.Professional_Service_Estimate__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
            strProject_Type = 'New Construction';
            strScope = 'Limited Scope';
            strPhases = '1';
            if (NCMTRec.Building_Type__c == 'LPOE') {
                List<AggregateResult> arLPOECostECC = [Select SUM(Total_ECC__c) ECCTotal from NCMT_LPOE_Cost_Summary__c where Project_Name__c = :ProjectID];
                For (AggregateResult ar :arLPOECostECC){
                     Total_ECC = (decimal) ar.get('ECCTotal');
                }
                
                List<AggregateResult> arLPOECostGSF = [Select SUM(Total_Cost__c) CostTotal from NCMT_LPOE_Cost_Summary__c where Project_Name__c = :ProjectID and Site_Related__c = false];
                For (AggregateResult ar1 :arLPOECostGSF){
                     Project_GSF = (decimal) ar1.get('CostTotal');
                }
            }
        }
        else {
            strProject_Type = 'Repair & Alteration';
            strScope = 'Limited Scope';
            if (intcountRA >= 1 ) {
                RAcount = intcountRA;
            }
            else {  
                strRecordTypeID = Schema.SObjectType.Professional_Service_Estimate__c.getRecordTypeInfosByName().get('Default Repair and Alteration').getRecordTypeId();
                
                List<AggregateResult> arRAPhasing = [Select Count(id) RATotal from NCMT_RA_Phasing__c where Project__c = :ProjectID]; 
                                                      
                For(AggregateResult ar :arRAPhasing){
                     RAcount = (integer) ar.get('RATotal');
                }   
            }

            IF (RAcount == 0) {
                strPhases = '1';
            }   
            else If (RAcount <= 4) {
                strPhases = string.valueof(RAcount);
            }   
            else {      
                strPhases = '4+';
            }   
        }
        List<Professional_Service_Estimate__c> objProfServEstRecord = New List<Professional_Service_Estimate__c>();

        if (strinsup == 'insert') {
            objProfServEstRecord.Add(new Professional_Service_Estimate__c(
                RecordTypeID = strRecordTypeID,
                Name = NCMTRec.Name,
                NCMT_Project__c = ProjectID,
                Project_Type__c = strProject_Type,
                Building_Type__c = strBuilding_Type,
                Delivery_Method__c = strDelivery_Method,
                CM_Role__c = strCM_Role,
                Anticipated_Date_of_Design_Award__c = NCMTRec.Anticipated_Date_of_Design_Award__c,
                Design_Build_Leased_Delivery_Only__c = strDesign_Build_Leased_Delivery_Only,
                For_Design_Build_Owned_Stipend_Detail__c = strFor_Design_Build_Owned_Stipend_Detail,
                For_Design_Build_Owned_Stipend_Compl__c = strFor_Design_Build_Owned_Stipend_Compl,
                ECC__c = Total_ECC,
                Estimated_Total_GSF__c = Project_GSF,
                State__c = NCMTRec.State__c,
                City__c = NCMTRec.City__c,
                Location_Parameter__c = NCMTRec.Location__c,
                Region_Code__c = NCMTRec.RegionCode__c,
                Base_Date_of_Estimate__c =  NCMTRec.Cost_Parameter_Date__c, 
                Anticipated_Start_Date_of_Construction__c = Start_Construction,
                Scope__c = strScope,
                Estimated_Number_of_Phases__c = strPhases
            )); 
            insert objProfServEstRecord;
        }
        else {
            List<Professional_Service_Estimate__c> ListPSE = [Select ID From Professional_Service_Estimate__c
                                                                Where NCMT_Project__c = :ProjectID];
            
            for (Professional_Service_Estimate__c PSE : ListPSE)
                objProfServEstRecord.Add(new Professional_Service_Estimate__c(
                ID = (ID) PSE.get('ID'),
                Name = NCMTRec.Name,
                NCMT_Project__c = ProjectID,
                RecordTypeID = strRecordTypeID,
                Project_Type__c = strProject_Type,
                Building_Type__c = strBuilding_Type,
                Delivery_Method__c = strDelivery_Method,
                CM_Role__c = strCM_Role,
                Anticipated_Date_of_Design_Award__c = NCMTRec.Anticipated_Date_of_Design_Award__c,    
                Design_Build_Leased_Delivery_Only__c = strDesign_Build_Leased_Delivery_Only,
                For_Design_Build_Owned_Stipend_Detail__c = strFor_Design_Build_Owned_Stipend_Detail,
                For_Design_Build_Owned_Stipend_Compl__c = strFor_Design_Build_Owned_Stipend_Compl,
                ECC__c = Total_ECC,
                Estimated_Total_GSF__c = Project_GSF,
                State__c = NCMTRec.State__c,
                City__c = NCMTRec.City__c,
                Location_Parameter__c = NCMTRec.Location__c,
                Region_Code__c = NCMTRec.RegionCode__c,
                Anticipated_Start_Date_of_Construction__c = Start_Construction,
                Estimated_Number_of_Phases__c = strPhases
            )); 
            update objProfServEstRecord;
        }
    }
    
    public void UpdateProjectData(List<NCMT_Project__c> projList, String strProjectRecordTypeName, String ProjectType, String strProjectBldgHeight, Decimal dblProjectAt_and_above_grade, String strBuilding_Quality, String strRemoteness, String strstate, String strcity, String strParkingAreaType) {
        
        System.debug('UpdateProjectData');
        string strNCMTRecordType = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId();   
        boolean blncheck;
        blncheck = true;
        integer intcheck;
        Date CostParameterDate;
        String CostParameterYear;
        intcheck = 0;
        for (NCMT_Project__c NCMT0 : projList) {
            //check for Start and End construction
            /*if (NCMT0.Start_Construction__c == null && NCMT0.End_Construction__c == null) {
                blncheck = false;
            }*/
            if (NCMT0.Housing_Plan__c == true && NCMT0.Total_Area_Including_Parking__c > 0) {
                System.debug('NCMT0.Housing_Plan__c == true && NCMT0.Total_Area_Including_Parking__c > 0');
                blncheck = false;
            }
            //check if multiple checkbox are checked
            if (NCMT0.RecordTypeid == strNCMTRecordType && blncheck == true) {
                //Check if multiple Parking Structure Area are checked
                if (NCMT0.Parking_Structure__c == true) {
                    intcheck = 1;
                    if (NCMT0.At_and_above_grade__c < 1) {
                        intcheck = intcheck + 1;
                    }
                }   
                if (NCMT0.Parking_Deck__c == true) {
                    intcheck = intcheck + 1;
                    if (NCMT0.At_and_above_grade__c <> 2 || NCMT0.Below_grade__c <> 0) {
                        intcheck = intcheck + 1;
                    }
                }
                if (NCMT0.Below_Grade_Structure__c == true) {
                    intcheck = intcheck + 1;
                    if (NCMT0.At_and_above_grade__c <> 0 || NCMT0.Below_grade__c < 1) {
                        intcheck = intcheck + 1;
                    }
                }
                if (intcheck > 1) {
                    blncheck = false;
                }
                //Check if multiple Ramping Options are checked
                intcheck = 0;
                if (blncheck == true) {
                    If (NCMT0.Sloped_Parking_Deck__c == true) {
                        intcheck = 1;
                    }   
                    if (NCMT0.Speed_Ramp__c == true) {
                        intcheck = intcheck + 1;
                    }
                    if (intcheck > 1) {
                        blncheck = false;
                    }
                }
                //Check if multiple Layout Efficiency are checked   
                intcheck = 0;
                if (blncheck == true) {
                    if (NCMT0.Optimized_for_Parking__c == true) {
                        intcheck = 1;
                    }   
                    if (NCMT0.Medium_Efficiency__c == true) {
                        intcheck = intcheck + 1;
                    }
                    if (NCMT0.Low_Efficiency__c == true) {
                        intcheck = intcheck + 1;
                    }
                    if (intcheck > 1) {
                        blncheck = false;
                    }
                }
                //Check if multiple Cladding Options are checked    
                intcheck = 0;
                if (blncheck == true) {
                    if (NCMT0.Utilitarian__c == true) {
                        intcheck = 1;
                    }   
                    if (NCMT0.Medium__c == true) {
                        intcheck = intcheck + 1;
                    }
                    if (NCMT0.High__c == true) {
                        intcheck = intcheck + 1;
                    }
                    if (intcheck > 1) {
                        blncheck = false;
                    }
                }     
            }            
        }
        
        if (blncheck == true) { 
            //get Building Parameter Code 
            string Bcode;            
            //get Building Height Code 
            string BHeightCode;
            
            string Quality_Code;
            string Cladding_Quality;
            string Cladding_List;    

            system.debug('jmd strProjectRecordTypeName '+strProjectRecordTypeName);
            //get Building Code Id to store in Project Building parameter
             List <NCMT_Building_Parameter__c> ListBcode = [SELECT ID,EDRC_5_M__C FROM NCMT_Building_Parameter__c where Building_Parameter_Name__c = :strProjectRecordTypeName];
             For (NCMT_Building_Parameter__c objBCode: ListBcode) {
                 BCode = objBCode.ID;
             }
             
             //get Location Parameter Id to store in Project Location parameter
             string strSOQL;
             string LocName;
             string LocCode;
             String LocationQuality;
             string LocRegion;
             Decimal LocStandardRate=0;
             Decimal LocSalesTax=0, dbllocationadjDC =0.0,dblPLA =0.0,dblsbhub =0.0;
             LocCode='';
             /*
             IF (strCity == null) {
                LocName = 'State Average';
                strSOQL = 'SELECT ID, Location_Tier_for_Quality__c, GSA_Region__c FROM NCMT_Location_Parameters__c where State__c = :strState And Name = :LocName';
             } else {
                strSOQL = 'SELECT ID, Location_Tier_for_Quality__c, GSA_Region__c FROM NCMT_Location_Parameters__c where ID = :strCity';
             }
             */
             NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
             CostParameterDate = ncmt_customsettings.Cost_Parameter_Date__c;
             CostParameterYear = string.valueof(CostParameterDate.year()+1);             
             
             strSOQL = 'SELECT Name, Location_Tier_for_Quality__c, Standard_Escalation__c,GSA_Region__c,Sales_Tax__c,Location_Adjustment_DC__c, PLA__c, SB_HUB__c FROM NCMT_Location_Parameters__c where Name = :strCity and state__c = :strstate and Fiscal_Year__c = :CostParameterYear';
             List <NCMT_Location_Parameters__c> ListLcode = Database.query(strSOQL);
             For (NCMT_Location_Parameters__c objLCode: ListLcode) {
                 LocCode = objLCode.Name;
                 LocationQuality = objLCode.Location_Tier_for_Quality__c;
                 LocRegion = objLCode.GSA_Region__c;
                 LocStandardRate = objLCode.Standard_Escalation__c;
                 LocSalesTax = objLCode.Sales_Tax__c;
                 dbllocationadjDC = objLCode.Location_Adjustment_DC__c;
                 dblPLA = objLCode.PLA__c;
                 dblsbhub = objLCode.SB_HUB__c;
             }
            Integer intGSF_10000;   
            Integer intGSF_25000;
            Integer intGSF_50000;
            Integer intGSF_100000;
            Integer intGSF_150000;
            Integer intGSF_250000;
            Integer intGSF_500000;
            Integer intGSF_GT_500000;   
            //get FAR values from Building Height Parameter
            Decimal FARvalue=0;
            Decimal No_of_Floors;
            Decimal Bast_Ratio = 0;
            Decimal Story_Ht;
            Decimal Plumbing_Fixtures;
            Decimal Elevators;
        
            //get the Construction months from Building Height Parameters
            Decimal ConstructionMonth=0;
                              
            //get Building Height Code Id to store in Project Building Height parameter for Parking Garage
            IF (strProjectRecordTypeName == 'Parking Garage' && strParkingAreaType == 'Parking Structure') {
                IF (dblProjectAt_and_above_grade == 1) {
                    BHeightCode='PS01';
                }
                ELSE IF (dblProjectAt_and_above_grade >=2 && dblProjectAt_and_above_grade <=3) {
                    BHeightCode='PS02';
                }
                ELSE IF (dblProjectAt_and_above_grade >=4 && dblProjectAt_and_above_grade <=9) {
                    BHeightCode='PS06';
                }
                ELSE IF (dblProjectAt_and_above_grade >= 10) {
                    BHeightCode='PS15';
                }
            }  
            else if (strProjectRecordTypeName == 'Parking Garage' && strParkingAreaType == 'Parking Deck') {
                BHeightCode='PS02';
            }
            else if (strProjectRecordTypeName == 'Parking Garage' && strParkingAreaType == 'Below Grade Structure') {
                BHeightCode='PS01';
            }
            IF (strProjectRecordTypeName == 'Parking Garage' ) { 
                strSOQL = 'SELECT ID, GSF_10000__c, GSF_25000__c, GSF_50000__c, GSF_100000__c, GSF_150000__c, ' + ' ' +   
                          'GSF_250000__c, GSF_500000__c, GSF_GT_500000__c, Remote__c,  ' + ' ' + 
                          'No_of_Floors__c, Bast_Ratio__c, Story_Ht__c, Plumbing_Fixtures__c, Elevators__c ' + ' ' +   
                          'FROM NCMT_Building_Height_Parameter__c where Name = :BHeightCode' ;
            } 
            ELSE {
                //get Building Height Code Id to store in Project Building Height parameter
                 //strSOQL = 'SELECT ID, GSF_10000__c, GSF_25000__c, GSF_50000__c, GSF_100000__c, GSF_150000__c, ' + ' ' + 
                 //          'GSF_250000__c, GSF_500000__c, GSF_GT_500000__c, Remote__c,  ' + ' ' +  
                 //          'No_of_Floors__c, Bast_Ratio__c, Story_Ht__c, Plumbing_Fixtures__c, Elevators__c ' + ' ' +             
                 //           'FROM NCMT_Building_Height_Parameter__c where RecordType.Name = :strProjectRecordTypeName and Building_Height__c = :strProjectBldgHeight' ;
                 string strBldgCode;
                 if (strProjectRecordTypeName == 'Childcare Center') {
                    strBldgCode = 'CC%';
                 }           
                 else if (strProjectRecordTypeName == 'Courthouse') {
                    strBldgCode = 'CO%';
                 } 
                 else if (strProjectRecordTypeName == 'Laboratory: Dry') {
                    strBldgCode = 'LD%';
                 }
                 else if (strProjectRecordTypeName == 'Laboratory: Wet') {
                    strBldgCode = 'LW%';
                 }
                 else if (strProjectRecordTypeName == 'Office') {
                    strBldgCode = 'OF%';
                 }
                 //else if (strProjectRecordTypeName == 'Parking Garage') {
                 //   strBldgCode = 'PS%';
                 //}
                 else if (strProjectRecordTypeName == 'Utility') {
                    strBldgCode = 'UT%';
                 }
                 else if (strProjectRecordTypeName == 'Data Center') {
                    strBldgCode = 'DC%';
                 }
                 else if (strProjectRecordTypeName == 'Medical Clinic') {
                    strBldgCode = 'MC%';
                 }
                 else if (strProjectRecordTypeName == 'Medical Office') {
                    strBldgCode = 'MO%';
                 }else if (strProjectRecordTypeName == 'LPOE') {
                    strBldgCode = 'LP%';
                 }
                 
                 strSOQL = 'SELECT ID, GSF_10000__c, GSF_25000__c, GSF_50000__c, GSF_100000__c, GSF_150000__c, ' + ' ' + 
                           'GSF_250000__c, GSF_500000__c, GSF_GT_500000__c, Remote__c,  ' + ' ' +  
                           'No_of_Floors__c, Bast_Ratio__c, Story_Ht__c, Plumbing_Fixtures__c, Elevators__c ' + ' ' +             
                           'FROM NCMT_Building_Height_Parameter__c where name like :strBldgCode and Building_Height__c = :strProjectBldgHeight' ;
            }

            List <NCMT_Building_Height_Parameter__c> ListBHcode = Database.query(strSOQL); 
            For (NCMT_Building_Height_Parameter__c objBHCode: ListBHcode) {
                    BHeightCode = objBHCode.ID;
                    intGSF_10000 = Integer.valueOf(objBHCode.GSF_10000__c );
                    intGSF_25000 = Integer.valueOf(objBHCode.GSF_25000__c );
                    intGSF_50000 = Integer.valueOf(objBHCode.GSF_50000__c );
                    intGSF_100000 = Integer.valueOf(objBHCode.GSF_100000__c );
                    intGSF_150000 = Integer.valueOf(objBHCode.GSF_150000__c );
                    intGSF_250000 = Integer.valueOf(objBHCode.GSF_250000__c );
                    intGSF_500000 = Integer.valueOf(objBHCode.GSF_500000__c );
                    intGSF_GT_500000 = Integer.valueOf(objBHCode.GSF_GT_500000__c );
                    FARvalue = objBHCode.Remote__c; 
                    No_of_Floors = objBHCode.No_of_Floors__c;
                    Bast_Ratio = objBHCode.Bast_Ratio__c;
                    Story_Ht = objBHCode.Story_Ht__c;
                    Plumbing_Fixtures = objBHCode.Plumbing_Fixtures__c;
                    Elevators = objBHCode.Elevators__c;                 
            }
                
            //get Building Height Code Id to store in Project Building Height parameter for Parking Garage
              
            //Update Quality Code
           //get Location Tier for Quality
           //NCMT_Location_Parameters__c NCP = [SELECT Location_Tier_for_Quality__c FROM NCMT_Location_Parameters__c where Id = :LocCode];
           //LocationQuality = NCP.Location_Tier_for_Quality__c; 
           //system.debug('BCode==='+ BCode);
           IF (strProjectRecordTypeName <> 'Parking Garage' && ProjectType <> 'New Construction - DES' && ProjectType <> 'Repair & Alteration - DES' 
              && ProjectType <> 'New Construction - CEW' && ProjectType <> 'Repair & Alteration - CEW') {
                
                NCMT_Quality_Code_Lookup__c QCL = [SELECT  Quality_Code_Parameter__c 
                                                 FROM NCMT_Quality_Code_Lookup__c
                                                 WHERE Building_Code__c = :BCode
                                                 and Location_Quality_code__c = :LocationQuality
                                                 and Quality_Type__c = :strBuilding_Quality                                              
                                                 and Site_Remoteness__c = :strRemoteness ];
               Quality_Code = QCL.Quality_Code_Parameter__c;
               
               NCMT_Quality_Code_Parameter__c QCP = [SELECT Name,Cladding_Quality__c,Cladding_List__c FROM NCMT_Quality_Code_Parameter__c where Id = :Quality_Code];
               
               Quality_Code = QCP.Name;           
               Cladding_Quality = QCP.Cladding_Quality__c;
               Cladding_List = QCP.Cladding_List__c;            
           } 

            Decimal intParking_Structure;  
            Decimal intParking_Deck;
            Decimal intBelow_Grade_Structure;
            Decimal intSloped_Parking_Deck;
            Decimal intSpeed_Ramp;
            Decimal intOptimized_for_Parking;
            Decimal intMedium_Efficiency;
            Decimal intLow_Efficiency;
                         
            IF (strProjectRecordTypeName == 'Parking Garage') {     
                //get the Parking Garage values from System Level Parameter
                string PGParking_Structure;
                
                List <System_Level_Parameter__c> SLPList = [SELECT Name, Value__c FROM System_Level_Parameter__c where
                                                                Category__c = 'Parking Structure Types' or Category__c = 'Ramping Options' or Category__c = 'Layout Efficiency' ];
                
                For (System_Level_Parameter__c SLP : SLPList ){
                    if (SLP.Name == 'Parking Structure' ) {
                        intParking_Structure = SLP.Value__c ;
                    }
                    if (SLP.Name == 'Parking Deck' ) {
                        intParking_Deck = SLP.Value__c ;
                    }
                    if (SLP.Name == 'Below Grade Structure' ) {
                        intBelow_Grade_Structure = SLP.Value__c ;
                    }
                    if (SLP.Name == 'Sloped Parking Deck' ) {
                        intSloped_Parking_Deck = SLP.Value__c ;
                    }
                    if (SLP.Name == 'Speed Ramp' ) {
                        intSpeed_Ramp = SLP.Value__c ;
                    }
                    if (SLP.Name == 'Optimized for Parking' ) {
                        intOptimized_for_Parking = SLP.Value__c ;
                    }
                    if (SLP.Name == 'Medium Efficiency' ) {
                        intMedium_Efficiency = SLP.Value__c ;
                    }
                    if (SLP.Name == 'Low Efficiency' ) {
                        intLow_Efficiency = SLP.Value__c ;
                    }
                }
            }
            
            Decimal intGrossAreaSF=0;
            //update Parking Garage Gross Area SF
            for (NCMT_Project__c NCMT1 : projList) {
                System.debug('NCMT1: ' + NCMT1.Project_Record_ID__c);
                //update Building, Building Height Parameter and Location Parameter
                NCMT1.Building_Parameter__c = BCode;
                NCMT1.Building_Height_Parameter__c = BHeightCode;
                //NCMT1.Location__c = LocCode;
                NCMT1.RegionCode__c = LocRegion;
                NCMT1.Standard_Esc_Rate__c = LocStandardRate;
                //Do not use Location Parameter Sales Tax if clone
                if(NCMT1.Project_Record_ID__c == null) {
                    //System.debug('SALES TAX NOT A CLONE!');
                    NCMT1.Sales_Tax__c = LocSalesTax; }
                NCMT1.Location_Adjustment_DC__c = dbllocationadjDC ;
                NCMT1.PLA__c = dblPLA ;
                NCMT1.SB_HUB__c = dblsbhub ;
                if (Bast_Ratio == null) {
                    Bast_Ratio = 0;
                }
                
                IF (strProjectRecordTypeName == 'Parking Garage') {
                    NCMT1.Default_Above_Ground__c = NCMT1.At_and_above_grade__c;
                    NCMT1.Default_Below_Ground__c = NCMT1.Below_grade__c;
                }   
                else {
                    NCMT1.Quality_Code__c = Quality_Code;
                    NCMT1.Cladding_Quality__c = Cladding_Quality;
                    NCMT1.Cladding_List__c = Cladding_List;
                    NCMT1.Default_Above_Ground__c = No_of_Floors;
                    NCMT1.Default_Below_Ground__c = MATH.CEIL(Bast_Ratio);
                }
                                
                NCMT1.Default_Average_Story_Height__c = Story_Ht;
                NCMT1.Default_Plumbing_Fixtures__c = Plumbing_Fixtures;
                NCMT1.Default_Vertical_Convey_Elevators_Stops__c = Elevators;
                
                //if(trigger.isinsert){  
                NCMT1.Above_Ground__c = NCMT1.Default_Above_Ground__c;
                NCMT1.Below_Ground__c = NCMT1.Default_Below_Ground__c;
                NCMT1.Average_Story_Height__c = NCMT1.Default_Average_Story_Height__c;
                NCMT1.Plumbing_Fixtures__c = NCMT1.Default_Plumbing_Fixtures__c;
                NCMT1.Vertical_Conveyance_Elevators_Stops__c = NCMT1.Default_Vertical_Convey_Elevators_Stops__c;
                //}
                
                //update Parking Garage Gross Area SF
                if (NCMT1.RecordTypeid == strNCMTRecordType ) {
    
                        IF ( NCMT1.Parking_Structure__c ) {
                            intGrossAreaSF = NCMT1.Number_of_Spaces__c * intParking_Structure;
                        }
                        ELSE IF ( NCMT1.Parking_Deck__c ) {
                            intGrossAreaSF = NCMT1.Number_of_Spaces__c * intParking_Deck;
                        }
                        ELSE IF ( NCMT1.Below_Grade_Structure__c ) {
                            intGrossAreaSF = NCMT1.Number_of_Spaces__c * intBelow_Grade_Structure;
                        }
                        
                        IF ( NCMT1.Sloped_Parking_Deck__c ) {
                            intGrossAreaSF = intGrossAreaSF * intSloped_Parking_Deck;
                        }
                        ELSE IF ( NCMT1.Speed_Ramp__c ) {
                            intGrossAreaSF = intGrossAreaSF * intSpeed_Ramp;
                        }
                        
                        IF ( NCMT1.Optimized_for_Parking__c ) {
                            intGrossAreaSF = intGrossAreaSF * intOptimized_for_Parking;
                        }
                        ELSE IF ( NCMT1.Medium_Efficiency__c ) {
                            intGrossAreaSF = intGrossAreaSF * intMedium_Efficiency;
                        }
                        ELSE IF ( NCMT1.Low_Efficiency__c  ) {
                            intGrossAreaSF = intGrossAreaSF * intLow_Efficiency;
                        }
               
                       NCMT1.PG_GrossAreaSF__c = intGrossAreaSF;
                
                       IF (intGrossAreaSF < 10000 ) {
                           ConstructionMonth = intGSF_10000;
                       } 
                       ELSE IF (intGrossAreaSF >= 10000 && intGrossAreaSF < 25000) {
                           ConstructionMonth = intGSF_25000;
                       }    
                       ELSE IF (intGrossAreaSF >= 25000 && intGrossAreaSF < 50000) {
                           ConstructionMonth = intGSF_50000;
                       } 
                       ELSE IF (intGrossAreaSF >= 50000 && intGrossAreaSF < 100000) {
                           ConstructionMonth = intGSF_100000;
                       } 
                       ELSE IF (intGrossAreaSF >= 100000 && intGrossAreaSF < 150000) {
                           ConstructionMonth = intGSF_150000;
                       } 
                       ELSE IF (intGrossAreaSF >= 150000 && intGrossAreaSF < 250000) {
                           ConstructionMonth = intGSF_250000;
                       } 
                       ELSE IF (intGrossAreaSF >= 250000 && intGrossAreaSF < 500000) {
                           ConstructionMonth = intGSF_500000;
                       } 
                       ELSE IF (intGrossAreaSF >= 500000 ) {
                           ConstructionMonth = intGSF_GT_500000;
                       } 
                       //If (ConstructionMonth <> 0 && ConstructionMonth <> NULL) {
                       //    ConstructionMonth = (ConstructionMonth * 30.2)/2;
                       //}
                       
                       IF (NCMT1.Start_Construction__c <> null && NCMT1.End_Construction__c <> null && Trigger.isInsert) {
                            NCMT1.adderror('Enter either Start Construction or Date of Occupancy, not both.');
                       }

                       IF (NCMT1.Start_Construction__c <> null) {
                            if (ConstructionMonth == 0) {
                                NCMT1.End_Construction__c = NCMT1.Start_Construction__c;
                            }
                            else {
                                NCMT1.End_Construction__c = NCMT1.Start_Construction__c.addMonths(Integer.valueOf(ConstructionMonth)) ;
                            }      
                       }
                       ELSE IF (NCMT1.End_Construction__c <> null) {
                            if (ConstructionMonth == 0) {
                                NCMT1.Start_Construction__c = NCMT1.End_Construction__c;
                            }
                            else {
                                NCMT1.Start_Construction__c = NCMT1.End_Construction__c.addMonths(Integer.valueOf(ConstructionMonth * - 1));
                            }   
                       }  
                }
            }
        }                 
    }
    
    public void updateProjStartEndConstruction (List<NCMT_Project__c> projList, Id BHCode, Decimal dblGrossAreaSF, string Building_Cost_Type) {
        System.debug('updateProjStartEndConstruction');
        Decimal ConstructionMonth=0;
        
        NCMT_Building_Height_Parameter__c objBH = [SELECT ID, GSF_10000__c, GSF_25000__c, GSF_50000__c, GSF_100000__c, GSF_150000__c,  
                                                    GSF_250000__c, GSF_500000__c, GSF_GT_500000__c, Remote__c,USF_GT_500000__c,
                                                    USF_10000__c, USF_100000__c, USF_150000__c, USF_25000__c, USF_250000__c, USF_50000__c, USF_500000__c,    
                                                    No_of_Floors__c, Bast_Ratio__c, Story_Ht__c, Plumbing_Fixtures__c, Elevators__c              
                                                    FROM NCMT_Building_Height_Parameter__c where ID = :BHCode] ;
        System.debug(projList.size());                   
        for (NCMT_Project__c NCMT1 : projList) {
            
           IF (dblGrossAreaSF < 10000 ) {
               if(Building_Cost_Type == 'Core/Shell with TI' || Building_Cost_Type == 'Core/Shell only'){   
                    ConstructionMonth = objBH.GSF_10000__c;
               }else{
                    ConstructionMonth = objBH.USF_10000__c;
               }
           } 
           ELSE IF (dblGrossAreaSF >= 10000 && dblGrossAreaSF < 25000) {
                if(Building_Cost_Type == 'Core/Shell with TI' || Building_Cost_Type == 'Core/Shell only'){  
                    ConstructionMonth = objBH.GSF_25000__c;
                }else{
                    ConstructionMonth = objBH.USF_25000__c;
                }
           }    
           ELSE IF (dblGrossAreaSF >= 25000 && dblGrossAreaSF < 50000) {
               if(Building_Cost_Type == 'Core/Shell with TI' || Building_Cost_Type == 'Core/Shell only'){
                    ConstructionMonth = objBH.GSF_50000__c;
               }else{
                    ConstructionMonth = objBH.USF_50000__c;
               }
           } 
           ELSE IF (dblGrossAreaSF >= 50000 && dblGrossAreaSF < 100000) {
               if(Building_Cost_Type == 'Core/Shell with TI' || Building_Cost_Type == 'Core/Shell only'){
                    ConstructionMonth = objBH.GSF_100000__c;
               }else{
                    ConstructionMonth = objBH.USF_100000__c;
               }
           } 
           ELSE IF (dblGrossAreaSF >= 100000 && dblGrossAreaSF < 150000) {
               if(Building_Cost_Type == 'Core/Shell with TI' || Building_Cost_Type == 'Core/Shell only'){
                    ConstructionMonth = objBH.GSF_150000__c;
               }else{
                    ConstructionMonth = objBH.USF_150000__c;
               }
           } 
           ELSE IF (dblGrossAreaSF >= 150000 && dblGrossAreaSF < 250000) {
                if(Building_Cost_Type == 'Core/Shell with TI' || Building_Cost_Type == 'Core/Shell only'){
                    ConstructionMonth = objBH.GSF_250000__c;
                }else{
                    ConstructionMonth = objBH.USF_250000__c;
                }
           } 
           ELSE IF (dblGrossAreaSF >= 250000 && dblGrossAreaSF < 500000) {
               if(Building_Cost_Type == 'Core/Shell with TI' || Building_Cost_Type == 'Core/Shell only'){
                    ConstructionMonth = objBH.GSF_500000__c;
               }else{
                    ConstructionMonth = objBH.USF_500000__c;
               }
           } 
           ELSE IF (dblGrossAreaSF >= 500000 ) {
                if(Building_Cost_Type == 'Core/Shell with TI' || Building_Cost_Type == 'Core/Shell only'){
                    ConstructionMonth = objBH.GSF_GT_500000__c;
                }else{
                    ConstructionMonth = objBH.USF_GT_500000__c;
                }
           } 

           IF (NCMT1.Start_Construction__c <> null) {
                if (ConstructionMonth == 0) {
                    NCMT1.End_Construction__c = NCMT1.Start_Construction__c;
                }
                else {
                    NCMT1.End_Construction__c = NCMT1.Start_Construction__c.addMonths(Integer.valueOf(ConstructionMonth)) ;
                }      
           }
           ELSE IF (NCMT1.End_Construction__c <> null) {
                if (ConstructionMonth == 0) {
                    NCMT1.Start_Construction__c = NCMT1.End_Construction__c;
                }
                else {
                    NCMT1.Start_Construction__c = NCMT1.End_Construction__c.addMonths(Integer.valueOf(ConstructionMonth * - 1));
                }   
           } 
        }
        
    }
    
    public void UpdateProjectMarkup(List<NCMT_Project__c> projList, String ProjectType, String Building_Cost_Type, String strBuildingSelection,Boolean Include_Exclude_AIA, String ProjectRecordTypeName){
        //get Markup values from System Level Parameter
        Decimal intDesignSiteContingency = 0;
        Decimal intGeneralContractorOverhead = 0;
        Decimal intConstructionContingency = 0;
        Decimal intArtInArchitecture = 0;
        Decimal SpecialUseGrossReceiptsTax = 0; 
          
        if(ProjectRecordTypeName != 'LPOE'){
            List <System_Level_Parameter__c> SLPList = [SELECT Name, Value__c, Category__c FROM System_Level_Parameter__c where Category__c IN ('Markups', 'Markups - RA') ];
            
            For (System_Level_Parameter__c SLP : SLPList ){
                if(SLP.Category__c == 'Markups' && ProjectType == 'New Construction'){
                        if (SLP.Name == 'Design and Site Contingency' ) {
                            intDesignSiteContingency = SLP.Value__c ;
                        }
                        if (SLP.Name == 'General Contractor Overhead Profit and Bonds' ) {
                            intGeneralContractorOverhead = SLP.Value__c ;
                        }
                        if (strBuildingSelection == 'Existing' && (Building_Cost_Type == 'TI Only' || Building_Cost_Type == 'TI Including Warm Lit Shell' ||Building_Cost_Type == 'TI Retrofit')) {
                            if (SLP.Name == 'Construction Contingency - TI'){
                                intConstructionContingency = SLP.Value__c ;
                            }
                        }else{
                            
                            if(SLP.Name == 'Construction Contingency'){
                                intConstructionContingency = SLP.Value__c ;
                            }
                        }
                        if(Include_Exclude_AIA == True && SLP.Name == 'Art-In-Architecture'){
                                intArtInArchitecture = SLP.Value__c ;
                        }
                        if (SLP.Name == 'Special Use/Gross Receipts Tax' ) {
                            SpecialUseGrossReceiptsTax = SLP.Value__c ;
                        }
                }else if(SLP.Category__c == 'Markups - RA' && ProjectType != 'New Construction'){
                        if (SLP.Name == 'Design and Site Contingency' ) {
                            intDesignSiteContingency = SLP.Value__c ;
                        }
                        if (SLP.Name == 'General Contractor Overhead Profit and Bonds' ) {
                            intGeneralContractorOverhead = SLP.Value__c ;
                        }
                        if (SLP.Name == 'Construction Contingency' ) {
                            intConstructionContingency = SLP.Value__c ;
                        }
                        if(Include_Exclude_AIA == True && SLP.Name == 'Art-In-Architecture'){
                                intArtInArchitecture = SLP.Value__c ;
                        }
                        if (SLP.Name == 'Special Use/Gross Receipts Tax' ) {
                            SpecialUseGrossReceiptsTax = SLP.Value__c ;
                        }
                }
            }
        }
         
        NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
        
        for(NCMT_Project__c objProj :projList){
            //update Project Markups from System Level Parameters
            if(ProjectRecordTypeName != 'LPOE'){
                objProj.Design_and_Site_Contingency__c = intDesignSiteContingency;
                objProj.General_Contractor_Overhead_Profit_Bonds__c = intGeneralContractorOverhead;
                objProj.Construction_Contingency__c = intConstructionContingency;
                objProj.Art_In_Architecture__c = intArtInArchitecture;
                objProj.Special_Use_Gross_Receipts_Tax__c = SpecialUseGrossReceiptsTax;
                objProj.Cost_Parameter_Date__c = ncmt_customsettings.Cost_Parameter_Date__c;
            }else{
                objProj.Cost_Parameter_Date__c = ncmt_customsettings.Cost_Parameter_Date__c;
            }
        }  
        //system.debug('ncmt_customsettings.Cost_Parameter_Date__c==='+ ncmt_customsettings.Cost_Parameter_Date__c);     
    }
    
    public void UpdateHPData(Id PIds, String ProjectRecordTypeName) {
        
        list<NCMT_Housing_Plan__c> HPList = [select id from NCMT_Housing_Plan__c where Project__c = :PIds ];
        //NCMT_Housing_Plan__c HP = [SELECT Id FROM NCMT_Housing_Plan__c WHERE Project__c = :PIds ];
        update HPlist;
        
        /*NCMT_Housing_Plan_Summary__c HP = [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :PIds ];
        update HP;*/
    }

    public void UpdateOtherCosts(Id PIds, String ProjectRecordTypeName) {
        List <NCMT_Other_Cost__c> OClst = [SELECT Id FROM NCMT_Other_Cost__c WHERE NCMT_Project__c = :PIds] ;
        List<NCMT_Other_Cost__c> ListOfOCtobeUpdated = new list<NCMT_Other_Cost__c>();      
        for (NCMT_Other_Cost__c RowData : OClst ) { 
            ListOfOCtobeUpdated.Add(new NCMT_Other_Cost__c(
                        ID = (ID) RowData.get('ID'))
                );
        }
        update ListOfOCtobeUpdated;
        
    }
    /*        
    public void DeleteHousingPlanData (ID ProjectID) {
        List <NCMT_Housing_Plan__c> lstDelete = [SELECT Id from NCMT_Housing_Plan__c where Project__c = :ProjectID limit 50000] ;
        IF (lstDelete.size() > 0) Delete lstDelete;
    }
    */   
    //delete Housing Plan Summary record
    public void DeleteHousingPlanSummaryData (ID ProjectID) {
        List <NCMT_Housing_Plan_Summary__c> lstDelete = [SELECT Id from NCMT_Housing_Plan_Summary__c where Project__c = :ProjectID limit 50000] ;
        IF (lstDelete.size() > 0) Delete lstDelete;
    }
    
    //delete LPOE Space Plan record
    public void DeleteLPOESpacePlanData (ID ProjectID) {
        List <LPOE_Space_Plan__c> lstDelete = [SELECT Id from LPOE_Space_Plan__c where Project_name__c = :ProjectID limit 50000] ;
        IF (lstDelete.size() > 0) Delete lstDelete;
    }
        
    public void DeletePLPData (ID ProjectID) {
        //if (!plpGenerated){
            List <Project_Level_Parameter__c> lstDelete = new List <Project_Level_Parameter__c>();
            if (projParam != null){
                lstDelete.add(projParam);
            } else {
                lstDelete = [SELECT Id from Project_Level_Parameter__c where NCMT_Project__c = :ProjectID limit 50000] ;
            }
            IF (lstDelete.size() > 0){
                Delete lstDelete;
                projParam = null;
            }
        //}
    }   

    public void DeleteSiteInfoData (ID ProjectID) {
        List <Site_Information__c> lstDelete = [SELECT Id from Site_Information__c where Project__c = :ProjectID limit 50000] ;
        IF (lstDelete.size() > 0) Delete lstDelete;
    }   
    /*    
    public void DeleteProfServEstData (ID ProjectID) {
        List <Professional_Service_Estimate__c> lstDelete = [SELECT Id from Professional_Service_Estimate__c where NCMT_Project__c = :ProjectID limit 50000] ;
        IF (lstDelete.size() > 0) Delete lstDelete;
    }       
    */
    public static integer roundofneg(decimal value,integer paddingAmount ) {
        paddingAmount  = math.abs(paddingAmount);
        integer keyvalue = Math.round(value);
        integer size = string.valueof(keyvalue).length();
         if(size >paddingAmount) {
            if(paddingAmount  > 0 && value > 0) {
                system.debug('keyvalue =='+keyvalue );
                string temp= string.valueof(keyvalue);
                string temp2= temp.substring(temp.length()-paddingAmount,temp.length()-(paddingAmount-1));
                system.debug('temp2=='+temp2);
                boolean flag = integer.valueof(temp2) >= 5;
                system.debug(flag );
                string temp1= temp.substring(0,temp.length()-paddingAmount );
                if(temp1 == null || temp1 =='')
                   temp1= '0';
                if(flag)
                    temp1= string.valueof(integer.valueof(temp1)+1);
                for(integer i = 0; i < paddingAmount ; i++)
                    temp1+= '0';
                integer finalvalue = integer.valueof(temp1);
                return finalvalue ;
            }
            else
                return keyvalue;
         }
         else
                 return 0;

   }   
    
    //Insert related housing plan data when cloning
    public void generateHousingPlanCloneData(String origId, String projId, Boolean blnHousingPlan)
    {
        System.debug('generateHousingPlanData');
        System.debug('projId: ' + projId);
        System.debug('origId: ' + origId);
        Decimal SiteAreaSqFt = 0.0;
        NCMT_Project__c proj = [SELECT Id, Project_Record_ID__c
                                FROM NCMT_Project__c 
                                WHERE Id =: projId];
        
        if(origId == null)
        {
            //Not a clone. Set Project Record Id
            System.debug('Not a clone');
            proj.Project_Record_Id__C = projId;
            update proj;
        }
        else if(origId != null && blnHousingPlan)
        {
            //Call Queueable method 
            System.debug('Invoking HousingPlanClone');
            NCMT_HousingPlanClone hpc = new NCMT_HousingPlanClone(origId, projId);
            hpc.cloneHousingPlanSync(proj);
            hpc.cloneCoreShellCostDetails();
            //New Code
            List<Site_Information__c> lstSites = [Select Site_Area_for_Default_Value__c From Site_Information__c Where Project__c = :projId Limit 1];
            for(Site_Information__c objItem : lstSites){
            SiteAreaSqFt = objItem.Site_Area_for_Default_Value__c;
            }
            //New Code End
            //Update Project Record Id on cloned Project
            proj.Project_Record_ID__c = projId;
            proj.Calculated_Site_Area__c = SiteAreaSqFt;
            update proj;
        } else if(origId != null &&!blnHousingPlan){
            List<NCMT_Housing_Plan_Option_Selection__c> newSelects = new List<NCMT_Housing_Plan_Option_Selection__c>();
            for (NCMT_Housing_Plan_Option_Selection__c optSelect : [Select Id, NCMT_Housing_Plan_Option__c, NCMT_Housing_Plan__c, NCMT_Project__c, NCMT_Project__r.RecordTypeId, Recurrence__c
                from NCMT_Housing_Plan_Option_Selection__c where NCMT_Project__c =: origId]
            ){
                NCMT_Housing_Plan_Option_Selection__c clone = optSelect.clone(false,true);
                clone.NCMT_Project__c = projId;
                newSelects.add(clone);
            }
            NCMT_HousingPlan_OptSelection_Handler.skipGenerateProject = false;
            NCMT_GenerateProjectDetailsExt.genHPRun = false;
            insert newSelects;

        }
    }
}