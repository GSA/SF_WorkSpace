@IsTest
private class PBS_LOP_SpacesAndRatesController_Test {
    
    static testMethod void validate_SpacesAndRates() {      
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        String rsapRecordTypeID = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
        
        PBS_AAAP_Offer__c testOffer0 = new PBS_AAAP_Offer__c(
            RecordTypeId = rsapRecordTypeID,
            PBS_AAAP_Building_Name__c = 'Unit Test Bldg',
            PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = null,
            PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = null,
            PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = null,
            PBS_AAAP_RU_FACTOR__c = 0.00,
            PBS_AAAP_COST_PER_ABOA__c = 0.0,
            PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 12000,
            PBS_AAAP_OFFICE_SPACE_RSF__c = 1000.00,
            PBS_AAAP_CLEANING_SALARIES__c = 1.00,
            PBS_AAAP_CLEANING_SUPPLIES__c = 1.00,
            PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00,
            PBS_AAAP_HEATING_SALARIES__c = 1.00,
            PBS_AAAP_HEATING_FUEL__c = 'Coal',
            PBS_AAAP_HEATING_FUEL_COST__c = 1.00,
            PBS_AAAP_HEATING_MAINTENANCE__c = 1.00,
            PBS_AAAP_ELECTRICAL_POWER__c = 1.00,
            PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00,
            PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00,
            PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00,
            PBS_AAAP_PLUMBING_WATER__c = 1.00,
            PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00,
            PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00,
            PBS_AAAP_AC_UTILITIES__c = 1.00,
            PBS_AAAP_AC_MAINTENANCE__c = 1.00,
            PBS_AAAP_ELEVATOR_SALARIES__c = 1.00,
            PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00,
            PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00,
            PBS_AAAP_SECURITY__c = 1.00,
            PBS_AAAP_SSTAX_WORKCOMP__c = 1.00,
            PBS_AAAP_LANDSCAPING_MAINTENANCE__c = 1.00,
            PBS_AAAP_REAL_ESTATE_TAXES__c = 2.00,
            PBS_AAAP_INSURANCE__c = 2.00,
            PBS_AAAP_BUILDING_MAINTENANCE__c = 2.00,
            PBS_AAAP_LEASE_COMMISSION__c = 2.00,
            PBS_AAAP_MANAGEMENT__c = 2.00,
            PBS_AAAP_SECT2_TOTAL__c = 10.00,
            PBS_AAAP_SRVC_UTIL_TOTAL__c = 22.00,
            PBS_AAAP_TOTAL_OTHER_COSTS__c = 1.00,
            PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 28664.495,
            PBS_AAAP_Offer_Status__c = 'Draft',
            PBS_AAAP_RLP_Number__c = rlp.id,
            PBS_AAAP_Annual_TI_Rent__c = 9,
            PBS_AAAP_Office_RSF_OFFERED__c = 7,
            PBS_AAAP_TI_Amorization_in_Years__c = 3,
            PBS_AAAP_BSAC_Total_Build_out_Costs__c = 6,
            PBS_RSAP_BSAC_Calc_from_Rate__c = 60,
            PBS_AAAP_BSAC_Amorti_Interest_Rate__c = 7,
            PBS_AAAP_BSAC_Amorization_in_Years__c = 2,
            PBS_AAAP_Anual_BSAC_Rent__c = 7,
            PBS_AAAP_Total_Ofc_ABOA_offered__c = 6,
            PBS_AAAP_Step_1_Rent_Per_RSF__c = 1,
            PBS_AAAP_Step_2_Rent_Per_RSF__c = 1,
            PBS_AAAP_Step_3_Rent_Per_RSF__c = 1,
            PBS_AAAP_Renewal_Shell_Rate__c = 1,
            PBS_AAAP_Is_Shell_Rent_Stepped__c = 'No',
            PBS_AAAP_SITE_AREA_TYPE__c = 'Acres',
            PBS_AAAP_SITE_SIZE_SQFT__c = 3,
            PBS_AAAP_Shell_Rent_Per_RSF__c  = 1,
            PBS_AAAP_Shell_Rate_Years_Effective__c  = 3,
            PBS_AAAP_RLP_Parking_Cost_Incl__c = 'yes',
            PBS_AAAP_Monthly_cost_res_gar_park__c = 1,
            PBS_RSAP_Struct_Resv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_res_sur_park__c = 1,
            PBS_RSAP_Surf_Resv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_nonres_gar_park__c = 1,
            PBS_RSAP_Struct_NonResv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_nonres_sur_park__c = 1,
            PBS_RSAP_Surf_NonResv_Parking__c = 1,
            PBS_RSAP_Total_Parking_Annual_Amount__c = 1,
            PBS_RSAP_Shell_Initial_Annual__c = 1,
            PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c = 1,
            PBS_RSAP_Lease_Annual_Rent__c = 1
        );
        insert testOffer0;      
        System.currentPageReference().getParameters().put('offerId', testOffer0.Id);
        System.currentPageReference().getParameters().put('edit', 'false');
        PBS_LOP_SpacesAndRatesController obj = new PBS_LOP_SpacesAndRatesController();
        obj.saveSpaceRates();
        
        testOffer0.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c = 'Total BSAC buildout cost itemized on the Security Unit Price List';
        testOffer0.PBS_AAAP_BSAC_Amorti_Interest_Rate__c = 0.00;
        update testOffer0;
        obj.saveSpaceRates();
        
        obj.updateStepRents();
        
        testOffer0.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        testOffer0.PBS_AAAP_Renewal_Shell_Rate__c = 0;
        testOffer0.PBS_AAAP_Is_Shell_Rent_Stepped__c = 'Yes'; 
        testOffer0.PBS_AAAP_BSAC_Amorti_Interest_Rate__c = 0.00;
        update testOffer0;
        obj = new PBS_LOP_SpacesAndRatesController(); 
        obj.freeRentIndexNumber = '1' ;
        obj.deleteTheRow();
        PBS_RSAP_Renewal_Options__c renewalRecord = new PBS_RSAP_Renewal_Options__c();
        renewalRecord.PBS_AAAP_Offer__c=testOffer0.Id;
        insert renewalRecord;
        obj.lopOffer.PBS_RSAP_Are_you_offering_renewal_option__c = 'No';
        obj.actionSaveSpaceRates(); 
        
        obj.lopOffer.PBS_RSAP_Are_you_offering_renewal_option__c = 'Yes';
        obj.actionSaveSpaceRates(); 
        
        obj.backToLeaseTerms();
        obj.actionCancel();
        obj.getItems();
        obj.updateAreaType(testOffer0);
        obj.updateStepRents();
        
        obj.actionSaveSpaceRatesAndContinue();
        
        obj.lopOffer.PBS_RSAP_TIA_Or_Turnkey__c = 'Tenant Improvement Allowance (TIA)';
        obj.saveSpaceRates();
        
        obj.lopOffer.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c = 'Rate per ABOA SF specified in RLP';
        obj.saveSpaceRates();
        
        obj.lopOffer.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c = 'Total BSAC buildout cost itemized on the Security Unit Price List';
        obj.lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c = 0.00;
        obj.saveSpaceRates(); 
        
        obj.lopOffer.PBS_RSAP_TIA_Or_Turnkey__c = 'Turnkey';
        obj.saveSpaceRates();
        
        obj.lopOffer.PBS_AAAP_TI_Amorization_in_Years__c = 0;
        obj.saveSpaceRates();
        
        obj.lopOffer.PBS_AAAP_TI_Amorti_Interest_Rate__c = 10.00;
        obj.saveSpaceRates();
        
        obj.lopOffer.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c = 'Rate per ABOA SF specified in RLP';
        obj.lopOffer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c = 0.00;
        obj.saveSpaceRates();
        
        obj.lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        obj.actionSaveSpaceRatesAndContinue();
        
        // creating exception
        obj.lopOffer = null;
        obj.saveSpaceRates();
        
        obj.addRow();
        obj.addRow();
        obj.deleteTheRow();
        obj.addRow();
        
        List<PBS_AAAP_Offer__c> offers = [Select Id From PBS_AAAP_Offer__c];
        System.assertEquals(1, offers.size());
    }
    
