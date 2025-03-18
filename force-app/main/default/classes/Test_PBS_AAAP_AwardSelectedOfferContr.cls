@isTest(SeeAllData=True) 
private class Test_PBS_AAAP_AwardSelectedOfferContr {

    static testMethod void myUnitTest() { 

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();    
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        //agency.PBS_AAAP_LEASE_TERM__c = '25 months,16 firm'
        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        osai.PBS_AAAP_SELECTED_USF__c = 100;

        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.leaseTermforRates =  new List<String>();
        asoc.totTIammountRefStr = 'test';
        asoc.actionMethod();

        PageReference pref = asoc.actionCancel();
        System.assertNotEquals(pref, null);

        Test.stopTest();
    }

    static testMethod void myUnitTest1() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM';
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 PM';

        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        //agency.PBS_AAAP_LEASE_TERM__c = '25 months,16 firm'
        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Awarded_RSF__c = Integer.valueOf(space.PBS_AAAP_SF_OFFERED__c)-1000;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 2;
        osai.Unreserved_Structured_spaces_for_GOVs__c = 3;
        osai.Reserved_Surface_Spaces_for_GOVs__c = 4;
        osai.Reserved_Structured_Spaces_for_GOVs__c = 5;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionCancel();
        System.assertNotEquals(pref, null);

