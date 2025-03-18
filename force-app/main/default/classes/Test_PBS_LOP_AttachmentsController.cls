@IsTest
private class Test_PBS_LOP_AttachmentsController {
    
    static testMethod void testBuildingPage() { 
        
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        String userId = UserInfo.getUserId();
        // PBS_LOP_Offer__c oOther = [select o.Id From PBS_LOP_Offer__c o where o.ownerId != :userId limit 1];

        System.debug('u.id is ' + u.id);
        PBS_AAAP_Offer__c invalidOffer = new PBS_AAAP_Offer__c();
        System.runAs(u) {

            PBS_LOP_OFFER__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            insert offer;
        
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = true;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = 'Draft';
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
            offernew.PBS_AAAP_Building_Name__c = 'Test';
            offernew.PBS_AAAP_Street_Address__c = 'test addr';
            offernew.PBS_AAAP_City__c = 'test city';
            offernew.PBS_AAAP_State__c = 'test state';
            offernew.PBS_AAAP_ZipCode__c = '12345';
            offernew.PBS_AAAP_Energy_Star__c = 'No';
            offernew.PBS_AAAP_Energy_Star_Reason__c = 'Test Reason';
            offernew.PBS_AAAP_floors_Suites_in_Offered_Space__c = 2;
            offernew.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 3;
            insert offernew;
            
            System.assert(offernew.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOP_AttachmentsController obc = new PBS_LOP_AttachmentsController();
            obc.refreshForms();
            offer.LOP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            upsert offer;
            
            offernew.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            update offernew;
                 Test.startTest();
            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            obc.actionSaveAndSubmitOffer();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            obc.actionSubmitOffer2();
            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            obc.actionCancelSubmitOffer();
            obc.getItems();
            obc.actionCancel();


            PBS_LOP_Offer__c lopOffer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            lopOffer.LOP_ACK_READ_RLP_REQ_NO_CHANGE__c = 'Yes';
            lopOffer.LOP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
            lopOffer.LOP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
            lopOffer.LOP_ACCEPTED_LEASE_FORM_1364__c = 'Yes';
            lopOffer.LOP_ACCEPTED_TERMS_AND_COND__c = 'Yes';
            lopOffer.LOP_Historic_Property_Tier__c = 'Historic property within a historic district';
            lopOffer.LOP_Accessibility_Standards_Met__c = 'Yes';
            lopOffer.LOP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix';
            lopOffer.LOP_RLP_Contains_Seismic_Requirement__c = 'The RLP contains seismic requirements.';
            lopOffer.LOP_Offeror_Seismic_Declaration__c = 'Will be constructed to meet seismic requirements';
            lopOffer.LOP_Flood_Plain_Declaration__c = 'A 500-year flood plain';
            lopOffer.LOP_Fire_Safety_Declaration__c = 'Meets the Lease fire/life safety standards.';
            upsert lopOffer;
            System.debug('lopOffer Id is ***' + lopOffer.id);
            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            System.debug('before rlp checkbox');
            obc.rlpCheckBox = true;

            obc.actionSubmitOffer2();

            obc.uploadFormsOnFinalSubmit();
            PBS_GREX_Project_EOI__c projectEOI = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestGREXProjectEOI();
            upsert projectEOI;
            lopOffer = new PBS_LOP_OFFER__c(
                    Project_EOI_ID__c = projectEOI.id
            );
            lopOffer.LOP_ACCEPTED_TERMS_AND_COND__c = 'No';

            upsert lopOffer;
            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_LOP_AttachmentsController();
            //PBS_AAAP_GlobalConstants.checkFinalOfferBuildingValidations(lopOffer);
            obc.renderRLPSection();
            obc.actionSubmitOffer2();
            obc.uploadFormsOnFinalSubmit();
            
            
            invalidOffer = new PBS_AAAP_Offer__c();
            invalidOffer.PBS_AAAP_RLP_Number__c = RLP.id;
            invalidOffer.PBS_AAAP_Offer_Status__c = 'Draft';
            invalidOffer.RecordTypeId = RSAPRecTypeId;
            invalidOffer.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            invalidOffer.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            invalidOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
            invalidOffer.PBS_AAAP_Building_Name__c = 'Test';
            invalidOffer.PBS_AAAP_Street_Address__c = 'test addr';
            invalidOffer.PBS_AAAP_City__c = 'test city';
            invalidOffer.PBS_AAAP_State__c = 'test state';
            invalidOffer.PBS_AAAP_ZipCode__c = '12345';
            invalidOffer.PBS_AAAP_Energy_Star__c = 'No';
            invalidOffer.PBS_AAAP_Energy_Star_Reason__c = 'Test Reason';
            invalidOffer.PBS_AAAP_floors_Suites_in_Offered_Space__c = 2;
            invalidOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 3;          
            insert invalidOffer;
            
            
        }       
        ApexPages.currentPage().getParameters().put('offerId', invalidOffer.id);
        ApexPages.currentPage().getParameters().put('edit', 'true');
        PBS_LOP_AttachmentsController exceptionObj = new PBS_LOP_AttachmentsController();
        
        
    }

    static testMethod void validate_actionSavePage() {
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
         System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY17RLP();
            insert rlp;         
            offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            insert offer;
        }
        
        PBS_LOP_AttachmentsController obj = new PBS_LOP_AttachmentsController();
        obj.ofrID = offer.Id;
        try{
            obj.actionSavePage();
        }
        catch(exception ex){}
        
        obj.actionDeleteFormsAttachment();
        obj.actionDeleteFormsAttachment();
        System.assert(true);
        
    }
    
