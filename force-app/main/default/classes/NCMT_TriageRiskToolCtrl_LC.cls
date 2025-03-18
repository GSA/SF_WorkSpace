public with sharing class NCMT_TriageRiskToolCtrl_LC {
    @AuraEnabled public NCMT_Project__c proj {get;set;}
    @AuraEnabled public NCMT_Project_Deliverable__c filterDeliverable {get;set;}

    public NCMT_TriageRiskToolCtrl_LC(ApexPages.StandardController controller) {
        //proj = (NCMT_Project__c)controller.getRecord(); 
    }
    public NCMT_TriageRiskToolCtrl_LC() { //ApexPages.StandardController controller
        //proj = (NCMT_Project__c)controller.getRecord(); 
    }

    public class triageWrapper{     
        @AuraEnabled public NCMT_Project__c project {get; set;}
        @AuraEnabled public NCMT_Project_Deliverable__c filterDeliverable {get; set;}
    } 

    @AuraEnabled
    public static triageWrapper init(string recordId){
        triageWrapper wrapper = new triageWrapper();
        
        wrapper.filterDeliverable = new NCMT_Project_Deliverable__c();
        wrapper.filterDeliverable.Project_type__c = '';
        wrapper.filterDeliverable.Project_Delivery_Method__c = '';
        
        if (recordId != null &&recordId != ''){
            //If project passed in, pre-populate the filter
            wrapper.project = getProjectData(recordId);
            
            wrapper.filterDeliverable.Project_Delivery_Method__c = wrapper.project.Project_Delivery_Method__c;
            wrapper.filterDeliverable.Project_type__c = wrapper.project.Triage_project_type__c;
            wrapper.filterDeliverable.Funding_Type__c = wrapper.project.Funding_Type__c;
            wrapper.filterDeliverable.Project_Budget__c = wrapper.project.Triage_Budget__c;
        } else {
            wrapper.project = new NCMT_Project__c();
            
        }
        return wrapper;
    }

    @AuraEnabled
    public static NCMT_Project__c getProjectData(string projectId){
        NCMT_Project__c projectData = new NCMT_Project__c();
        if (projectId != null &&projectId != '')
            projectData = [SELECT id, Name, Triage_Budget__c, Project_Delivery_Method__c, 
                Project_Phases__c, Project_SubPhases__c, Triage_project_type__c, Funding_Type__c
                FROM NCMT_Project__c WHERE id= :projectId];
        return projectData;
    }

    @AuraEnabled
    public static List<NCMT_Project_Deliverable__c> getDeliverables(NCMT_Project_Deliverable__c filterDel){
        System.debug('filterDel ===== ' +filterDel);
        List<NCMT_Project_Deliverable__c> deliverables = new List<NCMT_Project_Deliverable__c>();
        String soql = 'Select Id, Funding_Type__c, Project_Budget__c, Project_Delivery_Method__c, ';
        soql += 'Project_Phases__c, Project_SubPhase__c , Project_type__c, Status__c, Name ';
        soql += ' from NCMT_Project_Deliverable__c where ';

        String whereString = '';
        if (filterDel.Funding_Type__c != null &&filterDel.Funding_Type__c != ''){
            if (whereString != '') whereString += ' AND ';
            whereString += ' Funding_Type__c = \'' +string.escapeSingleQuotes(filterDel.Funding_Type__c)+'\'';
        }
        if (filterDel.Project_Budget__c != null &&filterDel.Project_Budget__c != ''){
            if (whereString != '') whereString += ' AND ';
            whereString += ' Project_Budget__c = \'' +string.escapeSingleQuotes(filterDel.Project_Budget__c) +'\'';
        }
        if (filterDel.Project_Delivery_Method__c != null &&filterDel.Project_Delivery_Method__c != ''){
            if (whereString != '') whereString += ' AND ';
            whereString += ' Project_Delivery_Method__c = \'' +string.escapeSingleQuotes(filterDel.Project_Delivery_Method__c) +'\'';
        }
        if (filterDel.Project_type__c != null &&filterDel.Project_type__c != ''){
            if (whereString != '') whereString += ' AND ';
            whereString += ' Project_type__c = \'' +string.escapeSingleQuotes(filterDel.Project_type__c) +'\'';
        }

        if (whereString != ''){ 
            deliverables = Database.query(soql + whereString +' ORDER BY Sort_Order__c');
        }
        return deliverables;
    }
}