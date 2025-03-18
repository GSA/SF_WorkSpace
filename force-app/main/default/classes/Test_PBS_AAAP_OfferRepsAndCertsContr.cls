@IsTest
private class Test_PBS_AAAP_OfferRepsAndCertsContr {

    static testMethod void myOfferRepsAndCertsConstructorTest() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferRepsAndCerts');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            PBS_AAAP_Offer__c offer1 = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;

            offer1.PBS_AAAP_Representation__c = null;
            offer1.PBS_AAAP_Women_Owned_Identifier__c = null;
            offer1.PBS_AAAP_EEO_CLAUSE__c = null;
            offer1.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = null;
            offer1.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = null;
            offer1.PBS_AAAP_AUTHORIZED_SIGNATORY__c = null;
            offer1.PBS_AAAP_OWNER_CONVICTION__c = null;
            offer1.PBS_AAAP_OWNER_INDICTMENT__c = null;
            offer1.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = null;
            offer1.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = null;
            offer1.PBS_AAAP_Confirm_Owner_Status__c = null;
            //Vaishali 11/21/2013
            offer1.PBS_AAAP_FederalTax_Delinquent__c = null;
            offer1.PBS_AAAP_WOSB_Docs_Complete__c = null;
            offer1.PBS_AAAP_WOSB_Joint_Venture__c = null;
            offer1.PBS_AAAP_EDWOSB_Docs_Complete__c = null;
            offer1.PBS_AAAP_EDWOSB_Joint_Venture__c = null;
            offer1.EDWOSB_Joint_Venture_Names__c = null;
            offer1.WOSB_Joint_Venture_Names__c = null;
            offer1.PBS_AAAP_Corp_Not_Convicted_Felon__c = null;
            offer1.PBS_AAAP_Corporation_not_tax_felon__c = null;
            insert offer1;
            ApexPages.currentPage().getParameters().put('offerId', offer1.id);
            PBS_AAAP_OfferRepsAndCerts opc1;
            opc1 = new PBS_AAAP_OfferRepsAndCerts();
            opc1.gotoAttachmentsTab();

            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Other';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'KNOWN';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_Representation__c = 'Small Business';
            offer.PBS_AAAP_EEO_CLAUSE__c = 'No';
            offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes';
            offer.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = 'Yes';
            offer.PBS_AAAP_AUTHORIZED_SIGNATORY__c = 'No';
            //Vaishali 11/21/2013
            offer.PBS_AAAP_FederalTax_Delinquent__c = 'No';
            offer.PBS_AAAP_WOSB_Docs_Complete__c = 'Yes';
            offer.PBS_AAAP_WOSB_Joint_Venture__c = 'No';
            offer.PBS_AAAP_EDWOSB_Docs_Complete__c = 'Yes';
            offer.PBS_AAAP_EDWOSB_Joint_Venture__c = 'No';
            offer.EDWOSB_Joint_Venture_Names__c = null;
            offer.WOSB_Joint_Venture_Names__c = null;
            offer.PBS_AAAP_Corp_Not_Convicted_Felon__c = 'Yes';
            offer.PBS_AAAP_Corporation_not_tax_felon__c = 'Yes';


            insert offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferRepsAndCerts opc;

            Test.startTest();
            opc = new PBS_AAAP_OfferRepsAndCerts();


            List<SelectOption> items = opc.getItems();
            System.assert(items.size() > 0);

            List<SelectOption> itemsQ9 = opc.getItemsQ9();
            System.assert(itemsQ9.size() > 0);

            List<SelectOption> sb = opc.getSmallBusiness();
            System.assert(sb.size() > 0);


            PageReference page = opc.backToOfrPropertyOwnerTab();
            System.assert(page != null);

            page = opc.gotoAttachmentsTab();
            System.assert(page != null);

            PageReference pgOpCost = new PageReference('/apex//pbs_aaap_operatingcosts');
            pgOpCost.getParameters().put('offerId', offer.Id);
            System.assertEquals(opc.gotoAttachmentsTab().getUrl(), pgOpCost.getUrl());


            opc.offerRepsAndCerts = offer;
            opc.showPropertyOwnerSmallBusiness();
            opc.getSmallBusinessYES();
            system.assertEquals(opc.smallBusinessYES, true);

            opc.showPropertyOwnerComplianceReport();
            opc.getComplianceReport();
            system.assertEquals(opc.complianceReport, false);

            opc.showPropertyOwnerSecretaryLabor3a();
            opc.getSecretaryLabor();
            system.assertEquals(opc.secretaryLabor, false);

            opc.showPropertyOwnerSecretaryAcknowledge4a();
            opc.getAuthorizedSignature();

            opc.showPropertyOwnerPersonFullName4b();
            opc.getAuthorizedNames();

