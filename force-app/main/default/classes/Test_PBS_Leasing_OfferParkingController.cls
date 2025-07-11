@isTest
public class Test_PBS_Leasing_OfferParkingController {
	@isTest
    public static void doTest(){
        // Create a test PBS_AAAP_RLP__c record
        PBS_AAAP_RLP__c testRLP = new PBS_AAAP_RLP__c(PBS_AAAP_RLP_Number__c = 'Test AAAP', PBS_AAAP_Region__c = 'Census', PBS_AAAP_Title__c = 'TestAAAP',
                                                      PBS_AAAP_Year__c = '2023', PBS_AAAP_TELCOMM_DEFAULT__c = 50, PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 50,
                                                      PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1', PBS_AAAP_DEFAULT_MONTH_END__c ='31', PBS_AAAP_MOVE_DEFAULT__c =12.00,
                                                      PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 50000, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 50000,
                                                      PBS_AAAP_Posted_Date__c = Date.today().addDays(-10));
        insert testRLP;
        
        // Create a test PBS_AAAP_Offer__c record
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Test Building', PBS_AAAP_Street_Address__c = '123 Test St',
                                                           PBS_AAAP_Country__c = 'Test Country',PBS_AAAP_City__c = 'Test City',
                                                           PBS_AAAP_State__c = 'Test State',PBS_AAAP_ZipCode__c = '12345', PBS_AAAP_RLP_Number__c = testRLP.Id,  
                                                           PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Offer_Submission_Date__c = Date.today(),PBS_AAAP_Vacant_Premise_Rate__c = 10,
                                                           PBS_AAAP_Signature_First_Name__c = 'test', PBS_AAAP_SIGNATURE_LAST_NAME__c = 'user',PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 1000,
                                                           PBS_AAAP_OFFICE_SPACE_RSF__c = 600, PBS_AAAP_RETAIL_SPACE_RSF__c = 200, PBS_AAAP_GARAGE_SPACE_RSF__c = 200, 
                                                           PBS_AAAP_OFFEROR_INTEREST__c = 'Owner', PBS_AAAP_ACK_LTR_COMPLETED__c = 'No',PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'No',
                                                           PBS_AAAP_Owner_Name__c = 'Test User', PBS_AAAP_X_CO_ORD__c = 123.00, PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true, 
                                                           PBS_AAAP_Y_CO_ORD__c = 456.60, PBS_AAAP_Is_Offer_Valid__c = true);
        insert offerRec;
        PBS_Leasing_OfferParkingController clsObj = new PBS_Leasing_OfferParkingController();
        PBS_Leasing_OfferParkingController.getPropertyOfferDetails(offerRec.Id);
        PBS_AAAP_Utility.OfferValidationResponse obj = PBS_Leasing_OfferParkingController.updateOfferRecord(offerRec,'pageName');
        Assert.areEqual(true, obj.success, 'Should be true');
        offerRec.PBS_AAAP_Building_Name__c = 'Test BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest BuildingTest Building';
        PBS_Leasing_OfferParkingController.updateOfferRecord(offerRec,'pageName');
    }
}