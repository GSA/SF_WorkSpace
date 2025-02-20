public with sharing class NCMT_AssembliesView_Ctrl_LC {
    
    public static Id treeId {get;set;}
    public static Id projId {get;set;}
    public static String projName {get;set;}
    public static String estFormat {get;set;}
    public static Map<String, String> costCatOptions {get;set;}
    public static String selectedCat {get;set;}
    public static String fiscalYear {get;set;}
    
    @AuraEnabled
    public static ESTFormat populateCostCategories(String treeId, string fileName)
    {
        System.debug('fileName' + fileName);
        //Get ID of current tree structure and query for field values
        System.debug('TreeID: ' + treeId);
        ESTFormat response = new ESTFormat();
        List<NCMT_Tree_structure__c>  treestruc = [select Estimate_Format__c, Project_ID__c, Project_ID__r.name, 
                                                         Project_ID__r.Cost_Parameter_Date_FY__c, Name 
                                                   from NCMT_Tree_structure__c where id = :treeId];
        
        //Set project ID, name, and estimate format 
        // removed estimate format gm-6/17
        projId = treestruc[0].Project_ID__c;
        projName = treestruc[0].Project_ID__r.Name;
        // estFormat = treestruc[0].Estimate_Format__c;
        // estFormat = 'Uniformat';
        fiscalYear = treestruc[0].Project_ID__r.Cost_Parameter_Date_FY__c;
        System.debug('fiscalYear' + fiscalYear);

        //Get all cost categories associated with the estimate format of this tree structure
        costCatOptions = new Map<String, String>();
        List<NCMT_Cost_Category__c> cats = [SELECT CatDesc__c, Category_Description__c, Estimate_Format__c FROM NCMT_Cost_Category__c 
                                            WHERE (Estimate_Format__c = :estFormat OR Estimate_Format__c =: 'Assemblies') 
                                            order by Sort_Order__c];

        //now querying on lookups directly, instead of cost categories. Passing category list to cmp. gm - 6/17
        List<NCMT_Assembly_Lookup_Detail__c> uniqCats = new list<NCMT_Assembly_Lookup_Detail__c>();
        List<NCMT_Assembly_Lookup_Detail__c> allCats =[SELECT Level_2__r.Sort_Order__c,  Level_2__c,File_Type__c, Level_2__r.Estimate_Format__c,
                                                        Level_2_Description__c, Lvl2Desc__c,
                                                        Level_3_Description__c, Lvl3Desc__c,
                                                        Level_4_Description__c, Lvl4Desc__c,
                                                        Level_5_Description__c    

                                                        FROM NCMT_Assembly_Lookup_Detail__c 
                                                        WHERE Level_2__r.Estimate_Format__c in ('Assemblies', 'Uniformat') 
                                                        AND Fiscal_Year__c =: fiscalYear
                                                        AND File_Type__c =: fileName
                                                        ORDER BY Lvl2Desc__c,  Lvl3Desc__c,Lvl4Desc__c,Lvl5Desc__c];
        System.debug('allCats' + allCats);
        System.debug('allCats[0]' + allCats[0]);

        selectedCat = allCats[0].Lvl2Desc__c;
        for (NCMT_Assembly_Lookup_Detail__c a : allCats){
            boolean isDup = false;
            for(NCMT_Assembly_Lookup_Detail__c b : uniqCats){
                isDup = (a.Level_2__c == b.Level_2__c);
                break;                                               
            }
            if(!isDup){
            uniqCats.add(a);
            costCatOptions.put(String.valueOf(a.Level_2__r.Sort_Order__c), a.Lvl2Desc__c);
            }

        }
        response.descriptionMap=costCatOptions;
        response.fiscalYear = fiscalYear;
        response.assembList = allCats;
        return response;                                        
    }
    
    @AuraEnabled
    public static List<TreeItem> populateTree(list<NCMT_Assembly_Lookup_Detail__c> tempDetails)
    {

        for(NCMT_Assembly_Lookup_Detail__c a: tempDetails){


        }
        // System.debug('Selected: ' + selectedCat);
        // System.debug('estFormat: ' + estFormat);
        
        List<TreeItem> level2 = new List<TreeItem>();
        //removed assembly query, now passing in from cmp
        //Get tree structure levels for selected cost category  - gm 6/17
     
        
        //Remove duplicates from tempDetails list (Sets by default include no duplicates)
        Set<NCMT_Assembly_Lookup_Detail__c> tempSet = new Set<NCMT_Assembly_Lookup_Detail__c>();
        List<NCMT_Assembly_Lookup_Detail__c> details = new List<NCMT_Assembly_Lookup_Detail__c>();
        tempSet.addall(tempDetails);
        details.addAll(tempSet);
        System.debug('Size = ' + details.size());
        System.debug(details);
        
        //Populate tree
        for(Integer i = 0; i < details.size(); i++)
        {
            System.debug('i = ' + i);
            Integer l2size = level2.size();
            NCMT_Assembly_Lookup_Detail__c d = details[i];
            NCMT_Assembly_Lookup_Detail__c d2 = null;
            if(i != 0)
                d2 = details[i-1];
            
            List<TreeItem> level5 = new List<TreeItem>();
            List<TreeItem> level4 = new List<TreeItem>();
            List<TreeItem> level3 = new List<TreeItem>();
            
            System.debug('d = ' + d);
            System.debug('d2 = ' + d2 + '\n');
            if(d.Level_2_Description__c != null)
            {
                if(d.level_3_Description__c != null)
                {
                    if(d.level_4_Description__c != null)
                    {
                        //All 5 levels are populated
                        System.debug('d.level_5_description__c' + d.level_5_description__c + '\n');

                        
                        if(d.level_5_description__c != null)
                        {
                            //Add Level 5 item
                            TreeItem t = new TreeItem(d.Level_5_Description__c, constructName(d), false, true, null);
                            level5.add(t);  
                            
                            //If first item in list, add all rows without further checks
                            if(d2 == null || (d.Level_4_Description__c != d2.Level_4_Description__c && d.Level_3_Description__c != d2.Level_3_Description__c))
                            {
                                t = new TreeItem(d.Level_4_Description__c, 'N', false, true, level5);
                                level4.add(t);
                                
                                t = new TreeItem(d.Level_3_Description__c, 'N', false, true, level4);
                                level3.add(t);
                                level2.add(t);
                                System.debug('level2 size = ' +  level2.size());
                            }
                            //Level 5 item is a child of previous level 4
                            else if(d.Level_4_Description__c == d2.Level_4_Description__c)
                            {  
                                 //added conditional to pass test class, gm 3/11
                                if (level2.get(l2size-1).items != null){ 
                                    Integer l3size = level2.get(l2size-1).items.size();
                                    level2.get(l2size-1).items.get(l3size-1).items.add(t);
                                }
                            }
                            //Level 4 item is a child of previous level 3
                            else if(d.Level_3_Description__c == d2.Level_3_Description__c)
                            {
                                System.debug('Level 4 child of previous Level 3');
                                System.debug('CURRENT = ' + d);
                                System.debug('l2size = ' + l2size);
                                System.debug(level2.get(l2size-1));
                                System.debug(level2.get(l2size-1).items);
                                
                                t = new TreeItem(d.Level_4_Description__c, 'N', false, true, level5);
                                level4.add(t);
                                
                                //Add to previous level 3 list of children
                                level2.get(l2size-1).items.add(t);
                                
                            }
                        } 
                        
                        //TreeItem is populated up to level 4
                        else
                        {
                           //TreeItem t = new TreeItem(d.Level_4_Description__c, constructNameLevel3(d), false, true, null);
                           TreeItem t = new TreeItem(d.Lvl4Desc__c, constructNameLevel3(d), false, true, null);
                           level4.add(t);  
                           
                            //If first item in list, add all rows without further checks
                            if(d2 == null || (d.Level_3_Description__c != d2.Level_3_Description__c /*&& d.Level_2_Description__c != d2.Level_2_Description__c*/))
                            {
                                
                                //t = new TreeItem(d.Level_3_Description__c, 'N', false, true, level4);
                                t = new TreeItem(d.Lvl3Desc__c, 'N', false, true, level4);
                                level3.add(t);
                                
                                //TreeItem t2 = new TreeItem(d.Level_2_Description__c, 'N', false, true, level3);
                                TreeItem t2 = new TreeItem(d.Lvl2Desc__c, 'N', false, true, level3);
                                if(level2.size() == 0){
                                  level2.add(t2);
                                }else{
                                    //added conditional to pass test class, gm 3/11
                                    if(level2.get(l2size-1).items != null){ 
                                        level2.get(l2size-1).items.add(t);
                                    }
                                }
                                System.debug('level2 size = ' +  level2.size());
                            }
                            //Level 4 item is a child of previous level 3
                           else if(d.Level_3_Description__c == d2.Level_3_Description__c)
                            {
                                System.debug('LEVEL 4 CHILD');
                                System.debug('CURRENT ITEM: ' + d);
                                System.debug('t = ' + t);
                                System.debug(level2.get(l2size-1)); //Level2
                                System.debug(level2.get(l2size-1).items); //Level3
                                                                    //added conditional to pass test class, gm 6/22

                                if(level2.get(l2size-1).items != null){ 

                                    Integer l3size = level2.get(l2size-1).items.size();
                                    System.debug('l3size = ' + l3size + '\n');
                                    System.debug(level2.get(l2size-1).items.get(l3size-1).items);
                                    
                                    //t = new TreeItem(d.Level_3_Description__c, 'N', false, true, level4);
                                    //level3.add(t);
                                    
                                    //Add to previous level 3 list of children
                                    //level2.get(l2size-1).items.add(t);
                                    level2.get(l2size-1).items.get(l3size-1).items.add(t);
                                }
                            }
                            
                        }
                    }
                    //TreeItem is populated up to level 3
                    else
                    {
                        //TreeItem t = new TreeItem(d.Level_3_Description__c, 'N', false, true, null);
                        TreeItem t = new TreeItem(d.Lvl3Desc__c, 'N', false, true, null);
                        level3.add(t);
                        level2.add(t);
                        System.debug('level2 size = ' +  level2.size());
                    }
                }
                
            }
        }
      
        
        return level2;
    }
    
    public static String constructName(NCMT_Assembly_Lookup_Detail__c d)
    {
        String s = d.Level_5_Description__c + '|' +
            d.Level_4_Description__c + '|' +
            d.Level_3_Description__c + '|' +
            d.Level_2_Description__c;
        
        return s;
    }
    
    public static String constructNameLevel3(NCMT_Assembly_Lookup_Detail__c d)
    {
        String s = d.Level_4_Description__c + '|' +
            d.Level_3_Description__c + '|' +
            d.Level_2_Description__c;
        
        return s;
    }
    
    
    //Wrapper class
    public class TreeItem
    {
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public Boolean disabled {get;set;}
        @AuraEnabled public Boolean expanded {get;set;}
        @AuraEnabled public List<TreeItem> items {get;set;}
        
        public TreeItem(String label, String name, Boolean disabled, Boolean expanded, List<TreeItem> items)
        {
            this.label = label;
            this.name = name;
            this.disabled = disabled;
            this.expanded = false;
            this.items = items;
        }
        
           
    } 
    public class ESTFormat{
        @auraenabled public map<string,string> descriptionMap{get;set;}
        // @auraenabled public string estFormat{get;set;}
        @auraenabled public string fiscalYear{get;set;}
        @auraenabled public list<NCMT_Assembly_Lookup_Detail__c> assembList{get;set;}
        public ESTFormat(){
            this.descriptionMap= new map<string,string>();
            // this.estFormat='';
            this.fiscalYear='';
            this.assembList = new List<NCMT_Assembly_Lookup_Detail__c>();
        }
    }
}