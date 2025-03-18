/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    
    // Tab Panel
    global string selectTab {get;set;}
    
    // Variables used for User De-Registration
    global String userid {get; set;}
    global String pin {get; set;}
    global String offerType {get;set;}
    
    global PageReference login() {
        
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        System.debug('start URL:::::::::::::::: '+System.currentPageReference());
        System.debug('Offer Type is ****'+offerType);
        // return Site.login(username, password, '/home/home.jsp');
        if (startUrl == ''||startUrl == null) {
            // Set a cookie for checking if logging in the first time
            Cookie counter = ApexPages.currentPage().getCookies().get('counter');
            if (counter == null) {
                counter = new Cookie('counter', '1', '/', -1, true);
                ApexPages.currentPage().setCookies(new Cookie[] {counter});
            }
             if(offerType == 'AAAP')                        
            return Site.login(username, password, '/AAAP/CheckCredentials');     
            else
                return Site.login(username, password, '/RSAP/PortalHome');      
        } else {
            return Site.login(username, password, startUrl);
        }
    }
    
    global PageReference login(string username1, string password1) {
        
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        System.debug('start URL:::::::::::::::: '+System.currentPageReference());
       // return Site.login(username, password, '/home/home.jsp');
       if(startUrl == ''||startUrl == null)
       {
        return Site.login(username1, password1, '/AAAP/CheckCredentials');
       }   
       else
        return Site.login(username1, password1, startUrl);
       
    }
    
    /*
    // new code starts here
    global void tabPanelSelect(){
        if(ApexPages.currentPage().getParameters().get('selectTab')!=null){
            selectTab = ApexPages.currentPage().getParameters().get('selectTab');
        }
        else{
            selectTab = 'aboutAAAP';
        }
        System.debug('===>>> selected Tab ::: '+selectTab);
    }*/
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Traditional','RSAP Offer (Coming Soon)'));
        options.add(new SelectOption('AAAP','AAAP Offer'));
        return options;
    }

       
    global SiteLoginController () {
        
        offerType = 'AAAP';
    }
    
    //Snethith - commented below code in order to create a test class on its own 04/18/18
    //@IsTest(SeeAllData=true) global static void testSiteLoginController () {
    //    // Instantiate a new controller with all parameters in the page
    //    SiteLoginController controller = new SiteLoginController ();
    //    controller.username = 'test@salesforce.com';
    //    controller.password = '123456'; 
                
    //    System.assertEquals(controller.login(),null);
        
    //    ApexPages.currentPage().getParameters().put('startURL', '/apex/PBS_AAAP_PortalHome');    
    //    System.assertEquals(controller.login(),null);                       
    //} 
    
    // @IsTest(SeeAllData=true) global static void testSiteLoginController1 () {
    //    // Instantiate a new controller with all parameters in the page
    //    SiteLoginController controller = new SiteLoginController ();
    //    controller.username = 'test@salesforce.com';
    //    controller.password = '123456'; 
    //    controller.getItems();
    //     controller.offerType = 'Traditional';
    //     controller.selectTab = 'Home';
    //     controller.userid = '1231313213';
    //     controller.pin = '3456';
    //    System.assertEquals(controller.login(controller.username, controller.password),null);   
    //    ApexPages.currentPage().getParameters().put('startURL', '/apex/PBS_AAAP_PortalHome');    
    //    System.assertEquals(controller.login(controller.username, controller.password),null);   
    //     ApexPages.currentPage().getParameters().put('startURL', '');    
    //     controller.offerType = 'Traditional';
    //    System.assertEquals(controller.login(),null); 
         
    //}    
}