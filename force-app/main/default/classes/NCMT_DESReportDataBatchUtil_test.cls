@isTest
public class NCMT_DESReportDataBatchUtil_test {
    
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
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c;
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        NCMT_Project__c Proj = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('New Construction - DES').getRecordTypeId());
        
        //NCMT_Project__c Proj = new NCMT_Project__c ();

        Proj.Project_type__c = 'New Construction - DES';
        Proj.Estimate_Type_Proj__c	= 'Definitive Estimating';
        Proj.Building_Type__c = 'Office';
        Proj.Project_Phases__c ='Design';
        Proj.Project_Status__c= 'Draft';
        Proj.Project_Delivery_Method__c= 'IDIQ-JOC';
        Proj.Mid_Point_of_Construction__c= MidPtConst;
        Proj.Project_SubPhases__c='Final Concept';
        Proj.Name = 'testProjectDesOP';
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
        Proj.Markup_Method__c = 'RSMeans - O&P';

        insert Proj;
        system.assertNotEquals(NULL,Proj); 
        
        list<NCMT_RA_Phasing__c> phases = [select id from NCMT_RA_Phasing__c where Project__c = :Proj.id ];

        list<NCMT_Project_Cost_Summary__c> pcs = [select id from NCMT_Project_Cost_Summary__c  where Project_Name__c = :Proj.id];        
                        
        list<NCMT_Project_Markup__c> markupList = [select id, Name from NCMT_Project_Markup__c where Project_Name__c = :Proj.id];
        
        list<NCMT_Tree_structure__c> treeList = [select id,  Relatedtree__c, Relatedtree__r.Name, SortOrdertxt__c, Name from  NCMT_Tree_structure__c where Project_ID__c = :Proj.id];
        
		NCMT_DES_Items__c item = new NCMT_DES_Items__c ();
        item.Project_Cost_Summary_ID__c = pcs[0].id;
        item.Cost_Type__c = 'Security';
        item.Quantity__c =1000;
        item.Description__c = 'this is a test';
        item.Unit__c = 'Ea.';   
        item.Waste_Factor__c = 1;
        //item.Equipment_Rental_Day__c =1000;
        item.Tree_structure__c = treeList[0].id;
        item.Project_Phasing__c = phases[0].id;
        item.Comments__c = 'test';
        item.Sales_Tax__c  = 0.07;
        item.Location_Multiplier_Washington_DC_1_00__c = 8; 
        item.In_house_Unit_Total__c= 10000;
        item.O_P_Unit_Total__c = 5000;

        insert item; 
        system.assertNotEquals(NULL,item); 
        
        /*List<NCMT_DES_Items__c> itemList = [select id, Markup_Method__c,In_house_Unit_Total_Adj__c,Total_Cost__c,Total_Direct_Cost__c, Equipment_Rental_Day__c, Quantity__c,NCMT_Project_ID__c, NCMT_Project_Name__c  from NCMT_DES_Items__c where Project_Cost_Summary_ID__r.Project_Name__c =:Proj.Id];
        system.debug('itemList==='+itemList);
        List<NCMT_Project_Markup__c> MpList = [select id, Site_Design_Contingency__c,Prime_Con_OSWork_Jobsite_Overhead__c  from NCMT_Project_Markup__c where Project_Name__c =:Proj.Id];
        system.debug('MpList==='+MpList);
        List<NCMT_Tree_structure__c> treeList1 = [select id, ECCA__c, ECC__c, ETPC__c,SortOrdertxt__c,Total_Cost__c,Total_Including_Markups__c,Total_OS_Work__c,Total_Self_Work__c from NCMT_Tree_structure__c where Project_ID__c =:Proj.Id];
        system.debug('treeList1==='+treeList1);
        NCMT_Project__c proj1 = [Select Id, RecordType.Name,DES_Total_Direct_Cost__c, Total_Project_Cost_Aggregate__c from NCMT_Project__c where Id= :Proj.Id Limit 1];
        system.debug('proj1==='+proj1);*/
    }
        static testMethod void testProjectDES1(){    
        Test.startTest();
        
        NCMT_DESReportDataBatch obj = new NCMT_DESReportDataBatch(); 
        Database.executeBatch(obj);
        System.Assert(obj!=NULL); 
        
        Test.stopTest();
    }
}