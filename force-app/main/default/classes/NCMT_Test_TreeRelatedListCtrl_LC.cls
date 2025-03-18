@isTest
public class NCMT_Test_TreeRelatedListCtrl_LC{
    
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

         NCMT_Project__c p = new NCMT_Project__c ( Name = 'Test Project' );  
         NCMT_TreeRelatedListCtrl_LC projTest = new NCMT_TreeRelatedListCtrl_LC( new ApexPages.StandardController( p ) ); 

         insert Proj;
        
        NCMT_Project_Cost_Summary__c ProjCostSummary =[Select id, Project_Name__c 
                                From NCMT_Project_Cost_Summary__c 
                                Where Project_Name__c =:Proj.id limit 1];
        
         NCMT_DES_Items__c DESItem = new NCMT_DES_Items__c();
        	DESItem.Project_Cost_Summary_ID__c   = ProjCostSummary.id;
            DESItem.Item_Type__c = 'Master Format';
            DESItem.Hourly_Rate__c = 50;
            DESItem.Quantity__c =100;
            DESItem.NCMT_Project_Location__c ='Virginia';
            DESItem.Include_In_Estimate__c = true;    
            
            insert DESItem;
    }
    
    @isTest static void testTreeRelatedList(){   
        NCMT_Project__C proj = [SELECT Id FROM NCMT_Project__C LIMIT 1];
        
        list<NCMT_Tree_structure__c> treeList = [select id,  Relatedtree__c, Relatedtree__r.Name, SortOrdertxt__c, Name from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];
    
         NCMT_TreeRelatedListCtrl_LC.projectWrapper testWrap = NCMT_TreeRelatedListCtrl_LC.init(Proj.id);
 
         system.assertNotEquals(NULL, testWrap.project);
         system.assertNotEquals(NULL, testWrap.treeStruc);
         
     }
    
    @isTest static void testCopyPasteDeleteTrees()
    { 
        NCMT_Project__C proj = [SELECT Id FROM NCMT_Project__C LIMIT 1];
        list<NCMT_Tree_structure__c> treeList = [select id,  Relatedtree__c, Relatedtree__r.Name, SortOrdertxt__c, Name from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];

        Test.startTest();
        //Copy tree structure
        List<NCMT_Copy__c> copies = NCMT_TreeRelatedListCtrl_LC.copyTrees(treeList);
        system.assertNotEquals(NULL, copies);
        
        //Paste Tree Structure
        NCMT_TreeRelatedListCtrl_LC.getTreeData(proj.Id, true);
        NCMT_TreeRelatedListCtrl_LC.pasteTrees(copies, treeList[0].Id, proj.Id);
        treeList = [select id, SortOrdertxt__c from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];
        System.assertEquals(2, treeList.size());
        
        //Delete Tree Structure
        List<Id> toDelete = new List<Id>();
        for(NCMT_Tree_Structure__c t : treeList)
        {
            if(t.SortOrdertxt__c != '01')
                toDelete.add(t.Id);
        }
            
        NCMT_TreeRelatedListCtrl_LC.deleteTrees(toDelete);
        treeList = [select id, SortOrdertxt__c from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];
        System.assertEquals(1, treeList.size());
        Test.stopTest();
    }
    
    @isTest static void testDESItem_init()
    {
        NCMT_Project__C proj = [SELECT Id FROM NCMT_Project__C LIMIT 1];
        list<NCMT_Tree_structure__c> treeList = [select id,  Relatedtree__c, Relatedtree__r.Name, SortOrdertxt__c, Name from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];
		
        Test.startTest();
        NCMT_TreeRelatedListCtrl_LC.projectWrapper testWrap = NCMT_TreeRelatedListCtrl_LC.getDESItemData(treeList[0].Id);
        Test.stopTest();
    }
    
    @isTest static void testCopyPasteDelete_desItems()
    {
        NCMT_Project__C proj = [SELECT Id FROM NCMT_Project__C LIMIT 1];
        list<NCMT_Tree_structure__c> treeList = [select id,  Relatedtree__c, Relatedtree__r.Name, SortOrdertxt__c, Name from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];
		
        List<NCMT_DES_Items__c> items = [SELECT Id FROM NCMT_DES_Items__c LIMIT 1];
        for(NCMT_DES_Items__c i : items)
        	i.Tree_Structure__C =  treeList[0].Id;
        update items;
        
        Test.startTest();
        //Copy DES Item
        List<NCMT_Copy__c> copies = NCMT_TreeRelatedListCtrl_LC.copyDESItems(items);
        System.assertNotEquals(NULL, copies);
        
        //Paste DES Item
        NCMT_TreeRelatedListCtrl_LC.pasteDESItems(copies, treeList[0].Id, proj.Id, 0.90);
        List<NCMT_DES_Items__c> newItems = [SELECT Id FROM NCMT_DES_Items__C WHERE Tree_Structure__C =: treeList[0].Id];
        System.assertEquals(2, newItems.size());
        
        //Delete DES Item
        NCMT_TreeRelatedListCtrl_LC.deleteDESItems(newItems);
        newItems = [SELECT Id FROM NCMT_DES_Items__C WHERE Tree_Structure__C =: treeList[0].Id];
        System.assertEquals(0, newItems.size());
            
        Test.stopTest();
    }
    
    @isTest static void testDeleteCopies()
    {
        NCMT_Project__C proj = [SELECT Id FROM NCMT_Project__C LIMIT 1];
        list<NCMT_Tree_structure__c> treeList = [select id,  Relatedtree__c, Relatedtree__r.Name, SortOrdertxt__c, Name from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];

        Test.startTest();
        
        //Copy tree structure and delete copy
        List<NCMT_Copy__c> copies = NCMT_TreeRelatedListCtrl_LC.copyTrees(treeList);
        NCMT_TreeRelatedListCtrl_LC.deleteCopies(copies);
        copies = NCMT_TreeRelatedListCtrl_LC.getTreeCopies();
        System.assertEquals(0, copies.size());
    }
    
    // Below method added to cover changes made on class for SFWS-1775
     @isTest static void testUpdateDesLineItems()
     {
        
         List<NCMT_DES_Items__c> items = [SELECT Id FROM NCMT_DES_Items__c LIMIT 1];
         List<NCMT_DES_Items__c> updatedItems = new List<NCMT_DES_Items__c>();
         Test.startTest();
         List<NCMT_DES_Items__c> itemsToUpdate =new List<NCMT_DES_Items__c>();
           for(NCMT_DES_Items__c i :items ){
              i.Quantity__c = 20;
              itemsToUpdate.add(i);
         }
       updatedItems= NCMT_TreeRelatedListCtrl_LC.updateDesLineItems(itemsToUpdate);
       NCMT_DES_Items__c item = updatedItems[0];
       System.assertEquals(20,item.Quantity__c );
     }

}