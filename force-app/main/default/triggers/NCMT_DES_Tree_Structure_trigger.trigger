trigger NCMT_DES_Tree_Structure_trigger on NCMT_Tree_structure__c (before insert, before update, after insert, after update, before delete, after delete) {

    set<id> TCSIds = new set<id>();
    set<id> NCMTIDs = new set<id>();
    ID TreeStrucRecordid;
    ID parentnode;  
    Decimal Level, totalcount,totalcount1,parentlevel, parentorder =0;
    decimal Order, maxorder;
    ID NCMTTreeStrRecordTypeID;
    String Markupmethod;
    string  RecordTypeTreeBranch = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Tree Branch').getRecordTypeId();
    //string  RecordTypeTreeLeaf = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Tree Leaf').getRecordTypeId();
    string  RecordTypeTreeDefault = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
    NCMT_Tree_structure__c OldValues;

    //populate NCMT_Project_Markup__c lookup on tree structure
    if(trigger.isbefore && trigger.isInsert && (TriggerValue.isClone== false)){
        for(NCMT_Tree_structure__c objTreeStruc :trigger.new){
            NCMTIDs.add(objTreeStruc.Project_ID__c);
        }
        NCMT_Project_Markup__c markup = [SELECT Id from NCMT_Project_Markup__c WHERE Project_Name__c = :NCMTIDs];
        
        for(NCMT_Tree_structure__c objTreeStruc :trigger.new){
            objTreeStruc.Markup__c = markup.Id;
        }
    }

    if(trigger.isAfter && trigger.isInsert && (TriggerValue.isClone== false)){

        for(NCMT_Tree_structure__c objTreeStruc :trigger.new)
        {
            NCMTIDs.add(objTreeStruc.Project_ID__c);
            TreeStrucRecordid = objTreeStruc.ID;
            parentnode = objTreeStruc.Relatedtree__c;            
        }

        list<NCMT_Tree_structure__c>  NCMTList = new List<NCMT_Tree_structure__c>();
        if(parentnode != null){
            NCMT_Tree_structure__c TreeStruc = [SELECT RecordTypeID, Level__c, Order__c, SortOrdertxt__c
                                                FROM NCMT_Tree_structure__c WHERE Project_ID__c = :NCMTIDs and id =:parentnode ];
            
                    parentlevel = TreeStruc.Level__c;
                    parentorder = TreeStruc.Order__c;
                    string parentSortOrder = string.valueOf(TreeStruc.SortOrdertxt__c);
                    TreeStruc.RecordTypeID = RecordTypeTreeBranch;
           
                    NCMTList.add(TreeStruc);
                    
         for (AggregateResult ar : [SELECT max(Order__c) maxorder1, Count(id) totcount 
                                             FROM NCMT_Tree_structure__c 
                                            WHERE Relatedtree__c = :parentnode 
                                             and Project_ID__c = :NCMTIDs
                                             and Include_In_Estimate__c = true
                                         GROUP BY Project_ID__c]) {
                                        
                        maxorder = integer.valueof(ar.get('maxorder1'));
                        totalcount = integer.valueof(ar.get('totcount'));                   
                } 
         
         NCMT_Tree_structure__c TreeStrucChild = [SELECT Level__c, Order__c, SortOrdertxt__c 
                                                FROM NCMT_Tree_structure__c WHERE Project_ID__c = :NCMTIDs and id =:TreeStrucRecordid];
            
         TreeStrucchild.Level__c = ParentLevel + 1;
         system.debug('maxorder' + maxorder);
         system.debug('totalcount' + totalcount);

            if(maxorder == 1 && totalcount == 1){
                TreeStrucchild.Order__c = maxorder; 
            }else if(maxorder == 0 && TreeStrucchild.Level__c> 0){
                TreeStrucchild.Order__c = maxorder + 10; 
            }
            else{
                TreeStrucchild.Order__c = maxorder + 1;
            }  

                TreeStrucchild.SortOrdertxt__c = parentSortOrder + string.valueOf(TreeStrucchild.Level__c) + string.valueOf(TreeStrucchild.Order__c);

            NCMTList.add(TreeStrucChild);
            
         
          update NCMTList;
         
         }    
    }

   


    if(trigger.isAfter && trigger.isUpdate && (TriggerValue.isClone== false)){
        System.debug('Tree Structure After Update');
        Decimal totalcost = 0.00;
        map<string,decimal> totalcostMap = new map<string,decimal>();
         map<string,decimal> totaldirectcostMap = new map<string,decimal>();
        map<string,decimal> totalcostwosubMap = new map<string,decimal>();
        map<string,decimal> LevelMap = new map<string,decimal>();
        map<string,String> sortOrderMap = new map<string,string>();
        list<NCMT_Tree_structure__c>  NCMTList = new List<NCMT_Tree_structure__c>();
        set<id> parentnodeSet = new set<id>();
        for(NCMT_Tree_structure__c objTreeStruc :trigger.new)
        {
            System.debug('Updating...' + objTreeStruc.Id);
            NCMTIDs.add(objTreeStruc.Project_ID__c);
            TreeStrucRecordid = objTreeStruc.ID;
            parentnode = objTreeStruc.Relatedtree__c;
            parentnodeSet.add(objTreeStruc.Relatedtree__c);
            markupmethod = objTreeStruc.Markup_Method__c;
        }
        System.debug(parentnodeset);
        //Handles updating the Include_in_Estimate__c field of child records in a future method as it was hitting limits
        NCMT_DES_Tree_Structure_TriggerHandler handler = new NCMT_DES_Tree_Structure_TriggerHandler(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        handler.includeUpdates();

        if(parentnodeSet != null){
            
            system.debug('NCMTIDs---'+NCMTIDs);
            Integer i = 1;
            for (AggregateResult ar : [SELECT sum(Total_Cost__c) totalcost1,max(Order__c) maxorder1, 
                                              Count(id) totcount,Relatedtree__c relatedT,sum(Total_Cost_w_o_Subcon__c) totcostwosub,
                                              sum(Total_Direct_Cost__c) totdirectcost
                                             FROM NCMT_Tree_structure__c 
                                            WHERE Relatedtree__c In : parentnodeSet 
                                             and Project_ID__c In :NCMTIDs
                                             //and Include_In_Estimate__c = true
                                         GROUP BY Relatedtree__c,Project_ID__c]) {
                         System.debug('AR count = ' + i);
                         i++;
                        //totalcost = integer.valueof(ar.get('totalcost1'));
                          totalcostMap.put(string.valueof(ar.get('relatedT')),(Decimal)ar.get('totalcost1')); 
                          totaldirectcostMap.put(string.valueof(ar.get('relatedT')),(Decimal)ar.get('totdirectcost'));  
                          totalcostwosubMap.put(string.valueof(ar.get('relatedT')),(Decimal)ar.get('totcostwosub'));                   
                        maxorder = integer.valueof(ar.get('maxorder1'));
                        System.debug('maxorder= ' + maxorder);
                        totalcount = integer.valueof(ar.get('totcount'));
          
             }  
            list<NCMT_Tree_structure__c> TreeStrucParentList = [SELECT Total_Cost__c,RecordTypeID, order__c, level__c,SortOrdertxt__c
                                                                  FROM NCMT_Tree_structure__c 
                                                                 WHERE Project_ID__c = :NCMTIDs 
                                                                   and id In :parentnodeSet ];
            string parentSortOrder ;
            System.debug(totalCostMap);
            for( NCMT_Tree_structure__c TreeStrucParent : TreeStrucParentList){
                    System.debug('updating parent ' + TreeStrucParent.Id);
                    if(totalcostMap.get(TreeStrucParent.Id) != null){ 
                        TreeStrucParent.Total_Cost__c = totalcostMap.get(TreeStrucParent.Id);
                        TreeStrucParent.Total_Direct_Cost__c = totaldirectcostMap.get(TreeStrucParent.Id);
                        TreeStrucParent.Total_Cost_w_o_Subcon__c = totalcostwosubMap.get(TreeStrucParent.Id);
                    }else{
                        TreeStrucParent.Total_Cost__c = 0;
                        TreeStrucParent.Total_Direct_Cost__c =0;
                        TreeStrucParent.Total_Cost_w_o_Subcon__c=0;
                    }
                    parentlevel = TreeStrucParent.Level__c;
                    parentorder = TreeStrucParent.Order__c;
                    parentSortOrder = string.valueOf(TreeStrucParent.SortOrdertxt__c);
                    
                    TreeStrucParent.RecordTypeID = RecordTypeTreeBranch;
            
               NCMTList.add(TreeStrucParent);                    
            }
        
            OldValues = Trigger.oldMap.get(TreeStrucRecordid);
            if(OldValues.Relatedtree__c !=Null){
                if (parentnode != OldValues.Relatedtree__c){
                    for (AggregateResult ar : [SELECT Count(id) totcount
                                                    FROM NCMT_Tree_structure__c 
                                                WHERE Relatedtree__c = :OldValues.Relatedtree__c 
                                                    and Project_ID__c = :NCMTIDs
                                                GROUP BY Project_ID__c]) {
                            totalcount1 = integer.valueof(ar.get('totcount'));
                    }              
                                
                    NCMT_Tree_structure__c TreeStruc = [SELECT Total_Cost__c,RecordTypeID, Total_Direct_Cost__c,Total_Cost_w_o_Subcon__c,order__c, level__c, SortOrdertxt__c
                                                FROM NCMT_Tree_structure__c WHERE Project_ID__c = :NCMTIDs and id =:OldValues.Relatedtree__c];
                    
            
                    NCMT_Tree_structure__c TreeStruc1 = [SELECT Total_Cost__c, Total_Direct_Cost__c, Total_Cost_w_o_Subcon__c,SortOrdertxt__c, Level__c, Order__c
                                                FROM NCMT_Tree_structure__c WHERE Project_ID__c = :NCMTIDs and id = :TreeStrucRecordid ];
        
                    TreeStruc.Total_Cost__c = TreeStruc.Total_Cost__c - TreeStruc1.Total_Cost__c;
                    TreeStruc.Total_Direct_Cost__c =TreeStruc.Total_Direct_Cost__c - TreeStruc1.Total_Direct_Cost__c;
                    TreeStruc.Total_Cost_w_o_Subcon__c=TreeStruc.Total_Cost_w_o_Subcon__c - TreeStruc1.Total_Cost_w_o_Subcon__c;
                    if(totalcount1 == null || totalcount1 == 0){
                        TreeStruc.RecordTypeID = RecordTypeTreeDefault;
                    }
            
                    NCMTList.add(TreeStruc);
                    
                    TreeStruc1.Level__c = ParentLevel +1;
                
                    if(maxorder == 1 && totalcount == 1){
                        TreeStruc1.Order__c = maxorder; 
                    }else{
                        TreeStruc1.Order__c = maxorder + 1;
                    }  
                    TreeStruc1.SortOrdertxt__c = parentSortOrder + string.valueOf(TreeStruc1.Level__c) + string.valueOf(TreeStruc1.Order__c);
                    
                    string anothervalue, newsortorder;
                    decimal currentlevel=0;
                    anothervalue =   OldValues.SortOrdertxt__c +'%';
                    NCMTList.add(TreeStruc1);
                            
                    List<NCMT_Tree_structure__c> ListTreeSChild = [SELECT ID,SortOrdertxt__c, Level__c, Order__c, Relatedtree__c,
                                                                        Relatedtree__r.Level__c, Relatedtree__r.SortOrdertxt__c,
                                                                        name, Relatedtree__r.name, LastModifiedDate
                                                                    FROM NCMT_Tree_structure__c 
                                                                    WHERE Project_ID__c = :NCMTIDs 
                                                                    and SortOrdertxt__c like :anothervalue 
                                                                    order by Level__c ASC, Order__c ASC, LastModifiedDate DESC]; 

                
                    Integer count = 0;
                    String origSortOrder = '';
                    for(NCMT_Tree_structure__c objTreeStrucChild :ListTreeSChild )
                    {
                        IF(objTreeStrucChild.ID == TreeStrucRecordid ){
                            //system.debug('TreeStruc1.SortOrdertxt__c=='+TreeStruc1.SortOrdertxt__c);
                            System.debug('Adding ' + string.valueof(objTreeStrucChild.name) + ' to LevelMap');
                            LevelMap.put(string.valueof(objTreeStrucChild.name),(Decimal)TreeStruc1.Level__c);
                            objTreeStrucChild.Level__c = TreeStruc1.Level__c;
                            SortOrderMap.put(string.valueof(objTreeStrucChild.name),TreeStruc1.SortOrdertxt__c);
                            origSortOrder = objTreeStrucChild.SortOrdertxt__c;
                            objTreeStrucChild.SortOrdertxt__c = TreeStruc1.SortOrdertxt__c;
                        }else{
                            if(count > 0 && objTreeStrucChild.SortOrdertxt__c == origSortOrder)
                            {
                                //Skip the duplicate sort order item
                                System.debug('DUPLICATE SORT ORDER');
                            }
                            else{
                            System.debug('LevelMap (else): ' + LevelMap);
                            System.debug('objTreeStrucChild.relatedtree__r.name: ' + objTreeStrucChild.relatedtree__r.name);
                            objTreeStrucChild.Level__c = LevelMap.get(objTreeStrucChild.relatedtree__r.name) + 1;
                            objTreeStrucChild.SortOrdertxt__c = sortorderMap.get(objTreeStrucChild.relatedtree__r.name) + objTreeStrucChild.Level__c + objTreeStrucChild.Order__c;
                        
                            LevelMap.put(string.valueof(objTreeStrucChild.name),(Decimal)objTreeStrucChild.Level__c);
                            SortOrderMap.put(string.valueof(objTreeStrucChild.name),objTreeStrucChild.SortOrdertxt__c);
                            NCMTList.add(objTreeStrucChild);
                            }
                        }
                        count++;
                    }    
                }
            }
            
            update NCMTList;
             
        } 
        
        OldValues = Trigger.oldMap.get(TreeStrucRecordid);
        if (markupmethod != OldValues.Markup_Method__c){
            List<NCMT_DES_Items__c> DESItemsList = [Select ID, Name, Markup_Method__c
                                                From NCMT_DES_Items__c 
                                                where Tree_structure__c = :TreeStrucRecordid
                                               ];
            for (NCMT_DES_Items__c DESList : DESItemsList){
                DESList.Markup_Method__c =markupmethod;
            }
        
            update DESItemsList;
            
        }
        
    
    }
    if(trigger.isdelete && Trigger.isbefore){
        for(NCMT_Tree_structure__c NCMTTreeStr :trigger.old){
            NCMTTreeStrRecordTypeID = NCMTTreeStr.RecordTypeID;
            NCMTIDs.add(NCMTTreeStr.Project_ID__c);
            TreeStrucRecordid = NCMTTreeStr.ID;
            parentnode = NCMTTreeStr.Relatedtree__c;
        }
        //system.debug('TreeStrucRecordid' + TreeStrucRecordid);
        List<NCMT_Tree_structure__c> TreeStruclst = [SELECT Name, RecordTypeID
                                                     FROM NCMT_Tree_structure__c WHERE Project_ID__c = :NCMTIDs and Relatedtree__c =:TreeStrucRecordid ];
        List<NCMT_DES_Items__c> itemList = [select id, name from NCMT_DES_Items__c where Tree_structure__c = :TreeStrucRecordid];
        
        //system.debug('TreeStruclst' + TreeStruclst);
        /*if(TreeStruclst.size() > 0){
            for(NCMT_Tree_structure__c NCMTTreeSt : Trigger.old) {
                NCMTTreeSt.addError('This Tree Structure has related branches, and cannot be deleted. Please remove or re-assign related Tree Structures before deleting.');
            }   
        }
        if(itemList.size() > 0){
            for(NCMT_Tree_structure__c NCMTTreeSt : Trigger.old) {
                NCMTTreeSt.addError('This Tree Structure has related work items, and cannot be deleted. Please remove or re-assign related work items before deleting.');
            }   
        }*/
        
    }

    if(trigger.isdelete && Trigger.isafter){
        decimal totalcost;
        System.debug('After Delete Tree Structure');
        List<Id> parents = new List<Id>();
        for(NCMT_Tree_structure__c NCMTTreeStr :trigger.old){
            System.debug(NCMTTreeStr);
            NCMTTreeStrRecordTypeID = NCMTTreeStr.RecordTypeID;
            NCMTIDs.add(NCMTTreeStr.Project_ID__c);  
             //TreeStrucRecordid = NCMTTreeStr.ID;
             TreeStrucRecordid = trigger.old[0].Id;
            parentnode = trigger.old[0].Relatedtree__c;
            parents.add(NCMTTreeStr.Relatedtree__c);
             //parentnode = NCMTTreeStr.Relatedtree__c;
        }
        
        System.debug('parentnode ' + parentNode);
        System.debug('parents ' + parents);
        System.debug(NCMTIds);
        
        if(parentnode != null){
             for (AggregateResult ar : [SELECT Count(id) totcount
                                             FROM NCMT_Tree_structure__c 
                                            //WHERE Relatedtree__c = :parentnode 
                                            WHERE Relatedtree__c IN: parents
                                             and Project_ID__c = :NCMTIDs
                                         GROUP BY Project_ID__c]) {
                    System.debug(ar);                         
                    totalcount = integer.valueof(ar.get('totcount'));
                

                }  
                system.debug('total count' +totalCount );
            NCMT_Tree_structure__c TreeStruc = [SELECT RecordTypeID
                                                FROM NCMT_Tree_structure__c WHERE Project_ID__c = :NCMTIDs and id =:parentnode ];
            if(totalcount == null || totalcount == 0){
                //NCMT_Tree_structure__c TreeStruc = [SELECT RecordTypeID
                //                                    FROM NCMT_Tree_structure__c WHERE Project_ID__c = :NCMTIDs and id =:parentnode ];
                TreeStruc.RecordTypeID = RecordTypeTreeDefault;
                TreeStruc.Total_Cost__c = 0;
                TreeStruc.Total_Direct_Cost__c = 0;
                TreeStruc.Total_Cost_w_o_Subcon__c = 0;
                //update TreeStruc;
            } 
            update TreeStruc;
        }
    }

}