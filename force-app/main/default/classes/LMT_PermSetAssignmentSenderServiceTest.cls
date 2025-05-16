/*
*********************************************************
Apex Class Name    : LMT_PermSetAssignmentSenderServiceTest
Created Date       : April 14, 2025
@description       : This is the test class for LMT_PermSetAssignmentSenderService class. 
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-14-2025   Disha Bailoor						Create.
*********************************************************
*/
@isTest
public class LMT_PermSetAssignmentSenderServiceTest {    
    @isTest
    static void testPermissionSetupAuditProcessing(){   
        List<User> users = getUsers(); 
        
        User u;
        if (users.size() > 0) {
            u = users.get(0);
        }else{
            Assert.fail('Should never fail.'); 
        }
		
      	// Removing last 3 characters of User Id to use to Assertion
        String userId = u.Id;
        userId = userId.substring(0, userId.length()-3);
        
        List<SetupAuditTrail> setupAuditTrails = getSetupAuditTrails(); 
        SetupAuditTrail setupAuditTrail;
        if (setupAuditTrails.size() > 0) {
            setupAuditTrail = setupAuditTrails.get(0);
        }

        Assert.areEqual('PermSetAssign', setupAuditTrail.Action, 'PermSetAssign is the latest setupAuditTrailObject Action');
        Boolean containsUserId = setupAuditTrail.Display.contains(userId);
		Assert.isTrue(containsUserId, 'setupAuditTrail.Display text contains the User Id');
 
        //remove permission set assignment
        List<PermissionSetAssignment> psaList = [SELECT Id, PermissionSetId 
                                                 FROM PermissionSetAssignment 
                                                 WHERE AssigneeId = :u.Id AND 
                                                 PermissionSetId IN 
                                                 (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile = false)]; 
       
        if(!psaList.isEmpty()){
        	delete psaList; 
        }

        setupAuditTrails = [SELECT Id, CreatedDate, CreatedBy.Username, Display, Section, Action, DelegateUser,CreatedById,CreatedBy.Name FROM SetupAuditTrail ORDER BY CreatedDate DESC LIMIT 1];
        if (setupAuditTrails.size() > 0) {
            setupAuditTrail = setupAuditTrails.get(0);
        }

        Test.startTest();
            LMTMockHttpResponseSuccess mockResponse = new LMTMockHttpResponseSuccess(); 
            Test.setMock(HttpCalloutMock.class, mockResponse);
            LMT_PermSetAssignmentSenderService serviceTest = new LMT_PermSetAssignmentSenderService(); 
            serviceTest.processPermissionSetAssignments(setupAuditTrails); 
        Test.stopTest();
        
        System.assertEquals(200, mockResponse.getLastResponseStatusCode(), 'Success! Status Code 200'); 
        System.assert(mockResponse.getLastResponseBody().contains('Data processed successfully'), 'Expected response');
    }
    @isTest
    static void testPermissionSetSyncFailure(){
        List<User> users = getUsers(); 
        List<SetupAuditTrail> setupAuditTrails = getSetupAuditTrails(); 
        System.debug(setupAuditTrails); 
        //Mock HTTP response
        try{
            Test.startTest();
            LMTMockHttpResponseFailure mockResponse = new LMTMockHttpResponseFailure(); 
            Test.setMock(HttpCalloutMock.class, mockResponse); 
            
            //call the method being tested
            LMT_PermSetAssignmentSenderService serviceTest = new LMT_PermSetAssignmentSenderService(); 
            serviceTest.processPermissionSetAssignments(setupAuditTrails); 
            System.assert(false, 'Exception should have been thrown.'); 
            Test.stopTest();
            
        }catch(Exception e){
        	System.assert(e.getMessage().contains('Data process failed.'), 'Expected response');      
        }       
    }
    @isTest
    static void testScheduler(){
        Test.startTest(); 
        LMTMockHttpResponseSuccess mockResponse = new LMTMockHttpResponseSuccess(); 
        Test.setMock(HttpCalloutMock.class, mockResponse); 
        
        LMT_PermSetAssignmentHandler_Scheduler testScheduler = new LMT_PermSetAssignmentHandler_Scheduler();
        String sch = '20 30 8 10 2 ?';
		String jobID = System.schedule('LMT_PermSetAssignmentHandler_Scheduler', sch, testScheduler);
        Test.stopTest(); 
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger 
                          WHERE id = :jobId];
        System.assertEquals(sch, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);  
    }
    @isTest
    static void testBatch(){
        List<SetupAuditTrail> trails = getSetupAuditTrails();
        System.debug('testBatch: ' + trails); 
        Test.startTest(); 
        LMT_PermSetAssignmentHandler_Batch batchName = new LMT_PermSetAssignmentHandler_Batch();
        batchName.start(null); 
        batchName.finish(null); 
        Test.stopTest(); 
    }
    @isTest
    static void testBatchLog(){
        List<SetupAuditTrail> trails = getSetupAuditTrails();
        Batch_Process_Log__c log = BatchProcessLogHandler.logBatchCreate('LMT_PermSetAssignmentHandler_Batch'); 
        log.Status__c = 'Completed'; 
        update log; 
       	Test.startTest(); 
        LMTMockHttpResponseSuccess mockResponse = new LMTMockHttpResponseSuccess(); 
        Test.setMock(HttpCalloutMock.class, mockResponse); 
        
        LMT_PermSetAssignmentHandler_Scheduler testScheduler = new LMT_PermSetAssignmentHandler_Scheduler();
        String sch = '20 30 8 10 2 ?';
		String jobID = System.schedule('LMT_PermSetAssignmentHandler_Scheduler', sch, testScheduler);
        Test.stopTest(); 
        
    }
    public static List<User> getUsers(){
        return [SELECT ID, Profile.Name, CompanyName, FederationIdentifier, Profile.UserLicense.Id 
                            FROM User 
                            WHERE isActive = true 
                            AND Profile.Name LIKE '%GSA System Admin%' 
                            ORDER BY CreatedDate LIMIT 5];
    }
    public static List<SetupAuditTrail> getSetupAuditTrails(){
        List<User> users = [SELECT ID, Profile.Name, CompanyName, FederationIdentifier, Profile.UserLicense.Id 
                            FROM User 
                            WHERE isActive = true 
                            AND Profile.Name LIKE '%GSA System Admin%' 
                            ORDER BY CreatedDate LIMIT 5];
        User u;
        if (users.size() > 0) {
            u = users.get(0);
        }else{
            Assert.fail('Should never fail.'); 
        }
		
      	// Removing last 3 characters of User Id to use to Assertion
        String userId = u.Id;
        userId = userId.substring(0, userId.length()-3);
       
      	System.runAs(u) {     
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OrgWide_ModifyAll_System']; // Replace with your permission set name
    
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
    
            insert psa;
  		}
        List<SetupAuditTrail> setupAuditTrails = [SELECT Id, CreatedDate, CreatedBy.Username, Display, Section, Action, DelegateUser,CreatedById,CreatedBy.Name 
                                                  FROM SetupAuditTrail ORDER BY CreatedDate DESC LIMIT 1];
        return setupAuditTrails; 
    }
}