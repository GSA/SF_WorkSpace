public with sharing class NCMT_GSAExpressMenu_LC {
    /*Replaced by NCMT_TreeStructure_CostSelection, construction for test coverage*/
    public String fiscalYear {get;set;}
    public NCMT_GSAExpressMenu_LC(ApexPages.StandardController stdController) {

        NCMT_Tree_structure__c treeStruc = (NCMT_Tree_structure__c)stdController.getRecord();

        if (treeStruc != null && treeStruc.id != null){
            treeStruc = [select Estimate_Format__c, Project_ID__c, Project_ID__r.name, 
                                                         Project_ID__r.Cost_Parameter_Date_FY__c, Name 
                                                   from NCMT_Tree_structure__c where id = :treeStruc.Id];
            fiscalYear = treeStruc.Project_ID__r.Cost_Parameter_Date_FY__c;

        }
    }
/*
    @AuraEnabled
    public static NCMT_TreeNode treeMe(Integer level, String parentKey, String fiscalYear, String searchVal, String fileType){
        System.debug(level +' ' +parentKey +' ' +fiscalYear +' ' +searchVal +' ' +true);
        return new NCMT_TreeNode(level, 'toplevel', parentKey, fiscalYear, fileType, searchVal, true);
    }*/
}