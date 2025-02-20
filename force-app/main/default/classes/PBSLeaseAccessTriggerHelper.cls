public without sharing class PBSLeaseAccessTriggerHelper {
    public void OnBeforeInsert(List<PBS_Lease_Access__c> newList){
    	OnBeforeInsertUpdate(newList, null);
    }
    
	public void OnBeforeUpdate(List<PBS_Lease_Access__c> newList, Map<Id, PBS_Lease_Access__c> oldMap){
        OnBeforeInsertUpdate(newList, oldMap);
    } 

    public void OnBeforeInsertUpdate(List<PBS_Lease_Access__c> newList, Map<Id, PBS_Lease_Access__c> oldMap){
        List<PBS_Lease_Access__c> POCLeaseAccessList = new List<PBS_Lease_Access__c>();
        List<PBS_Lease_Access__c> approvedLeaseAccessList = new List<PBS_Lease_Access__c>();
        List<PBS_Lease_Access__c> rejectedLeaseAccessList = new List<PBS_Lease_Access__c>();
        List<PBS_Lease_Access__c> revokedLeaseAccessList = new List<PBS_Lease_Access__c>();
        for(PBS_Lease_Access__c la : newList) {
            if(oldMap != null){
                PBS_Lease_Access__c oldLa = oldMap.get(la.Id);
                if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_Requested) {
                    // PB/WFR sends email to POC to notify that Lease Access Request is Pending Approval
                } else if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_Approved && oldLa.Status__c != RET_LeaseShareUtility.RET_Access_Status_Approved) {
                    // Insert PBS_Lease__Share and CaseShare records
                    approvedLeaseAccessList.add(la);
                } else if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_Denied && oldLa.Status__c != RET_LeaseShareUtility.RET_Access_Status_Denied) {
                    // PB/WFR sends email to Requestor to notify that Lease Access Request is Denied/Rejected
                    rejectedLeaseAccessList.add(la);
                } else if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_Revoked && oldLa.Status__c != RET_LeaseShareUtility.RET_Access_Status_Revoked) {
                    // Find and delete related Lease and case share records
                    revokedLeaseAccessList.add(la);
                } else if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_POC && oldLa.Status__c != RET_LeaseShareUtility.RET_Access_Status_POC) {
                    // This records was inserted when owner changes to a new POC and need to create Case share records only(Access to lease will be provided by ownership)
                    POCLeaseAccessList.add(la);
                }
            }
            else {
                if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_Requested){
                    // PB/WFR sends email to POC to notify that Lease Access Request is Pending Approval
                } else if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_Approved){
                    // Insert PBS_Lease__Share and CaseShare records
                    approvedLeaseAccessList.add(la);
                } else if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_POC){
                    // This records was inserted when owner changes to a new POC and need to create Case share records only(Access to lease will be provided by ownership)
                    POCLeaseAccessList.add(la);
                }
            }
        }
        system.debug('approvedLeaseAccessList.size() ***'+approvedLeaseAccessList.size());
        system.debug('rejectedLeaseAccessList.size() ***'+rejectedLeaseAccessList.size());
        system.debug('revokedLeaseAccessList.size() ***'+revokedLeaseAccessList.size());
        system.debug('POCLeaseAccessList.size() *** '+POCLeaseAccessList.size());
        //Call utility methods to manage lease/case shares
        if(approvedLeaseAccessList != null && approvedLeaseAccessList.size() > 0){
            RET_LeaseShareUtility.InsertLeaseAndCaseShares(approvedLeaseAccessList);
        }
        if(revokedLeaseAccessList != null && revokedLeaseAccessList.size() > 0){
            RET_LeaseShareUtility.removeLeaseAndCaseShares(revokedLeaseAccessList);
        }
        if(POCLeaseAccessList != null && POCLeaseAccessList.size() > 0){
            RET_LeaseShareUtility.InsertCaseShares(POCLeaseAccessList);
        }
    } 
    
    public void OnBeforeDelete(List<PBS_Lease_Access__c> oldList){
		List<PBS_Lease_Access__c> deleteLeaseAccessList = new List<PBS_Lease_Access__c>();
        for(PBS_Lease_Access__c la : oldList){
            if(la.Status__c == RET_LeaseShareUtility.RET_Access_Status_Approved || la.Status__c == RET_LeaseShareUtility.RET_Access_Status_POC){
                // Prevent deleting lease access records if stsus is POC or Approved.
                la.addError('You can not delete a Lease Access record with status \'Approved\' or \'POC\'.');
            }
        }
   /*     //Call utility methods to delete lease/case shares
        if(deleteLeaseAccessList != null && deleteLeaseAccessList.size() > 0){
            RET_LeaseShareUtility.removeLeaseAndCaseShares(deleteLeaseAccessList);
        }
    */
    }

}