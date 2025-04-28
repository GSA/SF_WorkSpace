@isTest(SeeAllData=false)
public class TestPBS_gBUILD_UtilitySavingsController
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
        string usId = [select ActualUtilitySav__c from PBS_gBUILD_ProjectBuilding__c where id=:pb.id].ActualUtilitySav__c;

        PageReference pr = TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);
        pr.getParameters().put(PBS_gBUILD_Utility.queryStringUtilitySavingsContext, 'All Savings');
        pr.getParameters().put(PBS_gBUILD_Utility.queryStringUtilitySavingsId, usId);
        Test.setCurrentPageReference(pr);

        PBS_gBUILD_UtilitySavingsController ctrl = new PBS_gBUILD_UtilitySavingsController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assertEquals('All Savings', ctrl.contextName);
        system.assertEquals(usId, ctrl.itemId);
        system.assert(ctrl.item!=null);
        system.assertEquals(usId, ctrl.item.id);

        ctrl.edit();
        ctrl.save();
        ctrl.cancel();
    }
}