@isTest
public class NCMT_HousingPlan_optSelection_Test {
    @testSetup static void setup()
    {
        

        //NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff1','Virginia','State Average'
        //    ,'Lowrise (2 - 3 stories)', true, false, false, 1000000, true, false, false, false, false);
        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCov2','Virginia','State Average'
            ,'Lowrise (2 - 3 stories)', true, false, false, 1000000, false, false, false, false, false);
        
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        //Not sure why this needs to be done, but....
        Id tcoRecordTypeId = NCMT_Utilities.getProjectRecordTypeId('New_Construction_TCO');
        proj.RecordTypeId = tcoRecordTypeId;
        System.debug('About to update to TCO Record Type.....');
        update proj;
        

    }



    static testMethod void testOptionSelection(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        

        NCMT_TCO_Lifecycle_Input__c lifecycle = new NCMT_TCO_Lifecycle_Input__c(
            NCMT_Project__c = proj.Id,
            Include_Tenant_Refresh_Costs__c = true,
            New_fit_out_every_years__c = 7,
            Refresh_every_years__c = 7,
            Period_of_Analysis__c = 35,
            Planning_and_Pre_design__c = 6,
            Design__c = 6, 
            Construction__c = 12,
            End_Routine_Periodic_Maintenance_Early__c = 1,
            End_Major_Maint_System_Replace_Early__c = 3,
            Number_of_Years_of_Operation__c = 35
        );
        insert lifecycle;

        Id otherRT = NCMT_Housing_Plan_Option_Template__c.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Other_Cost').getRecordTypeId();

        NCMT_Housing_Plan_Option_Template__c temp = new NCMT_Housing_Plan_Option_Template__c(
            Sort_Order__c = 1,
            Sub_Type__c = 'Acquisition',
            Type__c = 'Moving Costs',
            RecordTypeId = otherRT
        );
        insert temp;

        NCMT_Housing_Plan_Option__c opt = new NCMT_Housing_Plan_Option__c(
            Choice_Text__c = 'My choice',
            NCMT_Housing_Plan_Option_Template__c = temp.Id,
            Recurs_on_TCO_Tenant_Renewal_Years__c = true,
            Sort_Order__c = 1,
            TCO_Default_Repair_Cost_Percentage__c = 25,
            TCO_Default_Repair_Every_X_Years__c = 1,
            TCO_Default_Replacement_Every_X_Years__c = 5
        );
        insert opt;

        List<NCMT_Housing_Plan_Cost_Parameter__c> params = new List<NCMT_Housing_Plan_Cost_Parameter__c>();
        params.add(new NCMT_Housing_Plan_Cost_Parameter__c(
            Cost__c = 2,
            Fiscal_Year__c = '2017',
            NCMT_Housing_Plan_Option__c = opt.Id,
            Space_Type__c = 'General Office Space Type, 50% Open'
        ));
        params.add(new NCMT_Housing_Plan_Cost_Parameter__c(
            Cost__c = 2,
            Fiscal_Year__c = '2017',
            NCMT_Housing_Plan_Option__c = opt.Id,
            Space_Type__c = 'General Storage'
        ));
        
        insert params;

        
        
        
        ApexPages.StandardController controller = new ApexPages.StandardController(proj);
        NCMT_HousingPlan_OptionSelection ctrl = new NCMT_HousingPlan_OptionSelection(controller);

        List<NCMT_HousePlan_TypeOptions> pageOpts = NCMT_HousingPlan_OptionSelection.retrieveOptions('Other_Cost', 'Moving Costs', proj.Id);
        for (NCMT_HousePlan_TypeOptions to : pageOpts){
            for (NCMT_HousePlan_TypeOptions.HousingPlan_Recurrence i : to.recurrences){
                for (NCMT_HousePlan_TypeOptions.HousingPlan_SubType sub : i.subTypes){
                    for (NCMT_HousePlan_TypeOptions.HousingPlan_Option o : sub.options){
                        o.selected = true;
                    }
                }
            }
        }
        Test.startTest();
        NCMT_GenerateProjectDetailsExt.genHPRun = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
        String resp = NCMT_HousingPlan_OptionSelection.saveHousingPlanOpts(pageOpts);
        System.assertEquals(null, resp);
        System.assertEquals(1, [Select Id from NCMT_Housing_Plan_Option_Selection__c where NCMT_Project__c =: proj.Id].size());
        System.assertEquals(1, [Select Id from NCMT_Other_Cost__c where NCMT_Project__c =: proj.Id AND NCMT_Housing_Plan_Cost_Parameter__c <> null].size()); // 

        ctrl = new NCMT_HousingPlan_OptionSelection(controller);

        NCMT_HousePlan_TypeOptions t = new NCMT_HousePlan_TypeOptions();
        NCMT_HousePlan_TypeOptions.HousingPlan_Recurrence r = new NCMT_HousePlan_TypeOptions.HousingPlan_Recurrence();
        NCMT_HousePlan_TypeOptions.HousingPlan_SubType s = new NCMT_HousePlan_TypeOptions.HousingPlan_SubType();
        NCMT_HousePlan_TypeOptions.HousingPlan_Option op = new NCMT_HousePlan_TypeOptions.HousingPlan_Option();

        ApexPages.currentPage().getParameters().put('ProjectID', Proj.id);
        NCMT_ReportData objTest = new NCMT_ReportData();
        objTest.getMovingCosts();
        

        pageOpts = NCMT_HousingPlan_OptionSelection.retrieveOptions('Other_Cost', 'Moving Costs', proj.Id);
        for (NCMT_HousePlan_TypeOptions to : pageOpts){
            for (NCMT_HousePlan_TypeOptions.HousingPlan_Recurrence i : to.recurrences){
                for (NCMT_HousePlan_TypeOptions.HousingPlan_SubType sub : i.subTypes){
                    for (NCMT_HousePlan_TypeOptions.HousingPlan_Option o : sub.options){
                        o.selected = false;
                    }
                }
            }
        }
        System.debug('About to stop test and fire future methods');
        Test.stopTest();

        NCMT_GenerateProjectDetailsExt.genHPRun = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
        resp = NCMT_HousingPlan_OptionSelection.saveHousingPlanOpts(pageOpts);
        System.assertEquals(null, resp);
    }
}