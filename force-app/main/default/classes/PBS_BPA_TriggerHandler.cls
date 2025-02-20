public with sharing class PBS_BPA_TriggerHandler implements ITriggerHandler {
  public void BeforeInsert(sObject[] newItems) {}

  public void BeforeUpdate(Map<Id, sObject> newItems, Map<Id, sObject> oldItems) {}

  public void BeforeDelete(Map<Id, sObject> oldItems) {}

  public void AfterInsert(Map<Id, sObject> newItems) {
    repopulateSphdBuildings(newItems.values());
  }

  public void AfterUpdate(Map<Id, sObject> newItems, Map<Id, sObject> oldItems) {
    repopulateSphdBuildings(newItems.values());
  }

  public void AfterDelete(Map<Id,sObject> oldItems) {
    repopulateSphdBuildings(oldItems.values());
  }

  public void AfterUndelete(Map<Id, sObject> oldItems) {}

  public Boolean IsDisabled() {
    try {
      return ![SELECT isActive__c
              FROM Trigger_Settings__mdt
              WHERE DeveloperName='PBS_Building_Project_Association'
              LIMIT 1].isActive__c;
    } catch (Exception e) { }

    return true;
  }


  public void repopulateSphdBuildings(sObject[] records) {
    final Set<Id> projectIds = new Set<Id>();

    for (sObject record: records) {
      projectIds.add((Id) record.get('rluProject__c'));
    }

    // Fire PBS_SPHD_Trigger to run PBS_SPHD_TriggerHandler.repopulateBuildings():
    update [SELECT Id, PBS_Project_Name__c
            FROM PBS_Small_Projects_Historical_Database__c
            WHERE PBS_Project_Name__c IN :projectIds];
  }
}