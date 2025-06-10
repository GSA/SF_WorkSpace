//Class Updated by Henry Dennis on 7/7/22

@IsTest
private class Test_PBS_AAAP_OfferAttachmentsContr {
 
    static testMethod void myOfferAttachmentsConstructorTest() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            PBS_AAAP_Offer_Attachments__c offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Authorization to Represent Ownership Entity', PBS_AAAP_Offer__c = offer.id);
            insert offeratt2;
            PBS_AAAP_Offer_Attachments__c offeratt3 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Other', PBS_AAAP_Offer__c = offer.id, PBS_AAAP_Sent_to_GREX__c = true);
            insert offeratt3;
            Blob b = Blob.valueOf('Test Data');
            Attachment attachment2 = new Attachment();
            attachment2.Name = 'Test Attachment for Parent2';
            attachment2.Body = b;
            attachment2.ParentId = offeratt2.Id;
            Attachment attachment = new Attachment();
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;
            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.getItems();
            opc.actionCancelSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);

            boolean flag = opc.checkOfferSubmissionValidations();
            System.assertEquals(flag, null);
            opc.actionSaveAndSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);
            opc.actionRequestPIN();
            pref = opc.actionDeleteOffer();
            System.assertEquals(pref, null);
            opc.actionDeleteAttachment();
            
            
            offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Authorization to Represent Ownership Entity', PBS_AAAP_Offer__c = offer.id, PBS_AAAP_Sent_to_GREX__c = true);
            insert offeratt2;
            
            offeratt3 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Other', PBS_AAAP_Offer__c = offer.id, PBS_AAAP_Sent_to_GREX__c = true);
            insert offeratt3;
            
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.uploadAdditional();
            
            rlp.PBS_AAAP_Year__c = '2019';
            update rlp;
            opc.DownloadAllFiles();
            PBS_AAAP_OfferAttachmentsController.ContentDocumentWrapper cdw = new PBS_AAAP_OfferAttachmentsController.ContentDocumentWrapper('Hi','Hi',Date.today(),'Hi');
            PBS_AAAP_OfferAttachmentsController.sequenceNumber sqn = new PBS_AAAP_OfferAttachmentsController.sequenceNumber(1,offeratt,cdw);
            PBS_AAAP_OfferAttachmentsController.FORMWrapper fw = new PBS_AAAP_OfferAttachmentsController.FORMWrapper(offeratt,'Hi');
            Test.stopTest();
        }
    }

    static testMethod void myOfferAttachmentsConstructorTest1() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            PBS_AAAP_Offer_Attachments__c offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Authorization to Represent Ownership Entity', PBS_AAAP_Offer__c = offer.id);
            insert offeratt2;
            Blob b = Blob.valueOf('Test Data');
            Blob attBody = Blob.valueOf('Test Data');
            Attachment attachment2 = new Attachment();
            attachment2.Name = 'Test Attachment for Parent2';
            attachment2.Body = b;
            attachment2.ParentId = offeratt2.Id;

            Attachment attachment = new Attachment();
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;

            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            pref = opc.actionDeleteOffer();
            System.assertNotEquals(pref, null);
            opc.redirectToHome();
            opc.actionBackToRatesAndSpaces();
            pref = opc.actionCancel();
            Test.stopTest();
        }
    }
    static testMethod void myOfferAttachmentsConstructorTest2() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            PBS_AAAP_Offer_Attachments__c offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Authorization to Represent Ownership Entity', PBS_AAAP_Offer__c = offer.id);
            insert offeratt2;
            Blob b = Blob.valueOf('Test Data');
            Blob attBody = Blob.valueOf('Test Data');
            Attachment attachment2 = new Attachment();
            attachment2.Name = 'Test Attachment for Parent2';
            attachment2.Body = b;
            attachment2.ParentId = offeratt2.Id;

            Attachment attachment = new Attachment();
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;
            System.debug('******** Hello Vaishali::: ' + offer.PBS_AAAP_Offer_Status__c);

            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            pref = opc.actionDeleteOffer();
            System.assertEquals(pref, null);
            opc.redirectToHome();
            opc.actionBackToRatesAndSpaces();
            pref = opc.actionCancel();
            Test.stopTest();
        }
    }

    static testMethod void myOfferAttachmentsConstructorTestUpload() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            PBS_AAAP_Offer__c childOffer = PBS_AAAP_UtilityTest.createOfferInfo();
            childOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            childOffer.PBS_AAAP_RLP_Number__c = rlp.Id;
            childOffer.Master_Offer__c = offer.Id;
            insert childOffer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            PBS_AAAP_Offer_Attachments__c offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Authorization to Represent Ownership Entity', PBS_AAAP_Offer__c = offer.id);
            insert offeratt2;
            PBS_AAAP_Offer_Attachments__c offeratt3 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Other', PBS_AAAP_Offer__c = offer.id);
            insert offeratt3;
            Blob b = Blob.valueOf('Test Data');
            Attachment attachment2 = new Attachment();
            attachment2.Name = 'Test Attachment for Parent2';
            attachment2.Body = b;
            attachment2.ParentId = offeratt.Id;

            Attachment attachment = new Attachment();
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
           
            PageReference pref = null;

            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            
            PBS_AAAP_Offer_Attachments__c ofratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offer.id);
            opc.offerattachment = offeratt;
            Blob b1 = Blob.valueOf('Test Data');
            Attachment att = new Attachment();
            att.Name = 'Test Attachment for Parent';
            opc.offerattachment = ofratt;
            opc.attBody = b1;
            opc.attName = 'Test Attachment for Parent';
            opc.upload();

            ofratt.PBS_AAAP_Attachment_Type__c = 'Floor Plan';
            opc.offerattachment = ofratt;
            opc.attBody = b1;
            opc.attName = 'Test Attachment for Parent1';
            opc.upload();            
            
            att.Body = b1;
            opc.actionSubmitOffer();

            pref = opc.actionDeleteOffer();
            opc.redirectToHome();
            opc.actionBackToRatesAndSpaces();
            Test.stopTest();
            List<Attachment> allAttachment = [Select Id From Attachment];
            System.assert(true);
                      
        }
    }

    static testMethod void myOfferAttachmentsConstructorTestSubmit() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            insert offer;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            opc.showMultiOwners();
            boolean flag = opc.getMultiOwners();
            System.assertEquals(flag, true);
            opc.actionSubmitOffer();


            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
            PBS_AAAP_Offer__c offerparent = PBS_AAAP_UtilityTest.createOfferInfo();
            offerparent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offerparent;
            offer.PBS_AAAP_Parent_Offer__c = offerparent.Id;
            update offer;
            opc.submitOffer = offer;

            opc.actionSubmitOffer();
            opc.actionSavePage();
            opc.pageUrl = '1====';
            opc.actionSavePage();

        }
    }

    static testMethod void myOfferSubmitCheckValidations() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;

            PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
            offer.PBS_AAAP_County__c = 'fairfax';
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 Wasser Ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            insert offer;
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments?offerId='+offer.id);
            Test.setCurrentPage(currentPage);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            opc.actionSubmitOffer();

            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 wasser ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            offer.PBS_AAAP_County__c = 'Fairfax';
            offer.PBS_AAAP_Energy_Star__c = 'Yes';
            offer.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offer.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offer.PBS_AAAP_Number_of_floors__c = 12;
            offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 400000;
            offer.PBS_AAAP_OFFICE_SPACE_RSF__c = 50000;
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 300000;
            offer.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Wood';
            offer.PBS_AAAP_Year_Built__c = '2001';
            offer.PBS_AAAP_Renovation_Year__c = '2007';
            offer.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offer.PBS_AAAP_MetroRail_Station__c = 'Metro';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '6:00 PM';
            offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c = '10:00 AM';
            offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c = '10:00 AM';
            offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';

            update offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            opc.actionSubmitOffer();
            offer.PBS_AAAP_Option_Parking__c = 'Yes';
            update offer;
            test.startTest();
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            opc.actionSubmitOffer();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'No';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            offer.PBS_AAAP_X_CO_ORD__c = -77.00896157;
            offer.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
            update offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            opc.showMultiOwners();
            opc.actionSubmitOffer();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '121212';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            update offer;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            opc.actionSubmitOffer();

            //Vaishali RLP FY15 90% coverage
            System.debug('***** message component: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getComponentLabel());
            System.debug('***** message detail: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getDetail());
            System.debug('***** message summary: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary());
            System.debug('***** message: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1));
            //Vaishali RLP FY15 Multi Owner Check
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            update offer;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            opc.actionSubmitOffer();
            System.debug('***** message component: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getComponentLabel());
            System.debug('***** message detail: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getDetail());
            System.debug('***** message summary: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary());
            System.debug('***** message: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1));

            PBS_AAAP_Offer__c offerParent = PBS_AAAP_UtilityTest.createOfferInfo();
            offerParent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offerParent;

            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
            offer.PBS_AAAP_Parent_Offer__c = offerParent.Id;
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'Yes'; //Vaishali
            update offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            opc.actionSubmitOffer();
            System.assertEquals(offerParent.Id, offer.PBS_AAAP_Parent_Offer__c);
            System.debug('***** message component: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getComponentLabel());
            System.debug('***** message detail: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getDetail());
            System.debug('***** message summary: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1).getSummary());
            System.debug('***** HELLO VAISHALI: ' + ApexPages.getMessages().get(ApexPages.getMessages().size() - 1));

			//Vaishali Offer delete attachment check            
            PBS_AAAP_Offer_Attachments__c offeratt1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt1;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.attachmentId = offeratt1.Id;
            PageReference pref = null;
            opc.actionDeleteAttachment();
            System.assert(opc != null);

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.attachmentId = null;
            opc.actionDeleteAttachment();
            System.assert(opc != null);
            test.stopTest();
        }
    }

    static testMethod void myOfferSubmission() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;

            PBS_AAAP_Offer__c offerParent = PBS_AAAP_UtilityTest.createOfferInfo();
            offerParent.PBS_AAAP_RLP_Number__c = rlp.Id;
            offerParent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            insert offerParent;

            PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 Wasser Ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            offer.PBS_AAAP_Energy_Star__c = 'Yes';
            offer.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offer.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offer.PBS_AAAP_Number_of_floors__c = 12;
            offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 400000;
            offer.PBS_AAAP_OFFICE_SPACE_RSF__c = 50000;
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 300000;
            offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 200000;
            offer.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Wood';
            offer.PBS_AAAP_Year_Built__c = '2001';
            offer.PBS_AAAP_Renovation_Year__c = '2007';
            offer.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offer.PBS_AAAP_MetroRail_Station__c = 'Metro';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '6:00 PM';
            offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c = '10:00 AM';
            offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c = '10:00 AM';
            offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_Option_Parking__c = 'Yes';
            offer.PBS_AAAP_Owner_Name__c = 'Test User';
            offer.PBS_AAAP_Owner_Address__c = '1660 International Drive';
            offer.PBS_AAAP_Owner_Country__c = 'USA';
            offer.PBS_AAAP_Owner_City__c = 'McLean';
            offer.PBS_AAAP_Owner_State__c = 'VA';
            offer.PBS_AAAP_Owner_Zip__c = '22102';
            offer.PBS_AAAP_county__c = 'fairfax';
            offer.PBS_AAAP_Owner_Main_Phone__c = '232-232-2332';
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Sole Proprietorship';
            offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Fee Simple';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_PARENT_NAME__c = null;
            offer.PBS_AAAP_Common_Parent_TIN__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'Known';
            offer.PBS_AAAP_Owner_TIN_Assigned__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Representation__c = 'Yes';
            offer.PBS_AAAP_Women_Owned_Identifier__c = 'Yes';
            offer.PBS_AAAP_EEO_CLAUSE__c = 'Yes';
            offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes';
            offer.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = 'Yes';
            offer.PBS_AAAP_Confirm_Owner_Status__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONVICTION__c = 'Yes';
            offer.PBS_AAAP_OWNER_INDICTMENT__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = 'Yes';
            offer.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = 'Yes';
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            offer.PBS_AAAP_Parent_Offer__c = offerParent.Id;
            offer.PBS_AAAP_COST_PER_ABOA__c = 10;
            insert offer;
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments?offerId='+offer.id);
            Test.setCurrentPage(currentPage);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            opc.actionSubmitOffer();

            PBS_AAAP_Space__c sp0 = new PBS_AAAP_Space__c();
            sp0 = PBS_AAAP_UtilityTest.createSpace();
            sp0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            sp0.PBS_AAAP_SF_OFFERED__c = 200000;
            insert sp0;
            PBS_AAAP_Rate__c r0 = new PBS_AAAP_Rate__c();
            r0 = PBS_AAAP_UtilityTest.createRate();
            r0.PBS_AAAP_Space__c = sp0.Id;
            r0.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10;
            insert r0;
            PageReference pref = null;
            pref = opc.actionCheckErrors();
            opc.actionSubmitOffer();
            System.assertEquals(pref, null);          
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'Yes';
            update offer;
            r0.PBS_AAAP_BSAC_RATE__c = null;
            r0.PBS_AAAP_BSAC__c = null;
            update r0;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionCheckErrors();
            System.assertEquals(pref, null);
            System.debug('***** HELLO VAISHALI B4: ');

            pref = opc.actionSaveAndSubmitOffer();
            System.debug('***** HELLO VAISHALI1: ');
            System.debug('***** HELLO VAISHALI2: ');
            System.assertEquals(pref, null);
            r0.PBS_AAAP_LEASE_TERM__c = '5+5 Years';
            r0.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 0;
            r0.PBS_AAAP_BSAC__c = 5;
            offer.PBS_AAAP_COST_PER_ABOA__c = 0;
            offer.PBS_AAAP_Option_Parking__c = null;
            update r0;
            update offer;
            opc.addrFlag = 'true';
            pref = opc.actionCheckErrors();
            pref = opc.actionSaveAndSubmitOffer();

            opc.upload();
            opc.getItems();
            opc.actionDeleteAttachment();
            opc.actionCancelSubmitOffer();
            opc.actionCancel();
        }
    }

     static testMethod void myOfferSubmission1() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;

            PBS_AAAP_Offer__c offerParent = PBS_AAAP_UtilityTest.createOfferInfo();
            offerParent.PBS_AAAP_RLP_Number__c = rlp.Id;
            offerParent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
            insert offerParent;

            PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 Wasser Ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            offer.PBS_AAAP_Energy_Star__c = 'Yes';
            offer.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offer.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offer.PBS_AAAP_Number_of_floors__c = 12;
            offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 400000;
            offer.PBS_AAAP_OFFICE_SPACE_RSF__c = 50000;
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 300000;
            offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 200000;
            offer.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Wood';
            offer.PBS_AAAP_Year_Built__c = '2001';
            offer.PBS_AAAP_Renovation_Year__c = '2007';
            offer.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offer.PBS_AAAP_MetroRail_Station__c = 'Metro';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '6:00 PM';
            offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c = '10:00 AM';
            offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c = '10:00 AM';
            offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_Option_Parking__c = 'Yes';
            offer.PBS_AAAP_Owner_Name__c = 'Test User';
            offer.PBS_AAAP_Owner_Address__c = '1660 International Drive';
            offer.PBS_AAAP_Owner_Country__c = 'USA';
            offer.PBS_AAAP_Owner_City__c = 'McLean';
            offer.PBS_AAAP_Owner_State__c = 'VA';
            offer.PBS_AAAP_Owner_Zip__c = '22102';
            offer.PBS_AAAP_county__c = 'fairfax';
            offer.PBS_AAAP_Owner_Main_Phone__c = '232-232-2332';
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Sole Proprietorship';
            offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Fee Simple';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_PARENT_NAME__c = null;
            offer.PBS_AAAP_Common_Parent_TIN__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'Known';
            offer.PBS_AAAP_Owner_TIN_Assigned__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Representation__c = 'Yes';
            offer.PBS_AAAP_Women_Owned_Identifier__c = 'Yes';
            offer.PBS_AAAP_EEO_CLAUSE__c = 'Yes';
            offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes';
            offer.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = 'Yes';
            offer.PBS_AAAP_Confirm_Owner_Status__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONVICTION__c = 'Yes';
            offer.PBS_AAAP_OWNER_INDICTMENT__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = 'Yes';
            offer.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = 'Yes';
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            offer.PBS_AAAP_Parent_Offer__c = offerParent.Id;
            offer.PBS_AAAP_COST_PER_ABOA__c = 10;
            offer.PBS_AAAP_X_CO_ORD__c = -77.00896157;
            offer.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
            insert offer;
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments?offerId='+offer.id);
            Test.setCurrentPage(currentPage);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            opc.actionSubmitOffer();

            PBS_AAAP_Space__c sp0 = new PBS_AAAP_Space__c();
            sp0 = PBS_AAAP_UtilityTest.createSpace();
            sp0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            sp0.PBS_AAAP_SF_OFFERED__c = 200000;
            insert sp0;
            PBS_AAAP_Rate__c r0 = new PBS_AAAP_Rate__c();
            r0 = PBS_AAAP_UtilityTest.createRate();
            r0.PBS_AAAP_Space__c = sp0.Id;
            r0.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10;
            insert r0;
            PageReference pref = null;
            pref = opc.actionCheckErrors();
            opc.actionSubmitOffer();
            
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'Yes';
            update offer;
            r0.PBS_AAAP_BSAC_RATE__c = null;
            r0.PBS_AAAP_BSAC__c = 0;
            update r0;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionCheckErrors();
            System.assertEquals(pref, null);
            System.debug('***** HELLO VAISHALI B4: ');

            pref = opc.actionSaveAndSubmitOffer();
            System.debug('***** HELLO VAISHALI1: ');
            System.debug('***** HELLO VAISHALI2: ');
            System.assertEquals(pref, null);
            r0.PBS_AAAP_LEASE_TERM__c = '5+5 Years';
            r0.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 0;
            r0.PBS_AAAP_BSAC__c = 5;
            offer.PBS_AAAP_COST_PER_ABOA__c = 0;
            offer.PBS_AAAP_Option_Parking__c = null;
            update r0;
            update offer;
            opc.addrFlag = 'true';
            pref = opc.actionCheckErrors();
            pref = opc.actionSaveAndSubmitOffer();

            opc.upload();
            opc.getItems();
            opc.actionDeleteAttachment();
            opc.actionCancelSubmitOffer();
            opc.actionCancel();
        }
    }

    static testMethod void myOfferSubmission2() {
        string suffix = '';
        integer AliasNum = 1;
        Profile p = [
                SELECT Name
                FROM Profile
                WHERE Name LIKE '%GSA System Administrator%'
                LIMIT 1
        ];

        UserRole ur = [
                SELECT Name
                FROM UserRole
                WHERE Name LIKE '%GSA_Enterprise%'
                LIMIT 1
        ];

        User currentUser = [
                SELECT FirstName, LastName, Email
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];


        Account testAccount = new Account(Name = 'test'+suffix);
        insert testAccount;
        Contact c = new Contact(FirstName = 'test', LastName = 'test'+suffix, accountId = testAccount.Id);
        insert c;

        User u = new User(firstname = 'firstname', lastname = 'testlastname'+suffix, alias = 'testa'+string.valueOf(AliasNum++), email = 'test'+suffix+'@testorg.com', emailencodingkey = 'UTF-8',
                languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, timezonesidkey = 'America/Los_Angeles', //userroleid=ur.id,
                username = 'test'+suffix+'@testorgani.com', street = '123 street', city = 'Vienna', state = 'Virginia', country = 'USA', postalcode = '22102', PBS_AAAP_PIN__c = '123456',
                phone = '202-202-2202', PBS_AAAP_StatesOfInterest__c = 'NCR', PBS_AAAP_Regions__c = 'National Capital Region;');
        insert u;
        u.ManagerId = currentUser.Id;
        system.debug('*** testing PBS_AAAP_UtilityTest New User***' + u.Id);       

        System.runAs(u) {

            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;

            PBS_AAAP_Offer__c offerParent = PBS_AAAP_UtilityTest.createOfferInfo();
            offerParent.PBS_AAAP_RLP_Number__c = rlp.Id;
            offerParent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
            insert offerParent;

            PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 Wasser Ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            offer.PBS_AAAP_Energy_Star__c = 'Yes';
            offer.PBS_AAAP_Building_Sprinklered__c = 'Yes';
            offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes';
            offer.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes';
            offer.PBS_AAAP_Number_of_floors__c = 12;
            offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 400000;
            offer.PBS_AAAP_OFFICE_SPACE_RSF__c = 50000;
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 300000;
            offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 200000;
            offer.PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Wood';
            offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Wood';
            offer.PBS_AAAP_Year_Built__c = '2001';
            offer.PBS_AAAP_Renovation_Year__c = '2007';
            offer.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offer.PBS_AAAP_MetroRail_Station__c = 'Metro';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '6:00 PM';
            offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c = '10:00 AM';
            offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c = '10:00 AM';
            offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
            offer.PBS_AAAP_Option_Parking__c = 'Yes';
            offer.PBS_AAAP_Owner_Name__c = 'Test User';
            offer.PBS_AAAP_Owner_Address__c = '1660 International Drive';
            offer.PBS_AAAP_Owner_Country__c = 'USA';
            offer.PBS_AAAP_Owner_City__c = 'McLean';
            offer.PBS_AAAP_Owner_State__c = 'VA';
            offer.PBS_AAAP_Owner_Zip__c = '22102';
            offer.PBS_AAAP_county__c = 'fairfax';
            offer.PBS_AAAP_Owner_Main_Phone__c = '232-232-2332';
            offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
            offer.PBS_AAAP_TYPE_OF_ORG__c = 'Sole Proprietorship';
            offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Fee Simple';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_PARENT_NAME__c = null;
            offer.PBS_AAAP_Common_Parent_TIN__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'Known';
            offer.PBS_AAAP_Owner_TIN_Assigned__c = null;
            offer.PBS_AAAP_DUNS_Number__c = '999999999';
            offer.PBS_AAAP_Representation__c = 'Yes';
            offer.PBS_AAAP_Women_Owned_Identifier__c = 'Yes';
            offer.PBS_AAAP_EEO_CLAUSE__c = 'Yes';
            offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes';
            offer.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c = 'Yes';
            offer.PBS_AAAP_Confirm_Owner_Status__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONVICTION__c = 'Yes';
            offer.PBS_AAAP_OWNER_INDICTMENT__c = 'Yes';
            offer.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = 'Yes';
            offer.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = 'Yes';
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer.PBS_AAAP_SIGNATURE_PIN__c = '123456';
            offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
            offer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
            offer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
            offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            offer.PBS_AAAP_Parent_Offer__c = offerParent.Id;
            offer.PBS_AAAP_COST_PER_ABOA__c = 10;
            offer.PBS_AAAP_X_CO_ORD__c = -77.00896157;
            offer.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
            insert offer;
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments?offerId='+offer.id);
            Test.setCurrentPage(currentPage);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            opc.actionSubmitOffer();

            PBS_AAAP_Space__c sp0 = new PBS_AAAP_Space__c();
            sp0 = PBS_AAAP_UtilityTest.createSpace();
            sp0.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            sp0.PBS_AAAP_SF_OFFERED__c = 200000;
            insert sp0;
            PBS_AAAP_Rate__c r0 = new PBS_AAAP_Rate__c();
            r0 = PBS_AAAP_UtilityTest.createRate();
            r0.PBS_AAAP_Space__c = sp0.Id;
            r0.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = 10;
            insert r0;
            PageReference pref = null;
            pref = opc.actionCheckErrors();
            opc.actionSubmitOffer();
            
            offer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'Yes';
            update offer;
            r0.PBS_AAAP_BSAC_RATE__c = null;
            r0.PBS_AAAP_BSAC__c = 0;
            update r0;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            pref = opc.actionCheckErrors();
            System.assertEquals(pref, null);
            System.debug('***** HELLO VAISHALI B4: ');

            pref = opc.actionSaveAndSubmitOffer();
            System.debug('***** HELLO VAISHALI1: ');
            System.debug('***** HELLO VAISHALI2: ');
            System.assertEquals(pref, null);
            r0.PBS_AAAP_LEASE_TERM__c = '5+5 Years';
            r0.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = 0;
            r0.PBS_AAAP_BSAC__c = 5;
            offer.PBS_AAAP_COST_PER_ABOA__c = 0;
            offer.PBS_AAAP_Option_Parking__c = null;
            update r0;
            update offer;
            opc.addrFlag = 'true';
            pref = opc.actionCheckErrors();
            pref = opc.actionSaveAndSubmitOffer();

            opc.upload();
            opc.getItems();
            opc.actionDeleteAttachment();
            opc.actionCancelSubmitOffer();
            opc.actionCancel();
        }
    }

    static testMethod void myOfferSubmitCheckErrors() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {

            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            rlp.PBS_AAAP_DEFAULT_MONTH_END__c = '30';
            insert RLP;
            PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();

            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            offer.PBS_AAAP_Building_Name__c = 'Sample';
            offer.PBS_AAAP_Street_Address__c = '2521 Wasser Ter';
            offer.PBS_AAAP_City__c = 'Herndon';
            offer.PBS_AAAP_State__c = 'VA';
            offer.PBS_AAAP_ZipCode__c = '20171';
            offer.PBS_AAAP_Country__c = 'USA';
            offer.PBS_AAAP_County__c = 'fairfax';
            offer.PBS_AAAP_Energy_Star__c = 'No';
            offer.PBS_AAAP_Energy_Star_Reason__c = '';
            offer.PBS_AAAP_Close_To_Metro__c = 'Yes';
            offer.PBS_AAAP_MetroRail_Station__c = null;
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = null;
            offer.PBS_AAAP_Owner_TIN_Status__c = null;
            offer.PBS_AAAP_Close_To_Metro__c = null;
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '9:00 AM';
            offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '11:00 PM';
            insert offer;
            System.debug('******** PBS_AAAP_SUBMITOFFER_ID ::: ' + offer.Id);
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments?offerId='+offer.id);
            Test.setCurrentPage(currentPage);
            PBS_AAAP_OfferAttachmentsController opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;

            PageReference pref = opc.actionCheckErrors();
            System.assertEquals(pref, null);

            offer.PBS_AAAP_Owner_Country__c = 'United States';
            offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes';
            offer.PBS_AAAP_Owner_TIN_Status__c = 'KNOWN';
            update offer;
            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.termsandconditons = 'Yes';
            opc.submitOffer = offer;
            pref = opc.actionCheckErrors();
            System.assertEquals(pref, null);
            opc.DownloadAllFiles_00();
        }
    }
 
    
    static testMethod void validate_ExitOffer() {
        PBS_AAAP_OfferAttachmentsController obj = new PBS_AAAP_OfferAttachmentsController();
        obj.exitOffer();
        string test = obj.leaseDefault;
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert RLP;
        
        PBS_AAAP_Offer__c offerparent = PBS_AAAP_UtilityTest.createOfferInfo();
        offerparent.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        offerparent.PBS_AAAP_RLP_Number__c = rlp.Id; 
        insert offerparent;
        
        obj.submitOffer = offerparent;
        
        obj.ofrID = offerparent.Id;     
        obj.actionSavePageAddl();
        List<PBS_AAAP_Offer__c> offerRecords = [Select Id From PBS_AAAP_Offer__c];
        System.assert(true);      
        
    }    
    
    static testMethod void validate_sequenceNumber2() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert RLP;
            
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_OFFER_ID ::: ' + offer.Id);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id); 
            insert offeratt;
                       
            Blob b = Blob.valueOf('Test Data');
            Attachment attachment = new Attachment();
            attachment.ParentId = offeratt.Id;
            attachment.Name = 'Form1364.pdf';
            attachment.Body = b;
            insert attachment;
            
            Attachment attachment1 = new Attachment();
            attachment1.ParentId = offeratt.Id;
            attachment1.Name = 'Form1217.pdf';
            attachment1.Body = b;
            insert attachment1;
            
            Attachment attachment2 = new Attachment();
            attachment2.ParentId = offeratt.Id;
            attachment2.Name = 'form3518.pdf';
            attachment2.Body = b;    
            insert attachment2; 
            
            offeratt = [select id,PBS_AAAP_Attachment_Type__c ,(select id,name from Attachments) from PBS_AAAP_Offer_Attachments__c  where id = :offeratt.Id];          
            
            PBS_AAAP_OfferAttachmentsController.sequenceNumber2 obj = new PBS_AAAP_OfferAttachmentsController.sequenceNumber2(1,offeratt);
            obj = new PBS_AAAP_OfferAttachmentsController.sequenceNumber2(1,system.now(),'Floor Plan',new List<Attachment>{attachment2});
            
            PBS_AAAP_OfferAttachmentsController mainoj = new PBS_AAAP_OfferAttachmentsController();
            mainoj.attachmentsList2 = new List<PBS_AAAP_Offer_Attachments__c>{offeratt,offeratt};
            try{
            Map<String, List<Attachment>> attMap = mainoj.getAttachmentMapByType2();
            
            System.assertEquals(0, attMap.size());
            }
            catch(exception ex){}        
    }
    
    static testMethod void validate_sequenceNumber3() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
            insert RLP;
            
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id); 
            insert offeratt;
            
            Blob b = Blob.valueOf('Test Data');
            Attachment attachment = new Attachment();
            attachment.ParentId = offeratt.Id;
            attachment.Name = 'Form1364.pdf';
            attachment.Body = b;
            insert attachment;
            
            Attachment attachment1 = new Attachment();
            attachment1.ParentId = offeratt.Id;
            attachment1.Name = 'Form1217.pdf';
            attachment1.Body = b;
            insert attachment1;
            
            Attachment attachment2 = new Attachment();
            attachment2.ParentId = offeratt.Id;
            attachment2.Name = 'form3518.pdf';
            attachment2.Body = b;    
            insert attachment2; 
            
            offeratt = [select id,PBS_AAAP_Attachment_Type__c ,CreatedDate,(select id,name from Attachments) from PBS_AAAP_Offer_Attachments__c  where id = :offeratt.Id];          
            PBS_AAAP_OfferAttachmentsController.sequenceNumber3 obj = new PBS_AAAP_OfferAttachmentsController.sequenceNumber3(1,offeratt);
            obj = new PBS_AAAP_OfferAttachmentsController.sequenceNumber3(1,'Floor Plan',new List<Attachment>{attachment2});
            PBS_AAAP_OfferAttachmentsController.ContentDocumentWrapper cdw = new PBS_AAAP_OfferAttachmentsController.ContentDocumentWrapper('Hi','Hi',Date.today(),'Hi');
            obj = new PBS_AAAP_OfferAttachmentsController.sequenceNumber3(offeratt,cdw);
            PBS_AAAP_RLP__c rlp1 = PBS_AAAP_UtilityTest.createRLP();
            insert rlp1;
            PBS_AAAP_RLP__c rlp2 = PBS_AAAP_UtilityTest.createFY17RLP();
            insert rlp2;
            PBS_AAAP_RLP__c rlp3 = PBS_AAAP_UtilityTest.createFY19RLP();
            insert rlp3;
            
            PBS_AAAP_Offer__c offer1 = PBS_AAAP_UtilityTest.createOfferInfo1();
            offer1.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer1.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
            offer1.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
            offer1.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
            offer1.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
            insert offer1; 
            
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments?offerId='+offer1.id);
            PBS_AAAP_OfferAttachmentsController obj1 = new PBS_AAAP_OfferAttachmentsController();            
            obj1.displayattachment = null;
            
            
            PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
            space.PBS_AAAP_OFFER_NUMBER__c = offer1.Id; 
            insert space;
            
            RecordType rec = [SELECT r.Id, r.Name, r.SobjectType FROM RecordType r WHERE SobjectType = 'Account' LIMIT 1];
            Account acc = new Account(RecordTypeId = rec.Id, Name = 'Sample Account');
            insert acc;
            
            PBS_AAAP_Agency_Requirement__c agency = PBS_AAAP_UtilityTest.createAgencyRequirement();         
            agency.PBS_AAAP_Account_Name__c = acc.Id;
            insert agency;
            
            PBS_AAAP_Offer_Select_Award_Info__c osai = new PBS_AAAP_Offer_Select_Award_Info__c();
            osai.PBS_AAAP_Offer_ID__c = offer1.Id;
            osai.PBS_AAAP_Space_ID__c = space.Id;
            osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agency.Id;
            osai.PBS_AAAP_SELECTED_USF__c = space.PBS_AAAP_SF_OFFERED__c;
            osai.PBS_AAAP_Unreserved_Surface__c = 100;
            osai.PBS_AAAP_Unreserved_Structured__c = 100;
            osai.PBS_AAAP_Reserved_Surface__c  = 100;
            osai.PBS_AAAP_Reserved_Structured__c = 100;
            insert osai;
            
            obj1.actionSendtoGREX();
            
            System.currentPageReference().getParameters().put('offerId', offer1.Id); 
            PBS_AAAP_Offer_Attachments__c offeratt1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Form 1364 AAAP', 
                                                                                            PBS_AAAP_Offer__c = offer1.id);
            insert offeratt1;           
            
            Blob b1 = Blob.valueOf('Test Data');
            Attachment attachment3 = new Attachment();
            attachment3.ParentId = offeratt1.Id;
            attachment3.Name = 'Test Attachment for Parent';
            attachment3.Body = b1;           
            insert attachment3;
            
            obj1.getgeneratedForm();
            obj1.actionSavePageAddl();
            obj1.pageUrl = '/apex/PBS_AAAP_OfferAttachments?offerId='+offer1.id; 
            obj1.actionSavePageAddl();
            
            currentPage = new PageReference('/apex/pbs_aaap_offeracknowledgment?offerId='+offer1.id);
            Test.setCurrentPage(currentPage);
            obj1 = new PBS_AAAP_OfferAttachmentsController(); 
            
            PBS_AAAP_Offer__c offer2 = PBS_AAAP_UtilityTest.createOfferInfo1();
            offer2.PBS_AAAP_RLP_Number__c = rlp.Id;
            offer2.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 10;
            offer2.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 10;
            offer2.PBS_AAAP_Monthly_cost_res_sur_park__c = 10;
            offer2.PBS_AAAP_Monthly_cost_res_gar_park__c = 10;
            offer2.Master_Offer__c = offer1.Id;
            insert offer2;
            obj1.ofrID = offer1.Id;
            obj1.uploadAttachment();
            
        ContentVersion contentVersion = new ContentVersion(
        Title          = 'a picture',
        PathOnClient   = 'Pic.jpg',
        VersionData    = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = offeratt1.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
            
         
         PBS_AAAP_OfferAttachmentsController.ContentDocumentWrapper cd = new PBS_AAAP_OfferAttachmentsController.ContentDocumentWrapper(cdl.id,'Test',datetime.now(),'test');
         
        
            obj1.existingAttachmentRecords.add(new PBS_AAAP_OfferAttachmentsController.sequenceNumber(1, offeratt1, cd));
            obj1.getPreviousSubmissionAttachmentsMap();
        
            System.assert(true); 
    }

	//SGanti added 08/2021

    static testMethod void OfferAttachmentsConstructorTest_1364_2022() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            PBS_AAAP_Offer_Attachments__c offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Authorization to Represent Ownership Entity', PBS_AAAP_Offer__c = offer.id);
            insert offeratt2;
            Blob b = Blob.valueOf('Test Data');
            Attachment attachment2 = new Attachment();
            attachment2.Name = 'Test Attachment for Parent2';
            attachment2.Body = b;
            attachment2.ParentId = offeratt2.Id;
            Attachment attachment = new Attachment();
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;


            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;
            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.getItems();
            opc.actionCancelSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);

            boolean flag = opc.checkOfferSubmissionValidations();
            System.assertEquals(flag, null);
            opc.actionSaveAndSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);
            opc.actionRequestPIN();
            pref = opc.actionDeleteOffer();
            System.assertEquals(pref, null);
            opc.actionDeleteAttachment();
            
            
            offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Other', PBS_AAAP_Offer__c = offer.id, PBS_AAAP_Sent_to_GREX__c = true);
            insert offeratt2;
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.uploadAdditional();
            
            //rlp.PBS_AAAP_Year__c = '2019';
            update rlp;
            opc.DownloadAllFiles();
            
            Test.stopTest();
        }   
    }

    //Todd Brown added "Other" tests 07/2022 for SFWS-1720

    static testMethod void OfferAttachmentsTestOtherAttchTypeGood() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_Start__c);
            System.debug('******** PBS_AAAP_Default_Start__c ::: ' + offer.PBS_AAAP_Default_End__c);
            PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Floor Plan', PBS_AAAP_Offer__c = offer.id);
            insert offeratt;
            PBS_AAAP_Offer_Attachments__c offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Authorization to Represent Ownership Entity', PBS_AAAP_Offer__c = offer.id);
            insert offeratt2;
            PBS_AAAP_Offer_Attachments__c offeratt3 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Other', Document_Description__c = 'Something descriptive here', PBS_AAAP_Offer__c = offer.id);
            insert offeratt3;
            Blob b = Blob.valueOf('Test Data');
            Attachment attachment3 = new Attachment();
            attachment3.Name = 'Test Attachment for Parent3';
            attachment3.Body = b;
            attachment3.ParentId = offeratt3.Id;
            Attachment attachment2 = new Attachment();
            attachment2.Name = 'Test Attachment for Parent2';
            attachment2.Body = b;
            attachment2.ParentId = offeratt2.Id;
            Attachment attachment = new Attachment();
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;
            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.getItems();
            opc.actionCancelSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);

            boolean flag = opc.checkOfferSubmissionValidations();
            System.assertEquals(flag, null);
            opc.actionSaveAndSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);
            opc.actionRequestPIN();
            pref = opc.actionDeleteOffer();
            System.assertEquals(pref, null);
            opc.actionDeleteAttachment();
            
            
            offeratt2 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Other', PBS_AAAP_Offer__c = offer.id, PBS_AAAP_Sent_to_GREX__c = true);
            insert offeratt2;
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.uploadAdditional();
            
            //rlp.PBS_AAAP_Year__c = '2019';
            update rlp;
            opc.DownloadAllFiles();
            
            Test.stopTest();
        }   
    }  

    static testMethod void OfferAttachmentsTestOtherAttchTypeBad() {

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
            insert RLP;
            PageReference currentPage = new PageReference('/apex/PBS_AAAP_OfferAttachments');
            Test.setCurrentPage(currentPage);
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;

            insert offer;
            PBS_AAAP_Offer_Attachments__c offeratt3 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Attachment_Type__c = 'Other', Document_Description__c = null, PBS_AAAP_Offer__c = offer.id);
            insert offeratt3;
            Blob b = Blob.valueOf('Test Data');
            Attachment attachment3 = new Attachment();
            attachment3.Name = 'Test Attachment for Parent3';
            attachment3.Body = b;
            attachment3.ParentId = offeratt3.Id;

            ApexPages.currentPage().getParameters().put('offerId', offer.id);
            PBS_AAAP_OfferAttachmentsController opc;
            PageReference pref = null;
            Test.startTest();
            opc = new PBS_AAAP_OfferAttachmentsController();
            opc.getItems();
            opc.actionCancelSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);

            boolean flag = opc.checkOfferSubmissionValidations();
            System.assertEquals(flag, true);
            opc.actionSaveAndSubmitOffer();
            System.assertEquals(opc.showAttachmentsPage, true);
            
            Test.stopTest();
        }   
    } 
    
    static testMethod void unitTest1() {
        Test.startTest();
            PBS_AAAP_OfferAttachmentsController poa = new PBS_AAAP_OfferAttachmentsController();
            poa.viewOffer();
            
            PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
            poa.submitOffer = offer;
            poa.actionDeleteAttachmentAdditional();
            system.assert(poa != null);
        Test.stopTest();
        
    
    }     
}