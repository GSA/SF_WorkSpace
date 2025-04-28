@isTest(SeeAllData=false)
public class TestPBS_gBUILD_ProjectBasicsController
{  
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    public static testMethod void testConstructorError()
    {
        PageReference pr = new PageReference('/TEST');
        Test.setCurrentPageReference(pr);
        try
        {
            PBS_gBUILD_PBuildingBasicsController ctrl = new PBS_gBUILD_PBuildingBasicsController();
            system.assert(!ctrl.showPageContent);
        }
        catch (exception ex)
        {
            system.assert(true);
        }
    }
    
    public static testMethod void testConstructor()
    {
        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);

        PBS_gBUILD_ProjectBasicsController ctrl;

        ctrl = new PBS_gBUILD_ProjectBasicsController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assertEquals(true, ctrl.viewModeCommon);
        system.assertEquals(false, ctrl.editModeCommon);

        system.assertEquals(p.id, ctrl.pro.id);
        system.assertEquals(p.Projectid__c, ctrl.pbsPro.id);

        system.assertEquals(null, ctrl.edit());
        system.assertEquals(null, ctrl.cancel());
        system.assertEquals(null, ctrl.save());
    }

    public static testMethod void testApprove()
    {
        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        PBS_gBUILD_ProjectBasicsController ctrl;
        ctrl = new PBS_gBUILD_ProjectBasicsController();

        PBS_gBUILD_WorkflowHistory__c[] wfs;
        wfs = [select id from PBS_gBUILD_WorkflowHistory__c where recordtypeid=:PBS_gBUILD_Utility.workflowHistoryRecordTypeIdFormSignoff and Rahd_ProjectParentId__c=:ctrl.projectId];
        system.assertEquals(0, wfs.size());
        ctrl.approve();
        wfs = [select id from PBS_gBUILD_WorkflowHistory__c where recordtypeid=:PBS_gBUILD_Utility.workflowHistoryRecordTypeIdFormSignoff and Rahd_ProjectParentId__c=:ctrl.projectId];
        system.assertEquals(1, wfs.size());
    }

    public static testMethod void testDocuments()
    {   
        //Since one cannot use DML to create folders, even in test cases, set the fallback folder to the polymorphic field
        //http://salesforce.stackexchange.com/questions/12396/how-can-document-folder-be-created-in-unit-tests 
        PBS_gBUILD_Utility.AppConfig.CustPortalProjectDocsFolderId__c = UserInfo.getUserId();
        PBS_gBUILD_Utility.AppConfig.CustPortalHelpFolderId__c = UserInfo.getUserId();

        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();

        PBS_gBUILD_ProjectBasicsController ctrl;
        Document d;

        d = new document();
        d.developerName = 'P'+UserInfo.getUserId()+'_NotForThisProject_BuildingX_KeyY';
        d.name = 'NotForThisProject';
        d.folderId = PBS_gBUILD_Utility.ProjectDocsFolderId;
        insert d;

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        ctrl = new PBS_gBUILD_ProjectBasicsController();
        system.assertEquals(0,ctrl.DocInfos.size());


        d = new document();
        d.developerName = 'P'+p.id+'_ForThisProject_BuildingX_KeyY';
        d.name = 'ForThisProject';
        d.folderId = PBS_gBUILD_Utility.ProjectDocsFolderId;
        insert d;

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        ctrl = new PBS_gBUILD_ProjectBasicsController();
        system.assertEquals(1,ctrl.DocInfos.size());
    }

    public static testMethod void testSendTemplatizedMessages()
    {
        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();
        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);
        PBS_gBUILD_ProjectBasicsController ctrl;
        ctrl = new PBS_gBUILD_ProjectBasicsController();
        system.assertEquals(null, ctrl.projectIdBaseControllerException);

        list<string> userIds = new list<string>();
        for (user u : [select id from user limit 3])
        {
            userIds.add(u.id);
        }
        userIds.add(UserInfo.getUserId());
        string subjectTemplate = 'RE: [Project Name]';
        string bodyTemplate = 'Dear [User.UserName], please visit [Project.Url].  Thanks - [HelpDesk]';
        map<string, string> extras = new map<string, string>();
        extras.put('a','1');

        ctrl.sendTemplatizedMessages(false, userIds, subjectTemplate, bodyTemplate, extras);
        PBS_gBUILD_Utility.AppConfig.SendApplicationEmails__c = false;
        ctrl.sendTemplatizedMessages(false, userIds, subjectTemplate, bodyTemplate, extras);
        PBS_gBUILD_Utility.AppConfig.SendApplicationEmails__c = false;
        ctrl.sendTemplatizedMessages(false, userIds, 'zzz', extras);
    }
}