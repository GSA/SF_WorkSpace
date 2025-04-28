public with sharing class NCMT_TreeView_Items_Ctrl_LC {
    public class itemWrapper {
        //wrapper object for passing all necessary data to component.
        @AuraEnabled public List<NCMT_DES_Lookup_details__c> lookups { get; set; }
        @AuraEnabled public integer lookupTotal {get; set;}
        // removed phase -- gm 5/8
        // @AuraEnabled public list<NCMT_RA_Phasing__c> phaseList { get; set; }
        @AuraEnabled public list<NCMT_Crew_Master__c> crewMasterList { get; set; }
        @AuraEnabled public string pcsId { get; set; }
        @AuraEnabled public NCMT_Project__c project { get; set; }
        @AuraEnabled public list<NCMT_Labor_Location_Markup__c> laborMarkups { get; set; }

        @AuraEnabled public Boolean isLevelFiveUser {get; set;}
        @AuraEnabled public Boolean isLevelTwoUser {get; set;}
        @AuraEnabled public string masterRecordTypeId {get; set;}
        @AuraEnabled public string treeMarkupMethod {get; set;}
        
        
    }
    
    @AuraEnabled
    public static itemWrapper init(string recordId, string level2desc, string level3desc, string level4desc, string level5desc, string costCat, string estFormat, String fiscalYear) {
        integer dataOffset = 0;
        
        itemWrapper wrapper = new itemWrapper();
        
        NCMT_Tree_structure__c pageTree = getTreeStructure(recordId);
        
        string projFiscalYear;

        if (pageTree.Id != null){

            wrapper.treeMarkupMethod = pageTree.Markup_Method__c;

            string projectId = pageTree.Project_ID__c;
            
            wrapper.project = getProjectData(projectId);
            projFiscalYear = wrapper.project.Cost_Parameter_Date_FY__c;
            string markupMethod = wrapper.project.Markup_Method__c;
            string projState = wrapper.project.State__c;
        
            wrapper.laborMarkups = getLaborBurden(projFiscalYear, projState); 

            // wrapper.phaseList = getPhaseOptions(projectId);
            
            wrapper.crewMasterList = getCrewMaster();
            
            wrapper.pcsId = getPcsId(projectId, costCat, estFormat);
            
            wrapper.masterRecordTypeId = getRecordType(markupMethod);
        } else {
            wrapper.project = new NCMT_Project__c();
            projFiscalYear = fiscalYear;
        }
        wrapper.isLevelFiveUser = islevelFive();
        wrapper.isLevelTwoUser = islevelTwo();

        
        wrapper.lookups = getLookupData(level2desc, level3desc, level4desc, level5desc, projFiscalYear);
        
        wrapper.lookupTotal = getLookupTotal(level2desc, level3desc, level4desc, level5desc, projFiscalYear);
        return wrapper;
        
    }
    @AuraEnabled
    public static List<NCMT_DES_Lookup_details__c> getLookupData(string level2desc, string level3desc, string level4desc, string level5desc, string projectFiscalYear){
        string[] excludedFiles = new string[]{'%GSA 2020 FMR_PM_ASSMUP.xlsx%', '%GSA_ 2020 M&R Unit Price Data.xls%'};

        List<NCMT_DES_Lookup_details__c> lookups = [select Id, Description__c, ItemDesc__c, Level_2__c
                                                    from NCMT_DES_Lookup_details__c
                                                    where Level_2_Description__c = :level2desc AND
                                                    Level_3_Description__c = :level3desc AND
                                                    Level_4_Description__c = :level4desc AND
                                                    Level_5_Description__c = :level5desc AND
                                                    Fiscal_Year__c =: projectFiscalYear AND
                                                     (NOT File_Name__c LIKE :excludedFiles)
                                                     Order by Line_Item_Number__c];                               
        return lookups;
    }
    @AuraEnabled 
    public static NCMT_DES_Lookup_details__c getSelectedLoookup(string lookupId){
        NCMT_DES_Lookup_details__c lookup =  [select Id, Difficulty_Factor_Percent__c, Description__c, Line_Item_Number__c,
                                              Equipment_Unit_Cost__c, Hourly_Rate_txt__c, Labor_Hours_txt__c, 
                                              Level_2__c, Level_2_Description__c, Level_3_Line_Item__c, Level_3_Description__c, 
                                              Level_4_Line_Item__c, Level_4_Description__c, Level_5_Line_Item__c, Level_5_Description__c, 
                                              Material_Unit_Cost__c, Tag__c, name, NCMT_Crew_Master__c, 
                                              NCMT_Crew_Master__r.name, NCMT_Contractor_ID__c, Quantity__c, 
                                              Unit__c, Waste_Factor__c, Daily_Output__c,
                                              O_P_Unit_Total__c, In_house_Unit_Total__c, 
                                              NCMT_Labor__c, NCMT_Labor__r.name
                                              from NCMT_DES_Lookup_details__c where Id =:lookupId];
        
        return lookup; 
        
    }
    public static integer getLookupTotal(string level2desc, string level3desc, string level4desc, string level5desc, string projFiscalYear){
        
        integer lookupTotal = [ Select count()
                               from NCMT_DES_Lookup_details__c
                               where Level_2_Description__c = :level2desc AND
                               Level_3_Description__c = :level3desc AND
                               Level_4_Description__c = :level4desc AND
                               Level_5_Description__c = :level5desc AND
                               Fiscal_Year__c = :projFiscalYear];
        return lookupTotal;
    }
    
    
    
    public static NCMT_Tree_structure__c getTreeStructure(string treeId) {
        
        NCMT_Tree_structure__c tree = new NCMT_Tree_structure__c();
        for (NCMT_Tree_structure__c t : [select Project_ID__c, Project_ID__r.name, Name, Markup_Method__c  from NCMT_Tree_structure__c where id = :treeId limit 1])
            tree = t;
        return tree;
    }
    
    // public static List<NCMT_RA_Phasing__c> getPhaseOptions(string projectId) {
    //     //List<selectOption> pos = new List<selectOption>();
    //     List<NCMT_RA_Phasing__c> pos = [select id, name from NCMT_RA_Phasing__c where Project__c = :projectId];
    //     return pos;
    // }
    
    public static  NCMT_Project__c getProjectData(string projectId) {
        NCMT_Project__c project = [SELECT id, Cost_Parameter_Date_FY__c, Location_Multiplier__c, Sales_Tax__c, Labor_Burden_Tax__c, Markup_Method__c, State__c  
                                   FROM NCMT_Project__c
                                   WHERE id = :projectId];
        return project;
    }
    
    
    public static List<NCMT_Crew_Master__c> getCrewMaster() {
        //List<selectOption> pos = new List<selectOption>();
        List<NCMT_Crew_Master__c> cm = [select id, name from NCMT_Crew_Master__c Limit 45000];
        return cm;
    }
    public static string getPcsId(string projectId, string costCat, string estFormat) {
        System.debug('estFormat: ' + estFormat);
        System.debug('COST CATEGORY: ' + costCat);
        List<NCMT_Project_Cost_Summary__c> projectCost = [SELECT id, Cost_Category_Description__c, Project_Name__c, project_name__r.name, Name 
                                                          FROM NCMT_Project_Cost_Summary__c
                                                          WHERE project_name__c = :projectId 
                                                          AND Cost_Category_Description__c = :costCat
                                                          AND Estimate_Format__c = :estFormat];
        
        string pcsId = projectCost[0].Id;
        return pcsId;
    } 
    
    public static Boolean islevelFive() {
        AggregateResult[] listCount = [select count(Id) usrs FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name ='NCMT_Users_LVL5_CRE'];
        Integer count = (integer) listCount [0].get('usrs');
        
        boolean islevelFive = (count > 0);
        return islevelFive;
        
    }

    public static Boolean islevelTwo() {
        AggregateResult[] listCount = [select count(Id) usrs FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name ='NCMT_Users_LVL2_CRE'];
        Integer count = (integer) listCount [0].get('usrs');
        
        boolean islevelTwo = (count > 0);
        return islevelTwo;
        
    }
    public static string getRecordType(string markupMethod){
        system.debug('markupMethod' +markupMethod );
        string recordTypeId;
        if(markupMethod == 'RSMeans - O&P' || markupMethod == 'User Defined'){
            recordTypeId = Schema.SObjectType.NCMT_DES_Items__c.getRecordTypeInfosByName().get('NCMT DES Item Master O&P').getRecordTypeId();
        }else{
            recordTypeId = Schema.SObjectType.NCMT_DES_Items__c.getRecordTypeInfosByName().get('NCMT DES Item Master Format').getRecordTypeId();
        }
        return recordTypeId;
    }
    @AuraEnabled
    public static list<NCMT_Labor_Location_Markup__c> getLaborBurden(string projectYear, string projectState){
        NCMT_Labor_Location_Markup__c[] locationMarkups = [SELECT NCMT_Labor_Resource__c, NCMT_Crew_Master__c, Labor_Burden_Tax__c 
                                                            FROM NCMT_Labor_Location_Markup__c
                                                            WHERE Fiscal_Year__c = :projectYear 
                                                            AND Per_State_Territory__c =:projectState];
        return locationMarkups;
    }
    
    @AuraEnabled
    public static list<NCMT_DES_Items__c> saveItems(string itemList) {
        system.debug('items list' + itemList);
        
        List<NCMT_DES_Items__c> itemsToInsert = (List<NCMT_DES_Items__c>) JSON.deserialize(itemList, List<NCMT_DES_Items__c>.class);
        for(ncmt_des_items__c item : itemsToInsert){
         //item.id = null;
            //NCMT DES Item Master O&P
            Id recordId = Schema.getGlobalDescribe().get('NCMT_DES_Items__c').getDescribe().getRecordTypeInfosByName().get('NCMT DES Item Master O&P').getRecordTypeId();
            if(item.RecordTypeId == recordId){
                //added line 196 for the story SFWS-1910
                if(item.id!=null  && string.valueof(item.id).contains('deleteMe')){
                item.In_house_Unit_Total__c = item.Material_Unit_Cost__c + item.Hourly_Rate__c + item.Equipment_Rental_Day__c;
                item.O_P_Unit_Total__c = item.Material_Unit_Cost__c + item.Hourly_Rate__c + item.Equipment_Rental_Day__c;
                }
               //item.In_house_Unit_Total__c = item.Labor_Assembly_Cost__c + item.Material_Assembly_Cost__c + item.Equipment_Assembly_Cost__c;
              // item.O_P_Unit_Total__c = item.O_P_Total_Cost__c; 
              // commented lines 203 and 204 added for the story sfws-1804 
              //item.In_house_Unit_Total__c = item.In_house_Unit_Total__c;
             // item.O_P_Unit_Total__c = item.O_P_Unit_Total__c; 
            }
           item.id = null;
        }
        system.debug('items to insert' + itemsToInsert);
        // string itemsSting = JSON.serialize(itemsToInsert);
        try{
        insert itemsToInsert;
        }catch(Exception e){
          throw new AuraHandledException('this is a thing that is happening : ' + e.getMessage());
        }
        return itemsToInsert;
    }
    
}