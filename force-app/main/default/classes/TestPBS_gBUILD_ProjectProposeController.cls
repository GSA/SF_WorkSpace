@isTest(SeeAllData=false)
public class TestPBS_gBUILD_ProjectProposeController
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

        PBS_gBUILD_ProjectProposeController ctrl = new PBS_gBUILD_ProjectProposeController();
        system.assert(ctrl!=null);
        ctrl.pbsProj.txtLongName__c='Toyland';
        ctrl.pbsProj.txtRegion__c='09';
        ctrl.pbsProj.txtCreatedIn__c=PBS_gBUILD_Utility.commonProjCreatorGbuild;
        ctrl.pbsProj.txtCurrentState__c='Active';        
        ctrl.create();

        PBS_gBUILD_Project__c[] postProjs = [select id from PBS_gBUILD_Project__c limit 900];
        system.assertEquals(preProjs.size()+1, postProjs.size());
        ctrl.cancel();
    }
}