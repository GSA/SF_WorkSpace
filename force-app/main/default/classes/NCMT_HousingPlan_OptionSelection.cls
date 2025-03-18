public with sharing class NCMT_HousingPlan_OptionSelection {
    
    public NCMT_HousingPlan_OptionSelection(ApexPages.StandardController stdController) {
        
    }

    /*@AuraEnabled
    public static List<NCMT_HousePlan_TypeOptions> retrieveHousingPlans(String projId){
        return [Select Id, Housing_Plan_Name__c from NCMT_Housing_Plan__c where Project__c =: projId Order by Housing_Plan_Name__c];
    }*/


    @AuraEnabled
    public static List<NCMT_HousePlan_TypeOptions> retrieveOptions(String recordType, String templateType, String projId){
        templateType = String.escapeSingleQuotes(templateType);
        recordType = String.escapeSingleQuotes(recordType);
        projId = String.escapeSingleQuotes(projId);
        System.debug('retrieveOptions- recordType = ' +recordType +' projId = ' +projId);
        Map<String, Map<Integer, Map<Id, NCMT_Housing_Plan_Option_Selection__c>>> planSelections = new Map<String, Map<Integer, Map<Id, NCMT_Housing_Plan_Option_Selection__c>>>();
        Map<String, Id> planIds = new Map<String, Id>();
        
        NCMT_Project__c proj = [Select Id, Name, Housing_Plan__c from NCMT_Project__c where Id =: projId][0];
        Boolean isHPProj = proj.Housing_Plan__c;
        Boolean isTCO = false;
        Id tcoRecordTypeId = NCMT_Utilities.getProjectRecordTypeId('New_Construction_TCO');
        if (isHPProj){
            for (NCMT_Housing_Plan__c hp : [Select Id, Name, Housing_Plan_Name__c, Project__r.RecordTypeId from NCMT_Housing_Plan__c 
                where Project__c =: projId Order by Housing_Plan_Name__c]
            ){
                String n = (hp.Housing_Plan_Name__c == null ? hp.Name : hp.Housing_Plan_Name__c);
                planSelections.put(n, new Map<Integer, Map<Id, NCMT_Housing_Plan_Option_Selection__c>>());
                planIds.put(n, hp.Id);
                if (hp.Project__r.RecordTypeId == tcoRecordTypeID) isTCO = true;
            }
        } else {
            for (NCMT_Project__c p : [Select Id, RecordTypeId from NCMT_Project__c where Id =: projId]){
                if (p.RecordTypeId == tcoRecordTypeID) isTCO = true;
            }
            planSelections.put(proj.Name, new Map<Integer, Map<Id, NCMT_Housing_Plan_Option_Selection__c>>());
        }

        //Rarely used but accounts for scenarios where move options are selected on a project and then it's updated to or from a Housing Plan project
        List<NCMT_Housing_Plan_Option_Selection__c> delSelections = new List<NCMT_Housing_Plan_Option_Selection__c>();

        for (NCMT_Housing_Plan_Option_Selection__c s : [Select Id, NCMT_Housing_Plan_Option__c, NCMT_Project__r.Name, 
            NCMT_Housing_Plan__c, NCMT_Housing_Plan__r.Name, NCMT_Housing_Plan__r.Housing_Plan_Name__c, Recurs_on_TCO_Tenant_Refresh_Years__c, 
            TCO_Repair_Cost_Percentage__c, TCO_Repair_Every_X_Years__c, TCO_Replacement_Every_X_Years__c, Recurrence__c
            from NCMT_Housing_Plan_Option_Selection__c 
                where NCMT_Project__c =: projId 
                Order by NCMT_Housing_Plan__r.Housing_Plan_Name__c, Recurrence__c]
        ){
            if ((isHPProj &&s.NCMT_Housing_Plan__c == null)){
                delSelections.add(s);
            } else {
                String groupName = (isHPProj ? (s.NCMT_Housing_Plan__r.Housing_Plan_Name__c == null ? s.NCMT_Housing_Plan__r.Name : s.NCMT_Housing_Plan__r.Housing_Plan_Name__c) : s.NCMT_Project__r.Name);
                if (s.Recurrence__c == null) s.Recurrence__c = 1;
                if (planSelections.get(groupName) == null)
                    planSelections.put(groupName, new Map<Integer, Map<Id, NCMT_Housing_Plan_Option_Selection__c>>());
                if (planSelections.get(groupName).get(Integer.valueOf(s.Recurrence__c)) == null)
                    planSelections.get(groupName).put(Integer.valueOf(s.Recurrence__c), new Map<Id, NCMT_Housing_Plan_Option_Selection__c>());

                //Clean-up for HP Projects that are switched to Gross Area to remove duplicates, generally won't come up
                if (planSelections.get(groupName).get(Integer.valueOf(s.Recurrence__c)).get(s.NCMT_Housing_Plan_Option__c) != null){
                    delSelections.add(s);
                } else {
                    planSelections.get(groupName).get(Integer.valueOf(s.Recurrence__c)).put(s.NCMT_Housing_Plan_Option__c, s);
                }
            }
        }
        if (delSelections.size() > 0){
            delete delSelections;
        }
        
        List<NCMT_Housing_Plan_Option__c> allOptions = [Select Id, Choice_Text__c, Description__c,
                TCO_Default_Repair_Cost_Percentage__c,
                TCO_Default_Repair_Every_X_Years__c, Recurs_on_TCO_Tenant_Renewal_Years__c,
                TCO_Default_Replacement_Every_X_Years__c,
                NCMT_Housing_Plan_Option_Template__r.RecordType.Name,
                NCMT_Housing_Plan_Option_Template__r.Type__c,
                NCMT_Housing_Plan_Option_Template__r.Sub_Type__c
            from NCMT_Housing_Plan_Option__c
            where NCMT_Housing_Plan_Option_Template__r.RecordType.DeveloperName =: recordType
                AND NCMT_Housing_Plan_Option_Template__r.Type__c =: templateType
            Order by NCMT_Housing_Plan_Option_Template__r.Sort_Order__c, Sort_Order__c];

        Map<String, Map<Integer, Map<String, List<NCMT_HousePlan_TypeOptions.HousingPlan_Option>>>> housingPlanOpts = new Map<String, Map<Integer, Map<String, List<NCMT_HousePlan_TypeOptions.HousingPlan_Option>>>>();
        for (String groupName : planSelections.keySet()){
            for (NCMT_Housing_Plan_Option__c opt : allOptions
            ){
                
                if (housingPlanOpts.get(groupName) == null)
                    housingPlanOpts.put(groupName, new Map<Integer, Map<String, List<NCMT_HousePlan_TypeOptions.HousingPlan_Option>>>());
                
                Set<Integer> recurrences = new Set<Integer>();
                recurrences.addAll(planSelections.get(groupName).keySet());
                if (recurrences.size() == 0) recurrences.add(1);

                for (Integer r : recurrences){
                    NCMT_HousePlan_TypeOptions.HousingPlan_Option houseOpt = new NCMT_HousePlan_TypeOptions.HousingPlan_Option(opt);
                    
                    if (planSelections.get(groupName) != null &&planSelections.get(groupName).get(r) != null)
                        houseOpt.optSelect = planSelections.get(groupName).get(r).get(opt.Id);
                    if (houseOpt.optSelect != null){
                        houseOpt.selected = true;
                    } else {
                        houseOpt.optSelect = new NCMT_Housing_Plan_Option_Selection__c(
                            NCMT_Housing_Plan__c = planIds.get(groupName),
                            NCMT_Housing_Plan_Option__c = opt.Id,
                            NCMT_Project__c = projId,
                            Recurrence__c = r,
                            TCO_Repair_Cost_Percentage__c = opt.TCO_Default_Repair_Cost_Percentage__c,
                            TCO_Repair_Every_X_Years__c = opt.TCO_Default_Repair_Every_X_Years__c,
                            TCO_Replacement_Every_X_Years__c = opt.TCO_Default_Replacement_Every_X_Years__c
                        );
                    }
                    if (housingPlanOpts.get(groupName).get(r) == null)
                        housingPlanOpts.get(groupName).put(r, new Map<String, List<NCMT_HousePlan_TypeOptions.HousingPlan_Option>>());

                    if (housingPlanOpts.get(groupName).get(r).get(opt.NCMT_Housing_Plan_Option_Template__r.Sub_Type__c) == null)
                        housingPlanOpts.get(groupName).get(r).put(opt.NCMT_Housing_Plan_Option_Template__r.Sub_Type__c, new List<NCMT_HousePlan_TypeOptions.HousingPlan_Option>());

                    housingPlanOpts.get(groupName).get(r).get(opt.NCMT_Housing_Plan_Option_Template__r.Sub_Type__c).add(houseOpt);
                }
            }
        }
        System.debug('planSelections...... ' +planSelections);
        System.debug('housingPlanOpts...... ' +housingPlanOpts);
        List<NCMT_HousePlan_TypeOptions> opts = new List<NCMT_HousePlan_TypeOptions>();
        
        for (String groupName : housingPlanOpts.keySet()){
            NCMT_HousePlan_TypeOptions hp = new NCMT_HousePlan_TypeOptions(groupName);
            hp.isTCO = isTCO;
            for (Integer r : housingPlanOpts.get(groupName).keySet()){
                List<NCMT_HousePlan_TypeOptions.HousingPlan_SubType> subs = new List<NCMT_HousePlan_TypeOptions.HousingPlan_SubType>();
                for (String subType : housingPlanOpts.get(groupName).get(r).keySet()){
                    NCMT_HousePlan_TypeOptions.HousingPlan_SubType sub = new NCMT_HousePlan_TypeOptions.HousingPlan_SubType(subType, housingPlanOpts.get(groupName).get(r).get(subType));
                    subs.add(sub);
                }
                NCMT_HousePlan_TypeOptions.HousingPlan_Recurrence rec = new NCMT_HousePlan_TypeOptions.HousingPlan_Recurrence(r, subs);
                hp.recurrences.add(rec);
            }
            opts.add(hp);
        }

        return opts;
    }


    @AuraEnabled
    public static String saveHousingPlanOpts(List<NCMT_HousePlan_TypeOptions> opts){

        List<NCMT_Housing_Plan_Option_Selection__c> upsertOpts = new List<NCMT_Housing_Plan_Option_Selection__c>();
        List<NCMT_Housing_Plan_Option_Selection__c> deleteOpts = new List<NCMT_Housing_Plan_Option_Selection__c>();
        Set<Id> delIds = new Set<Id>();
        for (NCMT_HousePlan_TypeOptions hpOpt : opts){
            for (NCMT_HousePlan_TypeOptions.HousingPlan_Recurrence rec : hpOpt.recurrences){
                for (NCMT_HousePlan_TypeOptions.HousingPlan_SubType subtype : rec.subTypes){
                    
                    for (NCMT_HousePlan_TypeOptions.HousingPlan_Option houseOpt : subtype.options){
                        if (houseOpt.selected){
                            houseOpt.optSelect.Recurrence__c = rec.num;
                            upsertOpts.add(houseOpt.optSelect);
                            System.debug('save it-------- ' +houseOpt.optSelect);
                        } else if (!houseOpt.selected &&houseOpt.optSelect.Id != null){
                            deleteOpts.add(houseOpt.optSelect);
                            delIds.add(houseOpt.optSelect.Id);
                            System.debug('delete it-------- ' +houseOpt.optSelect);
                        }
                    }
                }
            }
        }
        try{
            if (delIds.size() > 0){
                List<NCMT_Other_Cost__c> otherCosts = [Select Id from NCMT_Other_Cost__c where NCMT_Housing_Plan_Option_Selection__c IN: delIds];
                delete otherCosts;                           
                NCMT_HousingPlan_OptSelection_Handler.skipGenerateProject = (deleteOpts.size() > 0);
                delete deleteOpts;
            }
            NCMT_HousingPlan_OptSelection_Handler.skipGenerateProject = false;
            upsert upsertOpts;
        } catch (DMLException e){
            String err = 'Error(s): ';
            for (Integer i = 0; i < e.getNumDml(); i++) {
                err += '\n' +e.getDmlMessage(i);
            }
            return err;
        }


        return null;
    } 

}