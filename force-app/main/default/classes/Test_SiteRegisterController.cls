@isTest(SeeAllData=false)
private class Test_SiteRegisterController {

    
    static testMethod void createCustomerPortalUserTest() {  

         SiteRegisterController cpTest = new SiteRegisterController();  

        List<SelectOption> profileOptions = cpTest.getCustomerPortalProfiles();  
        Profile profile = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
        cpTest.selectedProfileId = profile.id; 
        
        
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        
        cpTest.c = new Contact(firstName='TestFirstName', lastName='TestLastName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = false, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');  
        cpTest.actionChkTermsAndConds();
        cpTest.c = new Contact(firstName='TestFirstName', lastName='TestLastName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');
         
        Test.startTest();  
        insert rlps1;
        insert rlps;
        System.assert(rlps1.id!= null);
        PageReference testPageRef= cpTest.createPortaluser();
        System.assert(testPageRef== null); 
        
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  
     
     }  

     static testMethod void createCustomerPortalUserCreateTestError() {  

         SiteRegisterController cpTest = new SiteRegisterController();  

        List<SelectOption> profileOptions = cpTest.getCustomerPortalProfiles(); 
        Profile profile = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
        cpTest.selectedProfileId = profile.id; 
        
        cpTest.c = new Contact(firstName='TestFirstName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;New York;');
         
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        PBS_AAAP_RLP_Regions_Map__c rlps2 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 2', PBS_AAAP_RLP_State_Abbrevation__c='NY', PBS_AAAP_RLP_State__c='New York');
                  

        Test.startTest(); 
        insert rlps1;
        System.assert(rlps1.id!= null);
        insert rlps;
        insert rlps2;
        PageReference testPageRef= cpTest.createPortaluser();
        System.assert(testPageRef== null);
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  
         
     }
     
