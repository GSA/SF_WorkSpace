@isTest(SeeAllData=false)
public class TestPBS_gBUILD_ProjectWorkflowController
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

        PBS_gBUILD_ProjectWorkflowController ctrl;
        
        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        ctrl = new PBS_gBUILD_ProjectWorkflowController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);                      
        system.assertEquals(0,  ctrl.history.size());
        ctrl.approve();
 
        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        ctrl = new PBS_gBUILD_ProjectWorkflowController();
        system.assertEquals(null, ctrl.edit());

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        ctrl = new PBS_gBUILD_ProjectWorkflowController();
        system.assertEquals(null, ctrl.cancel());
    }   

    public static testMethod void testTransition()
    {
        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();

        PBS_gBUILD_Project__Share s = new PBS_gBUILD_Project__Share();
        s.UserOrGroupId = UserInfo.getUserId();
        s.ParentId = p.id;
        s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleDataEntry__c;
        s.AccessLevel = 'Edit';
        insert s;    

        PBS_gBUILD_ProjectWorkflowController ctrl;

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        ctrl = new PBS_gBUILD_ProjectWorkflowController();
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        ctrl.selectedTransition = TestPBS_gBUILD_Utility.acWfTrans.id;
        ctrl.save();

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        ctrl = new PBS_gBUILD_ProjectWorkflowController();
        ctrl.forcedStateNameNext = TestPBS_gBUILD_Utility.acWfStateSmall.id;
        ctrl.save();
    }       
}