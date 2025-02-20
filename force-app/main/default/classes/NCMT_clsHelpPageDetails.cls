public with sharing class NCMT_clsHelpPageDetails{
public string redirectURL1{get;set;}
public string strProjectType {get;set;} 
public string strBuildingType {get;set;} 
    
    public pageReference load() {
    
        NCMT_HelpContent__c ncmt_customsettings = NCMT_HelpContent__c.getOrgDefaults();
        strProjectType = ApexPages.currentPage().getParameters().get('ProjectType');
        strBuildingType = ApexPages.currentPage().getParameters().get('BuildingType');
        
         if(strProjectType=='Parametric Entry' && strBuildingType != '')
        {
            redirectURL1 = ncmt_customsettings.NCMT_Help_Site_RA_Parametric__c;
        }
        else if(strProjectType=='Work Item Detail' && strBuildingType != '')
        {
            redirectURL1 = ncmt_customsettings.NCMT_Help_Site_RA_WorkItem__c;
        }
        else if(strProjectType=='New Construction' && strBuildingType == 'LPOE')
        {
            redirectURL1 = ncmt_customsettings.NCMT_Help_Site_New_Construction_LPOE__c;
        }
        else if(strProjectType=='New Construction' && strBuildingType == 'Parking Garage')
        {
            redirectURL1 = ncmt_customsettings.NCMT_Help_Site_New_Construction_PG__c;
        }   
        else if(strProjectType=='New Construction' && (strBuildingType != 'LPOE' || strBuildingType != 'Parking Garage'))
        {
            redirectURL1 = ncmt_customsettings.NCMT_Help_Site_New_Construction_Oth__c;
        }   
        else{
            redirectURL1 = ncmt_customsettings.NCMT_Help_Site__c;
        }    
        //system.debug('redirectURL=='+redirectURL);
        PageReference pageRef1 = new PageReference(redirectURL1);
        pageRef1.setRedirect(true);
        return pageRef1 ;

    }
}