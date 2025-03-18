@isTest
public with sharing class Test_PBS_AAAP_PublishRLPController {
	@isTest
    public static void getAttachmentsTesting(){
        Id RecTypeId = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('AAAP').getRecordTypeId();
        PBS_AAAP_RLP__c rlp1 = new PBS_AAAP_RLP__c();
        rlp1.PBS_AAAP_RLP_Number__c = '123456';
        rlp1.PBS_AAAP_Title__c = 'RLP TEST';
        rlp1.PBS_AAAP_Region__c = 'Region 2';
        rlp1.PBS_AAAP_Year__c = '2019';
        rlp1.PBS_AAAP_STATUS__c = 'Posted/Active';
        rlp1.PBS_AAAP_TELCOMM_DEFAULT__c = 10;
        rlp1.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 10;
        rlp1.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 10;
        rlp1.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 10;
        rlp1.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp1.PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1';
        rlp1.PBS_AAAP_DEFAULT_MONTH_END__c = '15';
        rlp1.RecordTypeId = RecTypeId;
        insert rlp1;
        
        PBS_AAAP_RLP_Attachments__c rlpatt1 = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp1.id, PBS_AAAP_Attachment_Type__c = 'Standard');
        insert rlpatt1;
        
        List<PBS_AAAP_RLP_Attachments__c> attachments = PBS_AAAP_PublishRLPController.getAttachments(rlp1.Id);
        System.assertEquals(1, attachments.size(),'The size is not equals');
    }
}