@IsTest(SeeAllData=false)
public class RET_LeaseListControllerTest {
    @testsetup static void createData(){
        Account accountRecord = new Account(name ='Real Estate Tax Bucket') ;
        insert accountRecord;
        
        PBS_Lease__c newPBS = new PBS_Lease__c(Lease_Number__c='98462383', Name ='98462383Test', Lease_Effective_Date__c = date.today(), Lease_Expiration_Date__c = date.today().adddays(365));
        Insert newPBS;
        
        List<Case> collCase = new List<Case>();
        collCase.add(new case(origin='Web',Status='Submitted',PBS_Lease__c =newPBS.ID));
        collCase.add(new case(origin='Phone',Status='Submitted',PBS_Lease__c =newPBS.ID));
        Insert collCase;
    }
    @isTest static void testPositive(){
        RET_LeaseListController.LeaseListWrapper controllerObj = 
            RET_LeaseListController.getWrapperList(new List<String>{'Submitted'},1,1);
        System.assertNotEquals(null,controllerObj);
        System.assertEquals(false,controllerObj.hasPrevious);
        System.assertEquals(false,controllerObj.hasNext);
        System.assertEquals(1,controllerObj.totalLeases);
        System.assertEquals(1,controllerObj.totalPages);
        //System.assertEquals(2,controllerObj.totalCases);
        System.assertEquals(1,controllerObj.wrapperList.size());
    }
}