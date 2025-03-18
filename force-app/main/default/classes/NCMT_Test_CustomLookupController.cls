@isTest
public  class NCMT_Test_CustomLookupController {
    
    
    @isTest static void NCMT_Test_CustomLookupController() {
        List<NCMT_Cost_Category__c> listCostCategories = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_DES_Cost_Category');
        
        NCMT_Assembly_Lookup_Detail__c  Ulookup = new NCMT_Assembly_Lookup_Detail__c();
        Ulookup.Name = 'General Requirements - 2019 -9';
        Ulookup.Level_2__c = listCostCategories [1].id;
        Ulookup.Level_3_Description__c = 'Test level 3';
        Ulookup.Level_4_Description__c = 'Test level 4';
        Ulookup.Level_5_Description__c = 'Test level 5';
        Ulookup.Fiscal_Year__c = '2019';
        insert Ulookup;
        system.debug('Ulookup' + Ulookup);
        
        NCMT_Crew_Master__c crewMaster = new NCMT_Crew_Master__c();
        crewMaster.Name = 'testCM';
        crewMaster.Description__c = 'testCM';
        insert crewMaster;
        system.debug('crewMaster' + crewMaster);
        
        NCMT_Contractor__c contractor = new NCMT_Contractor__c();
        contractor.Name = 'testContractor';
        contractor.Contractor_Description__c = 'Test Contractor';
        contractor.Overhead__c = 10;
        contractor.Profit__c = 10;
        contractor.Bond__c = 2;
        contractor.Fiscal_Year__c = '2019';

        insert contractor;
        system.debug('contractor' + contractor);
        
        
        List<NCMT_Crew_Master__c> crewMasterVal = NCMT_CustomLookUpController.fetchLookUpValues('testCM', 'NCMT_Crew_Master__c', null);
        system.assertEquals('testCM', crewMasterVal[0].Name);
        
        List<NCMT_Assembly_Lookup_Detail__c> uniformatLookupVal = NCMT_CustomLookUpController.fetchLookUpValues('General Requirements - 2019 -9', 'NCMT_Assembly_Lookup_Detail__c', '2019');
        system.assertEquals('Test level 3', uniformatLookupVal[0].Level_3_Description__c);
        
        
        List<NCMT_Contractor__c> contractorVal = NCMT_CustomLookUpController.fetchLookUpValues('testContractor', 'NCMT_Contractor__c', '2019');
        system.assertEquals('testContractor', contractorVal[0].Name);
        
    }
    
}