@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBuildingScopeController
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

        PBS_gBUILD_PBuildingScopeController ctrl = new PBS_gBUILD_PBuildingScopeController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assertEquals(0, ctrl.scopeSystems.size());

        SelectOption opt;
        opt = ctrl.scopeOptionsLevel1rendered[0];
        ctrl.scopeOptionLevel1Val = opt.getValue();
        ctrl.clickLevel1();
        opt = ctrl.scopeOptionsLevel2rendered[0];
        ctrl.scopeOptionLevel2Val = opt.getValue();
        ctrl.clickLevel2();        
        PBS_gBUILD_PBuildingScopeController.Item item = ctrl.scopeOptionsLevel3rendered[0];
        ctrl.scopeOptionLevel3Val = item.value;
        ctrl.clickLevel3();
        system.assertEquals(1, ctrl.scopeSystems.size());

        ctrl.selectedScopeSystemId = ctrl.scopeSystems[0].scopesystem.id;
        ctrl.open();
    }

}