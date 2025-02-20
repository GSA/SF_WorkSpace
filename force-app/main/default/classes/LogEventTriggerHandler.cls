/**
* @author Vishnu G 
* @date May 2020.
*
* @group Trigger
*
* @description Trigger handler to handle custom log events 
               and create AppLog and AppLog Details accordingly 
*/
public with sharing class LogEventTriggerHandler {
    
    private List<Log__e> events;
    
    public LogEventTriggerHandler(List<Log__e> events) { 
        this.events = events;
    }
    
    /*
    * @description Processes BatchApexErrorEvents, creates App Log and App Log Details to persist the event details.
                   Uses UUID,a unique Identifier present on events, to group a App Log and AppLog Details
    * @return void
    */  
    public void handle() {
        try{
            Set<String> uuids = new Set<String>();
            Map<String, App_Log__c> appLogMap = new Map<String, App_Log__c>();
            Map<String, List<App_Log_Detail__c>> appLogDetailsById = new Map<String, List<App_Log_Detail__c>>();
            
            for(Log__e evt : events){
                uuids.add(evt.UUID__c);
                appLogDetailsById.put(evt.UUID__c, new List<App_Log_Detail__c>());
            }
                        
            //Fetch the existing App Logs with the Unique Id present in the above UUID set
            for(App_Log__c al : [Select Id, UUID__c from App_Log__c where UUID__c IN :uuids]){
                appLogMap.put(al.UUID__c, al);
            }
                        
            for(Log__e evt: events){
                String uuid = evt.UUID__c;
                
                if(appLogMap == null || !appLogMap.containsKey(uuid)){
                    App_Log__c appLog =  new App_Log__c(
                        Apex_Class_Name__c = evt.Apex_Class_Name__c,
                        Username__c = evt.Username__c,
                        Start_Time__c = DateTime.now(),
                        End_Time__c = DateTime.now(),
                        Log_Type__c = String.isNotBlank(evt.Log_Type__c) ? evt.Log_Type__c : 'Info', 
                        Apex_Job_Id__c = String.isNotBlank(evt.AsyncApexJobId__c) ? evt.AsyncApexJobId__c : '',
                        UUID__c = uuid
                    );
                    appLogMap.put(uuid, appLog);
                } 
                
                //To populate Apex JobId if present in an event
                if(appLogMap != null && appLogMap.containsKey(uuid) && String.isNotBlank(evt.AsyncApexJobId__c)){
                    appLogMap.get(uuid).Apex_Job_Id__c =  String.isNotBlank(evt.AsyncApexJobId__c) ? evt.AsyncApexJobId__c : '';
                }
                // Add Error to Log
                appLogDetailsById.get(uuid).add(
                    new App_Log_Detail__c(
                        Username__c = evt.Username__c,
                        Message__c = evt.Message__c,
                        Job_Scope__c = evt.JobScope__c));
            }
            
            // Insert log records
            upsert appLogMap.values();
                
            List<App_Log_Detail__c> logDetails = new List<App_Log_Detail__c>();
            for(String uniqueId : appLogMap.keySet()) {
                App_Log__c log = appLogMap.get(uniqueId);
                for(App_Log_Detail__c logDetail : appLogDetailsById.get(uniqueId)) {

                    logDetail.App_Log__c = log.Id;
                    logDetails.add(logDetail);
                }        
            }
            insert logDetails;  
                
        }catch(Exception e){
            System.debug('Exception on inserting App Log and App Log Details ---> ' + e);
        }
    }

}