@IsTest
private class Test_PBS_AAAP_UserProfileController {

    static testMethod void myUnitTest() {

        Test.startTest();
        User testUser = new User();
        Profile p = [SELECT id, name FROM Profile WHERE name = 'AAAP Customer Portal' LIMIT 1];
        //UserRole r = [Select u.Id, u.Name From UserRole u where Name = 'AAAPCustomerPortalCustomerUser' limit 1];
        testUser.Email = 'test@test.com';
        testUser.Username = 'lastname@testuser.com';

        if (p.name == 'AAAP Customer Portal') {
            //Won't work w/o customer portal  
            Account a = new Account(name = 'TestMethod Account Name');
            insert a;
            Contact c = new Contact(LastName = 'D');
            c.AccountId = a.Id;
            insert c;
            testUser.contactId = c.id;
        }

        testUser.LastName = 'test';
        testUser.Alias = 'test';
        testUser.ProfileId = p.Id;
        //testUser.UserRoleId = r.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.LocaleSidKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.PBS_AAAP_StatesOfInterest__c = 'NCR';
        testUser.PBS_AAAP_PIN__c = '123456';
        insert testUser;
        System.runAs(testUser) {
            PBS_AAAP_UserProfileController upc = new PBS_AAAP_UserProfileController();
            upc.save();
            upc.cancel();
            upc.isEdit = false;
            upc.actionredirecttoDeregister();
            upc.isEdit = true;

            upc.edit();
            upc.getIsEdit();
            upc.userid = testUser.Username;
            upc.pin = '234567';
            upc.actionDeRegistration();
            upc.userid = testUser.Username;
            upc.pin = '123456';
            upc.actionDeRegistration();
            System.assertEquals(upc.pin, testUser.PBS_AAAP_PIN__c);
        }
        Test.stopTest();
    }

}