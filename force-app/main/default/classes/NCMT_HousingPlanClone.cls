public with sharing class NCMT_HousingPlanClone /*implements Queueable*/ {
    
    private String projId, origId;
    
    public static Boolean runHPTrigger = true;
    
    public NCMT_HousingPlanClone(String origId, String projId)
    {
        this.origId = origId;
        this.projId = projId; 
    }

    public void cloneHousingPlanSync(NCMT_Project__c proj)
    {
        system.debug('inside cloning housing plan<<<<<<<<<<<<<<<<<<<<');
        //Select all fields from Housing Plan related to original record
        List<NCMT_Housing_Plan__c> plans = [Select Id,name,recordtypeid,project__c,adp_high_density_pc_s_count__c,
                                                   adp_high_density_pc_s_entered_usf__c,adp_high_density_pc_s_use_usf__c,
                                                   adp_mainframe_use_usf__c,agency_bureau_code__c,atrium_ground_floor_plan_area__c,
                                                   atrium_upper_levels_phantom_floors__c,auditorium_sloped_floor_count__c,
                                                   auditorium_sloped_floor_entered_usf__c,auditorium_sloped_floor_use_usf__c,
                                                   average_floorplate_size__c,based_on_damped_cladding_ratio__c,building1_usf__c,
                                                   building2_usf__c,building3_usf__c,child_care_count__c,child_care_entered_usf__c,
                                                   child_care_use_usf__c,climate_controlled_for_artifacts_use_usf__c,clinics_health_units_use_usf__c,
                                                   closed_offices_count__c,closed_offices_entered_usf__c,closed_offices_use_usf__c,
                                                   conditioned_core_area__c,copy_center_use_usf__c,courtroom_bankruptcy_count__c,
                                                   courtroom_bankruptcy_entered_usf__c,courtroom_bankruptcy_use_usf__c,courtroom_magistrate_count__c,
                                                   courtroom_magistrate_entered_usf__c,courtroom_magistrate_use_usf__c,courtroom_district_ceremonialentered_usf__c,
                                                   courtroom_district_ceremonial_count__c,courtroom_district_ceremonial_use_usf__c,courtroom_district_standard_count__c,
                                                   courtroom_district_standard_entered_usf__c,courtroom_district_standard_use_usf__c,
                                                   credit_union_use_usf__c,elevator_lobbies__c,elevator_shafts__c,enclosed_parking__c,
                                                   enhanced_office_use_usf__c,finpct__c,firing_range_use_usf__c,food_service_cafeteria_use_usf__c,
                                                   general_storage_use_usf__c,grand_jury_room_count__c,grand_jury_room_entered_usf__c,
                                                   grand_jury_room_use_usf__c,ground_floor_circulation__c,hardened_offices_suites_use_usf__c,
                                                   high_density_storage_use_usf__c,holding_cell_central_count__c,holding_cell_central_entered_usf__c,
                                                   holding_cell_central_use_usf__c,holding_cell_court_floors_count__c,holding_cell_court_floors_entered_usf__c,
                                                   holding_cell_court_floors_use_usf__c,interview_detention_use_usf__c,joint_use_retail_use_usf__c,
                                                   judicial_chambers_count__c,judicial_chambers_entered_usf__c,judicial_chambers_use_usf__c,
                                                   judicial_hearing_count__c,judicial_hearing_entered_usf__c,judicial_hearing_use_usf__c,
                                                   kitchen_break_room_use_usf__c,laboratory_dry_electronic_use_usf__c,laboratory_wet_chemistry_use_usf__c,
                                                   libraries_count__c,libraries_entered_usf__c,libraries_use_usf__c,light_industrial_use_usf__c,
                                                   loading_dock_recycling_trash__c,locker_shower_room_use_usf__c,main_lobby__c,main_entry_stairs__c,
                                                   mechanical_electrical_it__c,non_marshal_holding_cell_double_use_usf__c,non_marshal_holding_cell_single_use_usf__c,
                                                   non_climate_controlled_use_usf__c,number_of_floors__c,number_of_stops__c,other_circulation__c,
                                                   other_vertical_penetrations__c,pbs_ab_code__c,physical_fitness_use_usf__c,private_toilets_count__c,
                                                   private_toilets_entered_usf__c,private_toilets_use_usf__c,project_gf__c,project_gsf__c,project_usf__c,
                                                   rentable_area__c,restrooms__c,sally_port_use_usf__c,secure_work_environment_swe_enhd_useusf__c,
                                                   secure_work_environment_swe_std_use_usf__c,secured_storage_scif_enhanced_use_usf__c,secured_storage_scif_standard_use_usf__c,
                                                   space_plan_name__c,stair_shafts__c,structural_area__c,teleconference_count__c,teleconference_entered_usf__c,
                                                   teleconference_use_usf__c,tenant_agency_name__c,total_floor_openings__c,total_gsf__c,total_gsf_w_o_parking__c,
                                                   total_rsf__c,total_rsf_w_o_parking__c,total_usf__c,transaction_counter_space_use_usf__c,usms_suite_administration_use_usf__c,
                                                   usms_suite_operations_use_usf__c,unfinished_shell_area_use_usf__c,unfinpct__c,useable_area__c,
                                                   user_defined_spaces1_description__c,user_defined_spaces1_usf_for_dc__c,user_defined_spaces1_use_usf__c,
                                                   user_defined_spaces2_description__c,user_defined_spaces2_usf_for_dc__c,user_defined_spaces2_use_usf__c,
                                                   user_defined_spaces3_description__c,user_defined_spaces3_usf_for_dc__c,user_defined_spaces3_use_usf__c,
                                                   vault_type_storage_use_usf__c,warehouse_use_usf__c,workstations_open_office_count__c,workstations_open_office_entered_usf__c,
                                                   workstations_open_office_use_usf__c,x20_or_more_person_rooms_count__c,x20_or_more_person_rooms_entered_usf__c,
                                                   x20_or_more_person_rooms_use_usf__c,x8_20_person_rooms_count__c,x8_20_person_rooms_entered_usf__c,
                                                   x8_20_person_rooms_use_usf__c,data_center_use_usf__c,va_ambulatory_surgery_use_usf__c,va_exam_suite_use_usf__c,
                                                   va_infusion_use_usf__c,va_intake_use_usf__c,va_pharmacy_use_usf__c,va_radiology_use_usf__c,
                                                   housing_plan_name__c,pbs_agency_ab_code__c,pbs_agency_bureau_name__c,housing_plan_type__c,
                                                   housingplanflag__c,building_type__c,project_type__c, mailroom_use_usf__c, secure_mailroom_use_usf__c
                                            from NCMT_Housing_Plan__c where Project__c =: origId];
        //System.debug('HOUSING PLANS TO CLONE: ' + plans.size());
        
        List<NCMT_Housing_Plan__c> plansToUpdate = new List<NCMT_Housing_Plan__c>();
        String ProjectRecordType;
        
        List<String> origHPIds = new List<String>();
        Map<string, String> mapHousingPlan = new Map<string, String>();
        
        //NCMT_Housing_Plan__C plan = (NCMT_Housing_Plan__c)NCMT_Utilities.cloneMe('NCMT_Housing_Plan__c', plans[0].Id, new Set<String>(), false);
    	for(NCMT_Housing_Plan__c p : plans)
        {
            origHPIds.add(p.Id);
            p.Id = null;
            p.Project__c = projId;
            plansToUpdate.add(p);
            ProjectRecordType = p.Building_Type__c;
        }
        
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = false;
        
        //Insert Housing Plan clone records without invoking NCMT_HousingPlanTrigger
        
        insert plansToUpdate;
        
        Integer count = 0;
        for(String objItem : origHPIds)
        {
        	mapHousingPlan.put(objItem, plansToUpdate[count].Id);
            count++;
        }
        System.debug('HP MAP: ' + mapHousingPlan);
        
        //Insert Housing Plan Summary Records
        List<NCMT_Housing_Plan_Summary__c> sums = [Select Id,name,recordtypeid,project__c,adp_high_density_pc_s_use_usf__c,adp_mainframe_use_usf__c,atrium_ground_floor_plan_area__c,
                                                  		atrium_upper_levels_phantom_floors_sf__c,atrium_upper_levels_phantom_floors__c,auditorium_sloped_floor_use_usf__c,
                                                         average_floorplate_size__c,based_on_damped_cladding_ratio__c,building1_usf__c,building2_usf__c,building3_usf__c,
                                                         child_care_use_usf__c,climate_controlled_for_artifacts_use_usf__c,clinics_health_units_use_usf__c,closed_offices_use_usf__c,
                                                         conditioned_core_area__c,copy_center_use_usf__c,courtroom_bankruptcy_use_usf__c,courtroom_magistrate_use_usf__c,
                                                         courtroom_district_ceremonial_use_usf__c,courtroom_district_standard_use_usf__c,credit_union_use_usf__c,data_center_use_usf__c,
                                                         default_atrium_ground_floor_plan_area__c,default_elevator_lobbies__c,default_enclosed_parking__c,default_ground_floor_circulation__c,
                                                         default_loading_dock_recycling_trash__c,default_main_lobby__c,default_mechanical_electrical_it__c,default_other_circulation__c,
                                                         default_restrooms__c,elevator_lobbies__c,elevator_shafts__c,enclosed_parking__c,enhanced_office_use_usf__c,finpct__c,
                                                         firing_range_use_usf__c,food_service_cafeteria_use_usf__c,general_storage_use_usf__c,grand_jury_room_use_usf__c,
                                                         ground_floor_circulation__c,hardened_offices_suites_use_usf__c,high_density_storage_use_usf__c,holding_cell_central_use_usf__c,
                                                         holding_cell_court_floors_use_usf__c,interview_detention_use_usf__c,joint_use_retail_use_usf__c,judicial_chambers_use_usf__c,
                                                         judicial_hearing_use_usf__c,kitchen_break_room_use_usf__c,laboratory_dry_electronic_use_usf__c,laboratory_wet_chemistry_use_usf__c,
                                                         libraries_use_usf__c,light_industrial_use_usf__c,loading_dock_recycling_trash__c,locker_shower_room_use_usf__c,main_lobby__c,
                                                         main_entry_stairs__c,mechanical_electrical_it__c,non_marshal_holding_cell_double_use_usf__c,non_marshal_holding_cell_single_use_usf__c,
                                                         non_climate_controlled_use_usf__c,number_of_floors__c,number_of_stops__c,other_circulation__c,other_vertical_penetrations__c,
                                                         override_rsf_range__c,override_rsf__c,physical_fitness_use_usf__c,private_toilets_use_usf__c,project_gf__c,project_gsf__c,project_usf__c,
                                                         rentable_area__c,restrooms__c,sally_port_use_usf__c,secure_work_environment_swe_enhd_useusf__c,secure_work_environment_swe_std_use_usf__c,
                                                         secured_storage_scif_enhanced_use_usf__c,secured_storage_scif_standard_use_usf__c,stair_shafts__c,structural_area__c,teleconference_use_usf__c,
                                                         total_floor_openings__c,total_gsf__c,total_gsf_w_o_parking__c,total_rsf__c,total_rsf_w_o_parking__c,total_usf__c,transaction_counter_space_use_usf__c,
                                                         usms_suite_administration_use_usf__c,usms_suite_operations_use_usf__c,unfinished_shell_area_use_usf__c,unfinpct__c,useable_area__c,
                                                         user_defined_spaces1_description__c,user_defined_spaces1_usf_for_dc__c,user_defined_spaces1_use_usf__c,user_defined_spaces2_description__c,
                                                         user_defined_spaces2_usf_for_dc__c,user_defined_spaces2_use_usf__c,user_defined_spaces3_description__c,user_defined_spaces3_usf_for_dc__c,
                                                         user_defined_spaces3_use_usf__c,va_ambulatory_surgery_use_usf__c,va_exam_suite_use_usf__c,va_infusion_use_usf__c,va_intake_use_usf__c,
                                                         va_pharmacy_use_usf__c,va_radiology_use_usf__c,vault_type_storage_use_usf__c,warehouse_use_usf__c,workstations_open_office_use_usf__c,
                                                         x20_or_more_person_rooms_use_usf__c,x8_20_person_rooms_use_usf__c, mailroom_use_usf__c, secure_mailroom_use_usf__c
                                                   from NCMT_Housing_Plan_Summary__c where Project__c =: origId];
        //System.debug('HOUSING PLAN SUMMARIES TO CLONE: ' + sums.size());
        
        List<NCMT_Housing_Plan_Summary__c> sumsToInsert = new List<NCMT_Housing_Plan_Summary__c>();
        
        for(NCMT_Housing_Plan_Summary__c s: sums)
        {
			s.Id = null;
            s.Project__c = projId;
            sumsToInsert.add(s);
        }
        
        insert sumsToInsert;

        List<NCMT_Housing_Plan_Option_Selection__c> newSelects = new List<NCMT_Housing_Plan_Option_Selection__c>();
        for (NCMT_Housing_Plan_Option_Selection__c optSelect : [Select Id, NCMT_Housing_Plan_Option__c, NCMT_Housing_Plan__c, NCMT_Project__c, NCMT_Project__r.RecordTypeId, Recurrence__c
            from NCMT_Housing_Plan_Option_Selection__c where NCMT_Project__c =: origId]
        ){
            NCMT_Housing_Plan_Option_Selection__c clone = optSelect.clone(false,true);
            clone.NCMT_Project__c = projId;
            if (clone.NCMT_Housing_Plan__c != null)
                clone.NCMT_Housing_Plan__c = mapHousingPlan.get(clone.NCMT_Housing_Plan__c);
            
                newSelects.add(clone);
        }
        insert newSelects;
        
        //Generate PCS Map
        List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :projId Limit 1000];
        //System.debug('PCS LIST: ' + listCostSummary.size());    
        Map<string, String> mapCostSummary = new Map<string, String>();
            for(NCMT_Project_Cost_Summary__c objItem : listCostSummary)
                mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
        System.debug('PCS MAP: ' + mapCostSummary);
        
        //Project Level Parameter clone
        List<Project_Level_Parameter__c> plps = [Select Id,name,recordtypeid,ncmt_project__c,above_ground__c,add_mailroom_xray__c,add_visitor_access_control__c,
                                                     additional_primary_circulation_stair__c,addnl_primary_circulation_stair_flights__c,adj_lop_setback__c,atrium_area_sf__c,
                                                     atrium_height_stories__c,atrium_phantom_floors__c,average_bay_area_calculated__c,average_cladding_cost_del1__c,
                                                     average_roofing_cost_directcost_sfro_del__c,average_story_height__c,average_typical_bay_area__c,bgfloors__c,
                                                     bgsf_atrium_sf__c,base_sf__c,basement1_sf__c,basement2_sf__c,basement_roof_sf__c,basement_sf__c,basement_story_height__c,
                                                     below_ground__c, building_parameter__c, change_setback_100__c, cladding_override_comments__c, cladding_override_percent__c,
                                                     cladding_quality__c,cladding_retaining_wall_sf__c, cladding_retaining_wall__c, cladding_skin_ratio_sf__c, cladding_skin_ratio__c, cladding_type_quality__c,
                                                     cladding_type__c,core_shell_partition_lf__c, cost_impact_percent__c, curtain_wall_percentage_sf__c, curtain_wall_percentage_total_window__c,
                                                     dead_load__c,def_blast_resistance_progressivecollapse__c, defaultchemicalfiltration_area_served_sf__c, default_above_ground__c,
                                                     default_ad_nl_primary_circulation_stair__c,default_adj_lop_setback_ft__c,default_air_handling_capacity__c,
                                                     default_atrium_phantom_floors__c, default_average_story_height__c, default_ballistic_protection_to_windows__c, default_basement1_sf__c,
                                                     default_basement2_sf__c, default_basement_sf__c, default_basement_story_height__c, default_below_ground__c, default_cctv_system_cctv_allowance__c,
                                                     default_cladding_quality__c, default_cladding_type__c, default_core_shell_partition_ratio__c, default_curtain_wall_percentage__c, default_dead_load__c,
                                                     default_electrical_load__c, default_elevated_floor_area_sf__c, default_fin_wall_modifiers__c, default_flat_roof_bg__c, default_flat_roof_ps__c,
                                                     default_foot_print_area__c, default_freeze_depth_footing_depth__c, default_glazing_ratio__c, default_green_roof_bg__c, default_green_roof_ps__c,
                                                     default_ground_sf__c, default_hepa_filtration_area_served_sf__c, default_hvac_cooling_load__c, default_hvac_heating_load__c,
                                                     default_intrusion_detection_system_ids__c, default_live_load__c, default_over_percentage_of_perimeter__c, default_pent_house__c,
                                                     default_plumbing_fixtures__c, default_retaining_wall__c, default_roofing_skylights__c, default_setback_100_ft__c, default_skin_deviation_check__c,
                                                     default_skin_q_modifiers__c, default_skin_ratio__c, default_sloped_roof_bg__c, default_sloped_roof_ps__c, default_typical_bay_area__c,
                                                     default_vertical_conveyance_elevators__c, default_vertical_conveyance_escalators__c, default_water_table_depth__c, electrical_load__c,
                                                     electrical_load_kw__c, elevated_floor_area_sf__c, excavation_percent_shored_bg__c, excavation_percentage_shored_bg__c, excavation_percentage_shored__c,
                                                     finished_opaque_wall_sf__c, finished_site__c, finished_wall_area_sf__c, finished_wall_area__c, flat_roof_bg__c, flat_roof_sf__c,
                                                     foot_print_area__c, freeze_depth_footing_depth_bg__c, freeze_depth_footing_depth__c, glazing_ratio_sf__c, glazing_ratio_of_above_grade_skin__c,
                                                     green_roof_bg__c, green_roof_sf__c, gross_building_area__c, ground_sf__c, hvac_air_handling_capacity_cfm__c, hvac_air_handling_capacity__c,
                                                     hvac_cooling_load_tons__c, hvac_cooling_load__c, hvac_heating_load_mbtu__c, hvac_heating_load__c, int_const_core_shell_partition_ratio__c,
                                                     interior_override_comments__c, level_of_protection__c, live_load__c, mep_override_comments__c, massing_override_comments__c, mid_sf__c,
                                                     number_of_stops__c, other_special_condition_specify__c, over_percentage_of_perimeter__c, parasiteadj__c, penthouse__c, plumbing_fixtures_ea__c,
                                                     plumbing_fixtures__c, primary_roof_type__c, recordtype__c, roof_system_override_comments__c, roofing_flat_roof_ps__c, roofing_green_roof_ps__c,
                                                     roofing_override_comments__c, roofing_override_percent__c, roofing_skylights_sf__c, roofing_skylights__c, roofing_sloped_roof_ps__c, siteremoteness_cost_impact__c,
                                                     site_access_cost_impact__c, site_access__c, site_remoteness__c, skin_system_override_comments__c, sloped_roof_bg__c, sloped_roof_sf__c,
                                                     soil_bearing_capacity__c, soil_bearing_strength__c, stair_analysis_total_flights__c, structural_frame__c, structure_override_comments__c, top_sf__c,
                                                     total_roof_area_sf__c, typical_bay_size_a__c, typical_bay_size_b__c, upper_roof_sf__c, use_ballistic_protection_to_windows__c, use_blast_resistance__c,
                                                     use_cctv_system_cctv_allowance__c, use_chemical_filtration_area_served_sf__c, use_hepa_filtration_area_served_sf__c, use_intrusion_detection_system_ids__c, use_level_of_protection__c,
                                                     vertical_conveyance_elevators__c, vertical_conveyance_escalators_pr__c, vertical_conveyance_escalators_pairs__c, vertical_transportation_override_comment__c, water_table_depth__c,
                                                     window_percentage_sf__c, window_percentage__c, balance__c, character__c, code_seismic_compliance__c, comments_cladding_system__c, comments_conveying__c,
                                                     comments_electrical__c, comments_fire_protection__c, comments_hvac__c, comments_plumbing__c, comments_roofing__c, comments_structural_frame__c, controls__c,
                                                     default_area_sf__c, default_finished_site_area__c, default_fire_protection_area_sf__c, distribution_system__c, dominant_glazing_system1__c,
                                                     dominant_glazing_system2__c, dominant_glazing_system3__c, dominant_roofing_material__c, elevator_type__c, finished_site_area__c,
                                                     finished_site_comments__c, fire_protection__c, lighting__c, number_of_elevators__c, overall_condition_cladding__c, overall_condition_conveying__c,
                                                     overall_condition_electrical__c, overall_condition_fire_protection__c, overall_condition_glazing_system__c, overall_condition_hvac__c,
                                                     overall_condition_interiors__c, overall_condition_plumbing__c, overall_condition_roofing__c, overall_condition_structural_frame__c, overall_quality__c,
                                                     overall_condition__c, override_area_sf__c, override_finished_wall_area_sf__c, override_fire_protection_area_sf__c, override_glazing_ratio_sf__c,
                                                     override_plumbing_fixtures_ea__c, override_total_roof_area_sf__c, parking_sf__c, plaza_sf__c, primary_system__c, special_system__c,
                                                     telecom_it__c, user_power__c, utilities_condition__c/*, default_finished_wall_area_sf__c,
                                                      default_glazing_sf__c, default_finished_opaque_wall_sf__c, default_stairs_flight__c, use_stairs_flight__c,
                                                     def_vertical_conveyance_elevators_stops__c, default_heating_load_mbtuh__c, default_cooling_load__c, default_ahu_load__c,
                                                     default_electrical_load_primary_kw__c, panelboards__c, fixtures_utility_water_coolers__c, default_fixtures_public_restrooms__c, use_fixtures_public_restrooms__c */
                                                 from Project_Level_Parameter__c where NCMT_Project__c =: origId];
       
    	List<Project_Level_Parameter__c> plpToInsert = new List<Project_Level_Parameter__c>();
        
        for(Project_Level_Parameter__c p : plps)
        {
            p.Id = null;
			p.NCMT_Project__c = projId;
            plpToInsert.add(p);
        }
        
        insert plpToInsert;
        System.debug('PLPs INSERTED: ' + plpToInsert);
        
        //Building Massing by Floor next! 
        List<NCMT_Building_Massing_By_Floor__c> bmbf = [SELECT Id,Building_Massing_Area__c,Default_Area_SF__c,
                                                               Proj_Level_Parameter__c, Use_Area_SF__c,Default_Skylights_SF__c
                                                        FROM NCMT_Building_Massing_By_Floor__c WHERE NCMT_Project_Id__c =: origId];
    	//System.debug('BMBF TO INSERT: ' + bmbf.size());
    	
        List<NCMT_Building_Massing_By_Floor__c> bmbfToInsert = new List<NCMT_Building_Massing_By_Floor__c>();
        
        for(NCMT_Building_Massing_By_Floor__c b: bmbf)
        {
			b.id = null;
            if(plpToInsert.size() > 0)
            	b.Proj_Level_Parameter__c = plpToInsert[0].Id;
            bmbfToInsert.add(b);
        }
        
        insert bmbfToInsert;
        
        //Clone Site Information Data
        List<Site_Information__c> sites = [Select Id, name, project__c, add_structured_parking__c, add_perimeter_site__c, adjusted_area_required__c, 
                                                base_area_required__c, best_minimum_floorplate_250_x_120__c, corners_area_required__c, far__c, 
                                                finished_site__c, floorplate__c, footprint_area__c, gf_perimeter__c, gross_building_area__c, 
                                                larger_of_far_or_footprint__c, number_of_stories_max__c, optimize_stories__c, perimeter_lf__c, 
                                                perimeter_area_sf__c, site_area_based_on_far__c, site_area_for_default_value__c, 
                                                structured_parking_area_required__c, surface_parking_area_required__c, total_area__c, 
                                                total_direct_site_area__c, total_minimum_overall_site_area_far__c, total_minimum_overall_site_area_demand__c, 
                                                total_site_required_by_setbacks__c 
                                        from Site_Information__c where Project__c =: origId];
        
        List<Site_Information__c> sitesToInsert = new List<Site_Information__c>();
        
        for(Site_Information__c s : sites)
        {
			s.Id = null;
            s.Project__c = projId;
            //if(s.Project_Level_Parameter__c != null)
            //    s.Project_Level_Parameter__c = plpToInsert[0].Id;
            sitesToInsert.add(s);
        }
        
        insert sitesToInsert;
        
        //Clone Estimate Adjustments --use existing method(only uses 1 query)
        NCMT_GenerateProjectDetailsExt d = new NCMT_GenerateProjectDetailsExt();
        System.debug('trigger.new====='+trigger.new);
        if(trigger.new.size() > 0)
        	d.GenerateEstimateAdjustments(trigger.new);
        
        //Clone Escalation records
        List<NCMT_Escalation__c> esc = [SELECT Id, Name, Duration__c, Escalation_Percentage__c, Escalation_Type__c,
                                               FY__c, Project__C, Yearly_Escalation__c FROM NCMT_Escalation__c WHERE Project__c =: origId];
        
        List<NCMT_Escalation__c> escToInsert = new List<NCMT_Escalation__c>();
        for(NCMT_Escalation__c e : esc)
        {
            e.Id = null;
            e.Project__c = projId;
            escToInsert.add(e);
        }
        
        insert escToInsert;
        
        //Clone Security Cost Detail records
        List<NCMT_Security_Detail__c> sec = [SELECT Id, Name, Project_Cost_Summary__c, Project_Cost_Summary__r.Cost_Category_Description__c,
                                                    Security_Criterion__c, Security_Parameter__c, Total_Cost__c,
                                                    Project_Name__c,Gross_Sq_Ft__c, Unit_Cost__c 
                                             FROM NCMT_Security_Detail__c WHERE Project_Cost_Summary__r.Project_Name__c =: origId];
        System.debug('SEC COST DETAIL TO CLONE: ' + sec.size());
        
        List<NCMT_Security_Detail__c> secToInsert = new List<NCMT_Security_Detail__c>();
        
        for(NCMT_Security_Detail__c s : sec)
        {
            s.Id = null;
            s.Project_Cost_Summary__c = mapCostSummary.get(s.Project_Cost_Summary__r.Cost_Category_Description__c);
        	secToInsert.add(s);
        }
    	
        insert secToInsert;
        
        //Clone TI-TRCS Cost Detail records
        List<NCMT_TI_TRCS_Cost_Detail__c> tiTRCS = [SELECT Id, NCMT_Project_ID__c, Project_Cost_Summary__r.Cost_Category_Description__c, //NCMT_Housing_Plan__c,
                                                           Project_Cost_Summary__c, Project_Name__c, RA_Core_Shell_Unit_Cost__c,
                                                           RA_New_Fit_Out_Total_Units__c, RA_New_Fit_Out_Unit_Cost__c, RA_Refresh_Total_Units__c,
                                                    	   RA_Refresh_Unit_Cost__c, RA_Renovate_Total_Units__c, RA_Renovate_Unit_Cost__c,
                                                           TI_Total_Cost__c, TI_Total_Units__c, TI_TRCS_Cost_Criterion__c, TI_TRCS_Cost_Parameter__c,
                                                           TI_TRCS_Space_Type__c, TI_Unit_Cost__c, TRCS_Total_Cost__c,TRCS_Total_Units__c, TRCS_Unit_Cost__c
                                                   FROM NCMT_TI_TRCS_Cost_Detail__c WHERE Project_Cost_Summary__r.Project_Name__c =: origId];
        System.debug('TI-TRCS TO CLONE: ' + tiTRCS.size());
        
        List<NCMT_TI_TRCS_Cost_Detail__c> tiTRCSToInsert = new List<NCMT_TI_TRCS_Cost_Detail__c>();
        
        for(NCMT_TI_TRCS_Cost_Detail__c t : tiTRCS)
        {
			t.Id = null;
            t.Project_Cost_Summary__c = mapCostSummary.get(t.Project_Cost_Summary__r.Cost_Category_Description__c);
        	//t.NCMT_Housing_Plan__c = mapHousingPlan.get(t.NCMT_Housing_Plan__c);
            tiTRCSToInsert.add(t);
        }
        
        insert tiTRCSToInsert;
        
        //Clone Professional Service Estimate
        List<Professional_Service_Estimate__c> pse = [Select Id, name, recordtypeid, AE75__c, AE90__c, AE_CMa_CMc_Cx_CECC__c, AE_CMa_CMc_Cx_ECC__c, Anticipated_date_of_design_award__c, anticipated_start_date_of_construction__c, 
                                                               base_date_of_estimate__c, building_type__c, cecc__c, cm75__c, cm90__c, cm_role__c, city__c, construction_ae_percent__c, construction_cm_as_agent_cm_as_const__c, 
                                                               construction_cx_percent__c, construction__c, cost_advantage_amount__c, cost_advantage__c, cost_factor_based_on_ecc__c, Cx75__c, Cx90__c,
                                                               delivery_method__c, design_ae_percent__c, design_build_leased_delivery_only__c, design_cm_as_agent_and_cm_as_const__c, 
                                                               design_cm_as_agent_and_cm_as_constructor__c, design_cx_percent__c, detail_complexity_index__c, ecc__c, estimated_total_gsf__c, 
                                                               for_design_build_owned_stipend_compl__c, for_design_build_owned_stipend_detail__c, gsa_cm_construction_fee__c, gsa_cm_construction__c, 
                                                               gsa_cm_design_fee__c, gsa_cm_design__c, gsa_cm_total_fee__c, gsa_cm_total__c, location_parameter__c, ncmt_project__c, project_type__c, 
                                                               region_code__c, state__c, stipend_amount__c, stipend_percentage_unadjusted__c, stipend_percentage__c, total_ae_percent__c, total_ae__c, 
                                                               total_amount__c, total_cm_as_agent_and_cm_as_constructor__c, total_const_cm_agent_cm_const_perc__c, total_construction_amount__c, 
                                                               total_construction_percent__c, total_construction_w_gsa_cm_fee__c, total_construction_w_gsa_cm__c, total_cx_percent__c, total_cx__c, 
                                                               total_design_amount__c, total_design_percent__c, total_design_w_gsa_cm__c, total_percent__c, total_w_gsa_cm_amount__c, total_w_gsa_cm_fee__c, 
                                                               total_w_gsa_cm__c, construction_ae__c, construction_cma_and_cmc__c, construction_cmc__c, construction_cma__c, construction_cx__c, design_ae__c, 
                                                               design_cma_and_cmc__c, design_cmc__c, design_cmx__c, design_cma__c, estimated_number_of_phases__c, scope__c, total_r_a_construction_duration_years__c, 
                                                               total_r_a_design_duration_years__c, location_parameter_name__c, New_Construction_Duration__c, Design_Duration__c
                                                        from Professional_Service_Estimate__c where NCMT_Project__c =: origId];
        System.debug('PSE: ' + pse);
        
        //Delete any existing PSE records
        List<Professional_Service_Estimate__c> pseToDelete = [SELECT Id FROM Professional_Service_Estimate__c WHERE NCMT_Project__c =: projId];
        System.debug('EXISTING PSE: ' + pseToDelete.size());
        delete pseToDelete;
        
        List<Professional_Service_Estimate__c> pseToInsert = new List<Professional_Service_Estimate__c>(); 
        NCMT_Project__c projName = [SELECT Name FROM NCMT_Project__c WHERE Id =: projId Limit 1];
        String projectName = projName.Name;
        
        for(Professional_Service_Estimate__c p : pse)
        {
            p.Id = null;
            p.NCMT_Project__c = projId;
            p.Name = projectName;
            pseToInsert.add(p);
        }
        
        insert pseToInsert;
        
		//Clone Professional Service Estimate List records
		List<Professional_Service_Estimate_List__c> pseList = [SELECT Id,Added_b_c_of_Construction_Escalation_ECC__c,What_s_Added_b_c_of_salary_escalation__c,
                                                                     Current_Fee__c, EDRC_EMIC_Type__c, Escalated_by_Salary__c, Future_Fee_ECC__c, Percentage_ECC__c,
                                                              		 Percentage_to_Use__c, PS__c, Total__c, Type__c  
                                                               FROM Professional_Service_Estimate_List__c WHERE PS__r.NCMT_Project__c =: origId];
        
        List<Professional_Service_Estimate_List__c> pseListToInsert = new List<Professional_Service_Estimate_List__c>();
        
        for(Professional_Service_Estimate_List__c l : pseList)
        {
            l.Id = null;
            l.PS__c = pseToInsert[0].Id;
            pseListToInsert.add(l);
        }
        
        insert pseListToInsert;
    }
    
    public void cloneCoreShellCostDetails()
    {
        //Generate PCS Map
        List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :projId Limit 1000];
        //System.debug('PCS LIST: ' + listCostSummary.size());    
        Map<string, String> mapCostSummary = new Map<string, String>();
            for(NCMT_Project_Cost_Summary__c objItem : listCostSummary)
                mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
        System.debug('PCS MAP: ' + mapCostSummary);
        
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
            //s.TCO_Performance_Input__c =perfInputId;
            //s.TCO_Project_Cost_Rate__c = pcrId;
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
        
        NCMT_GenerateTCOProjectDetailsExt.updateCoreShell_WF(coreShellIds);
    }
    
    
}