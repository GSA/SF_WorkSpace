@isTest
public class RET_LeaseShareUtilityTest {
    @testsetup static void createData(){
        //Create RET users
        
        Account ac = new Account(name ='Real Estate Tax Bucket') ;
        insert ac; 
        Id retProfileId = [select Id, name from Profile where Name = :RET_LeaseShareUtility.RET_CCP_Profile limit 1].Id;
        Id systemUserProfileId = [select Id, name from Profile where Name Like 'GSA System Administrator%' limit 1].Id;
        
        Contact con = new Contact(FirstName='TestRETFName', LastName='TestRETLName', Email='retUserTestEmail420@test.org',AccountId = ac.Id);
        insert con;  
        User castIronUser = new User(Alias = 'csirn', Email='castIronUserTestEmail@test.org',
                                     emailencodingkey='UTF-8', FirstName='Cast', LastName='IronPrd', languagelocalekey='en_US',
                                     localesidkey='en_US', profileid = systemUserProfileId, country='United States',IsActive =true,
                                     timezonesidkey='America/Los_Angeles', username='castIronUserTestEmail@test.org');
        
        insert castIronUser;
        system.runAs(castIronUser){
            User user = new User(Alias = 'rlfna', Email='retUserTestEmail420@test.org',
                                 emailencodingkey='UTF-8', FirstName='TestRETFName', LastName='TestRETLName', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = retProfileId, country='United States',IsActive =true,
                                 ContactId = con.Id,
                                 timezonesidkey='America/Los_Angeles', username='retUserTestEmail420@test.org');
            
            insert user;
            
            
            PBS_Lease__c newPBS = new PBS_Lease__c(Lease_Number__c='98462383', Name ='98462383Test', Lease_Effective_Date__c = date.today(), Lease_Expiration_Date__c = date.today().adddays(365));
            Insert newPBS;
            PBS_Lease_Access__c lsac1 = new PBS_Lease_Access__c(PBS_Lease__c = newPBS.id, Requestor__c=user.Id, Status__c = 'Requested');
            Insert lsac1;
            List<Case> collCase = new List<Case>();
            collCase.add(new case(origin='Web',Status='Submitted',PBS_Lease__c =newPBS.ID));
            collCase.add(new case(origin='Phone',Status='Submitted',PBS_Lease__c =newPBS.ID));
            Insert collCase;
        }
    }
    
    @isTest static void testPositive(){
        User castIronUser = [Select Id from user where email = 'castIronUserTestEmail@test.org' limit 1];
        system.runAs(castIronUser){
            List<String> statusFilters = new List<String>();
            List<Id> lsacIdList = new List<Id>();
            statusFilters.add('Requested');
            List<PBS_Lease__c> leaseList = [select Id, Name, OwnerId, LSR_Email_Text__c, LSR_Contact_Email__c from PBS_Lease__c];
            List<PBS_Lease_Access__c> lsacList = [select id, PBS_Lease__c, PBS_Lease__r.Lease_Number__c, 
                                                  Requestor__c, Status__c from PBS_Lease_Access__c];
            for(PBS_Lease_Access__c lsac : lsacList){lsacIdList.add(lsac.id);}
            
            RET_LeaseShareUtility.getLeaseAccessList(statusFilters,1,3);
            RET_LeaseShareUtility.getPendingApprovalsCount(statusFilters);
            RET_LeaseShareUtility.ApproveRejectLeaseAccess(lsacList, 'Approve');
            RET_LeaseShareUtility.ApproveRejectLeaseAccess(lsacList, 'Reject');
            RET_LeaseShareUtility.getLeaseAccessMap(leaseList);
            RET_LeaseShareUtility.revokePOCLeaseAccess(leaseList);
            RET_LeaseShareUtility.revokeRETLeaseAccess(leaseList);
            RET_LeaseShareUtility.revokePBSLeaseAccess(lsacIdList);
            RET_LeaseShareUtility.getCastIronUserId();
            RET_LeaseShareUtility.getPBSLeaseAccessRecords('leaseNumber');
            RET_LeaseShareUtility.InsertCaseShares(lsacList);
            String uType = RET_LeaseShareUtility.getUserType();
            system.assertNotEquals(null, uType);
        }
    }    
    
}