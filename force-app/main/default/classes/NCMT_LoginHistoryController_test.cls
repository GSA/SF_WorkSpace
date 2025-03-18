@isTest
public class NCMT_LoginHistoryController_test {
    @testSetup static void setup(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='GSA Standard Salesforce User'];
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',     UserName='testpermsetuser@testorg.com',
                          NCMT_UserRegionCode__c='CO', NCMT_User_Level__c = 'Level V');
        insert u;
        system.assertNotEquals(NULL,u); 

        
    }

    @isTest static void testLoginHistoryCtrl(){
        User usr = [SELECT Id, Name FROM User LIMIT 1];

            system.assertNotEquals(NULL, usr);
            
            NCMT_LoginHistoryController.reportData testReport =NCMT_LoginHistoryController.retrieveloginhist(0);

            system.assertNotEquals(NULL, testReport.usrList);   
    
            
    }
    

}