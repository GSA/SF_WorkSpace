/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username {get; set;}
    public String type {get; set;}
       
    public ForgotPasswordController() {
        type = Apexpages.currentPage().getParameters().get('type');
    }
    
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);
        pr.getParameters().put('type',type);
        if (success) {              
            return pr;
        }
        return null;
    }
    
    //Snehith - commented below code as a seperate test class has been created for the same purpose - 04/18/18
    // @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
    //    // Instantiate a new controller with all parameters in the page
    //    ForgotPasswordController controller = new ForgotPasswordController();
    //    controller.username = 'test@salesforce.com';        
    
    //    System.assertEquals(controller.forgotPassword(),null); 
    //}
    //@IsTest(SeeAllData=true) public static void testForgotPasswordController1() {
    //    // Instantiate a new controller with all parameters in the page
    //    ForgotPasswordController controller = new ForgotPasswordController();
    //    controller.username = 'sguni@acumensolutions.com';        
    
    //    System.assertEquals(controller.forgotPassword(),null); 
    //}
}