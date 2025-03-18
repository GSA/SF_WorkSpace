/** 
This Apex class is referenced on lightning component NCMT_TreeView_LC 
which is not used anywhere within NCMT Application.
Hence this artifact can be marked as redundant **/

public with sharing class NCMT_TreeView_Ctrl_LC {
    
    public static Id treeId {get;set;}
    public static Id projId {get;set;}
    public static String projName {get;set;}
    public static String estFormat {get;set;}
    public static Map<String, String> costCatOptions {get;set;}
    public static String selectedCat {get;set;}
    public static String fiscalYear {get;set;}
    
    @AuraEnabled
    public static ESTFormat populateCostCategories(String treeId)
    {
        //Get ID of current tree structure and query for field values
        System.debug('TreeID: ' + treeId);
        ESTFormat response = new ESTFormat();
        List<NCMT_Tree_structure__c>  treestruc = [select Estimate_Format__c, Project_ID__c, Name,
                                                   Project_ID__r.name, Project_ID__r.Cost_Parameter_Date_FY__c
                                                   from NCMT_Tree_structure__c 
                                                   where id = :treeId];
        
        //Set project ID, name, and estimate format
        projId = treestruc[0].Project_ID__c;
        projName = treestruc[0].Project_ID__r.Name;
        estFormat = treestruc[0].Estimate_Format__c;
        fiscalYear = treestruc[0].Project_ID__r.Cost_Parameter_Date_FY__c;
        
        //Get all cost categories associated with the estimate format of this tree structure
        costCatOptions = new Map<String, String>();
        List<NCMT_Cost_Category__c> cats = [SELECT CatDesc__c, Category_Description__c, Estimate_Format__c 
                                            FROM NCMT_Cost_Category__c
                                            WHERE Estimate_Format__c =: estFormat
                                            AND Has_Lookups__c >0 
                                            ORDER BY CatDesc__c];
        
        //Set the first cost category in the list as the default 
        // selectedCat = allCats[0].Lvl2Desc__c;
            selectedCat = cats[0].CatDesc__c;
        
        // Construct list of category descriptions to populate the cost category dropdown menu
        for(Integer i = 0; i < cats.size(); i++)
        {
            costCatOptions.put(String.valueOf(i), cats[i].CatDesc__c);
        }
        response.descriptionMap=costCatOptions;
        response.ESTFormat= estFormat;
        response.fiscalYear = fiscalYear;

        return response;                                        
    }
    
    @AuraEnabled
    public static List<TreeItem> populateTree(String selectedCat, string ESTFormat, String fiscalYear)
    {
        System.debug('Selected: ' + selectedCat);
        System.debug('estFormat: ' + estFormat);
        List<TreeItem> level2 = new List<TreeItem>();
        
      IF(estFormat == 'Master Format'){
        //Get tree structure levels for selected cost category
        string[] excludedFiles = new string[]{'%GSA 2020 FMR_PM_ASSMUP.xlsx%', '%GSA_ 2020 M&R Unit Price Data.xls%'};

        List<NCMT_DES_Lookup_details__c> tempDetails = [SELECT Level_2_Description__c, Lvl2Desc__c, //ItemDesc__c,
                                                        Level_3_Description__c, Lvl3Desc__c,
                                                        Level_4_Description__c, Lvl4Desc__c,
                                                        Level_5_Description__c, Lvl5Desc__c
                                                        FROM NCMT_DES_Lookup_details__c
                                                        WHERE Level_2_Description__c = :selectedCat 
                                                        AND Fiscal_Year__c =: fiscalYear
                                                        AND (NOT File_Name__c LIKE :excludedFiles)                           
                                                        ORDER BY Lvl3Desc__c,Lvl4Desc__c,Lvl5Desc__c];
          
        System.debug('Master Format items Size: ' + tempDetails.size());
          
        // Set all IDs to null so that duplicates may be removed from the details list
        for(NCMT_DES_Lookup_details__c d : tempDetails)
        {
            d.Id = null;
        }
        
        //Remove duplicates from tempDetails list (Sets by default include no duplicates)
        Set<NCMT_DES_Lookup_details__c> tempSet = new Set<NCMT_DES_Lookup_details__c>();
        List<NCMT_DES_Lookup_details__c> details = new List<NCMT_DES_Lookup_details__c>();
        tempSet.addall(tempDetails);
        details.addAll(tempSet);
        
        
        System.debug('Size = ' + details.size());
        
        //Populate tree
        for(Integer i = 0; i < details.size(); i++)
        {
            System.debug('i = ' + i);
            Integer l2size = level2.size();
            NCMT_DES_Lookup_details__c d = details[i];
            NCMT_DES_Lookup_details__c d2 = null;
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
                        if(d.level_5_description__c != null)
                        {
                            //Add Level 5 item
                            TreeItem t = new TreeItem(d.Lvl5Desc__c, constructName(d), false, true, null);//, d.ItemDesc__c);
                            level5.add(t);  
                            
                            //If first item in list, add all rows without further checks
                            if(d2 == null || (d.Level_4_Description__c != d2.Level_4_Description__c && d.Level_3_Description__c != d2.Level_3_Description__c))
                            {
                                t = new TreeItem(d.Lvl4Desc__c, 'N', false, true, level5);//, null);
                                level4.add(t);
                                
                                t = new TreeItem(d.Lvl3Desc__c, 'N', false, true, level4);//, null);
                                level3.add(t);
                                level2.add(t);
                                System.debug('level2 size = ' +  level2.size());
                            }
                            //Level 5 item is a child of previous level 4
                            else if(d.Level_4_Description__c == d2.Level_4_Description__c)
                            {
                                Integer l3size = level2.get(l2size-1).items.size();
                                level2.get(l2size-1).items.get(l3size-1).items.add(t);
                            }
                            //Level 4 item is a child of previous level 3
                            else if(d.Level_3_Description__c == d2.Level_3_Description__c)
                            {
                                System.debug('CURRENT = ' + d);
                                System.debug('l2size = ' + l2size);
                                System.debug(level2.get(l2size-1));
                                System.debug(level2.get(l2size-1).items);
                                
                                t = new TreeItem(d.Lvl4Desc__c, 'N', false, true, level5);//, null);
                                level4.add(t);
                                
                                //Add to previous level 3 list of children
                                //level2.get(i-1).items.add(t);
                                level2.get(l2size-1).items.add(t);
                                
                            }
                        } 
                        
                        //TreeItem is populated up to level 4
                        else
                        {
                            TreeItem t = new TreeItem(d.Lvl4Desc__c, 'N', false, true, null);//, null);
                            level4.add(t);
                            
                            t = new TreeItem(d.Lvl3Desc__c, 'N', false, true, level4);//, null);
                            level3.add(t);
                            level2.add(t);
                            System.debug('level2 size = ' +  level2.size());
                        }
                    }
                    //TreeItem is populated up to level 3
                    else
                    {
                        TreeItem t = new TreeItem(d.Lvl3Desc__c, 'N', false, true, null);//, null);
                        level3.add(t);
                        level2.add(t);
                        System.debug('level2 size = ' +  level2.size());
                    }
                }
                
            }
        }
      }
        return level2;
    }
    
    public static String constructName(NCMT_DES_Lookup_details__c d)
    {
        String s = d.Level_5_Description__c + '|' +
            d.Level_4_Description__c + '|' +
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
        //@AuraEnabled public string itemDescription {get;set;}

        public TreeItem(String label, String name, Boolean disabled, Boolean expanded, List<TreeItem> items)//, string itemDescription)
        {
            this.label = label;
            this.name = name;
            this.disabled = disabled;
            this.expanded = false;
            this.items = items;
            //this.itemDescription = itemDescription;
        }
        
             
    } 
    public class ESTFormat{
        @auraenabled public map<string,string> descriptionMap{get;set;}
        @auraenabled public string estFormat{get;set;}
        @auraenabled public string fiscalYear {get;set;}

        public ESTFormat(){
            this.descriptionMap= new map<string,string>();
            this.estFormat='';
            this.fiscalYear='';

        }
    }
}