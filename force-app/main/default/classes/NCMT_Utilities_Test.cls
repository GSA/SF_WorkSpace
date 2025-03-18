@isTest
public class NCMT_Utilities_Test {
    static testMethod void testClone(){
        Account acc = new Account(Name = 'Platy IT');
        insert acc;
        Contact c  = new Contact(FirstName = 'Jessie', LastName = 'Grenfell', AccountId = acc.Id);
        insert c;
        NCMT_Utilities.cloneMe('Account', acc.Id, new Set<String>{'Contact'}, true);
        
        System.assertEquals(2, [Select Id from Contact].size());

        String soql = NCMT_Utilities.getFieldSoQL('NCMT_Project__c');
        Boolean wasErr = false;
        try{
            try{
                update new Contact();
            } Catch(System.DmlException e){
                NCMT_Utilities.auraHandleDMLErrors(e);
            }
        } Catch (AuraHandledException ae){
            wasErr = true;
        }
    }
}