/*
*********************************************************
Apex Class Name    : BatchProcessLogHandler_Test
Modified Date      : April 07, 2025
@description       : This is the test class for the BatchProcessLogHandler.  
@author            : Disha Bailoor
Modification Log:
Ver   Date         Author                               Modification
1.0   04-07-2025   Disha Bailoor                        Create.
*********************************************************
*/
@isTest
public class BatchProcessLogHandler_Test {
    public static String BATCH_NAME = 'Test_Batch_Class'; 
    @testSetup
    static void testSetup(){
        User u = [SELECT Id FROM User WHERE Profile.Name LIKE '%GSA System Admin%' AND isActive = TRUE LIMIT 1]; 
        PermissionSet ps = [SELECT Id, Name FROM PermissionSet 
                            WHERE Name =: 'OrgWide_Batch_Process_Log_System' LIMIT 1];
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = ps.Id, AssigneeId = u.Id);
		insert psa;  
    }
	@isTest
    static void testLogBatchCreate(){
        User u = getTestUser(); 
        Test.startTest(); 
        System.runAs(u){
        	 Batch_Process_Log__c log = BatchProcessLogHandler.logBatchCreate(BATCH_NAME);     
        }
        Test.stopTest(); 
        Batch_Process_Log__c log = [SELECT Id, Batch_Name__c, Status__c, Start_Date_Time__c, End_Date_Time__c,Error__c
                                    FROM Batch_Process_Log__c
                                    WHERE Batch_Name__c =: BATCH_NAME LIMIT 1];  
        System.assertEquals(BATCH_NAME, log.Batch_Name__c);
        System.assertEquals('Not Started', log.Status__c);  
        System.assertEquals(null, log.Start_Date_Time__c);
        System.assertEquals(null, log.End_Date_Time__c);
        System.assertEquals(null, log.Error__c);
    }
    @isTest
    static void testLogBatchStart(){
        User u = getTestUser();
        Test.startTest(); 
        System.runAs(u){
            Batch_Process_Log__c log = BatchProcessLogHandler.logBatchCreate(BATCH_NAME); 
        	log = BatchProcessLogHandler.logBatchStart(log); 
        }
        Test.stopTest(); 
        Batch_Process_Log__c log = [SELECT Id, Batch_Name__c, Status__c, Start_Date_Time__c, End_Date_Time__c,Error__c
                                    FROM Batch_Process_Log__c
                                    WHERE Batch_Name__c =: BATCH_NAME LIMIT 1]; 
        Assert.areEqual(BATCH_NAME, log.Batch_Name__c);
        Assert.areEqual('Running', log.Status__c);  
        Assert.isNotNull(log.Start_Date_Time__c);
        Assert.areEqual(null, log.End_Date_Time__c);
        Assert.areEqual(null, log.Error__c);  
    }
    @isTest
    static void testLogBatchSuccess(){
        User u = getTestUser();
        Test.startTest(); 
        System.runAs(u){
            Batch_Process_Log__c log = BatchProcessLogHandler.logBatchCreate(BATCH_NAME); 
            log = BatchProcessLogHandler.logBatchStart(log); 
            log = BatchProcessLogHandler.logBatchSuccess(log);
            List<Batch_Process_Log__c> logSuccess = BatchProcessLogHandler.getCompleteLog(BATCH_NAME);
        }
        Test.stopTest(); 
        Batch_Process_Log__c log = [SELECT Id, Batch_Name__c, Status__c, Start_Date_Time__c, End_Date_Time__c,Error__c
                                    FROM Batch_Process_Log__c
                                    WHERE Batch_Name__c =: BATCH_NAME LIMIT 1]; 
        System.assertEquals(BATCH_NAME, log.Batch_Name__c);
        System.assertEquals('Completed', log.Status__c);  
        System.assertNotEquals(null, log.Start_Date_Time__c);
        Assert.isNotNull(log.End_Date_Time__c);
        System.assertEquals(null, log.Error__c);
    }
    @isTest
    static void testLogBatchFailure(){
        User u = getTestUser();
        Test.startTest(); 
        System.runAs(u){
            Batch_Process_Log__c log = BatchProcessLogHandler.logBatchCreate(BATCH_NAME); 
            log = BatchProcessLogHandler.logBatchStart(log); 
            log = BatchProcessLogHandler.logBatchFailure(log, 'Test Error Message'); 
            List<Batch_Process_Log__c> logFail = BatchProcessLogHandler.getFailedLog(BATCH_NAME); 
        }
        Test.stopTest(); 
        Batch_Process_Log__c log = [SELECT Id, Batch_Name__c, Status__c, Start_Date_Time__c, End_Date_Time__c,Error__c
                                    FROM Batch_Process_Log__c
                                    WHERE Batch_Name__c =: BATCH_NAME LIMIT 1]; 
        System.assertEquals(BATCH_NAME, log.Batch_Name__c);
        System.assertEquals('Failed', log.Status__c);  
        System.assertNotEquals(null, log.Start_Date_Time__c);
        System.assertNotEquals(null, log.End_Date_Time__c);
        System.assertEquals('Test Error Message', log.Error__c);
    }
    @isTest
    static void testLogBatchPaused(){
        User u = getTestUser();
        Test.startTest(); 
        System.runAs(u){ 
            Batch_Process_Log__c log = BatchProcessLogHandler.logBatchCreate(BATCH_NAME); 
            log = BatchProcessLogHandler.logBatchStart(log); 
            log = BatchProcessLogHandler.logBatchPaused(log, null); 
            List<Batch_Process_Log__c> logPaused = BatchProcessLogHandler.getPausedLog(BATCH_NAME); 
        }
        Test.stopTest(); 
        Batch_Process_Log__c log = [SELECT Id, Batch_Name__c, Status__c, Start_Date_Time__c, End_Date_Time__c,Error__c, Last_Processed_Iterator__c
                                    FROM Batch_Process_Log__c
                                    WHERE Batch_Name__c =: BATCH_NAME LIMIT 1];
        System.assertEquals(BATCH_NAME, log.Batch_Name__c);
        System.assertEquals('Paused', log.Status__c);  
        System.assertNotEquals(null, log.Start_Date_Time__c);
        System.assertEquals(null, log.Last_Processed_Iterator__c);
    }
    static User getTestUser(){
        PermissionSetAssignment psa = [SELECT Id, AssigneeId 
                                       FROM PermissionSetAssignment 
                                       WHERE PermissionSet.Name =: 'OrgWide_Batch_Process_Log_System' LIMIT 1]; 
		User u = new User(Id = psa.AssigneeId); 
        return u; 
    }
}