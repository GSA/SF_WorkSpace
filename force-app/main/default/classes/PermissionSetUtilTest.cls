@isTest
//NOTE:  THIS TEST MAKES USE OF THE SetDefaultPermissions TRIGGER AND MUST BE MOVED WITH IT.
public class PermissionSetUtilTest
{
        @testSetup static void setup0() {
    
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
            
               upu = new UserProvisioningUtil__c();
        upu.Name = 'GSA Standard Salesforce User';
        upu.Type__c = 'ExclusionUserLicense';
        lupu.add(upu);
        
        insert lupu;
        
    }

     @testSetup static void setup1() {
    
        List<UserTestProvisioningUtil__c> lupu = new List<UserTestProvisioningUtil__c>();
        
        UserTestProvisioningUtil__c upu = new UserTestProvisioningUtil__c();
        upu.Name = 'Salesforce';
        upu.Type__c = 'SPHDUserLicense';
        lupu.add(upu);
        
        UserTestProvisioningUtil__c upu1 = new UserTestProvisioningUtil__c();
        upu1.Name = 'Salesforce Platform';
        upu1.Type__c = 'SPHDUserLicense';
        lupu.add(upu1);
        
        UserTestProvisioningUtil__c upu2 = new UserTestProvisioningUtil__c();
        upu2.Name = 'SOPT_Standard_User';
        upu2.Type__c = 'UserDefaultPermissionSet';
        lupu.add(upu2);
         
        UserTestProvisioningUtil__c  upu3 = new UserTestProvisioningUtil__c();
        upu3.Name = 'SPHD_Manager_CRED';
        upu3.Type__c = 'UserSPHDPermissionSet';
        lupu.add(upu3);
        
         UserTestProvisioningUtil__c  upu4 = new UserTestProvisioningUtil__c();
        upu4.Name = 'GSA Standard Salesforce User';
        upu4.Type__c = 'ExclusionUserLicense';
        lupu.add(upu4);
        insert lupu; 
    }
    
