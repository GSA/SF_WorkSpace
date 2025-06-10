@isTest
public class PBS_Leasing_OfferPropertyWrapper_Test {
@testSetup
    static void setupTestData() {
        // Create a Property record
        PBS_AAAP_Property__c testProperty = new PBS_AAAP_Property__c(
            PBS_AAAP_Building_Name__c = 'Test Building',
            PBS_AAAP_State__c = 'CA',
            PBS_AAAP_Street_Address__c = '123 Test St',
            PBS_AAAP_City__c = 'Test City',
            PBS_AAAP_Common_Area_Factor__c = 10.0,
            PBS_AAAP_Country__c = 'USA',
            PBS_AAAP_County__c = 'Test County',
            PBS_AAAP_OFFICE_SPACE_RSF__c = 5000.0,
            PBS_AAAP_isBuildingProblem__c = false,
            PBS_AAAP_LEGACY_X_CO_ORD__c = 100.0,
            PBS_AAAP_Legacy_Y_CO_ORD__c = 200.0,
            PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '5:00 PM',
            PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM',
            PBS_AAAP_Monthly_cost_nonres_gar_park__c = 100.0,
            PBS_AAAP_Monthly_cost_nonres_sur_park__c = 80.0,
            PBS_AAAP_floors_Suites_in_Offered_Space__c = 2,
            PBS_AAAP_OFFEROR_INTEREST__c = 'Test Interest',
            OwnerId = UserInfo.getUserId(),
            PBS_AAAP_ZipCode__c = '12345'
        );
        insert testProperty;
        
        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c(PBS_AAAP_Category__c = 'Office', PBS_AAAP_DEFAULT_MONTH_END__c = '10',
                PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1', PBS_AAAP_DISCOUNT_RATE__c = 12.00,
                PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00,
                PBS_AAAP_Discount_percent_Rate__c = 5.00,
                PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50,
                PBS_AAAP_isActive__c = TRUE,
                PBS_AAAP_MOVE_DEFAULT__c = 2.00,
                PBS_AAAP_TELCOMM_DEFAULT__c = 2.00, PBS_AAAP_MAX_TIUSED__c = 52.00,
                PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 2.00, PBS_AAAP_Year__c = '2012',
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/Active',
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 20.00, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 4.00,
                PBS_AAAP_Title__c = 'Washington DC', PBS_AAAP_RLP_Number__c = '12-NCR', PBS_AAAP_ALLOW_TIER2_AMMORT__c = true, PBS_AAAP_BSAC_per_ABOA__c = 0);

        insert rlp;
        
         // Create a Offer record
        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c(
            PBS_AAAP_Building_Name__c = 'Offer Building',
            PBS_AAAP_State__c = 'NY',
            PBS_AAAP_Street_Address__c = '456 Offer Avenue',
            PBS_AAAP_City__c = 'Offer City',
            PBS_AAAP_Country__c = 'USA',
            PBS_AAAP_ZipCode__c = '67890',
            PBS_AAAP_RLP_Number__c = rlp.id // Will be set after RLP record is created
        );
        insert offer;
    }

    @isTest
    static void testGetPropertyDetails() {
        // Retrieve the Id of the test property record
        PBS_AAAP_Property__c testProperty = [SELECT Id FROM PBS_AAAP_Property__c LIMIT 1];

        // Call the method for record type 'Property'
        PBS_Leasing_OfferPropertyWrapper.objectWrapper result = PBS_Leasing_OfferPropertyWrapper.getPropertyDetails(testProperty.Id);

        // Validate that the result is not null and has the expected values
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(testProperty.Id, result.Id, 'Ids should match');
        System.assertEquals('Test Building', result.PBS_AAAP_Building_Name, 'Building names should match');
        System.assertEquals('CA', result.PBS_AAAP_State, 'States should match');
        System.assertEquals('123 Test St', result.PBS_AAAP_Street_Address, 'Street addresses should match');
        System.assertEquals('Test City', result.PBS_AAAP_City, 'Cities should match');
        System.assertEquals(10.0, result.PBS_AAAP_Common_Area_Factor, 'Common area factors should match');
        System.assertEquals('USA', result.PBS_AAAP_Country, 'Countries should match');
        System.assertEquals('Test County', result.PBS_AAAP_County, 'Counties should match');
        System.assertEquals(5000.0, result.PBS_AAAP_OFFICE_SPACE_RSF, 'Office space RSF should match');
        System.assertEquals(false, result.PBS_AAAP_isBuildingProblem, 'Building problem flag should match');
        System.assertEquals('12345', result.PBS_AAAP_ZipCode, 'Zip codes should match');
        System.assertEquals('5:00 PM', result.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END, 'HVAC end hours should match');
        System.assertEquals('9:00 AM', result.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START, 'HVAC start hours should match');
    }
    
    @isTest
    static void testGetPropertyDetailsForOffer() {
        // Fetch the Offer ID
        PBS_AAAP_Offer__c offer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];

