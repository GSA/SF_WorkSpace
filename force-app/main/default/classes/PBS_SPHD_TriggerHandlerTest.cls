@isTest
public class PBS_SPHD_TriggerHandlerTest extends TestDataFactory {
  @testSetup static void makeData() {
    for (Integer i = 0; i < TestDataFactory.TEST_CASES; i++) {
      TestDataFactory.testRecords.add(getBasicSPHD());
    }

    insert TestDataFactory.testRecords;
  }

  static testMethod void TestOnBeforeInsert() {
      PBS_Project__c proj1 = new PBS_Project__c();
      PBS_Project__c proj2 = new PBS_Project__c();

      PBS_Small_Projects_Historical_Database__c sphd1 = new PBS_Small_Projects_Historical_Database__c();
      PBS_Small_Projects_Historical_Database__c sphd2 = new PBS_Small_Projects_Historical_Database__c();

      proj1.Name = 'Test 1';
      proj1.txtProjectDescription__c = 'Scope Description for Project 1';

      proj2.Name = 'Test 2';
      proj2.txtProjectDescription__c = 'Scope Description for Project 2';

      List<PBS_Project__c> prjts = new List<PBS_Project__c>();
      prjts.add(proj1);
      prjts.add(proj2);
      insert prjts;

      sphd1.PBS_Project_Name__c = proj1.ID;
      sphd1.Central_Facility_Repository_CFR__c = 'www.gsa.gov';
      sphd1.Property_Manager_User__c = UserInfo.getUserId();
      sphd1.Supervisor_User__c = UserInfo.getUserId();
      insert sphd1;

      sphd2.PBS_Project_Name__c = proj1.ID;
      sphd2.Central_Facility_Repository_CFR__c = 'www.gsa.gov';
      sphd2.Property_Manager_User__c = UserInfo.getUserId();
      sphd2.Supervisor_User__c = UserInfo.getUserId();
      try {
          insert sphd2;
      } catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
        }

    insert new PBS_BuildingProjectAssociation__c(rluProject__c = prjts[0].Id);
    insert new PBS_BuildingProjectAssociation__c(rluProject__c = prjts[1].Id);
  }

  static testMethod void TestOnBeforeUpdate(){
    PBS_Project__c proj1 = getBasicProject();
    PBS_Project__c proj2 = getBasicProject();
    PBS_Project__c proj3 = getBasicProject();

    PBS_Small_Projects_Historical_Database__c sphd1 = getBasicSPHD(); // new PBS_Small_Projects_Historical_Database__c();
    PBS_Small_Projects_Historical_Database__c sphd2 = getBasicSPHD(); // new PBS_Small_Projects_Historical_Database__c();

    proj1.Name = 'Test 1';
    proj1.txtProjectDescription__c = 'Scope Description for Project 1';

    proj2.Name = 'Test 2';
    proj2.txtProjectDescription__c = 'Scope Description for Project 2';

    proj3.Name = 'Test 3';
    proj3.txtProjectDescription__c = 'Scope Description for Project 2';

    List<PBS_Project__c> prjts = new List<PBS_Project__c>();
    prjts.add(proj1);
    prjts.add(proj2);
    prjts.add(proj3);
    insert prjts;

    sphd1.PBS_Project_Name__c = proj1.ID;
    sphd1.Central_Facility_Repository_CFR__c = 'www.gsa.gov';
    sphd1.Property_Manager_User__c = UserInfo.getUserId();
    sphd1.Supervisor_User__c = UserInfo.getUserId();
    insert sphd1;

    sphd2.PBS_Project_Name__c = proj2.ID;
    sphd2.Central_Facility_Repository_CFR__c = 'www.gsa.gov';
    sphd2.Property_Manager_User__c = UserInfo.getUserId();
    sphd2.Supervisor_User__c = UserInfo.getUserId();
    insert sphd2;

    sphd1.PBS_Project_Name__c = proj3.ID;
    update sphd1;

    sphd1.PBS_Project_Name__c = proj2.ID;
    try {
        update sphd1;
    } catch (DmlException e) {
          System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
      }
    }

  @isTest static void testOnAfterDeleteUndelete() {
    final sObject[] records = [SELECT Id
                               FROM PBS_Small_Projects_Historical_Database__c];
    Test.startTest();
      delete records;

      System.assertEquals(0, [SELECT Id
                              FROM PBS_Small_Projects_Historical_Database__c].size());

      undelete records;
    Test.stopTest();
  }
}