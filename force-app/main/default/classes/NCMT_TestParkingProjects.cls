@isTest
public class NCMT_TestParkingProjects {
    @testSetup static void setup()
    {
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG1', 'Virginia','State Average', 'Urban', 
                                                    'Parking Deck', 'Speed Ramp', 'Medium Efficiency', 'Medium',
                                                    3000, 2, 0, false);
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_ProjectTriggerValue.firstRun = true;
    }

    @isTest static void test_AddHP()
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
                                                FROM NCMT_Project__c ORDER By CreatedDate DESC][0];
                                               
        System.assert(proj != null);
        NCMT_Housing_Plan__c hp = new NCMT_Housing_Plan__c();
        hp.Project__c = proj.Id;
        hp.Housing_Plan_Name__c = 'HousingPlanTest';
        hp.Workstations_open_office_Count__c = 100;
        hp.Closed_offices_Count__c = 10;
        hp.Private_toilets_Count__c = 5;
        hp.Total_USF__c = 1000;
        hp.Total_RSF__c = 1500;
        hp.Total_GSF__c = 2000;
        hp.RecordTypeId = Schema.SObjectType.NCMT_Housing_Plan__c.getRecordTypeInfosByName().get('User Defined').getRecordTypeId();
        insert hp;
    }

    @isTest static void test_parkingUpdate()
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
                                                FROM NCMT_Project__c ORDER By CreatedDate DESC][0];
        
        System.assert(proj != null);
        NCMT_ProjectTriggerValue.firstRun = true;
        proj.Number_of_Spaces__c = 666;
        
        Test.startTest();
        update proj;  
    }

    @isTest static void test_parkingUpdate2(){
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
                                                FROM NCMT_Project__c ORDER By CreatedDate DESC][0];

        System.assert(proj != null);
        Test.startTest();
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c;
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        NCMT_Project__c Projupd2 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
        NCMT_ProjectTriggerValue.firstRun = true;
        Date ConstDate2 = date.newinstance(2023, 1, 1);
        //NCMT_ProfSevEstTriggerValue.firstRun = true;
        
        Projupd2.Id = Proj.id;
        Projupd2.Number_of_Spaces__c = 4000;
        Projupd2.Set_Aside_100__c = true;
        Projupd2.Start_Construction__c = ConstDate2;
        Projupd2.End_Construction__c = null;
        
        update Projupd2;
        system.assertNotEquals(NULL,Projupd2);  
    }
    
}