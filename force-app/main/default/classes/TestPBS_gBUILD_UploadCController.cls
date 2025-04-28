@isTest(SeeAllData=false)
public class TestPBS_gBUILD_UploadCController
{  
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    private static void Construct(string projectBuildingId)
    {
        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(projectBuildingId);

        PBS_gBUILD_PBuildingBasicsController page = new PBS_gBUILD_PBuildingBasicsController();
        system.assert(page!=null);
        system.assertEquals(null, page.projectIdBaseControllerException);

        PBS_gBUILD_UploadCController ctrl = new PBS_gBUILD_UploadCController();
        system.assert(ctrl!=null);

        page.DocInfos_p = new List<PBS_gBUILD_Utility.DocInfo>();
        page.DocInfos_p.add(new PBS_gBUILD_Utility.DocInfo(page.projectid, page.pbuildingid, 'Mpc1d3' ));
                
        ctrl.pageController = page;
        ctrl.key = 'jason';

        ctrl.tags = 'tags';
        ctrl.description = 'description';
        ctrl.epmCatalog = 'epmCatalog';
        ctrl.contextualTitle = 'contextualTitle';
        ctrl.readableWaiverKeyPattern = 'Mpc[TOKEN]Waiver';
        ctrl.readableWaiverKeyTokens = '1,2,3,4';
        ctrl.readableUploadKeys = 'Mpc1d2,Mpc1d3';
        ctrl.intro = 'intro';
        ctrl.noAccessContactName = 'noAccessContactName';
        system.assertEquals('jason', ctrl.key);
        system.assert(ctrl.fileManagerUrl!=null);
        system.assertEquals(1, ctrl.DocCount);
        ctrl.actionId=projectBuildingId;
        ctrl.del();
    }

    public static testMethod void testConstructorGb()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        Construct(pb.id);
    }

    public static testMethod void testConstructorEpm()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();

        string pbsProjectId  = [select Projectid__c from PBS_gBUILD_Project__c where id=:pb.Rahd_ProjectParentId__c].Projectid__c;
        PBS_Project__c pbsProject = [select id, txtProlianceAccountName__c from PBS_Project__c where id=:pbsProjectId];
        pbsProject.txtProlianceAccountName__c = 'proliance';
        update pbsProject;
        Construct(pb.id);
    }
}