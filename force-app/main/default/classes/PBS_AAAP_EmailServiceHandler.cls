/*******************************************************************************************
* Name: PBS_AAAP_EmailServiceHandler
* Test: Test_PBS_AAAP_EmailServiceHandler
* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              ???               ????               Initial Creation  
*  1.1              Vanwinkle T       3/14/2021          update to With Shraring per SFWS-1666
*******************************************************************************/

global With Sharing class PBS_AAAP_EmailServiceHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String emailAddress = envelope.fromAddress;

        String userid = email.subject;
        System.debug('Userid:::::::: ' + userid);
        String[] userids = userid.split('usr-');
        System.debug('list of Userid:::::::: ' + userids);
        userid = userids[0].trim();
        System.debug('Userid:::::::: ' + userid);
        //userid  = userid.split('^')[1]; //Sandbox: ^sguni@acumensolutions.com
        //userid=userid.trim();
        System.debug('Userid:::::::: ' + userid);
        if (userid != null) {
            User usr = [SELECT id, username, isActive FROM User WHERE username = :userid];
            usr.IsActive = false;
            update usr;
        }
        return result;
    }
}