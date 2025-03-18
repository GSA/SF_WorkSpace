@isTest
public class NCMT_TestTCOUpdatesClass {
    
    @testSetup static void setup(){
        
        Date CostParaDate = date.newinstance(2016, 10, 1);
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        insert NCMT_Cust_settings;
        
    List <AE_CMa_CMc_Cx__c> lstAE_CMa_CMc_Cx = Test.loadData(AE_CMa_CMc_Cx__c.sObjectType,'NCMT_AE_CMa_CMc_Cx');
    
    List <Professional_Service_Estimate_Parameter__c> lstProfessional_Service_Estimate_Parameter = Test.loadData(Professional_Service_Estimate_Parameter__c.sObjectType, 'NCMT_Professional_Service_Estimate_Parameter');
    
    List <System_Level_Parameter__c> lstsystemlevelparameter = Test.loadData(System_Level_Parameter__c.sObjectType, 'NCMT_System_Level_Parameter');
    
    List <NCMT_Building_Parameter__c> lstbuilding = Test.loadData(NCMT_Building_Parameter__c.sObjectType, 'NCMT_Building_Parameter');
    
    List <NCMT_Building_Height_Parameter__c> lstbldgheight = Test.loadData(NCMT_Building_Height_Parameter__c.sObjectType, 'NCMT_Building_Height_Parameter');
    
    List <NCMT_Quality_Code_Parameter__c> lstqualitycodeparameter = Test.loadData(NCMT_Quality_Code_Parameter__c.sobjectType, 'NCMT_Quality_Code_Parameter');
    
    List <NCMT_Quality_Code_Lookup__c> lstqualitycodelookup = Test.loadData(NCMT_Quality_Code_Lookup__c.sObjectType, 'NCMT_Quality_Code_Lookup');
    
    List <NCMT_Cost_Category__c> lstNCMT_Cost_Category = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_Cost_Category');
    
    List <NCMT_Security_Parameters__c> lstNCMT_Security_Parameters = Test.loadData(NCMT_Security_Parameters__c.sObjectType, 'NCMT_Security_Parameters');
    
    List <NCMT_Core_Shell_Cost_Parameter__c> lstNCMT_Core_Shell_Cost_Parameter = Test.loadData(NCMT_Core_Shell_Cost_Parameter__c.sObjectType, 'NCMT_Core_Shell_Cost_Parameter');    
    
    List <TI_TRCS_Cost_Parameter__c> lstTI_TRCS_Cost_Parameter = Test.loadData(TI_TRCS_Cost_Parameter__c.sObjectType, 'NCMT_TI_TRCS_Cost_Parameter');
    
    //List <NCMT_P100_Parameter__c> lstNCMT_P100_Parameter = Test.loadData(NCMT_P100_Parameter__c.sObjectType, 'NCMT_P100_Parameter');  
    
    //List <NCMT_LEED_Parameter__c> lstNCMT_LEED_Parameter = Test.loadData(NCMT_LEED_Parameter__c.sObjectType, 'NCMT_LEED_Parameter');  
    
    List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');
      
    List <NCMT_TCO_Parameter__c> listTCOParameter = Test.loadData(NCMT_TCO_Parameter__c.sObjectType, 'NCMT_TCO_Parameter');

    List <NCMT_TCO_HP_Parameters__c> listTCOHPParameters = Test.loadData(NCMT_TCO_HP_Parameters__c.sObjectType, 'NCMT_TCO_HP_Parameter');

    List <NCMT_TCO_Cost_Parameter__c> listTCOCostParameter = Test.loadData(NCMT_TCO_Cost_Parameter__c.sObjectType, 'NCMT_TCO_Cost_Rates_Parameters');
    
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                                                            and State__c = 'Virginia' and Name = 'State Average'];        
        
       string strRecordTypeID = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction - TCO').getRecordTypeId();

        NCMT_Project__c Proj = new NCMT_Project__c ();
                
