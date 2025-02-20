public with sharing class  RedirectToRecordController {
    
    @AuraEnabled
    public static void cloneNCMTOtherDirectCost(String projectId) {
        List<NCMT_Other_Cost__c> projectCostRecords = [SELECT id, Total1__c
                                                       FROM NCMT_Other_Cost__c 
                                                       WHERE NCMT_Project__c = :projectId
                                                       AND (Cost_Type__c = 'Project Costs' OR Cost_Type__c = 'Site Acquisition Cost')];
        for (NCMT_Other_Cost__c projectCostObj : projectCostRecords) {                    
            projectCostObj.Total1__c = 0;
        }
        update projectCostRecords;
        
        Map<String, String> oldToNewId = new Map<String, String>();
        Map<String, String> descriptionToSummaryId = new Map<String, String>();
        Map<String, String> oldSummaryToNewSummaryId = new Map<String, String>();
        String originalProjectRecordId;
        
        List<NCMT_Other_Direct_Cost__c> insertOtherDirectCosts = new List<NCMT_Other_Direct_Cost__c>();
        List<NCMT_Other_Cost__c> otherCostRecords = [SELECT id, NCMT_Other_Cost_Original_Record_Id__c
                                                     FROM NCMT_Other_Cost__c 
                                                     WHERE NCMT_Project__c = :projectId
                                                     AND Cost_Type__c = 'Direct Costs'
                                                     AND NCMT_Other_Cost_Original_Record_Id__c <> null];
        Set<Id> originalOtherCostIds = new Set<Id>();
        if (!otherCostRecords.isEmpty()) {
            for (NCMT_Other_Cost__c oc : otherCostRecords) {
                originalOtherCostIds.add(oc.NCMT_Other_Cost_Original_Record_Id__c);
                oldToNewId.put(oc.NCMT_Other_Cost_Original_Record_Id__c, oc.Id);
            }
        }
        
        if (!originalOtherCostIds.isEmpty()) {
            List<NCMT_Other_Direct_Cost__c> directCosts = [SELECT id, Cost_Based_On__c, Cost_Category__c,
                                                           Cost_Category_Description__c, Area__c, NCMT_Other_Cost__c,
                                                           Project_Cost_Summary__c, Unit_Rate__c,
                                                           Project_Cost_Summary__r.Project_Name__c
                                                           FROM NCMT_Other_Direct_Cost__c
                                                           WHERE NCMT_Other_Cost__c IN :originalOtherCostIds
                                                           ORDER BY NCMT_Other_Cost__c];
            
          
            
           
            if (!directCosts.isEmpty()) {
                originalProjectRecordId = directCosts[0].Project_Cost_Summary__r.Project_Name__c;
                
                List<NCMT_Project_Cost_Summary__c> originalProjectCostSummary = [SELECT id, Cost_Category_Description__c
                                                                                 FROM NCMT_Project_Cost_Summary__c
                                                                                 WHERE Project_Name__c = :directCosts[0].Project_Cost_Summary__r.Project_Name__c];
                
                List<NCMT_Project_Cost_Summary__c> newProjectCostSummary = [SELECT id, Cost_Category_Description__c
                                                                            FROM NCMT_Project_Cost_Summary__c
                                                                            WHERE Project_Name__c = :projectId];
                
                for (NCMT_Project_Cost_Summary__c newSummary : newProjectCostSummary) {
                    descriptionToSummaryId.put(newSummary.Cost_Category_Description__c, newSummary.Id);
                }
                
                for (NCMT_Project_Cost_Summary__c oldSummary : originalProjectCostSummary) {
                    if (descriptionToSummaryId.containsKey(oldSummary.Cost_Category_Description__c)) {
                        oldSummaryToNewSummaryId.put(oldSummary.Id, descriptionToSummaryId.get(oldSummary.Cost_Category_Description__c));
                    }
                }   
                
                for (NCMT_Other_Direct_Cost__c dc : directCosts) {
                    NCMT_Other_Direct_Cost__c odc = new NCMT_Other_Direct_Cost__c();
                    odc.Cost_Based_On__c = dc.Cost_Based_On__c;
                    odc.Cost_Category__c = dc.Cost_Category__c;
                    odc.Cost_Category_Description__c = dc.Cost_Category_Description__c;
                    odc.Area__c = dc.Area__c;
                    odc.Project_Cost_Summary__c = oldSummaryToNewSummaryId.get(dc.Project_Cost_Summary__c);
                    odc.NCMT_Other_Cost__c = oldToNewId.get(dc.NCMT_Other_Cost__c);
                    odc.Unit_Rate__c = dc.Unit_Rate__c;
                    insertOtherDirectCosts.add(odc);                    
                }
                
                insert insertOtherDirectCosts;
                
                /*NCMT_Project__c originalProjectRecord = getOriginalProjectRecord(originalProjectRecordId);
                NCMT_Project__c newProjectRecord = new NCMT_Project__c(Id = projectId);
                newProjectRecord.Total_Other_Project_Costs__c = originalProjectRecord.Total_Other_Project_Costs__c;
                update newProjectRecord; 
                
                List<NCMT_Other_Cost__c> projectCostRecords = [SELECT id, Total1__c
                                                             FROM NCMT_Other_Cost__c 
                                                             WHERE NCMT_Project__c = :projectId
                                                             AND Cost_Type__c = 'Project Costs'];
                for (NCMT_Other_Cost__c projectCostObj : projectCostRecords) {                    
                    projectCostObj.Total1__c = 0;
                }
                update projectCostRecords; */
               // updateProject(projectId);
                
            }
        }
    }
    
    /*@future
    public static void updateOtherCostRecords(String projectId) {
        List<NCMT_Other_Cost__c> projectCostRecords = [SELECT id, Total1__c
                                                       FROM NCMT_Other_Cost__c 
                                                       WHERE NCMT_Project__c = :projectId
                                                       AND Cost_Type__c = 'Project Costs'];
        for (NCMT_Other_Cost__c projectCostObj : projectCostRecords) {                    
            projectCostObj.Total1__c = 0;
        }
        update projectCostRecords;
    }
    
    public static NCMT_Project__c getOriginalProjectRecord(String originalProjectRecordId) {
        return [
            SELECT id, Total_Other_Project_Costs__c
            FROM NCMT_Project__c
            WHERE Id = :originalProjectRecordId
        ];
    }*/
    
}