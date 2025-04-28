@IsTest
public class PBSLeaseTriggerHelperTest {
    @testsetup static void createData() { 
        //Create RET and POC users
        
        Id acctOwnerId =  [Select Id From User where isActive = true and UserRoleId != null and profile.name = 'GSA System Administrator' Limit 1].id;
        Account ac = new Account(name ='Real Estate Tax Bucket', ownerid = acctOwnerId) ;
        insert ac; 
        
        Id systemUserProfileId = [select Id, name from Profile where Name= 'GSA System User' limit 1].Id;
        
        Contact c = new Contact(LastName = 'Your Contact Last Name', AccountId = ac.id);
        insert c;
        User castIronUser = new User(Alias = 'csirn', Email='castironusertestemail@test.org',
                                     emailencodingkey='UTF-8', FirstName='Cast', LastName='IronPrd', languagelocalekey='en_US',
                                     localesidkey='en_US', profileid = systemUserProfileId, country='United States',IsActive =true,
                                     timezonesidkey='America/Los_Angeles', username='castironusertestemail@test.org');
        
        insert castIronUser;
        List<User> uList = new List<User>();
        Id retProfileId = [select Id, name from Profile where Name = :RET_LeaseShareUtility.RET_CCP_Profile limit 1].Id;
            Id appProfileId = [select Id, name from Profile where Name = 'AAAP Customer Portal' limit 1].Id;
            List<Contact> conList = new List<Contact>();
            Contact retCon = new Contact(FirstName='TestRETFName', LastName='TestRETLName', Email='retusertestemail420@test.org',AccountId = ac.Id); 
            conList.add(retCon); 
            Contact pocCon = new Contact(FirstName='TestPOCFName', LastName='TestPOCLName', Email='pocusertestemail420@test.org',AccountId = ac.Id);
            conList.add(pocCon);
            insert conList;            
            //UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];UserRoleId=portalRole.id,
            User retUser = new User(Alias = 'rlfna', Email='retusertestemail420@test.org',
                                    emailencodingkey='UTF-8', FirstName='TestRETFName', LastName='TestRETLName', languagelocalekey='en_US',
                                    localesidkey='en_US', profileId = appProfileId, country='United States',IsActive =true,
                                    ContactId = retCon.Id,
                                    timezonesidkey='America/Los_Angeles', username='retusertestemail420@test.org');
            retUser.profileId = appProfileId;
            uList.add(retUser);
            insert retUser;
           User pocUser = new User(Alias = 'plgna', Email='pocusertestemail420@test.org',
                                    emailencodingkey='UTF-8', FirstName='TestPOCFName', LastName='TestPOCLName', languagelocalekey='en_US',
                                    localesidkey='en_US', profileId = retProfileId, country='United States',IsActive =true,
                                    ContactId = pocCon.Id,
                                    timezonesidkey='America/Los_Angeles', username='pocusertestemail420@test.org');
            uList.add(pocUser);
            insert pocUser;
        System.RunAs(castIronUser) {
            
            
            
            
            PBS_Lease__c newPBS = new PBS_Lease__c(Lease_Number__c='98462383', 
                                                   Name ='98462383Test', 
                                                   Lease_Effective_Date__c = date.today(), 
                                                   Lease_Expiration_Date__c = date.today().adddays(365), 
                                                   LSR_Email_Text__c ='pocusertestemail421@test.org', 
                                                   LMC_Contact_Email__c='pocusertestemail421@test.org',
                                                   LSR_Last_Name__c='lastName',
                                                   LSR_First_Name__c='firstName' );
            Insert newPBS; 
            newPBS.LSR_Email_Text__c =null;
            newPBS.LMC_Contact_Email__c=null;
            update newPBS;
            newPBS.LSR_Email_Text__c ='pocusertestemail421@test.com';
            newPBS.LMC_Contact_Email__c='pocusertestemail421@test.com';
            update newPBS;
            newPBS.LMC_Contact_Email__c='pocusertestemail422@test.com';
            update newPBS;
            RET_GREX_Integration_Settings__c cs1 = new RET_GREX_Integration_Settings__c();
            cs1.Endpoint_URL__c = 'https://test.com';
            insert cs1;
            
            RET_GREX_Integration_Email_Settings__c cs2 = new RET_GREX_Integration_Email_Settings__c();
            cs2.Name = 'Integration Failure';
            cs2.To_Address__c = 'xyz@test.com';
            cs2.Email_Subject__c = 'test email';
            cs2.Sender_Display_Name__c = 'Test Sender';
            cs2.Email_Body__c = 'Test Body';
            insert cs2;
            
            //Create Lease Record
            PBS_Lease__c leaseRec = new PBS_Lease__c(Name='Test Lease', Lease_Number__c='1234', LSR_Email_Text__c ='pocusertestemail420@test.org',
                                                     Lease_Effective_Date__c=date.today());
            Insert leaseRec; 
            leaseRec.LSR_Contact_Email__c = null;
            Update leaseRec;
            System.assertNotEquals(null, leaseRec.Id,'DML - insertion issue');

            //create a case record
            Case tmpCase = new case(origin='Web',Status='Submitted',RET_Last_Submission_Date__c=datetime.now().addDays(-1),
                                    RET_Base_Tax_Year__c='2017',PBS_Lease__c = leaseRec.id,RET_Tax_County__c = 'US', ownerId=uList[1].Id);
            Insert tmpCase;
            
            List<Attachment> collAtt = new List<Attachment>();
            collAtt.add(new Attachment(parentid=tmpCase.Id,name='Bill desk',body=Blob.valueOf('Unit Test Attachment Body')));
            collAtt.add(new Attachment(parentid=tmpCase.Id,name='Bill desk2',body=Blob.valueOf('Unit Test Attachment Body')));
            collAtt.add(new Attachment(parentid=tmpCase.Id,name='Bill desk3',body=Blob.valueOf('Unit Test Attachment Body')));
            
            insert collAtt;
            
            List<RET_Document_Data__c> collDocData = new List<RET_Document_Data__c>();
            collDocData.add(new RET_Document_Data__c(Attachment_ID__c =collAtt[0].Id,name ='test ret',Full_File_Name__c='ret test',Tax_Year__c ='2017',
                                                     Document_Category__c = 'Real Estate Taxes', Document_Type__c ='Tax bill(s)',Tax_Bill_Frequency__c='Annual',Tax_Block_Number__c='123',
                                                     Tax_Lot_Number__c='ABC',Tax_Period_Start__c=date.today().addyears(-2),Tax_Period_End__c=date.today().addyears(-1)));
            collDocData.add(new RET_Document_Data__c(Attachment_ID__c =collAtt[1].Id,name ='test ret', Full_File_Name__c='ret test',Tax_Year__c ='2017',
                                                     Document_Category__c = 'Real Estate Taxes', Document_Type__c ='Tax appeal notification',Tax_Bill_Frequency__c='Annual',Tax_Block_Number__c='123',
                                                     Tax_Lot_Number__c='ABC',Tax_Period_Start__c=date.today().addyears(-3),Tax_Period_End__c=date.today().addyears(-2)));
            collDocData.add(new RET_Document_Data__c(Attachment_ID__c =collAtt[2].Id,name ='test ret', Full_File_Name__c='ret test',Tax_Year__c ='2017',
                                                     Document_Category__c = 'Real Estate Taxes', Document_Type__c ='Proof of payment',Tax_Bill_Frequency__c='Annual',Tax_Block_Number__c='123',
                                                     Tax_Lot_Number__c='ABC',Tax_Period_Start__c=date.today().addyears(-1),Tax_Period_End__c=date.today()));
            
            Insert collDocData;
            
            List<RET_Required_Documents__c> collReqDocs = new List<RET_Required_Documents__c>();
            collReqDocs.add(new RET_Required_Documents__c(name ='Real Estate Tax - Bill',Document_Name__c ='Real Estate Tax - Bill',minimum_quantity__c =1));
            collReqDocs.add(new RET_Required_Documents__c(name ='Real Estate Tax - Appeal Notice',Document_Name__c ='Real Estate Tax - Appeal Notice',minimum_quantity__c =1));
            collReqDocs.add(new RET_Required_Documents__c(name ='Proof of Ownership',Document_Name__c ='Proof of Ownership',minimum_quantity__c =2));
            insert collReqDocs;
        }
    }
    
