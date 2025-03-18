@isTest
public class NCMT_TIReport_Ctrl_Test {
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
    
    List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');
   
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                   and State__c = 'Virginia' and Name = 'State Average'];        
        NCMT_Project__c Proj = new NCMT_Project__c ();

        Proj.Project_type__c = 'New Construction';
        Proj.Building_Type__c = 'Office';
        Proj.Estimate_Type_Proj__c  = 'Parametric';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Building_Selection__c = 'New';
        Proj.Name = 'TestNewConstructionProj';
        Proj.State__c = 'Virginia';
        Proj.City__c = 'State Average'; 
        Proj.Purpose_of_Estimate__c = 'Scenario Planning';
        
        Proj.Location__c = objlocation.Id;
        
        Date ConstDate = date.newinstance(2021, 1, 1);
        //Date EndConstDate = date.newinstance(2020, 10, 1);
        Proj.Start_Construction__c = ConstDate;
        Proj.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj.Building_Quality__c = 'P100: Baseline';        
        Proj.Level_of_Protection__c = 'Level II - Low';
        Proj.Remoteness__c = 'Urban';
        Proj.Gross_Area__c = false;
        Proj.Useable_Area__c = false;
        Proj.Housing_Plan__c = true;
        Proj.Project_Status__c = 'Draft';
        Proj.Total_Area_Including_Parking__c = 0;
        Proj.Cost_Parameter_Date__c = CostParaDate;
        
        insert Proj;
        system.assertNotEquals(NULL,Proj); 
        
        Schema.DescribeSObjectResult cfrSchemaHP = Schema.SObjectType.NCMT_Housing_Plan__c; 
        Map<String,Schema.RecordTypeInfo> HousingPlanTypeInfo = cfrSchemaHP.getRecordTypeInfosByName();
        
        NCMT_Housing_Plan__c HousingPlan = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
        
        HousingPlan.Project__c = Proj.id ;
        HousingPlan.Housing_Plan_Type__c = 'New Fit Out';
        HousingPlan.Workstations_open_office_Count__c = 30;
        
        insert HousingPlan;
        system.assertNotEquals(NULL,HousingPlan); 
        
    }

    @isTest static void testTIReport(){
        NCMT_Project__C proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        system.assertNotEquals(NULL, proj);
        
        NCMT_Housing_Plan__c hp = [SELECT Id, Name FROM NCMT_Housing_Plan__c LIMIT 1];
        system.assertNotEquals(NULL, hp);
            
            NCMT_TIReport_Controller.reportData testReport =NCMT_TIReport_Controller.getTIReportData(hp.id,proj.id);
            NCMT_TIReport_Controller.costDetails objcostDetails= new NCMT_TIReport_Controller.costDetails();
            NCMT_TIReport_Controller.costDetails objcostDetails1= new NCMT_TIReport_Controller.costDetails('1','test',1.2,1.3,2.5 );
     
            system.assertNotEquals(NULL, testReport.hpData); 
            
    }
    

}