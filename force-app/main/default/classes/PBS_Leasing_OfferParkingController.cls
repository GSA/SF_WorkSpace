public with sharing class PBS_Leasing_OfferParkingController {
    
    public PBS_Leasing_OfferParkingController() {

    }

    @AuraEnabled
    public static PBS_AAAP_Offer__c getPropertyOfferDetails(String recordId) { 
        return PBS_AAAP_GlobalConstants.getOfferDetail(recordId);
    }

    @AuraEnabled
    public static PBS_AAAP_Utility.OfferValidationResponse updateOfferRecord(PBS_AAAP_Offer__c offerRecord,String pageName) {
        
        PBS_AAAP_Utility.OfferValidationResponse response = new PBS_AAAP_Utility.OfferValidationResponse();
        response = PBS_AAAP_Utility.validateOffer(offerRecord,new List<String>{pageName});
        if(response.errorMessages.size() == 0){
            try{
                update offerRecord;
                response.success = true;
            }
            catch(DMLException e){
                response.addErrorMessage(e.getDmlMessage(0));
            }
        }
        return response;
    }
}