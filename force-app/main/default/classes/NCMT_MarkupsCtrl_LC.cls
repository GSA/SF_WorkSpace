public with sharing class NCMT_MarkupsCtrl_LC {

    @AuraEnabled public NCMT_Project_Markup__c projmp {get;set;}
    public NCMT_MarkupsCtrl_LC(ApexPages.StandardController controller) {
        projmp = (NCMT_Project_Markup__c)controller.getRecord(); 
    }
    public class projectWrapper{     
        @AuraEnabled public NCMT_Project_Markup__c project {get; set;}
    } 
    @AuraEnabled
    public static projectWrapper init(string recordId){
        projectWrapper wrapper = new projectWrapper();
        wrapper.project = getProjectMPData(recordId);  
        return wrapper;
    }
    @AuraEnabled
    public static NCMT_Project_Markup__c getProjectMPData(string projectId){
        NCMT_Project_Markup__c projectMPData = [SELECT id, Name, Project_Name__r.Markup_Method__c FROM NCMT_Project_Markup__c WHERE id= :projectId];
        return projectMPData;
    }
    /*public static Boolean islevelThree() {
        AggregateResult[] listCount = [select count(Id) usrs FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name ='NCMT-Users-LVL3-CRE'];
        Integer count = (integer) listCount [0].get('usrs');
        
        boolean islevelThree = (count > 0);
        return islevelThree;
        
    }*/
}