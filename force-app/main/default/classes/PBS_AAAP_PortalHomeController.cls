public with sharing class PBS_AAAP_PortalHomeController {

    public User usrinfo { get; set; }
    public List<PBS_AAAP_Offer__c> offersList { get; set; }    // List used to store the list of offers for the logged in User
    public List<PBS_AAAP_Offer__c> lopList { get; set; }
    public boolean isEdit = false;
    public boolean isLOP { get; set; }
    //public Boolean canViewOnly {get;set;}    
    public String ofrID { get; set; }    // Stores the offerId while redirecting it to an Offer page.
    public boolean showWarningPopup{get;set;}

    public string selectRLP { get; set; } // Used for RLP picklist to show on the offers table

    public string message { get; set; }
    public boolean pmError { get; set; }

    public String pageURLForRedirection{get;set;}    // j.rogers 1/26/2023  Communities upgrade

    //public List<PBS_AAAP_Offer_Attachments__c> attachmentsList  {get;set;}
    //public PBS_AAAP_Offer_Attachments__c offerattachment        {get;set;}
    //public List<OfferWrapper> offerWrapperList {get; set;}

    public void showPopup() {
        //showWarningPopup = ApexPages.currentPage().getParameters().get('sw');
    }

    public PBS_AAAP_PortalHomeController() {
        string requestType = ApexPages.currentPage().getParameters().get('Type');
        system.debug('========THIS will return Current GMT time=====' + datetime.now());
        system.debug('=======This will return Current New_York time=====' + datetime.now().format('MM/dd/yyyy HH:mm:ss', 'America/New_York'));
        if (requestType == 'LOP') {
            isLOP = true;
        } else {
            isLOP = false;
        }

        Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
        string tempval =  ApexPages.currentPage().getParameters().get('t');
       showWarningPopup = tempval != null ? true:false;
        
    
        //RITM0031831: Capture RLP Status in order to determine the display of action buttons        
        offersList = [
                SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Building_Name__c,
                        p.PBS_AAAP_Offer_Status__c, p.PBS_AAAP_Default_Start__c, p.PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                        PBS_AAAP_Total_Withdraw_Space_Available__c, PBS_AAAP_Total_Withdraw_Space__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c
                FROM PBS_AAAP_Offer__c p
                WHERE p.OwnerId = :UserInfo.getUserId()
                AND p.PBS_AAAP_Is_Offer_Valid__c = TRUE
                AND p.Master_Offer__c = NULL
                AND p.recordTypeId != :RSAPRecTypeId
                ORDER BY p.LastModifiedDate DESC
        ];
        lopList = [
                SELECT p.id,p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Project_Number__c, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c,
                        p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Building_Name__c, p.OwnerId, p.PBS_AAAP_Offer_Status__c, //p.Project_Offer_Due_Date__c,
                        p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c, p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c
                FROM PBS_AAAP_Offer__c p
                WHERE p.OwnerId = :UserInfo.getUserId()
                AND p.recordTypeId = :RSAPRecTypeId
                ORDER BY p.LastModifiedDate DESC
        ];
        System.debug('lopList :::::::::::::  ' + lopList);
        /* for(PBS_AAAP_Offer__c o:offersList)
         {
        // offerWrapperList.add(new OfferWrapper(o));
         }*/


        usrinfo = [
                SELECT id, email, Name, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                        street, city, country, CompanyName, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email, contact.PBS_AAAP_Website__c,
                        PBS_AAAP_StatesOfInterest__c, PBS_AAAP_PIN__c
                FROM User
                WHERE id = :UserInfo.getUserId()
        ];

        //pmError = FALSE;

    }


    /* public List<OfferWrapper> getresults()
     {
         return offerWrapperList;
     }


     public class OfferWrapper{
         public String Total_Withdraw_Space_Available{get; set;}
         public PBS_AAAP_Offer__c offer{get; set;}
         public OfferWrapper(PBS_AAAP_Offer__c o) {
         offer= o;
         Total_Withdraw_Space_Available=String.valueOf(o.PBS_AAAP_Total_Withdraw_Space_Available__c);
         }
     }*/
     
     public static string QueryStr(String ObjectName, String whereName, String recId, List<Id> Ids){
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
           if(s != 'lastvieweddate'
               && s != 'lastreferenceddate')
               query += ' ' + s + ',';
        }
    
        // Manually add related object's fields that are needed.
        //query += 'Account.Name,'; // modify as needed
        
        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
    
        // Add FROM statement
        query += ' FROM ' + objectName;
    
        // Add on a WHERE/ORDER/LIMIT statement as needed
        //query += ' WHERE Id =\'' + recId + '\''; // modify as needed
        if(recId != ''){
            query += ' WHERE ' + whereName + ' =\'' + recId + '\'';
        } else {
            String str = '(';
            for(Id i : Ids){
                str += '\''+i+'\'';
            }
            str += ')';
            str = str.replace('\'\'', '\',\'');
      
      // codition (19-feb-2019) i.e. if st is empty or () do not include in query
      if(str != '()') query += ' WHERE ' + whereName + ' IN' + str + '';
      
        
        }
        system.debug('*****'+query);
        /**
        try {
                agReq = database.query(query);
        } catch (QueryException e){
                //perform exception handling
        }
        **/
        return query;
    }

    // Action offer edit button logic. Redirect to an Offer page to show the offer details
    public PageReference actionOfferEdit() {
        PageReference p = null;
        String offerId = ApexPages.currentPage().getParameters().get('editofferIdParam');
        System.debug('*******actionOfferEdit: OfferID******* ::: ' + offerId);

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();

        try {
            PBS_AAAP_Offer__c newofferDraft;

            PBS_AAAP_Offer__c offer = [
                    SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_Building_Name__c, p.PBS_AAAP_Offer_Status__c,
                            p.PBS_AAAP_Default_Start__c, p.PBS_AAAP_Default_End__c, p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_RLP_Number__c,
                            p.PBS_AAAP_Offer_Submission_Date__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :offerId
            ];
            PBS_AAAP_RLP__c rlp = [
                    SELECT p.PBS_AAAP_EXCEPTION_MONTH__c, p.PBS_AAAP_EXCEPTION_MONTH_END__c, p.PBS_AAAP_EXCEPTION_MONTH_BEGIN__c,
                            p.PBS_AAAP_DEFAULT_MONTH_END__c, p.PBS_AAAP_DEFAULT_MONTH_BEGIN__c, p.Name, p.Id
                    FROM PBS_AAAP_RLP__c p
                    WHERE p.Id = :offer.PBS_AAAP_RLP_Number__c
            ];
            System.debug('::::::::::::: rlp end date ::: ' + rlp.PBS_AAAP_DEFAULT_MONTH_BEGIN__c);
            System.debug('::::::::::::: rlp end date ::: ' + rlp.PBS_AAAP_DEFAULT_MONTH_END__c);
            Date dt = Date.today();

            if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT ||
                    offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION
                    ) {
                p = new PageReference('/AAAP/OfferBuilding');
                //p = Page.PBS_AAAP_OfferBuilding;
                p.getParameters().put('offerId', offer.Id);
                p.getParameters().put('isNew', 'false');
                //AAAP_OfferState.offerID = offerId;
                //System.debug('::::::::::::: Global Value for offerid ::: '+ AAAP_OfferState.offerID);
                p.setRedirect(true);

            } else if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED || offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED) {  //OOLOP-1100
                System.debug('3. The offer Status :::::::::::::  ' + offer.PBS_AAAP_Offer_Status__c);
                System.debug('offer Submission Date :::::::::::::  ' + offer.PBS_AAAP_Offer_Submission_Date__c);

                // Edit logic for current open period and next open period
                Date ofrSubmissionDate = offer.PBS_AAAP_Offer_Submission_Date__c;
                Date dtoday = Date.today();

                //integer day1 = dtoday.day();
                integer month1 = ofrSubmissionDate.month();
                integer begindt = integer.valueOf(rlp.PBS_AAAP_DEFAULT_MONTH_BEGIN__c);
                integer enddt = integer.valueOf(rlp.PBS_AAAP_DEFAULT_MONTH_END__c);
                //integer todayMonth = dtoday.month();
                System.debug('day1 :::::::::::::  ' + dtoday.day());
                System.debug('month1 :::::::::::::  ' + month1);
                System.debug('begindt :::::::::::::  ' + begindt);
                System.debug('enddt :::::::::::::  ' + enddt);
                System.debug('today month :::::::::::::  ' + dtoday.month());
                if (dtoday.day() >= begindt && dtoday.day() <= enddt && month1 == dtoday.month()) {
                    p = new PageReference('/AAAP/OfferBuilding');
                    //p = Page.PBS_AAAP_OfferBuilding;
                    p.getParameters().put('offerId', offer.Id);
                    p.getParameters().put('isNew', 'false');
                    p.setRedirect(true);
                }// edit logic ends
                else {
                    //CHECK IF A PENDING MODIFICATION OFFER ALREADY EXISTS
                    List<PBS_AAAP_Offer__c> pmOffer = [SELECT Id FROM PBS_AAAP_Offer__c WHERE PBS_AAAP_Parent_Offer__c = :offerId AND PBS_AAAP_Offer_Status__c = 'Pending Modification' LIMIT 1];
                    if(pmOffer.isEmpty()) {

                        newofferDraft = offerClone(offer.id, 'PM');
                        newofferDraft.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
                        // need to have lookup to current offer, when this offer gets submitted the original offer status should get change.
                        newofferDraft.PBS_AAAP_Parent_Offer__c = offer.Id;
                        //newofferDraft.PBS_AAAP_Is_Offer_Valid__c = false;
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
                        
                        /*************************************/
                        List<PBS_AAAP_Offer_Attachments__c> newOfferAtt = new List<PBS_AAAP_Offer_Attachments__c>();
                        List<Id> oldOffAttIds = new List<Id>();
                        for(PBS_AAAP_Offer_Attachments__c offAtt : [SELECT Id, PBS_AAAP_Offer__c, PBS_AAAP_Attachment_Type__c, Cloned_From__c,
                                                                            PBS_AAAP_Date_sent_to_GREX__c, PBS_AAAP_Legacy_Offer_Att_ID__c, 
                                                                            Offer_Attachments_Name__c, PBS_AAAP_Sent_to_GREX__c                                                                             
                                                                            FROM PBS_AAAP_Offer_Attachments__c
                                                                            WHERE PBS_AAAP_Offer__c = :offer.id]){
                            PBS_AAAP_Offer_Attachments__c newAtt = offAtt.clone(false, true);
                            newAtt.PBS_AAAP_Offer__c = newofferDraft.id;
                            newAtt.Cloned_From__c = offAtt.Id;
                            newAtt.PBS_AAAP_Legacy_Offer_Att_ID__c = null;  
                            newOfferAtt.add(newAtt);
                            
                            oldOffAttIds.add(offAtt.Id);
                                                                            
                        }
                        if(!newOfferAtt.isEmpty()){
                            insert newOfferAtt;
                        }
                        
                        Map<Id, Id> mapOldIdNewId = new Map<Id, Id>();
                        for(PBS_AAAP_Offer_Attachments__c offAtt : newOfferAtt){
                            mapOldIdNewId.put(offAtt.Cloned_From__c, offAtt.Id);
                        }                 

                        List<PBS_AAAP_Space__c> newSpaceitems = new List<PBS_AAAP_Space__c>();
                        List<PBS_AAAP_Rate__c> newRatesList = new List<PBS_AAAP_Rate__c>();
                        Map<Id, Id> spaceMap = new Map<Id, Id>(); //(oldspaceId,newSpaceId)
                        Map<string, PBS_AAAP_Space__c> spaceMapDetail = new Map<string, PBS_AAAP_Space__c>();
                        //Map<Id,List<PBS_AAAP_Rate__c>> ratesMap = new Map<Id,List<PBS_AAAP_Rate__c>>();// (oldSpaceId,rates)

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
                            p = new PageReference('/AAAP/OfferBuilding');
                            //p = Page.PBS_AAAP_OfferBuilding;
                            p.getParameters().put('offerId', newofferDraft.Id);
                            p.getParameters().put('isNew', 'true');
                            p.getParameters().put('action', 'modify');
                            p.setRedirect(true);
                        }
                    } else {
                        pmError = TRUE;
                        return null;
                    }
                }

            } /** as same status is added in above statement else if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED) {

                System.debug('3. The offer Status :::::::::::::  ' + offer.PBS_AAAP_Offer_Status__c);

                newofferDraft = offerClone(offer.id, 'edit');
                newofferDraft.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION;
                // need to have lookup to current offer, when this offer gets submitted the original offer status should get change.
                newofferDraft.PBS_AAAP_Parent_Offer__c = offer.Id;
                //newofferDraft.PBS_AAAP_Is_Offer_Valid__c = false;
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
                        newspace.PBS_AAAP_ClonedFromSpace__c = pi.Id;
                        newSpace.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                        System.debug('5. Total ABOA Available :::::::::::::  ' + newSpace.PBS_AAAP_Total_ABOA_Available__c);
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

                if (newofferDraft.Id != null) {
                    p = new PageReference('/AAAP/OfferBuilding');
                    //p = Page.PBS_AAAP_OfferBuilding;
                    p.getParameters().put('offerId', newofferDraft.Id);
                    p.getParameters().put('isNew', 'true');
                    p.getParameters().put('action', 'modify');
                    p.setRedirect(true);
                }

            }
            **/
            //added by syam 02/05/2016 if the offer status is withdrawn make current offer invalid and create draft offer
            else if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED ||
                    offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) {

                System.debug('3. The offer Status :::::::::::::  ' + offer.PBS_AAAP_Offer_Status__c);

                newofferDraft = offerClone(offer.id, 'edit');
                newofferDraft.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                // need to have lookup to current offer, when this offer gets submitted the original offer status should get change.
                newofferDraft.PBS_AAAP_Parent_Offer__c = offer.Id;
                //newofferDraft.PBS_AAAP_Is_Offer_Valid__c = false;
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
                        System.debug('===========> pi.PBS_AAAP_Total_Actual_Space_Available__c ::: ' + pi.PBS_AAAP_Total_Actual_Space_Available__c);
                        System.debug('===========> pi.PBS_AAAP_SF_OFFERED__c ::: ' + pi.PBS_AAAP_SF_OFFERED__c);
                        System.debug('===========> pi.PBS_AAAP_Total_ABOA_Selected__c ::: ' + pi.PBS_AAAP_Total_ABOA_Selected__c);
                        System.debug('===========> pi.PBS_AAAP_Total_ABOA_Edited__c ::: ' + pi.PBS_AAAP_Total_ABOA_Edited__c);
                        System.debug('===========> pi.PBS_AAAP_Total_ABOA_Withdrawn__c ::: ' + pi.PBS_AAAP_Total_ABOA_Withdrawn__c);
                        System.debug('===========> pi.PBS_AAAP_Total_ABOA_Awarded__c ::: ' + pi.PBS_AAAP_Total_ABOA_Awarded__c);
                        if (pi.PBS_AAAP_Total_Actual_Space_Available__c > 0) { // Space has to be copied only when it has actual remaining space available
                            PBS_AAAP_Space__c newSpace = pi.clone(false, true, false, false);
                            newSpace.PBS_AAAP_OFFER_NUMBER__c = newofferDraft.id;
                            newspace.PBS_AAAP_SF_OFFERED__c = pi.PBS_AAAP_Total_Actual_Space_Available__c;
                            newSpace.PBS_AAAP_Total_ABOA_Available__c = pi.PBS_AAAP_Total_Actual_Space_Available__c;
                            newSpace.PBS_AAAP_Total_ABOA_Awarded__c = 0.00; // making total awarded space to null for new copy
                            newSpace.PBS_AAAP_Total_ABOA_Selected__c = 0.00; // making total selected space to null for new copy
                            newSpace.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                            System.debug('5. Total ABOA Available :::::::::::::  ' + newSpace.PBS_AAAP_Total_ABOA_Available__c);
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
                    //message = 'A new copy of the offer is got created successfully for Building name : '+ copyoffer.PBS_AAAP_Building_Name__c+' and with status "'+;
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
                            SELECT Id, Name, PBS_AAAP_Attachment_Type__c/*, (SELECT Id, Name,Description, ParentId, createdDate FROM Attachments)*/
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
                        //Attachment attTemp = new Attachment();
                        //copy the actual attachment file with body
                        //attTemp = [SELECT Name, Description, bodylength, body, contenttype FROM Attachment WHERE parentid = :attach.Id];
                        //System.debug('New attachment Id is ****' + newAttach.Id + ' attachment Id is ***' + attTemp.Id);
                        
                        /*
                        Attachment att = new Attachment();
                        att.Name = attTemp.Name;
                        att.Body = attTemp.Body;
                        att.Description = attTemp.Description;
                        att.ContentType = attTemp.ContentType;
                        att.ParentId = newAttach.id;
                        insert att;
                        */
                    }
                    if(newAttachmentsList.size() > 0){
                        //insert newAttachmentsList;
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
                            //Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ContVerFile.Id].ContentDocumentId;
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
                    p = new PageReference('/AAAP/OfferBuilding');
                    //p = Page.PBS_AAAP_OfferBuilding;
                    p.getParameters().put('offerId', newofferDraft.Id);
                    p.getParameters().put('isNew', 'true');
                    //added by syam on 06/13/2016 because for withdrawn offer is edited should not display any message on the offer building page on top
                    if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) {
                        p.getParameters().put('action', 'withdrawn');
                    } else {
                        p.getParameters().put('action', 'modify');
                    }
                    p.setRedirect(true);
                }
            }
            
            // Communities Upgrade   return p;
            

        } catch (Exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }

        
        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuilding', Label.LOP_Community_Base_URL+'AAAP-OfferBuilding');
        system.debug('pageURLForRedirection ===> '+ JSON.serializePretty(pageURLForRedirection));
        return null;

    }

    // Action offer copy button logic
    public PageReference actionOfferCopy() {

        String offerId = ApexPages.currentPage().getParameters().get('copyofferIdParam');
        //System.debug('*******OfferID******* ::: '+ offerId);

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();

        try {
            PBS_AAAP_Offer__c copyoffer = new PBS_AAAP_Offer__c();
            if (offerId != null) {
                copyoffer = offerClone(offerId, 'copy');
                copyoffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                copyoffer.PBS_AAAP_Offer_Submission_Date__c = null;
                copyoffer.PBS_AAAP_LEGACY_OFFER_NUMBER__c = null;
                copyoffer.PBS_AAAP_Street_Address__c = null;  // this line blanks the street which forces the copied offer to validate address button hide function
                insert copyoffer;

                List<PBS_AAAP_Other_Costs__c> newOtherCosts = new List<PBS_AAAP_Other_Costs__c>();
                for (PBS_AAAP_Other_Costs__c oc : [
                        SELECT p.PBS_AAAP_SHORT_DESC__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_COST__c, p.PBS_AAAP_COST_TYPE__c,
                                p.PBS_AAAP_COST_REMOVAL__c, p.Name, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                        FROM PBS_AAAP_Other_Costs__c p
                        WHERE p.PBS_AAAP_OFFER_NUMBER__c = :offerId
                ]) {
                    PBS_AAAP_Other_Costs__c newOCost = oc.clone(false, true);
                    newOCost.PBS_AAAP_OFFER_NUMBER__c = copyoffer.id;
                    newOCost.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                    newOtherCosts.add(newOCost);
                }
                insert newOtherCosts;

                //added by syam 02/17 to copy the attachments also while copy offer functionality 
                List<PBS_AAAP_Offer_Attachments__c> newAttachmentsList = new List<PBS_AAAP_Offer_Attachments__c>();
                System.debug('offer attachments cloning !!!' + offerId + '   new offer Id ' + copyoffer.id);
                /*
                for (PBS_AAAP_Offer_Attachments__c attach : [
                        SELECT Id, Name, PBS_AAAP_Attachment_Type__c, (SELECT Id, Name,Description, ParentId, createdDate FROM Attachments)
                        FROM PBS_AAAP_Offer_Attachments__c p
                        //Stop copying of Form 1217 && Form 1364
                        WHERE p.PBS_AAAP_Offer__c = :offerId AND PBS_AAAP_Attachment_Type__c NOT IN ('Form 1364 AAAP','Offeror Form 1217- Lessor\'s Annual Cost Statement','Lessors Annual Cost Statement (Form 1217)','Lessors Annual Cost Statement (Form 1217 attachment)','Offeror GSA Form 1364')

                ]) {
                    PBS_AAAP_Offer_Attachments__c newAttach = attach.clone(false, true);
                    System.debug('Old attachment Id is ****' + attach.Id);
                    newAttach.PBS_AAAP_Offer__c = copyoffer.id;
                    insert newAttach;
                    Attachment attTemp = new Attachment();
                    //copy the actual attachment file with body
                    attTemp = [SELECT Name, Description, bodylength, body, contenttype FROM Attachment WHERE parentid = :attach.Id];
                    System.debug('New attachment Id is ****' + newAttach.Id + ' attachment Id is ***' + attTemp.Id);
                    Attachment att = new Attachment();
                    att.Name = attTemp.Name;
                    att.Body = attTemp.Body;
                    att.Description = attTemp.Description;
                    att.ContentType = attTemp.ContentType;
                    att.ParentId = newAttach.id;
                    insert att;
                }
*/
                List<PBS_AAAP_Offer_Attachments__c> oldAttachmentsList = [
                        SELECT Id, Name, PBS_AAAP_Attachment_Type__c, (SELECT Id, Name,Description, ParentId, createdDate FROM Attachments)
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
                        newAttach.Id = null; 
                        newAttach.PBS_AAAP_Offer__c = copyoffer.id;
                        insert newAttach;
                        olddAttIdWithNewAttIdMap.put(newAttach.Id, attach.Id);
                        newAttachmentsList.add(newAttach);
                        //Attachment attTemp = new Attachment();
                        //copy the actual attachment file with body
                        //attTemp = [SELECT Name, Description, bodylength, body, contenttype FROM Attachment WHERE parentid = :attach.Id];
                        //System.debug('New attachment Id is ****' + newAttach.Id + ' attachment Id is ***' + attTemp.Id);
                        
                        /*
                        Attachment att = new Attachment();
                        att.Name = attTemp.Name;
                        att.Body = attTemp.Body;
                        att.Description = attTemp.Description;
                        att.ContentType = attTemp.ContentType;
                        att.ParentId = newAttach.id;
                        insert att;
                        */
                    }
                    if(newAttachmentsList.size() > 0){
                        //insert newAttachmentsList;
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
                            //Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ContVerFile.Id].ContentDocumentId;
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

                /* List<PBS_AAAP_Space__c> newSpaceitems = new List<PBS_AAAP_Space__c>();


                 for (PBS_AAAP_Space__c pi : [Select p.Id, p.PBS_AAAP_Total_ABOA_Withdrawn__c, p.PBS_AAAP_Total_ABOA_Selected__c, p.PBS_AAAP_Total_ABOA_Awarded__c,
                                                     p.PBS_AAAP_Total_ABOA_Available__c, p.PBS_AAAP_TOT_EXP_ABOA__c, p.PBS_AAAP_TOTAL_MARKUP__c, p.PBS_AAAP_SUITE_INDICATOR__c,
                                                     p.PBS_AAAP_SF_OFFERED__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, p.PBS_AAAP_Max_Contiguous_Space__c,
                                                     p.PBS_AAAP_MIN_OFFERABLE_SPACE__c, p.PBS_AAAP_MAX_OFFERABLE_SPACE__c, p.PBS_AAAP_MANAGEMENT_COORD_FEES__c,
                                                     p.PBS_AAAP_LOCATION_OF_FLOORS__c, p.PBS_AAAP_LEGACY_OFFER_NUMBER__c, p.PBS_AAAP_LEGACY_IDENTIFIER_ID__c,
                                                     p.PBS_AAAP_IDENTIFIER_TYPE__c, p.PBS_AAAP_IDENTIFIER_TO__c, p.PBS_AAAP_IDENTIFIER_ID__c, p.PBS_AAAP_IDENTIFIER_FROM__c,
                                                     p.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c, p.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, p.PBS_AAAP_GC_CONDITIONS__c, p.PBS_AAAP_FLOOR_INDICATOR__c,
                                                     p.PBS_AAAP_DATE_SPACE_AVAILABILITY__c, p.PBS_AAAP_BASE_OPERATING_COSTS__c, p.PBS_AAAP_ARCH_ENG_FEES__c, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c,
                                                     p.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, p.Name, PBS_AAAP_Total_Actual_Space_Available__c, PBS_AAAP_ClonedFromSpace__c
                                                From PBS_AAAP_Space__c p
                                               where PBS_AAAP_OFFER_NUMBER__c = :offerId]) {

                     PBS_AAAP_Space__c newSpace = pi.clone(false,true);
                     newSpace.PBS_AAAP_OFFER_NUMBER__c = copyoffer.Id;
                     newspace.PBS_AAAP_ClonedFromSpace__c = pi.Id;
                     newSpace.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                     newSpaceitems.add(newSpace);

                 }
                     insert newSpaceitems; */

            }


            //PageReference p = Page.PBS_AAAP_OfferBuilding;
            PageReference p = new PageReference('/AAAP/OfferBuilding');
            p.getParameters().put('offerId', copyoffer.Id);
            p.getParameters().put('isNew', 'true');
            p.getParameters().put('action', 'copy');
            // J. Rogers - Commmunities Upgrade
           // p.setRedirect(true);
            //return p;

            
            p.setRedirect(false);
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuilding', Label.LOP_Community_Base_URL+'AAAP-OfferBuilding');
           
            return null;
        } catch (Exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
    }

    // Redirect to an offer page to create a new offer
    public PageReference createNewOffer() {
        /* J. Rogers - Communities Update
        PageReference p = new PageReference('/AAAP/OfferBuilding');
        //PageReference p = Page.PBS_AAAP_OfferBuilding;
        p.setRedirect(true);
        return p;
        */
        

        PageReference p = new PageReference('/AAAP/OfferBuilding');
        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuilding', Label.LOP_Community_Base_URL+'AAAP-OfferBuilding');
        system.debug('pageURLForRedirection ===> '+ JSON.serializePretty(pageURLForRedirection));
        return null;
    }

    //added for lop offer creation
    // // Redirect to an offer page to create a new offer
    public PageReference createLopOffer() {

        /* J. Rogers - Communities Upgrade
            PageReference p = new PageReference('/RSAP/OfferLanding');
            //PageReference p = Page.PBS_LOP_OfferLanding;
            p.setRedirect(true);
        return p;
        */

        PageReference p = new PageReference('/RSAP/OfferLanding');
        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/OfferLanding', Label.LOP_Community_Base_URL+'RSAP-OfferLanding');
        system.debug('pageURLForRedirection ===> '+ JSON.serializePretty(pageURLForRedirection));
        return null;

    }

    public PageReference changePassword() {
        return Page.ChangePassword;
    }

    // Action offer withdrawn button logic
    public PageReference updateToWithdrawnStatus() {
        String offerId = ApexPages.currentPage().getParameters().get('updateofferIdParam');
        System.debug('1. The selected ID :::::::::::::  ' + offerId);

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        PBS_AAAP_Offer__c offerWithdrawn;
        try {
            PBS_AAAP_Offer__c offer = [
                    SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_Building_Name__c, PBS_AAAP_Offer_Status__c,
                            PBS_AAAP_Default_Start__c, PBS_AAAP_Default_End__c, PBS_AAAP_Total_Withdraw_Space_Available__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :offerId
            ];
            System.debug('2. The offer info :::::::::::::  ' + offer);
            if (offer.PBS_AAAP_Offer_Status__c != PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED
                    && offer.PBS_AAAP_Offer_Status__c != PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED
                    && offer.PBS_AAAP_Offer_Status__c != PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED) {
                offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFER_WITHDRAWN;
                update offer;
                message = 'Your offer with building name: "' + offer.PBS_AAAP_Building_Name__c + '" has been withdrawn successfully';
            } else if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED) {
                System.debug('3. The offer Status :::::::::::::  ' + offer.PBS_AAAP_Offer_Status__c);

                offerWithdrawn = offerClone(offer.id, 'withdraw');
                offerWithdrawn.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
                offerWithdrawn.PBS_AAAP_LEGACY_OFFER_NUMBER__c = null;
                insert offerWithdrawn;
                System.debug('4. The offer Inserted :::::::::::::  ' + offerWithdrawn.Id + '   with Status:::  ' + offerWithdrawn.PBS_AAAP_Offer_Status__c);

                List<PBS_AAAP_Other_Costs__c> newOtherCosts = new List<PBS_AAAP_Other_Costs__c>();
                for (PBS_AAAP_Other_Costs__c oc : [
                        SELECT p.PBS_AAAP_SHORT_DESC__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_COST__c, p.PBS_AAAP_COST_TYPE__c,
                                p.PBS_AAAP_COST_REMOVAL__c, p.Name, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                        FROM PBS_AAAP_Other_Costs__c p
                        WHERE p.PBS_AAAP_OFFER_NUMBER__c = :offer.id
                ]) {
                    PBS_AAAP_Other_Costs__c newOCost = oc.clone(false, true);
                    newOCost.PBS_AAAP_OFFER_NUMBER__c = offerWithdrawn.id;
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
                                p.PBS_AAAP_LOCATION_OF_FLOORS__c, p.PBS_AAAP_LEGACY_OFFER_NUMBER__c, p.PBS_AAAP_LEGACY_IDENTIFIER_ID__c, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c,
                                p.PBS_AAAP_IDENTIFIER_TYPE__c, p.PBS_AAAP_IDENTIFIER_TO__c, p.PBS_AAAP_IDENTIFIER_ID__c, p.PBS_AAAP_IDENTIFIER_FROM__c,
                                p.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c, p.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, p.PBS_AAAP_GC_CONDITIONS__c, p.PBS_AAAP_FLOOR_INDICATOR__c,
                                p.PBS_AAAP_DATE_SPACE_AVAILABILITY__c, p.PBS_AAAP_BASE_OPERATING_COSTS__c, p.PBS_AAAP_ARCH_ENG_FEES__c,
                                p.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, p.Name, PBS_AAAP_Total_Actual_Space_Available__c, PBS_AAAP_ClonedFromSpace__c
                        FROM PBS_AAAP_Space__c p
                        WHERE PBS_AAAP_OFFER_NUMBER__c = :offer.id
                ]) {
                    if (pi.PBS_AAAP_Total_Actual_Space_Available__c > 0) { // Space has to be copied only when it has actual remaining space available
                        PBS_AAAP_Space__c newSpace = pi.clone(false, true, false, false);
                        newSpace.PBS_AAAP_OFFER_NUMBER__c = offerWithdrawn.id;
                        newSpace.PBS_AAAP_Total_ABOA_Available__c = pi.PBS_AAAP_Total_Actual_Space_Available__c;
                        newspace.PBS_AAAP_SF_OFFERED__c = pi.PBS_AAAP_Total_Actual_Space_Available__c;
                        newSpace.PBS_AAAP_Total_ABOA_Awarded__c = 0.00; // making total awarded space to null for new copy
                        newSpace.PBS_AAAP_Total_ABOA_Selected__c = 0.00; // making total selected space to null for new copy
                        newSpace.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                        System.debug('5. Total ABOA Available :::::::::::::  ' + newSpace.PBS_AAAP_Total_ABOA_Available__c);
                        newspace.PBS_AAAP_ClonedFromSpace__c = pi.Id;
                        newSpaceitems.add(newSpace);
                        spaceMapDetail.put(newspace.PBS_AAAP_ClonedFromSpace__c, newSpace);

                        // Update old spcae items for Total ABOA Withdrawn
                        pi.PBS_AAAP_Total_ABOA_Withdrawn__c = pi.PBS_AAAP_Total_ABOA_Withdrawn__c + pi.PBS_AAAP_Total_Actual_Space_Available__c;
                        oldSpaceitems.add(pi);
                    }

                }
                insert spaceMapDetail.values(); //insert newSpaceitems;
                update oldSpaceitems;
                System.debug('6. Spaces inserted :::::::::::::  ' + newSpaceitems);
                for (PBS_AAAP_Space__c pi : [
                        SELECT p.Id, PBS_AAAP_ClonedFromSpace__c, PBS_AAAP_OFFER_NUMBER__c
                        FROM PBS_AAAP_Space__c p
                        WHERE PBS_AAAP_ClonedFromSpace__c IN :spaceMapDetail.keySet() AND PBS_AAAP_OFFER_NUMBER__c = :offerWithdrawn.id
                ]) {
                    spaceMap.put(pi.PBS_AAAP_ClonedFromSpace__c, pi.Id);
                }
                // // added by syam issues with rates not cloning bsac fields.. p.PBS_AAAP_BSAC__c, p.PBS_AAAP_BSAC_RATE__c
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
                                p.PBS_AAAP_BSAC__c,p.PBS_AAAP_BSAC_RATE__c
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

            } else if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED) {
                System.debug('3. The offer Status :::::::::::::  ' + offer.PBS_AAAP_Offer_Status__c);

                offerWithdrawn = offerClone(offer.id, 'withdraw');
                offerWithdrawn.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
                offerWithdrawn.PBS_AAAP_LEGACY_OFFER_NUMBER__c = null;
                insert offerWithdrawn;
                System.debug('4. The offer Inserted :::::::::::::  ' + offerWithdrawn.Id + '   with Status:::  ' + offerWithdrawn.PBS_AAAP_Offer_Status__c);

                List<PBS_AAAP_Other_Costs__c> newOtherCosts = new List<PBS_AAAP_Other_Costs__c>();
                for (PBS_AAAP_Other_Costs__c oc : [
                        SELECT p.PBS_AAAP_SHORT_DESC__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_COST__c, p.PBS_AAAP_COST_TYPE__c,
                                p.PBS_AAAP_COST_REMOVAL__c, p.Name, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                        FROM PBS_AAAP_Other_Costs__c p
                        WHERE p.PBS_AAAP_OFFER_NUMBER__c = :offer.id
                ]) {
                    PBS_AAAP_Other_Costs__c newOCost = oc.clone(false, true);
                    newOCost.PBS_AAAP_OFFER_NUMBER__c = offerWithdrawn.id;
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
                                p.PBS_AAAP_DATE_SPACE_AVAILABILITY__c, p.PBS_AAAP_BASE_OPERATING_COSTS__c, p.PBS_AAAP_ARCH_ENG_FEES__c,
                                p.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, p.Name, PBS_AAAP_Total_Actual_Space_Available__c, PBS_AAAP_ClonedFromSpace__c, p.PBS_AAAP_LEGACY_EXTERNAL_ID__c
                        FROM PBS_AAAP_Space__c p
                        WHERE PBS_AAAP_OFFER_NUMBER__c = :offer.id
                ]) {
                    if (pi.PBS_AAAP_Total_Actual_Space_Available__c > 0) { // Space has to be copied only when it has actual remaining space available
                        PBS_AAAP_Space__c newSpace = pi.clone(false, true, false, false);
                        newSpace.PBS_AAAP_OFFER_NUMBER__c = offerWithdrawn.id;
                        newSpace.PBS_AAAP_SF_OFFERED__c = pi.PBS_AAAP_Total_Actual_Space_Available__c;
                        newSpace.PBS_AAAP_Total_ABOA_Available__c = pi.PBS_AAAP_Total_Actual_Space_Available__c;
                        newSpace.PBS_AAAP_Total_ABOA_Awarded__c = 0.00; // making total awarded space to null for new copy
                        newSpace.PBS_AAAP_Total_ABOA_Selected__c = 0.00; // making total selected space to null for new copy
                        newSpace.PBS_AAAP_LEGACY_EXTERNAL_ID__c = null;
                        System.debug('5. Total ABOA Available :::::::::::::  ' + newSpace.PBS_AAAP_Total_ABOA_Available__c);
                        newspace.PBS_AAAP_ClonedFromSpace__c = pi.Id;
                        newSpaceitems.add(newSpace);
                        spaceMapDetail.put(newspace.PBS_AAAP_ClonedFromSpace__c, newSpace);

                        // Update old spcae items for Total ABOA Withdrawn
                        pi.PBS_AAAP_Total_ABOA_Withdrawn__c = pi.PBS_AAAP_Total_ABOA_Withdrawn__c + pi.PBS_AAAP_Total_Actual_Space_Available__c;
                        oldSpaceitems.add(pi);
                    }
                }
                insert spaceMapDetail.values(); //insert newSpaceitems;
                update oldSpaceitems;
                offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED;
                update offer;
                System.debug('6. Spaces inserted :::::::::::::  ' + newSpaceitems);
                for (PBS_AAAP_Space__c pi : [
                        SELECT p.Id, PBS_AAAP_ClonedFromSpace__c, PBS_AAAP_OFFER_NUMBER__c
                        FROM PBS_AAAP_Space__c p
                        WHERE PBS_AAAP_ClonedFromSpace__c IN :spaceMapDetail.keySet() AND PBS_AAAP_OFFER_NUMBER__c = :offerWithdrawn.id
                ]) {
                    spaceMap.put(pi.PBS_AAAP_ClonedFromSpace__c, pi.Id);
                }
                // // added by syam issues with rates not cloning bsac fields.. p.PBS_AAAP_BSAC__c, p.PBS_AAAP_BSAC_RATE__c
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
                                p.PBS_AAAP_BSAC__c,p.PBS_AAAP_BSAC_RATE__c
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

        } catch (Exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }

        offersList = null;
