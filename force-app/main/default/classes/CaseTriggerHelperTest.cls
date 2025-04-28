@isTest public class CaseTriggerHelperTest {
    
    // Helper method to create a Lease
     
      private static PBS_Lease__c  createLease(String LeaseName, String LeaseNumber, String POCEmail) { 
          PBS_Lease__c lease = new PBS_Lease__c(Name=LeaseName, Lease_Number__c= LeaseNumber,
                                                 Lease_Effective_Date__c=date.today(),
                                                 LSR_Email_Text__c = POCEmail);
          return lease;
     }
    
    // Helper method to create a community user
     private static User  createUser(String userID, String userLastName)
     {
        Id acctOwnerId = [Select Id From User where isActive = true and UserRoleId != null and profile.name = 'GSA System Administrator' Limit 1].id;
        Account a = new Account(name ='Real Estate Tax Bucket', ownerid = acctOwnerId) ;
        insert a; 
        
        Contact c = new Contact(LastName=userLastName, AccountID = a.ID);
        insert c;
        
        //Profile Updated
        //ID pID = [select id from profile where name = 'GSA RET Community Plus User' ].id;
        ID pID = [select id from profile where name = 'GSA RET Community Plus Login User' ].id;
        User u = new User(alias = UserLastName.substring(1,3) + '111',
                          email = userID,
                          emailencodingkey = 'UTF-8',
                          lastname = userLastName,
                          languagelocalekey = 'en_US',
                          localesidkey = 'en_US',
                          profileID = pID,
                          country = 'United States',
                          IsActive = true,
                          ContactID = c.id,
                          timezonesidkey = 'America/Chicago',
                          username = userID);
        return u;
    }
    
    @future
    public static void inactivateUser(String name)
    {
        User u = [select id, isActive from user where username = :name];
        u.isActive = false;
        update u;
    }
    
    // Helper method to create Lease access
    private static PBS_Lease_Access__c createLeaseAccess(User u, PBS_Lease__c lease, String Status)
    {
        return new PBS_Lease_Access__c(PBS_Lease__c = lease.id, Requestor__c = u.id, Status__c = Status);
    }
    
    // Create a single Case owned by POC user
    @isTest static void singleCaseZeroRETUser()
    {
        User u = createUser('testPoCuser@email.gov', 'TestPOCuser');
        insert u;
        
        PBS_Lease__c lease = createLease('LV1234', '1234', u.Email);
        insert lease;
        
        PBS_Lease_Access__c access = createLeaseAccess(u,lease,'POC');
        insert access;
        
        Case c = null;
        system.runAs(u) {
            c = new Case(RecordTypeId =RET_LeaseShareUtility.RETRecordType, Description = 'Test RET Case', PBS_Lease__c = lease.id);
            insert c;
        }
        
        //count number of shares 
        List<CaseShare> cs = new List<CaseShare>([select id from CaseShare where CaseId = :c.id and  RowCause = 'Manual']);
        system.assertEquals(0, cs.size());
    }
    
    //create a single case owned by RET user shared with POC user
    @isTest static void singleCaseOneRETUserOwner()
    {
        User u = createUser('testPOCUser@email.gov', 'TestPOCUser');
        insert u;
        
        PBS_Lease__c lease = createLease('LV1234', '1234', u.Email);
        insert lease;
        
        PBS_Lease_Access__c access = createLeaseAccess(u,lease,'POC');
        insert access;
       
        User u2 = createUser('testRETUser@email.gov','TestRETUser' );
        insert u2;
        
        PBS_Lease_Access__c access2 = createLeaseAccess(u2, lease, 'Approved');
        insert access2;
        
        //Case c = null;
        //system.runAs(u2) {
        //    c = new Case(RecordTypeId =RET_LeaseShareUtility.RETRecordType, Description = 'Test RET Case', PBS_Lease__c = lease.id);
        //    insert c;
        //}
        
        //count number of shares 
        //List<CaseShare> cs = new List<CaseShare>([select id from CaseShare where CaseId = :c.id  and RowCause = 'Manual']);
        //system.assertEquals(0, cs.size());
        
        //cs = new List<CaseShare>([select id from CaseShare where CaseId = :c.ID  and RowCause = 'Manual' and UserOrGroupID = :u2.ID]);
        //system.assertEquals(0, cs.size());
    } 
    
    // create a single case owned by RET user shared with POC and another RET user on the Lease
    @isTest static void singleCaseTwoRETUsers()
    {
        User u = createUser('testPOCUser@email.gov', 'TestPOCUser');
        insert u;
        
        PBS_Lease__c lease = createLease('LV1234', '1234', u.Email);
        insert lease;
        
        PBS_Lease_Access__c access = createLeaseAccess(u,lease,'POC');
        insert access;
       
        User u2 = createUser('testRETUser2@email.gov','TestRETUser2' );
        insert u2;
        
        PBS_Lease_Access__c access2 = createLeaseAccess(u2, lease, 'Approved');
        insert access2;
        
        User u3 = createUser('testRETUser3@email.gov','TestRETUser3' );
        insert u3;
        
        PBS_Lease_Access__c access3 = createLeaseAccess(u3, lease, 'Approved');
        insert access3;
        
        //Case c = null;
        //system.runAs(u3) {
        //    c = new Case(RecordTypeId =RET_LeaseShareUtility.RETRecordType, Description = 'Test RET Case', PBS_Lease__c = lease.id);
        //    insert c;
        //}
        
       
        //List<CaseShare> cs = new List<CaseShare>([select id from CaseShare where CaseId = :c.id  and RowCause = 'Manual']);
        //system.assertEquals(2, cs.size());
        
        //cs = new List<CaseShare>([select id from CaseShare where CaseId = :c.ID  and RowCause = 'Manual' and  UserOrGroupID = :u3.ID]);
        //system.assertEquals(0, cs.size());
    }
    
    // create a two cases and 2 Leases
    // c1 owned by POC user, shared with RET1, RET2, RET3
    // c2 owned by POC user, shared with RET1
    @isTest static void twoCasesThreeRETUser()
    {
        User u = createUser('testPoCuser@email.gov', 'TestPOCuser');
        insert u;
        
        PBS_Lease__c lease1 = createLease('LV11111', '1111', u.Email);
        insert lease1;
        
        PBS_Lease__c lease2 = createLease('LV2222', '22222', u.Email);
        insert lease2;
        
        PBS_Lease_Access__c access1 = createLeaseAccess(u,lease1,'POC');
        insert access1;
        
         PBS_Lease_Access__c access2 = createLeaseAccess(u,lease2,'POC');
        insert access2;
       
        User u1 = createUser('testRETUser1@email.gov', 'TestRETuser1');
        insert u1;
        PBS_Lease_Access__c access11 = createLeaseAccess(u1, lease1, 'Approved');
        insert access11;
        
        User u2 = createUser('testRETUser2@email.gov', 'TestRETuser2');
        insert u2;
        PBS_Lease_Access__c access21 = createLeaseAccess(u2, lease1, 'Approved');
        insert access21;
        
        User u3 = createUser('testRETUser3@email.gov', 'TestRETUser3');
        insert u3;
        PBS_Lease_Access__c access31 = createLeaseAccess(u3, lease1, 'Approved');
        insert access31;
        
        //share Lease2 with RET1
        PBS_Lease_Access__c access12 = createLeaseAccess(u1, lease2, 'Approved');
        insert access12;
        
        List<Case> cList =new List<Case>();
        Case c1;
        Case c2;
        
        system.runAs(u) {
            c1 = new Case(RecordTypeId =RET_LeaseShareUtility.RETRecordType, Description = 'Test RET Case1', PBS_Lease__c = lease1.id);
            cList.add(c1);
            
            c2 =  new Case(RecordTypeId =RET_LeaseShareUtility.RETRecordType, Description = 'Test RET Case2', PBS_Lease__c = lease2.id);
            cList.add(c2);
            
            insert cList;
        }
        
        //List<CaseShare> cs = new List<CaseShare>([select id from CaseShare where CaseId = :c1.id  and RowCause = 'Manual']);
        //system.assertEquals(3, cs.size());
        
        //cs = new List<CaseShare>([select id from CaseShare where CaseId = :c2.id  and RowCause = 'Manual']);
        //system.assertEquals(1, cs.size());
        
    }
    
    // create  two cases (owned by POC) and 1 Lease shared with RET1, RET2, RET3
    @isTest static void twoCasesThreeRETUserSingleLease()
    {
        User u = createUser('testPoCuser@email.gov', 'TestPOCuser');
        insert u;
        
        PBS_Lease__c lease = createLease('LV1234', '1234', u.Email);
        insert lease;
        
        PBS_Lease_Access__c access = createLeaseAccess(u,lease,'POC');
        insert access;
       
        User u1 = createUser('testRETUser1@email.gov', 'TestRETuser1');
        insert u1;
        PBS_Lease_Access__c access1 = createLeaseAccess(u1, lease, 'Approved');
        insert access1;
        
        User u2 = createUser('testRETUser2@email.gov', 'TestRETuser2');
        insert u2;
        PBS_Lease_Access__c access2 = createLeaseAccess(u2, lease, 'Approved');
        insert access2;
        
        User u3 = createUser('testRETUser3@email.gov', 'TestRETUser3');
        insert u3;
        PBS_Lease_Access__c access3 = createLeaseAccess(u3, lease, 'Approved');
        insert access3;       
        
        List<Case> cList = new List<Case>();
        Case c1;
        Case c2;
        
        system.runAs(u) {
            c1 = new Case(RecordTypeId =RET_LeaseShareUtility.RETRecordType, Description = 'Test RET Case1', PBS_Lease__c = lease.id);
            cList.add(c1);
            
            c2 =  new Case(RecordTypeId =RET_LeaseShareUtility.RETRecordType, Description = 'Test RET Case2', PBS_Lease__c = lease.id);
            cList.add(c2);
            
            insert cList;
        }
        
        //List<CaseShare> cs = new List<CaseShare>([select id from CaseShare where CaseId = :c1.id  and RowCause = 'Manual']);
        //system.assertEquals(3, cs.size());
        
        //cs = new List<CaseShare>([select id from CaseShare where CaseId = :c2.id  and RowCause = 'Manual']);
        //system.assertEquals(3, cs.size());
        
    }
    
    // create  two cases (owned by POC) and 1 Lease shared with RET1, RET2, RET3
    @isTest static void twoNonRETCases()
    {
        User u = createUser('testPoCuser@email.gov', 'TestPOCuser');
        insert u;
        
        PBS_Lease__c lease = createLease('LV1234', '1234', u.Email);
        insert lease;
        
        PBS_Lease_Access__c access = createLeaseAccess(u,lease,'POC');
        insert access;
        
        List<Case> cList = new List<Case>();
        Case c1;
        Case c2;
        
        system.runAs(u) {
            c1 = new Case(Description = 'Test RET Case1', PBS_Lease__c = lease.id);
            cList.add(c1);
            
            c2 = new Case(RecordTypeId = RET_LeaseShareUtility.RETRecordType, Description = 'Test RET Case2', PBS_Lease__c = null);
            cList.add(c2);
            
            insert cList;
        }
        
        List<CaseShare> cs = new List<CaseShare>([select id from CaseShare where RowCause = 'Manual']);
        system.assertEquals(0, cs.size());
         
    }
    
}