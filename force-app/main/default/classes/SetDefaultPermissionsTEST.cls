@IsTest (seeAllData = true)
public class SetDefaultPermissionsTEST{
    public static testMethod void testInsert(){
      //create and insert a user
      //Set up a user to assign to user lookup fields during test
        User user = new User();
        user.Username ='gsatestemail@test.com';
        user.LastName = 'GSATestLastName';
        user.Email = 'GSATestEmail@test.com';
        user.alias = 'GSAtest';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='GSA Standard Platform User'].Id;
        user.LanguageLocaleKey = 'en_US';
        user.SAML_Federation_ID_Custom__c = 'SAML ID';
        insert user;        
        system.assertEquals('GSAtest', user.alias);
    }   
    public static testMethod void testEdit(){
      //edit a user
        User user = new User();
        user.Username ='gsatestemail@test.com';
        user.LastName = 'GSATestLastName';
        user.Email = 'GSATestEmail@test.com';
        user.alias = 'GSAtest';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='GSA Standard Platform User'].Id;
        user.LanguageLocaleKey = 'en_US';
        user.SAML_Federation_ID_Custom__c = 'SAML ID';
        insert user;   
        user.ProfileId = [select id from Profile where Name='GSA Standard Platform User'].Id;
        update user;
        system.assertEquals('GSAtest', user.alias); 
        /*
        User runUser = [Select Id from User where Username=:LABEL.Cast_Iron_User Limit 1];
        System.runAs(runUser){
        	user.CommunityNickname = 'c2';
            update user;
       } */
            
/*        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');            
        insert config;    
        Test.startTest();
        PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = '', txtLongName__c = 'Testing Projects Long Name');
        insert proj;
        system.assertEquals('', proj.txtCreatedIn__c);           
        Test.stopTest();
*/        
    }   
/*    
    public static testMethod void testNoDefaults(){
    //Mark a user inactive
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');            
        insert config;    
        Test.startTest();
        PBS_Project__c proj = new PBS_Project__c();
        insert proj;
        system.assertEquals(null, proj.txtCreatedIn__c);           
        Test.stopTest();       
    }           
*/    
/*    
    public static testMethod void testMass(){
    //insert mass users
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');            
        insert config;
        Test.startTest();
        List<PBS_Project__c> projList = new List<PBS_Project__c>();
        for(Integer x=0; x<150; x++){
            PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = 'SOPT', txtLongName__c = 'Testing Projects Long Name');
            projList.add(proj);
        system.assertEquals('SOPT', proj.txtCreatedIn__c);                       
        }
        insert projList;
        Test.stopTest();           
    }  
    */             
}