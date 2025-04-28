@isTest(SeeAllData=true)
private class Test_PBS_AAAP_SiteRegisterController {

    
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
        //insert u;
                             
        cpTest.c = new Contact(firstName='TestFirstName', email='test@testorg.com', PBS_AAAP_Terms_and_Conditions__c = true, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;New York;');
                
        PBS_AAAP_RLP_Regions_Map__c rlps = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='VA', PBS_AAAP_RLP_State__c='Virginia');
        PBS_AAAP_RLP_Regions_Map__c rlps1 = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c='Region 3', PBS_AAAP_RLP_State_Abbrevation__c='MD', PBS_AAAP_RLP_State__c='Maryland');
        
        Test.startTest(); 
        //insert u;
        insert rlps1;
        System.assert(rlps1.id!= null);
        insert rlps;
        PageReference testPageRef= cpTest.createPortaluser();
        System.assert(testPageRef== null);
        Test.stopTest();  

        PageReference testPageRef2 = cpTest.reset();  

         
     }      
    
}