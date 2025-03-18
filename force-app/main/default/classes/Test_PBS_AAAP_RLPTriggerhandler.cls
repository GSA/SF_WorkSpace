@IsTest
public class Test_PBS_AAAP_RLPTriggerhandler {
    static testMethod void createRLPTest() {
        PBS_AAAP_RLP__c rlp1 = PBS_AAAP_UtilityTest.createRLP();
        insert rlp1;
        system.assert(rlp1.Id != null);

        rlp1.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
        update rlp1;

        rlp1.PBS_AAAP_MAX_TIUSED__c = 60.00;
        try {
            update rlp1;
        } catch (exception ex) {

            system.assertNotEquals('You can update only start and end fields once RLP is in Posted status', ex.getMessage());
        }

        rlp1.PBS_AAAP_Canceled_Date__c = Date.today() + 1;
        rlp1.PBS_AAAP_Canceled_Reason__c = 'Reason for cancel';
        update rlp1;
        System.assert(rlp1.PBS_AAAP_Canceled_Reason__c != null);


        PBS_AAAP_RLP__c rlp2 = PBS_AAAP_UtilityTest.createRLP();
        insert rlp2;

        rlp2.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_REPLACED;
        try {
            update rlp2;
        } catch (Exception ex) {

        }
        rlp2.Replaced_RLP__c = rlp1.Id;
        update rlp2;
        System.assert(rlp2.Replaced_RLP__c != null);

        PBS_AAAP_RLP__c rlp0 = PBS_AAAP_UtilityTest.createRLP();
        rlp0.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
        insert rlp0;
        system.assert(rlp0.Id != null);


        PBS_AAAP_RLP__c rlpRec = PBS_AAAP_UtilityTest.createRLP();
        rlpRec.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_DRAFT;

        insert rlpRec;
        rlpRec.Replaced_RLP__c = rlp0.Id;
        rlpRec.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
        //rlpRec.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_REPLACED;


        update rlpRec;

    }
	
}