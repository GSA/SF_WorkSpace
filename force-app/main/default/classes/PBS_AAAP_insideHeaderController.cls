public with sharing class PBS_AAAP_insideHeaderController {
    String offerId {get; set;}
    public PageReference updateOfferStatus () {
        System.debug('----offerId'+ offerId);
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        String allowStatusChange = ApexPages.currentPage().getParameters().get('allowStatusChange');
        if (String.isNotBlank(offerId) && allowStatusChange != 'n') {
            List<PBS_AAAP_Offer__c> offers = [SELECT Id, PBS_AAAP_Offer_Status__c FROM PBS_AAAP_Offer__c WHERE Id = :offerId];
            System.debug('----offers'+ offers);
            Schema.DescribeSObjectResult res = Schema.SObjectType.PBS_AAAP_Offer__c;
            if (offers != null && !offers.isEmpty() && offers[0].PBS_AAAP_Offer_Status__c == 'Submitted' && res.isAccessible() && res.isUpdateable()) {
                offers[0].PBS_AAAP_Offer_Status__c = 'Pending Modification';
                update offers[0];
            }
        }
        return null;
    }
}