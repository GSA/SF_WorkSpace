@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBManageController
{  
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    public static testMethod void testConstructor()
    {
        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);

        PBS_gBUILD_PBuildingsManageController ctrl = new PBS_gBUILD_PBuildingsManageController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        
        ctrl.syncPBuildings();

        ctrl.nextPage();
        ctrl.prevPage();
        ctrl.resortVal = 'Building_Name__c';
        ctrl.resort();
        ctrl.resort();
        ctrl.resortVal = 'City__c';
        ctrl.resort();
        ctrl.filterExpr = 'fdsfkljads';
        ctrl.filter();
        system.assertEquals(0, ctrl.buildings.size());
        ctrl.paramBuildingId = '34254264';
        system.assert(ctrl.openLinkedBuilding()!=null);
        system.assert(ctrl.openUnlinkedBuilding()!=null);

        if (ctrl.buildings.size()>0)
        {
            ctrl.paramBuildingId = ctrl.buildings[0].id;
            ctrl.link();
        }
        if (ctrl.linkedBuildings.size()>0)
        {
            ctrl.paramPbaId = ctrl.linkedBuildings[0].pbaId;
            ctrl.unlink();
            ctrl = new PBS_gBUILD_PBuildingsManageController();
        }
        if (ctrl.buildings.size()>0)
        {
            ctrl.paramBuildingId = ctrl.buildings[0].id;
            ctrl.link();
        }
    }
}