@IsTest
private class Test_PBS_AAAP_SelectedOfferSpace_Contr {

    static testMethod void myUnitTest() {
        PageReference pageRef = Page.PBS_AAAP_SelectedOfferSpace;
        Test.setCurrentPage(pageRef);


        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
        insert offer;

        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        insert agency;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_isSelected__c = true;
        osai.PBS_AAAP_SELECTED_USF__c = 300000.00;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        insert osai;

        ApexPages.currentPage().getParameters().put('selectedOfferId', offer.Id);
        ApexPages.currentPage().getParameters().put('selectedSpaceId', space.Id);
        ApexPages.currentPage().getParameters().put('agencyRequirementId', agency.Id);
        PBS_AAAP_OfferDeselectReasonContr odrc = new PBS_AAAP_OfferDeselectReasonContr();

        PageReference pref = odrc.actionSaveDeselectReason();
        PBS_AAAP_Offer_Deselect_Reject_Reasons__c odrr = new PBS_AAAP_Offer_Deselect_Reject_Reasons__c();

        odrr.PBS_AAAP_Action_Reason__c = 'Other';
        odrr.PBS_AAAP_Action_Comments__c = null;
        odrc.offerDeselect = odrr;
        pref = odrc.actionSaveDeselectReason();

        odrr.PBS_AAAP_Action_Reason__c = 'Other';
        odrr.PBS_AAAP_Action_Comments__c = 'Other';
        odrc.offerDeselect = odrr;
        pref = odrc.actionSaveDeselectReason();

        pref = odrc.actionCancelDeselect();
        System.assertNotEquals(pref, null);

    }

    static testMethod void myUnitTestOfferAwardedSelected() {
        PageReference pageRef = Page.PBS_AAAP_AgencyRequirementEdit;
        Test.setCurrentPage(pageRef);

        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        // rate.

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        insert agency;

        ApexPages.currentPage().getParameters().put('selectedOfferId', offer.Id);
        ApexPages.currentPage().getParameters().put('selectedSpaceId', space.Id);
        ApexPages.currentPage().getParameters().put('agencyRequirementId', agency.Id);
        PBS_AAAP_OfferDeselectReasonContr odrc = new PBS_AAAP_OfferDeselectReasonContr();

        PageReference pref = odrc.actionSaveDeselectReason();
        PBS_AAAP_Offer_Deselect_Reject_Reasons__c odrr = new PBS_AAAP_Offer_Deselect_Reject_Reasons__c();

        odrr.PBS_AAAP_Action_Reason__c = 'Other';
        odrr.PBS_AAAP_Action_Comments__c = 'Other';
        odrc.offerDeselect = odrr;
        pref = odrc.actionSaveDeselectReason();
        System.assertEquals(pref, null);

    }
    static testMethod void myUnitTestOfferSelected() {
        PageReference pageRef = Page.PBS_AAAP_AgencyRequirementEdit;
        Test.setCurrentPage(pageRef);

        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED;
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        // rate.

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        insert agency;

        ApexPages.currentPage().getParameters().put('selectedOfferId', offer.Id);
        ApexPages.currentPage().getParameters().put('selectedSpaceId', space.Id);
        ApexPages.currentPage().getParameters().put('agencyRequirementId', agency.Id);
        PBS_AAAP_OfferDeselectReasonContr odrc = new PBS_AAAP_OfferDeselectReasonContr();

        PageReference pref = odrc.actionSaveDeselectReason();
        PBS_AAAP_Offer_Deselect_Reject_Reasons__c odrr = new PBS_AAAP_Offer_Deselect_Reject_Reasons__c();

        odrr.PBS_AAAP_Action_Reason__c = 'Other';
        odrr.PBS_AAAP_Action_Comments__c = 'Other';
        odrc.offerDeselect = odrr;
        pref = odrc.actionSaveDeselectReason();
        System.assertEquals(pref, null);

    }

    static testMethod void myUnitTestSelectedOfferSpace() {
        Test.startTest();
        PageReference pageRef = Page.PBS_AAAP_SelectedOfferSpace;
        Test.setCurrentPage(pageRef);

        //PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_Total_ABOA_Selected__c = null;
        insert space;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        // rate.

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        insert agency;
        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_isSelected__c = true;
        osai.PBS_AAAP_SELECTED_USF__c = 30000.00;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        insert osai;

        ApexPages.currentPage().getParameters().put('selectedOfferSpaceId', osai.Id);
        ApexPages.currentPage().getParameters().put('agencyId', agency.Id);
        PBS_AAAP_SelectedOfferSpace_Contr odrc = new PBS_AAAP_SelectedOfferSpace_Contr();
        odrc.currentObj.PBS_AAAP_SELECTED_USF__c = null;
        PageReference pref = odrc.actionSave();

        odrc.currentObj.PBS_AAAP_SELECTED_USF__c = 30000.00;
        pref = odrc.actionSave();

        System.assertNotEquals(pref, null);

        ApexPages.currentPage().getParameters().put('selectedOfferSpaceId', osai.Id);
        odrc = new PBS_AAAP_SelectedOfferSpace_Contr();
        odrc.actionCancel();

        Test.stopTest();
    }

    static testMethod void myUnitTestSelectedOfferSpace1() {
        Test.startTest();
        PageReference pageRef = Page.PBS_AAAP_SelectedOfferSpace;
        Test.setCurrentPage(pageRef);

        //PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
        insert offer;
        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        space.PBS_AAAP_Total_ABOA_Selected__c = null;
        insert space;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        // rate.

        PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();
        insert agency;
        PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
        osai.PBS_AAAP_isSelected__c = true;
        osai.PBS_AAAP_SELECTED_USF__c = 30000.00;
        osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
        osai.PBS_AAAP_Space_ID__c = space.Id;
        insert osai;

        ApexPages.currentPage().getParameters().put('selectedOfferSpaceId', osai.Id);
        ApexPages.currentPage().getParameters().put('agencyId', agency.Id);
        PBS_AAAP_SelectedOfferSpace_Contr odrc = new PBS_AAAP_SelectedOfferSpace_Contr();
        odrc.currentObj.PBS_AAAP_SELECTED_USF__c = null;
        PageReference pref = odrc.actionSave();

        odrc.currentObj.PBS_AAAP_SELECTED_USF__c = 30000.00;
        pref = odrc.actionSave();

        System.assertNotEquals(pref, null);

        ApexPages.currentPage().getParameters().put('selectedOfferSpaceId', osai.Id);
        odrc = new PBS_AAAP_SelectedOfferSpace_Contr();
        odrc.actionCancel();

        Test.stopTest();
    }
}