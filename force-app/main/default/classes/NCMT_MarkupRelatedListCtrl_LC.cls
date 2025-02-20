public with sharing class NCMT_MarkupRelatedListCtrl_LC {
    
    @AuraEnabled public NCMT_Project__c proj {get;set;}
    
    public NCMT_MarkupRelatedListCtrl_LC(ApexPages.StandardController controller) {
        proj = (NCMT_Project__c)controller.getRecord();
    }
    public class projectWrapper{     
        @AuraEnabled public NCMT_Project__c project {get; set;}
        @AuraEnabled public List<NCMT_Project_Markup__c> projectMP {get; set;}
    } 
    @AuraEnabled
    public static projectWrapper init(string recordId){
        projectWrapper wrapper = new projectWrapper();
        wrapper.project = getProjectData(recordId);
        wrapper.projectMP = getProjectMPData(recordId);  
        return wrapper;
    }
    @AuraEnabled
    public static NCMT_Project__c getProjectData(string projectId){
        NCMT_Project__c projectData = [SELECT id, Name, Markup_Method__c, Location_Multiplier__c FROM NCMT_Project__c WHERE id= :projectId];
        return projectData;
    }
    @AuraEnabled
    public static List <NCMT_Project_Markup__c> getProjectMPData(string projectId){
         List<NCMT_Project_Markup__c> projectMPData = new List<NCMT_Project_Markup__c>();
        
        
     /*
      * Below Line has been commented out and new query without ECCA,ECC and ETPC has been added as a fix to SFWS-2014 on Nov 8, 2022.
      * 
      * /   
  /*      projectMPData = [SELECT Id, Name,Site_Design_Contingency__c, Construction_Contingency__c,Art_In_Architecture__c,ECCA__c, ECC__c,ETPC__c 
                                                FROM NCMT_Project_Markup__c WHERE Project_Name__c = :projectId]; */
        
         projectMPData = [SELECT Id, Name,Site_Design_Contingency__c, Construction_Contingency__c,Art_In_Architecture__c
                                                FROM NCMT_Project_Markup__c WHERE Project_Name__c = :projectId]; 
        return projectMPData;
    }
}