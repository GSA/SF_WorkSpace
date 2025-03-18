@isTest(seeAllData=true)
public class NCMT_MoveCostModule_Ctrl_LC_Test {
    
    
    @isTest static void test_MoveCostModule() 
    {
        Test.startTest();
        NCMT_MoveCostModule_Ctrl_LC.moveCostWrapper mc = NCMT_MoveCostModule_Ctrl_LC.initMoveCostMod();
        System.assertNotEquals(null, mc.reportId);
        
        String projName = 'Move Cost Module Test';
        NCMT_Project__c proj = NCMT_MoveCostModule_Ctrl_LC.createProject(projName);
        System.assertNotEquals(null, proj);
        Test.stopTest();
    }
    
    @isTest static void test_OtherCosts()
    {
        NCMT_Housing_Plan__c testHP = [SELECT Project__c, Housing_Plan_Name__c, Workstations_open_office_Count__c
                                       FROM NCMT_Housing_Plan__c
                                       WHERE Workstations_open_office_Count__c = 0 LIMIT 1];
        
        Test.startTest();
        NCMT_MoveCostModule_Ctrl_LC.moveCostWrapper mc = NCMT_MoveCostModule_Ctrl_LC.getOtherCostData(testHP.Id);
        System.assertNotEquals(null, mc.housingPlan);
        Test.stopTest();
    }

}