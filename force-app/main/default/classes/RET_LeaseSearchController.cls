public without sharing class RET_LeaseSearchController {
    public static final List<String> selectFields = new List<String>{'Lease_Number__c ','Building_City__c', 'Building_Name__c', 'Building_State_Code__c', 'Building_Street_Address__c', 'Building_Zip_Code__c', 'Lease_Effective_Date__c', 'Lease_Expiration_Date__c', 'Short_Lease_Number__c','Lessor__c'};
    public static final List<String> searchableFields = new List<String>{'Lease_Effective_Date__c', 'Lease_Expiration_Date__c', 'Short_Lease_Number__c', 'Lessor__c'};

    /* Commented out for 2024-2025 RET Surge to no longer facilitate Lease Access Request and Approval functionality
       on the Search and Home pages.
    @AuraEnabled
    public static boolean createLeaseAccess(String leaseId, String ReqComments) {
        PBS_Lease_Access__c leaseAccess;
        boolean result;
        try {
            //Seatch for existing lease access record if there is one.
            PBS_Lease_Access__c[] lsacList = [select Id, PBS_Lease__c, Requestor__c, Requestor_Comments__c, Status__c from PBS_Lease_Access__c
                           where Requestor__c = :UserInfo.getUserId()
                           and PBS_Lease__c = :leaseId];
            if(lsacList != null && lsacList.size() > 0){
                PBS_Lease_Access__c updateLsac = lsacList[0];
                updateLsac.Status__c = RET_LeaseShareUtility.RET_Access_Status_Requested;
                updateLsac.Requestor_Comments__c = ReqComments;
                update updateLsac;
                result = true;
            } else {
                leaseAccess = new PBS_Lease_Access__c(
                    PBS_Lease__c = leaseId,
                    Requestor__c = UserInfo.getUserId(),
                    Requestor_Comments__c = ReqComments,
                    Status__c = RET_LeaseShareUtility.RET_Access_Status_Requested);
                insert leaseAccess;  
                result = true;
            }
        } catch(Exception e) {
            result = false; throw new AuraHandledException(e.getMessage());
        }   
        return result;
    } */
    
    @AuraEnabled
    public static Case createNewCase(String leaseId) {
        createApprovedLeaseAccess(leaseId);
        if(avoidDuplicateCaseCreation(leaseId) !=null){ return avoidDuplicateCaseCreation(leaseId); }
        system.debug('leaseId ' +leaseId);
        PBS_Lease__c lease;
        Case c;
        try {
            lease = [select Id,Region_Code__c from PBS_Lease__c where Id = :leaseId limit 1];
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.RET_Lease_Not_Found);
        }
        //Check if the lease has an existing Draft case with same requesting lease owner
        List<Case> existingCase = [select Id,PBS_Lease__c from Case where PBS_Lease__c = :leaseId AND Status ='Draft' AND  OwnerId =:UserInfo.getUserId() limit 1];
        if(existingCase.size() >0){
            return existingCase[0];
        }
        system.debug('No Existing Cases');
        //Fetch the custom setting for region and email
        Map<String,String> regionEmailmap = new Map<String,String>();
        for(RET_RegionalEmail__mdt  regCst : [select RegionalEmail__c,RegionCode__c  from RET_RegionalEmail__mdt]){
            regionEmailmap.put(regCst.RegionCode__c,regCst.RegionalEmail__c);
        }
        try {
            c = new Case(
                Origin = 'Web',
                OwnerId = UserInfo.getUserId(),
                PBS_Lease__c = lease.Id,
                Status = 'Draft',
                Subject = 'Real Estate Tax Submission',
                Region_Code__c  = lease.Region_Code__c);
                
            if(String.isNotBlank(lease.Region_Code__c) && !regionEmailmap.isEmpty() && regionEmailmap.containsKey(lease.Region_Code__c))  c.GSA_Inbox__c  = regionEmailmap.get(lease.Region_Code__c);
                        
            insert c;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        //createApprovedLeaseAccess(lease.Id);
        return c;
    }
    
    //Check if the lease has an existing Draft case with same requesting lease owner
    public static case avoidDuplicateCaseCreation(String leaseId) {
        case cse = null;
        List<Case> existingCase = [select Id,PBS_Lease__c from Case where PBS_Lease__c = :leaseId AND Status ='Draft' AND  OwnerId =:UserInfo.getUserId() limit 1];
        if(existingCase.size() >0)  cse = existingCase[0];
        return cse;
    }
    
    public static void createApprovedLeaseAccess(String leaseId) {
        PBS_Lease_Access__c leaseAccess;
        //Seatch for existing lease access record so we don't create unneeded records.
        PBS_Lease_Access__c[] lsacList = [select Id, PBS_Lease__c, Requestor__c, Requestor_Comments__c, Status__c from PBS_Lease_Access__c
                       where Requestor__c = :UserInfo.getUserId()
                       and PBS_Lease__c = :leaseId
                       and Status__c in ('POC', 'Approved')];
        if(lsacList != null && lsacList.size() > 0){
            //Do nothing since user already has a "POC" or "Approved" Lease Access record
        } else {
            leaseAccess = new PBS_Lease_Access__c(
                PBS_Lease__c = leaseId,
                Requestor__c = UserInfo.getUserId(),
                Requestor_Comments__c = '',
                Status__c = RET_LeaseShareUtility.RET_Access_Status_Approved);
            insert leaseAccess;  
        }
    }

    @AuraEnabled
    public Static SearchResultsWrapper getLeaseResults(PBS_Lease__c template, 
                                                        Integer selectedPage, 
                                                        Integer pageSize, 
                                                        String buildingName, 
                                                        String buildingAddress, 
                                                        String buildingCity, 
                                                        String buildingState,
                                                        String buildingZipCode) {
        selectedPage = Integer.valueOf(selectedPage);
        pageSize = Integer.valueOf(pageSize);

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('PBS_Lease__c').getDescribe().fields.getMap();
        List<PBS_Lease__c> leaseList = new List<PBS_Lease__c>();
        Map<Id, PBS_Lease_Access__c> leaseLeaseAccessMap = new Map<Id, PBS_Lease_Access__c>();
        List<LeaseAccessWrapper> leaseAccessWrapperList = new List<LeaseAccessWrapper>();
        String soql = 'select Id,' + String.join(selectFields, ', ') + ' FROM PBS_Lease__c where ';
        List<String> whereStrings = new List<String>();
        if(template != null) {
            for(String field : searchableFields) {
                System.debug('Checking on adding searchable field ' + field + ' to whereStrings...');
                Schema.DisplayType fielddataType = fieldMap.get(field).getDescribe().getType();
                if(fielddataType == Schema.DisplayType.Date) {
                    if(template.get(field) != null) {
                        Date tmpDate = Date.valueof(template.get(field));
                        String dateVal = DateTime.newInstance(tmpDate.year(), tmpDate.month(), tmpDate.day()).format('yyyy-MM-dd');
                        whereStrings.add(field + ' = ' + dateVal);
                    }
                } else if(fielddataType == Schema.DisplayType.String) {
                    if(String.isNotBlank(String.valueOf(template.get(field)))) {
                        String strEsc = String.escapeSingleQuotes(String.valueof(template.get(field))); 
                        String tempInput = '\'%'+strEsc+'%\''; 
                        whereStrings.add(field + ' like ' + tempInput);
                    }
                }
                System.debug('whereStrings after date or string check: ' + whereStrings);
            }
            // Building fields
            if(String.isNotBlank(buildingName)) {
                whereStrings.add(createWhereClause('Building_Name__c', buildingName));
            }
            if(String.isNotBlank(buildingAddress)) {
                whereStrings.add(createWhereClause('Building_Street_Address__c', buildingAddress));
            }
            if(String.isNotBlank(buildingState)) {
                whereStrings.add(createWhereClause('Building_State_Code__c', buildingState));
            }
            if(String.isNotBlank(buildingCity)) {
                whereStrings.add(createWhereClause('Building_City__c', buildingCity));
            }
            if(String.isNotBlank(buildingZipCode)) {
                whereStrings.add(createWhereClause('Building_Zip_Code__c', buildingZipCode));
            }
            /* Commented out for 2024-2025 RET Surge to allow all Leases to be searched
            // Filter out search results if the owner is 'Cast Ironprd'(Integration User)
            if(System.Label.RET_Integration_User_Name != null) {
                whereStrings.add('Owner.Name != \''+ String.escapeSingleQuotes(System.Label.RET_Integration_User_Name) + '\'');
            } */
            //Added error handling if state is missing when lease number is entered - Ramesh
            if(String.isNotBlank(String.valueOf(template.get('Short_Lease_Number__c'))) && String.isBlank(buildingState)){
               throw new AuraHandledException(System.Label.RET_Missing_State_in_Search_Criteria);
            }

            //Replaced for 2024-2025 RET Surge to only require 1 or more where clause predicates 
            //since we commented out line 127 above which excluded leases owned by Cast Ironprd user.
            //if(whereStrings.size() > 1) {
            if(whereStrings.size() > 0) {
                try{
                    soql += String.join(whereStrings, ' AND ');
                    String countSoql = 'select count(Id) result from PBS_Lease__c where ' + String.join(whereStrings, ' AND ');
                    List<AggregateResult> countResult = Database.query(countSoql);
                    Integer rowCount = (Integer)countResult[0].get('result');
                    soql += ' order by Short_Lease_Number__c asc';
                    soql += ' limit ' + String.valueOf(pageSize);
                    soql += ' offset ' + String.valueOf(pageSize * (selectedPage - 1));
                    system.debug('getLeaseResults soql **** '+soql);
                    leaseList = Database.query(soql);
                    
                    // Get Lease Access records
                    for(PBS_Lease_Access__c lsac : [Select Id, PBS_Lease__c, Requestor__c, Status__c from PBS_Lease_Access__c 
                                                    where PBS_Lease__c in :leaseList
                                                    and Requestor__c = :UserInfo.getUserId() order by lastModifiedDate desc]) {
                        if(leaseLeaseAccessMap.containsKey((lsac.PBS_Lease__c))) {
                            continue;
                        } else {
                            leaseLeaseAccessMap.put(lsac.PBS_Lease__c, lsac);
                        }
                    }
                    for(PBS_Lease__c lease : leaseList) {
                        leaseAccessWrapperList.add(new LeaseAccessWrapper(lease, leaseLeaseAccessMap.get(lease.Id)));
                    }
                    system.debug('leaseAccessWrapperList ***' +leaseAccessWrapperList);
                    SearchResultsWrapper srw = new SearchResultsWrapper(leaseAccessWrapperList, rowCount, pageSize, selectedPage);
                    system.debug('Returning SearchResultWrapper: ' + srw);
                    return srw;
                }catch(Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            } else {
                throw new AuraHandledException(System.Label.RET_Missing_Search_Criteria);
            } 
        }
        return null;
    }

    private static String createWhereClause(String apiName, String value) {
        String strEsc = String.escapeSingleQuotes(value);
        String tempInput = '\'%'+strEsc+'%\''; 
        return apiName + ' like ' + tempInput;
    }
    
    public class LeaseAccessWrapper {
        @AuraEnabled Public PBS_Lease__c lease {get;set;}
        @AuraEnabled Public PBS_Lease_Access__c leaseAccess {get;set;}
        LeaseAccessWrapper(PBS_Lease__c ls, PBS_Lease_Access__c lsac) {
            lease = ls;
            leaseAccess = lsac;
        }
    }

    public class SearchResultsWrapper {
        @AuraEnabled @testvisible Public List<LeaseAccessWrapper> leaseWrapperList {get;set;}
        @AuraEnabled @Testvisible Public Integer totalPages {get;set;}
        @AuraEnabled @Testvisible Public Integer totalResults {get;set;}
        @AuraEnabled @Testvisible Public Boolean hasPrevious {get;set;}
        @AuraEnabled @Testvisible Public Boolean hasNext {get;set;}

        public SearchResultsWrapper(List<LeaseAccessWrapper> wrappers, Integer rowCount, Integer pageSize, Integer selectedPage) {
            leaseWrapperList = wrappers;
            totalResults = rowCount;
            totalPages = (Integer)((Decimal)rowCount / (Decimal)pageSize).round(System.RoundingMode.UP);
            hasPrevious = selectedPage > 1;
            hasNext = selectedPage < totalPages;
        }
    }
    
}