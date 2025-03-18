/*
 * 	Class Description: This batch job retreives the records from custom object Login_History__c
 * and deletes all the record to create space to insert new records for current month's data from LoginHistory 
 * System Object. 
 * The Finish method of this batch chains to another batch job when run under non Test context and this line
 * cannot be covered by test case due to salesforce test method limitations. Below error will be encountered
 * if isRunnintTest condition is not validated.
 * "System.UnexpectedException: No more than one executeBatch can be called from within a testmethod. 
 * Please make sure the iterable returned from your start method matches the batch size, 
 * resulting in one executeBatch invocation."
 *  *********************************************************
	  Created By      | Version |  Date    | Description     
 *  *********************************************************
	  Ramesh Dugar       1.0      04/19/2017  Created 
*  *********************************************************/


global with sharing class LoginHistoryDeleteBatch implements Database.Batchable<sObject>{

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([SELECT Id FROM Login_History__c]);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     system.debug('The list of Audit is======>'+scope);
     Delete scope;
    }

   global void finish(Database.BatchableContext BC){
     if(!Test.isRunningTest()){
        //Execute the batch only under non test context
        Database.executeBatch(new LoginHistoryInsertBatch(), 200);
     }
   }
}