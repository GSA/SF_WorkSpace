@isTest(SeeAllData=false)
public class TestPBS_gBUILD_MpcWaiversCController
{  
    static 
    {
        TestPBS_gBUILD_Utility.setup();
    }

    public static testMethod void testConstructor()
    {
        PBS_gBUILD_MpcWaiversCController ctrl = new PBS_gBUILD_MpcWaiversCController();
        system.assert(ctrl!=null);
        ctrl.viewMode = true;
        system.assertEquals(false, ctrl.editMode);
        ctrl.viewMode = false;
        system.assertEquals(true, ctrl.editMode);
        ctrl.mpcNum = 1;
        system.assert(ctrl.ctitle!=null);
        system.assertEquals(PBS_gBUILD_Utility.epmCatalogExecution, ctrl.epmCatalog);
    } 
}