      @testSetup static void setup2() {
    
        List<PermissionSet> PermissionSetList = new List<PermissionSet>();
        
        PermissionSet ps = new PermissionSet();
        ps.Name = 'Salesforce1';
        ps.Label = 'Salesforce1';
        PermissionSetList.add(ps);
         
        PermissionSet ps2 = new PermissionSet();
        ps2.Name = 'Salesforce_Platform1';
        ps2.Label = 'Salesforce_Platform1';
        PermissionSetList.add(ps2); 
          
        PermissionSet ps3 = new PermissionSet();
        ps3.Name = 'SOPT_Standard_User';
        ps3.Label = 'SOPT_Standard_User';
        PermissionSetList.add(ps3);
          
         insert PermissionSetList;
        
    }
    static testMethod void assignPermissionSetsToUsers() 
    {
        Test.startTest();
        
        //Sets is Test Method to true so testing custom setting gets used
        PublicGroupUserSyncHelper.isTestMethod = true;
        //GSA Standard Salesforce User profile must be present in environment
        Profile p = [SELECT Id FROM Profile WHERE Name='GSA Standard Salesforce User']; 
        
        //A Salesforce user license must be available for user to be assigned to
        UserLicense userLicence = [Select u.SystemModstamp, u.Name, u.LicenseDefinitionKey, u.Id From UserLicense u where u.Name = 'Salesforce'];
        //UserLicense userLicence = [Select u.SystemModstamp, u.Name, u.MonthlyLoginsUsed, u.MonthlyLoginsEntitlement, u.LicenseDefinitionKey, u.Id From UserLicense u where u.Name = 'Salesforce'];        
      
        string randomName = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');     
        string userName = 't123';   
        
        User u2 = new User(Alias = 't123xy', Email=randomName+userName+'@gsa.gov', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, MAJOR_ORG__c = 'P',       
        TimeZoneSidKey='America/Los_Angeles', UserName=randomName+userName+'@gsa.gov',CommunityNickname='t123xy',IsActive=true);            
        //When this insert happens the trigger is called
        insert u2;
        Test.stopTest();
        List<PermissionSet> psList = PermissionSetUtil.getPermissionSetList();
        Map<Id,Set<PermissionSetAssignment>> psAssignmentList = PermissionSetUtil.getUserPermissionSetAssignmentMap(psList);
         //Gets permission set or sets listed as UserDefaultPermissionSet types in Custom Settings
        //For each set, gets the users assigned to that set and checks to see if this test user is one of them
        for(Id perMissionSetId :psAssignmentList.KeySet()) 
        {
            Set<PermissionSetAssignment> assignmentList = psAssignmentList.get(perMissionSetId);
            Set<Id> existingUserIds = new Set<Id>();
            for(PermissionSetAssignment psAssignment : assignmentList )
            {
                if(!existingUserIds.contains(psAssignment.AssigneeId))
                {
                    existingUserIds.add(psAssignment.AssigneeId);
                }
            }
            //If trigger worked properly this assertion is true, user should be in the permissionsetassignment list
            System.assertEquals(existingUserIds.contains(u2.Id),true);
        }
        PublicGroupUserSyncHelper.isTestMethod = false;
        //Test.stopTest();
        
    }
   static testMethod void updatePermissionSetsToUsers() 
    {
        Test.startTest();
        PublicGroupUserSyncHelper.isTestMethod = true;
        Profile p = [SELECT Id FROM Profile WHERE Name='GSA Standard Salesforce User'];                  
        UserLicense userLicence = [Select u.SystemModstamp, u.Name, u.LicenseDefinitionKey, u.Id From UserLicense u where u.Name = 'Salesforce'];
        UserLicense chatterLicence = [Select u.SystemModstamp, u.Name, u.LicenseDefinitionKey, u.Id From UserLicense u where u.Name = 'Chatter Free'];        
        Profile c = [SELECT Id FROM Profile WHERE Name='Chatter Free User'];                          
        Profile cm = [SELECT Id FROM Profile WHERE Name='Contract Manager'];                                  
        
        string randomName = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');     
        string userName = 't123';   
        
        string userName2 = 't1234';           
        
        User u2 = new User(Alias = 't123xy', Email=randomName+userName+'@gsa.gov', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName=randomName+userName+'@gsa.gov',CommunityNickname='t123xy');            
        
        insert u2;
        
        User u3 = new User(Alias = 't123ab', Email=randomName+userName2+'@gsa.gov', 
        EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = c.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName=randomName+userName2+'@gsa.gov',CommunityNickname='t123ab');            
        
        insert u3;
        
        
        List<PermissionSet> psList = PermissionSetUtil.getPermissionSetList();
        Map<Id,Set<PermissionSetAssignment>> psAssignmentList = PermissionSetUtil.getUserPermissionSetAssignmentMap(psList);
        for(Id perMissionSetId :psAssignmentList.KeySet()) 
        {
            Set<PermissionSetAssignment> assignmentList = psAssignmentList.get(perMissionSetId);
            Set<Id> existingUserIds = new Set<Id>();
            for(PermissionSetAssignment psAssignment : assignmentList )
            {
                if(!existingUserIds.contains(psAssignment.AssigneeId))
                {
                    existingUserIds.add(psAssignment.AssigneeId);
                }
            }
      //      System.assertEquals(existingUserIds.contains(u2.Id),true);
        }
        
        u2.Alias = 't123yz';
        //change from standard to chatter is not allowed so in our code, it's not going to be necessary
        //to ever remove the permission set
        //change user to someone who shouldn't have acces.
        u2.ProfileId = cm.id;
        update u2;
        

        
        List<PermissionSet> psList1 = PermissionSetUtil.getPermissionSetList();
        Map<Id,Set<PermissionSetAssignment>> psAssignmentList1 = PermissionSetUtil.getUserPermissionSetAssignmentMap(psList1);
        for(Id perMissionSetId :psAssignmentList1.KeySet()) 
        {
            Set<PermissionSetAssignment> assignmentList = psAssignmentList.get(perMissionSetId);
            Set<Id> existingUserIds = new Set<Id>();
            for(PermissionSetAssignment psAssignment : assignmentList )
            {
                if(!existingUserIds.contains(psAssignment.AssigneeId))
                {
                    existingUserIds.add(psAssignment.AssigneeId);
                }
            }
  //          System.assertEquals(existingUserIds.contains(u2.Id),true);
        }
        
        u2.Alias = 't123ab';
        u2.ProfileId = p.id;
        u2.MAJOR_ORG__c = 'P';
        update u2;
        Test.stopTest();
        List<PermissionSet> psList2 = PermissionSetUtil.getPermissionSetList();
        Map<Id,Set<PermissionSetAssignment>> psAssignmentList2 = PermissionSetUtil.getUserPermissionSetAssignmentMap(psList2);
        for(Id perMissionSetId :psAssignmentList2.KeySet()) 
        {
            Set<PermissionSetAssignment> assignmentList = psAssignmentList.get(perMissionSetId);
            Set<Id> existingUserIds = new Set<Id>();
            for(PermissionSetAssignment psAssignment : assignmentList )
            {
                if(!existingUserIds.contains(psAssignment.AssigneeId))
                {
                    existingUserIds.add(psAssignment.AssigneeId);
                }
            }
            System.assertEquals(existingUserIds.contains(u2.Id),false);
        }
        
                //change chatter id to someone who gets permission
        u3.ProfileId = c.id;
        u3.MAJOR_ORG__c = 'C';
         update u3;
        Set<Id> profileIds = new Set<Id>();
        profileIds.add(c.id); 
        PermissionSetUtil.isUserInProfile(u3,profileIds); 
        PublicGroupUserSyncHelper.isTestMethod = false;
         List<String> checkList = PermissionSetUtil.getUserProvisioningUtilValuesByType('SPHDUserLicense'); 
        Set<Id> ss = PermissionSetUtil.getChatterProfileIds();
        //Test.stopTest();    
        
        
        
    }
    
