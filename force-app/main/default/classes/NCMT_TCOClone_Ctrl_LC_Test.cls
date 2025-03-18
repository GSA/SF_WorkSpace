@isTest
public class NCMT_TCOClone_Ctrl_LC_Test {
    
    @testSetup static void setup()
    {
        Date CostParaDate = date.newinstance(2016, 10, 1);
        Date StartConst = date.newInstance(2020, 6, 1);
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        
        
        insert NCMT_Cust_settings;
        
        List <AE_CMa_CMc_Cx__c> lstAE_CMa_CMc_Cx = Test.loadData(AE_CMa_CMc_Cx__c.sObjectType,'NCMT_AE_CMa_CMc_Cx');
        
        List <Professional_Service_Estimate_Parameter__c> lstProfessional_Service_Estimate_Parameter = Test.loadData(Professional_Service_Estimate_Parameter__c.sObjectType, 'NCMT_Professional_Service_Estimate_Parameter');
        
        List <System_Level_Parameter__c> lstsystemlevelparameter = Test.loadData(System_Level_Parameter__c.sObjectType, 'NCMT_System_Level_Parameter');
        
        List <NCMT_Building_Parameter__c> lstbuilding = Test.loadData(NCMT_Building_Parameter__c.sObjectType, 'NCMT_Building_Parameter');
        
        List <NCMT_Building_Height_Parameter__c> lstbldgheight = Test.loadData(NCMT_Building_Height_Parameter__c.sObjectType, 'NCMT_Building_Height_Parameter');
        
        List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');
        List <NCMT_Quality_Code_Parameter__c> lstqualitycodeparameter = Test.loadData(NCMT_Quality_Code_Parameter__c.sobjectType, 'NCMT_Quality_Code_Parameter');
        
        List <NCMT_Quality_Code_Lookup__c> lstqualitycodelookup = Test.loadData(NCMT_Quality_Code_Lookup__c.sObjectType, 'NCMT_Quality_Code_Lookup');
        
        
        List <NCMT_Cost_Category__c> listCostCategories = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_DES_Cost_Category_Assemblies');
        system.debug('listCostCategories'+ listCostCategories[0].Estimate_Format__c);
        
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetails = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Lookup_Detail2');
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                   and State__c = 'Virginia' and Name = 'State Average'];        
        
        NCMT_Project__c Proj = new NCMT_Project__c ();

        Proj.Project_type__c = 'New Construction';
        Proj.Estimate_Type_Proj__c  = 'Parametric';
        Proj.Building_Type__c = 'Office';
        Proj.Project_Delivery_Method__c= 'Design-Bid-Build';
        Proj.Start_Construction__c = StartConst;
        Proj.Name = 'NewConstructionTest';
        Proj.State__c = 'Virginia';
        Proj.City__c = 'State Average'; 
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Above_Ground__c = 2;   
        Proj.Location__c = objlocation.Id;
        Proj.Below_Ground__c = 0;
        Proj.Below_grade__c = 0;
        Proj.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj.Building_Quality__c = 'P100: Baseline';        
        Proj.Level_of_Protection__c = 'Level II - Low';
        Proj.Remoteness__c = 'Urban';
        Proj.Gross_Area__c = false;
        Proj.Useable_Area__c = false;
        Proj.Housing_Plan__c = true;
        Proj.Project_Status__c = 'Draft';
        Proj.Parking_Deck__c = false;
        Proj.Cost_Parameter_Date__c = CostParaDate;
        Proj.RecordTypeId = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction - TCO').getRecordTypeId();

        insert Proj;
        Proj.Project_Record_Id__c = Proj.Id;
        update Proj;
        
        //create Project Level Parameter to attach to Proj
        Project_Level_Parameter__c plp = new Project_Level_Parameter__c(NCMT_Project__c = Proj.Id);
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = false;
        insert plp;
        
        //Buidling Massing by Floor
        NCMT_Building_Massing_By_Floor__c bMBF = new NCMT_Building_Massing_By_Floor__c(Proj_Level_Parameter__c = plp.Id);
        insert bMBF;
        
        //Project Cost Rate
        NCMT_Project_Cost_Rate__c pcr = new NCMT_Project_Cost_Rate__c(Project_Name__c = Proj.Id);
        insert pcr;
        
        //Housing Plan
        NCMT_Housing_Plan__c hp = new NCMT_Housing_Plan__c();
            hp.Project__c = Proj.Id;
            hp.Housing_Plan_Name__c = 'HousingPlanTest';
            hp.Workstations_open_office_Count__c = 100;
            hp.Closed_offices_Count__c = 10;
            hp.Private_toilets_Count__c = 5;
            hp.Total_USF__c = 1000;
            hp.Total_RSF__c = 1500;
            hp.Total_GSF__c = 2000;
            hp.RecordTypeId = Schema.SObjectType.NCMT_Housing_Plan__c.getRecordTypeInfosByName().get('User Defined').getRecordTypeId();
        insert hp;
        
