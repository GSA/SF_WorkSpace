@isTest
public class NCMT_TCO_ProjectReportTests {

    @testSetup static void setup()
    {
        //To avoid soql limits
        //NCMT_GenerateTCOProjectDetailsExt.runTriggers = false;

        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCov2','Virginia','State Average'
            ,'Lowrise (2 - 3 stories)', true, false, false, 1000000, false, false, false, false, false);
       
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
        //Don't fire trigger, the rest of the test hits limits and the Test.startTest / stopTest 
        //area already BOTH used in the CreateTCOProject...
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = true;
        insert lifecycle;
        NCMT_TCO_LCC__c lcc = new NCMT_TCO_LCC__c(
            TCO_Lifecycle_Input__c = lifecycle.Id,
            Year__c = 1,
            NCMT_Project__c = proj.Id
        );
        insert lcc;
        Test.stopTest(); 
    }

    static testMethod void testBasicInputDetails(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        ApexPages.StandardController controller = new ApexPages.StandardController(proj);
        NCMT_TCOBuildingCostsPerYear_LC ctrl = new NCMT_TCOBuildingCostsPerYear_LC(controller);
        
        Test.startTest();
        List<String> projIds = new List<String>{proj.Id};
        Integer totalTests = 0;
        String reportType = 'BasicInputs';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'details', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(8, tcoProj.sections.size());

            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testBasicInputDetails

    static testMethod void testBasicCostOutputsDetails(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        ApexPages.StandardController controller = new ApexPages.StandardController(proj);
        NCMT_TCOBuildingCostsPerYear_LC ctrl = new NCMT_TCOBuildingCostsPerYear_LC(controller);
        
        Test.startTest();
        List<String> projIds = new List<String>{proj.Id};
        Integer totalTests = 0;
        String reportType = 'BasicCostOutputs';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'details', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(2, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testBasicCostOutputsDetails

    static testMethod void testDetailedCostOutputsDetails(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        ApexPages.StandardController controller = new ApexPages.StandardController(proj);
        NCMT_TCOBuildingCostsPerYear_LC ctrl = new NCMT_TCOBuildingCostsPerYear_LC(controller);
        
        Test.startTest();
        List<String> projIds = new List<String>{proj.Id};
        Integer totalTests = 0;
        String reportType = 'DetailedCostOutputs';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'details', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(5, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testDetailedCostOutputsDetails

    static testMethod void testDetailedSummaryDetails(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        ApexPages.StandardController controller = new ApexPages.StandardController(proj);
        NCMT_TCOBuildingCostsPerYear_LC ctrl = new NCMT_TCOBuildingCostsPerYear_LC(controller);
        
        Test.startTest();
        List<String> projIds = new List<String>{proj.Id};
        Integer totalTests = 0;
        String reportType = 'DetailedSummary';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'details', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(11, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testDetailedSummaryDetails

    static testMethod void testExpenditureCurveStackedDetails(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        ApexPages.StandardController controller = new ApexPages.StandardController(proj);
        NCMT_TCOBuildingCostsPerYear_LC ctrl = new NCMT_TCOBuildingCostsPerYear_LC(controller);
        
        Test.startTest();
        List<String> projIds = new List<String>{proj.Id};
        Integer totalTests = 0;
        String reportType = 'ExpenditureCurveStacked';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'details', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(2, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testExpenditureCurveStackedDetails

    //COMPARISON REPORTS

    static testMethod void testBasicInputComparison(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c];

        Test.startTest();
        List<String> projIds = new List<String>{projs[0].Id};
        Integer totalTests = 0;
        String reportType = 'BasicInputs';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'comparison', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(8, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testBasicInputDetails

    static testMethod void testBasicCostOutputsComparison(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};


        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c];
        
        Test.startTest();
        List<String> projIds = new List<String>{projs[0].Id};
        Integer totalTests = 0;
        String reportType = 'BasicCostOutputs';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'comparison', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(2, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testBasicCostOutputsDetails

    static testMethod void testDetailedCostOutputsComparison(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c];

        Test.startTest();
        List<String> projIds = new List<String>{projs[0].Id};
        Integer totalTests = 0;
        String reportType = 'DetailedCostOutputs';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'comparison', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(5, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testDetailedCostOutputsDetails

    static testMethod void testDetailedSummaryComparison(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c];

        Test.startTest();
        List<String> projIds = new List<String>{projs[0].Id};
        Integer totalTests = 0;
        String reportType = 'DetailedSummary';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'comparison', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(11, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testDetailedSummaryDetails

    static testMethod void testExpenditureCurveComparison(){
        Set<String> costTypes = new Set<String>{'cost', 'escalatedCost', 
                'escalatedDiscountedCost'};

        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c];

       
        Test.startTest();
        List<String> projIds = new List<String>{projs[0].Id};
        Integer totalTests = 0;
        String reportType = 'ExpenditureCurve';
        for (String costType : costTypes){
            NCMT_TCO_ReportData tcoProj = NCMT_TCOReportDataSelector.getReportData(projIds, reportType, 'comparison', costType);
            System.debug('Running details, report: ' +reportType +' costType: ' +costType);

            System.assertEquals(2, tcoProj.sections.size());
            
            totalTests++;
        }
        
        //Sanity check
        System.assertEquals(3, totalTests);
    }//end testExpenditureCurveDetails


}