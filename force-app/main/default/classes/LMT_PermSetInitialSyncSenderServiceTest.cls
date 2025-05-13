/*
*********************************************************
Apex Class Name    : LMT_PermSetInitialSyncSenderServiceTest
Created Date       : April 14, 2025
@description       : This is the test class for LMT_PermSetInitialSyncSenderService class. 
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-14-2025   Disha Bailoor						Create.
*********************************************************
*/
@isTest
public class LMT_PermSetInitialSyncSenderServiceTest {
    @isTest
    static void testPermissionSetSync(){
        List<User> users = getUsers(); 
        User u;
        if (users.size() > 1) {
            u = users.get(0);
        }else{
            Assert.fail('Should never fail.'); 
        }
		
      	// Removing last 3 characters of User Id to use to Assertion
        String userId = u.Id;
        userId = userId.substring(0, userId.length()-3);
        
        Organization org = [SELECT Id, Name FROM Organization]; 
        System.debug(u); 
        System.runAs(u) {
            List<LMT_CRM_Permission_Sets__mdt> crmPermSets = [SELECT Id, DeveloperName FROM LMT_CRM_Permission_Sets__mdt]; 
            List<String> crmDeveloperNames = new List<String>(); 
            for(LMT_CRM_Permission_Sets__mdt license : crmPermSets){
                if(license != null){crmDeveloperNames.add(license.DeveloperName);}
            }
            System.debug(crmPermSets); 
            PermissionSet ps = [SELECT Id FROM PermissionSet 
                                WHERE Name NOT IN:crmDeveloperNames 
                                	AND IsOwnedByProfile = false
                                	AND LicenseId =: u.Profile.UserLicense.Id
                                	LIMIT 1];

            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
    
            insert psa;
        }
        
        
        Test.startTest();
        LMTMockHttpResponseSuccess mockResponse = new LMTMockHttpResponseSuccess(); 
        Test.setMock(HttpCalloutMock.class, mockResponse);
        LMT_PermSetInitialSyncSenderService serviceTest = new LMT_PermSetInitialSyncSenderService(); 
        serviceTest.processCRMAssignments(users); 
        Test.stopTest();

        System.assertEquals(200, mockResponse.getLastResponseStatusCode(), 'Success! Status Code 200'); 
        System.assert(mockResponse.getLastResponseBody().contains('Data processed successfully'), 'Expected response');
    }
    @isTest 
    static void testScheduler(){
        User u = getUserWithPerms();
        System.runAs(u) {
            Test.startTest(); 
            LMTMockHttpResponseSuccess mockResponse = new LMTMockHttpResponseSuccess(); 
            Test.setMock(HttpCalloutMock.class, mockResponse); 
            
            LMT_PermSetInitialSync_Scheduler testScheduler = new LMT_PermSetInitialSync_Scheduler();
            String sch = '20 30 8 10 2 ?';
            String jobID = System.schedule('LMT_PermSetInitialSync_Scheduler', sch, testScheduler);
            Test.stopTest(); 
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                              FROM CronTrigger 
                              WHERE id = :jobId];
            System.assertEquals(sch, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);   
        }
    }
    @isTest
    static void testPermissionSetSyncFailure(){
        List<User> users = getUsers(); 
        
        //Mock HTTP response
        try{
            Test.startTest();
            LMTMockHttpResponseFailure mockResponse = new LMTMockHttpResponseFailure(); 
            Test.setMock(HttpCalloutMock.class, mockResponse); 
            
            //call the method being tested
            LMT_PermSetInitialSyncSenderService serviceTest = new LMT_PermSetInitialSyncSenderService(); 
        	serviceTest.processCRMAssignments(users); 
            System.assert(false, 'Exception should have been thrown.'); 
            Test.stopTest();
            
        }catch(Exception e){
        	System.assert(e.getMessage().contains('Data process failed.'), 'Expected response');      
        }       
    }

    public static List<User> getUsers(){
        return [SELECT ID, Profile.Name, CompanyName, FederationIdentifier, Profile.UserLicense.Id 
                            FROM User 
                            WHERE isActive = true 
                            AND Profile.Name LIKE '%GSA System Admin%' 
                            ORDER BY CreatedDate LIMIT 5];
    }
    public static User getUserWithPerms(){
        List<User> users = [SELECT ID 
                            FROM User 
                            WHERE isActive = true 
                            AND Profile.Name LIKE '%GSA System Admin%' 
                            ORDER BY CreatedDate LIMIT 1];
        if(users.size() > 0){
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :'OrgWide_Batch_Process_Log_System'];
            PermissionSetAssignment assignment = new PermissionSetAssignment(AssigneeId = users[0].Id,PermissionSetId = ps.Id);
            insert assignment; 
        }
        return users[0]; 
    }
}