@isTest
Public class ScheduleSetupAuditTrailBatchTest{
   
    static testMethod void ScheduleTestMethod(){
		DateTime n = datetime.now().addMinutes(1);
   		String cron = '';
   		cron += n.second();
   		cron += ' ' + n.minute();
   		cron += ' ' + n.hour();
   		cron += ' ' + n.day();
   		cron += ' ' + n.month();
   		cron += ' ' + '?';
   		cron += ' ' + n.year();
   		
   		String jobId = System.schedule('SetupAuditTrailBatch', cron, new ScheduleSetupAuditTrailBatch());
   		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger 
                          WHERE id = :jobId];
   		System.assertEquals(cron, ct.CronExpression);
   		System.assertEquals(0, ct.TimesTriggered);
	}
    
    static testMethod void DeleteBatchTestMethod(){
        Audit__c a = new Audit__c();
        a.User__c = 'test@gsa.gov';
        a.Action__c = 'TestChange';
        a.Section__c = 'TestSection';
        a.Date__c = system.today();
        insert a;
        
        test.startTest();
        	SetUpAuditTrailDeleteBatch s = new SetUpAuditTrailDeleteBatch();
        	ID jobID = database.executeBatch(s);
        test.stopTest();
        AsyncApexJob ajob = [SELECT ID, Status, NumberOfErrors, JobItemsProcessed,
        				 TotalJobItems, CreatedBy.Email, ExtendedStatus
                         FROM AsyncApexJob WHERE ID =:jobID];
        
        system.assertEquals('Completed', ajob.Status);
	}
}