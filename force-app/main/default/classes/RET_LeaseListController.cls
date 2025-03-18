public with sharing class RET_LeaseListController {

    @AuraEnabled
    public static LeaseListWrapper getWrapperList(List<String> statusFilters, Integer selectedPage, Integer pageSize) {
        selectedPage = Integer.valueOf(selectedPage);
        pageSize = Integer.valueOf(pageSize);

        List<LeaseWrapper> wrapperList = new List<LeaseWrapper>();
        Map<Id, List<Case>> leaseCaseMap = new Map<Id, List<Case>>();
        Map<Id, PBS_Lease_Access__c> leaseLeaseAccessMap = new Map<Id, PBS_Lease_Access__c>();
        Integer queryOffset = pageSize * (selectedPage - 1);

        // Count case results.
       // List<AggregateResult> countResult = [Select count(Id) result from Case where OwnerId = :UserInfo.getUserId() and Status in :statusFilters];
        List<AggregateResult> countResult = [Select count(Id) result from Case where PBS_Lease__c IN (Select Id from PBS_Lease__c) and Status in :statusFilters];
        Integer caseCount = (Integer)countResult[0].get('result');
        
        countResult = [Select count(Id) result from PBS_Lease__c];
        Integer rowCount = (Integer)countResult[0].get('result');       

        List<PBS_Lease__c> currentLeaseList = [select Id, Lease_Number__c, Building_Street_Address__c,
                            Building_State_Code__c, Building_Zip_Code__c,Short_Lease_Number__c, 
                            Building_Name__c, Lease_Effective_Date__c, Lease_Expiration_Date__c,
                            Lessor__c, Building_City__c from PBS_Lease__c
                            order by Lease_Number__c asc
                            limit :pageSize offset :queryOffset];

        // Get actual page results.
        for(Case taxCase : [Select Id, CaseNumber, PBS_Lease__c, RET_Base_Tax_Year__c, RET_Initial_Submission_Date__c, Status from Case 
                         where Status in :statusFilters
                         and PBS_Lease__c in :currentLeaseList order by CaseNumber asc]) {
            if(leaseCaseMap.containsKey(taxCase.PBS_Lease__c)) {
                leaseCaseMap.get(taxCase.PBS_Lease__c).add(taxCase);
            } else {
                leaseCaseMap.put(taxCase.PBS_Lease__c, new List<Case>{taxCase});
            }
        }
        system.debug('currentLeaseList *** '+currentLeaseList);
        system.debug('UserInfo.getUserId() *** '+ UserInfo.getUserId());
        
        // Get Lease Access records
        leaseLeaseAccessMap = RET_LeaseShareUtility.getLeaseAccessMap(currentLeaseList);
        
        /*for(PBS_Lease_Access__c lsac : [Select Id, PBS_Lease__c, Requestor__c, Status__c from PBS_Lease_Access__c 
                                       where PBS_Lease__c in :currentLeaseList
                                        and Requestor__c = :UserInfo.getUserId() order by lastModifiedDate desc]) {
             system.debug('Inside lease access for loop ***'+lsac);
            if(leaseLeaseAccessMap.containsKey((lsac.PBS_Lease__c))) {
                continue;
            } else {
                leaseLeaseAccessMap.put(lsac.PBS_Lease__c, lsac);
            }
        }*/
        

        for(PBS_Lease__c lease : currentLeaseList) {
            wrapperList.add(new LeaseWrapper(lease, leaseCaseMap.get(lease.Id), leaseLeaseAccessMap.get(lease.Id)));
        }
        system.debug('wrapperList ***' +wrapperList);
        return new LeaseListWrapper(wrapperList, rowCount, pageSize, selectedPage, caseCount);
    }

    public class LeaseWrapper {
        @AuraEnabled public List<Case> caseList {get;set;}
        @AuraEnabled public PBS_Lease__c lease {get;set;}
        @AuraEnabled public PBS_Lease_Access__c leaseAccess {get;set;}
        public LeaseWrapper(PBS_Lease__c ls, List<Case> csl, PBS_Lease_Access__c lsac) {
            lease = ls;
            caseList = csl;
            leaseAccess = lsac;
        }
    }

    public class LeaseListWrapper {
        @AuraEnabled @testvisible public List<LeaseWrapper> wrapperList {get;set;}
        @AuraEnabled @testvisible public Integer totalPages {get;set;}
        @AuraEnabled @testvisible public Integer totalCases {get;set;}
        @AuraEnabled @testvisible public Integer totalLeases {get;set;}
        @AuraEnabled @testvisible public Boolean hasPrevious {get;set;}
        @AuraEnabled @testvisible public Boolean hasNext {get;set;}

        public LeaseListWrapper(List<LeaseWrapper> wrappers, Integer rowCount, Integer pageSize, Integer selectedPage, Integer caseCount) {
            wrapperList = wrappers;
            totalLeases = rowCount;
            totalCases = caseCount;
            totalPages = (Integer)((Decimal)rowCount / (Decimal)pageSize).round(System.RoundingMode.UP);
            hasPrevious = selectedPage > 1;
            hasNext = selectedPage < totalPages;
        }
    }
}