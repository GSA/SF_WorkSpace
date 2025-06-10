@IsTest
public class PBS_Leasing_PropertyController_Test {
    
    @isTest static void testCopyUserDetails() {
            PBS_Leasing_OfferPropertyWrapper.objectWrapper myRecord = new PBS_Leasing_OfferPropertyWrapper.objectWrapper();
            Test.startTest();
            PBS_Leasing_PropertyController.ResponseWrapper response = PBS_Leasing_PropertyController.copyUserDetails(myRecord);
            Test.stopTest();
    } 
    
    @IsTest
    public static void saveProperty(){
        // Create a test property record
        PBS_AAAP_Property__c property = new PBS_AAAP_Property__c(Name = 'test property', PBS_AAAP_Street_Address__c = 'test Address 123',
                                                                 PBS_AAAP_Parking_Onsite__c = 'Yes',
                                                                 PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 16);
        insert property;
        
        Test.StartTest();
        // Test the saveProperty method
        PBS_Leasing_PropertyController.ResponseWrapper response = PBS_Leasing_PropertyController.saveProperty(property, 'Offer-Location');
        // Assert that the property save was successful
        System.assertEquals(true, response.isSuccess, 'The property save should be successful.');
        System.assertEquals(0, response.errorMessages.size(), 'There should be no error messages.');
        
        // Test the addnewProperty method
        Id newPropertyId = PBS_Leasing_PropertyController.addnewProperty(property.Name, property.PBS_AAAP_Street_Address__c);
        // Assert that the new property was created and has a valid ID
        System.assertNotEquals(null, newPropertyId, 'The new property should be created and have a valid ID.');
        
        // Verify the new property was inserted by querying it
        PBS_AAAP_Property__c newProperty = [SELECT Id, Name FROM PBS_AAAP_Property__c WHERE Id = :newPropertyId];
        System.assertNotEquals(null, newProperty, 'The newly added property should exist in the database.');
        
        // Test the getPropertyDetails method
        PBS_AAAP_Property__c fetchedProperty = PBS_Leasing_PropertyController.getPropertyDetails(property.Id);
        // Assert that the fetched property matches the original property
        //System.assertEquals(property.Id, fetchedProperty.Id, 'The fetched property details should match the original property.');
        
        // Test the getGisConfig method
        Map<String, String> gisConfig = PBS_Leasing_PropertyController.getGisConfig();
        // Assert that the GIS configuration has the expected keys
        System.assert(gisConfig.containsKey('myGisUrlPrefix'), 'The GIS config should contain myGisUrlPrefix.');
        System.assert(gisConfig.containsKey('myGisLocatorUrl'), 'The GIS config should contain myGisLocatorUrl.');
        System.assert(gisConfig.containsKey('myGisLocator'), 'The GIS config should contain myGisLocator.');
        System.assert(gisConfig.containsKey('myGisToken'), 'The GIS config should contain myGisToken.');
        
        // Test the callGetCommunityURL method
        String modifiedPageUrl = 'https://workspace--wsdv16dvn.sandbox.my.salesforce.com/';
        String communityUrl = PBS_Leasing_PropertyController.callGetCommunityURL(modifiedPageUrl);
        // Assert that the community URL is returned and not null
        System.assertNotEquals(null, communityUrl, 'The community URL should be returned.');
        
        Test.StopTest();
    }
    
    @IsTest public static void testGetPropertyOfferDetails(){
        PBS_AAAP_Property__c property = new PBS_AAAP_Property__c(Name = 'test property', PBS_AAAP_Street_Address__c = 'test Address 123',
                                                                 PBS_AAAP_Parking_Onsite__c = 'Yes',
                                                                 PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 16);
        insert property;
        PBS_Leasing_OfferPropertyWrapper.objectWrapper result = PBS_Leasing_PropertyController.getPropertyOfferDetails(property.Id);
    }
    
