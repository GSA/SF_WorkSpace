@isTest
private class TestLicenseManagement{

    @isTest(SeeAllData=false) 
    Static void TestTriggerOrgUserLicenseTriggerClient() {
		
		OrgUsersLicense__c objOrgUser = New OrgUsersLicense__c();
		objOrgUser.ActiveUser__c = true;
		objOrgUser.FederationID__c = 'FedID';
		objOrgUser.OrgFedIDKey__c = 'OrgIDFedID';
		objOrgUser.OrgID__c = 'OrgID';
		objOrgUser.OrgName__c = 'OrgName';
		objOrgUser.UserID__c = 'UserID@test.com.EEO';
		objOrgUser.UserLicense__c = 'Salesforce';
		Insert objOrgUser;
		
		//Check if the Object record was created sucessfully
		System.Assert(objOrgUser.ID != NULL);
		
	}
	
	/*@isTest 
	public static void UpdateUserRecord(){
		
		List<Profile> ps = [select id, name from Profile where name = 'GSA System Administrator' or name = 'System Administrator'];
		Map<String,ID> profiles = new Map<String,ID>();
		for(Profile p : ps){  
            profiles.put(p.name, p.id);  
		}
		
		User U = [SELECT Id FROM User WHERE IsActive = True And profileid = :profiles.get('GSA System Administrator') Limit 1];
        U.Title = 'Updated Title';
        Update U;
        
    }*/
    
}