        Proj.RecordTypeID = strRecordTypeID;
        Proj.Project_type__c = 'New Construction';
        Proj.Building_Type__c = 'Office';
        Proj.Estimate_Type_Proj__c  = 'Parametric';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Building_Selection__c = 'New';
        Proj.Name = 'testProjCodeCovTCOOff2';
        Proj.State__c = 'Virginia';
        Proj.City__c = 'State Average'; 
        Proj.Purpose_of_Estimate__c = 'Scenario Planning';
        
        Proj.Location__c = objlocation.Id;
        
        Date ConstDate = date.newinstance(2021, 1, 1);
        //Date EndConstDate = date.newinstance(2020, 10, 1);
        Proj.Start_Construction__c = ConstDate;
        Proj.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj.Building_Heigtht__c = 'Single Story';
        Proj.Building_Quality__c = 'P100: Baseline';        
        Proj.Level_of_Protection__c = 'Level II - Low';
        Proj.Remoteness__c = 'Urban';
        Proj.Gross_Area__c = true;
        Proj.Useable_Area__c = false;
        Proj.Housing_Plan__c = false;
        Proj.Project_Status__c = 'Draft';
        Proj.Total_Area_Including_Parking__c = 100000;
        Proj.Cost_Parameter_Date__c = CostParaDate;
        
        insert Proj;
       
        Proj.Remoteness__c = 'Suburban';
        update Proj;
       
        Proj.Remoteness__c = 'Rural';
        update Proj;
       
        Proj.Remoteness__c = 'Remote';
        update Proj;
       
        Proj.Remoteness__c = 'Very Remote';
        update Proj;
        system.assertNotEquals(NULL,Proj); 
    	
    }
    static void testTCOinserts(){
        NCMT_Project__C proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        
        NCMT_TCOFLOWController tcoflowctrl = new NCMT_TCOFLOWController();
        tcoflowctrl.GeneratePerfInput(Proj.Id);
        triggervalue.isPerformanceUpdate = true;
        triggervalue.isCostUpdate = true;
        tcoflowctrl.GenerateAnnualCostSummary(Proj.Id);
        tcoflowctrl.GenerateHPLOS(Proj.Id);
        triggervalue.isPerformanceUpdate = false;
        triggervalue.isCostUpdate = false;
    }
    
    static testmethod void testTCOUpdates(){
        
        testTCOinserts();
        
         NCMT_Project__C proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        
         system.assertNotEquals(NULL, proj);
        
         NCMT_Project__c Projupd1 = new NCMT_Project__c();
        
        Test.startTest();
         
            //update project
            NCMT_ProjectTriggerValue.firstRun = true;
            Projupd1.id = Proj.id;
            Projupd1.Building_Heigtht__c = 'Midrise (4 - 9 stories)'; 
            update Projupd1;
            system.assertNotEquals(NULL,Projupd1);
        
        Test.stopTest(); 
    }
    static testmethod void testTCOUpdates2(){
        Test.startTest();
        NCMT_Project__C proj = [SELECT Id, Building_Cost_Type__c, Name FROM NCMT_Project__c LIMIT 1];
        proj.Building_Cost_Type__c='Core/Shell only';
        update proj;
        Test.stopTest(); 
    }
    static testmethod void testTCOUpdates3(){
        Test.startTest();
        NCMT_Project__C proj = [SELECT Id, Building_Cost_Type__c, Name FROM NCMT_Project__c LIMIT 1];
        proj.Building_Cost_Type__c='TI Only';
        update proj;
      Test.stopTest();
    }
    static testmethod void testTCOUpdates4(){
        Test.startTest();
        NCMT_Project__C proj = [SELECT Id, Building_Cost_Type__c, Name FROM NCMT_Project__c LIMIT 1];
        proj.Building_Cost_Type__c='TI Including Warm Lit Shell';
        update proj;
        Test.stopTest();
    }
    static testmethod void testTCOUpdates5(){
        Test.startTest();
        NCMT_Project__C proj = [SELECT Id, Building_Cost_Type__c, Name FROM NCMT_Project__c LIMIT 1];
        proj.Building_Cost_Type__c='TI Retrofit';
        update proj;
       Test.stopTest();
    }
}