/*
 * 	Class Description: This batch job retreives the records from System object SetupAuditTrail
 * and inserts in the custom object Audit__c. It also stores the data in a csv and 
 * creates a zip file document and stores in SetupAudit trail document folder which is 
 * Accessible only by the users with in the public group Audit Reporting Users CEO Org. 
 * The Batch is called from the finish method of the SetupAuditTrailDeleteBatch.apxc class to 
 * run the operations in sequence. 
 *  *********************************************************
	  Created By      | Version |  Date    | Description     
 *  *********************************************************
	  Ramesh Dugar       1.0      04/19/2017  Created 
*  *********************************************************/

global with sharing class SetUpAuditTrailInsertBatch implements Database.Batchable<sObject>,Database.Stateful{

	global String query = '';   
    global String csv = 'Id,Action,Section,User,Delegate User,Date\n';
    global List<Audit__c> auditLst;
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(Test.isRunningTest()){
        	return Database.getQueryLocator([Select Section, Id, Display, DelegateUser, CreatedDate, CreatedById,CreatedBy.Email, Action From SetupAuditTrail Limit 10]);

        }
		return Database.getQueryLocator([Select Section, Id, Display, DelegateUser, CreatedDate, CreatedById,CreatedBy.Email, Action From SetupAuditTrail]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<SetUpAuditTrail> audit= new List<SetUpAuditTrail>();
        List<Audit__c> auditlog = new List<Audit__c>();
        audit = scope;
        for ( SetUpAuditTrail a : audit ) {
			system.debug('===>a'+a);
            csv += a.id + ',' + a.Action.escapeCsv() +',' + a.Section + ',' + a.CreatedBy.Email +','+ a.DelegateUser+ ',' + a.CreatedDate +'\n';
            
			Audit__c auditVal= new Audit__c();
			if(a.Action!= null){  
				auditVal.Action__c= a.Action;
            }
			if(a.Section!= null){
				auditVal.Section__c= a.Section;
			}
         
			if(a.CreatedById!=null){
				auditVal.User__c = a.CreatedBy.Email;
			}    
			if(a.DelegateUser!= null){
				auditVal.Delegate_User__c= a.DelegateUser;
			}
        
			if(a.CreatedDate!= null){
				auditVal.Date__c = a.CreatedDate;
			}
			
			auditlog.add(auditVal);
        }  
        
		Insert auditlog;
        system.debug('***CSV'+csv);
       
    }

   global void finish(Database.BatchableContext BC){ 
   		Zippex zip = new Zippex();
        system.debug('****'+csv);
        zip.addFile('Audit.csv', Blob.valueOf(csv), null);
        Blob zipBlob = zip.getZipArchive();
        Id folderid = [Select Id,Name from Folder where Name='SetupAuditTrail' Limit 1].ID;
        Document doc = new Document();
        doc.FolderId = folderid;
        doc.Body = zipBlob;
        doc.Name = 'Audit'+system.today()+'.zip';
 
        insert doc;

   }
}