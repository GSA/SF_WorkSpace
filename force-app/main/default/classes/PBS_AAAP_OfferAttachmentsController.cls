//This Controller Class was updated by Henry Dennis on 7/5/22 

public without sharing class PBS_AAAP_OfferAttachmentsController {

    public PBS_AAAP_Offer_Attachments__c offerattachment { get; set; }
    public List<PBS_AAAP_Offer_Attachments__c> attachmentsList { get; set; }
    //public List<Attachment> attList { get; set; }
    //public Attachment att { get; set; }
    public String attName{ get; set; }
    public Blob attBody{ get; set; }
    public ID ofrID { get; set; }
    public boolean showAttachmentsPage { get; set; }
    public PBS_AAAP_Offer__c submitOffer { get; set; }
    public PBS_AAAP_Offer__c submitedOffer { get; set; } // Vaishali 01/11/2016
    public List<sequenceNumber> seqNumList { get; set; }
    public boolean showSubmitOfferButton { get; set; }
    //   public    boolean showStep2                                                                 {get;set;}
    public PBS_AAAP_RLP__c rlpInfo { get; set; }
    public PBS_AAAP_RLP__c rlpRegion2 { get; set; }
    public string termsandconditons { get; set; }
    public string submissionDate { get; set; }
    public string DateSubmitted { get; set; }  //Vaishali 01/11/2016
    public date rlpPostDate { get; set; }
    public String attachmentId { get; set; }
    public Boolean isValidUser { get; set; }
    // public String buildingPageAddrFlag                        {get;set;}
    public String addrFlag { get; set; }
    public String draftMsgFlag { get; set; }
    public Boolean offerSubmitFlag { get; set; }
    public String spaceIdToReport { get; set; }
    private PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
    public String regionCode { get; set; }
    public List<PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails> details { get; set; }
    public List<PBS_AAAP_Space__c> spaces { get; set; }         // spaces
    public List<PBS_AAAP_Rate__c> rates { get; set; }         // rate
    static final String GSADEFAULT = '';             // default value for Expiring GSA Lease Number
    public String leaseDefault { get {return PBS_AAAP_OfferAttachmentsController.GSADEFAULT;} }       // default expiring lease
    public String leaseTerm10_5Header { get; set; }     // leaseTerm10_5=true then 10,5; else 5+5
    public String leaseTerm15_10Header { get; set; }     // rlpGT2016=true then 15,10; else 5
    public Boolean offerFY { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String pageUrl{get;set;}
    public string pageURLForRedirection {get;set;}
    
    public boolean submitOffererror {get;set;}

    public map<string,List<sequenceNumber3>> mapType_attachment {get;set;}
    public map<string,List<string>> mapType_attachmentDate {get;set;}
    public List<PBS_AAAP_Offer_Attachments__c> attachmentsList2 { get; set; }
    public List<PBS_AAAP_Offer_Attachments__c> formAttachmentsList2 { get; set; }
    public List<sequenceNumber2> seqNumList2 { get; set; }
    public List<sequenceNumber2> formSeqNumList2 { get; set; }
    public List<sequenceNumber> existingAttachmentRecords { get; set; }
    public boolean displayattachment {get;set;}

    public PBS_AAAP_OfferAttachmentsController() {

        submitOffererror = false;
        //attList = new List<Attachment>();
        rlpRegion2 = new PBS_AAAP_RLP__c();
        //leaseDefault ='';
        leaseTerm10_5Header = '15, 13 YEAR FS';
        leaseTerm15_10Header = '17, 15 YEAR FS';
        showAttachmentsPage = true;
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {

            ofrID = ApexPages.currentPage().getParameters().get('offerId');
            Cookie offerIdCookie = new Cookie('offerId',ofrID,null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{offerIdCookie});
            // buildingPageAddrFlag = ApexPages.currentPage().getParameters().get('addrFlag');
            submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
            submitedOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID); //Vaishali 01/11/2016   
            DateTime dtLM = submitedOffer.LastModifiedDate;
            Date modDate = dtLM.date();
            Date checkDate = date.valueOf('2017-09-25');
            if (modDate > checkDate) { offerFY = false; } else { offerFY = true; }
            firstName = submitedOffer.PBS_AAAP_Signature_First_Name__c;
            lastName = submitedOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c;
            system.debug('First Name ' + firstName);
            system.debug('Last Name ' + lastName);
            //added by syam for offerId validation
     // }
            // Arvind changes 
            spaces = dao.getSpaces(ofrID);
            rates = dao.getRates(ofrID);
            if (spaces.size() > 0) {
                PBS_AAAP_ControllerSpacesAndRates spaceRates = new PBS_AAAP_ControllerSpacesAndRates();
                details = spaceRates.spaceSort(spaces, rates);
                regionCode = spaceRates.regionCode;
                System.debug('***** details: ' + details);
            } // end if

            // Arvind  changes 

            string userType = UserInfo.getUserType(); //vss 01/11/2016
            if (userType.contains('Portal')) {
                submitOffer.PBS_AAAP_Signature_First_Name__c = UserInfo.getFirstName();
                submitOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = UserInfo.getLastName();
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
            //submitOffer.PBS_AAAP_Signature_First_Name__c = UserInfo.getFirstName();            
            //submitOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = UserInfo.getLastName();
            offerSubmitFlag = true;
            if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
                offerSubmitFlag = false;
            }
            // User has to always accept the terms & Conditions before submitting the Offer each time.
            system.debug('$$$$$$' + ApexPages.currentPage().getUrl());
            String pgURL = '';
            pgURL = ApexPages.currentPage().getUrl();
            system.debug('$$$$$$' + pgURL);
            if (pgURL.contains('pbs_aaap_offeracknowledgment')) {
                system.debug('$$$$$');
                submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
                submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
                termsandconditons = 'Yes';
            } else {
                termsandconditons = 'No';
                submitOffer.PBS_AAAP_SIGNATURE_PIN__c = null;
                submitOffer.PBS_AAAP_FIRE_SAFETY_CERT__c = 'No';
                submitOffer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c = 'No';
                submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'No';
                submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'No';
                submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'No';
                submitOffer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c = 'No';
                submitOffer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c = 'No';
                submitOffer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c = 'No';
                submitOffer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c = 'No';
            }
            /*SFWS-783 changes start - Setting the submission date and making radio buttons to yes when the offer is submitted */
            if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED || 
                submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED || 
                submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED ||
                submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED){
                termsandconditons = 'Yes';
                submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c = 'Yes';
                submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'Yes';
                if(submitOffer.PBS_AAAP_Offer_Submission_Date__c != null){
                     submissionDate = submitOffer.PBS_AAAP_Offer_Submission_Date__c.month() + '/' + submitOffer.PBS_AAAP_Offer_Submission_Date__c.day() + '/' + submitOffer.PBS_AAAP_Offer_Submission_Date__c.year();
                }
            }
            /*SFWS-783 changes end*/

            system.debug('***************offer ID in Constructor:' + ofrID);
            offerattachment = new PBS_AAAP_Offer_Attachments__c();
            //att = new Attachment();

            // logic for displaying the attachments on the vf page.
            attachmentsList = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, /*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/
                    PBS_AAAP_Date_sent_to_GREX__c, PBS_AAAP_Sent_to_GREX__c
                FROM PBS_AAAP_Offer_Attachments__c p	
                    WHERE p.PBS_AAAP_Offer__c = :ofrID
                    AND p.PBS_AAAP_Attachment_Type__c != 'Offeror Form 1217- Lessors Annual Cost Statement'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Offeror Form 1217- Lessor\'s Annual Cost Statement'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Offeror GSA Form 1364'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Form 1364 AAAP'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Lessors Annual Cost Statement (Form 1217)'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Lessors Annual Cost Statement (Form 1217 attachment)'
            ];
            System.debug('::::::::::: Attachments List ::::::::::: ' + attachmentsList);
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
            existingAttachmentRecords= new List<sequenceNumber>();
            integer jIndex = 1;
            for (integer i = 0; i < attachmentsList.size(); i++) {
                if(contentDocumentMap.containsKey(attachmentsList[i].Id)){
                    if(attachmentsList[i].PBS_AAAP_Sent_to_GREX__c == FALSE){
                        seqNumList.add(new sequenceNumber(jIndex, attachmentsList[i], contentDocumentMap.get(attachmentsList[i].Id)));
                        jIndex++;
                    }
                }
            }
             jIndex = 1;
            for (integer i = 0; i < attachmentsList.size(); i++) {
                if(contentDocumentMap.containsKey(attachmentsList[i].Id)){
                    if(attachmentsList[i].PBS_AAAP_Sent_to_GREX__c == TRUE){
                        existingAttachmentRecords.add(new sequenceNumber(jIndex, attachmentsList[i], contentDocumentMap.get(attachmentsList[i].Id)));
                        jIndex++;
                    }
                }
            }

            // logic to diaplay "Submit Offer" Button on VF Page by pulling SFO information start and end dates on the Attachments Page.
            rlpPostDate = submitOffer.PBS_AAAP_RLP_Number__r.PBS_AAAP_Posted_Date__c; //RLP FY15 Vaishali
            Date dt = Date.today();
            Date dt1 = submitedOffer.PBS_AAAP_Offer_Submission_Date__c; 
            System.debug('dt1 before format is ' + dt1);
            if (dt1 == null) { DateSubmitted = ''; } else { DateSubmitted = dt1.format(); }

            integer day = dt.day();
            integer startRLPDay = integer.valueOf(submitOffer.PBS_AAAP_Default_Start__c);
            integer endRLPDay = integer.valueOf(submitOffer.PBS_AAAP_Default_End__c);

            system.debug('**********************');
            system.debug('******Date:' + dt);
            system.debug('*******dt.format:' + dt.format());
            system.debug('*******date.newInstance(dt.year(), dt.month(), dt.day()):' + date.newInstance(dt.year(), dt.month(), dt.day()));
            system.debug('*******date.newInstance(dt.year(), dt.month(), endRLPDay):' + date.newInstance(dt.year(), dt.month(), endRLPDay));
            system.debug('*******dt.isSameDay:' + dt.isSameDay(date.newInstance(dt.year(), dt.month(), dt.day())));
            system.debug('**********************');
            
            Boolean isValidOffer = PBS_AAAP_GlobalConstants.checkOfferIsValidOrNot(submitOffer);
            if(isValidOffer){ showSubmitOfferButton = true; submissionDate = dt.month() + '/' + dt.day() + '/' + dt.year(); }

            /*********************/
            attachmentsList2 = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c, /*(SELECT Id, Name, Description, ParentId, createdDate FROM Attachments),*/createdDate
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID //AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Offeror Form 1217- Lessors Annual Cost Statement', 'Form 1364 AAAP', 'SAM Registration')
                    AND PBS_AAAP_Sent_to_GREX__c = TRUE
                    AND p.PBS_AAAP_Attachment_Type__c NOT IN ('Lessor\'s Annual Cost Statement (Form 1217)', 'Lessor\'s Annual Cost Statement (Form 1217 attachment)', 'Form 1364 AAAP', 'Offeror GSA Form 1364', 'Offeror Form 1217- Lessor\'s Annual Cost Statement', 'Lessors Annual Cost Statement (Form 1217)', 'Lessors Annual Cost Statement (Form 1217 attachment)')
            ];
            system.debug('***DATE***' + attachmentsList2);

            formAttachmentsList2 = [
                    SELECT Id, Name, PBS_AAAP_Attachment_Type__c, PBS_AAAP_Date_sent_to_GREX__c,Submitted_Date__c/*, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)*/
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID //AND p.PBS_AAAP_Attachment_Type__c IN ('Offeror Form 1217- Lessors Annual Cost Statement', 'Form 1364 AAAP', 'SAM Registration')
                    AND PBS_AAAP_Sent_to_GREX__c = TRUE
            ];
            formSeqNumList2 = new List<sequenceNumber2>();
            seqNumList2 = new List<sequenceNumber2>();
            for (integer j = 0; j < formAttachmentsList2.size(); j++) {formSeqNumList2.add(new sequenceNumber2(j + 1, formAttachmentsList2[j])); }

            Map<String, List<Attachment>> attMap2 = getAttachmentMapByType2();
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
            mapType_attachment = new map<string, List<sequenceNumber3>>();
            mapType_attachmentDate = new map<string, List<string>>();
			attOfferIds = new List<Id>();
            contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : attachmentsList2){
                attOfferIds.add(attachmentRecord.Id);
            }
            if(attOfferIds.size() > 0){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocumentId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
                }
            }
            
            // for each record
            for (PBS_AAAP_Offer_Attachments__c attachment : attachmentsList2) {

                if (attachment.PBS_AAAP_Attachment_Type__c != 'Present Value Analysis (PVA) Evaluation') {
                    List<sequenceNumber3> lstTemp = new List<sequenceNumber3>();

                    // if map already have the type
                    if (mapType_attachment.containsKey(attachment.PBS_AAAP_Attachment_Type__c)) { lstTemp.addAll(mapType_attachment.get(attachment.PBS_AAAP_Attachment_Type__c)); }

                    // adding current record
                    if(contentDocumentMap.containsKey(attachment.Id)){
                    	lstTemp.add(new sequenceNumber3(attachment, contentDocumentMap.get(attachment.Id)));
                    }

                    // updating map
                    mapType_attachment.put(attachment.PBS_AAAP_Attachment_Type__c, lstTemp);
                    displayattachment = true;
                }
            }
            system.debug('\n--mapType_attachment--' + mapType_attachment + '\n--mapType_attachmentDate--' + mapType_attachmentDate);

            /********************/
        }

    }
    public Map<String,List<sequenceNumber>> getPreviousSubmissionAttachmentsMap(){
        Map<String,List<sequenceNumber>> previousSubmissionAttachmentRecords = new Map<String,List<sequenceNumber>>();
        for(sequenceNumber attRecord : existingAttachmentRecords){
            List<sequenceNumber> sequenceNumberRecords = new List<sequenceNumber>();
            if(previousSubmissionAttachmentRecords.containsKey(attRecord.offratts.PBS_AAAP_Attachment_Type__c)){
                sequenceNumberRecords = previousSubmissionAttachmentRecords.get(attRecord.offratts.PBS_AAAP_Attachment_Type__c);
            }
            sequenceNumberRecords.add(attRecord);
            previousSubmissionAttachmentRecords.put(attRecord.offratts.PBS_AAAP_Attachment_Type__c, sequenceNumberRecords);
        }
        return previousSubmissionAttachmentRecords;
    }
    public class sequenceNumber {
        public integer i { get; set; }
        public PBS_AAAP_Offer_Attachments__c offratts { get; set; }
        public ContentDocumentWrapper file { get; set; }

        public sequenceNumber(integer j, PBS_AAAP_Offer_Attachments__c att, ContentDocumentWrapper file) {
            i = j; 
            offratts = att;
            this.file = file;
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
    public PageReference uploadAdditional() {
        UploadCode(false);
        return null;
    }

    public PageReference upload() {
        uploadAttachment();
        return null;
    }
    public PageReference uploadAttachment() {
        return UploadCode(true);
    }
    
    public pagereference UploadCode(boolean addSuccessMessage){

        Savepoint sp0 = Database.setSavepoint();

        // saving the offer ids for which attachment ahs to be inserted
        set<string> setChildOffers = new set<string>();

        // this will save the list of ofer attachments to be insert
        List<PBS_AAAP_Offer_Attachments__c> lstOfferAtt = new List<PBS_AAAP_Offer_Attachments__c>();

        // this will save the list if attachment to be inserted
        //List<attachment> lstInsertAtt = new List<attachment>();

        // getting all child offer ids
        for(PBS_AAAP_Offer__c childoffer : [SELECT ID FROM PBS_AAAP_Offer__c WHERE Master_Offer__c =: ofrID]){
            lstOfferAtt.add(new PBS_AAAP_Offer_Attachments__c(PBS_AAAP_Offer__c = childoffer.Id, PBS_AAAP_Attachment_Type__c = offerattachment.PBS_AAAP_Attachment_Type__c));
        }

        attachmentsList = null;
        offerattachment.PBS_AAAP_Offer__c = ofrID;

        System.debug('Attachment Type:::::::::::::: ' + offerattachment.PBS_AAAP_Attachment_Type__c);
        //system.debug('Attachment Attached :::::::::::: ' + attBody);
        if (offerattachment.PBS_AAAP_Attachment_Type__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Attachment Type is required.'));
            attBody = null;
            return null;
        }

        if (offerattachment.PBS_AAAP_Attachment_Type__c == 'Other') {
            if (offerAttachment.Document_Description__c == null ||
                offerAttachment.Document_Description__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Other description is required for Attachment Type "Other".'));
                attBody = null;
                return null;
            }
        } else {
            offerAttachment.Document_Description__c = null;
        }
    
        if (attBody == null || attName == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Attachment is missing.'));
            return null;
        }
        try {

            // insert offer attachments
            insert offerattachment; //parent
            if(!lstOfferAtt.isEmpty()) insert lstOfferAtt; // child offer
            //System.debug('After Attachment Type:::::::::::::: '+offerattachment.id);

            //att.ParentId = offerattachment.id;
            // creating new instance of attachments	
            /*for(PBS_AAAP_Offer_Attachments__c offAtt : lstOfferAtt){	
                lstInsertAtt.add(new attachment(parentId = offAtt.Id, body = att.Body, name = att.Name));	
            }*/
            
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
            //Changes by Santhosh
            if(!lstOfferAtt.isEmpty()){
                List<ContentDocumentLink> contentDocumentLinkRecords = new List<ContentDocumentLink>();
                for(PBS_AAAP_Offer_Attachments__c offerAttachmentRecord : lstOfferAtt){
                    ContentDocumentLink cDe1 = new ContentDocumentLink();
                    cDe1.ContentDocumentId = conDoc;
                    cDe1.LinkedEntityId = offerAttachmentRecord.id;
                    cDe1.ShareType = 'V';
                    cDe1.Visibility = 'AllUsers';
                    contentDocumentLinkRecords.add(cDe1);
                }
                if(!contentDocumentLinkRecords.isEmpty()){
                    insert contentDocumentLinkRecords;
                }
            }
            //Changes by Santhosh   
            
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
            //insert att; // parent	
            /*if(!lstInsertAtt.isEmpty())	
                insert lstInsertAtt;*/ // child

            attBody = null;// clears the viewstate
            offerattachment = new PBS_AAAP_Offer_Attachments__c();
            attName = '';
            //att = new Attachment();
            // logic for displaying the attachments on the vf page.
            attachmentsList = [
                    SELECT Name, PBS_AAAP_Attachment_Type__c
                    FROM PBS_AAAP_Offer_Attachments__c p
                    WHERE p.PBS_AAAP_Offer__c = :ofrID
                    AND p.PBS_AAAP_Attachment_Type__c != 'Offeror Form 1217- Lessors Annual Cost Statement'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Offeror Form 1217- Lessor\'s Annual Cost Statement'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Offeror GSA Form 1364'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Form 1364 AAAP'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Lessors Annual Cost Statement (Form 1217)'
                    AND p.PBS_AAAP_Attachment_Type__c != 'Lessors Annual Cost Statement (Form 1217 attachment)'
                    AND PBS_AAAP_Sent_to_GREX__c = FALSE
                    ORDER BY p.CreatedDate
            ];
            List<Id> attOfferIds = new List<Id>();
            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : attachmentsList){
                attOfferIds.add(attachmentRecord.Id);
            }
            
            List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
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
            integer jIndex = 1;
            seqNumList = new List<sequenceNumber>();
            for (integer i = 0; i < attachmentsList.size(); i++) {
                if(contentDocumentMap.containsKey(attachmentsList[i].Id)){
                	seqNumList.add(new sequenceNumber(jIndex, attachmentsList[i], contentDocumentMap.get(attachmentsList[i].Id)));
                    jIndex++;
                }
            }

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
        
        if(addSuccessMessage) ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'File uploaded successfully'));
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
        System.debug('******* We are here::::::::::::::');
        System.debug('******* AttachmentsId::::::::::::::' + attachmentId);
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
            //return null;
        }

        //PageReference pref = Page.PBS_AAAP_OfferAttachments;
        PageReference pref = new PageReference('/AAAP/OfferAttachments');
        pref.getParameters().put('offerId', submitOffer.Id);
                //pageURLForRedirection = pref.getUrl();
        //pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferAttachments', Label.LOP_Community_Base_URL+'AAAP-OfferAttachments');
        
        //pref.setRedirect(true);
       // return pref;
    }

    public void actionDeleteAttachmentAdditional() {

        // TODO Delete Logic
        System.debug('******* We are here::::::::::::::');
        System.debug('******* AttachmentsId::::::::::::::' + attachmentId);
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
            
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            //return null;
        }

        //PageReference pref = Page.PBS_AAAP_OfferAttachments;
        PageReference pref = new PageReference('/AAAP/AdditionalAttachments');
        pref.getParameters().put('offerId', submitOffer.Id);
        //pref.setRedirect(true);
        //pageURLForRedirection = pref.getUrl();
        //pageURLForRedirection = pageURLForRedirection.replace('/AAAP/AdditionalAttachments', Label.LOP_Community_Base_URL+'AAAP-OfferAttachments');
        
        //return pref;
    }

    public void actionCancelSubmitOffer() {
        showAttachmentsPage = true;
    }

    public PageReference actionCancel() {
        //PageReference pref = Page.PBS_AAAP_PortalHome;
        PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/PortalHome', Label.LOP_Community_Base_URL+'AAAP-PortalHome');
        return null;
    }

    public boolean checkOfferSubmissionValidations() {
        attachmentsList = null; //Nik - 1/29
        boolean flag;
        system.debug('----NIKILESH1---'+termsandconditons);
        if (termsandconditons != 'Yes') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '1. You must acknowledge that you have read the RLP, lease and all the attachments in their entirety and are requesting no deviations.'));
            flag = true;
        }
        /* if(submitOffer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c != 'Yes'){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept solicitation provisions.'));
             flag=true;
         }
         if(submitOffer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c != 'Yes'){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept general clauses.'));
             flag=true;
         }
         if(submitOffer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c != 'Yes'){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept Representations and Certifications.'));
             flag=true;
         } */

        if (submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c != 'Yes') {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '2. You must acknowledge that you may be required to provide further due diligence submittals in order for your offer to be considered eligible for award.'));
            /* ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept that you are authorized by the owner to submit this offer and negotiate on their behalf.'));
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to certify that the Fire Safety Certificate attached is genuine and complete.'));
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept that you are aware of the Fire & Safety inspection needs to be certified by a fire engineer for floors 6 and above.'));
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot submit the offer if you are not authorized by the owner to represent other owners.'));*/
            flag = true;
        }

        if (submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c != 'Yes') {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '3. You must acknowledge that you are aware that, in addition to generic specifications and requirements outlined in the RLP and attachments, there may be unique agency requirements, as identified in a project specific advertisement posted on SAM.gov, that shall be used in evaluating and determining the eligibility of offers for award.'));
            /* ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept solicitation provisions.'));
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept general clauses.'));
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept eligibility of offers for award as posted on fbo.gov'));*/
            flag = true;
        }

        /* if(submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c == 'Yes' && submitOffer.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c != 'Yes'){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot submit the offer if you are not authorized by the owner to represent other owners.'));
             flag=true;
         } */
        /* if(submitOffer.PBS_AAAP_FIRE_SAFETY_CERT__c != 'Yes'){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to certify that the Fire Safety Certificate attached is genuine and complete.'));
             flag=true;
         }

         if(submitOffer.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c != 'Yes'){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Have to accept that you are aware of the Fire & Safety inspection needs to be certified by a fire engineer for floors 6 and above.'));
             flag=true;
         } */
        //added by syamganna on 06/24/2016 for latitude and langitude validations
        if (submitOffer.PBS_AAAP_X_CO_ORD__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PBS_AAAP_X_CO_ORD_REQ));
            flag = true;
        }
        if (submitOffer.PBS_AAAP_Y_CO_ORD__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PBS_AAAP_Y_CO_ORD_REQ));
            flag = true;
        }

        /*if(submitOffer.PBS_AAAP_SIGNATURE_PIN__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Signature - PIN field is missing'));
            flag=true;
        }*/
        Boolean floorPlanFlag = false;
        //Nik - 1/29
        attachmentsList = [
                SELECT Name, PBS_AAAP_Attachment_Type__c
                FROM PBS_AAAP_Offer_Attachments__c p
                WHERE p.PBS_AAAP_Offer__c = :ofrID
                ORDER BY p.CreatedDate
        ];
        System.debug('**** attachmentsList size is  ' + attachmentsList.size());
        System.debug('**** attachmentsList  ' + attachmentsList);
        for (integer i = 0; i < attachmentsList.size(); i++) {
            PBS_AAAP_Offer_Attachments__c attachmentFP = attachmentsList.get(i);
            System.debug('**** attachmentsList Type is  ' + attachmentFP.PBS_AAAP_Attachment_Type__c);
            if (attachmentFP.PBS_AAAP_Attachment_Type__c == 'Floor Plan') {
                floorPlanFlag = true;
            }
        }

        if (floorPlanFlag == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '  attachment for the offered space is missing'));
            flag = true;
        }

        return flag;
    }



    public PageReference actionCheckErrors() {
        boolean buildingFlag = PBS_AAAP_GlobalConstants.checkOfferBuildingValidations(submitOffer);

        boolean parkingFlag = PBS_AAAP_GlobalConstants.checkOfferParkingValidations(submitOffer);

        boolean propertyOwnerFlag = PBS_AAAP_GlobalConstants.checkOfferPropOwnerValidations(submitOffer);

        boolean RepsAndCertsFlag = PBS_AAAP_GlobalConstants.checkOfferRepsAndCertsValidations(submitOffer);

        boolean operatingCostsFlag = PBS_AAAP_GlobalConstants.checkOperatingCostsValidations(submitOffer);
        boolean noSpaceOrRatesFlag = false;
        //added by syam on 07/19/2016 to check pv
        boolean pvFlag = dao.validatePVRates(submitOffer.Id);

        attachmentsList = null; //Nik - 1/29

        boolean spaceAndRatesFlag = false ;
        system.debug('***************actionCheckErrors:');
        List<PBS_AAAP_Space__c> spaces = new List<PBS_AAAP_Space__c>();
        List<PBS_AAAP_Rate__c> rates = new List<PBS_AAAP_Rate__c>();
        List<ID> spaceId = new List<ID>();
        boolean flag = false;
        boolean BSACflag = false;
        boolean optionTermFlag = false;  //vss RLP FY15 O&M1
        boolean FY15RateSaveFlag = false;
        if (submitOffer.id != null) {
            spaces = [SELECT id, PBS_AAAP_IDENTIFIER_ID__C, name,LASTMODIFIEDDATE FROM PBS_AAAP_Space__c WHERE PBS_AAAP_OFFER_NUMBER__c = :submitOffer.Id];

            for (PBS_AAAP_Space__c s : spaces) {
                spaceId.add(s.id);
            }
            rates = [
                    SELECT id, PBS_AAAP_SPACE__c
                    FROM PBS_AAAP_Rate__c
                    WHERE PBS_AAAP_SPACE__c IN :spaceId
            ];
            Map<id, PBS_AAAP_Rate__c> ratesMap = new Map<id, PBS_AAAP_Rate__c>();
            for (PBS_AAAP_Rate__c r : rates) {
                ratesMap.put(r.PBS_AAAP_SPACE__c, r);
            }

            if (spaces.size() <= 0) {
                noSpaceOrRatesFlag = true;
            } else {
                for (PBS_AAAP_Space__c s : spaces) {
                    //added next line by Vaishali to fix BSAC issue
                    /**rates = [Select id, PBS_AAAP_SPACE__c, PBS_AAAP_BSAC__c from PBS_AAAP_Rate__c
                                              where PBS_AAAP_SPACE__c = :s.Id and PBS_AAAP_FULLY_SRVC_FIRM_TERM__c >0]; **/
                    //added next line by Vaishali to manage RLP FY15 calculations for past draft offers
                    rates = [
                            SELECT id, PBS_AAAP_SPACE__c, PBS_AAAP_BSAC__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, LASTMODIFIEDDATE,PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,PBS_AAAP_LEASE_TERM__c
                            FROM PBS_AAAP_Rate__c
                            WHERE PBS_AAAP_SPACE__c = :s.Id AND PBS_AAAP_FULLY_SRVC_FIRM_TERM__c > 0
                    ];
                    //if(rates.size() <= 0){
                    //    noSpaceOrRatesFlag=true;
                    // }
                    if (!ratesMap.containsKey(s.id)) { noSpaceOrRatesFlag = true; break; }
                    //Added by lekha to fix the checkmark security issues ends
                    //Added by Vaishali to fix BSAc issue 04/02/2014
                    else {

                        system.debug('***************Out Rates Routine:');
                        for (PBS_AAAP_Rate__c r : rates) {
                            system.debug('***************In Rates Routine:');
                            if ((r.PBS_AAAP_BSAC__c == null)) {
                                BSACflag = true;
                                spaceIdToReport = s.PBS_AAAP_IDENTIFIER_ID__c;
                                break;
                            }
                            system.debug('**********syam*****In Rates Routine:Checking Last Modified Date' + r.LASTMODIFIEDDATE);
                            system.debug('*********syam******In Rates Routine:Checking Posted Date' + submitOffer.PBS_AAAP_RLP_Number__r.PBS_AAAP_Posted_Date__c);
                            system.debug('*********syam******In offer last modified Date' + submitOffer.LastModifiedDate);
                            system.debug('*********syam******In space last modified Date' + s.LastModifiedDate);
                            double ratesABOA = (r.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c).setScale(2);
                            double offerABOA = (submitOffer.PBS_AAAP_COST_PER_ABOA__c).setScale(2);
                            system.debug('***rates  PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c ' + ratesABOA);
                            system.debug('***offer  PBS_AAAP_COST_PER_ABOA__c ' + offerABOA);
                            //removed following condition by syam on 07/14  || (r.LASTMODIFIEDDATE < s.LastModifiedDate)
                            /* commented by syam on 07/19/2016 no need of FY15RateSaveFlag, pvFlag covers it
                            if (ratesABOA != offerABOA){
                                 FY15RateSaveFlag = true;
                                 break;}*/
                            if (r.LASTMODIFIEDDATE <= submitOffer.PBS_AAAP_RLP_Number__r.PBS_AAAP_Posted_Date__c) {
                                spaceAndRatesFlag = true;
                                break;
                            }
                            system.debug('***************In Rates Routine:Checking PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c' + r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c);
                            if ((r.PBS_AAAP_LEASE_TERM__c == '5+5 Years') && ((r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c) == null || (r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c) == 0)) {
                                optionTermFlag = true;
                                spaceIdToReport = s.PBS_AAAP_IDENTIFIER_ID__c;
                                break;
                            }
                        }
                        //Added by Vaishali to fix BSAc issue End 04/02/2014 & RLP FY15 and new RLP calculation force
                    }

                }
            }
        }
        //        boolean spaceAndRatesFlag =flag;
        //        if (BSACflag  == true || optionTermFlag == true || FY15RateSaveFlag  == true) {spaceAndRatesFlag = true;}
        //        if (optionTermFlag  == true) {spaceAndRatesFlag = BSACflag;}
        //        if (FY15RateSaveFlag  == true) {spaceAndRatesFlag = FY15RateSaveFlag;}
        if (flag) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You must submit at least one space. For each submitted space, you must submit rate for at least one lease term.'));// Vaishali 07/19/16 added new message
        }
        if (spaceAndRatesFlag == true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Required data is missing in the \'Space & Rates\' section.  Please select and \'Edit\' each of the individual Space breakouts and look for required fields that are blank or have values that are not logical.  Pressing the \'Save\' button at the bottom of each page will identify possible mistakes on the page.'
            ));// Vaishali 07/19/16 removed present value from message
            //return null;
        }
        //added by syam
        if (operatingCostsFlag == true) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Operating Costs Page : 4. Cost per ABOA SF must be > 0.00'); //Vaishali 07/19/16 0.005 changed to 0.00
            Apexpages.addMessage(myMsg);
        }

        //boolean attachmentsFlag = PBS_AAAP_GlobalConstants.checkOfferAttachmentValidations(submitOffer);


        rlpInfo = dao.getRLP(submitOffer.PBS_AAAP_RLP_Number__c);
        regionCode = rlpInfo.PBS_AAAP_Region__c;

        if (regionCode == 'Census') { BSACflag = false; }
        if (BSACflag == true) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Space and Rates page is not complete.'));
            ////add " for Space # S.PBS_AAAP_IDENTIFIER_ID__C"  after "BSAC option (#4 /4a on rates page) is not complete" Vaishali ***
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'BSAC option (#3 /3b on rates page) is not complete for Space # ' + spaceIdToReport + '. Review and hit "Save Rates" button before submitting.'));
            //return null;
        }
        if (optionTermFlag == true) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Space and Rates page is not complete.'));
            //////add "For Space # S.PBS_AAAP_IDENTIFIER_ID__C"  before "Enter" Vaishali ***
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'For Space # ' + spaceIdToReport + ' Enter Base Rate per ANSI/BOMA Office Area square foot (ABOA) for years 6-10. If Base rate is unchanged from years 1-5, enter base rate amount from #1 above'));
            //return null;
        }
        if ((pvFlag) && (!(spaceAndRatesFlag))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Before submitting, go back to Operating Cost page and review and save; review Full Service Rent on Space and Rates page.'));
            //return null;
        }
        //added by syam on 07/19/2016
        /*if(pvFlag == true){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Your Operating Cost changed. Please go back to Operating Cost page, hit save & continue, review Full Service Rate on Space and Rates page before submitting.'));
               //return null;
            }
*/
        List<PBS_AAAP_Offer_Attachments__c> ofratts = new List<PBS_AAAP_Offer_Attachments__c>();
        boolean flag2;
        if (submitOffer.id != null) {
            ofrAtts = [SELECT id, name FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :submitOffer.Id];
            if (ofrAtts.size() <= 0) { flag2 = true; }
        }
        boolean attachmentsFlag = flag2;

        if (attachmentsFlag == true) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offer Attachments are missing.'));
            //return null;
        }
        Boolean floorPlanFlag = false;
        Boolean authorizationOfOwner = false;

        //Nik - 1/29
        attachmentsList = [
                SELECT Name, PBS_AAAP_Attachment_Type__c
                FROM PBS_AAAP_Offer_Attachments__c p
                WHERE p.PBS_AAAP_Offer__c = :ofrID
                ORDER BY p.CreatedDate
        ];

        System.debug('***** attachmentsList size is  ' + attachmentsList.size());
        for (integer i = 0; i < attachmentsList.size(); i++) {
            PBS_AAAP_Offer_Attachments__c attachmentFP = attachmentsList.get(i);
            System.debug('**** attachmentsList Type is  ' + attachmentFP.PBS_AAAP_Attachment_Type__c);
            if (attachmentFP.PBS_AAAP_Attachment_Type__c == 'Floor Plan') {
                floorPlanFlag = true;
            }
            if (attachmentFP.PBS_AAAP_Attachment_Type__c == 'Authorization to Represent Ownership Entity') ////////////////////// wes
            {
                authorizationOfOwner = true;
            }
        }
        if (floorPlanFlag == false) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    'Additional Action Required: The required Floor Plan document is missing.  Please choose the “Floor Plan” document type from the "Step 1" drop-down box and upload all relevant documentation (Steps 2 & 3).'));
            flag = true;
        }

        if (submitOffer.PBS_AAAP_OFFEROR_INTEREST__c != 'Owner' && authorizationOfOwner == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    'Additional Action Required: The Authorization to Represent Ownership document is missing, and is required based on your answer in the "Property Ownership" section (Question #7).  Please choose the “Authorization to Represent Ownership” document type from the "Step 1" drop-down box and upload all relevant documentation (Steps 2 & 3).'));
            flag = true;
        }///////////////////////////////////////////////// wes)

        if (noSpaceOrRatesFlag == true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ' Space and Rates Page: In order to submit offer, please add at least one space and for each space, enter rate for at least one lease term'));
            flag = true;
        }

        if (buildingFlag == true || parkingFlag == true || propertyOwnerFlag == true || BSACflag == true || flag == true ||
                RepsAndCertsFlag == true || spaceAndRatesFlag == true || attachmentsFlag == true || operatingCostsFlag == true || optionTermFlag == true || pvFlag == true) {
            return null;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, ' There are no errors or omissions detected that will prevent you from submitting your offer during an \'Open Period\'. This automated \'check\' does not certify compliance with the AAAP RLP Package. Please return to this page during the next \'Open Period\' (generally the first 7 days of every month) and a yellow \'Review Final Offer\' button will appear allowing you to complete the submission process.'));
            return null;
        }
        //return null;
    }

    public PageReference actionSaveAndSubmitOffer() {
        // validations for all other page fields
        boolean buildingFlag = PBS_AAAP_GlobalConstants.checkOfferBuildingValidations(submitOffer);

        boolean parkingFlag = PBS_AAAP_GlobalConstants.checkOfferParkingValidations(submitOffer);

        boolean propertyOwnerFlag = PBS_AAAP_GlobalConstants.checkOfferPropOwnerValidations(submitOffer);

        boolean RepsAndCertsFlag = PBS_AAAP_GlobalConstants.checkOfferRepsAndCertsValidations(submitOffer);

        //added by syam
        boolean operatingCostsFlag = PBS_AAAP_GlobalConstants.checkOperatingCostsValidations(submitOffer);

        //added on 07/14/2016 to update the PVRates
        boolean pvFlag = dao.validatePVRates(submitOffer.Id);

        boolean noSpaceOrRatesFlag = false;
        system.debug('***************actionSaveAndSubmitOffer:'+submitOffer.Id);
        List<PBS_AAAP_Space__c> spaces = new List<PBS_AAAP_Space__c>();
        List<PBS_AAAP_Rate__c> rates = new List<PBS_AAAP_Rate__c>();
        List<ID> spaceId = new List<ID>();
        boolean flag = false;
        boolean BSACflag = false;
        boolean FY15RateSaveFlag = false;
        boolean optionTermFlag = false;
        boolean spaceAndRatesFlag = false;
        if (submitOffer.id != null) {
            spaces = [SELECT id, PBS_AAAP_IDENTIFIER_ID__c, name, LASTMODIFIEDDATE FROM PBS_AAAP_Space__c WHERE PBS_AAAP_OFFER_NUMBER__c = :submitOffer.Id];
            //Added by lekha to fix the checkmark security issues
            system.debug('***************actionSaveAndSubmitOffer:'+spaces);
            for (PBS_AAAP_Space__c s : spaces) {
                spaceId.add(s.id);

            }
            //Added by lekha to fix the checkmark security issues ends
            rates = [
                    SELECT id, PBS_AAAP_SPACE__c
                    FROM PBS_AAAP_Rate__c
                    WHERE PBS_AAAP_SPACE__c IN :spaceId
            ];
            system.debug('***************actionSaveAndSubmitOffer:'+rates);
            Map<id, PBS_AAAP_Rate__c> ratesMap = new Map<id, PBS_AAAP_Rate__c>();
            for (PBS_AAAP_Rate__c r : rates) {
                ratesMap.put(r.PBS_AAAP_SPACE__c, r);
            }
            system.debug('***************actionSaveAndSubmitOffer:'+ratesMap);
            if (spaces.size() <= 0) {
                noSpaceOrRatesFlag = true;
            } else {
                for (PBS_AAAP_Space__c s : spaces) {

                    rates = [
                            SELECT id,PBS_AAAP_IDENTIFIER_ID__c, PBS_AAAP_SPACE__c, PBS_AAAP_BSAC__c, LASTMODIFIEDDATE,PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,PBS_AAAP_LEASE_TERM__c
                            FROM PBS_AAAP_Rate__c
                            WHERE PBS_AAAP_SPACE__c = :s.Id AND PBS_AAAP_FULLY_SRVC_FIRM_TERM__c > 0
                    ];
                    system.debug('***************actionSaveAndSubmitOffer:'+rates);
                    if (!ratesMap.containsKey(s.id)) {
                        noSpaceOrRatesFlag = true;
                        break;
                    }
                    //Added by lekha to fix the checkmark security issues ends
                    //Added by Vaishali to fix BSAc issue 04/14/2014
                    else {

                        system.debug('***************Out Rates Routine:');
                        for (PBS_AAAP_Rate__c r : rates) {
                            system.debug('***************In Rates Routine:');
                            if (r.PBS_AAAP_BSAC__c == null) {
                                spaceIdToReport = s.PBS_AAAP_IDENTIFIER_ID__c;
                                BSACflag = true;
                                break;
                            }
                            system.debug('***************In Rates  Last Modified Date ' + r.LASTMODIFIEDDATE);
                            system.debug('***************In Rates  Posted Date ' + rlpPostDate);
                            system.debug('********syam*******In spaces s.LASTMODIFIEDDATE ' + s.LASTMODIFIEDDATE);
                            system.debug('***************In offer submitOffer.LastModifiedDate' + submitOffer.LastModifiedDate);

                            double ratesABOA = (r.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c).setScale(2);
                            double offerABOA = (submitOffer.PBS_AAAP_COST_PER_ABOA__c).setScale(2);
                            system.debug('***rates  PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c ' + ratesABOA);
                            system.debug('***offer  PBS_AAAP_COST_PER_ABOA__c ' + offerABOA);

                            if (r.LASTMODIFIEDDATE <= rlpPostDate) {
                                spaceAndRatesFlag = true;
                                break;
                            }

                            system.debug('***************In Rates Routine:Checking PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c' + r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c);
                            if ((r.PBS_AAAP_LEASE_TERM__c == '5+5 Years') && ((r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c) == null || (r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c) == 0)) {
                                spaceIdToReport = s.PBS_AAAP_IDENTIFIER_ID__c;
                                optionTermFlag = true;
                                break;
                            }


                        }
                    }
                }
            }
        }

        if (addrFlag == 'true') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '-Your building address does not fall within region boundaries, Your offer is not saved. Please check your address data and try again.'));
            //return null;
        }
        if (flag == true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You must submit at least one space. For each submitted space, you must submit rate for at least one lease term.'));// Vaishali 07/19/16 added new message
        }

        if (spaceAndRatesFlag == true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Required data is missing in the \'Space & Rates\' section.  Please select and \'Edit\' each of the individual Space breakouts and look for required fields that are blank or have values that are not logical.  Pressing the \'Save\' button at the bottom of each page will identify possible mistakes on the page.'
            ));
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Space and/or Rates page is not complete. Review and save rates before submitting.'));
            //return null;
        }
        //added by syam on 01/12/2017 for Census validation

        rlpInfo = dao.getRLP(submitOffer.PBS_AAAP_RLP_Number__c);
        regionCode = rlpInfo.PBS_AAAP_Region__c;
        if (regionCode == 'Census') {
            BSACflag = false;
        }
        //added by syam
        if (operatingCostsFlag == true) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Operating Costs Page : 4. Cost per ABOA SF must be > 0.00')); //Vaishali 07/19/16 0.005 changed to 0.00);
        }
        if (BSACflag == true) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Space and Rates page is not complete.'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'BSAC option (#4/4a on rates page) is not complete for Space # ' + spaceIdToReport + '. Review and hit "Save Rates" button before submitting.'));
            //return null;
        }
        if (optionTermFlag == true) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Space and Rates page is not complete.'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'For Space # ' + spaceIdToReport + ' Enter Base Rate per ANSI/BOMA Office Area square foot (ABOA) for years 6-10. If Base rate is unchanged from years 1-5, enter base rate amount from #1 above'));
            //return null;
        }
        if ((pvFlag) && (!(spaceAndRatesFlag))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Before submitting, go back to Operating Cost page and review and save. Review Full Service Rent on Space and Rates.'));
            //return null;
        }
        //boolean attachmentsFlag = PBS_AAAP_GlobalConstants.checkOfferAttachmentValidations(submitOffer);

        List<PBS_AAAP_Offer_Attachments__c> ofratts = new List<PBS_AAAP_Offer_Attachments__c>();
        boolean flag3;
        if (submitOffer.id != null) {
            ofrAtts = [SELECT id, name FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :submitOffer.Id];
            if (ofrAtts.size() <= 0) {
                flag3 = true;
            }
        }
        boolean attachmentsFlag = flag3;
        //commented as part of FY16
        if (attachmentsFlag == true) {
            // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offer Attachments are missing.'));
            //return null;
        }
        
        attachmentsList = [
                SELECT Name, PBS_AAAP_Attachment_Type__c
                FROM PBS_AAAP_Offer_Attachments__c p
                WHERE p.PBS_AAAP_Offer__c = :ofrID
                ORDER BY p.CreatedDate
        ];



        Boolean floorPlanFlag = false;
        Boolean authorizationOfOwner = false;
        System.debug('**** attachmentsList size is  ' + attachmentsList.size());
        for (integer i = 0; i < attachmentsList.size(); i++) {
            PBS_AAAP_Offer_Attachments__c attachmentFP = attachmentsList.get(i);
            System.debug('**** attachmentsList Type is  ' + attachmentFP.PBS_AAAP_Attachment_Type__c);
            if (attachmentFP.PBS_AAAP_Attachment_Type__c == 'Floor Plan') {
                floorPlanFlag = true;
            }
            if (attachmentFP.PBS_AAAP_Attachment_Type__c == 'Authorization to Represent Ownership Entity') ////////////////////// wes
            {
                authorizationOfOwner = true;
            }
        }
        if (floorPlanFlag == false) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    'Additional Action Required: The required Floor Plan document is missing.  Please choose the “Floor Plan” document type from the "Step 1" drop-down box and upload all relevant documentation (Steps 2 & 3).'));
            flag = true;
        }

        if (submitOffer.PBS_AAAP_OFFEROR_INTEREST__c != 'Owner' && authorizationOfOwner == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    'Additional Action Required: The Authorization to Represent Ownership document is missing, and is required based on your answer in the "Property Ownership" section (Question #7).  Please choose the “Authorization to Represent Ownership” document type from the "Step 1" drop-down box and upload all relevant documentation (Steps 2 & 3).'));
            flag = true;
        }
        if (noSpaceOrRatesFlag == true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ' Space and Rates Page: In order to submit offer, please add at least one space and for each space, enter rate for at least one lease term'));
            flag = true;
        }

        if (buildingFlag == true || parkingFlag == true || propertyOwnerFlag == true || BSACflag == true || flag == true ||
                RepsAndCertsFlag == true || spaceAndRatesFlag == true || attachmentsFlag == true || operatingCostsFlag == true || optionTermFlag == true || pvFlag == true) {
            return null;
        }

        showAttachmentsPage = false;
        return null;
    }

    public boolean showPINMesg { get; set; }

    public PageReference actionRequestPIN() { // TODO Convert this method to Workflow on Contact or User object
        // TODO Write logic for sending an email with PIN
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User usr = [SELECT id, FirstName, LastName, username, email, PBS_AAAP_PIN__c, IsActive FROM User WHERE id = :UserInfo.getUserId()];
        System.debug('********** Future Method:::: ' + usr);
        if (usr != null) {
            usr.setOptions(dmo);
        }

        // Need to send an email to the user once he deregisters.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{
                usr.email
        };
        String[] ccAddresses = new String[]{
                'aaap.manager@gsa.gov'
        };
        // String[] ccAddresses = new String[] {'sguniganti@gmail.com'};
        mail.setToAddresses(toAddresses);
        //mail.setCcAddresses(ccAddresses);
        mail.setReplyTo('aaap.manager@gsa.gov');
        //mail.setReplyTo('sguni@acumensolutions.com');
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('AAAP PIN Request ' + usr.FirstName);
        mail.setHtmlBody('Please find the PIN below to submit an offer <br/> PIN : ' + usr.PBS_AAAP_PIN__c);
        System.debug(':::::::: User PIN:::::::::::::: ' + usr.PBS_AAAP_PIN__c);
        // Send the email you have created.
        //commented by syam ganna on 07/19 we no longer need to send email.
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        showPINMesg = true;
        return null;
    }

    // logic for delete button
    public PageReference actionDeleteOffer() {
        PageReference pref = null;
        //System.debug('************* submitOffer ::: '+submitOffer);
        //System.debug('************* submitOffer.PBS_AAAP_Offer_Status__c ::: '+submitOffer.PBS_AAAP_Offer_Status__c);
        //System.debug('************* submitOffer.PBS_AAAP_Offer_Status__c ::: '+PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT);
        if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
            delete submitOffer; // Cascade delete - Deletes all Spaces, Othercosts and Offer attachments associated with it.
            //pref = Page.PBS_AAAP_PortalHome;
            pref = new PageReference('/AAAP/PortalHome');
            pref.setRedirect(true);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + submitOffer.PBS_AAAP_Offer_Status__c +
                    ', you can only delete on Draft or Pending Modification stage');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    public PageReference redirectToHome() {
        //PageReference pref = Page.PBS_AAAP_PortalHome;
        PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(true);
        return pref;
    }

    public void actionBackToRatesAndSpaces() {
        //PageReference pref = Page.PBS_AAAP_SpacesAndRates;
        PageReference pref = new PageReference('/AAAP/SpacesAndRates');
        pref.getParameters().put('offerId', submitOffer.Id);
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/SpacesAndRates', Label.LOP_Community_Base_URL+'AAAP-SpacesAndRates');
        //return null;
    }

    // Re-rendering the Question 3a, Only visible if user selects "YES" on Question 3.
    public Boolean multiOwners = false;
    public PageReference showMultiOwners() {
        System.debug('Action Programs ::::::: ' + submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c);
        if (submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c == 'Yes') {
            multiOwners = true;
        } else {
            multiOwners = false;
            submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = 'No';
        }

        System.debug('************ multiOwners:::::::::::: ' + multiOwners);
        return null;
    }
    public boolean getMultiOwners() {
        if (submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c == 'Yes') {
            multiOwners = true;
        }
        return multiOwners;
    }

    /*added by syam ganna on 03/30 savePage action to save the page as draft if it is in submitted status.*/
    public void actionSavePage() {

        PageReference p = null;
        rlpInfo = dao.getRLP(submitOffer.PBS_AAAP_RLP_Number__c);
        submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(ofrID);
        submitOffer.PBS_AAAP_Signature_First_Name__c = UserInfo.getFirstName();
        submitOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = UserInfo.getLastName();
        system.debug('This is Region ' + rlpInfo.PBS_AAAP_Region__c);
        submitOffer.PBS_AAAP_RLP_Region__c = rlpInfo.PBS_AAAP_Region__c;
        draftMsgFlag = '';
        if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
            submitOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            draftMsgFlag = 'true';
        }

        update submitOffer;

        /*if( !(( pageUrl == null ) || ( pageUrl == '' )) )
        {
            Integer len = pageUrl.length();
            if( pageUrl.mid(len-1, 1) == '=' )
            {
                pageUrl = pageUrl + submitOffer.Id;
            }
                p = new PageReference(pageUrl);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                //return null;
        }*/
		String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        if(pageName.contains('OfferAttachments')){
            PageReference pref = new PageReference('/AAAP/OfferAttachments');
            pref.getParameters().put('offerId', submitOffer.Id);
            pref.setRedirect(false);
            pageURLForRedirection = pref.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferAttachments', Label.LOP_Community_Base_URL+'AAAP-OfferAttachments');
        }else{
            PageReference pref = new PageReference('/AAAP/AdditionalAttachments');
            pref.getParameters().put('offerId', submitOffer.Id);
            pref.setRedirect(false);
            pageURLForRedirection = pref.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/AdditionalAttachments', Label.LOP_Community_Base_URL+'AAAP-AdditionalAttachments');
        }
        //return null;

    }

    public PageReference actionSavePageAddl() {

        PageReference p = null;

        if( !(( pageUrl == null ) || ( pageUrl == '' )) )
        {
            Integer len = pageUrl.length();
            if( pageUrl.mid(len-1, 1) == '=' )  pageUrl = pageUrl + ofrID;
            
            p = new PageReference(pageUrl);
            return p;
        }

        //return null;
        PageReference pref = new PageReference('/AAAP/AdditionalAttachments?offerId='+ofrID);
        return pref;

    }

    public void exitOffer(){
        PageReference p = new PageReference('/AAAP/PortalHome');
        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/PortalHome', Label.LOP_Community_Base_URL+'AAAP-PortalHome');
    }

    public void actionSendtoGREX(){

        System.debug('::::::::actionSendtoGREX:::::::::::::: ');

        List<PBS_AAAP_Offer__c> allOffers = new List<PBS_AAAP_Offer__c>();
        Set<Id> allIds = new Set<Id>();
        List<PBS_AAAP_Offer_Select_Award_Info__c> allOSAI = new List<PBS_AAAP_Offer_Select_Award_Info__c>();
        String vPhase = 'P2';

        allOffers = [
                SELECT  Id,
                        Master_Offer__c
                FROM PBS_AAAP_Offer__c
                WHERE Master_Offer__c = :ofrID
        ];

        System.debug('::::::::actionSendtoGREX:::::::::::::: '+allOffers);

        for(PBS_AAAP_Offer__c ofr : allOffers){
            allIds.add(ofr.Id);
        }

        System.debug('::::::::actionSendtoGREX:::::::::::::: '+allIds);

        allIds.add(ofrID);

        System.debug('::::::::actionSendtoGREX:::::::::::::: '+allIds);

        allOSAI = [
                SELECT  Id,
                        PBS_AAAP_isSelected__c,
                        PBS_AAAP_Submission_DateTime__c,
                        PBS_AAAP_Offer_ID__c,
                        PBS_AAAP_AGENCY_REQUIREMENT_ID__c
                FROM PBS_AAAP_Offer_Select_Award_Info__c
                WHERE PBS_AAAP_Offer_ID__c IN :allIds
                AND PBS_AAAP_isSelected__c = TRUE
                LIMIT 49
        ];

        System.debug('::::::::actionSendtoGREX:::::::::::::: '+allOSAI);

        for(PBS_AAAP_Offer_Select_Award_Info__c osai : allOSAI){
            System.debug('::::::::actionSendtoGREX:::::::::::::: Start');
            PBS_AAAP_SendOfferDetailsAPI.sendOfferDetailsAAAP(osai.PBS_AAAP_Offer_ID__c, osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c, osai.Id, ofrID, vPhase);
            System.debug('::::::::actionSendtoGREX:::::::::::::: End');

        }

        PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(false);
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/PortalHome', Label.LOP_Community_Base_URL+'AAAP-PortalHome');

    }

    public class sequenceNumber2 {
        public integer k { get; set; }
        public PBS_AAAP_Offer_Attachments__c offratts { get; set; }
        public boolean isDisplay { get; set; }

        public List<Attachment> attachmentsList2 { get; set; }
        public sequenceNumber2(integer j, PBS_AAAP_Offer_Attachments__c att) {
            k = j;
            offratts = att;
            for(attachment at : att.Attachments){
                isDisplay = true;
                if( at.Name == 'Form1364.pdf'){
                    at.Name = '1364 - Proposal to Lease Space';
                }
                if( at.Name == 'Form1217.pdf'){
                    at.Name = '1217 - Lessors Annual Cost Statement';
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
        }
    }


    public Map<String, List<Attachment>> getAttachmentMapByType2() {

        Map<String, List<Attachment>> map1 = new Map<String, List<Attachment>>();
        System.debug('attachmentsList size in getAttachmentMapByType' + attachmentsList2.size());
        List<String> attachmentTypes = getAttachmentTypeList();
        for (String attachmentType : attachmentTypes) {
            for (PBS_AAAP_Offer_Attachments__c attachment : attachmentsList2) {
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
                    }*/
                }
            }
        }
        return map1;
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

    public class sequenceNumber3 {
        public integer i { get; set; }
        public PBS_AAAP_Offer_Attachments__c offratts { get; set; }
        public boolean isDisplay { get; set; }
        public List<Attachment> attachmentsList { get; set; }
        public boolean isAttachmentPresent { get; set; }
        public ContentDocumentWrapper file { get; set; }
        public string creatDate { get; set; }

        public sequenceNumber3(PBS_AAAP_Offer_Attachments__c offratts, ContentDocumentWrapper file){
            this.offratts = offratts;
            if(file != null){
                this.isAttachmentPresent = true;
                this.file = file;
            }
            this.creatDate = offratts.createdDate.format('MM/dd/yyyy');
        }
        public sequenceNumber3(integer j, PBS_AAAP_Offer_Attachments__c att) {
            i = j;
            offratts = att;
            for(attachment at : att.Attachments){
                isDisplay = true;
                if( at.Name == 'Form1364.pdf'){
                    at.Name = '1364 - Proposal to Lease Space';
                }
                if( at.Name == 'Form1217.pdf'){
                    at.Name = '1217 - Lessors Annual Cost Statement';
                }

                if( at.Name == 'form3518.pdf'){ isDisplay = false;                }
            }
        }
        public sequenceNumber3(integer j, String attachmentType, List<Attachment> attachments) {
            i = j;
            PBS_AAAP_Offer_Attachments__c att = new PBS_AAAP_Offer_Attachments__c();
            att.PBS_AAAP_Attachment_Type__c = attachmentType;
            offratts = att;
            attachmentsList = attachments;
        }
    }
    /****************/


    public pageReference actionSubmitOffer() {

        // validations for Submit offer page fields
        boolean errorflag = checkOfferSubmissionValidations();
        system.debug('----NIKILESH---'+errorFlag);
        submitOffererror = errorflag;
        if (errorflag == true) {
            return null;
        }

        //added by syam on 09/21/2016
        if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is already in submitted status. If you made any changes since it was submitted, please save them before submitting.');
            ApexPages.addMessage(myMsg);
            return null;
        }

        User usr = [SELECT id, FirstName, LastName, username, email, PBS_AAAP_PIN__c, IsActive FROM User WHERE id = :UserInfo.getUserId()];



        // TODO write logic for pulling RLP information
        PBS_AAAP_Offer__c[] offeralreadyexists = null;
        PageReference pref = null;

        String[] offerstatuscriteria = new String[]{
                PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED, PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED
        };
        offeralreadyexists = [
                SELECT id, PBS_AAAP_Offer_Status__c, PBS_AAAP_RLP_Number__c
                FROM PBS_AAAP_Offer__c
                WHERE PBS_AAAP_Offer_Status__c IN :offerstatuscriteria
                AND PBS_AAAP_RLP_Number__c = :submitOffer.PBS_AAAP_RLP_Number__c
                AND PBS_AAAP_Owner_Name__c = :submitOffer.PBS_AAAP_Owner_Name__c
                AND PBS_AAAP_X_CO_ORD__c = :submitOffer.PBS_AAAP_X_CO_ORD__c
                AND PBS_AAAP_Y_CO_ORD__c = :submitOffer.PBS_AAAP_Y_CO_ORD__c
                AND PBS_AAAP_Is_Offer_Valid__c = TRUE
                AND Ownerid = :UserInfo.getUserId()
                AND Master_Offer__c = NULL
                LIMIT 1
        ];

        // logic for "DRAFT" status.
        //Add || PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN as well.. for now.
        rlpInfo = dao.getRLP(submitOffer.PBS_AAAP_RLP_Number__c);
        submitOffer.PBS_AAAP_RLP_Region__c = rlpInfo.PBS_AAAP_Region__c;
        if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT) {

            if (offeralreadyexists.size() > 0 /*&& offeralreadyexists[0].Id != null && offeralreadyexists[0].PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED
                && submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT       */) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'AAAP user already has an existing offer in the system in ' + offeralreadyexists[0].PBS_AAAP_Offer_Status__c + ' status. ' +
                        'In order to submit the current offer the user should either modify the current offer or ' +
                        'withdraw the originally submitted offer from the system.');
                ApexPages.addMessage(myMsg);
                return null;
            } else {
                submitOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
                submitOffer.PBS_AAAP_Is_Offer_Valid__c = true;
                if (termsandconditons == 'Yes') {
                    submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
                    submitOffer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
                }
                update submitOffer;
                System.debug('******************** submitOffer.PBS_AAAP_Offer_Status__c ::::::::: : ' + submitOffer.PBS_AAAP_Offer_Status__c);

                // TODO might need to redirect them to PDF pages.
                //pref = Page.PBS_AAAP_OfferSubmitConfirmation;
                pref = new PageReference('/AAAP/OfferSubmitConfirmation');
                pref.getParameters().put('offerId', submitOffer.Id);
                //pref.setRedirect(false);
                pageURLForRedirection = pref.getUrl();
               pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferSubmitConfirmation', Label.LOP_Community_Base_URL+'AAAP-OfferSubmitConfirmation');
            }

        }

        // logic for "Pending Modification" status.
        if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
            if (submitOffer.PBS_AAAP_Parent_Offer__c != null) {

                if (offeralreadyexists.size() > 0 && offeralreadyexists[0].Id != submitOffer.PBS_AAAP_Parent_Offer__c) {

                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'AAAP user already has an existing offer in the system in ' + offeralreadyexists[0].PBS_AAAP_Offer_Status__c + ' status. ' +
                            'In order to submit the current offer the user should either modify the current offer or ' +
                            'withdraw the originally submitted offer from the system.');
                    ApexPages.addMessage(myMsg);
                    return null;
                }

                PBS_AAAP_Offer__c parentOffer = [
                        SELECT id, PBS_AAAP_Parent_Offer__c, PBS_AAAP_Offer_Status__c, PBS_AAAP_Is_Offer_Valid__c
                        FROM PBS_AAAP_Offer__c
                        WHERE id = :submitOffer.PBS_AAAP_Parent_Offer__c
                ];

                if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {

                    if (parentOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED) {
                        parentOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED;
                    }
                    if (parentOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                        parentOffer.PBS_AAAP_Is_Offer_Valid__c = false;
                    }
                    update parentOffer;
                    submitOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
                    submitOffer.PBS_AAAP_Is_Offer_Valid__c = true;
                    if (termsandconditons == 'Yes') {
                        submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
                        //---RITM0023066-------according to the code offers can be only be submitted of the Offer is in Draft or Pending Modification states----
                        //--the Draft state had the submission date set, but thePending Modification was still missing

                        submitOffer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
                        //--------------------------------------------------------------------------------------------------------------------------------------
                    }
                    update submitOffer;
                    System.debug('******************** submitOffer.PBS_AAAP_Offer_Status__c ::::::::: : ' + submitOffer.PBS_AAAP_Offer_Status__c);

                }

            }

            // TODO might need to redirect them to PDF pages.
            //pref = Page.PBS_AAAP_OfferSubmitConfirmation;
            pref = new PageReference('/AAAP/OfferSubmitConfirmation');
            pref.setRedirect(false);
            pageURLForRedirection = pref.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferSubmitConfirmation', Label.LOP_Community_Base_URL+'AAAP-OfferSubmitConfirmation');

        }

        return null;
        //return pref;

    }

    public pageReference DownloadAllFiles_00() {

        DownloadAllFiles();
        updateOfferDetails();

        PageReference pref = new PageReference('/AAAP/OfferSubmitConfirmation');
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferSubmitConfirmation', Label.LOP_Community_Base_URL+'AAAP-OfferSubmitConfirmation');
        system.debug('&&&&'+pageURLForRedirection);
        pref.setRedirect(false);
        return null;
    }

