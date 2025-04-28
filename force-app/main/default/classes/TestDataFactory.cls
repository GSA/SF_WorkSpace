public abstract class TestDataFactory {
  @testVisible static sObject[] testRecords = new sObject[]{};
  @testVisible static Integer TEST_CASES = 1;

  // The basic, required fields needed to perform DML on a User:
  @testVisible static User getBasicUser() {
    return new User();
  }

  @testVisible static PBS_Project__c getBasicProject() {
    return new PBS_Project__c();
  }

  @testVisible static PBS_Building__c getBasicBuilding(final Decimal buildingId, final String locationCodePlus) {
    return new PBS_Building__c(Building_ID__c = buildingId,
                               Location_Code_Plus__c = locationCodePlus);
  }

  @testVisible static PBS_BuildingProjectAssociation__c getBasicBPA() {
    return new PBS_BuildingProjectAssociation__c();
  }

  @testVisible static PBS_Small_Projects_Historical_Database__c getBasicSPHD() {
    return new PBS_Small_Projects_Historical_Database__c();
  }
}