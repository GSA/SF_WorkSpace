public with sharing class NCMT_TreeRelatedListCtrl_LC {

    @AuraEnabled public NCMT_Project__c proj {get;set;}
    public NCMT_TreeRelatedListCtrl_LC(ApexPages.StandardController controller) {
        proj = (NCMT_Project__c)controller.getRecord(); 
    }
    public class projectWrapper{     
        @AuraEnabled public List<NCMT_Tree_structure__c> treeStruc {get;set;}
        @AuraEnabled public NCMT_Project__c project {get; set;}
        @AuraEnabled public List<NCMT_Copy__c> treeCopy {get; set;}
        @AuraEnabled public List<NCMT_Copy__c> desCopy {get; set;}
        @AuraEnabled public List<NCMT_DES_Items__c> desItems {get; set;}
        @AuraEnabled public String projectId {get; set;}
    } 
    @AuraEnabled
    public static projectWrapper init(string recordId){
        projectWrapper wrapper = new projectWrapper();
        wrapper.project = getProjectData(recordId); 
        wrapper.treeStruc = getTreeData(recordId, false);
        wrapper.treeCopy = getTreeCopies();
        return wrapper;
    }
    @AuraEnabled
    public static NCMT_Project__c getProjectData(string projectId){
        NCMT_Project__c projectData = [SELECT id, Name, Markup_Method__c, Location_Multiplier__c FROM NCMT_Project__c WHERE id= :projectId];
        return projectData;
    }
    @AuraEnabled
    public static List <NCMT_Tree_structure__c> getTreeData(string projectId, boolean isPaste) {
		System.debug('getTreeData ' + isPaste);
        /*List<NCMT_Tree_structure__c> treeData = [SELECT id, Project_ID__c, Project_ID__r.name, Name, Total_Direct_Cost__c,RecordType.Name,
                                                description__c, branch_name__c, Include_In_Estimate__c, Level__c, Order__c, Relatedtree__r.name,
                                                Relatedtree__r.SortOrdertxt__c, Parent_Node_Desc__c, Total_Cost__c, SortOrdertxt__c, Quantity__c,
                                                UOM__c, ECCA__c, ECC__c, ETPC__c, Unit_Cost__c, Markup_Method__c
                                                FROM NCMT_Tree_structure__c 
                                                WHERE  Project_ID__c =:projectId
                                                //AND RecordType.Name =: 'Tree Branch'
                                                ORDER BY Order__c,SortOrdertxt__c];*/
        
        String soql = 'SELECT id, Project_ID__c, Project_ID__r.name, Name, Total_Direct_Cost__c,RecordType.Name,'+
                      'description__c, branch_name__c, Include_In_Estimate__c, Level__c, Order__c, Relatedtree__r.name,'+
                      'Relatedtree__r.SortOrdertxt__c, Parent_Node_Desc__c, Total_Cost__c, SortOrdertxt__c, Quantity__c,'+
                      'UOM__c, ECCA__c, ECC__c, ETPC__c, Unit_Cost__c FROM NCMT_Tree_structure__c WHERE  Project_ID__c =:projectId';
        
        if(isPaste){
            List<String> rtNames = new List<String>();
            rtNames.add('Default');
            rtNames.add('Tree Branch');
            soql += ' AND RecordType.Name IN: rtNames';
        }
        
        soql += ' ORDER BY Order__c,SortOrdertxt__c';
        System.debug(soql);
        
        List<NCMT_Tree_structure__c> treeData = Database.query(soql);
        //return tree structure data
        return treeData;
    }
    @AuraEnabled
    public static List<NCMT_Copy__c> getTreeCopies()
    {
        List<NCMT_Copy__c> copies = [SELECT Id, Tree_Structure__C, Tree_Structure__r.Markup_Method__c,
                                                    	   CreatedById, LastModifiedDate
                                             		FROM NCMT_Copy__c
                                             		WHERE CreatedById =: UserInfo.getUserId()
                                    				AND Tree_Structure__c != null];
        System.debug('Tree Structure Copies');
        System.debug(copies);
        
		return copies;
    }
    @AuraEnabled
    public static List<NCMT_Copy__c> copyTrees(List<NCMT_Tree_Structure__C> trees)
    {
        System.debug('copy trees! ' + trees.size());
        List<NCMT_Copy__c> copies = new List<NCMT_Copy__c>();
        
        for(NCMT_Tree_Structure__c t : trees)
        {
            System.debug(t);
            NCMT_Copy__c c = new NCMT_Copy__c();
            c.Tree_Structure__c = t.Id;
            copies.add(c);
        }
        
        System.debug(copies);
        insert copies;
        
        return copies;
    }
    
    @AuraEnabled
    public static void pasteTrees(List<NCMT_Copy__C> copies, Id parent, Id projId)
    {
        System.debug('Tree Structure Paste!');
        System.debug(copies);
        
        TriggerValue.isClone = true;
        
        List<Id> toPaste = new List<Id>();
        List<NCMT_Tree_Structure__C> trees = new List<NCMT_Tree_Structure__c>();
        List<NCMT_Tree_Structure__C> parents = new List<NCMT_Tree_Structure__c>();
        NCMT_Tree_Structure__C parentTree = [SELECT Id, Name, Relatedtree__c, Level__C, Order__c, SortOrdertxt__c, RecordTypeId, RecordType.Name FROM NCMT_Tree_Structure__C WHERE Id =: parent];
        String parentRecordType = parentTree.RecordType.Name;
        String parentRecordTypeId = parentTree.RecordTypeId;
        Decimal parentLevel = parentTree.Level__c;
        Decimal parentOrder = parentTree.Order__c;
        String parentSortOrder = parentTree.SortOrdertxt__c;
        Id tempParent = parent; //Set parent initally to parent selected on paste screen
        System.debug('tempParent === ' + tempParent);
        Decimal locationMultiplier;
        
        //Get all trees for paste destination project
        trees = [SELECT Id,Relatedtree__c,RecordTypeID, RecordType.Name, Branch_Name__c,
                        order__c, level__c,SortOrdertxt__c,Total_Cost_w_o_Subcon__c,
                        Total_Direct_Cost__c,Total_Cost__c, Project_ID__r.Location_Multiplier__c
                 FROM NCMT_Tree_Structure__C 
                 WHERE Project_Id__c =: projId 
                 order by Can_Have_Items__c desc,RecordTypeID desc, level__c desc];
        
        //Set location multiplier and create list of existing parent trees
        for(NCMT_Tree_Structure__C t : trees)
        {
            locationMultiplier = t.Project_ID__r.Location_Multiplier__c;
            System.debug(t);
            if(t.Id == tempParent)
            {
                parents.add(t);
                tempParent = t.Relatedtree__c;
                System.debug('NEW tempParent === ' + tempParent);
            }
        }
        
         System.debug('parents === ' + parents.size());
        
        map<string,string> masterRecordMap  = new map<string,string>();
        map<string,decimal> levelMap = new map<string,decimal>();
        
        //Create list of Ids of copied tree structures
        for(NCMT_Copy__c c : copies)
        {
            toPaste.add(c.Tree_Structure__c);
        }
        
        //Get full data for copied trees
        trees = [Select ID, Name, Branch_Name__c, description__c,Display_Name__c,Estimate_Format__c,
                     Include_In_Estimate__c,Level__c,Items__c,Project_ID__c,Order__c,Relatedtree__c,
                     Parent_Node_Desc__c,Quantity__c,SortOrdertxt__c,Parent_Name__c,Total_Including_Markups__c,
                     Relatedtree__r.SortOrdertxt__c, Relatedtree__r.Level__c,
                     Markup_Method__c,ECC__c,ECCA__c,ETPC__c,Markup__c,Total_OS_Work__c,Total_Self_Work__c,UOM__c,
                     Unit_Cost__c, RecordTypeID
                 FROM NCMT_Tree_Structure__c 
                 WHERE Id IN: toPaste
                 ORDER BY SortOrdertxt__c];
        System.debug('trees');
        NCMT_Project_Markup__c projMarkup = [SELECT Id from NCMT_Project_Markup__c WHERE Project_Name__c = : projId]; 
        
        //Create master map to retain relationships between copied trees
        for(NCMT_Tree_structure__c obj : trees){
            	System.debug(obj);
                masterRecordMap.put(obj.SortOrdertxt__c,obj.Relatedtree__r.SortOrdertxt__c);
        }
        System.debug('Master Record Map');
        System.debug(masterRecordMap);
        
        //Clone copied trees, set project to destination project, remove existing relationships, insert as new trees
        List<NCMT_Tree_structure__c> treeClones = trees.deepClone();
        //System.debug(treeClones);
        
        for(NCMT_Tree_structure__c obj : treeClones){
                obj.Markup__c = projMarkup.Id;
                obj.Project_ID__c = projId;
                obj.Relatedtree__c = Null;
            }
            insert treeClones;
        
        //System.debug(treeClones);
        
        //get related__c trees from orginal tree structures and find cloned versions with matching name, relate these to other tree structues based on original layout.  
            map<string, id> cloneNodeMap = new map<string, id>();
            for (NCMT_Tree_structure__c clone : treeClones){
                cloneNodeMap.put(clone.SortOrdertxt__c, clone.id);  
                levelMap.put(clone.SortOrdertxt__c, clone.Level__c);
            }
        System.debug('Clone Node Map');
        System.debug(cloneNodeMap);
        
        System.debug('Level Map');
        System.debug(levelMap);
        System.debug('tree clones');
        decimal maxorder = 0;
        for(AggregateResult ar : [SELECT max(Order__c) maxorder1, Count(id) totcount 
                                             FROM NCMT_Tree_structure__c 
                                            WHERE Relatedtree__c = : parent
                                             and Project_ID__c = : projId
                                             and Include_In_Estimate__c = true
                                  GROUP BY Project_ID__c]){
                                      maxorder = integer.valueof((ar.get('maxorder1')));}
        System.debug(maxorder);
        Map<Id,String> sortMap = new Map<Id,String>();
        for(NCMT_Tree_structure__c tree2 : treeClones){
            System.debug(tree2);
            		//if tree is not the top-level of the copied trees
                    if(cloneNodeMap.get(masterRecordMap.get(tree2.SortOrdertxt__c)) != null){
                        string nodeId= cloneNodeMap.get(masterRecordMap.get(tree2.SortOrdertxt__c));
                        //System.debug(tree2);
                        System.debug('parentLevel = ' + parentLevel + ' level = ' + (levelMap.get(tree2.Relatedtree__r.SortOrdertxt__c)+parentLevel));
                        tree2.Relatedtree__c = nodeId;
                        System.debug('parentLevel = ' + parentLevel + ' level = ' + (levelMap.get(tree2.Relatedtree__r.SortOrdertxt__c)+parentLevel));
                        System.debug('related tree =' + tree2.RelatedTree__c);
                        if(parentLevel != 0)
                        	tree2.Level__c = (levelMap.get(tree2.Relatedtree__r.SortOrdertxt__c)+(parentLevel/*+1*/));
                        else
                            tree2.Level__c = (levelMap.get(tree2.Relatedtree__r.SortOrdertxt__c)+1);
                        System.debug('parent sort order = ' + sortMap.get(tree2.Relatedtree__c));
                        tree2.SortOrdertxt__c = sortMap.get(nodeId) + tree2.Level__c + tree2.Order__c;
                        sortMap.put(tree2.Id, tree2.SortOrdertxt__c);
                    } 
                    else {
                        tree2.Relatedtree__c = parent;
                        tree2.Level__c = parentLevel+1;
                        levelMap.put(tree2.SortOrdertxt__c, tree2.Level__c); //update level map with new level values
                        System.debug('levelMap ' + levelMap);
                        if(maxorder == 0 && tree2.Level__c > 0){
                            tree2.Order__c = 10;
                            maxorder = tree2.Order__c;
                        }
                        else{
                           tree2.Order__c = maxorder + 1;
                            maxorder = tree2.Order__c;
                        }
                        System.debug('maxorder = ' + maxorder);
                        tree2.SortOrdertxt__c = parentSortOrder + tree2.Level__c + tree2.Order__c;
                        sortMap.put(tree2.Id, tree2.SortOrdertxt__c);
                    }
                //}
            } 
            List<Database.SaveResult> updateResults = Database.update(treeClones, false);
        
        	//for DES Items  
        	          
            list<NCMT_Project_Cost_Summary__c> pcs = [select id, Cost_Category_Code__c, Cost_Category_Description__c  from NCMT_Project_Cost_Summary__c where Project_Name__c= :projId];
            
            List<NCMT_DES_Items__c> DESItemsList = [Select ID, Name, RecordType.Name,Adj_Labor_Hours__c,Adj_Labor_Unit_Cost__c,Equipment_Assembly_Cost__c,Labor_Assembly_Cost__c,
                                                    Material_Assembly_Cost__c,Assembly_SKey__c,Comments__c,Cost_Summary__c,Cost_Type__c,CSI_Line_Item_Number__c,Daily_Output__c,
                                                    Default_Hourly_Rate__c,Default_Material_Unit_Cost__c,Description__c,DES_Lookup_Detail__c,Difficulty_Factor_Percent__c,
                                                    Direct_Cost__c,Equipment_Rental_Day__c,Hierarchy__c,Include_In_Estimate__c,Installation_Assembly_Cost__c,Item_Type__c,Labor_Burden_Tax__c,
                                                    Labor_Hours__c,Hourly_Rate__c,Level_2__c,Level_2_Description__c,Level_3__c,Level_3_Description__c,Level_4__c,Level_4_Description__c,Level_5__c,
                                                    Level_5_Description__c,Location_Multiplier_Washington_DC_1_00__c,Material_Adj__c,Material_Unit_Cost__c,NCMT_Assembly_Master__c,
                                                    NCMT_Crew_Master__c,NCMT_Project_ID__c,NCMT_Project_Name__c,NCMT_Contractor_ID__c,Project_Cost_Summary_ID__c,Project_Phasing__c,Quantity__c,
                                                    Sales_Tax__c,SubContractor_Bond__c,SubContractor_Overhead__c,SubContractor_Profit__c,Sub_Total__c,Tag__c,Total_Assembly_Cost__c,Total_Cost__c,
                                                    Total_Direct_Cost__c,Total_Equipment_Cost1__c,Total_Equip_Cost_Adj__c,Total_Equipment_Cost_w_Sales_Tax__c,Total_Labor_Cost_Adj__c,Total_Labor_Cost_w_Labor_Burden_Tax__c,
                                                    Total_Labor_Cost1__c,Total_Material_Cost_Adj__c,Total_Material_Cost_w_Sales_Tax__c,Total_Material_Cost1__c,Tree_structure__c,Unit__c,Waste_Factor__c,
                                                    Tree_structure__r.SortOrdertxt__c,Total_Cost_w_o_Subcon__c,In_house_Unit_Total__c,In_house_Unit_Total_f__c,In_house_Unit_Total_Adj__c,O_P_Unit_Total__c,O_P_Unit_Total_Adj__c,
                                                    Markup_Method__c,NCMT_Project_Location__c,Minimum_Cost__c,Total_In_House_Total_Adj_f__c,Labor_Burden_Impact_Rollup__c,Labor_Burden_Tax_f__c,MinID__c,Line_Item_Number__c,
                                                    Original_Minimum_Cost__c,Total_Labor_Cost__c,Labor_Cost__c, Labor_Unit_Hours__c
                                                    From NCMT_DES_Items__c 
                                                    where Tree_structure__c IN: toPaste
                                                    //Limit 25
                                                   ];
            System.debug('DES ITems: ' + DESITemsList.size());
            //list<ncmt_des_items__c> desItems = DESItemsList.deepClone();            
            
            //for(ncmt_des_items__c item : desItems){
            //    System.debug(item);
                /*item.Location_Multiplier_Washington_DC_1_00__c = dbllocationmultiplier;
                item.Sales_Tax__c = dblSalestax;  
                item.NCMT_Project_Location__c=strstate ;
                
                IF(strMarkupMethod == 'RSMeans - O&P' && item.Item_Type__c =='Master Format'){
                    item.RecordTypeID = strRTypeDESMOP;
                    if(item.markup_method__c !='User Defined'){
                        item.markup_method__c = 'RSMeans - O&P';
                    }
                }else if(strMarkupMethod == 'RSMeans - O&P' && item.Item_Type__c =='Assemblies'){
                    item.RecordTypeID = strRTypeDESUOP;
                    if(item.markup_method__c !='User Defined'){
                        item.markup_method__c = 'RSMeans - O&P';
                    }
                }*/
                
             /*   for(NCMT_Project_Cost_Summary__c pc :pcs ){
                    if (item.Cost_Summary__c == pc.Cost_Category_Description__c){
                        item.Project_Cost_Summary_ID__c = pc.id;
                    } 
                    if(item.Tree_structure__c != null){
                        id treeId = cloneNodeMap.get(item.Tree_structure__r.SortOrdertxt__c);
                        item.Tree_structure__c = treeId;
                    } 
                }
                System.debug(item);
            }
        	//System.debug(desItems);
            List<Database.SaveResult> insertResults = Database.insert(desItems, false); */
        for(NCMT_DES_Items__c d : DESItemsList)
        {
            d.Location_Multiplier_Washington_DC_1_00__c = locationMultiplier;
        }
        cloneDESItems(DESItemsList, projId, null, cloneNodeMap);
        
        map<string,decimal> totalcostMap = new map<string,decimal>();
        map<string,decimal> totaldirectcostMap = new map<string,decimal>();
        map<string,decimal> totalcostwosubMap = new map<string,decimal>();
        
        list<NCMT_Tree_structure__c>  NCMTList = new List<NCMT_Tree_structure__c>(); 
        Decimal totalCost_copy = 0, totalDirectCost_copy = 0, totalCostWOSub_copy = 0;
        
        //for updating parent tree cost
        list<NCMT_Tree_structure__c> TreeStrucParentList = [SELECT Id,Relatedtree__c,RecordTypeID, RecordType.Name, Branch_Name__c,
                                                            order__c, level__c,SortOrdertxt__c,Total_Cost_w_o_Subcon__c,
                                                            Total_Direct_Cost__c,Total_Cost__c
                                                            FROM NCMT_Tree_structure__c 
                                                            WHERE Id IN: treeClones
                                                            OR Id IN: parents
                                                            order by Can_Have_Items__c desc,RecordTypeID desc, level__c desc];
        System.debug('Update Parent Tree');
        System.debug(TreeStrucParentList);
        
        for(NCMT_Tree_structure__c Treelist:TreeStrucParentList){
            System.debug(Treelist);
            totalcostMap.put(Treelist.Id,Treelist.Total_Cost__c); 
            totaldirectcostMap.put(Treelist.Id,Treelist.Total_Direct_Cost__c);  
            totalcostwosubMap.put(Treelist.Id,Treelist.Total_Cost_w_o_Subcon__c); 
            if(!parents.contains(Treelist))
            {
                totalCost_copy += Treelist.Total_Cost__c;
                totalDirectCost_copy += Treelist.Total_Direct_Cost__c;
                totalCostWOSub_copy += Treelist.Total_Cost_w_o_Subcon__c;
            }
        }
        System.debug('Total Cost Map');
        System.debug(totalcostMap);
        for(NCMT_Tree_structure__c Treelist:TreeStrucParentList){
            System.debug(Treelist);
            System.debug(parents.contains(Treelist));
            System.debug(Treelist.Relatedtree__c);
            System.debug(totalcostMap.get(Treelist.Relatedtree__c));
            if (totalcostMap.get(Treelist.Relatedtree__c) !=null){
                if(!parents.contains(Treelist)){
                    totalcostMap.put(Treelist.Relatedtree__c,totalcostMap.get(Treelist.Relatedtree__c) + totalcostMap.get(Treelist.Id));
                    totaldirectcostMap.put(Treelist.Relatedtree__c,totaldirectcostMap.get(Treelist.Relatedtree__c) + totaldirectcostMap.get(Treelist.Id));
                    totalcostwosubMap.put(Treelist.Relatedtree__c,totalcostwosubMap.get(Treelist.Relatedtree__c) + totalcostwosubMap.get(Treelist.Id));
                }
                else {
                    totalcostMap.put(Treelist.Relatedtree__c,totalcostMap.get(Treelist.Relatedtree__c) + totalCost_copy);
                    totaldirectcostMap.put(Treelist.Relatedtree__c,totaldirectcostMap.get(Treelist.Relatedtree__c) + totalDirectCost_copy);
                    totalcostwosubMap.put(Treelist.Relatedtree__c,totalcostwosubMap.get(Treelist.Relatedtree__c) +totalCostWOSub_copy);
                }
            }
            
        }
        System.debug('Total Cost Map 2');
        System.debug(totalcostMap);
        for( NCMT_Tree_structure__c TreeStrucParent : TreeStrucParentList){
            System.debug(TreeStrucParent);
            TreeStrucParent.Total_Cost__c = totalcostMap.get(TreeStrucParent.Id);
            TreeStrucParent.Total_Direct_Cost__c = totaldirectcostMap.get(TreeStrucParent.Id);
            TreeStrucParent.Total_Cost_w_o_Subcon__c = totalcostwosubMap.get(TreeStrucParent.Id);
            
            //For updating parent Record Type from Default to Tree Branch
            if(TreeStrucParent.Id == parent && TreeStrucParent.RecordType.Name == 'Default')
            {
            	TreeStrucParent.RecordTypeId = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Tree Branch').getRecordTypeId();
            }
            
            NCMTList.add(TreeStrucParent);
        }
        System.debug('Total Cost Map 3');
        System.debug(totalcostMap);
        
        System.debug(NCMTList.size());
        Update NCMTList;  
        
        //TriggerValue.isClone = false;
        
        Delete copies;
    }
    
    @AuraEnabled
    public static void deleteCopies(List<NCMT_Copy__c> copies)
    {
        if(copies != null)
        	delete copies;
        /*if(desCopies != null)
            delete desCopies;*/
    }
    
    @AuraEnabled
    public static projectWrapper getDESItemData(String treeId)
    {
        projectWrapper wrapper = new projectWrapper();
        wrapper.desItems = [SELECT Id, Name, CSI_Line_Item_Number__c, Item_Type__c, Cost_Summary__c,
                                                   Description__c, Quantity__c, Unit__c, NCMT_Contractor_ID__r.Name,
                                           		   Total_Direct_Cost__c, Total_Cost__c, NCMT_Project_Id__C, Tree_Structure__C,
                            						Markup_Method__c
                                            FROM NCMT_DES_Items__c
                                            WHERE Tree_Structure__c =: treeId
                           					ORDER BY CSI_Line_Item_Number__c];
        
        List<NCMT_Tree_Structure__c> tree = [SELECT Id, Project_Id__C, Markup_Method__c, Project_Id__r.Location_Multiplier__c FROM NCMT_Tree_Structure__c WHERE Id =: treeId];
        wrapper.projectId = tree[0].Project_ID__c;
        wrapper.treeStruc = tree;
        
        List<NCMT_Copy__c> copies = [SELECT Id, DES_Item__c, DES_Item__r.Markup_Method__c, 
                                     CreatedById, LastModifiedDate
                                     FROM NCMT_Copy__c
                                     WHERE CreatedById =: UserInfo.getUserId()
                                     AND DES_Item__C != null];
        wrapper.desCopy = copies;
        
        return wrapper;
    }
    
    @AuraEnabled
    public static List<NCMT_Copy__c> copyDESItems(List<NCMT_DES_Items__c> items)
    {
        System.debug('copy DES items! ' + items.size());
        List<NCMT_Copy__c> copies = new List<NCMT_Copy__c>();
        
        for(NCMT_DES_Items__c i : items)
        {
            System.debug(i);
            NCMT_Copy__c c = new NCMT_Copy__c();
            c.DES_Item__c = i.Id;
            copies.add(c);
        }
        
        //System.debug(copies);
        insert copies;
        
        return copies;
    }
    
    @AuraEnabled
    public static void pasteDESItems(List<NCMT_Copy__c> copies, String treeId, String projId, Decimal locationMultiplier)
    {
        System.debug('DES Item Paste! ' + copies.size());
        System.debug(locationMultiplier);
        
        List<Id> toPaste = new List<Id>();
        
        for(NCMT_Copy__c c : copies)
        {
			toPaste.add(c.DES_Item__c);
        }
        
        List<NCMT_DES_Items__c> desItems = [Select ID, Name, RecordType.Name,Adj_Labor_Hours__c,Adj_Labor_Unit_Cost__c,Equipment_Assembly_Cost__c,Labor_Assembly_Cost__c,
                                                    Material_Assembly_Cost__c,Assembly_SKey__c,Comments__c,Cost_Summary__c,Cost_Type__c,CSI_Line_Item_Number__c,Daily_Output__c,
                                                    Default_Hourly_Rate__c,Default_Material_Unit_Cost__c,Description__c,DES_Lookup_Detail__c,Difficulty_Factor_Percent__c,
                                                    Direct_Cost__c,Equipment_Rental_Day__c,Hierarchy__c,Include_In_Estimate__c,Installation_Assembly_Cost__c,Item_Type__c,Labor_Burden_Tax__c,
                                                    Labor_Hours__c,Hourly_Rate__c,Level_2__c,Level_2_Description__c,Level_3__c,Level_3_Description__c,Level_4__c,Level_4_Description__c,Level_5__c,
                                                    Level_5_Description__c,Location_Multiplier_Washington_DC_1_00__c,Material_Adj__c,Material_Unit_Cost__c,NCMT_Assembly_Master__c,
                                                    NCMT_Crew_Master__c,NCMT_Project_ID__c,NCMT_Project_Name__c,NCMT_Contractor_ID__c,Project_Cost_Summary_ID__c,Project_Phasing__c,Quantity__c,
                                                    Sales_Tax__c,SubContractor_Bond__c,SubContractor_Overhead__c,SubContractor_Profit__c,Sub_Total__c,Tag__c,Total_Assembly_Cost__c,Total_Cost__c,
                                                    Total_Direct_Cost__c,Total_Equipment_Cost1__c,Total_Equip_Cost_Adj__c,Total_Equipment_Cost_w_Sales_Tax__c,Total_Labor_Cost_Adj__c,Total_Labor_Cost_w_Labor_Burden_Tax__c,
                                                    Total_Labor_Cost1__c,Total_Material_Cost_Adj__c,Total_Material_Cost_w_Sales_Tax__c,Total_Material_Cost1__c,Tree_structure__c,Unit__c,Waste_Factor__c,
                                                    Tree_structure__r.SortOrdertxt__c,Total_Cost_w_o_Subcon__c,In_house_Unit_Total__c,In_house_Unit_Total_f__c,In_house_Unit_Total_Adj__c,O_P_Unit_Total__c,O_P_Unit_Total_Adj__c,
                                                    Markup_Method__c,NCMT_Project_Location__c,Minimum_Cost__c,Total_In_House_Total_Adj_f__c,Labor_Burden_Impact_Rollup__c,Labor_Burden_Tax_f__c,MinID__c,Line_Item_Number__c,
                                                    Original_Minimum_Cost__c,Total_Labor_Cost__c,Labor_Cost__c,Labor_Unit_Hours__c
            								FROM NCMT_DES_Items__c
                                            WHERE Id IN: toPaste];
        for(NCMT_DES_Items__c d : desItems)
        {
            d.Location_Multiplier_Washington_DC_1_00__c = locationMultiplier;
        }
        cloneDESItems(desItems, projId, treeId, null);
        
        delete copies;
    }
    
    @AuraEnabled
    public static void deleteDESItems(List<NCMT_DES_Items__c> toDelete) 
    {
        System.debug('toDelete: ' + toDelete);
        
        delete toDelete;
    }
    
    @AuraEnabled
    public static void deleteTrees(List<Id> toDelete)
    {
        System.debug('toDelete: ' + toDelete);
        
        List<NCMT_Tree_Structure__c> toDelete2 = [SELECT Id, Branch_Name__c, RecordType.Name
                                                  FROM NCMT_Tree_Structure__c
                                                  WHERE Id IN: toDelete
                                                  OR Relatedtree__c IN: toDelete
                                                  order by Can_Have_Items__c desc,RecordTypeID desc, level__c desc];
        System.debug('deleting ' + toDelete2.size() + ' Tree Structures');
        for(NCMT_Tree_Structure__C t : toDelete2)
        {
            System.debug(t);
        }
        
        List<NCMT_DES_Items__c> itemsToDelete = [SELECT Id 
                                                 FROM NCMT_DES_Items__c
                                                 WHERE Tree_Structure__c IN: toDelete];
        System.debug('deleting ' + itemsToDelete.size() + ' DES Items');
        delete itemsToDelete;
        delete toDelete2;
    }
    
    private static void cloneDESItems(List<NCMT_DES_Items__c> toClone, String projId, String treeId, Map<String, Id> cloneNodeMap)
    {
        //for DES Items            
        list<NCMT_Project_Cost_Summary__c> pcs = [select id, Cost_Category_Code__c, Cost_Category_Description__c  from NCMT_Project_Cost_Summary__c where Project_Name__c= :projId];
        
        System.debug('DES Items To Clone: ' + toClone.size());
        list<ncmt_des_items__c> desItems = toClone.deepClone();            
        
        for(ncmt_des_items__c item : desItems){
            //System.debug(item);
                /*item.Location_Multiplier_Washington_DC_1_00__c = dbllocationmultiplier;
                    item.Sales_Tax__c = dblSalestax;  
                    item.NCMT_Project_Location__c=strstate ;
                    
                    IF(strMarkupMethod == 'RSMeans - O&P' && item.Item_Type__c =='Master Format'){
                    item.RecordTypeID = strRTypeDESMOP;
                    if(item.markup_method__c !='User Defined'){
                    item.markup_method__c = 'RSMeans - O&P';
                    }
                    }else if(strMarkupMethod == 'RSMeans - O&P' && item.Item_Type__c =='Assemblies'){
                    item.RecordTypeID = strRTypeDESUOP;
                    if(item.markup_method__c !='User Defined'){
                    item.markup_method__c = 'RSMeans - O&P';
                    }
    			}*/
            
            for(NCMT_Project_Cost_Summary__c pc :pcs ){
                if (item.Cost_Summary__c == pc.Cost_Category_Description__c){
                    item.Project_Cost_Summary_ID__c = pc.id;
                } 
                if(cloneNodeMap != null) { //Tree Structure copy/paste
                    if(item.Tree_structure__c != null){
                        id tId = cloneNodeMap.get(item.Tree_structure__r.SortOrdertxt__c);
                        item.Tree_structure__c = tId;
                    } 
                }
                else //DES Item copy/paste
                    item.Tree_structure__c = treeId;
            }
            System.debug(item.CSI_Line_Item_Number__c);
            System.debug(item.Location_Multiplier_Washington_DC_1_00__c);
        }
        //System.debug(desItems);
        //TriggerValue.isClone = true;
        TriggerValue.isPaste = true;
        List<Database.SaveResult> insertResults = Database.insert(desItems, false); 
    }
    
    /*private static void recalculateTree() 
    {
        
    }*/
    
     // Below method added for SFWS-1775
     @AuraEnabled
    public static List<NCMT_DES_Items__c> updateDesLineItems(List<NCMT_DES_Items__c> desItemsList){
        
       system.debug('Updated List'+desItemsList);
       update desItemsList;
         system.debug('Updated List After'+desItemsList);
       return desItemsList;
         
    }
}