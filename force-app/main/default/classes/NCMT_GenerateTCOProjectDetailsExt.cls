public with sharing class NCMT_GenerateTCOProjectDetailsExt {
    
    public String perfInputId, pcrId, acsId, lfcId, addCostId;
    public NCMT_Project__c currentProj = new NCMT_Project__c();
    List<String> origOCIds = new List<String>();
    Map<string, String> mapOtherCost = new Map<string, String>();
    
    public static Boolean runTriggers = true;
    
    public void cloneTCODetails(String origId, String projId, List<NCMT_Project__c> proj)
    {
        //Set static variable to false. Will prevent all triggers from running.
        runTriggers = false;
        
        //System.debug('generateProjectCostRates');
        if(proj.size() == 1)
            this.currentProj = proj[0];
        
        //Generate PCS Map
        List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :projId Limit 1000];
        //System.debug('PCS LIST: ' + listCostSummary.size());    
        Map<string, String> mapCostSummary = new Map<string, String>();
            for(NCMT_Project_Cost_Summary__c objItem : listCostSummary)
                mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
        System.debug('PCS MAP: ' + mapCostSummary);
        
        
        //Clone NCMT Project Cost Rate records
        List<NCMT_Project_Cost_Rate__c> rates = [SELECT Id FROM NCMT_Project_Cost_Rate__c WHERE Project_Name__c =: origId];
        //System.debug(rates);
        
        List<NCMT_Project_Cost_Rate__c> ratesToInsert = (List<NCMT_Project_Cost_Rate__c>)getCloneList(rates, projId);
        System.debug(ratesToInsert);
        
        insert ratesToInsert;
        if(ratesToInsert.size() > 0)
        	pcrId = ratesToInsert[0].Id;
        
        //Clone TCO Additional Cost records
        List<NCMT_TCO_Additional_Cost__c> add = [SELECT Id FROM NCMT_TCO_Additional_Cost__c WHERE Project_Name__c =: origId];
        
        List<NCMT_TCO_Additional_Cost__c> addToInsert = (List<NCMT_TCO_Additional_Cost__c>)getCloneList(add, projId);
        
        insert addToInsert;
        if(addToInsert.size() > 0)
        	addCostId = addToInsert[0].Id;
        
        
        //Clone NCMT TCO Performance Input records
        List<NCMT_TCO_Performance_Input__c> inputs = [SELECT Id FROM NCMT_TCO_Performance_Input__c WHERE NCMT_Project__c =: origId];
        
        List<NCMT_TCO_Performance_Input__c> inputsToInsert = (List<NCMT_TCO_Performance_Input__c>)getCloneList(inputs, projId);
        //System.debug(inputsToInsert);
        
        insert inputsToInsert;
        if(inputsToInsert.size() > 0)
        	perfInputId = inputsToInsert[0].Id;
        
        //Clone Core Shell Cost Detail records
        List<NCMT_Core_Shell_Cost_Detail__c> shells = [SELECT Id, Applicable_Cost__c, Core_Shell_Cost__c, Core_Shell_Cost_Parameter__c,
                                                       			Core_Shell_Criterion__c,Cost_Premium_Mod_2__c,Cost_Premium_Modifier__c,
                                                       			Cost_Rate_for_Space__c,Maintenance_Cost__c,Maintenance_Cost_Modifier__c,Project_Cost_Summary__r.Cost_Category_Description__c,
                                                       			Maintenance_Cost_Type__c,Maintenance_Cost_WF__c,NCMT_Project_ID__c,ParkingCost__c,
                                                       			Project_Cost_Summary__c,Project_Name__c,Project_Record_Type_Id__c,
                                                       			Replacement_Cost__c,Replacement_Frequency__c,Replacement_Type__c,TCO_Performance_Input__c,
                                                       			TCO_Project_Cost_Rate__c,Total_Cost__c,Total_Units__c,Unit_Cost__c,TCO_Unit_Maintenance_Cost__c
                                                       FROM NCMT_Core_Shell_Cost_Detail__c WHERE Project_Cost_Summary__r.Project_Name__c =: origId];
        
        List<NCMT_Core_Shell_Cost_Detail__c> shellsToInsert = new List<NCMT_Core_Shell_Cost_Detail__c>();
        
        for(NCMT_Core_Shell_Cost_Detail__c s : shells)
        {
            s.Id = null;
            s.Project_Cost_Summary__c = mapCostSummary.get(s.Project_Cost_Summary__r.Cost_Category_Description__c);
            s.TCO_Performance_Input__c =perfInputId;
            s.TCO_Project_Cost_Rate__c = pcrId;
            s.Run_Workflow__c = true; //Prevent Core Shell workflow rules from firing
			shellsToInsert.add(s);
        }
        
        insert shellsToInsert;
        
        List<ID> coreShellIds = new List<ID>();
        for(NCMT_Core_Shell_Cost_Detail__c s: shellsToInsert)
        {
			s.Run_Workflow__c = true; //Enable Core Shell workflow rules to run again
            coreShellIds.add(s.Id);
        }
        //update shellsToInsert;
        updateCoreShell_WF(coreShellIds);
        
        //Clone TCO Annual Cost Summary records
        List<NCMT_TCO_Annual_Cost_Summary__c> acsList = [SELECT Id FROM NCMT_TCO_Annual_Cost_Summary__c WHERE Project_Name__c =: origId];
        
        List<NCMT_TCO_Annual_Cost_Summary__c> acsToInsert = (List<NCMT_TCO_Annual_Cost_Summary__c>)getCloneList(acsList, projId);
        //System.debug(acsToInsert);
        
        insert acsToInsert;
        if(acsToInsert.size() > 0)
        	acsId = acsToInsert[0].Id;
        
        //Clone NCMT Other Cost records
        List<NCMT_Other_Cost__c> oc = [SELECT Id FROM 	NCMT_Other_Cost__c WHERE NCMT_Project__c =: origId];
        
        List<NCMT_Other_Cost__c> ocToInsert = (List<NCMT_Other_Cost__c>)getCloneList(oc, projId);
        //System.debug(ocToInsert);
        
        insert ocToInsert;
        Integer count = 0;
        for(String objItem : origOCIds)
        {
        	mapOtherCost.put(objItem, ocToInsert[count].Id);
            count++;
        }
        System.debug('OC MAP: ' + mapOtherCost);
        
        //Clone Other Direct Costs
        List<NCMT_Other_Direct_Cost__c> odc = [SELECT Id, Cost_Based_On__c, Cost_Category__c, Cost_Category_Description__c, Description__c,
                                               			NCMT_Other_Cost__c,Project_Cost_Summary__c,Area__c,Sub_Description__c,Total_Cost__c,
                                               			Unit_Rate__c, Project_Cost_Summary__r.Cost_Category_Description__c
                                               FROM NCMT_Other_Direct_Cost__c WHERE Project_Cost_Summary__r.Project_Name__c =: origId];
        
        List<NCMT_Other_Direct_Cost__c> odcToInsert = new List<NCMT_Other_Direct_Cost__c>();
        
        for(NCMT_Other_Direct_Cost__c o : odc)
        {
			o.Id = null;
            o.Project_Cost_Summary__c = mapCostSummary.get(o.Project_Cost_Summary__r.Cost_Category_Description__c);
            o.NCMT_Other_Cost__c = mapOtherCost.get(o.NCMT_Other_Cost__c);
            odcToInsert.add(o);
        }
        
        insert odcToInsert;

        
        //Clone NCMT TCO HP Level of Service records
        List<NCMT_TCO_HP_Level_of_Service__c> levels = [Select Id, name, usf__c, janitorial_cleanliness__c, operational_efficiency__c, project_name__c, 
                                                                space_type__c, hp_parameter__c, ease_of_access_parameter__c, opeeff_modifier__c, total_cleaning_hr_ksf__c, 
                                                                ti_refresh_cost_wf__c, janitorial_cost_hp__c, supplies_cost__c, maintenance_cost__c, tco_performance_input__c, 
                                                                usf_occupant__c, occuant_usf__c, tco_cost_rates__c, occ_h_sf_yr__c, open_h_sf__c, occ_cf_sf_yr__c, open_cf_sf_yr__c, 
                                                                off_cf_sf_yr__c, sum_cf_sf_yr__c, plug_heat_generation__c, lightning_heat_generation__c, occ_heat_generation__c, 
                                                                glazing_shg__c, total_btu_sf_yr__c, total_heating_load__c, total_cooling_load__c, cooling_kbtu_sf__c, heating_kbtu_sf__c, 
                                                                ti_renovate_cost_wf__c, j_cost_mod_param__c, total_heating_load_wf__c, total_cooling_load_wf__c, electrical_energy__c, 
                                                                gas_energy__c, water_occ__c, energy_other_cooling__c, energy_water__c, energy_other_heating__c, energy_gas__c, energy_electricity__c, 
                                                                energy_renewable__c, energy_grid__c, water_rec__c, water_portable__c, gas_cost__c, other_heating_cost__c, other_cooling_cost__c, 
                                                                portable_water_cost__c, utility_water_cost__c, sewer_cost__c, grid_energy_cost__c, total_btu_sf_yr_wf__c, renewable_energy_cost__c, 
                                                                npv_summary__c, bt7__c, bt12__c, grid_energy_cost_wf_c__c, renewable_energy_cost_wf__c, water_portable_wf__c, utility_water_cost_wf__c, 
                                                                sewer_cost_wf__c, janitorial_cost_hp_wf__c, gas_cost_wf__c, supplies_cost_wf__c, maintenance_cost_wf__c, total_electricity_wf__c, 
                                                                land_related__c, other_cooling_cost_wf__c, other_heating_cost_wf__c, ti_refresh_cost__c, ti_renovate_cost__c, sum_cf_sf_yr_wf__c, 
                                                                bt17__c, min_air_change__c, bt19__c, supplies_cost_mod__c, landscape_and_site_maint_cost__c, landscape_cost_wf__c, Project__c 
                                                        from NCMT_TCO_HP_Level_of_Service__c where Project_Name__c =: origId];
        System.debug('LoS RECORDS: ' + levels.size());
        
        List<NCMT_TCO_HP_Level_of_Service__c> levelsToInsert = new List<NCMT_TCO_HP_Level_of_Service__c>();
		
        for(NCMT_TCO_HP_Level_of_Service__c los: levels)
        {
            System.debug('HP LoS USF: ' + los.USF__c);
            los.Id = null;
            los.Project_Name__c = projId;
            if(los.USF__c != 0)
            	los.Project__c = projId;
            los.NPV_Summary__c = acsId;
            los.TCO_Cost_Rates__c = pcrId;
            los.TCO_Performance_Input__c = perfInputId;
            los.Run_Workflow__c = true; //Prevent LoS workflow rules from firing
            levelsToInsert.add(los);
        }

		insert levelsToInsert;  
        for(NCMT_TCO_HP_Level_of_Service__c los: levelsToInsert)
        {
			los.Run_Workflow__c = false; //Enable LoS workflow rules to run again
        }
        update levelsToInsert;
        
        //Clone NCMT TCO Lifecycle Input records
        List<NCMT_TCO_Lifecycle_Input__c> lfc = [SELECT Id FROM NCMT_TCO_Lifecycle_Input__c WHERE NCMT_Project__c =: origId];
        
        List<NCMT_TCO_Lifecycle_Input__c> lfcToInsert = (List<NCMT_TCO_Lifecycle_Input__c>)getCloneList(lfc, projId);
        //System.debug(lfcToInsert);
        
        insert lfcToInsert;
        if(lfcToInsert.size() > 0)
        	lfcId = lfcToInsert[0].Id;
        
        
        //Clone NCMT TCO Lifecycle LCC records
        List<NCMT_TCO_LCC__c> lcc = [Select Id, name, tco_lifecycle_input__c, ncmt_project__c, year__c, start_date__c, refresh_year__c, 
                                            previous_lcc__c, janitorial_cost__c, janitorial_escalated_cost__c, retrofit_year__c, 
                                            janitorial_escalated_discounted_cost__c, landscaping_escalated_cost__c, landscaping_cost__c, 
                                            landscaping_escalated_discounted_cost__c, bldg_mgmt_cost__c, bldg_mgmt_escalated_cost__c, 
                                            bldg_mgmt_escalated_discounted_cost__c, bldg_shell_clean_cost__c, bldg_shell_clean_esc_discounted_cost__c, 
                                            bldg_shell_clean_escalated_cost__c, bldg_supp_cost__c, bldg_supp_escalated_cost__c, bldg_supp_escalated_discounted_cost__c, 
                                            gas_cost__c, gas_escalated_cost__c, gas_escalated_discounted_cost__c, grid_electricity_cost__c, grid_electricity_escalated_cost__c, 
                                            grid_electricity_esc_discounted_cost__c, minor_repair_cost__c, minor_repair_escalated_cost__c, minor_repair_escalated_discounted_cost__c, 
                                            oth_heating_cost__c, oth_heating_escalated_cost__c, oth_heating_escalated_discounted_cost__c, ptbl_water_cost__c, 
                                            ptbl_water_escalated_cost__c, ptbl_water_escalated_discounted_cost__c, reclaim_water_cost__c, reclaim_water_esc_discounted_cost__c, 
                                            reclaim_water_escalated_cost__c, routine_maint_cost__c, routine_maint_esc_discounted_cost__c, routine_maint_escalated_cost__c, 
                                            sewer_cost__c, sewer_escalated_cost__c, sewer_escalated_discounted_cost__c, refresh_cost__c, retrofit_cost__c, months_pre_design__c, 
                                            months_design__c, months_construction__c, end_date__c, construction_cost__c, pre_design_cost__c, design_cost__c, pre_design_escalated_cost__c, 
                                            design_escalated_cost__c, construction_escalated_cost__c, pre_design_escalated_discounted_cost__c, design_escalated_discounted_cost__c, 
                                            construction_escalated_discounted_cost__c, months_commissioning_move_in__c, months_operational__c, refresh_escalated_cost__c, 
                                            retrofit_escalated_cost__c, refresh_escalated_discount_cost__c, retrofit_escalated_discounted_cost__c, replacement_cost__c, 
                                            replacement_escalated_cost__c, replacement_escalated_discounted_cost__c, operations_maintenance_cost__c, utilities_cost__c, total_cost__c, 
                                            operations_maintenance_escalated__c, operations_maint_esc_discounted__c, utilities_escalated__c, utilities_escalated_discounted__c, other_cooling_cost__c, 
                                            other_cooling_escalated_cost__c, other_cooling_escalated_discounted__c, ti_crr_cost__c, ti_crr_escalated_cost__c, ti_crr_escalated_discounted_cost__c 
                                    from NCMT_TCO_LCC__c where NCMT_Project__c =: origId];
        
        List<NCMT_TCO_LCC__c> lccToInsert = new List<NCMT_TCO_LCC__c>();
        
        for(NCMT_TCO_LCC__C l : lcc)
        {
            l.Id = null;
            l.NCMT_Project__c = projId;
            l.TCO_Lifecycle_Input__c = lfcId;
            lccToInsert.add(l);
        }
        
        insert lccToInsert;
        
        //Finally, update the Project Record Id from the Id of the original Project to the Id of the clone
        currentProj = [SELECT Id FROM NCMT_Project__c WHERE Id =: projId];
        currentProj.Project_Record_Id__c = projId;
        update currentProj;
        
    }
    
    //Returns list of cloned records to be inserted
    //toClone -- List of SObjects related to the original NCMT Project to be cloned and attached to cloned NCMT Project
    //projId -- Id of the CLONED NCMT Project
    private List<sObject> getCloneList(List<SObject> toClone, String projId)
    {
        List<SObject> toInsert = new List<SObject>();
        String objToClone = '';
        
        if(toClone.size() > 0){
            //Gets API name of SObject 
        	objToClone = String.valueOf(toClone[0].getSObjectType());
            System.debug('Object to clone: ' + objToClone);
        }
        
        for(SObject s : toClone)
        {
            if(objToClone == 'NCMT_Project_Cost_Rate__c')
            {
                NCMT_Project_Cost_Rate__c r = (NCMT_Project_Cost_Rate__c)NCMT_Utilities.cloneMe('NCMT_Project_Cost_Rate__c', s.Id, new Set<String>(), false);
                r.Id = null;
                r.Project_Name__c = projId;
                toInsert.add(r);
            }
            
            if(objToClone == 'NCMT_TCO_Performance_Input__c')
            {
                NCMT_TCO_Performance_Input__c i = (NCMT_TCO_Performance_Input__c)NCMT_Utilities.cloneMe('NCMT_TCO_Performance_Input__c', s.Id, new Set<String>(), false);
                i.Id = null;
                i.NCMT_Project__c = projId;
                //i.Project_Level_Parameter__c = plpId;
                toInsert.add(i);
            }
            
            if(objToClone == 'NCMT_TCO_Annual_Cost_Summary__c')
            {
                NCMT_TCO_Annual_Cost_Summary__c c = (NCMT_TCO_Annual_Cost_Summary__c)NCMT_Utilities.cloneMe('NCMT_TCO_Annual_Cost_Summary__c', s.Id, new Set<String>(), false);
                c.Id = null;
                c.Project_Name__c = projId;
                c.Performance_Input__c = perfInputId;
                c.TCO_Project_Cost_Rate__c = pcrId;
                c.TCO_Addtl_Cost__c = addCostId;
                toInsert.add(c);
            }
            
            if(objToClone == 'NCMT_TCO_Additional_Cost__c')
            {
                NCMT_TCO_Additional_Cost__c a = (NCMT_TCO_Additional_Cost__c)NCMT_Utilities.cloneMe('NCMT_TCO_Additional_Cost__c', s.Id, new Set<String>(), false);
            	a.Id = null;
                a.Project_Name__c = projId;
                a.TCO_Project_Cost_Rate__c = pcrId;
                toInsert.add(a);
            }
            
            if(objToClone == 'NCMT_Other_Cost__c')
            {
                NCMT_Other_Cost__c oc = (NCMT_Other_Cost__c)NCMT_Utilities.cloneMe('NCMT_Other_Cost__c', s.Id, new Set<String>(), false);
            	origOCIds.add(oc.Id);
                oc.Id = null;
                oc.NCMT_Project__c = projId;
                toInsert.add(oc);
                
            }     
            
            if(objToClone == 'NCMT_TCO_Lifecycle_Input__c')
            {
                NCMT_TCO_Lifecycle_Input__c	 lfc = (NCMT_TCO_Lifecycle_Input__c)NCMT_Utilities.cloneMe('NCMT_TCO_Lifecycle_Input__c', s.Id, new Set<String>(), false);
            	lfc.Id = null;
                lfc.NCMT_Project__c = projId;
                lfc.NCMT_TCO_Annual_Cost_Summary__c = acsId;
                lfc.TCO_Project_Cost_Rate__c = pcrId;
                //System.debug('DESIGN MONTHLY COST ====='+lfc.Design_Monthly_Cost__c);
                toInsert.add(lfc);
            } 
   
            
        }

        return toInsert;
    }
    
    @future
    public static void updateCoreShell_WF(List<ID> ids)
    {
          runTriggers = false; //Disable triggers
          //Update Run_Workflow__c field on Core Shell Cost Detail to true  
          List<NCMT_Core_Shell_Cost_Detail__c> records = [SELECT Run_Workflow__c FROM NCMT_Core_Shell_Cost_Detail__c WHERE Id IN: ids];
          List<NCMT_Core_Shell_Cost_Detail__c> toUpdate = new List<NCMT_Core_Shell_Cost_Detail__c>();
        
          for(NCMT_Core_Shell_Cost_Detail__c cs : records)
          {
              cs.Run_Workflow__c = false;
              toUpdate.add(cs);
          }
        System.debug('Updating Core Shell run workflow: ' + toUpdate);
        update toUpdate;
    }
    
   
 
}