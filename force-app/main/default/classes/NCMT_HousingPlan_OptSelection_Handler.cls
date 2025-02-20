public with sharing class NCMT_HousingPlan_OptSelection_Handler {
    private final List<NCMT_Housing_Plan_Option_Selection__c> oldList { get; set; }
    private final List<NCMT_Housing_Plan_Option_Selection__c> newList { get; set; }
    private final Map<Id, NCMT_Housing_Plan_Option_Selection__c> oldMap { get; set; }
    private final Map<Id, NCMT_Housing_Plan_Option_Selection__c> newMap { get; set; }
    public static Boolean skipGenerateProject = false;

    public NCMT_HousingPlan_OptSelection_Handler(List<NCMT_Housing_Plan_Option_Selection__c> oldLst, List<NCMT_Housing_Plan_Option_Selection__c> newLst, Map<Id, NCMT_Housing_Plan_Option_Selection__c> oldMp, Map<Id, NCMT_Housing_Plan_Option_Selection__c> newMp) {
        oldList = (oldLst == null ? new List<NCMT_Housing_Plan_Option_Selection__c>() : oldLst);
        newList = (newLst == null ? new List<NCMT_Housing_Plan_Option_Selection__c>() : newLst);
        oldMap = (oldMp == null ? new Map<Id, NCMT_Housing_Plan_Option_Selection__c>() : oldMp);
        newMap = (newMp == null ? new Map<Id, NCMT_Housing_Plan_Option_Selection__c>() : newMp);
        
        
    }

    public void manageCostComponents(){
        if (!skipGenerateProject){
            Id projId;
            if (newList.size() > 0){
                for (NCMT_Housing_Plan_Option_Selection__c  optSel : newList){
                    projId = optSel.NCMT_Project__c;
                }
            }
            if (oldList.size() > 0){
                for (NCMT_Housing_Plan_Option_Selection__c  optSel : oldList){
                    projId = optSel.NCMT_Project__c;
                }
            }

            if (projId != null){
                

                NCMT_Project__c proj = [Select Id, building_type__c, project_type__c, Housing_Plan__c,
                    Default_Housing_Plan__c, Cost_Parameter_Date_FY__c
                    from NCMT_Project__c where Id =: projId][0];
                
                

                NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt();   
        
                objGenerateDataExt.GenerateHPOptionData(projId, proj.project_type__c, proj.Housing_Plan__c, proj.Default_Housing_Plan__c, proj.Cost_Parameter_Date_FY__c);
            }
            
        }
    }
    
    /*Did this in NCMT_GenerateProjectDtailsExt instead, maybe useful later...
    public void addCostComponents(){
        Map<Id, String> hpSpaces = new Map<Id, String>();
        Map<Id, NCMT_Housing_Plan_Option__c> options = new Map<Id, NCMT_Housing_Plan_Option__c>();
        for (NCMT_Housing_Plan_Option_Selection__c sel : newList){
            options.put(sel.NCMT_Housing_Plan_Option__c, null);
            hpSpaces.put(sel.NCMT_Housing_Plan__c, null);
        }

        Id projId; //Only one is ever processed at a time
        for (NCMT_Housing_Plan__c hp : [Select Id, Space_Type__c, Project__c from NCMT_Housing_Plan__c where Id IN: hpSpaces]){
            hpSpaces.put(hp.Id, hp.Space_Type__c);
            projId = hp.Project__c;
        }
        Set<String> rts = new Set<String>();
        for (NCMT_Housing_Plan_Option__c o : [Select Id, Housing_Plan_Option_Template_Record_Type__c, 
                Housing_Plan_Template__c, NCMT_Housing_Plan_Option__c, Recurs_on_TCO_Tenant_Refresh_Years__c, 
                TCO_Repair_Cost_Percentage__c, TCO_Repair_Every_X_Years__c, TCO_Replacement_Cost_Percent__c, 
                TCO_Replacement_Every_X_Years__c 
            from NCMT_Housing_Plan_Option__c where Id IN: options.keySet()]
        ){
            options.put(o.id, o);
            rts.add(o.Housing_Plan_Option_Template_Record_Type__c);
        }

        List<NCMT_Core_Shell_Cost_Detail__c> coreCosts = new List<NCMT_Core_Shell_Cost_Detail__c>();
        List<NCMT_TI_TRCS_Cost_Detail__c> tiCosts = new List<NCMT_TI_TRCS_Cost_Detail__c>();
        List<NCMT_Security_Detail__c> securityCosts = new List<NCMT_Security_Detail__c>();

        if (rts.contains('TI-TRCS Cost')){
            tiCosts = [Select Id, Cost_Category__c  from NCMT_TI_TRCS_Cost_Detail__c where Project__c =: projId];
        }
    }
*/
}