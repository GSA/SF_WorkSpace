@isTest
public class PBS_Leasing_ProgressBarControllerTest {
    @isTest
    public static void testPBSLeasingProgressBar(){
        
        // Create a new instance of the Progress_Bar_Step__mdt custom metadata type
        Progress_Bar_Step__mdt progressBar = new Progress_Bar_Step__mdt();
        
        // Call the apex class method to retrieve the progress bar steps by name
        List<Progress_Bar_Step__mdt> steps = PBS_Leasing_ProgressBarController.getSteps('AAAP_Workflow');
        System.assertNotEquals(steps.size(), 0 , 'Steps Should be Available');
    }
    
    @isTest
    public static void testgetPBS_AAAP_RLP_ObjRecords(){
        //Create a new RLP record and a related AAAP Offer record
        PBS_AAAP_RLP__c rlpObj = new PBS_AAAP_RLP__c(PBS_RSAP_Solicitation_Number__c = '1',PBS_RSAP_Solicitation_Status__c = true,
                                                     PBS_RSAP_City__c = 'test', PBS_RSAP_State__c = 'PA', PBS_RSAP_Broker__c = 'test',
                                                     PBS_RSAP_Lease_Contracting_Officer__c = 'test', PBS_RSAP_Leasing_Specialist__c = 'testing');
        insert rlpObj;
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'AAAPtest', PBS_AAAP_RLP_Number__c = rlpObj.Id); 
        insert offerRec;  
        
        //Call the method to fetch RLP object records associated with the given offer
        PBS_Leasing_ProgressBarController.getPBS_AAAP_RLP_ObjRecords(offerRec.Id);
        PBS_Leasing_ProgressBarController.getPBS_AAAP_Offer_ObjRecords(offerRec.Id);
        
    }
}