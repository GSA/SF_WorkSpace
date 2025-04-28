@isTest
public class LogEventPublishHandlerTest {
    
    @isTest
    static void logEventPublishTest(){
        
        Map<String,ID> profiles = new Map<String,ID>();  
        List<Profile> ps = [select id, name from Profile where name = 'GSA System Administrator' or name = 'System Administrator'];  
        for(Profile p : ps){  
            profiles.put(p.name, p.id);  
        }  
        User admin = [SELECT Id FROM user WHERE IsActive = True And profileid = :profiles.get('GSA System Administrator') Limit 1];  
        
        List<Database.SaveResult> results = null;
        system.runAs(admin){
            List<Log__e> events = new List<Log__e>();
            
            Log__e log1 = new Log__e();
            log1.Message__c = 'Test Message 1';
            events.add(log1);
            
            results = LogEventsPublishHandler.publishLogEvents(events, 'Test Class');
        }
        
        system.assertEquals(results.size(),1);
    }
    
    
    @isTest
    static void logEventPublishTest1(){
        Map<String,ID> profiles = new Map<String,ID>();  
        List<Profile> ps = [select id, name from Profile where name = 'GSA System Administrator' or name = 'System Administrator'];  
        for(Profile p : ps){  
            profiles.put(p.name, p.id);  
        }  
        User admin = [SELECT Id FROM user WHERE IsActive = True And profileid = :profiles.get('GSA System Administrator') Limit 1];  
        
        List<Database.SaveResult> results = null;
        system.runAs(admin){
            List<Log__e> events = new List<Log__e>();
            
            Log__e log1 = new Log__e();
            log1.Message__c = 'Test Message 1';
            events.add(log1);
            results = LogEventsPublishHandler.publishLogEvents(events);
        }
        system.assertEquals(results.size(),1);
    }
}