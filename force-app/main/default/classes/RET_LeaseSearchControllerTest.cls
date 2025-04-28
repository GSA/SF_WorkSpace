@isTest(SeeAllData=false)
private class RET_LeaseSearchControllerTest {
    @testsetup static void createData(){  
        Id acctOwnerId = [Select Id From User where isActive = true and UserRoleId != null and profile.name = 'GSA System Administrator' Limit 1].id;
        Account acct = new Account(name ='Real Estate Tax Bucket', ownerid = acctOwnerId) ;
        insert acct; 
        //Create RET and POC users
        Id retProfileId = [select Id, name from Profile where Name = :RET_LeaseShareUtility.RET_CCP_Profile limit 1].Id;
        //Account ac = new Account(name ='RET Test Bucket Account') ;
        //insert ac; 
        List<Contact> conList = new List<Contact>();
        Contact retCon = new Contact(FirstName='TestRETFName', LastName='TestRETLName', Email='retUserTestEmail420@test.org',AccountId = acct.Id); 
        conList.add(retCon); 
        Contact pocCon = new Contact(FirstName='TestPOCFName', LastName='TestPOCLName', Email='pocUserTestEmail420@test.org',AccountId = acct.Id);
        conList.add(pocCon);
        insert conList;  
        
        List<User> uList = new List<User>();
        User retUser = new User(Alias = 'rlfna', Email='retUserTestEmail420@test.org',
                emailencodingkey='UTF-8', FirstName='TestRETFName', LastName='TestRETLName', languagelocalekey='en_US',
                localesidkey='en_US', profileid = retProfileId, country='United States',IsActive =true,
                ContactId = retCon.Id,
                timezonesidkey='America/Los_Angeles', username='retUserTestEmail420@test.org');
        uList.add(retUser);
        User pocUser = new User(Alias = 'plgna', Email='pocUserTestEmail420@test.org',
                emailencodingkey='UTF-8', FirstName='TestPOCFName', LastName='TestPOCLName', languagelocalekey='en_US',
                localesidkey='en_US', profileid = retProfileId, country='United States',IsActive =true,
                ContactId = pocCon.Id,
                timezonesidkey='America/Los_Angeles', username='pocUserTestEmail420@test.org');
        uList.add(pocUser);
        insert uList;
        system.debug('pocUser.Id *** '+pocUser);
        
        //Create Lease/Building Records
        PBS_Building__c testPB = new PBS_Building__c (Building_Name__c='1660',Building_ID__c = 111,
                                                      Location_Code_Plus__c='1234',
                                                      Street_Address__c='International Drive',
                                                      State_Code__c='VA',
                                                      City__c='Mclean',
                                                      Zip_Code__c='22102');
        insert testPB;
        system.debug('testPB *** '+testPB);
        PBS_Lease__c leaseRec = new PBS_Lease__c(Name='Test1234', Lease_Number__c='Test1234',
                                                 LSR_Email_Text__c ='pocUserTestEmail420@test.org',
                                                 Lease_Effective_Date__c=date.today(),
                                                 PBS_Building__c = testPB.id);
        Insert leaseRec;
        system.debug('leaseRec *** '+leaseRec);
        List<PBS_Lease__c> leaselst = [Select id from PBS_Lease__c];
        System.assertEquals(1,leaselst.size());
    }
    @isTest static void testPositive(){
        List<PBS_Lease__c> rec = [select id, Name, Lease_Effective_Date__c, Lessor__c, OwnerId,
                                  Short_Lease_Number__c, Lease_Expiration_Date__c,LSR_Email_Text__c, LSR_Contact_Email__c 
                                  from PBS_Lease__c limit 1];
        system.debug('rec *** '+rec);
        // Requesting access to selected lease.
        //RET_LeaseSearchController.createLeaseAccess(rec[0].id, 'Running Test Methods');
        // Requesting access again for the same lease.
        //RET_LeaseSearchController.createLeaseAccess(rec[0].id, 'Running Test Methods');
        RET_LeaseSearchController.SearchResultsWrapper objWrapper = RET_LeaseSearchController.getLeaseResults(rec[0],1,10,'1660','International Drive','Mclean','VA','22102');
        System.assertNotEquals(objWrapper.leaseWrapperList, null);
        system.debug('objWrapper.leaseWrapperList **** '+objWrapper.leaseWrapperList);
        System.assertEquals(objWrapper.totalPages, 1);
        System.assertEquals(objWrapper.totalResults, 1);
        System.assertEquals(objWrapper.hasPrevious, false);
        System.assertEquals(objWrapper.hasNext, false);
        
        system.assertEquals(0, [select count() from case]);
        Case caseRec = RET_LeaseSearchController.createNewCase(rec[0].id);
        System.AssertNotEquals(null, caseRec.id);
        caseRec = [select Origin,PBS_Lease__c,Status,Subject from case where id=:caseRec.Id];
        System.assertEquals('Web', caseRec.Origin);
        System.assertEquals('Draft', caseRec.Status);
        System.assertEquals('Real Estate Tax Submission', caseRec.Subject);
        System.assertEquals(rec[0].Id, caseRec.PBS_Lease__c);   
        
    }
    @isTest static void testNegative(){
        RET_LeaseSearchController.SearchResultsWrapper objWrapper = RET_LeaseSearchController.getLeaseResults(null,1,10,'test name','test address','test city','VA','12345');
        System.assertEquals(objWrapper, null);
        Case caseRec;
        system.assertEquals(0, [select count() from case]);
        try{//coverage for exception 
             caseRec = RET_LeaseSearchController.createNewCase(null);
        }catch(exception e){
            system.assertEquals(null, caseRec);
        }
    }
}