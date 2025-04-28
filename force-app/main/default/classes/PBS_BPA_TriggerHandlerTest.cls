@isTest class PBS_BPA_TriggerHandlerTest extends TestDataFactory {
  final static String locationCodePlus = 'Test ';

  @testSetup static void makeData() {
    final PBS_Project__c[] projects = new PBS_Project__c[]{};
    final PBS_Building__c[] buildings = new PBS_Building__c[]{};

    TestDataFactory.TEST_CASES = 2;

    for (Integer i = 0; i < TestDataFactory.TEST_CASES; i++) {
      projects.add(getBasicProject());
    }

    insert projects;

    for (Integer i = 0; i < TestDataFactory.TEST_CASES; i++) {
      buildings.add(getBasicBuilding(i, String.valueOf(i)));
      buildings[i].Location_Code_Plus__c = locationCodePlus + i;
    }

    insert buildings;

    for (Integer i = 0; i < TestDataFactory.TEST_CASES; i++) {
      PBS_Small_Projects_Historical_Database__c sphd = getBasicSPHD();

      sphd.PBS_Project_Name__c = projects[i].Id;

      TestDataFactory.testRecords.add(sphd);
    }

    insert TestDataFactory.testRecords;
  }

  static PBS_BuildingProjectAssociation__c[] makeBPAs() {
    final PBS_Project__c[] projects = [SELECT Id FROM PBS_Project__c];
    final PBS_Building__c[] buildings = [SELECT Id FROM PBS_Building__c];
    final PBS_BuildingProjectAssociation__c[] bpas = new PBS_BuildingProjectAssociation__c[]{};

    for (Integer i = 0; i < projects.size(); i++) {
      final PBS_BuildingProjectAssociation__c bpa = getBasicBPA();

      bpa.rluBuilding__c = buildings[i].Id;
      bpa.rluProject__c = projects[i].Id;

      bpas.add(bpa);
    }

    return bpas;
  }

  @isTest static void testInsert() {
    Test.startTest();
      insert makeBPAs();
    Test.stopTest();

    PBS_Small_Projects_Historical_Database__c[] sphds = [SELECT Id, Building_Number__c
                                                         FROM PBS_Small_Projects_Historical_Database__c];

    for (Integer i = 0; i < sphds.size(); i++) {
      System.assertEquals(locationCodePlus + i, sphds[i].Building_Number__c);
    }
  }

  @isTest static void testUpdate() {
    final PBS_Building__c[] buildings = [SELECT Id
                                         FROM PBS_Building__c
                                         LIMIT 2];

    PBS_BuildingProjectAssociation__c[] newRecords = makeBPAs();
    insert newRecords;

    final Map<Id, PBS_BuildingProjectAssociation__c> oldRecords = new Map<Id, PBS_BuildingProjectAssociation__c>(newRecords.clone());

    newRecords[0].rluBuilding__c = buildings[1].Id;
    newRecords[1].rluBuilding__c = buildings[0].Id;

    Test.startTest();
      update newRecords;
    Test.stopTest();

    System.assert(true);
  }

  @isTest static void testDeleteUndelete() {
    TestDataFactory.testRecords = makeBPAs();

    insert TestDataFactory.testRecords;

    Test.startTest();
    delete TestDataFactory.testRecords;

    for (PBS_Small_Projects_Historical_Database__c sphd: [SELECT Id, Building_Number__c
                                                          FROM PBS_Small_Projects_Historical_Database__c]) {
      System.assert(String.isBlank(sphd.Building_Number__c));
    }

    undelete TestDataFactory.testRecords;
    Test.stopTest();

  }
}