/**
*	The sf-sandbox-post-copy framework is an open source project managed in Github (https://github.com/GSA/sf-sandbox-post-copy)
*
*	SBX_AdminEmailWorkerTest
*
*	@author Derek Benner
*	@author Manikanta Ramineni
*	@author Christian Coleman
*	@date 4/12/2016
*/
@isTest
public with sharing class SBX_AdminEmailWorkerTest {

	private static final String UNAME_USER_1 = 'a1234@b.com.SBX_AdminEmailWorkerTest';
	private static final String UNAME_USER_2 = 'b1234@b.com.SBX_AdminEmailWorkerTest';
	/**
	* Validity in the constants below is based on whether the code will process successfully
	* 	i.e. a valid one has both '=gsa.gov' and '@example.com' in it - see the SBX_AdminEmailWorker
	* 	update method to see exact logic
	*/
	private static final String INVALID_EMAIL = 'a@b.com';
	private static final String VALID_EMAIL = 'abc=gsa.gov@example.com';
	private static final String VALID_EMAIL_CORRECTED = 'abc@gsa.gov';

	static testMethod void testRun_UserWithNonGSAEmail_NoEmailChange(){
		User userWithABadEmail;
		try {
			userWithABadEmail = [
							SELECT Id
							FROM User
							WHERE Username = :UNAME_USER_1
						];
		} catch (QueryException e){
			System.debug('User not found - e: ' + e);
			System.assert(false);
			return;
		}
		System.runAs(userWithABadEmail){
			Test.startTest();
			SBX_AdminEmailWorker worker = new SBX_AdminEmailWorker();
			worker.process(null); // null is the SandboxContext; SBX_AdminEmailWorker doesn't use it
			Test.stopTest();
		}
		try {
			userWithABadEmail = [
							SELECT Id, Email
							FROM User
							WHERE Username = :UNAME_USER_1
						];
		} catch (QueryException e){
			System.debug('User not found - e: ' + e);
			System.assert(false);
			return;
		}
		System.assertEquals(INVALID_EMAIL, userWithABadEmail.Email);
	}

	static testMethod void testRun_UserWithValidEmail_EmailChanged(){
		User userWithAGoodEmail;
		try {
			userWithAGoodEmail = [
							SELECT Id
							FROM User
							WHERE Username = :UNAME_USER_2
						];
		} catch (QueryException e){
			System.debug('User not found - e: ' + e);
			System.assert(false);
		}

		System.runAs(userWithAGoodEmail){
			Test.startTest();
			SBX_AdminEmailWorker worker = new SBX_AdminEmailWorker();
			worker.process(null); // null is the SandboxContext; SBX_AdminEmailWorker doesn't use it
			Test.stopTest();
		}
		try {
			userWithAGoodEmail = [
							SELECT Id, Email, ProfileId
							FROM User
							WHERE Username = :UNAME_USER_2
						];
		} catch (QueryException e){
			System.debug('User not found - e: ' + e);
			System.assert(false);
		}
		System.assertEquals(VALID_EMAIL_CORRECTED, userWithAGoodEmail.Email);
	}

	/**
	* It's important to note we are forcing an exception here using the SBX_AdminEmailWorker.IS_TEST variable.
	* What we want to do is verify a log object was created via the parent class SBX_PostCopyWorker.
	* SBX_PostCopyWorker will be implemented by others and the point here is to make sure we log any uncaught exceptions.
	*/
	static testMethod void testRun_UnknownExceptionOccursViaChildClass_VerifyLogObjectCreated(){
		SBX_AdminEmailWorker.IS_TEST = true;

		User firstUser;
		try {
			firstUser = [
						SELECT Id
						FROM User
						WHERE Username = :UNAME_USER_1
					];
		} catch (QueryException e){
			System.debug('User not found - e: ' + e);
			System.assert(false);
		}
		System.runAs(firstUser){
			Test.startTest();
			SBX_AdminEmailWorker worker = new SBX_AdminEmailWorker();
			worker.process(null); // null is the SandboxContext; SBX_AdminEmailWorker doesn't use it
			Test.stopTest();
		}
		// verify a log object was created - caught in SBX_PostCopyWorker - should only be one
		List<Post_Copy_Log__c> logList = [SELECT Id FROM Post_Copy_Log__c LIMIT 2];
		System.assertEquals(1, logList.size());
	}

	@testSetup static void initializeTestData(){
		List<User> usersToCreate = new List<User>();
		User secondUser = createTestUser(UNAME_USER_2, VALID_EMAIL);
		User firstUser = createTestUser(UNAME_USER_1, INVALID_EMAIL);
		usersToCreate.add(firstUser);
		usersToCreate.add(secondUser);
		insert usersToCreate;

		List<User> userList = [SELECT Id FROM User WHERE Username = :UNAME_USER_1 OR UserName = :UNAME_USER_2];
		System.assertEquals(userList.size(), 2);
	}

	private static User createTestUser(String uname, String email){
		User u = new User();
		u.Username = uname;
		u.LastName = 'LastName';
		u.Email = email;
		u.Alias = uname.substring(0,4);
		u.CommunityNickname = uname.substring(0,4);
		u.TimeZoneSidKey = 'GMT';
		u.EmailEncodingKey = 'UTF-8';
		u.LanguageLocaleKey = 'en_US';
		u.LocaleSidKey = 'en_US';
		u.ProfileId = SBX_AdminEmailWorker.getProfileId();
		// At least one GSA org has a required Region custom field
		// so attempt to set a value
		try {
			u.put('Region__c', '1');
		}
		catch (Exception e) {
			System.debug('No Region attribute for User in this org');
		}
		return u;
	}
}