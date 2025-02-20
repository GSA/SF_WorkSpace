global with sharing class NCMT_HousingPlanTriggerHelper
{
    @future
    public static void insertHousingPlanSummaryFuture(Id PIds, String ProjectRecordTypeName, String ProjectType, decimal TICostAdjusted, String triggerEvent, Id HPRecordID)
    { 
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
		
		housingPlanAfterInsert(PIds,ProjectRecordTypeName,ProjectType,TICostAdjusted,triggerEvent,HPRecordID);
    }
	
	
	public static void housingPlanAfterInsert(Id ProjectRecordID, String ProjectRecordType, String Project_Type, decimal TICostAdjusted, String triggerEvent, Id HPRecordID){
		if(Project_Type == 'Repair & Alteration - Work Item Detail'){
			//insert default work item after creation of housing p lan record    
			list<NCMT_RA_Work_Items__c> RAWIlst = new list<NCMT_RA_Work_Items__c>();
			
			string  strRAWIRecordTypeName = Schema.SObjectType.NCMT_RA_Work_Items__c.getRecordTypeInfosByName().get('RA Work Items Space Plan').getRecordTypeId();
			
			list<NCMT_Project_Cost_Summary__c> ProjCostSumlst = [SELECT Id, TI_Cost_Adjusted__c FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c = :ProjectRecordID and Cost_Category_Description__c = 'Interior Construction - Space Plans'];
			ID ProjCostSumID = ProjCostSumlst[0].id;
			TICostAdjusted = ProjCostSumlst[0].TI_Cost_Adjusted__c;
			
			list<NCMT_RA_Phasing__c>  RAPhasinglst =  [SELECT Id FROM NCMT_RA_Phasing__c WHERE Project__c = :ProjectRecordID and Work_Conditions__c = 'Fully vacant building'];
			
			list<NCMT_Housing_Plan__c> hplst = [SELECT Id, Total_USF__c FROM NCMT_Housing_Plan__c WHERE ID = :HPRecordID ];
							
			if(triggerEvent == 'insert'){
				RAWIlst.Add(new NCMT_RA_Work_Items__c(
					Housing_Plan__c = HPRecordID,
					Work_Item_Type_ID__c = ProjCostSumlst[0].id,
					Work_Item_Phase__c = RAPhasinglst[0].id,
					Quantity_SF__c  = hplst[0].Total_USF__c,
					Rate__c = TICostAdjusted/hplst[0].Total_USF__c,
					RecordTypeID = strRAWIRecordTypeName,
					Cost_Allocation_GSA__c = 0
					));
 
					insert RAWIlst;
			}else if(triggerEvent == 'update'){
			   NCMT_RA_Work_Items__c NCMTRAWI = [Select ID, Quantity_SF__c, Rate__c from NCMT_RA_Work_Items__c where Housing_Plan__c = :HPRecordID];
			   
			   NCMTRAWI.Quantity_SF__c  = hplst[0].Total_USF__c;
			   NCMTRAWI.Rate__c = TICostAdjusted/hplst[0].Total_USF__c;
			   
			   update NCMTRAWI;
			}
			NCMT_GenerateProjectDetails objGenerateData = new NCMT_GenerateProjectDetails(); 
			objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordType,'update',0);
		}
	}
}