@IsTest
private class Test_PBS_AAAP_CustomerPortalUserTest {
    static testMethod void myUnitTest() {
        test.startTest();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_IsAwarded__c = true;
        insert osai;

        PBS_AAAP_AwardedOffersInfo info = new PBS_AAAP_AwardedOffersInfo();
        System.assert(info.awardOffers.size() > 0);
        test.stopTest();
    }

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
        System.assert(rlps1.Id != null);
        
        PageReference testPageRef= cpTest.createPortaluser(); 
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  
     }  

     static testMethod void createCustomerPortalUserCreateTestError() {  

         SiteRegisterController cpTest = new SiteRegisterController();   
        
        //cpTest.selectRegions('Virginia;Maryland;District of Columbia');

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
        PageReference testPageRef= cpTest.createPortaluser();
        
        System.assert(testPageRef == null);
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  

         
     }
     
     static testMethod void createCustomerPortalUserError() {  

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
        //insert u;
                             
        cpTest.c = new Contact(firstName='TestFirstName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;New York;');
                
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        
        Test.startTest(); 
        //insert u;
        insert rlps1;
        System.assert(rlps1.id != null);
        insert rlps;
        PageReference testPageRef= cpTest.createPortaluser();
        System.assert(testPageRef == null);
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  

         
     }      
}