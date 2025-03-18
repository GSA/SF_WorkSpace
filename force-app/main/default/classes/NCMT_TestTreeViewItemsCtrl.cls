@isTest

public class NCMT_TestTreeViewItemsCtrl{
    public static final Date CostParaDate = date.newinstance(2016, 10, 1);
    @isTest static void testTreeViewItems(){      
        //set up test project  data
        
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
        
        
        List <NCMT_Cost_Category__c> listCostCategories = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_DES_Cost_Category');
        system.debug('listCostCategories'+ listCostCategories);
        
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
        system.debug('proj param date' + Proj.Cost_Parameter_Date__c);
        //phase data
        list<NCMT_RA_Phasing__c> phases = [select id from NCMT_RA_Phasing__c where Project__c = :Proj.id ];
        
        string level2desc = listCostCategories[0].Category_Description__c;
        string level3desc = 'Test Level 3';
        string level4desc   = 'Test Level 4';
        string level5desc  = 'Test Level 5';
        //des lookup data
        NCMT_DES_Lookup_details__c  lookup = new NCMT_DES_Lookup_details__c  ();
        lookup.Name = 'General Requirements - 2019 -9'; 
        lookup.Level_2__c = listCostCategories[0].id;
        lookup.Level_3_Description__c = level3desc;
        lookup.Level_4_Description__c  = level4desc;
        lookup.Level_5_Description__c = level5desc;
        lookup.Fiscal_Year__c = '2017';
        insert lookup;
        
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
        item.Quantity__c = 1;
        item.Description__c = 'this is a test';
        item.Unit__c = 'Ea.';
        Id recordTypeId = Schema.getGlobalDescribe().get('NCMT_DES_Items__c').getDescribe().getRecordTypeInfosByName().get('NCMT DES Item Master O&P').getRecordTypeId();
		item.RecordTypeId = recordTypeId;
        item.Material_Unit_Cost__c = 1;
        item.Hourly_Rate__c = 1;
        item.Equipment_Rental_Day__c = 1;
        item.In_house_Unit_Total__c = 3;
        item.O_P_Unit_Total__c = 3;
        item.Waste_Factor__c = 1;
        item.Tree_structure__c = treeList[0].id;
        item.Project_Phasing__c = phases[0].id;
        
        //put items in json format to send to insert method
        List<NCMT_DES_Items__c> itemList = new List<NCMT_DES_Items__c>();
        itemList.add(item);
        string itemJson =  JSON.serialize(itemList);
        
        
        
        // call controller methods and run tests
        NCMT_TreeView_Items_Ctrl_LC.itemWrapper testWrapper = NCMT_TreeView_Items_Ctrl_LC.init(treeId, level2desc, level3desc, level4desc, level5desc, level2desc, estFormat, '' +CostParaDate.year());
        list<NCMT_DES_Lookup_details__c> lookupsList = testWrapper.lookups;
        // system.assertEquals('Phase 1', testWrapper.phaseList[0].Name);
        System.assertEquals('testCM',  testWrapper.crewMasterList[0].Name);
        System.assertNotEquals(NULL, testWrapper.pcsId);
        
        System.assertNotEquals(NULL, testWrapper.lookups);
        system.debug('lookups' + lookupsList[0]);

        NCMT_DES_Lookup_details__c selectedLookup = NCMT_TreeView_Items_Ctrl_LC.getSelectedLoookup(lookupsList[0].Id);
        
        System.assertEquals('General Requirements', selectedLookup.Level_2_Description__c);

        List<NCMT_DES_Items__c> items = NCMT_TreeView_Items_Ctrl_LC.saveItems(itemJson);
        system.assertEquals(1, items.size());
    }
}