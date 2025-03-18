@isTest
public class NCMT_TCOBuildingCostsPerYear_LC_Test {
    @testSetup static void setup()
    {
       

        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff1','Virginia','State Average'
            ,'Lowrise (2 - 3 stories)', true, false, false, 1000000, true, false, false, false, false);
       
    }



    static testMethod void testReport(){
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];

        ApexPages.StandardController controller = new ApexPages.StandardController(proj);
        NCMT_TCOBuildingCostsPerYear_LC ctrl = new NCMT_TCOBuildingCostsPerYear_LC(controller);
        NCMT_TCO_Project tcoProj = NCMT_TCOBuildingCostsPerYear_LC.projectData(proj.Id);

        System.assert(tcoProj.record != null);
    }
}