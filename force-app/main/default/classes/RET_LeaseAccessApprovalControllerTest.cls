@isTest
public class RET_LeaseAccessApprovalControllerTest {
	@testsetup static void createData(){
        Account accountRecord = new Account(name ='Real Estate Tax Bucket') ;
        insert accountRecord; 
        
        //Create RET users
        Id retProfileId = [select Id, name from Profile where Name = :RET_LeaseShareUtility.RET_CCP_Profile limit 1].Id;
        Id systemUserProfileId = [select Id, name from Profile where Name Like 'GSA System Administrator%' limit 1].Id;
        
        Account ac = new Account(name ='RET Test Bucket Account') ;
        insert ac; 
       
        Contact con = new Contact(FirstName='TestRETFName', LastName='TestRETLName', Email='retUserTestEmail420@test.org',AccountId = ac.Id);
        insert con;  
        
        User user = new User(Alias = 'rlfna', Email='retUserTestEmail420@test.org',
                emailencodingkey='UTF-8', FirstName='TestRETFName', LastName='TestRETLName', languagelocalekey='en_US',
                localesidkey='en_US', profileid = retProfileId, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='retUserTestEmail420@test.org');
       
        insert user;
        User castIronUser = new User(Alias = 'csirn', Email='castIronUserTestEmail@test.org',
                					emailencodingkey='UTF-8', FirstName='Cast', LastName='IronPrd', languagelocalekey='en_US',
                					localesidkey='en_US', profileid = systemUserProfileId, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='castIronUserTestEmail@test.org');
       
        insert castIronUser;
        
        PBS_Lease__c newPBS = new PBS_Lease__c(Lease_Number__c='98462383', Name ='98462383Test', Lease_Effective_Date__c = date.today(), Lease_Expiration_Date__c = date.today().adddays(365));
        Insert newPBS;
        PBS_Lease_Access__c lsac1 = new PBS_Lease_Access__c(PBS_Lease__c = newPBS.id, Requestor__c=user.Id, Status__c = 'Requested');
        Insert lsac1;
        List<Case> collCase = new List<Case>();
        collCase.add(new case(origin='Web',Status='Submitted',PBS_Lease__c =newPBS.ID));
        collCase.add(new case(origin='Phone',Status='Submitted',PBS_Lease__c =newPBS.ID));
        Insert collCase;
    }
    
     @isTest static void testPositive(){
         List<String> statusFilters = new List<String>();
         boolean result = false;
         statusFilters.add('Requested');
         List<PBS_Lease__c> leaseList = [select Id, Name from PBS_Lease__c];
         List<PBS_Lease_Access__c> lsacList = [select id, PBS_Lease__c, PBS_Lease__r.Lease_Number__c, 
                               Requestor__c, Status__c from PBS_Lease_Access__c];
         RET_LeaseAccessApprovalController.getLsacWrapperList(statusFilters,1,3);
         result = RET_LeaseAccessApprovalController.ApproveLeaseAccess(lsacList[0]);
         system.assert(result);
         result = RET_LeaseAccessApprovalController.RejectLeaseAccess(lsacList[0]);
         system.assert(result);
     }

}