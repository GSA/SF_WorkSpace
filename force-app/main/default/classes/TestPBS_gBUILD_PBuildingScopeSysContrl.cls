@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBuildingScopeSysContrl
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
        PBS_gBUILD_PBuildingScopeSystemDetail__c ssd = new PBS_gBUILD_PBuildingScopeSystemDetail__c(Rahd_ScopeSysParentId__c=ss.id, RecordTypeId=TestPBS_gBUILD_Utility.getRecordTypeId('PBS_gBUILD_PBuildingScopeSystemDetail__c', 'Other_ChilledWaterHotH2OAndSteamDistSys'));
        insert ssd;

        test.startTest();
        
        PageReference pr = TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);
        pr.getParameters().put(PBS_gBUILD_Utility.queryStringRecordTypeId, TestPBS_gBUILD_Utility.acScopeL3.Name);
        pr.getParameters().put(PBS_gBUILD_Utility.queryStringScopeSystemId, ss.id);
        Test.setCurrentPageReference(pr);

        PBS_gBUILD_PBuildingScopeSysController ctrl = new PBS_gBUILD_PBuildingScopeSysController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assertEquals(pb.id, ctrl.scopeSystem.Rahd_ProjectBldgParentId__c);

        system.assertEquals(1, ctrl.systemInfos.size());

        system.assert(ctrl.newSystem()!=null);
        ctrl.paramSystemInfoId = ssd.id;
        system.assert(ctrl.openSystem()!=null);
        ctrl.deleteSystem();

        ctrl.cancel();
        ctrl.edit();
        ctrl.descope();
        ctrl.save();
        
        test.stopTest();
    }
}