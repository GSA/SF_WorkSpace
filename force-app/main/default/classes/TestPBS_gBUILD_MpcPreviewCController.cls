@istest
public class TestPBS_gBUILD_MpcPreviewCController
{
   /* public static testMethod void testPlaceholder()
    {  
        system.assert(true);  
    }  
    */


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
                mpc.Status__c = 'Planned but not started ';
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
            Comments__c = 'The Current one',
            Status__c = 'Planned but not started'
        );
        insert mpcCurrent;
    }

    public static testMethod void testPreviewController()
    {
        
        List<PBS_gBUILD_PBuildingMPCUpdate__c> mus = new List<PBS_gBUILD_PBuildingMPCUpdate__c>();  
        boolean showExistingMpcUpdates = false;
        if(mus!=null && mus.size()>0){
            showExistingMpcUpdates = true;
        }
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);
        PBS_gBUILD_PBuildingMPCUpdate__c mpc = new PBS_gBUILD_PBuildingMPCUpdate__c();
        mpc.recordtypeid = PBS_gBUILD_Utility.mpcUpdateRecordTypeIdDR;
        mpc.Rahd_ProjectBldgParentId__c = pb.id;
        mpc.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(9);
        
       // mpc.RecordType.DeveloperName='MPC';
        insert mpc;

        PBS_gBUILD_PBuildingMpcController ctrl = new PBS_gBUILD_PBuildingMpcController();

        PBS_gBUILD_MpcPreviewCController q;
        q = new PBS_gBUILD_MpcPreviewCController();
        q.mus = new List<PBS_gBUILD_PBuildingMPCUpdate__c> ();
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
        q.num=1;
         PBS_gBUILD_PBuildingMPCUpdate__c mpcCurrent = new PBS_gBUILD_PBuildingMPCUpdate__c
        (
            recordtypeid = PBS_gBUILD_Utility.mpcUpdateRecordTypeIdMPC,
            Rahd_ProjectBldgParentId__c = ctrl.pbuildingId,
            Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(1),
            Comments__c = 'The Current one',
            Status__c = 'Planned but not started'
        );
        insert mpcCurrent;
        
        List<PBS_gBUILD_PBuildingMPCUpdate__c> showMPCUpdate = [SELECT Id, Name,RecordType.DeveloperName, Status__c, Comments__c, CreatedDate,Question__c  FROM PBS_gBUILD_PBuildingMPCUpdate__c WHERE Question__c = :mpcCurrent.Question__c AND Rahd_ProjectBldgParentId__c = :ctrl.pbuildingId ORDER BY CreatedDate DESC LIMIT 1];
        if(!showMPCUpdate.isEmpty()){           
                 q.mpcEdit.Status__c = showMPCUpdate[0].Status__c;
                 q.mpcEdit.Comments__c = showMPCUpdate[0].Comments__c;
            }
            q.edit();
        ctrl.edit();
        ctrl.cancel(); //thus forcing a bind
        system.assertEquals(null, q.mus);
        system.assertEquals(ctrl.pbuildingId, q.pbuildingId);
        
        q.drEdit.DesignReviewStatus__c = 'okie';
        q.mpcEdit.Status__c = 'dokie';
        q.flag = false;
        //q.showExistingMpcUpdates = true;
        q.isDesignReviewer = true;
        q.mpcEdit.Comments__c = 'The Current one';
        
        q.save();
        q.actionid='123';
        if(q.mpcEdit.Status__c!=null){
         List<String> previousValuesList = new List<String>();
         previousValuesList.add('dokie 1');
         previousValuesList.add('The Current one 1');
         q.mpcEdit.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(9);
         String keyVal1 = ctrl.pbuildingId +PBS_gBUILD_Utility.convertNumToMpcQuestion(9)+'MPC';
         String keyVal2 = ctrl.pbuildingId +PBS_gBUILD_Utility.convertNumToMpcQuestion(1)+'MPC';
         String keyVal3 = ctrl.pbuildingId +PBS_gBUILD_Utility.convertNumToMpcQuestion(3)+'MPC';
        q.previousValuesMap.put(keyVal1,previousValuesList);
        q.previousValuesMap.put(keyVal2,previousValuesList);
        q.previousValuesMap.put(keyVal3,previousValuesList);
         q.save();
        q.actionid='123';
        }
        //q.flag = true;
           //added here
           
        List<String> previousValuesList = new List<String>();
        //previousValuesList1 = previousValuesList; 
         previousValuesList.add('dokie 2');
         previousValuesList.add('The Current one 2');
         q.mpcEdit.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(9);
         String keyVal1 = ctrl.pbuildingId +PBS_gBUILD_Utility.convertNumToMpcQuestion(9)+'MPC';
         String keyVal2 = ctrl.pbuildingId +PBS_gBUILD_Utility.convertNumToMpcQuestion(1)+'MPC';
         String keyVal3 = ctrl.pbuildingId +PBS_gBUILD_Utility.convertNumToMpcQuestion(3)+'MPC'; 
        q.previousValuesMap.put(keyVal1,previousValuesList);
        q.previousValuesMap.put(keyVal2,previousValuesList);
        q.previousValuesMap.put(keyVal3,previousValuesList);
         q.save();
        q.actionid='123';
        q.flag = true;
        
        PBS_gBUILD_MpcPreviewCController q1 = new PBS_gBUILD_MpcPreviewCController();
        q1.num=34;
        q1.drEdit.DesignReviewStatus__c = 'okie 12';
        q1.mpcEdit.Status__c = 'dokie 12';
        q1.mpcEdit.Comments__c = 'The Current one 12';
        q1.flag = true;
        q1.pageController = ctrl;
        q1.save();
        q1.actionid='123';
        
        //till here     
        
        system.assert(q.open()!=null);
    }
    
  /*
    public static testMethod void testMpcPreview()
    {
        PBS_Project__c testMPro = new PBS_Project__c();
        insert testMPro;
        PBS_gBUILD_Project__c testPro = new PBS_gBUILD_Project__c (Projectid__c=testMPro.id);
        //testPro.MachineName__c='testmachine';
        testPro.StateNameCurrent__c='testState';
        insert testPro;
        PBS_Building__c testPB = new PBS_Building__c (Building_ID__c=1111, Location_Code_Plus__c='abcd');
        insert testPB;
        PBS_gBUILD_ProjectBuilding__c testB = new PBS_gBUILD_ProjectBuilding__c ( Rahd_ProjectParentId__c=testPro.id, BldgId__c=testpb.id);
        insert testB;
        PBS_gBUILD_MpcPreviewCController con= new PBS_gBUILD_MpcPreviewCController ();
        con.viewmode=true;
        con.save();
        con.num=0;
        con.mpcEdit=new PBS_gBUILD_PBuildingMPCUpdate__c();
        con.drEdit=new PBS_gBUILD_PBuildingMPCUpdate__c();
        // con.onRegistered();
        con.drEdit.DesignReviewStatus__c='test';
        //  con.drEdit.Question__c='test';
        con.isDesignReviewer=false;
        con.drEdit.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(con.num);
        con.drEdit.Rahd_ProjectBldgParentId__c = testb.id;
        //con.drEdit.MpcUpdateRecordTypeId__c = PBS_gBUILD_Utility.mpcUpdateDrRecordType;
        con.drEdit.RecordTypeId = PBS_gBUILD_Utility.mpcUpdateDrRecordType;
        // insert con.drEdit;


        con.mpcEdit.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(con.num);
        con.mpcEdit.Rahd_ProjectBldgParentId__c = testb.id;
        //con.mpcEdit.MpcUpdateRecordTypeId__c = PBS_gBUILD_Utility.mpcUpdateMpcRecordType;
        con.mpcEdit.MpcUpdateRecordTypeId = PBS_gBUILD_Utility.mpcUpdateMpcRecordType
        // insert con.mpcEdit;
        //con.save();
        //con.drEdit.DesignReviewStatus__c=null;
        //con.mpcEdit.Status__c='test';
        //system.assert(con.mpcEdit.status__c!=null);
        //con.save();
        //boolean ff=con.editMode;

        //PageReference pr = con.open();
        //system.assert(pr!=null);
    }
    */
 
    
}