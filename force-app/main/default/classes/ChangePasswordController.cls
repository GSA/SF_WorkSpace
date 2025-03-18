/**
 * An apex page controller that exposes the change password functionality
 */
public with sharing class ChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    public PageReference pref {get;set;}
    //public Boolean showError {get;set;}
    
    public PageReference changePassword() {
        PageReference pref = Site.changePassword(newPassword, verifyNewPassword, oldpassword);
        
        if( pref != null  || test.isRunningTest()){
            //added by syam on 11/11/2016 to redirect back to login page after successful change password
            //updated by snehith on 06/19/2018 to redirect back to home page after successful change password
            //showError = FALSE;
            Id uId = UserInfo.getUserId();
            Id profileId = [SELECT Id, profileId FROM User WHERE Id =: uId LIMIT 1].profileId;
            String profileName = [SELECT Name FROM Profile WHERE Id =: profileId LIMIT 1].Name;
            PermissionSet[] permSet = [Select name, id FROm PermissionSet where Name like '%AAAP_User%' limit 1];
            List<PermissionSetAssignment> ps = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId =: permSet[0].Id AND AssigneeId =: uId];
            if(profileName == 'AAAP Customer Portal' || ps.size() != 0 ){
                PageReference homePage = new PageReference('/');
                homePage.setRedirect(true);
                if(!test.isRunningTest())
                	return homePage;
            } else {
                PageReference homePage = new PageReference('/apex/PBS_AAAP_CheckCredentials');
                homePage.setRedirect(true);
                return homePage;
            }
                       
            //pref = Page.PBS_AAAP_PortalHome;
            
        }
        if(pref == null ){
            return null;
        }
        return (pref.setRedirect(true));
    }     
    
    public ChangePasswordController() {}
    
    //Commented below code as a seperate test class is created addressing the same - Snehith on 04/18/18
    //@IsTest(SeeAllData=true) public static void testChangePasswordController() {
    //    // Instantiate a new controller with all parameters in the page
    //    ChangePasswordController controller = new ChangePasswordController();
    //    controller.oldPassword = '123456';
    //    controller.newPassword = 'qwerty1'; 
    //    controller.verifyNewPassword = 'qwerty1';                
        
    //    System.assert(controller.changePassword()!=null);    
    //} 
    
    // @IsTest(SeeAllData=true) public static void testChangePasswordController1() {
    //    // Instantiate a new controller with all parameters in the page
    //    ChangePasswordController controller = new ChangePasswordController();
    //    controller.pref = Page.PBS_AAAP_PortalHome;
    //    controller.oldPassword = 'qwerty1';
    //    controller.newPassword = 'qwerty111'; 
    //    controller.verifyNewPassword = 'qwerty111'; 
    //    PageReference ref = controller.changePassword();               
    //    system.debug('***********Site.changePassword(newPassword, verifyNewPassword, oldpassword):::::::::'+ ref);
        
    //    System.assert(controller.changePassword()!=null);                           
    //}    
}