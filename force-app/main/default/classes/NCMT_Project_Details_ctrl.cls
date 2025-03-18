public with sharing class NCMT_Project_Details_ctrl {
    
    public NCMT_Project__c projectData {get;set;}
    
    public NCMT_Project_Details_ctrl(ApexPages.StandardController controller) { 
        NCMT_Project__c proj = (NCMT_Project__c)controller.getRecord();      
        projectData = getProjectData(proj.Id);
    }
    
    public class projectWrapper{
        @AuraEnabled public NCMT_Project__c  project {get; set;}
        @AuraEnabled public NCMT_Project_Markup__c markup {get; set;}
        @AuraEnabled public List<NCMT_Tree_structure__c > trees {get; set;} 
        @AuraEnabled public list<TreeValues> treeValues {get; set;}
        
    }

    @AuraEnabled
    public static map<string, string>  sanitizeParams(string reportType, string categoriesReport){
        string cleanReportType = reportType.escapeHtml4();
        string cleanCategoriesReport = categoriesReport.escapeHtml4();
        map<string, string > stringMap = new map<String, string> {'cleanReportType'=> cleanReportType, 'cleanCategoriesReport'=>cleanCategoriesReport};
        return stringMap;
    }
    @AuraEnabled
    public static projectWrapper init(string recordId){
        projectWrapper wrapper = new projectWrapper();
        
        wrapper.project = getProjectData(recordId);     
        wrapper.markup = getMarkupData(recordId);
        wrapper.trees = getTreeStructureData(recordId);
        list<string>treeIds = getTreeIds(wrapper.trees);
        // wrapper.lineItems = getTreeLineItems(treeIds);
        wrapper.treeValues = getTreeItemsData(wrapper.trees, treeIds);
        return wrapper;
    }
    
    
    
    public static NCMT_Project__c getProjectData(String projectId) {
        NCMT_Project__c projectData = [select CUI_Header__c, id, Name,  Basis_Date_Of_Estimate__c, Brief_Narrative__c, Building_Heigtht__c, Building_Quality__c, CreatedDate,
                                       CreatedBy.Name, GSA_Project__c, Level_of_Protection__c, Location__c, Location__r.State__c, Location__r.City__c, Project_type__c, 
                                        City__c, State__c, Project_Delivery_Method__c, Project_Phases__c, Project_SubPhases__c, Peer_Reviewer__r.name, Project_Status__c,
                                        Project_Seismic_Design_Category__c, RegionCode__c , Mid_Point_of_Construction__c, Start_Construction__c, Markup_Method__c,
                                        PBS_Building__r.Location_Code_Plus__c, PBS_Building__c,Signed_By__c,Sign_this_Project__c,Signed_Date__c,Estimate_Reviewed_By__r.Name,Estimate_Approved_By__r.Name, Requestor__c
                                       from NCMT_Project__c 
                                       where id= :projectId];
        return projectData;
        
    }

    //removed these unused fields from markup query. --Griffin 2/14/20
    //Total_Labor_w_SubCon__c Total_Labor_w_o_SubCon__c, Total_Equip_Mat_w_o_Sub_Con_Cost__c,Total_Equip_Mat_w_Sub_Con_Cost__c,Sales_Tax__c, 
    // SubTotal_Mat_Equip_wo_SubCon__c, SubTotal_Material_Equipment_w_SubCon__c, SubTotal_Material_Equipment__c, Insurance__c, 
    // 4/2/20 -- Total_Direct_Cost__c
    
    public static NCMT_Project_Markup__c getMarkupData(string projectId){
        NCMT_Project_Markup__c markupData = [SELECT id, Subtotal_OS_Self__c,

                                            Total_Cost_w_o_SubCon_Markups__c, Total_Cost_w_Subcon_Markups__c,
                                            Site_Design_Contingency__c, Site_and_Design_Cont_Impact__c,
                                            
                                             SubTotal_w_o_SubCon__c, SubTotal_with_SubCon__c,  SubTotal__c,

                                            Self_Work_Home_Office_Impact__c, Self_Work_Jobsite_Impact__c, Self_Work_Profit_Impact__c, 
                                            Self_Work_Commission_Impact__c, Self_Work_Bond_Impact__c, Self_Work_Pro_Services_Impact__c,

                                            OS_Work_Home_Office_Impact__c, OS_Work_Jobsite_Overhead_Impact__c, OS_Work_Profit_Impact__c,
                                            OS_Work_Commission_Impact__c, OS_Work_Bond_Impact__c, OS_Work_Pro_Services_Impact__c, 
                                            
                                            SubTotal_SelfPerformedWork__c, Prime_Contractor_Markup_Cost__c,
                                            Prime_Con_SelfWork_HomeOff_Overhead__c, Prime_Con_SelfWork_JobSiteOverhead__c, Prime_Con_SelfWork_Profit__c, 
                                            Prime_Con_SelfWork_Commission__c, Prime_Con_SelfWork_Bond__c, Professional_Services_Fees_SelfWork__c,
                                            
                                            SubTotal_BidFactor__c, Bid_Factor__c, Bid_Factor_Impact__c,

                                            SubTotal_Out_SourcedWork__c, Subcontractor_Markup_Cost__c,
                                            Prime_Con_OSWork_Homeoff_Overhead__c, Prime_Con_OSWork_Jobsite_Overhead__C, Prime_Con_OSWork_Profit__c, 
                                            Prime_Con_OSWork_Commission__c, Prime_Con_OSWork_Bond__c, Professional_Services_Fees_OSWork__c,
                                                
                                            CMc__c, CMC_Impact__c, Professional_Services_Fees_Preconst__c, Pro_Services_Pre_Const_Impact__c, SubTotal_CMc_f__c, 

                                            Developer_Fee__c, Professional_Services_Developer_Fee__c, SubTotal_Developer_f__c,
                                            Developer_Fee_Impact__c, Developer_Professional_Services_Impact__c,

                                            Lessor_Fee__c, Professional_Services_Lessor_Fee__c, Sub_Total_Lessor__c, SubTotal_Lessor_f__c,
                                            Lessor_Fee_impact__c, Lessor_Professional_Services_Impact__c,

                                            Gross_Receipt_State_Construction__c, Gross_Receipts_Impact__c, CECCA__c, Total_CECCA__c,
                                            
                                            Market_Escalation__c, Market_Escalation_Markup_Impact__c, ECCA__c,
                                            
                                            Construction_Contingency__c, Construction_Contingency_Markup_Impact__c, 
                                            Art_In_Architecture__c, Art_In_Architecture_Markup_Impact__c, ECC__c, 

                                            EDRC_Estimated_Design_and_Review_Cost__c , EDRC_Impact__c,
                                            EMIC_Estimated_Management_Inspection_Co__c, EMIC_Impact__c, ETPC__c
                                            
                                            FROM NCMT_Project_Markup__c 
                                            WHERE Project_Name__c  =:projectId];
        return markupData;
    }
    public static List<NCMT_Tree_structure__c> getTreeStructureData(string projectId){          
        List<NCMT_Tree_structure__c> treeData = [SELECT id, Name, Level__c, Order__c, SortOrdertxt__c,Total_Cost__c, Branch_Name__c,
                                                 Total_Direct_Cost__c, description__c, Parent_Node_Desc__c, Quantity__c, UOM__c,
                                                 Relatedtree__r.name,Relatedtree__r.branch_name__c,Relatedtree__r.SortOrdertxt__c, Total_Assembly_Cost__c,
                                                 ECCA__c, ECC__C, ETPC__c, Unit_Cost__c, Total_Including_Markups__c, OP_Unit_Cost__c, RecordType.Name,
                                                 Total_Items_Cost__c, Total_Cost_w_o_Subcon__c 
                                                 FROM NCMT_Tree_structure__c 
                                                 WHERE Project_ID__c = :projectId
                                                 AND Include_in_Estimate__c = TRUE
                                                 ORDER BY SortOrdertxt__c];
        return treeData;
        
    }
    
    
    public static list<string> getTreeIds(list<NCMT_Tree_structure__c> trees){
        string[] treeIds = new string[]{}; 
            for(NCMT_Tree_structure__c tree: trees){
                treeIds.add(tree.id);
            }
        return treeIds;
        
    }
    public static list<TreeValues> getTreeItemsData(List <NCMT_Tree_structure__c> trees, list<string> treeIds){
        TreeValues[] finalTree = new TreeValues[]{};
        List<NCMT_DES_Items__c> items = [SELECT id, Cost_Summary__c, project_Cost_Summary_ID__r.Cost_Category_Code__c , CSI_Line_Item_Number__c,  Name, Description__c, Labor_Hours__c, 
                                    Quantity__c, Unit__c, Total_Cost__c,  Total_Direct_Cost__c, 
                                    NCMT_Contractor_ID__c,  Total_Material_Cost1__c, Total_Labor_Cost1__c, 
                                    Total_Equipment_Cost1__c, Tree_structure__c, 

                                    //detail A fields
                                    Total_Material_Cost_w_Sales_Tax__c, Total_Material_Cost_Adj__c,
                                    Total_Labor_Cost_w_Labor_Burden_Tax__c,  Total_Labor_Cost_Adj__c,  Adj_Labor_Hours__c, Labor_Subtotal__c,
                         
                                    Total_Equipment_Cost_w_Sales_Tax__c, Total_Equip_Cost_Adj__c, 
                                    Hourly_Rate__c, Difficulty_Factor_Percent__c, NCMT_Crew_Master__c , NCMT_Crew_Master__r.Name, Daily_Output__c,
                                    //o&p fields
                                    O_P_Unit_Total__c, In_house_Unit_Total__c,
                                    (Select Id, Name, Assembly_SKey__c, Crew_Master_Name__c, Equipment_Unit_Cost__c, 
                                            Installation_Unit_Cost__c, Labor_Burden_Impact__c, Labor_Burden_Tax__c, Labor_Resource_Name__c, 
                                            Labor_Unit_Cost__c, Line_Item_Description__c, Material_Unit_Cost__c, NCMT_Project_ID__c, Quantity__c,
                                            Total_Cost_w_Labor_Burden_Tax_f__c, Unit__c 
                                        from NCMT_DES_Assembly_Details__r ORDER BY Name)

                                     FROM NCMT_DES_Items__c
                                     WHERE  Tree_structure__c in :treeIds and  Include_In_Estimate__c = true
                                     Order by CSI_Line_Item_Number__c ];
                                           
        string catKey;
        for(integer i=0; i<trees.size(); i++){
            map<string, list<NCMT_DES_Items__c>> catMap = new Map<string, list<NCMT_DES_Items__c>>();

            for(integer j=0; j<items.size(); j++){
                if(items[j].Tree_structure__c == trees[i].id){ 
                    catKey = items[j].Project_Cost_Summary_ID__r.Cost_Category_Code__c + ' - '+ items[j].Cost_Summary__c;
                    //find each category within a tree
                    if(catMap.containsKey(catKey)){
                        catMap.get(catKey).add(items[j]);

                    }else{
                        //add items to category map
                        NCMT_DES_Items__c[]  itemList = new NCMT_DES_Items__c[] {};
                        itemList.add(items[j]);
                        catMap.put(catKey, itemList);
                    }
                }
            }
            TreeValues t = new TreeValues(trees[i], catMap);
            finalTree.add(t);

        }
        return finalTree;
    }
                               


    //container for tree, category, items
    public class TreeValues{
        @AuraEnabled public NCMT_Tree_structure__c tree {get; set;}
        @AuraEnabled public  map<string, list<NCMT_DES_Items__c>> catMap {get; set;}

        public TreeValues(NCMT_Tree_structure__c tree,  map<string, list<NCMT_DES_Items__c>> catMap){
        this.tree = tree;
        this.catMap = catMap;
    }

    }
    
}