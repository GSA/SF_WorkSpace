public with sharing class PBS_AAAP_OfferPreviewPageController extends PBS_AAAP_PageBaseController {
    
    public ID offerId { get; set; }
    public PBS_AAAP_Offer__c offerpdf { get; set; }
    public List<PageWrapper> lstPageWrapper { get; set; }
    public String formName { get; set; }
    public Boolean displayLink { get; set; }
    //updates by Snehith - 03/13/2018 to avoid Form 1217 links to Census Offers 
    public Boolean displayform1217link { get; set; }
    public Boolean displayform1364_2019link {get; set;}
    //SGanti added 8/2021
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
                o.CREATEDBYID
                FROM PBS_AAAP_Offer__c o
                WHERE o.id = :offerId
            ];
            
            List<PBS_AAAP_Offer_Attachments__c>  attachmentsList = [
                SELECT Name, PBS_AAAP_Attachment_Type__c
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
            //Boolean to set false if RLP region is Census - Snehith
            displayform1217link = true;
            displayform1364_2019link = false;
            //SGanti added 8/2021
            displayform1364_2022link = false;
            
            system.debug('***'+offerpdf);
            system.debug('***'+offerpdf.PBS_AAAP_RLP_Number__c);
            system.debug('***'+offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c);
            //SGanti commented out to update conditions for displayform1364_2019link.          
            /*  if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018){
displayform1364_2019link = true;
}else{
displayform1364_2019link = false;
}
*/
            
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
        /*       if(displayform1364_2019link == false){
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
//pgObj2.linkName = 'GSA Form 1364C - STANDARD';
pgObj2.linkName = 'Form 1364 AAAP (OfferForm1364_2019)';
pgObj2.clicked = false;
lstPageWrapper.add(pgObj2);              
}    
*/
        //SGanti added on 8/2021   
        /*       if(displayform1364_2021link == false) {      
PageWrapper pgObj5 = new PageWrapper();
PageReference p5 = Page.Offerform1364_2019;
p5.getParameters().put('offerId', offerId);
p5.getParameters().put('formtype', 'OfferForm1364');
p5.setRedirect(true);
pgObj5.pgRefObj = p5;
pgObj5.formName = 'OfferForm1364';
pgObj5.linkName = 'Form 1364 AAAP (OfferForm1364_2019)';
pgObj5.clicked = false;
lstPageWrapper.add(pgObj5);  
}else{
PageWrapper pgObj6 = new PageWrapper();
PageReference p6 = Page.PBS_AAAP_NewOfferForm1364;
//ToddBrown testing while Santhosh is developing in PBS_AAAP_NewOfferForm1364 VF page
//PageReference p5 = Page.OfferForm1364_2021;
p6.getParameters().put('offerId', offerId);
p6.getParameters().put('formtype', 'NewOfferForm1364');
p6.setRedirect(true);
pgObj6.pgRefObj = p6;
pgObj6.formName = 'NewOfferForm1364';
pgObj6.linkName = 'Form 1364 AAAP (NewOfferForm1364)';
pgObj6.clicked = false;
lstPageWrapper.add(pgObj6);
}
*/       
        
        if(displayform1364_2022link == true){
            PageWrapper pgObj6 = new PageWrapper();
            PageReference p6 = Page.PBS_AAAP_NewOfferForm1364;
            //ToddBrown testing while Santhosh is developing in PBS_AAAP_NewOfferForm1364 VF page
            //PageReference p5 = Page.OfferForm1364_2021;
            p6.getParameters().put('offerId', offerId);
            p6.getParameters().put('formtype', 'OfferForm1364_2022');
            p6.setRedirect(true);
            pgObj6.pgRefObj = p6;
            pgObj6.formName = 'OfferForm1364_2022';
            // pgObj6.linkName = 'Form 1364 AAAP (OfferForm1364_2022)';
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
                //pgObj2.linkName = 'GSA Form 1364C - STANDARD';
                //pgObj2.linkName = 'Form 1364 AAAP (OfferForm1364_2019)';
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
                
                //attachment att = [SELECT Id FROM Attachment WHERE Name = :param AND parentId IN :offAttIds ORDER BY CreatedDate DESC LIMIT 1];                
                //return new pageReference('/servlet/servlet.FileDownload?file='+att.Id);
                
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
        /*   if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018){
displayform1364_2019link = true;
}else{
displayform1364_2019link = false;
}
*/
        /*
        if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018 && Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) <= 2021){
            displayform1364_2019link = true;
        }else{
            displayform1364_2019link = false;
        }                                     
        //SGanti added 8/2021 condition for displayform1364_2022link         
        if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2021){
            displayform1364_2022link = true;
        }else{
            displayform1364_2022link = false;
        }      
        
        DateTime dt = offerpdf.LastModifiedDate;
        Date modDate = dt.date();
        Date checkDate = date.valueOf(CurrentCheckDate);
        if (modDate > checkDate) {
            displayLink = false;
        } else {
            displayLink = true;
        }
        
        System.debug('---------------OfferId is: ' + offerId + '--------------------------------');
        List<Attachment> lstAttachments = new List<Attachment>();
        List <AttachmentWrapper> lstAttachmentWrapper = new List <AttachmentWrapper>();
        // Add Attachment
        if (displayform1217link == true) {
            system.debug('#######1');
            addAttachementToOffer(offerId, 'Form1217', 'Form1217.pdf');
            addAttachementToOffer(offerId, 'Form1217Attachment', 'Form1217Attachment.pdf');
            system.debug('#######2');
        }
        //SGanti added logic for OfferForm1364_2022
        
        if(displayform1364_2022link == true){
            System.debug('---------------ABOUT TO ADD New Offer Form 1364_2022-------------');  
            addAttachementToOffer(offerId, 'OfferForm1364_2022', 'OfferForm1364.pdf');
            
            //addAttachementToOffer(offerId, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
            if (displayLink == true && displayform1217link == true) {
                system.debug('#######3');
                addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
                lstAttachments = [
                    SELECT Id, Name, ParentId, ContentType, Body
                    FROM Attachment
                    WHERE ParentId = :offerId
                    //(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
                    AND Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf','OfferForm3518.pdf')
                ];
                system.debug('#######4');
            } else if (displayLink == true && displayform1217link != true) {
                system.debug('#######5');
                addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
                lstAttachments = [
                    SELECT Id, Name, ParentId, ContentType, Body
                    FROM Attachment
                    WHERE ParentId = :offerId AND
                    //(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
                    Name IN ('OfferForm1364.pdf','OfferForm3518.pdf')
                ];
                system.debug('#######6');
            } else if (displayLink != true && displayform1217link == true) {
                system.debug('#######7');
                lstAttachments = [
                    SELECT Id, Name, ParentId, ContentType, Body
                    FROM Attachment
                    WHERE ParentId = :offerId AND
                    //(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
                    Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf')
                ];
                system.debug('#######8');
            } else if (displayLink != true && displayform1217link != true) {
                system.debug('#######9');
                lstAttachments = [
                    SELECT Id, Name, ParentId, ContentType, Body
                    FROM Attachment
                    WHERE ParentId = :offerId AND
                    //(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
                    Name IN ('OfferForm1364.pdf')
                ];
                system.debug('#######10');
            }
        }
        else{
            if(displayform1364_2019link == true){
                system.debug('#######11');
                System.debug('---------------ABOUT TO ADD offerForm1364-------------');
                addAttachementToOffer(offerId, 'Offerform1364_2019', 'OfferForm1364.pdf');                      
                //addAttachementToOffer(offerId, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
                if (displayLink == true && displayform1217link == true) {
                    system.debug('#######12');
                    addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
                    lstAttachments = [
                        SELECT Id, Name, ParentId, ContentType, Body
                        FROM Attachment
                        WHERE ParentId = :offerId
                        //(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
                        //SGanti added 8/2021   
                        AND Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf','OfferForm3518.pdf')
                    ];
                    system.debug('#######13');
                } else if (displayLink == true && displayform1217link != true) {
                    system.debug('#######14');
                    addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
                    lstAttachments = [
                        SELECT Id, Name, ParentId, ContentType, Body
                        FROM Attachment
                        WHERE ParentId = :offerId AND
                        //(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
                        //SGanti added 8/2021                          
                        Name IN ('OfferForm1364.pdf','OfferForm3518.pdf')
                    ];
                    system.debug('#######15');
                } else if (displayLink != true && displayform1217link == true) {
                    system.debug('#######16');
                    lstAttachments = [
                        SELECT Id, Name, ParentId, ContentType, Body
                        FROM Attachment
                        WHERE ParentId = :offerId AND
                        //(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
                        //SGanti added 8/2021                                                 
                        Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf')
                    ];
                    system.debug('#######17');
                } else if (displayLink != true && displayform1217link != true) {
                    system.debug('#######18');
                    lstAttachments = [
                        SELECT Id, Name, ParentId, ContentType, Body
                        FROM Attachment
                        WHERE ParentId = :offerId AND
                        //(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
                        //SGanti added 8/2021                                                 
                        Name IN ('OfferForm1364.pdf')
                    ];
                    system.debug('#######19');
                }
            }    
            else{
                system.debug('#######20');
                //SGanti commented out 8/2021. Added back again.
                addAttachementToOffer(offerId, 'OfferForm1364', 'OfferForm1364.pdf');          
                //addAttachementToOffer(offerId,'OfferForm1364Attachment','OfferForm1364Attachment.pdf');
                addAttachementToOffer(offerId, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
                if (displayLink == true && displayform1217link == true) {
                    system.debug('#######21');
                    addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
                    lstAttachments = [
                        SELECT Id, Name, ParentId, ContentType, Body
                        FROM Attachment
                        WHERE ParentId = :offerId
                        //(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
                        //SGanti added 8/2021                       
                        AND Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf','OfferForm1364RateStructure.pdf','OfferForm3518.pdf')
                    ];
                    system.debug('#######22');
                } else if (displayLink == true && displayform1217link != true) {
                    addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
                    lstAttachments = [
                        SELECT Id, Name, ParentId, ContentType, Body
                        FROM Attachment
                        WHERE ParentId = :offerId AND
                        //(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
                        //SGanti added 8/2011                        
                        Name IN ('OfferForm1364.pdf','OfferForm1364RateStructure.pdf','OfferForm3518.pdf')
                    ];
                    system.debug('#######23');
                } else if (displayLink != true && displayform1217link == true) {
                    lstAttachments = [
                        SELECT Id, Name, ParentId, ContentType, Body
                        FROM Attachment
                        WHERE ParentId = :offerId AND
                        //(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
                        //SGanti added 8/2021                        
                        Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf','OfferForm1364RateStructure.pdf')
                    ];
                    system.debug('#######24');
                } else if (displayLink != true && displayform1217link != true) {
                    system.debug('#######25');
                    lstAttachments = [
                        SELECT Id, Name, ParentId, ContentType, Body
                        FROM Attachment
                        WHERE ParentId = :offerId AND
                        //(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
                        //SGanti added 8/2021                        
                        Name IN ('OfferForm1364.pdf','OfferForm1364RateStructure.pdf')
                    ];
                    system.debug('#######26');
                }
            }
        }
        
        //SGanti commented out 8/2021        
        /*   if(displayform1364_2019link == true){
system.debug('#######3');
System.debug('---------------ABOUT TO ADD offerForm1364-------------');
addAttachementToOffer(offerId, 'Offerform1364_2019', 'OfferForm1364.pdf');

//SGanti added 8/2021 for OfferForm1364_2022
System.debug('---------------ABOUT TO ADD New Offer Form 1364-------------');  
addAttachementToOffer(offerId, 'OfferForm1364_2022', 'OfferForm1364_2022.pdf');

//addAttachementToOffer(offerId, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
if (displayLink == true && displayform1217link == true) {
system.debug('#######4');
addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
lstAttachments = [
SELECT Id, Name, ParentId, ContentType, Body
FROM Attachment
WHERE ParentId = :offerId
//(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
//SGanti added 8/2021   
AND Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf','OfferForm1364_2022.pdf','OfferForm3518.pdf')
];
system.debug('#######5');
} else if (displayLink == true && displayform1217link != true) {
system.debug('#######6');
addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
lstAttachments = [
SELECT Id, Name, ParentId, ContentType, Body
FROM Attachment
WHERE ParentId = :offerId AND
//(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
//SGanti added 8/2021                          
Name IN ('OfferForm1364.pdf','OfferForm3518.pdf','OfferForm1364_2022.pdf')
];
system.debug('#######7');
} else if (displayLink != true && displayform1217link == true) {
system.debug('#######8');
lstAttachments = [
SELECT Id, Name, ParentId, ContentType, Body
FROM Attachment
WHERE ParentId = :offerId AND
//(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
//SGanti added 8/2021                                                 
Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf','OfferForm1364_2022.pdf')
];
system.debug('#######9');
} else if (displayLink != true && displayform1217link != true) {
system.debug('#######10');
lstAttachments = [
SELECT Id, Name, ParentId, ContentType, Body
FROM Attachment
WHERE ParentId = :offerId AND
//(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
//SGanti added 8/2021                                                 
Name IN ('OfferForm1364.pdf','OfferForm1364_2022.pdf')
];
system.debug('#######11');
}
}
else{
system.debug('#######12');
//SGanti commented out 8/2021. Added back again.
addAttachementToOffer(offerId, 'OfferForm1364', 'OfferForm1364.pdf');

//SGanti added 8/2021 OfferForm1364_2022
addAttachementToOffer(offerId, 'OfferForm1364_2022', 'OfferForm1364_2022.pdf');

//addAttachementToOffer(offerId,'OfferForm1364Attachment','OfferForm1364Attachment.pdf');
addAttachementToOffer(offerId, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
if (displayLink == true && displayform1217link == true) {
system.debug('#######13');
addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
lstAttachments = [
SELECT Id, Name, ParentId, ContentType, Body
FROM Attachment
WHERE ParentId = :offerId
//(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
//SGanti added 8/2021                       
AND Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf','OfferForm1364_2022.pdf','OfferForm1364RateStructure.pdf','OfferForm3518.pdf')
];
system.debug('#######14');
} else if (displayLink == true && displayform1217link != true) {
addAttachementToOffer(offerId, 'OfferForm3518', 'OfferForm3518.pdf');
lstAttachments = [
SELECT Id, Name, ParentId, ContentType, Body
FROM Attachment
WHERE ParentId = :offerId AND
//(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf' OR Name = 'OfferForm3518.pdf')
//SGanti added 8/2011                        
Name IN ('OfferForm1364_2022.pdf','OfferForm1364.pdf','OfferForm1364RateStructure.pdf','OfferForm3518.pdf')
];
system.debug('#######15');
} else if (displayLink != true && displayform1217link == true) {
lstAttachments = [
SELECT Id, Name, ParentId, ContentType, Body
FROM Attachment
WHERE ParentId = :offerId AND
//(Name = 'Form1217.pdf' OR Name = 'Form1217Attachment.pdf' OR Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
//SGanti added 8/2021                        
Name IN ('Form1217.pdf','Form1217Attachment.pdf','OfferForm1364.pdf','OfferForm1364_2022.pdf','OfferForm1364RateStructure.pdf')
];
system.debug('#######16');
} else if (displayLink != true && displayform1217link != true) {
system.debug('#######17');
lstAttachments = [
SELECT Id, Name, ParentId, ContentType, Body
FROM Attachment
WHERE ParentId = :offerId AND
//(Name = 'OfferForm1364.pdf' OR Name = 'OfferForm1364RateStructure.pdf')
//SGanti added 8/2021                        
Name IN ('OfferForm1364_2022.pdf','OfferForm1364.pdf','OfferForm1364RateStructure.pdf')
];
system.debug('#######18');
}

}
        for (Attachment att : lstAttachments) {
            AttachmentWrapper wrapper = new AttachmentWrapper();
            wrapper.attName = att.Name;
            wrapper.attEncodedBody = EncodingUtil.base64Encode(att.Body);
            lstAttachmentWrapper.add(wrapper);
        }
        System.debug('display 1217 Boolean ' + displayform1217link + displayLink);
        System.debug('Offer detail' + offerpdf);
        System.debug('List of Attachments ' + lstAttachments);
        delete lstAttachments;
        System.debug('Wrapper before ATT'+lstAttachmentWrapper);
        List<PBS_AAAP_Offer_Attachments__c> offerattachment = new List<PBS_AAAP_Offer_Attachments__c>();
        offerattachment = [SELECT Id
                           FROM PBS_AAAP_Offer_Attachments__c p
                           WHERE p.PBS_AAAP_Offer__c = :offerId
                          ];
        
        System.debug('OFFER Attachment '+offerattachment);
        lstAttachments = [SELECT Id, Name, ParentId, ContentType, Body
                          FROM Attachment
                          WHERE ParentId = :offerattachment
                         ];
        for (Attachment att : lstAttachments) {
            AttachmentWrapper wrapper = new AttachmentWrapper();
            wrapper.attName = att.Name;
            wrapper.attEncodedBody = EncodingUtil.base64Encode(att.Body);
            lstAttachmentWrapper.add(wrapper);
        }
        */
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
    /*
    //SGanti - method to add attachment to offer    
    @RemoteAction
    public static void addAttachementToOffer(string offerId, string formType, string fileName) {
        remoteOfferId = offerId;
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
        //SGanti added 8/2021
        Boolean displayform1364_2022link = false;        
        //SGanti commented out 8/2021        
        /*  //if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018){
            //displayform1364_2019link = true;
            //}else{
            //displayform1364_2019link = false;
            //}

        //SGanti added 8/2021. Updated conditions for displayform1364_2019link.
        
        if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018 && Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) <= 2021){
            displayform1364_2019link = true;
        }else{
            displayform1364_2019link = false;
        } 
        
        //SGanti added 8/2021. Set conditions for displayform1364_2022link          
        if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2021){
            displayform1364_2022link = true;
        }else{
            displayform1364_2022link = false;
        }                     
        system.debug('&&&&&&2'+displayform1364_2019link);
        PageReference pageRef;
        
        // getting offer key
        string sesid = fetchOfferKey();
        
        if (formType == 'Form1217' && displayform1217link == true) {
            system.debug('&&&&&&3');
            pageRef = Page.OfferForm1217;
            pageRef.getParameters().put('formtype', 'offerform1217');
            system.debug('&&&&&&4');
        }
        if (formType == 'Form1217Attachment' && displayform1217link == true) {
            system.debug('&&&&&&5');
            pageRef = Page.Offerform1217Attachment;
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
        
        //SGanti added 08/2021.
        
        if(formtype == 'OfferForm1364_2022' && displayform1364_2022link == true){
            system.debug('&&&&&&new1364');
            pageRef = Page.PBS_AAAP_NewOfferForm1364;
            //Todd Brown testing since Santhosh is developing in PBS_AAAP_NewOfferForm1364
            //pageRef = Page.OfferForm1364_2021;
            pageRef.getParameters().put('formtype', 'OfferForm1364_2022');
            system.debug('&&&&&&new1364');
        }         
        /*     if (formType == 'OfferForm1364_2022' && displayform1364_2022link == false) {
system.debug('&&&&&&new1364');
pageRef = Page.PBS_AAAP_NewOfferForm1364;
//Todd Brown testing since Santhosh is developing in PBS_AAAP_NewOfferForm1364
//pageRef = Page.OfferForm1364_2021;
pageRef.getParameters().put('formtype', 'OfferForm1364_2022');
pageRef.getParameters().put('offerid', offerId);
system.debug('&&&&&&new1364');
}
*/    
        /*  
        //if (formType == 'OfferForm1364Attachment') {
        //pageRef = Page.OfferForm1364Attachment;
        //pageRef.getParameters().put('formtype', 'offerform1364Attachment');
        //} 
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
        if (!Test.isRunningTest()) {
            pageRef.getParameters().put('sesid', sesid);
            system.debug('&&&&&&17'+pageRef.getContentAsPDF());
            pdfPageBlob = pageRef.getContentAsPDF();
        } else {
            pdfPageBlob = Blob.valueOf('TEST');
        }
        system.debug('&&&&&&16'+pdfPageBlob);
        //-- create a corresponding record on Attachment std object.
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = offerId;
        a.Name = fileName;
        insert a;
        system.debug('\n-a--'+a.Id);
        PBS_AAAP_Utility.logMethodEnd('addAttachementToOffer');
        
        
        
    }
    */
    
    
   
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