// method to download all files in a single click
    public void DownloadAllFiles() {

        // delete existing delete
        list<attachment> lstDelAtt = new list<attachment>();
        list<PBS_AAAP_Offer_Attachments__c> oAtt = new List<PBS_AAAP_Offer_Attachments__c>();
        set<Id> idSet = new Set<Id>();
        oAtt = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE (PBS_AAAP_Offer__c = :ofrID AND (PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217)' OR PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217 attachment)' OR PBS_AAAP_Attachment_Type__c = 'Form 1364 AAAP')) AND IsDeleted = false];
        if(oAtt.size() > 0){
            delete oAtt;
        }
        //lstDelAtt = [select id from attachment where parentId IN :idSet];

        // if we ahve data then delete
        if(!lstDelAtt.isEmpty()){
            delete lstDelAtt;
        }
        PBS_AAAP_Utility.logMethodStart('DownloadAllFiles');
        System.debug('---------------entering downloadall soql-------------');

        PBS_AAAP_Offer__c offerpdf = [
                SELECT o.id, o.Name, o.PBS_AAAP_Building_Name__c, o.PBS_AAAP_Street_Address__c, o.PBS_AAAP_Country__c,
                        o.PBS_AAAP_City__c, o.PBS_AAAP_State__c, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c,
                        o.PBS_AAAP_RLP_Number__c, o.PBS_AAAP_ZipCode__c, o.LastModifiedDate, o.Formula_RLP_Region__c, o.PBS_AAAP_Offer_Status__c,
                        o.PBS_AAAP_Offer_Submission_Date__c
                FROM PBS_AAAP_Offer__c o
                WHERE o.id = :ofrID
        ];
        System.debug('--------------offerpdf-------------'+offerpdf);

        Boolean displayLink = false;
        Boolean displayform1217link = true;
        
        if (offerpdf.Formula_RLP_Region__c == 'Census') {
            displayform1217link = false;
        }
        Boolean displayform1364_2019link = false;
