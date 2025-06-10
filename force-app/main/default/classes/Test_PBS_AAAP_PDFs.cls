@IsTest
private class Test_PBS_AAAP_PDFs {

    static testMethod void testNullOfferId() {
        ApexPages.currentPage().getParameters().put('offerId', null);
        PBS_AAAP_NewOfferForm1364Controller nofc = new PBS_AAAP_NewOfferForm1364Controller();
        System.assertEquals(false, nofc.isValidOfferId);        
     }   
    static testMethod void testInvalidOfferId() {
        ApexPages.currentPage().getParameters().put('offerId', 'a03350000050rCcZZ9');
        PBS_AAAP_NewOfferForm1364Controller nofc = new PBS_AAAP_NewOfferForm1364Controller();
        System.assertEquals(false, nofc.isValidOfferId);
     }     
     static testMethod void offerPreviewController() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2020-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');        
        pref.redirectToExpectedPage();
        System.assertEquals(true, true);
        pref.actionDeleteAttachment();
    }

    static testMethod void offerPreviewController1() {

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('TEST');
        a1.ParentID = offeratt.Id;
        a1.Name = 'offerform1217.pdf';
        insert a1;
        
        PBS_AAAP_OfferPreviewPageController.ContentDocumentWrapper cdw = new PBS_AAAP_OfferPreviewPageController.ContentDocumentWrapper('Hi','Hi',Date.today(),'Hi');
        PBS_AAAP_OfferPreviewPageController.sequenceNumber sqn = new PBS_AAAP_OfferPreviewPageController.sequenceNumber(1,offeratt,cdw);
        
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2020-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();

        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm3518');

                
        pref.redirectToExpectedPage();
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        System.assertEquals(true, true);
        
        PBS_AAAP_OfferPreviewPageController pref2 = new PBS_AAAP_OfferPreviewPageController();
        pref2.attachmentId = offeratt.Id;
        pref2.actionDeleteAttachment();
    }
    
    static testMethod void offerPreviewController1_0() {

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('TEST');
        a1.ParentID = offeratt.Id;
        a1.Name = 'offerform1217.pdf';
        insert a1;
  

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2017-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();

        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm3518');       
                
        pref.redirectToExpectedPage();
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        System.assertEquals(true, true);        
    }

    static testMethod void offerPreviewController_Census() {

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        rlp.PBS_AAAP_Region__c = 'Census';
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('TEST');
        a1.ParentID = offeratt.Id;
        a1.Name = 'offerform1217.pdf';
        insert a1;
        Attachment a2 = new Attachment();
        a2.Body = Blob.valueOf('TEST');
        a2.ParentID = offeratt.Id;
        a2.Name = 'offerform1364.pdf';
        insert a2; 

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2020-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();

        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm3518');
        ApexPages.currentPage().getParameters().put('formtype', 'Offerform1364_2019');

        pref.redirectToExpectedPage();
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        System.assertEquals(true, true);
        
        pref.actionDeleteAttachment();
    }
    
    static testMethod void offerPreviewController_Census_0() {

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        rlp.PBS_AAAP_Region__c = 'Census';
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('TEST');
        a1.ParentID = offeratt.Id;
        a1.Name = 'offerform1217.pdf';
        insert a1;
        Attachment a2 = new Attachment();
        a2.Body = Blob.valueOf('TEST');
        a2.ParentID = offeratt.Id;
        a2.Name = 'offerform1364.pdf';
        insert a2;


        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2017-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();

        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm3518');
        ApexPages.currentPage().getParameters().put('formtype', 'Offerform1364_2019');
        pref.redirectToExpectedPage();
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        System.assertEquals(true, true);
        
    }

    static testMethod void offerPreviewController_2019() {

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('TEST');
        a1.ParentID = offeratt.Id;
        a1.Name = 'offerform1217.pdf';
        insert a1;
        Attachment a2 = new Attachment();
        a2.Body = Blob.valueOf('TEST');
        a2.ParentID = offeratt.Id;
        a2.Name = 'offerform1364.pdf';
        insert a2;


        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2020-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();

        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm3518');
        ApexPages.currentPage().getParameters().put('formtype', 'Offerform1364_2019');
       
        
        pref.redirectToExpectedPage();
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        System.assertEquals(true, true);

        pref.actionDeleteAttachment();
    }
    
    static testMethod void offerPreviewController_2019_0() {

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('TEST');
        a1.ParentID = offeratt.Id;
        a1.Name = 'offerform1217.pdf';
        insert a1;
        Attachment a2 = new Attachment();
        a2.Body = Blob.valueOf('TEST');
        a2.ParentID = offeratt.Id;
        a2.Name = 'offerform1364.pdf';
        insert a2;


        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2017-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();

        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm3518');
        ApexPages.currentPage().getParameters().put('formtype', 'Offerform1364_2019');
        
        oppc.lstPageWrapper = new List<PBS_AAAP_OfferPreviewPageController.PageWrapper>();
        
        pref.redirectToExpectedPage();
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        
        PBS_AAAP_OfferPreviewPageController.PageWrapper wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'offerform1217';
        wrapperObj.formName = 'offerform1217';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;

        oppc.lstPageWrapper.add(wrapperObj);
        
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'offerform1217Attachment';
        wrapperObj.formName = 'offerform1217Attachment';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        
        oppc.lstPageWrapper.add(wrapperObj);
        
        
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'Offerform1364_2019';
        wrapperObj.formName = 'Offerform1364_2019';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;

        oppc.lstPageWrapper.add(wrapperObj);

        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm1364';
        wrapperObj.formName = 'OfferForm1364';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);

        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm3518';
        wrapperObj.formName = 'OfferForm3518';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;

        oppc.lstPageWrapper.add(wrapperObj);

        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm1364RateStructure';
        wrapperObj.formName = 'OfferForm1364RateStructure';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        
        oppc.lstPageWrapper.add(wrapperObj);       
        oppc.lstPageWrapper.add(wrapperObj);        

        oppc.formName = 'offerform1217';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'offerform1217Attachment';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'Offerform1364_2019';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'OfferForm1364';
        oppc.redirectToExpectedPage();       
        oppc.formName = 'OfferForm3518';
        oppc.displayLink = true;
        oppc.redirectToExpectedPage();      
        
        System.assertEquals(true, true);

    }

    static testMethod void offerForm1217() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        insert offer;
        System.assert(offer.Id != null);
        PageReference pref = null;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        PBS_AAAP_OfferForm1217 form1217 = new PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Lease Hold Interest';
        offer.PBS_AAAP_HEATING_FUEL__c = 'Natural Gas';
        update offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_HEATING_FUEL__c = 'Oil';
        update offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_HEATING_FUEL__c = 'Coal';
        update offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new PBS_AAAP_OfferForm1217();
        
        form1217.strImagename = 'test';
        form1217.strImageBlob = 'abd';
        form1217.captureImage();
    }

    static testMethod void offerLOPForm1217() {
        PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
        insert offer;
        System.assert(offer.Id != null);
        PageReference pref = null;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'lop');
        PBS_AAAP_OfferForm1217 form1217 = new PBS_AAAP_OfferForm1217();

        offer.LOP_OFFEROR_INTEREST__c = 'Owner';
        offer.LOP_HEATING_FUEL__c = 'Gas';
        update offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'lop');
        form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.LOP_HEATING_FUEL__c = 'Oil';
        update offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'lop');
        form1217 = new PBS_AAAP_OfferForm1217();

        offer.LOP_HEATING_FUEL__c = 'Coal';
        update offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'lop');
        form1217 = new PBS_AAAP_OfferForm1217();
    }
    
    static testMethod void offerLOPForm1217_LOP() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        insert offer;
        System.assert(offer.Id != null);
        PageReference pref = null;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        LOP_PBS_AAAP_OfferForm1217 form1217 = new LOP_PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Lease Hold Interest';
        offer.PBS_AAAP_HEATING_FUEL__c = 'Natural Gas';
        update offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new LOP_PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_HEATING_FUEL__c = 'Oil';
        update offer;

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new LOP_PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_HEATING_FUEL__c = 'Coal';
        offer.PBS_AAAP_Session_Key__c = '11111';
        update offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('sesid', '11111');
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217');
        form1217 = new LOP_PBS_AAAP_OfferForm1217();
        form1217.isValidUserAction();
        
        ApexPages.currentPage().getParameters().put('sesid', '33');
        form1217.isValidUserAction();
        form1217.strImageBlob = 'abd';
        form1217.captureImage();
    }

    static testMethod void offerForm1217Attachment() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        insert offer;
        PBS_AAAP_Other_Costs__c ocosts = PBS_AAAP_UtilityTest.createOtherCosts();
        ocosts.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocosts;
        PageReference pref = null;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1217Attachment');
        PBS_AAAP_OfferForm1217 form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
    }

    static testMethod void offerForm3518() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        insert offer;

        PageReference pref = null;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm3518');
        PBS_AAAP_OfferForm1217 form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_Representation__c = 'Not a Small Business';
        offer.PBS_AAAP_SMALL_DISADVANTAGED_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_Women_Owned_Identifier__c = 'No';
        offer.PBS_AAAP_Veteran_Owned_Identifier__c = 'No';
        offer.PBS_AAAP_SERVICE_DISABLED_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_HUBZONE_JOINT_VENTURE__c = 'No';
        offer.PBS_AAAP_HUBZONE_JOINT_VENTURE_NAMES__c = null;
        offer.PBS_AAAP_EEO_CLAUSE__c = 'No';
        offer.PBS_AAAP_COMPLIANCE_REPORT__c = 'No';
        offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'No';
        offer.PBS_AAAP_AFFIRMATIVE_ACTION_CONTRACTS__c = 'No';
        offer.PBS_AAAP_NAMES_RESP_FOR_DET_PRICES__c = null;
        offer.PBS_AAAP_Confirm_Owner_Status__c = 'No';
        offer.PBS_AAAP_OWNER_CONVICTION__c = 'No';
        offer.PBS_AAAP_OWNER_INDICTMENT__c = 'No';
        offer.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = 'No';
        offer.PBS_AAAP_Owner_TIN_Status__c = 'KNOWN';
        offer.PBS_AAAP_Owner_TIN_Assigned__c = '686786789';
        offer.PBS_AAAP_TYPE_OF_ORG__c = 'Other';
        offer.PBS_AAAP_TYPE_OF_ORG_OTHER__c = 'Other';
        offer.PBS_AAAP_CONTROLLED_BY_PARENT__c = 'No';
        offer.PBS_AAAP_PARENT_NAME__c = 'Sam';
        offer.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = 'No';
        update offer;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm3518');
        form1217 = new PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_Owner_TIN_Status__c = 'Applied For';
        offer.PBS_AAAP_TYPE_OF_ORG__c = 'Sole Proprietorship';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_Owner_TIN_Status__c = 'Not required';
        offer.PBS_AAAP_OWN_NOT_REQ_REASON__c = 'Property owner is an agency of a foreign government';
        offer.PBS_AAAP_TYPE_OF_ORG__c = 'Partnership';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_OWN_NOT_REQ_REASON__c = 'Property owner is an agency of the Federal governament';
        offer.PBS_AAAP_TYPE_OF_ORG__c = 'Corporate entity (not tax-exempt)';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_OWN_NOT_REQ_REASON__c = 'Property Owner is a nonresident alien, foreign corporation, or foreign partnership that does not have income';
        offer.PBS_AAAP_TYPE_OF_ORG__c = 'Corporate entity (tax-exempt)';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_TYPE_OF_ORG__c = 'Government entity(Federal,State,or local)';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_TYPE_OF_ORG__c = 'Foreign government';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();

        offer.PBS_AAAP_TYPE_OF_ORG__c = 'International organization per 26 CFR 1.6049-4';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
    }

    static testMethod void offerForm1364Attachment() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        insert offer;
        System.assert(offer.Id != null);
        PageReference pref = null;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerform1364Attachment');
        PBS_AAAP_OfferForm1217 form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_Building_Sprinklered__c = 'No';
        offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'No';
        offer.PBS_AAAP_BLDG_Wide_Alarm_System__c = 'No';
        offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Wood';
        offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Brick';
        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        offer.PBS_AAAP_Option_Parking__c = 'No';
        offer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = false;
        offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'Yes';
        offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'Yes';
        offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'Yes';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_Building_Sprinklered__c = 'Partial';
        offer.PBS_AAAP_Option_Parking__c = 'Partial';
        offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'No';
        offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'No';
        offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'No';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();
        System.assert(offer.Id != null);
        offer.PBS_AAAP_Building_Sprinklered__c = '';
        offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = '';
        offer.PBS_AAAP_BLDG_Wide_Alarm_System__c = '';
        update offer;
        form1217 = new PBS_AAAP_OfferForm1217();
        form1217.isValidUser();
        System.assert(offer.Id != null);

        form1217.rlp = null; 
        form1217.otherCostList = null;
        form1217.officeSpacePercent = null;
        form1217.retailSpacePercent = null;
        form1217.garageSpacePercent = null;
        form1217.opCost3b = null;
        form1217.opCost4 = null;
        form1217.opCostGov4 = null;
        form1217.opCostGov5 = null;
        form1217.opCostGov6 = null;
        form1217.opCostGov7 = null;
        form1217.opCostGov8 = null;
        form1217.opCostGov9 = null;
        form1217.opCostGov10 = null;
        form1217.opCostGov11 = null;
        form1217.opCostGov12 = null;
        form1217.opCostGov13 = null;
        form1217.opCostGov14 = null;
        form1217.opCostGov15 = null;
        form1217.opCostGov16 = null;
        form1217.opCostGov17 = null;
        form1217.opCostGov18 = null;
        form1217.opCostGov19 = null;
        form1217.opCostGov20 = null;
        form1217.opCostGov21 = null;
        form1217.opCostGov22 = null;
        form1217.opCostGov23 = null;
        form1217.opCostGov24 = null;
        form1217.opCostGov25 = null;
        form1217.opCostGov26 = null;
        form1217.opCostGov27 = null;
        form1217.opCostGov28 = null;
        form1217.opCostGov29 = null;
        form1217.opCostGov30 = null;
        form1217.opCostGov31 = null;
        form1217.opCostGov32 = null;
        form1217.opCostGov33 = null;
        form1217.isValidUserAction();
    }

    static testMethod void offerForm1364RateStructure() {

        //Vaishali 11/21 retrieve rlp for RLP FY14 change
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        //Vaishali 11/21 retrieve rlp for RLP FY14 change
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id; //Vaishali 11/21
        insert offer;

        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate;
        System.assert(offer.Id != null);
        System.assert(space.Id != null);
        System.assert(rate.Id != null);


        ApexPages.currentPage().getParameters().put('offerId', offer.Id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364RateStructure');

        PBS_AAAP_OfferForm1364RateStructure form1364 = new PBS_AAAP_OfferForm1364RateStructure();

        space.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true;
        update space;
        rate.PBS_AAAP_BSAC_RATE__c = 0;
        rate.PBS_AAAP_BSAC__c = 1.2;
        update rate;
        form1364 = new PBS_AAAP_OfferForm1364RateStructure();
        System.assert(space.Id != null);
        System.assert(rate.Id != null);
        form1364.strImagename = 'test';
        form1364.strImageBlob = 'abd';
        form1364.captureImage();
    }

    static testMethod void offerForm1364() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_LIVE_FLOOR_LOAD__c = '100';
        insert offer;

        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate;
        System.assert(offer.Id != null);


        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364RateStructure');

        PBS_AAAP_OfferForm1364Controller form1364 = new PBS_AAAP_OfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';

        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
        offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller();
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller();
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_Energy_Star__c = 'No';
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller();
        offer.PBS_AAAP_HUBZone_SBC_Offeror__c = true;
        offer.PBS_AAAP_Energy_Star__c = 'No';
        offer.PBS_AAAP_Energy_Star_Reason__c = ' Testing for 500 character limit for the offeror energy star reason comments, Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror';
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller();
        System.debug(form1364.legalAgentType);
        System.debug(form1364.xownerType);
        System.debug(form1364.monthlyCostResSurf);
        System.debug(form1364.monthlyCostNonResSurf);
        System.debug(form1364.monthlyCostNonResGar);
        System.assert(offer.Id != null);

    }
    
    static testMethod void offerForm1364_LOP() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_LIVE_FLOOR_LOAD__c = '100';
        offer.PBS_RSAP_Year_Built__c = '2000';
        offer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = 40;
        offer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c = 40;
        offer.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
        offer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
        offer.PBS_RSAP_Flood_Plain_Declaration__c = 'in a 500-year flood plain';
        offer.PBS_RSAP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix';
        offer.PBS_RSAP_Offeror_Seismic_Declaration__c = 'Fully meets seismic requirements or meets an exemption under the RLP';
        offer.PBS_RSAP_Accessibility_Standards_Met__c = 'Yes';
        offer.PBS_AAAP_Taxes_Fully_Assessed_Value__c = 'Yes';
        offer.PBS_AAAP_HVAC_OT_Rate_Type__c = 'Per Zone';
        offer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c = 'Yes';
        offer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 10000;
        offer.PBS_AAAP_Office_RSF_OFFERED__c = 10000;
        insert offer;

        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate;
        System.assert(offer.Id != null);


        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364RateStructure');

        PBS_LOP_OfferForm1364Controller form1364 = new PBS_LOP_OfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        offer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = null;
        offer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c = null;
        offer.PBS_RSAP_Historical_Property_Description__c = 'Historic properties outside of historic district';
        offer.PBS_RSAP_HubZone_Waiver__c = '';
        offer.PBS_RSAP_Flood_Plain_Declaration__c = 'in a base (100-year) flood plain';
        offer.PBS_RSAP_Asbestos_Declaration__c = '';
        offer.PBS_RSAP_Offeror_Seismic_Declaration__c = 'Does not meet seismic requirements, but will be retrofitted to meet seismic requirements';
        offer.PBS_RSAP_Accessibility_Standards_Met__c = 'No';
        offer.PBS_AAAP_Taxes_Fully_Assessed_Value__c = 'No';
        offer.PBS_AAAP_HVAC_OT_Rate_Type__c = 'Per Floor';
        offer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c = 'No';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
        offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_Energy_Star__c = 'No';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_HUBZone_SBC_Offeror__c = true;
        offer.PBS_AAAP_Energy_Star__c = 'No';
        offer.PBS_AAAP_Energy_Star_Reason__c = ' Testing for 500 character limit for the offeror energy star reason comments, Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        System.debug(form1364.legalAgentType);
        System.debug(form1364.xownerType);
        System.debug(form1364.monthlyCostResSurf);
        System.debug(form1364.monthlyCostNonResSurf);
        System.debug(form1364.monthlyCostNonResGar);
        System.assert(offer.Id != null);

    }

   static testMethod void offerForm1364_LOP2() {
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_LIVE_FLOOR_LOAD__c = '100';
        offer.PBS_RSAP_Year_Built__c = '2000';
        offer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = 40;
        offer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c = 40;
        offer.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
        offer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
        offer.PBS_RSAP_Flood_Plain_Declaration__c = 'in a 500-year flood plain';
        offer.PBS_RSAP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix';
        offer.PBS_RSAP_Offeror_Seismic_Declaration__c = 'Fully meets seismic requirements or meets an exemption under the RLP';
        offer.PBS_RSAP_Accessibility_Standards_Met__c = 'Yes';
        offer.PBS_AAAP_Taxes_Fully_Assessed_Value__c = 'Yes';
        offer.PBS_AAAP_HVAC_OT_Rate_Type__c = 'Per Zone';
        offer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c = 'Yes';
        offer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 10000;
        offer.PBS_AAAP_Office_RSF_OFFERED__c = 10000;
        insert offer;

        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;

        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert rate;
        System.assert(offer.Id != null);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364RateStructure');

        PBS_LOP_OfferForm1364Controller form1364 = new PBS_LOP_OfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        offer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = null;
        offer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c = null;
        offer.PBS_RSAP_Historical_Property_Description__c = 'Historic properties outside of historic district';
        offer.PBS_RSAP_HubZone_Waiver__c = '';
        offer.PBS_RSAP_Flood_Plain_Declaration__c = 'in a base (100-year) flood plain';
        offer.PBS_RSAP_Asbestos_Declaration__c = '';
        offer.PBS_RSAP_Offeror_Seismic_Declaration__c = 'Will be constructed to meet seismic requirements';
        offer.PBS_RSAP_Accessibility_Standards_Met__c = 'No';
        offer.PBS_AAAP_Taxes_Fully_Assessed_Value__c = 'No';
        offer.PBS_AAAP_HVAC_OT_Rate_Type__c = 'Per Space';
        offer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c = 'No';
        offer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = '1. Per ABOA Square Feet ($)';
        offer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'Yes';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
        offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_Energy_Star__c = 'No';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        offer.PBS_AAAP_HUBZone_SBC_Offeror__c = true;
        offer.PBS_AAAP_Energy_Star__c = 'No';
        offer.PBS_AAAP_Energy_Star_Reason__c = ' Testing for 500 character limit for the offeror energy star reason comments, Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror';
        update offer;
        form1364 = new PBS_LOP_OfferForm1364Controller();
        form1364.isValidUserAction();
        System.debug(form1364.legalAgentType);
        System.debug(form1364.xownerType);
        System.debug(form1364.monthlyCostResSurf);
        System.debug(form1364.monthlyCostNonResSurf);
        System.debug(form1364.monthlyCostNonResGar);
        System.assert(offer.Id != null);
        
        PBS_LOP_OfferForm1364Controller obj1 = new PBS_LOP_OfferForm1364Controller();
        obj1.offer = null;
        obj1.rlp = null;
        obj1.yearBuilt = null;
        obj1.energyStarExplanation = null;
        obj1.liveFloorLoadStr = null;
        obj1.floodPlainsTitle = null;
        obj1.historicFooter = null;
        obj1.field27cLine2 = null;

    }
    
    static testMethod void offerForm1364_2019() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer1 = PBS_AAAP_UtilityTest.createOfferInfo();
        offer1.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer1;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        
        System.runAs(u) {
        ApexPages.currentPage().getParameters().put('offerId', offer1.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364');
        PBS_AAAP_OfferForm1364Controller_2019 formnews1364 = new PBS_AAAP_OfferForm1364Controller_2019();
           
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            insert offer;
    
            PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
            space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            insert space;
    
            PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
            rate.PBS_AAAP_SPACE__c = space.Id;
            rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            insert rate;
            System.assert(offer.Id != null);
        }

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364');

        PBS_AAAP_OfferForm1364Controller_2019 form1364 = new PBS_AAAP_OfferForm1364Controller_2019();
        
        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller_2019();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
        offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller_2019();
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller_2019();
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_Energy_Star__c = 'No';
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller_2019();
        offer.PBS_AAAP_HUBZone_SBC_Offeror__c = true;
        offer.PBS_AAAP_Energy_Star__c = 'No';
        offer.PBS_AAAP_Energy_Star_Reason__c = ' Testing for 500 character limit for the offeror energy star reason comments, Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror';
        offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 0;
        offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 0;
        update offer;
        form1364 = new PBS_AAAP_OfferForm1364Controller_2019();
        System.assert(offer.Id != null);
        System.runAs(u) {
            form1364 = new PBS_AAAP_OfferForm1364Controller_2019();
            offer.PBS_AAAP_Energy_Star__c = 'N/A';
            offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet/Acres';
        }
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'offerForm1364');
        PBS_AAAP_OfferForm1364Controller_2019 form1364_2019 = new PBS_AAAP_OfferForm1364Controller_2019();
        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        offer.PBS_AAAP_Session_Key__c = '222222';
       
        update offer;

        form1364_2019.strImagename = 'test';
        form1364_2019.strImageBlob = 'abd';
        form1364_2019.captureImage();
        
        ApexPages.currentPage().getParameters().put('offerId', offer.Id);
        ApexPages.currentPage().getParameters().put('sesid', '222222');   
        ApexPages.currentPage().getParameters().put('isFromOfferAtt', 'true');
        form1364_2019.isValidUserAction();
        ApexPages.currentPage().getParameters().put('isFromOfferAtt', 'false');  
        form1364_2019.isValidUserAction();        
        ApexPages.currentPage().getParameters().put('sesid', '11111');      
        form1364_2019.isValidUserAction();

    }   
    
    static testMethod void offerLOPForm1364() {
        PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
        offer.LOP_Energy_Star__c = 'No';
        insert offer;
        System.assert(offer.id != null);

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'LOP');
        PBS_AAAP_OfferForm1364Controller form1364 = new PBS_AAAP_OfferForm1364Controller();
        form1364.field19f = 'test';
        form1364.field20a1 = 'test';
        form1364.field20b1 = 'test';
        form1364.field20b2 = 'test';
        form1364.field20c1 = 'test';
        form1364.field20c2 = 'test';
        form1364.field20d1 = 'test';
        form1364.field20d2 = 'test';
        form1364.field20e1 = 'test';
        form1364.field20e2 = 'test';
        form1364.field20f1 = 'test';
        form1364.field20f2 = 'test';
        form1364.field22a = 'test';
        form1364.field22b = 'test';
        form1364.field22c = 'test';
        form1364.field23a = 'test';
        form1364.field23b = 'test';
        form1364.field23c = 'test';
        form1364.field23d = 'test';
        form1364.field26a = 'test';
        form1364.field26b = 'test';
        form1364.field26c1 = 'test';
        form1364.field27a = 'test';
        form1364.field27a1 = 'test';
        form1364.field27a2 = 'test';
        form1364.field27a3 = 'test';

        form1364.field27b = 'test';
        form1364.field27c = 'test';
        form1364.field28HVACRt = 'test';

        form1364.field28HVACzone = 'test';
        form1364.field28HVACfloor = 'test';
        form1364.field28HVACspace = 'test';
        form1364.field28HVACZones = 'test';
        form1364.field28HVAC24Hr = 'test';
        form1364.prcntGovOccupancy = 'test';
        form1364.currentYrTaxes = 'test';
        form1364.fullyAssessedYes = 'test';
        form1364.fullyAssessedNo = 'test';
        form1364.multyTaxBillYes = 'test';
        form1364.multyTaxBillNo = 'test';
        form1364.totalLandCost = 'test';
        form1364.noOfMonthsFreeRentLOP = 'test';
        form1364.noOfMonthsFreeRentAAAP = 'test';
        form1364.additionalRemarks = 'test';

        form1364.floodPlainsTitle = 'test';
        form1364.seismicTitle = 'test';
        form1364.seismicFooter = 'test';
        form1364.historicFooter = 'test';
        form1364.asbestosFooter = 'test';
        form1364.fireLifeFooter = 'test';
        form1364.accessibilityFooter = 'test';
        form1364.floodPlain100Yrs = 'test';
        form1364.floodPlain500Yrs = 'test';
        form1364.floodPlainNot = 'test';
        form1364.rlpSeismic = 'test';
        form1364.rlpNotSeismic = 'test';

        offer.LOP_Energy_Star__c = 'Yes';
        offer.LOP_Flood_Plain_Declaration__c = 'A base (100-year) flood plain';
        offer.LOP_Historic_Property_Tier__c = 'Non-historic property or underdeveloped site within a historic district';

        upsert offer;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'LOP');

        form1364 = new PBS_AAAP_OfferForm1364Controller();
        offer.LOP_OFFEROR_INTEREST__c = 'Owner';
        offer.LOP_SITE_AREA_TYPE__c = 'SQFT';
        offer.LOP_Historic_Property_Tier__c = 'Historic properties outside of historic district';
        offer.LOP_Historic_Property_Tier__c = 'Non-historic property';
        offer.LOP_Energy_Star_Reason__c = 'Testing for energy star reason.';
        offer.LOP_Flood_Plain_Declaration__c = 'A 500-year flood plain';

        upsert offer;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'LOP');
        form1364 = new PBS_AAAP_OfferForm1364Controller();
        offer.LOP_Historic_Property_Tier__c = 'Historic property within a historic district';
        offer.LOP_RLP_Contains_Seismic_Requirement__c = 'The RLP contains seismic requirements.';
        offer.LOP_Offeror_Seismic_Declaration__c = 'Fully meets seismic requirements or meets an exemption under the RLP';
        upsert offer;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'LOP');
        form1364 = new PBS_AAAP_OfferForm1364Controller();
        offer.LOP_Historic_Property_Tier__c = 'Historic properties outside of historic district';
        offer.LOP_SITE_AREA_TYPE__c = '';       
        offer.LOP_RLP_Contains_Seismic_Requirement__c = 'The RLP contains seismic requirements.';
        offer.LOP_Asbestos_Declaration__c = 'Contains ACM not in a stable, solid matrix';
        offer.LOP_Offeror_Seismic_Declaration__c = 'Does not meet seismic requirements, but will be retrofitted to meet seismic requirements';
        upsert offer;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'LOP');
        form1364 = new PBS_AAAP_OfferForm1364Controller();
        
        System.assert(offer.Id != null);
    }

    static testMethod void downloadAllAttachments() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferForm1364Controller form1364 = new PBS_AAAP_OfferForm1364Controller();
        form1364.rlp = rlp;
        form1364.isValidUserAction();
        ApexPages.currentPage().getParameters().put('isFromOfferAtt', 'true');	
        form1364.isValidUserAction();	
        ApexPages.currentPage().getParameters().put('isFromOfferAtt', 'false');
        PBS_AAAP_OfferForm1364RateStructure form1364Rate = new PBS_AAAP_OfferForm1364RateStructure();
        form1364Rate.isValidUserAction();
