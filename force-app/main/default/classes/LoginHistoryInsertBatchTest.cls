@isTest(SeeAllData=false)
Public class LoginHistoryInsertBatchTest{   
    static testMethod void TestMethod1(){
        test.startTest();
        	LoginHistoryInsertBatch lh = new LoginHistoryInsertBatch();
        	ID batchID = database.executeBatch(lh);
        test.stopTest();
        AsyncApexJob a = [SELECT ID, Status, NumberOfErrors, JobItemsProcessed,
        				 TotalJobItems, CreatedBy.Email, ExtendedStatus
                         FROM AsyncApexJob WHERE ID =:batchID];
        
        system.assertEquals('Completed', a.Status);
        
	}
}