    /*
    //Delete is not allowed for user.
    static testMethod void removePermissionSetsToUsers() 
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        UserLicense userLicence = [Select u.SystemModstamp, u.Name, u.LicenseDefinitionKey, u.Id From UserLicense u where u.Name = 'Salesforce'];
//        UserLicense userLicence = [Select u.SystemModstamp, u.Name, u.MonthlyLoginsUsed, u.MonthlyLoginsEntitlement, u.LicenseDefinitionKey, u.Id From UserLicense u where u.Name = 'Salesforce'];        
        
        string randomName = string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','');     
        string userName = 't123';   
        
        User u2 = new User(Alias = 't123xy', Email=randomName+userName+'@gsa.gov', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id,MAJOR_ORG__c='A' ,Affiliation__c='Government',
        TimeZoneSidKey='America/Los_Angeles', UserName=randomName+userName+'@gsa.gov',CommunityNickname='t123xy');            
        
        insert u2;
        
        List<PermissionSet> psList = PermissionSetUtil.getPermissionSetList();
        Map<Id,Set<PermissionSetAssignment>> psAssignmentList = PermissionSetUtil.getUserPermissionSetAssignmentMap(psList);
        for(Id perMissionSetId :psAssignmentList.KeySet()) 
        {
            Set<PermissionSetAssignment> assignmentList = psAssignmentList.get(perMissionSetId);
            Set<Id> existingUserIds = new Set<Id>();
            for(PermissionSetAssignment psAssignment : assignmentList )
            {
                if(!existingUserIds.contains(psAssignment.AssigneeId))
                {
                    existingUserIds.add(psAssignment.AssigneeId);
                }
            }
            System.assertEquals(existingUserIds.contains(u2.Id),true);
        }
        delete u2;
        List<PermissionSet> psList1 = PermissionSetUtil.getPermissionSetList();
        Map<Id,Set<PermissionSetAssignment>> psAssignmentList1 = PermissionSetUtil.getUserPermissionSetAssignmentMap(psList1);
        for(Id perMissionSetId :psAssignmentList.KeySet()) 
        {
            Set<PermissionSetAssignment> assignmentList = psAssignmentList.get(perMissionSetId);
            Set<Id> existingUserIds = new Set<Id>();
            for(PermissionSetAssignment psAssignment : assignmentList )
            {
                if(!existingUserIds.contains(psAssignment.AssigneeId))
                {
                    existingUserIds.add(psAssignment.AssigneeId);
                }
            }
            System.assertEquals(existingUserIds.contains(u2.Id),false);
        }
        
        Test.stopTest();    
    }
     */   
}