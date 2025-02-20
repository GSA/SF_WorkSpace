trigger PBS_SPHD_Trigger on PBS_Small_Projects_Historical_Database__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  TriggerDispatcher.Run(new PBS_SPHD_TriggerHandler());
}