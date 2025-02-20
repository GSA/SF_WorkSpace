public with sharing class PBS_SPHD_TriggerHandler implements ITriggerHandler {
  public void BeforeInsert(sObject[] newItems) {
    Set<ID> projName = new Set<ID>();
    map<String,String> gtMap =new map<String,String>();
    map<String,String> gtMap2 =new map<String,String>();

    try{
      for(PBS_Small_Projects_Historical_Database__c obj: (PBS_Small_Projects_Historical_Database__c[]) newItems){
              projName.add(obj.PBS_Project_Name__c);
      }

      List<PBS_Small_Projects_Historical_Database__c> gtList = [SELECT PBS_Project_Name__c, Name FROM PBS_Small_Projects_Historical_Database__c
                                                              WHERE PBS_Project_Name__c IN :projName];

      List<PBS_Project__c> gtList2 = [SELECT ID, txtProjectDescription__c FROM PBS_Project__c WHERE ID IN :projName];

      if(gtList != null && gtList.size() > 0){
          for(PBS_Small_Projects_Historical_Database__c gRec:gtList){
              String iprojName = gRec.PBS_Project_Name__c;
              String irecName = gRec.Name;
              System.debug('iprojName=' + iprojName);
              gtMap.put(iprojName, irecName);
          }
      }

      if(gtList2 != null && gtList2.size() > 0){
          for(PBS_Project__c gRec2:gtList2){
              String iprojName2 = gRec2.ID;
              String iscopeDesc2 = gRec2.txtProjectDescription__c;
              System.debug('iprojName2=' + iprojName2);
              gtMap2.put(iprojName2, iscopeDesc2);
          }
      }

      for(PBS_Small_Projects_Historical_Database__c sphd: (PBS_Small_Projects_Historical_Database__c[]) newItems){
          String jrecName = gtMap.get(sphd.PBS_Project_Name__c);
          sphd.Scope_Description__c = gtMap2.get(sphd.PBS_Project_Name__c);
          If (jrecName != null) {
              sphd.addError('This ePM Project Name has already been selected as part of SPHD Salesforce Record ID ' + jrecName + '. Please select another ePM Project Name');
          }
      }
      repopulateBuildings(newItems);
    } catch (Exception e) {
      System.debug('The following exception has occurred: ' + e.getMessage());
    }
  }

  public void BeforeUpdate(Map<Id, sObject> newItems, Map<Id, sObject> oldItems) {
    Set<ID> projName = new Set<ID>();
    List<PBS_Small_Projects_Historical_Database__c> lstAffRecs = new List<PBS_Small_Projects_Historical_Database__c>();
    map<String,String> gtMap =new map<String,String>();
    map<String,String> gtMap2 =new map<String,String>();

    try {
        for(PBS_Small_Projects_Historical_Database__c obj: (PBS_Small_Projects_Historical_Database__c[]) newItems.values()){
            if (obj.PBS_Project_Name__c <> ((PBS_Small_Projects_Historical_Database__c)oldItems.get(obj.ID)).PBS_Project_Name__c){
                projName.add(obj.PBS_Project_Name__c);
                lstAffRecs.add(obj);
            }
        }

        if(projName != null && projName.size() > 0){
            List<PBS_Small_Projects_Historical_Database__c> gtList = [SELECT PBS_Project_Name__c, Name
                                                                    FROM PBS_Small_Projects_Historical_Database__c
                                                                    WHERE PBS_Project_Name__c IN :projName];

            List<PBS_Project__c> gtList2 = [SELECT ID, txtProjectDescription__c FROM PBS_Project__c WHERE ID IN :projName];

            if(gtList != null && gtList.size() > 0){
                for(PBS_Small_Projects_Historical_Database__c gRec:gtList){
                    String iprojName = gRec.PBS_Project_Name__c;
                    String irecName = gRec.Name;
                    System.debug('iprojName=' + iprojName);
                    gtMap.put(iprojName, irecName);
                }
            }

            if(gtList2 != null && gtList2.size() > 0){
                for(PBS_Project__c gRec2:gtList2){
                    String iprojName2 = gRec2.ID;
                    String iscopeDesc2 = gRec2.txtProjectDescription__c;
                    System.debug('iprojName2=' + iprojName2);
                    gtMap2.put(iprojName2, iscopeDesc2);
                }
            }

            for(PBS_Small_Projects_Historical_Database__c sphd:lstAffRecs){
                String jrecName = gtMap.get(sphd.PBS_Project_Name__c);
                sphd.Scope_Description__c = gtMap2.get(sphd.PBS_Project_Name__c);
                If (jrecName != null) {
                    sphd.addError('This ePM Project Name has already been selected as part of SPHD Salesforce Record ID ' + jrecName + '. Please select another ePM Project Name');
                }
            }
        }
        repopulateBuildings(newItems.values());
    } catch (Exception e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
  }

  public void BeforeDelete(Map<Id, sObject> oldItems) {}

  public void AfterInsert(Map<Id, sObject> newItems) {}

  public void AfterUpdate(Map<Id, sObject> newItems, Map<Id, sObject> oldItems) { }

  public void AfterDelete(Map<Id,sObject> oldItems) {}

  public void AfterUndelete(Map<Id, sObject> oldItems) {}

  public Boolean IsDisabled() {
    Trigger_Settings__mdt triggerMeta = new Trigger_Settings__mdt();
    Boolean isTriggerActive = false;

    try {
      triggerMeta = [SELECT DeveloperName, isActive__c, ObjectName__c, Recursion_Check__c, Max_Loop_Count__c
                     FROM Trigger_Settings__mdt
                     WHERE DeveloperName='SPHD' LIMIT 1];
      isTriggerActive = triggerMeta.isActive__c;
    } catch (Exception e) {
      isTriggerActive = true;
    }

    return !isTriggerActive;
  }

  void repopulateBuildings(final PBS_Small_Projects_Historical_Database__c[] records) {
    final Set<Id> projectIds = new Set<Id>();
    final Map<Id, String> projectToBuildings = new Map<Id, String>();

    for (PBS_Small_Projects_Historical_Database__c record: records) {
      projectIds.add(record.PBS_Project_Name__c);
    }

    for (PBS_Project__c project: [SELECT (SELECT rluBuilding__r.Location_Code_Plus__c
                                          FROM PBS_Building_Project_Associations__r)
                                  FROM PBS_Project__c
                                  WHERE Id IN :projectIds]) {
      String buildings = '';
      for (Integer i = 0; i < project.PBS_Building_Project_Associations__r.size(); i++) {
        final String locationCodePlus = project.PBS_Building_Project_Associations__r[i].rluBuilding__r.Location_Code_Plus__c;

        if (!String.isBlank(locationCodePlus) && !buildings.contains(locationCodePlus)) {
          if (i > 0) {
            buildings += ', ';
          }

          buildings += locationCodePlus;
        }
      }

      projectToBuildings.put(project.Id, buildings);
    }

    for (PBS_Small_Projects_Historical_Database__c record: records) {
      record.Building_Number__c = projectToBuildings.get(record.PBS_Project_Name__c);
    }
  }
}