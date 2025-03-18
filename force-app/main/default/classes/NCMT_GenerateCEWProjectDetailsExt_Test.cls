@isTest
public class NCMT_GenerateCEWProjectDetailsExt_Test {
    
    @testSetup static void setup()
    {
        Date CostParaDate = date.newinstance(2016, 10, 1);
        Date MidPtConst = date.newInstance(2019, 12, 1);
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
        
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetails = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Lookup_Detail');
        
        List <NCMT_Cost_Category__c> listCostCategoriesGSA = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_Cost_Category_GSA_Assemblies');
       
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetailsGSA = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Master_GSA_Assemblies');
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                   and State__c = 'Virginia' and Name = 'State Average'];        
        NCMT_Project__c Proj = new NCMT_Project__c ();

        Proj.Project_type__c = 'New Construction - CEW';
        Proj.Estimate_Type_Proj__c	= 'Cost Estimating Workbook';
        Proj.Building_Type__c = 'Office';
        Proj.Project_Phases__c ='Design';
        Proj.Project_Status__c= 'Draft';
        Proj.Project_Delivery_Method__c= 'Design-Bid-Build';
        Proj.Mid_Point_of_Construction__c= MidPtConst;
        Proj.Project_SubPhases__c='Final Concept';
        Proj.Name = 'testProjectCEW';
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
        Proj.Housing_Plan__c = false;
        Proj.Project_Status__c = 'Draft';
        Proj.Parking_Deck__c = false;
        Proj.Cost_Parameter_Date__c = CostParaDate;
        Proj.Project_Area_GSF__c = 100;
        Proj.CEW_Item1__c = 50;
        Proj.Include_Exclude_AIA__c = false;
        Proj.CEW_Occupancy_Status__c = 'Fully Vacated Building';
        Proj.Phasing_Plan_Construction__c = '1';
        
        
        insert Proj;
        //Proj.Project_Record_Id__c = Proj.Id;
        //update Proj;
        
        NCMT_Project__c Proj2 = new NCMT_Project__c ();

        Proj2.Project_type__c = 'New Construction - CEW';
        Proj2.Estimate_Type_Proj__c	= 'Cost Estimating Workbook';
        Proj2.Building_Type__c = 'Office';
        Proj2.Project_Phases__c ='Design';
        Proj2.Project_Status__c= 'Draft';
        Proj2.Project_Delivery_Method__c= 'Design-Bid-Build';
        Proj2.Mid_Point_of_Construction__c= MidPtConst;
        Proj2.Project_SubPhases__c='Final Concept';
        Proj2.Name = 'testProjectCEW';
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
        Proj2.Housing_Plan__c = false;
        Proj2.Project_Status__c = 'Draft';
        Proj2.Parking_Deck__c = false;
        Proj2.Cost_Parameter_Date__c = CostParaDate;
        Proj2.Project_Area_GSF__c = 100;
        Proj2.CEW_Item1__c = 50;
        Proj2.Include_Exclude_AIA__c = false;
        Proj2.CEW_Occupancy_Status__c = 'Fully Vacated Building';
        Proj2.Phasing_Plan_Construction__c = '1';
        
        
        insert Proj2;
        
        List<NCMT_Project_Cost_Summary__c> pcs = [SELECT Id, Name, Cost_Category__c FROM NCMT_Project_Cost_Summary__C WHERE Project_Name__c =: Proj.Id];
        
        NCMT_CEW_Project_Agency__c pa = new NCMT_CEW_Project_Agency__c();
        pa.NCMT_Project__c = Proj.Id;
        pa.Agency_Tier__c = '1';
        insert pa;
        
        NCMT_Work_Description__c wd = new NCMT_Work_Description__c();
        wd.NCMT_Project__c = Proj.Id;
        wd.Number__c = '1';
        wd.UOM__c = 'Affected Area - GSF';
        insert wd;
        
        NCMT_CEW_Work_Item__c wi = new NCMT_CEW_Work_Item__c();
        wi.Project_Cost_Summary__c = pcs[0].Id;
        wi.NCMT_CEW_Work_Description__c = wd.Id;
        wi.CEW_Project_Agency__c = pa.Id;
        insert wi;
        
    }
    
    @isTest static void test_cloneCEWProject()
    {
		List<NCMT_Project__c> projList = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
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
                                 FROM NCMT_Project__c];
        
        NCMT_Project__c proj1 = projList[0];
        NCMT_Project__c proj2 = projList[1];
        
        
        
        Test.startTest();
        
        	NCMT_GenerateCEWProjectDetailsExt.insertCloneDetails(proj1.Id, proj2.ID);
        
        Test.stopTest();
        
        proj2 = [SELECT Id, Project_Record_Id__c FROM NCMT_Project__C WHERE Id =: proj2.Id];
        
        System.assertEquals(proj2.Id, proj2.Project_Record_ID__c);
        
        
    }

}