    @isTest static void testGetPropertyInfo() {
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        
        PBS_AAAP_Property__c property1 = new PBS_AAAP_Property__c(
            PBS_AAAP_Building_Name__c = 'Building A',
            PBS_AAAP_Street_Address__c = '123 Test St',
            PBS_AAAP_City__c = 'Test City',
            PBS_AAAP_State__c = 'Test State',
            OwnerId = testUser.Id
        );
        
        PBS_AAAP_Property__c property2 = new PBS_AAAP_Property__c(
            PBS_AAAP_Building_Name__c = 'Building B',
            PBS_AAAP_Street_Address__c = '456 Test St',
            PBS_AAAP_City__c = 'Another City',
            PBS_AAAP_State__c = 'Another State',
            OwnerId = testUser.Id
        );
        
        insert new List<PBS_AAAP_Property__c>{property1, property2};
            PBS_Leasing_PropertyController.getPropertyInfo();
    }
    
    @isTest static void testUpdateOfferRecord() {
        
        RecordType offerRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'PBS_AAAP_Offer__c' AND Name = 'AAAP' LIMIT 1];
        
        PBS_AAAP_RLP__c testRLP = new PBS_AAAP_RLP__c(PBS_AAAP_RLP_Number__c = 'Region1', PBS_AAAP_STATUS__c = 'Posted/Active', PBS_AAAP_isActive__c = true,
                                                      PBS_RSAP_Solicitation_Status__c = true, PBS_RSAP_Solicitation_Number__c = '12345', PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '5',
                                                      PBS_AAAP_DEFAULT_MONTH_END__c = '20');
        insert testRLP;
        
