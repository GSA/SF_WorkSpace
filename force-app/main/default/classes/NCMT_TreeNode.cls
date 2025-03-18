public with sharing class NCMT_TreeNode {
    //@AuraEnabled public NCMT_TreeNode parent {get;set;}
    @AuraEnabled public String treeType {get;set;} 
    @AuraEnabled public String objectName {get;set;}
    @AuraEnabled public List<NCMT_TreeNode> branches {get;set;}
    //@AuraEnabled public List<NCMT_TreeLeaf> leaves {get;set;}
    @AuraEnabled public String parentKey {get;set;}
    @AuraEnabled public String uniqueKey {get;set;}
    @AuraEnabled public String label {get;set;}
    @AuraEnabled public String name {get;set;}
    @AuraEnabled public String searchVal {get;set;}
    @AuraEnabled public String fiscalYear {get;set;}
    
    //@AuraEnabled public Boolean disabled {get;set;} //TODO: Needed?
    @AuraEnabled public Integer level {get;set;}
    @AuraEnabled public Boolean hasItems {get;set;}
    //Throw back for the old component, this too shall go
    @AuraEnabled public SObject lookupRecord {get;set;}
    @AuraEnabled public String title {get;set;}
    @AuraEnabled public String estFormat {get;set;}
    @AuraEnabled public String loadError {get;set;}

    @AuraEnabled public Boolean searchFound {get;set;}
    @AuraEnabled public Boolean branchesExpanded {get;set;}
    @AuraEnabled public Boolean hasChildBranches {get;set;}
    //@AuraEnabled public Boolean branchBearing {get;set;}
    //@AuraEnabled public Boolean leafBearing {get;set;}

    public NCMT_TreeNode(){}

    public NCMT_TreeNode(Integer l, String u, String p, String f, String tt, String s, Boolean doInit) {
        //leaves = new List<NCMT_TreeLeaf>();
        branches = new List<NCMT_TreeNode>();
        parentKey = p;
        uniqueKey = u;
        level = l;
        treeType = tt;
        searchVal = (s != null ? String.escapeSingleQuotes(s) : null);
        searchFound = (s == null || s == '');
        branchesExpanded = false;
        fiscalYear = f;
        System.debug('tree node construct, doInit === ' +doInit);
        //Only called when branches are loaded from the page so the tree can be built branch by branch
        if (doInit) initBranch();

        if (l == 1){

        }
    }
    
    public void initBranch(){
        if (treeType == 'RSM FCC'
        ){ //All others are assemblies
            objectName = 'NCMT_DES_Lookup_details__c';  
        } else {
            objectName = 'NCMT_Assembly_Lookup_Detail__c';
            //estFormat = 'GSA Assemblies';
        }

        assembliesBranch();
    }
    /*Consider for later....
    public class NCMT_TreeLeaf{
        @AuraEnabled public Id parentKey {get;set;}
        //@AuraEnabled SObject obj {get;set;}

        public NCMT_TreeLeaf(){

        }

    }*/

    public void assembliesBranch(){
        try{
            Integer dataLevel = level+1; //Express branch starts on level two
            Set<Id> costCatIds = new Set<Id>();
            Set<Id> lookupDetailIds = new Set<Id>();

            String codeField = 'Level_' +dataLevel +(dataLevel > 2 &&objectName == 'NCMT_DES_Lookup_details__c' ? '_Line_Item' : '') +'__c';
            String descField = 'Level_' +dataLevel +'_Description__c';
            String parentCodeField = 'Level_' +(dataLevel - 1) +(objectName == 'NCMT_DES_Lookup_details__c' ? '_Line_Item' : '') +'__c';
            if(treeType == 'RSM FCC') //Use description field as parent code if DES tree
                parentCodeField = 'Level_' +(dataLevel - 1) +(objectName == 'NCMT_DES_Lookup_details__c' ? '_Description' : '') +'__c';
            //if (dataLevel == 3) parentCodeField = 'Level_2__c';
           
            String nextCodeField = 'Level_' +(dataLevel + 1) +(objectName == 'NCMT_DES_Lookup_details__c' ? '_Line_Item' : '') +'__c';
             System.debug('nextCodeField ' +nextCodeField);
            
            //BUILD SOQL WHERE STATEMENT
            
        
            String catSoQL = 'Select Id, Name, Category_Description__c, Estimate_Format__c from NCMT_Cost_Category__c WHERE ';
            if (treeType == 'RSM FCC') catSoQL += '(Estimate_Format__c = \'Master Format\' AND RSM_FCC_Items__c > 0)';
            if (treeType == 'GSA_ 2020 FAC_ASMDES.xlsx') catSoQL += '(Estimate_Format__c = \'Uniformat\' AND FCC_Assembly_Items__c > 0)';
            if (treeType == 'GSA_ 2020 ASMDESC.xlsx') catSoQL += '((Estimate_Format__c = \'Uniformat\' OR Estimate_Format__c = \'Assemblies\') AND RSM_Assemblies_Cost_Items__c > 0)';
            if (treeType == 'GSA_ 2020 MR Assembly Data.xlsx') catSoQL += '((Estimate_Format__c = \'Uniformat\' OR Estimate_Format__c = \'Assemblies\') AND RSM_FMRD_Maintenence_and_Repair_Items__c > 0)';
            if (treeType == 'GSA_ 2020 PM_SEQ.xlsx') catSoQL += '(Estimate_Format__c = \'Uniformat\' AND RSM_Preventative_Maintenence_Items__c > 0)';
            if (treeType == 'GSAAssemblies') catSoQL += '(Estimate_Format__c = \'GSA Assemblies\' AND GSA_Express_Menu_Items__c > 0)';

            catSoQL += ' ORDER By Name, Category_Description__c';
            System.debug('catSoQL =========================== ' +catSoQL);
            Set<Id> catIds = new Set<Id>();
            //-----------Testing FY filter!!!
            List<NCMT_Cost_Category__c> cats = Database.query(catSoQL);
            List<NCMT_Assembly_Lookup_detail__c> fyAss = new List<NCMT_Assembly_Lookup_detail__c>();
            List<Id> fyCatIds = new List<Id>();
            if(treeType == 'GSA_ 2020 FAC_ASMDES.xlsx'){
                fyAss = [SELECT Id, Name, Level_2__c 
                         FROM NCMT_Assembly_Lookup_detail__c 
                         WHERE Level_2__c IN: cats 
                         AND Fiscal_Year__c =: fiscalYear
                         AND File_Type__c =: 'GSA_ 2020 FAC_ASMDES.xlsx'];
                
                for(NCMT_Assembly_Lookup_detail__c a : fyAss)
                {
                    fyCatIds.add(a.Level_2__c);
                }
            }
            //-------------End test
            for (NCMT_Cost_Category__c cc : Database.query(catSoQL)){
                //Level 1 created with cost categories instead of looping through all records
                system.debug('level>>>>>'+level + 'searchVal>>>'+ searchVal);
                if (level == 1 &&(searchVal == null || searchVal == '')){
                    String nodeName = cc.Category_Description__c;
                    String nodeLabel = cc.Name +' - ' +nodeName;
                    
                    String newParent = cc.Id;
                    if(treeType == 'RSM FCC') //Use description field as parent if DES tree
                        newParent = cc.Category_Description__c;
                    NCMT_TreeNode n = new NCMT_TreeNode(level, cc.Id, newParent, fiscalYear, treeType, searchVal, false);
                    n.name = nodeName;
                    //n.lookupRecord = ass;
                    n.label = nodeLabel;
                    n.hasItems = false;
                    n.hasChildBranches = true;
                    n.estFormat = cc.Estimate_Format__c;
                    //System.debug('COST CAT IN FY?: ' + fyCatIds.contains(cc.Id));
                    if(treeType != 'GSA_ 2020 FAC_ASMDES.xlsx')
                        branches.add(n);
                    else{
                        if(fyCatIds.contains(cc.Id))
                            branches.add(n);
                    }
                }
                else {
                    //For other levels, collect the Cost Category Ids to filter/speed up the query
                    catIds.add(cc.Id);
                }
                
            }

            String masterLookupWhere =  ' Level_2__c IN: catIds AND Fiscal_Year__c =: fiscalYear ';
           
            string[] excludedFiles = new string[]{'%GSA 2020 FMR_PM_ASSMUP.xlsx%', '%GSA_ 2020 M&R Unit Price Data.xls%'/*, '%GSA_2020 FACL2020 DAT.xlsx'*/};
            Integer highestLevel = (objectName == 'NCMT_Assembly_Lookup_Detail__c' ? 6 : 5);

            if (objectName == 'NCMT_DES_Lookup_details__c'){
                if (level > 1) //This was already filtered for subsequent levels, Not slows query performance
                masterLookupWhere += 'AND (NOT File_Name__c LIKE :excludedFiles)';
            } else {
                masterLookupWhere += ' AND File_Type__c = \'' +treeType +'\'';
            }

            //SEARCH
            if (searchVal != null &&searchVal != ''){
                searchVal = '%' +searchVal +'%';
                String sosl = 'FIND :searchVal IN ALL FIELDS ' +
                                'RETURNING ';
                if (objectName == 'NCMT_Assembly_Lookup_Detail__c'){
                    sosl += 'NCMT_Assembly_Lookup_Detail__c (Id, Level_2__c, Level_2__r.Estimate_Format__c ' +
                                    'WHERE ' +masterLookupWhere  +'), ' + 
                                'NCMT_Assembly_Lookup_Item__c (Id, Assembly_Lookup_Detail__c, Assembly_Lookup_Detail__r.Level_2__c ' +
                                    'WHERE Assembly_Lookup_Detail__r.File_Type__c = \'' +treeType +'\' AND Assembly_Lookup_Detail__r.Fiscal_Year__c =: fiscalYear)';
                } else {
                    sosl += 'NCMT_DES_Lookup_details__c (Id, Level_2__c, Level_2__r.Estimate_Format__c ' +
                                    'WHERE ' +masterLookupWhere  +')';
                }
                //if (dataLevel == 2)
                //    sosl += ', NCMT_Cost_Category__c (Id WHERE Estimate_Format__c = \'GSA Assemblies\')';
                 system.debug('sosl>>>'+ sosl);
                List<List<SObject>> searchList = search.query(sosl);

                System.debug('objectName ===== ' +objectName + ' searchVal ======= ' +searchVal +' catIds ' +catIds);
                if (objectName == 'NCMT_Assembly_Lookup_Detail__c'){
                    String searchSoQL = 'Select Id, Level_2__c from NCMT_Assembly_Lookup_Detail__c ' +
                            ' where ' +masterLookupWhere +
                            ' AND (Name LIKE :searchVal OR Description__c LIKE :searchVal OR Level_1_Description__c LIKE :searchVal ' +
                            ' OR Level_2_Description__c LIKE :searchVal OR Level_3_Description__c LIKE :searchVal ' +
                            ' OR Level_4_Description__c LIKE :searchVal OR Level_5_Description__c LIKE :searchVal OR Assembly_Number__c like :searchVal)' ;
                    //for (NCMT_Assembly_Lookup_Detail__c l : (NCMT_Assembly_Lookup_Detail__c[])searchList[0]){
                    for (NCMT_Assembly_Lookup_Detail__c l : Database.query(searchSoQL)){
                        lookupDetailIds.add(l.Id);
                        costCatIds.add(l.Level_2__c);
                    }
                    
                    searchSoQL = 'Select Id, Assembly_Lookup_Detail__c, Assembly_Lookup_Detail__r.Level_2__c from NCMT_Assembly_Lookup_Item__c ' +
                            ' where Assembly_Lookup_Detail__r.File_Type__c = \'' +treeType +'\' AND Assembly_Lookup_Detail__r.Fiscal_Year__c =: fiscalYear' +
                            ' AND (Name LIKE :searchVal OR Master_Format_Line_Item_Number__c LIKE :searchVal OR MF_Line_Item_Description__c LIKE :searchVal )';
                    //for (NCMT_Assembly_Lookup_Item__c l : (NCMT_Assembly_Lookup_Item__c[])searchList[1]){
                    for (NCMT_Assembly_Lookup_Item__c l : Database.query(searchSoQL)){
                        lookupDetailIds.add(l.Assembly_Lookup_Detail__c);
                        costCatIds.add(l.Assembly_Lookup_Detail__r.Level_2__c);
                    }
                } else {
                    String searchSoQL = 'Select Id, Level_2__c from NCMT_DES_Lookup_details__c WHERE ' +masterLookupWhere +
                            ' AND (Name like :searchVal OR Description__c like :searchVal OR Line_Item_Number__c like :searchVal ' +
                            ' OR Level_2_Description__c LIKE :searchVal OR Level_3_Description__c LIKE :searchVal ' +
                            ' OR Level_4_Description__c LIKE :searchVal OR Level_5_Description__c LIKE :searchVal)';
                     
                    //for (NCMT_DES_Lookup_details__c l : (NCMT_DES_Lookup_details__c[])searchList[0]){
                    for (NCMT_DES_Lookup_details__c l : Database.query(searchSoQL)){
                        lookupDetailIds.add(l.Id);
                        costCatIds.add(l.Level_2__c);
                    }
                }

                if (costCatIds.size() > 0 && level > 2)
                    masterLookupWhere += ' AND Level_2__c IN: costCatIds';

                //No results? Get out of here
                if (lookupDetailIds.size() > 0){
                    masterLookupWhere += ' AND Id IN: lookupDetailIds';
                } else {
                    searchFound = false;
                    return;
                }
            
            }//end if searchVal

            

            //2nd level (labeled 3 in the fields) and downward
            //Also for seach
            if (level > 1 || (searchVal != null &&searchVal != '')){
                //This shouldn't be part of the search...
                if (dataLevel > 2){
                    masterLookupWhere += ' AND ' +parentCodeField +' =: parentKey';
                    //masterLookupWhere += ' AND ' +codeField +' <> null';
                }
                
                String soql = 'SELECT Id, Name, ' +
                        ' Level_2_Description__c, Level_3_Description__c, ' +
                        'Level_4_Description__c, Level_5_Description__c, ' +
                        'Level_2__c, Level_2__r.Estimate_Format__c, Level_2__r.Name';

                //DES doesn't go up to 6
                if (objectName == 'NCMT_Assembly_Lookup_Detail__c'){
                    soql += ', GSAAssemblies_Lookup_Items__c, Level_6__c, Level_6_Description__c';
                    soql += ', Level_3__c, Level_4__c, Level_5__c ';
                } else {
                    //soql += ', GSAAssemblies_Lookup_Items__c'; //NEED
                    soql += ', Level_3_Line_Item__c, Level_4_Line_Item__c, Level_5_Line_Item__c ';
                }

                soql += ' FROM ' +objectName +
                        ' WHERE ' +masterLookupWhere;

                if (objectName == 'NCMT_Assembly_Lookup_Detail__c'){
                    soql += ' ORDER BY Level_2__r.Name Nulls First, Level_3__c Nulls First, Level_4__c Nulls First, Level_5__c Nulls First, Level_6__c Nulls First';
                } else {
                    soql += ' ORDER BY Level_2__r.Name Nulls First, Level_3_Line_Item__c Nulls First, Level_4_Line_Item__c Nulls First, Level_5_Line_Item__c Nulls First';
                }
            
                System.debug('parentKey ==== ' +parentKey);
                System.debug('soql ==== ' +soql);
                
                Map<String, Boolean> nodesUsed = new Map<String, Boolean>();
                Map<String, String> desNodes = new Map<String, String>();
                List<SObject> asses = Database.query(soql);
                System.debug('size ==== ' + asses.size());
                
                for (SObject ass : asses) {
                    //System.debug('ASS ==== ' + ass);
                    String nodeName = String.valueOf(ass.get(codeField));
                    String nodeLabel = nodeName +' - ' +String.valueOf(ass.get(descField));
                    String nodeDesc = String.valueOf(ass.get(descField)).toLowerCase();
                    System.debug('jmd level ==== ' + level);
                    System.debug('jmd nodeName ==== ' + nodeName);
                    System.debug('jmd nodesUsed ==== ' + nodesUsed);
                     System.debug('jmd !nodesUsed.keySet().contains(nodeName) ==== ' + !nodesUsed.keySet().contains(nodeName));
                    if (level == 1){
                        nodeName = String.valueOf(ass.get('Level_2_Description__c'));
                        nodeLabel = String.valueOf(ass.getSObject('Level_2__r').get('Name')) +' - ' +nodeName;
                    }
                    
                    //Make sure this level of the tree hasn't been added already 
                    //TODO: Create actual tree db model
                    if (nodeName != null && nodeName != '-' && !nodesUsed.keySet().contains(nodeName)) {
                        System.debug('ass === ' +ass);
                        String newParent = String.valueOf(ass.get(codeField));
                         system.debug('jmd treeType === ' +treeType);
                        if(treeType == 'RSM FCC') //Use description as parent if DES tree
                            newParent = nodeDesc;
                        System.debug('new parent === ' + newParent);
                        if (treeType == 'RSM FCC' && desNodes.get(nodeDesc) != null) {
                            System.debug('duplicate found!');
                        }
                        
                        //if (level == 1) newParent = String.valueOf(ass.get('Level_2__c'));
                        NCMT_TreeNode n = new NCMT_TreeNode(level, ass.Id, newParent, fiscalYear, treeType, searchVal, false);
                        n.name = nodeName;
                        n.lookupRecord = ass;
                        n.label = nodeLabel;
                        n.estFormat = String.valueOf(ass.getSObject('Level_2__r').get('Estimate_Format__c'));
                       if (objectName == 'NCMT_Assembly_Lookup_Detail__c') {
                         n.hasItems = (Integer.valueOf(ass.get('GSAAssemblies_Lookup_Items__c')) > 0
                                            && (dataLevel == highestLevel || ass.get(nextCodeField) == null)
                            );
                            
                        } else {
                            //TODO DES SET HASITEMS (I don't know how to do that yet)
                      
                            n.hasItems = (dataLevel == highestLevel);
                        }
                        //n.hasItems = true;
                        
                        if(treeType == 'RSM FCC' && desNodes.get(nodeDesc) != null) {
                           System.debug('duplicate! ' + newParent + ' ' + nodeName + ' ' + nodeLabel);
                           //System.debug('current branches === ' + branches.size());
                           //Add to previous branch
                           //System.debug(branches[branches.size() -1]);
                        }
                        //Only add if not a duplicate
                        else
                            branches.add(n);
                    }
                    
                    //For now we are artificially capped at 6 levels due to database design
                    
                    String nextLabel = (dataLevel < highestLevel ? String.valueOf(ass.get(nextCodeField)) : null);
                    //System.debug('nextLabel === ' + nextLabel);
                    if (nodesUsed.get(nodeName) == null || nodesUsed.get(nodeName) == false) {
                        nodesUsed.put(nodeName, (nextLabel != null));
                        
                        //Add des categories to map to use for dupe check
                        System.debug('des check === ' + desNodes);
                        if(treeType == 'RSM FCC' && desNodes.get(nodeDesc) == null){
                            desNodes.put(nodeDesc, nodeName);
                            System.debug('added to desNodes ' + nodeDesc + ' - ' + nodeName);
                        }
                    }
                }
                 system.debug('jmd branches '+branches);
                for (NCMT_TreeNode b : branches) {
                    system.debug('jmd branch '+nodesUsed.get(b.name));
                    b.hasChildBranches = nodesUsed.get(b.name);
                }
            } 
            //for (NCMT_TreeNode b : branches){
                if (level == 1) {
                    switch on treeType {
                        when 'RSM FCC'{
                            title = 'RSM FCC';
                        }
                        when 'GSA_ 2020 FAC_ASMDES.xlsx'{//
                            title = 'RSM FCC Assembly Data';
                        }
                        when 'GSA_ 2020 ASMDESC.xlsx'{//
                            title = 'RSM Assemblies Cost Data';
                        }
                        when 'GSA_ 2020 MR Assembly Data.xlsx'{//
                            title = 'RSM FMRD Maintenence and Repair Data';
                        }
                        when 'GSA_ 2020 PM_SEQ.xlsx'{//
                            title = 'RSM Preventative Maintenence Data';
                        }
                        when 'GSAAssemblies'{
                            title = 'GSA Express Menu Items';
                        }
                    }
                }
            //}
            
        } Catch (Exception e){
            NCMT_TreeNode n = new NCMT_TreeNode();
            n.name = 'Error';
            n.loadError = 'Error querying assemblies: ' +e.getMessage() +'\n ' +e.getStackTraceString();
        }
        


        
    }//end expressBranch

}