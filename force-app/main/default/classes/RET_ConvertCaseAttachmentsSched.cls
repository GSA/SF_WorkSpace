global class RET_ConvertCaseAttachmentsSched implements Schedulable {
   global void execute(SchedulableContext ctx) {
      RET_ConvertCaseAttachmentsBatch ret = new RET_ConvertCaseAttachmentsBatch();
      database.executeBatch(ret, 10);
   }   
}