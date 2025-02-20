public with sharing class NCMT_UpdateHousingPlan {
    public static boolean checkFirstRun= true;
    public void UpdateHousingPlanData(List<NCMT_Housing_Plan__c> HPList, Id PIds) {
        
        Map<Id, NCMT_Project__c> Proj = new Map <Id, NCMT_Project__c> ( [select Gross_Area__c, Building_Type__c, Useable_Area__c, Housing_Plan__c, Total_Area_Including_Parking__c, Parking_Within_Building_Structure__c,
                                    Percentage_of_Tenant_Area_Unfinished__c, Building_Cost_Type__c,
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
                                    Parking_Garage_Gross_Area_SF__c, At_and_above_grade__c, Below_grade__c, Building_Height_Parameter__r.Cladding_Thickness__c                                                                  
                                                from NCMT_Project__c where Id = :PIds]);
        
        //get BuildingCode 
        string BCode;
        //get Total Area Including Parking
        Decimal Total_Area_Including_Parking,BuildingStep1Size,BuildingStep2Size,BuildingStep1Percent,BuildingStep2Percent;
        //get Building Parameter values
        //Decimal BuildingStep3Size;
        //Decimal BuildingStep3Percent;
        Decimal Workstations_open_off_Building1_Percent,Workstations_open_off_Building2_Percent, Workstations_open_off_Building3_Percent, Closed_offices_Building1_Percent,Closed_offices_Building2_Percent,Closed_offices_Building3_Percent,
                X8_20_person_rooms_Building1_Percent,X8_20_person_rooms_Building2_Percent,X8_20_person_rooms_Building3_Percent,X20_or_more_person_rooms_Bldg1_Percent,X20_or_more_person_rooms_Bldg2_Percent, X20_or_more_person_rooms_Bldg3_Percent,
                Teleconference_Building1_Percent,Teleconference_Building2_Percent,Teleconference_Building3_Percent,Auditorium_sloped_floor_Bldg1_Percent,Auditorium_sloped_floor_Bldg2_Percent,Auditorium_sloped_floor_Bldg3_Percent,General_storage_Building1_Percent,
                General_storage_Building2_Percent,General_storage_Building3_Percent,Clinics_health_units_Building1_Percent,Clinics_health_units_Building2_Percent,Clinics_health_units_Building3_Percent,Physical_fitness_Building1_Percent,
                Physical_fitness_Building2_Percent,Physical_fitness_Building3_Percent,Child_care_Building1_Percent,Child_care_Building2_Percent,Child_care_Building3_Percent,Libraries_Building1_Percent,Libraries_Building2_Percent,
                Libraries_Building3_Percent,ADP_high_density_PC_s_Bldg1_Percent, ADP_high_density_PC_s_Bldg2_Percent,ADP_high_density_PC_s_Bldg3_Percent,ADP_mainframe_Building1_Percent,ADP_mainframe_Building2_Percent,ADP_mainframe_Building3_Percent,
                Joint_use_retail_Building1_Percent,Joint_use_retail_Building2_Percent,Joint_use_retail_Building3_Percent,Food_service_cafeteria_Bldg1_Percent,Food_service_cafeteria_Bldg2_Percent,Food_service_cafeteria_Bldg3_Percent,
                Laboratory_Dry_elec_Building1_Percent,Laboratory_Dry_elec_Building2_Percent, Laboratory_Dry_elec_Building3_Percent, Laboratory_Wet_chem_Building1_Percent, Laboratory_Wet_chem_Building2_Percent, Laboratory_Wet_chem_Building3_Percent,     Locker_Shower_room_Building1_Percent, Locker_Shower_room_Building2_Percent, Locker_Shower_room_Building3_Percent, Light_industrial_Building1_Percent, Light_industrial_Building2_Percent,Light_industrial_Building3_Percent,
                Warehouse_Building1_Percent,Warehouse_Building2_Percent, Warehouse_Building3_Percent, Courtroom_dist_Ceremonial_B1_Percent,Courtroom_dist_Ceremonial_B2_Percent,Courtroom_dist_Ceremonial_B3_Percent,      Courtroom_dist_Standard_Bldg1_Percent,Courtroom_dist_Standard_Bldg2_Percent,Courtroom_dist_Standard_Bldg3_Percent,Courtroom_Bankruptcy_Building1_Percent,Courtroom_Bankruptcy_Building2_Percent,      Courtroom_Bankruptcy_Building3_Percent,Courtroom_Magistrate_Building1_Percent,Courtroom_Magistrate_Building2_Percent,Courtroom_Magistrate_Building3_Percent,Grand_Jury_Room_Building1_Percent,
                Grand_Jury_Room_Building2_Percent,Grand_Jury_Room_Building3_Percent, Judicial_hearing_Building1_Percent,Judicial_hearing_Building2_Percent,Judicial_hearing_Building3_Percent,Judicial_chambers_Building1_Percent,
                Judicial_chambers_Building2_Percent,Judicial_chambers_Building3_Percent,Enhanced_office_Building1_Percent,Enhanced_office_Building2_Percent,Enhanced_office_Building3_Percent,USMS_Suite_Admin_Building1_Percent,
                USMS_Suite_Admin_Building2_Percent,USMS_Suite_Admin_Building3_Percent,USMS_Suite_Operations_Building1_Percent,USMS_Suite_Operations_Building2_Percent,USMS_Suite_Operations_Building3_Percent,      Sally_Port_Building1_Percent,Sally_Port_Building2_Percent,Sally_Port_Building3_Percent,Holding_cell_Central_Building1_Percent,Holding_cell_Central_Building2_Percent,Holding_cell_Central_Building3_Percent,
                Holding_cell_Court_floors_Bldg1_Percent,Holding_cell_Court_floors_Bldg2_Percent,Holding_cell_Court_floors_Bldg3_Percent,Non_climate_controlled_Building1_Percent,Non_climate_controlled_Building2_Percent,
                Non_climate_controlled_Building3_Percent,Climate_controlled_Building1_Percent,Climate_controlled_Building2_Percent,Climate_controlled_Building3_Percent, VA_Intake_Building1_Percent,VA_Intake_Building2_Percent,
                VA_Intake_Building3_Percent,VA_Exam_Suite_Building1_Percent,VA_Exam_Suite_Building2_Percent,VA_Exam_Suite_Building3_Percent,VA_Radiology_Building1_Percent,VA_Radiology_Building2_Percent,       VA_Radiology_Building3_Percent,VA_Ambulatory_Surgery_Building1_Percent,VA_Ambulatory_Surgery_Building2_Percent,VA_Ambulatory_Surgery_Building3_Percent,VA_Infusion_Building1_Percent,
                VA_Infusion_Building2_Percent,VA_Infusion_Building3_Percent, VA_Pharmacy_Building1_Percent,VA_Pharmacy_Building2_Percent,VA_Pharmacy_Building3_Percent, Data_Center_Building1_Percent,Data_Center_Building2_Percent,
                Data_Center_Building3_Percent, Average_Story_Height,Plumbing_Fixtures,Number_of_Stops,PLPAverage_Story_Height,PLPPlumbing_Fixtures,PLPNumber_of_Stops,Number_of_Floors,No_of_Stairs_Floors,Main_Entry_Stairs;
        Decimal Above_Ground = 0;
        
        //get values from Project Level Parameter
        /*List <Project_Level_Parameter__c> PLPList = [SELECT Above_Ground__c FROM Project_Level_Parameter__c WHERE NCMT_Project__c = :PIds  ];
        For (Project_Level_Parameter__c PLP : PLPList ){
            Above_Ground = PLP.Above_Ground__c; 
        }
        */
        //Project_Level_Parameter__c PLP = [SELECT Above_Ground__c FROM Project_Level_Parameter__c WHERE NCMT_Project__c = :PIds ];
        //Above_Ground = PLP.Above_Ground__c; 
                                                                                            
        Decimal intOpenOfficeTypUSFUnit, intClosedOfficesTypUSFUnit,intPrivateTioletsTypUSFUnit, int8_20roomsTypUSFUnit,int20moreTypUSFUnit,intTeleconferenceTypUSFUnit,intAuditoriumTypUSFUnit,intLibrariesTypUSFUnit
                ,intChildCareTypUSFUnit,intADPhighdensitypcsTypUSFUnit,intCourtroomdistCereTypUSFUnit,intCourtroomdistStdTypUSFUnit,intCourtroomBankruptcyTypUSFUnit,intCourtroomMagistrateTypUSFUnit,intGrandJuryRoomTypUSFUnit
                ,intJudicialHearingTypUSFUnit,intJudicialchambersTypUSFUnit,intHoldingcellCentralTypUSFUnit,intHoldingcellCourtfloorsTypUSFUnit;        

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
        
        For (NCMT_Housing_Plan__c HPobj : HPList) {
            /*
            if (Above_Ground > 0 && HPobj.Atrium_upper_levels_phantom_floors__c + 1 > Above_Ground) {
                HPobj.adderror('Atrium too tall for building');
            } 
            */
            
            NCMT_Project__c Proj0 = Proj.get(HPobj.Project__c);
            
            if (Proj0.Above_Ground__c > 0 && HPobj.Atrium_upper_levels_phantom_floors__c + 1 > Proj0.Above_Ground__c) {
                HPobj.adderror('Atrium too tall for building');
            }            
            BCode = Proj0.Building_Parameter__r.Name;
            String ProjectRecordTypeName = Proj0.Building_Type__c;
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
            //Average_Story_Height = Proj0.Building_Height_Parameter__r.Story_Ht__c;
            //Plumbing_Fixtures = Proj0.Building_Height_Parameter__r.Plumbing_Fixtures__c;
            Average_Story_Height = Proj0.Average_Story_Height__c;
            Plumbing_Fixtures = Proj0.Plumbing_Fixtures__c;
            
        //}

//--        
        //for(NCMT_Housing_Plan__c HPobj : HPList) {
                //NCMT_Project__c Proj1 = Proj.get(HPobj.Project__c);
                
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
                /*
                //Project USF 
                IF (Proj0.Gross_Area__c == True) {
                    HPobj.Project_USF__c = Proj0.Total_Area_Including_Parking__c * Proj0.Building_Parameter__r.Efficiency__c;
                }
                ELSE IF (Proj0.Useable_Area__c == True){ 
                    HPobj.Project_USF__c = Proj0.Total_Area_Including_Parking__c + (400 * Proj0.Parking_Within_Building_Structure__c );
                }
                //Project GSF
                IF (Proj0.Gross_Area__c == True) {
                    HPobj.Project_GSF__c = Proj0.Total_Area_Including_Parking__c;
                }
                ELSE IF (Proj0.Useable_Area__c == True) { 
                    HPobj.Project_GSF__c = (Proj0.Total_Area_Including_Parking__c + (400 * Proj0.Parking_Within_Building_Structure__c )) / Proj0.Building_Parameter__r.Efficiency__c;
                }
                */
                //Project GF
                //IF ( Proj0.Building_Height_Parameter__r.No_of_Floors__c == 1 ) {
                system.debug('Number_of_Floors===='+ Number_of_Floors);
                if (Number_of_Floors == 1) {
                    HPobj.Project_GF__c = HPobj.Project_GSF__c;
                }
                ELSE {
                    //HPobj.Project_GF__c = MATH.ROUND ( ( ( MATH.ROUND( HPobj.Project_GSF__c) / Proj0.Building_Height_Parameter__r.No_of_Floors__c) * 1.15) ) ;
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
                /*        
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
                    HPobj.Ground_floor_circulation__c =  MATH.ROUND (HPobj.Project_GF__c * (Proj0.Building_Parameter__r.Ground_floor_circulation_Bldg2_Percent__c / 100) * ((HPobj.Project_GSF__c - HPobj.Enclosed_Parking__c) / HPobj.Project_GSF__c));
                    //Number of stops
                    if (Number_of_Floors == 1) {
                        HPobj.Number_of_stops__c = 0;
                    }   
                    Else {
                        HPobj.Number_of_stops__c = Number_of_Floors * Math.Max(Math.Ceil(HPobj.Project_GSF__c * Proj0.Vertical_Conveyance_Elevators_Stops__c/10000),2);
                    }

                    //system.debug('HPobj.Number_of_stops__c===='+HPobj.Number_of_stops__c);            
                    //Elevator lobbies
                    IF (HPobj.Project_GSF__c == 0) {
                        HPobj.Elevator_lobbies__c = 0;
                    }
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
                    //Based on damped Cladding Ratio Based_on_damped_Cladding_Ratio__c
                    //HPobj.Based_on_damped_Cladding_Ratio__c = HPobj.Project_GSF__c * ( ( ((MATH.SQRT ((0.5 * HPobj.Project_GSF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * intStory_Ht) 
                    //                                          /  (HPobj.Project_GSF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) + 0.5 ) / 2 ) / intStory_Ht ;
                    //HPobj.Using_2_1_aspect_ratio__ctest =   ( MATH.SQRT ((0.5 * HPobj.Project_GSF__c ) / Number_of_Floors )  
                    //                                      * 6 * intStory_Ht )  
                    //                                      /  (HPobj.Project_GSF__c / Number_of_Floors)  ;
                    //HPobj.Based_on_damped_Cladding_Ratio__c = ( HPobj.Project_GSF__c * ( (HPobj.Using_2_1_aspect_ratio__ctest + 0.5) / 2 ) ) / intStory_Ht; 
                    HPobj.Based_on_damped_Cladding_Ratio__c = HPobj.Project_GSF__c * ( ( ((MATH.SQRT ((0.5 * HPobj.Project_GSF__c ) / Number_of_Floors )) * 6 * intStory_Ht) 
                                                                /  (HPobj.Project_GSF__c / Number_of_Floors) + 0.5 ) / 2 ) / intStory_Ht ;                                                          
                    //Structural Area                   
                    IF (HPobj.Project_GSF__c == 0) {
                        HPobj.Structural_Area__c = 0;
                    }
                    ELSE {
                        HPobj.Structural_Area__c = ( ( ( HPobj.Project_GSF__c / 900) + ((HPobj.Based_on_damped_Cladding_Ratio__c /30)/2 ) ) * 6 ) + (HPobj.Based_on_damped_Cladding_Ratio__c * intunit);
                        //HPobj.Structural_Area__c = ( ( ( HPobj.Project_GSF__c / 900) + ((HPobj.Based_on_damped_Cladding_Ratio__c /30)/2 ) ) * 6 ) + (HPobj.Based_on_damped_Cladding_Ratio__c * Number_of_Floors);
                        //HPobj.Structural_Area__c =  ( HPobj.Project_GSF__c / 900);
                        //HPobj.Structural_Area__c = ((HPobj.Based_on_damped_Cladding_Ratio__c /30)/2 ) ;
                        //HPobj.Structural_Area__c = (HPobj.Based_on_damped_Cladding_Ratio__c * Number_of_Floors);
                    }
                    
                    //HPobj.Structural_Area__c = ((MATH.ROUND(HPobj.Project_GSF__c) * ((MATH.ROUND(( (MATH.SQRT( (0.5 * HPobj.Project_GSF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * 
                    //                          intStory_Ht) / ( MATH.ROUND(HPobj.Project_GSF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) )) 
                    //                          + 0.5) / 2 ) / intStory_Ht) * intunit) 
                    //                          + ((((MATH.ROUND(HPobj.Project_GSF__c) * ((MATH.ROUND(( (MATH.SQRT( (0.5 * HPobj.Project_GSF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * 
                    //                          intStory_Ht) / ( MATH.ROUND(HPobj.Project_GSF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) ))  
                    //                          + 0.5) / 2 ) / intStory_Ht) / 30 ) / 2) + HPobj.Project_GSF__c / 900) * 6 ;                                                                                                                                 
                    
                    //HPobj.Based_on_damped_Cladding_Ratio__c = (MATH.ROUND(HPobj.Project_GSF__c) * ((MATH.ROUND(( (MATH.SQRT( (0.5 * HPobj.Project_GSF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * 
                    //                                          intStory_Ht) / ( MATH.ROUND(HPobj.Project_GSF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) ))  
                    //                                          + 0.5) / 2 ) / intStory_Ht);    
                    //Elevator shafts                   
                    IF (HPobj.Project_GSF__c == 0) {
                        HPobj.Elevator_shafts__c = 0;
                    }
                    ELSE {
                        HPobj.Elevator_shafts__c = HPobj.Number_of_stops__c * 40;
                    }
                    If (Number_of_Floors ==1) {
                        HPobj.Total_Floor_openings__c = 0;
                    }
                    else {
                        HPobj.Total_Floor_openings__c = (Number_of_Floors * (Math.MAX(2, MATH.CEIL(HPobj.Average_floorplate_size__c/100000))) + (HPobj.Main_entry_stairs__c + 1));
                    }
                    //Stair shafts
                    IF ( HPobj.Project_GSF__c == 0 ) {
                        HPobj.Stair_shafts__c = 0;
                    }
                    ELSE {
                        HPobj.Stair_shafts__c = HPobj.Total_Floor_openings__c * 24 * 14;
                    } 
                    //Other vertical penetrations 
                    HPobj.Other_vertical_penetrations__c = 6 * HPobj.Elevator_shafts__c ;
                }
                */
                /*
                //Rentable Area and Useable Area calculations
                IF (Proj0.Gross_Area__c == True) {
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
                }
                */
                //Parking Garage calculation for Non-Rentable Area
                if (ProjectRecordTypeName == 'Parking Garage') {

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
                            /*
                            IF (Proj0.Building_Height_Parameter__r.RecordType.Name == 'Utility' || ProjectRecordTypeName == 'Parking Garage') {
                                intunit = 1.5;
                            }
                            ELSE {
                                intunit = 2;
                            }
                            
                            if ((ProjectRecordTypeName == 'Office' || ProjectRecordTypeName == 'Laboratory: Dry' || ProjectRecordTypeName == 'Laboratory: Wet') && Number_of_Floors == 10) {
                                intunit = 1.5;  
                            }
                            else {
                                intunit = Proj0.Building_Height_Parameter__r.Cladding_Thickness__c;
                            }
                            */
                            intunit = Proj0.Building_Height_Parameter__r.Cladding_Thickness__c;
                            intStory_HT=Average_Story_Height;                   
                            //Based on damped Cladding Ratio Based_on_damped_Cladding_Ratio__c
                            //HPobj.Based_on_damped_Cladding_Ratio__c = Proj0.Parking_Garage_Gross_Area_SF__c * ( ( ((MATH.SQRT ((0.5 * Proj0.Parking_Garage_Gross_Area_SF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * intStory_Ht) 
                            //                                          /  (Proj0.Parking_Garage_Gross_Area_SF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) + 0.5 ) / 2 ) / intStory_Ht ;
                            HPobj.Based_on_damped_Cladding_Ratio__c = Proj0.Parking_Garage_Gross_Area_SF__c * ( ( ((MATH.SQRT ((0.5 * Proj0.Parking_Garage_Gross_Area_SF__c ) / Number_of_Floors )) * 6 * intStory_Ht) 
                                                                        /  (Proj0.Parking_Garage_Gross_Area_SF__c / Number_of_Floors) + 0.5 ) / 2 ) / intStory_Ht ;                                                                                         
                            //Structural Area                   
                            IF (Proj0.Parking_Garage_Gross_Area_SF__c == 0) {
                                HPobj.Structural_Area__c = 0;
                            }
                            ELSE {
                                HPobj.Structural_Area__c = ( ( ( Proj0.Parking_Garage_Gross_Area_SF__c / 900) + ((HPobj.Based_on_damped_Cladding_Ratio__c /30)/2 ) ) * 6 ) + (HPobj.Based_on_damped_Cladding_Ratio__c * intunit);
                            }
                            
                            //Elevator shafts                   
                            IF (Proj0.Parking_Garage_Gross_Area_SF__c == 0) {
                                HPobj.Elevator_shafts__c = 0;
                            }
                            ELSE {
                                HPobj.Elevator_shafts__c = HPobj.Number_of_stops__c * 40;
                            }
                            If (Number_of_Floors == 1) {
                                HPobj.Total_Floor_openings__c = 0;
                            }
                            else {
                                HPobj.Total_Floor_openings__c = (Number_of_Floors * (Math.MAX(2, MATH.CEIL(HPobj.Average_floorplate_size__c/100000))) + (HPobj.Main_entry_stairs__c + 1));
                            }
                            //Stair shafts
                            IF ( HPobj.Project_GSF__c == 0 ) {
                                HPobj.Stair_shafts__c = 0;
                            }
                            ELSE {
                                HPobj.Stair_shafts__c = HPobj.Total_Floor_openings__c * 24 * 14;
                            }                           
                           
                            //Other vertical penetrations 
                            HPobj.Other_vertical_penetrations__c = 2 * HPobj.Elevator_shafts__c ;
                            //Project GSF
                            HPobj.Project_GSF__c = Proj0.Parking_Garage_Gross_Area_SF__c;
                            //Total GSF
                            HPobj.Total_GSF__c = Proj0.Parking_Garage_Gross_Area_SF__c;
                            HPobj.Total_USF__c = 0;
                            
                }
                //HousingPlan Entry calculations
                ELSE {
                    
                        if (HPobj.Workstations_open_office_Count__c == null) HPobj.Workstations_open_office_Count__c = 0;
                        
                        if(HPobj.Closed_offices_Count__c== null) HPobj.Closed_offices_Count__c = 0;
                        
                        if(HPobj.Private_toilets_Count__c== null) HPobj.Private_toilets_Count__c = 0;
                        
                        if(HPobj.X8_20_person_rooms_Count__c== null) HPobj.X8_20_person_rooms_Count__c = 0;
                        
                        if(HPobj.X20_or_more_person_rooms_Count__c== null) HPobj.X20_or_more_person_rooms_Count__c = 0;
                        
                        if(HPobj.Teleconference_Count__c== null) HPobj.Teleconference_Count__c = 0;
                        
                        if(HPobj.Auditorium_sloped_floor_Count__c== null) HPobj.Auditorium_sloped_floor_Count__c = 0;
                        
                        if(HPobj.Child_care_Count__c== null) HPobj.Child_care_Count__c = 0;
                        
                        if(HPobj.Libraries_Count__c== null) HPobj.Libraries_Count__c = 0;
                        
                        if(HPobj.ADP_high_density_PC_s_Count__c== null) HPobj.ADP_high_density_PC_s_Count__c = 0;
                        
                        if(HPobj.Courtroom_district_Ceremonial_Count__c== null) HPobj.Courtroom_district_Ceremonial_Count__c = 0;
                        
                        if(HPobj.Courtroom_district_Standard_Count__c== null) HPobj.Courtroom_district_Standard_Count__c = 0;
                        
                        if(HPobj.Courtroom_Bankruptcy_Count__c== null) HPobj.Courtroom_Bankruptcy_Count__c = 0;
                        
                        if(HPobj.Courtroom_Magistrate_Count__c== null) HPobj.Courtroom_Magistrate_Count__c = 0;
                        
                        if(HPobj.Grand_Jury_Room_Count__c== null) HPobj.Grand_Jury_Room_Count__c = 0;
                        
                        if(HPobj.Judicial_hearing_Count__c== null) HPobj.Judicial_hearing_Count__c = 0;
                        
                        if(HPobj.Judicial_chambers_Count__c== null) HPobj.Judicial_chambers_Count__c = 0;
                        
                        if(HPobj.Holding_cell_Central_Count__c== null) HPobj.Holding_cell_Central_Count__c = 0;
                        
                        if(HPobj.Holding_cell_Court_floors_Count__c== null) HPobj.Holding_cell_Court_floors_Count__c = 0;
                        
                        
                    //Workstations/open office Use USF calculation
                    IF (HPobj.Workstations_open_office_Entered_USF__c > 0 ) {
                        HPobj.Workstations_open_office_Use_USF__c = HPobj.Workstations_open_office_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Workstations_open_office_Use_USF__c = HPobj.Workstations_open_office_Count__c * intOpenOfficeTypUSFUnit;
                    }
                    //Closed offices Use USF calculation
                    IF (HPobj.Closed_offices_Entered_USF__c > 0 ) {
                        HPobj.Closed_offices_Use_USF__c = HPobj.Closed_offices_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Closed_offices_Use_USF__c = HPobj.Closed_offices_Count__c * intClosedOfficesTypUSFUnit;
                    }
                    //Private toilets Use USF
                    IF (HPobj.Private_toilets_Entered_USF__c > 0 ) {
                        HPobj.Private_toilets_Use_USF__c = HPobj.Private_toilets_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Private_toilets_Use_USF__c = HPobj.Private_toilets_Count__c * intPrivateTioletsTypUSFUnit;
                    }
                    //8 - 20 person rooms Use USF calculation
                    IF (HPobj.X8_20_person_rooms_Entered_USF__c > 0 ) {
                        HPobj.X8_20_person_rooms_Use_USF__c = HPobj.X8_20_person_rooms_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.X8_20_person_rooms_Use_USF__c = HPobj.X8_20_person_rooms_Count__c * int8_20roomsTypUSFUnit;
                    }
                    //20 or more person rooms Use USF calculation
                    IF (HPobj.X20_or_more_person_rooms_Entered_USF__c > 0 ) {
                        HPobj.X20_or_more_person_rooms_Use_USF__c = HPobj.X20_or_more_person_rooms_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.X20_or_more_person_rooms_Use_USF__c = HPobj.X20_or_more_person_rooms_Count__c * int20moreTypUSFUnit;
                    }
                    //Teleconference calculations
                    IF (HPobj.Teleconference_Entered_USF__c > 0 ) {
                        HPobj.Teleconference_Use_USF__c = HPobj.Teleconference_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Teleconference_Use_USF__c = HPobj.Teleconference_Count__c * intTeleconferenceTypUSFUnit;
                    }
                    //Auditorium (sloped floor) calculations
                    IF (HPobj.Auditorium_sloped_floor_Entered_USF__c > 0 ) {
                        HPobj.Auditorium_sloped_floor_Use_USF__c = HPobj.Auditorium_sloped_floor_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Auditorium_sloped_floor_Use_USF__c = HPobj.Auditorium_sloped_floor_Count__c * intAuditoriumTypUSFUnit;
                    }
                    //Child care calculations
                    IF (HPobj.Child_care_Entered_USF__c > 0 ) {
                        HPobj.Child_care_Use_USF__c = HPobj.Child_care_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Child_care_Use_USF__c = HPobj.Child_care_Count__c * intChildCareTypUSFUnit;
                    }
                    //Libraries calculations
                    IF (HPobj.Libraries_Entered_USF__c > 0 ) {
                        HPobj.Libraries_Use_USF__c = HPobj.Libraries_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Libraries_Use_USF__c = HPobj.Libraries_Count__c * intLibrariesTypUSFUnit;
                    }
                    //ADP (high density PC’s) calculations
                    IF (HPobj.ADP_high_density_PC_s_Entered_USF__c > 0 ) {
                        HPobj.ADP_high_density_PC_s_Use_USF__c = HPobj.ADP_high_density_PC_s_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.ADP_high_density_PC_s_Use_USF__c = HPobj.ADP_high_density_PC_s_Count__c * intADPhighdensitypcsTypUSFUnit;
                    }                   
                    //Courtroom dist Ceremonial calculations
                    IF (HPobj.Courtroom_district_CeremonialEntered_USF__c > 0 ) {
                        HPobj.Courtroom_district_Ceremonial_Use_USF__c = HPobj.Courtroom_district_CeremonialEntered_USF__c;
                    }
                    ELSE {
                        HPobj.Courtroom_district_Ceremonial_Use_USF__c = HPobj.Courtroom_district_Ceremonial_Count__c * intCourtroomdistCereTypUSFUnit;
                    }
                    //Courtroom dist Standard calculations
                    IF (HPobj.Courtroom_district_Standard_Entered_USF__c > 0 ) {
                        HPobj.Courtroom_district_Standard_Use_USF__c = HPobj.Courtroom_district_Standard_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Courtroom_district_Standard_Use_USF__c = HPobj.Courtroom_district_Standard_Count__c * intCourtroomdistStdTypUSFUnit;
                    }
                    //Courtroom Bankruptcy calculations
                    IF (HPobj.Courtroom_Bankruptcy_Entered_USF__c > 0 ) {
                        HPobj.Courtroom_Bankruptcy_Use_USF__c = HPobj.Courtroom_Bankruptcy_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Courtroom_Bankruptcy_Use_USF__c = HPobj.Courtroom_Bankruptcy_Count__c * intCourtroomBankruptcyTypUSFUnit;
                    }
                    //Courtroom Magistrate calculations
                    IF (HPobj.Courtroom_Magistrate_Entered_USF__c > 0 ) {
                        HPobj.Courtroom_Magistrate_Use_USF__c = HPobj.Courtroom_Magistrate_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Courtroom_Magistrate_Use_USF__c = HPobj.Courtroom_Magistrate_Count__c * intCourtroomMagistrateTypUSFUnit;
                    }
                    //Grand Jury Room calculations
                    IF (HPobj.Grand_Jury_Room_Entered_USF__c > 0 ) {
                        HPobj.Grand_Jury_Room_Use_USF__c = HPobj.Grand_Jury_Room_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Grand_Jury_Room_Use_USF__c = HPobj.Grand_Jury_Room_Count__c * intGrandJuryRoomTypUSFUnit;
                    }
                    //Judicial Hearing calculations
                    IF (HPobj.Judicial_hearing_Entered_USF__c > 0 ) {
                        HPobj.Judicial_hearing_Use_USF__c = HPobj.Judicial_hearing_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Judicial_hearing_Use_USF__c = HPobj.Judicial_hearing_Count__c * intJudicialHearingTypUSFUnit;
                    }
                    //Judicial chambers calculations
                    IF (HPobj.Judicial_chambers_Entered_USF__c > 0 ) {
                        HPobj.Judicial_chambers_Use_USF__c = HPobj.Judicial_chambers_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Judicial_chambers_Use_USF__c = HPobj.Judicial_chambers_Count__c * intJudicialchambersTypUSFUnit;
                    }
                    //Holding cell Central calculations
                    IF (HPobj.Holding_cell_Central_Entered_USF__c > 0 ) {
                        HPobj.Holding_cell_Central_Use_USF__c = HPobj.Holding_cell_Central_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Holding_cell_Central_Use_USF__c = HPobj.Holding_cell_Central_Count__c * intHoldingcellCentralTypUSFUnit;
                    }
                    //Holding cell Courtfloors calculations
                    IF (HPobj.Holding_cell_Court_floors_Entered_USF__c > 0 ) {
                        HPobj.Holding_cell_Court_floors_Use_USF__c = HPobj.Holding_cell_Court_floors_Entered_USF__c;
                    }
                    ELSE {
                        HPobj.Holding_cell_Court_floors_Use_USF__c = HPobj.Holding_cell_Court_floors_Count__c * intHoldingcellCourtfloorsTypUSFUnit;
                    }
                    
                    //try {
                        if(HPobj.Unfinished_Shell_Area_Use_USF__c== null) HPobj.Unfinished_Shell_Area_Use_USF__c = 0;
                        
                        if(HPobj.General_storage_Use_USF__c== null) HPobj.General_storage_Use_USF__c = 0;
                        
                        if(HPobj.High_density_storage_Use_USF__c== null) HPobj.High_density_storage_Use_USF__c = 0;
                        
                        if(HPobj.Clinics_health_units_Use_USF__c== null) HPobj.Clinics_health_units_Use_USF__c = 0;
                        
                        if(HPobj.Physical_fitness_Use_USF__c== null) HPobj.Physical_fitness_Use_USF__c = 0;
                        
                        if(HPobj.ADP_mainframe_Use_USF__c== null) HPobj.ADP_mainframe_Use_USF__c = 0;
                        
                        if(HPobj.Joint_use_retail_Use_USF__c== null) HPobj.Joint_use_retail_Use_USF__c = 0;
                        
                        if(HPobj.Food_service_cafeteria_Use_USF__c== null) HPobj.Food_service_cafeteria_Use_USF__c = 0;
                        
                        if(HPobj.Climate_controlled_for_artifacts_Use_USF__c== null) HPobj.Climate_controlled_for_artifacts_Use_USF__c = 0;
                        
                        if(HPobj.Non_climate_controlled_Use_USF__c== null) HPobj.Non_climate_controlled_Use_USF__c = 0;
                        
                        if(HPobj.Laboratory_Dry_electronic_Use_USF__c== null) HPobj.Laboratory_Dry_electronic_Use_USF__c = 0;
                        
                        if(HPobj.Laboratory_Wet_chemistry_Use_USF__c== null) HPobj.Laboratory_Wet_chemistry_Use_USF__c = 0;
                        
                        if(HPobj.Firing_range_Use_USF__c== null) HPobj.Firing_range_Use_USF__c = 0;
                        
                        if(HPobj.Copy_Center_Use_USF__c== null) HPobj.Copy_Center_Use_USF__c = 0;
                        
                        if(HPobj.Credit_Union_Use_USF__c== null) HPobj.Credit_Union_Use_USF__c = 0;
                        
                        if(HPobj.Transaction_counter_space_Use_USF__c== null) HPobj.Transaction_counter_space_Use_USF__c = 0;
                        
                        if(HPobj.Kitchen_Break_room_Use_USF__c== null) HPobj.Kitchen_Break_room_Use_USF__c = 0;
                        
                        if(HPobj.Locker_Shower_room_Use_USF__c== null) HPobj.Locker_Shower_room_Use_USF__c = 0;
                        
                        if(HPobj.Hardened_offices_suites_Use_USF__c== null) HPobj.Hardened_offices_suites_Use_USF__c = 0;
                        
                        if(HPobj.Secure_Work_Environment_SWE_Std_Use_USF__c== null) HPobj.Secure_Work_Environment_SWE_Std_Use_USF__c = 0;
                        
                        if(HPobj.Secure_Work_Environment_SWE_Enhd_UseUSF__c== null) HPobj.Secure_Work_Environment_SWE_Enhd_UseUSF__c = 0;
                        
                        if(HPobj.Secured_Storage_SCIF_Standard_Use_USF__c== null) HPobj.Secured_Storage_SCIF_Standard_Use_USF__c = 0;
                        
                        if(HPobj.Secured_Storage_SCIF_Enhanced_Use_USF__c== null) HPobj.Secured_Storage_SCIF_Enhanced_Use_USF__c = 0;
                        
                        if(HPobj.Vault_Type_Storage_Use_USF__c== null) HPobj.Vault_Type_Storage_Use_USF__c = 0;
                        
                        if(HPobj.Interview_Detention_Use_USF__c== null) HPobj.Interview_Detention_Use_USF__c = 0;
                        
                        if(HPobj.Non_Marshal_Holding_Cell_Single_Use_USF__c== null) HPobj.Non_Marshal_Holding_Cell_Single_Use_USF__c = 0;
                        
                        if(HPobj.Non_Marshal_Holding_Cell_Double_Use_USF__c== null) HPobj.Non_Marshal_Holding_Cell_Double_Use_USF__c = 0;
                        
                        if(HPobj.Enhanced_office_Use_USF__c== null) HPobj.Enhanced_office_Use_USF__c = 0;
                        
                        if(HPobj.USMS_Suite_Administration_Use_USF__c== null) HPobj.USMS_Suite_Administration_Use_USF__c = 0;
                        
                        if(HPobj.USMS_Suite_Operations_Use_USF__c== null) HPobj.USMS_Suite_Operations_Use_USF__c = 0;
                        
                        if(HPobj.Sally_Port_Use_USF__c== null) HPobj.Sally_Port_Use_USF__c = 0;
                        
                        if(HPobj.Light_industrial_Use_USF__c== null) HPobj.Light_industrial_Use_USF__c = 0;
                        
                        if(HPobj.Warehouse_Use_USF__c== null) HPobj.Warehouse_Use_USF__c = 0;
                        
                        if(HPobj.VA_Intake_Use_USF__c== null) HPobj.VA_Intake_Use_USF__c = 0;
                        
                        if(HPobj.VA_Exam_Suite_Use_USF__c== null) HPobj.VA_Exam_Suite_Use_USF__c = 0;
                        
                        if(HPobj.VA_Radiology_Use_USF__c== null) HPobj.VA_Radiology_Use_USF__c = 0;
                        
                        if(HPobj.VA_Ambulatory_Surgery_Use_USF__c== null) HPobj.VA_Ambulatory_Surgery_Use_USF__c = 0;
                        
                        if(HPobj.VA_Infusion_Use_USF__c== null) HPobj.VA_Infusion_Use_USF__c= 0;
                        
                        if(HPobj.VA_Pharmacy_Use_USF__c== null) HPobj.VA_Pharmacy_Use_USF__c= 0;
                        
                        if(HPobj.Data_Center_Use_USF__c== null) HPobj.Data_Center_Use_USF__c= 0;
                        
                        if(HPobj.Mailroom_Use_USF__c== null) HPobj.Mailroom_Use_USF__c=0;
                        
                        if(HPobj.Secure_Mailroom_Use_USF__c== null) HPobj.Secure_Mailroom_Use_USF__c=0;
                        
                    
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
                                        
                        HPobj.Project_USF__c =  HPobj.Total_USF__c;
                        
                        IF (HPobj.Total_USF__c > 0) {
                            //Number of Floors
                            Number_of_Floors = Proj0.Above_Ground__c + Proj0.Below_Ground__c;
                            HPobj.Number_of_Floors__c = Number_of_Floors;
                            //Project GSF
                            HPobj.Project_GSF__c =  (HPobj.Project_USF__c / Proj0.Building_Parameter__r.Efficiency__c) +  HPobj.Enclosed_Parking__c ;
                            //Number of stops
                            if (Number_of_Floors == 1) {
                                HPobj.Number_of_stops__c = 0;
                            }   
                            Else {
                                HPobj.Number_of_stops__c = Number_of_Floors * Math.Max(Math.Ceil(HPobj.Project_GSF__c * Proj0.Vertical_Conveyance_Elevators_Stops__c/10000),2);
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
                            //Project GF Number_of_Floors
                            IF ( Number_of_Floors == 1 ) {
                                HPobj.Project_GF__c = HPobj.Project_GSF__c;
                            }
                            ELSE {
                                //HPobj.Project_GF__c = MATH.ROUND ( ( ( MATH.ROUND( HPobj.Project_GSF__c) / Proj0.Building_Height_Parameter__r.No_of_Floors__c) * 1.15) ) ;
                                HPobj.Project_GF__c = MATH.ROUND ( ( ( MATH.ROUND( HPobj.Project_GSF__c) / Number_of_Floors) * 1.15) ) ;
                            }
                            
                            //Enclosed Parking
                            HPobj.Enclosed_Parking__c = Proj0.Parking_Within_Building_Structure__c * 400;
    
                            //Common Area calculations
                            //Main Lobby
                            /*IF ( HPobj.Enclosed_Parking__c > HPobj.Project_USF__c ) {
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
                            }*/
                            if (HPobj.Project_USF__c < 0 ) {
                                HPobj.Main_Lobby__c = 0;
                            }
                            else {
                                IF ( ( HPobj.Project_USF__c) * (Proj0.Building_Parameter__r.Main_Lobby_Building2_Percent__c / 100) < 100 ) {
                                    HPobj.Main_Lobby__c = 0;
                                }
                                ELSE IF ((HPobj.Project_USF__c) * (Proj0.Building_Parameter__r.Main_Lobby_Building2_Percent__c / 100) < 299) {
                                    HPobj.Main_Lobby__c = 200;
                                }
                                ELSE {
                                    HPobj.Main_Lobby__c = MATH.ROUND((HPobj.Project_USF__c) * (Proj0.Building_Parameter__r.Main_Lobby_Building2_Percent__c / 100) / 200) * 200 ;
                                }
                            }
                            
                            //Atrium (Ground floor plan area)
                            IF (HPobj.Project_USF__c > 50000) {
                                //HPobj.Atrium_Ground_floor_plan_area__c = (HPobj.Project_USF__c - HPobj.Enclosed_Parking__c ) * (Proj0.Building_Parameter__r.Atrium_Building2_Percent__c / 100);
                                HPobj.Atrium_Ground_floor_plan_area__c = MATH.ROUND(HPobj.Project_USF__c  * (Proj0.Building_Parameter__r.Atrium_Building2_Percent__c / 100) );  
                            }
                            ELSE {
                                HPobj.Atrium_Ground_floor_plan_area__c = 0; 
                            }                   
                            //Restrooms
                            //HPobj.Restrooms__c = MATH.ROUND(((HPobj.Project_GSF__c - HPobj.Enclosed_Parking__c) * Plumbing_Fixtures) / 1000 * 25);
                            HPobj.Restrooms__c =  MATH.ROUND( (HPobj.Project_GSF__c * Plumbing_Fixtures) / 1000 * 25 );                     
                            //Ground floor circulation
                            HPobj.Ground_floor_circulation__c =  MATH.ROUND (HPobj.Project_GF__c * (Proj0.Building_Parameter__r.Ground_floor_circulation_Bldg2_Percent__c / 100) * ((HPobj.Project_GSF__c - HPobj.Enclosed_Parking__c) / HPobj.Project_GSF__c));

                            //Elevator lobbies
                            IF (HPobj.Project_GSF__c == 0) {
                                HPobj.Elevator_lobbies__c = 0;
                            }
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
                            //HPobj.Mechanical_Electrical_IT__c = MATH.ROUND(( HPobj.Project_USF__c - HPobj.Enclosed_Parking__c) * (Proj0.Building_Parameter__r.Mechanical_Electrical_IT_Bldg2_Percent__c / 100));
                            HPobj.Mechanical_Electrical_IT__c = MATH.ROUND(HPobj.Total_USF__c * (Proj0.Building_Parameter__r.Mechanical_Electrical_IT_Bldg2_Percent__c / 100) );
                            
                            //Non-Rentable calculations
                            Decimal intStory_Ht;
                            Decimal intunit;

                            if ((ProjectRecordTypeName == 'Office' || ProjectRecordTypeName == 'Laboratory: Dry' || ProjectRecordTypeName == 'Laboratory: Wet') && Number_of_Floors == 10) {
                                intunit = 1.5;  
                            }
                            else {
                                intunit = Proj0.Building_Height_Parameter__r.Cladding_Thickness__c;
                            }
                            intStory_HT=Average_Story_Height;                   
                            //Based on damped Cladding Ratio Based_on_damped_Cladding_Ratio__c Number_of_Floors
                            //HPobj.Based_on_damped_Cladding_Ratio__c = HPobj.Project_GSF__c * ( ( ((MATH.SQRT ((0.5 * HPobj.Project_GSF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * intStory_Ht) 
                            //                                          /  (HPobj.Project_GSF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) + 0.5 ) / 2 ) / intStory_Ht ;   
                            HPobj.Based_on_damped_Cladding_Ratio__c = HPobj.Project_GSF__c * ( ( ((MATH.SQRT ((0.5 * HPobj.Project_GSF__c ) / Number_of_Floors )) * 6 * intStory_Ht) 
                                                                        /  (HPobj.Project_GSF__c / Number_of_Floors) + 0.5 ) / 2 ) / intStory_Ht ;                                                                                          
                            //Structural Area                   
                            IF (HPobj.Project_GSF__c == 0) {
                                HPobj.Structural_Area__c = 0;
                            }
                            ELSE {
                                HPobj.Structural_Area__c = ( ( ( HPobj.Project_GSF__c / 900) + ((HPobj.Based_on_damped_Cladding_Ratio__c /30)/2 ) ) * 6 ) + (HPobj.Based_on_damped_Cladding_Ratio__c * intunit);
                            }
                            
                            //HPobj.Structural_Area__c = ((MATH.ROUND(HPobj.Project_GSF__c) * ((MATH.ROUND(( (MATH.SQRT( (0.5 * HPobj.Project_GSF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * 
                            //                          intStory_Ht) / ( MATH.ROUND(HPobj.Project_GSF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) )) 
                            //                          + 0.5) / 2 ) / intStory_Ht) * intunit) 
                            //                          + ((((MATH.ROUND(HPobj.Project_GSF__c) * ((MATH.ROUND(( (MATH.SQRT( (0.5 * HPobj.Project_GSF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * 
                            //                          intStory_Ht) / ( MATH.ROUND(HPobj.Project_GSF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) ))  
                            //                          + 0.5) / 2 ) / intStory_Ht) / 30 ) / 2) + HPobj.Project_GSF__c / 900) * 6 ;                                                                                                                                 
                            
                            //HPobj.Based_on_damped_Cladding_Ratio__c = (MATH.ROUND(HPobj.Project_GSF__c) * ((MATH.ROUND(( (MATH.SQRT( (0.5 * HPobj.Project_GSF__c ) / Proj0.Building_Height_Parameter__r.No_of_Floors__c )) * 6 * 
                            //                                          intStory_Ht) / ( MATH.ROUND(HPobj.Project_GSF__c / Proj0.Building_Height_Parameter__r.No_of_Floors__c) ))  
                            //                                          + 0.5) / 2 ) / intStory_Ht);    
                            //Elevator shafts Number_of_Floors                  
                            IF (HPobj.Project_GSF__c == 0) {
                                HPobj.Elevator_shafts__c = 0;
                            }
                            ELSE {
                                HPobj.Elevator_shafts__c = HPobj.Number_of_stops__c * 40;
                            }

                            If (Number_of_Floors == 1) {
                                HPobj.Total_Floor_openings__c = 0;
                            }
                            else {
                                HPobj.Total_Floor_openings__c = (Number_of_Floors * (Math.MAX(2, MATH.CEIL(HPobj.Average_floorplate_size__c/100000))) + (HPobj.Main_entry_stairs__c + 1));
                            }
                            //Stair shafts
                            IF ( HPobj.Project_GSF__c == 0 ) {
                                HPobj.Stair_shafts__c = 0;
                            }
                            ELSE {
                                HPobj.Stair_shafts__c = HPobj.Total_Floor_openings__c * 24 * 14;
                            }                           
                            //Other vertical penetrations 
                            HPobj.Other_vertical_penetrations__c = 2 * HPobj.Elevator_shafts__c ;
                        }   
                    //}
                    //catch (Exception e) 
                    //  HPobj.adderror('All Use USF fields must have values. If fields are null, enter zero.');
                    //
                    
                }                         
                /*
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
                                        + HPobj.Data_Center_Use_USF__c ;
                                        
                                                                                
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
                */ 
                if (Proj0.Housing_Plan__c == True) {
                    
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
                    /*
                    HPobj.Conditioned_Core_Area__c = HPobj.Main_Lobby__c + HPobj.Atrium_Ground_floor_plan_area__c + HPobj.Enclosed_Parking__c
                                                        + HPobj.Restrooms__c + HPobj.Ground_floor_circulation__c + HPobj.Elevator_lobbies__c + HPobj.Other_circulation__c 
                                                        + HPobj.Mechanical_Electrical_IT__c + HPobj.Loading_dock_Recycling_Trash__c
                                                        + HPobj.Structural_Area__c + HPobj.Elevator_shafts__c + HPobj.Stair_shafts__c + HPobj.Other_vertical_penetrations__c
                                                        + (HPobj.Atrium_Ground_floor_plan_area__c * HPobj.Atrium_upper_levels_phantom_floors__c );
                    */
                    if (HPobj.Total_GSF__c < 2000) {
                        //HPobj.adderror('Total GSF (' + HPobj.Total_GSF__c.setscale(2) + ') cannot be less than 2000 sq ft.');
                    }                                                       
                }
         }
    }
    /*
    public void UpdateProjectData(List<NCMT_Housing_Plan__c> HPList, Id PIds) {
        
        Integer intGSF_10000;   
        Integer intGSF_25000;
        Integer intGSF_50000;
        Integer intGSF_100000;
        Integer intGSF_150000;
        Integer intGSF_250000;
        Integer intGSF_500000;
        Integer intGSF_GT_500000;       
        Decimal ConstructionMonth=0;
        Decimal Total_GSF;
        Decimal Enclosed_Parking;
        Decimal Total_RSF;
        Decimal Total_USF;
        Decimal Unfinished_Shell_Area_Use_USF;
        Decimal Number_of_stops;

        for(NCMT_Housing_Plan__c HPobj : HPList) {
            Total_GSF = HPobj.Total_GSF__c;
            Enclosed_Parking = HPobj.Enclosed_Parking__c;
            Total_RSF = HPobj.Total_RSF__c; 
            Total_USF = HPobj.Total_USF__c;
            Unfinished_Shell_Area_Use_USF = HPobj.Unfinished_Shell_Area_Use_USF__c;
            Number_of_stops = HPobj.Number_of_stops__c;
        }       
        
        string strNCMTRecordType = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId();
        //update Total GSF, Start or End Construction
         IF (Total_GSF > 0) {
            
            
            NCMT_Project__c Proj = [SELECT Total_GSF__c, RecordTypeID, 
                                    Building_Height_Parameter__r.GSF_10000__c, Building_Height_Parameter__r.GSF_25000__c, Building_Height_Parameter__r.GSF_50000__c, 
                                    Building_Height_Parameter__r.GSF_100000__c, Building_Height_Parameter__r.GSF_150000__c, Building_Height_Parameter__r.GSF_250000__c, 
                                    Building_Height_Parameter__r.GSF_500000__c, Building_Height_Parameter__r.GSF_GT_500000__c,
                                    Start_Construction__c, End_Construction__c,
                                    Enclosed_parking_PRSF__c, Gross_Area_w_o_parking_BGSF__c, Gross_Area_w_o_parking_Efficiency__c,
                                    Rentable_Area_w_o_parking_RSF__c, Rentable_Area_w_o_parking_Efficiency__c,
                                    Useable_Area_Total_USF__c, Useable_Area_Total_Efficiency__c,
                                    Useable_Area_Built_out_USF__c, Useable_Area_Unfinished_USF__c, Number_of_Stops__c
                                    FROM NCMT_Project__c WHERE Id = :PIds ];
                
            IF (Proj.RecordTypeID <> strNCMTRecordType ) {
                intGSF_10000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_10000__c);
                intGSF_25000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_25000__c );
                intGSF_50000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_50000__c );
                intGSF_100000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_100000__c );
                intGSF_150000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_150000__c );
                intGSF_250000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_250000__c );
                intGSF_500000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_500000__c );
                intGSF_GT_500000 = Integer.valueOf(Proj.Building_Height_Parameter__r.GSF_GT_500000__c );
                Proj.Total_GSF__c = Total_GSF;
                Proj.Enclosed_parking_PRSF__c = Enclosed_Parking;
                Proj.Gross_Area_w_o_parking_BGSF__c = Total_GSF - Enclosed_Parking;
                Proj.Number_of_Stops__c = Number_of_stops;
                IF (Total_GSF - Enclosed_Parking == 0) {
                    Proj.Gross_Area_w_o_parking_Efficiency__c = 0;
                }
                ELSE {
                    Proj.Gross_Area_w_o_parking_Efficiency__c = 1.000;
                }
                Proj.Rentable_Area_w_o_parking_RSF__c = Total_RSF - Enclosed_Parking;
                IF (Total_RSF - Enclosed_Parking == 0) {
                    Proj.Rentable_Area_w_o_parking_Efficiency__c = 0;
                }
                ELSE {
                    Proj.Rentable_Area_w_o_parking_Efficiency__c = (Total_RSF - Enclosed_Parking) / (Total_GSF - Enclosed_Parking);
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
    */
}