@isTest
public with sharing class TestPBS_gBUILD_ProjectIdBaseController {
	public static testmethod void additionalTesting(){
		
		PBS_gBUILD_ProjectIdBaseController controller = new PBS_gBUILD_ProjectIdBaseController('TestName');
		Boolean  test = controller.ReadWriteMode;
		map<String, String> result = controller.formPermissionByRole;
		controller.createPageLinkFromObjectId('12345');
		
		system.assertEquals(test, false);
		
	} 
}