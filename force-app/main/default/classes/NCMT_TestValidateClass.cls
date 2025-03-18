@isTest
public class NCMT_TestValidateClass {

    static testmethod void OfficeProject1() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff1','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, true);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
   
    static testmethod void OfficeDESProject2() {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff2','Office','Virginia','State Average','TI - Leasing','GSA Markups',false,true,false,false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    static testmethod void OfficeDESProject2a() {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff2','Office','Virginia','State Average','TI - Leasing','GSA Markups',false,true,false,false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        
        NCMT_Tree_structure__c treestruc = [Select id,name
                        From NCMT_Tree_structure__c 
                        where Project_ID__c = :Proj.id LIMIT 1];
        NCMT_NewTreeButton_Ctrl.getRecordInformation(treestruc.Id);
        NCMT_NewTreeButton_Ctrl.getsaveNewrecord('Test', treestruc.Id, 'Test', 'Test', true);
        NCMT_NewTreeButton_Ctrl.getProjectName(treestruc.Id);
        NCMT_NewTreeButton_Ctrl.getParentTree(treestruc.Id);
        NCMT_NewTreeButton_Ctrl.getrecordTypeName(treestruc.Id);
        NCMT_NewTreeButton_Ctrl.getCheck(treestruc.Id);
        System.assert(proj !=null);
    }
    
    static testmethod void OfficeDESProject3() {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff3','Office','Virginia','State Average','Build to Suit Lease','GSA Markups',true,false,false,false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
    static testmethod void OfficeDESProject4() {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff4','Office','Virginia','State Average','IDIQ-JOC','GSA Markups',false,false,true,false);
        NCMT_Project__c proj = [SELECT Id, Name, Project_Phases__c, Project_SubPhases__c FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
    
    static testmethod void OfficeDESProject5() {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff5','Office','Virginia','State Average','Design-Bid-Build','GSA Markups',false,false,false,true);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    /*Duplicated in NCMT_TestDesProjects
    static testmethod void OfficeDESProject6() {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff6','Office','Virginia','State Average','Design Build - Bridging','GSA Markups',false,false,false,false);
        
    }*/
    
    static testmethod void OfficeDESProject7() {
        NCMT_TestDataClass.CreateDESProject('Repair & Alteration - DES', 'testDESProjCodeCovDESOff7','Office','Virginia','State Average','CMc','GSA Markups',false,false,false,false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
        //SFWS2040
    static testmethod void OfficeCEWProject1() {
        NCMT_TestDataClass.CreateCEWProject('New Construction - CEW', 'testCEWProjCodeCovCEWOff1','Office','Virginia','State Average','Pre-Planning','Pre-Planning Phase','6',1000);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
      
    static testmethod void OfficeProject4() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff2','Office','South Dakota','Aberdeen','TI Including Warm Lit Shell'
                                        ,'Lowrise (2 - 3 stories)','Code Minimum','Level II - Low','Urban', false, true, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);                              
    }

    static testmethod void OfficeProject6() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff3','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level II - Low','Urban', true, false, false, false, 30000, 0, 1, 0, false, false, false, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }   
 
   
    /*static testmethod void OfficeProject81() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff4','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level III - Medium','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }*/
  
    static testmethod void OfficeProject9() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff5','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level III - Medium','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
    static testmethod void OfficeProject14() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff6','Office','Missouri','Cape Girardeau','Core/Shell with TI'
                                        ,'Midrise (4 - 9 stories)','P100: Monumental','Level II - Low','Urban', false, true, false, false, 1000000, 10, 0, 0, false, false, false, false, false, true, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }   
     
    static testmethod void OfficeCustomHPProject1() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff5','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, true, 100000, 0, 0, 0, false, false, false, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
    static testmethod void OfficeCustomHPProject3() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff6','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);

        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }

    static testmethod void OfficeCustomHPProject4() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff6','Office','Virginia','State Average','TI Including Warm Lit Shell'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }

    static testmethod void OfficeCustomHPProject5() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff6','Office','Virginia','State Average','TI Retrofit'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
        
    static testmethod void CourthouseProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovCO1','Courthouse','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 100000, 0, 0, 0, false, true, false, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
    static testmethod void LaboratoryDryProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovLD1','Laboratory: Dry','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 100000, 0, 0, 0, false, false, true, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
    static testmethod void LaboratoryWetProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovLW1','Laboratory: Wet','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 100000, 0, 0, 0, false, false, false, false, false, false, false);
        
        
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);

        Test.startTest();
        ApexPages.currentPage().getParameters().put('ProjectID', Proj.id);
        
        NCMT_ReportData objTest = new NCMT_ReportData();
        System.assert(objTest != null);
        objTest.DatasetProjectCostSummaryGrouped(Proj.id);
        
        objTest.getProjectInformation();
        Test.stopTest();
        objTest.getDatasetProjectCostSummary();  
        objTest.getDatasetHousingPlan();   

        objTest.getCoreShellData(); 
    }

    static testmethod void AUtilityProject1() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovUT1','Utility','Virginia','State Average','Core/Shell only'
                                        ,'1 story, high bay, light structure','P100: Baseline','Level I - Minimum','Urban', true, false, false, false, 10000, 0, 0, 0, false, false, false, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
        /*
       static testmethod void AUtilityProject1a() {
        NCMT_TestDataClass.CreateProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovUT1','Utility','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level I - Minimum','Urban', false, false, true, false, 10000, 0, 0, 1, false, false, false, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name, Stand_alone_Parking_Garage__c FROM NCMT_Project__c LIMIT 1];
		NCMT_Housing_Plan__c hp1 = new NCMT_Housing_Plan__c (id = null, recordtypeid = Schema.SObjectType.NCMT_Housing_Plan__c.getRecordTypeInfosByName().get('User Defined').getRecordTypeId());
          
           hp1.Project__c=proj.Id;
           insert hp1;
           proj.Stand_alone_Parking_Garage__c=1;
           proj.Below_Ground__c=1;
           update proj;
        System.assert(proj != null);
    } */
    //SFWS2040 starts
    static testmethod void AUtilityProject2() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovUT1','Utility','Virginia','State Average','Core/Shell only'
                                        ,'1 story, high bay, light structure','Code Minimum','Level I - Minimum','Urban', true, false, false, false, 10000, 0, 0, 0, false, false, false, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    //SFWS2040 ends
    
    
    static testmethod void ChildcareProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovCC1','Childcare Center','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 3000, 0, 0, 0, false, false, false, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    /* Duplicated in NCMT_TestParkingProjects 
    static testmethod void ParkingProject1() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG1', 'Virginia','State Average', 'Urban', 
                                                    'Parking Deck', 'Speed Ramp', 'Medium Efficiency', 'Medium',
                                                    3000, 2, 0, false);

                                                     
    }*/

    static testmethod void AParkingProject4() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG2', 'Virginia','State Average', 'Urban',                                                     
                                                    'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    1000, 3, 2, false);

        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);

        ApexPages.currentPage().getParameters().put('ProjectID', Proj.id);
        
        NCMT_ReportData objTest = new NCMT_ReportData();
        System.assert(objTest != null);
        objTest.DatasetProjectCostSummaryGrouped(Proj.id);
        
        objTest.getProjectInformation();
        Test.stopTest();
        objTest.getDatasetProjectCostSummary();  
        objTest.getDatasetHousingPlan();   

        objTest.getCoreShellData(); 
    }
    //SFWS2040 starts
    static testmethod void AParkingProject4a() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG2', 'Virginia','State Average', 'Urban',                                                     
                                                    'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    1000, 3, 2, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
        NCMT_GenerateProjectDetails testobjGenerateData=new NCMT_GenerateProjectDetails();
        List <NCMT_Housing_Plan_Summary__c> lstDelete = [SELECT Id from NCMT_Housing_Plan_Summary__c where Project__c = :proj.Id limit 1] ;
        testobjGenerateData.DeleteHousingPlanSummaryData(lstDelete[0].Id);
        
        testobjGenerateData.GenerateHousingPlanData(proj.Id, true, false, 'New Construction', false);
        
        testobjGenerateData.DeletePLPData(proj.Id);     
        testobjGenerateData.GeneratePLPData(proj.Id,'Parking Garage', 'New Construction','Parking Garage');
        
        //Update Project Level Parameter Data with data from Housing Plan
        testobjGenerateData.UpdatePLPData(proj.Id);        
        // Delete and Generate Cost Estimate Adjustment Data ...
        /*If (strProjectStatus == 'Draft'){
            objGenerateDataExt.DeleteEstimateAdjustments(proj.Id);
            objGenerateDataExt.GenerateEstimateAdjustments(trigger.new);
        }*/        
        //Generate Site Information Data
        testobjGenerateData.DeleteSiteInfoData(proj.Id);
        testobjGenerateData.GenerateSiteInfoData(proj.Id,'Parking Garage',1000,50,false, 'insert', 1000.00);
        
        testobjGenerateData.DeleteCoreShellData(proj.Id);
        //objGenerateDataCoreShellPG.GenerateCoreShellDataPG(proj.Id, 'Parking Garage');
    }
