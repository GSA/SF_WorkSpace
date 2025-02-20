trigger NCMT_BuildingMassingByFloortrigger on NCMT_Building_Massing_By_Floor__c (after insert,after update,before update) {
    set<id> NCMTIds = new  set<id>();
    set<id> NCMTIdsset = new  set<id>();
    set<id> NPIdsset = new  set<id>();
    set<id>PLPIds = new  set<id>();
    map<id,decimal> maplist = new map<id,decimal>();
    map<id,Project_Level_Parameter__c> plpmap = new map<id,Project_Level_Parameter__c>();
    map<id,NCMT_Project__c > ncmtmap = new map<id,NCMT_Project__c >();
    map<id,NCMT_Housing_Plan_Summary__c> hpmap = new map<id,NCMT_Housing_Plan_Summary__c>();
    map<string,Decimal> basementValue = new map<string,decimal>();
    map<string,Decimal> basementValue1 = new map<string,decimal>();
    map<string,Decimal> basementValue2 = new map<string,decimal>();
    list<NCMT_Building_Massing_By_Floor__c> ncmtlist = new list<NCMT_Building_Massing_By_Floor__c> ();
    list<Project_Level_Parameter__c> PLPListToupdate = new list<Project_Level_Parameter__c>();
    map<string,NCMT_RA_Mods__c> RAModsMap = new map<string,NCMT_RA_Mods__c>();
    string strFiscalYear, strProjectType;
    string fieldName,fieldName1, fieldName2, fieldName3, fieldName6, fieldName7, fieldName8, fieldName9, fieldName10, fieldName11, fieldName12, fieldName16, fieldName17;
    map<id,string> dominantVal = new map<id,string>();
    
    System.debug('RUN BMbF TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
    for(NCMT_Building_Massing_By_Floor__c ncmtbmf : Trigger.new) {
        NCMTIds.add(ncmtbmf.Proj_Level_Parameter__c);
        PLPIds.add(ncmtbmf.Proj_Level_Parameter__c);
    }
    for(Project_Level_Parameter__c PLP:[SELECT id,above_ground__c,below_Ground__c,Building_Parameter__c,Default_Basement_Story_Height__c,Cladding_Skin_Ratio__c,Cladding_Retaining_Wall__c,Glazing_Ratio_of_above_grade_skin__c,Green_Roof_BG__c,
                                               HVAC_Heating_Load__c,HVAC_Cooling_Load__c,HVAC_Air_Handling_Capacity__c,Atrium_Area_SF__c,Curtain_Wall_Percentage_Total_Window__c,Atrium_Phantom_Floors__c,Roofing_Skylights__c,Sloped_Roof_BG__c,
                                               NCMT_Project__c,NCMT_Project__r.Total_GSF__c,Default_Fin_Wall_Modifiers__c,Roofing_Sloped_Roof_PS__c,Roofing_Green_Roof_PS__c, Overall_Condition_Structural_Frame__c, Code_Seismic_Compliance__c,
                                               Overall_Condition_Cladding__c, Cladding_Code__c, Dominant_Glazing_System1__c, Overall_Condition_Glazing_System__c, Dominant_Glazing_System2__c, Dominant_Glazing_System3__c ,
                                               Overall_Condition_Roofing__c, Character__c, Overall_Condition_Interiors__c, Overall_Condition_Conveying__c, Overall_Condition_Plumbing__c,
                                               Overall_Condition_HVAC__c, Overall_Condition_Electrical__c, Overall_Condition_Fire_Protection__c, Overall_condition__c,Utilities_Condition__c,
                                               Override_Glazing_Ratio_SF__c,Override_Finished_Wall_Area_SF__c
                                          FROM Project_Level_Parameter__c 
                                         WHERE id IN :PLPIds]) {
        maplist.put(PLP.Id,PLP.above_ground__c);
        plpmap.put(PLP.Id,PLP);
        NCMTIdsset.add(PLP.NCMT_Project__c);
    }
    for(NCMT_Project__c  PLP1:[SELECT id,recordtypeId,Parking_Garage_Gross_Area_SF__c,below_Grade__c, Gross_Area_Including_Parking__c, Building_type__c, Project_Type__c, Dominant_Period__c, Cost_Parameter_Date_FY__c
                                 FROM NCMT_Project__c 
                                WHERE id In :NCMTIdsset]) {
        ncmtmap.put(PLP1.Id,PLP1 );  
        NPIdsset.add(PLP1.id);
        strFiscalYear = PLP1.Cost_Parameter_Date_FY__c;
        dominantVal.put(PLP1.id,PLP1.Dominant_Period__c);
        strProjectType = PLP1.Project_Type__c;
    }
     
    for(NCMT_Housing_Plan_Summary__c  HP1:[SELECT Project__c,Atrium_Ground_floor_plan_area__c,Atrium_upper_levels_phantom_floors__c,Total_GSF__c    
                                             FROM NCMT_Housing_Plan_Summary__c 
                                            WHERE Project__c In :NPIdsset]) {
        hpmap.put(HP1.Project__c,HP1 ); 
    }
     
    if(Trigger.isbefore) {
        Decimal totalUseAreaSf = 0; 
        Decimal totalgrosssf = 0;
        string ncmtId;
        
        for(NCMT_Building_Massing_By_Floor__c ncmtbmf : Trigger.new) {
            ncmtId = ncmtbmf.id;
        
        }
        //for calculating Total Use Area Sf
        for (AggregateResult BMF : [SELECT sum(use_area_sf__c)sum FROM NCMT_Building_Massing_By_Floor__c 
                                     WHERE Proj_Level_Parameter__c In : PLPIds and id !=:ncmtId
                                  GROUP BY Proj_Level_Parameter__c]) {
            totalUseAreaSf = integer.valueof(BMF.get('sum'));                
        }
        
        for (AggregateResult BMF : [SELECT sum(default_area_sf__c)sum FROM NCMT_Building_Massing_By_Floor__c 
                                    WHERE  Proj_Level_Parameter__c In : PLPIds 
                                 GROUP BY  Proj_Level_Parameter__c]) {
            totalgrosssf = integer.valueof(BMF.get('sum'));                
        }   
        for(NCMT_Building_Massing_By_Floor__c ncmtbmf : Trigger.new) {
            
            if(trigger.oldmap.get(ncmtbmf.id).get('use_area_sf__c') !=ncmtbmf.use_area_sf__c ) {
                totalUseAreaSf = totalUseAreaSf + ncmtbmf.use_area_sf__c;
            }
            if(totalUseAreaSf > totalgrosssf){
                ncmtbmf.addError('Total User Area SF should be equal to Total Gross Area(GSF)');
            }
        }   
     }

     if(TriggerValue.firstRun && Trigger.isafter) {
        
        TriggerValue.firstRun = false; 
        
        // calculating skylights based on override use area sf
        if(trigger.isupdate && strProjectType == 'New Construction'){
            ncmtlist = [SELECT Building_Massing_Area__c,Proj_Level_Parameter__c ,Use_Area_SF__c, Default_Skylights_SF__c  
                          FROM NCMT_Building_Massing_By_Floor__c 
                         WHERE Proj_Level_Parameter__c IN : NCMTIds 
                      ORDER BY name];
            Decimal aboveGround= maplist.get(ncmtlist[0].Proj_Level_Parameter__c );
         
            for(integer i= 0 ;i<ncmtlist.size();i++) {
                if(i<(ncmtlist.size()-1) ){
                    ncmtlist[i+1].Default_Skylights_SF__c = math.max(ncmtlist[i].Use_Area_SF__c-ncmtlist[i+1].Use_Area_SF__c,0);
                }  
                else if(aboveGround > 20){
                    ncmtlist[i].Default_Skylights_SF__c = ncmtlist[i].Use_Area_SF__c;
                }   
                else{
                    ncmtlist[i].Default_Skylights_SF__c = 0;
                }
            }
            update ncmtlist;
        }
        // for updating project level parameters based on building massing by floor records
        if((trigger.isupdate || trigger.isinsert) && trigger.isafter){
           
           Decimal retainingwall = 0;
           Decimal bgsfatriumsf = 0;
           Decimal heatingload = 0;
           Decimal Coolingload = 0;
           Decimal airhandlingcapacity = 0;
           Decimal skinratiosf = 0;
           Decimal retainingwallsf = 0;
           Decimal finishedwallareasf = 0;
           Decimal glazingratiosf = 0;
           Decimal curtainwallpercentage = 0;
           Decimal curtainwallpercentagesf = 0;
           Decimal finishedopaquewallsf = 0;
           Decimal windowpercentage =0;
           Decimal windowpercentagesf = 0;
           Decimal roofingskylights = 0;
           Decimal sumdefaultareasf =0;
           Decimal totalroofarea = 0;
           Decimal basementroofarea = 0;
           Decimal upperroofsf = 0;
           Decimal slopedroofsf = 0;
           Decimal greenroofsf = 0;
           Decimal flatroofsf = 0;
           Decimal roofingskylightssf = 0;
           Decimal maxroofingskylights = 0;
           Decimal Basesf = 0;
           Decimal midsf = 0;
           Decimal topsf = 0;
           Decimal numberofstairsperfloor = 0;
           Decimal stairanalysistotalflights = 0;
           Decimal atriumsf = 0;
           Decimal totalgrosssf = 0;
           string PLPID;
           string buildingMassId;
           
           for(NCMT_Building_Massing_By_Floor__c ncmtbmf : Trigger.new) {
            
              buildingMassId = ncmtbmf.Proj_Level_Parameter__c;
              PLPID = ncmtbmf.Proj_Level_Parameter__c;
           }
           for(NCMT_Building_Massing_By_Floor__c ncmt : [select Building_Massing_Area__c,Default_Skylights_SF__c,Default_Area_SF__c, Use_Area_SF__c from NCMT_Building_Massing_By_Floor__c where Proj_Level_Parameter__c=:buildingMassId]) {
                basementValue.put(ncmt.Building_Massing_Area__c,ncmt.Use_Area_SF__c);   
                basementValue1.put(ncmt.Building_Massing_Area__c,ncmt.Default_Area_SF__c);
                basementValue2.put(ncmt.Building_Massing_Area__c,ncmt.Default_Skylights_SF__c);
           }
            
           Project_Level_Parameter__c PLP= plpmap.get(PLPID );
           
             NCMT_Project__c ncmt = ncmtmap.get(PLP.NCMT_Project__c);           
             NCMT_Housing_Plan_Summary__c hp = hpmap.get(PLP.NCMT_Project__c);
             atriumsf = hp.Atrium_Ground_floor_plan_area__c;
             if(ncmt.project_type__c == 'New Construction' && ncmt.building_type__c != 'Parking Garage'){
                totalgrosssf= hp.Total_GSF__c;
             }else{
                totalgrosssf= ncmt.Gross_Area_Including_Parking__c;
             }
             
           //for calculating roofing skylights
           for (AggregateResult BMF : [SELECT sum(Default_Skylights_SF__c)sum, Max(Default_Skylights_SF__c) max, Proj_Level_Parameter__c 
                                         FROM NCMT_Building_Massing_By_Floor__c 
                                        WHERE Proj_Level_Parameter__c =: Trigger.new[0].Proj_Level_Parameter__c 
                                     GROUP BY Proj_Level_Parameter__c  limit 1]) {
                roofingskylights = integer.valueof(BMF.get('sum'));
                maxroofingskylights = integer.valueof(BMF.get('max'));
            }
            //for calculating Cladding SF in project level parameters
            for (AggregateResult BMF : [SELECT sum(Default_Area_SF__c)sum,Proj_Level_Parameter__c 
                                         FROM NCMT_Building_Massing_By_Floor__c 
                                        WHERE Proj_Level_Parameter__c =: Trigger.new[0].Proj_Level_Parameter__c 
                                          AND (Building_Massing_Area__c like '%FloorSF%'
                                           OR Building_Massing_Area__c like '%Ground%'
                                           OR Building_Massing_Area__c like '%Penthouse%')
                                     GROUP BY Proj_Level_Parameter__c  limit 1]) {
                sumdefaultareasf = integer.valueof(BMF.get('sum'));
                
             }
            
         if(ncmt.RecordTypeid != Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId()){
            TriggerValue.isupdate1 = false;   
           //for calculating cladding retaining wall 
             if(PLP.below_Ground__c > 0){
                retainingwall = ((8*(Math.Sqrt((basementValue.get('Basement2 SF') + basementValue.get('Basement1 SF') )/2)))*((PLP.Default_Basement_Story_Height__c +2)/totalgrosssf)).setscale(3);
             }    
             else {
                retainingwall  = 0;
             }
             // for calculating cladding retaining wall sf 
             if(TriggerValue.isinsert){
               retainingwallsf = Math.Round(retainingwall * totalgrosssf); 
             }
             else {
               retainingwallsf = Math.Round(PLP.Cladding_Retaining_Wall__c * totalgrosssf);
          
             }
          bgsfatriumsf = (PLP.Atrium_Phantom_Floors__c * atriumsf) + totalgrosssf;
          heatingload = Math.Round(bgsfatriumsf/PLP.HVAC_Heating_Load__c);                    
          coolingload = Math.Round(bgsfatriumsf*PLP.HVAC_Cooling_Load__c);                        
          airhandlingcapacity = Math.Round(bgsfatriumsf * PLP.HVAC_Air_Handling_Capacity__c);
          skinratiosf = Math.Round(bgsfatriumsf * PLP.Cladding_Skin_Ratio__c);
          finishedwallareasf = (skinratiosf - retainingwallsf);   
          glazingratiosf = Math.Round((PLP.Glazing_Ratio_of_above_grade_skin__c / 100) * (skinratiosf - retainingwallsf)); 
          //if(TriggerValue.isinsert){
                finishedopaquewallsf = (skinratiosf - retainingwallsf - glazingratiosf); 
          //}else{
                if(ncmt.project_type__c != 'New Construction' && !TriggerValue.isinsert){
                    finishedopaquewallsf = PLP.Override_Finished_Wall_Area_SF__c - PLP.Override_Glazing_Ratio_SF__c;
                }
          //}
          // for calculating base sf in cladding
          if((PLP.Above_Ground__c + PLP.Below_Ground__c) == 1){
            
                basesf = Math.Round((basementValue1.get('Ground SF')/sumdefaultareasf)*finishedopaquewallsf);
            
          }
          else if((PLP.Above_Ground__c + PLP.Below_Ground__c) >= 2){
                if(PLP.Building_Parameter__c == 'CO'){
                     basesf = NCMT_GenerateProjectDetails.roundofneg(((basementValue1.get('Ground SF')+basementValue1.get('FloorSF-2'))/sumdefaultareasf)*finishedopaquewallsf,-2);
                }
                else{
                     basesf = NCMT_GenerateProjectDetails.roundofneg((basementValue1.get('Ground SF')/sumdefaultareasf)*finishedopaquewallsf,-2);
                }
          }
          
          curtainwallpercentage = (basesf/finishedopaquewallsf).setscale(2);
          if(TriggerValue.isinsert){
             windowpercentage = Math.Round((1 - curtainwallpercentage)*100);  
             curtainwallpercentagesf = glazingratiosf * curtainwallpercentage;
          } 
          else{
             windowpercentage = Math.Round((1 - PLP.Curtain_Wall_Percentage_Total_Window__c)*100);
             curtainwallpercentagesf = glazingratiosf * PLP.Curtain_Wall_Percentage_Total_Window__c;
          }            
          windowpercentagesf = (glazingratiosf * windowpercentage)/100;    
          // for calculating top sf for cladding
          if((PLP.Above_Ground__c + PLP.Below_Ground__c) == 1) {
              topsf = 0;
          }  
          else if((PLP.Above_Ground__c + PLP.Below_Ground__c) >= 2) {
               if(PLP.Building_Parameter__c == 'CO'){
                  topsf = 0;
               }
               else{
                  topsf = NCMT_GenerateProjectDetails.roundofneg((maxroofingskylights/sumdefaultareasf) * finishedopaquewallsf,-2);
               }
          }
             midsf =  finishedopaquewallsf - basesf - topsf;
          // calculating roofing sf
          totalroofarea =  roofingskylights;
          basementroofarea = basementValue2.get('Ground SF');
          upperroofsf = (totalroofarea - basementroofarea);
          if (PLP.Sloped_Roof_BG__c == null) {
            PLP.Sloped_Roof_BG__c = 0;
          }
          if (PLP.Green_Roof_BG__c == null) {
            PLP.Green_Roof_BG__c = 0;
          }
          if (PLP.Roofing_Skylights__c == null) {
            PLP.Roofing_Skylights__c = 0;
          }          
          slopedroofsf = PLP.Sloped_Roof_BG__c * totalroofarea ;
          greenroofsf = PLP.Green_Roof_BG__c * totalroofarea;
          flatroofsf = upperroofsf - slopedroofsf -greenroofsf;
          if(TriggerValue.isinsert){
             if(ncmt.project_type__c == 'New Construction' && ncmt.building_type__c != 'Parking Garage'){
                roofingskylightssf = Math.Min(Math.round(roofingskylights*0.03),(flatroofsf*0.2));
             }else{                 
               roofingskylightssf = Math.Min(PLP.Roofing_Skylights__c,(flatroofsf*0.2));
             }
          }
          else{
             roofingskylightssf = Math.Min(PLP.Roofing_Skylights__c,(flatroofsf*0.2));
          }
          // formula for calculating stair analysis total flights
          numberofstairsperfloor = Math.Max(2,Math.Ceil((totalgrosssf/(PLP.Above_Ground__c + PLP.Below_Ground__c))/100000));
          if((PLP.Above_Ground__c + PLP.Below_Ground__c) == 1) {
              stairanalysistotalflights = 0;
          }
          else{
              stairanalysistotalflights = (numberofstairsperfloor * ((PLP.Above_Ground__c + PLP.Below_Ground__c)-1) + 1);
          }
          
          Project_Level_Parameter__c plps = new Project_Level_Parameter__c();
          plps.id=PLPId;
              
          //for repair and alteration RA Mods calculations
          if(ncmt.Project_Type__c == 'Repair & Alteration - Parametric Entry' || ncmt.Project_Type__c == 'Repair & Alteration - Work Item Detail'){        
                for(NCMT_RA_Mods__c RAMods : [SELECT  ID, RA_Category__c, RA_Category_Type__c,Fiscal_Year__c, Cost_Category__r.Name, Very_Good__c, Good__c, Moderate__c,
                                                      Poor__c, Very_Poor__c
                                                    FROM  NCMT_RA_Mods__c 
                                                    WHERE Fiscal_Year__c = :strFiscalYear
                                                    ])
                {
                          string keyModsValue = RAMods.RA_Category_Type__c+RAMods.RA_Category__c;
                          RAModsMap.put(keyModsValue,RAMods);                                                       
                } 
          
            //Calculation for Structure 
            string key = 'Structural'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName = PLP.Overall_Condition_Structural_Frame__c.replaceAll(' ','_');
                   fieldName =  fieldName+'__c';
                   NCMT_RA_Mods__c temp = RAModsMap.get(key);  
            //Calculation for Seismic
            string key1 = 'Seismic'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName1 = PLP.Code_Seismic_Compliance__c.replaceAll(' ','_');
                   fieldName1 =  fieldName1+'__c';
                   NCMT_RA_Mods__c temp1 = RAModsMap.get(key1); 
            //Calculation for Cladding
            string key2 = 'Cladding'+PLP.Cladding_Code__c;
                   fieldName2 = PLP.Overall_Condition_Cladding__c.replaceAll(' ','_');
                   fieldName2 =  fieldName2+'__c';
                   NCMT_RA_Mods__c temp2 = RAModsMap.get(key2);   
            //Calculation for Windows1 Glazing System
            string key3 = 'Windows1'+PLP.Dominant_Glazing_System1__c;
                   fieldName3 = PLP.Overall_Condition_Glazing_System__c.replaceAll(' ','_');
                   fieldName3 =  fieldName3+'__c';
                   NCMT_RA_Mods__c temp3 = RAModsMap.get(key3);  
            //Calculation for Window3 Glazing System
            string key4 = 'Windows3'+PLP.Dominant_Glazing_System2__c;
                   NCMT_RA_Mods__c temp4 = RAModsMap.get(key4); 
            //Calculation for Window2 Glazing System
            string key5 = 'Windows2'+PLP.Dominant_Glazing_System3__c;
                   NCMT_RA_Mods__c temp5 = RAModsMap.get(key5); 
            //Calculation for roofing
            string key6 = 'Roofing'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName6 = PLP.Overall_Condition_Roofing__c.replaceAll(' ','_');
                   fieldName6 =  fieldName6+'__c';
                   NCMT_RA_Mods__c temp6 = RAModsMap.get(key6);  
            //Calculation for Interiors
            string key7 = 'Interiors'+PLP.Character__c;
                   fieldName7 = PLP.Overall_Condition_Interiors__c.replaceAll(' ','_');
                   fieldName7 =  fieldName7+'__c';
                   NCMT_RA_Mods__c temp7 = RAModsMap.get(key7); 
            //Calculation for Elevators
            string key8 = 'Elevators'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName8 = PLP.Overall_Condition_Conveying__c.replaceAll(' ','_');
                   fieldName8 =  fieldName8+'__c';
                   NCMT_RA_Mods__c temp8 = RAModsMap.get(key8); 
            //Calculation for Plumbing
            string key9 = 'Plumbing'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName9 = PLP.Overall_Condition_Plumbing__c.replaceAll(' ','_');
                   fieldName9 =  fieldName9+'__c';
                   NCMT_RA_Mods__c temp9 = RAModsMap.get(key9); 
            //Calculation for HVAC
            string key10 = 'HVAC'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName10 = PLP.Overall_Condition_HVAC__c.replaceAll(' ','_');
                   fieldName10 =  fieldName10+'__c';
                   NCMT_RA_Mods__c temp10 = RAModsMap.get(key10);
            //Calculation for Electrical
            string key11 = 'Electrical'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName11 = PLP.Overall_Condition_Electrical__c.replaceAll(' ','_');
                   fieldName11 =  fieldName11+'__c';
                   NCMT_RA_Mods__c temp11 = RAModsMap.get(key11);   
            //Calculation for Fire Protection
            string key12 = 'Fire Protection'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName12 = PLP.Overall_Condition_Fire_Protection__c.replaceAll(' ','_');
                   fieldName12 =  fieldName12+'__c';
                   NCMT_RA_Mods__c temp12 = RAModsMap.get(key12); 
            //Calculation for User Power
            string key13 = 'User Power'+dominantVal.get(PLP.NCMT_Project__c);
                   NCMT_RA_Mods__c temp13 = RAModsMap.get(key13); 
            //Calculation for Lighting
            string key14 = 'Lighting'+dominantVal.get(PLP.NCMT_Project__c);
                   NCMT_RA_Mods__c temp14 = RAModsMap.get(key14); 
            //Calculation for Telecom/IT
            string key15 = 'Telecom/IT'+dominantVal.get(PLP.NCMT_Project__c);
                   NCMT_RA_Mods__c temp15 = RAModsMap.get(key15);  
            //Calculation for Site
            string key16 = 'Site'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName16 = PLP.Overall_condition__c.replaceAll(' ','_');
                   fieldName16 =  fieldName16+'__c'; 
                   NCMT_RA_Mods__c temp16 = RAModsMap.get(key16); 
           //Calculation for Sutil
            string key17 = 'Sutil'+dominantVal.get(PLP.NCMT_Project__c);
                   fieldName17 = PLP.Utilities_Condition__c.replaceAll(' ','_');
                   fieldName17 =  fieldName17+'__c'; 
                   NCMT_RA_Mods__c temp17 = RAModsMap.get(key17);
                   
                 
           
              plps.RA_Str_Mod__c = (decimal)(temp.get(fieldName)); 
              plps.RA_Seis_Mod__c = (decimal)(temp1.get(fieldName1)); 
              plps.RA_Clad_Mod__c = (decimal)(temp2.get(fieldName2));
              plps.RA_Glaz_Mod__c = (decimal)(temp3.get(fieldName3)) + (decimal)(temp4.get(fieldName3)) + (decimal)(temp5.get(fieldName3));
              plps.RA_Roof_Mod__c = (decimal)(temp6.get(fieldName6));  
              plps.RA_Int_Mod__c =  (decimal)(temp7.get(fieldName7)); 
              plps.RA_Elev_Mod__c = (decimal)(temp8.get(fieldName8)); 
              plps.RA_Plum_Mod__c = (decimal)(temp9.get(fieldName9));
              plps.RA_HVAC_Mod__c = (decimal)(temp10.get(fieldName10));  
              plps.RA_Elec_Mod__c = (decimal)(temp11.get(fieldName11));  
              plps.RA_FP_Mod__c = (decimal)(temp12.get(fieldName12)); 
              plps.RA_UP_Mod__c = (decimal)(temp13.get(fieldName11));  
              plps.RA_LTG_Mod__c = (decimal)(temp14.get(fieldName11));
              plps.RA_TLC_Mod__c = (decimal)(temp15.get(fieldName11)); 
              plps.RA_SITE_Mod__c = (decimal)(temp16.get(fieldName16));
              plps.RA_UTIL_Mod__c = (decimal)(temp17.get(fieldName17)); 
              
              //PLPListToupdate.add(plps);     
          } 
                                   
          //Project_Level_Parameter__c plps = new Project_Level_Parameter__c();
          //plps.id=PLPId;
          plps.Default_Retaining_Wall__c = retainingwall;
          plps.BGSF_Atrium_SF__c = bgsfatriumsf;
          plps.HVAC_Heating_Load_Mbtu__c = heatingload;
          plps.HVAC_Cooling_Load_Tons__c = coolingload;
          plps.HVAC_Air_Handling_Capacity_CFM__c = airhandlingcapacity;
          plps.Cladding_Skin_Ratio_SF__c = skinratiosf;
          plps.Cladding_Retaining_Wall_SF__c = retainingwallsf;
          plps.Finished_Wall_Area_SF__c = finishedwallareasf;
          plps.Finished_Wall_Area__c = finishedwallareasf/totalgrosssf;
          plps.Glazing_Ratio_SF__c = glazingratiosf;
          plps.Default_Curtain_Wall_Percentage__c = (curtainwallpercentage*100);
          plps.Curtain_Wall_Percentage_SF__c = curtainwallpercentagesf;
          plps.Finished_Opaque_Wall_SF__c = finishedopaquewallsf;
          plps.Window_Percentage__c = windowpercentage;
          plps.Window_Percentage_SF__c = windowpercentagesf;
          if(ncmt.project_type__c == 'New Construction' && ncmt.building_type__c != 'Parking Garage'){
             plps.Default_Roofing_Skylights__c = Math.Round(roofingskylights * 0.03);
          }
          plps.Cladding_Retaining_Wall_SF__c = retainingwallsf;
          if(Trigger.isinsert && TriggerValue.isinsert) {
                if(ncmt.project_type__c == 'New Construction' && ncmt.building_type__c != 'Parking Garage'){
                    plps.Roofing_Skylights__c = Math.Round(roofingskylights * 0.03);
                }
              plps.Cladding_Retaining_Wall__c = retainingwall;
              plps.Curtain_Wall_Percentage_Total_Window__c = curtainwallpercentage;
          }
          plps.Base_SF__c = basesf;
          plps.Mid_SF__c = midsf;
          plps.Top_SF__c = topsf;
          plps.Total_Roof_Area_SF__c = totalroofarea;
          plps.Basement_Roof_SF__c = basementroofarea;
          plps.Upper_Roof_SF__c = upperroofsf;
          plps.Sloped_Roof_SF__c = slopedroofsf;
          plps.Green_Roof_SF__c = greenroofsf;
          plps.Flat_Roof_SF__c = flatroofsf;    
          plps.Roofing_Skylights_SF__c = roofingskylightssf; 
          plps.Stair_Analysis_Total_Flights__c = stairanalysistotalflights;  
             
          PLPListToupdate.add(plps);
         }
         // for parking garage record type 
         else if(trigger.isinsert && ncmt.RecordTypeid == Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId()){ 
            TriggerValue.isupdate1 = false;
            //for calculating cladding retaining wall 
            if(ncmt.below_Grade__c > 0){
                retainingwall = (6*(Math.Sqrt((basementValue.get('Basement2 SF') + basementValue.get('Basement1 SF'))/2))*(PLP.Default_Basement_Story_Height__c +2)/ncmt.Parking_Garage_Gross_Area_SF__c).setscale(3);
            }    
            else {
                retainingwall  = 0;
            }
            skinratiosf = ncmt.Parking_Garage_Gross_Area_SF__c * PLP.Cladding_Skin_Ratio__c;
            retainingwallsf = Math.Round(skinratiosf * (PLP.Below_Ground__c/(PLP.Above_Ground__c+PLP.Below_Ground__C)));
            finishedwallareasf = (skinratiosf - retainingwallsf) * PLP.Default_Fin_Wall_Modifiers__c;
            glazingratiosf = Math.Round((PLP.Glazing_Ratio_of_above_grade_skin__c / 100) * (skinratiosf - retainingwallsf));
            finishedopaquewallsf = (skinratiosf - retainingwallsf - glazingratiosf); 
            basesf = NCMT_GenerateProjectDetails.roundofneg(((basementValue1.get('Ground SF')+basementValue1.get('FloorSF-2'))/sumdefaultareasf)*finishedopaquewallsf,-2);
            topsf = NCMT_GenerateProjectDetails.roundofneg((maxroofingskylights/sumdefaultareasf) * finishedopaquewallsf,-2); 
            midsf =  finishedopaquewallsf - basesf - topsf;
            if(finishedopaquewallsf > 0){
                curtainwallpercentage = (basesf/finishedopaquewallsf).setscale(2);
            }
            curtainwallpercentagesf = glazingratiosf * curtainwallpercentage;
            windowpercentage = Math.Round((1 - curtainwallpercentage)*100);
            windowpercentagesf = (glazingratiosf * windowpercentage)/100; 
            totalroofarea =  roofingskylights;
            basementroofarea = basementValue2.get('Ground SF');
            upperroofsf = (totalroofarea - basementroofarea);
            slopedroofsf = PLP.Roofing_Sloped_Roof_PS__c * totalroofarea/100;
            greenroofsf = PLP.Roofing_Green_Roof_PS__c * totalroofarea/100;
            flatroofsf = upperroofsf - slopedroofsf -greenroofsf;
            roofingskylightssf = Math.Min(Math.round(roofingskylights*0.03),(flatroofsf*0.2));
            
            Project_Level_Parameter__c plps = new Project_Level_Parameter__c();
            plps.id=PLPId;
            plps.Default_Retaining_Wall__c = retainingwall;
            plps.Cladding_Retaining_Wall__c = retainingwall;
            plps.Cladding_Skin_Ratio_SF__c = skinratiosf;
            plps.Cladding_Retaining_Wall_SF__c = retainingwallsf;
            plps.Finished_Wall_Area_SF__c = finishedwallareasf;
            plps.Finished_Wall_Area__c = finishedwallareasf/ncmt.Parking_Garage_Gross_Area_SF__c;
            plps.Glazing_Ratio_SF__c = glazingratiosf;
            plps.Finished_Opaque_Wall_SF__c = finishedopaquewallsf;
            plps.Base_SF__c = basesf;
            plps.Top_SF__c = topsf;
            plps.Mid_SF__c = midsf;
            plps.Default_Curtain_Wall_Percentage__c = (curtainwallpercentage*100);
            plps.Curtain_Wall_Percentage_Total_Window__c = curtainwallpercentage;
            plps.Curtain_Wall_Percentage_SF__c = curtainwallpercentagesf;
            plps.Window_Percentage__c = windowpercentage;
            plps.Window_Percentage_SF__c = windowpercentagesf;
            plps.Total_Roof_Area_SF__c = totalroofarea;
            plps.Basement_Roof_SF__c = basementroofarea;
            plps.Upper_Roof_SF__c = upperroofsf;
            plps.Sloped_Roof_SF__c = slopedroofsf;
            plps.Green_Roof_SF__c = greenroofsf;
            plps.Flat_Roof_SF__c = flatroofsf; 
            plps.Default_Roofing_Skylights__c = Math.Round(roofingskylights * 0.03);
            plps.Roofing_Skylights__c = Math.Round(roofingskylights * 0.03);
            plps.Roofing_Skylights_SF__c = roofingskylightssf;
          
            PLPListToupdate.add(plps);
            
         }
         
         update PLPListToupdate; 
            
     }  
   } 
    }
}