@isTest(SeeAllData=false)
public class RET_ThemeControllerTest {

	static testmethod void testUserType() {

		String usrType = RET_ThemeController.getUserType();
		System.assertNotEquals(null, usrType);

	}

}