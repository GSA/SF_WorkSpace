@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBCloseoutController
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

        PBS_gBUILD_PBuildingCloseoutController ctrl = new PBS_gBUILD_PBuildingCloseoutController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);

        ctrl.edit();
        ctrl.cancel();
        ctrl.edit();
        ctrl.save();
    }
}