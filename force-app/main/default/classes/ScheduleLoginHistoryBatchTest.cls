@isTest
Public class ScheduleLoginHistoryBatchTest{
   
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
   		
   		String jobId = System.schedule('LoginHistoryBatchJob', cron, new ScheduleLoginHistoryBatch());
   		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger 
                          WHERE id = :jobId];
   		System.assertEquals(cron, ct.CronExpression);
   		System.assertEquals(0, ct.TimesTriggered);
	}
    
    static testMethod void DeleteBatchTestMethod(){
        Login_History__c l = new Login_History__c();
       	l.Username__c	='00530000009TyoYAAS';
 	 	l.Login_Time__c = system.today();
        l.Source_IP__c = '69.255.192.143';
        l.Login_Type__c = 'Application';
        l.Status__c = 'Failed:Computer activation required';
        l.Browser__c = 'Chrome 56';
        l.Platform__c = 'Mac OSX';
        l.Application__c = 'Browser';	  	 
		l.Client_Version__c	= 'N/A';
 	    l.API_Type__c = 'N/A';
        l.API_Version__c ='38.0';
        l.Login_URL__c = 'Test.salesforce.com';
        insert l;
        
        test.startTest();
        	LoginHistoryDeleteBatch lb = new LoginHistoryDeleteBatch();
        	ID batchID = database.executeBatch(lb);
        test.stopTest();
        AsyncApexJob ajob = [SELECT ID, Status, NumberOfErrors, JobItemsProcessed,
        				 TotalJobItems, CreatedBy.Email, ExtendedStatus
                         FROM AsyncApexJob WHERE ID =:batchID];
        
        system.assertEquals('Completed', ajob.Status);
	}
}