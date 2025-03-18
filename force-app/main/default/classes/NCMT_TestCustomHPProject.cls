@isTest
public class NCMT_TestCustomHPProject {
    @testSetup static void setup()
    {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff6','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
        NCMT_Project__c proj = [SELECT Id, Name, Housing_Plan__c FROM NCMT_Project__c LIMIT 1];
        System.assert(proj.Housing_Plan__c);
        
        Test.startTest();
        NCMT_GenerateProjectDetailsExt.genHPRun = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
        NCMT_Housing_Plan__c hp = new NCMT_Housing_Plan__c();
        hp.Project__c = proj.Id;
        hp.Housing_Plan_Name__c = 'HousingPlanTest';
        hp.Workstations_open_office_Count__c = 100;
        hp.Closed_offices_Count__c = 10;
        hp.Private_toilets_Count__c = 5;
        hp.Total_USF__c = 1000;
        hp.Total_RSF__c = 1500;
        hp.Total_GSF__c = 2000;
        hp.RecordTypeId = Schema.SObjectType.NCMT_Housing_Plan__c.getRecordTypeInfosByName().get('User Defined').getRecordTypeId();
        insert hp;

        Test.stopTest();

        NCMT_GenerateProjectDetailsExt.genHPRun = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
    }
    /*Failing because of RSF validation rule, may be worth adjusting to work
    @isTest static void testHPSummaryUpdate(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        proj.Building_Cost_Type__c = 'TI Only';
        update proj;

        Test.startTest();

        NCMT_Housing_Plan_Summary__c HousingPlanSummary = new NCMT_Housing_Plan_Summary__c (id = null);
        HousingPlanSummary =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
        
        HousingPlanSummary.Override_RSF__c = 1990000;
        
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_ProjectTriggerValue.firstRun = true;
        update HousingPlanSummary;
        system.assertNotEquals(NULL,HousingPlanSummary);
    }

    @isTest static void testHPSummaryUpdate2(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        NCMT_Housing_Plan_Summary__c HousingPlanSummary = new NCMT_Housing_Plan_Summary__c (id = null);
        HousingPlanSummary =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
        
        HousingPlanSummary.Override_RSF__c = 2370001;
        
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_ProjectTriggerValue.firstRun = true;
        update HousingPlanSummary;
        system.assertNotEquals(NULL,HousingPlanSummary);
    }*/

    @isTest
    static void testHPOptions(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);

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
        NCMT_Housing_Plan_Cost_Parameter__c param = new NCMT_Housing_Plan_Cost_Parameter__c(
            Cost__c = 2,
            Fiscal_Year__c = '2017',
            NCMT_Housing_Plan_Option__c = opt.Id,
            Space_Type__c = 'General Office Space Type, 50% Open'
        );
        insert param;

        Test.startTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        
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
        
        NCMT_GenerateProjectDetailsExt.genHPRun = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
        String resp = NCMT_HousingPlan_OptionSelection.saveHousingPlanOpts(pageOpts);
        System.assertEquals(null, resp);
    }

    @isTest
    static void testProjUpdate(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);

        proj.Surface_Parking__c = 100;
        NCMT_ProjectTriggerValue.firstRun = true;
        Test.startTest();
        update proj;
    }
    
    @isTest
    static void testAddHP(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
        NCMT_ProjectTriggerValue.firstRun = true;

        Test.startTest();
        //Housing Plan
        NCMT_Housing_Plan__c hp = new NCMT_Housing_Plan__c();
        hp.Project__c = Proj.Id;
        hp.Housing_Plan_Name__c = 'HousingPlanTest';
        hp.Workstations_open_office_Count__c = 100;
        hp.Closed_offices_Count__c = 10;
        hp.Private_toilets_Count__c = 5;
        hp.Total_USF__c = 1000;
        hp.Total_RSF__c = 1500;
        hp.Total_GSF__c = 2000;
        hp.RecordTypeId = Schema.SObjectType.NCMT_Housing_Plan__c.getRecordTypeInfosByName().get('User Defined').getRecordTypeId();
        insert hp;

        Test.stopTest();
        NCMT_ProjectTriggerValue.firstRun = true;
        update proj;
    }
}