@isTest
public class NCMT_TreeStructure_CostSelection_Test {
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
        listCostCategories[0].Estimate_Format__c = 'Master Format';
        update listCostCategories[0];
        
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetails = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Lookup_Detail');
        NCMT_DES_Lookup_details__c  lookup = new NCMT_DES_Lookup_details__c  ();
        lookup.Name = 'General Requirements - 2019 -9'; 
        lookup.Level_2__c = listCostCategories[0].id;
        lookup.Level_3_Description__c = 'Test Level 3';
        lookup.Level_4_Description__c  = 'Test Level 4';
        lookup.Level_5_Description__c = 'Test Level 5';
        lookup.Fiscal_Year__c = '2016';
        insert lookup;

        List <NCMT_Cost_Category__c> listCostCategoriesGSA = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_Cost_Category_GSA_Assemblies');
       
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetailsGSA = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Master_GSA_Assemblies');
        

        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                   and State__c = 'Virginia' and Name = 'State Average'];        
        NCMT_Project__c Proj = new NCMT_Project__c ();

        Proj.Project_type__c = 'New Construction - DES';
        Proj.Estimate_Type_Proj__c	= 'Definitive Estimating';
        Proj.Building_Type__c = 'Office';
        Proj.Project_Phases__c ='Design';
        Proj.Project_Status__c= 'Draft';
        Proj.Project_Delivery_Method__c= 'Design-Bid-Build';
        Proj.Mid_Point_of_Construction__c= MidPtConst;
        Proj.Project_SubPhases__c='Final Concept';
        Proj.Name = 'testProjectDes';
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

        insert Proj;
    }
    
    static testMethod void test_Me(){
        Test.startTest();
        NCMT_Project__c Proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        NCMT_Tree_Structure__c parent = [SELECT Id FROM NCMT_Tree_Structure__C WHERE Project_Id__c =: proj.Id];
        
        NCMT_Tree_Structure__c tree = new NCMT_Tree_Structure__c();
        tree.Project_ID__c = proj.Id;
        tree.Branch_Name__c = 'Branch1';
        tree.Relatedtree__c = parent.Id;
        insert tree;

        List <NCMT_Cost_Category__c> costCategories = [Select Id from NCMT_Cost_Category__c where Estimate_Format__c = 'GSA Assemblies'];
       
        //update costCategories;

        NCMT_Assembly_Lookup_Detail__c assLook = new NCMT_Assembly_Lookup_Detail__c();
        assLook.Name = 'General Requirements - 2016';
        assLook.Level_2__c = costCategories[1].id;
        assLook.Level_3_Description__c = 'Test level 3';
        assLook.Level_4_Description__c = 'Test level 4';
        assLook.Level_5_Description__c = 'Test level 5';
        assLook.Fiscal_Year__c = '2016';
        assLook.File_Type__c = 'GSAAssemblies';
        insert assLook;

        NCMT_Assembly_Lookup_Item__c item = new NCMT_Assembly_Lookup_Item__c(
            Assembly_Lookup_Detail__c = assLook.Id,
            File_Name__c = 'GSAAssemblies',
            Fiscal_Year__c = '2016',
            Master_Format_Line_Item_Number__c = 'Test',
            Quantity__c = 0,
            Material_Unit_Cost__c = 1,
            Labor_Hours_F__c = 0,
            Installation_Cost__c = 20,
            Equipment_Unit_Cost__c = 30,
            Conversion_Factor__c = 1
        );
        insert item;

        List<Id> searchIds = new List<Id>();
        searchIds.add(item.Id);
        searchIds.add(assLook.Id);

        for (NCMT_DES_Lookup_details__c d : [Select Id from NCMT_DES_Lookup_details__c Limit 1])
            searchIds.add(d.Id);

        Test.setFixedSearchResults(searchIds);

        NCMT_TreeNode treeNode = NCMT_TreeStructure_CostSelection.treeMe(1, tree.Id, '2016', null, 'GSAAssemblies');
        System.assertEquals(5, treeNode.branches.size());

        String sosl = 'FIND \'*Test*\' IN ALL FIELDS RETURNING NCMT_Assembly_Lookup_Detail__c (Id, Level_2__c, Level_2__r.Estimate_Format__c WHERE  Fiscal_Year__c = \'2016\' AND File_Type__c = \'GSAAssemblies\'), NCMT_Assembly_Lookup_Item__c (Id, Assembly_Lookup_Detail__c, Assembly_Lookup_Detail__r.Level_2__c, Master_Format_Line_Item_Number__c WHERE Assembly_Lookup_Detail__r.File_Type__c = \'GSAAssemblies\' AND Assembly_Lookup_Detail__r.Fiscal_Year__c = \'2016\')';

        List<List<SObject>> searchList = search.query(sosl);

        List<NCMT_Assembly_Lookup_Detail__c> masters = Database.query('Select Id, Level_2__c, Level_2__r.Estimate_Format__c from NCMT_Assembly_Lookup_Detail__c WHERE  Fiscal_Year__c = \'2016\' AND File_Type__c = \'GSAAssemblies\'');
        System.debug('masters ==== ' +searchList[0].size() +' items ==== ' +searchList[1].size());

        treeNode = NCMT_TreeStructure_CostSelection.treeMe(1, tree.Id, '2016', 'Test', 'GSAAssemblies');

        treeNode = NCMT_TreeStructure_CostSelection.treeMe(2, costCategories[1].Id, '2016',null, 'GSAAssemblies');

        treeNode = NCMT_TreeStructure_CostSelection.treeMe(1, tree.Id, '2016', null, 'GSA_ 2020 FAC_ASMDES.xlsx');
        
        treeNode = NCMT_TreeStructure_CostSelection.treeMe(2, 'Test level 1', '2016', null, 'GSA_ 2020 ASMDESC.xlsx');

        Test.setFixedSearchResults(searchIds);
        treeNode = NCMT_TreeStructure_CostSelection.treeMe(1, tree.Id, '2016', 'Level', 'RSM FCC');
        treeNode = NCMT_TreeStructure_CostSelection.treeMe(3, 'Test level 2', '2016', null, 'RSM FCC');


        ApexPages.StandardController ctrl = new ApexPages.StandardController(tree);
        NCMT_TreeStructure_CostSelection express = new NCMT_TreeStructure_CostSelection(ctrl);

        NCMT_GSAExpressMenu_LC oldGSA = new NCMT_GSAExpressMenu_LC(ctrl);
        
    }
}