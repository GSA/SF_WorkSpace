@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PFundingItemController
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

        PageReference pr=TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);

        PBS_gBUILD_PFundingItemController ctrl = new PBS_gBUILD_PFundingItemController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assert(ctrl.item!=null);

        ctrl.save();
        PBS_gBUILD_ProjectFunding__c[] afterItems = [select id, ProjectId__c from PBS_gBUILD_ProjectFunding__c limit 900];
        system.assertEquals(1, afterItems.size());
        system.assertEquals(p.id, afterItems[0].ProjectId__c);

        ctrl.saveAndNew();
        ctrl.cancel();
        ctrl.edit();
        
        //Force the error path to get run
        delete p;
        ctrl.save();
        
        
        pr.getParameters().put(PBS_gBUILD_Utility.queryStringPFundingId,string.valueof(ctrl.item.id));
        Test.setCurrentPageReference(pr);
        ctrl = new PBS_gBUILD_PFundingItemController();
    }
}