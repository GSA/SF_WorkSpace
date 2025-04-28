public without sharing class RET_LeaseListController {
// For 2024-2025 RET Surge, changed to "Without Sharing" since we no longer utilize manual sharing and so we now
// need to programatically ensure all Leases and Cases are retrieved appropriately for the signed on user.
//
// RET Home Page needs to show all Leases the signed-on user is owner of along with any cases associated to those Leases.

// RET Home Page needs to show all Leases the signed-on user is NOT owner of, if there is an "Approved" PBS_Lease_Access__c record, 
// plus any case associate to those Leases that the sign-on user is owner of.

    @AuraEnabled
    public static LeaseListWrapper getWrapperList(List<String> statusFilters, Integer selectedPage, Integer pageSize) {
        selectedPage = Integer.valueOf(selectedPage);
        pageSize = Integer.valueOf(pageSize);

        List<LeaseWrapper> wrapperList = new List<LeaseWrapper>();
        Map<Id, List<Case>> leaseCaseMap = new Map<Id, List<Case>>();
        Map<Id, PBS_Lease_Access__c> leaseLeaseAccessMap = new Map<Id, PBS_Lease_Access__c>();
        Integer queryOffset = pageSize * (selectedPage - 1);

        //Replaced for 2024-2025 RET Surge to count the cases associated with the Leases the signed-on user is an owner of plus
        //cases the signed-on user is owner of for Leases he/she is NOT an owner but has an "Approved" PBS_Lease_Access__c record 
        //which indicates the Lease is a "Favorite". 
        //List<AggregateResult> countResult = [Select count(Id) result from Case where PBS_Lease__c IN (Select Id from PBS_Lease__c) and Status in :statusFilters];
        //Integer caseCount = (Integer)countResult[0].get('result');
        //List<AggregateResult> countResult = [Select count(Id) result from PBS_Lease__c];
        //Integer rowCount = (Integer)countResult[0].get('result');       
        
        //List<Case> myCases = [SELECT Id FROM Case WHERE PBS_Lease__r.OwnerId = :UserInfo.getUserId() OR (PBS_Lease__r.OwnerId != :UserInfo.getUserId() AND OwnerId = :UserInfo.getUserId())];
        //Integer caseCount = myCases.size();
        //System.debug('caseCount: ' + caseCount);
        Integer caseCount = 0;
        
        List<Id> myApprLaxLeaseIds = new List<Id>();
        for(PBS_Lease_Access__c laxs : [SELECT PBS_Lease__c 
                                        FROM PBS_Lease_Access__c
                                        WHERE Requestor__c = :UserInfo.getUserId() AND
                                              Status__c = 'Approved']) {
            myApprLaxLeaseIds.add(laxs.PBS_Lease__c);  
            System.debug('Added lease access rec ID to list: ' + laxs.Id);                                    
        }
        System.debug('approved Lease Access Records count: ' + myApprLaxLeaseIds.size());
        System.debug('pageSize: ' + pageSize);
        System.debug('queryOffset: ' + queryOffset);
        //Get the total Leases for the signed on user
        List<PBS_Lease__c> currentLeaseList = [select Id, Lease_Number__c, Building_Street_Address__c,
                            Building_State_Code__c, Building_Zip_Code__c,Short_Lease_Number__c, 
                            Building_Name__c, Lease_Effective_Date__c, Lease_Expiration_Date__c,
                            Lessor__c, Building_City__c from PBS_Lease__c
                            where OwnerId = :UserInfo.getUserId() OR
                                  Id IN :myApprLaxLeaseIds
                            order by Lease_Number__c asc];
        Integer rowCount = currentLeaseList.size();
        System.debug('rowCount: ' + rowCount);
        //Get the offset Leases to display on the requested page
        currentLeaseList = [select Id, Lease_Number__c, Building_Street_Address__c,
                            Building_State_Code__c, Building_Zip_Code__c,Short_Lease_Number__c, 
                            Building_Name__c, Lease_Effective_Date__c, Lease_Expiration_Date__c,
                            Lessor__c, Building_City__c from PBS_Lease__c
                            where OwnerId = :UserInfo.getUserId() OR
                                  Id IN :myApprLaxLeaseIds
                            order by Lease_Number__c asc
                            limit :pageSize offset :queryOffset];
        // Get actual page results.
        /* Replaced for 2024-2025 RET Surge so all cases are used no matter what the status is
        for(Case taxCase : [Select Id, CaseNumber, PBS_Lease__c, RET_Base_Tax_Year__c, RET_Initial_Submission_Date__c, Status from Case 
                         where Status in :statusFilters
                         and PBS_Lease__c in :currentLeaseList order by CaseNumber asc]) {
            if(leaseCaseMap.containsKey(taxCase.PBS_Lease__c)) {
                leaseCaseMap.get(taxCase.PBS_Lease__c).add(taxCase);
            } else {
                leaseCaseMap.put(taxCase.PBS_Lease__c, new List<Case>{taxCase});
            }
        } */
        //for(Case taxCase : [Select Id, CaseNumber, PBS_Lease__c, RET_Base_Tax_Year__c, RET_Initial_Submission_Date__c, Status from Case 
        //                   Where PBS_Lease__c in :currentLeaseList order by CaseNumber asc]) {
        //    if(leaseCaseMap.containsKey(taxCase.PBS_Lease__c)) {
        //        leaseCaseMap.get(taxCase.PBS_Lease__c).add(taxCase);
        //    } else {
        //        leaseCaseMap.put(taxCase.PBS_Lease__c, new List<Case>{taxCase});
        //    }
        //}         
        system.debug('currentLeaseList *** '+currentLeaseList);
        system.debug('UserInfo.getUserId() *** '+ UserInfo.getUserId());
        
        // Get Lease Access records
        /* Commented out for 2024-2025 RET Surge to remove Access Request/Approval functionality
        leaseLeaseAccessMap = RET_LeaseShareUtility.getLeaseAccessMap(currentLeaseList);
        */
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