    static testMethod void validate_SpacesAndRatesEdit() {      
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c testOffer0 = new PBS_AAAP_Offer__c(
            PBS_AAAP_Building_Name__c = 'Unit Test Bldg',
            PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = null,
            PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = null,
            PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = null,
            PBS_AAAP_RU_FACTOR__c = 0.00,
            PBS_AAAP_COST_PER_ABOA__c = 0.0,
            PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 12000,
            PBS_AAAP_OFFICE_SPACE_RSF__c = 1000.00,
            PBS_AAAP_CLEANING_SALARIES__c = 1.00,
            PBS_AAAP_CLEANING_SUPPLIES__c = 1.00,
            PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00,
            PBS_AAAP_HEATING_SALARIES__c = 1.00,
            PBS_AAAP_HEATING_FUEL__c = 'Coal',
            PBS_AAAP_HEATING_FUEL_COST__c = 1.00,
            PBS_AAAP_HEATING_MAINTENANCE__c = 1.00,
            PBS_AAAP_ELECTRICAL_POWER__c = 1.00,
            PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00,
            PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00,
            PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00,
            PBS_AAAP_PLUMBING_WATER__c = 1.00,
            PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00,
            PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00,
            PBS_AAAP_AC_UTILITIES__c = 1.00,
            PBS_AAAP_AC_MAINTENANCE__c = 1.00,
            PBS_AAAP_ELEVATOR_SALARIES__c = 1.00,
            PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00,
            PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00,
            PBS_AAAP_SECURITY__c = 1.00,
            PBS_AAAP_SSTAX_WORKCOMP__c = 1.00,
            PBS_AAAP_LANDSCAPING_MAINTENANCE__c = 1.00,
            PBS_AAAP_REAL_ESTATE_TAXES__c = 2.00,
            PBS_AAAP_INSURANCE__c = 2.00,
            PBS_AAAP_BUILDING_MAINTENANCE__c = 2.00,
            PBS_AAAP_LEASE_COMMISSION__c = 2.00,
            PBS_AAAP_MANAGEMENT__c = 2.00,
            PBS_AAAP_SECT2_TOTAL__c = 10.00,
            PBS_AAAP_SRVC_UTIL_TOTAL__c = 22.00,
            PBS_AAAP_TOTAL_OTHER_COSTS__c = 1.00,
            PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 28664.495,
            PBS_AAAP_Offer_Status__c = 'Draft',
            PBS_AAAP_RLP_Number__c = rlp.id,
            PBS_AAAP_Annual_TI_Rent__c = 9,
            PBS_AAAP_Office_RSF_OFFERED__c = 1,
            PBS_AAAP_BSAC_Total_Build_out_Costs__c = 6,
            PBS_RSAP_BSAC_Calc_from_Rate__c = 60,
            PBS_AAAP_Anual_BSAC_Rent__c = 7,
            PBS_AAAP_Total_Ofc_ABOA_offered__c = 6,
            PBS_AAAP_Step_1_Rent_Per_RSF__c = 1,
            PBS_AAAP_Step_2_Rent_Per_RSF__c = 1,
            PBS_AAAP_Step_3_Rent_Per_RSF__c = 1,
            PBS_AAAP_Renewal_Shell_Rate__c = 1,
            PBS_AAAP_Is_Shell_Rent_Stepped__c = 'No',
            PBS_AAAP_SITE_AREA_TYPE__c = 'Acres',
            PBS_AAAP_SITE_SIZE_SQFT__c = 3,
            PBS_RSAP_TIA_Or_Turnkey__c = 'Turnkey',
            PBS_AAAP_TI_Amorti_Interest_Rate__c = 0.00,
            PBS_AAAP_TI_Amorization_in_Years__c = 60,
            PBS_RSAP_BSAC_Rate_ABOA_or_Total__c = 'Total BSAC buildout cost itemized on the Security Unit Price List',
            PBS_AAAP_BSAC_Amorti_Interest_Rate__c = 0.00,
            PBS_AAAP_BSAC_Amorization_in_Years__c = 60,
            PBS_AAAP_Monthly_cost_nonres_gar_park__c = 1,
            PBS_RSAP_Surf_Resv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_res_sur_park__c = 1,
            PBS_RSAP_Struct_NonResv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_nonres_sur_park__c = 1,
            PBS_RSAP_Surf_NonResv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_res_gar_park__c = 1
        );
        insert testOffer0;      
        System.currentPageReference().getParameters().put('offerId', testOffer0.Id);
        System.currentPageReference().getParameters().put('edit', 'true');
        PBS_LOP_SpacesAndRatesController obj = new PBS_LOP_SpacesAndRatesController();
        obj.offerId = testOffer0.Id;
        obj.saveSpaceRates();
        obj.updateStepRents();
        
        testOffer0.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        testOffer0.PBS_AAAP_Renewal_Shell_Rate__c = 0;
        testOffer0.PBS_AAAP_Is_Shell_Rent_Stepped__c = 'Yes'; 
        update testOffer0;
        
        obj = new PBS_LOP_SpacesAndRatesController(); 
        obj.actionSaveSpaceRates(); 
        obj.backToLeaseTerms();
        obj.actionCancel();
        obj.getItems();
        obj.updateAreaType(testOffer0);
        obj.updateStepRents();
        //Rental Concessions Julia added 8.27.20
        obj.getRentalItems();
        obj.getRentalConcession();
        obj.setRentalConcession('Yes');
        obj.rentalConcessionsRerender();
        obj.freeRentIndexNumber = '1';
        obj.deleteTheRow();
        obj.resetRenewalOrder();
        obj.deleteTheRenewalRow();
        obj.getMinimum(1,2,3);
        
        List<PBS_AAAP_Offer__c> offers = [Select Id From PBS_AAAP_Offer__c];
        System.assertEquals(1, offers.size());
    }  
    
