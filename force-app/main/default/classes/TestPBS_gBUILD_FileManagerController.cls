@isTest(SeeAllData=false)
public class TestPBS_gBUILD_FileManagerController
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

        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingBasicsController page = new PBS_gBUILD_PBuildingBasicsController();
        system.assert(page!=null);
        system.assertEquals(null, page.projectIdBaseControllerException);

        PBS_gBUILD_UploadCController ctrl = new PBS_gBUILD_UploadCController();
        system.assert(ctrl!=null);

        ctrl.pageController = page;
        ctrl.key = 'jason';

        ctrl.tags = 'tags';
        ctrl.description = 'description';
        ctrl.epmCatalog = 'epmCatalog';
        ctrl.contextualTitle = 'contextualTitle';
        ctrl.intro = 'intro';
        ctrl.noAccessContactName = 'noAccessContactName';
        system.assertEquals('jason', ctrl.key);
        system.assert(ctrl.fileManagerUrl!=null);

        PageReference pr = new PageReference(ctrl.fileManagerUrl);
        Test.setCurrentPageReference(pr);

        PBS_gBUILD_FileManagerController fm = new PBS_gBUILD_FileManagerController();
        system.assert(fm!=null);
        fm.file.body = EncodingUtil.base64Decode('SmFzb24gQnJ5Y2UgVGhvbWFzIChqYXNvbkBqYXNvbnRob21hcy5jb20pIGRldmVsb3BlZCBnQlVJTEQuICBEcm9wIG1lIGEgbGluZSBpZiB5b3UgZGVjb2RlIHRoaXMgc3RyaW5nLg==');
        fm.file.name = 'untitled.pdf';
        fm.upload();
    }
}