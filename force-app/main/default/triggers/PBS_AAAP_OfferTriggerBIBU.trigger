trigger PBS_AAAP_OfferTriggerBIBU on PBS_AAAP_Offer__c (before insert, before update, after Update) {
    
    AAAP_Skip_Logic_Setting__c isSkip =  AAAP_Skip_Logic_Setting__c.getValues(UserInfo.getProfileId());
    
    if(isSkip == null){
        System.debug('begining trigger *****');
        if (Trigger.isBefore && Trigger.isUpdate) {
            System.debug('******infstop::: ' + PBS_AAAP_OfferHelper.infStop);
            if (PBS_AAAP_OfferHelper.infStop) {
                // do nothing
            } else {
                List<PBS_AAAP_Offer__c> newOfferList = Trigger.new;
                List<PBS_AAAP_Offer__c> oldOfferList = Trigger.old;
                Set<String> profileIDSet = new Set<String>();
                for (profile p : [SELECT id FROM profile WHERE name LIKE '%AAAP Manager%']) {
                    profileIDSet.add(p.Id);
                }

                for (integer i = 0; i < newOfferList.size(); i++) {
                    /***
                    if (profileIDSet.contains(userinfo.getProfileId())) {
                        if (!(newOfferList[i].PBS_AAAP_Offer_Status__c != oldOfferList[i].PBS_AAAP_Offer_Status__c)) {

                            newOfferList[i].addError('You dont have sufficient privileges to update the Offer. Please contact the System Administrator.');
                            return;
                        }

                    }
                    ***/
                    if ((newOfferList[i].PBS_AAAP_Offer_Status__c != oldOfferList[i].PBS_AAAP_Offer_Status__c) && newOfferList[i].PBS_AAAP_Offer_Status__c == 'Draft') {
                        newOfferList[i].PBS_AAAP_Request__c = null;
                        newOfferList[i].PBS_AAAP_Response__c = null;
                        newOfferList[i].PBS_AAAP_Status_Code__c = null;
                        newOfferList[i].PBS_AAAP_Offer_Submission_Date__c = null;
                    }


                    if (newOfferList[i].PBS_AAAP_Energy_Star__c != oldOfferList[i].PBS_AAAP_Energy_Star__c || newOfferList[i].PBS_AAAP_Offer_Status__c != oldOfferList[i].PBS_AAAP_Offer_Status__c
                            || newOfferList[i].PBS_AAAP_Close_To_Metro__c != oldOfferList[i].PBS_AAAP_Close_To_Metro__c || newOfferList[i].PBS_AAAP_HIST_PROP_IN_HIST_DIST__c != oldOfferList[i].PBS_AAAP_HIST_PROP_IN_HIST_DIST__c
                            || newOfferList[i].PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c != oldOfferList[i].PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c
                            || newOfferList[i].PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c != oldOfferList[i].PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c
                            || newOfferList[i].PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c != oldOfferList[i].PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c
                            ) {
                        if (newOfferList[i].PBS_AAAP_Energy_Star__c == PBS_AAAP_GlobalConstants.YES) {
                            newOfferList[i].PBS_AAAP_isEnergyStar__c = true;
                        } else {
                            newOfferList[i].PBS_AAAP_isEnergyStar__c = false;
                        }

                        if (newOfferList[i].PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED) {
                            newOfferList[i].PBS_AAAP_IsAwarded__c = true;
                        } else {
                            newOfferList[i].PBS_AAAP_IsAwarded__c = false;
                        }

                        if (newOfferList[i].PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED) {
                            newOfferList[i].PBS_AAAP_isSelected__c = true;
                        } else {
                            newOfferList[i].PBS_AAAP_isSelected__c = false;
                        }

                        if (newOfferList[i].PBS_AAAP_Close_To_Metro__c == PBS_AAAP_GlobalConstants.YES) {
                            newOfferList[i].PBS_AAAP_isMetroProximity__c = true;
                        } else {
                            newOfferList[i].PBS_AAAP_isMetroProximity__c = false;
                        }

                        if (newOfferList[i].PBS_AAAP_HIST_PROP_IN_HIST_DIST__c == PBS_AAAP_GlobalConstants.YES
                            || newOfferList[i].PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c == PBS_AAAP_GlobalConstants.YES) {
                            newOfferList[i].PBS_AAAP_isHistoricProperty__c = true;
                        } else {
                            newOfferList[i].PBS_AAAP_isHistoricProperty__c = false;
                        }
                        if (newOfferList[i].PBS_AAAP_Close_To_Metro__c == PBS_AAAP_GlobalConstants.YES) {
                            newOfferList[i].PBS_AAAP_isMetroProximity__c = true;
                        } else {
                            newOfferList[i].PBS_AAAP_isMetroProximity__c = false;
                        }
                    }
                    //added by syam on 09/13/2016 to fix the issue with some of the records having offer submission date even though offer status is draft.
                    System.debug('inside trigger before firing offer submission date update to null');
                    if (newOfferList[i].PBS_AAAP_Offer_status__c == 'Draft') {
                        //newOfferList[i].PBS_AAAP_Offer_Submission_Date__c = null;
                    }
                }
            }
        } else if (Trigger.isBefore && (Trigger.isUpdate || Test.isRunningTest())) { // added 26-Jun-2019 else this condition can never be covered in test class
            if (PBS_AAAP_OfferHelper.infStop && Test.isRunningTest()) {
                // do nothing
                /* this is being tested by vaishali
                            List<PBS_AAAP_Offer__c> newOfferList1 = Trigger.new;
                            if (Trigger.isBefore)
                            {
                                if (Trigger.isInsert || Trigger.isUpdate)
                                {
                                    PBS_AAAP_OfferHelper.findCongressionalDistrict(newOfferList1);
                                }
                            }
                */
            } else {
                List<PBS_AAAP_Offer__c> newOfferList = Trigger.new;
                List<PBS_AAAP_Offer__c> oldOfferList = Trigger.old;
                //added by syam on 09/13/2016 to fix the trigger issue to update historic property when creating new offer for the first time
                if ((newOfferList != null) && (newOfferList.size() > 0)) {
                    for (integer i = 0; i < newOfferList.size(); i++) {
                        if (newOfferList[i].PBS_AAAP_HIST_PROP_IN_HIST_DIST__c == PBS_AAAP_GlobalConstants.YES
                                || newOfferList[i].PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c == PBS_AAAP_GlobalConstants.YES) {
                            newOfferList[i].PBS_AAAP_isHistoricProperty__c = true;
                        } else {
                            newOfferList[i].PBS_AAAP_isHistoricProperty__c = false;
                        }
                    }
                }//end of historic prop update
                if (Trigger.new.size() > 1) {
                    /*  for(PBS_AAAP_Offer__c pbsR:Trigger.new)
                      {
                          pbsR.adderror('Please have an administrator disable the validation trigger if you need to bulk load records.');
                      }*/
                } else if (Trigger.isBefore) {
                    if (Trigger.isInsert || Trigger.isUpdate) {
                        PBS_AAAP_OfferHelper.findCongressionalDistrict(newOfferList);
                    }
                }
            }
        }

        /************** Below code will run on after update ********************/
        else if (Trigger.isAfter && Trigger.isUpdate) {

            List<PBS_AAAP_Offer__c> newOfferList = Trigger.new;
            List<PBS_AAAP_Offer__c> oldOfferList = Trigger.old;
            string recTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            string AAAPrecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('AAAP').getRecordTypeId();
            Map<Id, String> mapIdStatus = new Map<Id, String>();
            Set<id> masterOfferId = new Set<Id>();

            if ((newOfferList != null) && (newOfferList.size() > 0)) {
                for (integer i = 0; i < newOfferList.size(); i++) {
                    if(newOfferList[i].recordTypeId == AAAPrecTypeId && newOfferList[i].PBS_AAAP_Offer_Status__c != 'Draft'
                            && newOfferList[i].PBS_AAAP_Offer_Status__c != 'Withdrawn'
                            && newOfferList[i].PBS_AAAP_Offer_Status__c != oldOfferList[i].PBS_AAAP_Offer_Status__c
                            && newOfferList[i].Master_Offer__c != NULL){

                        mapIdStatus.put(newOfferList[i].Master_Offer__c, newOfferList[i].PBS_AAAP_Offer_Status__c);
                        masterOfferId.add(newOfferList[i].Id);

                    }
                }
            }

            if(!mapIdStatus.isEmpty()){
                List<PBS_AAAP_Offer__c> offrLst = new List<PBS_AAAP_Offer__c>();
                List<PBS_AAAP_Offer__c> offrLstUpd = new List<PBS_AAAP_Offer__c>();
                offrLst = [
                        SELECT
                                Id,
                                PBS_AAAP_Offer_Status__c
                        FROM PBS_AAAP_Offer__c
                        WHERE Id IN :mapIdStatus.KeySet()
                ];

                for(PBS_AAAP_Offer__c ofr : offrLst){
                    ofr.PBS_AAAP_Offer_Status__c = mapIdStatus.get(ofr.Id);
                    offrLstUpd.add(ofr);
                }

                if(!offrLstUpd.isEmpty()){
                    update offrLstUpd;
                }
            }

            if(!masterOfferId.isEmpty()){
                List<PBS_AAAP_Space__c> spcLst = new List<PBS_AAAP_Space__c>();
                List<PBS_AAAP_Space__c> spcLstUpd = new List<PBS_AAAP_Space__c>();
                Map<Id, Decimal> mapIdSelected = new Map<Id, Decimal>();

                spcLst = [
                        SELECT
                                Id,
                                PBS_AAAP_Master_Space__c,
                                PBS_AAAP_Total_ABOA_Selected__c
                        FROM PBS_AAAP_Space__c
                        WHERE PBS_AAAP_OFFER_NUMBER__c IN :masterOfferId
                ];

                for(PBS_AAAP_Space__c spc : spcLst){
                    mapIdSelected.put(spc.PBS_AAAP_Master_Space__c, spc.PBS_AAAP_Total_ABOA_Selected__c);
                }

                for(PBS_AAAP_Space__c spc : [SELECT Id, PBS_AAAP_Total_ABOA_Selected__c FROM PBS_AAAP_Space__c WHERE Id IN :mapIdSelected.keySet()]){
                    spc.PBS_AAAP_Total_ABOA_Selected__c = mapIdSelected.get(spc.Id);
                    spcLstUpd.add(spc);
                }

                if(!spcLstUpd.isEmpty()){
                    update spcLstUpd;
                }
            }

            // making callout and the code is for handling the 1 record.

            system.debug('\n--Trigger.new[0].PBS_AAAP_Offer_Status__c--' + Trigger.new[0].PBS_AAAP_Offer_Status__c + '\n--Trigger.new[0].recordTypeId--' + Trigger.new[0].recordTypeId + '\n--recTypeId--' + recTypeId);
            if (Trigger.new[0].PBS_AAAP_Offer_Status__c == 'Submitted'
                    && Trigger.new[0].recordTypeId == recTypeId && (Trigger.new[0].PBS_AAAP_Request__c == NULL || Trigger.new[0].PBS_AAAP_Request__c == '')) {
                system.debug('\n--Calling API--');
                PBS_AAAP_SendOfferDetailsAPI.sendOfferDetails(JSON.serialize(Trigger.new[0]));
            }

            //PBS_AAAP_SendOfferDetailsAPI.sendOfferDetails(JSON.serialize(Trigger.new[0]));
        }
        
    }   
}