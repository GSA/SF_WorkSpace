/**
 * Created by nkopparthi on 4/16/20.
 */

trigger PBS_AAAP_OSAI_Trigger on PBS_AAAP_Offer_Select_Award_Info__c (after insert) {

    AAAP_Skip_Logic_Setting__c isSkip =  AAAP_Skip_Logic_Setting__c.getValues(UserInfo.getProfileId());

    if(isSkip == null){
        if (Trigger.isAfter && Trigger.isInsert) {

            List<PBS_AAAP_Offer_Select_Award_Info__c> newOfferList = Trigger.new;

            if ((newOfferList != null) && (newOfferList.size() > 0)) {
                String vPhase = 'P1';
                
                for (integer i = 0; i < newOfferList.size(); i++) {
                    String recId = String.valueOf(newOfferList[i].Id);
                    PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c();
                    offerRec = [SELECT Id, Master_Offer__c FROM PBS_AAAP_Offer__c WHERE Id = :newOfferList[i].PBS_AAAP_Offer_ID__c LIMIT 1];

                    PBS_AAAP_SendOfferDetailsAPI.sendOfferDetailsAAAP(newOfferList[i].PBS_AAAP_Offer_ID__c, newOfferList[i].PBS_AAAP_AGENCY_REQUIREMENT_ID__c, recId, offerRec.Master_Offer__c, vPhase);

                }
            }

        }
    }

}