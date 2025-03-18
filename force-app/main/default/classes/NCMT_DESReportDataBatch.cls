global with sharing class NCMT_DESReportDataBatch implements Database.Batchable<sObject>,Schedulable{
    global Database.QueryLocator start(Database.BatchableContext BC) {         
        String query = 'SELECT Id, Name FROM NCMT_Project__c Where Estimate_Type_Proj__c = \'Definitive Estimating\' And Total_Project_Cost_Aggregate__c > 0';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<NCMT_Project__c> projects) {
        List<Id> projectIds = new List<Id>();
        // process each batch of records default size is 200
        for(NCMT_Project__c prj : projects) {        
            projectIds.add(prj.Id);
        }
        //system.debug(':::projectIds111:::'+projectIds);
        try {
            NCMT_DESReportDataBatchUtility.copyReportDataToObject(projectIds);
         
        } catch(Exception e) {
            System.debug(e);
            //System.debug(e.getStackTraceString());
            //System.debug(e.getMessage());
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
     global void execute(SchedulableContext sc) {
      NCMT_DESReportDataBatch b = new NCMT_DESReportDataBatch(); 
      Database.executeBatch(b,1);
   }
}