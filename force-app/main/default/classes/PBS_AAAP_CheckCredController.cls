public with sharing class PBS_AAAP_CheckCredController{//Julia Kantarovsky removed 'without sharing' and added 'with sharing' on 6.25.21

    public Boolean showError {get;set;}
    public string pageURLForRedirection {get;set;}
    public PBS_AAAP_CheckCredController(){
    
    }

    public pageReference checkCred(){
        showError = FALSE;
        Id uId = UserInfo.getUserId();
        Id profileId = [SELECT Id, profileId FROM User WHERE Id =: uId LIMIT 1].profileId;
        String profileName = [SELECT Name FROM Profile WHERE Id =: profileId LIMIT 1].Name;
        PermissionSet[] permSet = [Select name, id FROM PermissionSet where Name like '%AAAP_User%' limit 1];
        List<PermissionSetAssignment> ps = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId =: permSet[0].Id AND AssigneeId =: uId];
        if(profileName == 'AAAP Customer Portal' || ps.size() != 0){
            /*PageReference homePage = new PageReference('/AAAP/portalHome');
            homePage.setRedirect(true);*/
            //return homePage;
            PageReference p = new PageReference(Label.LOP_Community_Base_URL+'AAAP-PortalHome');
            pageURLForRedirection = p.getUrl();
            return p;
        } else {
            showError = TRUE;
            return null;
        }
    }
    
    
    

}