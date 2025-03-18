public with sharing class NCMT_TreeRelatedListController {
    
    @AuraEnabled public List<NCMT_Tree_structure__c> treestruc {get;set;}
    @AuraEnabled public NCMT_Project__c projects {get;set;}
    @AuraEnabled public NCMT_Project__c proj {get;set;}
    
    //Constructor
    public NCMT_TreeRelatedListController(ApexPages.StandardController controller) { 
        
        proj = (NCMT_Project__c)controller.getRecord();      
        
        projects = [SELECT id, Name FROM NCMT_Project__c WHERE id=: proj.id LIMIT 1];
        
        treestruc = [SELECT id, Project_ID__c, Project_ID__r.name, Name, Total_Direct_Cost__c,RecordType.Name, description__c, branch_name__c, Include_In_Estimate__c, Level__c, Order__c, Relatedtree__r.name, Parent_Node_Desc__c, Total_Cost__c, SortOrdertxt__c
                     from NCMT_Tree_structure__c where Project_ID__c = :projects.id ORDER BY SortOrdertxt__c];
        
    }
    
    
     /*public static Boolean islevel1User() {
        AggregateResult[] listCount = [select count(Id) usr FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name IN ('NCMT-Users-LVL2-CRE','NCMT-Users-LVL3-CRE','NCMT-Users-LVL4-CRE','NCMT-Users-LVL5-CRE')];
        Integer count = (integer) listCount [0].get('usr');
        system.debug('count' + count);
        
        boolean islevel1User = (count > 0);
        system.debug('islevel1User::' + islevel1User);
        return islevel1User;
        
    }*/
    
    
    //This method is to edit the existing record while clicking the Edit link 
    /*public pageReference editTree(){  
        
        String treeId = Apexpages.currentpage().getParameters().get('treeId');  
        
        pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + treeId + '/e?retURL=' + projects.id);  
        
        return pageRef;  
        
    }  */     
}