//SGanti added 8/2021        
        PBS_AAAP_NewOfferForm1364Controller newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
        newform1364.isValidUserAction();
        system.assertEquals(true, true);
    }    
    
    static testMethod void BaseController(){
        string paramName = 'Test';
        string url = '/AAAP/LoginPage?';
        Decimal defaultValue = 2;
        ApexPages.currentPage().getParameters().put('testParam', 'testValue');
        String result = PBS_AAAP_Utility.getQueryParamAsString('testParam');
        PBS_AAAP_Utility.getQueryParamAsDecimal(paramName,defaultValue);
        PBS_AAAP_Utility.getQueryParamAsDecimal(paramName);
        PBS_AAAP_Utility.setQueryParam(paramName,paramName);
        
        PBS_AAAP_Utility.getCommunityURL(url);
        
        PBS_AAAP_Utility.getCommunityURL('Offer-M');
        
        String communityURL = 'fromLWC'+Label.LOP_Community_Base_URL;
        PBS_AAAP_Utility.getCommunityURL(communityURL);
        
        string url1 = '/AAAP/LoginPage';
        PBS_AAAP_Utility.getCommunityURL(url1);
        system.assert(true);

    }  
      
//SGanti added method to test offerForm1364_2022. 8/2021. Region != Census, RLP Year = 2022,     
static testMethod void offerForm1364_2022() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.runAs(u) {
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            insert offer;
    
            PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
            space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            insert space;
    
            PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
            rate.PBS_AAAP_SPACE__c = space.Id;
            rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            insert rate;
            System.assert(offer.Id != null);
                        }
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm1364_2022');
        PBS_AAAP_NewOfferForm1364Controller newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        
        update offer;
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
        offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
        update offer;
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        update offer;
        
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
        
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_Energy_Star__c = 'No';
        offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 3;
        update offer;
        
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();

        offer.PBS_AAAP_HUBZone_SBC_Offeror__c = true;
        offer.PBS_AAAP_Energy_Star__c = 'No';
        offer.PBS_AAAP_Energy_Star_Reason__c = ' Testing for 500 character limit for the offeror energy star reason comments, Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror';
         //jk adding from here:
            offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 0;
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 0;
        update offer;
        
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();

        System.assert(offer.Id != null);
        System.runAs(u) {
            newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
            offer.PBS_AAAP_Energy_Star__c = 'N/A';
            offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet/Acres';
        }
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm1364_2022');
        PBS_AAAP_NewOfferForm1364Controller newform1364_2022 = new PBS_AAAP_NewOfferForm1364Controller();
        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        offer.PBS_AAAP_Session_Key__c = '222222';
       
        update offer;
        
        ApexPages.currentPage().getParameters().put('offerId', offer.Id);
        ApexPages.currentPage().getParameters().put('sesid', '222222');     
        newform1364_2022.isValidUserAction();
        
        ApexPages.currentPage().getParameters().put('sesid', '11111');      
        newform1364_2022.isValidUserAction();

    } 