//SGanti modified 8/2021 - conditions for displayform1364_2019link         
        //if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018){
            //displayform1364_2019link = true;
        //}else{
            //displayform1364_2019link = false;
        //}
       if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018 && Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) <= 2021){
                displayform1364_2019link = true;
            }else{
                displayform1364_2019link = false;
            }  
//SGanti added 8/2021-displayform1364_2022link
        Boolean displayform1364_2022link;
        if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2021){
                displayform1364_2022link = true;
            }else{
                displayform1364_2022link = false;
            }    
        
        DateTime dt = offerpdf.LastModifiedDate;
        Date modDate = dt.date();
        string DefaultCheckDate = '2017-09-25';
        Date checkDate = date.valueOf(DefaultCheckDate);
        if (modDate > checkDate) {
            displayLink = false;
        } else {
            displayLink = true;
        }

        System.debug('---------------OfferId is: ' + ofrID + '--------------------------------');
        //List<Attachment> lstAttachments = new List<Attachment>();
        // Add Attachment
        if (displayform1217link == true) {
            system.debug('#######1');
            addAttachementToOffer(ofrID, 'Form1217', 'Form1217.pdf');
            addAttachementToOffer(ofrID, 'Form1217Attachment', 'Form1217Attachment.pdf');
            system.debug('#######2');
        }
