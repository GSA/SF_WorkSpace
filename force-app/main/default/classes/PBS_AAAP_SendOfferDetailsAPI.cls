/*******************************************************************************************
* Name: PBS_AAAP_SendOfferDetailsAPI
* Test : Test_PBS_AAAP_AwardSelectedOfferContr
* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              ???               ????               Initial Creation   
*  1.1              Vanwinkle T       3/14/2021          update to With Shraring per SFWS-1666
                    Ramya              9/15/2022          updated to without sharing 
*******************************************************************************/

public without sharing class PBS_AAAP_SendOfferDetailsAPI { 
    public static DateTime submitedDateTime;
    public static Date submitedDate;
    @future(callout=true)
    public static void sendOfferDetails(string offerRecDetails){
        system.debug('\n--offerRecDetails--'+offerRecDetails);

        // de serialze the offer record
        PBS_AAAP_Offer__c offerRec = (PBS_AAAP_Offer__c)System.JSON.deserialize(offerRecDetails, PBS_AAAP_Offer__c.class);
        system.debug('\n--offerRec--'+offerRec);
        
        List<PBS_AAAP_Submission_Attempt_History__c> submissionAttemptHistoryRecords = [Select Id, Offer__c, Date__c From PBS_AAAP_Submission_Attempt_History__c Where Offer__c = :offerRec.Id Order By Date__c Desc Limit 1];
        if(submissionAttemptHistoryRecords.size() > 0){
            submitedDateTime = submissionAttemptHistoryRecords[0].Date__c;
            submitedDate = submissionAttemptHistoryRecords[0].Date__c.date();
        }
        System.debug('submitedDateTime '+submitedDateTime);
        System.debug('submitedDate '+submitedDate);
        //query attachment based upon offer id
        List<PBS_AAAP_Offer_Attachments__c> lstAtt = new List<PBS_AAAP_Offer_Attachments__c>();
        lstAtt = [select id,
                PBS_AAAP_Attachment_Type__c,
                PBS_AAAP_Legacy_Offer_Att_ID__c,
                Offer_Attachments_Name__c,
                PBS_AAAP_Sent_to_GREX__c,
                Document_Description__c
        FROM PBS_AAAP_Offer_Attachments__c
        WHERE PBS_AAAP_Offer__c =: offerRec.Id
        AND PBS_AAAP_Sent_to_GREX__c = FALSE
        ];

        // list of wrapper of doc
        List<documents> lstDoc =  new List<documents>();

        // making doc Wrapper
        system.debug('\n--lstAtt--'+lstAtt);
        List<Id> attOfferIds = new List<Id>();
            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : lstAtt){
                attOfferIds.add(attachmentRecord.Id);
            }
            if(attOfferIds.size() > 0){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocument.LatestPublishedVersionId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
                }
            }
        for(PBS_AAAP_Offer_Attachments__c attCus : lstAtt){
            if(contentDocumentMap.containsKey(attCus.Id)){
                lstDoc.add(new documents(contentDocumentMap.get(attCus.Id),attCus));
            }
        }
        system.debug('\n--lstDoc--'+lstDoc);

        // code for making the request wrapper
        requestWrapper obj = new requestWrapper(offerRec,lstDoc);
        system.debug('\n--obj--'+obj);

        string requestJSON = JSON.serialize(obj);
        system.debug('\n--requestJSON--'+requestJSON);

        /***************** Below is the code section for making callout ****************/
        callOfferAPI(requestJSON,offerRec.Id);

    }

    public static void callOfferAPI(string reqJson, string offerId){
        String returnCode;
        try{
            system.debug('***reqJson***' + reqJson);
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:PBS_AAAP_OfferAPIPwd');
            req.setMethod('POST');
            req.setBody(reqJson);

            // setting header
            req.setHeader('Content-Type','application/json');
            req.setHeader('Content-Length',string.valueOf(reqJson.length()));
            req.setHeader('Appian-API-Key', '{!$Credential.Password}');
            req.setTimeout(120000);

            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('**request**'+req);           
            system.debug('**respone**'+ res.getBody());
            returnCode = string.valueOf(res.getStatusCode());
            system.debug('**returnCode1**'+ returnCode);
      
            if (returnCode == '401') {
                returnCode = ''; res=null;
                HTTPResponse res2 = http.send(req);
                returnCode = string.valueOf(res2.getStatusCode());
                system.debug('**returnCode2**'+ returnCode);               
                res = res2;
                 
                if (returnCode == '401') {
                    returnCode = ''; res=null;
                    HTTPResponse res3 = http.send(req);
                    returnCode = string.valueOf(res3.getStatusCode()); 
                    system.debug('**returnCode3**'+ returnCode); 
                    res = res3;                     
                }    
            }
            system.debug('**final response**'+ res); 
            captureLogs(offerId,reqJson,res.getBody(),string.valueOf(res.getStatusCode()));
        }
        catch(Exception ex){
            captureLogs(offerId,reqJson,ex.getMessage(),'ERR');
        }

    }

    // method to capture api logs
    public static void captureLogs(string offerId, string req, string res, string code){
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(id = offerId);

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(req.length() > 131072)
            offerRec.PBS_AAAP_Request__c = req.substring(0,131072);
        else
                offerRec.PBS_AAAP_Request__c = req;

        if(res.length() > 131072)
            offerRec.PBS_AAAP_Response__c = res;
        else
                offerRec.PBS_AAAP_Response__c = res;

        offerRec.PBS_AAAP_Status_Code__c = code;

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        offerRec.PBS_AAAP_Offer_Submission_Date__c = submitedDate;
        offerRec.PBS_AAAP_Submission_DateTime__c = submitedDateTime;
        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        } else if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Central')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'CST';
        } else if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Mountain')){
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'MST';
        } else if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Pacific')) {
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = 'PST';
        } else {
            offerRec.PBS_AAAP_Offer_Submission_Timezone__c = String.valueOf(UserInfo.getTimeZone().getDisplayName());
        }


        
        update offerRec;

        if(code == '200'){
            List<PBS_AAAP_Offer_Attachments__c> lstOfferAtt = new List<PBS_AAAP_Offer_Attachments__c>();
            List<PBS_AAAP_Offer_Attachments__c> lstOfferAttUpd = new List<PBS_AAAP_Offer_Attachments__c>();
            lstOfferAtt = [
                    SELECT
                            Id,
                            PBS_AAAP_Sent_to_GREX__c,
                            PBS_AAAP_Date_sent_to_GREX__c
                    FROM PBS_AAAP_Offer_Attachments__c
                    WHERE PBS_AAAP_Offer__c = :offerId
            ];

            for(PBS_AAAP_Offer_Attachments__c rec : lstOfferAtt){
                if(rec.PBS_AAAP_Sent_to_GREX__c == FALSE) {
                    rec.PBS_AAAP_Sent_to_GREX__c = TRUE;
                    rec.PBS_AAAP_Date_sent_to_GREX__c = submitedDateTime;
                    lstOfferAttUpd.add(rec);
                }
            }

            if(!lstOfferAttUpd.isEmpty()){
                update lstOfferAttUpd;
            }
        }
    }



    public class requestWrapper{

        public Integer solicitationId {get;set;}
        public string solicitationNumber {get;set;}
        public string ueiNumber {get;set;}
        public string zip {get;set;}
        public string offerId {get;set;}
        public string buildingName {get;set;}
        public string buildingStreetAddress {get;set;}
        public string city {get;set;}
        public string state {get;set;}
        public string space {get;set;}
        public string offerorFirstName {get;set;}
        public string offerorLastName {get;set;}
        public string offerorEmail {get;set;}
        public string offerorTitle {get;set;}
        public string offerorPhone {get;set;}
        public string ownerName {get;set;}
        public Datetime submissionDate {get;set;}
        public List<documents> documents {get;set;}

        public requestWrapper(){

        }

        public requestWrapper(PBS_AAAP_Offer__c offer, List<documents> lstDocuments){
            if(!string.isBlank(offer.PBS_AAAP_Solicitation_Id__c))
                this.solicitationId = integer.valueof(offer.PBS_AAAP_Solicitation_Id__c);
            else
                    this.solicitationId = 0;

            this.solicitationNumber = offer.PBS_AAAP_Solicitation_Number__c;
            this.ueiNumber = offer.PBS_AAAP_DUNS_Number__c;
        	this.zip = offer.PBS_AAAP_ZipCode__c;
            this.offerId = offer.Id;
            this.buildingName = offer.PBS_AAAP_Building_Name__c;
            this.buildingStreetAddress = offer.PBS_AAAP_Street_Address__c;
            this.city = offer.PBS_AAAP_City__c;
            this.state = offer.PBS_AAAP_State__c;
            this.space = offer.PBS_AAAP_floors_and_suites_offered__c;
            this.offerorFirstName = offer.PBS_AAAP_Signature_First_Name__c;
            this.offerorLastName = offer.PBS_AAAP_SIGNATURE_LAST_NAME__c;
            this.offerorEmail = offer.PBS_AAAP_Offeror_Email__c;
            this.offerorTitle = offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
            this.offerorPhone = offer.PBS_AAAP_Offeror_Primary_Phone_Number__c;
            this.ownerName = offer.PBS_AAAP_Owner_Name__c;
            this.submissionDate = submitedDateTime;    //offer.PBS_AAAP_Offer_Submission_Date__c;
            this.documents = new List<documents>();
            this.documents = lstDocuments;
        }

    }

    public class documents{
        public string contentVersionId {get;set;}
        public string fileName {get;set;}
        public string documentType {get;set;}
        public string documentDescription {get;set;}
        
        public documents(){
        }

        public documents(ContentDocumentWrapper contentDocumentWrapperObj ,PBS_AAAP_Offer_Attachments__c attCus){
            this.contentVersionId = contentDocumentWrapperObj.id;
            this.fileName = contentDocumentWrapperObj.Name;
            this.documentDescription = attCus.Document_Description__c;            
            String doc1364 = '1364 - Proposal to Lease Space';
            String doc1217 = '1217 - Lessor’s Annual Cost Statement';
            if(attCus.PBS_AAAP_Attachment_Type__c == 'Offeror GSA Form 1364'){
                this.documentType = doc1364;
            } else if (attCus.PBS_AAAP_Attachment_Type__c == 'Lessors Annual Cost Statement (Form 1217)'){
                this.documentType = doc1217;
            } else {
                this.documentType = attCus.PBS_AAAP_Attachment_Type__c;
            }
        }
    }

    @future(callout=true)
    public static void sendOfferDetailsAAAP(Id ofrId, Id agId, String osaiId, Id mastId, String vPhase){

        system.debug('\n--AAAP GREX Callout--');
        system.debug('vPhase in API Call=' + vPhase);

        PBS_AAAP_Offer__c offerRec = [
                                    SELECT  Id,
                                            PBS_AAAP_Building_Name__c,
                                            PBS_AAAP_Street_Address__c,
                                            PBS_AAAP_City__c,
                                            PBS_AAAP_State__c,
                                            PBS_AAAP_ZipCode__c,
                                            PBS_AAAP_floors_and_suites_offered__c,
                                            PBS_AAAP_Signature_First_Name__c,
                                            PBS_AAAP_SIGNATURE_LAST_NAME__c,
                                            PBS_AAAP_Offeror_Email__c,
                                            PBS_AAAP_OFFEROR_INTEREST_OTHER__c,
                                            PBS_AAAP_Offeror_Primary_Phone_Number__c,
                                            
                                            PBS_AAAP_Owner_Name__c
                                    FROM PBS_AAAP_Offer__c
                                    WHERE Id = :ofrId
                                    LIMIT 1
        ];

        PBS_AAAP_Agency_Requirement__c agencyRec = [
                                                SELECT  Id,
                                                        PBS_AAAP_Project_ID__c
                                                FROM PBS_AAAP_Agency_Requirement__c
                                                WHERE Id = :agId
                                                LIMIT 1
        ];

        List<PBS_AAAP_Offer_Attachments__c> lstAtt = new List<PBS_AAAP_Offer_Attachments__c>();
        
        
        If (vPhase == 'P1'){
            lstAtt = [
                    SELECT  Id,
                            PBS_AAAP_Attachment_Type__c,
                            PBS_AAAP_Legacy_Offer_Att_ID__c,
                            Offer_Attachments_Name__c,
                            Document_Description__c,
                            PBS_AAAP_Sent_to_GREX__c
                    FROM PBS_AAAP_Offer_Attachments__c
                    WHERE PBS_AAAP_Offer__c =: offerRec.Id
            ];        
        }
        
        If (vPhase == 'P2'){
            lstAtt = [
                    SELECT  Id,
                            PBS_AAAP_Attachment_Type__c,
                            PBS_AAAP_Legacy_Offer_Att_ID__c,
                            Offer_Attachments_Name__c,
                            Document_Description__c,
                            PBS_AAAP_Sent_to_GREX__c
                    FROM PBS_AAAP_Offer_Attachments__c
                    WHERE PBS_AAAP_Offer__c =: offerRec.Id
                    AND PBS_AAAP_Sent_to_GREX__c = FALSE
            ];        
        } 
        
        
        system.debug('lstAtt' + lstAtt);       

        List<documentsAAAP> lstDoc =  new List<documentsAAAP>();
        List<Id> attOfferIds = new List<Id>();
            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
            for(PBS_AAAP_Offer_Attachments__c attachmentRecord : lstAtt){
                attOfferIds.add(attachmentRecord.Id);
            }
            if(attOfferIds.size() > 0){
                List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                    contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocument.LatestPublishedVersionId, contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.CreatedDate, contentDocumentLinkRecord.ContentDocument.Description));
                }
            }
        for(PBS_AAAP_Offer_Attachments__c attCus : lstAtt){
            if(contentDocumentMap.containsKey(attCus.Id)){
                lstDoc.add(new documentsAAAP(contentDocumentMap.get(attCus.Id),attCus));
            }
        }
        
        system.debug('\n--lstDoc--'+lstDoc);

        requestWrapperAAAP obj = new requestWrapperAAAP(offerRec, agencyRec, lstDoc);
        system.debug('\n--obj--'+obj);

        string requestJSON = JSON.serialize(obj);
        system.debug('\n--requestJSON--'+requestJSON);

        /***************** Below is the code section for making callout ****************/
        callOfferAPIAAAP(requestJSON, osaiId, mastId);
    }

    public static void callOfferAPIAAAP(string reqJson, string osaiId, Id masterId){
        String returnCode;
        try{
            system.debug('***reqJson***' + reqJson);
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:PBS_AAAP_OfferAPIPwdAAAP');
            req.setMethod('POST');
            req.setBody(reqJson);

            // setting header
            req.setHeader('Content-Type','application/json');
            req.setHeader('Content-Length',string.valueOf(reqJson.length()));
            req.setHeader('Appian-API-Key', '{!$Credential.Password}');
            req.setTimeout(120000);

            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('**request**'+req);           
            system.debug('**response**'+ res.getBody());
            returnCode = string.valueOf(res.getStatusCode());
            system.debug('**returnCode1**'+ returnCode);
          
            if (returnCode == '401') {
                returnCode = '';
                HTTPResponse res2 = http.send(req);
                returnCode = string.valueOf(res2.getStatusCode());
                system.debug('**returnCode2**'+ returnCode); 
                res = res2;
                 
                if (returnCode == '401') {
                    returnCode = '';
                    HTTPResponse res3 = http.send(req);
                    returnCode = string.valueOf(res3.getStatusCode()); 
                    system.debug('**returnCode3**'+ returnCode); 
                    res = res3;                     
                }    
            }
            system.debug('**final response**'+ res);
            captureLogsAAAP(osaiId,reqJson,res.getBody(),string.valueOf(res.getStatusCode()), masterId);
        }
        catch(Exception ex){
            captureLogsAAAP(osaiId,reqJson,ex.getMessage(),'ERR', masterId);
        }

    }

    // method to capture api logs
    public static void captureLogsAAAP(string osaiId, string req, string res, string code, Id masOffId){
        PBS_AAAP_Offer_Select_Award_Info__c osaiRec = new PBS_AAAP_Offer_Select_Award_Info__c(id = osaiId);

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(req.length() > 131072)
            osaiRec.PBS_AAAP_Request__c = req.substring(0,131072);
        else
            osaiRec.PBS_AAAP_Request__c = req;

        if(res.length() > 131072)
            osaiRec.PBS_AAAP_Response__c = res;
        else
            osaiRec.PBS_AAAP_Response__c = res;

        osaiRec.PBS_AAAP_Status_Code__c = code;

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        }

        osaiRec.PBS_AAAP_Offer_Submission_Date__c = system.today();
        osaiRec.PBS_AAAP_Submission_DateTime__c = system.now();
        if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Eastern')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'EST';
        } else if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Central')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'CST';
        } else if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Mountain')){
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'MST';
        } else if(String.valueOf(UserInfo.getTimeZone().getDisplayName()).contains('Pacific')) {
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = 'PST';
        } else {
            osaiRec.PBS_AAAP_Offer_Submission_Timezone__c = String.valueOf(UserInfo.getTimeZone().getDisplayName());
        }


        
        update osaiRec;

        if(code == '200') {
            system.debug('\n--updateAttachments--' + osaiRec);
            system.debug('\n--updateAttachments--' + osaiRec.PBS_AAAP_Offer_ID__c);
            List<PBS_AAAP_Offer_Attachments__c> lstOfferAtt = new List<PBS_AAAP_Offer_Attachments__c>();
            List<PBS_AAAP_Offer_Attachments__c> lstOfferAttUpd = new List<PBS_AAAP_Offer_Attachments__c>();
            PBS_AAAP_Offer_Select_Award_Info__c OSAI = [SELECT PBS_AAAP_Offer_ID__c FROM PBS_AAAP_Offer_Select_Award_Info__c WHERE Id = :osaiRec.Id LIMIT 1];
            lstOfferAtt = [
                    SELECT
                            Id,
                            PBS_AAAP_Sent_to_GREX__c,
                            PBS_AAAP_Date_sent_to_GREX__c
                    FROM PBS_AAAP_Offer_Attachments__c
                    WHERE PBS_AAAP_Offer__c = :OSAI.PBS_AAAP_Offer_ID__c
            ];

            system.debug('\n--updateAttachments--' + lstOfferAtt);

            for (PBS_AAAP_Offer_Attachments__c rec : lstOfferAtt) {
                if (rec.PBS_AAAP_Sent_to_GREX__c == FALSE) {
                    rec.PBS_AAAP_Sent_to_GREX__c = TRUE;
                    rec.PBS_AAAP_Date_sent_to_GREX__c = system.now();
                    lstOfferAttUpd.add(rec);
                }
            }

            system.debug('\n--updateAttachments--' + lstOfferAttUpd);

            if (!lstOfferAttUpd.isEmpty()) {
                update lstOfferAttUpd;
            }

            if(masOffId != null){
                system.debug('\n--updateAttachments2--' + masOffId);
                List<PBS_AAAP_Offer_Attachments__c> lstOfferAtt2 = new List<PBS_AAAP_Offer_Attachments__c>();
                List<PBS_AAAP_Offer_Attachments__c> lstOfferAttUpd2 = new List<PBS_AAAP_Offer_Attachments__c>();
                //PBS_AAAP_Offer_Select_Award_Info__c OSAI = [SELECT PBS_AAAP_Offer_ID__c FROM PBS_AAAP_Offer_Select_Award_Info__c WHERE Id = :osaiRec.Id LIMIT 1];
                lstOfferAtt2 = [
                        SELECT
                                Id,
                                PBS_AAAP_Sent_to_GREX__c,
                                PBS_AAAP_Date_sent_to_GREX__c
                        FROM PBS_AAAP_Offer_Attachments__c
                        WHERE PBS_AAAP_Offer__c = :masOffId
                ];

                system.debug('\n--updateAttachments--' + lstOfferAtt2);

                for (PBS_AAAP_Offer_Attachments__c rec : lstOfferAtt2) {
                    if (rec.PBS_AAAP_Sent_to_GREX__c == FALSE) {
                        rec.PBS_AAAP_Sent_to_GREX__c = TRUE;
                        rec.PBS_AAAP_Date_sent_to_GREX__c = system.now();
                        lstOfferAttUpd2.add(rec);
                    }
                }

                system.debug('\n--updateAttachments--' + lstOfferAttUpd2);

                if (!lstOfferAttUpd2.isEmpty()) {
                    update lstOfferAttUpd2;
                }
            }
        }
    }



    public class requestWrapperAAAP{

        public string projectNumber {get;set;}
        public string salesforceOfferId {get;set;}
        public string buildingName {get;set;}
        public string buildingStreetAddress {get;set;}
        public string city {get;set;}
        public string state {get;set;}
        public string zip {get;set;}
        public string floorSuiteNumber {get;set;}
        public string offerorFirstName {get;set;}
        public string offerorLastName {get;set;}
        public string offerorEmail {get;set;}
        public string offerorTitle {get;set;}
        public string offerorPhone {get;set;}
        public string ownerName {get;set;}
        public Datetime offerSubmissionDate {get;set;}
        public List<documentsAAAP> documents {get;set;}

        public requestWrapperAAAP(){

        }

        public requestWrapperAAAP(PBS_AAAP_Offer__c offer, PBS_AAAP_Agency_Requirement__c agReq, List<documentsAAAP> lstDocuments){

            this.projectNumber = agReq.PBS_AAAP_Project_ID__c;
            this.salesforceOfferId = offer.Id;
            this.buildingName = offer.PBS_AAAP_Building_Name__c;
            this.buildingStreetAddress = offer.PBS_AAAP_Street_Address__c;
            this.city = offer.PBS_AAAP_City__c;
            this.state = offer.PBS_AAAP_State__c;
            this.zip = offer.PBS_AAAP_ZipCode__c;
            this.floorSuiteNumber = offer.PBS_AAAP_floors_and_suites_offered__c;
            this.offerorFirstName = offer.PBS_AAAP_Signature_First_Name__c;
            this.offerorLastName = offer.PBS_AAAP_SIGNATURE_LAST_NAME__c;
            this.offerorEmail = offer.PBS_AAAP_Offeror_Email__c;
            this.offerorTitle = offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
            this.offerorPhone = offer.PBS_AAAP_Offeror_Primary_Phone_Number__c;
            this.ownerName = offer.PBS_AAAP_Owner_Name__c;
            this.offerSubmissionDate = system.now();    //offer.PBS_AAAP_Offer_Submission_Date__c;
            this.documents = new List<documentsAAAP>();
            this.documents = lstDocuments;
        }

    }

    public class documentsAAAP{
        public string contentVersionId {get;set;}
        public string fileName {get;set;}
        public string documentType {get;set;}
        public string documentDescription {get;set;}
       
    
        public documentsAAAP(){
        }

        public documentsAAAP(ContentDocumentWrapper contentDocumentWrapperObj ,PBS_AAAP_Offer_Attachments__c attCus){
            this.contentVersionId = contentDocumentWrapperObj.id;
            this.fileName = contentDocumentWrapperObj.Name;
            String doc1364 = 'Form 1364 AAAP';
            String doc1217 = 'Lessor\'s Annual Cost Statement (Form 1217)';
            String doc1217A = 'Lessor\'s Annual Cost Statement (Form 1217 Attachment)';
            this.documentDescription = attCus.Document_Description__c;            
            if(attCus.PBS_AAAP_Attachment_Type__c == 'Form 1364 AAAP'){
                this.documentType = doc1364;
            } else if (attCus.PBS_AAAP_Attachment_Type__c == 'Lessors Annual Cost Statement (Form 1217)'){
                this.documentType = doc1217;
            } else if (attCus.PBS_AAAP_Attachment_Type__c == 'Lessors Annual Cost Statement (Form 1217 Attachment)') {
                this.documentType = doc1217A;
            } else {
                this.documentType = attCus.PBS_AAAP_Attachment_Type__c;
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
}