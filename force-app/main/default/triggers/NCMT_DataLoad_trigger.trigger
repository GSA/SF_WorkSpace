trigger NCMT_DataLoad_trigger on NCMT_Data_Upload__c (before insert, after insert) {
    NCMT_DataUpload_TriggerHandler handler = new NCMT_DataUpload_TriggerHandler(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        
    if (Trigger.isAfter &&Trigger.isInsert){
        handler.annual_des_dataload();
        handler.annual_param_dataload();
    }
}