            opc.showPropertyOwnerVeteranOwned();
            opc.getSmallBusiness1D();
            system.assertEquals(opc.smallBusiness1D, true);
            opc.showPropertyOwnerHUBZONE();
            opc.getSmallBusinessHUBZONE();
            system.assertEquals(opc.smallBusinessHUBZONE, true);
            opc.showPropertyOwnerHUBZONEJointVentureNames();
            opc.getSmallBusinessHUBZONENames();
            system.assertEquals(opc.smallBusinessHUBZONENames, true);

            page = opc.actionDeleteOffer();
            System.assert(page == null);


            offer.PBS_AAAP_Representation__c = 'Not a Small Business';
            offer.PBS_AAAP_Veteran_Owned_Identifier__c = 'Yes';
            offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'Yes';
            offer.PBS_AAAP_HUBZONE_JOINT_VENTURE__c = 'Yes';
            offer.PBS_AAAP_EEO_CLAUSE__c = 'Yes';
            offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'No';
            offer.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = 'No';
            offer.PBS_AAAP_AUTHORIZED_SIGNATORY__c = 'Yes';

            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            update offer;
            opc.offerRepsAndCerts = offer;
            opc.showPropertyOwnerSmallBusiness();
            opc.getSmallBusinessNO();
            system.assertEquals(opc.smallBusinessNo, true);
            opc.showPropertyOwnerVeteranOwned();
            opc.getSmallBusiness1D();
            system.assertEquals(opc.smallBusiness1D, false);
            opc.showPropertyOwnerHUBZONE();
            opc.getSmallBusinessHUBZONE();
            system.assertEquals(opc.smallBusinessHUBZONE, false);
            opc.showPropertyOwnerHUBZONEJointVentureNames();
            opc.getSmallBusinessHUBZONENames();
            system.assertEquals(opc.smallBusinessHUBZONENames, false);

            opc.showPropertyOwnerComplianceReport();
            opc.getComplianceReport();
            system.assertEquals(opc.complianceReport, true);

            opc.showPropertyOwnerSecretaryLabor3a();
            opc.getSecretaryLabor();
            system.assertEquals(opc.secretaryLabor, true);

            opc.showPropertyOwnerSecretaryAcknowledge4a();
            opc.getAuthorizedSignature();

            opc.showPropertyOwnerPersonFullName4b();
            opc.getAuthorizedNames();


            page = opc.saveRepsAndCertsInfo();
            //System.assert(page != null);

            page = opc.actionDeleteOffer();
            System.assert(page != null);

            page = opc.actionCancel();
            System.assert(page != null);
            //Syam adding more test cases to increase the coverage
            opc.getWOSB1();
            opc.getEDWOSB1();
            opc.getWOSBJointNames();
            opc.getEDWOSBJointNames();
            offer.PBS_AAAP_Representation__c = 'Small Business';
            offer.PBS_AAAP_Women_Owned_Identifier__c = null;
            opc.checkOfferRepsAndCertsValidations();
            offer.PBS_AAAP_Women_Owned_Identifier__c = 'Yes';
            opc.showPropertyOwnerWOSB();
            Test.stopTest();

        }
    }
    static testMethod void myTest1() {
        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferRepsAndCerts');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Other';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'KNOWN';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_Representation__c = 'Small Business';
            offer.PBS_AAAP_EEO_CLAUSE__c = 'No';
            offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes';
            offer.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = 'Yes';
            offer.PBS_AAAP_AUTHORIZED_SIGNATORY__c = 'No';
            //Vaishali 11/21/2013
            offer.PBS_AAAP_FederalTax_Delinquent__c = 'No';
            offer.PBS_AAAP_WOSB_Docs_Complete__c = 'Yes';
            offer.PBS_AAAP_WOSB_Joint_Venture__c = 'No';
            offer.PBS_AAAP_EDWOSB_Docs_Complete__c = 'Yes';
            offer.PBS_AAAP_EDWOSB_Joint_Venture__c = 'No';
            offer.EDWOSB_Joint_Venture_Names__c = null;
            offer.WOSB_Joint_Venture_Names__c = null;
            offer.PBS_AAAP_Corp_Not_Convicted_Felon__c = 'Yes';
            offer.PBS_AAAP_Corporation_not_tax_felon__c = 'Yes';
            insert offer;

            PageReference pgOpCost = new PageReference('/apex//pbs_aaap_operatingcosts');
            System.assert(pgOpCost != null);
            currentPage.getParameters().put('offerId', offer.Id);
            System.assert(offer.Id != null);
            Test.startTest();
            PBS_AAAP_OfferRepsAndCerts opc = new PBS_AAAP_OfferRepsAndCerts();
            System.debug('before goto attachmentsTab ****syam ***');
            PageReference page = opc.gotoAttachmentsTab();
            System.assert(page != null);
            System.debug('page url is ****syam ***' + page.getUrl());
            Test.stopTest();
        }
    }
}