public with sharing class PBS_AAAP_PV_SummaryController extends PBS_AAAP_PageBaseController {
    
    public string folderId {get;set;}    
    transient public string strImageBlob {get;set;}
    transient public string strImagename {get;set;}
    
    public List<PBS_AAAP_Offer__c> lstOffer { get; set; }
    public List<PBS_AAAP_Agency_Requirement__c> lstAgency { get; set; }
    public List<PBS_AAAP_RLP__c> lstRLP { get; set; }
    public List<PBS_AAAP_Space__c> lstSpace { get; set; }
    public List<PBS_AAAP_Rate__c> lstRate { get; set; }
    public PBS_AAAP_Offer__c offer { get; set; }
    public String offerId { get; set; }
    public String agencyId { get; set; }
    public String pv { get; set; }
    public Decimal pvValue { get; set; }
    public string comments { get; set; }
    public string pvComments { get; set; }
    public Decimal lease15Y10F { get; set; }
    public Decimal lease10Y5F { get; set; }
    public Decimal lease10Y { get; set; }
    public Decimal totalLOHFee { get; set; }
    public Decimal freeRent1510 { get; set; }
    public Decimal BSAC { get; set; }
    public Decimal TI { get; set; }
    public Decimal structPark { get; set; }
    public Decimal surfPark { get; set; }

    public Decimal newLease {get; set;}
    public Decimal succeedingLease {get; set;}
    public Decimal physicalMoveCost {get; set;}
    public Decimal otherupfrontcosts {get; set;}
    public Decimal telecommunicationsCost {get; set;}
    public Decimal bsacperABOA {get; set;}
    public Decimal bsacForContinuingSpace {get; set;}
    public String spaceId{ get; set; }
    public Boolean continuingspace {get;set;}
    public Decimal rlpYear {get; set;}
    public Boolean tiNew {get; set;}
    public Boolean bsacNew {get; set;}

    public PBS_AAAP_PV_SummaryController() {
        offerId = getQueryParamAsString('offerId');
        agencyId = getQueryParamAsString('agencyId');
        pv = getQueryParamAsString('pv');
        comments = getQueryParamAsString('comment');
        newLease = getQueryParamAsDecimal('newLease');
        succeedingLease = getQueryParamAsDecimal('succeedingLease');
        physicalMoveCost = getQueryParamAsDecimal('physicalMoveCost');
        otherupfrontcosts = getQueryParamAsDecimal('otherupfrontcosts');
        telecommunicationsCost = getQueryParamAsDecimal('telecommunicationsCost');
        bsacperABOA = getQueryParamAsDecimal('bsacperABOA');
        bsacForContinuingSpace = getQueryParamAsDecimal('bsacForContinuingSpace');
        spaceId = getQueryParamAsString('spaceId');
        system.debug('TI NEW '+succeedingLease);
        system.debug('TI OLD '+newLease);
        pvValue = decimal.valueOf(pv);

        system.debug(offerId + agencyId + pv);
        offer = new PBS_AAAP_Offer__c();

        lstOffer = [
                SELECT Id, Name, PBS_AAAP_RLP_Number__c, PBS_AAAP_Signature_First_Name__c, PBS_AAAP_SIGNATURE_LAST_NAME__c, PBS_AAAP_Street_Address__c,
                        PBS_AAAP_Building_Name__c, PBS_AAAP_Email__c, PBS_AAAP_City__c, PBS_AAAP_State__c, LastModifiedDate,
                        PBS_AAAP_Monthly_cost_res_sur_park__c, PBS_AAAP_Monthly_cost_nonres_sur_park__c, PBS_AAAP_Monthly_cost_res_gar_park__c,
                        PBS_AAAP_Monthly_cost_nonres_gar_park__c, CreatedById, PBS_AAAP_Energy_Star_Reason__c
                FROM PBS_AAAP_Offer__c
                WHERE Id = :offerId
                LIMIT 1
        ];
        lstAgency = [
                SELECT Id, Name, PBS_AAAP_TYPE_OF_REQUIREMENT__c, PBS_AAAP_LEASE_TERM__c, PBS_AAAP_USF_REQ_MIN__c, PBS_AAAP_USF_REQ_MAX__c,
                        PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c, PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c, PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c,
                        PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, PBS_AAAP_BSAC_per_ABOA__c, PBS_AAAP_MOVE_DEFAULT__c,
                        PBS_AAAP_TELCOMM_DEFAULT__c, PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c, BSAC_for_Continuing_Space_per_ABOA_SF__c,
            			PBS_AAAP_Region__c
                FROM PBS_AAAP_Agency_Requirement__c
                WHERE Id = :agencyId
                LIMIT 1
        ];
        system.debug('Agency ID: '+agencyId); 
        system.debug('Agency: '+lstAgency[0]);
        System.debug('Total reserved parking spaces sur lot: '+lstAgency[0].PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c);
        lstRLP = [
                SELECT Id, PBS_AAAP_Discount_percent_Rate__c, PBS_AAAP_ESCALATION_PRCNT_RATE__c, PBS_AAAP_MOVE_DEFAULT__c, PBS_AAAP_TELCOMM_DEFAULT__c,
                        PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c, PBS_AAAP_BSAC_per_ABOA__c,BSAC_for_Continuing_Space_per_ABOA_SF__c,PBS_AAAP_Year__c
                FROM PBS_AAAP_RLP__c
                WHERE Id = :lstOffer[0].PBS_AAAP_RLP_Number__c
                LIMIT 1
        ];

        //if (lstRLP != null && lstRLP.size() > 0) {
        //    PBS_AAAP_RLP__c rlp = lstRLP[0];

        //    rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = newLease;
        //    rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = succeedingLease;
        //    rlp.PBS_AAAP_MOVE_DEFAULT__c = physicalMoveCost;
        //    rlp.PBS_AAAP_TELCOMM_DEFAULT__c = telecommunicationsCost;
        //    rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = otherupfrontcosts;
        //    rlp.PBS_AAAP_BSAC_per_ABOA__c=bsacperABOA;
        //    rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c= bsacForContinuingSpace;
        //}

        rlpYear = integer.valueof(lstRLP[0].PBS_AAAP_Year__c);

        lstSpace = [
                SELECT Id, PBS_AAAP_OFFER_NUMBER__c, Name, PBS_AAAP_GC_OVERHEAD_AND_PROF__c, PBS_AAAP_ARCH_ENG_FEES__c, PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,PBS_AAAP_NEW_SUCCEED_LEASE_IND__c,
                        PBS_AAAP_TOTAL_MARKUP__c
                FROM PBS_AAAP_Space__c
                WHERE PBS_AAAP_OFFER_NUMBER__c = :lstOffer[0].Id AND Id = :spaceId
                LIMIT 1
        ];

        System.debug('Space ID: '+lstSpace[0].Id+' Type of Agency: '+lstAgency[0].PBS_AAAP_TYPE_OF_REQUIREMENT__c+' New Space? : '+lstSpace[0].PBS_AAAP_NEW_SUCCEED_LEASE_IND__c);
        if (lstRLP != null && lstRLP.size() > 0 && lstAgency[0].PBS_AAAP_TYPE_OF_REQUIREMENT__c == 'Continuing' && lstSpace[0].PBS_AAAP_NEW_SUCCEED_LEASE_IND__c == false) {
            PBS_AAAP_RLP__c rlp = lstRLP[0];

            rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = newLease;
            rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = succeedingLease;
            rlp.PBS_AAAP_MOVE_DEFAULT__c = 0;
            rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 0;
            rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 0;
            if(rlpYear > 2018){
                rlp.PBS_AAAP_BSAC_per_ABOA__c=bsacperABOA;
                rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c= bsacForContinuingSpace;
            }
            //else{
            //    //rlp.PBS_AAAP_BSAC_per_ABOA__c=bsacperABOA;
            //    rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c= bsacperABOA;
            //}
            continuingspace = true;

        }else if(lstRLP != null && lstRLP.size() > 0){
            PBS_AAAP_RLP__c rlp = lstRLP[0];

            rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = newLease;
            rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = succeedingLease;
            rlp.PBS_AAAP_MOVE_DEFAULT__c = physicalMoveCost;
            rlp.PBS_AAAP_TELCOMM_DEFAULT__c = telecommunicationsCost;
            rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = otherupfrontcosts;
            if(rlpYear > 2018){
                rlp.PBS_AAAP_BSAC_per_ABOA__c=bsacperABOA;
                rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c= bsacForContinuingSpace;
            }

        }
        bsacNew = true;
        if((lstAgency[0].PBS_AAAP_TYPE_OF_REQUIREMENT__c == 'Continuing' && lstSpace[0].PBS_AAAP_NEW_SUCCEED_LEASE_IND__c == false)||(lstAgency[0].PBS_AAAP_TYPE_OF_REQUIREMENT__c == 'New' && lstSpace[0].PBS_AAAP_NEW_SUCCEED_LEASE_IND__c == false)){
            tiNew = false;
            //if(rlpYear > 2018){
                bsacNew = false;
            //}
        }else{
            tiNew = true;
        }

        if (!lstSpace.isEmpty()) {
            lstRate = [
                    SELECT Id, Name, PBS_AAAP_SPACE__c, PBS_AAAP_BSAC_RATE__c, PBS_AAAP_BSAC__c, PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c,
                            PBS_AAAP_BASE_RATE__c, PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                            PBS_AAAP_PV_Value__c, PBS_AAAP_PV_Value_Blended__c, PBS_AAAP_LEASE_TERM__c, PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c
                    FROM PBS_AAAP_Rate__c
                    WHERE PBS_AAAP_SPACE__c = :lstSpace[0].Id AND PBS_AAAP_LEASE_TERM__c = :lstAgency[0].PBS_AAAP_LEASE_TERM__c
                    LIMIT 1
            ];
            if(lstRate.size() == 0){
                string leaseTerm;
                leaseTerm = lstAgency[0].PBS_AAAP_LEASE_TERM__c;
                if(leaseTerm == '19 months, 11 firm'|| leaseTerm == '19 months,11 firm' ||
                    leaseTerm == '25 months, 16 firm'|| leaseTerm == '25 months,16 firm'){
                    if(leaseTerm.contains('ths, ')){
                        leaseTerm = leaseTerm.replace('ths, ', 'ths,');
                        System.debug('leasekey post update: '+leaseTerm);
                    }else{
                        leaseTerm = leaseTerm.replace('ths,', 'ths, ');
                        System.debug('leasekey post update: '+leaseTerm);
                    }

                    lstRate = [
                    SELECT Id, Name, PBS_AAAP_SPACE__c, PBS_AAAP_BSAC_RATE__c, PBS_AAAP_BSAC__c, PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c,
                            PBS_AAAP_BASE_RATE__c, PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                            PBS_AAAP_PV_Value__c, PBS_AAAP_PV_Value_Blended__c, PBS_AAAP_LEASE_TERM__c, PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c
                    FROM PBS_AAAP_Rate__c
                    WHERE PBS_AAAP_SPACE__c = :lstSpace[0].Id AND PBS_AAAP_LEASE_TERM__c = :leaseTerm
                    LIMIT 1
            ];

                }
            }

            TI = lstRate[0].PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c;
            BSAC = lstRate[0].PBS_AAAP_BSAC__c;
            if (TI < 0) {
                TI = TI * -1;
            }
            if (BSAC < 0) {
                BSAC = BSAC * -1;
            }
        }

        Decimal shell = lstRate[0].PBS_AAAP_BASE_RATE__c;
        Decimal operCost = lstRate[0].PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c;
        Decimal aTI = lstRate[0].PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c;
        Decimal totalFeeCost = lstSpace[0].PBS_AAAP_TOTAL_MARKUP__c;
        Decimal newContTI;
        Decimal amoBSAC = lstRate[0].PBS_AAAP_BSAC__c;

        if (lstAgency[0].PBS_AAAP_TYPE_OF_REQUIREMENT__c == 'New') {
            newContTI = lstRLP[0].PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c;
            } else {
            newContTI = lstRLP[0].PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c;
            }
        if (aTI < 0) {
            aTI = aTI * -1;
        }
        if (amoBSAC < 0) {
            amoBSAC = amoBSAC * -1;
        }
        system.debug('newContTI '+newContTI);
        if(newContTI > 0){
            totalLOHFee = totalFeeCost / newContTI;
        }else{ 
            totalLOHFee = 0;
        }

        Decimal resSur = 0;
        Decimal nonResSur = 0;
        Decimal totalSur = 0;
        if (lstAgency[0].PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c != null && lstOffer[0].PBS_AAAP_Monthly_cost_res_sur_park__c != null) {
            resSur = lstAgency[0].PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c * lstOffer[0].PBS_AAAP_Monthly_cost_res_sur_park__c;
        }
        if (lstAgency[0].PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c != null && lstOffer[0].PBS_AAAP_Monthly_cost_nonres_sur_park__c != null) {
            nonResSur = lstAgency[0].PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c * lstOffer[0].PBS_AAAP_Monthly_cost_nonres_sur_park__c;
        }
        if (lstAgency[0].PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c != null && lstAgency[0].PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c != null) {
            totalSur = lstAgency[0].PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c + lstAgency[0].PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c;
        }

        Decimal ABOA = lstAgency[0].PBS_AAAP_USF_REQ_MIN__c + lstAgency[0].PBS_AAAP_USF_REQ_MAX__c;

        Decimal resStr = 0;
        Decimal nonResStr = 0;
        Decimal totalStr = 0;
        if (lstAgency[0].PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c != null && lstOffer[0].PBS_AAAP_Monthly_cost_res_gar_park__c != null) {
            resStr = lstAgency[0].PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c * lstOffer[0].PBS_AAAP_Monthly_cost_res_gar_park__c;
        }
        if (lstAgency[0].PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c != null && lstOffer[0].PBS_AAAP_Monthly_cost_nonres_gar_park__c != null) {
            nonResStr = lstAgency[0].PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c * lstOffer[0].PBS_AAAP_Monthly_cost_nonres_gar_park__c;
        }
        if (lstAgency[0].PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c != null && lstAgency[0].PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c != null) {
            totalStr = lstAgency[0].PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c + lstAgency[0].PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c;
        }

        if (totalStr != 0) {
            structPark = (resStr + nonResStr) * 12 / totalStr / (ABOA / 2);
        } else {
            structPark = 0;
        }
        if (totalSur != 0) {
            surfPark = (resSur + nonResSur) * 12 / totalSur / (ABOA / 2);
        } else {
            surfPark = 0;
        }
        //lease15Y10F = 0;
        if (lstAgency[0].PBS_AAAP_LEASE_TERM__c == '15 years,10 firm' || lstAgency[0].PBS_AAAP_LEASE_TERM__c == '10 years' || lstAgency[0].PBS_AAAP_LEASE_TERM__c == '10 years,5 firm' || lstAgency[0].PBS_AAAP_LEASE_TERM__c == '10 years, 8 firm' || lstAgency[0].PBS_AAAP_LEASE_TERM__c == '15 years, 13 firm' || lstAgency[0].PBS_AAAP_LEASE_TERM__c == '17 years, 15 firm') {
            //if(shell != null && operCost !=null && aTI != null && totalLOHFee != null && amoBSAC!=null){
                system.debug('Shell: '+shell+'operCost: '+operCost+'aTI :'+aTI+'totalLOHFee: '+totalLOHFee+'amoBSAC :'+amoBSAC);
                lease15Y10F = (shell + operCost + aTI + (aTI * totalLOHFee) + amoBSAC) / 12;
                system.debug('Free rent value : '+lease15Y10F);
            //}
            if (lstRate[0].PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == 0) {
                freeRent1510 = 0;
            } else {
                freeRent1510 = lease15Y10F; //* lstRate[0].PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c;
                //freeRent1510 = lease15Y10F * lstRate[0].PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c;
            }
        }

    }

    public pagereference GeneratePDF() {
        PageReference pageRef = new PageReference('/apex/PBS_AAAP_PV_Summary_Page_PDF?offerId=' + lstOffer[0].Id + '&agencyId=' + lstAgency[0].Id + '&spaceId=' +lstSpace[0].Id +'&pv=' + pv + '&comment=' + comments+'&newLease=' + newLease +'&succeedingLease=' + succeedingLease +'&physicalMoveCost=' + physicalMoveCost +'&otherupfrontcosts=' + otherupfrontcosts +'&telecommunicationsCost=' + telecommunicationsCost +'&bsacperABOA=' + bsacperABOA +'&bsacForContinuingSpace=' + bsacForContinuingSpace);
        Map<String, String> getParams;
        getParams = pageRef.getParameters();
        newLease = getQueryParamAsDecimal('newLease');
        succeedingLease = getQueryParamAsDecimal('succeedingLease');
        physicalMoveCost = getQueryParamAsDecimal('physicalMoveCost');
        otherupfrontcosts = getQueryParamAsDecimal('otherupfrontcosts');
        telecommunicationsCost = getQueryParamAsDecimal('telecommunicationsCost');
        bsacperABOA = getQueryParamAsDecimal('bsacperABOA');
        bsacForContinuingSpace = getQueryParamAsDecimal('bsacForContinuingSpace');
        spaceId = getQueryParamAsString('spaceId');

        lstRLP = [
                SELECT Id, PBS_AAAP_Discount_percent_Rate__c, PBS_AAAP_ESCALATION_PRCNT_RATE__c, PBS_AAAP_MOVE_DEFAULT__c, PBS_AAAP_TELCOMM_DEFAULT__c,
                        PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c, PBS_AAAP_BSAC_per_ABOA__c,BSAC_for_Continuing_Space_per_ABOA_SF__c,PBS_AAAP_Year__c
                FROM PBS_AAAP_RLP__c
                WHERE Id = :lstOffer[0].PBS_AAAP_RLP_Number__c
                LIMIT 1
        ];

        rlpYear = integer.valueof(lstRLP[0].PBS_AAAP_Year__c);
        if (lstRLP != null && lstRLP.size() > 0 && continuingspace == true) {
            PBS_AAAP_RLP__c rlp = lstRLP[0];
            System.debug('Continuing Space other costs: '+rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c);
            rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = newLease;
            rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = succeedingLease;
            rlp.PBS_AAAP_MOVE_DEFAULT__c = 0;
            rlp.PBS_AAAP_TELCOMM_DEFAULT__c = 0;
            rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 0;
            if(rlpYear > 2018){
                rlp.PBS_AAAP_BSAC_per_ABOA__c=bsacperABOA;
                rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c= bsacForContinuingSpace;
            }
        }else if (lstRLP != null && lstRLP.size() > 0) {
            PBS_AAAP_RLP__c rlp = lstRLP[0];

            rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = newLease;
            rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = succeedingLease;
            rlp.PBS_AAAP_MOVE_DEFAULT__c = physicalMoveCost;
            rlp.PBS_AAAP_TELCOMM_DEFAULT__c = telecommunicationsCost;
            rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = otherupfrontcosts;
            if(rlpYear > 2018){
                rlp.PBS_AAAP_BSAC_per_ABOA__c=bsacperABOA;
                rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c= bsacForContinuingSpace;
            }
        }
        
        //getParams.put('tiNew', getQueryParamAsString('tiNew'));
        //getParams.put('tiUsed', getQueryParamAsString('tiUsed'));
        //getParams.put('estMoveCosts', getQueryParamAsString('estMoveCosts'));
        //getParams.put('estTelecomCosts', getQueryParamAsString('estTelecomCosts'));
        //getParams.put('lumpOverTi', getQueryParamAsString('lumpOverTi'));
        getParams.put('offerId', lstOffer[0].Id);
        getParams.put('agencyId', lstAgency[0].Id);
        getParams.put('pv', pv);
        pageRef.setRedirect(true);
        return pageRef;
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

}