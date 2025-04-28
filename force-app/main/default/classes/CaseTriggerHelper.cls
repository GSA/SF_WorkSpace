public without sharing class CaseTriggerHelper {
    
    public void OnAfterInsertRETCases(List<Case> newList){
        
        //get the List of relevant Case Ids, only consider those with  relevant to Real Estate Taxes and an associated Lease
        system.debug('CaseTriggerHelper:' +'Trigger Case List');
        for (Case c: newList)
            system.debug('Case Id: ' + c.id + ', CaseNumber: ' + c.CaseNumber + ', and PBS_Lease__c: ' + c.PBS_Lease__c);
       
        Map<ID,List<Case>> leaseToCaseMap = new Map<ID,List<Case>>();
        for (Case c: newList) {
            //skip non RET Cases or where there is no associated Lease
            if (c.RecordTypeID != RET_LeaseShareUtility.RETRecordType || c.PBS_Lease__c == null)
                continue;
                
            List<Case> cList = leaseToCaseMap.get(c.PBS_Lease__c);
            if( cList == null)
            {
                cList = new List<Case>();
            }
            cList.add(c);
            leaseToCaseMap.put(c.PBS_Lease__c, cList);                
        }
        
        // get the Lease accessors
        List<PBS_Lease_Access__c> leaseAccessors = new List<PBS_Lease_Access__c>([select Requestor__c, Requestor__r.isActive, PBS_Lease__c, Status__c from PBS_Lease_Access__c 
                                                                                  where PBS_Lease__c in :leaseToCaseMap.keySet() and
                                                                                         status__c in ('Approved','POC')]);
        system.debug('CaseTriggerHelper:'+ 'Leases Accessors');
        for(PBS_Lease_Access__c a:leaseAccessors)
            system.debug(a.Requestor__c+':'+a.PBS_Lease__c+':'+ a.status__c);
        
        /* Commented out for 2024-2025 RET Surge where all manual sharing was removed...
        // creating Case Shares
        List<sObject> caseShareList = new List<sObject>();
        for (PBS_Lease_Access__c leaseAccessor : leaseAccessors) {
             
           List<Case> cList = leaseToCaseMap.get(leaseAccessor.PBS_Lease__c);
             
            for (Case c: cList)
            {
                // skip a Lease Access row for case Owner as Share record is created by system
                if ( leaseAccessor.Requestor__c == c.OwnerId || !leaseAccessor.Requestor__r.isActive)
                    continue;
                
                    //setup a case share
                    CaseShare cShare = new CaseShare(
                                                CaseId = c.ID,
                                                UserOrGroupId = leaseAccessor.Requestor__c,
                                                CaseAccessLevel = RET_LeaseShareUtility.RET_Access_Level_Edit,
                                                RowCause = 'Manual');
                    caseShareList.add(cShare);
                }
            }
            
            // create CaseShares... 
            insert caseShareList;
        }
        */
    }
  
            
}