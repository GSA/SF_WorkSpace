@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBuildingBasicsController
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

        PBS_gBUILD_PBuildingBasicsController ctrl = new PBS_gBUILD_PBuildingBasicsController();
        ctrl.openProject();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assert(ctrl.projectAssociations.size()>0);
    }

    public static testMethod void testConstructorError()
    {
        PageReference pr = new PageReference('/TEST');
        Test.setCurrentPageReference(pr);
        try
        {
            PBS_gBUILD_PBuildingBasicsController ctrl = new PBS_gBUILD_PBuildingBasicsController();
            system.assert(!ctrl.showPageContent);
        }
        catch (exception ex)
        {
            system.assert(true);
        }
    }
}