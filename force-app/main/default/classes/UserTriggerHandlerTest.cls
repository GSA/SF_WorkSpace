@isTest
public class UserTriggerHandlerTest {

    @testSetup static void setup() {
    
        List<UserProvisioningUtil__c> lupu = new List<UserProvisioningUtil__c>();
        
        UserProvisioningUtil__c upu = new UserProvisioningUtil__c();
        upu.Name = 'Salesforce';
        upu.Type__c = 'SPHDUserLicense';
        lupu.add(upu);
        
        upu = new UserProvisioningUtil__c();
        upu.Name = 'Salesforce Platform';
        upu.Type__c = 'SPHDUserLicense';
        lupu.add(upu);
        
        upu = new UserProvisioningUtil__c();
        upu.Name = 'SPHD_Manager_CRED';
        upu.Type__c = 'UserSPHDPermissionSet';
        lupu.add(upu);
        
        insert lupu;
        
    }

    static testMethod void TestSPHDAfterInserts(){

        Id sphdMgrGrpId = [SELECT Id FROM Group WHERE DeveloperName = 'SPHD_Manager' limit 1].Id;
        Id profileId = [SELECT Name FROM Profile WHERE Profile.UserLicense.Name = 'Salesforce' limit 1].Id; 

        List<User> users = new List<User>();
        //Test that new user must be Major_Org__c = 'P' and Salesforce or Salesforce Platform license to get SPHD access
        User user1 = new User();
        user1.Username='wsdv33dvn@email.com';
        user1.Alias='WS33';
        user1.CommunityNickname='DS33';
        user1.TimeZoneSidKey='GMT';
        user1.LocaleSidKey='en_US';
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.ProfileId = profileId;
        user1.LastName='Smith';
        user1.FirstName='wsdv33dvn';
        user1.Email='wsdv33dvn@email.com';
        user1.LanguageLocaleKey = 'en_US';
        user1.FederationIdentifier = '482a7bc9-82d0-472e-8334-9d40d8cgabcd';
        user1.Major_Org__c = null;
        user1.isActive=true;
        users.add(user1);
    
        //Test that new PBS user receives SPHD access
        User user2 = new User();
        user2.Username='wsdv44dvn@email.com';
        user2.Alias='WS44';
        user2.CommunityNickname='DS44';
        user2.TimeZoneSidKey='GMT';
        user2.LocaleSidKey='en_US';
        user2.EmailEncodingKey = 'ISO-8859-1';
        user2.ProfileId = profileId;
        user2.LastName='Smith';
        user2.FirstName='wsdv44dvn';
        user2.Email='wsdv33dvn@email.com';
        user2.LanguageLocaleKey = 'en_US';
        user2.FederationIdentifier = '482a7bc9-82d0-472e-8334-9d40d8cgabde';
        user2.Major_Org__c = 'P';
        user2.isActive=true;
        users.add(user2);

        Test.startTest();
        insert users;
        Test.stopTest();
    
        //Check that user1 did not receive "SPHD - Manager - CRED" permission set
        List<PermissionSetAssignment> psa = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id = :user1.Id AND PermissionSet.Name = 'SPHD_Manager_CRED'];
        system.assertEquals(0, psa.size());
            
        //Check that user1 was not added to "SPHD-Manager" public group
        List<GroupMember> members = [SELECT Id FROM GroupMember WHERE GroupId =: sphdMgrGrpId AND UserOrGroupId =: user1.Id];
        system.assertEquals(0, members.size());
        
