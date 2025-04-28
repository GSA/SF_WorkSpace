@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PCreateGbuildController
{
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    public static testMethod void testConstructor()
    {
        PBS_gBUILD_Project__c[] preProjs = [select id from PBS_gBUILD_Project__c limit 900];

        PBS_gBUILD_ProjectCreateGbuildController ctrl = new PBS_gBUILD_ProjectCreateGbuildController();
        system.assert(ctrl!=null);
        ctrl.pbsProj.txtLongName__c='Toyland';
        ctrl.pbsProj.txtRegion__c='05';
        ctrl.pbsProj.txtCreatedIn__c=PBS_gBUILD_Utility.commonProjCreatorGbuild;
        ctrl.pbsProj.txtCurrentState__c='Cancelled';
                
        system.assert(ctrl.create()!=null);

        PBS_gBUILD_Project__c[] postProjs = [select id from PBS_gBUILD_Project__c limit 900];
        system.assertEquals(preProjs.size()+1, postProjs.size());
        ctrl.cancel();
    }
}