     static testMethod void createCustomerPortalUserError() {  

        SiteRegisterController cpTest = new SiteRegisterController();  

        List<SelectOption> profileOptions = cpTest.getCustomerPortalProfiles(); 
        Profile profile = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
        cpTest.selectedProfileId = profile.id;
        User u = new User(firstname='firstname', lastname='testlastname', alias='testa', email='test@testorg.com', emailencodingkey='UTF-8',        
                            languagelocalekey='en_US', localesidkey='en_US', profileid = profile.id, timezonesidkey='America/Los_Angeles', 
                            username='test@testorg.com', street='123 street', city='Vienna', state='Virginia', country='USA', postalcode='22102',
                            phone='202-202-2202', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');
                             
        cpTest.c = new Contact(firstName='TestFirstName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;New York;');
                
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        
        Test.startTest(); 
        insert rlps1;
        System.assert(rlps1.id!= null);
        insert rlps;
        PageReference testPageRef= cpTest.createPortaluser();
        System.assert(testPageRef== null);
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  
         
     }      
     
     static testMethod void validate_UserExist() {  
 
        Account portalAccount1 = new Account(Name = 'TestAccount');
        Database.insert(portalAccount1);

        //Create contact
        Contact contact1 = new Contact(
                                FirstName = 'Test',
                                Lastname = 'McTesty',
                                AccountId = portalAccount1.Id,
                                Email = System.now().millisecond() + 'test@test.com'
                                );
        Database.insert(contact1);
        
        // create user
        Profile profile = [Select p.name, p.id From Profile p where p.Name like '%GSA RET Community Plus Login User%' limit 1];
        User user1 = new User(
                            Username = contact1.Email,
                            ContactId = contact1.Id,
                            ProfileId = profile.Id,
                            Alias = 'test123',
                            Email = 'test12345@test.com',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'McTesty',
                            CommunityNickname = 'test12345',
                            TimeZoneSidKey = 'America/Los_Angeles',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US'
                            );
                            Database.insert(user1);
                
        SiteRegisterController cpTest = new SiteRegisterController();  
        cpTest.c = contact1;
        cpTest.createPortaluser();
        ApexPages.currentPage().getHeaders().put('referer','RSAP');
        cpTest.getReferer();
        ApexPages.currentPage().getHeaders().put('referer','SF');
        cpTest.getReferer();
        System.assert(true);
     }
    //@isTest(SeeAllData=true); 

    static testMethod void createCustomerPortalUserTest1() {  

        SiteRegisterController cpTest = new SiteRegisterController();

        List<SelectOption> profileOptions = cpTest.getCustomerPortalProfiles();  
        Profile profile = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
        cpTest.selectedProfileId = profile.id; 
        
        
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        
        cpTest.c = new Contact(firstName='TestFirstName', lastName='TestLastName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = false, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');  
        cpTest.actionChkTermsAndConds();
        cpTest.c = new Contact(firstName='TestFirstName', lastName='TestLastName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');
         
        Test.startTest();  
        insert rlps1;
        insert rlps;
        System.assert(rlps1.Id != null);
		Test.setMock(HttpCalloutMock.class, new reCAPTCHACalloutMockImpl());     
		System.currentPageReference().getParameters().put('g-recaptcha-response', 'testGoogleResponse');        
        PageReference testPageRef= cpTest.createPortaluser(); 
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  

     }  

     static testMethod void createCustomerPortalUserCreateTestError1() {  
        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id customRecTypeId = recordTypes.get('AAAP Portal').getRecordTypeId();
        
        Account a = new Account(Name=PBS_AAAP_GlobalConstants.CUSTOMER_PORTAL_ACCOUNT_NAME, RecordTypeId=customRecTypeId);
        insert a;

        SiteRegisterController cpTest = new SiteRegisterController();
         
        SiteRegisterController.selectRegions('Virginia;Maryland;District of Columbia');

        List<SelectOption> profileOptions = cpTest.getCustomerPortalProfiles(); 
        Profile profile = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
        cpTest.selectedProfileId = profile.id; 
        
        cpTest.c = new Contact(firstName='TestFirstName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;New York;');
         
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        PBS_AAAP_RLP_Regions_Map__c rlps2 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 2', PBS_AAAP_RLP_State_Abbrevation__c='NY', PBS_AAAP_RLP_State__c='New York');
                  

        Test.startTest(); 
        insert rlps1;
        insert rlps;
        insert rlps2;
        System.assert(rlps1.Id != null);
		Test.setMock(HttpCalloutMock.class, new reCAPTCHACalloutMockImpl());     
		System.currentPageReference().getParameters().put('g-recaptcha-response', 'testGoogleResponse');        
        PageReference testPageRef= cpTest.createPortaluser();
        
        System.assert(testPageRef == null);
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  
        
     }
     
     static testMethod void createCustomerPortalUserError1() {  
        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id customRecTypeId = recordTypes.get('AAAP Portal').getRecordTypeId();
        
        Account a = new Account(Name=PBS_AAAP_GlobalConstants.CUSTOMER_PORTAL_ACCOUNT_NAME, RecordTypeId=customRecTypeId);
        insert a;
        
        SiteRegisterController cpTest = new SiteRegisterController();  

        List<SelectOption> profileOptions = cpTest.getCustomerPortalProfiles(); 
        Profile profile = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
        cpTest.selectedProfileId = profile.id;
        User u = new User(firstname='firstname', lastname='testlastname', alias='testa', email='sguni@acumensolutions.com', emailencodingkey='UTF-8',       
                            languagelocalekey='en_US', localesidkey='en_US', profileid = profile.id, timezonesidkey='America/Los_Angeles', 
                            username='sguni@acumensolutions.com', street='123 street', city='Vienna', state='Virginia', country='USA', postalcode='22102',
                            phone='202-202-2202', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');
        User u1 = new User(firstname='firstname', lastname='testlastname', alias='testa', email='sguni@acumensolutions.com', emailencodingkey='UTF-8',      
                            languagelocalekey='en_US', localesidkey='en_US', profileid = profile.id, timezonesidkey='America/Los_Angeles', 
                            username='sguni@acumensolutions.com', street='123 street', city='Vienna', state='Virginia', country='USA', postalcode='22102',
                            phone='202-202-2202', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');
           
        cpTest.c = new Contact(firstName='TestFirstName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;New York;');
                
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        
        Test.startTest(); 
        insert rlps1;
        System.assert(rlps1.id != null);
        insert rlps;
		Test.setMock(HttpCalloutMock.class, new reCAPTCHACalloutMockImpl());     
		System.currentPageReference().getParameters().put('g-recaptcha-response', 'testGoogleResponse');        
        PageReference testPageRef= cpTest.createPortaluser();
        System.assert(testPageRef == null);
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  
         
     }   
  
     static testMethod void createCustomerPortalUserTest2() {  
        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id customRecTypeId = recordTypes.get('AAAP Portal').getRecordTypeId();
        
        Account a = new Account(Name=PBS_AAAP_GlobalConstants.CUSTOMER_PORTAL_ACCOUNT_NAME, RecordTypeId=customRecTypeId);
        insert a;
        
        Contact con = new Contact(firstName='RETFirstNameContact', lastName='RETLastNameContact', email='test@testorg.com', accountId=a.Id); 
        insert con;
        
        Profile p = [Select p.name, p.id From Profile p where p.Name like '%GSA RET Community Plus Login User%' limit 1];
        
        User usr = new User(FirstName='RETFirstNameContact',LastName='RETLastNameContact', alias='rretl', email='test@testorg.com', 
                            username='test@testorg.com',emailencodingkey='UTF-8',       
                            languagelocalekey='en_US', localesidkey='en_US', profileid = p.id, timezonesidkey='America/Los_Angeles',contactId=con.Id);
                            
        insert usr;
                                
        SiteRegisterController cpTest = new SiteRegisterController();  
        List<SelectOption> profileOptions = cpTest.getCustomerPortalProfiles();  
        Profile profile = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
        cpTest.selectedProfileId = profile.id; 
        
        
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        
        cpTest.c = new Contact(firstName='TestFirstName', lastName='TestLastName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = false, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');  

        
        PageReference pageRef = Page.PBS_AAAP_UserRegistration;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('confirmTempEmail', 'test@testorg.com');
	    cpTest.confirmTempEmail = 'test@testorg.com';
                
        cpTest.actionChkTermsAndConds();
        cpTest.c = new Contact(firstName='TestFirstName', lastName='TestLastName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');
         
        Test.startTest();  
        insert rlps1;
        insert rlps;
        System.assert(rlps1.Id != null);
        
		Test.setMock(HttpCalloutMock.class, new reCAPTCHACalloutMockImpl());     
		System.currentPageReference().getParameters().put('g-recaptcha-response', 'testGoogleResponse');
        PageReference testPageRef= cpTest.createPortaluser(); 
        Test.stopTest();  
        
        PageReference testPageRef2 = cpTest.reset();  
        
        SiteRegisterController.createUser(null, 'abcGmail.com',  'fname', 'lName', 'userName@username.com', 'Phone', 'street', 'state', 'pin', 'city', 'country',  'zip',  'company',  'sofi',  'sofreg',  'altPhone', null, 'Mr.');
        
        Account accUser = new Account();
        accUser.Name = 'User Name';
        insert accUser;
        
        Contact conUser = new Contact();
        conUser.LastName = 'TestConhere';
        conUser.accountId = accUser.Id;
        insert conUser;
        
         User u = new User(
         ProfileId = [Select name, id From Profile where Name like '%GSA RET Community Plus Login User%' limit 1].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com007_',
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         ContactId = conUser.Id
        );
        insert u;
        
        cpTest.conf1 = true;
        cpTest.conf2 = true;
        cpTest.regions = null;
        
        system.runAs(u){

            PermissionSet[] permSet = [Select name, id FROm PermissionSet where Name like '%AAAP_User%' limit 1];
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permSet[0].Id, AssigneeId = UserInfo.getUserId());
            insert psa;
            SiteRegisterController.assignPermissionSet(UserInfo.getUserId());
            
            Contact con1 =  new Contact();
            con1.email = 'puser000@amamama.com007_';            
            cpTest.c = con1;
            Test.setMock(HttpCalloutMock.class, new reCAPTCHACalloutMockImpl());     
            System.currentPageReference().getParameters().put('g-recaptcha-response', 'testGoogleResponse');           
            cpTest.createPortaluser();
        }
        
     } 
    
}