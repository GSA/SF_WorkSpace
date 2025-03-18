public with sharing class RET_ThemeController {

	@AuraEnabled
	public static String getUserType() {
		return userInfo.getUserType();
	}


}