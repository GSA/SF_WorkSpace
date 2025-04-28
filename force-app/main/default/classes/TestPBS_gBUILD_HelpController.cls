@isTest(SeeAllData=false)
public class TestPBS_gBUILD_HelpController
{  
    static 
    {
        TestPBS_gBUILD_Utility.setup();
    }

    public static testMethod void testConstructor()
    {
        //Since one cannot use DML to create folders, even in test cases, set the fallback folder to the polymorphic field
        //http://salesforce.stackexchange.com/questions/12396/how-can-document-folder-be-created-in-unit-tests 
        PBS_gBUILD_Utility.AppConfig.CustPortalProjectDocsFolderId__c = UserInfo.getUserId();
        PBS_gBUILD_Utility.AppConfig.CustPortalHelpFolderId__c = UserInfo.getUserId();

        PBS_gBUILD_HelpController ctrl = new PBS_gBUILD_HelpController();
        system.assertEquals(0, ctrl.docs.size());
    } 
}