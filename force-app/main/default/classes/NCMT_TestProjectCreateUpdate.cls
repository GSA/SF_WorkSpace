@isTest
public class NCMT_TestProjectCreateUpdate {
    static final String strState = 'Virginia';
    static final String strCity = 'State Average';

    @testSetup static void setup()
    {
        //NCMT_TestDataClass.CreateProject('New Construction - DES', 'testDesProjCodeCovOff1','Office',strState,strCity,'Core/Shell only'
       //                                 ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
       NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff1','Office','Virginia','State Average','Core/Shell only'
       ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, true);
       
       NCMT_GenerateProjectDetailsExt.genHPRun = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
    }

    @isTest static void testProjUpdate(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
        proj.Surface_Parking__c = 100;
        //proj.Above_Ground__c = 2;
        NCMT_ProjectTriggerValue.firstRun = true;

        Test.startTest();
        update proj;
    }

    @isTest static void test_RSFOverride(){
        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c, Plumbing_Fixtures__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
        System.assert(proj != null);
        List<NCMT_Housing_Plan_Summary__c> summs = [Select Ground_floor_circulation__c,Atrium_Ground_floor_plan_area__c,Main_Lobby__c,
                    Elevator_lobbies__c,Other_circulation__c,Mechanical_Electrical_IT__c,Loading_dock_Recycling_Trash__c,
                    Restrooms__c,Stair_shafts__c,Conditioned_Core_Area__c,Total_USF__c,Enclosed_Parking__c,Total_GSF__c, Total_RSF__c,
                    Override_RSF__c, Project_USF__c, Project_GF__c, Project_GSF__c, Number_of_stops__c, Atrium_upper_levels_phantom_floors__c,
                    Structural_Area__c, Other_vertical_penetrations__c, Elevator_shafts__c

                    from NCMT_Housing_Plan_Summary__c where Project__c =: proj.Id];
        NCMT_UpdateHousingPlanSummary c = new NCMT_UpdateHousingPlanSummary();
        Test.startTest();
        c.UpdateOverrideRSFData(summs, proj.Id, 'New Construction');
        Test.stopTest();

    }
    
    @isTest static void test_CommonArea (){
      

        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c, Plumbing_Fixtures__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
        System.assert(proj != null);                                                                    
        Test.startTest();
       /* NCMT_ProjectTriggerValue.firstRun = true;
        proj.Plumbing_Fixtures__c = 8;
        update proj;
*/
        List<NCMT_Housing_Plan_Summary__c> summs = [Select Ground_floor_circulation__c,Atrium_Ground_floor_plan_area__c,Main_Lobby__c,Elevator_lobbies__c,Other_circulation__c,Mechanical_Electrical_IT__c,Loading_dock_Recycling_Trash__c,
            Restrooms__c,Stair_shafts__c,Conditioned_Core_Area__c,Total_USF__c,Enclosed_Parking__c,Total_GSF__c 
            from NCMT_Housing_Plan_Summary__c where Project__c =: proj.Id];

        for (NCMT_Housing_Plan_Summary__c s : summs){
            s.Restrooms__c = s.Restrooms__c +1;
        }
        update summs;
        //objUpdateHPSummaryData.UpdateOverrideRSFData(trigger.new, ProjectRecordID, ProjectRecordTypeName);
    }
/*
    @isTest static void testCostTypUpdates(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        proj.Surface_Parking__c = 100;
        NCMT_ProjectTriggerValue.firstRun = true;

        Test.startTest();

        proj.Building_Cost_Type__c = 'TI Only';
        update proj;

        proj.Building_Cost_Type__c = 'TI Including Warm Lit Shell';
        NCMT_GenerateProjectDetailsExt.genHPRun = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        update proj;

        Test.stopTest();

        proj.Building_Cost_Type__c = 'TI Retrofit';
        NCMT_GenerateProjectDetailsExt.genHPRun = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        update proj;
    }
    */

    @isTest static void test_locationUpdate()
    {
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where State__c = :strState and Name <> :strCity][0];

        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
                                                                             
    
        System.assert(proj != null);
        Test.startTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        proj.Location__c = objlocation.Id;
        update proj;
    }

/*    @isTest static void test_phaseUpdate()
    {
       
        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
                                                                             
        Test.startTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        proj.Project_SubPhases__c = 'Final Concept';
        update proj;
    }*/

    @isTest static void test_OverrideSiteAreaUpdate()
    {
        
        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
        System.assert(proj != null);                                                                     
        Test.startTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        proj.Override_Calculated_Site_Area__c = 1000000;
        update proj;
    }

    @isTest static void test_costType1Update()
    {
        
        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
        
        System.assert(proj != null);
        Test.startTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        proj.Building_Cost_Type__c = 'Core/Shell with TI';
        update proj;
    }

    @isTest static void test_costType2Update()
    {
        
        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
        System.assert(proj != null);                                                                    
        Test.startTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        proj.Building_Cost_Type__c = 'TI Only';
        update proj;
    }

    @isTest static void test_costType3Update()
    {
        
        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
        System.assert(proj != null);                                                  
        Test.startTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        proj.Building_Cost_Type__c = 'TI Including Warm Lit Shell';
        update proj;
    }

    @isTest static void test_costType4Update()
    {
        
        NCMT_Project__c proj = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
                                                                                    Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
                                                                                    Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
                                                                                    Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
                                                                                    Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
                                                                                    Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
                                                                                    Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
                                                                                    Project_Area_GSF__c, Include_Exclude_AIA__c, 
                                                                                   CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                                                                   CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                                                                   CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                                                                   CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                                                                   CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                                                             FROM NCMT_Project__c][0];
        System.assert(proj != null);                                                      
        Test.startTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        proj.Building_Cost_Type__c = 'TI Retrofit';
        update proj;
    }
}