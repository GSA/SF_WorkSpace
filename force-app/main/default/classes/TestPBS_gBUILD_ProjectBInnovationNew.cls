@isTest(SeeAllData=false)
public class TestPBS_gBUILD_ProjectBInnovationNew
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

        PBS_gBUILD_PBInnovationNew ctrl = new PBS_gBUILD_PBInnovationNew();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assertEquals(null, ctrl.item.id);
        system.assertEquals(pb.id, ctrl.item.Rahd_ProjectBldgParentId__c);

        ctrl.saveAndNew();
        system.assert(ctrl.item.id!=null);

        ctrl.edit();
        ctrl.cancel();
    }

    public static testMethod void testLoadingAnExistingItem()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        PBS_gBUILD_PBuildingInnovation__c item = new PBS_gBUILD_PBuildingInnovation__c(Rahd_ProjectBldgParentId__c=pb.id);
        insert item;
        PageReference pr = TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);
        pr.getParameters().put(PBS_gBUILD_Utility.queryStringPInnovationId, item.id);
        Test.setCurrentPageReference(pr);
        PBS_gBUILD_PBInnovationNew ctrl = new PBS_gBUILD_PBInnovationNew();
        system.assert(ctrl.item!=null);
    }
}