global without sharing class URLRewriter implements Site.UrlRewriter {
   
    global PageReference mapRequestUrl(PageReference myOriginalUrl){
        String url = myOriginalUrl.getUrl();
        String name;
        system.debug('Orginal URL is: '+url);
        if(url.equalsignorecase('/RSAP/help')){
            name = 'PBS_LOP_Help';
        } else if(url.equalsignorecase('/AAAP/help')){
            name = 'PBS_AAAP_Help';
        } else if(url.equalsignorecase('/LOPHelp')) {
            name = 'PBS_AAAP_LOPHelp';
        } else if(url.equalsignorecase('/RSAP/Help?Type=lop')){
            name = 'PBS_AAAP_Help?Type=lop';
        } else if(url.equalsIgnoreCase('/RSAP/UserRegistration')) {
            name = 'PBS_AAAP_UserRegistration';
        } else if(url.equalsIgnoreCase('/RSAP/userprofile?Type=lop')){
            name = 'PBS_AAAP_UserProfile?Type=lop';
        } else if(url.equalsIgnoreCase('/RSAP/UserProfile')) {
            name = '/PBS_AAAP_UserProfile';
        } else if(url.equalsIgnoreCase('/aaap')){
            name = '/PBS_AAAP_LoginPage';
        } else if(url.equalsIgnoreCase('/rsap')){
            name = '/PBS_LOP_LoginPage';
        } else if(url.equalsIgnoreCase('/lop')){
            name = '/PBS_LOP_LoginPage';
        } else if(url.startsWithIgnoreCase('/AAAP/LOP_offerform1364')) {
           // name = url.remove('/AAAP');
            name = url.remove('/AAAP/LOP_offerform1364');
            name = '/PBS_LOP_NewOfferForm1364'+name;
        } else if(url.startsWithIgnoreCase('/AAAP/LOP_offerform1217')) {
            name = url.remove('/AAAP');
        } else if(url.startsWithIgnoreCase('/AAAP/PBS_LOP_RSAPpv')) {
            name = url.remove('/AAAP');
        } else if(url.startsWithIgnoreCase('/AAAP/') && !url.contains('PBS_AAAP_')){
            name = url.remove('/AAAP/');
            name = 'PBS_AAAP_'+name;
        } else if (url.startsWithIgnoreCase('/RSAP/')){
            name = url.remove('/RSAP/');
            name = 'PBS_LOP_'+name;
        }  else {
            name = url;
        }
        system.debug('Converted incoming URL name to '+name);
        if (name.startsWithIgnoreCase('https')) { 
            //drop the host to protect against possible URL redirection attack
            name = name.substring(name.indexOf('/', 8));
        } else {
            if (name.startsWithIgnoreCase('http')) {
                name = name.substring(name.indexOf('/', 7));
            }
        }
        system.debug('Final converted URL: ' + name);
        PageReference pr = new PageReference(name);
        system.debug('PageReference is: '+name);
        return pr;
    }
    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls){
        system.debug('In the method'+mySalesforceUrls);
        return mySalesforceUrls;
    }
}