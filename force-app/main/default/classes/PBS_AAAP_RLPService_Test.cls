@isTest
public class PBS_AAAP_RLPService_Test {    
    
    public static testMethod void getPhoneUser() {
        PBS_AAAP_RLPService.RequestWrapper obj = new PBS_AAAP_RLPService.RequestWrapper();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/RLPService'; 
        req.addParameter('phoneNumber', '9876543210');
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{		"PBS_RSAP_Solicitation_G_REX_ID" : "1234567893",		"PBS_RSAP_Solicitation_Number" : "24kjkjh325kj542",		"PBS_RSAP_Project_Number" : "1234567",		"PBS_RSAP_City" : "Washington",		"PBS_RSAP_State" : "DC",		"PBS_RSAP_Solicitation_Status" : true	}');
        RestContext.request = req;
        RestContext.response = res;        
        
        
        string resp = PBS_AAAP_RLPService.doPost();
        System.assertNotEquals(null, resp, 'Response should not be null');
        
    }
    
    public static testMethod void getPhoneUser2() {
        PBS_AAAP_RLPService.RequestWrapper obj = new PBS_AAAP_RLPService.RequestWrapper();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/RLPService';
        req.addParameter('phoneNumber', '9876543210');
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{		"PBS_RSAP_Solicitation_G_REX_ID" : "1234567893",		"PBS_RSAP_Solicitation_Number" : "24kjkjh325kj542",		"PBS_RSAP_Project_Number" : "1234567",		"PBS_RSAP_City" : "Washington",		"PBS_RSAP_State" : "DC",		"PBS_RSAP_Solicitation_Status" : true	}');
        RestContext.request = req;
        RestContext.response = res;
        
        
        string resp = PBS_AAAP_RLPService.doPost();
        
        PBS_AAAP_Offer__c off = new PBS_AAAP_Offer__c();
        off.PBS_AAAP_RLP_Number__c = Id.valueOf(resp);
        insert off;
        
        
        PBS_AAAP_RLPService.RequestWrapper obj2 = new PBS_AAAP_RLPService.RequestWrapper();
        
        RestRequest req2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/RLPService';
        req2.addParameter('phoneNumber', '9876543210');
        req2.httpMethod = 'POST';
        req2.requestBody = Blob.valueof('{		"PBS_RSAP_Solicitation_G_REX_ID" : "1234567893",		"PBS_RSAP_Solicitation_Number" : "24kjkjh325kj542",		"PBS_RSAP_Project_Number" : "1234567",		"PBS_RSAP_City" : "Washington",		"PBS_RSAP_State" : "DC",		"PBS_RSAP_Solicitation_Status" : false	}');
        
        RestContext.request = req2;
        RestContext.response = res2;
        
        string resp2 = PBS_AAAP_RLPService.doPost();
        System.assertNotEquals(null, resp2, 'Response should not be null');
    }
    //Julia Kantarovsky changes start here 2.9.21
    public static testMethod void testNewData() {
        //System.debug('JK testNewData');
        PBS_AAAP_RLPService.RequestWrapper obj = new PBS_AAAP_RLPService.RequestWrapper();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/RLPService'; 
        req.addParameter('phoneNumber', '9876543210');
        req.httpMethod = 'POST';
        //req.requestBody = Blob.valueof('{		"PBS_RSAP_Solicitation_G_REX_ID" : "1234567893",		"PBS_RSAP_Solicitation_Number" : "24kjkjh325kj542",		"PBS_RSAP_Project_Number" : "1234567",		"PBS_RSAP_City" : "Washington",		"PBS_RSAP_State" : "DC",		"PBS_RSAP_Solicitation_Status" : true	}');
        
        req.requestBody = Blob.valueOf('{"PBS_RSAP_Solicitation_G_REX_ID":"321","PBS_RSAP_Solicitation_Number":"ABCDEFG","PBS_RSAP_Project_Number":"HIJKLMN","PBS_RSAP_City":"MILWAUKEE","PBS_RSAP_State":"WI","PBS_RSAP_Solicitation_Status":true,"PBS_RSAP_Agency":"SMALL BUSINESS ADMINISTRATION","PBS_RSAP_Lease_Acquisition_Strategy":"SLAT - Competitive - TI Allowance ","PBS_RSAP_Project_Contact":["Leasing Specialist, Jane Doe, N/A, jane.doe@gsa.gov","Lease Contracting Officer, John Doe, N/A, john.doe@gsa.gov","Broker Contractor, Joe Doe, N/A, joe.doe@gsa.gov"]}');       
        
        RestContext.request = req;
        RestContext.response = res;        
        
        string resp = PBS_AAAP_RLPService.doPost();
        //System.debug('JK in test resp ' + resp);
        System.assertNotEquals(null, resp, 'Response should not be null');
        
    }
    //JK changes end here
    @isTest
    public static void testChangeOffersStatus(){
        //create test data
        PBS_AAAP_RLP__c rlpRecord = new PBS_AAAP_RLP__c(PBS_AAAP_RLP_Number__c = '1234', PBS_AAAP_Title__c = 'test',
                                                        PBS_AAAP_Region__c = 'Region 1', PBS_AAAP_Year__c = '2024',
                                                        PBS_AAAP_TELCOMM_DEFAULT__c = 20.20, PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 10.03,
                                                        PBS_AAAP_DEFAULT_MONTH_BEGIN__c	= '5', PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 12.02,
                                                        PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c	= 16.02, PBS_AAAP_MOVE_DEFAULT__c = 13.05,
                                                        PBS_AAAP_DEFAULT_MONTH_END__c = '7');
        insert rlpRecord;
        
        PBS_AAAP_Offer__c offRecord = new PBS_AAAP_Offer__c(PBS_AAAP_RLP_Number__c = rlpRecord.Id, PBS_AAAP_Offer_Status__c = 'Draft');
		insert offRecord;
        Test.startTest();
        // call apex method 'changeOffersStatus'
        PBS_AAAP_RLPService.changeOffersStatus(rlpRecord.Id, 'Draft');
        test.stopTest();
        System.assertNotEquals(null, rlpRecord.Id, 'Response should not be null');
    }
}