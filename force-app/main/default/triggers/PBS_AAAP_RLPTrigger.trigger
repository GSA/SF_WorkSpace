trigger PBS_AAAP_RLPTrigger on PBS_AAAP_RLP__c (before insert, before update) {

    AAAP_Skip_Logic_Setting__c isSkip =  AAAP_Skip_Logic_Setting__c.getValues(UserInfo.getProfileId());
    if(isSkip==null){
         if (Trigger.isBefore && Trigger.isInsert) {
    
            PBS_AAAP_RLPTriggerHandler.processRLPs(Trigger.new,
                    Trigger.old,
                    PBS_AAAP_TriggerHelper.Action.BEFOREINSERT);
    
        }
    
        if (Trigger.isBefore && Trigger.isUpdate) {
    
            PBS_AAAP_RLPTriggerHandler.processRLPs(Trigger.new,
                    Trigger.old,
                    PBS_AAAP_TriggerHelper.Action.BEFOREUPDATE);
    
        }
    }
   

}