//SGanti commented out 8/2021 -  to include logic for displayform1364_2022link        
      /*  if(displayform1364_2019link == true){
            system.debug('#######3');
//SGanti commented out Offerform1364_2019 on 8/2021     
          //  addAttachementToOffer(ofrID, 'Offerform1364_2019', 'OfferForm1364.pdf');
            //addAttachementToOffer(ofrID, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
//SGanti added 8/2021
            System.debug('---------------ABOUT TO ADD New Offer Form 1364-------------');  
            addAttachementToOffer(ofrID, 'NewOfferForm1364', 'NewOfferForm1364.pdf');         
            
            if (displayLink == true && displayform1217link == true) {
                system.debug('#######4');
                addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######5');
            } else if (displayLink == true && displayform1217link != true) {
                system.debug('#######6');
                addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######7');
            } else if (displayLink != true && displayform1217link == true) {
                system.debug('#######8');
                system.debug('#######9');
            } else if (displayLink != true && displayform1217link != true) {
                system.debug('#######10');
                system.debug('#######11');
            }
        }else{
            system.debug('#######12');
//SGanti commented out 8/2021           
           // addAttachementToOffer(ofrID, 'OfferForm1364', 'OfferForm1364.pdf');
//SGanti added 8/2021
            addAttachementToOffer(ofrID, 'NewOfferForm1364', 'NewOfferForm1364.pdf');

            //addAttachementToOffer(ofrID,'OfferForm1364Attachment','OfferForm1364Attachment.pdf');
            addAttachementToOffer(ofrID, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
            if (displayLink == true && displayform1217link == true) { addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######14');
            } else if (displayLink == true && displayform1217link != true) {  addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######15');
            } else if (displayLink != true && displayform1217link == true) {
                system.debug('#######16');
            } //else if (displayLink != true && displayform1217link != true) {
                //system.debug('#######17');
                //system.debug('#######18');
            //}
    }
   */     
        if(displayform1364_2022link == true){
                  system.debug('#######3');
            addAttachementToOffer(ofrID, 'OfferForm1364_2022', 'OfferForm1364.pdf');
            //addAttachementToOffer(ofrID, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');       
            
            if (displayLink == true && displayform1217link == true) {
                system.debug('#######4');
                addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######5');
            } else if (displayLink == true && displayform1217link != true) {
                system.debug('#######6');
                addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######7');
            } else if (displayLink != true && displayform1217link == true) {
                system.debug('#######8');
                system.debug('#######9');
            } else if (displayLink != true && displayform1217link != true) {
                system.debug('#######10');
                system.debug('#######11');
            }
            
        }
        else{
            if(displayform1364_2019link == true){
                system.debug('#######12');
            addAttachementToOffer(ofrID, 'Offerform1364_2019', 'OfferForm1364.pdf');
            //addAttachementToOffer(ofrID, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');       
            
            if (displayLink == true && displayform1217link == true) {
                system.debug('#######13');
                addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######14');
            } else if (displayLink == true && displayform1217link != true) {
                system.debug('#######15');
                addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######16');
            } else if (displayLink != true && displayform1217link == true) {
                system.debug('#######17');
                system.debug('#######18');
            } else if (displayLink != true && displayform1217link != true) {
                system.debug('#######19');
                system.debug('#######20');
            }              
            }
            else{
                system.debug('#######21');
           addAttachementToOffer(ofrID, 'OfferForm1364', 'OfferForm1364.pdf');
            //addAttachementToOffer(ofrID,'OfferForm1364Attachment','OfferForm1364Attachment.pdf');
            addAttachementToOffer(ofrID, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
            if (displayLink == true && displayform1217link == true) { addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######22');
            } else if (displayLink == true && displayform1217link != true) {  addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                system.debug('#######23');
            } else if (displayLink != true && displayform1217link == true) {
                system.debug('#######24');
            } //else if (displayLink != true && displayform1217link != true) {
                //system.debug('#######25');
                //system.debug('#######26');
            //}
            }
        }     

        updateOfferDetails();
    }
