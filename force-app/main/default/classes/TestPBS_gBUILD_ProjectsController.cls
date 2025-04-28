@isTest(SeeAllData=false)
public class TestPBS_gBUILD_ProjectsController
{  
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    public static testMethod void testConstructor()
    {
        PBS_gBUILD_ProjectsController ctrl;

        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());

        td.createGbProjectOnPbsProjectEpm1();
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assertEquals(1, ctrl.projects.size());

        system.assert(ctrl.createGbuild() != null);
        system.assert(ctrl.linkToEpm() != null);
        system.assert(ctrl.proposeEcoe() != null);
        system.assert(ctrl.open()!=null);
    }
    
    public static testMethod void testNullInitializers(){
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        system.assertEquals(null, ctrl.paramProjectId);
        system.assertEquals(null, ctrl.paramPbsProjectId);
        system.assertEquals(null, ctrl.qs);
    }
    
    public static testMethod void testRunSearch(){
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        system.assert(ctrl.runSearch()==null);
    }
    
    public static testMethod void testSoqlSubstrings(){
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        system.assert(ctrl.projectBuilding != null);
        system.assert(ctrl.projectName != null);
        system.assert(ctrl.projectPhase != null);
        system.assert(ctrl.projectStatus != null);
        system.assert(ctrl.projectType != null);
        system.assert(ctrl.projectRegion != null);
        
        system.assert(ctrl.projectBuildingSoql() != null);
        system.assert(ctrl.projectNameSoql() != null);
        system.assert(ctrl.projectPhaseSoql() != null);
        system.assert(ctrl.projectStatusSoql() != null);
        system.assert(ctrl.projectTypeSoql() != null);
        system.assert(ctrl.projectRegionSoql() != null);
        
        system.assert(ctrl.projectId !=null);
        system.assert(ctrl.projectTypes != null);
        system.assert(ctrl.projectRegions != null);
        system.assert(ctrl.projectBACode != null);
        system.assert(ctrl.status != null);
        system.assert(ctrl.projectNameQS() != null);
        system.assert(ctrl.projectIdQS() !=null);
        system.assert(ctrl.projectTypesQS() != null);
        system.assert(ctrl.projectRegionsQS() != null);
        system.assert(ctrl.BACodeQS() !=null);
        system.assert(ctrl.statusQS() != null);
        system.assert(ctrl.projNameLikeSoql !=null);
        system.assert(ctrl.portalUser !=null);
        system.assert(ctrl.viewAllProjectsPortalAccount !=null);
    }
    
    public static testMethod void testAdditionalCondition(){
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        
    }
    
    public static testMethod void testUserIDInfo(){
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl.userInfoID != null);
    }
    
    public static testMethod void testSoql(){
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        system.assert(ctrl.soql !=null);
        system.assert(ctrl.debugSoql !=null);
    }

    public static testMethod void testSortDir(){
        PBS_gBUILD_ProjectsController ctrl;
        PBS_gBUILD_ProjectsController ctrl2;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        system.assertEquals('asc', ctrl.sortDir);
        ctrl2 = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl2!=null);
        system.assertEquals(0, ctrl2.projects.size());
        ctrl2.sortDir='desc';
        system.assertEquals('desc', ctrl2.sortDir);
    }
    
    public static testMethod void testSortField(){
        PBS_gBUILD_ProjectsController ctrl;
        PBS_gBUILD_ProjectsController ctrl2;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        system.assertEquals('name', ctrl.sortField);
        ctrl2 = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl2!=null);
        system.assertEquals(0, ctrl2.projects.size());
        ctrl2.sortField='id';
        system.assertEquals('id', ctrl2.sortField);
    }
    
    public static testMethod void testConProject()
    {
        PBS_gBUILD_ProjectsController ctrl;
        PBS_gBUILD_ProjectsController ctrl2;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());       
        system.assert(ctrl.conProject != null);
        ctrl2 = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl2!=null);
        system.assertEquals(0,ctrl2.projects.size());
        ctrl2.conProject = null;
        system.assert(ctrl.conProject != ctrl2.conProject);
        ctrl.filterProjects();
        system.assertEquals(ctrl.conProject.getPageSize(), 2000);
        system.assert(ctrl.projects.size()>=0);
    }
    
    public static testMethod void testRunQuery()
    {
        PBS_gBUILD_ProjectsController ctrl,ctrl2;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());       
        system.assert(ctrl.conProject != null);
        ctrl2 = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl2!=null);
        system.assertEquals(0,ctrl2.projects.size());
        ctrl2.conProject = null;
        system.assert(ctrl.conProject != ctrl2.conProject);
    }
    
    public static testMethod void testQueryString()
    {
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        system.assert(ctrl.querystring !=null);
    }
    
    public static testMethod void testToggleSort()
    {
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        ctrl.sortDir = 'asc';
        ctrl.toggleSort();
        system.assertEquals('desc', ctrl.sortDir);
        ctrl.toggleSort();
        system.assertEquals('asc', ctrl.sortDir);
    }
    
    public static testMethod void testUserSettings(){
        PBS_gBUILD_ProjectsController ctrl;
        ctrl = new PBS_gBUILD_ProjectsController();
        system.assert(ctrl!=null);
        system.assertEquals(0, ctrl.projects.size());
        ctrl.portalUser = false;
        ctrl.viewAllProjectsPortalAccount = true;
        system.assert(ctrl.conProject !=null);
        ctrl.portalUser = true;
        ctrl.viewAllProjectsPortalAccount = false;
        system.assert(ctrl.conProject != null);
        ctrl.portalUser = false;
        ctrl.viewAllProjectsPortalAccount = false;
        system.assert(ctrl.conProject != null);
        ctrl.portalUser = true;
        ctrl.viewAllProjectsPortalAccount = true;
        system.assert(ctrl.conProject !=null);
    }
    
    
}