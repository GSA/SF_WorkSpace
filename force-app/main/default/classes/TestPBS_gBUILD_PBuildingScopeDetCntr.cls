@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBuildingScopeDetCntr
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
        PBS_gBUILD_PBuildingScopeSystem__c ss = new PBS_gBUILD_PBuildingScopeSystem__c(Rahd_ProjectBldgParentId__c=pb.id, RecordTypeId=TestPBS_gBUILD_Utility.getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c', 'R_NewReplacement'));
        insert ss;

        List<Cookie> cookies = TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id).getCookies().values();
        PageReference pr;
        PBS_gBUILD_PBuildingScopeDetController ctrl;

        test.startTest();

        pr = PBS_gBUILD_Utility.getScopeSystemDetailsPageRef(ss.id, '', 'R_NewReplacement', true);
        pr.setCookies(cookies);
        Test.setCurrentPageReference(pr);
        ctrl = new PBS_gBUILD_PBuildingScopeDetController();
        ctrl.edit();
        ctrl.cancel();

        pr = PBS_gBUILD_Utility.getScopeSystemDetailsPageRef(ss.id, '', 'R_NewReplacement', true);
        pr.setCookies(cookies);
        Test.setCurrentPageReference(pr);
        ctrl = new PBS_gBUILD_PBuildingScopeDetController();
        system.assert(ctrl!=null);
        system.assert(ctrl.ssd!=null);
        system.assertEquals(null, ctrl.ssd.id);
        system.assert(ctrl.ssd.Rahd_ScopeSysParentId__c!=null);
        system.assert(ctrl.projectId!=null);
        system.assert(ctrl.pbuildingId!=null);
        ctrl.saveAndNew();
        system.assert(ctrl.ssd.id!=null);

        pr = PBS_gBUILD_Utility.getScopeSystemDetailsPageRef(ss.id, ctrl.ssd.id, 'R_NewReplacement', true);
        pr.setCookies(cookies);
        Test.setCurrentPageReference(pr);
        ctrl = new PBS_gBUILD_PBuildingScopeDetController();
        system.assert(ctrl.ssd.id!=null);
        ctrl.save();
       
        test.stopTest();
    }
}