// method to add attachment to offer
    public void addAttachementToOffer(string offerId, string formType, string fileName) {
        PBS_AAAP_Utility.logMethodStart('addAttachementToOffer');

        PBS_AAAP_Offer__c offerpdf = [
                SELECT o.id, o.Name, o.PBS_AAAP_Building_Name__c, o.PBS_AAAP_Street_Address__c, o.PBS_AAAP_Country__c,
                        o.PBS_AAAP_City__c, o.PBS_AAAP_State__c,o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c,
                        o.PBS_AAAP_RLP_Number__c, o.PBS_AAAP_ZipCode__c, o.LastModifiedDate, o.Formula_RLP_Region__c
                FROM PBS_AAAP_Offer__c o
                WHERE o.id = :offerId
        ];
        Boolean displayLink = false;
        DateTime dt = offerpdf.LastModifiedDate;
        Date modDate = dt.date();
        Date checkDate = date.valueOf('2017-09-25');
        if (modDate > checkDate) {
            displayLink = false;
        } else {
            displayLink = true;
        }
        system.debug('&&&&&&1'+displayLink);
        Boolean displayform1217link = true;
        if (offerpdf.Formula_RLP_Region__c == 'Census') {
            displayform1217link = false;
        }
        system.debug('&&&&&&2'+displayform1217link);
        Boolean displayform1364_2019link = false;
//SGanti commented out 8/2021 - to update conditions for displayform1364_2019link        
       
       // if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018){
         //   displayform1364_2019link = true;
        //}else{
          //  displayform1364_2019link = false;
        //}
//SGanti added 8/2021. Updated conditions for displayform1364_2019link.
        
         if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018 && Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) <= 2021){
                displayform1364_2019link = true;
            }else{
                displayform1364_2019link = false;
            }       

        system.debug('&&&&&&2'+displayform1364_2019link);
        PageReference pageRef;