    static testMethod void validate_SpacesAndRates2() {      
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        rlp.PBS_RSAP_Solicitation_Status__c = true;
        insert rlp;
        String rsapRecordTypeID = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
        
        PBS_AAAP_Offer__c testOffer0 = new PBS_AAAP_Offer__c(
            RecordTypeId = rsapRecordTypeID,
            PBS_AAAP_Building_Name__c = 'Unit Test Bldg',
            PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = null,
            PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = null,
            PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = null,
            PBS_AAAP_RU_FACTOR__c = 0.00,
            PBS_AAAP_COST_PER_ABOA__c = 0.0,
            PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 12000,
            PBS_AAAP_OFFICE_SPACE_RSF__c = 1000.00,
            PBS_AAAP_CLEANING_SALARIES__c = 1.00,
            PBS_AAAP_CLEANING_SUPPLIES__c = 1.00,
            PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00,
            PBS_AAAP_HEATING_SALARIES__c = 1.00,
            PBS_AAAP_HEATING_FUEL__c = 'Coal',
            PBS_AAAP_HEATING_FUEL_COST__c = 1.00,
            PBS_AAAP_HEATING_MAINTENANCE__c = 1.00,
            PBS_AAAP_ELECTRICAL_POWER__c = 1.00,
            PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00,
            PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00,
            PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00,
            PBS_AAAP_PLUMBING_WATER__c = 1.00,
            PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00,
            PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00,
            PBS_AAAP_AC_UTILITIES__c = 1.00,
            PBS_AAAP_AC_MAINTENANCE__c = 1.00,
            PBS_AAAP_ELEVATOR_SALARIES__c = 1.00,
            PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00,
            PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00,
            PBS_AAAP_SECURITY__c = 1.00,
            PBS_AAAP_SSTAX_WORKCOMP__c = 1.00,
            PBS_AAAP_LANDSCAPING_MAINTENANCE__c = 1.00,
            PBS_AAAP_REAL_ESTATE_TAXES__c = 2.00,
            PBS_AAAP_INSURANCE__c = 2.00,
            PBS_AAAP_BUILDING_MAINTENANCE__c = 2.00,
            PBS_AAAP_LEASE_COMMISSION__c = 2.00,
            PBS_AAAP_MANAGEMENT__c = 2.00,
            PBS_AAAP_SECT2_TOTAL__c = 10.00,
            PBS_AAAP_SRVC_UTIL_TOTAL__c = 22.00,
            PBS_AAAP_TOTAL_OTHER_COSTS__c = 1.00,
            PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 28664.495,
            PBS_AAAP_Offer_Status__c = 'Draft',
            PBS_AAAP_RLP_Number__c = rlp.id,
            PBS_AAAP_Annual_TI_Rent__c = 9,
            PBS_AAAP_Office_RSF_OFFERED__c = 7,
            PBS_AAAP_TI_Amorization_in_Years__c = 3,
            PBS_AAAP_BSAC_Total_Build_out_Costs__c = 6,
            PBS_RSAP_BSAC_Calc_from_Rate__c = 60,
            PBS_AAAP_BSAC_Amorti_Interest_Rate__c = 7,
            PBS_AAAP_BSAC_Amorization_in_Years__c = 2,
            PBS_AAAP_Anual_BSAC_Rent__c = 7,
            PBS_AAAP_Total_Ofc_ABOA_offered__c = 6,
            PBS_AAAP_Step_1_Rent_Per_RSF__c = 1,
            PBS_AAAP_Step_2_Rent_Per_RSF__c = 1,
            PBS_AAAP_Step_3_Rent_Per_RSF__c = 1,
            PBS_AAAP_Renewal_Shell_Rate__c = 1,
            PBS_AAAP_Is_Shell_Rent_Stepped__c = 'No',
            PBS_AAAP_SITE_AREA_TYPE__c = 'Acres',
            PBS_AAAP_SITE_SIZE_SQFT__c = 3,
            PBS_AAAP_Shell_Rent_Per_RSF__c  = 1,
            PBS_AAAP_Shell_Rate_Years_Effective__c  = 3,
            PBS_AAAP_RLP_Parking_Cost_Incl__c = 'yes',
            PBS_AAAP_Monthly_cost_res_gar_park__c = 1,
            PBS_RSAP_Struct_Resv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_res_sur_park__c = 1,
            PBS_RSAP_Surf_Resv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_nonres_gar_park__c = 1,
            PBS_RSAP_Struct_NonResv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_nonres_sur_park__c = 1,
            PBS_RSAP_Surf_NonResv_Parking__c = 1,
            PBS_RSAP_Total_Parking_Annual_Amount__c = 1,
            PBS_RSAP_Shell_Initial_Annual__c = 1,
            PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c = 1,
            PBS_RSAP_Lease_Annual_Rent__c = 1
        );
        insert testOffer0;   
        
        PBS_RSAP_Renewal_Options__c renewalRecord = new PBS_RSAP_Renewal_Options__c();
        renewalRecord.PBS_AAAP_Offer__c=testOffer0.Id;
        insert renewalRecord;
        System.currentPageReference().getParameters().put('offerId', testOffer0.Id);
        System.currentPageReference().getParameters().put('edit', 'false');
        PBS_LOP_SpacesAndRatesController obj2 = new PBS_LOP_SpacesAndRatesController();
        obj2.stepFreeRentRecords[0].PBS_RSAP_Step_Rent_Type__c = 'Shell';
        obj2.stepFreeRentRecords[0].PBS_RSAP_Step_Annual_Rent__c = 1; 
        obj2.saveSpaceRates();
        System.assertEquals(true, obj2.isValidUser);
    }
    
