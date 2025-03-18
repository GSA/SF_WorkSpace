/*******************************************************************************************
* Name: Test_PBS_AAAP_EmailServiceHandler
* supports: PBS_AAAP_EmailServiceHandler
* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              ???               ????               Initial Creation  
*  1.1              Vanwinkle T       3/14/2021          per SFWS-1666 - email of receiver update to test user to provied code coverage.
*******************************************************************************/
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_PBS_AAAP_EmailServiceHandler {
    
    static testMethod void testMe() {
        //look up the standard user profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         String orgId = UserInfo.getOrganizationId();
    String dateString = 
        String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
        ///create standard user
        User u = new User(Alias = 'standt1', Email='standarduser@testorg1.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName + '@test' + orgId + '.org');
        insert u;
        
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email
        email.subject = uniqueName + '@test' + orgId + '.org' ;
        email.fromname = 'FirstName LastName';
        env.fromAddress = 'someaddress@email.com';
        
        
        
        // call the email service class and test it with the data in the testMethod
        PBS_AAAP_EmailServiceHandler edr = new PBS_AAAP_EmailServiceHandler();
        Test.startTest();
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Test.stopTest();
        System.assert (result.success, 'InboundEmailResult returned a failure message');
        
        
    }
}