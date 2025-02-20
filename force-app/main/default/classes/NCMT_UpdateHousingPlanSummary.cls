public with sharing class NCMT_UpdateHousingPlanSummary {
    public static boolean checkFirstRun= true;
    public void UpdateHousingPlanSummaryData(List<NCMT_Housing_Plan_Summary__c> HPList, Id PIds, String ProjectRecordTypeName) {
        
        System.debug('UdpateHousingPlanSummaryData');
        Map<Id, NCMT_Project__c> Proj = new Map <Id, NCMT_Project__c> ( [select Gross_Area__c, Useable_Area__c, Housing_Plan__c, Default_Housing_Plan__c, Total_Area_Including_Parking__c, Parking_Within_Building_Structure__c,
                                    Percentage_of_Tenant_Area_Unfinished__c, Building_Cost_Type__c, Total_Area_Incl_Parking__c,
                                    Building_Parameter__r.Name, Building_Parameter__r.Efficiency__c, Building_Height_Parameter__r.Elevators__c,
                                    Building_Parameter__r.Main_Lobby_Building2_Percent__c, Building_Parameter__r.Atrium_Building2_Percent__c, Building_Parameter__r.Ground_floor_circulation_Bldg2_Percent__c, 
                                    Building_Parameter__r.Mechanical_Electrical_IT_Bldg2_Percent__c, Building_Parameter__r.Other_circulation_Building2_Percent__c,
                                    Building_Parameter__r.Loading_dock_Recycling_Trash_B2_Percent__c,
                                    Building_Height_Parameter__r.RecordType.Name, Building_Height_Parameter__r.No_of_Floors__c, Building_Height_Parameter__r.Bast_Ratio__c, 
                                    Building_Height_Parameter__r.Plumbing_Fixtures__c, Building_Height_Parameter__r.Story_Ht__c,                                    
                                    Building_Parameter__r.Step_1_Size__c, Building_Parameter__r.Step_1_Percentage__c, Building_Parameter__r.Step_2_Size__c, Building_Parameter__r.Step_2_Percentage__c,
                                    Building_Parameter__r.Workstations_open_off_Building1_Percent__c, Building_Parameter__r.Workstations_open_off_Building2_Percent__c, Building_Parameter__r.Workstations_open_off_Building3_Percent__c,
                                    Building_Parameter__r.Closed_offices_Building1_Percent__c, Building_Parameter__r.Closed_offices_Building2_Percent__c, Building_Parameter__r.Closed_offices_Building3_Percent__c,
                                    Building_Parameter__r.X8_20_person_rooms_Building1_Percent__c, Building_Parameter__r.X8_20_person_rooms_Building2_Percent__c, Building_Parameter__r.X8_20_person_rooms_Building3_Percent__c,
                                    Building_Parameter__r.X20_or_more_person_rooms_Bldg1_Percent__c, Building_Parameter__r.X20_or_more_person_rooms_Bldg2_Percent__c, Building_Parameter__r.X20_or_more_person_rooms_Bldg3_Percent__c,
                                    Building_Parameter__r.Teleconference_Building1_Percent__c, Building_Parameter__r.Teleconference_Building2_Percent__c, Building_Parameter__r.Teleconference_Building3_Percent__c,
                                    Building_Parameter__r.Auditorium_sloped_floor_Bldg1_Percent__c, Building_Parameter__r.Auditorium_sloped_floor_Bldg2_Percent__c, Building_Parameter__r.Auditorium_sloped_floor_Bldg3_Percent__c,
                                    Building_Parameter__r.General_storage_Building1_Percent__c, Building_Parameter__r.General_storage_Building2_Percent__c, Building_Parameter__r.General_storage_Building3_Percent__c,
                                    Building_Parameter__r.Clinics_health_units_Building1_Percent__c, Building_Parameter__r.Clinics_health_units_Building2_Percent__c, Building_Parameter__r.Clinics_health_units_Building3_Percent__c,
                                    Building_Parameter__r.Physical_fitness_Building1_Percent__c, Building_Parameter__r.Physical_fitness_Building2_Percent__c, Building_Parameter__r.Physical_fitness_Building3_Percent__c,
                                    Building_Parameter__r.Child_care_Building1_Percent__c, Building_Parameter__r.Child_care_Building2_Percent__c, Building_Parameter__r.Child_care_Building3_Percent__c,
                                    Building_Parameter__r.Libraries_Building1_Percent__c, Building_Parameter__r.Libraries_Building2_Percent__c, Building_Parameter__r.Libraries_Building3_Percent__c,
                                    Building_Parameter__r.ADP_high_density_PC_s_Bldg1_Percent__c, Building_Parameter__r.ADP_high_density_PC_s_Bldg2_Percent__c, Building_Parameter__r.ADP_high_density_PC_s_Bldg3_Percent__c,
                                    Building_Parameter__r.ADP_mainframe_Building1_Percent__c, Building_Parameter__r.ADP_mainframe_Building2_Percent__c, Building_Parameter__r.ADP_mainframe_Building3_Percent__c,
                                    Building_Parameter__r.Joint_use_retail_Building1_Percent__c, Building_Parameter__r.Joint_use_retail_Building2_Percent__c, Building_Parameter__r.Joint_use_retail_Building3_Percent__c,
                                    Building_Parameter__r.Food_service_cafeteria_Bldg1_Percent__c, Building_Parameter__r.Food_service_cafeteria_Bldg2_Percent__c, Building_Parameter__r.Food_service_cafeteria_Bldg3_Percent__c,
                                    Building_Parameter__r.Laboratory_Dry_elec_Building1_Percent__c, Building_Parameter__r.Laboratory_Dry_elec_Building2_Percent__c, Building_Parameter__r.Laboratory_Dry_elec_Building3_Percent__c,
                                    Building_Parameter__r.Laboratory_Wet_chem_Building1_Percent__c, Building_Parameter__r.Laboratory_Wet_chem_Building2_Percent__c, Building_Parameter__r.Laboratory_Wet_chem_Building3_Percent__c,
                                    Building_Parameter__r.Locker_Shower_room_Building1_Percent__c, Building_Parameter__r.Locker_Shower_room_Building2_Percent__c, Building_Parameter__r.Locker_Shower_room_Building3_Percent__c,
                                    Building_Parameter__r.Light_industrial_Building1_Percent__c, Building_Parameter__r.Light_industrial_Building2_Percent__c, Building_Parameter__r.Light_industrial_Building3_Percent__c,
                                    Building_Parameter__r.Warehouse_Building1_Percent__c, Building_Parameter__r.Warehouse_Building2_Percent__c, Building_Parameter__r.Warehouse_Building3_Percent__c,
                                    Building_Parameter__r.Courtroom_dist_Ceremonial_B1_Percent__c, Building_Parameter__r.Courtroom_dist_Ceremonial_B2_Percent__c, Building_Parameter__r.Courtroom_dist_Ceremonial_B3_Percent__c,
                                    Building_Parameter__r.Courtroom_dist_Standard_Bldg1_Percent__c, Building_Parameter__r.Courtroom_dist_Standard_Bldg2_Percent__c, Building_Parameter__r.Courtroom_dist_Standard_Bldg3_Percent__c,
                                    Building_Parameter__r.Courtroom_Bankruptcy_Building1_Percent__c, Building_Parameter__r.Courtroom_Bankruptcy_Building2_Percent__c, Building_Parameter__r.Courtroom_Bankruptcy_Building3_Percent__c,
                                    Building_Parameter__r.Courtroom_Magistrate_Building1_Percent__c, Building_Parameter__r.Courtroom_Magistrate_Building2_Percent__c, Building_Parameter__r.Courtroom_Magistrate_Building3_Percent__c,
                                    Building_Parameter__r.Grand_Jury_Room_Building1_Percent__c, Building_Parameter__r.Grand_Jury_Room_Building2_Percent__c, Building_Parameter__r.Grand_Jury_Room_Building3_Percent__c,
                                    Building_Parameter__r.Judicial_hearing_Building1_Percent__c, Building_Parameter__r.Judicial_hearing_Building2_Percent__c, Building_Parameter__r.Judicial_hearing_Building3_Percent__c,
                                    Building_Parameter__r.Judicial_chambers_Building1_Percent__c, Building_Parameter__r.Judicial_chambers_Building2_Percent__c, Building_Parameter__r.Judicial_chambers_Building3_Percent__c,
                                    Building_Parameter__r.Enhanced_office_Building1_Percent__c, Building_Parameter__r.Enhanced_office_Building2_Percent__c, Building_Parameter__r.Enhanced_office_Building3_Percent__c,
                                    Building_Parameter__r.USMS_Suite_Admin_Building1_Percent__c, Building_Parameter__r.USMS_Suite_Admin_Building2_Percent__c, Building_Parameter__r.USMS_Suite_Admin_Building3_Percent__c,
                                    Building_Parameter__r.USMS_Suite_Operations_Building1_Percent__c, Building_Parameter__r.USMS_Suite_Operations_Building2_Percent__c, Building_Parameter__r.USMS_Suite_Operations_Building3_Percent__c,
                                    Building_Parameter__r.Sally_Port_Building1_Percent__c, Building_Parameter__r.Sally_Port_Building2_Percent__c, Building_Parameter__r.Sally_Port_Building3_Percent__c,
                                    Building_Parameter__r.Holding_cell_Central_Building1_Percent__c, Building_Parameter__r.Holding_cell_Central_Building2_Percent__c, Building_Parameter__r.Holding_cell_Central_Building3_Percent__c,
                                    Building_Parameter__r.Holding_cell_Court_floors_Bldg1_Percent__c, Building_Parameter__r.Holding_cell_Court_floors_Bldg2_Percent__c, Building_Parameter__r.Holding_cell_Court_floors_Bldg3_Percent__c,
                                    Building_Parameter__r.Non_climate_controlled_Building1_Percent__c, Building_Parameter__r.Non_climate_controlled_Building2_Percent__c, Building_Parameter__r.Non_climate_controlled_Building3_Percent__c,
                                    Building_Parameter__r.Climate_controlled_Building1_Percent__c, Building_Parameter__r.Climate_controlled_Building2_Percent__c, Building_Parameter__r.Climate_controlled_Building3_Percent__c,                                    
                                    Building_Parameter__r.VA_Intake_Building1_Percent__c, Building_Parameter__r.VA_Intake_Building2_Percent__c, Building_Parameter__r.VA_Intake_Building3_Percent__c,
                                    Building_Parameter__r.VA_Exam_Suite_Building1_Percent__c, Building_Parameter__r.VA_Exam_Suite_Building2_Percent__c, Building_Parameter__r.VA_Exam_Suite_Building3_Percent__c,
                                    Building_Parameter__r.VA_Radiology_Building1_Percent__c, Building_Parameter__r.VA_Radiology_Building2_Percent__c, Building_Parameter__r.VA_Radiology_Building3_Percent__c,
                                    Building_Parameter__r.VA_Ambulatory_Surgery_Building1_Percent__c, Building_Parameter__r.VA_Ambulatory_Surgery_Building2_Percent__c, Building_Parameter__r.VA_Ambulatory_Surgery_Building3_Percent__c,
                                    Building_Parameter__r.VA_Infusion_Building1_Percent__c, Building_Parameter__r.VA_Infusion_Building2_Percent__c, Building_Parameter__r.VA_Infusion_Building3_Percent__c,
                                    Building_Parameter__r.VA_Pharmacy_Building1_Percent__c, Building_Parameter__r.VA_Pharmacy_Building2_Percent__c, Building_Parameter__r.VA_Pharmacy_Building3_Percent__c,
                                    Building_Parameter__r.Data_Center_Building1_Percent__c, Building_Parameter__r.Data_Center_Building2_Percent__c, Building_Parameter__r.Data_Center_Building3_Percent__c,
                                    Average_Story_Height__c, Plumbing_Fixtures__c, Vertical_Conveyance_Elevators_Stops__c, Above_Ground__c, Below_Ground__c,
                                    Parking_Garage_Gross_Area_SF__c, At_and_above_grade__c, Below_grade__c, Building_Height_Parameter__r.Cladding_Thickness__c, Project_Type__c, Gross_Area_Including_Parking__c, Affected_Tenant_Area_USF__c                                                                  
                                                from NCMT_Project__c where Id = :PIds]);
        
        //get BuildingCode 
        string BCode;
        //get Total Area Including Parking
        Decimal Total_Area_Including_Parking;
        //get Building Parameter values
        Decimal BuildingStep1Size;
        Decimal BuildingStep2Size;
        //Decimal BuildingStep3Size;
        Decimal BuildingStep1Percent;
        Decimal BuildingStep2Percent;
        //Decimal BuildingStep3Percent;
        Decimal Workstations_open_off_Building1_Percent;
        Decimal Workstations_open_off_Building2_Percent;
        Decimal Workstations_open_off_Building3_Percent;
        Decimal Closed_offices_Building1_Percent;
        Decimal Closed_offices_Building2_Percent;
        Decimal Closed_offices_Building3_Percent;
        Decimal X8_20_person_rooms_Building1_Percent;
        Decimal X8_20_person_rooms_Building2_Percent;
        Decimal X8_20_person_rooms_Building3_Percent;
        Decimal X20_or_more_person_rooms_Bldg1_Percent;
        Decimal X20_or_more_person_rooms_Bldg2_Percent;
        Decimal X20_or_more_person_rooms_Bldg3_Percent;
        Decimal Teleconference_Building1_Percent;
        Decimal Teleconference_Building2_Percent;
        Decimal Teleconference_Building3_Percent;
        Decimal Auditorium_sloped_floor_Bldg1_Percent;
        Decimal Auditorium_sloped_floor_Bldg2_Percent;
        Decimal Auditorium_sloped_floor_Bldg3_Percent;
        Decimal General_storage_Building1_Percent;
        Decimal General_storage_Building2_Percent;
        Decimal General_storage_Building3_Percent;
        Decimal Clinics_health_units_Building1_Percent;
        Decimal Clinics_health_units_Building2_Percent;
        Decimal Clinics_health_units_Building3_Percent;
        Decimal Physical_fitness_Building1_Percent;
        Decimal Physical_fitness_Building2_Percent;
        Decimal Physical_fitness_Building3_Percent;
        Decimal Child_care_Building1_Percent;
        Decimal Child_care_Building2_Percent;
        Decimal Child_care_Building3_Percent;
        Decimal Libraries_Building1_Percent;
        Decimal Libraries_Building2_Percent;
        Decimal Libraries_Building3_Percent;
        Decimal ADP_high_density_PC_s_Bldg1_Percent;
        Decimal ADP_high_density_PC_s_Bldg2_Percent;
        Decimal ADP_high_density_PC_s_Bldg3_Percent;
        Decimal ADP_mainframe_Building1_Percent;
        Decimal ADP_mainframe_Building2_Percent;
        Decimal ADP_mainframe_Building3_Percent;
        Decimal Joint_use_retail_Building1_Percent;
        Decimal Joint_use_retail_Building2_Percent;
        Decimal Joint_use_retail_Building3_Percent;
        Decimal Food_service_cafeteria_Bldg1_Percent;
        Decimal Food_service_cafeteria_Bldg2_Percent;
        Decimal Food_service_cafeteria_Bldg3_Percent;
        Decimal Laboratory_Dry_elec_Building1_Percent;
        Decimal Laboratory_Dry_elec_Building2_Percent;
        Decimal Laboratory_Dry_elec_Building3_Percent;
        Decimal Laboratory_Wet_chem_Building1_Percent;
        Decimal Laboratory_Wet_chem_Building2_Percent;
        Decimal Laboratory_Wet_chem_Building3_Percent;
        Decimal Locker_Shower_room_Building1_Percent;
        Decimal Locker_Shower_room_Building2_Percent;
        Decimal Locker_Shower_room_Building3_Percent;
        Decimal Light_industrial_Building1_Percent;
        Decimal Light_industrial_Building2_Percent;
        Decimal Light_industrial_Building3_Percent;
        Decimal Warehouse_Building1_Percent;
        Decimal Warehouse_Building2_Percent;
        Decimal Warehouse_Building3_Percent;
        Decimal Courtroom_dist_Ceremonial_B1_Percent;
        Decimal Courtroom_dist_Ceremonial_B2_Percent;
        Decimal Courtroom_dist_Ceremonial_B3_Percent;
        Decimal Courtroom_dist_Standard_Bldg1_Percent;
        Decimal Courtroom_dist_Standard_Bldg2_Percent;
        Decimal Courtroom_dist_Standard_Bldg3_Percent;
        Decimal Courtroom_Bankruptcy_Building1_Percent;
        Decimal Courtroom_Bankruptcy_Building2_Percent;
        Decimal Courtroom_Bankruptcy_Building3_Percent;
        Decimal Courtroom_Magistrate_Building1_Percent;
        Decimal Courtroom_Magistrate_Building2_Percent;
        Decimal Courtroom_Magistrate_Building3_Percent;
        Decimal Grand_Jury_Room_Building1_Percent;
        Decimal Grand_Jury_Room_Building2_Percent;
        Decimal Grand_Jury_Room_Building3_Percent;
        Decimal Judicial_hearing_Building1_Percent;
        Decimal Judicial_hearing_Building2_Percent;
        Decimal Judicial_hearing_Building3_Percent;
        Decimal Judicial_chambers_Building1_Percent;
        Decimal Judicial_chambers_Building2_Percent;
        Decimal Judicial_chambers_Building3_Percent;
        Decimal Enhanced_office_Building1_Percent;
        Decimal Enhanced_office_Building2_Percent;
        Decimal Enhanced_office_Building3_Percent;
        Decimal USMS_Suite_Admin_Building1_Percent;
        Decimal USMS_Suite_Admin_Building2_Percent;
        Decimal USMS_Suite_Admin_Building3_Percent;
        Decimal USMS_Suite_Operations_Building1_Percent;
        Decimal USMS_Suite_Operations_Building2_Percent;
        Decimal USMS_Suite_Operations_Building3_Percent;
        Decimal Sally_Port_Building1_Percent;
        Decimal Sally_Port_Building2_Percent;
        Decimal Sally_Port_Building3_Percent;
        Decimal Holding_cell_Central_Building1_Percent;
        Decimal Holding_cell_Central_Building2_Percent;
        Decimal Holding_cell_Central_Building3_Percent;
        Decimal Holding_cell_Court_floors_Bldg1_Percent;
        Decimal Holding_cell_Court_floors_Bldg2_Percent;
        Decimal Holding_cell_Court_floors_Bldg3_Percent;
        Decimal Non_climate_controlled_Building1_Percent;
        Decimal Non_climate_controlled_Building2_Percent;
        Decimal Non_climate_controlled_Building3_Percent;
        Decimal Climate_controlled_Building1_Percent;
        Decimal Climate_controlled_Building2_Percent;
        Decimal Climate_controlled_Building3_Percent; 
        Decimal VA_Intake_Building1_Percent;
        Decimal VA_Intake_Building2_Percent;
        Decimal VA_Intake_Building3_Percent;        
        Decimal VA_Exam_Suite_Building1_Percent;
        Decimal VA_Exam_Suite_Building2_Percent;
        Decimal VA_Exam_Suite_Building3_Percent;
        Decimal VA_Radiology_Building1_Percent;
        Decimal VA_Radiology_Building2_Percent;
        Decimal VA_Radiology_Building3_Percent; 
        Decimal VA_Ambulatory_Surgery_Building1_Percent;
        Decimal VA_Ambulatory_Surgery_Building2_Percent;
        Decimal VA_Ambulatory_Surgery_Building3_Percent; 
        Decimal VA_Infusion_Building1_Percent;
        Decimal VA_Infusion_Building2_Percent;
        Decimal VA_Infusion_Building3_Percent; 
        Decimal VA_Pharmacy_Building1_Percent;
        Decimal VA_Pharmacy_Building2_Percent;
        Decimal VA_Pharmacy_Building3_Percent; 
        Decimal Data_Center_Building1_Percent;
        Decimal Data_Center_Building2_Percent;
        Decimal Data_Center_Building3_Percent;      
        Decimal Average_Story_Height;
        Decimal Plumbing_Fixtures;
        Decimal Number_of_Stops;
        Decimal PLPAverage_Story_Height;
        Decimal PLPPlumbing_Fixtures;
        Decimal PLPNumber_of_Stops;     
        Decimal Number_of_Floors;
        Decimal No_of_Stairs_Floors;
        Decimal Main_Entry_Stairs;
        
        Decimal intOpenOfficeTypUSFUnit; 
        Decimal intClosedOfficesTypUSFUnit;
        Decimal intPrivateTioletsTypUSFUnit;
        Decimal int8_20roomsTypUSFUnit;
        Decimal int20moreTypUSFUnit;
        Decimal intTeleconferenceTypUSFUnit;
        Decimal intAuditoriumTypUSFUnit;
        Decimal intLibrariesTypUSFUnit;
        Decimal intChildCareTypUSFUnit;
        Decimal intADPhighdensitypcsTypUSFUnit;
        Decimal intCourtroomdistCereTypUSFUnit;
        Decimal intCourtroomdistStdTypUSFUnit;
        Decimal intCourtroomBankruptcyTypUSFUnit;
        Decimal intCourtroomMagistrateTypUSFUnit;
        Decimal intGrandJuryRoomTypUSFUnit;
        Decimal intJudicialHearingTypUSFUnit;
        Decimal intJudicialchambersTypUSFUnit;
        Decimal intHoldingcellCentralTypUSFUnit;
        Decimal intHoldingcellCourtfloorsTypUSFUnit;        

        List <System_Level_Parameter__c> SLPList = [SELECT Name, Value__c FROM System_Level_Parameter__c where Category__c = 'Housing Plan' ];      
        For (System_Level_Parameter__c SLP : SLPList ){
            if (SLP.Name == 'Workstations/open office Typical USF/Unit' ) {
                intOpenOfficeTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Closed offices Typical USF/Unit' ) {
                intClosedOfficesTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Private toilets Typical USF/Unit' ) {
                intPrivateTioletsTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == '8 - 20 person rooms Typical USF/Unit' ) {
                int8_20roomsTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == '20 or more person rooms Typical USF/Unit' ) {
                int20moreTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Teleconference Typical USF/Unit' ) {
                intTeleconferenceTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Auditorium (sloped floor) Typical USF/Unit' ) {
                intAuditoriumTypUSFUnit = SLP.Value__c ;
            }            
            if (SLP.Name == 'Libraries Typical USF/Unit' ) {
                intLibrariesTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Child Care Typical USF/Unit' ) {
                intChildCareTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'ADP (high density PCs) Typical USF/Unit' ) {
                intADPhighdensitypcsTypUSFUnit = SLP.Value__c ;
            }            
            if (SLP.Name == 'Courtroom - district Ceremonial Typical USF/Unit' ) {
                intCourtroomdistCereTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Courtroom - district Standard Typical USF/Unit' ) {
                intCourtroomdistStdTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Courtroom - Bankruptcy Typical USF/Unit' ) {
                intCourtroomBankruptcyTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Courtroom - Magistrate Typical USF/Unit' ) {
                intCourtroomMagistrateTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Grand Jury Room Typical USF/Unit' ) {
                intGrandJuryRoomTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Judicial Hearing Typical USF/Unit' ) {
                intJudicialHearingTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Judicial chambers Typical USF/Unit' ) {
                intJudicialchambersTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Holding cell - Central Typical USF/Unit' ) {
                intHoldingcellCentralTypUSFUnit = SLP.Value__c ;
            }
            if (SLP.Name == 'Holding cell - Court floors Typical USF/Unit' ) {
                intHoldingcellCourtfloorsTypUSFUnit = SLP.Value__c ;
            }
        }
        
        For (NCMT_Housing_Plan_Summary__c HPobj : HPList) {
            
            NCMT_Project__c Proj0 = Proj.get(HPobj.Project__c);
            BCode = Proj0.Building_Parameter__r.Name;
            Total_Area_Including_Parking = Proj0.Total_Area_Including_Parking__c;   
            
            BuildingStep1Size = Proj0.Building_Parameter__r.Step_1_Size__c;
            BuildingStep1Percent = Proj0.Building_Parameter__r.Step_1_Percentage__c;
            BuildingStep2Size = Proj0.Building_Parameter__r.Step_2_Size__c;
            BuildingStep2Percent = Proj0.Building_Parameter__r.Step_2_Percentage__c;
            Workstations_open_off_Building1_Percent = Proj0.Building_Parameter__r.Workstations_open_off_Building1_Percent__c ;
            Workstations_open_off_Building2_Percent = Proj0.Building_Parameter__r.Workstations_open_off_Building2_Percent__c ;
            Workstations_open_off_Building3_Percent = Proj0.Building_Parameter__r.Workstations_open_off_Building3_Percent__c ;
            Closed_offices_Building1_Percent = Proj0.Building_Parameter__r.Closed_offices_Building1_Percent__c ;
            Closed_offices_Building2_Percent = Proj0.Building_Parameter__r.Closed_offices_Building2_Percent__c ;
            Closed_offices_Building3_Percent = Proj0.Building_Parameter__r.Closed_offices_Building3_Percent__c ;
            X8_20_person_rooms_Building1_Percent = Proj0.Building_Parameter__r.X8_20_person_rooms_Building1_Percent__c ;
            X8_20_person_rooms_Building2_Percent = Proj0.Building_Parameter__r.X8_20_person_rooms_Building2_Percent__c ;
            X8_20_person_rooms_Building3_Percent = Proj0.Building_Parameter__r.X8_20_person_rooms_Building3_Percent__c ;
            X20_or_more_person_rooms_Bldg1_Percent = Proj0.Building_Parameter__r.X20_or_more_person_rooms_Bldg1_Percent__c ;
            X20_or_more_person_rooms_Bldg2_Percent = Proj0.Building_Parameter__r.X20_or_more_person_rooms_Bldg2_Percent__c ;
            X20_or_more_person_rooms_Bldg3_Percent = Proj0.Building_Parameter__r.X20_or_more_person_rooms_Bldg3_Percent__c ;
            Teleconference_Building1_Percent = Proj0.Building_Parameter__r.Teleconference_Building1_Percent__c;
            Teleconference_Building2_Percent = Proj0.Building_Parameter__r.Teleconference_Building2_Percent__c;
            Teleconference_Building3_Percent = Proj0.Building_Parameter__r.Teleconference_Building3_Percent__c;
            Auditorium_sloped_floor_Bldg1_Percent = Proj0.Building_Parameter__r.Auditorium_sloped_floor_Bldg1_Percent__c;
            Auditorium_sloped_floor_Bldg2_Percent = Proj0.Building_Parameter__r.Auditorium_sloped_floor_Bldg2_Percent__c;
            Auditorium_sloped_floor_Bldg3_Percent = Proj0.Building_Parameter__r.Auditorium_sloped_floor_Bldg3_Percent__c;
            General_storage_Building1_Percent = Proj0.Building_Parameter__r.General_storage_Building1_Percent__c;
            General_storage_Building2_Percent = Proj0.Building_Parameter__r.General_storage_Building2_Percent__c;
            General_storage_Building3_Percent = Proj0.Building_Parameter__r.General_storage_Building3_Percent__c;
            Clinics_health_units_Building1_Percent = Proj0.Building_Parameter__r.Clinics_health_units_Building1_Percent__c;
            Clinics_health_units_Building2_Percent = Proj0.Building_Parameter__r.Clinics_health_units_Building2_Percent__c;
            Clinics_health_units_Building3_Percent = Proj0.Building_Parameter__r.Clinics_health_units_Building3_Percent__c;
            Physical_fitness_Building1_Percent = Proj0.Building_Parameter__r.Physical_fitness_Building1_Percent__c;
            Physical_fitness_Building2_Percent = Proj0.Building_Parameter__r.Physical_fitness_Building2_Percent__c;
            Physical_fitness_Building3_Percent = Proj0.Building_Parameter__r.Physical_fitness_Building3_Percent__c;
            Child_care_Building1_Percent = Proj0.Building_Parameter__r.Child_care_Building1_Percent__c;
            Child_care_Building2_Percent = Proj0.Building_Parameter__r.Child_care_Building2_Percent__c;
            Child_care_Building3_Percent = Proj0.Building_Parameter__r.Child_care_Building3_Percent__c;
            Libraries_Building1_Percent = Proj0.Building_Parameter__r.Libraries_Building1_Percent__c;
            Libraries_Building2_Percent = Proj0.Building_Parameter__r.Libraries_Building2_Percent__c;
            Libraries_Building3_Percent = Proj0.Building_Parameter__r.Libraries_Building3_Percent__c;
            ADP_high_density_PC_s_Bldg1_Percent = Proj0.Building_Parameter__r.ADP_high_density_PC_s_Bldg1_Percent__c;
            ADP_high_density_PC_s_Bldg2_Percent = Proj0.Building_Parameter__r.ADP_high_density_PC_s_Bldg2_Percent__c;
            ADP_high_density_PC_s_Bldg3_Percent = Proj0.Building_Parameter__r.ADP_high_density_PC_s_Bldg3_Percent__c;
            ADP_mainframe_Building1_Percent = Proj0.Building_Parameter__r.ADP_mainframe_Building1_Percent__c;
            ADP_mainframe_Building2_Percent = Proj0.Building_Parameter__r.ADP_mainframe_Building2_Percent__c;
            ADP_mainframe_Building3_Percent = Proj0.Building_Parameter__r.ADP_mainframe_Building3_Percent__c;
            Joint_use_retail_Building1_Percent = Proj0.Building_Parameter__r.Joint_use_retail_Building1_Percent__c;
            Joint_use_retail_Building2_Percent = Proj0.Building_Parameter__r.Joint_use_retail_Building2_Percent__c;
            Joint_use_retail_Building3_Percent = Proj0.Building_Parameter__r.Joint_use_retail_Building3_Percent__c;
            Food_service_cafeteria_Bldg1_Percent = Proj0.Building_Parameter__r.Food_service_cafeteria_Bldg1_Percent__c;
            Food_service_cafeteria_Bldg2_Percent = Proj0.Building_Parameter__r.Food_service_cafeteria_Bldg2_Percent__c;
            Food_service_cafeteria_Bldg3_Percent = Proj0.Building_Parameter__r.Food_service_cafeteria_Bldg3_Percent__c;
            Laboratory_Dry_elec_Building1_Percent = Proj0.Building_Parameter__r.Laboratory_Dry_elec_Building1_Percent__c;
            Laboratory_Dry_elec_Building2_Percent = Proj0.Building_Parameter__r.Laboratory_Dry_elec_Building2_Percent__c;
            Laboratory_Dry_elec_Building3_Percent = Proj0.Building_Parameter__r.Laboratory_Dry_elec_Building3_Percent__c;
            Laboratory_Wet_chem_Building1_Percent = Proj0.Building_Parameter__r.Laboratory_Wet_chem_Building1_Percent__c;
            Laboratory_Wet_chem_Building2_Percent = Proj0.Building_Parameter__r.Laboratory_Wet_chem_Building2_Percent__c;
            Laboratory_Wet_chem_Building3_Percent = Proj0.Building_Parameter__r.Laboratory_Wet_chem_Building3_Percent__c;
            Locker_Shower_room_Building1_Percent = Proj0.Building_Parameter__r.Locker_Shower_room_Building1_Percent__c;
            Locker_Shower_room_Building2_Percent = Proj0.Building_Parameter__r.Locker_Shower_room_Building2_Percent__c;
            Locker_Shower_room_Building3_Percent = Proj0.Building_Parameter__r.Locker_Shower_room_Building3_Percent__c;
            Light_industrial_Building1_Percent = Proj0.Building_Parameter__r.Light_industrial_Building1_Percent__c;
            Light_industrial_Building2_Percent = Proj0.Building_Parameter__r.Light_industrial_Building2_Percent__c;
            Light_industrial_Building3_Percent = Proj0.Building_Parameter__r.Light_industrial_Building3_Percent__c;
            Warehouse_Building1_Percent = Proj0.Building_Parameter__r.Warehouse_Building1_Percent__c;
            Warehouse_Building2_Percent = Proj0.Building_Parameter__r.Warehouse_Building2_Percent__c;
            Warehouse_Building3_Percent = Proj0.Building_Parameter__r.Warehouse_Building3_Percent__c; 
            Courtroom_dist_Ceremonial_B1_Percent = Proj0.Building_Parameter__r.Courtroom_dist_Ceremonial_B1_Percent__c;         
            Courtroom_dist_Ceremonial_B2_Percent = Proj0.Building_Parameter__r.Courtroom_dist_Ceremonial_B2_Percent__c;
            Courtroom_dist_Ceremonial_B3_Percent = Proj0.Building_Parameter__r.Courtroom_dist_Ceremonial_B3_Percent__c;
            Courtroom_dist_Standard_Bldg1_Percent = Proj0.Building_Parameter__r.Courtroom_dist_Standard_Bldg1_Percent__c;
            Courtroom_dist_Standard_Bldg2_Percent = Proj0.Building_Parameter__r.Courtroom_dist_Standard_Bldg2_Percent__c;
            Courtroom_dist_Standard_Bldg3_Percent = Proj0.Building_Parameter__r.Courtroom_dist_Standard_Bldg3_Percent__c;
            Courtroom_Bankruptcy_Building1_Percent = Proj0.Building_Parameter__r.Courtroom_Bankruptcy_Building1_Percent__c;
            Courtroom_Bankruptcy_Building2_Percent = Proj0.Building_Parameter__r.Courtroom_Bankruptcy_Building2_Percent__c;
            Courtroom_Bankruptcy_Building3_Percent = Proj0.Building_Parameter__r.Courtroom_Bankruptcy_Building3_Percent__c;
            Courtroom_Magistrate_Building1_Percent = Proj0.Building_Parameter__r.Courtroom_Magistrate_Building1_Percent__c;
            Courtroom_Magistrate_Building2_Percent = Proj0.Building_Parameter__r.Courtroom_Magistrate_Building2_Percent__c;
            Courtroom_Magistrate_Building3_Percent = Proj0.Building_Parameter__r.Courtroom_Magistrate_Building3_Percent__c;
            Grand_Jury_Room_Building1_Percent = Proj0.Building_Parameter__r.Grand_Jury_Room_Building1_Percent__c;
            Grand_Jury_Room_Building2_Percent = Proj0.Building_Parameter__r.Grand_Jury_Room_Building2_Percent__c;
            Grand_Jury_Room_Building3_Percent = Proj0.Building_Parameter__r.Grand_Jury_Room_Building3_Percent__c;
            Judicial_hearing_Building1_Percent = Proj0.Building_Parameter__r.Judicial_hearing_Building1_Percent__c;
            Judicial_hearing_Building2_Percent = Proj0.Building_Parameter__r.Judicial_hearing_Building2_Percent__c;
            Judicial_hearing_Building3_Percent = Proj0.Building_Parameter__r.Judicial_hearing_Building3_Percent__c;
            Judicial_chambers_Building1_Percent = Proj0.Building_Parameter__r.Judicial_chambers_Building1_Percent__c;
            Judicial_chambers_Building2_Percent = Proj0.Building_Parameter__r.Judicial_chambers_Building2_Percent__c;
            Judicial_chambers_Building3_Percent = Proj0.Building_Parameter__r.Judicial_chambers_Building3_Percent__c;
            Enhanced_office_Building1_Percent = Proj0.Building_Parameter__r.Enhanced_office_Building1_Percent__c;
            Enhanced_office_Building2_Percent = Proj0.Building_Parameter__r.Enhanced_office_Building2_Percent__c;
            Enhanced_office_Building3_Percent = Proj0.Building_Parameter__r.Enhanced_office_Building3_Percent__c;
            USMS_Suite_Admin_Building1_Percent = Proj0.Building_Parameter__r.USMS_Suite_Admin_Building1_Percent__c;
            USMS_Suite_Admin_Building2_Percent = Proj0.Building_Parameter__r.USMS_Suite_Admin_Building2_Percent__c;
            USMS_Suite_Admin_Building3_Percent = Proj0.Building_Parameter__r.USMS_Suite_Admin_Building3_Percent__c;
            USMS_Suite_Operations_Building1_Percent = Proj0.Building_Parameter__r.USMS_Suite_Operations_Building1_Percent__c;
            USMS_Suite_Operations_Building2_Percent = Proj0.Building_Parameter__r.USMS_Suite_Operations_Building2_Percent__c;
            USMS_Suite_Operations_Building3_Percent = Proj0.Building_Parameter__r.USMS_Suite_Operations_Building3_Percent__c;
            Sally_Port_Building1_Percent = Proj0.Building_Parameter__r.Sally_Port_Building1_Percent__c;
            Sally_Port_Building2_Percent = Proj0.Building_Parameter__r.Sally_Port_Building2_Percent__c;
            Sally_Port_Building3_Percent = Proj0.Building_Parameter__r.Sally_Port_Building3_Percent__c;
            Holding_cell_Central_Building1_Percent = Proj0.Building_Parameter__r.Holding_cell_Central_Building1_Percent__c;
            Holding_cell_Central_Building2_Percent = Proj0.Building_Parameter__r.Holding_cell_Central_Building2_Percent__c;
            Holding_cell_Central_Building3_Percent = Proj0.Building_Parameter__r.Holding_cell_Central_Building3_Percent__c;
            Holding_cell_Court_floors_Bldg1_Percent = Proj0.Building_Parameter__r.Holding_cell_Court_floors_Bldg1_Percent__c;
            Holding_cell_Court_floors_Bldg2_Percent = Proj0.Building_Parameter__r.Holding_cell_Court_floors_Bldg2_Percent__c;
            Holding_cell_Court_floors_Bldg3_Percent = Proj0.Building_Parameter__r.Holding_cell_Court_floors_Bldg3_Percent__c;
            Non_climate_controlled_Building1_Percent = Proj0.Building_Parameter__r.Non_climate_controlled_Building1_Percent__c;
            Non_climate_controlled_Building2_Percent = Proj0.Building_Parameter__r.Non_climate_controlled_Building2_Percent__c;
            Non_climate_controlled_Building3_Percent = Proj0.Building_Parameter__r.Non_climate_controlled_Building3_Percent__c;
            Climate_controlled_Building1_Percent = Proj0.Building_Parameter__r.Climate_controlled_Building1_Percent__c;
            Climate_controlled_Building2_Percent = Proj0.Building_Parameter__r.Climate_controlled_Building2_Percent__c;
            Climate_controlled_Building3_Percent = Proj0.Building_Parameter__r.Climate_controlled_Building3_Percent__c;         
            VA_Intake_Building1_Percent = Proj0.Building_Parameter__r.VA_Intake_Building1_Percent__c;
            VA_Intake_Building2_Percent = Proj0.Building_Parameter__r.VA_Intake_Building2_Percent__c;
            VA_Intake_Building3_Percent = Proj0.Building_Parameter__r.VA_Intake_Building3_Percent__c;
            VA_Exam_Suite_Building1_Percent = Proj0.Building_Parameter__r.VA_Exam_Suite_Building1_Percent__c;
            VA_Exam_Suite_Building2_Percent = Proj0.Building_Parameter__r.VA_Exam_Suite_Building2_Percent__c;
            VA_Exam_Suite_Building3_Percent = Proj0.Building_Parameter__r.VA_Exam_Suite_Building3_Percent__c;
            VA_Radiology_Building1_Percent = Proj0.Building_Parameter__r.VA_Radiology_Building1_Percent__c;
            VA_Radiology_Building2_Percent = Proj0.Building_Parameter__r.VA_Radiology_Building2_Percent__c;
            VA_Radiology_Building3_Percent = Proj0.Building_Parameter__r.VA_Radiology_Building3_Percent__c;
            VA_Ambulatory_Surgery_Building1_Percent = Proj0.Building_Parameter__r.VA_Ambulatory_Surgery_Building1_Percent__c;
            VA_Ambulatory_Surgery_Building2_Percent = Proj0.Building_Parameter__r.VA_Ambulatory_Surgery_Building2_Percent__c;
            VA_Ambulatory_Surgery_Building3_Percent = Proj0.Building_Parameter__r.VA_Ambulatory_Surgery_Building3_Percent__c;
            VA_Infusion_Building1_Percent = Proj0.Building_Parameter__r.VA_Infusion_Building1_Percent__c;
            VA_Infusion_Building2_Percent = Proj0.Building_Parameter__r.VA_Infusion_Building2_Percent__c;
            VA_Infusion_Building3_Percent = Proj0.Building_Parameter__r.VA_Infusion_Building3_Percent__c;
            VA_Pharmacy_Building1_Percent = Proj0.Building_Parameter__r.VA_Pharmacy_Building1_Percent__c;
            VA_Pharmacy_Building2_Percent = Proj0.Building_Parameter__r.VA_Pharmacy_Building2_Percent__c;
            VA_Pharmacy_Building3_Percent = Proj0.Building_Parameter__r.VA_Pharmacy_Building3_Percent__c;
            Data_Center_Building1_Percent = Proj0.Building_Parameter__r.Data_Center_Building1_Percent__c;
            Data_Center_Building2_Percent = Proj0.Building_Parameter__r.Data_Center_Building2_Percent__c;
            Data_Center_Building3_Percent = Proj0.Building_Parameter__r.Data_Center_Building3_Percent__c;           

            if (HPobj.Override_RSF__c == null) HPobj.Override_RSF__c = 0;
            
            
            Average_Story_Height = Proj0.Average_Story_Height__c;
            Plumbing_Fixtures = Proj0.Plumbing_Fixtures__c;
            
                    //Unfinpct
                    IF (string.valueof(Proj0.Building_Cost_Type__c) == 'Core/Shell only') {
                        HPobj.Unfinpct__c = 100;
                    }
                    ELSE IF (string.valueof(Proj0.Building_Cost_Type__c) == 'Core/Shell with TI')  {
                        IF (Proj0.Percentage_of_Tenant_Area_Unfinished__c > 0) {
                            HPobj.Unfinpct__c = Proj0.Percentage_of_Tenant_Area_Unfinished__c ; 
                        }
                        ELSE {
                            HPobj.Unfinpct__c = 0;
                        }                                   
                    }
                    ELSE {
                        HPobj.Unfinpct__c = 0;
                    }
                    //finpct
                    IF (string.valueof(Proj0.Building_Cost_Type__c) == 'Core/Shell only') {
                        HPobj.Finpct__c = 0;
                    }
                    ELSE IF (string.valueof(Proj0.Building_Cost_Type__c) == 'Core/Shell with TI')  {
                        IF (Proj0.Percentage_of_Tenant_Area_Unfinished__c > 0) {
                            HPobj.Finpct__c = 100 - (Proj0.Percentage_of_Tenant_Area_Unfinished__c ) ;
                        }
                        ELSE {
                            HPobj.Finpct__c = 100;
                        }
                    }   
                    ELSE {
                        HPobj.Finpct__c = 100;
                    }               
                
                //Number of Floors
                Number_of_Floors = Proj0.Above_Ground__c + Proj0.Below_Ground__c;
                HPobj.Number_of_Floors__c = Number_of_Floors;
                //Project USF 
                IF (Proj0.Gross_Area__c == True ) {
                    HPobj.Project_USF__c = (Proj0.Total_Area_Including_Parking__c + (400 * Proj0.Parking_Within_Building_Structure__c )) * Proj0.Building_Parameter__r.Efficiency__c;
                }
                ELSE IF (Proj0.Useable_Area__c == True){ 
                    HPobj.Project_USF__c = Proj0.Total_Area_Including_Parking__c + (400 * Proj0.Parking_Within_Building_Structure__c );
                }
                //Project GSF
                IF (Proj0.Gross_Area__c == True) {
                    HPobj.Project_GSF__c = Proj0.Total_Area_Including_Parking__c + (400 * Proj0.Parking_Within_Building_Structure__c );
                }
                ELSE IF (Proj0.Useable_Area__c == True) { 
                    HPobj.Project_GSF__c = (Proj0.Total_Area_Including_Parking__c + (400 * Proj0.Parking_Within_Building_Structure__c )) / Proj0.Building_Parameter__r.Efficiency__c;
                }
                //Project GF
                //system.debug('Number_of_Floors===='+ Number_of_Floors);
                if (Number_of_Floors == 1) {
                    HPobj.Project_GF__c = HPobj.Project_GSF__c;
                }
                ELSE {
                    HPobj.Project_GF__c = MATH.ROUND ( ( ( MATH.ROUND( HPobj.Project_GSF__c) / Number_of_Floors) * 1.15) ) ;
                }  
                
                HPobj.Average_floorplate_size__c = HPobj.Project_GSF__c / Number_of_Floors;
                If (Number_of_Floors == 1) {
                    HPobj.Main_entry_stairs__c = 0;
                }
                else if (Number_of_Floors == 2) {
                    if (HPobj.Average_floorplate_size__c > 30000) {
                        HPobj.Main_entry_stairs__c = 1 * 1; 
                    }
                    else {
                        HPobj.Main_entry_stairs__c = 1 * 0;
                    }
                }
                else {
                    if (HPobj.Average_floorplate_size__c > 30000) {
                        HPobj.Main_entry_stairs__c = 2 * 1; 
                    }
                    else {
                        HPobj.Main_entry_stairs__c = 2 * 0;
                    }
                }
                //Enclosed Parking
                HPobj.Enclosed_Parking__c = Proj0.Parking_Within_Building_Structure__c * 400;   
                        
                IF (Proj0.Gross_Area__c == True || Proj0.Useable_Area__c == True) {
                    //Common Area calculations
                    //Main Lobby
                    IF ( HPobj.Enclosed_Parking__c > HPobj.Project_USF__c ) {
                        HPobj.Main_Lobby__c = 0;
                    }
                    ELSE {                      
                        IF ( ( HPobj.Project_USF__c - HPobj.Enclosed_Parking__c) * (Proj0.Building_Parameter__r.Main_Lobby_Building2_Percent__c / 100) < 100 ) {
                            HPobj.Main_Lobby__c = 0;
                        }
                        ELSE IF ((HPobj.Project_USF__c - HPobj.Enclosed_Parking__c) * (Proj0.Building_Parameter__r.Main_Lobby_Building2_Percent__c / 100) < 299) {
                            HPobj.Main_Lobby__c = 200;
                        }
                        ELSE {
                            HPobj.Main_Lobby__c = MATH.ROUND((HPobj.Project_USF__c - HPobj.Enclosed_Parking__c) * (Proj0.Building_Parameter__r.Main_Lobby_Building2_Percent__c / 100) / 200) * 200 ;
                        }
                    }
                    //Atrium (Ground floor plan area)
                    IF (HPobj.Project_USF__c > 50000) {
                        HPobj.Atrium_Ground_floor_plan_area__c = (HPobj.Project_USF__c - HPobj.Enclosed_Parking__c ) * (Proj0.Building_Parameter__r.Atrium_Building2_Percent__c / 100); 
                    }
                    ELSE {
                        HPobj.Atrium_Ground_floor_plan_area__c = 0; 
                    }                   
                    //Restrooms
                    HPobj.Restrooms__c = MATH.ROUND(((HPobj.Project_GSF__c - HPobj.Enclosed_Parking__c) * Plumbing_Fixtures) / 1000 * 25);                  
                    //Ground floor circulation
                    System.debug('ERROR CHECK: ' + HPobj.Project_GSF__c);
                    HPobj.Ground_floor_circulation__c =  MATH.ROUND (HPobj.Project_GF__c * (Proj0.Building_Parameter__r.Ground_floor_circulation_Bldg2_Percent__c / 100) * ((HPobj.Project_GSF__c - HPobj.Enclosed_Parking__c) / HPobj.Project_GSF__c));

                    //Number of stops
                    if (Number_of_Floors == 1) {
                        HPobj.Number_of_stops__c = 0;
                    }   
                    Else {
                        HPobj.Number_of_stops__c = Number_of_Floors * Math.Max(MATH.ROUND(HPobj.Project_GSF__c * Proj0.Vertical_Conveyance_Elevators_Stops__c/10000),2);
                        //HPobj.Number_of_stops__c = HPobj.Project_GSF__c;
                    }

                    //system.debug('HPobj.Number_of_stops__c===='+HPobj.Number_of_stops__c);            
                    //Elevator lobbies
                    IF (HPobj.Project_GSF__c == 0) HPobj.Elevator_lobbies__c = 0;
                    
                    ELSE {
                        HPobj.Elevator_lobbies__c = HPobj.Number_of_stops__c * 72;
                    }
                    //Other circulation 
                    HPobj.Other_circulation__c =  MATH.ROUND ( (HPobj.Project_GSF__c - HPobj.Project_GF__c ) * (Proj0.Building_Parameter__r.Other_circulation_Building2_Percent__c / 100) * ((HPobj.Project_GSF__c - HPobj.Enclosed_Parking__c ) / HPobj.Project_GSF__c)); 
 
                    //Loading dock/Recycling/Trash 
                    IF ( HPobj.Project_GF__c * (Proj0.Building_Parameter__r.Loading_dock_Recycling_Trash_B2_Percent__c / 100) < 250 ) {
                        HPobj.Loading_dock_Recycling_Trash__c = 0;
                    }
                    ELSE IF ( HPobj.Project_GF__c * (Proj0.Building_Parameter__r.Loading_dock_Recycling_Trash_B2_Percent__c / 100) < 750) {
                        HPobj.Loading_dock_Recycling_Trash__c = 500;
                    }
                    ELSE {
                        HPobj.Loading_dock_Recycling_Trash__c = MATH.ROUND( HPobj.Project_GF__c * (Proj0.Building_Parameter__r.Loading_dock_Recycling_Trash_B2_Percent__c / 100) / 500) * 500;
                    }
                                                                
                    //Mechanical/Electrical/IT
                    HPobj.Mechanical_Electrical_IT__c = MATH.ROUND(( HPobj.Project_USF__c - HPobj.Enclosed_Parking__c) * (Proj0.Building_Parameter__r.Mechanical_Electrical_IT_Bldg2_Percent__c / 100));
                    
                    //Non-Rentable calculations
                    Decimal intStory_Ht;
                    Decimal intunit;
                    if ((ProjectRecordTypeName == 'Office' || ProjectRecordTypeName == 'Laboratory: Dry' || ProjectRecordTypeName == 'Laboratory: Wet') && Number_of_Floors == 10) {
                        intunit = 1.5;  
                    }
                    else {
                        intunit = Proj0.Building_Height_Parameter__r.Cladding_Thickness__c;
                    }   
                    
                    //need Cladding thickness lookup from RSF-GSF Analysis page for intunit
                    intStory_HT=Average_Story_Height;                   

                    HPobj.Based_on_damped_Cladding_Ratio__c = HPobj.Project_GSF__c * ( ( ((MATH.SQRT ((0.5 * HPobj.Project_GSF__c ) / Number_of_Floors )) * 6 * intStory_Ht) 
                                                                /  (HPobj.Project_GSF__c / Number_of_Floors) + 0.5 ) / 2 ) / intStory_Ht ;                                                          
                    //Structural Area                   
                    IF (HPobj.Project_GSF__c == 0) HPobj.Structural_Area__c = 0;
                    IF (HPobj.Project_GSF__c != 0) HPobj.Structural_Area__c = ( ( ( HPobj.Project_GSF__c / 900) + ((HPobj.Based_on_damped_Cladding_Ratio__c /30)/2 ) ) * 6 ) + (HPobj.Based_on_damped_Cladding_Ratio__c * intunit);
                    
                    
                    //Elevator shafts                   
                    IF (HPobj.Project_GSF__c == 0) HPobj.Elevator_shafts__c = 0;
                    IF (HPobj.Project_GSF__c != 0) HPobj.Elevator_shafts__c = HPobj.Number_of_stops__c * 40;
                    
                    If (Number_of_Floors ==1) HPobj.Total_Floor_openings__c = 0;
                    If (Number_of_Floors !=1) HPobj.Total_Floor_openings__c = (Number_of_Floors * (Math.MAX(2, MATH.CEIL(HPobj.Average_floorplate_size__c/100000))) + (HPobj.Main_entry_stairs__c + 1));
                    
                    //Stair shafts
                    IF ( HPobj.Project_GSF__c == 0 ) HPobj.Stair_shafts__c = 0;
                    IF ( HPobj.Project_GSF__c != 0 ) HPobj.Stair_shafts__c = HPobj.Total_Floor_openings__c * 24 * 14;
                    
                    //Other vertical penetrations 
                    HPobj.Other_vertical_penetrations__c = 2 * HPobj.Elevator_shafts__c ;
                }

                //Rentable Area and Useable Area calculations
                IF (Proj0.Gross_Area__c == True ) {
                    HPobj.Rentable_Area__c = HPobj.Project_GSF__c - ( HPobj.Structural_Area__c +  HPobj.Elevator_shafts__c +  HPobj.Stair_shafts__c +  HPobj.Other_vertical_penetrations__c );
                    HPobj.Useable_Area__c = HPobj.Rentable_Area__c - ( HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c + HPobj.Enclosed_Parking__c 
                                                                        + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c + HPobj.Other_circulation__c 
                                                                        + HPobj.Mechanical_Electrical_IT__c + HPobj.Loading_dock_Recycling_Trash__c);                        
                }
                ELSE IF (Proj0.Useable_Area__c == True) {       
                    HPobj.Rentable_Area__c = ( HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c + HPobj.Enclosed_Parking__c 
                                            + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c + HPobj.Other_circulation__c 
                                            + HPobj.Mechanical_Electrical_IT__c + HPobj.Loading_dock_Recycling_Trash__c) + HPobj.Project_USF__c;
                    HPobj.Useable_Area__c = HPobj.Project_USF__c - HPobj.Enclosed_Parking__c;                   
                }
                
                IF(Proj0.Project_Type__c == 'Repair & Alteration - Parametric Entry' || Proj0.Project_Type__c == 'Repair & Alteration - Work Item Detail'){
                    HPobj.Useable_Area__c  = Proj0.Affected_Tenant_Area_USF__c;
                }
                
                IF (Proj0.Gross_Area__c == True || Proj0.Useable_Area__c == True) {
                    //Unfinished Shell Area Use USF calculation
                        HPobj.Unfinished_Shell_Area_Use_USF__c =  HPobj.Useable_Area__c * (HPobj.Unfinpct__c / 100); 
                    //Building1 USF, Building2 USF & Building3 USF calculations
                    HPobj.Building1_USF__c = MATH.MIN (HPobj.Useable_Area__c, BuildingStep1Size * BuildingStep1Percent);
                    HPobj.Building2_USF__c = MATH.MAX( MATH.MIN (HPobj.Useable_Area__c - HPobj.Building1_USF__c, (BuildingStep2Size * BuildingStep2Percent)) , 0);
                    IF (HPobj.Useable_Area__c - HPobj.Building2_USF__c - HPobj.Building1_USF__c < 0 ) {
                        HPobj.Building3_USF__c = 0;
                    }
                    ELSE {
                        HPobj.Building3_USF__c = HPobj.Useable_Area__c - HPobj.Building2_USF__c - HPobj.Building1_USF__c ;
                    }        
                    //Workstations/open office Use USF calculation
                    HPobj.Workstations_open_office_Use_USF__c =  ( ((Workstations_open_off_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Workstations_open_off_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Workstations_open_off_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);  
                    //Closed offices Use USF calculation
                    HPobj.Closed_offices_Use_USF__c =  ( ((Closed_offices_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Closed_offices_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Closed_offices_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100); 
                    //8 - 20 person rooms Use USF calculation
                    HPobj.X8_20_person_rooms_Use_USF__c =  ( ((X8_20_person_rooms_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((X8_20_person_rooms_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((X8_20_person_rooms_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100); 
                    //20 or more person rooms Use USF calculation
                    HPobj.X20_or_more_person_rooms_Use_USF__c =  ( ((X20_or_more_person_rooms_Bldg1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((X20_or_more_person_rooms_Bldg2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((X20_or_more_person_rooms_Bldg3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100); 
                    //Teleconference calculations
                    HPobj.Teleconference_Use_USF__c =  ( ((Teleconference_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Teleconference_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Teleconference_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Auditorium (sloped floor) calculations
                    HPobj.Auditorium_sloped_floor_Use_USF__c =  ( ((Auditorium_sloped_floor_Bldg1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Auditorium_sloped_floor_Bldg2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Auditorium_sloped_floor_Bldg3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //General storage Use USF
                    HPobj.General_storage_Use_USF__c = ( ((General_storage_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((General_storage_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((General_storage_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Clinics/health units Use USF
                    HPobj.Clinics_health_units_Use_USF__c = ( ((Clinics_health_units_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Clinics_health_units_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Clinics_health_units_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Physical fitness Use USF
                    HPobj.Physical_fitness_Use_USF__c = ( ((Physical_fitness_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Physical_fitness_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Physical_fitness_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Child care
                    HPobj.Child_care_Use_USF__c = ( ((Child_care_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Child_care_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Child_care_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Libraries
                    HPobj.Libraries_Use_USF__c = ( ((Libraries_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Libraries_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Libraries_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //ADP (high density PC’s)
                    HPobj.ADP_high_density_PC_s_Use_USF__c = ( ((ADP_high_density_PC_s_Bldg1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((ADP_high_density_PC_s_Bldg2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((ADP_high_density_PC_s_Bldg3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //ADP (mainframe)
                    HPobj.ADP_mainframe_Use_USF__c = ( ((ADP_mainframe_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((ADP_mainframe_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((ADP_mainframe_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);                 
                    //Joint-use, retail
                    HPobj.Joint_use_retail_Use_USF__c   = ( ((Joint_use_retail_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Joint_use_retail_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Joint_use_retail_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);              
                    //Food service (cafeteria)
                    HPobj.Food_service_cafeteria_Use_USF__c = ( ((Food_service_cafeteria_Bldg1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Food_service_cafeteria_Bldg2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Food_service_cafeteria_Bldg3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Laboratory (Dry/electronic)
                    HPobj.Laboratory_Dry_electronic_Use_USF__c = ( ((Laboratory_Dry_elec_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Laboratory_Dry_elec_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Laboratory_Dry_elec_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Laboratory (wet/chemistry)
                    HPobj.Laboratory_Wet_chemistry_Use_USF__c = ( ((Laboratory_Wet_chem_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Laboratory_Wet_chem_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Laboratory_Wet_chem_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Locker / Shower room
                    HPobj.Locker_Shower_room_Use_USF__c = ( ((Locker_Shower_room_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Locker_Shower_room_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Locker_Shower_room_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Light industrial
                    HPobj.Light_industrial_Use_USF__c = ( ((Light_industrial_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Light_industrial_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Light_industrial_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Warehouse                                         
                    HPobj.Warehouse_Use_USF__c = ( ((Warehouse_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Warehouse_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Warehouse_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Courtroom – district Ceremonial
                    HPobj.Courtroom_district_Ceremonial_Use_USF__c = ( ((Courtroom_dist_Ceremonial_B1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Courtroom_dist_Ceremonial_B2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Courtroom_dist_Ceremonial_B3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Courtroom – district Standard
                    HPobj.Courtroom_district_Standard_Use_USF__c = ( ((Courtroom_dist_Standard_Bldg1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Courtroom_dist_Standard_Bldg2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Courtroom_dist_Standard_Bldg3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Courtroom – Bankruptcy
                    HPobj.Courtroom_Bankruptcy_Use_USF__c = ( ((Courtroom_Bankruptcy_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Courtroom_Bankruptcy_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Courtroom_Bankruptcy_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Courtroom – Magistrate                                                                
                    HPobj.Courtroom_Magistrate_Use_USF__c = ( ((Courtroom_Magistrate_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Courtroom_Magistrate_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Courtroom_Magistrate_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);  
                    //Grand Jury Room
                    HPobj.Grand_Jury_Room_Use_USF__c = ( ((Grand_Jury_Room_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Grand_Jury_Room_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Grand_Jury_Room_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100); 
                    //Judicial hearing
                    HPobj.Judicial_hearing_Use_USF__c = ( ((Judicial_hearing_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Judicial_hearing_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Judicial_hearing_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Judicial chambers
                    HPobj.Judicial_chambers_Use_USF__c = ( ((Judicial_chambers_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Judicial_chambers_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Judicial_chambers_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Enhanced office Use
                    HPobj.Enhanced_office_Use_USF__c = ( ((Enhanced_office_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Enhanced_office_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Enhanced_office_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //USMS Suite: Administration
                    HPobj.USMS_Suite_Administration_Use_USF__c = ( ((USMS_Suite_Admin_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((USMS_Suite_Admin_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((USMS_Suite_Admin_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //USMS Suite: Operations
                    HPobj.USMS_Suite_Operations_Use_USF__c = ( ((USMS_Suite_Operations_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((USMS_Suite_Operations_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((USMS_Suite_Operations_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Sally Port Use USF
                    HPobj.Sally_Port_Use_USF__c = ( ((Sally_Port_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Sally_Port_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Sally_Port_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Holding cell - Central
                    HPobj.Holding_cell_Central_Use_USF__c = ( ((Holding_cell_Central_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Holding_cell_Central_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Holding_cell_Central_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Holding cell - Court floors
                    HPobj.Holding_cell_Court_floors_Use_USF__c = ( ((Holding_cell_Court_floors_Bldg1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Holding_cell_Court_floors_Bldg2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Holding_cell_Court_floors_Bldg3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100); 
                    //Climate controlled for artifacts
                    HPobj.Climate_controlled_for_artifacts_Use_USF__c = ( ((Climate_controlled_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Climate_controlled_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Climate_controlled_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);    
                    //Non-climate controlled 
                    HPobj.Non_climate_controlled_Use_USF__c = ( ((Non_climate_controlled_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Non_climate_controlled_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Non_climate_controlled_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //VA-Intake
                    HPobj.VA_Intake_Use_USF__c = ( ((VA_Intake_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((VA_Intake_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((VA_Intake_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);                 
                    //VA-Exam Suite
                    HPobj.VA_Exam_Suite_Use_USF__c = ( ((VA_Exam_Suite_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((VA_Exam_Suite_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((VA_Exam_Suite_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);    
                    //VA-Radiology
                    HPobj.VA_Radiology_Use_USF__c = ( ((VA_Radiology_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((VA_Radiology_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((VA_Radiology_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);    
                    //VA-Ambulatory Surgery
                    HPobj.VA_Ambulatory_Surgery_Use_USF__c = ( ((VA_Ambulatory_Surgery_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((VA_Ambulatory_Surgery_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((VA_Ambulatory_Surgery_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);    
                    //VA-Infusion
                    HPobj.VA_Infusion_Use_USF__c = ( ((VA_Infusion_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((VA_Infusion_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((VA_Infusion_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);    
                    //VA-Pharmacy
                    HPobj.VA_Pharmacy_Use_USF__c = ( ((VA_Pharmacy_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((VA_Pharmacy_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((VA_Pharmacy_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);    
                    //Data Center
                    HPobj.Data_Center_Use_USF__c = ( ((Data_Center_Building1_Percent/100) *  HPobj.Building1_USF__c)
                                                                +((Data_Center_Building2_Percent/100) *  HPobj.Building2_USF__c)
                                                                +((Data_Center_Building3_Percent/100) *  HPobj.Building3_USF__c) ) * (HPobj.Finpct__c / 100);
                    //Mailroom/Secure Mailroom null handling
                    if(HPobj.Mailroom_Use_USF__c == null){
                        HPobj.Mailroom_Use_USF__c = 0;
                    }
                    if(HPobj.Secure_Mailroom_Use_USF__c == null){
                        HPobj.Secure_Mailroom_Use_USF__c = 0;
                    }
                }
                //Parking Garage calculation for Non-Rentable Area
                Else if (ProjectRecordTypeName == 'Parking Garage') {

                        //Number of Floors
                        Number_of_Floors = Proj0.At_and_above_grade__c + Proj0.Below_grade__c;
                        //Number of stops
                        if (Number_of_Floors == 1) {
                            HPobj.Number_of_stops__c = 0;
                        }   
                        Else {
                            HPobj.Number_of_stops__c = Number_of_Floors * Math.Max(Math.Ceil(Proj0.Parking_Garage_Gross_Area_SF__c * Proj0.Vertical_Conveyance_Elevators_Stops__c/10000),2);
                        }
                            HPobj.Average_floorplate_size__c = HPobj.Project_GSF__c / Number_of_Floors;
                            If (Number_of_Floors == 1) {
                                HPobj.Main_entry_stairs__c = 0;
                            }
                            else if (Number_of_Floors == 2) {
                                if (HPobj.Average_floorplate_size__c > 30000) {
                                    HPobj.Main_entry_stairs__c = 1 * 1; 
                                }
                                else {
                                    HPobj.Main_entry_stairs__c = 1 * 0;
                                }
                            }
                            else {
                                if (HPobj.Average_floorplate_size__c > 30000) {
                                    HPobj.Main_entry_stairs__c = 2 * 1; 
                                }
                                else {
                                    HPobj.Main_entry_stairs__c = 2 * 0;
                                }
                            }                       
                            //Non-Rentable calculations
                            Decimal intStory_Ht;
                            Decimal intunit;

                            intunit = Proj0.Building_Height_Parameter__r.Cladding_Thickness__c;
                            intStory_HT=Average_Story_Height;                   

                            HPobj.Based_on_damped_Cladding_Ratio__c = Proj0.Parking_Garage_Gross_Area_SF__c * ( ( ((MATH.SQRT ((0.5 * Proj0.Parking_Garage_Gross_Area_SF__c ) / Number_of_Floors )) * 6 * intStory_Ht) 
                                                                        /  (Proj0.Parking_Garage_Gross_Area_SF__c / Number_of_Floors) + 0.5 ) / 2 ) / intStory_Ht ;                                                                                         
                            //Structural Area                   
                            IF (Proj0.Parking_Garage_Gross_Area_SF__c == 0) HPobj.Structural_Area__c = 0;
                            IF (Proj0.Parking_Garage_Gross_Area_SF__c != 0) HPobj.Structural_Area__c = ( ( ( Proj0.Parking_Garage_Gross_Area_SF__c / 900) + ((HPobj.Based_on_damped_Cladding_Ratio__c /30)/2 ) ) * 6 ) + (HPobj.Based_on_damped_Cladding_Ratio__c * intunit);
                            
                            
                            //Elevator shafts                   
                            IF (Proj0.Parking_Garage_Gross_Area_SF__c == 0) HPobj.Elevator_shafts__c = 0;
                            IF (Proj0.Parking_Garage_Gross_Area_SF__c != 0) HPobj.Elevator_shafts__c = HPobj.Number_of_stops__c * 40;
                            
                            If (Number_of_Floors == 1) HPobj.Total_Floor_openings__c = 0;
                            If (Number_of_Floors != 1) HPobj.Total_Floor_openings__c = (Number_of_Floors * (Math.MAX(2, MATH.CEIL(HPobj.Average_floorplate_size__c/100000))) + (HPobj.Main_entry_stairs__c + 1));
                            
                            //Stair shafts
                            IF ( HPobj.Project_GSF__c == 0 ) HPobj.Stair_shafts__c = 0;
                            IF ( HPobj.Project_GSF__c != 0 ) HPobj.Stair_shafts__c = HPobj.Total_Floor_openings__c * 24 * 14;
                                              

                            //Other vertical penetrations 
                            HPobj.Other_vertical_penetrations__c = 2 * HPobj.Elevator_shafts__c ;
                            //Project GSF
                            HPobj.Project_GSF__c = Proj0.Parking_Garage_Gross_Area_SF__c;
                            //Total GSF
                            HPobj.Total_GSF__c = Proj0.Parking_Garage_Gross_Area_SF__c;
                            HPobj.Total_USF__c = 0;
                            
                }

                IF (Proj0.Gross_Area__c == True || Proj0.Useable_Area__c == True) {
                        HPobj.Total_USF__c = HPobj.Workstations_open_office_Use_USF__c + HPobj.Closed_offices_Use_USF__c + HPobj.Private_toilets_Use_USF__c
                                        + HPobj.X8_20_person_rooms_Use_USF__c + HPobj.X20_or_more_person_rooms_Use_USF__c
                                        + HPobj.Teleconference_Use_USF__c + HPobj.Auditorium_sloped_floor_Use_USF__c 
                                        + HPobj.Child_care_Use_USF__c + HPobj.Libraries_Use_USF__c + HPobj.ADP_high_density_PC_s_Use_USF__c
                                        + HPobj.Courtroom_district_Ceremonial_Use_USF__c + HPobj.Courtroom_district_Standard_Use_USF__c
                                        + HPobj.Courtroom_Bankruptcy_Use_USF__c + HPobj.Courtroom_Magistrate_Use_USF__c + HPobj.Grand_Jury_Room_Use_USF__c
                                        + HPobj.Judicial_hearing_Use_USF__c + HPobj.Judicial_chambers_Use_USF__c
                                        + HPobj.Holding_cell_Central_Use_USF__c + HPobj.Holding_cell_Court_floors_Use_USF__c
                                        + HPobj.Unfinished_Shell_Area_Use_USF__c + HPobj.General_storage_Use_USF__c + HPobj.High_density_storage_Use_USF__c
                                        + HPobj.Clinics_health_units_Use_USF__c + HPobj.Physical_fitness_Use_USF__c + HPobj.ADP_mainframe_Use_USF__c
                                        + HPobj.Joint_use_retail_Use_USF__c + HPobj.Food_service_cafeteria_Use_USF__c
                                        + HPobj.Climate_controlled_for_artifacts_Use_USF__c + HPobj.Non_climate_controlled_Use_USF__c
                                        + HPobj.Laboratory_Dry_electronic_Use_USF__c + HPobj.Laboratory_Wet_chemistry_Use_USF__c
                                        + HPobj.Firing_range_Use_USF__c + HPobj.Copy_Center_Use_USF__c + HPobj.Credit_Union_Use_USF__c
                                        + HPobj.Transaction_counter_space_Use_USF__c + HPobj.Kitchen_Break_room_Use_USF__c + HPobj.Locker_Shower_room_Use_USF__c
                                        + HPobj.Hardened_offices_suites_Use_USF__c 
                                        + HPobj.Secure_Work_Environment_SWE_Std_Use_USF__c + HPobj.Secure_Work_Environment_SWE_Enhd_UseUSF__c
                                        + HPobj.Secured_Storage_SCIF_Standard_Use_USF__c + HPobj.Secured_Storage_SCIF_Enhanced_Use_USF__c 
                                        + HPobj.Vault_Type_Storage_Use_USF__c + HPobj.Interview_Detention_Use_USF__c
                                        + HPobj.Non_Marshal_Holding_Cell_Single_Use_USF__c + HPobj.Non_Marshal_Holding_Cell_Double_Use_USF__c
                                        + HPobj.Enhanced_office_Use_USF__c + HPobj.USMS_Suite_Administration_Use_USF__c + HPobj.USMS_Suite_Operations_Use_USF__c
                                        + HPobj.Sally_Port_Use_USF__c + HPobj.Light_industrial_Use_USF__c + HPobj.Warehouse_Use_USF__c 
                                        + HPobj.VA_Intake_Use_USF__c + HPobj.VA_Exam_Suite_Use_USF__c + HPobj.VA_Radiology_Use_USF__c
                                        + HPobj.VA_Ambulatory_Surgery_Use_USF__c + HPobj.VA_Infusion_Use_USF__c + HPobj.VA_Pharmacy_Use_USF__c
                                        + HPobj.Data_Center_Use_USF__c + HPobj.Mailroom_Use_USF__c + HPobj.Secure_Mailroom_Use_USF__c;
                                        
                                                                                
                    HPobj.Total_RSF__c = (HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c + HPobj.Enclosed_Parking__c 
                                        + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c + HPobj.Other_circulation__c 
                                        + HPobj.Mechanical_Electrical_IT__c + HPobj.Loading_dock_Recycling_Trash__c) 
                                        + HPobj.Total_USF__c;
                    IF (Proj0.Gross_Area__c == True) {
                        HPobj.Total_GSF__c = (HPobj.Structural_Area__c + HPobj.Elevator_shafts__c + HPobj.Stair_shafts__c + HPobj.Other_vertical_penetrations__c)
                                            + HPobj.Total_RSF__c;
                    }
                    ELSE {
                        HPobj.Total_GSF__c = (HPobj.Structural_Area__c + HPobj.Elevator_shafts__c + HPobj.Stair_shafts__c + HPobj.Other_vertical_penetrations__c )
                                        + HPobj.Total_RSF__c;
                    }
                
                    HPobj.Total_RSF_w_o_parking__c = HPobj.Total_RSF__c - HPobj.Enclosed_Parking__c;
                    HPobj.Total_GSF_w_o_parking__c = HPobj.Total_GSF__c - HPobj.Enclosed_Parking__c;
                    HPobj.Conditioned_Core_Area__c = HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c 
                                                    + HPobj.Restrooms__c 
                                                    + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c 
                                                    + HPobj.Other_circulation__c + HPobj.Mechanical_Electrical_IT__c 
                                                    + HPobj.Loading_dock_Recycling_Trash__c
                                                    + HPobj.Stair_shafts__c 
                                                    + (HPobj.Atrium_Ground_floor_plan_area__c * HPobj.Atrium_upper_levels_phantom_floors__c );
                }   
                /*ELSE if (Proj0.Housing_Plan__c == True) {
                    
                    HPobj.Total_RSF__c = (HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c + HPobj.Enclosed_Parking__c 
                                        + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c + HPobj.Other_circulation__c 
                                        + HPobj.Mechanical_Electrical_IT__c + HPobj.Loading_dock_Recycling_Trash__c) 
                                        + HPobj.Total_USF__c;
                    HPobj.Total_GSF__c = (HPobj.Structural_Area__c + HPobj.Elevator_shafts__c + HPobj.Stair_shafts__c + HPobj.Other_vertical_penetrations__c )
                                        + HPobj.Total_RSF__c;                   
                    HPobj.Total_RSF_w_o_parking__c = HPobj.Total_RSF__c - HPobj.Enclosed_Parking__c;
                    HPobj.Total_GSF_w_o_parking__c = HPobj.Total_GSF__c - HPobj.Enclosed_Parking__c;
                    HPobj.Conditioned_Core_Area__c = HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c 
                                                    + HPobj.Restrooms__c 
                                                    + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c 
                                                    + HPobj.Other_circulation__c + HPobj.Mechanical_Electrical_IT__c 
                                                    + HPobj.Loading_dock_Recycling_Trash__c
                                                    + HPobj.Stair_shafts__c 
                                                    + (HPobj.Atrium_Ground_floor_plan_area__c * HPobj.Atrium_upper_levels_phantom_floors__c );                  
                    if (HPobj.Total_GSF__c < 2000) {
                        //HPobj.adderror('Total GSF (' + HPobj.Total_GSF__c.setscale(2) + ') cannot be less than 2000 sq ft.');
                    }                                                       
                }
                */
         }
    }
    
    public void insertHousingPlanSummary (List<NCMT_Housing_Plan__c> HPList, Id PIds, String ProjectRecordTypeName) {
        
        List <NCMT_Housing_Plan_Summary__c> lstDelete = [SELECT Id from NCMT_Housing_Plan_Summary__c where Project__c = :PIds limit 50000] ;
        IF (lstDelete.size() > 0) Delete lstDelete;
        
        Decimal Total_USF, Project_USF, Project_GSF, Project_GF, Affected_Tenant_Area_USF = 0.0; 
        Decimal Number_of_Floors, Above_Ground, Below_Ground, Number_of_stops, Building_Parameter_Efficiency, Average_Story_Height = 0.0;
        Decimal Vertical_Conveyance_Elevators_Stops, Parking_Within_Building_Structure, Building_Parameter_Main_Lobby_Building2_Percent = 0.0;
        Decimal Building_Parameter_Atrium_Building2_Percent, Building_Parameter_Ground_floor_circulation_Bldg2_Percent, Building_Parameter_Other_circulation_Building2_Percent = 0.0;
        Decimal Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent, Building_Parameter_Mechanical_Electrical_IT_Bldg2_Percent, Building_Height_Parameter_Cladding_Thickness, Plumbing_Fixtures = 0.0;
        Boolean blnDefault = true;
        String Project_Type;
        
        List <NCMT_Project__c> ProjList = [select Above_Ground__c, Below_Ground__c, Building_Parameter__r.Efficiency__c, Vertical_Conveyance_Elevators_Stops__c,
                                    Parking_Within_Building_Structure__c, Building_Parameter__r.Main_Lobby_Building2_Percent__c, Building_Parameter__r.Atrium_Building2_Percent__c,
                                    Building_Parameter__r.Ground_floor_circulation_Bldg2_Percent__c, Building_Parameter__r.Other_circulation_Building2_Percent__c,
                                    Building_Parameter__r.Loading_dock_Recycling_Trash_B2_Percent__c, Building_Parameter__r.Mechanical_Electrical_IT_Bldg2_Percent__c,
                                    Building_Height_Parameter__r.Cladding_Thickness__c, Plumbing_Fixtures__c, Average_Story_Height__c,
                                    Gross_Area__c, Useable_Area__c, Housing_Plan__c, Default_Housing_Plan__c, Affected_Tenant_Area_USF__c, Project_Type__c                                                                           
                                    from NCMT_Project__c where Id = :PIds ];        
                                    
        For (NCMT_Project__c ProjData : ProjList ){
            Above_Ground = (Decimal) ProjData.Above_Ground__c;
            Below_Ground = (Decimal) ProjData.Below_Ground__c;
            Project_Type = ProjData.Project_Type__c;
            Affected_Tenant_Area_USF = (Decimal) ProjData.Affected_Tenant_Area_USF__c;
            Building_Parameter_Efficiency = (Decimal) ProjData.Building_Parameter__r.Efficiency__c;
            Vertical_Conveyance_Elevators_Stops = (Decimal) ProjData.Vertical_Conveyance_Elevators_Stops__c;
            Parking_Within_Building_Structure = (Decimal) ProjData.Parking_Within_Building_Structure__c;
            Building_Parameter_Main_Lobby_Building2_Percent = (Decimal) ProjData.Building_Parameter__r.Main_Lobby_Building2_Percent__c;
            Building_Parameter_Atrium_Building2_Percent = (Decimal) ProjData.Building_Parameter__r.Atrium_Building2_Percent__c;
            Building_Parameter_Ground_floor_circulation_Bldg2_Percent = (Decimal) ProjData.Building_Parameter__r.Ground_floor_circulation_Bldg2_Percent__c;
            Building_Parameter_Other_circulation_Building2_Percent = (Decimal) ProjData.Building_Parameter__r.Other_circulation_Building2_Percent__c;
            Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent = (Decimal) ProjData.Building_Parameter__r.Loading_dock_Recycling_Trash_B2_Percent__c;
            Building_Parameter_Mechanical_Electrical_IT_Bldg2_Percent = (Decimal) ProjData.Building_Parameter__r.Mechanical_Electrical_IT_Bldg2_Percent__c;
            Building_Height_Parameter_Cladding_Thickness = (Decimal) ProjData.Building_Height_Parameter__r.Cladding_Thickness__c;
            Plumbing_Fixtures = (Decimal) ProjData.Plumbing_Fixtures__c;
            Average_Story_Height = (Decimal) ProjData.Average_Story_Height__c;
            if (ProjData.Gross_Area__c == true || ProjData.Useable_Area__c == true) {
                blnDefault = true;
            }
            else if (ProjData.Housing_Plan__c == true) {
                blnDefault = false;             
            }
        }
        
        Decimal  dblSpace1, dblSpace2, dblSpace3, dblSpace4, dblSpace5, dblSpace6, dblSpace7, dblSpace8, dblSpace9, dblSpace10 = 0.0;
        Decimal  dblSpace11, dblSpace12, dblSpace13, dblSpace14, dblSpace15, dblSpace16, dblSpace17, dblSpace18, dblSpace19, dblSpace20 = 0.0;
        Decimal  dblSpace21, dblSpace22, dblSpace23, dblSpace24, dblSpace25, dblSpace26, dblSpace27, dblSpace28, dblSpace29, dblSpace30 = 0.0;
        Decimal  dblSpace31, dblSpace32, dblSpace33, dblSpace34, dblSpace35, dblSpace36, dblSpace37, dblSpace38, dblSpace39, dblSpace40 = 0.0;
        Decimal  dblSpace41, dblSpace42, dblSpace43, dblSpace44, dblSpace45, dblSpace46, dblSpace47, dblSpace48, dblSpace49, dblSpace50, dblSpace51, dblSpace52 = 0.0;
        Decimal  dblSpace53, dblSpace54, dblSpace55, dblSpace56, dblSpace57, dblSpace58, dblSpace59, dblSpace60, dblSpace61, Enclosed_Parking = 0.0;        
        Decimal  Average_floorplate_size, Main_entry_stairs, Atrium_upper_levels_phantom_floors = 0.0;
        Decimal User_Defined_Spaces1_USF_for_DC, User_Defined_Spaces2_USF_for_DC, User_Defined_Spaces3_USF_for_DC = 0.0;
        Decimal User_Defined_Spaces1_Use_USF, User_Defined_Spaces2_Use_USF, User_Defined_Spaces3_Use_USF = 0.0;
        String User_Defined_Spaces1_Description = '';
        String User_Defined_Spaces2_Description = '';
        String User_Defined_Spaces3_Description = '';
        
        /*List<NCMT_Housing_Plan__c> ListUDHp = [Select User_Defined_Spaces1_Description__c, User_Defined_Spaces2_Description__c, User_Defined_Spaces3_Description__c
                                    From    NCMT_Housing_Plan__c
                                    Where   Project__c = :PIds];
        for (NCMT_Housing_Plan__c UDHp : ListUDHp) {
            if (UDHp.get('User_Defined_Spaces1_Description__c') <> null) {
                User_Defined_Spaces1_Description = User_Defined_Spaces1_Description + (String) UDHp.get('User_Defined_Spaces1_Description__c') + '; ';
            }
            if (UDHp.get('User_Defined_Spaces2_Description__c') <> null) {
                User_Defined_Spaces2_Description = User_Defined_Spaces2_Description + (String) UDHp.get('User_Defined_Spaces2_Description__c') + '; ';
            }
            if (UDHp.get('User_Defined_Spaces3_Description__c') <> null) {
                User_Defined_Spaces3_Description = User_Defined_Spaces3_Description + (String) UDHp.get('User_Defined_Spaces3_Description__c') + '; ';
            }
        }*/
        
        //system.debug('User_Defined_Spaces1_Description==='+ User_Defined_Spaces1_Description);
        //system.debug('User_Defined_Spaces2_Description==='+ User_Defined_Spaces2_Description);
        //system.debug('User_Defined_Spaces3_Description==='+ User_Defined_Spaces3_Description);                                    
        
        AggregateResult[] AgR = [Select 
                                    SUM(Unfinished_Shell_Area_Use_USF__c)  Space1, SUM(Workstations_open_office_Use_USF__c)  Space2, SUM(Closed_offices_Use_USF__c)  Space3, SUM(Private_toilets_Use_USF__c)  Space4, 
                                    SUM(X8_20_person_rooms_Use_USF__c)  Space5, SUM(X20_or_more_person_rooms_Use_USF__c)  Space6, SUM(Teleconference_Use_USF__c)  Space7, SUM(Auditorium_sloped_floor_Use_USF__c)  Space8, 
                                    SUM(General_storage_Use_USF__c)  Space9, SUM(High_density_storage_Use_USF__c)  Space10, SUM(Clinics_health_units_Use_USF__c)  Space11, SUM(Physical_fitness_Use_USF__c)  Space12, 
                                    SUM(Child_care_Use_USF__c)  Space13, SUM(Libraries_Use_USF__c)  Space14, SUM(ADP_mainframe_Use_USF__c)  Space15, SUM(ADP_high_density_PC_s_Use_USF__c)  Space16, 
                                    SUM(Joint_use_retail_Use_USF__c)  Space17, SUM(Food_service_cafeteria_Use_USF__c)  Space18, SUM(Climate_controlled_for_artifacts_Use_USF__c) Space19, SUM(Laboratory_Dry_electronic_Use_USF__c)  Space20, 
                                    SUM(Laboratory_Wet_chemistry_Use_USF__c)  Space21, SUM(Firing_range_Use_USF__c)  Space22, SUM(Copy_Center_Use_USF__c)  Space23, SUM(Credit_Union_Use_USF__c)  Space24, 
                                    SUM(Transaction_counter_space_Use_USF__c)  Space25, SUM(Kitchen_Break_room_Use_USF__c)  Space26, SUM(Locker_Shower_room_Use_USF__c)  Space27, SUM(Hardened_offices_suites_Use_USF__c)  Space28, 
                                    SUM(Secure_Work_Environment_SWE_Std_Use_USF__c)  Space29, SUM(Secure_Work_Environment_SWE_Enhd_UseUSF__c)  Space30, SUM(Secured_Storage_SCIF_Standard_Use_USF__c)  Space31, 
                                    SUM(Secured_Storage_SCIF_Enhanced_Use_USF__c)  Space32, SUM(Vault_Type_Storage_Use_USF__c)  Space33, SUM(Interview_Detention_Use_USF__c)  Space34, SUM(Non_Marshal_Holding_Cell_Single_Use_USF__c)  Space35, 
                                    SUM(Non_Marshal_Holding_Cell_Double_Use_USF__c)  Space36, SUM(Courtroom_district_Ceremonial_Use_USF__c)  Space37, SUM(Courtroom_district_Standard_Use_USF__c)  Space38, SUM(Courtroom_Bankruptcy_Use_USF__c)  Space39, 
                                    SUM(Courtroom_Magistrate_Use_USF__c)  Space40, SUM(Grand_Jury_Room_Use_USF__c)  Space41, SUM(Judicial_hearing_Use_USF__c)  Space42, SUM(Judicial_chambers_Use_USF__c)  Space43, 
                                    SUM(Enhanced_office_Use_USF__c)  Space44, SUM(USMS_Suite_Administration_Use_USF__c)  Space45, SUM(USMS_Suite_Operations_Use_USF__c)  Space46, SUM(Sally_Port_Use_USF__c)  Space47, 
                                    SUM(Holding_cell_Central_Use_USF__c)  Space48, SUM(Holding_cell_Court_floors_Use_USF__c)  Space49, SUM(Light_industrial_Use_USF__c)  Space50, SUM(Warehouse_Use_USF__c)  Space51,
                                    SUM(Non_climate_controlled_Use_USF__c) Space52, SUM(VA_Exam_Suite_Use_USF__c) Space53, SUM(VA_Ambulatory_Surgery_Use_USF__c) Space54, SUM(VA_Infusion_Use_USF__c) Space55,
                                    SUM(VA_Intake_Use_USF__c) Space56, SUM(VA_Pharmacy_Use_USF__c) Space57, SUM(VA_Radiology_Use_USF__c) Space58, SUM(Data_Center_Use_USF__c) Space59, SUM(Mailroom_Use_USF__c) Space60, SUM(Secure_Mailroom_Use_USF__c) Space61,
                                    SUM(Enclosed_Parking__c) Enclosed_Parking, SUM(Atrium_upper_levels_phantom_floors__c) Atrium_upper_levels_phantom_floors,
                                    SUM(User_Defined_Spaces1_USF_for_DC__c) User_Defined_Spaces1_USF_for_DC, SUM(User_Defined_Spaces2_USF_for_DC__c) User_Defined_Spaces2_USF_for_DC, SUM(User_Defined_Spaces3_USF_for_DC__c) User_Defined_Spaces3_USF_for_DC,
                                    SUM(User_Defined_Spaces1_Use_USF__c) User_Defined_Spaces1_Use_USF, SUM(User_Defined_Spaces2_Use_USF__c) User_Defined_Spaces2_Use_USF, SUM(User_Defined_Spaces3_Use_USF__c) User_Defined_Spaces3_Use_USF
                                From    NCMT_Housing_Plan__c
                                Where   Project__c = :PIds
                                Group by Project__c];
                                
        for (AggregateResult RowData : AgR) { 
            dblSpace1 = (Decimal) RowData.get('Space1');
            dblSpace2 = (Decimal) RowData.get('Space2');
            dblSpace3 = (Decimal) RowData.get('Space3');
            dblSpace4 = (Decimal) RowData.get('Space4');
            dblSpace5 = (Decimal) RowData.get('Space5');
            dblSpace6 = (Decimal) RowData.get('Space6');
            dblSpace7 = (Decimal) RowData.get('Space7');
            dblSpace8 = (Decimal) RowData.get('Space8');
            dblSpace9 = (Decimal) RowData.get('Space9');
            dblSpace10 = (Decimal) RowData.get('Space10');
            dblSpace11 = (Decimal) RowData.get('Space11');
            dblSpace12 = (Decimal) RowData.get('Space12');
            dblSpace13 = (Decimal) RowData.get('Space13');
            dblSpace14 = (Decimal) RowData.get('Space14');
            dblSpace15 = (Decimal) RowData.get('Space15');
            dblSpace16 = (Decimal) RowData.get('Space16');
            dblSpace17 = (Decimal) RowData.get('Space17');
            dblSpace18 = (Decimal) RowData.get('Space18');
            dblSpace19 = (Decimal) RowData.get('Space19');
            dblSpace20 = (Decimal) RowData.get('Space20');
            dblSpace21 = (Decimal) RowData.get('Space21');
            dblSpace22 = (Decimal) RowData.get('Space22');
            dblSpace23 = (Decimal) RowData.get('Space23');
            dblSpace24 = (Decimal) RowData.get('Space24');
            dblSpace25 = (Decimal) RowData.get('Space25');
            dblSpace26 = (Decimal) RowData.get('Space26');
            dblSpace27 = (Decimal) RowData.get('Space27');
            dblSpace28 = (Decimal) RowData.get('Space28');
            dblSpace29 = (Decimal) RowData.get('Space29');
            dblSpace30 = (Decimal) RowData.get('Space30');
            dblSpace31 = (Decimal) RowData.get('Space31');
            dblSpace32 = (Decimal) RowData.get('Space32');
            dblSpace33 = (Decimal) RowData.get('Space33');
            dblSpace34 = (Decimal) RowData.get('Space34');
            dblSpace35 = (Decimal) RowData.get('Space35');
            dblSpace36 = (Decimal) RowData.get('Space36');
            dblSpace37 = (Decimal) RowData.get('Space37');
            dblSpace38 = (Decimal) RowData.get('Space38');
            dblSpace39 = (Decimal) RowData.get('Space39');
            dblSpace40 = (Decimal) RowData.get('Space40');
            dblSpace41 = (Decimal) RowData.get('Space41');
            dblSpace42 = (Decimal) RowData.get('Space42');
            dblSpace43 = (Decimal) RowData.get('Space43');
            dblSpace44 = (Decimal) RowData.get('Space44');
            dblSpace45 = (Decimal) RowData.get('Space45');
            dblSpace46 = (Decimal) RowData.get('Space46');
            dblSpace47 = (Decimal) RowData.get('Space47');
            dblSpace48 = (Decimal) RowData.get('Space48');
            dblSpace49 = (Decimal) RowData.get('Space49');
            dblSpace50 = (Decimal) RowData.get('Space50');
            dblSpace51 = (Decimal) RowData.get('Space51');
            dblSpace52 = (Decimal) RowData.get('Space52');
            dblSpace53 = (Decimal) RowData.get('Space53');
            dblSpace54 = (Decimal) RowData.get('Space54');
            dblSpace55 = (Decimal) RowData.get('Space55');
            dblSpace56 = (Decimal) RowData.get('Space56');
            dblSpace57 = (Decimal) RowData.get('Space57');
            dblSpace58 = (Decimal) RowData.get('Space58');
            dblSpace59 = (Decimal) RowData.get('Space59');
            dblSpace60 = (Decimal) RowData.get('Space60');
            dblSpace61 = (Decimal) RowData.get('Space61');
            Enclosed_Parking = (Decimal) RowData.get('Enclosed_Parking');
            Atrium_upper_levels_phantom_floors = (Decimal) RowData.get('Atrium_upper_levels_phantom_floors');
            User_Defined_Spaces1_USF_for_DC = (Decimal) RowData.get('User_Defined_Spaces1_USF_for_DC');
            User_Defined_Spaces2_USF_for_DC = (Decimal) RowData.get('User_Defined_Spaces2_USF_for_DC');
            User_Defined_Spaces3_USF_for_DC = (Decimal) RowData.get('User_Defined_Spaces3_USF_for_DC');
            User_Defined_Spaces1_Use_USF = (Decimal) RowData.get('User_Defined_Spaces1_Use_USF');
            User_Defined_Spaces2_Use_USF = (Decimal) RowData.get('User_Defined_Spaces2_Use_USF');
            User_Defined_Spaces3_Use_USF = (Decimal) RowData.get('User_Defined_Spaces3_Use_USF');
        }       
        
        Total_USF = dblSpace1 + dblSpace2 + dblSpace3 + dblSpace4 + dblSpace5 + dblSpace6 + dblSpace7 + dblSpace8 + dblSpace9 + dblSpace10 + 
                        dblSpace11 + dblSpace12 + dblSpace13 + dblSpace14 + dblSpace15 + dblSpace16 + dblSpace17 + dblSpace18 + dblSpace19 + dblSpace20 +
                        dblSpace21 + dblSpace22 + dblSpace23 + dblSpace24 + dblSpace25 + dblSpace26 + dblSpace27 + dblSpace28 + dblSpace29 + dblSpace30 +
                        dblSpace31 + dblSpace32 + dblSpace33 + dblSpace34 + dblSpace35 + dblSpace36 + dblSpace37 + dblSpace38 + dblSpace39 + dblSpace40 +
                        dblSpace41 + dblSpace42 + dblSpace43 + dblSpace44 + dblSpace45 + dblSpace46 + dblSpace47 + dblSpace48 + dblSpace49 + dblSpace50 + dblSpace51 + dblSpace52 +
                        dblSpace53 + dblSpace54 + dblSpace55 + dblSpace56 + dblSpace57 + dblSpace58 + dblSpace59 + dblSpace60 + dblSpace61;
                                        
        Project_USF = Total_USF;

        Decimal Main_Lobby, Atrium_Ground_floor_plan_area, Restrooms, Ground_floor_circulation, Elevator_lobbies, Other_circulation, Loading_dock_Recycling_Trash, Mechanical_Electrical_IT = 0.0;
        Decimal Based_on_damped_Cladding_Ratio, Structural_Area, Elevator_shafts, Total_Floor_openings, Stair_shafts, Other_vertical_penetrations = 0.0;
        Decimal Total_RSF, Total_GSF, Total_RSF_w_o_parking, Total_GSF_w_o_parking, Conditioned_Core_Area = 0.0;
                        
        IF (Total_USF > 0) {
            //Number of Floors
            Number_of_Floors = Above_Ground + Below_Ground;
            //Project GSF
            Project_GSF = (Project_USF / Building_Parameter_Efficiency) +  Enclosed_Parking ;
            //Number of stops
            if (Number_of_Floors == 1) {
                Number_of_stops = 0;
            }   
            Else {
                Number_of_stops = Number_of_Floors * Math.Max(Math.ROUND(Project_GSF * Vertical_Conveyance_Elevators_Stops/10000),2);
                //Number_of_stops = Math.round(Project_GSF);
            }
            //Average FloorPlate Size                           
            Average_floorplate_size = Project_GSF / Number_of_Floors;
            //Main Entry Stairs
            If (Number_of_Floors == 1) {
                Main_entry_stairs = 0;
            }
            else if (Number_of_Floors == 2) {
                if (Average_floorplate_size > 30000) {
                    Main_entry_stairs = 1 * 1;  
                }
                else {
                    Main_entry_stairs = 1 * 0;
                }
            }
            else {
                if (Average_floorplate_size > 30000) {
                    Main_entry_stairs = 2 * 1;  
                }
                else {
                    Main_entry_stairs = 2 * 0;
                }
            }                           
            //Project GF Number_of_Floors
            IF ( Number_of_Floors == 1 ) Project_GF = Project_GSF;
            IF ( Number_of_Floors != 1 )Project_GF = MATH.ROUND ( ( ( MATH.ROUND( Project_GSF) / Number_of_Floors) * 1.15) ) ;
            
                            
            //Common Area calculations
            //Main Lobby
            if (Project_USF < 0 ) {
                Main_Lobby = 0;
            }
            else {
                IF ( ( Project_USF) * (Building_Parameter_Main_Lobby_Building2_Percent / 100) < 100 ) {
                    Main_Lobby = 0;
                }
                ELSE IF ((Project_USF) * (Building_Parameter_Main_Lobby_Building2_Percent / 100) < 299) {
                    Main_Lobby = 200;
                }
                ELSE {
                    Main_Lobby = MATH.ROUND((Project_USF) * (Building_Parameter_Main_Lobby_Building2_Percent / 100) / 200) * 200 ;
                }
            }
                            
            //Atrium (Ground floor plan area)
            IF (Project_USF > 50000) {
                //HPobj.Atrium_Ground_floor_plan_area__c = (HPobj.Project_USF__c - HPobj.Enclosed_Parking__c ) * (Proj0.Building_Parameter__r.Atrium_Building2_Percent__c / 100);
                Atrium_Ground_floor_plan_area = MATH.ROUND(Project_USF  * (Building_Parameter_Atrium_Building2_Percent / 100) );    
            }
            ELSE {
                Atrium_Ground_floor_plan_area = 0;  
            }                   
            //Restrooms
            Restrooms =  MATH.ROUND( (Project_GSF   * Plumbing_Fixtures) / 1000 * 25 );                     
            //Ground floor circulation
            Ground_floor_circulation =  MATH.ROUND (Project_GF * (Building_Parameter_Ground_floor_circulation_Bldg2_Percent / 100) * ((Project_GSF - Enclosed_Parking) / Project_GSF));

            //Elevator lobbies
            IF (Project_GSF == 0) Elevator_lobbies = 0;
            IF (Project_GSF != 0) Elevator_lobbies = Number_of_stops * 72;
            
            //Other circulation 
            Other_circulation =  MATH.ROUND ( (Project_GSF - Project_GF ) * (Building_Parameter_Other_circulation_Building2_Percent / 100) * ((Project_GSF - Enclosed_Parking ) / Project_GSF)); 
            //Loading dock/Recycling/Trash 
            IF ( Project_GF * (Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent / 100) < 250 ) {
                Loading_dock_Recycling_Trash = 0;
            }
            ELSE IF ( Project_GF * (Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent / 100) < 750) {
                Loading_dock_Recycling_Trash = 500;
            }
            ELSE {
                Loading_dock_Recycling_Trash = MATH.ROUND( Project_GF * (Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent / 100) / 500) * 500;
            }                                                                       
            //Mechanical/Electrical/IT
            Mechanical_Electrical_IT = MATH.ROUND(Total_USF * (Building_Parameter_Mechanical_Electrical_IT_Bldg2_Percent / 100) );
            //Non-Rentable calculations
            Decimal intStory_Ht, intunit;

            if ((ProjectRecordTypeName == 'Office' || ProjectRecordTypeName == 'Laboratory: Dry' || ProjectRecordTypeName == 'Laboratory: Wet') && Number_of_Floors == 10) {
                intunit = 1.5;  
            }
            else {
                intunit = Building_Height_Parameter_Cladding_Thickness;
            }
            intStory_HT = Average_Story_Height;                 
            
            Based_on_damped_Cladding_Ratio = Project_GSF * ( ( ((MATH.SQRT ((0.5 * Project_GSF ) / Number_of_Floors )) * 6 * intStory_Ht) 
                                                        /  (Project_GSF / Number_of_Floors) + 0.5 ) / 2 ) / intStory_Ht ;                                                                                       
            //Structural Area                   
            IF (Project_GSF == 0) {
                Structural_Area = 0;
            }
            ELSE {
                Structural_Area = ( ( ( Project_GSF / 900) + ((Based_on_damped_Cladding_Ratio /30)/2 ) ) * 6 ) + (Based_on_damped_Cladding_Ratio * intunit);
            }                           
            //Elevator shafts Number_of_Floors                  
            IF (Project_GSF == 0) {
                Elevator_shafts = 0;
            }
            ELSE {
                Elevator_shafts = Number_of_stops * 40;
            }                           
            //Total Floor Openings
            If (Number_of_Floors == 1) {
                Total_Floor_openings = 0;
            }
            else {
                Total_Floor_openings = (Number_of_Floors * (Math.MAX(2, MATH.CEIL(Average_floorplate_size/100000))) + (Main_entry_stairs + 1));
            }
            //Stair shafts
            IF ( Project_GSF == 0 ) {
                Stair_shafts = 0;
            }
            ELSE {
                Stair_shafts = Total_Floor_openings * 24 * 14;
            }                           
            //Other vertical penetrations 
            Other_vertical_penetrations = 6 * Elevator_shafts ;
        }   
        //}
        //catch (Exception e) 
        //  HPobj.adderror('All Use USF fields must have values. If fields are null, enter zero.');
        //

        Total_RSF = (Main_Lobby + Atrium_Ground_floor_plan_area + Enclosed_Parking 
                            + Restrooms + Ground_floor_circulation + Elevator_lobbies + Other_circulation 
                            + Mechanical_Electrical_IT + Loading_dock_Recycling_Trash) 
                            + Total_USF;
        Total_GSF = (Structural_Area + Elevator_shafts + Stair_shafts + Other_vertical_penetrations )
                            + Total_RSF;                    
        Total_RSF_w_o_parking = Total_RSF - Enclosed_Parking;
        Total_GSF_w_o_parking = Total_GSF - Enclosed_Parking;
        Conditioned_Core_Area = Main_Lobby + Atrium_Ground_floor_plan_area 
                                        + Restrooms 
                                        + Ground_floor_circulation + Elevator_lobbies 
                                        + Other_circulation + Mechanical_Electrical_IT 
                                        + Loading_dock_Recycling_Trash
                                        + Stair_shafts 
                                        + (Atrium_Ground_floor_plan_area * Atrium_upper_levels_phantom_floors );                    
        //if (HPobj.Total_GSF__c < 2000) {
            //HPobj.adderror('Total GSF (' + HPobj.Total_GSF__c.setscale(2) + ') cannot be less than 2000 sq ft.');
        //}                    

        //insert Housing Plan Summary record
        
        String strRecordTypeID;
        if (blnDefault == true) {
            strRecordTypeID = Schema.SObjectType.NCMT_Housing_Plan_Summary__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
            if(Project_Type == 'Repair & Alteration - Parametric Entry' || Project_Type == 'Repair & Alteration - Work Item Detail'){
                dblSpace1= Total_USF - Affected_Tenant_Area_USF;
            }
        }
        else {
            strRecordTypeID = Schema.SObjectType.NCMT_Housing_Plan_Summary__c.getRecordTypeInfosByName().get('User Defined').getRecordTypeId();
        }
        
        List<NCMT_Housing_Plan_Summary__c> objHousingPlanSummaryRecords = New List<NCMT_Housing_Plan_Summary__c>();

        objHousingPlanSummaryRecords.Add(new NCMT_Housing_Plan_Summary__c(
            Project__c = PIds,
            RecordTypeID = strRecordTypeID,
            Unfinished_Shell_Area_Use_USF__c = dblSpace1, 
            Workstations_open_office_Use_USF__c = dblSpace2, 
            Closed_offices_Use_USF__c = dblSpace3, 
            Private_toilets_Use_USF__c = dblSpace4, 
            X8_20_person_rooms_Use_USF__c = dblSpace5, 
            X20_or_more_person_rooms_Use_USF__c = dblSpace6, 
            Teleconference_Use_USF__c = dblSpace7, 
            Auditorium_sloped_floor_Use_USF__c = dblSpace8, 
            General_storage_Use_USF__c = dblSpace9, 
            High_density_storage_Use_USF__c = dblSpace10, 
            Clinics_health_units_Use_USF__c = dblSpace11, 
            Physical_fitness_Use_USF__c = dblSpace12, 
            Child_care_Use_USF__c = dblSpace13, 
            Libraries_Use_USF__c = dblSpace14, 
            ADP_mainframe_Use_USF__c = dblSpace15, 
            ADP_high_density_PC_s_Use_USF__c = dblSpace16, 
            Joint_use_retail_Use_USF__c = dblSpace17, 
            Food_service_cafeteria_Use_USF__c = dblSpace18, 
            Climate_controlled_for_artifacts_Use_USF__c = dblSpace19, 
            Laboratory_Dry_electronic_Use_USF__c = dblSpace20, 
            Laboratory_Wet_chemistry_Use_USF__c = dblSpace21, 
            Firing_range_Use_USF__c = dblSpace22, 
            Copy_Center_Use_USF__c = dblSpace23, 
            Credit_Union_Use_USF__c = dblSpace24, 
            Transaction_counter_space_Use_USF__c = dblSpace25, 
            Kitchen_Break_room_Use_USF__c = dblSpace26, 
            Locker_Shower_room_Use_USF__c = dblSpace27, 
            Hardened_offices_suites_Use_USF__c = dblSpace28, 
            Secure_Work_Environment_SWE_Std_Use_USF__c = dblSpace29, 
            Secure_Work_Environment_SWE_Enhd_UseUSF__c = dblSpace30, 
            Secured_Storage_SCIF_Standard_Use_USF__c = dblSpace31, 
            Secured_Storage_SCIF_Enhanced_Use_USF__c = dblSpace32, 
            Vault_Type_Storage_Use_USF__c = dblSpace33, 
            Interview_Detention_Use_USF__c = dblSpace34, 
            Non_Marshal_Holding_Cell_Single_Use_USF__c = dblSpace35, 
            Non_Marshal_Holding_Cell_Double_Use_USF__c = dblSpace36, 
            Courtroom_district_Ceremonial_Use_USF__c = dblSpace37, 
            Courtroom_district_Standard_Use_USF__c = dblSpace38, 
            Courtroom_Bankruptcy_Use_USF__c = dblSpace39, 
            Courtroom_Magistrate_Use_USF__c = dblSpace40, 
            Grand_Jury_Room_Use_USF__c = dblSpace41, 
            Judicial_hearing_Use_USF__c = dblSpace42, 
            Judicial_chambers_Use_USF__c = dblSpace43, 
            Enhanced_office_Use_USF__c = dblSpace44, 
            USMS_Suite_Administration_Use_USF__c = dblSpace45, 
            USMS_Suite_Operations_Use_USF__c = dblSpace46, 
            Sally_Port_Use_USF__c = dblSpace47, 
            Holding_cell_Central_Use_USF__c = dblSpace48, 
            Holding_cell_Court_floors_Use_USF__c = dblSpace49, 
            Light_industrial_Use_USF__c = dblSpace50, 
            Warehouse_Use_USF__c = dblSpace51,
            Non_climate_controlled_Use_USF__c = dblSpace52,
            User_Defined_Spaces1_USF_for_DC__c = User_Defined_Spaces1_USF_for_DC,
            User_Defined_Spaces2_USF_for_DC__c = User_Defined_Spaces2_USF_for_DC,
            User_Defined_Spaces3_USF_for_DC__c = User_Defined_Spaces3_USF_for_DC,
            User_Defined_Spaces1_Use_USF__c = User_Defined_Spaces1_Use_USF,
            User_Defined_Spaces2_Use_USF__c = User_Defined_Spaces2_Use_USF,
            User_Defined_Spaces3_Use_USF__c = User_Defined_Spaces3_Use_USF, 
            User_Defined_Spaces1_Description__c = '',
            User_Defined_Spaces2_Description__c = '',
            User_Defined_Spaces3_Description__c = '',
            VA_Exam_Suite_Use_USF__c = dblSpace53, 
            VA_Ambulatory_Surgery_Use_USF__c = dblSpace54, 
            VA_Infusion_Use_USF__c = dblSpace55,
            VA_Intake_Use_USF__c = dblSpace56, 
            VA_Pharmacy_Use_USF__c = dblSpace57, 
            VA_Radiology_Use_USF__c = dblSpace58, 
            Data_Center_Use_USF__c = dblSpace59,
            Mailroom_Use_USF__c = dblSpace60,
            Secure_Mailroom_Use_USF__c = dblSpace61,
            Number_of_Floors__c = Number_of_Floors,
            Total_USF__c = Total_USF,
            Project_USF__c = Project_USF,
            Project_GSF__c = Project_GSF,
            Number_of_stops__c = Number_of_stops,
            Average_floorplate_size__c = Average_floorplate_size,
            Main_entry_stairs__c = Main_entry_stairs,
            Project_GF__c = Project_GF,
            Based_on_damped_Cladding_Ratio__c = Based_on_damped_Cladding_Ratio,
            Total_Floor_openings__c = Total_Floor_openings,
            Main_Lobby__c = Main_Lobby,
            Default_Main_Lobby__c = Main_Lobby,
            Atrium_Ground_floor_plan_area__c = Atrium_Ground_floor_plan_area,
            Default_Atrium_Ground_floor_plan_area__c = Atrium_Ground_floor_plan_area,
            Enclosed_Parking__c = Enclosed_Parking,
            Default_Enclosed_Parking__c = Enclosed_Parking,
            Restrooms__c = Restrooms,
            Default_Restrooms__c = Restrooms,
            Ground_floor_circulation__c = Ground_floor_circulation,
            Default_Ground_floor_circulation__c = Ground_floor_circulation,
            Elevator_lobbies__c = Elevator_lobbies,
            Other_circulation__c = Other_circulation,
            Default_Other_circulation__c = Other_circulation,
            Mechanical_Electrical_IT__c = Mechanical_Electrical_IT,
            Default_Mechanical_Electrical_IT__c = Mechanical_Electrical_IT,
            Loading_dock_Recycling_Trash__c = Loading_dock_Recycling_Trash,
            Default_Loading_dock_Recycling_Trash__c = Loading_dock_Recycling_Trash,
            Structural_Area__c = Structural_Area,
            Elevator_shafts__c = Elevator_shafts,
            Stair_shafts__c = Stair_shafts,
            Other_vertical_penetrations__c = Other_vertical_penetrations,
            Total_RSF__c = Total_RSF,
            Total_GSF__c = Total_GSF,
            Total_RSF_w_o_parking__c = Total_RSF_w_o_parking,
            Total_GSF_w_o_parking__c = Total_GSF_w_o_parking,
            Atrium_upper_levels_phantom_floors__c = Atrium_upper_levels_phantom_floors,
            Conditioned_Core_Area__c = Conditioned_Core_Area            
        ));
        
        insert objHousingPlanSummaryRecords;        
    }

    public void UpdateProjectData(List<NCMT_Housing_Plan_Summary__c> HPList, Id PIds) {
        System.debug('UpdateProjectData INVOKED');
        Integer intGSF_10000;   
        Integer intGSF_25000;
        Integer intGSF_50000;
        Integer intGSF_100000;
        Integer intGSF_150000;
        Integer intGSF_250000;
        Integer intGSF_500000;
        Integer intGSF_GT_500000;       
        Decimal ConstructionMonth=0;
        Decimal Total_GSF, Enclosed_Parking, Total_RSF, Total_USF, Unfinished_Shell_Area_Use_USF, Number_of_stops, Override_RSF;

        for(NCMT_Housing_Plan_Summary__c HPobj : HPList) {
            Total_GSF = HPobj.Total_GSF__c;
            Enclosed_Parking = HPobj.Enclosed_Parking__c;
            Total_RSF = HPobj.Total_RSF__c; 
            Total_USF = HPobj.Total_USF__c;
            Unfinished_Shell_Area_Use_USF = HPobj.Unfinished_Shell_Area_Use_USF__c;
            Number_of_stops = HPobj.Number_of_stops__c;
            Override_RSF = HPobj.Override_RSF__c;
            System.debug('Override_RSF==='+Override_RSF);
            System.debug('Total_GSF==='+Total_GSF);
            System.debug('Total_USF==='+Total_USF);
        }   

        string strNCMTRecordType = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId();
        //update Total GSF, Start or End Construction
         IF (Total_GSF > 0) {
            
            
            NCMT_Project__c Proj = [SELECT Total_GSF__c, RecordTypeID, 
                                    Building_Height_Parameter__r.GSF_10000__c, Building_Height_Parameter__r.GSF_25000__c, Building_Height_Parameter__r.GSF_50000__c, 
                                    Building_Height_Parameter__r.GSF_100000__c, Building_Height_Parameter__r.GSF_150000__c, Building_Height_Parameter__r.GSF_250000__c, 
                                    Building_Height_Parameter__r.GSF_500000__c, Building_Height_Parameter__r.GSF_GT_500000__c,
                                    Building_Height_Parameter__r.USF_10000__c, Building_Height_Parameter__r.USF_25000__c, Building_Height_Parameter__r.USF_50000__c, 
                                    Building_Height_Parameter__r.USF_100000__c, Building_Height_Parameter__r.USF_150000__c, Building_Height_Parameter__r.USF_250000__c, 
                                    Building_Height_Parameter__r.USF_500000__c, Building_Height_Parameter__r.USF_GT_500000__c,Building_Cost_Type__c,
                                    Start_Construction__c, End_Construction__c,
                                    Enclosed_parking_PRSF__c, Gross_Area_w_o_parking_BGSF__c, Gross_Area_w_o_parking_Efficiency__c,
                                    Rentable_Area_w_o_parking_RSF__c, Rentable_Area_w_o_parking_Efficiency__c,
                                    Useable_Area_Total_USF__c, Useable_Area_Total_Efficiency__c,
                                    Useable_Area_Built_out_USF__c, Useable_Area_Unfinished_USF__c, Number_of_Stops__c, Total_Area_Including_Parking__c,Gross_Area_Including_Parking__c,
                                    Project_Type__c, Building_Type__c
                                    FROM NCMT_Project__c WHERE Id = :PIds ];
                
            IF (Proj.RecordTypeID <> strNCMTRecordType ) {
                if(Proj.Building_Cost_Type__c == 'Core/Shell with TI' || Proj.Building_Cost_Type__c =='Core/Shell only'){
                    intGSF_10000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_10000__c);
                    intGSF_25000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_25000__c );
                    intGSF_50000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_50000__c );
                    intGSF_100000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_100000__c );
                    intGSF_150000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_150000__c );
                    intGSF_250000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_250000__c );
                    intGSF_500000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_500000__c );
                    intGSF_GT_500000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_GT_500000__c );
                }else{
                    intGSF_10000 = Integer.valueOf(Proj.Building_Height_Parameter__r.USF_10000__c);
                    intGSF_25000 = Integer.valueOf(Proj.Building_Height_Parameter__r.USF_25000__c );
                    intGSF_50000 = Integer.valueOf(Proj.Building_Height_Parameter__r.USF_50000__c );
                    intGSF_100000 = Integer.valueOf(Proj.Building_Height_Parameter__r.USF_100000__c );
                    intGSF_150000 = Integer.valueOf(Proj.Building_Height_Parameter__r.USF_150000__c );
                    intGSF_250000 = Integer.valueOf(Proj.Building_Height_Parameter__r.USF_250000__c );
                    intGSF_500000 = Integer.valueOf(Proj.Building_Height_Parameter__r.USF_500000__c );
                    intGSF_GT_500000 = Integer.valueOf(Proj.Building_Height_Parameter__r.USF_GT_500000__c );
                }
                if(Proj.Building_Type__c != 'Parking Garage'){
                    Proj.Total_GSF__c = Total_GSF;
                }else{
                    Proj.Total_GSF__c = Proj.Gross_Area_Including_Parking__c;
                    Total_GSF = Proj.Total_GSF__c;
                }

                Proj.Enclosed_parking_PRSF__c = Enclosed_Parking;
                Proj.Gross_Area_w_o_parking_BGSF__c = Total_GSF - Enclosed_Parking;
                Proj.Number_of_Stops__c = Number_of_stops;
                IF (Total_GSF - Enclosed_Parking == 0) {
                    Proj.Gross_Area_w_o_parking_Efficiency__c = 0;
                }
                ELSE {
                    Proj.Gross_Area_w_o_parking_Efficiency__c = 1.000;
                }
                if (Override_RSF == 0) {
                    Proj.Rentable_Area_w_o_parking_RSF__c = Total_RSF - Enclosed_Parking;
                }
                else {
                    Proj.Rentable_Area_w_o_parking_RSF__c = Override_RSF - Enclosed_Parking;
                }
                if (Override_RSF == 0) {
                    IF (Total_RSF - Enclosed_Parking == 0) {
                        Proj.Rentable_Area_w_o_parking_Efficiency__c = 0;
                    }
                    ELSE {
                        system.debug('Total_RSF==='+ Total_RSF);
                        system.debug('Enclosed_Parking==='+ Enclosed_Parking);
                        system.debug('Total_GSF==='+ Total_GSF);
                        Proj.Rentable_Area_w_o_parking_Efficiency__c = (Total_RSF - Enclosed_Parking) / (Total_GSF - Enclosed_Parking);
                    }
                }   
                else {
                    IF (Override_RSF - Enclosed_Parking == 0) {
                        Proj.Rentable_Area_w_o_parking_Efficiency__c = 0;
                    }
                    ELSE {
                        Proj.Rentable_Area_w_o_parking_Efficiency__c = (Override_RSF - Enclosed_Parking) / (Total_GSF - Enclosed_Parking);
                    }
                }
                Proj.Useable_Area_Total_USF__c = Total_USF;
                IF (Total_USF == 0 || Total_GSF == 0) {
                    Proj.Useable_Area_Total_Efficiency__c = 0;
                }
                ELSE {
                    Proj.Useable_Area_Total_Efficiency__c = Total_USF / (Total_GSF - Enclosed_Parking);
                }               
                Proj.Useable_Area_Built_out_USF__c = Total_USF - Unfinished_Shell_Area_Use_USF;
                Proj.Useable_Area_Unfinished_USF__c = Unfinished_Shell_Area_Use_USF;
                
                //update End or Start Construction Building Type other than Parking Garage
               IF (Total_GSF < 10000 ) {
                   ConstructionMonth = intGSF_10000;
               } 
               ELSE IF (Total_GSF >= 10000 && Total_GSF < 25000) {
                   ConstructionMonth = intGSF_25000;
               }    
               ELSE IF (Total_GSF >= 25000 && Total_GSF < 50000) {
                   ConstructionMonth = intGSF_50000;
               } 
               ELSE IF (Total_GSF >= 50000 && Total_GSF < 100000) {
                   ConstructionMonth = intGSF_100000;
               } 
               ELSE IF (Total_GSF >= 100000 && Total_GSF < 150000) {
                   ConstructionMonth = intGSF_150000;
               } 
               ELSE IF (Total_GSF >= 150000 && Total_GSF < 250000) {
                   ConstructionMonth = intGSF_250000;
               } 
               ELSE IF (Total_GSF >= 250000 && Total_GSF < 500000) {
                   ConstructionMonth = intGSF_500000;
               } 
               ELSE IF (Total_GSF >= 500000 ) {
                   ConstructionMonth = intGSF_GT_500000;
               } 
               //If (ConstructionMonth <> 0 && ConstructionMonth <> NULL) {
               //    ConstructionMonth = (ConstructionMonth * 30.2)/2;
               //}
               IF (Proj.Start_Construction__c <> null) {
                    Proj.End_Construction__c = Proj.Start_Construction__c.addMonths(Integer.valueOf(ConstructionMonth)) ;   
               }
               ELSE IF (Proj.End_Construction__c <> null) {
                    Proj.Start_Construction__c = Proj.End_Construction__c.addMonths(Integer.valueOf(ConstructionMonth * - 1));
               } 
                update Proj;                    
            }
         }
    }

    public void UpdateConditionedCoreAreaData(List<NCMT_Housing_Plan_Summary__c> HPList, Id PIds, String ProjectRecordTypeName) {
        for(NCMT_Housing_Plan_Summary__c HPobj : HPList) {
            if (HPobj.Atrium_upper_levels_phantom_floors__c == null) {
                HPobj.Atrium_upper_levels_phantom_floors__c = 0;
            }
            //Conditioned Core Area
            HPobj.Conditioned_Core_Area__c  = HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c  
                                    + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c
                                    + HPobj.Other_circulation__c + HPobj.Mechanical_Electrical_IT__c 
                                    + HPobj.Loading_dock_Recycling_Trash__c + HPobj.Stair_shafts__c 
                                    + (HPobj.Atrium_Ground_floor_plan_area__c * HPobj.Atrium_upper_levels_phantom_floors__c );
                        
        }
    }
    
    public void UpdateCommonAreaData(List<NCMT_Housing_Plan_Summary__c> HPList, Id PIds, String ProjectRecordTypeName) {
        
        for(NCMT_Housing_Plan_Summary__c HPobj : HPList) {
            HPobj.Override_RSF__c = 0;
            
            if (HPobj.Main_Lobby__c == null) HPobj.Main_Lobby__c = 0;
            
            if (HPobj.Atrium_Ground_floor_plan_area__c == null) HPobj.Atrium_Ground_floor_plan_area__c = 0;
            
            if (HPobj.Enclosed_Parking__c == null) HPobj.Enclosed_Parking__c = 0;
            
            if (HPobj.Restrooms__c == null) HPobj.Restrooms__c = 0;
            
            if (HPobj.Ground_floor_circulation__c == null) HPobj.Ground_floor_circulation__c = 0;
            
            if (HPobj.Elevator_lobbies__c == null) HPobj.Elevator_lobbies__c = 0;
            
            if (HPobj.Other_circulation__c == null) HPobj.Other_circulation__c = 0;
            
            if (HPobj.Mechanical_Electrical_IT__c == null) HPobj.Mechanical_Electrical_IT__c = 0;
            
            if (HPobj.Loading_dock_Recycling_Trash__c == null) HPobj.Loading_dock_Recycling_Trash__c = 0;
                      
            if (HPobj.Atrium_upper_levels_phantom_floors__c == null) HPobj.Atrium_upper_levels_phantom_floors__c = 0;
        

            //Conditioned Core Area
            HPobj.Conditioned_Core_Area__c  = HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c  
                                    + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c
                                    + HPobj.Other_circulation__c + HPobj.Mechanical_Electrical_IT__c 
                                    + HPobj.Loading_dock_Recycling_Trash__c + HPobj.Stair_shafts__c 
                                    + (HPobj.Atrium_Ground_floor_plan_area__c * HPobj.Atrium_upper_levels_phantom_floors__c );
            HPobj.Total_RSF__c = (HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c + HPobj.Enclosed_Parking__c 
                        + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c + HPobj.Other_circulation__c 
                        + HPobj.Mechanical_Electrical_IT__c + HPobj.Loading_dock_Recycling_Trash__c) 
                        + HPobj.Total_USF__c;                       
            HPobj.Total_GSF__c = (HPobj.Structural_Area__c + HPobj.Elevator_shafts__c + HPobj.Stair_shafts__c + HPobj.Other_vertical_penetrations__c )
                                + HPobj.Total_RSF__c;                   
            HPobj.Total_RSF_w_o_parking__c = HPobj.Total_RSF__c - HPobj.Enclosed_Parking__c;
            HPobj.Total_GSF_w_o_parking__c = HPobj.Total_GSF__c - HPobj.Enclosed_Parking__c;  
            
         } 
        //Update Project for Project Area - Calculated section fields
        UpdateProjectData(HPList, PIds);            
    }
    
    public void UpdateOverrideRSFData(List<NCMT_Housing_Plan_Summary__c> HPList, Id PIds, String ProjectRecordTypeName) {
        System.debug('OverrideRSFData INVOKED');
        Decimal Total_USF, Project_USF, Project_GSF, Project_GF= 0.0; 
        
        Decimal Number_of_Floors, Above_Ground, Below_Ground, Building_Parameter_Efficiency, Average_Story_Height = 0.0;
        Decimal Vertical_Conveyance_Elevators_Stops, Parking_Within_Building_Structure, Building_Parameter_Main_Lobby_Building2_Percent = 0.0;
        Decimal Building_Parameter_Atrium_Building2_Percent, Building_Parameter_Ground_floor_circulation_Bldg2_Percent, Building_Parameter_Other_circulation_Building2_Percent = 0.0;
        Decimal Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent, Building_Parameter_Mechanical_Electrical_IT_Bldg2_Percent, Building_Height_Parameter_Cladding_Thickness, Plumbing_Fixtures = 0.0;
        
        List <NCMT_Project__c> ProjList = [select Above_Ground__c, Below_Ground__c, Building_Parameter__r.Efficiency__c, Vertical_Conveyance_Elevators_Stops__c,
                                    Parking_Within_Building_Structure__c, Building_Parameter__r.Main_Lobby_Building2_Percent__c, Building_Parameter__r.Atrium_Building2_Percent__c,
                                    Building_Parameter__r.Ground_floor_circulation_Bldg2_Percent__c, Building_Parameter__r.Other_circulation_Building2_Percent__c,
                                    Building_Parameter__r.Loading_dock_Recycling_Trash_B2_Percent__c, Building_Parameter__r.Mechanical_Electrical_IT_Bldg2_Percent__c,
                                    Building_Height_Parameter__r.Cladding_Thickness__c, Plumbing_Fixtures__c, Average_Story_Height__c
                                    from NCMT_Project__c where Id = :PIds ];
                                    
        For (NCMT_Project__c ProjData : ProjList ){
            Above_Ground = (Decimal) ProjData.Above_Ground__c;
            Below_Ground = (Decimal) ProjData.Below_Ground__c;
            Building_Parameter_Efficiency = (Decimal) ProjData.Building_Parameter__r.Efficiency__c;
            Vertical_Conveyance_Elevators_Stops = (Decimal) ProjData.Vertical_Conveyance_Elevators_Stops__c;
            Parking_Within_Building_Structure = (Decimal) ProjData.Parking_Within_Building_Structure__c;
            Building_Parameter_Main_Lobby_Building2_Percent = (Decimal) ProjData.Building_Parameter__r.Main_Lobby_Building2_Percent__c;
            Building_Parameter_Atrium_Building2_Percent = (Decimal) ProjData.Building_Parameter__r.Atrium_Building2_Percent__c;
            Building_Parameter_Ground_floor_circulation_Bldg2_Percent = (Decimal) ProjData.Building_Parameter__r.Ground_floor_circulation_Bldg2_Percent__c;
            Building_Parameter_Other_circulation_Building2_Percent = (Decimal) ProjData.Building_Parameter__r.Other_circulation_Building2_Percent__c;
            Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent = (Decimal) ProjData.Building_Parameter__r.Loading_dock_Recycling_Trash_B2_Percent__c;
            Building_Parameter_Mechanical_Electrical_IT_Bldg2_Percent = (Decimal) ProjData.Building_Parameter__r.Mechanical_Electrical_IT_Bldg2_Percent__c;
            Building_Height_Parameter_Cladding_Thickness = (Decimal) ProjData.Building_Height_Parameter__r.Cladding_Thickness__c;
            Plumbing_Fixtures = (Decimal) ProjData.Plumbing_Fixtures__c;
            Average_Story_Height = (Decimal) ProjData.Average_Story_Height__c;
            if (Plumbing_Fixtures == null) Plumbing_Fixtures = 0;
            if (Average_Story_Height == null) Average_Story_Height = 0;
        }

        Decimal Total_RSF, Override_RSF, Override_RSF_Diff = 0.0;
                                
        for(NCMT_Housing_Plan_Summary__c HPobj : HPList) {
            Total_RSF = HPobj.Total_RSF__c;
            Override_RSF = HPobj.Override_RSF__c;
            Total_USF = HPobj.Total_USF__c;
            //Based_on_damped_Cladding_Ratio = HPobj.Based_on_damped_Cladding_Ratio__c;
            //system.debug('Total_USF * 1.1==='+ Total_USF * 1.1);
            //system.debug('Total_USF * 1.4==='+  Total_USF * 1.4);
            
            //Reset - Common Area calculations
            //Main Lobby
            if (HPobj.Project_USF__c < 0 ) {
                HPobj.Main_Lobby__c = 0;
            }
            else {
                IF ( ( HPobj.Project_USF__c) * (Building_Parameter_Main_Lobby_Building2_Percent / 100) < 100 ) {
                    HPobj.Main_Lobby__c = 0;
                }
                ELSE IF ((HPobj.Project_USF__c) * (Building_Parameter_Main_Lobby_Building2_Percent / 100) < 299) {
                    HPobj.Main_Lobby__c = 200;
                }
                ELSE {
                    HPobj.Main_Lobby__c = MATH.ROUND((HPobj.Project_USF__c) * (Building_Parameter_Main_Lobby_Building2_Percent / 100) / 200) * 200 ;
                }
            }
                            
            //Atrium (Ground floor plan area)
            IF (HPobj.Project_USF__c > 50000) {
                //HPobj.Atrium_Ground_floor_plan_area__c = (HPobj.Project_USF__c - HPobj.Enclosed_Parking__c ) * (Proj0.Building_Parameter__r.Atrium_Building2_Percent__c / 100);
                HPobj.Atrium_Ground_floor_plan_area__c = MATH.ROUND(HPobj.Project_USF__c  * (Building_Parameter_Atrium_Building2_Percent / 100) );  
            }
            ELSE {
                HPobj.Atrium_Ground_floor_plan_area__c = 0; 
            }                   
            //Restrooms
            HPobj.Restrooms__c =  MATH.ROUND( (HPobj.Project_GSF__c * Plumbing_Fixtures) / 1000 * 25 );                     
            //Ground floor circulation
            HPobj.Ground_floor_circulation__c =  MATH.ROUND (HPobj.Project_GF__c * (Building_Parameter_Ground_floor_circulation_Bldg2_Percent / 100) * ((HPobj.Project_GSF__c - HPobj.Enclosed_Parking__c) / HPobj.Project_GSF__c));

            //Elevator lobbies
            IF (HPobj.Project_GSF__c == 0) {
                HPobj.Elevator_lobbies__c  = 0;
            }
            ELSE {
                HPobj.Elevator_lobbies__c  = HPobj.Number_of_stops__c * 72;
            }
            //Other circulation 
            HPobj.Other_circulation__c  =  MATH.ROUND ( (HPobj.Project_GSF__c - HPobj.Project_GF__c ) * (Building_Parameter_Other_circulation_Building2_Percent / 100) * ((HPobj.Project_GSF__c - HPobj.Enclosed_Parking__c ) / HPobj.Project_GSF__c)); 
            //Loading dock/Recycling/Trash 
            IF ( HPobj.Project_GF__c * (Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent / 100) < 250 ) {
                HPobj.Loading_dock_Recycling_Trash__c = 0;
            }
            ELSE IF ( HPobj.Project_GF__c * (Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent / 100) < 750) {
                HPobj.Loading_dock_Recycling_Trash__c  = 500;
            }
            ELSE {
                HPobj.Loading_dock_Recycling_Trash__c  = MATH.ROUND( HPobj.Project_GF__c * (Building_Parameter_Loading_dock_Recycling_Trash_B2_Percent / 100) / 500) * 500;
            }                                                                       
            //Mechanical/Electrical/IT
            HPobj.Mechanical_Electrical_IT__c  = MATH.ROUND(HPobj.Total_USF__c * (Building_Parameter_Mechanical_Electrical_IT_Bldg2_Percent / 100) );
            
            if (Override_RSF == 0) {
                //Conditioned Core Area
                HPobj.Conditioned_Core_Area__c  = HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c  
                                        + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c
                                        + HPobj.Other_circulation__c + HPobj.Mechanical_Electrical_IT__c 
                                        + HPobj.Loading_dock_Recycling_Trash__c + HPobj.Stair_shafts__c 
                                        + (HPobj.Atrium_Ground_floor_plan_area__c * HPobj.Atrium_upper_levels_phantom_floors__c );
                HPobj.Total_RSF__c = (HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c + HPobj.Enclosed_Parking__c 
                            + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c + HPobj.Other_circulation__c 
                            + HPobj.Mechanical_Electrical_IT__c + HPobj.Loading_dock_Recycling_Trash__c) 
                            + HPobj.Total_USF__c;                       
                HPobj.Total_GSF__c = (HPobj.Structural_Area__c + HPobj.Elevator_shafts__c + HPobj.Stair_shafts__c + HPobj.Other_vertical_penetrations__c )
                                    + HPobj.Total_RSF__c;                   
                HPobj.Total_RSF_w_o_parking__c = HPobj.Total_RSF__c - HPobj.Enclosed_Parking__c;
                HPobj.Total_GSF_w_o_parking__c = HPobj.Total_GSF__c - HPobj.Enclosed_Parking__c;  
                
                //Total_GSF = HPobj.Total_GSF__c;                                               
            }
            else if (Override_RSF < Total_USF * 1.1 || Override_RSF > Total_USF * 1.4 ) {
                System.debug('Do nothing');
                //HPobj.adderror('Override RSF must be between ' + MATH.ROUND((Total_USF * 1.1) ) + ' and ' + MATH.ROUND((Total_USF * 1.4) + 1) );
                //HPobj.adderror('Override RSF must be ' + HPobj.Override_RSF_Range__c.replace('B','b'));
            }
            else if (Override_RSF >= Total_USF * 1.1 && Override_RSF <= Total_USF * 1.4) {
                Override_RSF_Diff = Override_RSF - Total_RSF;
                System.debug('Override_RSF_Diff = ' + Override_RSF_Diff);
                
                if (Override_RSF_Diff > 0) {
                    
                    Override_RSF_Diff = MATH.MAX(Override_RSF_Diff,0);
                    
                    Decimal Atrium_add1, Add2_Total, Override_RSF_Diff2, Main_Lobby_add2, Add3_Total, Override_RSF_Diff3, Ground_Floor_add2, Add4_Total, Override_RSF_Diff4, Other_circulation_add2, Add5_Total = 0.0;
                    Decimal Override_RSF_Diff5, Loading_Dock_add2, Add6_Total, Override_RSF_Diff6, Mech_add2, Add7_Total, Override_RSF_Diff7, Restrooms_add2, Add8_Total = 0.0;
                    Decimal Override_RSF_Diff8, Elevator_Lobbies_add2, Add9_Total, Override_RSF_Diff9, Ground_Floor_add3, Add10_Total, Override_RSF_Diff10, Atrium_add2, Add11_Total = 0.0;
                    Decimal Override_RSF_Diff11, Other_circulation_add3, Add12_Total = 0.0;
        
                    Atrium_add1 = MATH.MIN(Override_RSF_Diff, HPobj.Atrium_Ground_floor_plan_area__c);
                    Add2_Total = Atrium_add1;
                    
                    Override_RSF_Diff2 = Override_RSF_Diff - Add2_Total;
                    Main_Lobby_add2 = MATH.MIN (Override_RSF_Diff2, (HPobj.Main_Lobby__c * 2 ) - HPobj.Main_Lobby__c);
                    Add3_Total = Main_Lobby_add2;
                    
                    Override_RSF_Diff3 = Override_RSF_Diff2 - Add3_Total;
                    Ground_Floor_add2 = MATH.MIN(Override_RSF_Diff3, HPobj.Ground_floor_circulation__c * 2);
                    Add4_Total = Ground_Floor_add2;
                    
                    Override_RSF_Diff4 = Override_RSF_Diff3 - Add4_Total;
                    Other_circulation_add2 = MATH.MIN(Override_RSF_Diff4, (HPobj.Other_circulation__c * 1.2) - HPobj.Other_circulation__c);
                    Add5_Total = Other_circulation_add2;
                    
                    Override_RSF_Diff5 = Override_RSF_Diff4 - Add5_Total;
                    Loading_Dock_add2 = MATH.MIN(Override_RSF_Diff5, 1000);
                    Add6_Total = Loading_Dock_add2;
                    
                    Override_RSF_Diff6 = Override_RSF_Diff5 - Add6_Total;
                    Mech_add2 = MATH.MIN(Override_RSF_Diff6, 0);
                    Add7_Total = Mech_add2;
                    
                    Override_RSF_Diff7 = Override_RSF_Diff6 - Add7_Total;
                    Restrooms_add2 = MATH.MIN(Override_RSF_Diff7, HPobj.Restrooms__c * 0.5);
                    Add8_Total = Restrooms_add2;
                    
                    Override_RSF_Diff8 = Override_RSF_Diff7 - Add8_Total;
                    Elevator_Lobbies_add2 = MATH.MIN(Override_RSF_Diff8, HPobj.Elevator_lobbies__c * 0.75);
                    Add9_Total = Elevator_Lobbies_add2;
                    
                    Override_RSF_Diff9 = Override_RSF_Diff8 - Add9_Total;
                    Ground_Floor_add3 = MATH.MIN(Override_RSF_Diff9, (HPobj.Ground_floor_circulation__c + Ground_Floor_add2) * 1.2);
                    Add10_Total = Ground_Floor_add3;
                                    
                    Override_RSF_Diff10 = Override_RSF_Diff9 - Add10_Total;
                    Atrium_add2 = MATH.MIN(Override_RSF_Diff10, HPobj.Atrium_Ground_floor_plan_area__c);
                    Add11_Total = Atrium_add2;
                    
                    Override_RSF_Diff11 = Override_RSF_Diff10 - Add11_Total;
                    Other_circulation_add3 = MATH.MIN(Override_RSF_Diff11, (HPobj.Other_circulation__c + Other_circulation_add2) * 0.75);
                    Add12_Total = Other_circulation_add3;
                    
                    HPobj.Main_Lobby__c = HPobj.Main_Lobby__c + Main_Lobby_add2;
                    HPobj.Atrium_Ground_floor_plan_area__c = HPobj.Atrium_Ground_floor_plan_area__c + Atrium_add1;
                    HPobj.Restrooms__c = HPobj.Restrooms__c + Restrooms_add2;
                    HPobj.Ground_floor_circulation__c = HPobj.Ground_floor_circulation__c + Ground_Floor_add2 + Ground_Floor_add3;
                    HPobj.Elevator_lobbies__c = HPobj.Elevator_lobbies__c + Elevator_Lobbies_add2;
                    HPobj.Other_circulation__c = HPobj.Other_circulation__c + Other_circulation_add2 + Other_circulation_add3;
                    HPobj.Mechanical_Electrical_IT__c = HPobj.Mechanical_Electrical_IT__c + Mech_add2;
                    HPobj.Loading_dock_Recycling_Trash__c = HPobj.Loading_dock_Recycling_Trash__c + Loading_Dock_add2;
                    
                    HPobj.Conditioned_Core_Area__c  = HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c  
                                        + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c
                                        + HPobj.Other_circulation__c + HPobj.Mechanical_Electrical_IT__c 
                                        + HPobj.Loading_dock_Recycling_Trash__c + HPobj.Stair_shafts__c 
                                        + (HPobj.Atrium_Ground_floor_plan_area__c * HPobj.Atrium_upper_levels_phantom_floors__c );      
                    //Commented out in Release 4.4. Total GSF should not be recalculated
                    //Uncommented because this value is used in various calculations and is causing test failures...
                    //HPobj.Total_GSF__c = (HPobj.Structural_Area__c + HPobj.Elevator_shafts__c + HPobj.Stair_shafts__c + HPobj.Other_vertical_penetrations__c )
                    //                + HPobj.Override_RSF__c;   
                    System.debug('HPobj.Total_GSF__c 2======= ' + HPobj.Total_GSF__c);     
                    HPobj.Total_RSF_w_o_parking__c = HPobj.Override_RSF__c - HPobj.Enclosed_Parking__c;
                    HPobj.Total_GSF_w_o_parking__c = HPobj.Total_GSF__c - HPobj.Enclosed_Parking__c;    
                    
                    //Total_GSF = HPobj.Total_GSF__c;                           
                }
                else if (Override_RSF_Diff < 0) {
                    System.debug('Override_RSF_Diff less than 0');
                    Override_RSF_Diff = MATH.MAX(0, -Override_RSF_Diff);
                    System.debug('Override_RSF_Diff==='+Override_RSF_Diff);
                    
                    Decimal Mech_add1, Add2_Total, Override_RSF_Diff2, Atrium_add2, Add3_Total, Override_RSF_Diff3, Other_Circulation_add2, Add4_Total, Override_RSF_Diff4, Elevator_Lobbies_add2, Add5_Total = 0.0;
                    Decimal Override_RSF_Diff5, Mech_add2, Add6_Total, Override_RSF_Diff6, Ground_floor_circulation2, Add7_Total, Override_RSF_Diff7, Restrooms_add2, Add8_Total = 0.0;
                    Decimal Override_RSF_Diff8, Other_Circulation_add3, Add9_Total, Override_RSF_Diff9, Main_Lobby_add2, Add10_Total, Override_RSF_Diff10, Mech_add3, Add11_Total = 0.0;
                    
                    Mech_add1 = MATH.MIN(Override_RSF_Diff, HPobj.Mechanical_Electrical_IT__c * 0.5);
                    Add2_Total = Mech_add1;
                    
                    Override_RSF_Diff2 = Override_RSF_Diff - Add2_Total;
                    Atrium_add2 = MATH.MIN (Override_RSF_Diff, HPobj.Atrium_Ground_floor_plan_area__c);
                    Add3_Total = Atrium_add2;
                    
                    Override_RSF_Diff3 = Override_RSF_Diff2 - Add3_Total;
                    Other_Circulation_add2 = MATH.MIN(Override_RSF_Diff3, HPobj.Other_circulation__c * 0.3);
                    Add4_Total = Other_Circulation_add2;
                    
                    Override_RSF_Diff4 = Override_RSF_Diff3 - Add4_Total;
                    Elevator_Lobbies_add2 = MATH.MIN(Override_RSF_Diff4, HPobj.Elevator_lobbies__c * 0.5);
                    Add5_Total = Elevator_Lobbies_add2;
                    
                    Override_RSF_Diff5 = Override_RSF_Diff4 - Add5_Total;
                    Mech_add2 = MATH.MIN(Override_RSF_Diff5,  HPobj.Mechanical_Electrical_IT__c * 0.2);
                    Add6_Total = Mech_add2;
                    
                    Override_RSF_Diff6 = Override_RSF_Diff5 - Add6_Total;
                    Ground_floor_circulation2 = MATH.MIN(Override_RSF_Diff6, HPobj.Ground_floor_circulation__c * 0.5);
                    Add7_Total = Ground_floor_circulation2;
                    
                    Override_RSF_Diff7 = Override_RSF_Diff6 - Add7_Total;
                    Restrooms_add2 = MATH.MIN(Override_RSF_Diff7, HPobj.Restrooms__c * 0.3);
                    Add8_Total = Restrooms_add2;
                    
                    Override_RSF_Diff8 = Override_RSF_Diff7 - Add8_Total;
                    Other_Circulation_add3 = MATH.MIN(Override_RSF_Diff8, HPobj.Other_circulation__c * 0.5);
                    Add9_Total = Other_Circulation_add3;
                    
                    Override_RSF_Diff9 = Override_RSF_Diff8 - Add9_Total;
                    Main_Lobby_add2 = MATH.MIN(Override_RSF_Diff9, HPobj.Main_Lobby__c * 0.7);
                    Add10_Total = Main_Lobby_add2;
                    
                    Override_RSF_Diff10 = Override_RSF_Diff9 - Add10_Total;
                    Mech_add3 = MATH.MIN(Override_RSF_Diff10, HPobj.Mechanical_Electrical_IT__c * 0.2);
                    Add11_Total = Mech_add3;
                    
                    HPobj.Main_Lobby__c = HPobj.Main_Lobby__c - Main_Lobby_add2;
                    HPobj.Atrium_Ground_floor_plan_area__c = HPobj.Atrium_Ground_floor_plan_area__c - Atrium_add2;
                    HPobj.Restrooms__c = HPobj.Restrooms__c - Restrooms_add2;
                    HPobj.Ground_floor_circulation__c = HPobj.Ground_floor_circulation__c - Ground_floor_circulation2;
                    HPobj.Elevator_lobbies__c = HPobj.Elevator_lobbies__c - Elevator_Lobbies_add2;
                    HPobj.Other_circulation__c = HPobj.Other_circulation__c - (Other_circulation_add2 + Other_circulation_add3);
                    HPobj.Mechanical_Electrical_IT__c = HPobj.Mechanical_Electrical_IT__c - (Mech_add2 + Mech_add1 + Mech_add3);
                    HPobj.Loading_dock_Recycling_Trash__c = HPobj.Loading_dock_Recycling_Trash__c;
                    
                    HPobj.Conditioned_Core_Area__c  = HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c  
                                        + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c
                                        + HPobj.Other_circulation__c + HPobj.Mechanical_Electrical_IT__c 
                                        + HPobj.Loading_dock_Recycling_Trash__c + HPobj.Stair_shafts__c 
                                        + (HPobj.Atrium_Ground_floor_plan_area__c * HPobj.Atrium_upper_levels_phantom_floors__c );      
                    //Commented out in Release 4.4. Total GSF should not be recalculated
                    //Uncommented because this value is used in various calculations and is causing test failures...
                    //HPobj.Total_GSF__c = (HPobj.Structural_Area__c + HPobj.Elevator_shafts__c + HPobj.Stair_shafts__c + HPobj.Other_vertical_penetrations__c ) 
                    //                            + HPObj.Override_RSF__c;       
                    System.debug('HPobj.Total_GSF__c 2======= ' + HPobj.Total_GSF__c);                                       
                    HPobj.Total_RSF_w_o_parking__c = HPobj.Override_RSF__c - HPobj.Enclosed_Parking__c;
                    HPobj.Total_GSF_w_o_parking__c = HPobj.Total_GSF__c - HPobj.Enclosed_Parking__c; 
                    
                    //Total_GSF = HPobj.Total_GSF__c;
                }
            }
        } 
        //Update Project for Project Area - Calculated section fields
        if (!Test.isRunningTest()) UpdateProjectData(HPList, PIds);    
    }
}