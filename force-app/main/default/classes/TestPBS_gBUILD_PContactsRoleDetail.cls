@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PContactsRoleDetail
{  
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    public static testMethod void testConstructor()
    {
        //PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();
        Profile pro = [SELECT Id FROM Profile WHERE Name='GSA System User'];
        User u = new User(Alias = 'GBTest2', Email='gbuildtesuser123_2@testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = pro.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='gbuildTestclassuser123_2@gsa.gov');
        insert u;
         
            PBS_Project__c pbsproj = new PBS_Project__c(
                txtLongName__c='gBUILD:TEST:EPM:XXX',
                txtRegion__c='00',
                txtCreatedIn__c=PBS_gBUILD_Utility.commonProjCreatorEpm,
                txtCurrentState__c='Active'
            );
            insert pbsproj ;
             String sobjectName ='gBUILD_ApplicationConfig__c';
             String devName ='WfState';
             String rtId = [select id from RecordType where sobjecttype=:sobjectName and developername=:devName].id; 
             gBUILD_ApplicationConfig__c acWfStateLarge = new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='WFS1_LargeProject_Initiated');
             insert acWfStateLarge; 
            PBS_gBUILD_Project__c p = new PBS_gBUILD_Project__c(
                Projectid__c=pbsproj.id,
                WorkflowPhaseId__c = acWfStateLarge.id,
                ProjectType__c=PBS_gBUILD_Utility.projectTypeNewConstruction
            );
            insert p;
        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);

        PBS_gBUILD_PContactsRoleDetailController ctrl = new PBS_gBUILD_PContactsRoleDetailController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assert(ctrl.container!=null);        
        ctrl.Container = p;
        ctrl.Container.OwnerId = u.id;//UserInfo.getUserId();
        ctrl.Role = PBS_gBUILD_Utility.SharingReasonWfRoleDataEntry;
        ctrl.Save();
        ctrl.Role = PBS_gBUILD_Utility.SharingReasonWfRoleDesignReviewer;
        ctrl.Save();
        ctrl.Role = PBS_gBUILD_Utility.SharingReasonWfRoleProjectAdmin;
        ctrl.Save();
        ctrl.Role = 'superman';
        ctrl.saveAndNew();
        system.assert(ctrl.cancel()!=null);
        
    }
}