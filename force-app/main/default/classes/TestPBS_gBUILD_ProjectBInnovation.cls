@isTest(SeeAllData=false)
public class TestPBS_gBUILD_ProjectBInnovation
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

        PBS_gBUILD_PBuildingInnovation__c i = new PBS_gBUILD_PBuildingInnovation__c(Rahd_ProjectBldgParentId__c=pb.id);
        insert i;

        PBS_gBUILD_PBuildingInnovationController ctrl = new PBS_gBUILD_PBuildingInnovationController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assert(ctrl.items.size()>0);

        system.assert(ctrl.add()!=null);
                                     
        ctrl.actionid=i.id;
        ctrl.open();
        ctrl.del();
    }
}