        //Housing Plan Summary
        NCMT_Housing_Plan_Summary__c hps = new NCMT_Housing_Plan_Summary__c(Project__c = Proj.Id);
        insert hps;
        

        //Site Information
        Site_Information__c site = new Site_Information__c(Project__c = Proj.Id);
        insert site;
        
        //Escalations
        NCMT_Escalation__c e = new NCMT_Escalation__c(Project__c = Proj.Id);
        insert e;
        
        //Get list of Project Cost Summary records inserted with Project
        List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :Proj.Id Limit 1000];
        
        
        //Security Detail
        NCMT_Security_Detail__c sec = new NCMT_Security_Detail__c(Project_Cost_Summary__c = listCostSummary[0].Id, Gross_Sq_Ft__c = 100);
        insert sec;
        
        //TI-TRCS
        NCMT_TI_TRCS_Cost_Detail__c ti = new NCMT_TI_TRCS_Cost_Detail__c(Project_Cost_Summary__c = listCostSummary[0].Id);
        insert ti;
        
        //Additional Cost
        NCMT_TCO_Additional_Cost__c add = new NCMT_TCO_Additional_Cost__c(Project_Name__c = Proj.Id);
        insert add;
        
        //Performance Input
        NCMT_TCO_Performance_Input__c input = new NCMT_TCO_Performance_Input__c(NCMT_Project__c = Proj.Id);
        insert input;
        
        //Core Shell Cost Details
        NCMT_Core_Shell_Cost_Detail__c det = new NCMT_Core_Shell_Cost_Detail__c(Project_Cost_Summary__c = listCostSummary[0].Id);
        insert det;
        
        //Annual Cost Summary
        NCMT_TCO_Annual_Cost_Summary__c acs = new NCMT_TCO_Annual_Cost_Summary__c(Project_Name__c = Proj.Id);
        insert acs;
        
        //Other Cost
        NCMT_Other_Cost__c oc = new NCMT_Other_Cost__c(NCMT_Project__c = Proj.Id);
        insert oc;
        
        //Other Direct Cost
        NCMT_Other_Direct_Cost__c odc = new NCMT_Other_Direct_Cost__c(Project_Cost_Summary__c = listCostSummary[0].Id, NCMT_Other_Cost__c = oc.Id);
        insert odc;
        
        //HP Level of Service
        NCMT_TCO_HP_Level_of_Service__c los = new NCMT_TCO_HP_Level_of_Service__c(Project_Name__c = Proj.Id, NPV_Summary__c = acs.Id, TCO_Cost_Rates__c = pcr.Id, TCO_Performance_Input__c = input.Id, Run_Workflow__c = true);
        insert los;
        
        //Lifecycle
        NCMT_TCO_Lifecycle_Input__c life = new NCMT_TCO_Lifecycle_Input__c(NCMT_Project__c = Proj.Id, Design__c = 10, Period_of_Analysis__c = 5, Planning_and_Pre_design__c = 12);
        insert life;
        
        //TCO LCC
        NCMT_TCO_LCC__c lcc = new NCMT_TCO_LCC__c(NCMT_Project__c = Proj.Id, TCO_Lifecycle_Input__c = life.Id, Year__c = 2020);
        insert lcc;
    }
    
    @isTest public static void test_TCOClone_LC()
    {
        NCMT_Project__C proj = [SELECT Id, Project_Record_Id__c, Total_Project_Cost_Aggregate__c FROM NCMT_Project__c LIMIT 1];
        NCMT_Project__c proj2 = new NCMT_Project__c();
        
        Test.startTest();
            proj2 = NCMT_TCOClone_Ctrl_LC.getProject(proj.Id);
            String projString = JSON.serialize(proj2);
            NCMT_TCOClone_Ctrl_LC.cloneTCOProject(projString);
        Test.stopTest();
        
        System.assertEquals(proj.Total_Project_Cost_Aggregate__c, proj2.Total_Project_Cost_Aggregate__c);
    }
    
    @isTest public static void test_TCOClone_Error()
    {
        NCMT_Project__C proj = [SELECT Id, Project_Record_Id__c, Total_Project_Cost_Aggregate__c, Start_Construction__c, End_Construction__c FROM NCMT_Project__c LIMIT 1];
        NCMT_Project__c proj2 = new NCMT_Project__c();
        
        try {
            proj2 = NCMT_TCOClone_Ctrl_LC.getProject(proj.Id);
            proj2.Project_Record_ID__c = '';
            proj2.End_Construction__c = date.newInstance(2020, 6, 1);
            String projString = JSON.serialize(proj2);
            NCMT_TCOClone_Ctrl_LC.cloneTCOProject(projString);
        }
        catch(Exception e)
        {
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }

}