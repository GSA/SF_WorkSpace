/*
 * 	Class Description: Scheduler class for SetUpAuditTrailDeleteBatch class.
 *  *********************************************************
	  Created By      | Version |  Date    | Description     
 *  *********************************************************
	  Ramesh Dugar       1.0      04/19/2017  Created 
 *  ********************************************************
*/

global class ScheduleSetupAuditTrailBatch implements Schedulable{
    global void execute(SchedulableContext SC) {
       SetUpAuditTrailDeleteBatch sa = new SetUpAuditTrailDeleteBatch();
       database.executeBatch(sa,200);
    }
}