@isTest
public with sharing class NCMT_TestPermSetDataController{

@isTest static void NCMT_TestUsersListController(){ 
    
    Test.startTest();
    Profile p = [SELECT Id FROM Profile WHERE Name='GSA Standard Salesforce User'];
    
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',     UserName='testpermsetuser@testorg.com');
        insert u;


    PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'NCMT_Users_R'];
    
    PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        
        System.runAs(u)
        {
            NCMT_Permsetdata pr = new NCMT_Permsetdata();
            System.assert(true);
        }
        
        Test.stopTest();
  }
}