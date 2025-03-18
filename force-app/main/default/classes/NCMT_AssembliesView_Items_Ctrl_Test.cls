@isTest
public class NCMT_AssembliesView_Items_Ctrl_Test {
    public static Date CostParaDate = date.newinstance(2016, 10, 1);
    @testSetup static void setup()
    {
        
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
    
    @isTest static void test_Init()
    {   
        NCMT_Project__c Proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.debug('Proj: ' + Proj);
        
        NCMT_Tree_Structure__c tree = new NCMT_Tree_Structure__c(Project_ID__c = Proj.id, Estimate_Format__c = 'Uniformat');
        insert tree;
        System.debug('Tree: ' + tree);
        
        NCMT_Assembly_Lookup_detail__c lookup = [SELECT Description__c,
                               							Level_2__c, Level_2_Description__c,Level_3__c, Level_3_Description__c, 
                               							Level_4__c,Level_4_Description__c, Level_5__c,Level_5_Description__c
                                                 FROM NCMT_Assembly_Lookup_Detail__c 
                                                 WHERE File_Type__c != 'GSAAssemblies'
                                                 LIMIT 1];
        
        // call controller methods and run tests
        Test.startTest();
        
        	NCMT_AssembliesView_Items_Ctrl_LC.itemWrapper wrapper = 
                		NCMT_AssembliesView_Items_Ctrl_LC.init(tree.Id, lookup.Level_2_Description__c, lookup.Level_3_Description__c,
                                                               lookup.Level_4_Description__c, lookup.Level_2_Description__c, 'Uniformat', lookup.Level_2__c, '' +CostParaDate.year());
        
        	
        
        Test.stopTest();
        
        System.assert(wrapper != null);

        wrapper = NCMT_AssembliesView_Items_Ctrl_LC.init(null, lookup.Level_2_Description__c, lookup.Level_3_Description__c,
                                                               lookup.Level_4_Description__c, lookup.Level_2_Description__c, 'Uniformat', lookup.Level_2__c, '' +CostParaDate.year());
        System.assert(wrapper != null);
    }
    
    @isTest static void test_InitGSA()
    {   
        NCMT_Project__c Proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.debug('Proj: ' + Proj);
        
        NCMT_Tree_Structure__c tree = new NCMT_Tree_Structure__c(Project_ID__c = Proj.id, Estimate_Format__c = 'Uniformat');
        insert tree;
        System.debug('Tree: ' + tree);
        
        NCMT_Assembly_Lookup_detail__c lookup = [SELECT Description__c,
                               							Level_2__c, Level_2_Description__c,Level_3__c, Level_3_Description__c, 
                                                           Level_4__c,Level_4_Description__c, Level_5__c,Level_5_Description__c,
                                                           Level_6_Description__c, Level_6__c
                                                 FROM NCMT_Assembly_Lookup_Detail__c 
                                                 WHERE File_Type__c = 'GSAAssemblies'
                                                 LIMIT 1];
        
        // call controller methods and run tests
        Test.startTest();
        
        NCMT_AssembliesView_Items_Ctrl_LC.itemWrapper wrapper = 
                    NCMT_AssembliesView_Items_Ctrl_LC.initGSA(tree.Id, lookup.Level_2_Description__c, lookup.Level_3_Description__c,
                                                            lookup.Level_4_Description__c, lookup.Level_5_Description__c, lookup.Level_6_Description__c, lookup.Level_2_Description__c, 'GSA Assemblies', '' +CostParaDate.year());
        
        Test.stopTest();
        
        System.assert(wrapper != null);

        wrapper = NCMT_AssembliesView_Items_Ctrl_LC.initGSA(tree.Id, lookup.Level_2_Description__c, null,
                                                            null, null, null, lookup.Level_2_Description__c, 'GSA Assemblies', '' +CostParaDate.year());
        System.assert(wrapper != null);
    }
    
    @isTest static void test_Select()
    {
		NCMT_Assembly_Lookup_detail__c lookup = [SELECT Id FROM NCMT_Assembly_Lookup_detail__c LIMIT 1];
        
        Test.startTest();
        
        	NCMT_Assembly_Lookup_detail__c selected = NCMT_AssembliesView_Items_Ctrl_LC.getSelectedLoookup(lookup.Id);
        
        Test.stopTest();
        
        System.assert(selected != null);
    }
    
    @isTest static void test_Save()
    {
        NCMT_Project__c Proj = [SELECT Id FROM NCMT_Project__c LIMIT 1];
        
        //phase data
        list<NCMT_RA_Phasing__c> phases = [select id from NCMT_RA_Phasing__c where Project__c = :Proj.id ];
        
        //project cost summary data
        list<NCMT_Project_Cost_Summary__c> pcs = [select id, Estimate_Format__c, Cost_Category_Description__c from NCMT_Project_Cost_Summary__c  where Project_Name__c = :Proj.id]; 
        for(NCMT_Project_Cost_Summary__c pc : pcs){
            system.debug('156 est format ****' + pc.Estimate_Format__c);
            system.debug('Cost_Category_Description__c +++++' + pc.Cost_Category_Description__c);

        }
        //tree structure data
        list<NCMT_Tree_structure__c> treeList = [select id,  Relatedtree__c, Relatedtree__r.Name, SortOrdertxt__c, Estimate_Format__c, Name from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];
        string treeId = treeList[0].id;
        string estFormat = treeList[0].Estimate_Format__c;
        
        //crew master data
        NCMT_Crew_Master__c crewMaster = new NCMT_Crew_Master__c();
        crewMaster.Name = 'testCM';
        crewMaster.Description__c = 'testCM';
        insert crewMaster;
        
        //des items 
        NCMT_DES_Items__c item = new NCMT_DES_Items__c ();
        item.Project_Cost_Summary_ID__c = pcs[0].id;
        item.Cost_Type__c = 'Security';
        item.Quantity__c =1;
        item.Description__c = 'this is a test';
        item.Unit__c = 'Ea.';   
        item.Waste_Factor__c = 1;
        item.Equipment_Rental_Day__c =1;
        item.Tree_structure__c = treeList[0].id;
        item.Project_Phasing__c = phases[0].id;
        
        
        //put items in json format to send to insert method
       	/*NCMT_DES_Items__c item = [SELECT Name, Description__c, Unit__c, Quantity__c, Cost_Type__c,
                                      			Project_Cost_Summary_ID__c, Waste_Factor__c, Tree_structure__c,
                                            	Equipment_Rental_Day__c, Project_Phasing__c
                                      FROM NCMT_DES_Items__c LIMIT 1];*/
        
        List<NCMT_DES_Items__c> itemList = new List<NCMT_DES_Items__c>();
        itemList.add(item);
        
        string itemJson =  JSON.serialize(itemList);
        System.debug(itemJson);
        
        Test.startTest();
        
        	List<NCMT_DES_Items__c> toSave = NCMT_AssembliesView_Items_Ctrl_LC.saveItems(itemJson);
        
        Test.stopTest();
        
        System.assert(toSave != null);
    }
    
    @isTest static void test_SaveGSA()
    {
        NCMT_Project__c Proj = [SELECT Id FROM NCMT_Project__c LIMIT 1];
        
        //phase data
        list<NCMT_RA_Phasing__c> phases = [select id from NCMT_RA_Phasing__c where Project__c = :Proj.id ];
        
        //project cost summary data
        list<NCMT_Project_Cost_Summary__c> pcs = [select id from NCMT_Project_Cost_Summary__c  where Project_Name__c = :Proj.id];       
        //tree structure data
        list<NCMT_Tree_structure__c> treeList = [select id,  Relatedtree__c, Relatedtree__r.Name, SortOrdertxt__c, Estimate_Format__c, Name from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];
        string treeId = treeList[0].id;
        string estFormat = treeList[0].Estimate_Format__c;
        
        //crew master data
        NCMT_Crew_Master__c crewMaster = new NCMT_Crew_Master__c();
        crewMaster.Name = 'testCM';
        crewMaster.Description__c = 'testCM';
        insert crewMaster;
        
        //des items 
        NCMT_DES_Items__c item = new NCMT_DES_Items__c ();
        item.Project_Cost_Summary_ID__c = pcs[0].id;
        item.Cost_Type__c = 'Security';
        item.Quantity__c =1;
        item.Description__c = 'this is a test';
        item.Unit__c = 'Ea.';   
        item.Waste_Factor__c = 1;
        item.Equipment_Rental_Day__c =1;
        item.Tree_structure__c = treeList[0].id;
        item.Project_Phasing__c = phases[0].id;
        item.MinID__c = '090505309000';
        item.Minimum_Cost__c = 129;
        item.Labor_Cost__c = 21;
        insert item;
        
        NCMT_DES_Items__c item2 = new NCMT_DES_Items__c ();
        item2.Project_Cost_Summary_ID__c = pcs[0].id;
        item2.Cost_Type__c = 'Security';
        item2.Quantity__c =1;
        item2.Description__c = 'this is a test';
        item2.Unit__c = 'Ea.';   
        item2.Waste_Factor__c = 1;
        item2.Equipment_Rental_Day__c =1;
        item2.Tree_structure__c = treeList[0].id;
        item2.Project_Phasing__c = phases[0].id;
        item2.MinID__c = '090505309000';
        item2.Minimum_Cost__c = 129;
        item2.Labor_Cost__c = 10;
        
        NCMT_DES_Items__c item3 = new NCMT_DES_Items__c ();
        item3.Project_Cost_Summary_ID__c = pcs[0].id;
        item3.Cost_Type__c = 'Security';
        item3.Quantity__c =1;
        item3.Description__c = 'this is a test';
        item3.Unit__c = 'Ea.';   
        item3.Waste_Factor__c = 1;
        item3.Equipment_Rental_Day__c =1;
        item3.Tree_structure__c = treeList[0].id;
        item3.Project_Phasing__c = phases[0].id;
        item3.MinID__c = '080505109000';
        item3.Minimum_Cost__c = 129;
        item3.Labor_Cost__c = 10;
        
        NCMT_DES_Items__c item4 = new NCMT_DES_Items__c ();
        item4.Project_Cost_Summary_ID__c = pcs[0].id;
        item4.Cost_Type__c = 'Security';
        item4.Quantity__c =1;
        item4.Description__c = 'this is a test';
        item4.Unit__c = 'Ea.';   
        item4.Waste_Factor__c = 1;
        item4.Equipment_Rental_Day__c =1;
        item4.Tree_structure__c = treeList[0].id;
        item4.Project_Phasing__c = phases[0].id;
        item4.MinID__c = '090505309000';
        item4.Minimum_Cost__c = 129;
        item4.Labor_Cost__c = 10;
        
        List<NCMT_DES_Items__c> itemList = new List<NCMT_DES_Items__c>();
        itemList.add(item2);
        itemList.add(item3);
        itemList.add(item4);
        
        string itemJson =  JSON.serialize(itemList);
        System.debug(itemJson);
        
        Test.startTest();
        
        	List<NCMT_DES_Items__c> toSave = NCMT_AssembliesView_Items_Ctrl_LC.saveItemsGSA(itemJson, treeList[0].id);
        
        Test.stopTest();
        
        System.assert(toSave != null);
    }
    
    @isTest static void test_Total()
    {
		List<NCMT_Assembly_Lookup_detail__c> lookups = [SELECT Description__c,
                               							Level_2__c, Level_2_Description__c,Level_3__c, Level_3_Description__c, 
                               							Level_4__c,Level_4_Description__c, Level_5__c,Level_5_Description__c 
                                                 FROM NCMT_Assembly_Lookup_Detail__c ];
        
        String level2desc = lookups[0].Level_2_Description__c;
        String level3desc = lookups[0].Level_3_Description__c;
        String level4desc = lookups[0].Level_4_Description__c;
        
        Test.startTest();
        
        	Integer total = NCMT_AssembliesView_Items_Ctrl_LC.getLookupTotal(level2desc, level3desc, level4desc);
        
        Test.stopTest();
        
        System.assertEquals(24, total);
    }
}