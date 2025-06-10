public with sharing class PBS_Leasing_OfferOptionsController {
	
    
    @AuraEnabled
    public static ResponseWrapper getOffer(String offerId) {
        ResponseWrapper response = new ResponseWrapper();
        if (offerId != null && offerId != '') {
            List<PBS_AAAP_Offer__c> offerList = [SELECT o.RecordType.Name, o.PBS_AAAP_Solicitation_Number__c, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                            o.PBS_AAAP_Signature_First_Name__c, o.PBS_AAAP_SIGNATURE_PIN__c, o.PBS_AAAP_SIGNATURE_MIDDLE_NAME__c, o.PBS_AAAP_SIGNATURE_LAST_NAME__c,
                            o.PBS_AAAP_SIGNATURE_LAST_4DIGITS_SSN__c, o.PBS_AAAP_SIGNATURE_DOB__c, o.PBS_AAAP_SIGNATURE_DATE__c, o.PBS_AAAP_RLP_Region__c,
                            o.PBS_AAAP_RLP_Number__c, o.PBS_AAAP_Parent_Offer__c, o.PBS_AAAP_PARENT_NAME__c, o.PBS_AAAP_Owner_Zip__c, o.PBS_AAAP_Owner_State__c,
                            o.PBS_AAAP_Owner_State_Reg__c, o.PBS_AAAP_Owner_Name__c, o.PBS_AAAP_Owner_Main_Phone__c, o.PBS_AAAP_Owner_Country__c,
                            o.PBS_AAAP_Owner_Country_Reg__c, o.PBS_AAAP_Owner_City__c, o.PBS_AAAP_Owner_Alt_Phone__c, o.PBS_AAAP_Owner_Address__c,
                            o.PBS_AAAP_Offer_Status__c, o.PBS_AAAP_OFFER_NUMBER__c, o.PBS_AAAP_OFFEROR_INTEREST__c, o.PBS_AAAP_OFFEROR_INTEREST_OTHER__c,
                            o.PBS_AAAP_Is_Offer_Valid__c, o.PBS_AAAP_DUNS_Number__c, o.PBS_AAAP_Building_Name__c, o.PBS_AAAP_Offer_Submission_Date__c,
                            o.OwnerId, o.Name, o.Id, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Region__c, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Posted_Date__c, o.CREATEDBYID,
                            o.Formula_RLP_Num__c, o.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c, o.PBS_RSAP_Property_Owner_Same_as_Offeror__c,
                            o.PBS_AAAP_RLP_Number__r.PBS_RSAP_Project_Number__c, o.PBS_AAAP_Submission_DateTime__c, o.PBS_AAAP_RLP_Number__r.Default_Start_Time_ET__c, 
                            o.PBS_AAAP_RLP_Number__r.Default_Start_Time_AM_PM__c,o.PBS_AAAP_RLP_Number__r.Default_End_Time_ET__c,o.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c,
                            o.PBS_AAAP_RLP_Number__r.Default_End_Time_AM_PM__c, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_DEFAULT_MONTH_BEGIN__c, o.PBS_AAAP_RLP_Number__r.PBS_AAAP_DEFAULT_MONTH_END__c,
                            o.PBS_AAAP_RLP_Number__r.name,o.PBS_AAAP_Total_Withdraw_Space__c,o.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c
                    FROM PBS_AAAP_Offer__c o
                    WHERE o.id = :offerId LIMIT 1];
            if (offerList.size() == 0) {
                response.addErrorMessage('The offerId was not found.');
            } else {
                response.offer = offerList[0];
                response.isSuccess = true;
            } 
        } else {
            response.addErrorMessage('Missing OfferId parameter.');
        }
        return response;
    }    
    @AuraEnabled
    public static ResponseWrapper deleteOffer(String offerId) {
        ResponseWrapper response = new ResponseWrapper();
        if (offerId != null && offerId != '') {
            PBS_AAAP_Offer__c delOffer = [SELECT ID, PBS_AAAP_Offer_Status__c FROM PBS_AAAP_Offer__c  WHERE Id = :offerId];
            if(delOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT ||
                delOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION){
                delete delOffer; 
            	response.isSuccess = true; 
            }else{
            	response.addErrorMessage('You can only delete on Draft or Pending Modification stage.');
            }
        } else {
            response.addErrorMessage('Missing OfferId.');
        }
        return response;
    }    
    // Helper class to store the response of the controller calls
    public class ResponseWrapper {
        @AuraEnabled public Boolean isSuccess { get; set; }
        @AuraEnabled public List<String> errorMessages { get; set; }
        @AuraEnabled public PBS_AAAP_Offer__c offer { get; set; }
        // Constructor to initialize the response object
        public ResponseWrapper() {
            this.isSuccess = false;
            this.errorMessages = new List<String>();
            this.offer = null;
        }
        // Method to add an error message to the response
        public void addErrorMessage(String message) {
            this.errorMessages.add(message);
        }
    }
    @AuraEnabled
    public static String actionLopOfferEdit(String offerId, String propertyId) {
        String redirectURL = '';
        
        
        Savepoint sp = Database.setSavepoint();
        try {
            PBS_AAAP_Offer__c lopoffer = [
                    SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Building_Name__c,
                            p.PBS_AAAP_Offer_Status__c, p.PBS_AAAP_Default_Start__c, p.PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                            p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_Total_Withdraw_Space__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c,
                            p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c,p.property__c,p.property__r.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c,
                            p.property__r.PBS_AAAP_GEN_PURPOSE_RENTABLE__c,p.property__r.PBS_AAAP_Building_Name__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :offerId
            ];
            
            
                PBS_AAAP_property__c lopprop = [
                    SELECT prop.id,prop.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c,
                            prop.PBS_AAAP_GEN_PURPOSE_RENTABLE__c,prop.PBS_AAAP_Building_Name__c
                    FROM PBS_AAAP_property__c prop
                    WHERE prop.id = :propertyId
            ];
            
            
            if ((lopoffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT) && (lopoffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c)) {
                
                if(lopoffer.property__c == null){
            	
                	redirectURL = '/leasing/s/Offer-Location?edit=true&terminated=false&offerId='+lopoffer.Id;
                    }
                    else if(lopprop.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null || lopprop.PBS_AAAP_Building_Name__c == null || lopprop.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null)
                    {
                        redirectURL = '/leasing/s/Offer-Location?edit=true&terminated=false&offerId='+lopoffer.Id+'&propertyId='+propertyId;  
                    }
                    else{
                        redirectURL = '/leasing/s/Offer-S-Eligibility?edit=true&terminated=false&offerId='+lopoffer.Id+'&propertyId='+propertyId;
                    }
 
            } else if (!lopoffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                
                
                if(lopoffer.property__c == null){
            	
                	redirectURL = '/leasing/s/Offer-Location?edit=false&terminated=true&offerId='+lopoffer.Id;
                    }
                    else if(lopprop.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null || lopprop.PBS_AAAP_Building_Name__c == null || lopprop.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null)
                    {
                        redirectURL = '/leasing/s/Offer-Location?edit=false&terminated=true&offerId='+lopoffer.Id+'&propertyId='+propertyId;  
                    }
                    else{
                        redirectURL = '/leasing/s/Offer-S-Eligibility?edit=false&terminated=true&offerId='+lopoffer.Id+'&propertyId='+propertyId;
                    }
                
                
                
   
            } else if (lopoffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED || lopoffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED) {  //OOLOP-1100
                lopoffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                update lopoffer;
                
                if(lopoffer.property__c == null){
            	
                	redirectURL = '/leasing/s/Offer-Location?edit=true&draftMsgFlag=true&offerId='+lopoffer.Id;
                    }
                    else if(lopprop.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null || lopprop.PBS_AAAP_Building_Name__c == null || lopprop.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null)
                    {
                        redirectURL = '/leasing/s/Offer-Location?edit=true&draftMsgFlag=true&offerId='+lopoffer.Id+'&propertyId='+propertyId;  
                    }
                    else{
                        redirectURL = '/leasing/s/Offer-S-Eligibility?edit=true&draftMsgFlag=true&offerId='+lopoffer.Id+'&propertyId='+propertyId;
                    }
                

              }  
            
        }
        catch (Exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
        }
        return redirectURL;
    }    
    @AuraEnabled
    public static String updateLOPToWithdrawnStatus(String offerId) {
        
        Savepoint sp = Database.setSavepoint();
        try {
            PBS_AAAP_Offer__c lopoffer = [
                    SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Building_Name__c,
                            p.PBS_AAAP_Offer_Status__c, p.PBS_AAAP_Default_Start__c, p.PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                            p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_Total_Withdraw_Space__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :offerId
            ];
            lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            update lopOffer;
            return null;
        } catch (Exception e) {
            Database.rollback(sp);
            
            return null;
        }
    }    
    @AuraEnabled
    public static PBS_AAAP_Offer__c offerClone(string offerId, string action) {
        PBS_AAAP_Offer__c copySelectedOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
        PBS_AAAP_Offer__c newoffer = new PBS_AAAP_Offer__c();
        newoffer = copySelectedOffer.clone(false, true);
        return newoffer;
    }    
    public class ContentDocumentWrapper {
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public Blob bodyBlob { get; set; }
        public ContentDocumentWrapper() {}
        public ContentDocumentWrapper(String name, Blob bodyBlob){
            this.name = name;
            this.bodyBlob = bodyBlob;
        }
    } 
    
    @AuraEnabled(cacheable = true)
    public static List<Map<String,String>> getRegions() {
        List<Map<String,String>> options = new List<Map<String,String>>();
        options.add(new Map<String,String>{'label' => 'Select a Region', 'value' => ''});
        
        options.add(new Map<String,String>{'label' => 'Region 1', 'value' => 'Region 1'});
        options.add(new Map<String,String>{'label' => 'Region 2', 'value' => 'Region 2'});
        options.add(new Map<String,String>{'label' => 'Region 3', 'value' => 'Region 3'});
        options.add(new Map<String,String>{'label' => 'Region 4', 'value' => 'Region 4'});
        options.add(new Map<String,String>{'label' => 'Region 5', 'value' => 'Region 5'});
        options.add(new Map<String,String>{'label' => 'Region 6', 'value' => 'Region 6'});
        options.add(new Map<String,String>{'label' => 'Region 7', 'value' => 'Region 7'});
        options.add(new Map<String,String>{'label' => 'Region 8', 'value' => 'Region 8'});
        options.add(new Map<String,String>{'label' => 'Region 9', 'value' => 'Region 9'});
        options.add(new Map<String,String>{'label' => 'Region 10', 'value' => 'Region 10'});
        options.add(new Map<String,String>{'label' => 'National Capital Region', 'value' => 'National Capital Region'});
        options.add(new Map<String,String>{'label' => '10/5 Term - All Regions', 'value' => '10/5 Term - All Regions'});
        return options;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<PBS_AAAP_RLP__c> actionSearchRLPSite(String selectedRegion) {
        List<PBS_AAAP_RLP__c> rlpList = [
            SELECT Id, CreatedDate, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c, 
                   PBS_AAAP_Category__c, PBS_AAAP_Title__c, PBS_AAAP_STATUS__c
            FROM PBS_AAAP_RLP__c
            WHERE PBS_AAAP_Region__c = :selectedRegion
            AND PBS_AAAP_isActive__c = TRUE
            AND PBS_AAAP_STATUS__c = 'Posted/active'
        ];
        
        return rlpList;
    }
    
     
    
     @AuraEnabled(cacheable=true)
    public Static String actionShowRLPs(string selectedRegion) {
         
         List <PBS_AAAP_RLP__c> rlpList;
         String rlpID='' ; 
         String redirectURL = '';
         
         
               rlpList = [
                SELECT id, CreatedDate, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c, PBS_AAAP_Category__c, PBS_AAAP_Title__c, PBS_AAAP_STATUS__c
                FROM PBS_AAAP_RLP__c
                WHERE PBS_AAAP_Region__c = :selectedRegion
                AND PBS_AAAP_isActive__c = TRUE
                AND PBS_AAAP_STATUS__c = 'Posted/active'
        ];
        
        
                 
         if (rlpList.size() == 1) {
            
            PBS_AAAP_RLP__c rlpDetails = rlpList.get(0);
            rlpID = rlpDetails.id;
            System.debug('rlpID in actionShowRLPs is **** ' + rlpID);
            
            redirectURL = '/leasing/s/Offer-M-ViewRLP?rlpID='+rlpID;
             
        }

        else if (selectedRegion != null) {
            
            redirectURL = '/leasing/s/Offer-M-ViewRLP?rlpRegion='+selectedRegion;
            
        }
             
        return redirectURL;

     
    }
    
    
    @AuraEnabled
    public static String actionOfferEdit(String offerId, String propertyId) {
        
        
        String redirectURL = '';
        
        Savepoint sp = Database.setSavepoint();

        try {
            PBS_AAAP_Offer__c newofferDraft;

            PBS_AAAP_Offer__c offer = [
                    SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_Building_Name__c, p.PBS_AAAP_Offer_Status__c,
                            p.PBS_AAAP_Default_Start__c,p.PBS_AAAP_Default_End__c, p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_RLP_Number__c,
                            p.PBS_AAAP_Offer_Submission_Date__c,p.property__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :offerId
            ];
            PBS_AAAP_RLP__c rlp = [
                    SELECT p.PBS_AAAP_EXCEPTION_MONTH__c, p.PBS_AAAP_EXCEPTION_MONTH_END__c, p.PBS_AAAP_EXCEPTION_MONTH_BEGIN__c,
                            p.PBS_AAAP_DEFAULT_MONTH_END__c, p.PBS_AAAP_DEFAULT_MONTH_BEGIN__c, p.Name, p.Id
                    FROM PBS_AAAP_RLP__c p
                    WHERE p.Id = :offer.PBS_AAAP_RLP_Number__c
            ];
            
            PBS_AAAP_property__c property = [
                    SELECT prop.id,prop.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c,
                            prop.PBS_AAAP_GEN_PURPOSE_RENTABLE__c,prop.PBS_AAAP_Building_Name__c
                    FROM PBS_AAAP_property__c prop
                    WHERE prop.id = :propertyId
            ];
            System.debug('::::::::::::: rlp end date ::: ' + rlp.PBS_AAAP_DEFAULT_MONTH_BEGIN__c);
            System.debug('::::::::::::: rlp end date ::: ' + rlp.PBS_AAAP_DEFAULT_MONTH_END__c);
            Date dt = Date.today();
            
            if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT ||
                    offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION
                    ) {
                
                if(offer.property__c == null)
            	{
                	redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=false&offerId='+offer.Id;
                }
                else if(property.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null || property.PBS_AAAP_Building_Name__c == null || property.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null)
                {
             	 	redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=false&offerId='+offer.Id+'&propertyId='+propertyId;  
                }
                else{
                	redirectURL = '/leasing/s/Offer-M-Eligibility?edit=true&isNew=false&offerId='+offer.Id+'&propertyId='+propertyId;
                    }
 

            } else if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED || offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED) {  //OOLOP-1100
                System.debug('3. The offer Status :::::::::::::  ' + offer.PBS_AAAP_Offer_Status__c);
                System.debug('offer Submission Date :::::::::::::  ' + offer.PBS_AAAP_Offer_Submission_Date__c);

                // Edit logic for current open period and next open period
              
                Date ofrSubmissionDate = offer.PBS_AAAP_Offer_Submission_Date__c;
                Date dtoday = Date.today();

                
                integer month1 = ofrSubmissionDate.month();
                integer begindt = integer.valueOf(rlp.PBS_AAAP_DEFAULT_MONTH_BEGIN__c);
                integer enddt = integer.valueOf(rlp.PBS_AAAP_DEFAULT_MONTH_END__c);
                if (dtoday.day() >= begindt && dtoday.day() <= enddt && month1 == dtoday.month()) {
                   
                    if(offer.property__c == null){
            	
                	redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=false&offerId='+offer.Id;
                    }
                    else if(property.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null || property.PBS_AAAP_Building_Name__c == null || property.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null)
                    {
                        redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=false&offerId='+offer.Id+'&propertyId='+propertyId;  
                    }
                    else{
                        redirectURL = '/leasing/s/Offer-M-Eligibility?edit=true&isNew=false&offerId='+offer.Id+'&propertyId='+propertyId;
                    }
              
                }// edit logic ends
                else {
                    //CHECK IF A PENDING MODIFICATION OFFER ALREADY EXISTS
                    List<PBS_AAAP_Offer__c> pmOffer = [SELECT Id FROM PBS_AAAP_Offer__c WHERE PBS_AAAP_Parent_Offer__c = :offerId AND PBS_AAAP_Offer_Status__c = 'Pending Modification' LIMIT 1];
                    if(pmOffer.isEmpty()) {

                        newofferDraft = offerClone(offer.id, 'PM');
                        newofferDraft.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
                        // need to have lookup to current offer, when this offer gets submitted the original offer status should get change.
                        newofferDraft.PBS_AAAP_Parent_Offer__c = offer.Id;
                        
                        newofferDraft.PBS_AAAP_Offer_Submission_Date__c = null;
                        newofferDraft.PBS_AAAP_LEGACY_OFFER_NUMBER__c = null;
                        insert newofferDraft;                      
                        
                        System.debug('4. The offer Inserted :::::::::::::  ' + newofferDraft.Id + '   with Status:::  ' + newofferDraft.PBS_AAAP_Offer_Status__c);
                        List<PBS_AAAP_Other_Costs__c> newOtherCosts = new List<PBS_AAAP_Other_Costs__c>();
                        for (PBS_AAAP_Other_Costs__c oc : [
                                SELECT p.PBS_AAAP_SHORT_DESC__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_COST__c, p.PBS_AAAP_COST_TYPE__c,
                                        p.PBS_AAAP_COST_REMOVAL__c, p.Name, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                                FROM PBS_AAAP_Other_Costs__c p
                                WHERE p.PBS_AAAP_OFFER_NUMBER__c = :offer.id
                        ]) {
                            PBS_AAAP_Other_Costs__c newOCost = oc.clone(false, true);
                            newOCost.PBS_AAAP_OFFER_NUMBER__c = newofferDraft.id;
                            newOCost.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                            newOtherCosts.add(newOCost);
                        }
                        insert newOtherCosts;
                        
                        List<PBS_AAAP_Offer_Attachments__c> newOfferAtt = new List<PBS_AAAP_Offer_Attachments__c>();
                        List<Id> oldOffAttIds = new List<Id>();
                        Map<Id, Id> olddAttIdWithNewAttIdMap = new Map<Id, Id>();
                        List<Id> attOfferIds = new List<Id>();
                        for(PBS_AAAP_Offer_Attachments__c offAtt : [SELECT Id, PBS_AAAP_Offer__c, PBS_AAAP_Attachment_Type__c, Cloned_From__c,
                                                                            PBS_AAAP_Date_sent_to_GREX__c, PBS_AAAP_Legacy_Offer_Att_ID__c, 
                                                                            Offer_Attachments_Name__c, PBS_AAAP_Sent_to_GREX__c                                                                             
                                                                            FROM PBS_AAAP_Offer_Attachments__c
                                                                            WHERE PBS_AAAP_Offer__c = :offer.id]){
                            PBS_AAAP_Offer_Attachments__c newAtt = offAtt.clone(false, true);
                            newAtt.PBS_AAAP_Offer__c = newofferDraft.id;
                            newAtt.Cloned_From__c = offAtt.Id;
                            newAtt.PBS_AAAP_Legacy_Offer_Att_ID__c = null;  
                            insert newAtt;
                                                                                
                            olddAttIdWithNewAttIdMap.put(newAtt.Id, offAtt.Id);                                                    
                            newOfferAtt.add(newAtt);
                            attOfferIds.add(offAtt.Id);
                            oldOffAttIds.add(offAtt.Id);
                                                                            
                        }
                        if(!newOfferAtt.isEmpty()){
                            //insert newOfferAtt;
                            
                            Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
                            List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.VersionData, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                            for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                                contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.VersionData));
                            }
                            if(newOfferAtt.size() > 0){
                                //insert newAttachmentsList;
                                Map<Id,Id> offerIdWithContentVersionIdMap = new Map<Id,Id>();
                                Set<Id> contentVersionIds = new Set<Id>();
                                for (PBS_AAAP_Offer_Attachments__c attach : newOfferAtt) {
                                    ContentVersion ContVerFile = new ContentVersion();
                                    ContentDocumentWrapper contentDocumentWrapperObj = contentDocumentMap.get(olddAttIdWithNewAttIdMap.get(attach.Id));
                                    ContVerFile.VersionData = contentDocumentWrapperObj.bodyBlob;
                                    ContVerFile.Title = contentDocumentWrapperObj.name; 
                                    ContVerFile.PathOnClient= contentDocumentWrapperObj.name;
                                    insert ContVerFile;
                                    contentVersionIds.add(ContVerFile.Id);
                                    offerIdWithContentVersionIdMap.put(ContVerFile.Id, attach.Id);
                                }
                                List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
                                List<ContentDistribution> contentDistributionList = new List<ContentDistribution>();
                                for(ContentVersion contentVersionRecord : [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id In:contentVersionIds]){
   
                                    ContentDocumentLink cDe = new ContentDocumentLink();
                                    cDe.ContentDocumentId = contentVersionRecord.ContentDocumentId;
                                    cDe.LinkedEntityId = offerIdWithContentVersionIdMap.get(contentVersionRecord.Id);
                                    cDe.ShareType = 'V';
                                    cDe.Visibility = 'AllUsers';
                                    contentDocumentLinkList.add(cDe);
                                    
                                    contentDistributionList.add(new ContentDistribution(
                                       Name = contentVersionRecord.Title,
                                       ContentVersionId = contentVersionRecord.Id,
                                       PreferencesAllowViewInBrowser= true,
                                       PreferencesNotifyOnVisit= false
                                    ));
                                    
                                }
                                if(contentDocumentLinkList.size() > 0){
                                    insert contentDocumentLinkList;
                                }
                                if(contentDistributionList.size() > 0){
                                    insert contentDistributionList;
                                }
                                List<ContentDocument> contentDocumentList = new List<ContentDocument>();
                                for(ContentDistribution contentDistributionRecord : [SELECT DistributionPublicUrl, ContentDocumentId FROM ContentDistribution 
                                                           WHERE contentVersionId In :contentVersionIds]){
                                    contentDocumentList.add(new ContentDocument(Id=contentDistributionRecord.ContentDocumentId,Description=contentDistributionRecord.DistributionPublicUrl));
                                }
                                if(contentDocumentList.size() > 0){
                                    update contentDocumentList;
                                }
                            }
                        }
                        
                        Map<Id, Id> mapOldIdNewId = new Map<Id, Id>();
                        for(PBS_AAAP_Offer_Attachments__c offAtt : newOfferAtt){
                            mapOldIdNewId.put(offAtt.Cloned_From__c, offAtt.Id);
                        }                 

                        List<PBS_AAAP_Space__c> newSpaceitems = new List<PBS_AAAP_Space__c>();
                        List<PBS_AAAP_Rate__c> newRatesList = new List<PBS_AAAP_Rate__c>();
                        Map<Id, Id> spaceMap = new Map<Id, Id>(); //(oldspaceId,newSpaceId)
                        Map<string, PBS_AAAP_Space__c> spaceMapDetail = new Map<string, PBS_AAAP_Space__c>();                        

                        for (PBS_AAAP_Space__c pi : [
                                SELECT p.PBS_AAAP_Total_ABOA_Withdrawn__c, p.PBS_AAAP_Total_ABOA_Selected__c, p.PBS_AAAP_Total_ABOA_Awarded__c,
                                        p.PBS_AAAP_Total_ABOA_Available__c, p.PBS_AAAP_TOT_EXP_ABOA__c, p.PBS_AAAP_TOTAL_MARKUP__c, p.PBS_AAAP_SUITE_INDICATOR__c,
                                        p.PBS_AAAP_SF_OFFERED__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, p.PBS_AAAP_Max_Contiguous_Space__c,
                                        p.PBS_AAAP_MIN_OFFERABLE_SPACE__c, p.PBS_AAAP_MAX_OFFERABLE_SPACE__c, p.PBS_AAAP_MANAGEMENT_COORD_FEES__c,
                                        p.PBS_AAAP_LOCATION_OF_FLOORS__c, p.PBS_AAAP_LEGACY_OFFER_NUMBER__c, p.PBS_AAAP_LEGACY_IDENTIFIER_ID__c,
                                        p.PBS_AAAP_IDENTIFIER_TYPE__c, p.PBS_AAAP_IDENTIFIER_TO__c, p.PBS_AAAP_IDENTIFIER_ID__c, p.PBS_AAAP_IDENTIFIER_FROM__c,
                                        p.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c, p.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, p.PBS_AAAP_GC_CONDITIONS__c, p.PBS_AAAP_FLOOR_INDICATOR__c,
                                        p.PBS_AAAP_DATE_SPACE_AVAILABILITY__c, p.PBS_AAAP_BASE_OPERATING_COSTS__c, p.PBS_AAAP_ARCH_ENG_FEES__c, PBS_AAAP_Total_ABOA_Edited__c,
                                        p.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, p.Name, PBS_AAAP_Total_Actual_Space_Available__c, p.Id, PBS_AAAP_ClonedFromSpace__c, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                                FROM PBS_AAAP_Space__c p
                                WHERE PBS_AAAP_OFFER_NUMBER__c = :offer.id
                        ]) {

                            PBS_AAAP_Space__c newSpace = pi.clone(false, true, false, false);
                            newSpace.PBS_AAAP_OFFER_NUMBER__c = newofferDraft.id;
                            newspace.PBS_AAAP_ClonedFromSpace__c = pi.Id;
                            newSpace.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                            newSpaceitems.add(newSpace);

                            spaceMapDetail.put(newspace.PBS_AAAP_ClonedFromSpace__c, newSpace);

                        }

                        //insert newSpaceitems;
                        insert spaceMapDetail.values();
                        for (PBS_AAAP_Space__c pi : [
                                SELECT p.Id, PBS_AAAP_ClonedFromSpace__c, PBS_AAAP_OFFER_NUMBER__c
                                FROM PBS_AAAP_Space__c p
                                WHERE PBS_AAAP_ClonedFromSpace__c IN :spaceMapDetail.keySet() AND PBS_AAAP_OFFER_NUMBER__c = :newofferDraft.id
                        ]) {
                            spaceMap.put(pi.PBS_AAAP_ClonedFromSpace__c, pi.Id);
                        }
                        // added by syam issues with rates not cloning bsac fields.. p.PBS_AAAP_BSAC__c, p.PBS_AAAP_BSAC_RATE__c
                        for (PBS_AAAP_Rate__c rate : [
                                SELECT p.PBS_AAAP_Vacant_Premise_Rate__c, p.PBS_AAAP_TWO_YEAR_EXTENSION__c, p.PBS_AAAP_SPACE__c,
                                        p.PBS_AAAP_PV_Value__c, p.PBS_AAAP_PV_Value_Blended__c, p.PBS_AAAP_OT_RATE_COOLING_HEAT__c,
                                        p.PBS_AAAP_ONE_YEAR_EXTENSION__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                                        p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, p.PBS_AAAP_LEGACY_OFFER_NUMBER__c,
                                        p.PBS_AAAP_LEGACY_IDENTIFIER_ID__c, p.PBS_AAAP_LEASE_TERM__c, p.PBS_AAAP_IDENTIFIER_ID__c,
                                        p.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, p.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, p.PBS_AAAP_EXTERNAL_ID__c,
                                        p.PBS_AAAP_COST_FOR_TI__c, p.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, p.PBS_AAAP_BASE_RATE__c,
                                        p.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, p.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                                        p.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, p.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,
                                        p.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, p.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                                        p.Name, p.IsDeleted, p.Id,
                                        p.PBS_AAAP_BSAC__c, p.PBS_AAAP_BSAC_RATE__c
                                FROM PBS_AAAP_Rate__c p
                                WHERE p.PBS_AAAP_SPACE__c = :spaceMap.keySet()
                        ]) {
                            if (spaceMap.containsKey(rate.PBS_AAAP_SPACE__c)) {
                                PBS_AAAP_Rate__c newRate = rate.clone(false, true);
                                newRate.PBS_AAAP_SPACE__c = spaceMap.get(rate.PBS_AAAP_SPACE__c);
                                newRate.PBS_AAAP_EXTERNAL_ID__c = null;
                                newRate.PBS_AAAP_OFFER_NUMBER__c = newofferDraft.id;
                                newRatesList.add(newRate);
                            }

                        }
                        insert newRatesList;
                        if (newofferDraft.Id != null) {
                            
                            if(offer.property__c == null){
            	
                            redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=true&action=modify&offerId='+newofferDraft.Id;
                            }
                            else if(property.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null || property.PBS_AAAP_Building_Name__c == null || property.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null)
                            {
                                redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=true&action=modify&offerId='+newofferDraft.Id+'&propertyId='+propertyId;  
                            }
                            else{
                            redirectURL = '/leasing/s/Offer-M-Eligibility?edit=true&isNew=true&action=modify&offerId='+newofferDraft.Id+'&propertyId='+propertyId;
                            }
                            
                        }
                    } else {
                        
                        redirectURL = 'pmError';
                        
                    }
                }
            
            } 
            //added by syam 02/05/2016 if the offer status is withdrawn make current offer invalid and create draft offer
            else if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED ||
                    offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) {

                System.debug('3. The offer Status :::::::::::::  ' + offer.PBS_AAAP_Offer_Status__c);

                newofferDraft = offerClone(offer.id, 'edit');
                newofferDraft.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                // need to have lookup to current offer, when this offer gets submitted the original offer status should get change.
                newofferDraft.PBS_AAAP_Parent_Offer__c = offer.Id;
                
                newofferDraft.PBS_AAAP_Offer_Submission_Date__c = null;
                newofferDraft.PBS_AAAP_LEGACY_OFFER_NUMBER__c = null;
                insert newofferDraft;
                System.debug('4. The offer Inserted :::::::::::::  ' + newofferDraft.Id + '   with Status:::  ' + newofferDraft.PBS_AAAP_Offer_Status__c);
                if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED) {
                    List<PBS_AAAP_Other_Costs__c> newOtherCosts = new List<PBS_AAAP_Other_Costs__c>();
                    for (PBS_AAAP_Other_Costs__c oc : [
                            SELECT p.PBS_AAAP_SHORT_DESC__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_COST__c, p.PBS_AAAP_COST_TYPE__c,
                                    p.PBS_AAAP_COST_REMOVAL__c, p.Name, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                            FROM PBS_AAAP_Other_Costs__c p
                            WHERE p.PBS_AAAP_OFFER_NUMBER__c = :offer.id
                    ]) {
                        PBS_AAAP_Other_Costs__c newOCost = oc.clone(false, true);
                        newOCost.PBS_AAAP_OFFER_NUMBER__c = newofferDraft.id;
                        newOCost.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                        newOtherCosts.add(newOCost);
                    }
                    insert newOtherCosts;

                    List<PBS_AAAP_Space__c> newSpaceitems = new List<PBS_AAAP_Space__c>();
                    List<PBS_AAAP_Space__c> oldSpaceitems = new List<PBS_AAAP_Space__c>();
                    Map<Id, Id> spaceMap = new Map<Id, Id>(); //(oldspaceId,newSpaceId)
                    Map<string, PBS_AAAP_Space__c> spaceMapDetail = new Map<string, PBS_AAAP_Space__c>();
                    List<PBS_AAAP_Rate__c> newRatesList = new List<PBS_AAAP_Rate__c>();
                    for (PBS_AAAP_Space__c pi : [
                            SELECT p.PBS_AAAP_Total_ABOA_Withdrawn__c, p.PBS_AAAP_Total_ABOA_Selected__c, p.PBS_AAAP_Total_ABOA_Awarded__c,
                                    p.PBS_AAAP_Total_ABOA_Available__c, p.PBS_AAAP_TOT_EXP_ABOA__c, p.PBS_AAAP_TOTAL_MARKUP__c, p.PBS_AAAP_SUITE_INDICATOR__c,
                                    p.PBS_AAAP_SF_OFFERED__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, p.PBS_AAAP_Max_Contiguous_Space__c,
                                    p.PBS_AAAP_MIN_OFFERABLE_SPACE__c, p.PBS_AAAP_MAX_OFFERABLE_SPACE__c, p.PBS_AAAP_MANAGEMENT_COORD_FEES__c,
                                    p.PBS_AAAP_LOCATION_OF_FLOORS__c, p.PBS_AAAP_LEGACY_OFFER_NUMBER__c, p.PBS_AAAP_LEGACY_IDENTIFIER_ID__c,
                                    p.PBS_AAAP_IDENTIFIER_TYPE__c, p.PBS_AAAP_IDENTIFIER_TO__c, p.PBS_AAAP_IDENTIFIER_ID__c, p.PBS_AAAP_IDENTIFIER_FROM__c,
                                    p.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c, p.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, p.PBS_AAAP_GC_CONDITIONS__c, p.PBS_AAAP_FLOOR_INDICATOR__c,
                                    p.PBS_AAAP_DATE_SPACE_AVAILABILITY__c, p.PBS_AAAP_BASE_OPERATING_COSTS__c, p.PBS_AAAP_ARCH_ENG_FEES__c, PBS_AAAP_Total_ABOA_Edited__c,
                                    p.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, p.Name, PBS_AAAP_Total_Actual_Space_Available__c, PBS_AAAP_ClonedFromSpace__c, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                            FROM PBS_AAAP_Space__c p
                            WHERE PBS_AAAP_OFFER_NUMBER__c = :offer.id
                    ]) {
                        if (pi.PBS_AAAP_Total_Actual_Space_Available__c > 0) { // Space has to be copied only when it has actual remaining space available
                            PBS_AAAP_Space__c newSpace = pi.clone(false, true, false, false);
                            newSpace.PBS_AAAP_OFFER_NUMBER__c = newofferDraft.id;
                            newspace.PBS_AAAP_SF_OFFERED__c = pi.PBS_AAAP_Total_Actual_Space_Available__c;
                            newSpace.PBS_AAAP_Total_ABOA_Available__c = pi.PBS_AAAP_Total_Actual_Space_Available__c;
                            newSpace.PBS_AAAP_Total_ABOA_Awarded__c = 0.00; // making total awarded space to null for new copy
                            newSpace.PBS_AAAP_Total_ABOA_Selected__c = 0.00; // making total selected space to null for new copy
                            newSpace.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                            newspace.PBS_AAAP_ClonedFromSpace__c = pi.Id;
                            newSpaceitems.add(newSpace);
                            spaceMapDetail.put(newspace.PBS_AAAP_ClonedFromSpace__c, newSpace);
                            // Update old spcae items for Total ABOA Withdrawn
                            pi.PBS_AAAP_Total_ABOA_Edited__c = pi.PBS_AAAP_Total_ABOA_Edited__c + pi.PBS_AAAP_Total_Actual_Space_Available__c;
                            oldSpaceitems.add(pi);
                        }

                    }
                    insert spaceMapDetail.values(); //insert newSpaceitems;
                    update oldSpaceitems;
                    
                    System.debug('6. Spaces inserted :::::::::::::  ' + newSpaceitems);

                    for (PBS_AAAP_Space__c pi : [
                            SELECT p.Id, PBS_AAAP_ClonedFromSpace__c, PBS_AAAP_OFFER_NUMBER__c
                            FROM PBS_AAAP_Space__c p
                            WHERE PBS_AAAP_ClonedFromSpace__c IN :spaceMapDetail.keySet() AND PBS_AAAP_OFFER_NUMBER__c = :newofferDraft.id
                    ]) {
                        spaceMap.put(pi.PBS_AAAP_ClonedFromSpace__c, pi.Id);
                    }
                    // added by syam issues with rates not cloning bsac fields.. p.PBS_AAAP_BSAC__c, p.PBS_AAAP_BSAC_RATE__c
                    for (PBS_AAAP_Rate__c rate : [
                            SELECT p.PBS_AAAP_Vacant_Premise_Rate__c, p.PBS_AAAP_TWO_YEAR_EXTENSION__c, p.PBS_AAAP_SPACE__c,
                                    p.PBS_AAAP_PV_Value__c, p.PBS_AAAP_PV_Value_Blended__c, p.PBS_AAAP_OT_RATE_COOLING_HEAT__c,
                                    p.PBS_AAAP_ONE_YEAR_EXTENSION__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                                    p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, p.PBS_AAAP_LEGACY_OFFER_NUMBER__c,
                                    p.PBS_AAAP_LEGACY_IDENTIFIER_ID__c, p.PBS_AAAP_LEASE_TERM__c, p.PBS_AAAP_IDENTIFIER_ID__c,
                                    p.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, p.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, p.PBS_AAAP_EXTERNAL_ID__c,
                                    p.PBS_AAAP_COST_FOR_TI__c, p.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, p.PBS_AAAP_BASE_RATE__c,
                                    p.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, p.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                                    p.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, p.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,
                                    p.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, p.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                                    p.Name, p.IsDeleted, p.Id,
                                    p.PBS_AAAP_BSAC__c, p.PBS_AAAP_BSAC_RATE__c
                            FROM PBS_AAAP_Rate__c p
                            WHERE p.PBS_AAAP_SPACE__c = :spaceMap.keySet()
                    ]) {
                        if (spaceMap.containsKey(rate.PBS_AAAP_SPACE__c)) {
                            PBS_AAAP_Rate__c newRate = rate.clone(false, true);
                            newRate.PBS_AAAP_SPACE__c = spaceMap.get(rate.PBS_AAAP_SPACE__c);
                            newRate.PBS_AAAP_EXTERNAL_ID__c = null;
                            newRatesList.add(newRate);
                        }

                    }
                    insert newRatesList;
                }
                //added by syam 02/05/2016 if offer status is withdrawn make invalid and reset parent offer
                if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) {
                    offer.PBS_AAAP_Parent_Offer__c = null;
                    offer.PBS_AAAP_Is_Offer_Valid__c = false;
                    update offer;

                    //added by syam on 06/13 to copy the attachments and also copy other costs when the user trying to edit the with drawn offer
                    List<PBS_AAAP_Other_Costs__c> newOtherCosts = new List<PBS_AAAP_Other_Costs__c>();
                    for (PBS_AAAP_Other_Costs__c oc : [
                            SELECT p.PBS_AAAP_SHORT_DESC__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_COST__c, p.PBS_AAAP_COST_TYPE__c,
                                    p.PBS_AAAP_COST_REMOVAL__c, p.Name, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                            FROM PBS_AAAP_Other_Costs__c p
                            WHERE p.PBS_AAAP_OFFER_NUMBER__c = :offer.id
                    ]) {
                        PBS_AAAP_Other_Costs__c newOCost = oc.clone(false, true);
                        newOCost.PBS_AAAP_OFFER_NUMBER__c = newofferDraft.id;
                        newOCost.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                        newOtherCosts.add(newOCost);
                    }
                    insert newOtherCosts;

                    List<PBS_AAAP_Offer_Attachments__c> newAttachmentsList = new List<PBS_AAAP_Offer_Attachments__c>();
                    System.debug('offer attachments cloning !!!' + offer.Id + '   new offer Id ' + newofferDraft.id);
                    List<PBS_AAAP_Offer_Attachments__c> oldAttachmentsList = [
                            SELECT Id, Name, PBS_AAAP_Attachment_Type__c
                            FROM PBS_AAAP_Offer_Attachments__c p
                            WHERE p.PBS_AAAP_Offer__c = :offerId
                    ];
                    List<Id> attOfferIds = new List<Id>();
                    Map<Id, ContentDocumentWrapper> contentDocumentMap = new Map<Id, ContentDocumentWrapper>();
                    Map<Id, Id> olddAttIdWithNewAttIdMap = new Map<Id, Id>();
                    for(PBS_AAAP_Offer_Attachments__c attachmentRecord : oldAttachmentsList){
                        attOfferIds.add(attachmentRecord.Id);
                    }
                    
                    List<ContentDocumentLink> ContentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.VersionData, ContentDocument.CreatedDate, ContentDocument.Description  FROM ContentDocumentLink Where LinkedEntityId IN :attOfferIds];
                    for(ContentDocumentLink contentDocumentLinkRecord : ContentDocumentLinks){
                        contentDocumentMap.put(contentDocumentLinkRecord.LinkedEntityId,new ContentDocumentWrapper(contentDocumentLinkRecord.ContentDocument.Title, contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.VersionData));
                    }
                    for (PBS_AAAP_Offer_Attachments__c attach : oldAttachmentsList) {
                        PBS_AAAP_Offer_Attachments__c newAttach = attach.clone(false, true);
                        System.debug('Old attachment Id is ****' + attach.Id);
                        newAttach.PBS_AAAP_Offer__c = newofferDraft.id;
                        insert newAttach;
                        olddAttIdWithNewAttIdMap.put(newAttach.Id, attach.Id);
                        newAttachmentsList.add(newAttach);
                    }
                    if(newAttachmentsList.size() > 0){
                        Map<Id,Id> offerIdWithContentVersionIdMap = new Map<Id,Id>();
                        Set<Id> contentVersionIds = new Set<Id>();
                        for (PBS_AAAP_Offer_Attachments__c attach : newAttachmentsList) {
                            ContentVersion ContVerFile = new ContentVersion();
                            ContentDocumentWrapper contentDocumentWrapperObj = contentDocumentMap.get(olddAttIdWithNewAttIdMap.get(attach.Id));
                            ContVerFile.VersionData = contentDocumentWrapperObj.bodyBlob;
                            ContVerFile.Title = contentDocumentWrapperObj.name; 
                            ContVerFile.PathOnClient= contentDocumentWrapperObj.name;
                            insert ContVerFile;
                            contentVersionIds.add(ContVerFile.Id);
                            offerIdWithContentVersionIdMap.put(ContVerFile.Id, attach.Id);
                        }
                        List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
                        List<ContentDistribution> contentDistributionList = new List<ContentDistribution>();
                        for(ContentVersion contentVersionRecord : [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id In:contentVersionIds]){
                            ContentDocumentLink cDe = new ContentDocumentLink();
                            cDe.ContentDocumentId = contentVersionRecord.ContentDocumentId;
                            cDe.LinkedEntityId = offerIdWithContentVersionIdMap.get(contentVersionRecord.Id);
                            cDe.ShareType = 'V';
                            cDe.Visibility = 'AllUsers';
                            contentDocumentLinkList.add(cDe);
                            
                            contentDistributionList.add(new ContentDistribution(
                               Name = contentVersionRecord.Title,
                               ContentVersionId = contentVersionRecord.Id,
                               PreferencesAllowViewInBrowser= true,
                               PreferencesNotifyOnVisit= false
                            ));
                            
                        }
                        if(contentDocumentLinkList.size() > 0){
                            insert contentDocumentLinkList;
                        }
                        if(contentDistributionList.size() > 0){
                            insert contentDistributionList;
                        }
                        List<ContentDocument> contentDocumentList = new List<ContentDocument>();
                        for(ContentDistribution contentDistributionRecord : [SELECT DistributionPublicUrl, ContentDocumentId FROM ContentDistribution 
                                                   WHERE contentVersionId In :contentVersionIds]){
                            contentDocumentList.add(new ContentDocument(Id=contentDistributionRecord.ContentDocumentId,Description=contentDistributionRecord.DistributionPublicUrl));
                        }
                        if(contentDocumentList.size() > 0){
                            update contentDocumentList;
                        }
                    }
                }

                if (newofferDraft.Id != null) {
                    
                    if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) 
                        {
                            if(offer.property__c == null){
            	
                            redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=true&action=withdrawn&offerId='+newofferDraft.Id;
                            }
                            else if(property.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null || property.PBS_AAAP_Building_Name__c == null || property.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null)
                            {
                                redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=true&action=withdrawn&offerId='+newofferDraft.Id+'&propertyId='+propertyId;  
                            }
                            else{
                            redirectURL = '/leasing/s/Offer-M-Eligibility?edit=true&isNew=true&action=withdrawn&offerId='+newofferDraft.Id+'&propertyId='+propertyId;
                            }
                         
                             
                        }
                     else
                     {
                         if(offer.property__c == null){
            	
                            redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=true&action=modify&offerId='+newofferDraft.Id;
                            }
                            else if(property.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null || property.PBS_AAAP_Building_Name__c == null || property.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null)
                            {
                                redirectURL = '/leasing/s/Offer-Location?edit=true&isNew=true&action=modify&offerId='+newofferDraft.Id+'&propertyId='+propertyId;  
                            }
                            else{
                            redirectURL = '/leasing/s/Offer-M-Eligibility?edit=true&isNew=true&action=modify&offerId='+newofferDraft.Id+'&propertyId='+propertyId;
                            }
        
                          
                     }
                     
                }
               }
               else{
                redirectURL = '/leasing/s/Offer-M-Eligibility?edit=true&offerId='+offerId+'&propertyId='+propertyId;
                
            }
        } catch (Exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            
            return null;
        }        

        return redirectURL;
    } 
}