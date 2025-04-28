global class RET_ConvertOldDraftCasesBatch implements Database.Batchable<sObject>{
// Batch class created for 2024/2025 RET Surge to Close duplicate Draft Cases so they're not used in the new RET app design

    global Database.QueryLocator start(Database.BatchableContext BC){

        //Get the list of cases ordered by ownerId ASC, Lease Number ASC, and created date DESC
        List<Case> cases = [SELECT RecordType.Name, Id, PBS_Lease__c, OwnerId, CreatedDate, Status FROM Case WHERE RecordType.Name = 'Real Estate Taxes' ORDER BY OwnerId ASC, PBS_Lease__c ASC, CreatedDate DESC];
        System.debug('RecordType "Real Estate Taxes" base Cases count: ' + cases.size());    

        
        //Find any "duplicate" Draft cases (that is, older than the most recently created Draft Case for a user/Lease)
        List<Id> caseIdsToClose = new List<Id>();
        String lastOwnerLease = '';
        String lastOwnerLeaseStatus = '';
        for(Case myCase : cases) {
            String thisOwnerLease = (String) myCase.OwnerId + (String) myCase.PBS_Lease__c;
            String thisOwnerLeaseStatus = myCase.Status;
            if (thisOwnerLease == lastOwnerLease && thisOwnerLeaseStatus == 'Draft' && lastOwnerLeaseStatus == 'Draft') {
                    caseIdsToClose.add(myCase.Id);
            } else {
                lastOwnerLease = thisOwnerLease;
                lastOwnerLeaseStatus = thisOwnerLeaseStatus;
            }
        }
        System.debug('CaseIdsToClose count: ' + caseIdsToClose.size()); 

        return Database.getQueryLocator([SELECT Id, Status FROM Case WHERE Id IN :caseIdsToClose]);

    }
    
    global void execute(Database.BatchableContext BC, List<Case> retCases){

        for (Case aCase : retCases) {
            aCase.Status = 'Closed';
        }
        update retCases;

    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}