@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PFundingSourcesController
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
		PBS_Project__c pbs = [select id, txtCurrentState__c from PBS_Project__c where id=:p.ProjectId__c];
        pbs.txtCurrentState__c=PBS_gBUILD_Utility.projectStateFormative;
        update pbs;
		
        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);

        PBS_gBUILD_PFundingSourcesController ctrl = new PBS_gBUILD_PFundingSourcesController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assertEquals(true, ctrl.viewMode);
        system.assertEquals(false, ctrl.editMode);
        system.assertEquals(0, ctrl.items.size());
        system.assert(ctrl.isProjectFormative);


        PBS_gBUILD_ProjectFunding__c item = new PBS_gBUILD_ProjectFunding__c ( ProjectId__c = p.id );
        insert item;
        ctrl = new PBS_gBUILD_PFundingSourcesController();        
        system.assertEquals(1, ctrl.items.size());
        ctrl.actionId = item.id;
        system.assert(ctrl.del()!=null);
        system.assert(ctrl.add()!=null);
        system.assert(ctrl.open()!=null);
    }
}