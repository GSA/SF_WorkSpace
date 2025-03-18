public with sharing class PBS_AAAP_OfferForm1364RateStructure {
	
    public string folderId {get;set;}    
    transient public string strImageBlob {get;set;}
    transient public string strImagename {get;set;} 

    public ID offerId { get; set; }

    public string formtype { get; set; }

    // Space and Rates Field variables  

    public List<PBS_AAAP_Rate__c> rateList = new List<PBS_AAAP_Rate__c>();
    //*** Vaishali RLP Field variables  

    public string maxTIUsed { get; set; }
    public string newTIUsed { get; set; }
    public string sucTIUsed { get; set; }
    public string BSACUsed { get; set; }
    public boolean isValidUser { get; set; }
    //*** Vaishali RLP Field variables  
    public List<RateClass> spaceandrate { get; set; }

    public integer countsize { get; set; }

    public String regionCode { get; set; }

    public PBS_AAAP_OfferForm1364RateStructure() {

        offerId = ApexPages.currentPage().getParameters().get('offerId');

        // validation for site guest user
        system.debug('\n--UserInfo.getUserType()--'+UserInfo.getUserType());
        if(UserInfo.getUserType() == 'Guest'){
            if(!isValidUser()){
                return;
            }
        }

        formtype = ApexPages.currentPage().getParameters().get('formtype');
        spaceandrate = new List<RateClass>();
        string userType = UserInfo.getUserType();
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            //added by syam for security check as part of FY16
            PBS_AAAP_Offer__c offerDetails = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            //added this condition because it is only applicable for extranet users , intranet users can see the page. extranet users always have portal in the userType
            if (userType.contains('Portal')) {
                if (offerDetails.OwnerId == UserInfo.getUserId()) {
                    isValidUser = true;
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                    Apexpages.addMessage(myMsg);
                    isValidUser = false;
                    return;
                }
            } else {
                isValidUser = true;
            }
            //***Vaishali Get RLP data based on OfferId
            PBS_AAAP_Offer__c offer = [
                    SELECT p.id, p.PBS_AAAP_RLP_Number__c
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :offerId
            ];
            PBS_AAAP_RLP__c rlp = [
                    SELECT p.PBS_AAAP_Region__c,p.PBS_AAAP_MAX_TIUSED__c, p.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, P.PBS_AAAP_BSAC_per_ABOA__c,p.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c
                    FROM PBS_AAAP_RLP__c p
                    WHERE p.Id = :offer.PBS_AAAP_RLP_Number__c
            ];
            maxTIUsed = String.valueOf(rlp.PBS_AAAP_MAX_TIUSED__c);
            newTIUsed = String.valueOf(rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c);
            sucTIUsed = String.valueOf(rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c);
            BSACUsed = String.valueOf(rlp.PBS_AAAP_BSAC_per_ABOA__c);
            regionCode = rlp.PBS_AAAP_Region__c;
            System.debug('regionCode is ****' + regionCode);
            //***Vaishali RLP Data in
            if (formtype == 'offerform1364ratestructure') {

                rateList = PBS_AAAP_GlobalConstants.getRatesandSpace(offerId);
                System.debug('********** rateList size::: ' + rateList.size());
                System.debug('********** rateList 1::: ' + rateList);
                System.debug('********** rlp 1::: ' + rlp);
                if (rateList.size() > 0) {
                    for (PBS_AAAP_Rate__c rate : rateList) {
                        spaceandrate.add(new RateClass(rate, true));
                    }
                    System.debug('********** List ::: ' + spaceandrate);
                }
                if (rateList.size() < 45) {
                    countsize = 45 - rateList.size();
                    PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c();
                    for (integer i = rateList.size() - 1; i <= 45; i++) {
                        spaceandrate.add(new RateClass(rate, false));
                    }
                }
            } // end if ratestructure
        } // end if param        
    }

    public class RateClass {
        public string field1 { get; set; }
        public string field2 { get; set; }
        public string field3 { get; set; }
        public string field4 { get; set; }
        public string field5 { get; set; }
        public string field6 { get; set; }
        public string field7 { get; set; }
        public string field8 { get; set; }
        public string field9 { get; set; }
        public string field10 { get; set; }
        public string field11 { get; set; }
        public string field12 { get; set; }
        public string field13 { get; set; }
        public string field14 { get; set; }
        public string field15 { get; set; }
        public string field16 { get; set; }
        public string field17 { get; set; }
        public string field18 { get; set; }
        public string field19 { get; set; }
        public string field20 { get; set; }
        //***Vaishali    
        public string field21 { get; set; }     //BSAC Rate
        public string field22 { get; set; }     //BSAC AMT
        //*** Vaishali

        //added by syam on 08/04/2016 for p.PBS_AAAP_OT_RATE_COOLING_HEAT__c  (HVAC Overtime Rate)
        public string field23 { get; set; }
        public string field24 { get; set; }
        public string field25 { get; set; }
        public string field26 { get; set; }

        public RateClass(PBS_AAAP_Rate__c rate, boolean flag) {
            Decimal returnVal = 0.00;
            if (flag == true) {
                if (rate.PBS_AAAP_SPACE__r.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c == true)
                    field1 = 'N'; else {
                    field1 = 'C';
                }


                field2 = (rate.PBS_AAAP_LEASE_TERM__c).substring(0, ((rate.PBS_AAAP_LEASE_TERM__c).length() - 5));
                if (field2.length() > 3) {
                    field2 = field2.replace('years', '');
                } //Vaishali RLP FY15
                field3 = String.valueOf(rate.PBS_AAAP_SPACE__r.PBS_AAAP_SF_OFFERED__c);
                field4 = String.valueOf((rate.PBS_AAAP_BASE_RATE__c).setScale(2));
                field5 = String.valueOf((rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c).setScale(2));
                field6 = String.valueOf((rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c).setScale(2));
                field7 = String.valueOf(math.abs((rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c).setScale(2))); //String.ValueOf((rate.PBS_AAAP_COST_FOR_TI__c).setScale(2));
                field8 = String.valueOf((rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c).setScale(2));
                //  field9 = String.ValueOf((rate.PBS_AAAP_SPACE__r.PBS_AAAP_TOTAL_MARKUP__c).setScale(2));
                field9 = String.valueOf(rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
//                field10 = String.ValueOf((rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c).setScale(2)); //moved
//                field11 = String.ValueOf(rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c); //moved
                field12 = String.valueOf(rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
                field13 = String.valueOf(rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c);
                field14 = String.valueOf(rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c);
                field15 = 'N/A';
//                field16 = String.ValueOf(rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c);//no longer used
//                field17 = 'N/A'; //String.ValueOf(rate.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c);
                field18 = String.valueOf((rate.PBS_AAAP_PV_Value__c).setScale(2)); //String.ValueOf((rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c).setScale(2));
                field19 = 'N/A';
                field20 = 'N/A';//String.ValueOf((rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c).setScale(2));
                field21 = 'N/A'; //Vaishali 11/21 assigning values
                field22 = 'N/A'; //Vaishali 11/21 assigning values

                //***Vaishali Set BSAC Values
                //field21 = String.ValueOf(rate.PBS_AAAP_BSAC_RATE__c); //replaces field10 position
                //field22 = String.ValueOf(rate.PBS_AAAP_BSAC__c);  //replaces field11 position
                //field10 = String.ValueOf((rate.PBS_AAAP_BSAC_RATE__c).setScale(2)); //moved
                //field11 = String.ValueOf(math.abs((rate.PBS_AAAP_BSAC__c).setScale(2))); //moved

                //Vaishali BSAC issue fix 04/02/2014
                if (rate.PBS_AAAP_BSAC_RATE__c == null) {
                    field10 = 'N/A';
                } else {
                    field10 = String.valueOf((rate.PBS_AAAP_BSAC_RATE__c).setScale(2)); //moved
                }
                if (rate.PBS_AAAP_BSAC__c == null) {
                    field11 = 'N/A';
                } else {
                    field11 = String.valueOf(math.abs((rate.PBS_AAAP_BSAC__c).setScale(2))); //moved
                }
                field16 = String.valueOf((rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c).setScale(2)); //moved
                field17 = String.valueOf(rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c); //moved
                //added by syam on 08/04/2016
                field23 = String.valueOf((rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c).setScale(2));
                field24 = String.valueOf((rate.PBS_AAAP_SPACE__r.PBS_AAAP_GC_OVERHEAD_AND_PROF__c).setScale(2));
                field25 = String.valueOf((rate.PBS_AAAP_SPACE__r.PBS_AAAP_ARCH_ENG_FEES__c).setScale(2));
                field26 = (rate.PBS_AAAP_SPACE__r.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c == null) ? '' : (rate.PBS_AAAP_SPACE__r.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c).substring(0, 1);

            } else {
                field1 = '';
                field2 = '';
                field3 = '';
                field4 = '';
                field5 = '';
                field6 = '';
                field7 = '';
                field8 = '';
                field9 = '';
                field10 = '';
                field11 = '';
                field12 = '';
                field13 = '';
                field14 = '';
                field15 = '';
                field16 = '';
                field17 = '';
                field18 = '';
                field19 = '';
                field20 = '';
                field21 = '';
                field22 = '';
                field23 = '';
                field24 = '';
                field25 = '';
                field26 = '';
            }

        }
    }
    
    public void captureImage()
    {
        folderId = [SELECT ID 
                   		FROM Folder 
                   		WHERE NAME = 'AAAP Folder'].Id;
        Document d = new Document(); 
        d.Name = strImagename+'.png';

        Integer strLen = strImageBlob.length() / 2;
        String first = strImageBlob.substring(0, strLen);
        String second = strImageBlob.substring(strLen);
        String first1 = first.replaceFirst('data:image/png;base64,','');
        String concat = first1 + second;
        d.Body = EncodingUtil.base64Decode(concat);

        //d.Body = EncodingUtil.base64Decode(strImageBlob.replaceFirst('data:image/png;base64,',''));
        d.ContentType = 'image/png';
        d.FolderId = folderId;
        d.IsPublic = true;
        insert d;
        PBS_AAAP_relateListSnapCntrl.saveRecIdinCookie(d.Id);
        system.debug('\n--d---'+d);
    }

    string fetchOfferKey(){
        string ofId = ApexPages.currentPage().getParameters().get('offerId');
        return [select PBS_AAAP_Session_key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_key__c;
    }

    boolean isValidUser(){
        // getting session id
        string paramSessionKey = ApexPages.currentPage().getParameters().get('sesid');
        string sessionOfferKey = fetchOfferKey();

        if(paramSessionKey != sessionOfferKey
                || string.isBlank(sessionOfferKey)
                || string.isBlank(paramSessionKey)){
            return false;
        }
        return true;
    }

    public pageReference isValidUserAction(){
        if(!isValidUser()){
            return new pageReference('/apex/GenricErrorPage?errormessage=Not Authorized to see this page');
        }
        return null;
    }

}