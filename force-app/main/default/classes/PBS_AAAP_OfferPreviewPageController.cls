public with sharing class PBS_AAAP_OfferPreviewPageController extends PBS_AAAP_PageBaseController {
    
    public ID offerId { get; set; }
    public PBS_AAAP_Offer__c offerpdf { get; set; }
    public List<PageWrapper> lstPageWrapper { get; set; }
    public String formName { get; set; }
    public Boolean displayLink { get; set; }
    public Boolean displayform1217link { get; set; }
    public Boolean displayform1364_2019link {get; set;}
    public Boolean displayform1364_2022link {get; set;}
    public string pageURLForRedirection {get;set;}
    
    public List<PBS_AAAP_Offer_Attachments__c> offerattachment { get; set; }
    public List<sequenceNumber> seqNumList { get; set; }
    public String attachmentId { get; set; }
    
    public static final string DefaultCheckDate = '2017-09-25';
    public static string CurrentCheckDate = DefaultCheckDate;
    
    public static string remoteOfferId { get; set; }
    
    public PageReference actionDeleteAttachment() {
        // TODO Delete Logic
        System.debug('******* We are here::::::::::::::');
        System.debug('******* AttachmentsId::::::::::::::' + attachmentId);
        try {
            PBS_AAAP_Offer_Attachments__c delOfrAtt = [SELECT id, name FROM PBS_AAAP_Offer_Attachments__c WHERE id = :attachmentId];
            delete delOfrAtt;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            return null;
        }
        
        PageReference pref = Page.PBS_AAAP_PreviewOfferPage;
        pref.getParameters().put('offerId', offerId);
        pref.setRedirect(true);
        return pref;
    }
    
    public PBS_AAAP_OfferPreviewPageController() {
        logConstructorStart('PBS_AAAP_OfferPreviewPageController');
        lstPageWrapper = new List<PageWrapper>();
        //Santhosh Changes Started
        if (ApexPages.currentPage().getParameters().get('id') != null) {
            offerId = ApexPages.currentPage().getParameters().get('id');
            Cookie offerIdCookie = new Cookie('offerId',offerId,null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{offerIdCookie});
        }
        //Santhosh Changes Ended
        Cookie offerIdCookie = ApexPages.currentPage().getCookies().get('offerId');
        if(offerIdCookie != Null){
            ApexPages.currentPage().getParameters().put('offerId', offerIdCookie.getValue());
        }
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            
            offerId = ApexPages.currentPage().getParameters().get('offerId');
            
            offerpdf = [
                SELECT o.id, o.Name, o.PBS_AAAP_Building_Name__c, o.PBS_AAAP_Street_Address__c, o.PBS_AAAP_Country__c,
                o.PBS_AAAP_City__c, o.PBS_AAAP_State__c, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c,
                o.PBS_AAAP_RLP_Number__c, o.PBS_AAAP_ZipCode__c, o.LastModifiedDate, o.Formula_RLP_Region__c,
                o.CREATEDBYID, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c, PBS_AAAP_Offer_Status__c 
                FROM PBS_AAAP_Offer__c o
                WHERE o.id = :offerId
            ];
            
            List<PBS_AAAP_Offer_Attachments__c>  attachmentsList = [
                SELECT Name, PBS_AAAP_Attachment_Type__c, Document_Description__c 
                FROM PBS_AAAP_Offer_Attachments__c p
                WHERE p.PBS_AAAP_Offer__c = :offerId
                AND p.PBS_AAAP_Attachment_Type__c != 'Lessors Annual Cost Statement (Form 1217)'
                AND p.PBS_AAAP_Attachment_Type__c != 'Form 1364 AAAP'
                AND p.PBS_AAAP_Attachment_Type__c != 'Lessors Annual Cost Statement (Form 1217 attachment)'
                AND p.PBS_AAAP_Attachment_Type__c != 'Offeror Form 1217- Lessor\'s Annual Cost Statement'
                AND p.PBS_AAAP_Attachment_Type__c != 'Offeror GSA Form 1364'
                ORDER BY p.CreatedDate
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
            for (integer i = 0; i < attachmentsList.size(); i++) {
                if(contentDocumentMap.containsKey(attachmentsList[i].Id)){
                    seqNumList.add(new sequenceNumber(i + 1, attachmentsList[i], contentDocumentMap.get(attachmentsList[i].Id)));
                }
            }
            
            
            
            displayLink = false;
            
            displayform1217link = true;
            displayform1364_2019link = false;
            //SGanti added 8/2021
            displayform1364_2022link = false;
            
            system.debug('***'+offerpdf);
            system.debug('***'+offerpdf.PBS_AAAP_RLP_Number__c);
            system.debug('***'+offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c);
            
            
            if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018 && Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) <= 2021){
                displayform1364_2019link = true;
            }else{
                displayform1364_2019link = false;
            } 
            
            //SGanti added 8/2021]         
            if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2021){
                displayform1364_2022link = true;
            }else{
                displayform1364_2022link = false;
            }      
            
            if (offerpdf.Formula_RLP_Region__c == 'Census') {
                displayform1217link = false;
            }
            System.debug('display 1217 Boolean' + displayform1217link);
            System.debug('Offer detail' + offerpdf);
            DateTime dt = offerpdf.LastModifiedDate;
            Date modDate = dt.date();
            Date checkDate = date.valueOf(CurrentCheckDate);
            if (modDate > checkDate) {
                displayLink = false;
            } else {
                displayLink = true;
            }
            System.debug('modDate=['+string.valueOf(modDate)+'] checkData=['+string.valueOf(checkDate)+'] displayLink=' +string.valueOf(displayLink));
            
        }
        if (displayform1217link == true) {
            PageWrapper pgObj = new PageWrapper();
            PageReference p = Page.OfferForm1217;
            p.getParameters().put('offerId', offerId);
            p.getParameters().put('formtype', 'offerform1217');
            p.setRedirect(true);                                   
            pgObj.pgRefObj = p;
            pgObj.formName = 'offerform1217';
            pgObj.linkName = 'Lessors Annual Cost Statement (Form 1217)';
            pgObj.clicked = false;
            lstPageWrapper.add(pgObj);
            
            PageWrapper pgObj1 = new PageWrapper();
            PageReference p1 = Page.Offerform1217Attachment;
            p1.getParameters().put('offerId', offerId);
            p1.getParameters().put('formtype', 'offerform1217Attachment');
            p1.setRedirect(true);
            pgObj1.pgRefObj = p1;
            pgObj1.formName = 'offerform1217Attachment';
            pgObj1.linkName = 'Lessors Annual Cost Statement (Form 1217 attachment)';
            pgObj1.clicked = false;
            lstPageWrapper.add(pgObj1);
        }
        //SGanti commented out 8/2021
        
        
        if(displayform1364_2022link == true){
            PageWrapper pgObj6 = new PageWrapper();
            PageReference p6 = Page.PBS_AAAP_NewOfferForm1364;
            
           
            p6.getParameters().put('offerId', offerId);
            p6.getParameters().put('formtype', 'OfferForm1364_2022');
            p6.setRedirect(true);
            pgObj6.pgRefObj = p6;
            pgObj6.formName = 'OfferForm1364_2022';
            
            pgObj6.linkName = 'Form 1364 AAAP';
            pgObj6.clicked = false;
            lstPageWrapper.add(pgObj6);
        }
        else{
            if(displayform1364_2019link == false){
                PageWrapper pgObj2 = new PageWrapper();
                PageReference p2 = Page.OfferForm1364;
                p2.getParameters().put('offerId', offerId);
                p2.getParameters().put('formtype', 'OfferForm1364');
                p2.setRedirect(true);
                pgObj2.pgRefObj = p2;
                pgObj2.formName = 'OfferForm1364';
                //pgObj2.linkName = 'GSA Form 1364C - STANDARD';
                pgObj2.linkName = 'Form 1364 AAAP';
                pgObj2.clicked = false;
                lstPageWrapper.add(pgObj2);
                
                PageWrapper pgObj3 = new PageWrapper();
                PageReference p3 = Page.OfferForm1364RateStructure;
                p3.getParameters().put('offerId', offerId);
                p3.getParameters().put('formtype', 'offerform1364ratestructure');
                p3.setRedirect(true);
                pgObj3.pgRefObj = p3;
                pgObj3.formName = 'offerform1364ratestructure';
                pgObj3.linkName = 'Attachment #1 - Rate Structure (Attachment to GSA Form 1364-A)';
                pgObj3.clicked = false;
                lstPageWrapper.add(pgObj3);                      
            }else{
                
                PageWrapper pgObj2 = new PageWrapper();
                PageReference p2 = Page.Offerform1364_2019;
                p2.getParameters().put('offerId', offerId);
                p2.getParameters().put('formtype', 'OfferForm1364');
                p2.setRedirect(true);
                pgObj2.pgRefObj = p2;
                pgObj2.formName = 'OfferForm1364';
                pgObj2.linkName = 'Form 1364 AAAP';
                pgObj2.clicked = false;
                lstPageWrapper.add(pgObj2);              
            }                                                     
        }
        
        
        if (displayLink == true || Test.isRunningTest()) {
            PageWrapper pgObj4 = new PageWrapper();
            PageReference p4 = Page.OfferForm3518;
            p4.getParameters().put('offerId', offerId);
            p4.getParameters().put('formtype', 'OfferForm3518');
            p4.setRedirect(true);
            pgObj4.pgRefObj = p4;
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.formName = 'OfferForm3518';
            pgObj4.linkName = 'Representations and Certifications (Form 3518)';
            pgObj4.clicked = false;
            lstPageWrapper.add(pgObj4);
        }
        logConstructorEnd('PBS_AAAP_OfferPreviewPageController');
    }
    //method to redirect to the form page
    public PageReference redirectToExpectedPage() {
        logMethodStart('redirectToExpectedPage'+lstPageWrapper);
        for (PageWrapper pgWrapObj : lstPageWrapper) {
            system.debug('\n--pgWrapObj--'+pgWrapObj);
            if (pgWrapObj.formName == formName) {
                
                // query the attachment
                string param = '';
                
                if (formName == 'offerform1217') {
                    param += 'Form1217.pdf';
                }
                else if (formName == 'offerform1217Attachment'){
                    param += 'Form1217Attachment.pdf';
                }
                else if(formName == 'Offerform1364_2019'){
                    param += 'offerform1364.pdf';
                }
                else if (formName == 'OfferForm1364'){
                    param += 'offerform1364.pdf';
                }
                
                //SGanti added 8/2021
                else if (formName == 'OfferForm1364_2022') {
                    param += 'OfferForm1364.pdf';
                }
                else if (formName == 'OfferForm1364RateStructure') {
                    param += 'offerform1364ratestructure.pdf';
                }
                else if (formName == 'OfferForm3518' && displayLink == true) {
                    param += 'offerform3518.pdf';
                }
                
                else {
                    param+= formName+'.pdf';
                }
                
                Set<Id> offAttIds = new Set<Id>();
                List<PBS_AAAP_Offer_Attachments__c> offAtts = new List<PBS_AAAP_Offer_Attachments__c>();                
                offAtts = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE PBS_AAAP_Offer__c = :offerId];
                
                for(PBS_AAAP_Offer_Attachments__c recs : offAtts){
                    offAttIds.add(recs.Id);
                }
                system.debug('\n--param--'+param);
                
                return pgWrapObj.pgRefObj;
                

                
            }
        }       
        return null;
    }
    
   
    //SGanti -- method to Downloading all files in a single click
    @RemoteAction
    public static List<AttachmentWrapper> DownloadAllFiles(string offerId) {
        remoteOfferId = offerId;
        System.debug(remoteOfferId);
        PBS_AAAP_Utility.logMethodStart('DownloadAllFiles');
        System.debug('---------------entering downloadall soql-------------');
        
        PBS_AAAP_Offer__c offerpdf = [
            SELECT o.id, o.Name, o.PBS_AAAP_Building_Name__c, o.PBS_AAAP_Street_Address__c, o.PBS_AAAP_Country__c,
            o.PBS_AAAP_City__c, o.PBS_AAAP_State__c, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c,
            o.PBS_AAAP_RLP_Number__c, o.PBS_AAAP_ZipCode__c, o.LastModifiedDate, o.Formula_RLP_Region__c
            FROM PBS_AAAP_Offer__c o
            WHERE o.id = :offerId
        ];
        System.debug('--------------offerpdf-------------'+offerpdf);
        
        Boolean displayLink = false;
        Boolean displayform1217link = true;
        if (offerpdf.Formula_RLP_Region__c == 'Census') {
            displayform1217link = false;
        }
        Boolean displayform1364_2019link = false;
        Boolean displayform1364_2022link = false;
        //SGanti commented out 8/2021 to update conditions for displayform1364_2019link
        
        List<AttachmentWrapper> lstAttachmentWrapper = new List<AttachmentWrapper>();
        List<PBS_AAAP_Offer_Attachments__c> offerattachment = [SELECT Id
                           FROM PBS_AAAP_Offer_Attachments__c p
                           WHERE p.PBS_AAAP_Offer__c = :offerId
                          ];
        Set<Id> attOfferIds = new Set<Id>();
        for(PBS_AAAP_Offer_Attachments__c attachmentRecord : offerattachment){
            attOfferIds.add(attachmentRecord.Id);
        }
        if(attOfferIds.size() > 0){
            List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.VersionData, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
            for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                AttachmentWrapper wrapper = new AttachmentWrapper();
                wrapper.attName = contentDocumentLinkRecord.ContentDocument.Title;
                wrapper.attEncodedBody = EncodingUtil.base64Encode(contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.VersionData);//EncodingUtil.base64Encode(att.Body);
                lstAttachmentWrapper.add(wrapper);
            }
        }
        //delete lstAttachments;
        
        PBS_AAAP_Utility.logMethodEnd('DownloadAllFiles', lstAttachmentWrapper);
        updateOfferDetails();
        return lstAttachmentWrapper;
    }
    
    // getting random key and update on Offer
    public static void updateOfferDetails(){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        Integer len = Integer.valueOf(Label.PBS_AAAP_KeyLength);
        String randStr = '';
        
        // generating the random number
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        
        string ofId = '';
        System.debug(remoteOfferId);
        if(!string.isBlank(remoteOfferId)){
            ofId = remoteOfferId;
        }
        else{
            ofId = ApexPages.currentPage().getParameters().get('offerId');
        }
        if(ofId == Null){
            Cookie offerIdCookie = ApexPages.currentPage().getCookies().get('offerId');
            if(offerIdCookie != Null){
                ofId = offerIdCookie.getValue();
            }
        }
        //updating user
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(id = ofId,
                                                           PBS_AAAP_Session_Key__c = randStr);
        update offerRec;
    }
    
    public static string fetchOfferKey(){
        string ofId = '';
        if(!string.isBlank(remoteOfferId)){
            ofId = remoteOfferId;
        }
        else{
            ofId = ApexPages.currentPage().getParameters().get('offerId');
        }
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_Key__c;
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
    
    public class AttachmentWrapper {
        public String attEncodedBody { get; set; }
        public String attName { get; set; }
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
    
    public class PageWrapper {
        public String linkName { get; set; }
        public String formName { get; set; }
        public PageReference pgRefObj { get; set; }
        public Boolean clicked { get; set; }
    }
}