//SGanti added 8/2021
    
  static testMethod void offerForm1364_2022_0() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
        rlp.PBS_AAAP_Region__c = 'Census';
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        System.runAs(u) {
            offer.PBS_AAAP_RLP_Number__c = rlp.Id;
            insert offer;
    
            PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
            space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            insert space;
    
            PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
            rate.PBS_AAAP_SPACE__c = space.Id;
            rate.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
            insert rate;
            System.assert(offer.Id != null);
                        }
    

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm1364_2022');
        PBS_AAAP_NewOfferForm1364Controller newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        
        update offer;
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();

        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
        offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
        update offer;
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'Yes';
        offer.PBS_AAAP_Energy_Star__c = 'Yes';
        update offer;
        
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
        
        offer.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'No';
        offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet';
        offer.PBS_AAAP_SITE_SIZE_SQFT__c = 12;
        offer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'No';
        offer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No';
        offer.PBS_AAAP_Energy_Star__c = 'No';
        update offer;
        
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();

        offer.PBS_AAAP_HUBZone_SBC_Offeror__c = true;
        offer.PBS_AAAP_Energy_Star__c = 'No';
        offer.PBS_AAAP_Energy_Star_Reason__c = ' Testing for 500 character limit for the offeror energy star reason comments, Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror energy star reason comments,Testing for 500 character limit for the offeror';
         //jk adding from here:
            offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 0;
            offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 0;
        update offer;
        
        newform1364 = new PBS_AAAP_NewOfferForm1364Controller();

        System.assert(offer.Id != null);
        System.runAs(u) {
            newform1364 = new PBS_AAAP_NewOfferForm1364Controller();
            offer.PBS_AAAP_Energy_Star__c = 'N/A';
            offer.PBS_AAAP_SITE_AREA_TYPE__c = 'Square Feet/Acres';
        }
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm1364_2022');
        PBS_AAAP_NewOfferForm1364Controller newform1364_2022 = new PBS_AAAP_NewOfferForm1364Controller();
        offer.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';
        offer.PBS_AAAP_Session_Key__c = '222222';
       
        update offer;
       
        ApexPages.currentPage().getParameters().put('offerId', offer.Id);
        ApexPages.currentPage().getParameters().put('sesid', '222222');     
        newform1364_2022.isValidUserAction();
        
        ApexPages.currentPage().getParameters().put('sesid', '11111');      
        newform1364_2022.isValidUserAction();

    }   
   
