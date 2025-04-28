@isTest(SeeAllData=false)
public class TestPBS_gBUILD_LinkListCController
{  
    static 
    {
        TestPBS_gBUILD_Utility.setup();
    }

    public static testMethod void testConstructor()
    {
        gBUILD_ApplicationConfig__c container = new gBUILD_ApplicationConfig__c(RecordTypeId=PBS_gBUILD_Utility.appConfigRecordTypeIdLinkList, Name='LinkContainer1', Label__c='Test Link Container');
        insert container;
        gBUILD_ApplicationConfig__c[] links = new gBUILD_ApplicationConfig__c[]
        {
            new gBUILD_ApplicationConfig__c(RecordTypeId=PBS_gBUILD_Utility.appConfigRecordTypeIdLink, Parent__c=container.id, Name='Link1', Label__c='Link 1', LinkReference__c='/l1'),
            new gBUILD_ApplicationConfig__c(RecordTypeId=PBS_gBUILD_Utility.appConfigRecordTypeIdLink, Parent__c=container.id, Name='Link2', Label__c='Link 2', LinkReference__c='/l2'),
            new gBUILD_ApplicationConfig__c(RecordTypeId=PBS_gBUILD_Utility.appConfigRecordTypeIdLink, Parent__c=container.id, Name='Link3', Label__c='Link 3', LinkReference__c='/l3')
        };
        insert links;

        PBS_gBUILD_LinkListCController ctrl = new PBS_gBUILD_LinkListCController();
        system.assert(ctrl!=null);
        ctrl.name=container.Name;
        system.assertEquals(3, ctrl.Links.size());
        system.assertEquals(container.Label__c, ctrl.Title);
    } 
}