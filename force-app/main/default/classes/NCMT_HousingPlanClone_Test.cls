@isTest
public class NCMT_HousingPlanClone_Test {
    
    @isTest public static void test_HousingPlanClone()
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
        Proj.RecordTypeId = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction').getRecordTypeId();

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
        
        //Core Shell Cost Details
        NCMT_Core_Shell_Cost_Detail__c det = new NCMT_Core_Shell_Cost_Detail__c(Project_Cost_Summary__c = listCostSummary[0].Id);
        insert det;
        
        NCMT_Project__c Proj2 = new NCMT_Project__c();

        Proj2.Project_type__c = 'New Construction';
        Proj2.Estimate_Type_Proj__c = 'Parametric';
        Proj2.Building_Type__c = 'Office';
        Proj2.Project_Delivery_Method__c= 'Design-Bid-Build';
        Proj2.Start_Construction__c = StartConst;
        Proj2.Name = 'NewConstructionTest';
        Proj2.State__c = 'Virginia';
        Proj2.City__c = 'State Average'; 
        Proj2.Purpose_of_Estimate__c = 'Project Controls';
        Proj2.Above_Ground__c = 2;  
        Proj2.Location__c = objlocation.Id;
        Proj2.Below_Ground__c = 0;
        Proj2.Below_grade__c = 0;
        Proj2.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj2.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj2.Building_Quality__c = 'P100: Baseline';        
        Proj2.Level_of_Protection__c = 'Level II - Low';
        Proj2.Remoteness__c = 'Urban';
        Proj2.Gross_Area__c = false;
        Proj2.Useable_Area__c = false;
        Proj2.Housing_Plan__c = true;
        Proj2.Project_Status__c = 'Draft';
        Proj2.Parking_Deck__c = false;
        Proj2.Cost_Parameter_Date__c = CostParaDate;
        Proj2.Project_Record_ID__c = Proj.Id;
        Proj2.RecordTypeId = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction').getRecordTypeId();

        
        Test.startTest();
            insert Proj2;
        Test.stopTest();
        
        List<NCMT_Housing_Plan__c> plans = [SELECT Id FROM NCMT_Housing_Plan__c WHERE Project__c =: Proj2.Id];
        System.assert(plans.size() > 0);
    }

}