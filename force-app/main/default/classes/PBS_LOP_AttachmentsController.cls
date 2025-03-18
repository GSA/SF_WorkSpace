public with sharing class PBS_LOP_AttachmentsController {
    public User usrinfo { get; set; }
    public PBS_AAAP_Offer_Attachments__c offerattachment { get; set; }
    public PBS_AAAP_Offer_Attachments__c formAttachment { get; set; }
    public List<PBS_AAAP_Offer_Attachments__c> attachmentsList { get; set; }
    public List<PBS_AAAP_Offer_Attachments__c> formAttachmentsList { get; set; }
    public PBS_AAAP_RLP__c project { get; set; }
    //public List<Attachment> attList { get; set; }
    public Attachment att { get; set; }
    public String attName{ get; set; }
    public Blob attBody{ get; set; }
    public ID ofrID { get; set; }
    public boolean showAttachmentsPage { get; set; }
    public PBS_AAAP_Offer__c submitOffer { get; set; }
    public PBS_AAAP_Offer__c submitedOffer { get; set; } // Vaishali 01/11/2016
    public List<sequenceNumber> seqNumList { get; set; }
    public List<sequenceNumber> formSeqNumList { get; set; }
    public List<sequenceNumber> previousSubmissionAttachments { get; set; }
    // public boolean showSubmitOfferButton                        {get;set;}
    // public PBS_AAAP_RLP__c rlpInfo                              {get;set;}
    //public string termsandconditons { get; set; }
    public string submissionDate { get; set; }
    public string DateSubmitted { get; set; }  //Vaishali 01/11/2016
    // public date rlpPostDate                                     {get;set;}
    public String attachmentId { get; set; }
    public String lopAttachmentId { get; set; }
    public Boolean isValidUser { get; set; }
    // public String buildingPageAddrFlag                        {get;set;}
    public String addrFlag { get; set; }
    public String draftMsgFlag { get; set; }
    public Boolean offerSubmitFlag { get; set; }
    // public String spaceIdToReport                                {get;set;}
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
            // buildingPageAddrFlag = ApexPages.currentPage().getParameters().get('addrFlag');
            submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
            String projectEOI = submitOffer.PBS_AAAP_RLP_Number__c;
            //project = PBS_AAAP_GlobalConstants.getProjectDetails(projectEOI);
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
            /**
            if (project.Project_Offer_Due_Date__c != null) {
                DateTime dt = project.Project_Offer_Due_Date__c;
                // offerDueDate = dt.format('MM/dd/yyyy HH:mm:ss','America/New_York');
                offerDueDate = PBS_AAAP_GlobalConstants.convertToTimeZone(project);
            }
            **/
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
                viewMsg = 'Offer opened in a View mode';
            } else {
                viewOnly = false;
            }
            if (!submitOffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                viewOnly = true;
            }
            /**
            if (submitOffer.Project_Offer_Due_Date__c < datetime.now()) {
                pastDueDate = true;
            } else {
                pastDueDate = false;
            }
            **/
            if ((!viewOnly) && (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED)) {
                viewOnly = false;
                submitOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            }
            // User has to always accept the terms & Conditions before submitting the Offer each time.
            if (submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == TRUE) {
                termsAndConditions = 'Yes';
            } else {
                termsAndConditions = NULL;
            }
            system.debug('***NIK***' + submitedOffer);
            system.debug('***NIK***' + submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c);
            //termsandconditons = 'No';
            /*  submitOffer.PBS_AAAP_SIGNATURE_PIN__c = null;
              submitOffer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'No';
              submitOffer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
              submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'No';
              submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'No';
              submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'No';
              submitOffer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'No';
              submitOffer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'No';
              submitOffer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'No';
              submitOffer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'No';
              */
            system.debug('***************offer ID in Constructor:' + ofrID);
            offerattachment = new PBS_AAAP_Offer_Attachments__c();

            // logic for displaying the attachments on the vf page.
            attachmentsList = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/ 
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
                    AND PBS_AAAP_Sent_to_GREX__c = FALSE
            ];
            System.debug('::::::::::: Attachments List ::::::::::: ' + attachmentsList);
            if(isAdditionalAttachmentsPage){
                formAttachmentsList = [
                        SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/
                        FROM PBS_AAAP_Offer_Attachments__c p
                        WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
                        AND PBS_AAAP_Sent_to_GREX__c = true
                ];
            }else{
                formAttachmentsList = [
                        SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/
                        FROM PBS_AAAP_Offer_Attachments__c p
                        WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
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
                //formSeqNumList.add(new sequenceNumber(i + 1, formAttachmentsList[i]));
                if(contentDocumentMap.containsKey(formAttachmentsList[i].Id)){
                    formSeqNumList.add(new sequenceNumber(jIndex, formAttachmentsList[i], contentDocumentMap.get(formAttachmentsList[i].Id)));
                    jIndex++;
                }
            }

            fillAttachmentList();

            attachmentsList2 = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/,createdDate
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID //AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
                    AND PBS_AAAP_Sent_to_GREX__c = TRUE
            ];
            system.debug('***DATE***'+attachmentsList2);

            formAttachmentsList2 = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID //AND p.PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
                    AND PBS_AAAP_Sent_to_GREX__c = TRUE
            ];
            /*
            formSeqNumList2 = new List<sequenceNumber2>();
            seqNumList2 = new List<sequenceNumber2>();
            for (integer j = 0; j < formAttachmentsList2.size(); j++) {
                formSeqNumList2.add(new sequenceNumber2(j + 1, formAttachmentsList2[j]));
            }
            */

            //Map<String, List<Attachment>> attMap2 = getAttachmentMapByType2();
            Integer j = 0;
            /**
            // @Added by Nik
            for (PBS_AAAP_Offer_Attachments__c attachment : attachmentsList2) {
                List<Attachment> atts = (List<Attachment>) attMap2.get(attachment.PBS_AAAP_Attachment_Type__c);
                seqNumList2.add(new sequenceNumber2(j+1,attachment.PBS_AAAP_Date_sent_to_GREX__c, attachment.PBS_AAAP_Attachment_Type__c, (List<Attachment>) attMap2.get(attachment.PBS_AAAP_Attachment_Type__c)));
                j++;
            }
            **/

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
                    //if(attachment.PBS_AAAP_Sent_to_GREX__c == true){
                        //previousSubmissionAttachments.add(new sequenceNumber(attachment, contentDocumentMap.get(attachment.Id)));
                    //}
                }
            }
            //formSeqNumList = tempsequenceNumberList;
            // for each record
            for(PBS_AAAP_Offer_Attachments__c attachment : attachmentsList2) {

                if((isAdditionalAttachmentsPage == false 
                    && attachment.PBS_AAAP_Attachment_Type__c != 'Present Value Analysis (PVA) Evaluation') || 
                    (isAdditionalAttachmentsPage == true 
                     && attachment.PBS_AAAP_Attachment_Type__c != 'Present Value Analysis (PVA) Evaluation'
                     && attachment.PBS_AAAP_Attachment_Type__c != 'Offeror Form 1217- Lessor\'s Annual Cost Statement' 
                     && attachment.PBS_AAAP_Attachment_Type__c != 'Offeror GSA Form 1364')) {
                    List<sequenceNumber> lstTemp = new List<sequenceNumber>();
//if(attachment.PBS_AAAP_Sent_to_GREX__c == true){
                        previousSubmissionAttachments.add(new sequenceNumber(attachment, contentDocumentMap.get(attachment.Id)));
                    //}
                    // if map already have the type
                    if (mapType_attachment.containsKey(attachment.PBS_AAAP_Attachment_Type__c)) {
                        lstTemp.addAll(mapType_attachment.get(attachment.PBS_AAAP_Attachment_Type__c));
                    }

                    // adding current record
                    //lstTemp.add(new sequenceNumber(attachment, attachment.Attachments));
                    if(contentDocumentMap.containsKey(attachment.Id)){
                        lstTemp.add(new sequenceNumber(attachment, contentDocumentMap.get(attachment.Id)));
                    }

                    // updating map
                    mapType_attachment.put(attachment.PBS_AAAP_Attachment_Type__c, lstTemp);
                    displayattachment = true;
                }
            }
            system.debug('\n--mapType_attachment--'+mapType_attachment+'\n--mapType_attachmentDate--'+mapType_attachmentDate);

            /*System.debug('Map size is' + attMap2.size());
            System.debug('Map is ' + attMap2);
            Integer j = 0;
            for (String key : attMap2.keySet()) {
                System.debug('key is ' + key);
                List<Attachment> atts = (List<Attachment>) attMap2.get(key);
                System.debug('actual attachments are' + atts);
                System.debug('actual attachments size is' + atts.size());

                seqNumList2.add(new sequenceNumber2(j + 1, key, (List<Attachment>) attMap2.get(key)));
                j++;
            }*/
        getAndAddAttachmentMapByType();

        }



        /**
        Date dToday = Date.today();
        DateTime dt1 = null;
        if (submitOffer != null) {
            dt1 = submitOffer.LOP_Offer_Submission_Date__c;
        }
        System.debug('dt1 before format is ' + dt1);
        if (dt1 == null) {
            DateSubmitted = (Date.newInstance(dToday.year(), dToday.month(), dToday.day())).format();
        } else {
            DateSubmitted = (Date.newInstance(dt1.year(), dt1.month(), dt1.day())).format();
        }
        **/

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
                    WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
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
        //public List<Attachment> attachmentsList { get; set; }
        public boolean isAttachmentPresent { get; set; }
        //public Attachment attachmentRec { get; set; }
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
        /*public sequenceNumber(integer j, String attachmentType, List<Attachment> attachments) {
            i = j;
            PBS_AAAP_Offer_Attachments__c att = new PBS_AAAP_Offer_Attachments__c();
            att.PBS_AAAP_Attachment_Type__c = attachmentType;
            offratts = att;
            attachmentsList = attachments;
            isDisplay = true;
            
        }*/
        /* public sequenceNumber(integer j, PBS_LOP_Offer_Attachment__c att,List<Attachment> attachments){
             i=j;
             offratts = att;
             attachmentsList = attachments;

         }*/
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

        /*public List<Attachment> attachmentsList2 { get; set; }
        public sequenceNumber2(integer j, PBS_AAAP_Offer_Attachments__c att) {
            k = j;
            offratts = att;
            
            for(attachment at : att.Attachments){
                isDisplay = true;
                if( at.Name == 'Form1364.pdf'){
                    at.Name = '1364 - Proposal to Lease Space';
                }
                if( at.Name == 'Form1217.pdf'){
                    at.Name = '1217 - Lessor\'s Annual Cost Statement';
                }

                if( at.Name == 'form3518.pdf'){
                    isDisplay = false;
                }
            }
            
        }
        public sequenceNumber2(integer j,DateTime submittedDate, String attachmentType, List<Attachment> attachments) {
            k = j;
            PBS_AAAP_Offer_Attachments__c att = new PBS_AAAP_Offer_Attachments__c();
            att.PBS_AAAP_Attachment_Type__c = attachmentType;
            att.PBS_AAAP_Date_sent_to_GREX__c = submittedDate;
            offratts = att;
            attachmentsList2 = attachments;
        }*/
        /* public sequenceNumber(integer j, PBS_LOP_Offer_Attachment__c att,List<Attachment> attachments){
             i=j;
             offratts = att;
             attachmentsList = attachments;

         }*/
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
                    WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
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
                //formSeqNumList.add(new sequenceNumber(i + 1, formAttachmentsList[i]));
                if(contentDocumentMap.containsKey(attachmentsList[i].Id)){
                    seqNumList.add(new sequenceNumber(jIndex, attachmentsList[i], contentDocumentMap.get(attachmentsList[i].Id)));
                    jIndex++;
                }
            }
    }
    /*public Map<String, List<Attachment>> getAttachmentMapByType() {
        
        Map<String, List<Attachment>> map1 = new Map<String, List<Attachment>>();
        //System.debug('attachmentsList size in getAttachmentMapByType' + attachmentsList.size());
        List<String> attachmentTypes = getAttachmentTypeList();
        for (String attachmentType : attachmentTypes) {
            for (PBS_AAAP_Offer_Attachments__c attachment : attachmentsList) {
                if (attachment.PBS_AAAP_Attachment_Type__c == attachmentType) {
                    if (map1.containsKey(attachment.PBS_AAAP_Attachment_Type__c)) {
                        System.debug('inside contains key');
                        List<Attachment> tempAtts = map1.get(attachment.PBS_AAAP_Attachment_Type__c);
                        //tempAtts.add(attachment.Attachments);
                        System.debug('tempAtts size is' + tempAtts.size());
                        System.debug('tempAtts is' + tempAtts);
                        map1.put(attachment.PBS_AAAP_Attachment_Type__c, tempAtts);
                    } /*else {
                        map1.put(attachment.PBS_AAAP_Attachment_Type__c, attachment.Attachments);
                    }
                }
            }
        }
        return map1;
    }*/
