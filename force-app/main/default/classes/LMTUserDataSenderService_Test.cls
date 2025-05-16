/*
*********************************************************
Apex Class Name    : LMTUserDataSenderService_Test
Modified Date      : April 07, 2025
@description       : This is a test class for LMTUserDataSenderService.
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-07-2025   Disha Bailoor                        Create.
*********************************************************
*/
@isTest
private class LMTUserDataSenderService_Test {
	@testSetup
    static void setupTestData(){
        Profile stdProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Standard%' LIMIT 1];
        //Create test users 
        List<User> users = new List<User>(); 
        
        for(Integer i = 0; i < 3; i++){
            User u = new User(
            	FirstName = 'Test', 
                LastName = 'User' + i, 
                Email = 'test' + i + '@example.com', 
                Username = 'test' + i + '@example.com.salesforce',
                FederationIdentifier = 'fedID'+i, 
                Alias = 'tuser' + i, 
                CommunityNickname = 'tuser' + i, 
                ProfileId = stdProfile.Id, 
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US', 
                EmailEncodingKey = 'UTF-8', 
                LanguageLocaleKey = 'en_US', 
                IsActive = true         
            ); 
            users.add(u); 
        }
        insert users; 
    }
    
    @isTest
    static void testSendUserAndOrgData_Success(){
        //retrieve data
        List<User> users = [SELECT Id, FederationIdentifier, Email, IsActive, User_License__c, LastLoginDate, CreatedDate
                            FROM User 
                            WHERE IsActive = TRUE AND User_License__c != NULL AND LastLoginDate != NULL LIMIT 5]; 
        Organization org = [SELECT Id, Name FROM Organization LIMIT 1];
        
        Test.startTest(); 
        
        //Mock HTTP response
        LMTMockHttpResponseSuccess mockResponse = new LMTMockHttpResponseSuccess(); 
        Test.setMock(HttpCalloutMock.class, mockResponse); 
        
        //call the method being tested
        LMTUserDataSenderService.sendUserAndOrgData(users, org);
        
        Test.stopTest(); 
        
        System.assertEquals(200, mockResponse.getLastResponseStatusCode(), 'Success! Status Code 200'); 
        System.assert(mockResponse.getLastResponseBody().contains('Data processed successfully'), 'Expected response');
        
        
    }
     @isTest
    static void testSendUserAndOrgData_Failure(){
        //retrieve data
        List<User> users = [SELECT Id, FederationIdentifier, Email, IsActive, User_License__c, LastLoginDate, CreatedDate
                            FROM User WHERE Email LIKE '%@example.com%' LIMIT 2]; 
        Organization org = [SELECT Id, Name FROM Organization LIMIT 1];

        //Mock HTTP response
        try{
            Test.startTest();
            LMTMockHttpResponseFailure mockResponse = new LMTMockHttpResponseFailure(); 
            Test.setMock(HttpCalloutMock.class, mockResponse); 
            
            //call the method being tested
            LMTUserDataSenderService.sendUserAndOrgData(users, org);
            System.assert(false, 'Exception should have been thrown.'); 
            Test.stopTest();
            
        }catch(Exception e){
        	System.assert(e.getMessage().contains('Data process failed.'), 'Expected response');      
        }     
    }
}