//SFWS2040 ends
  
    static testmethod void MedicalClinicProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovMC1','Medical Clinic','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, true, false, false, false, false, false, false);
        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(projs.size() == 0); //This test deletes the project because blnOtherCost == true
    }       

    static testmethod void MedicalOfficeProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovMO1','Medical Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }   
    
    static testmethod void DataCenterProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovDC1','Data Center','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
        
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
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
            
    static testmethod void AProfServEst() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst123', 'Virginia','State Average', 150000, 60000, 
                                                'Federal Office Building', 'New Construction', 'Design-Bid-Build', 'CM as Agent',
                                                '','','','','');
        Professional_Service_Estimate__c proj = [SELECT Id, Name FROM Professional_Service_Estimate__c LIMIT 1];
        System.assert(proj != null);
    }

    static testmethod void AProfServEstRA() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst1', 'Virginia','State Average', 150000, 60000, 
                                                'Federal Office Building', 'Repair & Alteration', 'Design-Bid-Build', 'CM as Agent',
                                                '','','','Limited Scope','1');
        Professional_Service_Estimate__c proj = [SELECT Id, Name FROM Professional_Service_Estimate__c LIMIT 1];
        System.assert(proj != null);
    }    
    
    static testmethod void AProfServEstRA2() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst2', 'Virginia','State Average', 60000, 26000000, 
                                                'Federal Office Building', 'Repair & Alteration', 'Design Build - Owned', 'Design-Build CM',
                                                '','Low','Low','Distributed Scope','2');
        Professional_Service_Estimate__c proj = [SELECT Id, Name FROM Professional_Service_Estimate__c LIMIT 1];
        System.assert(proj != null);
    }
    
    static testmethod void AProfServEstRA3() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst3', 'Virginia','State Average', 270000, 270000000, 
                                                'Courthouse', 'Repair & Alteration', 'Design Build - Leased', 'Developer CM',
                                                'Build to Suit','','','Full Modernization','3');
        Professional_Service_Estimate__c proj = [SELECT Id, Name FROM Professional_Service_Estimate__c LIMIT 1];
        System.assert(proj != null);
    }  
        
    static testmethod void OfficeRAProject1() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff1','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', false,'','',true,'');
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    //SFWS2040
    static testmethod void OfficeRAProject1a() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff1','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', false,'','',true,'');
        List<NCMT_Project__c> proj = [SELECT Id,Start_Construction__c, End_Construction__c, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
        List<NCMT_Building_Height_Parameter__c> bldgHghtParam=new List<NCMT_Building_Height_Parameter__c>();
        bldgHghtParam=Test.loadData(NCMT_Building_Height_Parameter__c.sObjectType, 'NCMT_Building_Height_Parameter');
        NCMT_GenerateProjectDetails objectGenerateData = new NCMT_GenerateProjectDetails();
 		System.assert(objectGenerateData != null);
        objectGenerateData.updateProjStartEndConstruction(proj,bldgHghtParam[0].Id,2000.00,'Core/Shell only');
    }
    static testmethod void OfficeRAProject1b() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff1','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', false,'','',true,'');
        List<NCMT_Project__c> proj = [SELECT Id,Start_Construction__c, End_Construction__c, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
        List<NCMT_Building_Height_Parameter__c> bldgHghtParam=new List<NCMT_Building_Height_Parameter__c>();
        bldgHghtParam=Test.loadData(NCMT_Building_Height_Parameter__c.sObjectType, 'NCMT_Building_Height_Parameter');
        NCMT_GenerateProjectDetails objectGenerateData = new NCMT_GenerateProjectDetails();
 		System.assert(objectGenerateData != null);
        objectGenerateData.updateProjStartEndConstruction(proj,bldgHghtParam[0].Id,2000.00,'TI Only');
    }
    static testmethod void OfficeRAProject1c() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff1','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', false,'','',true,'');
        List<NCMT_Project__c> proj = [SELECT Id,Start_Construction__c, End_Construction__c, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
        List<NCMT_Building_Height_Parameter__c> bldgHghtParam=new List<NCMT_Building_Height_Parameter__c>();
        bldgHghtParam=Test.loadData(NCMT_Building_Height_Parameter__c.sObjectType, 'NCMT_Building_Height_Parameter');
        NCMT_GenerateProjectDetails objectGenerateData = new NCMT_GenerateProjectDetails();
 		System.assert(objectGenerateData != null);
        objectGenerateData.updateProjStartEndConstruction(proj,bldgHghtParam[0].Id,15000.00,'Core/Shell with TI');
    }
    static testmethod void OfficeRAProject1d() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff1','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', false,'','',true,'');
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    //SFWS2040
    /*static testmethod void OfficeRAProject2() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Work Item Detail', 'testProjCodeCovRAOff2','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', true,'Roofing','Roofing - 2017 - 74',false,'Repair');
        
    }*/
    
    static testmethod void OfficeRAProject7() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Work Item Detail', 'testProjCodeCovRAOff3','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, 'Renovate', false,'','',false,'');
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }   

    static testmethod void OfficeRAProject8() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Work Item Detail', 'testProjCodeCovRAOff3','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, 'New Fit Out', false,'','',false,'');
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }  

    /*static testmethod void OfficeRAProject232() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Work Item Detail', 'testProjCodeCovRAOff4','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', true,'Land Improvements','Land Improvements - 2017 - 54',false,'Repair');
        
    }*/

    static testmethod void OfficeRAProject3() {
        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff5','Courthouse','Virginia','State Average','Core/Shell with TI'
                                        ,'Highrise (10 + stories)','P100: Baseline','Level II - Low','Urban', false, true, false, 'New Fit Out', false,'','',true,'');
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }    

    static testmethod void LPOEProject() {
        NCMT_TestRALPOEDataClass.CreateLPOEProject('New Construction', 'testProjCodeCovLPOE1','LPOE','California','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban','Medium','Medium', true);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    static testmethod void LPOEProject2() {
        NCMT_TestRALPOEDataClass.CreateLPOEProject('New Construction', 'testProjCodeCovLPOE2','LPOE','California','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Remote','Small','Small', false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
/*    static testmethod void DES_IncludeInEstimate() {
        NCMT_DES_Tree_Structure_trigger_test.test_IncludeInEstimate();
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
 */   
    static testmethod void HousingPlanClone() {
        NCMT_HousingPlanClone_Test.test_HousingPlanClone();
        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c LIMIT 3];
        System.assert(projs.size() == 2);
    }
    
    static testmethod void ProjectMarkupClone() {
        NCMT_ProjectMarkupClone_Test.test_ProjectMarkupClone();
        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c LIMIT 3];
        System.assert(projs.size() > 0);
    }
    
    static testmethod void tcoClone() {
        NCMT_GenerateTCOProjectDetailsExt_Test.test_TCOClone();
        List<NCMT_Project__c> projs = [SELECT Id, Name FROM NCMT_Project__c LIMIT 3];
        System.assert(projs.size() == 2);
    }
    
}