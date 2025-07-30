public without sharing class PBS_Leasing_AttachmentController {
    // Instantiate the DAO utility object
    public static PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
    @AuraEnabled
    public static ResponseWrapper getColumnsAndRecords(String datatableName, String recordId, Boolean isDisabledDelete){
        // Create a page reference to a specific Visualforce page
        
        // Initialize the response wrapper object
        ResponseWrapper responseWrapperObj = new ResponseWrapper();
        List<String> fields = new List<String>();
        // Query for metadata associated with the dynamic datatable
        PBS_Leasing_Dynamic_Datatable__mdt dynamicDatatableObj = [SELECT Id, DeveloperName, Label, PBS_Leasing_Object_API_Name__c, PBS_Leasing_Related_Field_API_Name__c, Filter__c FROM PBS_Leasing_Dynamic_Datatable__mdt where DeveloperName =:datatableName];
        // Set the label in the response wrapper
        responseWrapperObj.label = dynamicDatatableObj.Label;
        // Query for columns associated with the dynamic datatable
        for(PBS_Leasing_Dynamic_Datatable_Column__mdt dynamicDatatableColumn : [SELECT Id, Label,PBS_Leasing_Order__c  , PBS_Leasing_Field_API_Name__c, PBS_Leasing_Type__c, Initial_Width__c FROM PBS_Leasing_Dynamic_Datatable_Column__mdt where PBS_Leasing_Dynamic_Datatable__r.DeveloperName = :datatableName order by PBS_Leasing_Order__c Asc]){
            ColumnWrapper column = new ColumnWrapper(); 
            column.label = dynamicDatatableColumn.Label;
            column.fieldName = dynamicDatatableColumn.PBS_Leasing_Field_API_Name__c;
            column.type = dynamicDatatableColumn.PBS_Leasing_Type__c;
            column.initialWidth = dynamicDatatableColumn.Initial_Width__c;
            // Initialize and set type attributes for the column
            TypeAttribute typeAttributeObj = new TypeAttribute();
            typeAttributeObj.name = dynamicDatatableColumn.Label;
            // Configure special attributes for specific columns
            if(dynamicDatatableColumn.Label == 'DELETE FILE'){
                column.type= 'button-icon';
                typeAttributeObj.iconClass= 'slds-icon-text-error';
                column.sortable = false;
                typeAttributeObj.variant = 'destructive';
                typeAttributeObj.label = '';
                if(isDisabledDelete){
                    typeAttributeObj.disabled = true;
                }
                typeAttributeObj.iconName = 'utility:delete';
                column.fixedWidth = 100;
                column.cellAttributes.alignment = 'center';
            }else if(dynamicDatatableColumn.Label == 'VIEW FILE'){
                column.type= 'button-icon';
                typeAttributeObj.variant = 'brand';
                typeAttributeObj.label = '';
                typeAttributeObj.iconName = 'utility:preview';
                column.sortable = false;
                column.fixedWidth = 100;
                column.cellAttributes.alignment = 'center';
            }
            // Configure date formatting for date columns
            if(dynamicDatatableColumn.PBS_Leasing_Type__c == 'date'){
                typeAttributeObj.month = '2-digit';
                typeAttributeObj.day = '2-digit';
                typeAttributeObj.year = 'numeric';
            }
            // Configure datetime formatting for a specific column
            if(dynamicDatatableColumn.Label == 'Date/Time Submitted'){
                typeAttributeObj.month = '2-digit';
                typeAttributeObj.day = '2-digit';
                typeAttributeObj.year = 'numeric';
                typeAttributeObj.hour = '2-digit';
                typeAttributeObj.minute = '2-digit';
                typeAttributeObj.hour12 = true;
            }
            // Add field API name to the list of fields to query, excluding specific ones
            if(dynamicDatatableColumn.PBS_Leasing_Field_API_Name__c != Null && dynamicDatatableColumn.PBS_Leasing_Field_API_Name__c != 'Title' 
               && dynamicDatatableColumn.PBS_Leasing_Field_API_Name__c != 'RecordNumber'){
                   fields.add(dynamicDatatableColumn.PBS_Leasing_Field_API_Name__c);
               }
            if(dynamicDatatableColumn.Label == 'NO #'){
                column.fixedWidth = 50;
            }
            if(dynamicDatatableColumn.Label == 'DATE UPLOADED'){
                column.fixedWidth = 120;
            }
            // Add the column wrapper to the response
            responseWrapperObj.columns.add(column);
            
            column.typeAttributes = typeAttributeObj;
        }
        
        List<Map<String,Object>> records = new List<Map<String,Object>>();
        
        // Add 'Id' to the list of fields to query        
        fields.add('Id');
        // Build and execute the dynamic SOQL query

        String query = 'SELECT ' + String.join(fields, ',') + ' FROM ' + dynamicDatatableObj.PBS_Leasing_Object_API_Name__c + ' WHERE ' + dynamicDatatableObj.PBS_Leasing_Related_Field_API_Name__c + ' = :recordId';
        if(dynamicDatatableObj.Filter__c != Null){
            query += ' AND '+dynamicDatatableObj.Filter__c;
        }
        List<sObject> sObjectRecords = Database.query(query);
        Integer counter = 1;
        Set<Id> attachmentIds = new Set<Id>();
        for(sObject sObjectRecord : sObjectRecords){
            attachmentIds.add(sObjectRecord.Id);
        }
        // Query for related content document links if records are found
        if(attachmentIds.size() > 0){
            Map<Id, ContentDocumentLink> contentDocumentMap = new Map<Id, ContentDocumentLink>();
            List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attachmentIds];
            for(ContentDocumentLink contentDocumentLinkRecord : contentDocumentLinks){
                contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,contentDocumentLinkRecord);
            }
            // Populate records data with queried field values and content document details
            for(sObject sObjectRecord : sObjectRecords){
                Map<String,Object> recordData = new Map<String,Object>();
                for(String fieldAPIName : fields){
                    Object fieldValue = sObjectRecord.get(fieldAPIName);
                    System.debug('Field: ' + fieldAPIName + ', Value: ' + fieldValue);
                    recordData.put(fieldAPIName, fieldValue);
                    
                }
                recordData.put('RecordNumber', counter);
                recordData.put('ContentDocumentId', contentDocumentMap.get(String.valueOf(sObjectRecord.Id)).Id);
                recordData.put('Title', contentDocumentMap.get(String.valueOf(sObjectRecord.Id)).ContentDocument.Title);
                recordData.put('PreviewLink', contentDocumentMap.get(String.valueOf(sObjectRecord.Id)).ContentDocument.Description);
                records.add(recordData);
                counter++;
            }
            // Add the populated records to the response wrapper
            responseWrapperObj.records = records;
        }
        // Return the response wrapper containing columns and records
        return responseWrapperObj;
    }
    // Wrapper class for the response
    public class ResponseWrapper{
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public List<ColumnWrapper> columns{get;set;}
        @AuraEnabled public List<Map<String,Object>> records{get;set;}
        // Constructor to initialize lists
        public ResponseWrapper(){
            this.columns = new List<ColumnWrapper>();
            this.records = new List<Map<String,Object>>();
        }
    }   
    // Wrapper class for column data
    public class ColumnWrapper{
        @AuraEnabled public string fieldName{get;set;}
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string type{get;set;}
        @AuraEnabled public string initialWidth{get;set;}
        @AuraEnabled public Boolean wrapText{get;set;}
        @AuraEnabled public Boolean hideDefaultActions{get;set;}
        @AuraEnabled public Boolean sortable{get;set;}
        @AuraEnabled public Integer fixedWidth{get;set;}
        @AuraEnabled public TypeAttribute typeAttributes{get;set;}
        @AuraEnabled public CellAttribute cellAttributes{get;set;}
        // Constructor to set default values
        public ColumnWrapper(){
            wrapText = true;
            hideDefaultActions = true;
            sortable = true;
            cellAttributes = new CellAttribute();
        }
    }
    // Wrapper class for cell attributes
    public class CellAttribute{
        @AuraEnabled public string alignment{get;set;}
        // Constructor to set default alignment
        public CellAttribute(){
            alignment = 'left';
        }
    }
    // Wrapper class for type attributes
    public class TypeAttribute{
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string variant{get;set;}
        @AuraEnabled public string iconName{get;set;}
        @AuraEnabled public string month{get;set;}
        @AuraEnabled public string day{get;set;}
        @AuraEnabled public string year{get;set;}
        @AuraEnabled public string hour{get;set;}
        @AuraEnabled public string minute{get;set;}
        @AuraEnabled public Boolean hour12{get;set;}
        @AuraEnabled public Integer maximumFractionDigits{get;set;}
        @AuraEnabled public Boolean disabled{get;set;}
        @AuraEnabled public string iconClass{get;set;}
        // Empty constructor
        public TypeAttribute(){
            
        }
    }
    
    @AuraEnabled
    public static OfferValidationResponse validateOffer(String offerId, String propertyId, String pageName) {
        // Initialize the response wrapper class
        OfferValidationResponse response = new OfferValidationResponse();
        
        // Fetch the offer details using the provided offerId
        PBS_AAAP_Offer__c submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
        System.debug(String.valueOf(submitOffer.get('PBS_AAAP_GEN_PURPOSE_RENTABLE__c')));
        
        PBS_AAAP_Property__c submitProperty = PBS_Leasing_PropertyController.getPropertyDetails(propertyId);
        PBS_Leasing_PropertyController.ResponseWrapper propertyResponse;
        if(submitProperty != null){
        	propertyResponse = PBS_Leasing_PropertyController.validateProperty(submitProperty,new List<String>{'Offer-Location','Offer-Overview','Offer-Owner','Offer-RLP'});
        	if (propertyResponse.errorMessages.size() > 0 ) {
            	for(String error : propertyResponse.errorMessages){
                response.addErrorMessage(error);
            	}
        	}  
        }
        

        PBS_AAAP_Utility.OfferValidationResponse response1;
        if(submitOffer.RecordType.Name == 'RSAP'){
        	response1 = PBS_AAAP_Utility.validateOffer(submitOffer,new List<String>{'Offer-S-Eligibility','Offer-S-SpaceParking','Offer-S-TermsFinancials','Offer-S-Rent'});
        }else{
            response1 = PBS_AAAP_Utility.validateOffer(submitOffer,new List<String>{'Offer-M-Eligibility','Offer-M-Parking','Offer-M-Costs'});
        }
        if (response1.errorMessages.size() > 0 ) {
            for(String error : response1.errorMessages){
                response.addErrorMessage(error);
            }
        }
        if(submitOffer.RecordType.Name == 'RSAP'){
            
            if (submitOffer.PBS_AAAP_Office_RSF_OFFERED__c <= submitOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) {
                response.addErrorMessage(PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_RSF_GT_ABOA);
            }
            
            if(submitOffer.PBS_AAAP_floors_and_suites_offered__c == Null || submitOffer.PBS_AAAP_floors_and_suites_offered__c == ''){
              response.addErrorMessage('Space and parking Page: Space Offered: 4. List the floor/s and or suite/s of the offered space is required.');  
        	}
            if(submitOffer.PBS_AAAP_Office_RSF_OFFERED__c == Null || submitOffer.PBS_AAAP_Office_RSF_OFFERED__c == 0 || submitOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == Null || submitOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == 0){
              response.addErrorMessage('2d. Total rentable square feet (RSF) in Building on the Property overview page and 2. What is the amount of Rentable Square Feet (RSF) offered on the Space and parking page must be populated for the Prorate function to work.');  
        	}
            
            
            
        }else{
            if(submitOffer.PBS_AAAP_COST_PER_ABOA__c < submitOffer.PBS_AAAP_Vacant_Premise_Rate__c){
                response.addErrorMessage('Costs Page: 28. The Adjustment for Vacant Premises rate is a portion of the total Operating Cost rate, and therefore cannot exceed the total Operating Cost rate. Please input an amount less than the total Operating Cost rate calculated on #4.');
            }
    
            // Initialize flags for further validations
            boolean noSpaceOrRatesFlag = false;
            boolean pvFlag = dao.validatePVRates(submitOffer.Id);
            boolean spaceAndRatesFlag = false;
            boolean flag = false;
            boolean BSACflag = false;
            boolean optionTermFlag = false;
            // Initialize lists to store spaces and rates
            List<PBS_AAAP_Space__c> spaces = new List<PBS_AAAP_Space__c>();
            List<PBS_AAAP_Rate__c> rates = new List<PBS_AAAP_Rate__c>();
            List<ID> spaceId = new List<ID>();
            String spaceIdToReport;
            // Fetch spaces and rates related to the offer
            if (submitOffer.id != null) {
                spaces = [SELECT Id, PBS_AAAP_IDENTIFIER_ID__C, Name, LASTMODIFIEDDATE FROM PBS_AAAP_Space__c WHERE PBS_AAAP_OFFER_NUMBER__c = :submitOffer.Id];
                for (PBS_AAAP_Space__c s : spaces) {
                    spaceId.add(s.Id);
                }
                if (spaces.size() <= 0) {
                    noSpaceOrRatesFlag = true;
                } else {
                    rates = [SELECT Id, PBS_AAAP_SPACE__c, PBS_AAAP_BSAC__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, LASTMODIFIEDDATE, PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, PBS_AAAP_LEASE_TERM__c FROM PBS_AAAP_Rate__c WHERE PBS_AAAP_SPACE__c IN :spaceId AND PBS_AAAP_FULLY_SRVC_FIRM_TERM__c > 0];
                    Map<Id, PBS_AAAP_Rate__c> ratesMap = new Map<Id, PBS_AAAP_Rate__c>();
                    for (PBS_AAAP_Rate__c r : rates) {
                        ratesMap.put(r.PBS_AAAP_SPACE__c, r);
                    }
                    for (PBS_AAAP_Space__c s : spaces) {
                        if (!ratesMap.containsKey(s.Id)) {
                            noSpaceOrRatesFlag = true;
                            break;
                        } else {
                             // Validate specific conditions related to rates
                            for (PBS_AAAP_Rate__c r : rates) {
                                if (r.PBS_AAAP_BSAC__c == null) {
                                    BSACflag = true;
                                    spaceIdToReport = s.PBS_AAAP_IDENTIFIER_ID__c;
                                    break;
                                }
                                if (r.LASTMODIFIEDDATE <= submitOffer.PBS_AAAP_RLP_Number__r.PBS_AAAP_Posted_Date__c) {
                                    spaceAndRatesFlag = true;
                                    break;
                                }
                                if (r.PBS_AAAP_LEASE_TERM__c == '5+5 Years' && (r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c == null || r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c == 0)) {
                                    optionTermFlag = true;
                                    spaceIdToReport = s.PBS_AAAP_IDENTIFIER_ID__c;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            // Add appropriate error messages based on the flags
            if (flag) {
                response.addErrorMessage('You must submit at least one space. For each submitted space, you must submit rate for at least one lease term.');
            }
            if (spaceAndRatesFlag) {
                response.addErrorMessage('Required data is missing in the \'Space & Rates\' section. Please select and \'Edit\' each of the individual Space breakouts and look for required fields that are blank or have values that are not logical. Pressing the \'Save\' button at the bottom of each page will identify possible mistakes on the page.');
            }
            // Fetch the RLP information related to the offer
            PBS_AAAP_RLP__c rlpInfo = dao.getRLP(submitOffer.PBS_AAAP_RLP_Number__c);
            String regionCode = rlpInfo.PBS_AAAP_Region__c;
            // Specific condition for Census region
            if (regionCode == 'Census') { 
                BSACflag = false; 
            }
            // Add additional error messages based on further validations
            if (BSACflag) {
                response.addErrorMessage('BSAC option (#3 /3b on rates page) is not complete for Space # ' + spaceIdToReport + '. Review and hit "Save Rates" button before submitting.');
            }
            if (optionTermFlag) {
                response.addErrorMessage('For Space # ' + spaceIdToReport + ' Enter Base Rate per ANSI/BOMA Office Area square foot (ABOA) for years 6-10. If Base rate is unchanged from years 1-5, enter base rate amount from #1 above.');
            }
            if (pvFlag && !spaceAndRatesFlag) {
                response.addErrorMessage('Before submitting, go back to Cost page and review and save; review Full Service Rent on completed Space and rates page.');
            }
            // Fetch attachments related to the offer
            List<PBS_AAAP_Offer_Attachments__c> attachmentsList = [SELECT Name, PBS_AAAP_Attachment_Type__c 
                                                                   FROM PBS_AAAP_Offer_Attachments__c 
                                                                   WHERE PBS_AAAP_Offer__c = :submitOffer.Id 
                                                                   ORDER BY CreatedDate];
            boolean floorPlanFlag = false;
            boolean authorizationOfOwner = false;
            // Validate the presence of required attachments
            for (PBS_AAAP_Offer_Attachments__c attachment : attachmentsList) {
                if (attachment.PBS_AAAP_Attachment_Type__c == 'Floor Plan') {
                    floorPlanFlag = true;
                }
                if (attachment.PBS_AAAP_Attachment_Type__c == 'Authorization to Represent Ownership Entity') {
                    authorizationOfOwner = true;
                }
            }
            // Add error messages if required attachments are missing
            if (!floorPlanFlag) {
                response.addErrorMessage('Attachments Page: The required Floor Plan document is missing. Please choose the Floor Plan document type as described in Step 3 of the upload instructions.');
                flag = true;
            }
            
            if (submitOffer.PBS_AAAP_OFFEROR_INTEREST__c != 'Owner' && !authorizationOfOwner) {
                response.addErrorMessage('Attachments Page: The Authorization to Represent Ownership Entity document is missing, and is required based on your answer in the Property owner section (question #6). Please choose the Authorization to Represent Ownership Entity document type as described in Step 3 of the upload instructions.');
                flag = true;
            }
            
            if (noSpaceOrRatesFlag) {
                response.addErrorMessage('Space and Rates Page: In order to submit offer, please add at least one space and for each space, enter rate for at least one lease term.');
                flag = true;
            }
            // Set the response success status based on the presence of error messages
        }
        
        if (response.errorMessages.size() > 0) {
            response.success = false;
        } else {
            response.success = true;
            response.addInfoMessage('There are no errors or omissions detected that will prevent you from submitting your offer during an \'Open Period\'. This automated \'check\' does not certify compliance with the AAAP RLP Package. Please return to this page during the next \'Open Period\' (generally the first 7 days of every month) and a yellow \'Review Final Offer\' button will appear allowing you to complete the submission process.');
        }
        // Return the response 
        return response;
    }
    // Helper class to store the response of the validation process
    public class OfferValidationResponse {
        @AuraEnabled public Boolean success { get; set; }
        @AuraEnabled public List<String> errorMessages { get; set; }
        @AuraEnabled public List<String> infoMessages { get; set; }
        // Constructor to initialize the response object
        public OfferValidationResponse() {
            this.success = false;
            this.errorMessages = new List<String>();
            this.infoMessages = new List<String>();
        }
         // Method to add an error message to the response
        public void addErrorMessage(String message) {
            this.errorMessages.add(message);
        }
        // Method to add an informational message to the response
        public void addInfoMessage(String message) {
            this.infoMessages.add(message);
        }
    }
    
    @AuraEnabled
    public static List<DocumentWrapper> insertDocumentLinkRecord(String offerId, List<DocumentWrapper> contentdocumentRecords){
        List<PBS_AAAP_Offer_Attachments__c> offerAttachments = new List<PBS_AAAP_Offer_Attachments__c>();
        Map<Id,ContentDocument> contentDocumentMap = new Map<Id,ContentDocument>();
        for(integer i=0; i< contentdocumentRecords.Size(); i++){
            PBS_AAAP_Offer_Attachments__c offerAttachmentsObj = new PBS_AAAP_Offer_Attachments__c();
            offerAttachmentsObj.PBS_AAAP_Offer__c = offerId;
            if(contentdocumentRecords[i].attachmentType != Null){
            	offerAttachmentsObj.PBS_AAAP_Attachment_Type__c = contentdocumentRecords[i].attachmentType;
            }
            if(contentdocumentRecords[i].attachmentDescription != Null){
            	offerAttachmentsObj.Document_Description__c = contentdocumentRecords[i].attachmentDescription;
            }
            offerAttachments.add(offerAttachmentsObj);
            contentDocumentMap.put(contentdocumentRecords[i].contentDocumentId,new ContentDocument());
        }
        if(offerAttachments.Size()>0){
            insert offerAttachments;
        }
        
        List<ContentDocumentLink> contentDocumentLinkRecords = new List<ContentDocumentLink>();
        for(integer i=0; i< contentdocumentRecords.Size(); i++){
            ContentDocumentLink obj = new ContentDocumentLink();
            obj.ContentDocumentId = contentdocumentRecords[i].contentDocumentId;
            obj.LinkedEntityId = offerAttachments[i].Id;
            obj.ShareType = 'V';
            obj.Visibility = 'AllUsers';
            contentDocumentLinkRecords.add(obj);
            contentdocumentRecords[i].offerAttachmentId = offerAttachments[i].Id;
        }
        
        if(contentDocumentLinkRecords.Size()>0){
            insert contentDocumentLinkRecords;
            contentDocumentMap = new Map<Id,ContentDocument>([SELECT Id, LatestPublishedVersion.Title, LatestPublishedVersionId FROM ContentDocument Where Id=:contentDocumentMap.keyset()]);
            List<ContentDistribution> contentDistributionRecords = new List<ContentDistribution>();
            for(ContentDocument contentDocumentRecord : contentDocumentMap.values()){
                ContentDistribution cdl = new ContentDistribution(
                    Name = contentDocumentRecord.LatestPublishedVersion.Title,
                    ContentVersionId = contentDocumentRecord.LatestPublishedVersionId,
                    PreferencesAllowViewInBrowser= true,
                    PreferencesNotifyOnVisit= false
                );
                contentDistributionRecords.add(cdl);
            }
            insert contentDistributionRecords;
            List<ContentDocument> contentDocumentRecordsToUpdate = new List<ContentDocument>();
            for(ContentDistribution cd : [SELECT DistributionPublicUrl, ContentVersion.ContentDocumentId, ContentVersion.Title, ContentVersion.FileExtension  FROM ContentDistribution WHERE Id In: contentDistributionRecords]){
                ContentDocument contentDocumentObj = new ContentDocument();
                contentDocumentObj.Id = cd.ContentVersion.ContentDocumentId;
                contentDocumentObj.Description  = cd.DistributionPublicUrl;
                contentDocumentObj.Title  = cd.ContentVersion.Title + '.'+cd.ContentVersion.FileExtension;
                contentDocumentRecordsToUpdate.add(contentDocumentObj);
            }
            update contentDocumentRecordsToUpdate;
        }
        
        return contentdocumentRecords;
    }
    
    
    @AuraEnabled
    public static void updateContentDocumentRecords(List<DocumentWrapper> contentdocumentRecords){
        
        List<PBS_AAAP_Offer_Attachments__c> offerAttachments = new List<PBS_AAAP_Offer_Attachments__c>();
        List<PBS_AAAP_Offer_Attachments__c> cloneOfferAttachments = new List<PBS_AAAP_Offer_Attachments__c>();
        List<Id> offerAttachmentsIds = new List<Id>();
        List<Id> offerIds = new List<Id>();
        for(DocumentWrapper documentWrapperObj : contentdocumentRecords){
            if(documentWrapperObj.offerAttachmentId != Null){
                offerAttachmentsIds.add(documentWrapperObj.offerAttachmentId);
            }
        }
        for(PBS_AAAP_Offer_Attachments__c offerAttachmentRecord : [Select Id, PBS_AAAP_Offer__c From PBS_AAAP_Offer_Attachments__c Where Id In :offerAttachmentsIds]){
            offerIds.add(offerAttachmentRecord.PBS_AAAP_Offer__c);
        }
        
        for(DocumentWrapper documentWrapperObj : contentdocumentRecords){
            PBS_AAAP_Offer_Attachments__c offAttRecord = new PBS_AAAP_Offer_Attachments__c();
            offAttRecord.Id = documentWrapperObj.offerAttachmentId;
            offAttRecord.PBS_AAAP_Attachment_Type__c = documentWrapperObj.attachmentType;
            offAttRecord.Document_Description__c = documentWrapperObj.attachmentDescription;
            offerAttachments.add(offAttRecord);
        }
        update offerAttachments;
        for(PBS_AAAP_Offer__c childoffer : [SELECT Id FROM PBS_AAAP_Offer__c WHERE Master_Offer__c =: offerIds]){
            insertDocumentLinkRecord(childoffer.Id, contentdocumentRecords);
        }
        System.debug('contentdocumentRecords '+contentdocumentRecords);
        System.debug('offerAttachments '+ offerAttachments);
    }
    
    @AuraEnabled
    public static List<DocumentWrapper> unSavedOfferAttRecords(String offerId){
        List<DocumentWrapper> wrappList = new List<DocumentWrapper>();
        Map<String, DocumentWrapper> mapOfOfferAtt = new Map<String, DocumentWrapper>();
        Map<String, ContentDocument> offerAttachmentIdWithTitleMap = new Map<String, ContentDocument>();
        Set<Id> offerAttachmentIds = new Set<Id>();
        List<PBS_AAAP_Offer_Attachments__c> offerAttachmentRecords = [SELECT Id, PBS_AAAP_Offer__c, PBS_AAAP_Attachment_Type__c  FROM PBS_AAAP_Offer_Attachments__c where PBS_AAAP_Offer__c =:offerId AND PBS_AAAP_Attachment_Type__c = null];
        for(PBS_AAAP_Offer_Attachments__c offerAttachmentRecord : offerAttachmentRecords){
            offerAttachmentIds.add(offerAttachmentRecord.Id);
        }
        for(ContentDocumentLink contentDocumentLinkRecord : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title,ContentDocument.Id FROM ContentDocumentLink where LinkedEntityId In :offerAttachmentIds]){
            offerAttachmentIdWithTitleMap.put(contentDocumentLinkRecord.LinkedEntityId, contentDocumentLinkRecord.ContentDocument);
        }
        for(PBS_AAAP_Offer_Attachments__c offerAttachmentRecord : offerAttachmentRecords){
            DocumentWrapper documentWrapperObj = new DocumentWrapper();
            if(offerAttachmentIdWithTitleMap.containsKey(offerAttachmentRecord.Id)){
                documentWrapperObj.name = offerAttachmentIdWithTitleMap.get(offerAttachmentRecord.Id).Title;
                documentWrapperObj.ContentDocumentId = offerAttachmentIdWithTitleMap.get(offerAttachmentRecord.Id).Id;
            }
            documentWrapperObj.offerAttachmentId = offerAttachmentRecord.Id;
            wrappList.add(documentWrapperObj);
        }
        
        return wrappList;
    }
    
    @AuraEnabled
    public static void deleteTheUploadedDocuments(List<DocumentWrapper> contentdocumentRecords){
        List<ContentDocument> contentRecords = new List<ContentDocument>();
        List<PBS_AAAP_Offer_Attachments__c> offerAttachments = new List<PBS_AAAP_Offer_Attachments__c>();
        for(DocumentWrapper contentdocumentRecord : contentdocumentRecords){
            contentRecords.add(new ContentDocument(Id=contentdocumentRecord.contentDocumentId));
            offerAttachments.add(new PBS_AAAP_Offer_Attachments__c(Id=contentdocumentRecord.offerAttachmentId));
        }
        if(contentRecords.size() >0){
            delete contentRecords;
        }
        if(offerAttachments.size() >0){
            delete offerAttachments;
        }
    }
    public class DocumentWrapper{
        @AuraEnabled Public Boolean isShowOthers{get;set;}
        @AuraEnabled Public String contentDocumentId{get;set;}
        @AuraEnabled Public String name{get;set;}
        @AuraEnabled Public String offerAttachmentId{get;set;}
        @AuraEnabled Public String attachmentType{get;set;}
        @AuraEnabled Public String attachmentDescription{get;set;}
        public DocumentWrapper(){
            this.isShowOthers = false;
            this.attachmentType = '';
            this.attachmentDescription = '';
        }
    }
    
    @AuraEnabled
    public static void actionSavePage(String offerId) {
        PBS_AAAP_Offer__c submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
        PBS_AAAP_RLP__c rlpInfo = dao.getRLP(submitOffer.PBS_AAAP_RLP_Number__c);
        submitOffer.PBS_AAAP_Signature_First_Name__c = UserInfo.getFirstName();
        submitOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = UserInfo.getLastName();
        submitOffer.PBS_AAAP_RLP_Region__c = rlpInfo.PBS_AAAP_Region__c;
        String draftMsgFlag = '';
        if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
            submitOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
            draftMsgFlag = 'true';
        }
        if(submitOffer != null){
            update submitOffer; 
        }
    } 
    
    @AuraEnabled
    public static void deleteRecord(String recordId) {
        ContentDocumentLink obj = [Select Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId =:recordId];
        delete new ContentDocument(Id=obj.ContentDocumentId);
        delete new PBS_AAAP_Offer_Attachments__c(Id=recordId);
    }
    
    @AuraEnabled
    public static string callGetCommunityURL(String modifiedPageUrl) {
        return PBS_AAAP_Utility.getCommunityURL(modifiedPageUrl);
    }
    @AuraEnabled
    public static SubmitOfferInfo getSubmitOfferInfo(String offerId) {
		

        Date dt = Date.today();
        PBS_AAAP_Offer__c submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
        SubmitOfferInfo submitOfferInfoObj = new SubmitOfferInfo();
        submitOfferInfoObj.firstName = UserInfo.getFirstName();
        submitOfferInfoObj.lastName = UserInfo.getLastName();

        submitOfferInfoObj.submissionDate = dt.month() + '/' + dt.day() + '/' + dt.year();
        
        ColumnWrapper column1 = new ColumnWrapper(); 
        column1.label = 'Space #';
        column1.fieldName = 'spaceNo';
        column1.type = 'text';
        submitOfferInfoObj.columns.add(column1);
        
        ColumnWrapper column2 = new ColumnWrapper(); 
        column2.label = 'Lease Type';
        column2.fieldName = 'leaseType';
        column2.type = 'text';
        submitOfferInfoObj.columns.add(column2);
        
        ColumnWrapper column3 = new ColumnWrapper(); 
        column3.label = 'GSA Lease #';
        column3.fieldName = 'GSALeaseNo';
        column3.type = 'text';
        submitOfferInfoObj.columns.add(column3);
        
        ColumnWrapper column4 = new ColumnWrapper(); 
        column4.label = 'SF Offered';
        column4.fieldName = 'sqFtOffered';
        column4.type = 'text';
        TypeAttribute typeAttributeObj = new TypeAttribute();
        typeAttributeObj.maximumFractionDigits = 2;		
        
        submitOfferInfoObj.columns.add(column4);
        List<PBS_AAAP_Space__c> spaces = dao.getSpaces(offerId);
        List<PBS_AAAP_Rate__c> rates =dao.getRates(offerId);
        if (spaces.size() > 0) {
            PBS_AAAP_ControllerSpacesAndRates spaceRates = new PBS_AAAP_ControllerSpacesAndRates(offerId);
            submitOfferInfoObj.data = spaceRates.spaceSort(spaces, rates);
            PBS_AAAP_RLP__c rlp = dao.getRLP(submitOffer.PBS_AAAP_RLP_Number__c);
            String regionCode = rlp.PBS_AAAP_Region__c;
            if(regionCode == 'Census'){
                ColumnWrapper column5 = new ColumnWrapper(); 
                column5.label = '25, 16 month FS';
                column5.fieldName = 'fiveYrFS';
                column5.type = 'currency';
                column5.typeAttributes = typeAttributeObj;
                submitOfferInfoObj.columns.add(column5);
                
                ColumnWrapper column6 = new ColumnWrapper(); 
                column6.label = '19, 11 month FS';
                column6.fieldName = 'fiveFiveYrFS';
                column6.type = 'currency';
                column6.typeAttributes = typeAttributeObj;
                submitOfferInfoObj.columns.add(column6);
                
            }else if(regionCode == '10/5 Term - All Regions'){
                ColumnWrapper column5 = new ColumnWrapper(); 
                column5.label = '10, 5 YEAR FS';
                column5.fieldName = 'fiveFiveYrFS';
                column5.type = 'currency';
                column5.typeAttributes = typeAttributeObj;
                submitOfferInfoObj.columns.add(column5);
            }else{
                ColumnWrapper column5 = new ColumnWrapper(); 
                column5.label = '17, 15 YEAR FS';
                column5.fieldName = 'fiveYrFS';
                column5.type = 'currency';
                column5.typeAttributes = typeAttributeObj;
                submitOfferInfoObj.columns.add(column5);
                
                ColumnWrapper column6 = new ColumnWrapper(); 
                column6.label = '15, 13 YEAR FS';
                column6.fieldName = 'fiveFiveYrFS';
                column6.type = 'currency';
                column6.typeAttributes = typeAttributeObj;
                submitOfferInfoObj.columns.add(column6);
                
                ColumnWrapper column7 = new ColumnWrapper(); 
                column7.label = '10, 8 Year FS';
                column7.fieldName = 'tenYrFS';
                column7.type = 'currency';
                column7.typeAttributes = typeAttributeObj;
                submitOfferInfoObj.columns.add(column7);
            }
            System.debug('***** details: ' + submitOfferInfoObj.data);
        }
        
        return submitOfferInfoObj;
    }
    public class SubmitOfferInfo {
        @AuraEnabled Public String firstName{get;set;}
        @AuraEnabled Public String lastName{get;set;}
        @AuraEnabled Public String submissionDate{get;set;}
        @AuraEnabled Public List<ColumnWrapper> columns{get;set;}
        @AuraEnabled Public List<PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails> data{get;set;}
        public SubmitOfferInfo(){
            columns = new List<ColumnWrapper>();
            data = new List<PBS_AAAP_ControllerSpacesAndRates.SpaceAndRatesDetails>();
        }
    }
    @AuraEnabled
    public static OfferValidationResponse submitOffer(String offerId, String termsandconditons, String ackLTRCompleted, String ackRepresentOthers) {
        OfferValidationResponse response = new OfferValidationResponse();
        response.success = false;
        PBS_AAAP_Offer__c submitOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
        submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c = ackLTRCompleted;
        submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c = ackRepresentOthers;
        submitOffer.PBS_AAAP_Signature_First_Name__c = UserInfo.getFirstName();
        submitOffer.PBS_AAAP_SIGNATURE_LAST_NAME__c = UserInfo.getLastName();
        
        if (termsandconditons != 'Yes') {
            response.addErrorMessage('1. You must acknowledge that you have read the RLP, lease and all the attachments in their entirety and are requesting no deviations.');
        }
        if (submitOffer.PBS_AAAP_ACK_LTR_COMPLETED__c != 'Yes') {
            response.addErrorMessage('2. You must acknowledge that you may be required to provide further due diligence submittals in order for your offer to be considered eligible for award.');
        }
        if (submitOffer.PBS_AAAP_ACK_REPRESENT_OTHERS__c != 'Yes') {
            response.addErrorMessage('3. You must acknowledge that you are aware that, in addition to generic specifications and requirements outlined in the RLP and attachments, there may be unique agency requirements, as identified in a project specific advertisement posted on SAM.gov, that shall be used in evaluating and determining the eligibility of offers for award.');
        }
        if (submitOffer.PBS_AAAP_X_CO_ORD__c == null) {
            response.addErrorMessage(PBS_AAAP_GlobalConstants.PBS_AAAP_X_CO_ORD_REQ);
        }
        if (submitOffer.PBS_AAAP_Y_CO_ORD__c == null) {
            response.addErrorMessage(PBS_AAAP_GlobalConstants.PBS_AAAP_Y_CO_ORD_REQ);
        }
        Boolean floorPlanFlag = false;
        //Nik - 1/29
        List<PBS_AAAP_Offer_Attachments__c> attachmentsList = [
            SELECT Name, PBS_AAAP_Attachment_Type__c
            FROM PBS_AAAP_Offer_Attachments__c p
            WHERE p.PBS_AAAP_Offer__c = :offerId
            ORDER BY p.CreatedDate
        ];
        for (integer i = 0; i < attachmentsList.size(); i++) {
            PBS_AAAP_Offer_Attachments__c attachmentFP = attachmentsList.get(i);
            System.debug('**** attachmentsList Type is  ' + attachmentFP.PBS_AAAP_Attachment_Type__c);
            if (attachmentFP.PBS_AAAP_Attachment_Type__c == 'Floor Plan') {
                floorPlanFlag = true;
            }
        }
        if (floorPlanFlag == false) {
            response.addErrorMessage('attachment for the offered space is missing');
            return response;
        }
        
        if (response.errorMessages.size() == 0) {
            if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                response.addErrorMessage('Offer is already in submitted status. If you made any changes since it was submitted, please save them before submitting.');
                return response;
            }
            User usr = [SELECT id, FirstName, LastName, username, email, PBS_AAAP_PIN__c, IsActive FROM User WHERE id = :UserInfo.getUserId()];
            // TODO write logic for pulling RLP information
            PBS_AAAP_Offer__c[] offeralreadyexists = null;
            PageReference pref = null;
            
            String[] offerstatuscriteria = new String[]{
                PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED, PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED
            };
                        offeralreadyexists = [SELECT id, PBS_AAAP_Offer_Status__c, PBS_AAAP_RLP_Number__c
                            				  FROM PBS_AAAP_Offer__c
                            				  WHERE PBS_AAAP_Offer_Status__c IN :offerstatuscriteria
                            				  AND PBS_AAAP_RLP_Number__c = :submitOffer.PBS_AAAP_RLP_Number__c
                            				  AND PBS_AAAP_Owner_Name__c = :submitOffer.PBS_AAAP_Owner_Name__c
                           					  AND PBS_AAAP_X_CO_ORD__c = :submitOffer.PBS_AAAP_X_CO_ORD__c
                            				  AND PBS_AAAP_Y_CO_ORD__c = :submitOffer.PBS_AAAP_Y_CO_ORD__c
                            				  AND PBS_AAAP_Is_Offer_Valid__c = TRUE
                            				  AND Ownerid = :UserInfo.getUserId()
                            				  AND Master_Offer__c = NULL LIMIT 1];
            
            
            PBS_AAAP_RLP__c rlpInfo = dao.getRLP(submitOffer.PBS_AAAP_RLP_Number__c);
            submitOffer.PBS_AAAP_RLP_Region__c = rlpInfo.PBS_AAAP_Region__c;
            if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT) {
                
                if (offeralreadyexists.size() > 0 ){
                    response.addErrorMessage('AAAP user already has an existing offer in the system in ' + offeralreadyexists[0].PBS_AAAP_Offer_Status__c + ' status. ' +
                                             'In order to submit the current offer the user should either modify the current offer or ' +
                                             'withdraw the originally submitted offer from the system.');
                    return response;
                } else {
                    submitOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
                    submitOffer.PBS_AAAP_Is_Offer_Valid__c = true;
                    if (termsandconditons == 'Yes') {
                        submitOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true;
                        submitOffer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
                    }
                    update submitOffer;
                }
                
            }
            
            // logic for "Pending Modification" status.
            if (submitOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
                if (submitOffer.PBS_AAAP_Parent_Offer__c != null) {
                    
                    if (offeralreadyexists.size() > 0 && offeralreadyexists[0].Id != submitOffer.PBS_AAAP_Parent_Offer__c) {
                        response.addErrorMessage('AAAP user already has an existing offer in the system in ' + offeralreadyexists[0].PBS_AAAP_Offer_Status__c + ' status. ' +
                                                 'In order to submit the current offer the user should either modify the current offer or ' +
                                                 'withdraw the originally submitted offer from the system.');
                        return response;
                    }
                    PBS_AAAP_Offer__c parentOffer = [SELECT id, PBS_AAAP_Parent_Offer__c, PBS_AAAP_Offer_Status__c, PBS_AAAP_Is_Offer_Valid__c
                       								 FROM PBS_AAAP_Offer__c WHERE id = :submitOffer.PBS_AAAP_Parent_Offer__c];
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
                            submitOffer.PBS_AAAP_Offer_Submission_Date__c = Date.today();
                            
                        }
                        update submitOffer;
                    }
                    
                }
            }
        }
        if (response.errorMessages.size() == 0) {
            response.success = true;
        }
        return response;
    }
    @AuraEnabled
    public static void submitDocuments(String offerId) {
    	PBS_AAAP_Offer__c newOfferRecord = [select PBS_AAAP_Solicitation_Id__c,PBS_AAAP_Solicitation_Number__c, 
                                            PBS_AAAP_Offeror_Primary_Phone_Number__c, PBS_AAAP_Offeror_Email__c,
                                            PBS_AAAP_DUNS_Number__c, PBS_AAAP_ZipCode__c, PBS_AAAP_Building_Name__c,
                                            Id, PBS_AAAP_Street_Address__c, PBS_AAAP_City__c, PBS_AAAP_State__c,
                                            PBS_AAAP_floors_and_suites_offered__c,PBS_AAAP_Signature_First_Name__c, 
                                            PBS_AAAP_SIGNATURE_LAST_NAME__c, PBS_AAAP_OFFEROR_INTEREST_OTHER__c,
                                            PBS_AAAP_Owner_Name__c
                                            FROM PBS_AAAP_Offer__c WHERE Id=: offerId];
        
        
        PBS_AAAP_Submission_Attempt_History__c historyRecord = new PBS_AAAP_Submission_Attempt_History__c();
        historyRecord.Date__c = system.now();
        historyRecord.Offer__c = offerId;
        insert historyRecord;
        
        PBS_AAAP_SendOfferDetailsAPI.sendOfferDetails(JSON.serialize(newOfferRecord));
    }    
    @AuraEnabled
    public static void actionOfferDocuments(String offerId){
        List<PBS_AAAP_Offer__c> allOffers = new List<PBS_AAAP_Offer__c>();
        Set<Id> allIds = new Set<Id>();
        List<PBS_AAAP_Offer_Select_Award_Info__c> allOSAI = new List<PBS_AAAP_Offer_Select_Award_Info__c>();
        String vPhase = 'P2';
        allOffers = [SELECT  Id, Master_Offer__c FROM PBS_AAAP_Offer__c WHERE Master_Offer__c = :offerId];
        for(PBS_AAAP_Offer__c ofr : allOffers){
            allIds.add(ofr.Id);
        }
        allIds.add(offerId);
        allOSAI = [SELECT  Id,PBS_AAAP_isSelected__c,PBS_AAAP_Submission_DateTime__c, PBS_AAAP_Offer_ID__c,PBS_AAAP_AGENCY_REQUIREMENT_ID__c
                   FROM PBS_AAAP_Offer_Select_Award_Info__c WHERE PBS_AAAP_Offer_ID__c IN :allIds AND PBS_AAAP_isSelected__c = TRUE LIMIT 49];
        for(PBS_AAAP_Offer_Select_Award_Info__c osai : allOSAI){
            PBS_AAAP_SendOfferDetailsAPI.sendOfferDetailsAAAP(osai.PBS_AAAP_Offer_ID__c, osai.PBS_AAAP_AGENCY_REQUIREMENT_ID__c, osai.Id, offerId, vPhase);
        }
    }
    @AuraEnabled
    public static void updateAutoGeneratedFormsDocuments(String ofrID) {
        
        // delete existing delete
        list<attachment> lstDelAtt = new list<attachment>();
        list<PBS_AAAP_Offer_Attachments__c> oAtt = new List<PBS_AAAP_Offer_Attachments__c>();
        set<Id> idSet = new Set<Id>();
        Set<Id> offerAttachmentIds = new Set<Id>();
        List<ContentDocument>  contentDocumentRecords = new  List<ContentDocument>();
        oAtt = [SELECT Id FROM PBS_AAAP_Offer_Attachments__c WHERE (PBS_AAAP_Offer__c = :ofrID AND (PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217)' OR PBS_AAAP_Attachment_Type__c = 'Lessors Annual Cost Statement (Form 1217 attachment)' OR PBS_AAAP_Attachment_Type__c = 'Form 1364 AAAP' OR PBS_AAAP_Attachment_Type__c = 'Offeror GSA Form 1364' OR PBS_AAAP_Attachment_Type__c = 'Offeror Form 1217- Lessor\'s Annual Cost Statement')) AND (PBS_AAAP_Offer__r.RecordType.Name = 'AAAP' OR PBS_AAAP_Sent_to_GREX__c != true) AND IsDeleted = false];
        for(PBS_AAAP_Offer_Attachments__c offerAttachmentRecord : oAtt){
            offerAttachmentIds.add(offerAttachmentRecord.Id);
        }
        if(offerAttachmentIds.size() > 0){
            for(ContentDocumentLink contentDocumentLinkRecord : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId In :offerAttachmentIds]){
                contentDocumentRecords.add(new ContentDocument(Id=contentDocumentLinkRecord.ContentDocumentId));
            }
        }
        if(contentDocumentRecords.size() > 0){
            delete contentDocumentRecords;
        }
        if(oAtt.size() > 0){
            delete oAtt;
        }
        if(!lstDelAtt.isEmpty()){
            delete lstDelAtt;
        }
        PBS_AAAP_Utility.logMethodStart('DownloadAllFiles');
        PBS_AAAP_Offer__c offerpdf = [SELECT o.id, o.Name, o.PBS_AAAP_Building_Name__c, o.PBS_AAAP_Street_Address__c, o.PBS_AAAP_Country__c,
            						  o.PBS_AAAP_City__c, o.PBS_AAAP_State__c, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c,
            						  o.PBS_AAAP_RLP_Number__c, o.PBS_AAAP_ZipCode__c, o.LastModifiedDate, o.Formula_RLP_Region__c, o.PBS_AAAP_Offer_Status__c,
            						  o.PBS_AAAP_Offer_Submission_Date__c, RecordType.Name FROM PBS_AAAP_Offer__c o WHERE o.id = :ofrID];        
        if(offerpdf.RecordType.Name == 'AAAP'){
            Boolean displayLink = false;
            Boolean displayform1217link = true;
            
            if (offerpdf.Formula_RLP_Region__c == 'Census') {
                displayform1217link = false;
            }
            Boolean displayform1364_2019link = false;
            
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
            if (displayform1217link == true) {
                addAttachementToOffer(ofrID, 'Form1217', 'Form1217.pdf');
                addAttachementToOffer(ofrID, 'Form1217Attachment', 'Form1217Attachment.pdf');
            }
            if(displayform1364_2022link == true){
                addAttachementToOffer(ofrID, 'OfferForm1364_2022', 'OfferForm1364.pdf');
                if (displayLink == true && displayform1217link == true) {
                    addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                } else if (displayLink == true && displayform1217link != true) {
                    addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                } else if (displayLink != true && displayform1217link == true) {} 
                else if (displayLink != true && displayform1217link != true) {}   
            }
            else{
                if(displayform1364_2019link == true){
                    addAttachementToOffer(ofrID, 'Offerform1364_2019', 'OfferForm1364.pdf');
                    if (displayLink == true && displayform1217link == true) {
                        addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                    } else if (displayLink == true && displayform1217link != true) {
                        addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                    } else if (displayLink != true && displayform1217link == true) {}
                    else if (displayLink != true && displayform1217link != true) {}              
                }
                else{
                    addAttachementToOffer(ofrID, 'OfferForm1364', 'OfferForm1364.pdf');
                    addAttachementToOffer(ofrID, 'OfferForm1364RateStructure', 'OfferForm1364RateStructure.pdf');
                    if (displayLink == true && displayform1217link == true) {
                        addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                    } else if (displayLink == true && displayform1217link != true) { 
                        addAttachementToOffer(ofrID, 'OfferForm3518', 'OfferForm3518.pdf');
                    } else if (displayLink != true && displayform1217link == true) {}
                }
            }     
        }else{
            addAttachementToOffer(ofrID, 'PBS_LOP_NewOfferForm1364', '1364 - Proposal to Lease Space.pdf');
            addAttachementToOffer(ofrID, 'LOP_offerform1217', '1217 - Lessor\'s Annual Cost Statement.pdf');
        }
        updateOfferDetails(ofrID);
    }
    // method to add attachment to offer
    public static void addAttachementToOffer(string offerId, string formType, string fileName) {
        PBS_AAAP_Utility.logMethodStart('addAttachementToOffer');
        PBS_AAAP_Offer__c offerpdf = [SELECT o.id, o.Name, o.PBS_AAAP_Building_Name__c, o.PBS_AAAP_Street_Address__c, o.PBS_AAAP_Country__c,
            						  o.PBS_AAAP_City__c, o.PBS_AAAP_State__c,o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c,
            						  o.PBS_AAAP_RLP_Number__c, o.PBS_AAAP_ZipCode__c, o.LastModifiedDate, o.Formula_RLP_Region__c
            						  FROM PBS_AAAP_Offer__c o WHERE o.id = :offerId];
        Boolean displayLink = false;
        DateTime dt = offerpdf.LastModifiedDate;
        Date modDate = dt.date();
        Date checkDate = date.valueOf('2017-09-25');
        if (modDate > checkDate) {
            displayLink = false;
        } else {
            displayLink = true;
        }
        Boolean displayform1217link = true;
        if (offerpdf.Formula_RLP_Region__c == 'Census') {
            displayform1217link = false;
        }
        Boolean displayform1364_2019link = false;
        
        
        if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2018 && Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) <= 2021){
            displayform1364_2019link = true;
        }else{
            displayform1364_2019link = false;
        }       
        PageReference pageRef;
        //SGanti added 8/2021. Set conditions for displayform1364_2022link
        Boolean displayform1364_2022link = false;                 
        if(Integer.valueOf(offerpdf.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) > 2021){
            displayform1364_2022link = true;
        }else{
            displayform1364_2022link = false;
        } 
        // getting offer key  
        string sesid = fetchOfferKey(offerId);
        if (formType == 'Form1217' && displayform1217link == true) {
            pageRef = Page.OfferForm1217;
            pageRef.getParameters().put('formtype', 'offerform1217');
        }
        if (formType == 'Form1217Attachment' && displayform1217link == true) {
            pageRef = Page.OfferForm1217Attachment;
            pageRef.getParameters().put('formtype', 'offerform1217Attachment');
        }
        if(formtype == 'Offerform1364_2019' && displayform1364_2019link == true){
            pageRef = Page.Offerform1364_2019;    //NIK
            pageRef.getParameters().put('formtype', 'offerform1364');
        }
        if (formType == 'OfferForm1364' && displayform1364_2019link == false) {
            pageRef = Page.OfferForm1364;
            pageRef.getParameters().put('formtype', 'offerform1364');
            pageRef.getParameters().put('offerid', offerId);
        }
        //SGanti added 08/2021
        if(formtype == 'OfferForm1364_2022' && displayform1364_2022link == true){
            pageRef = Page.PBS_AAAP_NewOfferForm1364;
            pageRef.getParameters().put('formtype', 'OfferForm1364_2022');
        }         
        if (formType == 'OfferForm1364_2022' && displayform1364_2022link == false) {
            pageRef = Page.PBS_AAAP_NewOfferForm1364;
            pageRef.getParameters().put('formtype', 'OfferForm1364_2022');
            pageRef.getParameters().put('offerid', offerId);
        }        
        
        if (formType == 'OfferForm1364RateStructure') {
            pageRef = Page.OfferForm1364RateStructure;
            pageRef.getParameters().put('formtype', 'offerform1364ratestructure');
        }
        if (formType == 'OfferForm3518' && displayLink == true) {
            pageRef = Page.OfferForm3518;
            pageRef.getParameters().put('formtype', 'offerform3518');
        }
        if (formType == 'PBS_LOP_NewOfferForm1364'){
            pageRef = Page.PBS_LOP_NewOfferForm1364;
        }
        if (formType == 'LOP_offerform1217'){
            pageRef = Page.LOP_offerform1217;
        }
        pageRef.getParameters().put('offerId', offerId);
        Blob pdfPageBlob;
        if(sesid == null){
            pageRef.getParameters().put('isFromOfferAtt', 'true');
        }
        if (!Test.isRunningTest()) {
            pageRef.getParameters().put('sesid', sesid);  
            pdfPageBlob = pageRef.getContentAsPDF();
            
        } else {
            pdfPageBlob = Blob.valueOf('TEST');
        }        
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

        if (formType == 'PBS_LOP_NewOfferForm1364'){
            offAtt.PBS_AAAP_Attachment_Type__c = 'Offeror GSA Form 1364';
        }
        if (formType == 'LOP_offerform1217'){
            offAtt.PBS_AAAP_Attachment_Type__c = 'Offeror Form 1217- Lessor\'s Annual Cost Statement';
        }

        offAtt.PBS_AAAP_Offer__c = offerId;
        insert offAtt;
        ContentVersion ContVerFile = new ContentVersion();	
        ContVerFile.VersionData = pdfPageBlob; 	
        ContVerFile.Title = fileName; 	
        ContVerFile.PathOnClient= fileName;	
        insert ContVerFile;
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ContVerFile.Id].ContentDocumentId;
        List<ContentDocumentLink> contentDocumentLinkRecords = new List<ContentDocumentLink>();
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = offAtt.Id;
        cDe.ShareType = 'V';
        cDe.Visibility = 'AllUsers';
        contentDocumentLinkRecords.add(cDe);

        ContentDocumentLink cDe1 = new ContentDocumentLink();
        cDe1.ContentDocumentId = conDoc;
        cDe1.LinkedEntityId = offerId;
        cDe1.ShareType = 'V';
        cDe1.Visibility = 'AllUsers';
        contentDocumentLinkRecords.add(cDe1);

        insert contentDocumentLinkRecords;
        
        ContentDistribution cdl = new ContentDistribution(
            Name = ContVerFile.Title,
            ContentVersionId = ContVerFile.Id,
            PreferencesAllowViewInBrowser= true,
            PreferencesNotifyOnVisit= false
        );
        insert cdl;
        ContentDistribution cd = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id =: cdl.Id LIMIT 1];
        ContentDocument contentDocumentObj = new ContentDocument();
        contentDocumentObj.Id = conDoc;
        contentDocumentObj.Description  = cd.DistributionPublicUrl;
        update contentDocumentObj;
        PBS_AAAP_Utility.logMethodEnd('addAttachementToOffer');
    }
    public static string fetchOfferKey(string ofId){
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_Key__c;
    }
    // getting randon key and update on Offer
    public static void updateOfferDetails(String ofId){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        Integer len = Integer.valueOf(Label.PBS_AAAP_KeyLength);
        String randStr = '';
        // generating the random number
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        //updating user
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(id = ofId, PBS_AAAP_Session_Key__c = randStr);
        update offerRec;
    }
    @AuraEnabled
    public static String getLabel(String pageName){
        List<Attachment_Type_Mapping__mdt> attachmentTypeMappingRecords = [SELECT  MasterLabel, Attachment_Type__c FROM Attachment_Type_Mapping__mdt Where MasterLabel=:pageName];
        if(attachmentTypeMappingRecords.size() > 0){
            return attachmentTypeMappingRecords[0].Attachment_Type__c;
        }
        return null;
    }
    @AuraEnabled
    public static List<PBS_AAAP_Offer_Attachments__c> getAllOfferAttachments(String offerId){
        return [Select Id from PBS_AAAP_Offer_Attachments__c where PBS_AAAP_Offer__c =:offerId];
    }
    @AuraEnabled
    public static ContentDocumentLinkWrapper getOfferAttachmentData(String offerAttachmentId){
        ContentDocumentLink contentDocumentLinkObj = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.LatestPublishedVersion.VersionData
            FROM ContentDocumentLink
            WHERE LinkedEntityId  =:offerAttachmentId limit 1];
        ContentDocumentLinkWrapper contentDocumentLinkWrapperObj = new ContentDocumentLinkWrapper();
        contentDocumentLinkWrapperObj.title = contentDocumentLinkObj.ContentDocument.Title;
        contentDocumentLinkWrapperObj.FileExtension = contentDocumentLinkObj.ContentDocument.FileExtension;
        contentDocumentLinkWrapperObj.fileContent = EncodingUtil.base64Encode(contentDocumentLinkObj.ContentDocument.LatestPublishedVersion.VersionData);
        return contentDocumentLinkWrapperObj;
    }
    @AuraEnabled
    public static Boolean checkOfferIsValidOrNot(String offerId){
        PBS_AAAP_Offer__c offerBuilding = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
		return PBS_AAAP_GlobalConstants.checkOfferIsValidOrNot(offerBuilding);        
    }
    public class ContentDocumentLinkWrapper {
        @AuraEnabled Public String title{get;set;}
        @AuraEnabled Public String fileExtension{get;set;}
        @AuraEnabled Public String fileContent{get;set;}
        public ContentDocumentLinkWrapper(){}
    }
}