@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBuildingComplianceCntr
{  
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    public static testMethod void testConstructor()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingComplianceController ctrl = new PBS_gBUILD_PBuildingComplianceController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assert(ctrl.items.size()>0);

        ctrl.selectedNum = 1;
        system.assert(ctrl.open()!=null);
        ctrl.edit();
    }
}