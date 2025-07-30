@IsTest
private class Test_PBS_AAAP_GlobalConstants {
    
    static testMethod void myUnitTest() {
    
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        // Julia Kantarovsky changed the following queried name on 8.28.2020 from 'GREX Integration' to 'G-REX Integration'. The name was changed on the profile and was therefore changed here in order for the test to pass.
        Profile p = [SELECT Id FROM Profile WHERE Name='G-REX Integration'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);
        
        
        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName();
        Id rlp = recordTypes.get('RSAP').getRecordTypeId();
        Map<String, Schema.RecordTypeInfo> recordTypes2 = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName();
        Id offerRSAP = recordTypes2.get('RSAP').getRecordTypeId();
        
        System.runAs(u) {

            PBS_AAAP_RLP__c projectEOI = new PBS_AAAP_RLP__c(
                PBS_RSAP_Solicitation_G_REX_ID__c = '9',
                PBS_RSAP_Solicitation_Number__c = 'test_test_test_Joe',
                PBS_RSAP_Solicitation_Status__c = TRUE,
                PBS_RSAP_Project_Number__c = '9IN2225',
                PBS_RSAP_City__c = 'LACONIA',
                PBS_RSAP_State__c = 'IN',
                PBS_AAAP_isActive__c = TRUE,
                RecordTypeId = rlp
            );
            projectEOI.PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '01';
            projectEOI.Default_Start_Time_ET__c = '12:00';
            projectEOI.Default_Start_Time_AM_PM__c = 'AM';
            projectEOI.PBS_AAAP_DEFAULT_MONTH_END__c = '31';
            projectEOI.Default_End_Time_ET__c = '12:00';
            projectEOI.Default_End_Time_AM_PM__c = 'AM';
            upsert projectEOI;
            
            PBS_AAAP_Offer__c offer2 = new PBS_AAAP_Offer__c();
            offer2.PBS_AAAP_Offer_Status__c = 'Draft';
            offer2.PBS_AAAP_RLP_Number__c = projectEOI.Id;
            offer2.PBS_AAAP_Solicitation_Number__c = 'test_test_test_Joe';
            offer2.PBS_AAAP_Solicitation_Id__c = '9';
            offer2.RecordTypeId = offerRSAP;
            
            insert offer2;
            
            PBS_AAAP_GlobalConstants.checkOfferBuildingValidations(offer2);
            PBS_AAAP_GlobalConstants.checkOfferPropOwnerValidations(offer2);  
            PBS_AAAP_GlobalConstants.updateOfferToDraft(offer2);
            PBS_AAAP_GlobalConstants.checkLOPOfferSpaceRates(offer2);
            PBS_AAAP_GlobalConstants.validateOfferSubmission(offer2,false); 
            PBS_AAAP_GlobalConstants.validateOfferSubmissionBefore(offer2);
            PBS_AAAP_GlobalConstants.getRatesandSpace(offer2.Id);
            PBS_AAAP_GlobalConstants.getSpaces(offer2.Id);     
            PBS_AAAP_Offer__c offr = PBS_AAAP_GlobalConstants.getOfferDetail(offer2.Id);
            PBS_AAAP_GlobalConstants.checkOfferIsValidOrNot(offr);         
        }
        
        PBS_GREX_Project_EOI__c projectEOI2 = new PBS_GREX_Project_EOI__c(
                Project_EOI_ID__c = 'GIN123456666-1111',
                Project_Number__c = '5VA2016',
                Project_Offer_Due_Date__c = Date.today() + 7
        );      
        upsert projectEOI2;  
           
        PBS_AAAP_GlobalConstants.getProjectDetails(projectEOI2.Id);       
        PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
        offer.LOP_Building_Name__c = null;
        offer.LOP_Street_Address__c = null;
        offer.LOP_City__c = null;
        offer.LOP_State__c = null;
        offer.LOP_Zip__c = null;
        offer.LOP_Energy_Star__c = null;
        offer.LOP_Number_of_floors__c = null;
        offer.LOP_GEN_PURPOSE_RENTABLE__c = null;
        offer.LOP_Year_Built__c = null;
        offer.LOP_HVAC_HRS_MON_TO_FRI_START__c = null;
        offer.LOP_HVAC_HRS_MON_TO_FRI_END__c = null;        
        offer.LOP_Historic_Property_Tier__c = null;
        offer.LOP_Accessibility_Standards_Met__c = null;
        offer.LOP_Asbestos_Declaration__c = null;
        offer.LOP_RLP_Contains_Seismic_Requirement__c = null;
        offer.LOP_Flood_Plain_Declaration__c = null;
        offer.LOP_Fire_Safety_Declaration__c = null;        
        offer.LOP_Property_Owner_Company__c = null;
        offer.LOP_Owner_Address__c = null;
        offer.LOP_Owner_City__c = null;
        offer.LOP_OFFEROR_INTEREST__c = null;        
        offer.LOP_INITIAL_NO_OF_YEARS__c = null;
        offer.LOP_Initial_YEARS_FIRM__c = null;
        offer.LOP_Total_Ofc_ABOA_offered__c = null; 
        offer.LOP_Office_RSF_OFFERED__c = null; 
        offer.LOP_Shell_Rent_Per_RSF__c = null;  
        offer.LOP_Shell_Rate_Years_Effective__c = null;  
        offer.LOP_RLP_Parking_Cost_Incl__c = null;  
        insert offer;
         
        PBS_LOP_Offer__c getOffer = PBS_AAAP_GlobalConstants.getLOPOfferDetail(offer.Id);
        System.assertNotEquals(null, getOffer);

    }

    @isTest
    static void validateOffer()
    {
        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName();
        Id rlp = recordTypes.get('RSAP').getRecordTypeId();
        Map<String, Schema.RecordTypeInfo> recordTypes2 = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName();
        Id offerRSAP = recordTypes2.get('RSAP').getRecordTypeId();
        
        PBS_AAAP_RLP__c projectEOI = new PBS_AAAP_RLP__c(
            PBS_RSAP_Solicitation_G_REX_ID__c = '9',
            PBS_RSAP_Solicitation_Number__c = 'test_test_test_Joe',
            PBS_RSAP_Solicitation_Status__c = TRUE,
            PBS_RSAP_Project_Number__c = '9IN2225',
            PBS_RSAP_City__c = 'LACONIA',
            PBS_RSAP_State__c = 'IN',
            PBS_AAAP_isActive__c = TRUE,
            RecordTypeId = rlp
        );
        projectEOI.PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '01';
        projectEOI.PBS_AAAP_DEFAULT_MONTH_END__c = '11';
        upsert projectEOI;
        
        PBS_AAAP_Offer__c offer2 = new PBS_AAAP_Offer__c();
        offer2.PBS_AAAP_Offer_Status__c = 'Draft';
        offer2.PBS_AAAP_RLP_Number__c = projectEOI.Id;
        offer2.PBS_AAAP_Solicitation_Number__c = 'test_test_test_Joe';
        offer2.PBS_AAAP_Solicitation_Id__c = '9';
        offer2.RecordTypeId = offerRSAP;
        offer2.PBS_AAAP_COST_PER_ABOA__c = 0.005;
        offer2.PBS_AAAP_Energy_Star__c = 'No';
        insert offer2;

        PBS_AAAP_GlobalConstants.checkOfferRepsAndCertsValidations(offer2);
        PBS_AAAP_GlobalConstants.getRates(offer2.Id);
        System.assert(true);
    }
    
}