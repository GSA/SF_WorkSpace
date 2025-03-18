global class ScheduleLoginHistoryBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        LoginHistoryDeleteBatch lh = new LoginHistoryDeleteBatch();
        database.executeBatch(lh,200);
    }

}