//--------------------------------------------------------------------------------------
//        offersList = [Select p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_Building_Name__c, PBS_AAAP_Offer_Status__c,
//                                 PBS_AAAP_Offer__c.PBS_AAAP_ZipCode__c, PBS_AAAP_Default_Start__c, PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
//                                 p.PBS_AAAP_Total_Withdraw_Space_Available__c 
//                          From PBS_AAAP_Offer__c p 
//                          where p.OwnerId =:UserInfo.getUserId() 
//                          and p.PBS_AAAP_Is_Offer_Valid__c = true 
//                          order by p.LastModifiedDate desc]; 

        offersList = [
                SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_Building_Name__c, PBS_AAAP_Offer_Status__c,
                        PBS_AAAP_Offer__c.PBS_AAAP_ZipCode__c, PBS_AAAP_Default_Start__c, PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                        p.PBS_AAAP_Total_Withdraw_Space_Available__c,PBS_AAAP_Total_Withdraw_Space__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c
                FROM PBS_AAAP_Offer__c p
                WHERE p.OwnerId = :UserInfo.getUserId()
                AND p.PBS_AAAP_Is_Offer_Valid__c = TRUE
            AND p.Master_Offer__c = NULL
                ORDER BY p.LastModifiedDate DESC
        ];


        return null;
    }

    public PBS_AAAP_Offer__c offerClone(string offerId, string action) {

        PBS_AAAP_Offer__c copySelectedOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);

        PBS_AAAP_Offer__c newoffer = new PBS_AAAP_Offer__c();
        newoffer = copySelectedOffer.clone(false, true);

        //System.debug('::::::::: New Offer ::: ' +copySelectedOffer);
        //System.debug(':::::: Copy Offer ::: '+ newoffer.Id);


        return newoffer;

    }

    public PageReference actionViewOnly() {
        pageReference p;
        String offerId = ApexPages.currentPage().getParameters().get('viewofferIdParam');
        String Status = [SELECT PBS_AAAP_Offer_Status__c FROM PBS_AAAP_Offer__c WHERE Id = :offerId LIMIT 1].PBS_AAAP_Offer_Status__c;
        if (Status == 'Submitted' || Status == 'Awarded/Submitted' || Status == 'Awarded') {
            p = new PageReference('/AAAP/OfferAcknowledgment');
            //PageReference p = Page.PBS_AAAP_offerAcknowledgment;
            p.getParameters().put('offerId', offerId);
           // p.setRedirect(true);
           // return p;
        } else {
            p = new PageReference('/AAAP/OfferAcknowledgment');
            //PageReference p = Page.PBS_AAAP_OfferBuildingView;
            p.getParameters().put('offerId', offerId);
          //  p.setRedirect(true);
          //  return p;
        }
        
        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferAcknowledgment', Label.LOP_Community_Base_URL+'AAAP-OfferAcknowledgment');
        system.debug('pageURLForRedirection ===> '+ JSON.serializePretty(pageURLForRedirection));
        return null;

    }

    public List<SelectOption> getRLPs() {
        List<SelectOption> options = new List<SelectOption>();
        User usrinfo = [SELECT PBS_AAAP_Regions__c FROM User WHERE id = :UserInfo.getUserId()];
        String userRegions = usrInfo.PBS_AAAP_Regions__c;
        List<String> listofregions = new List<String>();
        List<PBS_AAAP_RLP__c> RLPList;
        if (userRegions != null) {
            listofregions = userRegions.split(';');
        }

        RLPList = [SELECT id, PBS_AAAP_RLP_Number__c FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_Region__c IN :listofregions AND PBS_AAAP_STATUS__c != :PBS_AAAP_GlobalConstants.RLPSTATUS_DRAFT];
        //System.debug ('*****Regions List ::::::::' + RLPList);
        options.add(new SelectOption('All', 'Select RLP'));
        if (RLPList.size() > 0) {
            for (PBS_AAAP_RLP__c rlp : RLPList) {
                options.add(new SelectOption(rlp.id, rlp.PBS_AAAP_RLP_Number__c));
            }
        }
        //System.debug('******************** RLP Info list::::::::: : '+RLPList);
        return options;
    }

    public PageReference showRLPOffers() {

        offersList = null;
        try {
            if (selectRLP != 'All') {
                system.debug('******** Slect RLP ::: ' + selectRLP);
                offersList = [
                        SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Building_Name__c,
                                p.PBS_AAAP_Offer_Status__c, p.PBS_AAAP_Default_Start__c, p.PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                                p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_Total_Withdraw_Space__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c
                        FROM PBS_AAAP_Offer__c p
                        WHERE p.OwnerId = :UserInfo.getUserId()
                        AND p.PBS_AAAP_Is_Offer_Valid__c = TRUE
                        AND p.PBS_AAAP_RLP_Number__c = :selectRLP.trim()
                    	AND p.Master_Offer__c = NULL
                        ORDER BY p.LastModifiedDate DESC
                ];
                System.debug('********select RLP*** offer list size ::::::: ' + offersList.size());
            } else {
                offersList = [
                        SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Building_Name__c,
                                p.PBS_AAAP_Offer_Status__c, p.PBS_AAAP_Default_Start__c, p.PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                                p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_Total_Withdraw_Space__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c
                        FROM PBS_AAAP_Offer__c p
                        WHERE p.OwnerId = :UserInfo.getUserId()
                        AND p.PBS_AAAP_Is_Offer_Valid__c = TRUE
                    	AND p.Master_Offer__c = NULL
                        ORDER BY p.LastModifiedDate DESC
                ];
                System.debug('******ALL***** offer list size ::::::: ' + offersList.size());
            }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }

    public PageReference actionLopOfferEdit() {

        PageReference p = null;
        String offerId = ApexPages.currentPage().getParameters().get('editofferIdParam');
        System.debug('*******OfferID******* ::: ' + offerId);

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();

        try {

            PBS_AAAP_Offer__c lopoffer = [
                    SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Building_Name__c,
                            p.PBS_AAAP_Offer_Status__c, p.PBS_AAAP_Default_Start__c, p.PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                            p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_Total_Withdraw_Space__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c,
                            p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :offerId
            ];
            System.debug('::::::::::::: Due  date ::: ' + lopoffer);
            //System.debug('::::::::::::: Project_Termination_Flag__c ::: ' + lopoffer.Project_EOI_ID__r.Project_Termination_Flag__c);
            System.debug('::::::::::::: Due  date ::: ' + lopoffer.PBS_AAAP_Offer_Status__c);
            System.debug('::::::::::::: Due  date ::: ' + PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT);
            System.debug('::::::::::::: Due  date ::: ' + lopoffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c);
            if ((lopoffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT) && (lopoffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c)) {
                System.debug('::::::::::::: Due  date2 ::: ' + lopoffer);
                p = new PageReference('/RSAP/Building');
                //p = Page.PBS_LOP_Building;
                p.getParameters().put('offerId', lopoffer.Id);
                p.getParameters().put('edit', 'true');
                p.getParameters().put('terminated', 'false');
               // communities  p.setRedirect(true);
            } else if (!lopoffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                //System.debug('3. The offer Status :::::::::::::  ' + lopoffer.LOP_Offer_Status__c);
                //System.debug('offer Submission Date :::::::::::::  ' + lopoffer.LOP_Offer_Submission_Date__c);
                //Syam***LOP: please add message that will say "Project has been terminated. Offer opened in "View" mode.
                p = new PageReference('/RSAP/Building');
                //p = Page.PBS_LOP_Building;
                p.getParameters().put('offerId', lopoffer.Id);
                p.getParameters().put('edit', 'false');
                p.getParameters().put('terminated', 'true');
                 // communities  p.setRedirect(true);
            } else if (lopoffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED || lopoffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED) {  //OOLOP-1100
                //System.debug('3. The offer Status :::::::::::::  ' + lopoffer.LOP_Offer_Status__c);
                //System.debug('offer Submission Date :::::::::::::  ' + lopoffer.LOP_Offer_Submission_Date__c);

                //datetime ofrDueDate = lopoffer.Project_Offer_Due_Date__c;
                //datetime dtoday = datetime.now();

                //if (dtoday < ofrDueDate) {
                //p = Page.PBS_LOP_Building;
                //p.getParameters().put('offerId', lopoffer.Id);
                //p.getParameters().put('edit', 'true');
                //p.setRedirect(true);
                //}// edit logic ends
                //else {
                lopoffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                update lopoffer;
                p = new PageReference('/RSAP/Building');
                //p = Page.PBS_LOP_Building;
                p.getParameters().put('offerId', lopoffer.Id);
                p.getParameters().put('edit', 'true');
                p.getParameters().put('draftMsgFlag', 'true');
                 // communities  p.setRedirect(true);

                //}
            }
           // return p;
           
            p.setRedirect(false);
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Building', Label.LOP_Community_Base_URL+'RSAP-Building');
            system.debug('pageURLForRedirection ===> '+ JSON.serializePretty(pageURLForRedirection));
            return null;
        }


        catch (Exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }


    }
    public PageReference actionLOPViewOnly() {
        system.debug('===> RUNNING actionLOPViewOnly');
        String offerId = ApexPages.currentPage().getParameters().get('viewofferIdParam');
        //PageReference p = Page.PBS_LOP_Building;
        PageReference p = new PageReference('/RSAP/Building');

        p.getParameters().put('offerId', offerId);
        p.getParameters().put('edit', 'false');
            
        /* J. Rogers - Communities Upgrade
            p.setRedirect(true);
            return p; 
        */

        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Building', Label.LOP_Community_Base_URL+'RSAP-Building');
  
        system.debug('pageURLForRedirection===> ' + pageURLForRedirection);
  
        return null;

    }

    public PageReference updateLOPToWithdrawnStatus() {
        PageReference p = null;
        String offerId = ApexPages.currentPage().getParameters().get('updateofferIdParam');
        System.debug('*******OfferID******* ::: ' + offerId);

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();

        try {

            PBS_AAAP_Offer__c lopoffer = [
                    SELECT p.id, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_City__c, p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Building_Name__c,
                            p.PBS_AAAP_Offer_Status__c, p.PBS_AAAP_Default_Start__c, p.PBS_AAAP_Default_End__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                            p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_Total_Withdraw_Space__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :offerId
            ];
            //System.debug('::::::::::::: Due  date ::: ' + lopoffer.Project_Offer_Due_Date__c);
            //System.debug('::::::::::::: Project_Termination_Flag__c ::: ' + lopoffer.Project_EOI_ID__r.Project_Termination_Flag__c);
            lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN;
            update lopOffer;
            return null;
        } catch (Exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }

    }
    
    // Action offer edit button logic. Redirect to an Offer page to show the offer details
    public PageReference actionAdditionalDocs() {
        PageReference p = null;
        String offerId = ApexPages.currentPage().getParameters().get('additionalOfferParam');
        p = new PageReference('/AAAP/AdditionalAttachments');
        //p = Page.PBS_AAAP_OfferBuilding;
        p.getParameters().put('offerId', offerId);

        /* J. Rogers - Communities Upgrade
            p.setRedirect(true);
            return p;
        */
        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/AdditionalAttachments', Label.LOP_Community_Base_URL+'AAAP-AdditionalAttachments');
        system.debug('pageURLForRedirection ===> '+ JSON.serializePretty(pageURLForRedirection));
        return null;
        
    }
    // Action offer edit button logic. Redirect to an Offer page to show the offer details
    public PageReference actionAdditionalRSAPDocs() {
        PageReference p = null;
        String offerId = ApexPages.currentPage().getParameters().get('additionalOfferParam');
        p = new PageReference('/RSAP/AdditionalAttachments');
        //p = Page.PBS_AAAP_OfferBuilding;
        p.getParameters().put('offerId', offerId);
        
        /* J. Rogers - Communities Upgrade
            p.setRedirect(true);
            return p;
        */
        
        p.setRedirect(false);
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/AdditionalAttachments', Label.LOP_Community_Base_URL+'RSAP-AdditionalAttachments');
        system.debug('pageURLForRedirection ===> '+ JSON.serializePretty(pageURLForRedirection));
        return null;
    }
    public class ContentDocumentWrapper {
        public String name { get; set; }
        public Blob bodyBlob { get; set; }
        public ContentDocumentWrapper(String name, Blob bodyBlob){
            this.name = name;
            this.bodyBlob = bodyBlob;
        }
    }

}