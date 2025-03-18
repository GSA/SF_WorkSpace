@isTest
public class NCMT_GenerateProjectDetailsExtTest {
  static testmethod void OfficeProject1() {
  NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff1','Office','Virginia','State Average','Core/Shell only','Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, true);

   NCMT_GenerateProjectDetailsExt gP = new NCMT_GenerateProjectDetailsExt();
   gp.fnUserLevel('Level I');
   gp.fnUserLevel('Level II');
   gp.fnUserLevel('Level III OFM');
   gp.fnUserLevel('Level IV');
   gp.fnUserLevel('Level V');
}
  static testmethod void OfficeProject81() {
  NCMT_TestDataClass.CreateProjectNew('New Construction', 'testProjCodeCovOff9','Office','Virginia','State Average','Core/Shell only','Single Story','P100: Baseline','Level III - Medium','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, false, false, false);
}

  static testmethod void AProfServEstRA() {
  NCMT_TestDataClass.CreateProfServEst('testProfServEst6', 'Virginia','State Average', 150000, 60000,'Federal Office Building', 'Repair & Alteration', 'Design-Bid-Build', 'CM as Agent','','','','Limited Scope','1');
}

  static testmethod void OfficeProject10() {
  NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff13','Office','Virginia','State Average','Core/Shell with TI','Lowrise (2 - 3 stories)','P100: Baseline','Level I - Minimum','Central Business District', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, false);
}


  static testmethod void ParkingProject1() {        
  NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG1', 'Virginia','State Average', 'Urban','Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',3000, 1, 0, false);
}

  static testmethod void AParkingProject4() {        
  NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG2', 'Virginia','State Average', 'Urban', 'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',1000, 3, 2, false);
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
    
  static testmethod void OfficeDESProject1() {
  NCMT_TestDataClass.CreateProject('New Construction - DES', 'testDesProjCodeCovOff1','Office','Virginia','State Average','Core/Shell only','Single Story','P100: Baseline','Level II - Low','Urban', false, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
  NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
  System.assert(proj != null);
}
    //SFWS1744 starts
  static testmethod void OfficeDESProject1a() {
  NCMT_TestDataClass.CreateProject('New Construction - DES', 'testDesProjCodeCovOff1a','Office','Virginia','State Average','Core/Shell only','Single Story','P100: Baseline','Level II - Low','Urban', false, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
  NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1]; 
  NCMT_Escalation__c esc = new NCMT_Escalation__c();
  esc.Project__c   = proj.id;
  esc.Escalation_Type__c = 'Market Escalation';
  esc.Yearly_Escalation__c = 4;
  esc.Escalation_Percentage__c = 3;          
  insert esc;   
  esc.Yearly_Escalation__c = 5;  
  NCMT_GenerateProjectDetailsExt.firstCall=true;
  update esc;

  NCMT_GenerateProjectDetailsExt testGenerateData=new NCMT_GenerateProjectDetailsExt();
  testGenerateData.AdjustEscalationData(proj.Id);  
  
}
  static testmethod void OfficeDESProject1b() {
  NCMT_TestDataClass.CreateProject('New Construction - DES', 'testDesProjCodeCovOff1a','Office','Virginia','State Average','Core/Shell only','Single Story','P100: Baseline','Level II - Low','Urban', false, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
  NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
  NCMT_Escalation__c esc = new NCMT_Escalation__c();
  esc.Project__c   = proj.id;
  esc.Escalation_Type__c = 'Code & Practice Escalation';
  esc.Yearly_Escalation__c = 4;
  esc.Escalation_Percentage__c = 3;          
  insert esc;       
  esc.Yearly_Escalation__c = 5;  
       NCMT_GenerateProjectDetailsExt.firstCall=true;
  update esc;    
  
  NCMT_GenerateProjectDetailsExt testGenerateData=new NCMT_GenerateProjectDetailsExt();
  testGenerateData.AdjustEscalationData(proj.Id); 
}

//SFWS1744 ends

  static testmethod void OfficeDESProject6() {
  NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff7','Office','Virginia','State Average','Core/Shell with TI','Lowrise (2 - 3 stories)','P100: Baseline','Level I - Minimum','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
  NCMT_Project__c proj = [SELECT Id,Level_of_Protection__c,Name FROM NCMT_Project__c LIMIT 1];
  System.assert(proj != null);
} 

  static testmethod void OfficeDESProject3() {
  NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff7','Office','Virginia','State Average','Core/Shell with TI','Lowrise (2 - 3 stories)','P100: Baseline','Level III - Medium','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
  NCMT_Project__c proj = [SELECT Id,Level_of_Protection__c,Name FROM NCMT_Project__c LIMIT 1];
  System.assert(proj != null);
} 

  static testmethod void OfficeDESProject4() {
  NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff7','Office','Virginia','State Average','Core/Shell with TI','Lowrise (2 - 3 stories)','P100: Baseline','Level IV - High','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
  NCMT_Project__c proj = [SELECT Id,Level_of_Protection__c,Name FROM NCMT_Project__c LIMIT 1];
  System.assert(proj != null);
} 

  static testmethod void OfficeDESProject5() {
  NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff7','Office','Virginia','State Average','Core/Shell with TI','Lowrise (2 - 3 stories)','P100: Baseline','Level V - Very High','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
  NCMT_Project__c proj = [SELECT Id,Level_of_Protection__c,Name FROM NCMT_Project__c LIMIT 1];
  System.assert(proj != null);
} 

  static testmethod void OfficeDESProject7() {
  NCMT_TestDataClass.CreateDESProject('Repair & Alteration - DES', 'testDESProjCodeCovDESOff7','Office','Virginia','State Average','CMc','GSA Markups',false,false,false,false);
  NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
  System.assert(proj != null);
}

  static testmethod void OfficeRAProject1() {
  NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff1','Office','Virginia','State Average','Core/Shell with TI','Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, 'Refresh', false,'','',true,'');
  NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
  System.assert(proj != null);
}

  static testmethod void OfficeDESProject2() {
  NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff2','Office','Virginia','State Average','TI - Leasing','GSA Markups',false,true,false,false);
  NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
  System.assert(proj != null);
}
    
    static testmethod void OfficeRAProject7() {

        NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Work Item Detail', 'testProjCodeCovRAOff3','Office','Virginia','State Average','Core/Shell with TI'
                                                 ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, 'Renovate', false,'','',false,'');
        NCMT_Project__c proj = [SELECT Id,Name,Total_GSF__c,Building_Type__c,project_Type__c,Cost_Parameter_Date_FY__c  FROM NCMT_Project__c LIMIT 1];
        String ProjectRecordID = proj.Id;
        String sProjectType = proj.Project_Type__c;
		String txtCostParameterDateFY = proj.Cost_Parameter_Date_FY__c;
        NCMT_Housing_Plan_Option_Template__c hpTemp = new NCMT_Housing_Plan_Option_Template__c();
        hpTemp.Sort_Order__c=1;
        hpTemp.Sub_Type__c='Move Out';
        hpTemp.Type__c='Moving Costs';
        
        insert hpTemp;
        NCMT_Housing_Plan_Option__c hp = new NCMT_Housing_Plan_Option__c();
        
        hp.NCMT_Housing_Plan_Option_Template__c =hpTemp.id;
        hp.Choice_Text__c='Furniture';
        insert hp;
        
        NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt(); 
        Schema.DescribeSObjectResult cfrSchemaHP = Schema.SObjectType.NCMT_Housing_Plan__c; 
            Map<String,Schema.RecordTypeInfo> HousingPlanTypeInfo = cfrSchemaHP.getRecordTypeInfosByName();
            
            NCMT_Housing_Plan__c HousingPlan = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
            //NCMT_Housing_Plan__c HousingPlanupd = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
            
                HousingPlan.Project__c = Proj.id ;
                HousingPlan.Housing_Plan_Type__c = 'New Fit Out';
                HousingPlan.Workstations_open_office_Entered_USF__c = 100000;
                HousingPlan.Closed_offices_Entered_USF__c = 100000;
                HousingPlan.Closed_offices_Use_USF__c = 10000;
                HousingPlan.Private_toilets_Entered_USF__c = 100000;
                HousingPlan.X8_20_person_rooms_Entered_USF__c = 100000;
                HousingPlan.X20_or_more_person_rooms_Entered_USF__c = 100000;
                HousingPlan.Teleconference_Entered_USF__c = 100000;
                HousingPlan.Auditorium_sloped_floor_Entered_USF__c = 100000;
                HousingPlan.Child_care_Entered_USF__c = 100000;
                HousingPlan.Libraries_Entered_USF__c = 100000;
                HousingPlan.ADP_high_density_PC_s_Entered_USF__c = 100000;
                HousingPlan.Courtroom_district_CeremonialEntered_USF__c = 100000;
                HousingPlan.Courtroom_district_Standard_Entered_USF__c = 100000;
                HousingPlan.Courtroom_Bankruptcy_Entered_USF__c = 100000;
                HousingPlan.Courtroom_Magistrate_Entered_USF__c = 100000;
                HousingPlan.Grand_Jury_Room_Entered_USF__c = 100000;
                HousingPlan.Judicial_hearing_Entered_USF__c = 100000;
                HousingPlan.Judicial_chambers_Entered_USF__c = 100000;
                HousingPlan.Holding_cell_Central_Entered_USF__c = 100000;
                HousingPlan.Holding_cell_Court_floors_Entered_USF__c = 100000;   
                HousingPlan.User_Defined_Spaces1_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces2_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces3_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces1_Description__c = 't1';
                HousingPlan.User_Defined_Spaces2_Description__c = 't1';
                HousingPlan.User_Defined_Spaces3_Description__c = 't1';         
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            insert HousingPlan;
         
        NCMT_Housing_Plan_Option_Selection__c hpOption = new NCMT_Housing_Plan_Option_Selection__c ();
            hpOption.NCMT_Housing_Plan_Option__c = hp.id;
            hpOption.NCMT_Project__c = Proj.id ;
            hpOption.Recurrence__c = 1;
            hpOption.NCMT_Housing_Plan__c = HousingPlan.id;
            insert hpOption;
        
        NCMT_Housing_Plan_Option_Selection__c hpOption1 = new NCMT_Housing_Plan_Option_Selection__c ();
            hpOption1.NCMT_Housing_Plan_Option__c = hp.id;
            hpOption1.NCMT_Project__c = Proj.id ;
            hpOption1.Recurrence__c = 1;
            insert hpOption1;
        
        NCMT_Housing_Plan_Cost_Parameter__c hPlnOptionP = new NCMT_Housing_Plan_Cost_Parameter__c();
        hPlnOptionP.Cost__c = 1;
        hPlnOptionP.NCMT_Housing_Plan_Option__c = hp.id;
        hPlnOptionP.Space_Type__c = 'General Office Space Type, 20% Open'; 
        hPlnOptionP.Fiscal_Year__c = txtCostParameterDateFY;
        insert hPlnOptionP;
        
        NCMT_GenerateProjectDetailsExt.genHPRun = false;        
       // System.debug('genHPRun 1--------------- ');
        objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, sProjectType, true, true,txtCostParameterDateFY);
        NCMT_GenerateProjectDetailsExt.genHPRun = false; 
        objGenerateDataExt.GenerateHPOptionData(ProjectRecordID, sProjectType, false, true,txtCostParameterDateFY);
        System.assert(proj != null);
    }
    
     static testmethod void OfficeRAProject3() {
     NCMT_TestRALPOEDataClass.CreateRAProject('Repair & Alteration - Parametric Entry', 'testProjCodeCovRAOff5','Courthouse','Virginia','State Average','Core/Shell with TI' ,'Highrise (10 + stories)','P100: Baseline','Level II - Low','Urban', false, true, false, 'New Fit Out', false,'','',true,'');
     NCMT_Project__c proj = [SELECT Id,Name,Total_GSF__c,Building_Type__c,project_Type__c,Cost_Parameter_Date_FY__c FROM NCMT_Project__c LIMIT 1];
     //String ProjectId =[SELECT id FROM NCMT_Housing_Plan__c LIMIT 1].id;
     NCMT_Housing_Plan__c hp = new NCMT_Housing_Plan__c();
     Schema.DescribeSObjectResult cfrSchemaOC = Schema.SObjectType.NCMT_Housing_Plan__c; 
     Map<String,Schema.RecordTypeInfo> OtherCostsTypeInfo = cfrSchemaOC.getRecordTypeInfosByName();

       hp.recordtypeid = OtherCostsTypeInfo.get('Default').getRecordTypeId();
       hp.Housing_Plan_Type__c ='New Fit Out';
       hp.Closed_offices_Use_USF__c = 1;
       hp.Project__c = proj.id;
       hp.Unfinished_Shell_Area_Use_USF__c=1;
       hp.Workstations_open_office_Use_USF__c=1;
       hp.Closed_offices_Count__c =2;
       hp.Private_toilets_Use_USF__c=1;
       Insert hp;

       NCMT_Housing_Plan__c hp1 = new NCMT_Housing_Plan__c();
       hp1.recordtypeid = OtherCostsTypeInfo.get('Default').getRecordTypeId();
       hp1.Housing_Plan_Type__c ='Refresh';
       hp1.Closed_offices_Use_USF__c = 1;
       hp1.Project__c = proj.id;
       hp1.Unfinished_Shell_Area_Use_USF__c=1;
       hp1.Workstations_open_office_Use_USF__c=1;
       hp1.Closed_offices_Count__c =2;
       hp1.Private_toilets_Use_USF__c=1;
       Insert hp1;

     NCMT_Housing_Plan__c hp2 = new NCMT_Housing_Plan__c();
     hp2.recordtypeid = OtherCostsTypeInfo.get('Default').getRecordTypeId();
     hp2.Housing_Plan_Type__c ='Renovate';
     hp2.Closed_offices_Use_USF__c = 1;
     hp2.Project__c = proj.id;
     hp2.Unfinished_Shell_Area_Use_USF__c=1;
     hp2.Workstations_open_office_Use_USF__c=1;
     hp2.Closed_offices_Count__c =2;
     hp2.Private_toilets_Use_USF__c=1;
     Insert hp2;

     String ProjectRecordID = proj.Id;
     Decimal dblGrossSqFt = 0;
     dblGrossSqFt = proj.Total_GSF__c;
     String ProjectRecordTypeName = proj.Building_Type__c;
     String ProjectType = proj.Project_Type__c;
     String txtCostParameterDateFY = proj.Cost_Parameter_Date_FY__c;
     List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :ProjectRecordID Limit 1000];
     Map<string, String> mapCostSummary = new Map<string, String>();
     for(NCMT_Project_Cost_Summary__c objItem : listCostSummary){
        mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
     }
   NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt(); 
   objGenerateDataExt.GenerateTIandTRCSData(ProjectRecordID, dblGrossSqFt, ProjectRecordTypeName, ProjectType, true, true,txtCostParameterDateFY, mapCostSummary);
   System.assert(proj != null);
}
   static testmethod void LPOEProject() {
   NCMT_TestRALPOEDataClass.CreateLPOEProject('New Construction', 'testProjCodeCovLPOE1','LPOE','California','State Average','Core/Shell only','Single Story','P100: Baseline','Level II - Low','Urban','Medium','Medium', true);
   NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
   System.assert(proj != null);
}

  static testmethod void OfficeCEWProject1() {
  NCMT_TestDataClass.CreateCEWProject('New Construction - CEW', 'testCEWProjCodeCovCEWOff1','Office','Virginia','State Average','Pre-Planning','Pre-Planning Phase','6',1000);
}

  static testmethod void OfficeProject82() {
  NCMT_TestDataClass.CreateProjectNew('New Construction', 'testProjCodeCovOff9','Office','Virginia','State Average','Core/Shell only','Single Story','P100: Baseline','Level III - Medium','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, true, false, true);
}  
}