@IsTest
public class Test_PBS_AAAP_PortalHomeController {

    static testMethod void myportalHomeTest() {
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        PBS_AAAP_OfferHelper.triggerupdate(true);

        system.debug('offer address::: ' + offer.PBS_AAAP_Street_Address__c + ' state::: ' + offer.PBS_AAAP_State__c + ' city::: ' + offer.PBS_AAAP_City__c + ' Zip::: ' + offer.PBS_AAAP_ZipCode__c + ' county ::: ' + offer.PBS_AAAP_County__c);
        system.debug('offer Country::: ' + offer.PBS_AAAP_Country__c);
        insert offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);

        PBS_AAAP_Space__c space = PBS_AAAP_UtilityTest.createSpace();
        space.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert space;
        PBS_AAAP_Rate__c rate = PBS_AAAP_UtilityTest.createRate();
        rate.PBS_AAAP_SPACE__c = space.Id;
        insert rate;
        PBS_AAAP_Other_Costs__c ocost = PBS_AAAP_UtilityTest.createOtherCosts();
        ocost.PBS_AAAP_OFFER_NUMBER__c = offer.Id;
        insert ocost;
        PBS_AAAP_PortalHomeController phc = new PBS_AAAP_PortalHomeController();
        ApexPages.currentPage().getParameters().put('editofferIdParam', offer.id);
        phc.actionOfferEdit();
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        offer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
        PBS_AAAP_OfferHelper.triggerupdate(true);
        update offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        phc.actionOfferEdit();
        System.assert(offer.PBS_AAAP_Offer_Status__c != null);
        
        
        
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
        offer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
        PBS_AAAP_OfferHelper.triggerupdate(true);
        update offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        phc.actionOfferEdit();
        System.assert(offer.PBS_AAAP_Offer_Status__c != null);
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
        PBS_AAAP_OfferHelper.triggerupdate(true);
        update offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        space.PBS_AAAP_Total_ABOA_Edited__c = 0;
        update space;
        phc.actionOfferEdit();
        System.assert(offer.PBS_AAAP_Offer_Status__c != null);
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        space.PBS_AAAP_Total_ABOA_Edited__c = 0;
        update space;
        offer.PBS_AAAP_Offer_Submission_Date__c = Date.newInstance(2012, 04, 17);
        PBS_AAAP_OfferHelper.triggerupdate(true);
        update offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        phc.actionOfferEdit();
        System.assert(offer.PBS_AAAP_Offer_Status__c != null);
        //added by syam on 06/14/2016 for offer withdrawn status
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
        PBS_AAAP_OfferHelper.triggerupdate(true);
        update offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        space.PBS_AAAP_Total_ABOA_Edited__c = 0;
        update space;
        // add attachments
        PBS_AAAP_Offer_Attachments__c newAttach = new PBS_AAAP_Offer_Attachments__c();
        newAttach.PBS_AAAP_Offer__c = offer.id;
        newAttach.PBS_AAAP_Attachment_Type__c = 'Floor Plan';
        insert newAttach;
        
        string before = 'Testing base 64 encode';            
        Blob beforeblob = Blob.valueOf(before);
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.LinkedEntityId = newAttach.Id;
        newFileShare.ShareType= 'V';
        insert newFileShare;
        Attachment attTemp = new Attachment();

        System.debug('New attachment Id is ****' + newAttach.Id + ' attachmentId is ***' + attTemp.Id);
        Attachment att = new Attachment();
        att.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        att.Body = bodyBlob;
        att.Description = attTemp.Description;
        att.ContentType = attTemp.ContentType;
        att.ParentId = newAttach.id;
        insert att;
        phc.actionOfferEdit();
        System.assert(offer.PBS_AAAP_Offer_Status__c != null);


        phc.offerClone(offer.id, 'copy');
        phc.offerClone(offer.id, 'modify');


        phc.selectRLP = rlp.Id;
        phc.showRLPOffers();
        System.assert(phc.selectRLP != null);

        phc.selectRLP = 'All';
        phc.showRLPOffers();

        ApexPages.currentPage().getParameters().put('copyofferIdParam', offer.id);
        phc.actionOfferCopy();

        //ApexPages.currentPage().getParameters().put('modifyofferIdParam', offer.id);
        //phc.actionOfferModify();

        phc.createNewOffer();

        ApexPages.currentPage().getParameters().put('viewofferIdParam', offer.id);
        phc.actionViewOnly();

        ApexPages.currentPage().getParameters().put('updateofferIdParam', offer.id);
        phc.updateToWithdrawnStatus();

        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
        offer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
        PBS_AAAP_OfferHelper.triggerupdate(true);
        update offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        space.PBS_AAAP_Total_ABOA_Edited__c = 0;
        update space;
        phc.updateToWithdrawnStatus();
        System.assert(offer.PBS_AAAP_Offer_Status__c != null);

        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
        offer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
        PBS_AAAP_OfferHelper.triggerupdate(true);
        update offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        space.PBS_AAAP_Total_ABOA_Edited__c = 0;
        update space;
        phc.updateToWithdrawnStatus();
        System.assert(offer.PBS_AAAP_Offer_Status__c != null);

