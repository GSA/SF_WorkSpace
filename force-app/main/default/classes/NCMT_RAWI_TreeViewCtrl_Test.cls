@isTest
public with sharing class NCMT_RAWI_TreeViewCtrl_Test {
   
    @testSetup static void setup(){
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
        
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetails = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Lookup_Detail');
        
        List <NCMT_Cost_Category__c> listCostCategoriesGSA = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_Cost_Category_GSA_Assemblies');
    
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetailsGSA = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Master_GSA_Assemblies');
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                and State__c = 'Virginia' and Name = 'State Average'];        

        List <NCMT_RA_Overhead_Analysis__c> lstNCMT_RA_Overhead_Analysis = Test.loadData(NCMT_RA_Overhead_Analysis__c.sObjectType, 'NCMT_RA_Overhead_Analysis');

        //List <NCMT_RA_WI_Lookup_Details__c> lstNCMT_RA_WI_Lookup_Details = Test.loadData(NCMT_RA_WI_Lookup_Details__c.sObjectType, 'NCMT_RA_WI_Lookup_Details');


        NCMT_Project__c Proj1 = new NCMT_Project__c ();
        Proj1.Project_type__c = 'Repair & Alteration - Parametric Entry';
        proj1.Building_type__c = 'Office';
        Proj1.Estimate_Type_Proj__c  = 'Parametric - Repair & Alteration';
        //Proj1.Project_Phases__c ='Design';
        //Proj1.Project_SubPhases__c='Preliminary Concept';
        Proj1.Purpose_of_Estimate__c = 'Project Controls';
        Proj1.Name = 'testrawipage';
        Proj1.State__c = 'Virginia';
        Proj1.City__c = 'State Average';
        Proj1.Building_Selection__c = 'Existing'; 
        Proj1.Purpose_of_Estimate__c = 'Scenario Planning';   
        Proj1.Location__c = objlocation.Id;
        Date ConstDate1 = date.newinstance(2019, 1, 1);
        Date EndConstDate1 = date.newinstance(2020, 10, 1);
        Proj1.Start_Construction__c = ConstDate1;
        Proj1.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj1.Building_Quality__c = 'P100: Baseline';        
        Proj1.Level_of_Protection__c = 'Level II - Low';
        Proj1.Remoteness__c = 'Urban';
        Proj1.Project_Status__c = 'Draft';
        Proj1.Cost_Parameter_Date__c = CostParaDate;
        Proj1.Dominant_Period__c = '1940 - 1949';
        Proj1.Historic_Landmark_Status__c = 'Class 2';
        Proj1.Overall_Condition__c = 'Good';
        Proj1.RA_Estimate_Type__c ='Parametric Entry';
        Proj1.Housing_Plan__c = true;
        Proj1.RA_Security__c = 'Minimum upgrade to existing'; 
        Proj1.Gross_Area_Including_Parking__c = 100000;
        Proj1.Affected_Tenant_Area_USF__c = 10000;
        Proj1.Total_Site_Area_Building_Footprint_SF__c = 200000;
        Proj1.Level_of_Program_Definition__c = '5';

        insert Proj1;
        

    
       list<NCMT_RA_WI_Lookup_Details__c> rawiList = new list<NCMT_RA_WI_Lookup_Details__c>();
        Integer addToPrev;
       for (integer i=0; i<3; i++ ){
            addToPrev = i-1;
            NCMT_RA_WI_Lookup_Details__c rawi = new NCMT_RA_WI_Lookup_Details__c();
            rawi.Name = 'rawi' + i;
            rawi.Cost_Category__c = listCostCategories[0].id;
            rawi.Fiscal_Year__c = '2017';
            rawi.Work_Item_Type__c = 'Repair';
            // rawi.Cost_Type__c = pcs.Cost_Category_Description__c;
            if(i ==1){ rawi.Work_Item_Category_Type__c = 'type' + addToPrev; }
            else{ rawi.Work_Item_Category_Type__c = 'type' + i; }
            
            if(i ==2){rawi.WI_Category_Sub_Type__c = 'subtype' + addToPrev;}
            else{rawi.WI_Category_Sub_Type__c = 'subtype' + i; }
            
            rawi.WI_Category_Code__c = 'code' +i;

            rawiList.add(rawi); 
         }
        insert rawiList;
        NCMT_RA_Phasing__c phase = new NCMT_RA_Phasing__c();
        phase.name = 'test phase';
        phase.Project__c = Proj1.id;
        phase.Work_Conditions__c = 'Fully vacant building';
        insert phase;
    }

    @isTest static void test_Init(){

        NCMT_Project__C proj = [SELECT Id, Name, Cost_Parameter_Date_FY__c 
                                FROM NCMT_Project__c 
                                LIMIT 1];
        NCMT_Project_Cost_Summary__c pcs = [SELECT Id, Name, Cost_Category_Description__c 
                                            FROM NCMT_Project_Cost_Summary__c
                                            WHERE Project_Name__c = :proj.Id 
                                            LIMIT 1];
        list<NCMT_RA_WI_Lookup_Details__c> rawiList = [SELECT Name, Cost_Category__c, Cost_Type__c, Fiscal_Year__c  
                                                       FROM NCMT_RA_WI_Lookup_Details__c ];

        Test.startTest();
            NCMT_RAWI_TreeViewCtrl_LC.raWIitems itemsTest = NCMT_RAWI_TreeViewCtrl_LC.init(pcs.id);
            // System.assertNotEquals(NULL, itemsTest.pcsId);
        Test.stopTest();
        System.assertEquals(proj.id, itemsTest.pcs.project_name__c);
        System.assertEquals(pcs.Cost_Category_Description__c, itemsTest.pcs.Cost_Category_Description__c);
        System.assertEquals(proj.Cost_Parameter_Date_FY__c, itemsTest.pcs.project_name__r.Cost_Parameter_Date_FY__c);
        System.assertNotEquals(NULL, itemsTest.items);
        System.assertNotEquals(NULL, itemsTest.phases);
    }
    @isTest static void test_Save(){
        NCMT_Project__C proj = [SELECT Id, Name, Cost_Parameter_Date_FY__c 
                                FROM NCMT_Project__c 
                                LIMIT 1];
        NCMT_Project_Cost_Summary__c pcs = [SELECT Id, Name, Cost_Category_Description__c 
        FROM NCMT_Project_Cost_Summary__c
        WHERE Project_Name__c = :proj.Id 
        LIMIT 1];

        list<NCMT_RA_WI_Lookup_Details__c> rawiList = [SELECT Name, Cost_Category__c, Cost_Type__c, Fiscal_Year__c  
        FROM NCMT_RA_WI_Lookup_Details__c ];

        NCMT_RA_Phasing__c phase =  [select id, name from NCMT_RA_Phasing__c where Project__c = :proj.id LIMIT 1];

        system.debug('phase' + phase);
        List<NCMT_RA_Work_Items__c> itms = new List<NCMT_RA_Work_Items__c>();
        system.debug('phase' + phase);
        NCMT_RA_Work_Items__c itm = new NCMT_RA_Work_Items__c(
            Work_Item_Type_ID__c = pcs.id,
            RA_WI_Lookup_Detail__c = rawiList[0].id,
            Work_Item_Type__c = 'Repair',
            Quantity_SF__c = 5,
            Rate__c = 10,
            Work_Item_Phase__c = phase.id
        );
        itms.add(itm);
        string itemJson =  JSON.serialize(itms);
        System.debug('itemJson )))))' + itemJson);

        Test.startTest();
        List<NCMT_RA_Work_Items__c> itemsToSave = NCMT_RA_WorkItems_Ctrl.saveRaWorkItems(itemJson);

        System.debug('items to save' +itemsToSave );

        List<NCMT_RA_Work_Items__c> itmsToFail = new List<NCMT_RA_Work_Items__c>();
        
        NCMT_RA_Work_Items__c itmToFail = new NCMT_RA_Work_Items__c(
            Work_Item_Type_ID__c = null,
            RA_WI_Lookup_Detail__c = rawiList[0].id,
            Work_Item_Type__c = 'Repair',
            Quantity_SF__c = 5,
            Rate__c = 10,
            Work_Item_Phase__c = phase.id
        );
        itmsToFail.add(itmToFail);
        string itemToFailJson =  JSON.serialize(itmsToFail);
        System.debug('itemToFailJson )))))' + itemToFailJson);
        try{
        List<NCMT_RA_Work_Items__c> itemsToFail = NCMT_RA_WorkItems_Ctrl.saveRaWorkItems(itemToFailJson);
        }catch(Exception e){
            
        }
        Test.stopTest();

         System.debug('items to save' +itemsToSave );
         System.assertNotEquals(NULL, itemsToSave);
        
    }


}