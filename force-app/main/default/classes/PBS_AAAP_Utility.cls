//public with sharing class PBS_AAAP_Utility {
public class PBS_AAAP_Utility {
    public static string getQueryParamAsString(string paramName) {
        return ApexPages.currentPage().getParameters().get(paramName);
    }
    public static decimal getQueryParamAsDecimal(string paramName) {
        return getQueryParamAsDecimal(paramName, 0);
    }
    public static decimal getQueryParamAsDecimal(string paramName, decimal defaultValue) {
        try {
            return decimal.valueOf(getQueryParamAsString(paramName));
        } catch (Exception ex) {
            return defaultValue;
        }
    }
    public static void setQueryParam(string paramName, string val) {
        ApexPages.currentPage().getParameters().put(paramName, val);
    }
    public static void logMethodStart(string methodName){
        system.debug(methodName+' vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
    }
    public static  void logMethodEnd(string methodName){
        system.debug(methodName+' ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    }
    public static  void logMethodEnd(string methodName, object ret){
        logMethodEnd(methodName);
    }
    
    public static String getCommunityURL(string url){
        System.debug('fromLWC '+url);
        if(url.contains('Offer-M') || url.contains('Offer-S') || url.contains('Offer-Overview')){
            return url.replace(Label.LOP_Community_Base_URL,'');
        }
        if(url.contains('fromLWC'+Label.LOP_Community_Base_URL)){
            return url.replace('fromLWC'+Label.LOP_Community_Base_URL,'');
        }
        if(url.startsWith('/')){
            url = url.replaceFirst('/', '');
        }
        List<Site_Page_Name_With_Community_Page__mdt> allRecords = Site_Page_Name_With_Community_Page__mdt.getAll().values();
        for(Site_Page_Name_With_Community_Page__mdt mdtRecord : allRecords){
            if(url.toLowercase().contains(mdtRecord.Label.toLowercase())){
                if(url.contains('?')){
                    String urlBefore = url.substringBefore('?');
                    String urlAfter = url.substringAfter('?');
                    System.debug(urlBefore);
                    System.debug(urlBefore.replace(mdtRecord.Label, mdtRecord.Community_Page__c));
                    url = urlBefore.replace(mdtRecord.Label, mdtRecord.Community_Page__c)+'?'+urlAfter;//.toLowercase()
                }else{
                    url = url.replace(mdtRecord.Label, mdtRecord.Community_Page__c);
                }
                return url;//toLowercase().
            }
            
        }
        
        return '';
    }
    @AuraEnabled
    public static OfferValidationResponse validateOffer(PBS_AAAP_Offer__c submitOffer, List<String> pages) {
        // Initialize the response wrapper class
        OfferValidationResponse response = new OfferValidationResponse();
        
        List<PBS_Leasing_Required_Offer_Fields__mdt> requiredOfferFields;
            if(pages.size() > 0){
                requiredOfferFields = [Select Id, Filter__c, Error_Message__c, Order_Number__c from PBS_Leasing_Required_Offer_Fields__mdt Where DeveloperName != Null AND Object_Name__c = 'PBS_AAAP_Offer__c' AND Page_name__c in :pages Order By Order_Number__c];
            }else{
                requiredOfferFields = [Select Id, Filter__c, Error_Message__c, Order_Number__c from PBS_Leasing_Required_Offer_Fields__mdt Where DeveloperName != Null AND Object_Name__c = 'PBS_AAAP_Offer__c' Order By Order_Number__c];
            }
            System.debug(requiredOfferFields);
        // Loop through each required field to validate the conditions
        for(PBS_Leasing_Required_Offer_Fields__mdt requiredOfferField : requiredOfferFields){
            Integer countOfPassedConditions = 0;
            // Handle 'OR' conditions in the filter
            if(requiredOfferField.Filter__c.contains(('||'))){
                System.debug('see the split'+ requiredOfferField.Filter__c.split(('\\|\\|')).size());
                for(String filter : requiredOfferField.Filter__c.split(('\\|\\|'))){
                    System.debug('seefilter '+filter);
                    // Validate based on equality and null checks
                    if(filter.contains('==')){
                        List<String> conditionParts = filter.split('==');
                        Object obj;
                        System.debug(submitOffer.get(conditionParts[0].trim()));
                        System.debug(conditionParts[1].trim());
                        System.debug(submitOffer.get(conditionParts[0].trim()) == conditionParts[1].trim());
                        if(conditionParts[1].trim() == 'null' && submitOffer.get(conditionParts[0].trim()) == obj){
                            countOfPassedConditions++;
                        }else if(String.valueOf(submitOffer.get(conditionParts[0].trim())) == conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }
                    
                }
                // If any condition passes, add the error message to the response
                if(countOfPassedConditions > 0){
                    response.addErrorMessage(requiredOfferField.Error_Message__c);
                }
            }
            // Handle 'AND' conditions in the filter
            else{
                for(String filter : requiredOfferField.Filter__c.split('&&')){
                     // Validate based on equality and null checks
                    if(filter.contains('==')){
                        System.debug(requiredOfferField.Error_Message__c + filter);
                        List<String> conditionParts = filter.split('==');
                        Object obj;
                        if(conditionParts[1].trim().contains('\'')){
                            conditionParts[1] = conditionParts[1].replaceAll('\'','');
                        }
                        System.debug(conditionParts[1].trim());
                        System.debug(submitOffer.get(conditionParts[0].trim()));
                        System.debug(submitOffer.get(conditionParts[0].trim()) == conditionParts[1].trim());
                        if(conditionParts[1].trim() == 'null' && submitOffer.get(conditionParts[0].trim()) == obj){
                            countOfPassedConditions++;
                        }else if(String.valueOf(submitOffer.get(conditionParts[0].trim())) == conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }else if(filter.contains('!=')){// Validate based on equality and null checks
                        List<String> conditionParts = filter.split('!=');
                        Object obj;
                        if(conditionParts[1].trim().contains('\'')){
                            conditionParts[1] = conditionParts[1].replaceAll('\'','');
                        }
                        if(conditionParts[1].trim() != 'null' && submitOffer.get(conditionParts[0].trim()) != obj){
                            countOfPassedConditions++;
                        }else if(submitOffer.get(conditionParts[0].trim()) != conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }
                    
                    else if(filter.contains('<')){
                        List<String> conditionParts = filter.split('<');
                        if(Decimal.valueOf(String.valueOf(submitOffer.get(conditionParts[0].trim()))) < Decimal.valueOf(conditionParts[1].trim())){
                            countOfPassedConditions++;
                        }
                    }
                }
                // If all conditions pass, add the error message to the response
                if(countOfPassedConditions == requiredOfferField.Filter__c.split('&&').size()){
                    response.addErrorMessage(requiredOfferField.Error_Message__c);
                }
            }
            
        }
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
}