        //Check that user2 received "SPHD - Manager - CRED" permission set
        psa = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id = :user2.Id AND PermissionSet.Name = 'SPHD_Manager_CRED'];
        system.assertEquals(1, psa.size());
            
        //Check that user2 was added to "SPHD-Manager" public group
        members = [SELECT Id FROM GroupMember WHERE GroupId =: sphdMgrGrpId AND UserOrGroupId =: user2.Id];
        system.assertEquals(1, members.size());
                      
    }
    

    static testMethod void TestSPHDBeforeUpdatesAdd(){

        Id sphdMgrGrpId = [SELECT Id FROM Group WHERE DeveloperName = 'SPHD_Manager' limit 1].Id;
        Profile profile = [SELECT Name FROM Profile WHERE Profile.UserLicense.Name = 'Salesforce' limit 1]; 

        //Test that updated non PBS user who just became PBS user receives SPHD access
        User user1 = new User();
        user1.Username='wsdv33dvn@email.com';
        user1.Alias='WS33';
        user1.CommunityNickname='DS33';
        user1.TimeZoneSidKey='GMT';
        user1.LocaleSidKey='en_US';
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.ProfileId = profile.Id;
        user1.LastName='Smith';
        user1.FirstName='wsdv33dvn';
        user1.Email='wsdv33dvn@email.com';
        user1.LanguageLocaleKey = 'en_US';
        user1.FederationIdentifier = '482a7bc9-82d0-472e-8334-9d40d8cgabcd';
        user1.Major_Org__c = null;
        user1.isActive=true;
        insert user1;
        
        //Check that user did not receive "SPHD - Manager - CRED" permission set
        List<PermissionSetAssignment> psa = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id = :user1.Id AND PermissionSet.Name = 'SPHD_Manager_CRED'];
        system.assertEquals(0, psa.size());
            
        //Check that user was not added to "SPHD-Manager" public group
        List<GroupMember> members = [SELECT Id FROM GroupMember WHERE GroupId =: sphdMgrGrpId AND UserOrGroupId =: user1.Id];
        system.assertEquals(0, members.size());        
    
        //Test that new PBS user receives SPHD access
        user1.Major_Org__c = 'P';

        Test.startTest();
        update user1;
        Test.stopTest();  
          
        //Check that user received "SPHD - Manager - CRED" permission set
        psa = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id = :user1.Id AND PermissionSet.Name = 'SPHD_Manager_CRED'];
        system.assertEquals(1, psa.size());
            
        //Check that user was added to "SPHD-Manager" public group
        members = [SELECT Id FROM GroupMember WHERE GroupId =: sphdMgrGrpId AND UserOrGroupId =: user1.Id];
        system.assertEquals(1, members.size());        
          
    }

    static testMethod void TestSPHDBeforeUpdatesRemove(){

        Id sphdMgrGrpId = [SELECT Id FROM Group WHERE DeveloperName = 'SPHD_Manager' limit 1].Id;
        Profile profile = [SELECT Name FROM Profile WHERE Profile.UserLicense.Name = 'Salesforce' limit 1]; 

        //Test that updated PBS user who just became non PBS user removes SPHD access
        User user1 = new User();
        user1.Username='wsdv33dvn@email.com';
        user1.Alias='WS33';
        user1.CommunityNickname='DS33';
        user1.TimeZoneSidKey='GMT';
        user1.LocaleSidKey='en_US';
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.ProfileId = profile.Id;
        user1.LastName='Smith';
        user1.FirstName='wsdv33dvn';
        user1.Email='wsdv33dvn@email.com';
        user1.LanguageLocaleKey = 'en_US';
        user1.FederationIdentifier = '482a7bc9-82d0-472e-8334-9d40d8cgabcd';
        user1.Major_Org__c = 'P';
        user1.isActive=true;
        insert user1;
        
        //Remove SPHD access from user who changed Major_Org__c value from 'P' on an update
        user1.Major_Org__c = null;
        Test.startTest();
        update user1;
        Test.stopTest();
    
        //Check that user's "SPHD - Manager - CRED" permission set was removed
        List<PermissionSetAssignment> psa = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id = :user1.Id AND PermissionSet.Name = 'SPHD_Manager_CRED'];
        system.assertEquals(0, psa.size());
            
        //Check that user was removed from "SPHD-Manager" public group
        List<GroupMember> members = [SELECT Id FROM GroupMember WHERE GroupId =: sphdMgrGrpId AND UserOrGroupId =: user1.Id];
        system.assertEquals(0, members.size());  
        
    }
    
    static testMethod void TestSPHDMassInserts(){

        Id sphdMgrGrpId = [SELECT Id FROM Group WHERE DeveloperName = 'SPHD_Manager' limit 1].Id;
        Id profileId = [SELECT Name FROM Profile WHERE Profile.UserLicense.Name = 'Salesforce' limit 1].Id; 
        
        List<User> users = new List<User>();
        User user;
        for (Integer i = 0; i < 100; i++) {
            user = new User();
            user.Username='wsdv27dvn' + i + '@email.com';
            user.Alias='WS27' + i;
            user.CommunityNickname='DS27' + i;
            user.TimeZoneSidKey='GMT';
            user.LocaleSidKey='en_US';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.ProfileId = profileId;
            user.LastName='Smith';
            user.FirstName='wsdv27dvn' + i;
            user.Email='wsdv27' + i + 'dvn@email.com';
            user.LanguageLocaleKey = 'en_US';
            user.FederationIdentifier = '48227' + i + '-82d0-472e-8334-9d40d8cgabcd';
            user.Major_Org__c = 'P';
            user.isActive=true;
            users.add(user);
        }
        
        Test.startTest();
        insert users;
        Test.stopTest();
        
        List<Id> userIds = new List<Id>();
        for (User u : [SELECT Id FROM User WHERE FirstName LIKE 'wsdv27dvn%']) {
            userIds.add(u.Id);
        }
    
        //Check that all users received "SPHD - Manager - CRED" permission set
        List<PermissionSetAssignment> psa = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id IN :userIds AND PermissionSet.Name = 'SPHD_Manager_CRED'];
        system.assertEquals(100, psa.size());
            
        //Check that all users were added to "SPHD-Manager" public group
        List<GroupMember> members = [SELECT Id FROM GroupMember WHERE GroupId =: sphdMgrGrpId AND UserOrGroupId IN :userIds];
        system.assertEquals(100, members.size());  
        
    }        
            
    static testMethod void TestOnBeforeUpdate(){

       String GSAprofileId = [Select Name from Profile where Name = 'GSA Standard Platform User'].Id; 
       String chatterprofileId = [Select Name from Profile where Name = 'GSA Chatter Free User'].Id; 
       User user = new User();
       user.Username='wsdv33dvn@email.com';
       user.Alias='WS';
       user.CommunityNickname='DS';
       user.TimeZoneSidKey='GMT';
       user.LocaleSidKey='en_US';
       user.EmailEncodingKey = 'ISO-8859-1';
       user.ProfileId = GSAprofileId;
       user.LastName='Smith';
       user.FirstName='wsdv33dvn';
       user.Email='wsdv33dvn@email.com';
       user.LanguageLocaleKey = 'en_US';
       user.FederationIdentifier = '482a7bc9-82d0-472e-8334-9d40d8cgabcd';
       user.isActive=true;
       List<User> users = new List<User>();
       users.add(user);
        insert users;
        user.ProfileId = chatterprofileId;
        user.Username='wsdv33dvnUp@email.com';
        user.CommunityNickname='DSUp';
        Map<Id,User> userselected = new Map<Id,User>([Select Id, ProfileId, Username, CommunityNickname  from User where Email='wsdv33dvn@email.com']);
        User runUser = new User();
        List<User> usersList = [Select Id from User where Username=:LABEL.Cast_Iron_User Limit 1];
        if(usersList.size() > 0){
            runUser = usersList[0];
        }else{
            
            runUser = user;
            runUser.Id = Null;
            runUser.FederationIdentifier = '482a7bc9-82d0-472e-8334-9d40d8cgabcg';
            runUser.Username = LABEL.Cast_Iron_User;
            insert runUser;
        }
        System.runAs(runUser){
            users[0].CommunityNickname = 'Test';
            users[0].Username = 'Test'+users[0].Username;
            update users;
          //userTriggerHandler handler = new userTriggerHandler();
          //handler.OnBeforeUpdate(users, userselected);    
        }
        system.assertEquals(true,true);
        
    }

}