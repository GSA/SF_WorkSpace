public with sharing class RET_LeaseAccessApprovalController {
    /* This class is no longer in use as of the 2024-2025 RET Surge
    @AuraEnabled
    public static LeaseAccessListWrapper getLsacWrapperList(List<String> statusFilters, Integer selectedPage, Integer pageSize) {
        selectedPage = Integer.valueOf(selectedPage);
        pageSize = Integer.valueOf(pageSize);

        List<PBS_Lease_Access__c> leaseAccessList = RET_LeaseShareUtility.getLeaseAccessList(statusFilters, selectedPage, pageSize);
        system.debug('leaseAccessList ** '+leaseAccessList);

        Integer rowCount = RET_LeaseShareUtility.getPendingApprovalsCount(statusFilters); 
        system.debug('rowCount *** '+rowCount);

        return new LeaseAccessListWrapper(leaseAccessList, rowCount, pageSize, selectedPage);
    }
    
    @AuraEnabled
    public static boolean ApproveLeaseAccess(PBS_Lease_Access__c lsac){
        system.debug('ApproveLeaseAccess controller method');
        List<PBS_Lease_Access__c> lsacList = new List<PBS_Lease_Access__c>{lsac};
        return ApproveLeaseAccessList(lsacList);        
    }
    @AuraEnabled
    public static boolean ApproveLeaseAccessList(List<PBS_Lease_Access__c> lsacList){
        system.debug('ApproveLeaseAccessList controller method');
        return RET_LeaseShareUtility.ApproveRejectLeaseAccess(lsacList, 'Approve');        
    }
    
    @AuraEnabled
    public static boolean RejectLeaseAccess(PBS_Lease_Access__c lsac) {
       system.debug('RejectLeaseAccess controller method');
       List<PBS_Lease_Access__c> lsacList = new List<PBS_Lease_Access__c>{lsac};
       return RejectLeaseAccessList(lsacList);  
    }
    @AuraEnabled
    public static boolean RejectLeaseAccessList(List<PBS_Lease_Access__c> lsacList){
        system.debug('RejectLeaseAccessList controller method');
        return RET_LeaseShareUtility.ApproveRejectLeaseAccess(lsacList, 'Reject');        
    }
    
    public class LeaseAccessListWrapper {
        @AuraEnabled @testvisible public List<PBS_Lease_Access__c> leaseAccessList {get;set;}
        @AuraEnabled @testvisible public Integer totalPages {get;set;}
        @AuraEnabled @testvisible public Integer totalCases {get;set;}
        @AuraEnabled @testvisible public Integer totalLsAcs {get;set;}
        @AuraEnabled @testvisible public Boolean hasPrevious {get;set;}
        @AuraEnabled @testvisible public Boolean hasNext {get;set;}

        public LeaseAccessListWrapper(List<PBS_Lease_Access__c> lsacList, Integer rowCount, Integer pageSize, Integer selectedPage) {
            leaseAccessList = lsacList;
            totalLsAcs = rowCount;
            totalPages = (Integer)((Decimal)rowCount / (Decimal)pageSize).round(System.RoundingMode.UP);
            hasPrevious = selectedPage > 1;
            hasNext = selectedPage < totalPages;
        }
    }
    */
    public static boolean codeCoverageTest(){
        system.debug('Just returning something we can check in the test class for code coverage...');
        return true;        
    }
}