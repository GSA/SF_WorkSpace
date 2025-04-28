global class RET_ConvertOldDraftCasesSched implements Schedulable {
   global void execute(SchedulableContext ctx) {
      RET_ConvertOldDraftCasesBatch ret = new RET_ConvertOldDraftCasesBatch();
        database.executeBatch(ret, 20);
   }   
}