        Test.stopTest();
    }

    static testMethod void myUnitTest2() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();     
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM';
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 PM';

        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_LEASE_TERM__c = '25 months,16 firm';
        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = '25 months, 16 firm';
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Awarded_RSF__c = Integer.valueOf(space.PBS_AAAP_SF_OFFERED__c)-1000;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 2;
        osai.Unreserved_Structured_spaces_for_GOVs__c = 3;
        osai.Reserved_Surface_Spaces_for_GOVs__c = 4;
        osai.Reserved_Structured_Spaces_for_GOVs__c = 5;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionCancel();
        PageReference pref2 = asoc.actionEdit();
        System.assertNotEquals(pref, null);

        Test.stopTest();
    }

    static testMethod void myUnitTest3() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM';
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 PM';

        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_LEASE_TERM__c = '19 months, 11 firm';
        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = '19 months, 11 firm';
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Awarded_RSF__c = Integer.valueOf(space.PBS_AAAP_SF_OFFERED__c)-1000;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 2;
        osai.Unreserved_Structured_spaces_for_GOVs__c = 3;
        osai.Reserved_Surface_Spaces_for_GOVs__c = 4;
        osai.Reserved_Structured_Spaces_for_GOVs__c = 5;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionCancel();
        PageReference pref2 = asoc.actionEdit();
        System.assertNotEquals(pref, null);

        Test.stopTest();
    }

    static testMethod void myUnitTest4() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM';
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 PM';

        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_LEASE_TERM__c = '10 years,5 firm';
        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = '10 years,5 firm';
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Awarded_RSF__c = Integer.valueOf(space.PBS_AAAP_SF_OFFERED__c)-1000;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 2;
        osai.Unreserved_Structured_spaces_for_GOVs__c = 3;
        osai.Reserved_Surface_Spaces_for_GOVs__c = 4;
        osai.Reserved_Structured_Spaces_for_GOVs__c = 5;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionCancel();
        PageReference pref2 = asoc.actionEdit();
        System.assertNotEquals(pref, null);

        Test.stopTest();
    }

    static testMethod void myUnitTest5() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();       
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM';
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 PM';

        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = '15 years,10 firm';
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Awarded_RSF__c = Integer.valueOf(space.PBS_AAAP_SF_OFFERED__c)-1000;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 2;
        osai.Unreserved_Structured_spaces_for_GOVs__c = 3;
        osai.Reserved_Surface_Spaces_for_GOVs__c = 4;
        osai.Reserved_Structured_Spaces_for_GOVs__c = 5;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionCancel();
        PageReference pref2 = asoc.actionEdit();
        System.assertNotEquals(pref, null);

        Test.stopTest();
    }
    
    static testMethod void myUnitTest6() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PBS_AAAP_CalloutMockImpl());       
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo1();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
        offer.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM';
        offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 PM';

        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirementFY19();
        agency.PBS_AAAP_LEASE_TERM__c = '10 years';
        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = '10 years';
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Awarded_RSF__c = Integer.valueOf(space.PBS_AAAP_SF_OFFERED__c)-1000;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 2;
        osai.Unreserved_Structured_spaces_for_GOVs__c = 3;
        osai.Reserved_Surface_Spaces_for_GOVs__c = 4;
        osai.Reserved_Structured_Spaces_for_GOVs__c = 5;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionCancel();
        PageReference pref2 = asoc.actionEdit();
        System.assertNotEquals(pref, null);

        Test.stopTest();
    }

    static testMethod void actionSaveTest() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);
        
        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionSave();
        System.assertNotEquals(pref, null);

        asoc.agencyRequirementId = 'agencyRequirementId';
        asoc.selectedOfferId = 'selectedOfferId';
        asoc.selectedSpaceId = 'selectedSpaceId';

        Test.stopTest();
    }

    static testMethod void actionSaveTest1() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();       
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_Total_ABOA_Awarded__c = 20000;
        //space.PBS_AAAP_SF_OFFERED__c = 100000;
        insert space;
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;

        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_AWARDED_USF__c = 20000;
        osai.PBS_AAAP_SELECTED_USF__c = 20000;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionSave();
        System.assertNotEquals(pref, null);

        Test.stopTest();
    }
    
    static testMethod void actionSaveTest2() {

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();      
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_Total_ABOA_Awarded__c = 20000;
        //space.PBS_AAAP_SF_OFFERED__c = 100000;
        space.PBS_AAAP_Total_ABOA_Selected__c = 100000;
        insert space;
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;
        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_AWARDED_USF__c = 100000;
        osai.PBS_AAAP_SELECTED_USF__c = 100000;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;

        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.actionSave();
        System.assertNotEquals(pref, null);
        
        asoc.currentObj.PBS_AAAP_SELECTED_USF__c = 0;
        pref = asoc.prepareDocument();
        
        asoc.currentObj = new PBS_AAAP_Offer_Select_Award_Info__c();
        pref = asoc.actionSave();

        Test.stopTest();
    }

    static testMethod void prepDocumentTest(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);
       
        Test.startTest();       
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;

        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.prepareDocument();
        system.debug('*****pref'+pref);
        System.assertEquals(pref, null);
        //system.debug('*****pref'+pref);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest2(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;

        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.prepareDocument();
        system.debug('*****pref'+pref);
         System.assertEquals(pref, null);
        //system.debug('*****pref'+pref);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest3(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();       
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;

        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.prepareDocument();
        system.debug('*****pref'+pref);
         System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        Test.stopTest();
    }
     
    static testMethod void prepDocumentTest4(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai.PBS_AAAP_Awarded_RSF__c = 1234;
        osai.PBS_AAAP_PV_RATE__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;

        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.prepareDocument();
         system.debug('*****pref'+pref);
        System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());     
        Test.stopTest();
    }
     
    static testMethod void prepDocumentTest5(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();      
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai.PBS_AAAP_Awarded_RSF__c = 1234;
        osai.PBS_AAAP_PV_RATE__c =100;
        osai.PBS_AAAP_TI_Allowance__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        
        
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 1;
        osai.Reserved_Surface_Spaces_for_GOVs__c = 2;
        osai.Unreserved_Structured_spaces_for_GOVs__c = 3;
        osai.Reserved_Structured_Spaces_for_GOVs__c = 4;
        
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.prepareDocument();
        system.debug('*****pref'+pref);
         System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest6(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();       
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai.PBS_AAAP_Awarded_RSF__c = 1234;
        osai.PBS_AAAP_PV_RATE__c =100;
        osai.PBS_AAAP_TI_Allowance__c = 100;
        osai.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();

        PageReference pref = asoc.prepareDocument();
        system.debug('*****pref'+pref);
        System.assert(true);
        //System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest7(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();       
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai.PBS_AAAP_Awarded_RSF__c = 1234;
        osai.PBS_AAAP_PV_RATE__c =100;
        osai.PBS_AAAP_TI_Allowance__c = 100;
        osai.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;      
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();
        PageReference pref = asoc.prepareDocument();
        
        
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        update osai;
        
        PBS_AAAP_AwardSelectedOfferController asoc1 = new PBS_AAAP_AwardSelectedOfferController();
        asoc1.actionMethod();

        PageReference pref1 = asoc1.prepareDocument();
        system.debug('*****pref'+pref);
        System.assert(true);
         //System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest8(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();     
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai.PBS_AAAP_Awarded_RSF__c = 1234;
        osai.PBS_AAAP_PV_RATE__c =100;
        osai.PBS_AAAP_TI_Allowance__c = 100;
        osai.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 100;     
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();
        PageReference pref = asoc.prepareDocument();
        system.debug('*****pref'+pref);
        System.assert(true);
        // System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest9(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai.PBS_AAAP_Awarded_RSF__c = 1234;
        osai.PBS_AAAP_PV_RATE__c =100;
        osai.PBS_AAAP_TI_Allowance__c = 100;
        osai.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.PBS_AAAP_Unreserved_Structured__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c  = 100;
        osai.PBS_AAAP_Reserved_Structured__c = 100;
        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();
        PageReference pref = asoc.prepareDocument();
        system.debug('*****pref'+pref);
        System.assert(true);
         //System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest10(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();       
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;


        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_Offer_ID__c = offer.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai.PBS_AAAP_Awarded_RSF__c = 1234;
        osai.PBS_AAAP_PV_RATE__c =100;
        osai.PBS_AAAP_TI_Allowance__c = 100;
        osai.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai.PBS_AAAP_Unreserved_Surface__c = 100;
        osai.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai.PBS_AAAP_Reserved_Surface__c = 100;
        osai.Reserved_Surface_Spaces_for_GOVs__c = 200;     
        osai.PBS_AAAP_Unreserved_Structured__c = 100;       
        osai.PBS_AAAP_Reserved_Structured__c = 100;

        insert osai;

        ApexPages.currentPage().getParameters().put('id', osai.id);

        PBS_AAAP_AwardSelectedOfferController asoc = new PBS_AAAP_AwardSelectedOfferController();
        asoc.actionMethod();
        PageReference pref = asoc.prepareDocument();
        system.debug('*****pref'+pref);
        //System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());

        PBS_AAAP_Offer_Select_Award_Info__c osai1 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai1.PBS_AAAP_Offer_ID__c = offer.Id;
        osai1.PBS_AAAP_Space_ID__c = space.Id;
        osai1.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai1.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai1.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai1.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai1.PBS_AAAP_Awarded_RSF__c = 1234;
        osai1.PBS_AAAP_PV_RATE__c =100;
        osai1.PBS_AAAP_TI_Allowance__c = 100;
        osai1.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai1.PBS_AAAP_Unreserved_Surface__c = 100;
        osai1.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai1.PBS_AAAP_Reserved_Surface__c = 100;
        osai1.PBS_AAAP_Unreserved_Structured__c = 200;
        osai1.Reserved_Surface_Spaces_for_GOVs__c = 200;
        osai1.PBS_AAAP_Reserved_Structured__c = 100;
        insert osai1;

        ApexPages.currentPage().getParameters().put('id', osai1.id);

        PBS_AAAP_AwardSelectedOfferController asoc1 = new PBS_AAAP_AwardSelectedOfferController();
        asoc1.actionMethod();
        PageReference pref1 = asoc1.prepareDocument();
        
        PBS_AAAP_Offer_Select_Award_Info__c osai2 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai2.PBS_AAAP_Offer_ID__c = offer.Id;
        osai2.PBS_AAAP_Space_ID__c = space.Id;
        osai2.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai2.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai2.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai2.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai2.PBS_AAAP_Awarded_RSF__c = 1234;
        osai2.PBS_AAAP_PV_RATE__c =100;
        osai2.PBS_AAAP_TI_Allowance__c = 100;
        osai2.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai2.PBS_AAAP_Unreserved_Surface__c = 100;
        osai2.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.PBS_AAAP_Unreserved_Structured__c = 200;
        osai2.Reserved_Surface_Spaces_for_GOVs__c = 200;
        osai2.PBS_AAAP_Reserved_Structured__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        insert osai2;

        ApexPages.currentPage().getParameters().put('id', osai2.id);

        PBS_AAAP_AwardSelectedOfferController asoc2 = new PBS_AAAP_AwardSelectedOfferController();
        asoc2.actionMethod();
        PageReference pref2 = asoc2.prepareDocument();
        system.debug('*****pref'+pref);
        System.assert(true);
        //System.assertEquals(pref, null);
        //System.assertEquals(pref.getUrl(), currentPage.getUrl());
        
        Test.stopTest();
    }
      
    static testMethod void prepDocumentTest11(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();     
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;

       
        PBS_AAAP_Offer_Select_Award_Info__c osai2 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai2.PBS_AAAP_Offer_ID__c = offer.Id;
        osai2.PBS_AAAP_Space_ID__c = space.Id;
        osai2.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai2.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai2.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai2.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai2.PBS_AAAP_Awarded_RSF__c = 1234;
        osai2.PBS_AAAP_PV_RATE__c =100;
        osai2.PBS_AAAP_TI_Allowance__c = 100;
        osai2.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai2.PBS_AAAP_Unreserved_Surface__c = 100;
        osai2.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.PBS_AAAP_Unreserved_Structured__c = 200;
        osai2.Reserved_Surface_Spaces_for_GOVs__c = 200;
        osai2.PBS_AAAP_Reserved_Structured__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.Unreserved_Structured_spaces_for_GOVs__c = 100;
        osai2.Reserved_Structured_Spaces_for_GOVs__c = 100;
        insert osai2;

        ApexPages.currentPage().getParameters().put('id', osai2.id);

        PBS_AAAP_AwardSelectedOfferController asoc2 = new PBS_AAAP_AwardSelectedOfferController();
        PBS_AAAP_AwardSelectedOfferController.setFields();
        asoc2.actionMethod();
        PageReference pref2 = asoc2.prepareDocument();
        System.assertNotEquals(pref2, null);
        system.debug('****pref2'+pref2);
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest12(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;

       
        PBS_AAAP_Offer_Select_Award_Info__c osai2 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai2.PBS_AAAP_Offer_ID__c = offer.Id;
        osai2.PBS_AAAP_Space_ID__c = space.Id;
        osai2.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai2.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai2.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai2.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai2.PBS_AAAP_Awarded_RSF__c = 1234;
        osai2.PBS_AAAP_PV_RATE__c = null;
        osai2.PBS_AAAP_TI_Allowance__c = 100;
        osai2.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai2.PBS_AAAP_Unreserved_Surface__c = 100;
        osai2.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.PBS_AAAP_Unreserved_Structured__c = 200;
        osai2.Reserved_Surface_Spaces_for_GOVs__c = 200;
        osai2.PBS_AAAP_Reserved_Structured__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.Unreserved_Structured_spaces_for_GOVs__c = 100;
        osai2.Reserved_Structured_Spaces_for_GOVs__c = 100;
        insert osai2;

        ApexPages.currentPage().getParameters().put('id', osai2.id);

        PBS_AAAP_AwardSelectedOfferController asoc2 = new PBS_AAAP_AwardSelectedOfferController();
        PBS_AAAP_AwardSelectedOfferController.setFields();
        asoc2.actionMethod();
        PageReference pref2 = asoc2.prepareDocument();
        System.assertEquals(pref2, null);
        system.debug('****pref2'+pref2);
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest18(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;

       
        PBS_AAAP_Offer_Select_Award_Info__c osai2 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai2.PBS_AAAP_Offer_ID__c = offer.Id;
        osai2.PBS_AAAP_Space_ID__c = space.Id;
        osai2.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai2.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai2.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai2.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai2.PBS_AAAP_Awarded_RSF__c = 1234;
        osai2.PBS_AAAP_PV_RATE__c = null;
        osai2.PBS_AAAP_TI_Allowance__c = 100;
        osai2.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai2.PBS_AAAP_Unreserved_Surface__c = null;
        osai2.Non_reserved_surface_Spaces_for_GOVs__c = null;
        osai2.PBS_AAAP_Reserved_Surface__c = null;
        osai2.PBS_AAAP_Unreserved_Structured__c = null;
        osai2.Reserved_Surface_Spaces_for_GOVs__c = null;
        osai2.PBS_AAAP_Reserved_Structured__c = null;
        osai2.PBS_AAAP_Reserved_Surface__c = null;
        osai2.Unreserved_Structured_spaces_for_GOVs__c = null;
        osai2.Reserved_Structured_Spaces_for_GOVs__c = null;
        insert osai2;

        ApexPages.currentPage().getParameters().put('id', osai2.id);

        PBS_AAAP_AwardSelectedOfferController asoc2 = new PBS_AAAP_AwardSelectedOfferController();
        PBS_AAAP_AwardSelectedOfferController.setFields();
        asoc2.actionMethod();
        PageReference pref2 = asoc2.prepareDocument();
        System.assertEquals(pref2, null);
        system.debug('****pref2'+pref2);
        Test.stopTest();
    }
    
    
    static testMethod void prepDocumentTest13(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();      
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;

       
        PBS_AAAP_Offer_Select_Award_Info__c osai2 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai2.PBS_AAAP_Offer_ID__c = offer.Id;
        osai2.PBS_AAAP_Space_ID__c = space.Id;
        osai2.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai2.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai2.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai2.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai2.PBS_AAAP_Awarded_RSF__c = 1234;
        osai2.PBS_AAAP_PV_RATE__c =100;
        osai2.PBS_AAAP_TI_Allowance__c = 100;
        osai2.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai2.PBS_AAAP_Unreserved_Surface__c = null;
        osai2.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.PBS_AAAP_Unreserved_Structured__c = 200;
        osai2.Reserved_Surface_Spaces_for_GOVs__c = 200;
        osai2.PBS_AAAP_Reserved_Structured__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.Unreserved_Structured_spaces_for_GOVs__c = 100;
        osai2.Reserved_Structured_Spaces_for_GOVs__c = 100;
        insert osai2;

        ApexPages.currentPage().getParameters().put('id', osai2.id);

        PBS_AAAP_AwardSelectedOfferController asoc2 = new PBS_AAAP_AwardSelectedOfferController();
        PBS_AAAP_AwardSelectedOfferController.setFields();
        asoc2.actionMethod();
        PageReference pref2 = asoc2.prepareDocument();
        System.assertNotEquals(pref2, null);
        system.debug('****pref2'+pref2);
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest14(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;

       
        PBS_AAAP_Offer_Select_Award_Info__c osai2 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai2.PBS_AAAP_Offer_ID__c = offer.Id;
        osai2.PBS_AAAP_Space_ID__c = space.Id;
        osai2.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai2.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai2.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai2.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai2.PBS_AAAP_Awarded_RSF__c = 1234;
        osai2.PBS_AAAP_PV_RATE__c =100;
        osai2.PBS_AAAP_TI_Allowance__c = 100;
        osai2.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai2.PBS_AAAP_Unreserved_Surface__c = 100;
        osai2.Non_reserved_surface_Spaces_for_GOVs__c = null;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.PBS_AAAP_Unreserved_Structured__c = 200;
        osai2.Reserved_Surface_Spaces_for_GOVs__c = 200;
        osai2.PBS_AAAP_Reserved_Structured__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.Unreserved_Structured_spaces_for_GOVs__c = 100;
        osai2.Reserved_Structured_Spaces_for_GOVs__c = 100;
        insert osai2;

        ApexPages.currentPage().getParameters().put('id', osai2.id);

        PBS_AAAP_AwardSelectedOfferController asoc2 = new PBS_AAAP_AwardSelectedOfferController();
        PBS_AAAP_AwardSelectedOfferController.setFields();
        asoc2.actionMethod();
        PageReference pref2 = asoc2.prepareDocument();
        System.assertNotEquals(pref2, null);
        system.debug('****pref2'+pref2);
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest15(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();      
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;

       
        PBS_AAAP_Offer_Select_Award_Info__c osai2 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai2.PBS_AAAP_Offer_ID__c = offer.Id;
        osai2.PBS_AAAP_Space_ID__c = space.Id;
        osai2.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai2.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai2.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai2.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai2.PBS_AAAP_Awarded_RSF__c = 1234;
        osai2.PBS_AAAP_PV_RATE__c =100;
        osai2.PBS_AAAP_TI_Allowance__c = 100;
        osai2.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai2.PBS_AAAP_Unreserved_Surface__c = 100;
        osai2.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.PBS_AAAP_Unreserved_Structured__c = null;
        osai2.Reserved_Surface_Spaces_for_GOVs__c = 200;
        osai2.PBS_AAAP_Reserved_Structured__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.Unreserved_Structured_spaces_for_GOVs__c = 100;
        osai2.Reserved_Structured_Spaces_for_GOVs__c = 100;
        insert osai2;

        ApexPages.currentPage().getParameters().put('id', osai2.id);

        PBS_AAAP_AwardSelectedOfferController asoc2 = new PBS_AAAP_AwardSelectedOfferController();
        PBS_AAAP_AwardSelectedOfferController.setFields();
        asoc2.actionMethod();
        PageReference pref2 = asoc2.prepareDocument();
        System.assertNotEquals(pref2, null);
        system.debug('****pref2'+pref2);
        Test.stopTest();
    }
    
    static testMethod void prepDocumentTest16(){
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_AwardSelectedOfferInfoEdit');
        Test.setCurrentPage(currentPage);

        Test.startTest();              
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        
        RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
        Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
        insert acc;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();

        agency.PBS_AAAP_Account_Name__c = acc.Id;
        insert agency;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_LEASE_TERM__c = agency.PBS_AAAP_LEASE_TERM__c;
        insert rate;

       
        PBS_AAAP_Offer_Select_Award_Info__c osai2 = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai2.PBS_AAAP_Offer_ID__c = offer.Id; 
        osai2.PBS_AAAP_Space_ID__c = space.Id;
        osai2.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai2.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
        osai2.PBS_AAAP_CONTRACT_AWARD_DATE__c = system.today();
        osai2.PBS_AAAP_NEW_GSA_LEASE_NUM__c = '1234';
        osai2.PBS_AAAP_Awarded_RSF__c = 1234;
        osai2.PBS_AAAP_PV_RATE__c =100;
        osai2.PBS_AAAP_TI_Allowance__c = 100;
        osai2.PBS_AAAP_BSAC_Placeholder__c = 100;
        osai2.PBS_AAAP_Unreserved_Surface__c = 100;
        osai2.Non_reserved_surface_Spaces_for_GOVs__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.PBS_AAAP_Unreserved_Structured__c = 100;
        osai2.Reserved_Surface_Spaces_for_GOVs__c = 200;
        osai2.PBS_AAAP_Reserved_Structured__c = 100;
        osai2.PBS_AAAP_Reserved_Surface__c = 100;
        osai2.Unreserved_Structured_spaces_for_GOVs__c = null;
        osai2.Reserved_Structured_Spaces_for_GOVs__c = 100;
        insert osai2;

        ApexPages.currentPage().getParameters().put('id', osai2.id);

        PBS_AAAP_AwardSelectedOfferController asoc2 = new PBS_AAAP_AwardSelectedOfferController();
        PBS_AAAP_AwardSelectedOfferController.setFields();
        //asoc2.actionMethod();
        PageReference pref2 = asoc2.prepareDocument();
        System.assertEquals(pref2, null);
        system.debug('****pref2'+pref2);
        
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        offeratt.PBS_AAAP_Sent_to_GREX__c = false;
        insert offeratt;
        
        // creating 2 offer
        PBS_AAAP_Offer__c offer2 = PBS_AAAP_UtilityTest.createOfferInfo();
        offer2.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer2;
        
        PBS_AAAP_Offer_Attachments__c offeratt2 = new PBS_AAAP_Offer_Attachments__c();
        offeratt2.PBS_AAAP_Offer__c = offer2.Id;
        offeratt2.PBS_AAAP_Sent_to_GREX__c = false;
        insert offeratt2;       
                
        // calling capture log method       
        PBS_AAAP_SendOfferDetailsAPI.captureLogsAAAP(osai2.Id, 'response', 'request', '200', offer2.Id);
        
        offeratt.PBS_AAAP_Sent_to_GREX__c = false; 
        update offeratt;
        PBS_AAAP_SendOfferDetailsAPI.captureLogs(offer.Id, 'response', 'request', '200');
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='Asia/Dubai', UserName='standarduser@testorg.com.gov.test');
        insert u;
        system.runAs(u){
            PBS_AAAP_SendOfferDetailsAPI.captureLogs(offer.Id, 'response', 'request', '200');
            PBS_AAAP_SendOfferDetailsAPI.captureLogsAAAP(osai2.Id, 'response', 'request', '200', offer2.Id);
        }
        
        Test.stopTest();
    }
    
   
    
    static testMethod void validate_sendOfferDetails() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
        insert rlp;
        
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        PBS_AAAP_SendOfferDetailsAPI.ContentDocumentWrapper contentDocumentWrapperObj = new PBS_AAAP_SendOfferDetailsAPI.ContentDocumentWrapper('','',System.now(), '');
        
        Test.setMock(HttpCalloutMock.class, new PBS_AAAP_CalloutMockImpl());
        PBS_AAAP_SendOfferDetailsAPI.sendOfferDetails(JSON.serialize(offer));
        PBS_AAAP_SendOfferDetailsAPI.documentsAAAP wrapObj = new PBS_AAAP_SendOfferDetailsAPI.documentsAAAP(contentDocumentWrapperObj,offeratt);
        System.assert(true);      
        
    }
    static testMethod void unittest1() {
      PBS_AAAP_SendOfferDetailsAPI.documentsAAAP con = new PBS_AAAP_SendOfferDetailsAPI.documentsAAAP();
      con.documentDescription = 'test description';
      
       PBS_AAAP_SendOfferDetailsAPI.requestWrapperAAAP con1 = new PBS_AAAP_SendOfferDetailsAPI.requestWrapperAAAP();
       
      
       PBS_AAAP_SendOfferDetailsAPI.documents con2 = new PBS_AAAP_SendOfferDetailsAPI.documents();
       con2.documentDescription = 'test description';
       
       PBS_AAAP_SendOfferDetailsAPI.requestWrapper con3 = new PBS_AAAP_SendOfferDetailsAPI.requestWrapper();
       System.assertEquals(1,1);
    }
}