//SGanti added 8/2021. Set conditions for displayform1364_2022link
            Boolean displayform1364_2022link = false;                 
            if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2021){
                displayform1364_2022link = true;
            }else{
                displayform1364_2022link = false;
            } 
        // getting offer key  
        string sesid = fetchOfferKey();
         if (formType == 'Form1217' && displayform1217link == true) {
            system.debug('&&&&&&3');
            pageRef = Page.OfferForm1217;
            pageRef.getParameters().put('formtype', 'offerform1217');
          //  pageRef.getParameters().put('offerId', offerId);
            //pageURLForRedirection = pageRef.getUrl();
           	//pageURLForRedirection = pageURLForRedirection.replace('/apex/offerform1217', Label.LOP_Community_Base_URL+'offerform1217');
           //  System.debug('Chandralekha'+pageURLForRedirection);
            system.debug('&&&&&&4');
        }
        if (formType == 'Form1217Attachment' && displayform1217link == true) {
            system.debug('&&&&&&5');
            pageRef = Page.OfferForm1217Attachment;
            pageRef.getParameters().put('formtype', 'offerform1217Attachment');
            system.debug('&&&&&&6');
        }
        if(formtype == 'Offerform1364_2019' && displayform1364_2019link == true){
            system.debug('&&&&&&7');
            pageRef = Page.Offerform1364_2019;    //NIK
            pageRef.getParameters().put('formtype', 'offerform1364');
            system.debug('&&&&&&8');
        }
        if (formType == 'OfferForm1364' && displayform1364_2019link == false) {
            system.debug('&&&&&&9');
            pageRef = Page.OfferForm1364;
            pageRef.getParameters().put('formtype', 'offerform1364');
            pageRef.getParameters().put('offerid', offerId);
            system.debug('&&&&&&10');
        }
        