        PBS_AAAP_Offer__c parentOfferRecord = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Building A',PBS_AAAP_Street_Address__c = '111 Test Ave',PBS_AAAP_City__c = 'City A',
                                                                    PBS_AAAP_State__c = 'State A', PBS_AAAP_Offer_Status__c = 'Draft',PBS_AAAP_RLP_Number__c = testRLP.Id,PBS_AAAP_Offer_Submission_Date__c = System.today());
        insert parentOfferRecord;
        
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        
        PBS_AAAP_Offer__c testOffer = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Building A',PBS_AAAP_Street_Address__c = '111 Test Ave',PBS_AAAP_City__c = 'City A',
                                                            PBS_AAAP_State__c = 'State A',RecordTypeId = offerRecordType.Id, PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Offer_Submission_Date__c = System.today(),
                                                            PBS_AAAP_Signature_First_Name__c = 'test1', PBS_AAAP_SIGNATURE_PIN__c = '34544', PBS_AAAP_SIGNATURE_MIDDLE_NAME__c = 't',
                                                            PBS_AAAP_SIGNATURE_LAST_NAME__c = 'test3', PBS_AAAP_RLP_Region__c = 'Region1',PBS_AAAP_RLP_Number__c = testRLP.Id, PBS_AAAP_Parent_Offer__c = parentOfferRecord.Id, 
                                                            PBS_AAAP_PARENT_NAME__c = 'test-parent-offer', PBS_AAAP_Owner_Zip__c = '12345', PBS_AAAP_Owner_State__c = 'test', 
                                                            PBS_AAAP_Owner_State_Reg__c = 'test', PBS_AAAP_floors_Suites_in_Offered_Space__c = 100, PBS_AAAP_OFFICE_SPACE_RSF__c = 10000,
                                                            PBS_AAAP_RETAIL_SPACE_RSF__c = 1000, PBS_AAAP_GARAGE_SPACE_RSF__c = 1000, PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 8000,
                                                            PBS_AAAP_Total_Surface_Parking_Spaces__c = 10, PBS_AAAP_Total_Structured_Parking_Spaces__c = 10, PBS_AAAP_Parking_Onsite__c = 'Yes',
                                                            PBS_AAAP_Owner_Name__c = 'test', PBS_AAAP_Owner_Address__c = 'testst', PBS_AAAP_Owner_City__c = 'test-city', PBS_AAAP_OFFEROR_INTEREST__c = 'Owner');
        insert testOffer;
        Test.startTest();
        PBS_Leasing_PropertyController.ResponseWrapper result = PBS_Leasing_PropertyController.updateOfferRecord(testOffer, 'Offer-Owner');
        
        PBS_AAAP_Property__c testProperty = new PBS_AAAP_Property__c(PBS_AAAP_Building_Name__c = testOffer.PBS_AAAP_Building_Name__c, PBS_AAAP_City__c = testOffer.PBS_AAAP_City__c,
                                                                     PBS_AAAP_State__c = testOffer.PBS_AAAP_State__c);
        insert testProperty;
        
        testOffer.Property__c = testProperty.Id;
        update testOffer;
        
        result = PBS_Leasing_PropertyController.updateOfferRecord(testOffer, 'Offer-Owner');
        String AAAPstateAbbr = PBS_Leasing_PropertyController.getAbbreviation(testOffer.PBS_AAAP_State__c);
        Test.stopTest();
    }
    
    @isTest static void testUpdateOfferRecordRSAP() {
        
        RecordType offerRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'PBS_AAAP_Offer__c' AND Name = 'RSAP' LIMIT 1];
        
        PBS_AAAP_RLP__c testRLP = new PBS_AAAP_RLP__c(PBS_AAAP_RLP_Number__c = 'Region1', PBS_AAAP_STATUS__c = 'Posted/Active', PBS_AAAP_isActive__c = true,
                                                      PBS_RSAP_Solicitation_Status__c = true, PBS_RSAP_Solicitation_Number__c = '12345', PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '5',
                                                      PBS_AAAP_DEFAULT_MONTH_END__c = '20');
        insert testRLP;
        
        PBS_AAAP_Offer__c parentOfferRecord = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Building A',PBS_AAAP_Street_Address__c = '111 Test Ave',PBS_AAAP_City__c = 'City A',
                                                                    PBS_AAAP_State__c = 'State A', PBS_AAAP_Offer_Status__c = 'Draft',PBS_AAAP_RLP_Number__c = testRLP.Id,PBS_AAAP_Offer_Submission_Date__c = System.today());
        insert parentOfferRecord;
        
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        
        PBS_AAAP_Offer__c testOffer = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Building A',PBS_AAAP_Street_Address__c = '111 Test Ave',PBS_AAAP_City__c = 'City A',
                                                            PBS_AAAP_State__c = 'State A',RecordTypeId = offerRecordType.Id, PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Offer_Submission_Date__c = System.today(),
                                                            PBS_AAAP_Signature_First_Name__c = 'test1', PBS_AAAP_SIGNATURE_PIN__c = '34544', PBS_AAAP_SIGNATURE_MIDDLE_NAME__c = 't',
                                                            PBS_AAAP_SIGNATURE_LAST_NAME__c = 'test3', PBS_AAAP_RLP_Region__c = 'Region1',PBS_AAAP_RLP_Number__c = testRLP.Id, PBS_AAAP_Parent_Offer__c = parentOfferRecord.Id, 
                                                            PBS_AAAP_PARENT_NAME__c = 'test-parent-offer', PBS_AAAP_Owner_Zip__c = '12345', PBS_AAAP_Owner_State__c = 'test', 
                                                            PBS_AAAP_Owner_State_Reg__c = 'test', PBS_AAAP_floors_Suites_in_Offered_Space__c = 100, PBS_AAAP_OFFICE_SPACE_RSF__c = 10000,
                                                            PBS_AAAP_RETAIL_SPACE_RSF__c = 1000, PBS_AAAP_GARAGE_SPACE_RSF__c = 1000, PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 8000,
                                                            PBS_AAAP_Total_Surface_Parking_Spaces__c = 10, PBS_AAAP_Total_Structured_Parking_Spaces__c = 10, PBS_AAAP_Parking_Onsite__c = 'Yes',
                                                            PBS_AAAP_Owner_Name__c = 'test', PBS_AAAP_Owner_Address__c = 'testst', PBS_AAAP_Owner_City__c = 'test-city', PBS_AAAP_OFFEROR_INTEREST__c = 'Owner');
        insert testOffer;
        Test.startTest();
        PBS_Leasing_PropertyController.ResponseWrapper result = PBS_Leasing_PropertyController.updateOfferRecord(testOffer, 'Offer-Owner');
        
        PBS_AAAP_Property__c testProperty = new PBS_AAAP_Property__c(PBS_AAAP_Building_Name__c = testOffer.PBS_AAAP_Building_Name__c, PBS_AAAP_City__c = testOffer.PBS_AAAP_City__c,
                                                                     PBS_AAAP_State__c = testOffer.PBS_AAAP_State__c);
        insert testProperty;
        
        testOffer.Property__c = testProperty.Id;
        update testOffer;
        
        result = PBS_Leasing_PropertyController.updateOfferRecord(testOffer, 'Offer-Owner');
        String RSAPstateAbbr = PBS_Leasing_PropertyController.getAbbreviation(testOffer.PBS_AAAP_State__c);
        Test.stopTest();
    }
    
    @isTest
    static void testCreatePropertyRecord() {
        Test.startTest();
        
        PBS_AAAP_Property__c testProperty = new PBS_AAAP_Property__c(PBS_AAAP_Building_Name__c = 'Test Building',PBS_AAAP_Street_Address__c = '123 Test St',
                                                                     PBS_AAAP_City__c = 'Test City',PBS_AAAP_State__c = 'Test State', PBS_AAAP_County__c = 'Test County',
                                                                     PBS_AAAP_X_CO_ORD__c = 12.345,PBS_AAAP_Y_CO_ORD__c = 67.890);
        
        PBS_Leasing_PropertyController.ResponseWrapper result = PBS_Leasing_PropertyController.createPropertyRecord(testProperty, 'offer-Location');
        Test.stopTest();
    }
    
    @isTest static void testCreatePropertyRecordWithError() {
        Test.startTest();
        PBS_AAAP_Property__c invalidProperty = new PBS_AAAP_Property__c();        
        PBS_Leasing_PropertyController.ResponseWrapper result = PBS_Leasing_PropertyController.createPropertyRecord(invalidProperty, 'offer-Overview');
        Test.stopTest();
    }
    
    @isTest static void testvalidateProperty() {
        Test.startTest();
        
        PBS_AAAP_Property__c testProperty = new PBS_AAAP_Property__c(PBS_AAAP_Building_Name__c = 'Test Building',PBS_AAAP_Street_Address__c = '123 Test St',
                                                                     PBS_AAAP_City__c = 'Test City', PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 8000, PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 1000,
                                                                    PBS_AAAP_OFFEROR_INTEREST__c = 'Other', PBS_AAAP_OFFEROR_INTEREST_OTHER__c = '');
        insert testProperty;
        PBS_Leasing_PropertyController.ResponseWrapper result = PBS_Leasing_PropertyController.validateProperty(testProperty, new List<String>{'Offer-Owner'});
        PBS_Leasing_PropertyController.ResponseWrapper result1 = PBS_Leasing_PropertyController.validateProperty(testProperty, new List<String>{'Offer-Overview'});
        PBS_Leasing_PropertyController.validateAllPropertyDetails(testProperty.Id, new List<String>{'Offer-Owner', 'Offer-Overview'});
        Test.stopTest();
    } 
    
    @isTest static void testvalidateOffer() {
        PBS_AAAP_Offer__c testOffer = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Building A',PBS_AAAP_Street_Address__c = '111 Test Ave',PBS_AAAP_City__c = 'City A', PBS_AAAP_OFFEROR_INTEREST_OTHER__c = '',
                                                            PBS_AAAP_OFFEROR_INTEREST__c = 'Other');
        insert testOffer;
        PBS_Leasing_PropertyController.ResponseWrapper result = PBS_Leasing_PropertyController.validateOffer(testOffer, 'offer-Owner');
        PBS_Leasing_PropertyController.ResponseWrapper result1 = PBS_Leasing_PropertyController.validateOffer(testOffer, 'Offer-Overview');
        
    } 
    
}