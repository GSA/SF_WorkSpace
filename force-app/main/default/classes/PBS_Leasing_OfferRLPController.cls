public with sharing class PBS_Leasing_OfferRLPController {
    
    
    @AuraEnabled(cacheable=true)
    
    public static RLPResponseWrapper searchRecords(String searchValue, String propertyId) {
        Boolean flag = false;
        String countyCompare;
        List<PBS_AAAP_RLP_Regions_Map__c > RLPRegionMapList;
        RLPResponseWrapper response = new RLPResponseWrapper();
        // Ensure the searchValue is not null or empty
        if (String.isBlank(searchValue)) {
            return response;
        }
        PBS_AAAP_Property__c propertyRecord = [Select Id, PBS_AAAP_County__c, PBS_AAAP_City__c, PBS_AAAP_State__c from PBS_AAAP_Property__c where Id =:propertyId];
        
        String query = searchValue;
        List<PBS_AAAP_RLP__c> rlpRecords; 
        if (String.isNotBlank(searchValue)) { 
            rlpRecords = [SELECT Id, PBS_AAAP_RLP_Number__c, PBS_RSAP_Project_Number__c, PBS_RSAP_Solicitation_Number__c, PBS_RSAP_Solicitation_G_REX_ID__c, PBS_RSAP_Solicitation_Status__c, recordtype.name, PBS_AAAP_Region__c FROM PBS_AAAP_RLP__c WHERE ((PBS_AAAP_STATUS__c = 'Posted/Active' AND PBS_AAAP_isActive__c = TRUE AND PBS_AAAP_RLP_Number__c = :searchValue) OR (PBS_RSAP_Solicitation_Status__c = true AND PBS_RSAP_Solicitation_Number__c = :searchValue))]; 
        }
        if(rlpRecords.size() > 0){
            response.rlpRecord = rlpRecords[0];
            response.isValidRLP = true;
            if(String.isNotBlank(response.rlpRecord.PBS_RSAP_Solicitation_Number__c)){
                response.isValidAddress = true;
            }else{
                if (response.rlpRecord.PBS_AAAP_RLP_Number__c == 'National Capital Region' || response.rlpRecord.PBS_AAAP_RLP_Number__c == 'NCR') {
                    
                    //select to check to see if the building resides in the correct region
                    // based on the state of the building
                    //NOTE: that the PBS_AAAP_RLP_State__c may contain a county, city or state. Counties end in " county"
                    RLPRegionMapList = [
                        SELECT Id, PBS_AAAP_Region_Name__c,PBS_AAAP_RLP_State_Abbrevation__c,
                        PBS_AAAP_RLP_State__c
                        FROM PBS_AAAP_RLP_Regions_Map__c
                        WHERE PBS_AAAP_Region_Name__c = 'National Capital Region'
                        AND PBS_AAAP_RLP_State_Abbrevation__c = :propertyRecord.PBS_AAAP_State__c
                    ];
                    //state or county
                    
                    //look for a matching record via
                    flag = true;  //set to false to assume that it does not exist
                    //do increment searches.  loop through all of the entries for the NCR Region by the buildings state
                    for (PBS_AAAP_RLP_Regions_Map__c rlp : RLPRegionMapList) {
                        //add the word "county" to the comparison variable
                        if (propertyRecord.PBS_AAAP_County__c != null) {
                            countyCompare = propertyRecord.PBS_AAAP_County__c + ' county';
                        } else {
                            countyCompare = 'No County'; //this is just a default for comparison purposes
                        }
                        
                        //If the property's City or county match the record is valid or if the county match
                        if ((propertyRecord.PBS_AAAP_City__c == rlp.PBS_AAAP_RLP_State__c)
                            || (countyCompare == rlp.PBS_AAAP_RLP_State__c)
                            || (propertyRecord.PBS_AAAP_County__c == rlp.PBS_AAAP_RLP_State__c)) {
                                flag = false;  //if found then break the loop and return that the address is valid
                                break;
                            }
                    }
                } else {
                    //do a select against the RLP Region table to pull the states
                    RLPRegionMapList = [
                        SELECT Id, PBS_AAAP_Region_Name__c,PBS_AAAP_RLP_State_Abbrevation__c
                        FROM PBS_AAAP_RLP_Regions_Map__c
                        WHERE PBS_AAAP_Region_Name__c = :response.rlpRecord.PBS_AAAP_Region__c
                        AND PBS_AAAP_RLP_State_Abbrevation__c = :propertyRecord.PBS_AAAP_State__c
                    ];
                    flag = true;  //set flag as true unless a value is found westonv
                    for (PBS_AAAP_RLP_Regions_Map__c rlp : RLPRegionMapList) {
                        flag = false;  //it has been found should only have one
                        break;
                    }
                }
                
                response.isValidAddress = !flag;
                
            }
        }
        return response;
        
    }
    public class RLPResponseWrapper {
        @AuraEnabled public Boolean isValidAddress{ get; set; }
        @AuraEnabled public Boolean isValidRLP{ get; set; }
        @AuraEnabled public PBS_AAAP_RLP__c rlpRecord{ get; set; }
        public RLPResponseWrapper(){
            this.isValidAddress = false;
            this.isValidRLP = false;
            this.rlpRecord = new PBS_AAAP_RLP__c();
        }
    }
    
    @AuraEnabled
    public static ResponseWrapper createOfferRecord(PBS_AAAP_Offer__c offerRecord,String pageName,String rType) {
        RecordType recordType = [SELECT Id,name FROM RecordType where sObjectType = 'PBS_AAAP_Offer__c' AND NAME = :rType LIMIT 1];
        ResponseWrapper resultOfCreateOffer = new ResponseWrapper();
        resultOfCreateOffer = validateOffer(offerRecord,pageName);
        offerRecord.RecordTypeId = recordType.Id;
        offerRecord.PBS_AAAP_Is_Offer_Valid__c =true;
        
        offerRecord.PBS_AAAP_Building_Common_Area_Factor__c = offerRecord.PBS_AAAP_Common_Area_Factor__c;
        offerRecord.PBS_AAAP_Common_Area_Factor__c = null;
        
        if(resultOfCreateOffer.errorMessages.size() == 0){
            try{
                insert offerRecord;
                resultOfCreateOffer.isSuccess = true;
            }
            catch(DMLException e){
                resultOfCreateOffer.addErrorMessage(e.getDmlMessage(0));
            }
        }
        resultOfCreateOffer.offerId = offerRecord.Id;
        return resultOfCreateOffer; // Return the ID of the newly created offer
    }
    
    
    @AuraEnabled
    public static PBS_Leasing_OfferPropertyWrapper.objectWrapper getPropertyOfferDetails(String recordId) { 
        return PBS_Leasing_OfferPropertyWrapper.getPropertyDetails(recordId);
    }
    @AuraEnabled
    public static ResponseWrapper updateOfferRecord(PBS_AAAP_Offer__c offerRecord,String pageName) {
        
        
        ResponseWrapper resultOfUpdateOffer = new ResponseWrapper();
        resultOfUpdateOffer = validateOffer(offerRecord,pageName);
        if(resultOfUpdateOffer.errorMessages.size() == 0){
            try{
                update offerRecord;
                resultOfUpdateOffer.isSuccess = true;
            }
            catch(DMLException e){
                resultOfUpdateOffer.addErrorMessage(e.getDmlMessage(0));
            }
        }
        resultOfUpdateOffer.offerId = offerRecord.Id;
        return resultOfUpdateOffer;
    }
    
    @AuraEnabled
    public static ResponseWrapper validateOffer(PBS_AAAP_Offer__c submitoffer, String pageName) {
        ResponseWrapper response = new ResponseWrapper();
        System.debug('submitoffer>>>>>>>'+submitoffer);
        List<PBS_Leasing_Required_Offer_Fields__mdt> requiredOfferFields = [SELECT Id, Object_Name__c, Order_Number__c, Error_Message__c, Filter__c FROM PBS_Leasing_Required_Offer_Fields__mdt WHERE Object_Name__c =:'PBS_AAAP_Offer__c' AND DeveloperName != Null AND Page_name__c=:pageName Order By Order_Number__c];
        System.debug('requiredOfferFields>>>>>>'+requiredOfferFields);
        for(PBS_Leasing_Required_Offer_Fields__mdt requiredOfferField : requiredOfferFields){
            Integer countOfPassedConditions = 0;
            
            if(requiredOfferField.Filter__c.contains('==')){
                List<String> conditionParts = requiredOfferField.Filter__c.split('==');
                System.debug('conditionparts>>>>>>'+conditionParts);
                System.debug('conditionparts0>>>>>>'+submitoffer.get(conditionParts[0].trim()));
                System.debug('conditionparts1>>>>>>'+conditionParts[1].trim());
                Object obj;
                if(conditionParts[1].trim() == 'null' && submitoffer.get(conditionParts[0].trim()) == obj){
                    countOfPassedConditions++;
                }else if(submitoffer.get(conditionParts[0].trim()) == conditionParts[1].trim()){
                    
                    countOfPassedConditions++;
                }
                
            }
            
            if(countOfPassedConditions > 0){
                response.addErrorMessage(requiredOfferField.Error_Message__c);
            }
            
            
        }
        
        return response;
    }
    
    // Helper class to store the response of the validation process
    public class ResponseWrapper {
        @AuraEnabled public Boolean isSuccess { get; set; }
        @AuraEnabled public List<String> errorMessages { get; set; }
        @AuraEnabled public String offerId { get; set; }
        // Constructor to initialize the response object
        public ResponseWrapper() {
            this.isSuccess = false;
            this.errorMessages = new List<String>();
        }
        // Method to add an error message to the response
        public void addErrorMessage(String message) {
            this.errorMessages.add(message);
        }
    }
}