//SGanti added 08/2021
        if(formtype == 'OfferForm1364_2022' && displayform1364_2022link == true){
            system.debug('&&&&&&1364_2022');
            pageRef = Page.PBS_AAAP_NewOfferForm1364;
            pageRef.getParameters().put('formtype', 'OfferForm1364_2022');
            system.debug('&&&&&&1364_2022');
        }         
        if (formType == 'OfferForm1364_2022' && displayform1364_2022link == false) {
            system.debug('&&&&&&1364_2022');
            pageRef = Page.PBS_AAAP_NewOfferForm1364;
            pageRef.getParameters().put('formtype', 'OfferForm1364_2022');
            pageRef.getParameters().put('offerid', offerId);
            system.debug('&&&&&&1364_2022');
        }        
        
        if (formType == 'OfferForm1364RateStructure') {
            system.debug('&&&&&&11');
            pageRef = Page.OfferForm1364RateStructure;
            pageRef.getParameters().put('formtype', 'offerform1364ratestructure');
            system.debug('&&&&&&12');
        }
        if (formType == 'OfferForm3518' && displayLink == true) {
            system.debug('&&&&&&13');
            pageRef = Page.OfferForm3518;
            pageRef.getParameters().put('formtype', 'offerform3518');
            system.debug('&&&&&&14');
        }
        system.debug('&&&&&&15'+pageRef);
        pageRef.getParameters().put('offerId', offerId);
        
        Blob pdfPageBlob;
    if(sesid == null){
            pageRef.getParameters().put('isFromOfferAtt', 'true');
        }
        if (!Test.isRunningTest()) {
            pageRef.getParameters().put('sesid', sesid);
            System.debug('Print PageReference'+ pageRef);
            system.debug('&&&&&&17'+pageRef.getContentAsPDF());
            
            pdfPageBlob = pageRef.getContentAsPDF();
            
        } else {
            pdfPageBlob = Blob.valueOf('TEST');
        }
        system.debug('&&&&&&16'+pdfPageBlob);

        PBS_AAAP_Offer_Attachments__c offAtt = new PBS_AAAP_Offer_Attachments__c();
        if(formType == 'Form1217'){
            offAtt.PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217)';
        } else if(formType == 'Form1217Attachment'){
            offAtt.PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217 attachment)';
        } 