    /*static testMethod void test_validateStepRow() {
// Case 1: Missing required fields
PBS_RSAP_Step_Rent__c step1 = new PBS_RSAP_Step_Rent__c(
PBS_RSAP_Step_Rent_Type__c = null,
PBS_RSAP_Step_End__c = null,
PBS_RSAP_Step_Annual_Rent__c = null
);
List<String> errors1 = PBS_LOP_SpacesAndRatesController.validateStepRow(step1);
System.assertEquals(1, errors1.size(), 'Should catch missing required fields');

// Case 2: Invalid year format
PBS_RSAP_Step_Rent__c step2 = new PBS_RSAP_Step_Rent__c(
PBS_RSAP_Step_Rent_Type__c = 'Fixed',
PBS_RSAP_Step_Start__c = 'abc',
PBS_RSAP_Step_End__c = '2027',
PBS_RSAP_Step_Annual_Rent__c = 1000
);
List<String> errors2 = PBS_LOP_SpacesAndRatesController.validateStepRow(step2);
System.assertEquals(1, errors2.size(), 'Should catch invalid year');

// Case 3: Start year > End year
PBS_RSAP_Step_Rent__c step3 = new PBS_RSAP_Step_Rent__c(
PBS_RSAP_Step_Rent_Type__c = 'Fixed',
PBS_RSAP_Step_Start__c = '2028',
PBS_RSAP_Step_End__c = '2027',
PBS_RSAP_Step_Annual_Rent__c = 1500
);
List<String> errors3 = PBS_LOP_SpacesAndRatesController.validateStepRow(step3);
System.assertEquals(1, errors3.size(), 'Should catch start > end');

// Case 4: Valid step (no errors)
PBS_RSAP_Step_Rent__c step4 = new PBS_RSAP_Step_Rent__c(
PBS_RSAP_Step_Rent_Type__c = 'Fixed',
PBS_RSAP_Step_Start__c = '2025',
PBS_RSAP_Step_End__c = '2026',
PBS_RSAP_Step_Annual_Rent__c = 2000
);
List<String> errors4 = PBS_LOP_SpacesAndRatesController.validateStepRow(step4);
System.assertEquals(0, errors4.size(), 'Should pass for valid step');
}*/
    static testMethod void test_validateStepRow_fullCoverage() {
        // Case 1: Missing Rent Type (null)
        PBS_RSAP_Step_Rent__c step1 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_End__c = '2025',
            PBS_RSAP_Step_Annual_Rent__c = 1000
        );
        List<String> errors1 = PBS_LOP_SpacesAndRatesController.validateStepRow(step1);
        System.assertEquals(1, errors1.size(), 'Expected error for missing rent type');
        
