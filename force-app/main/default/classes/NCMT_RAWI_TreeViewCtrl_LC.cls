public with sharing class NCMT_RAWI_TreeViewCtrl_LC {

    public class raWIitems{
        @AuraEnabled public NCMT_Project_Cost_Summary__c pcs {get; set;}
        @AuraEnabled public map<string, map<string, list<NCMT_RA_WI_Lookup_Details__c>>> items {get; set;}
        @AuraEnabled public Map<string, string> phases {get; set;}


    }
    @AuraEnabled
    public static raWIitems init(string pcsId){
        raWIitems wrapper = new raWIitems();
        wrapper.pcs = getPCS(pcsId);
        string projectId =  wrapper.pcs.project_name__c;
        string pcsType = wrapper.pcs.Cost_Category_Description__c;
        string projFiscalYear = wrapper.pcs.project_name__r.Cost_Parameter_Date_FY__c;
        wrapper.items = populateItemCategories(pcsType, projFiscalYear);
        wrapper.phases = getPhaseOptions(projectId);

        return wrapper;
    }

    public static NCMT_Project_Cost_Summary__c getPCS(string pcsId){
        NCMT_Project_Cost_Summary__c pcs = [SELECT Cost_Category_Description__c,  Project_name__c, project_name__r.name, project_name__r.Cost_Parameter_Date_FY__c, 
                                            project_name__r.Location_Multiplier_Washington_D_C_1_0__c, Name 
                                            FROM NCMT_Project_Cost_Summary__c
                                            WHERE id = :pcsId];
        return pcs;
    }

    public static map<string, map<string, list<NCMT_RA_WI_Lookup_Details__c>>> populateItemCategories(string pcsType, string projFiscalYear){
        		system.debug('pcsTypein ctrl' + pcsType);
        		system.debug('projFiscalYear ctrl' + projFiscalYear);


        
        list<NCMT_RA_WI_Lookup_Details__c> raWis = [SELECT id, name, codename__c, Cost_Category__c, Cost_Type__c, Fiscal_Year__c,  High__c, 
                                                    Low__c, Quantity_SF__c, Rate__c,UOM__c,  WI_Category_Description__c, WI_CATEGORY_Sub_Description__c,
                                                    WI_Category_Sub_Type__c, Work_Item_Category_Type__c, Work_Item_Type__c
                                                    FROM NCMT_RA_WI_Lookup_Details__c
                                                    WHERE Cost_Type__c = :pcsType 
                                                    AND  Fiscal_Year__c =: projFiscalYear  
                                                    AND WI_Category_Description__c != 'Other'
                                                    ORDER BY Work_Item_Category_Type__c, WI_Category_Sub_Type__c,WI_Category_Description__c];
        //create map for ra lookup tree containing items 
        Map<string, map<string, list<NCMT_RA_WI_Lookup_Details__c>>> raWiMap = new Map<string, map<string, list<NCMT_RA_WI_Lookup_Details__c>>>();
		system.debug('rawis in ctrl' + raWis);
        for(NCMT_RA_WI_Lookup_Details__c wi:raWis){
            //if cat type, and sub type map levels populated, add to item list
            if(raWiMap.containsKey(wi.Work_Item_Category_Type__c) && raWiMap.get(wi.Work_Item_Category_Type__c).containsKey(wi.codename__c)){
                raWiMap.get(wi.Work_Item_Category_Type__c).get(wi.codename__c).add(wi);
            }else{
                List<NCMT_RA_WI_Lookup_Details__c> newItems = new List<NCMT_RA_WI_Lookup_Details__c>();
                newItems.add(wi);
                map<string,List<NCMT_RA_WI_Lookup_Details__c>> subTypeMap = new map<string, List<NCMT_RA_WI_Lookup_Details__c>>();
                subTypeMap.put(wi.codename__c, newItems);
                //if cat type not populated, add to cat type map
                if(!raWiMap.containsKey(wi.Work_Item_Category_Type__c)){
                    raWiMap.put(wi.Work_Item_Category_Type__c, subTypeMap);
                //if sub type map not populated, add to sub type map
                }else if(!raWiMap.get(wi.Work_Item_Category_Type__c).containsKey(wi.codename__c)){
                    raWiMap.get(wi.Work_Item_Category_Type__c).putAll(subTypeMap);
                }
            }
        }
        
         return raWiMap;

    }
    public static Map<string, string> getPhaseOptions( string projectId) {
        map<string, string> phaseOptions = new map<string, string>();
        for(NCMT_RA_Phasing__c phase:  [select id, name from NCMT_RA_Phasing__c where Project__c = :projectId]){
            phaseOptions.put(phase.id, phase.name);
        }
        return phaseOptions;
    }
    

}