@IsTest
private class PBS_AAAP_OfferTriggerBIBU_Test {
    
    static testMethod void submittedOfferCheck() {      
        
        
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
                PBS_AAAP_Offer_Status__c = 'Draft' 
        );
        insert testOffer0;  
        
            PBS_AAAP_Offer__c testOffer1 = new PBS_AAAP_Offer__c(
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
                PBS_AAAP_Offer_Status__c = 'Draft' 
        );
        insert testOffer1;  
        
         PBS_AAAP_Space__c sp = new PBS_AAAP_Space__c(
         PBS_AAAP_OFFER_NUMBER__c	= testOffer0.Id,
         PBS_AAAP_IDENTIFIER_ID__c = '0',
         PBS_AAAP_SF_OFFERED__c = 1000,
         PBS_AAAP_IDENTIFIER_FROM__c = 50,
         PBS_AAAP_BASE_OPERATING_COSTS__c = 1,
         PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 2,
         PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF',
         PBS_AAAP_MIN_OFFERABLE_SPACE__c =1,
         PBS_AAAP_Max_Contiguous_Space__c=1,
         PBS_AAAP_IDENTIFIER_TO__c = 1,
         PBS_AAAP_DATE_SPACE_AVAILABILITY__c = System.Today(),
         PBS_AAAP_ARCH_ENG_FEES__c = 1000,
         PBS_AAAP_MAX_OFFERABLE_SPACE__c= 18,
         PBS_AAAP_TOTAL_MARKUP__c=2
         ); 
 		Insert sp;
        
        PBS_AAAP_Space__c sp1 = new PBS_AAAP_Space__c(
            PBS_AAAP_OFFER_NUMBER__c	= testOffer0.Id,
            PBS_AAAP_Master_Space__c = sp.id,
            PBS_AAAP_IDENTIFIER_ID__c = '0',
            PBS_AAAP_SF_OFFERED__c = 1000,
            PBS_AAAP_IDENTIFIER_FROM__c = 50,
            PBS_AAAP_BASE_OPERATING_COSTS__c = 1,
            PBS_AAAP_GC_OVERHEAD_AND_PROF__c = 2,
            PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF',
            PBS_AAAP_MIN_OFFERABLE_SPACE__c =1,
            PBS_AAAP_Max_Contiguous_Space__c=1,
            PBS_AAAP_IDENTIFIER_TO__c = 1,
            PBS_AAAP_DATE_SPACE_AVAILABILITY__c = System.Today(),
            PBS_AAAP_ARCH_ENG_FEES__c = 1000,
            PBS_AAAP_MAX_OFFERABLE_SPACE__c= 18,
            PBS_AAAP_TOTAL_MARKUP__c=2
        ); 
        Insert sp1;
        
        testOffer0.PBS_AAAP_Offer_Status__c = 'Draft';
        testOffer0.PBS_AAAP_Energy_Star__c = PBS_AAAP_GlobalConstants.YES;
        testOffer0.PBS_AAAP_Close_To_Metro__c = PBS_AAAP_GlobalConstants.YES;
        testOffer0.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c  = PBS_AAAP_GlobalConstants.YES;
        update testOffer0;
        
        testOffer0.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        testOffer0.RecordTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('AAAP').getRecordTypeId();
        testOffer0.Master_Offer__c = testOffer1.ID;
        update testOffer0;
        
        Test.setMock(HttpCalloutMock.class, new PBS_AAAP_OfferTriggerBIBU_MockTest());          
        
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = testOffer0.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;   

        PBS_AAAP_SendOfferDetailsAPI.sendOfferDetails(JSON.serialize(testOffer0));          
        System.assert(true);
    }
    
}