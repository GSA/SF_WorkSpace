@isTest
public with sharing class NCMT_CustomLookUpController_Test {
    @isTest
    public static void testMe() {
        
        List<sObject> fetched = NCMT_CustomLookUpController.fetchLookUpValues(null, 'NCMT_Assembly_Lookup_Detail__c', '2020');
        System.assert(fetched.size() == 0);
        
        fetched = NCMT_CustomLookUpController.fetchLookUpValues('test', 'NCMT_Contractor__c', '2020');
        System.assert(fetched.size() == 0);

        fetched = NCMT_CustomLookUpController.fetchLookUpValues(null, 'NCMT_Project__c', null);
        System.assert(fetched.size()== 0);

        fetched = NCMT_CustomLookUpController.fetchLookUpValues('test', 'NCMT_Project__c', null);
        System.assert(fetched.size()== 0);

        fetched = NCMT_CustomLookUpController.fetchMultiSelectLookup(null, 'NCMT_Project__c', 'Project_Comparison', new List<sObject>());
        System.assert(fetched.size()== 0);

        fetched = NCMT_CustomLookUpController.fetchMultiSelectLookup('test', 'NCMT_Project__c', 'Project_Comparison', new List<sObject>());
        System.assert(fetched.size()== 0);
    }
}