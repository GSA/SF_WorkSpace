public With Sharing class APIMuleHelperMockConsumer {

    private static APIMuleHelper.APIAttributes apiAttributes = null;
    private static String endpoint = '';
    private static List<Log__e> allLogs = new List<Log__e>();
    
    @AuraEnabled(cacheable=true)
    public static List<LeaseDetails> getLeaseDetails(String leaseId){ 

        System.debug('APIMuleHelperMockConsumer.getLeaseDetails starting, lease id : '+leaseId);
        List<LeaseDetails> leaseDetailsList = new  List<LeaseDetails>();
        LeaseDetails leaseDetails = new LeaseDetails();
        leaseDetails.BasicAndAddlInfoError = false; 
       
        allLogs.add(
            new Log__e(
                Apex_Class_Name__c = 'APIMuleHelperMockConsumer.getLeaseDetails()',
                Username__c = Userinfo.getUserName(),
                Message__c = 'APIMuleHelperMockConsumer.getLeaseDetails() starting, leaseId: '+leaseId
            ));
        
        String apiModel = 'For_Test_Class_BasicAuth';
        apiAttributes = APIMuleHelper.populateAPIAttributes(apiModel);
        System.debug('APIMuleHelperMockConsumer.getLeaseDetails(), apiAttributes: ' + apiAttributes);
        HttpResponse response = null;
        String errorEmail = '';
        
        if(String.isNotBlank(leaseId)){
            String leaseNumber = getLeaseNumber(leaseId);
            allLogs.add(
                new Log__e(
                    Apex_Class_Name__c = 'APIMuleHelperMockConsumer.getLeaseDetails()',
                    Username__c = Userinfo.getUserName(),
                    Message__c = 'APIMuleHelperMockConsumer.getLeaseDetails() leaseNumber: '+leaseNumber
                ));   
                
            // retrieve lease details basic and additional information from REXUS
            endpoint = apiAttributes.baseEndPoint + apiAttributes.vfilters + leaseNumber + '/additionalDetails';
            System.debug('APIMuleHelperMockConsumer.getLeaseDetails(), basic & addl info endPoint: ' + endPoint);
            response = APIMuleHelper.executeAPI('APIMuleHelperMockConsumer', endpoint, null, 
                                                apiAttributes.httpHeaders, 'GET', apiAttributes.additionalParams);
            System.debug('APIMuleHelperMockConsumer.getLeaseDetails(), response is : ' + response);
            if(response != null && response.getStatusCode() == 200){
                System.debug('APIMuleHelperMockConsumer.getLeaseDetails(), basic & addl info response body: ' + response.getBody());
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                leaseDetails.BasicAndAddlInfoFound = ((Integer)results.get('totalSize') > 0) ? true : false;
                List<Object> entityData = (List<Object>) results.get('records');
                Map<String, Object> entityRec = null;
                for (Object e: entityData) {
                    entityRec = (Map<String, Object>)e;
                    leaseDetails.LeaseNumber = (String)entityRec.get('LEASE_NUM');
                    leaseDetails.LeaseId = (Integer)entityRec.get('LEASE_ID');
                    leaseDetails.ExpirationNotificationMonths = (Integer)entityRec.get('EXPIRATION_NOTIFY_MONTHS');
                    leaseDetails.ExtensionReasonCode = (String)entityRec.get('EXTENSION_REASON_CD');
                    leaseDetails.OtherExtensionReason = (String)entityRec.get('OTHER_EXTENSION_REASON');
                    leaseDetails.LeaseEffectiveDate = (String)entityRec.get('EFFECTIVE_DT');
                    leaseDetails.LeaseStatusCode = (String)entityRec.get('LEASE_STATUS_CD');
                    leaseDetails.LeaseStatusDesc = (String)entityRec.get('LEASE_STATUS_DESC');
                    leaseDetails.BlockRSF = (Decimal)entityRec.get('BLK_RSF');
                    leaseDetails.LeaseExpirationDate = (String)entityRec.get('EXPIRATION_DT');
                    leaseDetails.UnexercisedOptions = (String)entityRec.get('UNEXERCISED_OPTIONS_IND');
                    leaseDetails.FullyServicedLease = (String)entityRec.get('FULLY_SERVICED_LEASE_IND');
                    leaseDetails.BlockNumber = (String)entityRec.get('BLOCK_NUM');
                }
            }
                     
        }
        
        System.debug('APIMuleHelperMockConsumer.getLeaseDetails ending, leaseDetails: ' + leaseDetails);
        allLogs.add(
            new Log__e(
                Apex_Class_Name__c = 'APIMuleHelperMockConsumer.getLeaseDetails()',
                Username__c = Userinfo.getUserName(),
                Message__c = 'APIMuleHelperMockConsumer.getLeaseDetails() ending, leaseDetails: ' + leaseDetails
            ));            
        LogEventsPublishHandler.publishLogEvents(allLogs);

        if (errorEmail.length() > 0)
            APIMuleHelper.sendIntegrationErrorEmail(apiAttributes, 'User ' + UserInfo.getName() + '(username: ' + UserInfo.getUserName() + '), responses: ' + errorEmail);

        leaseDetailsList.add(leaseDetails);
        return leaseDetailsList;
          
    }
    
    private static String getLeaseNumber(String leaseId){
        return [Select Lease_Number__c from PBS_Lease__c where ID =:leaseId limit 1].Lease_Number__c;
    }

    // Lease Details wrapper class 
    public class LeaseDetails{

        //Basic & Additional Information
        @auraEnabled
        public Boolean BasicAndAddlInfoFound{get;set;}
        @auraEnabled
        public Boolean BasicAndAddlInfoError{get;set;}
        @auraEnabled
        public String LeaseNumber{get;set;}
        @auraEnabled
        public Integer LeaseId{get;set;}
        @auraEnabled
        public String LeaseStatusCode{get;set;}
        @auraEnabled
        public String LeaseStatusDesc{get;set;}
        @auraEnabled
        public String ExtensionReasonCode{get;set;}
        @auraEnabled
        public String OtherExtensionReason{get;set;}
        @auraEnabled
        public String LeaseEffectiveDate{get;set;}
        @auraEnabled
        public String LeaseExpirationDate{get;set;}
        @auraEnabled
        public Integer ExpirationNotificationMonths{get;set;}
        @auraEnabled
        public String UnexercisedOptions{get;set;}
        @auraEnabled
        public String FullyServicedLease{get;set;}
        @auraEnabled
        public String BlockNumber{get;set;}
        @auraEnabled
        public Decimal BlockRSF{get;set;}

    }
    
}