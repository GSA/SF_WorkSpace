@isTest
public class LMTUserDataSenderService_Queueable_Test {
    private static String jsonDatetime; 
    private static Batch_Process_Log__c log; 

	@testSetup
    static void testSetup(){
        User u = [SELECT Id FROM User WHERE Profile.Name LIKE '%GSA System Admin%' AND isActive = TRUE LIMIT 1]; 
        PermissionSet ps = [SELECT Id, Name FROM PermissionSet 
                            WHERE Name =: 'OrgWide_Batch_Process_Log_System' LIMIT 1];
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = ps.Id, AssigneeId = u.Id);
		insert psa;  
    }    
	@isTest
    static void testQueueableWithNulls(){
       	User u = getTestUser();
        System.runAs(u){
           Test.startTest(); 
           LMTMockHttpResponseSuccess mockResponse = new LMTMockHttpResponseSuccess(); 
           Test.setMock(HttpCalloutMock.class, mockResponse); 
           LMTUserDataSenderService_Scheduler sch = new LMTUserDataSenderService_Scheduler(); 
           sch.execute(null); 
           LMTUserDataSenderService_Queueable testOne = new LMTUserDataSenderService_Queueable(); 
           System.enqueueJob(testOne); 
           Test.stopTest();           
        }
    }
    @isTest
    static void testQueueableWithAllData(){
        User u = getTestUser();
        System.runAs(u){
            String dt = '2008-07-28T13:25:25.000+0000'; 
            Datetime fromDatetime = (DateTime)Json.deserialize('"'+dt+'"', DateTime.class);
            jsonDatetime = LMTUserDataSenderService_Queueable.datetimeToJson(fromDatetime); 
            Batch_Process_Log__c log = BatchProcessLogHandler.logBatchCreate('LMTUserDataSenderService_Queueable');
            Test.startTest(); 
            LMTMockHttpResponseSuccess mockResponse = new LMTMockHttpResponseSuccess(); 
            Test.setMock(HttpCalloutMock.class, mockResponse); 
            LMTUserDataSenderService_Queueable testOne = new LMTUserDataSenderService_Queueable(jsonDatetime, log); 
            System.enqueueJob(testOne); 
            Test.stopTest(); 
        }
    }
    @isTest
    static void schedulableTest(){
        User u = getTestUser();
        System.runAs(u){
            Batch_Process_Log__c completeLog = new Batch_Process_Log__c(); 
            completeLog.Batch_Name__c = 'LMTUserDataSenderService_Queueable'; 
            completeLog.Status__c = 'Completed';
            completeLog.Start_Date_Time__c = System.now(); 
            completeLog.End_Date_Time__c = System.now();
            insert completeLog; 
            System.debug('completeLog: ' + completeLog);
            Test.startTest(); 
            LMTUserDataSenderService_Scheduler sch = new LMTUserDataSenderService_Scheduler(); 
            sch.execute(null);
            Test.stopTest(); 
        }
    }
    static User getTestUser(){
        PermissionSetAssignment psa = [SELECT Id, AssigneeId 
                                       FROM PermissionSetAssignment 
                                       WHERE PermissionSet.Name =: 'OrgWide_Batch_Process_Log_System' LIMIT 1]; 
		User u = new User(Id = psa.AssigneeId); 
        return u; 
    }
}