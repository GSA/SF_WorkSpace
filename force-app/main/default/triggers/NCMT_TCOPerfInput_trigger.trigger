trigger NCMT_TCOPerfInput_trigger on NCMT_TCO_Performance_Input__c (before insert, before update,after update) {
    set<id> NCMTIDs = new set<id>();
    string fieldName1;
    NCMT_TCO_Performance_Input__c OldValues;
    
    System.debug('RUN PERF INPUT TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {

    if((trigger.isInsert && trigger.isBefore) || (trigger.isUpdate && trigger.IsBefore)) {
    
        string state ,city ,strclimatezone,CostParameterFY;
        Id perfId;
        Decimal dblHDD=0, dblCDD=0,dblInsolation=0,dblenthalpy=0;
        map<string,decimal> RoofModMap = new map<string,decimal>();
        map<string,decimal> RoofPerfMap = new map<string,decimal>();
        map<string,decimal> WallNomModMap = new map<string,decimal>();
        map<string,decimal> WallNomPerfMap = new map<string,decimal>();
        map<string,decimal> WallActPerfMap = new map<string,decimal>();
        map<string,decimal> GlazeModMap = new map<string,decimal>();
        map<string,decimal> GlazePerfMap = new map<string,decimal>();
        map<string,decimal> GlazeSHGPerfMap = new map<string,decimal>();
        map<string,decimal> SlabCostMap = new map<string,decimal>();
        map<string,decimal> CoolEffPerfMap = new map<string,decimal>();
        map<string,decimal> CoolSysLosPerfMap = new map<string,decimal>();
        map<string,decimal> CoolPumpMap = new map<string,decimal>();
        map<string,decimal> CoolEffModMap = new map<string,decimal>();
        map<string,decimal> CoolSysLosMap = new map<string,decimal>();
                                                          
        map<string,decimal> HeatEffPerfMap = new map<string,decimal>();
        map<string,decimal> HeatSysLosPerfMap = new map<string,decimal>();
        map<string,decimal> HeatPumpMap = new map<string,decimal>();
        map<string,decimal> HeatEffModMap = new map<string,decimal>();
        map<string,decimal> HeatSysLosMap = new map<string,decimal>();
        map<string,decimal> FanEffPerfMap = new map<string,decimal>();
        map<string,decimal> FanEffCostMod2Map = new map<string,decimal>();
        map<string,decimal> FanEffCostMod3Map = new map<string,decimal>();
        map<string,decimal> FanEffCostMod1Map = new map<string,decimal>();
        map<string,decimal> PlugPerfMap = new map<string,decimal>();
        map<string,decimal> PlugCostModMap = new map<string,decimal>();
        map<string,decimal> LightSysPerfMap = new map<string,decimal>();
        map<string,decimal> LightSysCostModMap = new map<string,decimal>();
        map<string,decimal> lightCtrlPerfMap = new map<string,decimal>();
        map<string,decimal> lightCtrlMod1Map = new map<string,decimal>();
        map<string,decimal> lightCtrlMod2Map = new map<string,decimal>();    
            
        map<string,NCMT_TCO_Parameter__c> WPEFFModsMap = new map<string,NCMT_TCO_Parameter__c>();
        
        //get current year and convert to string for comparison to fiscal year
        //NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
        //Date CostParameterDate = ncmt_customsettings.Cost_Parameter_Date__c;
        //string CostParameterYear = string.valueof(CostParameterDate.year()+1);
    
         for(NCMT_TCO_Performance_Input__c iter :trigger.new){
             perfId = iter.id;
             state = iter.State_Location__c ;
             city = iter.Index_Location__c;
             CostParameterFY = iter.CostParameterFY__c;
         }
            
            list<NCMT_Location_Parameters__c> locrec = [Select HDD__c,CDD__c, Insolation__c,Enthalpy__c,Climate_Zone__c
                                                                from NCMT_Location_Parameters__c 
                                                                where Name = :city and state__c = :state 
                                                      and fiscal_year__c= :CostParameterFY ];
            if (locrec.size()>0){                                              
                 dblHDD = locrec[0].HDD__c;
                 dblCDD = locrec[0].CDD__c;
                 dblInsolation =locrec[0].Insolation__c;
                 dblenthalpy = locrec[0].Enthalpy__c; 
                 strclimatezone = locrec[0].Climate_Zone__c;
            }
        
        
            for(NCMT_TCO_Parameter__c tcoplst:[SELECT Id,Name,Roof_Cost_Modifier__c,Wall_Nom_Cost_Modifier__c,Type__c,Glaz_R_Cost_Modifier__c,
                                                          Fiscal_Year__c,Slab_Unit_Cost__c,Very_High__c,High__c,GSA_Standard__c,Basic__c,None__c,
                                                          Envelope_Roof_Perf__c,Envelope_Wall_Act_Perf__c,Envelope_Wall_Nom_Perf__c,Glazing_R_Perf__c,Glazing_SHG_Perf__c,
                                                          Cooling_Eff_Perf__c,Cooling_System_Loss_Perf__c,Cooling_Pump_Energy_kBtu_SF_Yr__c,Cooling_Eff_Cost_Modifier__c,
                                                          Cooling_System_Loss_Cost__c,Heating_Eff_Cost_Modifier__c,Heating_Eff_Perf__c,Heating_Pump_Energy_kBtu_SF_Yr__c,
                                                          Heating_System_Loss__c,Heating_System_Loss_Perf__c,No__c,For_Landscaping__c,For_Landscaping_Building__c,Fan_Eff_Cost_Modifier_1__c,
                                                          Fan_Eff_Cost_Modifier_2__c,Fan_Eff_Cost_Modifier_3__c,Fan_Efficiency_Perf__c,Plug_Load_Modifier__c,Plug_Load_Perf__c,Lighting_System_Perf__c,
                                                          Lightning_System_Cost_Modifier__c,Lighting_Control_Perf__c,Lightning_Control_Cost_Modifier_1__c,Lightning_Control_Cost_Modifier_2__c,
                                                          Exemplary__c,Superior__c,Generally_Acceptable__c,Poor__c,Very_poor__c
                                                          FROM NCMT_TCO_Parameter__c
                                                           where fiscal_year__c = :CostParameterFY ]){
            
                RoofModMap.put(tcoplst.Type__c,tcoplst.Roof_Cost_Modifier__c);
                RoofPerfMap.put(tcoplst.Type__c,tcoplst.Envelope_Roof_Perf__c); 
                                                               
                WallNomModMap.put(tcoplst.Type__c,tcoplst.Wall_Nom_Cost_Modifier__c);
                WallNomPerfMap.put(tcoplst.Type__c,tcoplst.Envelope_Wall_Nom_Perf__c);
                                                               
                WallActPerfMap.put(tcoplst.Type__c,tcoplst.Envelope_Wall_Act_Perf__c);
                                                               
                SlabCostMap.put(tcoplst.Type__c,tcoplst.Slab_Unit_Cost__c );                                               
                                                               
                GlazeModMap.put(tcoplst.Type__c,tcoplst.Glaz_R_Cost_Modifier__c);
                GlazePerfMap.put(tcoplst.Type__c,tcoplst.Glazing_R_Perf__c);
                GlazeSHGPerfMap.put(tcoplst.Type__c,tcoplst.Glazing_SHG_Perf__c);                                               
                 
                
                WPEFFModsMap.put(tcoplst.Type__c,tcoplst); 
                                                               
                CoolEffPerfMap.put(tcoplst.Type__c,tcoplst.Cooling_Eff_Perf__c);
                CoolSysLosPerfMap.put(tcoplst.Type__c,tcoplst.Cooling_System_Loss_Perf__c);
                CoolPumpMap.put(tcoplst.Type__c,tcoplst.Cooling_Pump_Energy_kBtu_SF_Yr__c);
                CoolEffModMap.put(tcoplst.Type__c,tcoplst.Cooling_Eff_Cost_Modifier__c);
                CoolSysLosMap.put(tcoplst.Type__c,tcoplst.Cooling_System_Loss_Cost__c);
                                                               
                HeatEffPerfMap.put(tcoplst.Type__c,tcoplst.Heating_Eff_Perf__c);
                HeatSysLosPerfMap.put(tcoplst.Type__c,tcoplst.Heating_System_Loss_Perf__c);
                HeatPumpMap.put(tcoplst.Type__c,tcoplst.Heating_Pump_Energy_kBtu_SF_Yr__c);
                HeatEffModMap.put(tcoplst.Type__c,tcoplst.Heating_Eff_Cost_Modifier__c);
                HeatSysLosMap.put(tcoplst.Type__c,tcoplst.Heating_System_Loss__c); 
                                                               
                FanEffPerfMap.put(tcoplst.Type__c,tcoplst.Fan_Efficiency_Perf__c);
                FanEffCostMod1Map.put(tcoplst.Type__c,tcoplst.Fan_Eff_Cost_Modifier_1__c);
                FanEffCostMod2Map.put(tcoplst.Type__c,tcoplst.Fan_Eff_Cost_Modifier_2__c);
                FanEffCostMod3Map.put(tcoplst.Type__c,tcoplst.Fan_Eff_Cost_Modifier_3__c);
                
                PlugPerfMap.put(tcoplst.Type__c,tcoplst.Plug_Load_Perf__c);
                PlugCostModMap.put(tcoplst.Type__c,tcoplst.Plug_Load_Modifier__c);
                                                               
                LightSysPerfMap.put(tcoplst.Type__c,tcoplst.Lighting_System_Perf__c);
                LightSysCostModMap.put(tcoplst.Type__c,tcoplst.Lightning_System_Cost_Modifier__c);
                                                               
                lightCtrlPerfMap.put(tcoplst.Type__c,tcoplst.Lighting_Control_Perf__c);
                lightCtrlMod1Map.put(tcoplst.Type__c,tcoplst.Lightning_Control_Cost_Modifier_1__c);
                lightCtrlMod2Map.put(tcoplst.Type__c,tcoplst.Lightning_Control_Cost_Modifier_2__c); 
                                                                                                                              
            }
            
            NCMT_TCO_Parameter__c temp = WPEFFModsMap.get('Workplace Efficiency');
            NCMT_TCO_Parameter__c temp1 = WPEFFModsMap.get('Utility Water');
            NCMT_TCO_Parameter__c temp2 = WPEFFModsMap.get('Supplies Modifier');
            NCMT_TCO_Parameter__c temp3 = WPEFFModsMap.get('Routine Maintenance Modifier');
            
            for(NCMT_TCO_Performance_Input__c iter :trigger.new){
            
                if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Envelope_efficiency__c != iter.Envelope_efficiency__c))){
                
                    iter.Roof_Cost_Modifier__c = RoofModMap.get(iter.Envelope_efficiency__c);
                    iter.Wall_Nom_Cost_Modifier__c =WallNomModMap.get(iter.Envelope_efficiency__c);
                    iter.Slab_Unit_Cost__c = SlabCostMap.get(iter.Envelope_efficiency__c); 
                    
                    iter.Roof_Perf__c = RoofPerfMap.get(iter.Envelope_efficiency__c);
                    iter.Wall_Act_Perf__c = WallActPerfMap.get(iter.Envelope_efficiency__c);
                    iter.Wall_Nom_Perf__c= WallNomPerfMap.get(iter.Envelope_efficiency__c);
                
              }
                  
              if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Glazing_efficiency__c!= iter.Glazing_efficiency__c))){
                
                    iter.Glaz_R_Cost_Modifier__c =GlazeModMap.get(iter.Glazing_efficiency__c);
                    iter.Glazing_R_Perf__c = GlazePerfMap.get(iter.Glazing_efficiency__c);
                    iter.Glazing_SHG_Perf__c = GlazeSHGPerfMap.get(iter.Glazing_efficiency__c);
                
                
              }
                
              if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Workplace_Efficiency__c!= iter.Workplace_Efficiency__c))){
                    
                     String fieldName = iter.Workplace_Efficiency__c.replaceAll(' ','_');
                           fieldName =  fieldName+'__c'; 
                    
                        iter.Workplace_Eff_Modifier__c = (decimal) temp.get(fieldName);
              }
               if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Cooling_Efficiency_CoP__c!= iter.Cooling_Efficiency_CoP__c))){
                  
                  iter.Cooling_Efficiency_CoP_P__c =CoolEffPerfMap.get(iter.Cooling_Efficiency_CoP__c);
                  iter.Cooling_Sytem_Los__c = CoolSysLosPerfMap.get(iter.Cooling_Efficiency_CoP__c);
                  iter.Cooling_Pump_Energy_kBtu_SF_Yr__c = CoolPumpMap.get(iter.Cooling_Efficiency_CoP__c);
                  iter.Cooling_Eff_Cost_Modifier__c = CoolEffModMap.get(iter.Cooling_Efficiency_CoP__c);
                  iter.Cooling_System_Loss_Cost__c =  CoolSysLosMap.get(iter.Cooling_Efficiency_CoP__c); 
              }
                
             if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Heating_Efficiency__c!= iter.Heating_Efficiency__c))){
                  iter.Heating_Efficiency_P__c =HeatEffPerfMap.get(iter.Heating_Efficiency__c);
                  iter.Heating_System_Los__c = HeatSysLosPerfMap.get(iter.Heating_Efficiency__c);
                  iter.Heating_Pump_Energy_kBtu_SF_Yr__c = HeatPumpMap.get(iter.Heating_Efficiency__c);
                  iter.Heating_Eff_Cost_Modifier__c = HeatEffModMap.get(iter.Heating_Efficiency__c);
                  iter.Heating_System_Loss_Cost__c =  HeatSysLosMap.get(iter.Heating_Efficiency__c);
                  
             }
                
            if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Is_Non_Portable_Water_Available__c!= iter.Is_Non_Portable_Water_Available__c))){
                    
                if(iter.Is_Non_Portable_Water_Available__c =='0'){
                    iter.Water_Cost_Modifier__c = (decimal) temp1.get('No__c');                  
                }else if(iter.Is_Non_Portable_Water_Available__c =='0.0'){
                    iter.Water_Cost_Modifier__c = (decimal) temp1.get('For_Landscaping__c');
                }else{
                    iter.Water_Cost_Modifier__c = (decimal) temp1.get('For_Landscaping_Building__c');
                }       
           } 
           
          if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Off_Hours_Set_Back__c!= iter.Off_Hours_Set_Back__c))){
         
                iter.Off_Hours_Set_Back_P__c = decimal.valueOf(iter.Off_Hours_Set_Back__c);
          }
          if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Air_Distribution_Fan_Efficiency__c!= iter.Air_Distribution_Fan_Efficiency__c))){
              iter.Fan_Efficiency_Perf__c = FanEffPerfMap.get(iter.Air_Distribution_Fan_Efficiency__c);
              iter.Fan_Eff_Cost_Modifier_1__c = FanEffCostMod1Map.get(iter.Air_Distribution_Fan_Efficiency__c);
              iter.Fan_Eff_Cost_Modifier_2__c = FanEffCostMod2Map.get(iter.Air_Distribution_Fan_Efficiency__c);
              iter.Fan_Eff_Cost_Modifier_3__c = FanEffCostMod3Map.get(iter.Air_Distribution_Fan_Efficiency__c);
              
          }
          if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Plug_Load_Management__c!= iter.Plug_Load_Management__c))){
                    iter.Plug_load_management_P__c = PlugPerfMap.get(iter.Plug_Load_Management__c);
                    iter.Plug_Load_Cost_Modifier__c = PlugCostModMap.get(iter.Plug_Load_Management__c);
          }
          if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Lighting_design__c!= iter.Lighting_design__c))){
                    iter.Lighting_design_P__c = LightSysPerfMap.get(iter.Lighting_design__c);
                    iter.Lightning_Systems_Cost_Modifier__c =LightSysCostModMap.get(iter.Lighting_design__c);
          }
          if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Lighting_control__c!= iter.Lighting_control__c))){
                    iter.Lighting_control_P__c = LightCtrlPerfMap.get(iter.Lighting_control__c);
                    iter.Lightning_Control_Cost_Modifier_1__c = LightCtrlMod1Map.get(iter.Lighting_control__c);
                    iter.Lightning_Control_Cost_Modifier_2__c =  LightCtrlMod2Map.get(iter.Lighting_control__c);  
          }      
          if(trigger.isinsert || (trigger.isupdate)){
              iter.HDD__c = dblHDD;
              iter.Default_HDD__c = dblHDD;
              iter.Default_CDD__c = dblCDD;   
              iter.CDD__c = dblCDD;
              iter.Default_Insolation__c =  dblInsolation;                                           
              iter.Insolation__c = dblInsolation;
              iter.Enthalpy__c = dblEnthalpy;
              iter.Climate_Zone__c = strclimatezone;
          
          }      
          if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Janitorial_Cleanliness__c!= iter.Janitorial_Cleanliness__c))){
                if(iter.Janitorial_Cleanliness__c =='1'){
                    iter.Supplies_Cost_Mod__c = (decimal) temp2.get('Exemplary__c');                  
                }else if(iter.Janitorial_Cleanliness__c =='2'){
                    iter.Supplies_Cost_Mod__c = (decimal) temp2.get('Superior__c');
                }else if(iter.Janitorial_Cleanliness__c =='3'){
                    iter.Supplies_Cost_Mod__c = (decimal) temp2.get('Generally_Acceptable__c');
                }else if(iter.Janitorial_Cleanliness__c =='4'){
                    iter.Supplies_Cost_Mod__c = (decimal) temp2.get('Poor__c');
                }else if(iter.Janitorial_Cleanliness__c =='5'){
                    iter.Supplies_Cost_Mod__c = (decimal) temp2.get('Very_poor__c');
                }                     
          }
          if(trigger.isinsert || (trigger.isupdate && (trigger.oldmap.get(iter.id).Routine_Maintenance__c != iter.Routine_Maintenance__c))){
                if(iter.Routine_Maintenance__c =='1'){
                    iter.R_Maint_Cost_Mod__c = (decimal) temp3.get('Exemplary__c');                  
                }else if(iter.Routine_Maintenance__c =='2'){
                    iter.R_Maint_Cost_Mod__c = (decimal) temp3.get('Superior__c');
                }else if(iter.Routine_Maintenance__c =='3'){
                    iter.R_Maint_Cost_Mod__c = (decimal) temp3.get('Generally_Acceptable__c');
                }else if(iter.Routine_Maintenance__c =='4'){
                    iter.R_Maint_Cost_Mod__c = (decimal) temp3.get('Poor__c');
                }else if(iter.Routine_Maintenance__c =='5'){
                    iter.R_Maint_Cost_Mod__c = (decimal) temp3.get('Very_poor__c');
                } 
          }      
                
        }
            

    }
    if(trigger.isAfter && trigger.isUpdate){
        string strJanitorialClean;
        ID perfinputID;
        if(triggervalue.isHPLosUpdate == false){
            for(NCMT_TCO_Performance_Input__c obj :trigger.new){
                perfinputID = obj.ID;
                NCMTIDs.add(obj.NCMT_Project__c);
                strJanitorialClean = obj.Janitorial_Cleanliness__c;
            }
            OldValues = Trigger.oldMap.get(perfinputID);
            List<NCMT_TCO_HP_Level_of_Service__c> HPLosUpdateList = [Select ID, Name,Janitorial_Cleanliness__c
                                                                        From NCMT_TCO_HP_Level_of_Service__c 
                                                                        where Project_Name__c = :NCMTIDs
                                                                       ];
            
            if (strJanitorialClean != OldValues.Janitorial_Cleanliness__c){
                
                for(NCMT_TCO_HP_Level_of_Service__c HPLOSLst :HPLosUpdateList){
                   HPLOSLst.Janitorial_Cleanliness__c =  strJanitorialClean;    
                }
            }
            update HPLosUpdateList;
        }
        
    }
    }
}