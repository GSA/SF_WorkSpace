@IsTest(SeeAllData = true)
public with sharing class LightningSelfRegisterControllerTest {

 /* Verifies that IsValidPassword method with various password combinations. */
 @IsTest
 static void testIsValidPassword() {
  System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334') == true);
  System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'dummyPassword') == false);
  System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', null) == false);
  System.assert(LightningSelfRegisterController.isValidPassword(null, 'fakePwd') == false);
 }

 @IsTest
 static void testSiteAsContainerEnabled() {
  System.assertNotEquals(null, LightningSelfRegisterController.siteAsContainerEnabled('https://portaleu1-developer-edition.eu11.force.com'));
 }

 /* Verifies the selfRegistration method flow with various invalid inputs */
 @IsTest
 static void testSelfRegistration() {
  Map < String, String > paramsMap = initializeParams();
  System.assertNotEquals(null, paramsMap);
  System.assertEquals(Label.Site.lastname_is_required, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), '', paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null,null, paramsMap.get('startUrl'), true, paramsMap.get('captchaSolve')));
  System.assertEquals(Label.Site.email_is_required, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, null, paramsMap.get('startUrl'), true, paramsMap.get('captchaSolve')));
  System.assertEquals(Label.Site.email_is_required, LightningSelfRegisterController.selfRegister(null, paramsMap.get('lastName'), '', null, paramsMap.get('confirmPasswordCorrect'), null,  null, paramsMap.get('startUrl'), true, paramsMap.get('captchaSolve')));
  System.assertEquals(Label.site.passwords_dont_match, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null,null, paramsMap.get('startUrl'), true, paramsMap.get('captchaSolve')));
  System.assertNotEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null,null, paramsMap.get('startUrl'), false, paramsMap.get('captchaSolve')));
 }


 /* Verifies the selfRegistration flow for valid inputs */
 @IsTest
 static void testSelfRegisterWithProperCredentials() {
  Map < String, String > paramsMap = initializeParams();
  Test.startTest();
  Test.setMock(HttpCalloutMock.class, new RET_reCAPTCHAMockCallout()); 
  System.assertEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, null, paramsMap.get('startUrl'), true, paramsMap.get('captchaSolve')));
  Test.stopTest();
 }

 /* Verifies SelfRegistration flow with an accounId that is created within the test */
 @IsTest
 static void testSelfRegisterWithCreatedAccount() {
  Account acc = new Account(name = 'test acc');
  insert acc;
  List < Account > accounts = [SELECT Id FROM Account LIMIT 1];
  System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
  String accountId = accounts[0].Id;
  Map < String, String > paramsMap = initializeParams();
  Test.startTest();
  Test.setMock(HttpCalloutMock.class, new RET_reCAPTCHAMockCallout());   
  System.assertEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), accountId,null, paramsMap.get('startUrl'), false, paramsMap.get('captchaSolve')));
  Test.stopTest();
 }

 @IsTest
 static void testGetNullExtraFields() {
  System.assertEquals(new List < Map < String, Object >> (), LightningSelfRegisterController.getExtraFields(null));
 }

 @IsTest
 static void testGetNonEmptyExtraFields() {
  System.assertEquals(new List < Map < String, Object >> (), LightningSelfRegisterController.getExtraFields('field1'));
 }

 /* Verifies validation of extraFields within the Self Registration flow */
 @IsTest
 static void testGetExtraFieldsInSelfRegistration() {
  List < Map < String, Object >> fieldlist = new List < Map < String, Object >> ();
  Map < String, String > paramsMap = initializeParams();
  Map < String, Object > fieldMap = new Map < String, Object > ();
  fieldMap.put('description', 'new field');
  //fieldMap.put('fieldPath', 'dummyPath');
  fieldMap.put('fieldPath', 'User_Region__c');
  fieldlist.add(fieldMap);
  String extraFields = JSON.serialize(fieldlist);
  Test.startTest();
  Test.setMock(HttpCalloutMock.class, new RET_reCAPTCHAMockCallout());   
  System.assertEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, extraFields, paramsMap.get('startUrl'), true, paramsMap.get('captchaSolve')));
  Test.stopTest();
 }

 @IsTest
 static void LightningSelfRegisterControllerInstantiation() {
  LightningSelfRegisterController controller = new LightningSelfRegisterController();
  System.assertNotEquals(controller, null);
 }

 @isTest
 static void testsetExperienceId(){

  String response = LightningSelfRegisterController.setExperienceId('1234');
  System.assertNotEquals(response, null);
 }

 @isTest
 static void testaddPermissionSet(){
    Id profileId = [Select Id from Profile where name='GSA System Administrator'].Id;
    User u = [Select Id from User Where profileId=:profileId and isActive=true Limit 1];
    LightningSelfRegisterController.addPermissionSet(u.Id);
    Id userId = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'AAAP_User' Limit 1].Id;
    System.assertNotEquals(userId, null);
    LightningSelfRegisterController.addPermissionSet(u.Id);
 }

    @isTest
    static void testswitchUserToRET(){
        Profile p = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id customRecTypeId = recordTypes.get('AAAP Portal').getRecordTypeId();
        Account a = new Account(Name=PBS_AAAP_GlobalConstants.CUSTOMER_PORTAL_ACCOUNT_NAME, RecordTypeId=customRecTypeId);
        insert a;
        Contact c = new Contact(accountId = a.Id, firstName='TestFirstName', lastName='TestLastName', email='testAAAPRET@testorg.com', PBS_AAAP_Terms_and_Conditions__c = false, PBS_AAAP_Company__c = 'Acumen',
                                MailingStreet = '1660 International Drive', MailingCity = 'McLean', MailingState = 'VA', MailingCountry='USA', MailingPostalCode = '22102',
                                Phone='202-202-2022', PBS_AAAP_PIN__c='123456', PBS_AAAP_StatesOfInterest__c='Virginia;Maryland;');
        insert c;
        User u = new User(alias = 'aliasStr', email='testAAAPRET@testorg.com', emailencodingkey='UTF-8', firstname='TestFirstName', lastname='TestLastName', PBS_AAAP_PIN__c = '123456',
                languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id, contactId=c.Id, timezonesidkey='America/Los_Angeles',
                username='testAAAPRET@testorg.com', PBS_AAAP_Regions__c='sofreg');
        insert u;
        Test.startTest();
        Map < String, String > paramsMap = initializeParams();
        Test.setMock(HttpCalloutMock.class, new RET_reCAPTCHAMockCallout()); 
        system.assertEquals(null, LightningSelfRegisterController.selfRegister('TestFirstName', 'TestLastName', 'testAAAPRET@testorg.com', paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null,null, paramsMap.get('startUrl'), true, paramsMap.get('captchaSolve')));
        Test.stopTest();
    }


 /* Helper method to initialize the parameters required for SelfRegistration. */
 private static Map < String, String > initializeParams() {
  Map < String, String > paramsMap = new Map < String, String > ();
  String firstName = 'test';
  String lastName = 'User';
  String email = 'testUser@salesforce.com';
  String password = 'testuser123';
  String confirmPasswordCorrect = 'testuser123';
  String confirmPasswordWrong = 'wrongpassword';
  String accountId = 'testuser123';
  String regConfirmUrl = 'http://registration-confirm.com';
  String startUrl = 'http://my.company.salesforce.com';
  String captchaSolve = 'test';
  paramsMap.put('firstName', firstName);
  paramsMap.put('lastName', lastName);
  paramsMap.put('email', email);
  paramsMap.put('password', password);
  paramsMap.put('confirmPasswordCorrect', confirmPasswordCorrect);
  paramsMap.put('confirmPasswordWrong', confirmPasswordWrong);
  paramsMap.put('accountId', accountId);
  paramsMap.put('regConfirmUrl', regConfirmUrl);
  paramsMap.put('startUrl', startUrl);
  paramsMap.put('captchaSolve', captchaSolve);
  System.assertNotEquals(paramsMap, null);
  return paramsMap;
 }
}