trigger PBS_BPA_Trigger on PBS_BuildingProjectAssociation__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  TriggerDispatcher.Run(new PBS_BPA_TriggerHandler());
}