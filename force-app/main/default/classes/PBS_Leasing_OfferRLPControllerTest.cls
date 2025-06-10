@isTest
public class PBS_Leasing_OfferRLPControllerTest {
    @testSetup
    static void setupTestData() {
        Id offerRecordType = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('AAAP').getRecordTypeId();
        
        Id rlpRecordType = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('AAAP').getRecordTypeId();
        
        PBS_AAAP_Property__c testProperty = new PBS_AAAP_Property__c(PBS_AAAP_County__c = 'Fillmore County', PBS_AAAP_City__c = 'Spring Valley',
                                                                     PBS_AAAP_State__c = 'MN');
        insert testProperty;
        
        List<PBS_AAAP_RLP__c> rlpList = new List<PBS_AAAP_RLP__c>();
        rlpList.add(new PBS_AAAP_RLP__c(PBS_AAAP_RLP_Number__c = 'NCR', PBS_RSAP_Project_Number__c = 'Proj-12',
                                        PBS_RSAP_Solicitation_Number__c = 'Sol-12345', PBS_RSAP_Solicitation_G_REX_ID__c = 'G-REX-2025',
                                        PBS_RSAP_Solicitation_Status__c = true, PBS_AAAP_Region__c = 'Region 1',
                                        RecordTypeId = rlpRecordType, PBS_AAAP_STATUS__c = 'Posted/Active',
                                        PBS_AAAP_isActive__c = TRUE));
        insert rlpList;
        
        
        PBS_AAAP_RLP_Regions_Map__c testMap = new PBS_AAAP_RLP_Regions_Map__c(PBS_AAAP_Region_Name__c = 'National Capital Region',
                                                                              PBS_AAAP_RLP_State_Abbrevation__c = testProperty.PBS_AAAP_State__c, 
                                                                              PBS_AAAP_RLP_State__c = 'Herndon');
        insert testMap;  
        
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Test Building', PBS_AAAP_Street_Address__c = '123 Test St',
                                                           PBS_AAAP_Country__c = 'Test Country',PBS_AAAP_City__c = 'Test City', RecordTypeId = offerRecordType,
                                                           PBS_AAAP_State__c = 'Test State',PBS_AAAP_ZipCode__c = '12345', //PBS_AAAP_RLP_Number__c = rlpList.Id,  
                                                           PBS_AAAP_Offer_Status__c = 'Draft', PBS_AAAP_Offer_Submission_Date__c = Date.today(),PBS_AAAP_Vacant_Premise_Rate__c = 10,
                                                           PBS_AAAP_Signature_First_Name__c = 'test', PBS_AAAP_SIGNATURE_LAST_NAME__c = 'user',PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 1000,
                                                           PBS_AAAP_OFFICE_SPACE_RSF__c = 600, PBS_AAAP_RETAIL_SPACE_RSF__c = 200, PBS_AAAP_GARAGE_SPACE_RSF__c = 200, 
                                                           PBS_AAAP_OFFEROR_INTEREST__c = 'Owner', PBS_AAAP_ACK_LTR_COMPLETED__c = 'No',PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'No',
                                                           PBS_AAAP_Owner_Name__c = 'Test User', PBS_AAAP_X_CO_ORD__c = 123.00, PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true, 
                                                           PBS_AAAP_Y_CO_ORD__c = 456.60, PBS_AAAP_Is_Offer_Valid__c = true);
        insert offerRec;    
    }
    
    @isTest
    static void testSearchRecords() {
        setupTestData();
        PBS_AAAP_Property__c prop = [SELECT Id FROM PBS_AAAP_Property__c LIMIT 1];
        List<PBS_AAAP_RLP__c> rlp = [SELECT Id, PBS_RSAP_Solicitation_Number__c, PBS_AAAP_RLP_Number__c FROM PBS_AAAP_RLP__c  where PBS_RSAP_Solicitation_Number__c = 'Sol-12345' LIMIT 1];
        
        PBS_Leasing_OfferRLPController.RLPResponseWrapper response0 = PBS_Leasing_OfferRLPController.searchRecords('', prop.Id);
        
        PBS_Leasing_OfferRLPController.RLPResponseWrapper response = PBS_Leasing_OfferRLPController.searchRecords('Sol-12345', prop.Id);
        rlp[0].PBS_AAAP_STATUS__c = 'Posted/Active';
        rlp[0].PBS_RSAP_Solicitation_Number__c = '';
        update rlp;
        System.debug([SELECT Id, PBS_AAAP_RLP_Number__c, PBS_RSAP_Project_Number__c, PBS_RSAP_Solicitation_Number__c, PBS_RSAP_Solicitation_G_REX_ID__c, PBS_RSAP_Solicitation_Status__c, recordtype.name, PBS_AAAP_Region__c FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_STATUS__c = 'Posted/Active' AND PBS_AAAP_isActive__c = TRUE AND PBS_AAAP_RLP_Number__c = 'NCR']);
        PBS_Leasing_OfferRLPController.RLPResponseWrapper response1 = PBS_Leasing_OfferRLPController.searchRecords('NCR', prop.Id);
       	
        rlp[0].PBS_AAAP_STATUS__c = 'Draft';
        update rlp;
        rlp[0].PBS_AAAP_Region__c = 'Region 1';
        rlp[0].PBS_AAAP_RLP_Number__c = 'Region 1';
        rlp[0].PBS_AAAP_STATUS__c = 'Posted/Active';
        rlp[0].PBS_RSAP_Solicitation_Number__c = '';
        update rlp;
        
        PBS_Leasing_OfferRLPController.RLPResponseWrapper response2 = PBS_Leasing_OfferRLPController.searchRecords('Region 1', prop.Id);
            
        System.assert(response != null, 'Response should not be null');
    }
    
    @isTest
    static void testCreateOfferRecord() {
        PBS_AAAP_Offer__c testOffer = [SELECT Id, PBS_AAAP_Common_Area_Factor__c FROM PBS_AAAP_Offer__c LIMIT 1];
        Test.startTest();
        PBS_Leasing_OfferRLPController.ResponseWrapper response = PBS_Leasing_OfferRLPController.createOfferRecord(testOffer, 'Offer-RLP', 'AAAP');
        Test.stopTest();
        System.assert(response != null, 'Response should not be null');
    }
    
    @isTest
    static void testGetPropertyOfferDetails() {
        PBS_AAAP_Offer__c testOffer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        Test.startTest();
        PBS_Leasing_OfferPropertyWrapper.objectWrapper response = PBS_Leasing_OfferRLPController.getPropertyOfferDetails(testOffer.Id);
        Test.stopTest();
        System.assert(response != null, 'Response should not be null');
    }
    
    @isTest
    static void testUpdateOfferRecord() {
        PBS_AAAP_Offer__c testOffer = [SELECT Id FROM PBS_AAAP_Offer__c LIMIT 1];
        testOffer.PBS_AAAP_Building_Name__c = 'Test-Building-offer';
        update testOffer;
        Test.startTest();
        PBS_Leasing_OfferRLPController.ResponseWrapper response = PBS_Leasing_OfferRLPController.updateOfferRecord(testOffer, 'offer-RLP');
        Test.stopTest();
        System.assert(response.isSuccess, 'Update should be successful');
    }
    
    @isTest
    static void testValidateOffer() {
        
        PBS_AAAP_Offer__c testoffer = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Test Building', PBS_AAAP_Street_Address__c = '123 Test St',
                                                            PBS_AAAP_Country__c = 'Test Country',PBS_AAAP_City__c = 'Test City');
        insert testoffer;
        
        Test.startTest();
        PBS_Leasing_OfferRLPController.ResponseWrapper response = PBS_Leasing_OfferRLPController.validateOffer(testOffer, 'Offer-M-Eligibility');
        
        Test.stopTest();
        System.assert(response != null, 'Response should not be null');
    }
}