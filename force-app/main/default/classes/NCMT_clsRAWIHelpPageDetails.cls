public with sharing class NCMT_clsRAWIHelpPageDetails {

    public string redirectURL{get;set;}

    public pageReference redirectHelp() {
        
        NCMT_HelpContent__c ncmt_customsettings = NCMT_HelpContent__c.getOrgDefaults();
        redirectURL = ncmt_customsettings.NCMT_Help_Site_RA_WorkItem_Detail__c;
        PageReference pageRef= new PageReference(redirectURL);
        pageRef.setRedirect(true);
        return pageRef ;
    }

}