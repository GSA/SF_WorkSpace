@IsTest(SeeAllData=false)
private class Test_PBS_AAAP_ChangePasswordController {
  static testmethod void testChangePasswordController() {  
  
    Profile pf = [Select Id from profile where Name='AAAP Customer Portal']; 
    String orgId=UserInfo.getOrganizationId(); 
    String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
    String uniqueName=orgId+dateString+RandomId; 

    Account portalAccount1 = new Account(
    Name = 'TestAccount');
    insert portalAccount1;
    
    //Create contact
    Contact contact1 = new Contact(
    FirstName = 'Test',
    Lastname = 'McTesty',
    AccountId = portalAccount1.Id);
    insert contact1;

    User uu = new User(firstname = 'ABC',
            contactId = contact1.Id, 
            lastName = 'XYZ', 
            email = uniqueName + '@test' + orgId + '.org', 
            Username = uniqueName + '@test' + orgId + '.org', 
            EmailEncodingKey = 'ISO-8859-1', 
            Alias = uniqueName.substring(18, 23), 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US', 
            ProfileId = pf.Id); 
    insert uu;
  
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assert(controller.changePassword()!=null);  
        
        system.runAs(uu){
            controller = new ChangePasswordController();
            controller.changePassword();
        }
    } 
    
     static testmethod void testChangePasswordController1() {
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.pref = Page.PBS_AAAP_PortalHome;
        controller.oldPassword = 'qwerty1';
        controller.newPassword = 'qwerty111'; 
        controller.verifyNewPassword = 'qwerty111'; 
        PageReference ref = controller.changePassword();               
        system.debug('***********Site.changePassword(newPassword, verifyNewPassword, oldpassword):::::::::'+ ref);
        
        System.assert(controller.changePassword()!=null); 
        
        controller = new ChangePasswordController();
        controller.changePassword();
                                  
    }
    
}