trigger NCMT_Housing_Plan_Option_Selection_trigger on NCMT_Housing_Plan_Option_Selection__c (after insert, after update, after delete) {

    NCMT_HousingPlan_OptSelection_Handler handler = new NCMT_HousingPlan_OptSelection_Handler(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    
    handler.manageCostComponents();
    
}