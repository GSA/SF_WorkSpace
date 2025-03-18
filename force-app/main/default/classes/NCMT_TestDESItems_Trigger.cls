@isTest
public class NCMT_TestDESItems_Trigger {

     static testmethod void OfficeDESProject2() {
        
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff2','Office','Virginia','State Average','TI - Leasing','GSA Markups',false,true,false,false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
    static testmethod void OfficeDESProject3() {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff3','Office','Virginia','State Average','Build to Suit Lease','GSA Markups',true,false,false,false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
    
    static testmethod void OfficeDESProject4() {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff4','Office','Virginia','State Average','IDIQ-JOC','GSA Markups',false,false,true,false);
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        System.assert(proj != null);
    }
}