        // Case 2: Rent Type is "--None--"
        PBS_RSAP_Step_Rent__c step2 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = '--None--',
            PBS_RSAP_Step_End__c = '2025',
            PBS_RSAP_Step_Annual_Rent__c = 1000
        );
        List<String> errors2 = PBS_LOP_SpacesAndRatesController.validateStepRow(step2);
        System.assertEquals(1, errors2.size(), 'Expected error for "--None--" rent type');
        
        // Case 3: End year is blank
        PBS_RSAP_Step_Rent__c step3 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = 'Fixed',
            PBS_RSAP_Step_End__c = '',
            PBS_RSAP_Step_Annual_Rent__c = 1000
        );
        List<String> errors3 = PBS_LOP_SpacesAndRatesController.validateStepRow(step3);
        System.assertEquals(1, errors3.size(), 'Expected error for blank end year');
        
        // Case 4: Annual Rent is null
        PBS_RSAP_Step_Rent__c step4 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = 'Fixed',
            PBS_RSAP_Step_End__c = '2026'
        );
        List<String> errors4 = PBS_LOP_SpacesAndRatesController.validateStepRow(step4);
        System.assertEquals(1, errors4.size(), 'Expected error for null rent');
        
        // Case 5: Invalid year values (not integers)
        PBS_RSAP_Step_Rent__c step5 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = 'Fixed',
            PBS_RSAP_Step_Start__c = 'abc',
            PBS_RSAP_Step_End__c = '2025',
            PBS_RSAP_Step_Annual_Rent__c = 1000
        );
        List<String> errors5 = PBS_LOP_SpacesAndRatesController.validateStepRow(step5);
        System.assert(errors5[0].contains('valid numbers'), 'Expected error for invalid year format');
        
        // Case 6: Start year > End year
        PBS_RSAP_Step_Rent__c step6 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = 'Fixed',
            PBS_RSAP_Step_Start__c = '2026',
            PBS_RSAP_Step_End__c = '2025',
            PBS_RSAP_Step_Annual_Rent__c = 1000
        );
        List<String> errors6 = PBS_LOP_SpacesAndRatesController.validateStepRow(step6);
        System.assert(errors6[0].contains('less than or equal to'), 'Expected error for start year > end year');
        
        // Case 7: All valid data
        PBS_RSAP_Step_Rent__c step7 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = 'Fixed',
            PBS_RSAP_Step_Start__c = '2024',
            PBS_RSAP_Step_End__c = '2025',
            PBS_RSAP_Step_Annual_Rent__c = 1200
        );
        List<String> errors7 = PBS_LOP_SpacesAndRatesController.validateStepRow(step7);
        System.assertEquals(0, errors7.size(), 'Expected no errors for valid input');
        
        // Case 8: Start year == End year (edge but valid)
        PBS_RSAP_Step_Rent__c step8 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = 'Fixed',
            PBS_RSAP_Step_Start__c = '2025',
            PBS_RSAP_Step_End__c = '2025',
            PBS_RSAP_Step_Annual_Rent__c = 1500
        );
        List<String> errors8 = PBS_LOP_SpacesAndRatesController.validateStepRow(step8);
        System.assertEquals(0, errors8.size(), 'Expected no errors when start and end years are equal');
        
        // Case 9: Start/End year with spaces
        PBS_RSAP_Step_Rent__c step9 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = 'Fixed',
            PBS_RSAP_Step_Start__c = ' 2023 ',
            PBS_RSAP_Step_End__c = ' 2024 ',
            PBS_RSAP_Step_Annual_Rent__c = 1000
        );
        List<String> errors9 = PBS_LOP_SpacesAndRatesController.validateStepRow(step9);
        System.assertEquals(0, errors9.size(), 'Expected no errors with spaces in year fields');
        
        // Case 10: Null start year with valid end year and rent
        PBS_RSAP_Step_Rent__c step10 = new PBS_RSAP_Step_Rent__c(
            PBS_RSAP_Step_Rent_Type__c = 'Fixed',
            PBS_RSAP_Step_Start__c = null,
            PBS_RSAP_Step_End__c = '2025',
            PBS_RSAP_Step_Annual_Rent__c = 1000
        );
        List<String> errors10 = PBS_LOP_SpacesAndRatesController.validateStepRow(step10);
        System.assert(errors10[0].contains('valid numbers') || errors10[0].contains('required'), 'Expected error for null start year');
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c testOffer0 = new PBS_AAAP_Offer__c(
            PBS_AAAP_Building_Name__c = 'Unit Test Bldg',
            PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = null,
            PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = null,
            PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = null,
            PBS_AAAP_RU_FACTOR__c = 0.00,
            PBS_AAAP_COST_PER_ABOA__c = 0.0,
            PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 12000,
            PBS_AAAP_OFFICE_SPACE_RSF__c = 1000.00,
            PBS_AAAP_CLEANING_SALARIES__c = 1.00,
            PBS_AAAP_CLEANING_SUPPLIES__c = 1.00,
            PBS_AAAP_CLEANING_CONTRACT_SERVICES__c = 1.00,
            PBS_AAAP_HEATING_SALARIES__c = 1.00,
            PBS_AAAP_HEATING_FUEL__c = 'Coal',
            PBS_AAAP_HEATING_FUEL_COST__c = 1.00,
            PBS_AAAP_HEATING_MAINTENANCE__c = 1.00,
            PBS_AAAP_ELECTRICAL_POWER__c = 1.00,
            PBS_AAAP_ELECTRICAL_REPLACEMENT__c = 1.00,
            PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c = 1.00,
            PBS_AAAP_ELECTRICAL_MAINTENANCE__c = 1.00,
            PBS_AAAP_PLUMBING_WATER__c = 1.00,
            PBS_AAAP_PLUMBING_SUPPLIES__c = 1.00,
            PBS_AAAP_PLUMBING_MAINTENANCE__c = 1.00,
            PBS_AAAP_AC_UTILITIES__c = 1.00,
            PBS_AAAP_AC_MAINTENANCE__c = 1.00,
            PBS_AAAP_ELEVATOR_SALARIES__c = 1.00,
            PBS_AAAP_ELEVATOR_MAINTENANCE__c = 1.00,
            PBS_AAAP_BLDG_ENGINEERCOST__c = 1.00,
            PBS_AAAP_SECURITY__c = 1.00,
            PBS_AAAP_SSTAX_WORKCOMP__c = 1.00,
            PBS_AAAP_LANDSCAPING_MAINTENANCE__c = 1.00,
            PBS_AAAP_REAL_ESTATE_TAXES__c = 2.00,
            PBS_AAAP_INSURANCE__c = 2.00,
            PBS_AAAP_BUILDING_MAINTENANCE__c = 2.00,
            PBS_AAAP_LEASE_COMMISSION__c = 2.00,
            PBS_AAAP_MANAGEMENT__c = 2.00,
            PBS_AAAP_SECT2_TOTAL__c = 10.00,
            PBS_AAAP_SRVC_UTIL_TOTAL__c = 22.00,
            PBS_AAAP_TOTAL_OTHER_COSTS__c = 1.00,
            PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 28664.495,
            PBS_AAAP_Offer_Status__c = 'Draft',
            PBS_AAAP_RLP_Number__c = rlp.id,
            PBS_AAAP_Annual_TI_Rent__c = 9,
            PBS_AAAP_Office_RSF_OFFERED__c = 1,
            PBS_AAAP_BSAC_Total_Build_out_Costs__c = 6,
            PBS_RSAP_BSAC_Calc_from_Rate__c = 60,
            PBS_AAAP_Anual_BSAC_Rent__c = 7,
            PBS_AAAP_Total_Ofc_ABOA_offered__c = 6,
            PBS_AAAP_Step_1_Rent_Per_RSF__c = 1,
            PBS_AAAP_Step_2_Rent_Per_RSF__c = 1,
            PBS_AAAP_Step_3_Rent_Per_RSF__c = 1,
            PBS_AAAP_Renewal_Shell_Rate__c = 1,
            PBS_AAAP_Is_Shell_Rent_Stepped__c = 'No',
            PBS_AAAP_SITE_AREA_TYPE__c = 'Acres',
            PBS_AAAP_SITE_SIZE_SQFT__c = 3,
            PBS_RSAP_TIA_Or_Turnkey__c = 'Turnkey',
            PBS_AAAP_TI_Amorti_Interest_Rate__c = 0.00,
            PBS_AAAP_TI_Amorization_in_Years__c = 60,
            PBS_RSAP_BSAC_Rate_ABOA_or_Total__c = 'Total BSAC buildout cost itemized on the Security Unit Price List',
            PBS_AAAP_BSAC_Amorti_Interest_Rate__c = 0.00,
            PBS_AAAP_BSAC_Amorization_in_Years__c = 60,
            PBS_AAAP_Monthly_cost_nonres_gar_park__c = 1,
            PBS_RSAP_Surf_Resv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_res_sur_park__c = 1,
            PBS_RSAP_Struct_NonResv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_nonres_sur_park__c = 1,
            PBS_RSAP_Surf_NonResv_Parking__c = 1,
            PBS_AAAP_Monthly_cost_res_gar_park__c = 1
        );
        insert testOffer0;      
        System.currentPageReference().getParameters().put('offerId', testOffer0.Id);
        System.currentPageReference().getParameters().put('edit', 'true');
        
        List<PBS_RSAP_Step_Rent__c> stepFreeRentRecords = new List<PBS_RSAP_Step_Rent__c>();
        stepFreeRentRecords.add(step6);
        stepFreeRentRecords.add(step8);
        stepFreeRentRecords.add(step9);
        PBS_LOP_SpacesAndRatesController obj = new PBS_LOP_SpacesAndRatesController();
        obj.validateStepRentRecords(stepFreeRentRecords);
    }
    
    
}