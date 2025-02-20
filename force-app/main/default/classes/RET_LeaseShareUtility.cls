public without sharing class RET_LeaseShareUtility {
    public static final string RET_Access_Status_Requested = 'Requested';
    public static final string RET_Access_Status_Approved = 'Approved';
    public static final string RET_Access_Status_Denied = 'Denied';
    public static final string RET_Access_Status_Revoked = 'Revoked';
    public static final string RET_Access_Status_POC = 'POC';
    public static final string RET_UserType_POC = 'POC';
    public static final string RET_UserType_RET = 'RET';
    public static final string RET_Access_Level_Edit = 'Edit';
    //Profile updated
    //@testVisible public static final string RET_CCP_Profile  = 'GSA RET Community Plus User';
    @testVisible public static final string RET_CCP_Profile = 'GSA RET Community Plus Login User';
    @testVisible public static final string RET_PermissionSet  = 'RET_Community_User_CRED';
    @testVisible public static final String RET_Integration_User_Name = 'Cast IronPrd';
    //added limit clause to below to remove vulnerability
    @testVisible public static final boolean isSandboxEnv = [SELECT Id, InstanceName, IsSandbox  FROM Organization limit 1].isSandbox;
    //@testVisible 
    //public static final string RET_CCP_Profile_Id  = [select id, Name from profile where Name = 'GSA RET Community Plus User'].Id;
    @testVisible 
    public static final string RET_CCP_Profile_Id  = [select id, Name from profile where Name = 'GSA RET Community Plus Login User'].Id;
    @testVisible 
    public static final string RET_AAAP_Profile_Id  = [select id, Name from profile where Name = 'AAAP Customer Portal'].Id;
    @testVisible 
    public static final string RET_AAAP_PemissionSet_Id  = [SELECT Id, name, Label FROM PermissionSet where name = 'AAAP_User'].Id;
    @testVisible
    public static final Id RET_Account_Id =  [select id from Account where Name = 'Real Estate Tax Bucket' LIMIT 1].Id;
    @testVisible 
    public static final string AAAP_Customer_Profile  = 'AAAP Customer Portal';
    
    public static final ID RETRecordType = [select ID from RecordType where sobjecttype = 'Case' and Name = 'Real Estate Taxes'].ID;
    public static List<PBS_Lease_Access__c> getLeaseAccessList(List<String> statusFilters, Integer selectedPage, Integer pageSize) {
        Integer queryOffset = pageSize * (selectedPage - 1);
        List<PBS_Lease_Access__c> leaseAccessList = [select id, PBS_Lease__c, PBS_Lease__r.Lease_Number__c, PBS_Lease__r.Building_Name__c, 
                               Requestor__c, Requestor__r.Name, Requestor__r.Email, Requestor_Comments__c from PBS_Lease_Access__c 
                               where PBS_Lease__r.OwnerId = :UserInfo.getUserId() and Status__c IN :statusFilters 
                               order by PBS_Lease__r.Lease_Number__c asc limit :pageSize offset :queryOffset];
        return leaseAccessList;
    }
    
    @testVisible public static boolean getIsMaskPOCEmails(){
         try { RET_Settings__mdt settings = [SELECT ComponentCheckbox__c FROM RET_Settings__mdt  WHERE developername='MaskPOCEmails' LIMIT 1]; return settings.ComponentCheckbox__c; } catch (Exception e) { return true; }  
    }
    
    public static Integer getPendingApprovalsCount(List<String> statusFilters) {
        List<AggregateResult> countResult = [Select count(Id) result from PBS_Lease_Access__c where PBS_Lease__r.OwnerId = :UserInfo.getUserId() and Status__c IN :statusFilters];
        Integer rowCount = (Integer)countResult[0].get('result'); 
        return rowCount;
    }
    
    public static Boolean ApproveRejectLeaseAccess(List<PBS_Lease_Access__c> lsacList, String descision) {
        Boolean result;
        if(descision == 'Approve'){
            result = ApproveLeaseAccess(lsacList);
        } else if (descision == 'Reject') {
            result = RejectLeaseAccess(lsacList);
        }
        return result;
    }
    
    public static Map<Id, PBS_Lease_Access__c> getLeaseAccessMap(List<PBS_Lease__c> currentLeaseList) {
        Map<Id, PBS_Lease_Access__c> leaseLeaseAccessMap = new Map<Id, PBS_Lease_Access__c>();
        for(PBS_Lease_Access__c lsac : [Select Id, PBS_Lease__c, Requestor__c, Status__c from PBS_Lease_Access__c 
                                       where PBS_Lease__c in :currentLeaseList
                                        and Requestor__c = :UserInfo.getUserId() order by lastModifiedDate desc]) {
             system.debug('Inside lease access for loop ***'+lsac);
            if(leaseLeaseAccessMap.containsKey((lsac.PBS_Lease__c))) {
                continue;
            } else {
                leaseLeaseAccessMap.put(lsac.PBS_Lease__c, lsac);
            }
        }
        return leaseLeaseAccessMap;
    }
    
    public static Boolean ApproveLeaseAccess(List<PBS_Lease_Access__c> lsacList) {
        Boolean result;
        List<sObject> insertList = new List<sObject>();
        List<sObject> updateList = new List<sObject>();
        Savepoint sp = Database.setSavepoint();
        for(PBS_Lease_Access__c lsac : lsacList) { // prepare all PBS Lease records to update
            lsac.Status__c = RET_Access_Status_Approved;
            updateList.add(lsac);
        }
        try {
            Database.SaveResult[] srUpdateList = Database.update(updateList, true);
            result = true;
        }catch (Exception ex) {
            system.debug('ApproveLeaseAccess Exception *** '+ex.getMessage());
            Database.rollback(sp);
            result = false;    
        }
        return result;
    }
    
    public static Boolean RejectLeaseAccess(List<PBS_Lease_Access__c> lsacList) {
        Boolean result;
        List<sObject> updateList = new List<sObject>();
        Savepoint sp = Database.setSavepoint();
        for(PBS_Lease_Access__c lsac : lsacList) { // prepare all PBS Lease records to update with 'Access Denied' Status
            lsac.Status__c = RET_Access_Status_Denied;
            updateList.add(lsac);
        }
        try {
            Database.SaveResult[] srUpdateList = Database.update(updateList, true);
            result = true;
        }catch (Exception ex) {
            system.debug('RejectLeaseAccess Exception *** '+ex.getMessage());
            Database.rollback(sp);
            result = false;    
        }
        return result;
    }
    
    public static boolean InsertLeaseAndCaseShares(List<PBS_Lease_Access__c> lsacList) {
        system.debug('inside InsertLeaseAndCaseShares** ');
        List<sObject> sharesList = new List<sObject>();
        sharesList.addAll(CreateLeaseShares(lsacList)); // prepare all PBS_Lease__Share records to insert
        sharesList.addAll(CreateCaseShares(lsacList)); // prepare all CaseShare records to insert
        if(sharesList.size() > 0){
            insert sharesList;
        }
        return true;
    }
    
    public static List<sObject> CreateLeaseShares(List<PBS_Lease_Access__c> lsacList) {
        List<sObject> leaseShareList = new List<sObject>();
        Map<Id,Id> leaseAccessIdLeaseOwnerIdMap = getLeaseOwnerMap(lsacList);
        for(PBS_Lease_Access__c lsac : lsacList) {
            if(leaseAccessIdLeaseOwnerIdMap.containsKey(lsac.Id) && leaseAccessIdLeaseOwnerIdMap.get(lsac.Id) == lsac.Requestor__c){
                //making sure we do not create a share for our record owner.
                continue;
            } else {
                PBS_Lease__Share leaseShare = new PBS_Lease__Share(
                                        ParentId = lsac.PBS_Lease__c,
                                        UserOrGroupId = lsac.Requestor__c,
                                        AccessLevel = RET_Access_Level_Edit,
                                        RowCause = Schema.PBS_Lease__Share.RowCause.Manual);
                leaseShareList.add(leaseShare);
            }
        }
        return leaseShareList;
    } 
    
    public static Map<Id,Id> getLeaseOwnerMap(List<PBS_Lease_Access__c> lsacList) {
        List<id> leaseIds = new List<Id>();
        for(PBS_Lease_Access__c lsac : lsacList) {
            leaseIds.add(lsac.PBS_Lease__c);
        }
        Map<Id,Id> leaseAccessIdLeaseOwnerIdMap = new Map<Id, Id>();            
        for(PBS_Lease__c ls : [select id, ownerId from PBS_Lease__c where Id IN :leaseIds]){
            for(PBS_Lease_Access__c lsac : lsacList) {
                if(lsac.PBS_Lease__c == ls.id){
                    leaseAccessIdLeaseOwnerIdMap.put(lsac.Id, ls.ownerId);
                }else {
                    continue;
                }
            }
        }
        return leaseAccessIdLeaseOwnerIdMap;
    }
    
    public static void InsertCaseShares(List<PBS_Lease_Access__c> lsacList) {
        List<sObject> sharesList = CreateCaseShares(lsacList);
        if(sharesList != null && sharesList.size() > 0){
            insert sharesList;
        }
    }
    
    public static List<sObject> CreateCaseShares(List<PBS_Lease_Access__c> lsacList) {
        List<sObject> caseShareList = new List<sObject>();
        set<Id> leaseIdsSet = new set<Id>();
        set<Id> requestorIdsSet = new set<Id>();
        for(PBS_Lease_Access__c lsac : lsacList){
            system.debug('inside CreateCaseShares Lsac.Id '+lsac.Id+'lsac.PBS_Lease__c *** '+lsac.PBS_Lease__c+'lsac.Requestor__c *** '+lsac.Requestor__c);
            if(lsac.PBS_Lease__c != null){
                leaseIdsSet.add(lsac.PBS_Lease__c);
                requestorIdsSet.add(lsac.Requestor__c);
            }
        }
        system.debug('leaseIdsSet *** '+leaseIdsSet+' and requestorIdsSet *** '+requestorIdsSet );
        
        Map<Id, List<Case>> leaseCaseListMap = new Map<Id, List<Case>>();
       
        List<Case> caseList = [Select Id, CaseNumber, OwnerId, PBS_Lease__c from Case where PBS_Lease__c IN :leaseIdsSet];
        for(Case cas : caseList) {
            system.debug('cas number *** '+cas.CaseNumber);
            if(leaseCaseListMap.containsKey(cas.PBS_Lease__c )){
                List<Case> temCaseList = leaseCaseListMap.get(cas.PBS_Lease__c);
                temCaseList.add(cas);
                leaseCaseListMap.put(cas.PBS_Lease__c, temCaseList);
            } else {
                leaseCaseListMap.put(cas.PBS_Lease__c, new List<Case>{cas});
            }
        }
        system.debug('leaseCaseListMap **** '+leaseCaseListMap);
        
        //Loop through all Leases and create share records for related cases(Tax Submissions)
        for(PBS_Lease_Access__c lsac : lsacList) {
            if(leaseCaseListMap.containsKey(lsac.PBS_Lease__c) && leaseCaseListMap.get(lsac.PBS_Lease__c) != null && leaseCaseListMap.get(lsac.PBS_Lease__c).size() > 0) {
                for(Case c : leaseCaseListMap.get(lsac.PBS_Lease__c)) {
                    system.debug('creating caseShare for loop'+c.CaseNumber);
                    if(c.OwnerId == lsac.Requestor__c){  //Making sure that we are not creating a CaseShare for case owner
                        system.debug('case owner is requestor');
                        continue;
                    } else {
                        CaseShare casShare = new CaseShare(
                                                CaseId = c.Id,
                                                UserOrGroupId = lsac.Requestor__c,
                                                CaseAccessLevel = RET_Access_Level_Edit,
                                                RowCause = 'Manual');
                        caseShareList.add(casShare);
                        system.debug('casShare record *** '+casShare);
                    }
                }
            }
        }
        system.debug('caseShareList.size() *** '+caseShareList.size());
        return caseShareList;
    }
    
    public static void removeLeaseAndCaseShares(List<PBS_Lease_Access__c> lsacList){
        removeLeaseShares(lsacList);
        removeCaseShares(lsacList);
        
    }
    
    public static void removeLeaseShares(List<PBS_Lease_Access__c> lsacList){
        List<PBS_Lease__Share> deleteLeaseShareList = new List<PBS_Lease__Share>();
        set<Id> leaseIdsSet = new set<Id>();
        set<Id> requestorIdsSet = new set<Id>();
        for(PBS_Lease_Access__c lsac : lsacList){
            leaseIdsSet.add(lsac.PBS_Lease__c);
            requestorIdsSet.add(lsac.Requestor__c);
        }
        system.debug('leaseIdsSet *** '+leaseIdsSet+' and requestorIdsSet *** '+requestorIdsSet );
        for(PBS_Lease__Share lsShare : [select Id, ParentId, UserOrGroupId, AccessLevel, RowCause from PBS_Lease__Share where ParentId IN :leaseIdsSet and UserOrGroupId IN :requestorIdsSet and RowCause = :Schema.PBS_Lease__Share.RowCause.Manual]) {
            for(PBS_Lease_Access__c lsac : lsacList){
                if(lsShare.ParentId == lsac.PBS_Lease__c && lsShare.UserOrGroupId == lsac.Requestor__c) { //Found corresponding LeaseShare record for this LeaseAccess record
                    deleteLeaseShareList.add(lsShare);
                }
            }
        }
        if(deleteLeaseShareList != null && deleteLeaseShareList.size() > 0){
            delete deleteLeaseShareList;
        }
    }
    
    public static void removeCaseShares(List<PBS_Lease_Access__c> lsacList){
        //Get all related cases from lease access list
        List<CaseShare> deleteCaseShareList = new List<CaseShare>();
        List<Id> relaredCaseIDList = new List<Id>();
        set<Id> leaseIdsSet = new set<Id>();
        set<Id> requestorIdsSet = new set<Id>();
        for(PBS_Lease_Access__c lsac : lsacList){
            leaseIdsSet.add(lsac.PBS_Lease__c);
            requestorIdsSet.add(lsac.Requestor__c);
        }
        system.debug('leaseIdsSet *** '+leaseIdsSet+' and requestorIdsSet *** '+requestorIdsSet );
        
        Map<Id, List<Case>> leaseCaseListMap = new Map<Id, List<Case>>();
        Map<Id, CaseShare> caseShareMap = new Map<Id, CaseShare>();
       
        for(Case cas : [Select Id, CaseNumber, PBS_Lease__c from Case where PBS_Lease__c IN :leaseIdsSet]) {
            relaredCaseIDList.add(cas.Id);
            if(leaseCaseListMap.containsKey(cas.PBS_Lease__c )){
                List<Case> tempCaseList = leaseCaseListMap.get(cas.PBS_Lease__c);
                tempCaseList.add(cas);
                leaseCaseListMap.put(cas.PBS_Lease__c, tempCaseList);
            } else {
                leaseCaseListMap.put(cas.PBS_Lease__c, new List<Case>{cas});
            }
        }
        
        //Loop through all caseShares, then LeaseAccessList and then CaseList
        for(CaseShare casShare : [select Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause from CaseShare where CaseId IN :relaredCaseIDList and UserOrGroupId IN :requestorIdsSet and RowCause = 'Manual']) {
            for(PBS_Lease_Access__c lsac : lsacList){
                if(leaseCaseListMap.get(lsac.Id) != null){
                    for(Case cas : leaseCaseListMap.get(lsac.Id)){
                        if(casShare.CaseId == cas.Id && casShare.UserOrGroupId == lsac.Requestor__c) { //Found corresponding LeaseShare record for this LeaseAccess record
                            deleteCaseShareList.add(casShare);
                        }
                    }
                }
            }
        }
        if(deleteCaseShareList != null && deleteCaseShareList.size() > 0){
            delete deleteCaseShareList;
        }
    }
    
    public static void revokePOCLeaseAccess(List<PBS_Lease__c> newList){
        List<PBS_Lease_Access__c> revokePOCLeaseAccessList = new List<PBS_Lease_Access__c>();
        Map<Id, Id> leaseOwnerIdMap = new Map<Id,Id>();
        for(PBS_Lease__c ls : newList){
            leaseOwnerIdMap.put(ls.Id, ls.OwnerId);
        }
        for(PBS_Lease_Access__c lsac : [select id, Status__c from PBS_Lease_Access__c where Status__c = :RET_LeaseShareUtility.RET_Access_Status_POC and PBS_Lease__c IN :leaseOwnerIdMap.keySet() and Requestor__c IN :leaseOwnerIdMap.values()]){
            lsac.status__c = RET_LeaseShareUtility.RET_Access_Status_Revoked;
            revokePOCLeaseAccessList.add(lsac);
        }
        if(revokePOCLeaseAccessList.size() > 0) {update revokePOCLeaseAccessList;}
    }
    
    public static void revokeRETLeaseAccess(List<PBS_Lease__c> newList){
        List<PBS_Lease_Access__c> revokeRETLeaseAccessList = new List<PBS_Lease_Access__c>();
        Map<Id, Id> leaseOwnerIdMap = new Map<Id,Id>();
        for(PBS_Lease__c ls : newList){
            leaseOwnerIdMap.put(ls.Id, ls.OwnerId);
        }
        for(PBS_Lease_Access__c lsac : [select id, Requestor__c, Status__c from PBS_Lease_Access__c where Status__c = :RET_LeaseShareUtility.RET_Access_Status_Approved and PBS_Lease__c IN :leaseOwnerIdMap.keySet()]){
            lsac.status__c = RET_LeaseShareUtility.RET_Access_Status_Revoked;
            revokeRETLeaseAccessList.add(lsac);
        }
        if(revokeRETLeaseAccessList.size() > 0) {update revokeRETLeaseAccessList;}
    }
        
    public static Id getCastIronUserId(){
        User[] intUser = [select Id, Name from user where Name = :RET_LeaseShareUtility.RET_Integration_User_Name Limit 1];
        if(intUser[0] != null) {
           return intUser[0].Id;
        }
        return null;
    }    
    
    @AuraEnabled
    public static List<PBS_Lease_Access__c> getPBSLeaseAccessRecords(String leaseNumber){
            return [Select Id, PBS_Lease__c, Requestor__c,Requestor__r.Name, Status__c from PBS_Lease_Access__c 
                                       where PBS_Lease__r.Name=:leaseNumber AND Status__c=:RET_Access_Status_Approved];
    }
    
    @AuraEnabled
    public static void revokePBSLeaseAccess(List<Id> leaseAccessIds){
        List<PBS_Lease_Access__c> leaseAccessToUpdate = new List<PBS_Lease_Access__c>();
        for(PBS_Lease_Access__c la : [Select Status__c from PBS_Lease_Access__c where ID IN:leaseAccessIds]) {
            la.Status__c = RET_Access_Status_Revoked;
            leaseAccessToUpdate.add(la);
        }
        
        if(leaseAccessToUpdate.size()>0){
            update leaseAccessToUpdate;
        }
    }
    @AuraEnabled
    public static string getUserType() {
        system.debug('getUserType apexCntrl method');
        String uType;
        String countQuery = 'select count() from PBS_Lease_Access__c where Requestor__c = \''+ UserInfo.getUserId()+'\' and Status__c = \'' +RET_LeaseShareUtility.RET_Access_Status_POC+'\'';
        Integer count= database.countQuery(countQuery);
        if(count != null && count > 0){
           uType = RET_LeaseShareUtility.RET_UserType_POC;
        } else {
            uType = RET_UserType_RET; // setting default community userType as 'RET'
        }
        system.debug('uType *** *'+uType);
        return uType;
    }
}