        // Call the method for 'Offer' type
        PBS_Leasing_OfferPropertyWrapper.objectWrapper result = (PBS_Leasing_OfferPropertyWrapper.objectWrapper) 
            PBS_Leasing_OfferPropertyWrapper.getPropertyDetails(offer.Id);

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(offer.Id, result.Id, 'Offer ID should match');
        System.assertEquals('Offer Building', result.PBS_AAAP_Building_Name, 'Building name should match');
        System.assertEquals('Offer City', result.PBS_AAAP_City, 'City should match');
    }
    
    @isTest
    static void testSaveUserDetailsForOffer() { //tests PropertyOwner "Same as Offeror" checkbox functionality
        PBS_AAAP_Offer__c offer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        PBS_Leasing_OfferPropertyWrapper.objectWrapper result = PBS_Leasing_OfferPropertyWrapper.getPropertyDetails(offer.Id);
        result.PBS_AAAP_Owner_Name = 'Another Name';
        result.PBS_AAAP_SIGNATURE_LAST_NAME = 'Name';
        result.PBS_AAAP_Signature_First_Name = 'Another';
        result.PBS_AAAP_Owner_Address = '200000 Some Other Street';
        result.PBS_AAAP_Owner_City = 'Somecity';
        result.PBS_AAAP_Owner_State = 'Washington';
        result.PBS_AAAP_Owner_Zip = '44444';
        result.PBS_AAAP_Owner_Country = 'US';
        result.PBS_RSAP_Property_Owner_Same_as_Offeror = TRUE;
        result.PBS_AAAP_OFFEROR_INTEREST = 'Owner';
        PBS_Leasing_OfferPropertyWrapper.saveUserDetails(result);
        result = PBS_Leasing_OfferPropertyWrapper.getPropertyDetails(offer.Id);
        System.assertEquals('Somecity', result.PBS_AAAP_Owner_City, 'Owner City should match.');
    }  

    @isTest
    static void testSaveUserDetailsForProperty() { //tests PropertyOwner "Same as Offeror" checkbox functionality
        PBS_AAAP_Property__c testProperty = [SELECT Id FROM PBS_AAAP_Property__c LIMIT 1];
        PBS_Leasing_OfferPropertyWrapper.objectWrapper result = PBS_Leasing_OfferPropertyWrapper.getPropertyDetails(testProperty.Id);
        result.PBS_AAAP_Owner_Name = 'Another Name';
        result.PBS_AAAP_SIGNATURE_LAST_NAME = 'Name';
        result.PBS_AAAP_Signature_First_Name = 'Another';
        result.PBS_AAAP_Owner_Address = '200000 Some Other Street';
        result.PBS_AAAP_Owner_City = 'Somecity';
        result.PBS_AAAP_Owner_State = 'Washington';
        result.PBS_AAAP_Owner_Zip = '44444';
        result.PBS_AAAP_Owner_Country = 'US';
        result.PBS_RSAP_Property_Owner_Same_as_Offeror = TRUE;
        result.PBS_AAAP_OFFEROR_INTEREST = 'Owner';
        PBS_Leasing_OfferPropertyWrapper.saveUserDetails(result);
        result = PBS_Leasing_OfferPropertyWrapper.getPropertyDetails(testProperty.Id);
        System.assertEquals('Somecity', result.PBS_AAAP_Owner_City, 'Owner City should match.');
    }
    
    @isTest
    static void testValidateProperty(){
        PBS_AAAP_Property__c testPro = [SELECT Id, PBS_AAAP_Building_Name__c,PBS_AAAP_State__c,PBS_AAAP_Street_Address__c,PBS_AAAP_City__c,PBS_AAAP_Common_Area_Factor__c,
                                        PBS_AAAP_Country__c,PBS_AAAP_County__c,PBS_AAAP_OFFICE_SPACE_RSF__c,PBS_AAAP_isBuildingProblem__c,PBS_AAAP_LEGACY_X_CO_ORD__c,
                                        PBS_AAAP_User_Defined_Address__c,PBS_AAAP_Legacy_Y_CO_ORD__c,PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c,PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c,
                                        PBS_AAAP_Monthly_cost_nonres_gar_park__c,PBS_AAAP_Monthly_cost_nonres_sur_park__c,PBS_AAAP_Monthly_cost_res_gar_park__c,
                                        PBS_AAAP_Monthly_cost_res_sur_park__c,PBS_AAAP_floors_Suites_in_Offered_Space__c,PBS_AAAP_OFFEROR_INTEREST__c,PBS_AAAP_OFFEROR_INTEREST_OTHER__c,
                                        PBS_AAAP_GARAGE_SPACE_RSF__c,OwnerId,PBS_AAAP_Parking_Onsite__c,Name,PBS_AAAP_Owner_City__c,PBS_AAAP_Owner_Name__c,
                                        PBS_RSAP_Property_Owner_Same_as_Offeror__c,PBS_AAAP_Owner_State__c,PBS_AAAP_Owner_Address__c,PBS_AAAP_Owner_Zip__c,PBS_AAAP_HVAC_HRS_ON_SAT_END__c,
                                        PBS_AAAP_HVAC_HRS_ON_SAT_START__c,PBS_AAAP_HVAC_HRS_ON_SUN_END__c,PBS_AAAP_HVAC_HRS_ON_SUN_START__c,PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c,
                                        PBS_AAAP_GEN_PURPOSE_RENTABLE__c,PBS_AAAP_Total_Park_Spaces_Offered__c,PBS_AAAP_Total_Structured_Parking_Spaces__c,PBS_AAAP_Total_Surface_Parking_Spaces__c,
                                        PBS_AAAP_DUNS_Number__c,PBS_AAAP_RETAIL_SPACE_RSF__c,PBS_AAAP_X_CO_ORD__c,PBS_AAAP_Y_CO_ORD__c,PBS_AAAP_Renovation_Year__c
                            			,PBS_AAAP_Year_Built__c,PBS_AAAP_ZipCode__c FROM PBS_AAAP_Property__c LIMIT 1];
        testPro.PBS_AAAP_Renovation_Year__c = '';
        testPro.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '';
        testPro.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '';
        update testPro;
        PBS_Leasing_OfferPropertyWrapper.validateProperty(testPro, 'offer-Overview');
    }
}