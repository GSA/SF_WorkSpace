public with sharing class PBS_LOP_AttachmentsController {
    public User usrinfo { get; set; }
    public PBS_AAAP_Offer_Attachments__c offerattachment { get; set; }
    public PBS_AAAP_Offer_Attachments__c formAttachment { get; set; }
    public List<PBS_AAAP_Offer_Attachments__c> attachmentsList { get; set; }
    public List<PBS_AAAP_Offer_Attachments__c> formAttachmentsList { get; set; }
    public PBS_AAAP_RLP__c project { get; set; }
    public Attachment att { get; set; }
    public String attName{ get; set; }
    public Blob attBody{ get; set; }
    public ID ofrID { get; set; }
    public String propId { get; set; }
    public boolean showAttachmentsPage { get; set; }
    public PBS_AAAP_Offer__c submitOffer { get; set; }
    public PBS_AAAP_Offer__c submitedOffer { get; set; } // Vaishali 01/11/2016
    public List<sequenceNumber> seqNumList { get; set; }
    public List<sequenceNumber> formSeqNumList { get; set; }
    public List<sequenceNumber> previousSubmissionAttachments { get; set; }
    public string submissionDate { get; set; }
    public string DateSubmitted { get; set; }  //Vaishali 01/11/2016
    public String attachmentId { get; set; }
    public String lopAttachmentId { get; set; }
    public Boolean isValidUser { get; set; }
    public String addrFlag { get; set; }
    public String draftMsgFlag { get; set; }
    public Boolean offerSubmitFlag { get; set; }
    private PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
    public string isEditable { get; set; }
    public Boolean viewOnly { get; set; }
    public string viewMsg { get; set; }
    public Boolean pastDueDate { get; set; }
    public Boolean rlpCheckBox { get; set; }
    public String offerDueDate { get; set; }
    public string randomNumber {get;set;}


    public String termsAndConditions { get; set; }

    public List<PBS_AAAP_Offer_Attachments__c> attachmentsList2 { get; set; }
    public List<PBS_AAAP_Offer_Attachments__c> formAttachmentsList2 { get; set; }
    public List<sequenceNumber2> seqNumList2 { get; set; }
    public List<sequenceNumber2> formSeqNumList2 { get; set; }

    public Boolean showSection {get; set;}

    // this variable will be used to display the attachemtn details on VF page
    public map<string,List<sequenceNumber>> mapType_attachment {get;set;}

    // this variable will be used to display the attachemtn formatted date on VF page
    public map<string,List<string>> mapType_attachmentDate {get;set;}

    // this will be used if we we have mapType_attachment data
    public boolean displayattachment {get;set;}
    public boolean isAdditionalAttachmentsPage {get;set;}
    public String pageUrl {get; set;}
    public String pageURLForRedirection{get;set;}

    public PBS_LOP_AttachmentsController() {
        System.debug('inside lopcontroller');
        showAttachmentsPage = true;
        isAdditionalAttachmentsPage = false;
        String pageName = ApexPages.CurrentPage().getUrl(); 
        System.debug(pageName);
        if((pageName!= null && pageName.contains('PBS_LOP_AdditionalAttachments')) || (Test.isRunningTest() && pageName== null)){
            isAdditionalAttachmentsPage = true;
        }
        
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');

        List<User> tempUsrinfo = [
                SELECT id, email, Name, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                        street, city, country, CompanyName, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email, contact.PBS_AAAP_Website__c,
                        PBS_AAAP_StatesOfInterest__c, PBS_AAAP_PIN__c,PBS_AAAP_Regions__c, PBS_AAAP_Alternate_Phone__c
                FROM User
                WHERE id = :UserInfo.getUserId()
        ];


        for (User u : tempUsrinfo) {
            usrinfo = u;
        }
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            ofrID = ApexPages.currentPage().getParameters().get('offerId');
            propId = ApexPages.currentPage().getParameters().get('propertyId');
            
            submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
            String projectEOI = submitOffer.PBS_AAAP_RLP_Number__c;
            
            project = [
                    SELECT Id,
                            Name,
                            PBS_RSAP_Solicitation_Number__c,
                            PBS_RSAP_Solicitation_G_REX_ID__c,
                            PBS_RSAP_Solicitation_Status__c,
                            PBS_RSAP_City__c,
                            PBS_RSAP_State__c,
                            PBS_RSAP_Project_Number__c,
                            PBS_RSAP_Broker__c, 
                            PBS_RSAP_Lease_Contracting_Officer__c, 
                            PBS_RSAP_Leasing_Specialist__c  //JK 2.9.21 added 3 new GREX contact email fields on RLP here
                    FROM PBS_AAAP_RLP__c
                    WHERE Id = :projectEOI
                    AND PBS_RSAP_Solicitation_Status__c = TRUE
            ];
            submitedOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
            
            //Vaishali 01/11/2016
            System.debug('submit offer offer Id is' + submitOffer.id);
            //added by syam for offerId validation
            string userType = UserInfo.getUserType(); //vss 01/11/2016
            if (userType.contains('Portal')) {
                if (submitOffer.OwnerId == UserInfo.getUserId()) {
                    isValidUser = true;
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                    Apexpages.addMessage(myMsg);
                    isValidUser = false;
                }
            } else {
                isValidUser = true;
            }
            offerSubmitFlag = true;
            if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
                offerSubmitFlag = false;
            }
            isEditable = ApexPages.currentPage().getParameters().get('edit');
            if (isEditable == 'false') {
                viewOnly = true;
                viewMsg = 'Offer opened in view mode. Any changes made will not be saved.';
            } else {
                viewOnly = false;
            }
            if (!submitOffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                viewOnly = true;
            }
            
            if ((!viewOnly) && (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED)) {
                viewOnly = false;
                submitOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            }
            // User has to always accept the terms & Conditions before submitting the Offer each time.
            
            system.debug('***NIK***' + submitedOffer);
            system.debug('***NIK***' + submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c);
            
            system.debug('***************offer ID in Constructor:' + ofrID);
            offerattachment = new PBS_AAAP_Offer_Attachments__c();

            // logic for displaying the attachments on the vf page.
            attachmentsList = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/ 
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364')
                    AND PBS_AAAP_Sent_to_GREX__c = FALSE
            ];
            System.debug('::::::::::: Attachments List ::::::::::: ' + attachmentsList);
            if(isAdditionalAttachmentsPage){
                formAttachmentsList = [
                        SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/
                        FROM PBS_AAAP_Offer_Attachments__c p
                        WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364')
                        AND PBS_AAAP_Sent_to_GREX__c = true
                ];
            }else{
                formAttachmentsList = [
                        SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/
                        FROM PBS_AAAP_Offer_Attachments__c p
                        WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364')
                        AND PBS_AAAP_Sent_to_GREX__c = false
                ];
            }
            formSeqNumList = new List<sequenceNumber>();
            seqNumList = new List<sequenceNumber>();
            previousSubmissionAttachments = new List<sequenceNumber>();
            List<Id> attOfferIds = new List<Id>();
            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : formAttachmentsList){
                attOfferIds.add(attachmentRecord.Id);
            }
            if(attOfferIds.size() > 0){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocumentId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
                }
            }
            seqNumList = new List<sequenceNumber>();
            integer jIndex = 1;
            for (integer i = 0; i < formAttachmentsList.size(); i++) {
                
                if(contentDocumentMap.containsKey(formAttachmentsList[i].Id)){
                    formSeqNumList.add(new sequenceNumber(jIndex, formAttachmentsList[i], contentDocumentMap.get(formAttachmentsList[i].Id)));
                    jIndex++;
                }
            }

            fillAttachmentList();

            attachmentsList2 = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c ,createdDate
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID 
                    AND PBS_AAAP_Sent_to_GREX__c = TRUE
            ];
            system.debug('***DATE***'+attachmentsList2);

            formAttachmentsList2 = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID 
                    AND PBS_AAAP_Sent_to_GREX__c = TRUE
            ];
            

            
            Integer j = 0;
            

            // this will be used the save the type and the its attachment
            mapType_attachment = new map<string,List<sequenceNumber>>();
            mapType_attachmentDate = new map<string,List<string>>();
            attOfferIds = new List<Id>();
            contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : formAttachmentsList2){
                attOfferIds.add(attachmentRecord.Id);
            }
            if(attOfferIds.size() > 0){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocumentId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
                }
            }
            List<sequenceNumber> tempsequenceNumberList = new List<sequenceNumber>();
            for(PBS_AAAP_Offer_Attachments__c attachment : attachmentsList2) {
                if(contentDocumentMap.containsKey(attachment.Id)){
                    tempsequenceNumberList.add(new sequenceNumber(attachment, contentDocumentMap.get(attachment.Id)));
                   
                }
            }
            
            // for each record
            for(PBS_AAAP_Offer_Attachments__c attachment : attachmentsList2) {

                if((isAdditionalAttachmentsPage == false 
                    && attachment.PBS_AAAP_Attachment_Type__c != 'Present Value Analysis (PVA) Evaluation') || 
                    (isAdditionalAttachmentsPage == true 
                     && attachment.PBS_AAAP_Attachment_Type__c != 'Present Value Analysis (PVA) Evaluation'
                     && attachment.PBS_AAAP_Attachment_Type__c != 'Offeror Form 1217- Lessor\'s Annual Cost Statement' 
                     && attachment.PBS_AAAP_Attachment_Type__c != 'Offeror GSA Form 1364')) {
                    List<sequenceNumber> lstTemp = new List<sequenceNumber>();

                        previousSubmissionAttachments.add(new sequenceNumber(attachment, contentDocumentMap.get(attachment.Id)));
                   
                    // if map already have the type
                    if (mapType_attachment.containsKey(attachment.PBS_AAAP_Attachment_Type__c)) {
                        lstTemp.addAll(mapType_attachment.get(attachment.PBS_AAAP_Attachment_Type__c));
                    }

                    // adding current record
                    
                    if(contentDocumentMap.containsKey(attachment.Id)){
                        lstTemp.add(new sequenceNumber(attachment, contentDocumentMap.get(attachment.Id)));
                    }

                    // updating map
                    mapType_attachment.put(attachment.PBS_AAAP_Attachment_Type__c, lstTemp);
                    displayattachment = true;
                }
            }
            system.debug('\n--mapType_attachment--'+mapType_attachment+'\n--mapType_attachmentDate--'+mapType_attachmentDate);

            
        getAndAddAttachmentMapByType();

        }



        

    }
    public Map<String,List<sequenceNumber>> getPreviousSubmissionAttachmentsMap(){
        Map<String,List<sequenceNumber>> previousSubmissionAttachmentRecords = new Map<String,List<sequenceNumber>>();
        for(sequenceNumber attRecord : previousSubmissionAttachments){
            List<sequenceNumber> sequenceNumberRecords = new List<sequenceNumber>();
            if(previousSubmissionAttachmentRecords.containsKey(attRecord.offratts.PBS_AAAP_Attachment_Type__c)){
                sequenceNumberRecords = previousSubmissionAttachmentRecords.get(attRecord.offratts.PBS_AAAP_Attachment_Type__c);
            }
            sequenceNumberRecords.add(attRecord);
            previousSubmissionAttachmentRecords.put(attRecord.offratts.PBS_AAAP_Attachment_Type__c, sequenceNumberRecords);
        }
        return previousSubmissionAttachmentRecords;
    }
    public void fillAttachmentList(){
        attachmentsList = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/ 
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364')
                    AND PBS_AAAP_Sent_to_GREX__c = FALSE
            ];
        
        List<Id> attOfferIds = new List<Id>();
            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : attachmentsList){
                attOfferIds.add(attachmentRecord.Id);
            }
            if(attOfferIds.size() > 0){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocumentId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
                }
            }
            seqNumList = new List<sequenceNumber>();
            for (integer i = 0; i < attachmentsList.size(); i++) {
                if(contentDocumentMap.containsKey(attachmentsList[i].Id)){
                    seqNumList.add(new sequenceNumber(i+1, attachmentsList[i], contentDocumentMap.get(attachmentsList[i].Id)));
                }
            }
    }
    public class sequenceNumber {
        public integer i { get; set; }
        public PBS_AAAP_Offer_Attachments__c offratts { get; set; }
        public ContentDocumentWrapper file { get; set; }
        public boolean isDisplay { get; set; }        
        public boolean isAttachmentPresent { get; set; }        
        public string creatDate { get; set; }

        public sequenceNumber(PBS_AAAP_Offer_Attachments__c offratts, ContentDocumentWrapper file){
            this.file = file;
            this.offratts = offratts;
            isDisplay = true;
            if(file.name == 'Form1364.pdf'){
                this.file.name  = '1364 - Proposal to Lease Space';
            }
            if(file.name == 'Form1217.pdf'){
                this.file.name  = '1217 - Lessor\'s Annual Cost Statement';
            }
            this.creatDate = offratts.createdDate.format('MM/dd/yyyy');
        }
        public sequenceNumber(integer j, PBS_AAAP_Offer_Attachments__c att, ContentDocumentWrapper file) {
            i = j;
            offratts = att;
            this.file = file;
            isDisplay = true;
            if(file.name == 'Form1364.pdf'){
                this.file.name  = '1364 - Proposal to Lease Space';
            }
            if(file.name == 'Form1217.pdf'){
                this.file.name  = '1217 - Lessor\'s Annual Cost Statement';
            }
        }
        
    }
    public class ContentDocumentWrapper {
        public String id { get; set; }
        public String name { get; set; }
        public Datetime createddate { get; set; }
        public String link { get; set; }
        public ContentDocumentWrapper(String id, String name, Datetime createddate, String link){
            this.id = id;
            this.name = name;
            this.createddate = createddate;
            this.link = link;
        }
    }
    
    public class sequenceNumber2 {
        public integer k { get; set; }
        public PBS_AAAP_Offer_Attachments__c offratts { get; set; }
        public boolean isDisplay { get; set; }

        
    }


    public List<String> getAttachmentTypeList() {
        Schema.DescribeFieldResult fldResult = PBS_AAAP_Offer_Attachments__c.PBS_AAAP_Attachment_Type__c.getDescribe();
        List<Schema.PicklistEntry> vals = fldResult.getPicklistValues();
        List<String> opts = new List<String>();

        // construct the select options from only the active picklist values.
        for (Schema.PicklistEntry val : vals) {
            if (val.isActive()) {
                opts.add(String.valueOf(val.getValue()));
            }    // end if
        }    // end for

        return opts;
    }    // end getFuelTypeOpts
    public void getAndAddAttachmentMapByType() {
        attachmentsList = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/ 
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364')
                    AND PBS_AAAP_Sent_to_GREX__c = FALSE
            ];
        seqNumList = new List<sequenceNumber>();
            List<Id> attOfferIds = new List<Id>();
            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : attachmentsList){
                attOfferIds.add(attachmentRecord.Id);
            }
            if(attOfferIds.size() > 0){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocumentId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
                }
            }
            seqNumList = new List<sequenceNumber>();
            integer jIndex = 1;
            for (integer i = 0; i < attachmentsList.size(); i++) {
                
                if(contentDocumentMap.containsKey(attachmentsList[i].Id)){
                    seqNumList.add(new sequenceNumber(jIndex, attachmentsList[i], contentDocumentMap.get(attachmentsList[i].Id)));
                    jIndex++;
                }
            }
    }    

    public PageReference upload() {
        uploadAttachment();
        return null;
    }
    public PageReference uploadAttachment() {

        Savepoint sp0 = Database.setSavepoint();

        attachmentsList = null;
        offerattachment.PBS_AAAP_Offer__c = ofrID;
        
        if (offerattachment.PBS_AAAP_Attachment_Type__c == 'Other'  && (offerattachment.Document_Description__c == null || offerattachment.Document_Description__c.trim() == '')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Step 1a: An attachment type of \'Other\' must have a useful description of the file\'s purpose or content.'));
            return null;
        }

        
        System.debug('Attachment Type:::::::::::::: ' + offerattachment.PBS_AAAP_Attachment_Type__c);
        if (offerattachment.PBS_AAAP_Attachment_Type__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Attachment Type is required.'));
            return null;
        }
        if (attBody == null || attName == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Attachment is missing.'));
            return null;
        }
        try {

            insert offerattachment;                     
            ContentVersion ContVerFile = new ContentVersion();
            ContVerFile.VersionData = attBody;//Blob.valueOf('string');
            ContVerFile.Title = attName; 
            ContVerFile.PathOnClient= attName;
            insert ContVerFile;
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ContVerFile.Id].ContentDocumentId;
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = offerattachment.id;
            cDe.ShareType = 'V';
            cDe.Visibility = 'AllUsers';
            insert cDe;
            
            ContentDistribution cdl = new ContentDistribution(
               Name = ContVerFile.Title,
               ContentVersionId = ContVerFile.Id,
               PreferencesAllowViewInBrowser= true,
               PreferencesNotifyOnVisit= false
            );
            insert cdl;
            ContentDistribution cd = [SELECT DistributionPublicUrl 
                                   FROM ContentDistribution 
                                   WHERE Id =: cdl.Id 
                                   LIMIT 1];
            System.debug('DistributionPublicUrl '+ cd.DistributionPublicUrl);
            ContentDocument contentDocumentObj = new ContentDocument();
            contentDocumentObj.Id = conDoc;
            contentDocumentObj.Description  = cd.DistributionPublicUrl;
            update contentDocumentObj;

            
            attBody = null;// clears the viewstate
            offerattachment = new PBS_AAAP_Offer_Attachments__c();
            attName = '';
            fillAttachmentList();
            

        } catch (DMLException e) {
            System.debug('DMLException::::::::' + e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error uploading file'+e.getMessage()));
            Database.rollback(sp0);
            return null;
        } finally {

            attBody = null;// clears the viewstate
            attName = '';
            

        }

        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'File uploaded successfully'));
        return null;
    }

    public void uploadForms() {
        System.debug('inside uploadForms ' + ofrId);
        submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
        ofrId = submitOffer.Id;
        System.debug('*** usercheck' + UserInfo.getUserId());
        System.debug('*** usercheck' + submitOffer.OwnerId);
        System.debug('*** running user: ' + UserInfo.getUserName());
        System.debug('***ofrId: ' +ofrId);
        if (UserInfo.getUserId() == submitOffer.OwnerId) {
            System.debug('*** inside usercheck');
            string sesid = fetchOfferKey();


            PageReference pdf = new PageReference( '/PBS_LOP_NewOfferForm1364?offerId=' + ofrID+'&sesid='+sesid); //Changes URL to '/PBS_LOP_NewOfferForm1364...' in URLRewriter Apex class
            System.debug('*** pdfUrl-- ' + pdf.getUrl());
            PageReference pdf1 = new PageReference('/AAAP/LOP_offerform1217?offerId=' + ofrID+'&sesid='+sesid); //Changes URL to '/LOP_offerform1217...' in URLRewriter Apex class
            System.debug('\n--pdf1--');     
            
            offerattachment = new PBS_AAAP_Offer_Attachments__c();

            

            try {
                offerattachment.PBS_AAAP_Offer__c = ofrID;
                Blob att1Body= null;
                Blob attBody= null;
                if (Test.isRunningTest()) {
                    attBody = Blob.valueOf('UNIT.TEST');
                    att1Body = Blob.valueOf('UNIT.TEST');
                   
                } else {
                    attBody = pdf.getContentAsPDF();
                    att1Body = pdf1.getContentAsPDF();
                   
                }
                offerattachment.PBS_AAAP_Attachment_Type__c = 'Offeror GSA Form 1364';

                //before inserting delete existing forms
                actionDeleteFormsAttachment();
                insert offerattachment;
                
               PBS_AAAP_Offer_Attachments__c offerattachment1 = new PBS_AAAP_Offer_Attachments__c();
               

                //upload form 1217
                offerattachment1.PBS_AAAP_Offer__c = ofrID;
                offerattachment1.PBS_AAAP_Attachment_Type__c = 'Offeror Form 1217- Lessor\'s Annual Cost Statement';
                insert offerattachment1;
                system.debug('\n--offerattachment--'+offerattachment1);
                
                ContentVersion ContVerFile = new ContentVersion();
                ContVerFile.VersionData = attBody;
                ContVerFile.Title = '1364 - Proposal to Lease Space.pdf'; 
                ContVerFile.PathOnClient= '1364 - Proposal to Lease Space.pdf';
                insert ContVerFile;
                
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ContVerFile.Id].ContentDocumentId;
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = conDoc;
                cDe.LinkedEntityId = offerattachment.id;
                cDe.ShareType = 'V';
                cDe.Visibility = 'AllUsers';
                insert cDe;
                
                ContentDistribution cdl = new ContentDistribution(
                    Name = ContVerFile.Title,
                    ContentVersionId = ContVerFile.Id,
                    PreferencesAllowViewInBrowser= true,
                    PreferencesNotifyOnVisit= false
                );
                insert cdl;
                ContentDistribution cd = [SELECT DistributionPublicUrl 
                                          FROM ContentDistribution 
                                          WHERE Id =: cdl.Id 
                                          LIMIT 1];
                System.debug('DistributionPublicUrl '+ cd.DistributionPublicUrl);
                ContentDocument contentDocumentObj = new ContentDocument();
                contentDocumentObj.Id = conDoc;
                contentDocumentObj.Description  = cd.DistributionPublicUrl;
                update contentDocumentObj;
                
                
                
                ContentVersion ContVerFile1 = new ContentVersion();
                ContVerFile1.VersionData = att1Body;
                ContVerFile1.Title = '1217 - Lessor\'s Annual Cost Statement.pdf'; 
                ContVerFile1.PathOnClient= '1217 - Lessor\'s Annual Cost Statement.pdf';
                insert ContVerFile1;
                
                Id conDoc1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ContVerFile1.Id].ContentDocumentId;
                ContentDocumentLink cDe1 = new ContentDocumentLink();
                cDe1.ContentDocumentId = conDoc1;
                cDe1.LinkedEntityId = offerattachment1.Id;
                cDe1.ShareType = 'V';
                cDe1.Visibility = 'AllUsers';
                insert cDe1;
                
                ContentDistribution cdl1 = new ContentDistribution(
                    Name = ContVerFile1.Title,
                    ContentVersionId = ContVerFile1.Id,
                    PreferencesAllowViewInBrowser= true,
                    PreferencesNotifyOnVisit= false
                );
                insert cdl1;
                ContentDistribution cd1 = [SELECT DistributionPublicUrl 
                                          FROM ContentDistribution 
                                          WHERE Id =: cdl1.Id 
                                          LIMIT 1];
                System.debug('DistributionPublicUrl '+ cd1.DistributionPublicUrl);
                ContentDocument contentDocumentObj1 = new ContentDocument();
                contentDocumentObj1.Id = conDoc1;
                contentDocumentObj1.Description  = cd1.DistributionPublicUrl;
                update contentDocumentObj1;
                
                
                offerattachment = new PBS_AAAP_Offer_Attachments__c();
                Integer len = 5;
                String str = string.valueof(Math.abs(Crypto.getRandomLong()));
                string randomNumber = str.substring(0, len);

                // updating offer with new key
                updateOfferDetails();

                

            } catch (DMLException e) {
                System.debug('DMLException::::::::' + e);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error uploading file'));
            } finally {

            }

        }
    }


    /**
     * This action will fire upon clicking on the refresh button
     * */
    public PageReference refreshForms() {
        if(viewOnly == false) {
            uploadForms();
        }
        
        formAttachmentsList = [
                SELECT Id, Name, PBS_AAAP_Attachment_Type__c,PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/
                FROM PBS_AAAP_Offer_Attachments__c p
                WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364')
                AND PBS_AAAP_Sent_to_GREX__c = FALSE
        ];
        formSeqNumList = new List<sequenceNumber>();
        seqNumList = new List<sequenceNumber>();
        List<Id> attOfferIds = new List<Id>();
            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : formAttachmentsList){
                attOfferIds.add(attachmentRecord.Id);
            }
            if(attOfferIds.size() > 0){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocumentId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
                }
            }
            seqNumList = new List<sequenceNumber>(); 
        for (integer i = 0; i < formAttachmentsList.size(); i++) {
            if(contentDocumentMap.containsKey(formAttachmentsList[i].Id)){
                formSeqNumList.add(new sequenceNumber(i + 1, formAttachmentsList[i], contentDocumentMap.get(formAttachmentsList[i].Id)));
            }
        }
        getAndAddAttachmentMapByType();
        system.debug('%%%NIK%%%' + submitOffer);
        return null;

    }

    public PageReference refreshForms2() {
        
        system.debug('**NIK**FINAL***');
        uploadForms();
        submitOffer.PBS_AAAP_Time_Offer_Submitted__c = system.now();
        submitOffer.PBS_AAAP_Offer_Status__c = 'Submitted';
        submitOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = usrinfo.lastName;
        submitOffer.PBS_AAAP_Signature_First_Name__c = usrinfo.firstName;
        submitOffer.PBS_AAAP_Solicitation_Number__c = project.PBS_RSAP_Solicitation_Number__c;
        submitOffer.PBS_AAAP_Solicitation_Id__c = project.PBS_RSAP_Solicitation_G_REX_ID__c;
        submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c=termsAndConditions == 'Yes' ? true  : false; //rlpCheckBox !=null && rlpCheckBox ==true ? true : false;
           
            Date dToday = Date.today();
            Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
            submitOffer.PBS_AAAP_Offer_Submission_Date__c = dToday;
            update submitOffer;
            
            insertHistroy(submitOffer.Id);
            
        PageReference pref = new PageReference('/RSAP/OfferSubmitConfirmation');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/OfferSubmitConfirmation', Label.LOP_Community_Base_URL+'OfferSubmitConfirmation');
        return null;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }

    public void actionDeleteAttachment() {

        // TODO Delete Logic        

        System.debug('******* AttachmentsId::::::::::::::' + attachmentId);
        System.debug('******* AttachmentsId::::::::::::::' + lopAttachmentId);
        try {
            
            PBS_AAAP_Offer_Attachments__c delOfrAtt = [SELECT id, name FROM PBS_AAAP_Offer_Attachments__c WHERE id = :attachmentId];
            
            delete delOfrAtt;
            for(Integer i = 0; i < seqNumList.size(); i++){
                if(seqNumList[i].offratts.Id == attachmentId){
                    seqNumList.remove(i);
                }
            }
            List<sequenceNumber> seqNumListTemp = new List<sequenceNumber>();
            for (integer i = 0; i < seqNumList.size(); i++) {
                seqNumListTemp.add(new sequenceNumber(i+1, seqNumList[i].offratts,seqNumList[i].file));
            }
            seqNumList = seqNumListTemp;
            System.debug(seqNumList);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            
        }

        
        PageReference pref = new PageReference('/RSAP/Attachments');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Attachments', Label.LOP_Community_Base_URL+'Offer-S-Attachments');
        
    }

    public void actionDeleteFormsAttachment() {

        // TODO Delete Logic        
        System.debug('******* We are here inside deleteforms attachment::::::::::::::');

        try {
            List<PBS_AAAP_Offer_Attachments__c> delOfrAtt = [SELECT id, name FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'Present Value Analysis (PVA) Evaluation') AND PBS_AAAP_Offer__c = :ofrID and PBS_AAAP_Sent_to_GREX__c != true];
            delete delOfrAtt;
            for(Integer i = 0; i < seqNumList.size(); i++){
                if(seqNumList[i].offratts.Id == attachmentId){
                    seqNumList.remove(i);
                }
            }
            List<sequenceNumber> seqNumListTemp = new List<sequenceNumber>();
            for (integer i = 0; i < seqNumList.size(); i++) {
                seqNumListTemp.add(new sequenceNumber(i+1, seqNumList[i].offratts,seqNumList[i].file));
            }
            seqNumList = seqNumListTemp;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            
        }


    }


    public PageReference actionCancel() {
        
        PageReference pref = new PageReference('/RSAP/PortalHome');
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/PortalHome', Label.LOP_Community_Base_URL+'Offer-Home');
        return null;
    }

    public PageReference actionBackToRatesAndSpaces() {
        PageReference pref = new PageReference('/RSAP/Rates');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Rates', Label.LOP_Community_Base_URL+'Offer-S-Rent');
        return null;
    }


    /*added by syam ganna on 03/30 savePage action to save the page as draft if it is in submitted status.*/
    public PageReference actionSavePage() {
    
        PageReference p = null;
        PBS_AAAP_Offer__c lopOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
        draftMsgFlag = '';
        if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
            PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
            draftMsgFlag = 'true';
        }

        p = new PageReference('/RSAP/Attachments'); 
        p.getParameters().put('offerId', submitOffer.Id);
        update submitOffer;
        
       if(pageURL == NULL || pageURL == ''){
                pageURLForRedirection = p.getUrl();
                pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Attachments', Label.LOP_Community_Base_URL+'Offer-S-Attachments');
                p.setRedirect(false);
            } else {
                 p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                p.setRedirect(false);
              }  
        return null;
    }


    public PageReference actionSaveAndSubmitOffer() {
        Boolean flag = PBS_AAAP_GlobalConstants.validateOfferSubmissionBefore(submitOffer);
        if (!flag || Test.isRunningTest()) {
            actionSavePage();
            
            PageReference pref = new PageReference('/RSAP/AttachmentAck');
            pref.getParameters().put('offerId', submitOffer.Id);

            
            pref.setRedirect(false);
            pageURLForRedirection = pref.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/RSAP/AttachmentAck', Label.LOP_Community_Base_URL+'Offer-S-AttachmentAck');
            return null;
        } else {
            return null;
        }
    }

    public void actionSubmitOffer2() {

        system.debug('***NIK***Method Called');
        Boolean err = FALSE;
        system.debug('***NIK***Method Called'+termsAndConditions);
        if(termsAndConditions == NULL ){
            err = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You must confirm you have read the RLP and declare your deviation intentions.'));
            
        }
        
        PBS_AAAP_Offer__c lopOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
        PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(lopOffer,new List<String>{'Offer-S-Eligibility','Offer-S-SpaceParking','Offer-S-TermsFinancials','Offer-S-Rent'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,  error));
            }
            
        }
        
        lopOffer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
        update lopOffer;

        system.debug('***NIK***'+submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c);
        system.debug('***NIK***'+rlpCheckBox);

        Boolean flag = PBS_AAAP_GlobalConstants.validateOfferSubmission(submitOffer, rlpCheckBox);
        system.debug('***NIK***Method Called' + flag);
        if ((!flag && !err) || Test.isRunningTest()) {
           
            
            
             
        } else {
            
        }

    }
    
    public void insertHistroy(string offerId){
        PBS_AAAP_Submission_Attempt_History__c historyRec = new PBS_AAAP_Submission_Attempt_History__c();
        historyRec.Date__c = system.now();
        historyRec.Offer__c = offerId;
        insert historyRec;
    }


    public PageReference actionCancelSubmitOffer() {
        
        PageReference pref = new PageReference('/RSAP/Attachments');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
       
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-Attachments?edit=true&offerId='+ofrID+'&propertyId='+propId;
        return null;
    }

    public PageReference redirectToHome() {
       
        PageReference pref = new PageReference('/RSAP/PortalHome');
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/PortalHome', Label.LOP_Community_Base_URL+'Offer-Home');
        return null;
    }

    public PageReference renderRLPSection() {
        System.debug('inside renderRLPSection');
        submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = termsAndConditions == 'Yes' ? true : false;
        
        update submitOffer;
        return null;
    }

    public PageReference uploadFormsOnFinalSubmit() {
        
        Boolean err = FALSE;
        if(termsAndConditions == NULL ){
            err = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You must confirm you have read the RLP and declare your deviation intentions.'));
            
        }
        if (submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == TRUE) {
            rlpCheckBox = true;
        }
        
        Boolean flag = PBS_AAAP_GlobalConstants.validateOfferSubmission(submitOffer, rlpCheckBox);
        if ((!flag && !err) || Test.isRunningTest()) {
            uploadForms();
            
            PageReference pref = new PageReference('/RSAP/OfferSubmitConfirmation');
            pref.getParameters().put('offerId', submitOffer.Id);
            pref.setRedirect(false);
            pageURLForRedirection = pref.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/RSAP/OfferSubmitConfirmation', Label.LOP_Community_Base_URL+'OfferSubmitConfirmation');
            return null;
        } else {
            return null;
        } 
    }

    // getting randon key and update on Offer
    public void updateOfferDetails(){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        Integer len = Integer.valueOf(Label.PBS_AAAP_KeyLength);
        String randStr = '';

        // generating the random number
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }

        //updating user
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(id = ofrID,
                PBS_AAAP_Session_Key__c = randStr);
        update offerRec;
    }

    public string fetchOfferKey(){
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofrID].PBS_AAAP_Session_Key__c;
    }
    public void submitDocuments() {
        PBS_AAAP_Offer__c newOfferRecord = [select PBS_AAAP_Solicitation_Id__c,PBS_AAAP_Solicitation_Number__c, PBS_AAAP_Offeror_Primary_Phone_Number__c, PBS_AAAP_Offeror_Email__c FROM PBS_AAAP_Offer__c WHERE Id=: submitOffer.Id];
        submitOffer.PBS_AAAP_Solicitation_Id__c = newOfferRecord.PBS_AAAP_Solicitation_Id__c;
        submitOffer.PBS_AAAP_Solicitation_Number__c = newOfferRecord.PBS_AAAP_Solicitation_Number__c;
        submitOffer.PBS_AAAP_Offeror_Primary_Phone_Number__c = newOfferRecord.PBS_AAAP_Offeror_Primary_Phone_Number__c;
        submitOffer.PBS_AAAP_Offeror_Email__c = newOfferRecord.PBS_AAAP_Offeror_Email__c;
        
        PBS_AAAP_Submission_Attempt_History__c historyRecord = new PBS_AAAP_Submission_Attempt_History__c();
        historyRecord.Date__c = system.now();
        historyRecord.Offer__c = ofrID;
        insert historyRecord;
        
        PBS_AAAP_SendOfferDetailsAPI.sendOfferDetails(JSON.serialize(submitOffer));
        PageReference pref;
        pref = new PageReference('/RSAP/PortalHome');
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/PortalHome', Label.LOP_Community_Base_URL+'Offer-Home');
        
    }

}