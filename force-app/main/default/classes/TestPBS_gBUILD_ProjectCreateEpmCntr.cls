@isTest(SeeAllData=false)
public class TestPBS_gBUILD_ProjectCreateEpmCntr
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

        PBS_gBUILD_ProjectCreateEpmController ctrl = new PBS_gBUILD_ProjectCreateEpmController();
        system.assert(ctrl!=null);
        system.assertEquals(1, ctrl.epmProjects.size());
        
        system.assert(!ctrl.allowPrev);
        ctrl.resortVal = 'txtRegion__c';
        ctrl.resort();
        ctrl.resort();
        ctrl.nextPage();
        ctrl.prevPage();
        ctrl.filterExpr = 'fdsfsda';
        ctrl.filter();
        system.assertEquals(0, ctrl.epmProjects.size());
        ctrl.view();
        
        ctrl.filterExpr = '';
        ctrl.filter();
        ctrl.proj.ProjectType__c = PBS_gBUILD_Utility.projectTypeNewConstruction;
        ctrl.selectedPbsProjectId = ctrl.epmProjects[0].rec.id;
        
        
        
        system.assert(ctrl.create()!=null);

        PBS_gBUILD_Project__c[] postProjs = [select id from PBS_gBUILD_Project__c limit 900];
        system.assertEquals(preProjs.size()+1, postProjs.size());
    }
    
    public static testMethod void testConstructor1()
    {
        PBS_gBUILD_Project__c[] preProjs = [select id from PBS_gBUILD_Project__c limit 900];

        PBS_gBUILD_ProjectCreateEpmController ctrl = new PBS_gBUILD_ProjectCreateEpmController();
        system.assert(ctrl!=null);
        system.assertEquals(1, ctrl.epmProjects.size());
        
        system.assert(!ctrl.allowPrev);
        ctrl.resortVal = 'txtRegion__c';
        ctrl.resort();
        ctrl.resort();
        ctrl.nextPage();
        ctrl.prevPage();
        ctrl.filterExpr = '1245';
        ctrl.filter();
        system.assertEquals(0, ctrl.epmProjects.size());
        ctrl.view();
        
        ctrl.filterExpr = '';
        ctrl.filter();
        ctrl.proj.ProjectType__c = PBS_gBUILD_Utility.projectTypeNewConstruction;
        ctrl.selectedPbsProjectId = ctrl.epmProjects[0].rec.id;
        
        
        
        system.assert(ctrl.create()!=null);

        PBS_gBUILD_Project__c[] postProjs = [select id from PBS_gBUILD_Project__c limit 900];
        system.assertEquals(preProjs.size()+1, postProjs.size());
    }
}