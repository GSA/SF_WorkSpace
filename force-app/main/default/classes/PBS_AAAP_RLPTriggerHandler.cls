public with sharing class PBS_AAAP_RLPTriggerHandler {

    public static void processRLPs(List<PBS_AAAP_RLP__c> newRecs, List<PBS_AAAP_RLP__c> oldRecs, PBS_AAAP_TriggerHelper.Action tha) {
        List<PBS_AAAP_RLP__c> updateRLPList = null;
        List<ID> rlpID = new List<ID>();
        String replacedRLP = null;

        if (tha == PBS_AAAP_TriggerHelper.Action.BEFOREINSERT) {

            for (Integer i = 0, leni = newRecs.size(); i < leni; ++i) {
                
                if(newRecs[i].Is_Historical__c == TRUE){
                    newRecs[i].PBS_AAAP_STATUS__c = 'Posted/Active';
                } else {
                    newRecs[i].PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_DRAFT;
                }
                newRecs[i].PBS_AAAP_DISCOUNT_RATE__c = newRecs[i].PBS_AAAP_Discount_percent_Rate__c;  //Vaishali using new field to show old field 07/15/2016
                newRecs[i].PBS_AAAP_ESCALATION_RATE_PERCENT__c = newRecs[i].PBS_AAAP_ESCALATION_PRCNT_RATE__c;  //Vaishali using new field to show old field 07/15/2016

            }   // END OF LOOPING THROUGH ALL THE RLPS
        }   // END OF BEFOREINSERT ACTION

        if (tha == PBS_AAAP_TriggerHelper.Action.BEFOREUPDATE) {

            for (Integer i = 0, leni = newRecs.size(); i < leni; ++i) {

                if (newRecs[i].PBS_AAAP_STATUS__c != oldRecs[i].PBS_AAAP_STATUS__c) {
                    newRecs[i].PBS_AAAP_Status_Change_Date__c = Date.today();
                }
                if ((newRecs[i].PBS_AAAP_STATUS__c == oldRecs[i].PBS_AAAP_STATUS__c) && (oldRecs[i].PBS_AAAP_STATUS__c == PBS_AAAP_GlobalConstants.RLPSTATUS_DRAFT)) {
                    newRecs[i].PBS_AAAP_DISCOUNT_RATE__c = newRecs[i].PBS_AAAP_Discount_percent_Rate__c;  //Vaishali using new field to show old field 07/15/2016
                    newRecs[i].PBS_AAAP_ESCALATION_RATE_PERCENT__c = newRecs[i].PBS_AAAP_ESCALATION_PRCNT_RATE__c;  //Vaishali using new field to show old field 07/15/2016
                }
                if (newRecs[i].PBS_AAAP_STATUS__c != oldRecs[i].PBS_AAAP_STATUS__c && newRecs[i].PBS_AAAP_STATUS__c == PBS_AAAP_GlobalConstants.RLPSTATUS_REPLACED) {
                    /*if(newRecs[i].Replaced_RLP__c == null){
                        newRecs[i].addError('Replaced RLP is required to make RLP status to "Replaced"');
                    }
                    else{*/
                    newRecs[i].RLP_Replaced_By__c = UserInfo.getUserId();
                    //}
                }
                //Vaishali: Make sure posted date is available.
                if (newRecs[i].PBS_AAAP_STATUS__c != oldRecs[i].PBS_AAAP_STATUS__c && newRecs[i].PBS_AAAP_STATUS__c == PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE) {
                    newRecs[i].PBS_AAAP_Posted_Date__c = Date.today();
                    newRecs[i].PBS_AAAP_DISCOUNT_RATE__c = newRecs[i].PBS_AAAP_Discount_percent_Rate__c; //Vaishali using new field to show old field 07/15/2016
                    newRecs[i].PBS_AAAP_ESCALATION_RATE_PERCENT__c = newRecs[i].PBS_AAAP_ESCALATION_PRCNT_RATE__c;  //Vaishali using new field to show old field 07/15/2016
                }
                if ((newRecs[i].PBS_AAAP_STATUS__c == oldRecs[i].PBS_AAAP_STATUS__c) && (oldRecs[i].PBS_AAAP_STATUS__c == PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE)) {

                    if (newRecs[i].PBS_AAAP_Canceled_Date__c != null && newRecs[i].PBS_AAAP_Canceled_Date__c != oldRecs[i].PBS_AAAP_Canceled_Date__c &&
                            newRecs[i].PBS_AAAP_Canceled_Reason__c != oldRecs[i].PBS_AAAP_Canceled_Reason__c) {
                        newRecs[i].PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_CANCELED;
                    }
                    system.debug('****%%%%'+newRecs[i].No_of_times_cloned__c+'***'+oldRecs[i].No_of_times_cloned__c);
                    if(newRecs[i].No_of_times_cloned__c == oldRecs[i].No_of_times_cloned__c){
                        if (!(newRecs[i].PBS_AAAP_DEFAULT_MONTH_BEGIN__c != oldRecs[i].PBS_AAAP_DEFAULT_MONTH_BEGIN__c ||
                                newRecs[i].PBS_AAAP_DEFAULT_MONTH_END__c != oldRecs[i].PBS_AAAP_DEFAULT_MONTH_END__c ||
                                newRecs[i].PBS_AAAP_EXCEPTION_MONTH__c != oldRecs[i].PBS_AAAP_EXCEPTION_MONTH__c ||
                                newRecs[i].PBS_AAAP_EXCEPTION_MONTH_BEGIN__c != oldRecs[i].PBS_AAAP_EXCEPTION_MONTH_BEGIN__c ||
                                newRecs[i].PBS_AAAP_EXCEPTION_MONTH_END__c != oldRecs[i].PBS_AAAP_EXCEPTION_MONTH_END__c ||
                                newRecs[i].PBS_AAAP_STATUS__c != oldRecs[i].PBS_AAAP_STATUS__c ||
                                newRecs[i].PBS_AAAP_Canceled_Date__c != oldRecs[i].PBS_AAAP_Canceled_Date__c ||
                                newRecs[i].PBS_AAAP_Canceled_Reason__c != oldRecs[i].PBS_AAAP_Canceled_Reason__c ||
                                newRecs[i].Default_Start_Time_ET__c != oldRecs[i].Default_Start_Time_ET__c || //Syed start
                                newRecs[i].Default_Start_Time_AM_PM__c != oldRecs[i].Default_Start_Time_AM_PM__c || 
                                newRecs[i].Default_End_Time_ET__c != oldRecs[i].Default_End_Time_ET__c || 
                                newRecs[i].Default_End_Time_AM_PM__c != oldRecs[i].Default_End_Time_AM_PM__c   //Syed end
    
                        )) {
                            newRecs[i].addError('You can update only start and end fields once RLP is in Posted status');
                        }
                    }
                }

                if ((newRecs[i].PBS_AAAP_STATUS__c == PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE) && (newRecs[i].Replaced_RLP__c != null)) {

                    rlpID.add(newRecs[i].Replaced_RLP__c);
                    System.debug('***********newRecs[i].Replaced_RLP__c ::: ' + newRecs[i].Replaced_RLP__c);


                }

            }   // END OF LOOPING THROUGH ALL THE RLPS

            if (rlpID.size() > 0) {
                updateRLPList = [SELECT id, PBS_AAAP_STATUS__c FROM PBS_AAAP_RLP__c WHERE id IN :rlpID];
                System.debug('***********updateRLPList for Replaced_RLP__c ::: ' + updateRLPList);
                for (PBS_AAAP_RLP__c p : updateRLPList) {
                    if (p.PBS_AAAP_STATUS__c != PBS_AAAP_GlobalConstants.RLPSTATUS_REPLACED) {
                        p.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_REPLACED;
                    }
                }
                update updateRLPList;
            }
        }   // END OF BEFOREUPDATE ACTION


    }

    //Snehith - commented below code as a seperate test class method has been created for the same on 04/18/18
    //static testMethod void createRLPTest() {
    //    PBS_AAAP_RLP__c rlp1 = PBS_AAAP_UtilityTest.createRLP();
    //    insert rlp1;
    //    system.assert(rlp1.Id != null);

    //    rlp1.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
    //    update rlp1;

    //    rlp1.PBS_AAAP_MAX_TIUSED__c = 60.00;
    //    try {
    //        update rlp1;
    //    } catch (exception ex) {

    //        system.assertNotEquals('You can update only start and end fields once RLP is in Posted status', ex.getMessage());
    //    }

    //    rlp1.PBS_AAAP_Canceled_Date__c = Date.today() + 1;
    //    rlp1.PBS_AAAP_Canceled_Reason__c = 'Reason for cancel';
    //    update rlp1;
    //    System.assert(rlp1.PBS_AAAP_Canceled_Reason__c != null);


    //    PBS_AAAP_RLP__c rlp2 = PBS_AAAP_UtilityTest.createRLP();
    //    insert rlp2;

    //    rlp2.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_REPLACED;
    //    try {
    //        update rlp2;
    //    } catch (Exception ex) {

    //    }
    //    rlp2.Replaced_RLP__c = rlp1.Id;
    //    update rlp2;
    //    System.assert(rlp2.Replaced_RLP__c != null);

    //    PBS_AAAP_RLP__c rlp0 = PBS_AAAP_UtilityTest.createRLP();
    //    rlp0.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
    //    insert rlp0;
    //    system.assert(rlp0.Id != null);


    //    PBS_AAAP_RLP__c rlpRec = PBS_AAAP_UtilityTest.createRLP();
    //    rlpRec.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_DRAFT;

    //    insert rlpRec;
    //    rlpRec.Replaced_RLP__c = rlp0.Id;
    //    rlpRec.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE;
    //    //rlpRec.PBS_AAAP_STATUS__c = PBS_AAAP_GlobalConstants.RLPSTATUS_REPLACED;


    //    update rlpRec;

    //}

}