/*
    public Map<String, List<Attachment>> getAttachmentMapByType2() {

        Map<String, List<Attachment>> map1 = new Map<String, List<Attachment>>();
        System.debug('attachmentsList size in getAttachmentMapByType' + attachmentsList2.size());
        List<String> attachmentTypes = getAttachmentTypeList();
        for (String attachmentType : attachmentTypes) {
            for (PBS_AAAP_Offer_Attachments__c attachment : attachmentsList2) {
                if (attachment.PBS_AAAP_Attachment_Type__c == attachmentType) {
                    if (map1.containsKey(attachment.PBS_AAAP_Attachment_Type__c)) {
                        System.debug('inside contains key');
                        //List<Attachment> tempAtts = map1.get(attachment.PBS_AAAP_Attachment_Type__c);
                        //tempAtts.add(attachment.Attachments);
                        //System.debug('tempAtts size is' + tempAtts.size());
                        //System.debug('tempAtts is' + tempAtts);
                        //map1.put(attachment.PBS_AAAP_Attachment_Type__c, tempAtts);
                    } /*else {
                        map1.put(attachment.PBS_AAAP_Attachment_Type__c, attachment.Attachments);
                    }
                }
            }
        }
        return map1;
    }*/


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
            //System.debug('After Attachment Type:::::::::::::: '+offerattachment.id);

            //att.ParentId = offerattachment.id;
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

            //insert att;
            attBody = null;// clears the viewstate
            offerattachment = new PBS_AAAP_Offer_Attachments__c();
            attName = '';
            fillAttachmentList();
            //att = new Attachment();
            // logic for displaying the attachments on the vf page.
            /*
            attachmentsList = [
                    SELECT Name, PBS_AAAP_Attachment_Type__c,PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
                    AND PBS_AAAP_Sent_to_GREX__c = FALSE
                    ORDER BY p.CreatedDate
            ];
            List<Id> attOfferIds = new List<Id>();
            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : attachmentsList){
                attOfferIds.add(attachmentRecord.Id);
            }
            
            List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.VersionData, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
            for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocumentId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
            }
            /*
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : attachmentsList){
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    if(contentDocumentLinkRecord.LinkedEntityId == attachmentRecord.Id){
                        attachmentRecord.Attachments.add(new Attachment(Id=contentDocumentLinkRecord.ContentDocumentId, Name=contentDocumentLinkRecord.ContentDocument.Title));
                    }
                }
            }
            */
            /*
            integer jIndex = 1;
            seqNumList = new List<sequenceNumber>();
            
            
            Map<String, List<Attachment>> attMap = getAttachmentMapByType();
            System.debug('Map size is' + attMap.size());
            System.debug('Map is ' + attMap);
            Integer i = 0;
            for (String key : attMap.keySet()) {
                System.debug('key is ' + key);
                List<Attachment> atts = (List<Attachment>) attMap.get(key);
                System.debug('actual attachments are' + atts);
                System.debug('actual attachments size is' + atts.size());

                seqNumList.add(new sequenceNumber(i + 1, key, (List<Attachment>) attMap.get(key)));
                i++;                
                
            }
            getAndAddAttachmentMapByType();
            */
            /*for (integer i = 0; i < attachmentsList.size(); i++) {
                if(contentDocumentMap.containsKey(attachmentsList[i].Id)){
                    seqNumList.add(new sequenceNumber(jIndex, attachmentsList[i], contentDocumentMap.get(attachmentsList[i].Id)));
                    jIndex++;
                }
            }*/


        } catch (DMLException e) {
            System.debug('DMLException::::::::' + e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error uploading file'+e.getMessage()));
            Database.rollback(sp0);
            return null;
        } finally {

            attBody = null;// clears the viewstate
            attName = '';
            //att = new Attachment();

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

            //PageReference pdf = new PageReference('/AAAP/LOP_offerform1364?offerId=' + ofrID+'&sesid='+sesid); //Changes URL to '/PBS_LOP_NewOfferForm1364...' in URLRewriter Apex class
            PageReference pdf = new PageReference( '/PBS_LOP_NewOfferForm1364?offerId=' + ofrID+'&sesid='+sesid); //Changes URL to '/PBS_LOP_NewOfferForm1364...' in URLRewriter Apex class
            System.debug('*** pdfUrl-- ' + pdf.getUrl());
            PageReference pdf1 = new PageReference('/AAAP/LOP_offerform1217?offerId=' + ofrID+'&sesid='+sesid); //Changes URL to '/LOP_offerform1217...' in URLRewriter Apex class
            System.debug('\n--pdf1--');
            
            //Todd Brown removing logic that creates and sends Property Valuation doc to GREX for RSAP '22 Surge story SFWS-1896
            //PageReference pdf2 = new PageReference('/PBS_LOP_RSAPpv?offerId=' + ofrID);
            //System.debug('\n--pdf2--'+pdf2);
            
            offerattachment = new PBS_AAAP_Offer_Attachments__c();

            //Attachment att = new Attachment();
            //Attachment att1 = new Attachment();
            //Attachment att2 = new Attachment();

            try {
                offerattachment.PBS_AAAP_Offer__c = ofrID;
                Blob att1Body= null;
                Blob attBody= null;
                if (Test.isRunningTest()) {
                    attBody = Blob.valueOf('UNIT.TEST');
                    att1Body = Blob.valueOf('UNIT.TEST');
                    //att2.Body = Blob.valueOf('UNIT.TEST');
                } else {
                    attBody = pdf.getContentAsPDF();
                    att1Body = pdf1.getContentAsPDF();
                    //Blob b = pdf2.getContent();
                    //att2.Body = b;
                }
                offerattachment.PBS_AAAP_Attachment_Type__c = 'Offeror GSA Form 1364';

                //before inserting delete existing forms
                actionDeleteFormsAttachment();
                insert offerattachment;
                
               PBS_AAAP_Offer_Attachments__c offerattachment1 = new PBS_AAAP_Offer_Attachments__c();
                //att = new Attachment();

                //upload form 1217
                offerattachment1.PBS_AAAP_Offer__c = ofrID;
                offerattachment1.PBS_AAAP_Attachment_Type__c = 'Offeror Form 1217- Lessor\'s Annual Cost Statement';
                insert offerattachment1;
                system.debug('\n--offerattachment--'+offerattachment1);
                
                ContentVersion ContVerFile = new ContentVersion();
                ContVerFile.VersionData = attBody;//Blob.valueOf('string');
                ContVerFile.Title = 'Form1364.pdf'; 
                ContVerFile.PathOnClient= 'Form1364.pdf';
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
                
                //system.debug('\n--att1--'+att1);
                
                ContentVersion ContVerFile1 = new ContentVersion();
                ContVerFile1.VersionData = att1Body;//Blob.valueOf('string');
                ContVerFile1.Title = 'Form1217.pdf'; 
                ContVerFile1.PathOnClient= 'Form1217.pdf';
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
                
                //att1.Body = null;// clears the viewstate
                offerattachment = new PBS_AAAP_Offer_Attachments__c();
                //att1 = new Attachment();

                //offerattachment = new PBS_AAAP_Offer_Attachments__c();
                //offerattachment.PBS_AAAP_Offer__c = ofrID;
                //offerattachment.PBS_AAAP_Attachment_Type__c = 'Present Value Analysis (PVA) Evaluation';
                //insert offerattachment;

                //att2.Name = 'GeneratedPVCalculation.xml';
                //att2.ParentId = offerattachment.id;
                //insert att2;
                //att2.Body = null;// clears the viewstate
                //offerattachment = new PBS_AAAP_Offer_Attachments__c();
                //att2 = new Attachment();

                // updating new id
                Integer len = 5;
                String str = string.valueof(Math.abs(Crypto.getRandomLong()));
                string randomNumber = str.substring(0, len);

                // updating offer with new key
                updateOfferDetails();

                

            } catch (DMLException e) {
                System.debug('DMLException::::::::' + e);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error uploading file'));
            } finally {

                ///att.Body = null;// clears the viewstate
                //att = new Attachment();
                //att1.Body = null;// clears the viewstate
                //att1 = new Attachment();
                //att2.Body = null;// clears the viewstate
                //att2 = new Attachment();
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
                WHERE p.PBS_AAAP_Offer__c = :ofrID AND p.PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration')
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
        /*
        Map<String, List<Attachment>> attMap = getAttachmentMapByType();
        System.debug('Map size is' + attMap.size());
        System.debug('Map is ' + attMap);
        Integer i = 0;
        for (String key : attMap.keySet()) {
            System.debug('key is ' + key);
            List<Attachment> atts = (List<Attachment>) attMap.get(key);
            System.debug('actual attachments are' + atts);
            System.debug('actual attachments size is' + atts.size());

            seqNumList.add(new sequenceNumber(i + 1, key, (List<Attachment>) attMap.get(key)));
            i++;
        }
        */



        system.debug('%%%NIK%%%' + submitOffer);
        //PageReference pref = Page.PBS_LOP_Attachments;
        //PageReference pref = new PageReference('/RSAP/Attachments');
        //pref.getParameters().put('offerId', submitOffer.Id);
        //pref.setRedirect(true);

        return null;

    }

    public PageReference refreshForms2() {
        system.debug('**NIK**FINAL***');
        uploadForms();
        submitOffer.PBS_AAAP_Time_Offer_Submitted__c = system.now();
        submitOffer.PBS_AAAP_Offer_Status__c = 'Submitted';
        update submitOffer;
        //PageReference pref = Page.PBS_LOP_OfferSubmitConfirmation;
        PageReference pref = new PageReference('/RSAP/OfferSubmitConfirmation');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/OfferSubmitConfirmation', Label.LOP_Community_Base_URL+'RSAP-OfferSubmitConfirmation');
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
            //Attachment attToDelete = [SELECT id,parentid,name FROM Attachment WHERE id = :attachmentId];
            //String parentId = attToDelete.ParentId;
            PBS_AAAP_Offer_Attachments__c delOfrAtt = [SELECT id, name FROM PBS_AAAP_Offer_Attachments__c WHERE id = :attachmentId];
            //delete attToDelete;
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
            //return null;
        }

        //PageReference pref = Page.PBS_LOP_Attachments;
        PageReference pref = new PageReference('/RSAP/Attachments');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Attachments', Label.LOP_Community_Base_URL+'RSAP-Attachments');
        //return null;
    }

    public void actionDeleteFormsAttachment() {

        // TODO Delete Logic        
        System.debug('******* We are here inside deleteforms attachment::::::::::::::');

        try {
            List<PBS_AAAP_Offer_Attachments__c> delOfrAtt = [SELECT id, name FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Offeror GSA Form 1364', 'SAM Registration', 'Present Value Analysis (PVA) Evaluation') AND PBS_AAAP_Offer__c = :ofrID and PBS_AAAP_Sent_to_GREX__c != true];
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
            //return null;
        }


    }


    public PageReference actionCancel() {
        //PageReference pref = Page.PBS_LOP_PortalHome;
        PageReference pref = new PageReference('/RSAP/PortalHome');
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/PortalHome', Label.LOP_Community_Base_URL+'RSAP-PortalHome');
        return null;
    }

    public PageReference actionBackToRatesAndSpaces() {
        PageReference pref = new PageReference('/RSAP/PropertyOwner');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/PropertyOwner', Label.LOP_Community_Base_URL+'RSAP-PropertyOwner');
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
                pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Attachments', Label.LOP_Community_Base_URL+'RSAP-Attachments');
                p.setRedirect(false);
            } else {
                 p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                p.setRedirect(false);
              }  
              
       /* PageReference pref = new PageReference('/RSAP/Attachments');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Attachments', Label.LOP_Community_Base_URL+'RSAP-Attachments');*/
        return null;
    }


    public PageReference actionSaveAndSubmitOffer() {
        Boolean flag = PBS_AAAP_GlobalConstants.validateOfferSubmissionBefore(submitOffer);
        if (!flag || Test.isRunningTest()) {
            actionSavePage();
            //PageReference pref = Page.PBS_LOP_AttachmentAck;
            PageReference pref = new PageReference('/RSAP/AttachmentAck');
            pref.getParameters().put('offerId', submitOffer.Id);

            // J. Rogers 2/18/23  Communities Upgrade497394
            //pref.setRedirect(true);
            //return pref;
            pref.setRedirect(false);
            pageURLForRedirection = pref.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/RSAP/AttachmentAck', Label.LOP_Community_Base_URL+'RSAP-AttachmentAck');
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
            //ApexPages.addMessage(myMsg);
        }
        
        if (submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == TRUE) {
            rlpCheckBox = false;
        }

        system.debug('***NIK***'+submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c);
        system.debug('***NIK***'+rlpCheckBox);

        Boolean flag = PBS_AAAP_GlobalConstants.validateOfferSubmission(submitOffer, rlpCheckBox);
        system.debug('***NIK***Method Called' + flag);
        if ((!flag && !err) || Test.isRunningTest()) {

            //submitOffer.PBS_AAAP_Offer_Status__c = 'Submitted';
            
             submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c=rlpCheckBox !=null && rlpCheckBox ==true ? true : false;
           
            Date dToday = Date.today();
            Datetime dt = datetime.newInstance(dToday.year(), dToday.month(), dToday.day());
            submitOffer.PBS_AAAP_Offer_Submission_Date__c = dToday;
            update submitOffer;
            insertHistroy(submitOffer.Id);
            //refreshForms();
            //submitOffer.PBS_AAAP_Offer_Status__c = 'Submitted';
            //update submitOffer;
            //PageReference pref = Page.PBS_LOP_OfferSubmitConfirmation;
            //pref.getParameters().put('offerId', submitOffer.Id);
            //ref.setRedirect(true);
            //return null;
        } else {
            //return null;
        }

    }
    
    public void insertHistroy(string offerId){
        PBS_AAAP_Submission_Attempt_History__c historyRec = new PBS_AAAP_Submission_Attempt_History__c();
        historyRec.Date__c = system.now();
        historyRec.Offer__c = offerId;
        insert historyRec;
    }


    public PageReference actionCancelSubmitOffer() {
        //PageReference pref = Page.PBS_LOP_Attachments;sites
        PageReference pref = new PageReference('/RSAP/Attachments');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Attachments', Label.LOP_Community_Base_URL+'RSAP-Attachments');
        return null;
    }

    public PageReference redirectToHome() {
        //PageReference pref = Page.PBS_LOP_portalHome;
        PageReference pref = new PageReference('/RSAP/PortalHome');
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/PortalHome', Label.LOP_Community_Base_URL+'RSAP-PortalHome');
        return null;
    }

    public PageReference renderRLPSection() {
        System.debug('inside renderRLPSection');
        if (termsAndConditions == 'Yes') {
            rlpCheckBox = FALSE;
            showSection = FALSE;
            submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = TRUE;
        } else {
            showSection = TRUE;
            submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = FALSE;
        }
        update submitOffer;
        //PageReference pref = Page.PBS_LOP_AttachmentAck;
        //pref.getParameters().put('offerId', submitOffer.Id);
        //pref.setRedirect(true);
        return null;
    }

    public PageReference uploadFormsOnFinalSubmit() {
        Boolean err = FALSE;
        if(termsAndConditions == NULL ){
            err = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You must confirm you have read the RLP and declare your deviation intentions.'));
            //ApexPages.addMessage(myMsg);
        }
        if (submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == TRUE) {
            rlpCheckBox = true;
        }
        Boolean flag = PBS_AAAP_GlobalConstants.validateOfferSubmission(submitOffer, rlpCheckBox);
        if ((!flag && !err) || Test.isRunningTest()) {

            uploadForms();
            //PageReference pref = Page.PBS_LOP_OfferSubmitConfirmation;
            PageReference pref = new PageReference('/RSAP/OfferSubmitConfirmation');
            pref.getParameters().put('offerId', submitOffer.Id);
            pref.setRedirect(false);
            pageURLForRedirection = pref.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/RSAP/OfferSubmitConfirmation', Label.LOP_Community_Base_URL+'RSAP-OfferSubmitConfirmation');
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
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/PortalHome', Label.LOP_Community_Base_URL+'RSAP-PortalHome');
        
    }

}