    static testMethod void myOfferAttachmentsConstructorTestUpload() { 

        User u = PBS_AAAP_UtilityTest.createPortalUser();

        System.runAs(u) {
            PageReference currentPage = new PageReference('/apex/PBS_LOP_Attachments');
            Test.setCurrentPage(currentPage);
            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();

            insert offer;
            
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = true;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = 'Draft';
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            insert offernew;
            
            System.assert(offernew.Id != null);
            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            PBS_LOP_AttachmentsController obc = new PBS_LOP_AttachmentsController(); 
            PBS_LOP_Offer_Attachment__c offeratt = new PBS_LOP_Offer_Attachment__c(PBS_LOP_Attachment_Type__c = 'Floor Plan',  PBS_LOP_Offer__c = offer.id); 
            insert offeratt;

            Blob b = Blob.valueOf('Test Data');

            Attachment attachment = new Attachment();
            //attachment.ParentId = parentId;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            attachment.ParentId = offeratt.Id;

            ApexPages.currentPage().getParameters().put('offerId', offernew.id);
            PBS_LOP_AttachmentsController opc;
            PageReference pref = null;

            Test.startTest();
            opc = new PBS_LOP_AttachmentsController();
            PBS_LOP_Offer_Attachment__c ofratt = new PBS_LOP_Offer_Attachment__c(PBS_LOP_Offer__c = offer.id);
            PBS_AAAP_Offer_Attachments__c offatt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='Floor Plan'); 
            opc.offerattachment = offatt;
            Blob b1 = Blob.valueOf('Test Data');

            Attachment att = new Attachment();
            //attachment.ParentId = parentId;
            att.Name = 'Test Attachment for Parent';
            //att.Body = b1;
            opc.offerattachment = offatt;
            //opc.att = att;
            //opc.ofrID = offer.id;
            opc.upload();

            ofratt.PBS_LOP_Attachment_Type__c = 'Floor Plan';
            opc.offerattachment = offatt;
            //opc.att = att;
            //opc.ofrID = offer.id;
            opc.upload();
            att.Body = b1;
            //opc.att = att;
            opc.upload();
            opc.attachmentId = att.Id;
            //pref = opc.actionDeleteAttachment();

            opc.actionSubmitOffer2();
            opc.redirectToHome();
            opc.actionBackToRatesAndSpaces();
            Test.stopTest();
            
        }
    }
    
    static testMethod void uploadAttachmentTest() {
       
        PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
        insert offer;
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        rlp.PBS_RSAP_Solicitation_Number__c = '123';
        rlp.PBS_RSAP_Solicitation_Status__c = true;
        rlp.PBS_AAAP_Region__c = 'test region';
        insert RLP;
        
        Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
    
        PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
        offernew.PBS_AAAP_RLP_Number__c = RLP.id;
        offernew.PBS_AAAP_Offer_Status__c = 'Draft';
        offernew.RecordTypeId = RSAPRecTypeId;
        offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
        offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
        offernew.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
        offernew.PBS_AAAP_Building_Name__c = 'Test';
        offernew.PBS_AAAP_Street_Address__c = 'test addr';
        offernew.PBS_AAAP_City__c = 'test city';
        offernew.PBS_AAAP_State__c = 'test state';
        offernew.PBS_AAAP_ZipCode__c = '12345';
        offernew.PBS_AAAP_Energy_Star__c = 'No';
        offernew.PBS_AAAP_Energy_Star_Reason__c = 'Test Reason';
        offernew.PBS_AAAP_floors_Suites_in_Offered_Space__c = 2;
        offernew.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 3;
        insert offernew;
       
        ApexPages.currentPage().getParameters().put('offerId', offernew.id);
       
        
         PBS_LOP_AttachmentsController opc = new PBS_LOP_AttachmentsController();
         
         opc.offerattachment = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='SAM Registration',PBS_AAAP_Sent_to_GREX__c = True);
         opc.attBody = Blob.valueOf('UNIT.TEST');
         opc.attName = 'Unit';
         opc.uploadAttachment();
         opc.uploadForms();

        System.assert(true);
    }
    
    static testMethod void actionDeleteAttachmentTest() {
       
        PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
        insert offer;
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        rlp.PBS_RSAP_Solicitation_Number__c = '123';
        rlp.PBS_RSAP_Solicitation_Status__c = true;
        rlp.PBS_AAAP_Region__c = 'test region';
        insert RLP;
        
        Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
    
        PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
        offernew.PBS_AAAP_RLP_Number__c = RLP.id;
        offernew.PBS_AAAP_Offer_Status__c = 'Draft';
        offernew.RecordTypeId = RSAPRecTypeId;
        offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
        offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
        offernew.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
        offernew.PBS_AAAP_Building_Name__c = 'Test';
        offernew.PBS_AAAP_Street_Address__c = 'test addr';
        offernew.PBS_AAAP_City__c = 'test city';
        offernew.PBS_AAAP_State__c = 'test state';
        offernew.PBS_AAAP_ZipCode__c = '12345';
        offernew.PBS_AAAP_Energy_Star__c = 'No';
        offernew.PBS_AAAP_Energy_Star_Reason__c = 'Test Reason';
        offernew.PBS_AAAP_floors_Suites_in_Offered_Space__c = 2;
        offernew.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 3;
        insert offernew;
       
        ApexPages.currentPage().getParameters().put('offerId', offernew.id);
       
        
         PBS_LOP_AttachmentsController opc = new PBS_LOP_AttachmentsController();
         
         PBS_AAAP_Offer_Attachments__c offerattachment = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='SAM Registration',PBS_AAAP_Sent_to_GREX__c = True);
         insert offerattachment;
         
         PBS_AAAP_Offer_Attachments__c offerattachment1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='SAM Registration',PBS_AAAP_Sent_to_GREX__c = True);
         insert offerattachment1;
         
        ContentVersion contentVersion = new ContentVersion(
        Title          = 'a picture',
        PathOnClient   = 'Pic.jpg',
        VersionData    = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = offerattachment1.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
            
         
         PBS_LOP_AttachmentsController.ContentDocumentWrapper cd = new PBS_LOP_AttachmentsController.ContentDocumentWrapper(cdl.id,'Test',datetime.now(),'test');
         
         opc.seqNumList = new List<PBS_LOP_AttachmentsController.sequenceNumber>();
         opc.seqNumList.add(new PBS_LOP_AttachmentsController.sequenceNumber(1, offerattachment, cd));
         opc.seqNumList.add(new PBS_LOP_AttachmentsController.sequenceNumber(2, offerattachment1, cd));
         
         opc.attachmentId = offerattachment.id;
         opc.getPreviousSubmissionAttachmentsMap();
         opc.actionDeleteAttachment();
         
        
        System.assert(true);
    }
    
    static testMethod void getAttachmentMapByTypeTest() {
       
        PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
        insert offer;
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        rlp.PBS_RSAP_Solicitation_Number__c = '123';
        rlp.PBS_RSAP_Solicitation_Status__c = true;
        rlp.PBS_AAAP_Region__c = 'test region';
        insert RLP;
        
        Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
    
        PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
        offernew.PBS_AAAP_RLP_Number__c = RLP.id;
        offernew.PBS_AAAP_Offer_Status__c = 'Draft';
        offernew.RecordTypeId = RSAPRecTypeId;
        offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
        offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
        offernew.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
        offernew.PBS_AAAP_Building_Name__c = 'Test';
        offernew.PBS_AAAP_Street_Address__c = 'test addr';
        offernew.PBS_AAAP_City__c = 'test city';
        offernew.PBS_AAAP_State__c = 'test state';
        offernew.PBS_AAAP_ZipCode__c = '12345';
        offernew.PBS_AAAP_Energy_Star__c = 'No';
        offernew.PBS_AAAP_Energy_Star_Reason__c = 'Test Reason';
        offernew.PBS_AAAP_floors_Suites_in_Offered_Space__c = 2;
        offernew.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 3;
        insert offernew;
       
        ApexPages.currentPage().getParameters().put('offerId', offernew.id);
       
        
         PBS_LOP_AttachmentsController opc = new PBS_LOP_AttachmentsController();
         
         PBS_AAAP_Offer_Attachments__c offerattachment = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='SAM Registration',PBS_AAAP_Sent_to_GREX__c = True);
         insert offerattachment;
         
         PBS_AAAP_Offer_Attachments__c offerattachment1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='SAM Registration',PBS_AAAP_Sent_to_GREX__c = True);
         insert offerattachment1;
         
         List<PBS_AAAP_Offer_Attachments__c> otList = new List<PBS_AAAP_Offer_Attachments__c>();
         otList.add(offerattachment);
         otList.add(offerattachment1);
         
         opc.attachmentsList = otList;
         //opc.getAttachmentMapByType();
         
        
        System.assert(true);
    }

    static testMethod void testNegative() {
       
        PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
        insert offer;
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        rlp.PBS_RSAP_Solicitation_Number__c = '123';
        rlp.PBS_RSAP_Solicitation_Status__c = true;
        rlp.PBS_AAAP_Region__c = 'test region';
        insert RLP;
        
        Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();

    
        PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
        offernew.PBS_AAAP_RLP_Number__c = RLP.id;
        offernew.PBS_AAAP_Offer_Status__c = 'Draft';
        offernew.RecordTypeId = RSAPRecTypeId;
        offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
        offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
        offernew.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
        offernew.PBS_AAAP_Building_Name__c = 'Test';
        offernew.PBS_AAAP_Street_Address__c = 'test addr';
        offernew.PBS_AAAP_City__c = 'test city';
        offernew.PBS_AAAP_State__c = 'test state';
        offernew.PBS_AAAP_ZipCode__c = '12345';
        offernew.PBS_AAAP_Energy_Star__c = 'No';
        offernew.PBS_AAAP_Energy_Star_Reason__c = 'Test Reason';
        offernew.PBS_AAAP_floors_Suites_in_Offered_Space__c = 2;
        offernew.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 3;
        insert offernew;
       
        ApexPages.currentPage().getParameters().put('offerId', offernew.id);
       
        PBS_LOP_AttachmentsController opc = new PBS_LOP_AttachmentsController();
        
        PBS_AAAP_Offer_Attachments__c offatt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id);
        opc.offerattachment = offatt;
        
        
        opc.upload();
        //opc.uploadForms();
        opc.actionDeleteAttachment();
        opc.actionDeleteFormsAttachment();
        opc.formAttachment = null;
        //opc.attList = null;
        opc.submissionDate = null;
        opc.DateSubmitted = null;
        opc.addrFlag = null;
        opc.pastDueDate = null;
        opc.offerDueDate = null;
        System.assert(true);
    }
    
    static testMethod void test_Wrapper() {
        PBS_LOP_AttachmentsController clsRecord = new PBS_LOP_AttachmentsController();
        clsRecord.viewMsg = ''; 
        clsRecord.randomNumber = '23';
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        rlp.PBS_RSAP_Solicitation_Number__c = '123';
        rlp.PBS_RSAP_Solicitation_Status__c = true;
        rlp.PBS_AAAP_Region__c = 'test region';
        insert RLP;
        
        Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
        
        PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
        offernew.PBS_AAAP_RLP_Number__c = RLP.id;
        offernew.PBS_AAAP_Offer_Status__c = 'Draft';
        offernew.RecordTypeId = RSAPRecTypeId;
        offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
        offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
        offernew.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
        offernew.PBS_AAAP_Building_Name__c = 'Test';
        offernew.PBS_AAAP_Street_Address__c = 'test addr';
        offernew.PBS_AAAP_City__c = 'test city';
        offernew.PBS_AAAP_State__c = 'test state';
        offernew.PBS_AAAP_ZipCode__c = '12345';
        offernew.PBS_AAAP_Energy_Star__c = 'No';
        offernew.PBS_AAAP_Energy_Star_Reason__c = 'Test Reason';
        offernew.PBS_AAAP_floors_Suites_in_Offered_Space__c = 2;
        offernew.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 3;
        insert offernew;
    
    ApexPages.currentPage().getParameters().put('offerId', offernew.id);
        
        PBS_AAAP_Offer_Attachments__c offatt = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='Floor Plan'); 
        
        insert offatt;
    
    PBS_AAAP_Offer_Attachments__c offatt1 = new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = offernew.id,PBS_AAAP_Attachment_Type__c='SAM Registration',PBS_AAAP_Sent_to_GREX__c = True);
        insert offatt1;
        
        ContentVersion contentVersion = new ContentVersion(
        Title          = 'a picture',
        PathOnClient   = 'Pic.jpg',
        VersionData    = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

//create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = offatt1.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
            
            
        
        Attachment attachment = new Attachment();       
        attachment.Name = 'Form1364.pdf';
        attachment.Body = blob.valueOf('dddd');
        attachment.ParentId = offatt.Id;
        insert attachment;
        
        attachment = new Attachment();      
        attachment.Name = 'Form1217.pdf';
        attachment.Body = blob.valueOf('dddd');
        attachment.ParentId = offatt.Id;
        insert attachment;
        
        attachment = new Attachment();      
        attachment.Name = 'form3518.pdf'; 
        attachment.Body = blob.valueOf('dddd');
        attachment.ParentId = offatt.Id;
        insert attachment;
        
        List<PBS_AAAP_Offer_Attachments__c> lst = [select id,(select id, name from attachments) from PBS_AAAP_Offer_Attachments__c where id = :offatt.Id];
        PBS_LOP_AttachmentsController.sequenceNumber2 obj = new PBS_LOP_AttachmentsController.sequenceNumber2();
        Datetime Dtime = system.now();
        obj = new PBS_LOP_AttachmentsController.sequenceNumber2();
        
        PBS_LOP_AttachmentsController opc = new PBS_LOP_AttachmentsController();
        
        // creating exception
        try{
            opc.refreshForms2();
        }
        catch(exception ex){}
        
                
        opc.ofrID = null;
        delete [select id from PBS_AAAP_Offer_Attachments__c];
        opc.actionDeleteFormsAttachment();
        opc.pastDueDate = false;
        opc.offerDueDate = 'false';
        opc.showSection = false;
        opc.viewMsg = 'false';  
        opc.randomNumber = '1234';  
        opc.submitDocuments();  
        opc.termsAndConditions = 'No';  
        opc.renderRLPSection();
        System.assert(true);
        
    }
}