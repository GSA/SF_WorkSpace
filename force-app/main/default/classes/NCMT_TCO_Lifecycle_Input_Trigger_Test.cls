@isTest
public class NCMT_TCO_Lifecycle_Input_Trigger_Test {
    @testSetup static void setup()
    {
       

        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff1','Virginia','State Average'
            ,'Lowrise (2 - 3 stories)', true, false, false, 1000000, true, false, false, false, false);
       
    }

    static testMethod void test_Triggs()
    {
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        Id otherRenewalRT = [Select Id from RecordType where DeveloperName = 'Other_Capital_Renewal_Cost'][0].Id;
        
        
        Test.startTest();
        
        
        NCMT_TCO_Lifecycle_Input__c lifecycle = new NCMT_TCO_Lifecycle_Input__c(
            NCMT_Project__c = proj.Id,
            Include_Tenant_Refresh_Costs__c = true,
            New_fit_out_every_years__c = 7,
            Refresh_every_years__c = 7,
            Period_of_Analysis__c = 35,
            Planning_and_Pre_design__c = 6,
            Design__c = 6, 
            Construction__c = 12,
            End_Routine_Periodic_Maintenance_Early__c = 1,
            End_Major_Maint_System_Replace_Early__c = 3,
            Number_of_Years_of_Operation__c = 35
        );
        insert lifecycle;

        //Does full LCC grouping and calculation
        NCMT_TCO_Project tco = new NCMT_TCO_Project(proj.Id, true);
        System.assertEquals(35, tco.lccs.size());

        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
        
        //Core Shell trigger...
        for (NCMT_Core_Shell_Cost_Detail__c c : [Select Id, Project_Cost_Summary__r.Project_Name__c,
                    Replacement_Cost__c, Replacement_Frequency__c, Core_Shell_Cost_Parameter__r.Type1__c
                    from NCMT_Core_Shell_Cost_Detail__c 
                    where Project_Cost_Summary__r.Project_Name__c =: proj.Id AND Replacement_Cost__c > 0
                    LIMIT 1]
        ){
            update c;
        }
        
        //Project trigger
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
        proj.Start_Construction__c = System.today().addMonths(-12);
        update proj;

        NCMT_Other_Cost__c otherCost = new NCMT_Other_Cost__c(
            RecordTypeId = otherRenewalRT,
            Frequency_Years__c = 6, 
            Total1__c = 100000,
            NCMT_Project__c = proj.Id
        );
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
        insert otherCost;

        Test.stopTest();

        
        NCMT_TCO_Lifecycle_Input_TriggerHandler.triggerHandlerUpdate = false;
        lifecycle.Period_of_Analysis__c = 40;
        update lifecycle;

        System.assertEquals(40, [Select Id from NCMT_TCO_LCC__c].size());
        
    }

    static testMethod void testClone(){
        Account acc = new Account(Name = 'Platy IT');
        insert acc;
        Contact c  = new Contact(FirstName = 'Jessie', LastName = 'Grenfell', AccountId = acc.Id);
        insert c;
        NCMT_Utilities.cloneMe('Account', acc.Id, new Set<String>{'Contact'}, true);
        
        System.assertEquals(2, [Select Id from Contact].size());
    }
}