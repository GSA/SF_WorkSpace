@isTest(seeAllData=true)
public class LMT_PermissionSetAssignmentHandler_Test {
    
    @isTest
    public static void processPermissionSetAssignmentstest(){
        
        LMT_PermissionSetAssignmentHandler.FlowInputParameters inputParam;  
        List<User> userList= new List<User>();
        List<User> updatedUserList= new List<User>();
        //Profile crmProfile = [select id from profile where name like 'GSA Standard Salesforce User'];
//        User crmUser1 = buildUser(1,crmProfile.id, 'crmUser1@gsa.gov');
        
       
       // User crmUser2 = buildUser(2,crmProfile.id, 'crmUser2@gsa.gov');
        
       // userList.add(crmUser1);
       // userList.add(crmUser2);
   		///insert userList;
        
        List<Id> useridlist = new List<Id>();
        List<Id> crmPSIDs = new List<Id>();
       // userIdlist.add(crmUser1.id);
        //userIdlist.add(crmUser2.id);
        List<User> users = [Select id, name,FederationIdentifier,email from user where FederationIdentifier!=null and User_License__c = 'Salesforce' limit 50 ];
        for (User u:users){
            useridlist.add(u.id);
        }
         List<PermissionSetAssignment> permissionsSetAssignmentList = [Select id, assigneeId, permissionSetId from PermissionSetAssignment where assigneeid in :userIdList limit 500];
        useridList.clear();
        for (PermissionSetAssignment permissionSetAssignmentRecord : permissionsSetAssignmentList){
            if(!useridlist.isEmpty()){
                if(useridList.get(0)==permissionSetAssignmentRecord.assigneeId){continue;}
                if(crmPSIDs.get(0)==permissionSetAssignmentRecord.permissionSetId){continue;}
               		useridlist.add(permissionSetAssignmentRecord.assigneeId);
               		crmPSIDs.add(permissionSetAssignmentRecord.permissionSetId);
               		break;   
            }
             useridlist.add(permissionSetAssignmentRecord.assigneeId);  
            crmPSIDs.add(permissionSetAssignmentRecord.permissionSetId);
        }
        
        List<User> users1 = [Select id, name,FederationIdentifier,email,User_License__c,isActive from user where id in :useridlist limit 50 ];
        User crmUser1 = users1.get(0);
        User crmUser2 = users1.get(1);
        
        List<LMT_User__c> lmtUsers = [SELECT Id, User_ID__c FROM LMT_User__c where User_ID__c = :crmUser1.id];
                 LMT_user__c lmtUser1 = new LMT_user__c();
            if (lmtUsers.isEmpty()) {
                 lmtUser1.Federation_ID__c= crmUser1.FederationIdentifier;
                 lmtUser1.User_ID__c= crmUser1.id;
                 lmtUser1.Email__c= crmUser1.email;
                List<LMT_User__c> insertList1 =  new List<LMT_User__c>();
                insertList1.add(lmtUser1);
                 insert insertList1;
    		}
        else {
            lmtUser1 = lmtUsers.get(0);
        }

    	List<LMT_User__c> lmtUsers1 = [SELECT Id, User_ID__c FROM LMT_User__c where User_ID__c = :crmUser2.id];
                 LMT_user__c lmtUser2 = new LMT_user__c();
            
            if (lmtUsers1.isEmpty()) {
                 lmtUser2.Federation_ID__c= crmUser2.FederationIdentifier;
                 lmtUser2.User_ID__c= crmUser2.id;
                 lmtUser2.Email__c= crmUser2.email;
                List<LMT_User__c> insertList2 =  new List<LMT_User__c>();
                insertList2.add(lmtUser2);
                 insert insertList2;
            }
        else {
            lmtUser2 = lmtUsers1.get(0);
        }

        List<OrgUsersLicense__c> lmtUserLicenseList1 = [SELECT Id, UserID__c FROM OrgUsersLicense__c where UserID__c = :crmUser1.id];
        OrgUsersLicense__c lmtUserLicense1 = new OrgUsersLicense__c();
            
        if(lmtUserLicenseList1.isEmpty()) {
            lmtUserLicense1.LMT_User__c=lmtUser1.id;
            lmtUserLicense1.OrgID__c='org Id';
            lmtUserLicense1.OrgName__c='org name';
            lmtUserLicense1.FederationID__c=crmUser1.FederationIdentifier;
            lmtUserLicense1.UserLicense__c=crmUser1.User_License__c;	
            lmtUserLicense1.UserID__c=crmUser1.id;
            lmtUserLicense1.ActiveUser__c=crmUser1.IsActive;	
            lmtUserLicense1.OrgFedIDKey__c=crmUser1.FederationIdentifier;
            List<OrgUsersLicense__c> insertList1 = new List<OrgUsersLicense__c>();
            insertList1.add(lmtUserLicense1);
            insert insertList1;
    	}
        else {
            lmtUserLicense1 = lmtUserLicenseList1.get(0);
        }
 
        List<OrgUsersLicense__c> lmtUserLicenseList2 = [SELECT Id, UserID__c FROM OrgUsersLicense__c where UserID__c = :crmUser2.id];
 		OrgUsersLicense__c lmtUserLicense2 = new OrgUsersLicense__c();

        if(lmtUserLicenseList2.isEmpty()) {
        lmtUserLicense2.LMT_User__c=lmtUser2.id;
        lmtUserLicense2.OrgID__c='org Id';
        lmtUserLicense2.OrgName__c='org name';
        lmtUserLicense2.FederationID__c=crmUser2.FederationIdentifier;
        lmtUserLicense2.UserLicense__c=crmUser2.User_License__c;	
        lmtUserLicense2.UserID__c=crmUser2.id;
        lmtUserLicense2.ActiveUser__c=crmUser2.IsActive;	
        lmtUserLicense2.OrgFedIDKey__c=crmUser2.FederationIdentifier;        
            List<OrgUsersLicense__c> insertList2 = new List<OrgUsersLicense__c>();
            insertList2.add(lmtUserLicense2);
            insert insertList2;
        }
        else {
            lmtUserLicense2 = lmtUserLicenseList2.get(0);
        }
        
        
        inputParam = new LMT_PermissionSetAssignmentHandler.FlowInputParameters();
        inputParam.userIdList= userIdlist;
        inputParam.crmPS = crmPSIDs;
        
        LMT_PermissionSetAssignmentHandler.FlowInputParameters[] inputParams = new List<LMT_PermissionSetAssignmentHandler.FlowInputParameters>();
        inputParams.add(inputParam);
        
        LMT_PermissionSetAssignmentHandler.processPermissionSetAssignments(inputParams);
        List<OrgUsersLicense__c> lmtOrgUsersLicenseList = [Select id, CRM_Permissions_Used__c,userid__c from OrgUsersLicense__c where userid__c=:useridlist];
         system.debug('userIdlist' + userIdlist);
        system.debug('lmtOrgUsersLicenseList' + lmtOrgUsersLicenseList);
        for (OrgUsersLicense__c orgLicense: lmtOrgUsersLicenseList){
            system.debug('CRM_Permissions_Used__c' + orgLicense.CRM_Permissions_Used__c);
            if(orgLicense.userid__c==crmUser1.id){
            system.debug('match ' + orgLicense.CRM_Permissions_Used__c);  
         	system.assertEquals(true,orgLicense.CRM_Permissions_Used__c);   
            }
        }
        
        
    }
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