        phc.changePassword();

    }

    static testMethod void submitOfferEdit() {
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        PBS_AAAP_OfferHelper.triggerupdate(true);       
        insert offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        
        
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
        update offer;
        PBS_AAAP_PortalHomeController phc = new PBS_AAAP_PortalHomeController();
        ApexPages.currentPage().getParameters().put('editofferIdParam', offer.id);      
        phc.actionOfferEdit();
        
        
        
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        update offer;
        rlp.PBS_RSAP_Solicitation_Status__c = true;
        update rlp;
        ApexPages.currentPage().getParameters().put('editofferIdParam', offer.id); 
        phc.actionLopOfferEdit();
        
        System.assertEquals(true, rlp.PBS_RSAP_Solicitation_Status__c, 'This should be updated.');
    }

    static testMethod void submitOfferEdit1() {
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY22RLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
       
        PBS_AAAP_OfferHelper.triggerupdate(true);       
        insert offer;
        
        PBS_AAAP_Offer_Attachments__c newAttach1 = new PBS_AAAP_Offer_Attachments__c();
        newAttach1.PBS_AAAP_Offer__c = offer.id;
        newAttach1.PBS_AAAP_Attachment_Type__c = 'Floor Plan';
        insert newAttach1;
        
        string before = 'Testing base 64 encode';            
        Blob beforeblob = Blob.valueOf(before);
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.LinkedEntityId = newAttach1.Id;
        newFileShare.ShareType= 'V';
        insert newFileShare;

        PBS_AAAP_OfferHelper.triggerupdate(false);
        
        
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        offer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
        PBS_AAAP_OfferHelper.triggerupdate(true);
        update offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        PBS_AAAP_PortalHomeController phc1 = new PBS_AAAP_PortalHomeController();
        ApexPages.currentPage().getParameters().put('editofferIdParam', offer.id);      
        phc1.actionOfferEdit();
        System.assert(offer.PBS_AAAP_Offer_Status__c != null);
        
        
        
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
        update offer;
        rlp.PBS_RSAP_Solicitation_Status__c = false;
        update rlp;
        ApexPages.currentPage().getParameters().put('editofferIdParam', offer.id); 
        phc1.actionLopOfferEdit();
        
        
       
    }

    static testMethod void submitOfferEdit2() {
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        PBS_AAAP_OfferHelper.triggerupdate(true);       
        insert offer;
        PBS_AAAP_OfferHelper.triggerupdate(false);
        
        PBS_AAAP_PortalHomeController phc = new PBS_AAAP_PortalHomeController();
        
        
        
        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
        update offer;
        rlp.PBS_RSAP_Solicitation_Status__c = true;
        update rlp;
        ApexPages.currentPage().getParameters().put('editofferIdParam', offer.id); 
        phc.actionLopOfferEdit();
        
        System.assertEquals(true, rlp.PBS_RSAP_Solicitation_Status__c, 'This should be updated.');
    }
    static testMethod void myportalHomeTest1() {
        User u = PBS_AAAP_UtilityTest.createPortalUser();
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        PBS_AAAP_PortalHomeController.ContentDocumentWrapper cdw = new PBS_AAAP_PortalHomeController.ContentDocumentWrapper('Hi',bodyBlob);
        //insert u; Vaishali 06/10/2015
        System.runAs(u) {
            PBS_AAAP_PortalHomeController phc = new PBS_AAAP_PortalHomeController();
            phc.getRLPs();
            System.assert(phc != null);
        }
    }

    static testMethod void lopOfferTest() {
        PBS_AAAP_HomePageController hp = new PBS_AAAP_HomePageController();

        User u = PBS_AAAP_UtilityTest.createPortalUser();
        String userId = UserInfo.getUserId();
        // PBS_LOP_Offer__c oOther = [select o.Id From PBS_LOP_Offer__c o where o.ownerId != :userId limit 1];

        System.debug('u.id is ' + u.id);

        System.runAs(u) {
            Test.startTest();


            PBS_LOP_Offer__c offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();

            insert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('editofferIdParam', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            ApexPages.currentPage().getParameters().put('Type', 'LOP');

            PBS_AAAP_PortalHomeController obc = new PBS_AAAP_PortalHomeController();
            obc.showPopup();
            obc.createLopOffer();
            obc.actionLopOfferEdit();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('viewofferIdParam', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_AAAP_PortalHomeController();
            obc.actionLOPViewOnly();

            offer = PBS_AAAP_UNIT_TEST_DATA_GENERATOR.genTestLopOffer();
            upsert offer;
            System.assert(offer.Id != null);
            ApexPages.currentPage().getParameters().put('updateofferIdParam', offer.id);
            ApexPages.currentPage().getParameters().put('edit', 'true');
            obc = new PBS_AAAP_PortalHomeController();
            obc.updateLOPToWithdrawnStatus();
            obc.actionAdditionalDocs();
            obc.actionAdditionalRSAPDocs();
            PBS_AAAP_PortalHomeController.QueryStr('PBS_LOP_Offer__c', 'id', offer.id, new List<Id>());
            PBS_AAAP_PortalHomeController.QueryStr('PBS_LOP_Offer__c', 'id', '', new List<Id>{offer.id});
            
            
        }
    }
}