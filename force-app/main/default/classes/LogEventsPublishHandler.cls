/**
* @author Vishnu G 
* @date May 2020.
*
* @group PlatformEvents Util
*
* @description Util class to publish custom platform events. This handler should be used to publish all Log events.
*/
public class LogEventsPublishHandler {

    //Static UniqueId for list of log events in a single transaction
    static string UUID = LogEventUtil.generateUUID();
    
    /*
    * @description Publish list of custom log events. Populates UUID(Unique Id) 
                   and class name (if given) on events before publishing.
    * @param List of log events to publish
    * @param ClassName associated with the events (Pass null, if no single class name associated )
    * @return List<Database.SaveResult> results from events publish
    */   
    public static List<Database.SaveResult> publishLogEvents(List<Log__e> events,String className){
        List<Log__e> logEventsToPublish = new List<Log__e>();
        List<Database.SaveResult> results = null;
        try{
            for(Log__e e: events){
                e.Apex_Class_Name__c = String.isNotBlank(className) ? className : (String.isNotBlank(e.Apex_Class_Name__c) ?
                                                                                  e.Apex_Class_Name__c : '');
                e.UUID__c = UUID;
                logEventsToPublish.add(e);
            }
            results = EventBus.publish(logEventsToPublish);
            if(results != null){
                for(Database.SaveResult s: results){
                    system.debug('s ----' + s.isSuccess());
                    system.debug('errors ---> ' + s.getErrors());
                }
            }                        
        } catch(Exception e){
            System.debug('Exception inserting log events ----> '+ e);
        }
        return results;
    }
    
    /*
    * @description Publish list of custom log events. Populates UUID(Unique Id) on events
    * @param list of log events to publish
    * @return List<Database.SaveResult> results from events publish
    */  
    public static List<Database.SaveResult> publishLogEvents(List<Log__e> events){
        List<Database.SaveResult> results = publishLogEvents(events, null);        
        return results;
    }
}