@IsTest
private class Test_PBS_AAAP_ForgotPasswordController {
	static testmethod void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
    static testmethod void testForgotPasswordController1() {
        // Instantiate a new controller with all parameters in the page
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = 'sguni@acumensolutions.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}