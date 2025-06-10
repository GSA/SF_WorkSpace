@RestResource(urlMapping='/RLPService')
global with sharing class PBS_AAAP_RLPService {
//Julia Kantarovsky added contacts functionality 2.12.21
    
    
    @HttpPost
    global static Id doPost(){  //string reqJSON
        
        string leasingSpecialist = '';
        string leaseContractingOfficer = '';
        string brokerContractor = '';
        
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        //System.debug('JK body ' + body);
        String requestString = body.toString();
        //System.debug('JK requestString ' + requestString);
        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c();
        RequestWrapper reqWrapper = (RequestWrapper)JSON.deserialize(requestString, RequestWrapper.class);
        System.debug('reqWrapper: ' + reqWrapper);
        if(reqWrapper.PBS_RSAP_Project_Contact != null){
            for(String projectContact : reqWrapper.PBS_RSAP_Project_Contact){
                //System.debug('JK projectContact ' + projectContact);
                //System.debug('JK substring ' + projectContact.substring(projectContact.lastIndexOf(',') + 1).trim());
                if(projectContact.contains('Leasing Specialist')){
                    leasingSpecialist = projectContact.substring(projectContact.lastIndexOf(',') + 1).trim();
                }
                if(projectContact.contains('Lease Contracting Officer')){
                    leaseContractingOfficer = projectContact.substring(projectContact.lastIndexOf(',') + 1).trim();
                }
                if(projectContact.contains('Broker Contractor')){
                    brokerContractor = projectContact.substring(projectContact.lastIndexOf(',') + 1).trim();
                }
            }
        }
        
        // checing if data exist
        List<PBS_AAAP_RLP__c> lstExistingRecs = [SELECT ID, PBS_RSAP_Solicitation_Status__c
                                                        FROM PBS_AAAP_RLP__c
                                                        WHERE PBS_RSAP_Solicitation_G_REX_ID__c =: reqWrapper.PBS_RSAP_Solicitation_G_REX_ID];
        System.debug('lstExistingRecs: ' + lstExistingRecs);
        if(!lstExistingRecs.isEmpty()){
            rlp.Id = lstExistingRecs[0].Id;
            //System.debug('lstExistingRecs not empty, Id is: ' + rlp.Id);
        }
        
        // mapping data
        rlp.PBS_RSAP_Solicitation_G_REX_ID__c  = reqWrapper.PBS_RSAP_Solicitation_G_REX_ID;
        rlp.PBS_RSAP_Solicitation_Number__c  = reqWrapper.PBS_RSAP_Solicitation_Number;
        rlp.PBS_RSAP_Project_Number__c = reqWrapper.PBS_RSAP_Project_Number;
        rlp.PBS_RSAP_City__c = reqWrapper.PBS_RSAP_City;
        rlp.PBS_RSAP_State__c = reqWrapper.PBS_RSAP_State;
        rlp.PBS_RSAP_Solicitation_Status__c = reqWrapper.PBS_RSAP_Solicitation_Status; 
        rlp.PBS_AAAP_Year__c = string.ValueOf(System.Today().year());  
        //JK changes from here
        rlp.PBS_RSAP_Broker__c = brokerContractor;
        rlp.PBS_RSAP_Lease_Contracting_Officer__c = leaseContractingOfficer;
        rlp.PBS_RSAP_Leasing_Specialist__c = leasingSpecialist;
        //System.debug('JK rlp to here: ' + rlp);
        //JK changes to here
        
        // setting record type
        rlp.recordTypeId =  Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
        upsert rlp;
        
        rlp.PBS_AAAP_STATUS__c = '';
        update rlp;        
        // Todd Brown 5/7/2025 as a fix for issue found during 2025 Merge Surge UAT testing replaced the following line of code
        // to properly determine if RLP Solicitation Status changed and needs to be propogated to related Offers' Status.
        //if(rlp.PBS_RSAP_Solicitation_Status__c != reqWrapper.PBS_RSAP_Solicitation_Status){
        if(!lstExistingRecs.isEmpty() && (lstExistingRecs[0].PBS_RSAP_Solicitation_Status__c != reqWrapper.PBS_RSAP_Solicitation_Status)){
            if(reqWrapper.PBS_RSAP_Solicitation_Status){
                changeOffersStatus(rlp.Id, 'Draft');
            } else {
                changeOffersStatus(rlp.Id, 'Closed');
            }
        }        
        return rlp.Id;
    }
    
    
    public class RequestWrapper{
        public string PBS_RSAP_Solicitation_G_REX_ID {get;set;}
        public string PBS_RSAP_Solicitation_Number {get;set;}        
        public string PBS_RSAP_Project_Number {get;set;}
        public string PBS_RSAP_City {get;set;}
        public string PBS_RSAP_State {get;set;}
        public Boolean PBS_RSAP_Solicitation_Status {get;set;}    
        //JK changes start here:
        public List<string> PBS_RSAP_Project_Contact {get; set;}
        //JK changes end here
    }

    @future
    public static void changeOffersStatus(Id rlpId, String status){
        System.debug('changeOffersStatus start, rlpId: ' + rlpId + ' status: ' + status);
        List<PBS_AAAP_Offer__c> offrLst = new List<PBS_AAAP_Offer__c>();
        List<PBS_AAAP_Offer__c> lstUpdOffer = new List<PBS_AAAP_Offer__c>();
        offrLst = [
                    SELECT
                            Id,
                            PBS_AAAP_Offer_Status__c
                    FROM PBS_AAAP_Offer__c
                    WHERE PBS_AAAP_RLP_Number__c = :rlpId
        ];

        if(offrLst.size() > 0) {
            for (PBS_AAAP_Offer__c off : offrLst) {
                off.PBS_AAAP_Offer_Status__c = status;
                lstUpdOffer.add(off);
            }
        }

        if(!lstUpdOffer.isEmpty()){
            update lstUpdOffer;
        }
    }
    
}