/*
 * 	Class Description: This batch job retreives the records from System object LoginHistory
 * and inserts in the custom object Login_History__c. It also stores the data in a csv and 
 * creates a zip file document and stores in LoginHistory  document folder which is 
 * Accessible only by the users with in the public group Audit Reporting Users CEO Org. 
 * The Batch is called from the finish method of the LoginHistoryDelete.apxc class to 
 * run the operations in sequence. 
 *  *********************************************************
	  Created By      | Version |  Date    | Description     
 *  *********************************************************
	  Ramesh Dugar       1.0      04/19/2017  Created 
      Murugaboopathi Natarajan       1.1     01/12/2020  Modified 
*  *********************************************************/

global with sharing class LoginHistoryInsertBatch implements Database.Batchable<sObject>,Database.Stateful{
	global String query = '';   
    global string csv = 'UserId,Login Time,SourceIP,Login Type,Status,Browser,Platform,Application,Client Version,API Type,API Version,Login URL\n';
    //global List<Audit__c> auditLst;
    global Integer fileCountValue = 1;
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(Test.isRunningTest()){
        	return Database.getQueryLocator([Select UserId, Status, SourceIp, Platform, LoginUrl, LoginType, LoginTime, Id, ClientVersion, Browser, Application, ApiVersion, ApiType From LoginHistory LIMIT 10]);

        }
        Integer currentMonth = Integer.valueOf(System.Today().month());
        System.debug('currentMonth:'+currentMonth);
        Integer archivalMonth = (currentMonth <= 6)?currentMonth + 6:currentMonth - 6;
        System.debug('archivalMonth:'+archivalMonth);
    	return Database.getQueryLocator([Select UserId, Status, SourceIp, Platform, LoginUrl, LoginType, LoginTime, Id, ClientVersion, Browser, Application, ApiVersion, ApiType From LoginHistory WHERE CALENDAR_MONTH(LoginTime) = :archivalMonth]);
   }

	global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<LoginHistory> login= new List<LoginHistory>();
        List<Login_History__c> loginLog = new List<Login_History__c>();
        login = scope;
        for(LoginHistory l : login){
            csv += l.UserId + ','+ l.LoginTime + ',' + l.SourceIP + ',' + l.LoginType + ',' + l.Status + ',' + l.Browser + ',' + l.Platform + ',' + l.Application + ',' + l.ClientVersion + ',' + l.APIType + ',' + l.APIVersion + ',' + l.LoginURL + '\n';
            Login_History__c logVal = new Login_History__c();
            if(l.UserId!=null){
                logVal.Username__c = l.UserId;
            }
            
            if(l.Status!=null){
                logVal.Status__c = l.Status;
            }
            
            if(l.SourceIp!=null){
                logVal.Source_IP__c = l.SourceIp;
            }
            
            if(l.Platform!=null){
                logVal.Platform__c = l.Platform;
            }
            
            if(l.LoginUrl!=null){
                logVal.Login_Url__c = l.LoginUrl;
            }
            
            if(l.LoginType!=null){
                logVal.Login_Type__c = l.LoginType;
            }
            
            if(l.LoginTime!=null){
                logVal.Login_Time__c = l.LoginTime;
            }
            
            if(l.ClientVersion!=null){
                logVal.Client_Version__c = l.ClientVersion;
            }
            
            if(l.Browser!=null){
                logVal.Browser__c = l.Browser;
            }
            
            if(l.Application!=null){
                logVal.Application__c = l.Application;
            }
            
            if(l.ApiVersion!=null){
                logVal.Api_Version__c = l.ApiVersion;
            }
            
            if(l.ApiType!=null){
                logVal.Api_Type__c = l.ApiType;
            }
            
            loginLog.add(logVal);
        }
        insert loginLog;
        if((Limits.getHeapSize() + 50000) >= Limits.getLimitHeapSize()) {
            //Zippex zip = new Zippex();
            //system.debug('****'+csv);
            //zip.addFile('LoginHistory.csv', Blob.valueOf(csv), null);
            //Blob zipBlob = zip.getZipArchive();
            Id folderid = [Select Id,Name from Folder where Name='LoginHistory' Limit 1].ID;
            Document doc = new Document();
            doc.FolderId = folderid;
            //doc.Body = zipBlob;
            doc.Body = Blob.valueOf(csv);
            doc.Name = 'LoginHistory-'+fileCountValue+'-'+system.today()+'.csv';
            insert doc;
            fileCountValue = fileCountValue + 1;
            // implement logic to reduce
            csv = null;
            csv = 'UserId,Login Time,SourceIP,Login Type,Status,Browser,Platform,Application,Client Version,API Type,API Version,Login URL\n';
        }
  
    }

    global void finish(Database.BatchableContext BC){ 
    	//Zippex zip = new Zippex();
        //system.debug('****'+csv);
        //zip.addFile('LoginHistory.csv', Blob.valueOf(csv), null);
        //Blob zipBlob = zip.getZipArchive();
        Id folderid = [Select Id,Name from Folder where Name='LoginHistory' Limit 1].ID;
        Document doc = new Document();
        doc.FolderId = folderid;
        doc.Body = Blob.valueOf(csv);
        //doc.Body = zipBlob;
        //doc.Name = 'LoginHistory'+system.today()+'.zip';
        doc.Name = 'LoginHistory-'+fileCountValue+'-'+system.today()+'.csv';
        insert doc;
    }
}