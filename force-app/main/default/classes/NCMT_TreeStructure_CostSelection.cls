public with sharing class NCMT_TreeStructure_CostSelection {

    public String fiscalYear {get;set;}
    public NCMT_TreeStructure_CostSelection(ApexPages.StandardController stdController) {

        NCMT_Tree_structure__c treeStruc = (NCMT_Tree_structure__c)stdController.getRecord();
		System.debug('treeStruc.Id: '+treeStruc.Id);
        if (treeStruc != null && treeStruc.id != null){
            treeStruc = [select Estimate_Format__c, Project_ID__c, Project_ID__r.name, 
                                                        Project_ID__r.Cost_Parameter_Date_FY__c, Name 
                                                from NCMT_Tree_structure__c where id = :treeStruc.Id];
            fiscalYear = treeStruc.Project_ID__r.Cost_Parameter_Date_FY__c;

        } else {
            fiscalYear = '' +System.today().year();
        }
    }

    @AuraEnabled
    public static NCMT_TreeNode treeMe(Integer level, String parentKey, String fiscalYear, String searchVal, String fileType){
        System.debug(level +' ' +parentKey +' ' +fiscalYear +' ' +searchVal +' ' +true);
		parentKey=string.isNotBlank(parentKey) ? string.escapeSingleQuotes(parentKey):'';
        fiscalYear=string.isNotBlank(fiscalYear) ? string.escapeSingleQuotes(fiscalYear):'';
        searchVal=string.isNotBlank(searchVal) ? string.escapeSingleQuotes(searchVal):'';
        fileType=string.isNotBlank(fileType) ? string.escapeSingleQuotes(fileType):'';
        NCMT_TreeNode n = new NCMT_TreeNode(level, 'toplevel', parentKey, fiscalYear, fileType, searchVal, true);
        
        return n;
    }

}