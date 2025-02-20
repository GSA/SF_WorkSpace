trigger PBS_AAAP_OfferDeselectCreateCase on PBS_AAAP_Offer_Deselect_Reject_Reasons__c (after insert) {

    // Creation of cases is not possible thru data migration based on this Object.
    // So we need to consider only one record at any time.  
    /*if(trigger.new.size()>1){
    for(PBS_AAAP_Offer_Deselect_Reject_Reasons__c pbsR:Trigger.new)
        {
            pbsR.adderror('Please have an administrator disable the validation trigger if you need to bulk load Deselect records.');
        }
    }
    else{
        PBS_AAAP_Offer_Deselect_Reject_Reasons__c FirstRecord = new PBS_AAAP_Offer_Deselect_Reject_Reasons__c();
        for(PBS_AAAP_Offer_Deselect_Reject_Reasons__c pbsR:Trigger.new)
            {
                FirstRecord=pbsR;
                
            }
                List<PBS_AAAP_Offer__c> offerList = new List<PBS_AAAP_Offer__c>();
                System.debug('******* trigger size::: '+Trigger.new.size());
                //for (PBS_AAAP_Offer_Deselect_Reject_Reasons__c d : Trigger.new) {
                    if(FirstRecord.PBS_AAAP_Action_Reason__c == 'Building Problems Found'){
                        PBS_AAAP_Offer__c offer = [Select id, property__c from PBS_AAAP_Offer__c where id = :FirstRecord.PBS_AAAP_Offer_Number__c];
                        if(offer.property__c != null){
                            PBS_AAAP_Property__c property= [Select id, PBS_AAAP_isBuildingProblem__c from PBS_AAAP_Property__c where id = :offer.property__c];
                            if(property.PBS_AAAP_isBuildingProblem__c != true){
                                System.debug('******* property record::: '+property);
                                property.PBS_AAAP_isBuildingProblem__c = true;
                                update property;
                                Case c = new Case();
                                c.Status = 'New';
                                c.Origin = 'Web';
                                c.Priority = 'Medium';
                                c.Type = 'Problem';
                                c.Reason = 'New Problem';
                                c.Subject = 'Building Problems Found';
                                c.Description = FirstRecord.PBS_AAAP_Action_Comments__c;
                                c.PBS_AAAP_Property__c = property.Id;
                                
                                insert c;
                                System.debug('******* case record::: '+c);
                                offerList = [Select id, PBS_AAAP_isBuildingProblem__c from PBS_AAAP_Offer__c where property__c = :property.Id];
                                for(PBS_AAAP_Offer__c ofr : offerList){
                                    ofr.PBS_AAAP_isBuildingProblem__c = 'Yes';
                                }
                            }
                        }
                    }
                //}
                update offerList;
       
    } */
}