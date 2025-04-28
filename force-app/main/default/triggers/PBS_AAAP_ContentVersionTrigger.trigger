trigger PBS_AAAP_ContentVersionTrigger on ContentVersion (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    //Here we are just call PBS_AAAP_ContentVersionTriggerHandler
    TriggerDispatcher.Run(new PBS_AAAP_ContentVersionTriggerHandler());
}