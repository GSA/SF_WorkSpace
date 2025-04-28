@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBuildingMpcController
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

        List<PBS_gBUILD_PBuildingMPCUpdate__c> mpcs = new List<PBS_gBUILD_PBuildingMPCUpdate__c>();
        for (string recordTypeId : new string[]{PBS_gBUILD_Utility.mpcUpdateRecordTypeIdDR, PBS_gBUILD_Utility.mpcUpdateRecordTypeIdMPC})
        {
            for (integer n=0;n<5;++n)
            {
                PBS_gBUILD_PBuildingMPCUpdate__c mpc = new PBS_gBUILD_PBuildingMPCUpdate__c();
                mpc.recordtypeid = recordTypeId;
                mpc.Rahd_ProjectBldgParentId__c = pb.id;
                mpc.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(n);
                mpc.Comments__c = string.format('auto generated comment for {0}', new string[]{n.format()});
                mpcs.add(mpc);
            }
        }
        insert mpcs;

        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingMpcController ctrl = new PBS_gBUILD_PBuildingMpcController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assertEquals(5, ctrl.mpcStatusByNum.size());
        system.assertEquals(5, ctrl.mpcDrByNum.size());

        ctrl.save();
        ctrl.edit();
        ctrl.cancel();

        //testing the trigger case where we must toggle a current mpc to a not current mpc
        PBS_gBUILD_PBuildingMPCUpdate__c mpcCurrent = new PBS_gBUILD_PBuildingMPCUpdate__c
        (
            recordtypeid = PBS_gBUILD_Utility.mpcUpdateRecordTypeIdMPC,
            Rahd_ProjectBldgParentId__c = pb.id,
            Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(1),
            Comments__c = 'The Current one'
        );
        insert mpcCurrent;
    }

    public static testMethod void testPreviewController()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);
        PBS_gBUILD_PBuildingMPCUpdate__c mpc = new PBS_gBUILD_PBuildingMPCUpdate__c();
        mpc.recordtypeid = PBS_gBUILD_Utility.mpcUpdateRecordTypeIdDR;
        mpc.Rahd_ProjectBldgParentId__c = pb.id;
        mpc.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(9);
        insert mpc;

        PBS_gBUILD_PBuildingMpcController ctrl = new PBS_gBUILD_PBuildingMpcController();

        PBS_gBUILD_MpcPreviewCController q;

        q = new PBS_gBUILD_MpcPreviewCController();
        q.viewMode = false;
        q.pageController = ctrl;
        q.key = 'mpcPreview9';
        ctrl.cancel(); //thus forcing a bind
        system.assertEquals(1, q.mus.size());        
        system.assertEquals(ctrl.pbuildingId, q.pbuildingId);        
        q.save();

        q = new PBS_gBUILD_MpcPreviewCController();
        q.viewMode = false;
        q.pageController = ctrl;
        q.key = 'mpcPreview10';
        ctrl.edit();
        ctrl.cancel(); //thus forcing a bind
        system.assertEquals(null, q.mus);
        system.assertEquals(ctrl.pbuildingId, q.pbuildingId);
        q.drEdit.DesignReviewStatus__c = 'okie';
        q.mpcEdit.Status__c = 'dokie';
        q.save();
        q.actionid='123';
        system.assert(q.open()!=null);
    }
    
    public static testMethod void testInstructionsCController()
    {
        PBS_gBUILD_MpcInstructionsCController i = new PBS_gBUILD_MpcInstructionsCController();
        string s;
        i.mpcNum = 1;
        i.projType = PBS_gBUILD_Utility.projectTypePartialModernizations;
        s = i.instructions;
        i.projType = PBS_gBUILD_Utility.projectTypeNewConstruction;
        s = i.instructions;
        i.mpcNum = -1;
        system.assert(i.instructions.startsWith('No instructions'));
    }    
}