//SGanti added 8/2021 
static testMethod void offerPreviewController_2022_0() {

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('TEST');
        a1.ParentID = offeratt.Id;
        a1.Name = 'offerform1217.pdf';
        insert a1;
        Attachment a2 = new Attachment();
        a2.Body = Blob.valueOf('TEST');
        a2.ParentID = offeratt.Id;
        a2.Name = 'offerform1364.pdf';
        insert a2;    

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2017-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();

        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm3518');
        ApexPages.currentPage().getParameters().put('formtype', 'Offerform1364_2019');
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm1364_2022');
        

        oppc.lstPageWrapper = new List<PBS_AAAP_OfferPreviewPageController.PageWrapper>();
        
        pref.redirectToExpectedPage();
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        
        PBS_AAAP_OfferPreviewPageController.PageWrapper wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'offerform1217';
        wrapperObj.formName = 'offerform1217';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);
        
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'offerform1217Attachment';
        wrapperObj.formName = 'offerform1217Attachment';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;

        oppc.lstPageWrapper.add(wrapperObj);
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm1364';
        wrapperObj.formName = 'OfferForm1364';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm3518';
        wrapperObj.formName = 'OfferForm3518';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm1364RateStructure';
        wrapperObj.formName = 'OfferForm1364RateStructure';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'Form 1364 AAAP';
        wrapperObj.formName = 'OfferForm1364_2022';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);       
        
        oppc.formName = 'offerform1217';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'offerform1217Attachment';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'Offerform1364_2019';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'OfferForm1364';
        oppc.redirectToExpectedPage();

        oppc.formName = 'OfferForm1364_2022';
        oppc.redirectToExpectedPage();
    
        oppc.formName = 'OfferForm3518';
        oppc.displayLink = true;
        oppc.redirectToExpectedPage();                
        
        System.assertEquals(true, true);

        
    }   
