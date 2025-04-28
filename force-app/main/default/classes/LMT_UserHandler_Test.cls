@isTest(seeAllData=true)
public class LMT_UserHandler_Test {
   
// Creating users 

    @isTest
    public static void processLMTUsersTest(){
        List<User> userList= new List<User>();
        List<User> updatedUserList= new List<User>();
        Profile crmProfile = [select id from profile where name like 'GSA Standard Salesforce User'];
        User crmUser = buildUser(1,crmProfile.id, 'crmUser@gsa.gov');
        
        Profile platformProfile = [select id from profile where name like 'GSA Standard Platform User'];
        User platformUser = buildUser(2,platformProfile.id, 'platformUser@gsa.gov');

		Profile gsaSystemProfile = [select id from profile where name like 'GSA System Administrator'];
        User gsaSystemUser = buildUser(3,gsaSystemProfile.id, 'gsaSystemProfile@gsa.gov');    
        
        userList.add(crmUser);
        userList.add(platformUser);
   		insert userList;

        System.runas(gsaSystemUser) {
       
            List<LMT_User__c> lmtList = new List<LMT_User__c>();
            LMT_User__c lmtUser1 = new LMT_User__c();
            lmtUser1.Federation_ID__c = 'testFedID' + 1;
            lmtUser1.email__c = 'email' + 1 + '@test.com';
            lmtList.add(lmtUser1);
            
            LMT_User__c lmtUser2 = new LMT_User__c();
            lmtUser2.Federation_ID__c = 'testFedID' + 2;
            lmtUser2.email__c = 'email' + 2 + '@test.com';
            lmtList.add(lmtUser2);        
            
            insert(lmtList);
            
            crmUser.email='updatedcrmuser@test.com';
            platformUser.email='updatedplatformuser@test.com';
            updatedUserList.add(crmUser);
            updatedUserList.add(platformUser);
            
            
            Organization orgDetail = [Select id, name from organization limit 1];
            LMT_UserHandler.FlowInputParameters inputParam;   
            inputParam = new LMT_UserHandler.FlowInputParameters();
            inputparam.orgDetail= orgDetail;
            inputparam.updatedUsers=updatedUserList;
            
            LMT_UserHandler.FlowInputParameters[] inputParams = new List<LMT_UserHandler.FlowInputParameters>();
            inputParams.add(inputParam);
                
            system.debug('usersList - test method ' + userlist);
            LMT_UserHandler.processLMTUsers(inputParams);
            List<OrgUsersLicense__c> usersUpdated = [Select id from OrgUsersLicense__c where FederationID__c like '%testFedID%'];
            system.assert(!usersUpdated.isEmpty());
            
            LMT_UserHandler.processLMTUsers(inputParams);
            
            // SFEEO-3534 and SFEEO-3536 Error Handling
            crmUser.FederationIdentifier = 'testFedID' + 4;
            lmtUser1.Federation_ID__c = 'testFedID' + 4;
            update crmUser;
            update lmtUser1;
            
            LMT_UserHandler.processLMTUsers(inputParams);
        }
    }
    
    //Create user
   public static User buildUser(Integer i, Id profileId, String email) {
        String fName = 'fN' + i;
        String lName = 'lN' + i;
        return new User(
            FirstName = fName,
            LastName = lName,
            Email = email,
            ProfileId = profileId,
            UserName = email.subStringBefore('@') + '@gsa.testUser',
            Alias = fName + 'al',
            CommunityNickname = email.subStringBefore('@'),
            FederationIdentifier = 'testFedID' + i,
            Affiliation__c = String.valueOf(i),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York',
            Contact_ID__c = i,
            GOVTPOC_COTAR__c = String.valueOf(i),
            MAJOR_ORG__c = String.valueOf(i),
            MAJOR_ORG_DESCRIPTION__c = String.valueOf(i),
            Middle_Name__c = String.valueOf(i),
            User_Region__c = String.valueOf(i),
            UPN__c = String.valueOf(i),
            WORK_BUILDING_PRIMARY__c = String.valueOf(i),
            Supervisory_Status__c = i,
            Supervisory_Status_Description__c = String.valueOf(i),
            SAML_Federation_ID_Custom__c = String.valueOf(i)
        );
    }
}