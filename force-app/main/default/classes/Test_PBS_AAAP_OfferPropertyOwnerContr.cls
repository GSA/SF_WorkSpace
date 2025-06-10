@IsTest
private class Test_PBS_AAAP_OfferPropertyOwnerContr {

    static testMethod void myOfferPropertyOwnerConstructorTest() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferPropertyOwner');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Other';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'KNOWN';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferPropertyOwner opc;

            Test.startTest();
            opc = new PBS_AAAP_OfferPropertyOwner();

            List<SelectOption> items = opc.getItems();
            System.assert(items.size() > 0);

            List<SelectOption> partialItems = opc.getTINNotRequiredReasonItems();
            System.assert(partialItems.size() > 0);

            Boolean flag = opc.getOtherRelationShip();
            System.assert(flag == true);
            PageReference page = opc.showOfferorRelationShipOther();
            System.assert(page == null);

            flag = opc.getRecordOwnershipOther();
            System.assert(flag == true);

            opc.showPropertyOwnerCommonParentSection();
            flag = opc.getParentName();
            System.assert(flag == true);

            page = opc.showRecordOwnershipOther();
            System.assert(page == null);

            flag = opc.getTinStatusKnown();
            System.assert(flag == true);

            page = opc.showTINStatus();
            System.assert(page == null);

            page = opc.actionSavePropertyOwnerAndContinue();
            System.assert(page == null);
            
            opc.sameOwner = TRUE;
            opc.copyUserDetails();
            Test.stopTest();


        }
    }
    static testMethod void myOfferPropertyOwnerConstructorTestErrors() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferPropertyOwner');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Other';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'KNOWN';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_Owner_Name__c  = null;
            offer.PBS_AAAP_Owner_Address__c  = null;
            offer.PBS_AAAP_Owner_Country__c  = null;
            offer.PBS_AAAP_Owner_City__c  = null;
            offer.PBS_AAAP_OFFEROR_INTEREST__c  = null;
            offer.PBS_AAAP_OFFEROR_INTEREST__c  = null;
            offer.PBS_AAAP_DUNS_Number__c  = null;

            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferPropertyOwner opc;

            Test.startTest();
            opc = new PBS_AAAP_OfferPropertyOwner();

            List<SelectOption> items = opc.getItems();
            System.assert(items.size() > 0);

            List<SelectOption> partialItems = opc.getTINNotRequiredReasonItems();
            System.assert(partialItems.size() > 0);

            Boolean flag = opc.getOtherRelationShip();
            opc.sameOwner = TRUE;
            opc.copyUserDetails();
            Test.stopTest();
        }
    }

    static testMethod void myOfferPropertyOwnerConstructorTest1() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferPropertyOwner');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Partnership';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'Not Required';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'No';
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferPropertyOwner opc;


            Test.startTest();
            opc = new PBS_AAAP_OfferPropertyOwner();
            opc.sameOwner = TRUE;//JKantarovsky added this line for code coverage 7/2021

            Boolean flag = opc.getOtherRelationShip();
            System.assert(flag == false);
            PageReference page = opc.showOfferorRelationShipOther();
            System.assert(page == null);

            flag = opc.getRecordOwnershipOther();
            System.assert(flag == false);

            page = opc.showRecordOwnershipOther();
            System.assert(page == null);

            opc.showPropertyOwnerCommonParentSection();

            flag = opc.getTinStatusNotRequired();
            System.assert(flag == true);

            page = opc.showTINStatus();
            System.assert(page == null);

            page = opc.actionDeleteOffer();
            System.assert(page != null);

            page = opc.backToOfrParking();
            System.assert(page == null);

            page = opc.actionSavePropertyOwner();
            Test.stopTest();
        }
    }

    static testMethod void myOfferPropertyOwnerConstructorTest2() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferPropertyOwner');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_Owner_TIN_Status__c = 'Applied for';
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferPropertyOwner opc;


            Test.startTest();
            opc = new PBS_AAAP_OfferPropertyOwner();

            PageReference page = opc.showTINStatus();
            System.assert(page == null);

            page = opc.actionDeleteOffer();
            System.assert(page == null);
            Test.stopTest();
        }
    }

    static testMethod void myOfferPropertyOwnerExceptionTest2() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferPropertyOwner');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_Owner_TIN_Status__c = null;
            offer.PBS_AAAP_Owner_Name__c = null;
            offer.PBS_AAAP_Owner_Address__c = null;
            offer.PBS_AAAP_Owner_Country__c = null;
            offer.PBS_AAAP_Owner_City__c = null;
            offer.PBS_AAAP_Owner_State__c = null;
            offer.PBS_AAAP_Owner_Zip__c = null;
            offer.PBS_AAAP_Owner_Main_Phone__c = null;
            offer.PBS_AAAP_Common_Parent_TIN__c = null;
            offer.PBS_AAAP_DUNS_Number__c = null;
            offer.PBS_AAAP_OFFEROR_INTEREST__c = null;
            offer.PBS_AAAP_TYPE_OF_ORG__c = null;
            offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = null;
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = null;

            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferPropertyOwner opc;

            Test.startTest();
            opc = new PBS_AAAP_OfferPropertyOwner();

            PageReference page = opc.actionSavePropertyOwnerAndContinue(); // throws exception as we are not passing id to update the offer.
            System.assert(page == null);
            Test.stopTest();
        }
    }

    static testMethod void myOfferPropertyOwnerExceptionTest3() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferPropertyOwner');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_Owner_TIN_Status__c = PBS_AAAP_GlobalConstants.TIN_KNOWN;
            offer.PBS_AAAP_Owner_Name__c = null;
            offer.PBS_AAAP_Owner_Address__c = null;
            offer.PBS_AAAP_Owner_Country__c = 'United States';
            offer.PBS_AAAP_Owner_City__c = null;
            offer.PBS_AAAP_Owner_State__c = null;
            offer.PBS_AAAP_Owner_Zip__c = null;
            offer.PBS_AAAP_Owner_Main_Phone__c = null;
            offer.PBS_AAAP_Common_Parent_TIN__c = null;
            offer.PBS_AAAP_DUNS_Number__c = null;
            offer.PBS_AAAP_OFFEROR_INTEREST__c = null;
            offer.PBS_AAAP_TYPE_OF_ORG__c = null;
            offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = null;
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_PARENT_NAME__c = null;
            offer.PBS_AAAP_Owner_TIN_Assigned__c = null;
            offer.PBS_AAAP_Building_Name__c = null;

            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferPropertyOwner opc;

            Test.startTest();
            opc = new PBS_AAAP_OfferPropertyOwner();

            PageReference page = opc.actionSavePropertyOwnerAndContinue(); // throws exception as we are not passing id to update the offer.
            System.assert(page == null);

            Test.stopTest();
        }
    }
    
    static testMethod void myOfferPropertyOwnerExceptionTest4() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferPropertyOwner');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferPropertyOwner opc;

            Test.startTest();
            opc = new PBS_AAAP_OfferPropertyOwner();
            opc.sameOwner = TRUE;

            PageReference page = opc.actionSavePropertyOwnerAndContinue();
            System.assert(page == null);

            page = opc.actionCancel();
            System.assert(page != null);
            Test.stopTest();
        }
    }
}