//SGanti updated 08/2021        
        else if(formType == 'Offerform1364_2019' || formType == 'Offerform1364' || formType == 'OfferForm1364_2022'){
            offAtt.PBS_AAAP_Attachment_Type__c = 'Form 1364 AAAP';
        }
        offAtt.PBS_AAAP_Offer__c = offerId;
        insert offAtt;
 //String base64 = EncodingUtil.base64Encode(pdfPageBlob);	
        	ContentVersion ContVerFile = new ContentVersion();	
            ContVerFile.VersionData = pdfPageBlob; //EncodingUtil.base64Decode(base64);//Blob.valueOf('string');	
            ContVerFile.Title = fileName; 	
            ContVerFile.PathOnClient= fileName;	
      		insert ContVerFile;
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ContVerFile.Id].ContentDocumentId;
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = offAtt.Id;
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
//-- create a corresponding record on Attachment std object.
		/*
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = offAtt.Id;
        a.Name = fileName;
        insert a;
        system.debug('\n-a--'+a.Id);
        */
        PBS_AAAP_Utility.logMethodEnd('addAttachementToOffer');



    }


    // getting randon key and update on Offer
    public static void updateOfferDetails(){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        Integer len = Integer.valueOf(Label.PBS_AAAP_KeyLength);
        String randStr = '';

        // generating the random number
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }

        string ofId = ApexPages.currentPage().getParameters().get('offerId');


        //updating user
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(id = ofId,
                PBS_AAAP_Session_Key__c = randStr);
        update offerRec;
    }

    public  string fetchOfferKey(){
        string ofId = ApexPages.currentPage().getParameters().get('offerId');
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_Key__c;
    }

    public List<FORMWrapper> getgeneratedForm(){
        List<FORMWrapper> lstFormDetails = new List<FORMWrapper>();
        string ofId = ApexPages.currentPage().getParameters().get('offerId');
        List<PBS_AAAP_Offer_Attachments__c> attachmentsList = [SELECT ID, PBS_AAAP_Attachment_Type__c FROM PBS_AAAP_Offer_Attachments__c
                                                        WHERE (PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217)'
                                                        OR PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217)'
                                                        OR PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217 attachment)'
                                                        OR PBS_AAAP_Attachment_Type__c = 'Form 1364 AAAP')
                                                        AND PBS_AAAP_Offer__c = :ofId];
        List<Id> attOfferIds = new List<Id>();
        Map<Id, String> contentDocumentMap = new Map<Id, String>();
        for(PBS_AAAP_Offer_Attachments__c attachmentRecord : attachmentsList){
            attOfferIds.add(attachmentRecord.Id);
        }
        
        List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
        for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
            contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId, contentDocumentLinkRecord.ContentDocument.Description);
        }
        for (PBS_AAAP_Offer_Attachments__c attForm : attachmentsList) {
            if(contentDocumentMap.containsKey(attForm.Id)){
                lstFormDetails.add(new FORMWrapper(attForm,contentDocumentMap.get(attForm.Id)));
            }
        }
        return lstFormDetails;
    }
    
    
    public class FORMWrapper{
        public PBS_AAAP_Offer_Attachments__c attachmentForm {get;set;}
        public string fileURL {get;set;}
        
        public FORMWrapper(PBS_AAAP_Offer_Attachments__c attachmentForm, String fileURL){
            this.attachmentForm = attachmentForm;
            this.fileURL = fileURL;
        }   
        
    }
    //changes start
    public PageReference viewOffer() {
        string ofId = ApexPages.currentPage().getParameters().get('offerId');
        PageReference p = new PageReference('/AAAP/PreviewOfferPage');
        p.getParameters().put('offerId', ofId);
        p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/PreviewOfferPage', Label.LOP_Community_Base_URL+'AAAP-PreviewOfferPage');
        return null;
    }
    //changes finish
}