    @isTest static void OnBeforeInsertUpdateTest() {
        User castIronUser = [Select Id from user where email = 'castironusertestemail@test.org' limit 1];
        system.runAs(castIronUser){
            
            PBS_Lease__c leaseRec = [select Id, Name, LSR_Last_Name__c, LSR_First_Name__c,LSR_Contact_Email__c, LSR_Email_Text__c  from PBS_Lease__c where Name = 'Test Lease' limit 1];
            User retUser = [select Id, Name from user where email ='retusertestemail420@test.org' limit 1];
            PBS_Lease_Access__c lsac = new PBS_Lease_Access__c(PBS_Lease__c = leaseRec.id, Requestor__c=castIronUser.Id, Status__c = 'Approved');
            insert lsac; 
            system.assertNotEquals(null, lsac.Id);
            delete lsac; 
            system.assertNotEquals(null, lsac.Id);
            PBS_Lease_Access__c lsac1 = new PBS_Lease_Access__c(PBS_Lease__c = leaseRec.id, Requestor__c=castIronUser.Id, Status__c = 'Approved');
            leaseRec.LSR_Email_Text__c ='retusertestemail420@test.org';
            update leaseRec;
            system.assertNotEquals(null, leaseRec.Id);
            PBSLeaseTriggerHelper pth = new PBSLeaseTriggerHelper();
            pth.validateLSREmail(new PBS_Lease__c(LSR_Email_Text__c='rr55tt'));
            pth.validateLSREmail(new PBS_Lease__c(LSR_Email_Text__c=''));
        }
    }
}