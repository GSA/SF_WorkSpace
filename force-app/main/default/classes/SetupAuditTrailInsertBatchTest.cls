@isTest(SeeAllData=false)
Public class SetupAuditTrailInsertBatchTest{   
    static testMethod void TestMethod1(){
        test.startTest();
        	SetUpAuditTrailInsertBatch si = new SetUpAuditTrailInsertBatch();
        	ID batchID = database.executeBatch(si);
        test.stopTest();
        AsyncApexJob a = [SELECT ID, Status, NumberOfErrors, JobItemsProcessed,
        				 TotalJobItems, CreatedBy.Email, ExtendedStatus
                         FROM AsyncApexJob WHERE ID =:batchID];
        
        system.assertEquals('Completed', a.Status);
        
	}
}