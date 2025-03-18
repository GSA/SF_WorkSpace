@isTest
public class LogEventTriggerTest {
    
    @isTest
    static void logEventPublishTest(){
        Test.startTest();
        
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
            log1.Apex_Class_Name__c = 'Test Class';
            log1.UUID__c = 'DFJSJ#@$46';
            events.add(log1);
            
            results =  EventBus.publish(events);
        }
        
        Test.stopTest();
        System.assertEquals(results.size(), 1);
    }
    
    
    @isTest
    static void testExistingAppLog(){
        Map<String,ID> profiles = new Map<String,ID>();  
        List<Profile> ps = [select id, name from Profile where name = 'GSA System Administrator' or name = 'System Administrator'];  
        for(Profile p : ps){  
            profiles.put(p.name, p.id);  
        }  
        User admin = [SELECT Id FROM user WHERE IsActive = True And profileid = :profiles.get('GSA System Administrator') Limit 1];  
       
        system.runAs(admin){
            App_Log__c al = new App_Log__c(Apex_Class_Name__c  = 'Test Class', UUID__c = '12389-DVF348899-389');
            insert al;
            
            List<Log__e> events = new List<Log__e>();
            
            Log__e log1 = new Log__e();
            log1.Message__c = 'Test Message 1';
            log1.Apex_Class_Name__c = 'Test Class';
            log1.UUID__c = '12389-DVF348899-389';
            log1.AsyncApexJobId__c = '01I35000000Grb8';
            events.add(log1);

            Test.startTest();
            EventBus.publish(events);
            Test.stopTest();
            
        }
        List<App_Log_Detail__c> detail = [Select ID from App_Log_Detail__c];

        system.debug('logEventTriggerTest.testExistingAppLog(), App_Log_Detail__c IDs: ' + detail);   
        system.assertEquals(detail.size(), 1);
    }
}