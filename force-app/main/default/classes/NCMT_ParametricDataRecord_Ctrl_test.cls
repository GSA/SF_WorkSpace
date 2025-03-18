@isTest
public class NCMT_ParametricDataRecord_Ctrl_test {
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
        Proj.Gross_Area__c = true;
        Proj.CUI_Header__c = 'CUI Header';
        Proj.Useable_Area__c = false;
        Proj.Housing_Plan__c = false;
        Proj.Project_Status__c = 'Draft';
        Proj.Total_Area_Including_Parking__c = 1000000;
        Proj.Cost_Parameter_Date__c = CostParaDate;
        
        insert Proj;
        system.assertNotEquals(NULL,Proj); 

        
    }

    @isTest static void testParametricRecord(){
        NCMT_Project__C proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

            system.assertNotEquals(NULL, proj);
            
            NCMT_ParametricDataRecord_Controller.reportData testReport =NCMT_ParametricDataRecord_Controller.getProjectData(proj.id);

            system.assertNotEquals(NULL, testReport.ProjectDetails);   
            system.assertNotEquals(NULL, testReport.PLPData);   
            system.assertNotEquals(NULL, testReport.bldgmassData);   
            system.assertNotEquals(NULL, testReport.siteData);  
            system.assertNotEquals(NULL, testReport.hpData); 
            system.assertNotEquals(NULL, testReport.coreShellData); 
            system.assertEquals('Spread', testReport.foundations);
            system.assertEquals('', testReport.Reviewed_By);
            system.assertEquals('', testReport.Approved_By);
            
    } 
    
   @isTest
    static void testValidProjectIdFromStandardController() {
       NCMT_Project__C proj = [SELECT Id, Name, CUI_Header__c FROM NCMT_Project__c LIMIT 1]; 
        
       ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        
       Test.StartTest();
       NCMT_ParametricDataRecord_Controller controller = new NCMT_ParametricDataRecord_Controller(sc);
       Test.StopTest();
      // Assertions
        System.assertEquals(proj.Id, controller.projectId, 'The projectId should match the ID from the StandardController.');
        System.assertEquals(proj.CUI_Header__c, controller.projectName, 'The projectName should match the CUI_Header__c field.');
    }
    @isTest
    static void testNoRecordIdInURL() {
        // Arrange: Simulate a page without a record ID
        ApexPages.StandardController sc = new ApexPages.StandardController(new NCMT_Project__c());
        Test.startTest();

        // Act: Create the controller instance
        NCMT_ParametricDataRecord_Controller controller = new NCMT_ParametricDataRecord_Controller(sc);

        // Assert: Check for error message
        Test.stopTest();
        System.assertEquals(
            1,
            ApexPages.getMessages().size(),
            'There should be an error message for a missing record ID.'
        );
        System.assertEquals(
            'No record ID in URL.',
            ApexPages.getMessages()[0].getSummary(),
            'The error message should indicate that the record ID is missing.'
        );
    }
}