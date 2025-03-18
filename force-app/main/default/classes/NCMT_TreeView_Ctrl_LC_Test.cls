@isTest
public class NCMT_TreeView_Ctrl_LC_Test {
    
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
        
        
        List <NCMT_Cost_Category__c> listCostCategories = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_DES_Cost_Category2');
        system.debug('listCostCategories'+ listCostCategories[0].Estimate_Format__c);
        
       List <NCMT_DES_Lookup_details__c> lstLookupDetails = Test.loadData(NCMT_DES_Lookup_details__c.sobjectType, 'NCMT_DES_Lookup_details');
        //   List <NCMT_DES_Lookup_details__c> lstLookupDetails = Test.loadData(NCMT_DES_Lookup_details__c.sobjectType, 'NCMT_DES_Lookup_details_2017');
      
        //List <NCMT_DES_Uniformat_Lookup_Detail__c> lstLookupUniDetails = Test.loadData(NCMT_DES_Uniformat_Lookup_Detail__c.sobjectType, 'NCMT_DES_Uniformat_Lookup_details');
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                   and State__c = 'Virginia' and Name = 'State Average'];        
        NCMT_Project__c Proj = new NCMT_Project__c ();

        Proj.Project_type__c = 'New Construction - DES';
        Proj.Estimate_Type_Proj__c  = 'Definitive Estimating';
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

    static testMethod void test_CostCategories()
    {

        list<NCMT_DES_Lookup_details__c> desList = [SELECT Level_2_Description__c, Lvl2Desc__c,
        Level_3_Description__c, Lvl3Desc__c,
        Level_4_Description__c, Lvl4Desc__c,
        Level_5_Description__c, Lvl5Desc__c,
        Level_2__c, Level_2__r.Sort_Order__c,
		Level_2__r.Estimate_Format__c, 
		File_Name__c,
		Fiscal_Year__c
        FROM NCMT_DES_Lookup_details__c];
        system.debug('dlist0'+ desList[0]);
        NCMT_Project__c Proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.debug('Proj: ' + Proj);
        
        NCMT_Tree_Structure__c tree = new NCMT_Tree_Structure__c(Project_ID__c = Proj.id, Estimate_Format__c = 'Master Format');
        insert tree;
        System.debug('Tree: ' + tree);
        
        Test.startTest();
        
            NCMT_TreeView_Ctrl_LC.ESTFormat e = NCMT_TreeView_Ctrl_LC.populateCostCategories(tree.Id);
            System.debug(e);
            
        Test.stopTest();
        
        System.assert(e.estFormat != null && e.descriptionMap != null);
    }
    
    static testMethod void test_populateTreeMaster()
    {
        
        list<NCMT_DES_Lookup_details__c> desList = [SELECT Level_2_Description__c, Lvl2Desc__c,
        Level_3_Description__c, Lvl3Desc__c,
        Level_4_Description__c, Lvl4Desc__c,
        Level_5_Description__c, Lvl5Desc__c,
        Level_2__c, Level_2__r.Sort_Order__c
        FROM NCMT_DES_Lookup_details__c];
        system.debug('des list' + desList);

        Test.startTest();
            
            List<NCMT_TreeView_Ctrl_LC.TreeItem> t = NCMT_TreeView_Ctrl_LC.populateTree('General Requirements', 'Master Format', '2020');
            // List<NCMT_TreeView_Ctrl_LC.TreeItem> t = NCMT_TreeView_Ctrl_LC.populateTree(desList);

            System.debug(t);
        
        Test.stopTest();
        
        System.assert(t.size() > 0);
    }
}