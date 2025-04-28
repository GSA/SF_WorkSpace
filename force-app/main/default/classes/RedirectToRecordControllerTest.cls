@isTest(seeAllData = True)
public with sharing class RedirectToRecordControllerTest {

	@isTest
    static void cloneNCMTOtherDirectCostTest() {
          Date CostParaDate = date.newinstance(2016, 10, 1);
        
        List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');

        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                                                            and State__c = 'Virginia' and Name = 'State Average'];        
              
        NCMT_Project__c Proj = new NCMT_Project__c ();
                        
        Proj.Project_type__c = 'New Construction';
        Proj.Building_Type__c = 'Office';
        Proj.Estimate_Type_Proj__c  = 'Parametric';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Building_Selection__c = 'New';
        Proj.Name = 'testProjCodeCovRAOff123';
        Proj.State__c = 'Virginia';
        Proj.City__c = 'State Average'; 
        Proj.Purpose_of_Estimate__c = 'Scenario Planning';
        
        Proj.Location__c = objlocation.Id;
        
        Date ConstDate = date.newinstance(2019, 1, 1);
        Date EndConstDate = date.newinstance(2020, 10, 1);
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
        Proj.Cost_Parameter_Date__c = CostParaDate;
        
        insert Proj;
        
         //Get list of Project Cost Summary records inserted with Project
        List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c 
                                                              From NCMT_Project_Cost_Summary__c Where Project_Name__c = :Proj.Id Limit 1000];
        
        
        Id recordTypeId = Schema.SObjectType.NCMT_Other_Cost__c.getRecordTypeInfosByName().get('Other Facilities - Other Direct Cost').getRecordTypeId();
        
        //Other Cost
        NCMT_Other_Cost__c oc = new NCMT_Other_Cost__c(NCMT_Project__c = Proj.Id, Cost_Type__c = 'Direct Costs',
                                                        NCMT_Other_Cost_Original_Record_Id__c = null, RecordTypeId = recordTypeId);
        insert oc;
        
        //Other Direct Cost
        NCMT_Other_Direct_Cost__c odc = new NCMT_Other_Direct_Cost__c(Project_Cost_Summary__c = listCostSummary[0].Id, 
                                                                      NCMT_Other_Cost__c = oc.Id);
        insert odc;
        
        
                
        NCMT_Project__c cloneProj = new NCMT_Project__c ();
                        
        cloneProj.Project_type__c = 'New Construction';
        cloneProj.Building_Type__c = 'Office';
        cloneProj.Estimate_Type_Proj__c  = 'Parametric';
        cloneProj.Purpose_of_Estimate__c = 'Project Controls';
        cloneProj.Building_Selection__c = 'New';
        cloneProj.Name = 'testProjCodeCovRAOff123';
        cloneProj.State__c = 'Virginia';
        cloneProj.City__c = 'State Average'; 
        cloneProj.Purpose_of_Estimate__c = 'Scenario Planning';        
        cloneProj.Location__c = objlocation.Id;
        cloneProj.Start_Construction__c = ConstDate;
        cloneProj.Building_Cost_Type__c = 'Core/Shell with TI';
        cloneProj.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        cloneProj.Building_Quality__c = 'P100: Baseline';        
        cloneProj.Level_of_Protection__c = 'Level II - Low';
        cloneProj.Remoteness__c = 'Urban';
        cloneProj.Gross_Area__c = false;
        cloneProj.Useable_Area__c = false;
        cloneProj.Housing_Plan__c = true;
        cloneProj.Project_Status__c = 'Draft';
        cloneProj.Cost_Parameter_Date__c = CostParaDate;        
        insert cloneProj;
        
        //Other Cost
        NCMT_Other_Cost__c oc1 = new NCMT_Other_Cost__c(NCMT_Project__c = cloneProj.Id, Cost_Type__c = 'Direct Costs',
                                                        NCMT_Other_Cost_Original_Record_Id__c = oc.id, RecordTypeId = recordTypeId);
        insert oc1;
        
        Test.startTest();
        RedirectToRecordController.cloneNCMTOtherDirectCost(cloneProj.id);
        Test.stopTest();
    }
    
}