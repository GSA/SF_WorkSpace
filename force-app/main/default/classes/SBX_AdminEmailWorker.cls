/**
*	The sf-sandbox-post-copy framework is an open source project managed in Github (https://github.com/GSA/sf-sandbox-post-copy)
*
*	SBX_AdminEmailWorker
*
*	@author Derek Benner
*	@author Manikanta Ramineni
*	@author Christian Coleman
*	@date 4/12/2016
*/
public with sharing class SBX_AdminEmailWorker extends SBX_PostCopyWorker{

	public static boolean IS_TEST = false;

	private static final String ADMIN_PROFILE = 'GSA System Administrator';
	private final String CLASS_NAME = 'SBX_AdminEmailWorker';
	private final String EMAIL_PATTERN_1 = '@example.com';
	private final String EMAIL_PATTERN_1_FIXED = '';
	private final String EMAIL_PATTERN_2 = '=gsa.gov';
	private final String EMAIL_PATTERN_2_FIXED = '@gsa.gov';

	public SBX_AdminEmailWorker(){
		// do nothing
	}

	protected override void run(SandboxContext context){
		Id profileId = getProfileId();
		List<User> adminUsers = [
							SELECT Id, Email
							FROM User
							WHERE ProfileId = :profileId
						];
		updateUsers(adminUsers);
	}

	public override String getClassName(){
		return CLASS_NAME;
	}

	private void updateUsers(List<User> userList){
		if(IS_TEST) throw new SBX_PostCopyUtil.ForcedException();
		Integer userListSize = userList.size();
		for(Integer i = 0; i < userListSize; i++){
			User u = userList.get(i);
			if(u.Email.contains(EMAIL_PATTERN_1) && u.Email.contains(EMAIL_PATTERN_2)){
				u.Email = fixEmailAddress(u.Email);
			} else {
				userList.remove(i);
				userListSize--;
				i--;
			}
		}
		update userList;
	}

	private String fixEmailAddress(String email){
		return email.replace(EMAIL_PATTERN_1,EMAIL_PATTERN_1_FIXED)
					.replace(EMAIL_PATTERN_2,EMAIL_PATTERN_2_FIXED);
	}

	public static Id getProfileId(){
		try {
			return [
				SELECT Id
				FROM Profile
				WHERE Name = :ADMIN_PROFILE].Id;
		} catch (QueryException e){

			return null;
		}
	}

}