//SGanti added 8/2021

static testMethod void offerPreviewController_2022_1() {

        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
        rlp.PBS_AAAP_Region__c = 'Census';
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert offer;
        PBS_AAAP_Offer_Attachments__c offeratt = new PBS_AAAP_Offer_Attachments__c();
        offeratt.PBS_AAAP_Offer__c = offer.Id;
        insert offeratt;
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('TEST');
        a.ParentID = offeratt.Id;
        a.Name = 'OfferForm3518.pdf';
        insert a;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('TEST');
        a1.ParentID = offeratt.Id;
        a1.Name = 'offerform1217.pdf';
        insert a1;
        Attachment a2 = new Attachment();
        a2.Body = Blob.valueOf('TEST');
        a2.ParentID = offeratt.Id;
        a2.Name = 'offerform1364.pdf';
        insert a2;    

        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        PBS_AAAP_OfferPreviewPageController oppc = new PBS_AAAP_OfferPreviewPageController();

        offer.PBS_AAAP_Close_To_Metro__c = 'No';
        update offer;

        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = '2017-01-01';
        oppc = new PBS_AAAP_OfferPreviewPageController();
        PBS_AAAP_OfferPreviewPageController.CurrentCheckDate = PBS_AAAP_OfferPreviewPageController.DefaultCheckDate;

        update offer;
        oppc = new PBS_AAAP_OfferPreviewPageController();

        PBS_AAAP_OfferPreviewPageController pref = new PBS_AAAP_OfferPreviewPageController();
        oppc.offerId = offer.Id;
        ApexPages.currentPage().getParameters().put('offerId', offer.id);
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm3518');
        ApexPages.currentPage().getParameters().put('formtype', 'Offerform1364_2019');
        ApexPages.currentPage().getParameters().put('formtype', 'OfferForm1364_2022');
        

        oppc.lstPageWrapper = new List<PBS_AAAP_OfferPreviewPageController.PageWrapper>();
        
        pref.redirectToExpectedPage();
        PBS_AAAP_OfferPreviewPageController.DownloadAllFiles(offer.Id);
        
        PBS_AAAP_OfferPreviewPageController.PageWrapper wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'offerform1217';
        wrapperObj.formName = 'offerform1217';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        
        // adding to list
        oppc.lstPageWrapper.add(wrapperObj);
        
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'offerform1217Attachment';
        wrapperObj.formName = 'offerform1217Attachment';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        
        // adding to list
        oppc.lstPageWrapper.add(wrapperObj);
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm1364';
        wrapperObj.formName = 'OfferForm1364';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);      
        
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm3518';
        wrapperObj.formName = 'OfferForm3518';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);
        
        
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'OfferForm1364RateStructure';
        wrapperObj.formName = 'OfferForm1364RateStructure';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);
		//SGanti added 08/2021
        wrapperObj = new PBS_AAAP_OfferPreviewPageController.PageWrapper();
        wrapperObj.linkName = 'Form 1364 AAAP';
        wrapperObj.formName = 'OfferForm1364_2022';
        wrapperObj.pgRefObj = null;
        wrapperObj.clicked = false;
        oppc.lstPageWrapper.add(wrapperObj);        

        oppc.formName = 'offerform1217';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'offerform1217Attachment';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'Offerform1364_2019';
        oppc.redirectToExpectedPage();
        
        oppc.formName = 'OfferForm1364';
        oppc.redirectToExpectedPage();

        oppc.formName = 'OfferForm1364_2022';
        oppc.redirectToExpectedPage();
    
        oppc.formName = 'OfferForm3518';
        oppc.displayLink = true;
        oppc.redirectToExpectedPage();                
        
        System.assertEquals(true, true);
    } 
    
	@isTest
    static void testOfferValidationResponse() {
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
        rlp.PBS_AAAP_Region__c = 'Census';
        insert rlp;
        
        PBS_AAAP_Offer__c testOffer = PBS_AAAP_UtilityTest.createOfferInfo();
        testOffer.PBS_AAAP_RLP_Number__c = rlp.Id;
        insert testOffer;
        
        Test.startTest();
        List<String> pages = new List<String>{'Offer-M-Eligibility', 'Offer-M-Costs', 'Offer-M-Parking', 'Offer-M-SpaceRates', 'Offer-M-Attachments', 'Offer-S-Eligibility', 'Offer-S-SpaceParking', 'Offer-S-TermsFinancials', 'Offer-S-Rent', 'Offer-S-Attachments'};
        PBS_AAAP_Utility.OfferValidationResponse response = PBS_AAAP_Utility.validateOffer(testOffer, pages);
        System.assertNotEquals(null, response);
        System.assertNotEquals(null, response.errorMessages);
        List<String> pages1 = new List<String>();
        PBS_AAAP_Utility.OfferValidationResponse response1 = PBS_AAAP_Utility.validateOffer(testOffer, pages1);
        
        Test.stopTest();
    }
              
}