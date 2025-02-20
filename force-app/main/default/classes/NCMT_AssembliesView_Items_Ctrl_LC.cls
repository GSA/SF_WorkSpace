public with sharing class NCMT_AssembliesView_Items_Ctrl_LC {
    public class itemWrapper {
        //wrapper object for passing all necessary data to component.         
        @AuraEnabled public List<NCMT_Assembly_Lookup_Detail__c> lookups {get; set;}
        //removed phasing gm 5_8
        // @AuraEnabled public list<NCMT_RA_Phasing__c> phaseList{get;set;}
        
        @AuraEnabled public list<NCMT_Crew_Master__c> crewMasterList {get; set;}
        @AuraEnabled public string pcsId {get; set;}
        @AuraEnabled public NCMT_Project__c project {get; set;}   
        @AuraEnabled public string recordTypeId {get; set;}
		@AuraEnabled public string treeMarkupMethod {get; set;}
    }
    
    //Sanitize params to comply with security scan
    @AuraEnabled public static String estimateFormat {  get {return estimateFormat;} 
                                                        //set {if(value == 'Uniformat' || value == 'GSA Assemblies')
                                                        set {if(value == 'Uniformat' || value == 'GSA Assemblies' || value == 'Assemblies')
                                                            	estimateFormat = value;}	}
    @AuraEnabled public static String catId {	get {return catId;} 
                                             	set {if(value != null && value.length() == 18)
                                                    	catId = value;}	}
    @AuraEnabled public static String costCategory {	get {return costCategory;} 
                                                    	set {if(gsaCats.contains(value))
                                                            	costCategory = value;}	}
    
    public static List<String> gsaCats = new List<String>();
    
    @AuraEnabled
    public static itemWrapper init(string recordId, string level2desc, string level3desc, string level4desc, string costCat, string ESTFormat, string categoryId, String fiscalYear){
        itemWrapper wrapper = new itemWrapper();
        estimateFormat = ESTFormat;
        catId = categoryId;
        costCategory = costCat;
        
        NCMT_Tree_structure__c pageTree = new NCMT_Tree_structure__c();
        string projFiscalYear;
        System.debug('recordId ======  ' +recordId);
        if (recordId != null &&recordId != ''){
            pageTree = getTreeStructure(recordId);
        
            wrapper.treeMarkupMethod = pageTree.Markup_Method__c;
            
            string projectId = pageTree.Project_ID__c;
            
            wrapper.project = getProjectData(projectId);
            
            projFiscalYear = wrapper.project.Cost_Parameter_Date_FY__c;
            
            // string itemEstFormat = wrapper.lookups[0]. Level_2__r.Estimate_Format__c;

            string markupMethod = wrapper.project.Markup_Method__c;

            
            //wrapper.pcsId = getPcsId(projectId, null, estimateFormat, catId);
            wrapper.pcsId = getPcsId(projectId);

            wrapper.recordTypeId = getRecordType(markupMethod);

        } else {
            projFiscalYear = fiscalYear;
            wrapper.project = new NCMT_Project__c();
        }
        // wrapper.phaseList = getPhaseOptions(projectId);
        wrapper.crewMasterList = getCrewMaster();
        wrapper.lookups = getLookupData(level2desc, level3desc, level4desc, projFiscalYear);
        
        
        
        
        return wrapper;
        
    }
    
    @AuraEnabled
    public static itemWrapper initGSA(string recordId, string level2desc, string level3desc, string level4desc, string level5desc, string level6desc, string costCat, string ESTFormat, String fiscalYear){
        itemWrapper wrapper = new itemWrapper();
        List<NCMT_Cost_Category__c> cats = [Select Category_Description__c FROM NCMT_Cost_Category__c WHERE Estimate_Format__C = 'GSA Assemblies'];
            for(NCMT_Cost_Category__c c : cats)
                gsaCats.add(c.Category_Description__c);
        estimateFormat = ESTFormat;
        costCategory = costCat;
        
        NCMT_Tree_structure__c pageTree;
        string projFiscalYear;

        if (recordId != null &&recordId != ''){
            pageTree =  getTreeStructure(recordId);
        
            wrapper.treeMarkupMethod = pageTree.Markup_Method__c;
            
            string projectId = pageTree.Project_ID__c;
            
            wrapper.project = getProjectData(projectId);
            
            projFiscalYear = wrapper.project.Cost_Parameter_Date_FY__c;
            string markupMethod = wrapper.project.Markup_Method__c;

            // wrapper.phaseList = getPhaseOptions(projectId);
            
            
            
            //wrapper.pcsId = getPcsId(projectId, costCategory, estimateFormat, null);
            wrapper.pcsId = getPcsId(projectId);
            
            wrapper.recordTypeId = getRecordType(markupMethod);
        } else {
            projFiscalYear = fiscalYear;
            wrapper.project = new NCMT_Project__c();
        }
        wrapper.crewMasterList = getCrewMaster();   
        System.debug('projFiscalYear,  fiscalYear' +projFiscalYear +' ' +fiscalYear);
        wrapper.lookups = getLookupDataGSA(level2desc, level3desc, level4desc, level5desc, level6desc, projFiscalYear);
        
        return wrapper;
        
    }
    
    @AuraEnabled
    public static List<NCMT_Assembly_Lookup_detail__c> getLookupData(string level2desc, string level3desc, string level4desc, string projectFiscalYear){
        // system.debug('dataLimit' + dataLimit);
        System.debug('getLookupData');
        
        List<NCMT_Assembly_Lookup_detail__c> lookups = [select Id, Description__c, Desc__c, Level_2__r.Estimate_Format__c
                                                    from NCMT_Assembly_Lookup_detail__c
                                                    where Level_2_Description__c = :level2desc AND
                                                    Level_3_Description__c = :level3desc AND
                                                    Level_4_Description__c = :level4desc AND
                                                    Fiscal_Year__c =: projectFiscalYear
                                                    order by Assembly_Number__c];
        //System.debug('lookups = ' + lookups);
        return lookups;
    }
    
    @AuraEnabled
    public static List<NCMT_Assembly_Lookup_detail__c> getLookupDataGSA(string level2desc, string level3desc, string level4desc, string level5desc, string level6desc, string projectFiscalYear){
        // system.debug('dataLimit' + dataLimit);
        System.debug('getLookupData');
        System.debug('Level2: ' + level2desc);
        System.debug('Level3: ' + level3desc);
        System.debug('Level4: ' + level4desc);
        System.debug('Level5: ' + level5desc);
        System.debug('Level6: ' + level6desc);
        
        /*List<NCMT_Assembly_Lookup_detail__c> lookups = [select Id, Description__c, Desc__c
                                                    from NCMT_Assembly_Lookup_detail__c
                                                    where Level_2_Description__c = :level2desc AND
                                                    Level_3_Description__c = :level3desc AND
                                                    Level_4_Description__c = :level4desc AND
                                                    Level_5_Description__c =: level5desc AND
                                                    Level_6_Description__c =: level6desc AND
                                                    File_Type__c = 'GSAAssemblies' AND
                                                    Fiscal_Year__c =: projectFiscalYear
                                                    order by Assembly_Number__c];
        System.debug('lookups = ' + lookups);
        return lookups;*/

        String soql = 'select Id, Description__c, Desc__c '+
            'from NCMT_Assembly_Lookup_detail__c '+
            'where Level_2_Description__c = :level2desc';
        if (level3desc != null){
            soql += ' AND Level_3_Description__c = :level3desc';
        } else {
            soql += ' AND Level_3_Description__c = null';
        }
        if (level4desc != null){
            soql += ' AND Level_4_Description__c = :level4desc';
        } else {
            soql += ' AND Level_4_Description__c = null';
        }
        if (level5desc != null){
            soql += ' AND Level_5_Description__c =: level5desc';
        } else {
            soql += ' AND Level_5_Description__c = null';
        }
        if (level6desc != null){
            soql += ' AND Level_6_Description__c =: level6desc';
        } else {
            soql += ' AND Level_6_Description__c = null';
        }
        
        soql += ' AND File_Type__c = \'GSAAssemblies\' AND ' +
                'Fiscal_Year__c =: projectFiscalYear ' +
                'order by Assembly_Number__c';
        List<NCMT_Assembly_Lookup_detail__c> lookups = Database.query(soql);
        System.debug('lookups = ' + lookups);
        return lookups;
    }
    
    @AuraEnabled 
    public static NCMT_Assembly_Lookup_detail__c getSelectedLoookup(string lookupId){
        
        NCMT_Assembly_Lookup_detail__c lookup =  [select Id, Description__c,
                               Level_2__c, Level_2_Description__c,Level_3__c, Level_3_Description__c, 
                               Level_4__c,Level_4_Description__c, Level_5__c,Level_5_Description__c,
                               Level_6__c, Level_6_Description__c,
                               Quantity__c, Unit__c, Material_Unit_Cost__c, Installation_Cost__c,Item_Type__c, Total_Cost__c,
                               Fiscal_Year__c, Name, Total_Cost_OP__c, Minimum_Cost__c, Installation_Cost_OP__c,
                               Material_Cost_OP__c, Assembly_Number__c, MinID__c, Assembly_Labor_Cost_Unit__c, Labor_Hours_txt__c
                               from NCMT_Assembly_Lookup_Detail__c
                               where Id =: lookupId 
                               ];
        return lookup; 
        
    }
    
    public static integer getLookupTotal(string level2desc, string level3desc, string level4desc){
        
        integer lookupTotal = [ Select count()
                               from NCMT_Assembly_Lookup_detail__c
                               where Level_2_Description__c = :level2desc AND
                               Level_3_Description__c = :level3desc AND
                               Level_4_Description__c = :level4desc];
        return lookupTotal;
    }
    
    
    public static NCMT_Tree_structure__c getTreeStructure( string treeId){
        System.debug('treeId = ' + treeId);
        NCMT_Tree_structure__c tree =  [select Estimate_Format__c, Project_ID__c, Project_ID__r.name, Name, Markup_Method__c 
                                        from NCMT_Tree_structure__c where id = :treeId limit 1];
     
        return tree;
    }
    
    // public static List<NCMT_RA_Phasing__c> getPhaseOptions(string projectId){
    //     //List<selectOption> pos = new List<selectOption>();
    //     List <NCMT_RA_Phasing__c> pos =  [select id, name from NCMT_RA_Phasing__c where Project__c = :projectId ];
    //     return pos;       
    // }
    
    public static  NCMT_Project__c getProjectData(string projectId){
        NCMT_Project__c   project = [select id, Cost_Parameter_Date_FY__c, Location_Multiplier__c, Sales_Tax__c, Labor_Burden_Tax__c, Markup_Method__c, State__c
                                     from NCMT_Project__c 
                                     where id = :projectId];
        return project;                                          
    }
    
    
    public static List<NCMT_Crew_Master__c> getCrewMaster(){
        //List<selectOption> pos = new List<selectOption>();
        List <NCMT_Crew_Master__c> cm =  [select id, name from NCMT_Crew_Master__c ];
        return cm;       
    }
    //public static string getPcsId(string projectId, string costCat, string ESTFormat, string categoryId){
    public static string getPcsId(string projectId){
        //changed assemblies to use cost category id instead of category name. Name was causing issues due to splitting the " - ". 
        // Probably should do this for GSA assemblies as well -- gm 6/17
        
        //estimateFormat = ESTFormat;
        //catId = categoryId;
        //costCategory = costCat;
        System.debug('getPcsId ESTFormat === ' + estimateFormat);
        System.debug('getPcsId categoryId === ' + catId);
        System.debug('getPcsId costCat === ' + costCategory);
        String pcsId = '';
        string andVar;
       	//For Assemblies
        if(catId != null){
            //andvar = ' and Cost_Category_ID__c = \'' + catId+'\'';
            NCMT_Project_Cost_Summary__c pcs = [SELECT id, Cost_Category_Description__c, Project_Name__c, 
                                                	   project_name__r.name, Name  
                                                FROM NCMT_Project_Cost_Summary__c 
                                                WHERE project_name__c =: projectId
                                                AND Estimate_Format__c =: estimateFormat
                                                AND Cost_Category_Id__c =: catId];
            pcsId = pcs.Id;
        }else if(costCategory != null){ //For Express Menu
            system.debug('is gsa' + costCategory);
            //andVar =  ' and Cost_Category_Description__c = \'' + costCategory+'\'';
            NCMT_Project_Cost_Summary__c pcs = [SELECT id, Cost_Category_Description__c, Project_Name__c, 
                                                	   project_name__r.name, Name  
                                                FROM NCMT_Project_Cost_Summary__c 
                                                WHERE project_name__c =: projectId
                                                AND Estimate_Format__c =: estimateFormat
                                                AND Cost_Category_Description__c =: costCategory];
            pcsId = pcs.Id;
        }

        /*string query = 'SELECT id, Cost_Category_Description__c, Project_Name__c, project_name__r.name, Name  FROM NCMT_Project_Cost_Summary__c WHERE project_name__c =  \'' + projectId+'\' ' 
        + ' and Estimate_Format__c =  \'' + estimateFormat +'\' ' + andVar;
     
        System.debug('query: ' + query);
        NCMT_Project_Cost_Summary__c pcs = Database.query(query);
        system.debug('pcs' + pcs);*/
        //pcsId = pcs.Id;
                // system.debug('project cost' +projectCost);
		// if(projectCost.size() > 0)
        // 	pcsId = projectCost[0].Id;
        return pcsId;                                          
    }
    
    @AuraEnabled
    public static list<NCMT_DES_Items__c> saveItems(string itemList){
        
        List<NCMT_DES_Items__c> itemsToInsert = (List<NCMT_DES_Items__c>)JSON.deserialize(itemList,List<NCMT_DES_Items__c>.class);
        
            system.debug('Before ItemstoInsert RAN'+itemsToInsert);
        insert itemsToInsert;
        
     system.debug('After ItemstoInsert RAN'+itemsToInsert);
        
        return itemsToInsert;
    }
    
    @AuraEnabled
    public static list<NCMT_DES_Items__c> saveItemsGSA(string itemList, string treeStruc){
        
        List<NCMT_DES_Items__c> itemsToInsert = (List<NCMT_DES_Items__c>)JSON.deserialize(itemList,List<NCMT_DES_Items__c>.class);
        
        Integer insertSize = itemsToInsert.size();
        System.debug('Insert size = ' + insertSize);
        
        //Minimum Cost
        System.debug('SAVE! Tree Structure = ' + treeStruc);
        AggregateResult[] res = [SELECT MinId__c, COUNT(Id) total FROM NCMT_DES_Items__c
                                 WHERE Tree_Structure__C =: treeStruc
                                 GROUP BY MinID__c];
        System.debug('AR size = ' + res.size());
        
        Map<String, Integer> insertMap = buildInsertMap(itemsToInsert, res);
        
        //System.debug('insertMap built!');
        //System.debug(insertMap);
        
        calculateMinCost(insertMap, itemsToInsert);
        
        //Total Labor Cost Calculation
        NCMT_Tree_Structure__c tree = [SELECT Project_ID__c FROM NCMT_Tree_structure__c WHERE Id =: treeStruc];
        String projId = tree.Project_ID__c;
        
        AggregateResult[] ar = [SELECT MinID__c, SUM(Labor_Cost__c) sumVal FROM NCMT_DES_Items__C 
                                WHERE NCMT_Project_Id__c =: projId.left(15)
                                AND MinID__c IN: insertMap.keySet()
                               GROUP BY MinId__c];
        //System.debug('AR ' + ar);
        Map<String, Decimal> newInserts = new Map<String, Decimal>();
        
        //No existing DES items on tree structure
        //Create map of new inserts MinId and total labor cost
            for(NCMT_DES_Items__c d : itemsToInsert)
            {
                if(newInserts.containsKey(d.MinID__c))
                {
                    //Add current item Labor_Cost__c to Total Labor Cost sum
                    Decimal sum = newInserts.get(d.MinId__c) + d.Labor_Cost__c;
					newInserts.put(d.MinID__c, sum);
                }
                else
                {
                    //Add new row to Map
                    System.debug('New MinID ' + d.Labor_Cost__C);
                    newInserts.put(d.MinID__c, d.Labor_Cost__c);
                }
            }
        //System.debug('newInserts Map: ' + newInserts);
        
        	
            for(NCMT_DES_Items__C i : itemsToInsert)
            {
                System.debug('CURRENT: ' + i.MinID__c);
                if(ar.size()>0){
                for(AggregateResult r : ar)
        		{
                    System.debug(r.get('MinID__c'));
                    System.debug(r.get('sumVal'));
                    Decimal existingVal = Decimal.valueOf(String.valueOf(r.get('sumVal')));
                    Decimal newVal = newInserts.get(i.MinID__c);
                    
                    //DES items with same MinID as item to insert exist on tree structure
                    if(i.MinID__c == r.get('MinID__c'))
                    {
                        System.debug('MinId match!');
                        System.debug(existingVal + ' + ' + newVal);
                        i.Total_Labor_Cost__c = existingVal + newVal;
                        
                        System.debug(i.Total_Labor_Cost__c);
                        break;
                    }
                    //No DES items with same MinID as item to insert exist on tree structure
                    else
                    {
                        System.debug('No match!');
                        i.Total_Labor_Cost__c = newInserts.get(i.MinID__c);
                        System.debug(i.Total_Labor_Cost__c);
                    }
                }
                    }else{
                        System.debug('Zero existing records!');
                        if(insertSize > 1)
                        {
                            //Get sum of Labor Costs of all new inserts with
                            //the same MinID and set Total Labor Cost for all new inserts
                            //with that value
                            Decimal newInsertSum = newInserts.get(i.MinID__c);
                            i.Total_Labor_Cost__c = newInsertSum;
                            System.debug('Total Labor Cost = ' + newInsertSum);
                        }
                        else
                        {
                            //Only one insert item
            				i.Total_Labor_Cost__c = i.Labor_Cost__C;
                        }
        			}
            }

        String msg = '';
        try 
        {
        	insert itemsToInsert; 
            
            return itemsToInsert;
        } 
        catch(DMLException e) 
        {
            //Get All DML Messages
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
        }
        catch(Exception e){
            //throw all other exception message
            throw new AuraHandledException(e.getMessage());
        }      
    }
    
    public static Map<String, Integer> buildInsertMap(List<NCMT_DES_Items__C> items,
                                                      AggregateResult[] existing)
    {
        Map<String, Integer> insertMap = new Map<String, Integer>();
        
        for(NCMT_DES_Items__c d : items)
        {
            String minID = d.MinID__c;
            
            //If first item in map
            if(insertMap.size() == 0)
            {
                insertMap.put(d.MinID__c, 1);
            }
            else
            {
                //check if MinID is already in map 
                if(insertMap.containsKey(d.MinID__c))
                {
                    //increment count for MinID
                    insertMap.put(d.MinID__c, insertMap.get(d.MinId__c)+1);
                }
                else //MinID not in map
                {
                    //add new MinID to map
                    insertMap.put(d.MinID__C, 1);
                }
            }
        }
        
        for(AggregateResult ar : existing)
        {
            if(insertMap.containsKey(String.valueOf(ar.get('MinID__c'))))
            {
                Integer total = insertMap.get(String.valueOf(ar.get('MinID__c'))) + 
                    			Integer.valueOf(ar.get('total'));
               
                insertMap.put(String.valueOf(ar.get('MinID__c')), total);
            }
            else
            {
            	insertMap.put(String.valueOf(ar.get('MinID__c')), Integer.valueOf(ar.get('total')));
            }
        }
        
        return insertMap;
    }
    
    public static void calculateMinCost(Map<String, Integer> insertMap,
                                        List<NCMT_DES_Items__c> itemsToInsert)
    {
		for(NCMT_DES_Items__c d : itemsToInsert)
        {
            //System.debug('mincost = ' + d.Minimum_Cost__c);
            d.Minimum_Cost__c = d.Minimum_Cost__c / insertMap.get(d.MinID__c);
            //System.debug('Updated Min Cost = ' + d.Minimum_Cost__c);
        }
        
    }
    
    
    public static string getRecordType(string markupMethod){
        string recordTypeId;
        //user defined. 
        if(markupMethod == 'RSMeans - O&P' || markupMethod == 'User Defined'){
             recordTypeId = Schema.SObjectType.NCMT_DES_Items__c.getRecordTypeInfosByName().get('NCMT DES Item Uniformat O&P').getRecordTypeId();
        }else{
            recordTypeId = Schema.SObjectType.NCMT_DES_Items__c.getRecordTypeInfosByName().get('NCMT DES Item Uniformat').getRecordTypeId();
        }
        return recordTypeId;
  }
    
}