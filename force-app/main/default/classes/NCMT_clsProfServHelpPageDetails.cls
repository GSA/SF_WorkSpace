public with sharing class NCMT_clsProfServHelpPageDetails {

public string redirectURL{get;set;}

    public pageReference redirectHelp() {
        
        NCMT_HelpContent__c ncmt_customsettings = NCMT_HelpContent__c.getOrgDefaults();
        redirectURL = ncmt_customsettings.NCMT_Help_Site_Professional_Services__c;
        PageReference pageRef= new PageReference(redirectURL);
        pageRef.setRedirect(true);
        return pageRef ;
    }
}