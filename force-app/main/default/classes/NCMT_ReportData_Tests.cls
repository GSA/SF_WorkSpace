@isTest
public with sharing class NCMT_ReportData_Tests {
    

    @testSetup static void setup()
    {
        NCMT_Cost_Category__c costCat = new NCMT_Cost_Category__c(
            Name = 'B10',
            Category_Description__c = 'The B10 one',
            Cost_Category_Type__c = 'New Construction'
        );
        insert costCat;
        NCMT_Security_Parameters__c secParam = new NCMT_Security_Parameters__c(
            SECURITY_CRITERION__C = 'Blast Resistance - Windows',
            LEVEL_I_MINIMUM__C = 0,
            LEVEL_II_LOW__C = 0,
            LEVEL_III_MEDIUM__C = 0,
            LEVEL_IV_HIGH__C = 0,
            LEVEL_V_VERY_HIGH__C = 0,
            COST_CATEGORY__C = costCat.ID,
            FISCAL_YEAR__C = '2017');
        insert secParam;
        secParam = new NCMT_Security_Parameters__c(
            SECURITY_CRITERION__C = 'Blast Resistance - Façade and Structure',
            LEVEL_I_MINIMUM__C = 0,
            LEVEL_II_LOW__C = 0,
            LEVEL_III_MEDIUM__C = 0,
            LEVEL_IV_HIGH__C = 0,
            LEVEL_V_VERY_HIGH__C = 0,
            COST_CATEGORY__C = costCat.ID,
            FISCAL_YEAR__C = '2017');
        insert secParam;
        NCMT_Core_Shell_Cost_Parameter__c coreParam = new NCMT_Core_Shell_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2017',
                        OTHER_SPACE_UNIT_COST__C = 1,
                        CORE_SHELL_COST_PARAMETER_IDENTIFIER__C = 'CC9',
                        COST_SUB_TYPE_DESCRIPTION__C = 'descrip',
                        COST_SUB_TYPE__C = 'sub',
                        OTHER_SPACE_UNIT__C = 'GSF',
                        PARKING_SPACE_UNIT_COST__C = 200,
                        PARKING_SPACE_UNIT__C = 'GSF',
                        LEVEL_3__C = 'lev3'
                    );
        insert coreParam;

        TI_TRCS_Cost_Parameter__c tiParam = new TI_TRCS_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2020',
                        Space_Type__c = 'Dry/Electronic Lab',
                        Level_3__c = 'G1100', 
                        Unit_TI_Cost__c = 20,
                        Unit_TI_Utilities_Cost__c = 0,
                        Unit_TRCS_Cost__c = 0
                    );
        insert tiParam;
        TI_TRCS_Cost_Parameter__c tiParam2 = new TI_TRCS_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2020',
                        Space_Type__c = 'Firing Range',
                        Level_3__c = 'G1100', 
                        Unit_TI_Cost__c = 20,
                        Unit_TI_Utilities_Cost__c = 0,
                        Unit_TRCS_Cost__c = 0
                    );
        insert tiParam2;
        TI_TRCS_Cost_Parameter__c tiParam3 = new TI_TRCS_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2020',
                        Space_Type__c = 'Credit Union',
                        Level_3__c = 'G1100', 
                        Unit_TI_Cost__c = 20,
                        Unit_TI_Utilities_Cost__c = 0,
                        Unit_TRCS_Cost__c = 0
                    );
        insert tiParam3;
        
        TI_TRCS_Cost_Parameter__c tiParam4 = new TI_TRCS_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2020',
                        Space_Type__c = 'Secure Mailroom',
                        Level_3__c = 'A1010', 
                        Unit_TI_Cost__c = 20,
                        Unit_TI_Utilities_Cost__c = 0,
                        Unit_TRCS_Cost__c = 0
                    );
        insert tiParam4;
        
        TI_TRCS_Cost_Parameter__c tiParam5 = new TI_TRCS_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2020',
                        Space_Type__c = 'Copy Center',
                        Level_3__c = 'A1010', 
                        Unit_TI_Cost__c = 20,
                        Unit_TI_Utilities_Cost__c = 0,
                        Unit_TRCS_Cost__c = 0
                    );
        insert tiParam5;
        
        TI_TRCS_Cost_Parameter__c tiParam6 = new TI_TRCS_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2020',
                        Space_Type__c = 'Public Transaction Space, Tenant Improvement',
                        Level_3__c = 'A1010', 
                        Unit_TI_Cost__c = 20,
                        Unit_TI_Utilities_Cost__c = 0,
                        Unit_TRCS_Cost__c = 0
                    );
        insert tiParam6;
        TI_TRCS_Cost_Parameter__c tiParam7 = new TI_TRCS_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2020',
                        Space_Type__c = 'Kitchen-Break room, Tenant Improvement',
                        Level_3__c = 'A1010', 
                        Unit_TI_Cost__c = 20,
                        Unit_TI_Utilities_Cost__c = 0,
                        Unit_TRCS_Cost__c = 0
                    );
        insert tiParam7;
        TI_TRCS_Cost_Parameter__c tiParam8 = new TI_TRCS_Cost_Parameter__c(
                        Cost_Category__c = costCat.Id,
                        Fiscal_Year__c = '2020',
                        Space_Type__c = 'Shower and Locker Rooms, Tenant Improvement',
                        Level_3__c = 'A1010', 
                        Unit_TI_Cost__c = 20,
                        Unit_TI_Utilities_Cost__c = 0,
                        Unit_TRCS_Cost__c = 0
                    );
        insert tiParam8;

        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff1','Virginia','State Average'
           ,'Lowrise (2 - 3 stories)', true, false, false, 1000000, false, false, false, false, false);

        //NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff6','Office','Missouri','Cape Girardeau','Core/Shell with TI'
        //                                ,'Midrise (4 - 9 stories)','P100: Monumental','Level II - Low','Urban', false, true, false, true, 1000000, 10, 0, 0, false, false, false, false, true, false, false);

        //NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff1','Office','Virginia','State Average','Core/Shell only'
        //                                ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, true);
       
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        //Get list of Project Cost Summary records inserted with Project
        List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c, Project_Name__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :Proj.Id Limit 1];
        System.assertEquals(proj.Id, listCostSummary[0].Project_Name__c);


        NCMT_GenerateTCOProjectDetailsExt.runTriggers = false;
         //Core Shell Cost Details
         NCMT_Core_Shell_Cost_Detail__c det = new NCMT_Core_Shell_Cost_Detail__c(
                Project_Cost_Summary__c = listCostSummary[0].Id,
                Core_Shell_Cost_Parameter__c = coreParam.Id, 
                Core_Shell_Cost__c = 5,
                Total_Units__c = 4,
                ParkingCost__c = 2

                );
         insert det;
         det = new NCMT_Core_Shell_Cost_Detail__c(
                Project_Cost_Summary__c = listCostSummary[0].Id,
                Core_Shell_Cost_Parameter__c = coreParam.Id, 
                Core_Shell_Cost__c = 5,
                Total_Units__c = 4,
                ParkingCost__c = 2

                );
         insert det;

         List<NCMT_Core_Shell_Cost_Detail__c> coreShell = [SELECT NCMT_Project_ID__c,
                                    Project_Cost_Summary__r.Cost_Category_ID__r.Name, Core_Shell_Cost_Parameter__r.Level_3__c,
                                    Core_Shell_Cost_Parameter__r.Level_3_Description__c
                                    
                                    FROM NCMT_Core_Shell_Cost_Detail__c
                                    WHERE Project_Cost_Summary__r.Project_Name__c =: proj.Id
                                    
                                    ];
        System.assertEquals(proj.Id, coreShell[0].NCMT_Project_ID__c);
         NCMT_TI_TRCS_Cost_Detail__c ti = new NCMT_TI_TRCS_Cost_Detail__c(
             Project_Cost_Summary__c = listCostSummary[0].Id,
             TI_TRCS_Cost_Parameter__c = tiParam.id
            );
         insert ti;

         ti = new NCMT_TI_TRCS_Cost_Detail__c(
            Project_Cost_Summary__c = listCostSummary[0].Id,
            TI_TRCS_Cost_Parameter__c = tiParam2.id
           );
        insert ti;

        ti = new NCMT_TI_TRCS_Cost_Detail__c(
            Project_Cost_Summary__c = listCostSummary[0].Id,
            TI_TRCS_Cost_Parameter__c = tiParam3.id
           );
        insert ti;
        
        ti = new NCMT_TI_TRCS_Cost_Detail__c(
            Project_Cost_Summary__c = listCostSummary[0].Id,
            TI_TRCS_Cost_Parameter__c = tiParam4.id
           );
        insert ti;
        
        ti = new NCMT_TI_TRCS_Cost_Detail__c(
            Project_Cost_Summary__c = listCostSummary[0].Id,
            TI_TRCS_Cost_Parameter__c = tiParam5.id
           );
        insert ti;
        ti = new NCMT_TI_TRCS_Cost_Detail__c(
            Project_Cost_Summary__c = listCostSummary[0].Id,
            TI_TRCS_Cost_Parameter__c = tiParam6.id
           );
        insert ti;
         ti = new NCMT_TI_TRCS_Cost_Detail__c(
            Project_Cost_Summary__c = listCostSummary[0].Id,
            TI_TRCS_Cost_Parameter__c = tiParam7.id
           );
        insert ti;
         ti = new NCMT_TI_TRCS_Cost_Detail__c(
            Project_Cost_Summary__c = listCostSummary[0].Id,
            TI_TRCS_Cost_Parameter__c = tiParam8.id
           );
        insert ti;
    }
    
    

    static testmethod void reportTest() {
        //NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff1','Office','Virginia','State Average','Core/Shell with TI'
         //                               ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', false,'','',true,'');

        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
  
        
        
        ApexPages.currentPage().getParameters().put('ProjectID', Proj.id);
        Test.startTest();
        NCMT_ReportData objTest = new NCMT_ReportData();
        System.assert(objTest != null);
        objTest.DatasetProjectCostSummaryGrouped(Proj.id);
        
        objTest.getProjectInformation();

        Test.stopTest();
        

        objTest.getDatasetProjectCostSummary();  
        objTest.getDatasetHousingPlan();   

        objTest.getCoreShellData();      
     
    }

   

    
}