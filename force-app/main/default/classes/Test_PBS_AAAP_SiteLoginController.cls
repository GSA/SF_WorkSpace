@IsTest
public class Test_PBS_AAAP_SiteLoginController {
	static testmethod void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);
        
        ApexPages.currentPage().getParameters().put('startURL', '/apex/PBS_AAAP_PortalHome');    
        System.assertEquals(controller.login(),null);                       
    } 
    
     static testmethod void testSiteLoginController1 () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        controller.getItems();
         controller.offerType = 'Traditional';
         controller.selectTab = 'Home';
         controller.userid = '1231313213';
         controller.pin = '3456';
        System.assertEquals(controller.login(controller.username, controller.password),null);   
        ApexPages.currentPage().getParameters().put('startURL', '/apex/PBS_AAAP_PortalHome');    
        System.assertEquals(controller.login(controller.username, controller.password),null);   
         ApexPages.currentPage().getParameters().put('startURL', '');    
         controller.offerType = 'Traditional';
        System.assertEquals(controller.login(),null); 
         
    }   
}