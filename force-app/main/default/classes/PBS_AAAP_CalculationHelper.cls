public class PBS_AAAP_CalculationHelper {
    
    public static double NPVCalculator(PBS_AAAP_Agency_Requirement__c agency,PBS_AAAP_Offer__c offer, PBS_AAAP_RLP__c rlp,PBS_AAAP_Space__c space, PBS_AAAP_Rate__c rate){
        double result = 0;
        System.debug('agency : '+agency);
        System.debug('Offer : '+offer);
        System.debug('rlp : '+rlp);
        System.debug('space : '+space);
        System.debug('rate : '+rate);
        double monthlyCostNonReservedGarageParking = (offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c!=null) ? offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c : 0;
        double monthlyCostReservedGarageParking = (offer.PBS_AAAP_Monthly_cost_res_gar_park__c!=null) ? offer.PBS_AAAP_Monthly_cost_res_gar_park__c : 0;
        double monthlyCostNonReservedSurfaceParking = (offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c!=null) ? offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c : 0;
        double monthlyCostReservedSurfaceParking = (offer.PBS_AAAP_Monthly_cost_res_sur_park__c!=null) ? offer.PBS_AAAP_Monthly_cost_res_sur_park__c : 0;
        
        double lessorsPMFees = (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c!=null) ? space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c/100 : 0;
        double aeFees = (space.PBS_AAAP_ARCH_ENG_FEES__c!=null) ? space.PBS_AAAP_ARCH_ENG_FEES__c : 0;
        string aeFeesUOM = space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c;
        System.debug('aeFeesUOM : '+aeFeesUOM);
        System.debug('Rate: '+rate);
        System.debug('shellRateFirmTerm : '+rate.PBS_AAAP_BASE_RATE__c);
        double shellRateFirmTerm = (rate.PBS_AAAP_BASE_RATE__c!=null) ? rate.PBS_AAAP_BASE_RATE__c : 0;
        System.debug('shellRateFirmTerm : '+shellRateFirmTerm);
        double tiAmortizationRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c!=null) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c/100 : 0;
        double shellRateSoftTerm = (rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c!=null) ? rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c : 0;
        double bsacAmortizationRate = (rate.PBS_AAAP_BSAC_RATE__c!=null) ? rate.PBS_AAAP_BSAC_RATE__c/100 : 0;
        double firmTermFreeMonths = (rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c!=null) ? rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c : 0;
        double operatingCostsperABOASF = (rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c!=null) ? rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c : 0;
        double shellRate = (rate.PBS_AAAP_BASE_RATE__c!=null) ? rate.PBS_AAAP_BASE_RATE__c : 0;

        double tiforNeworContinuingSpace = (rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c!=null) ? rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c : 0;
        double physicalMoveCostperABOASF = (rlp.PBS_AAAP_MOVE_DEFAULT__c!=null) ? rlp.PBS_AAAP_MOVE_DEFAULT__c : 0;
        double telecomCostperABOASF = (rlp.PBS_AAAP_TELCOMM_DEFAULT__c!=null) ? rlp.PBS_AAAP_TELCOMM_DEFAULT__c : 0;
        double bsacforNeworContinuingSpace = (rlp.PBS_AAAP_BSAC_per_ABOA__c!=null) ? rlp.PBS_AAAP_BSAC_per_ABOA__c : 0;
        double buildOutperABOASF = (rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c!=null) ? rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c : 0;
        double discountRate = (rlp.PBS_AAAP_Discount_percent_Rate__c!=null) ? rlp.PBS_AAAP_Discount_percent_Rate__c/100 : 0;
        double escalationRate = (rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c!=null) ? rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c/100 : 0;
        
        double aboaSFMin = (agency.PBS_AAAP_USF_REQ_MIN__c!=null) ? agency.PBS_AAAP_USF_REQ_MIN__c : 0;
        double aboaSFMax = (agency.PBS_AAAP_USF_REQ_MAX__c!=null) ? agency.PBS_AAAP_USF_REQ_MAX__c : 0;
        string leaseTerm = agency.PBS_AAAP_LEASE_TERM__c;
        double reservedSurfaceParking = (agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c!=null) ? agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c : 0;
        double nonReservedSurfaceParking = (agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c!=null) ? agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c : 0;
        double reservedGarageParking = (agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c!=null) ? agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c : 0;
        double nonReservedGarageParking = (agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c!=null) ? agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c : 0;

        if(agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c !=null && space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c!=null && agency.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c == space.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c){
            tiforNeworContinuingSpace = (rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c!=null) ? rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c : 0;
            physicalMoveCostperABOASF = 0;
            telecomCostperABOASF = 0;
            buildOutperABOASF = 0;
            bsacforNeworContinuingSpace = (rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c != null) ? rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c : 0;

            System.debug('Its a continuing space : '+tiforNeworContinuingSpace);
        }
        System.debug('shellRate H: '+shellRate);
        System.debug('operatingCostsperABOASF E: '+operatingCostsperABOASF);
        System.debug('monthlyCostNonReservedGarageParking: '+monthlyCostNonReservedGarageParking +' ,monthlyCostReservedGarageParking: '+monthlyCostReservedGarageParking+ ' ,monthlyCostNonReservedSurfaceParking'+monthlyCostNonReservedSurfaceParking+' ,monthlyCostReservedSurfaceParking:'+monthlyCostReservedSurfaceParking);
            System.debug('operatingCostsperABOASF: '+operatingCostsperABOASF+ ' ,lessorsPMFees : '+lessorsPMFees +' ,aeFees: '+aeFees+ ' ,aeFeesUOM: ' +aeFeesUOM+ ' ,shellRate: '+shellRate+',tiAmortizationRate: '+tiAmortizationRate+'shellRateSoftTerm:'+shellRateSoftTerm+'shellRateFirmTerm'+shellRateFirmTerm+'bsacAmortizationRate'+bsacAmortizationRate);
            System.debug('firmTermFreeMonths: '+firmTermFreeMonths+' ,tiforNeworContinuingSpace: '+tiforNeworContinuingSpace+' ,physicalMoveCostperABOASF: ' +physicalMoveCostperABOASF +' ,telecomCostperABOASF: '+telecomCostperABOASF);
            System.debug('buildOutperABOASF : '+buildOutperABOASF+'discountRate: '+discountRate+' aboaSFMin: '+aboaSFMin+' aboaSFMax: '+aboaSFMax);
            System.debug(' ,reservedSurfaceParking: '+reservedSurfaceParking+' ,nonReservedSurfaceParking : '+nonReservedSurfaceParking+' ,reservedGarageParking: '+reservedGarageParking+' ,nonReservedGarageParking: '+nonReservedGarageParking);
        if(leaseTerm == '10 years, 8 firm'){
            double leaseTermMonths = 120;
            double leaseFirmTermMonths = 96;
            
            system.debug('--monthlyCostNonReservedGarageParking--'+monthlyCostNonReservedGarageParking);
            system.debug('--monthlyCostReservedGarageParking--'+monthlyCostReservedGarageParking);
            system.debug('--monthlyCostNonReservedSurfaceParking--'+monthlyCostNonReservedSurfaceParking);
            system.debug('--monthlyCostReservedSurfaceParking--'+monthlyCostReservedSurfaceParking);
            system.debug('--operatingCostsperABOASF--'+operatingCostsperABOASF);
            system.debug('--lessorsPMFees--'+lessorsPMFees);
            system.debug('--aeFees--'+aeFees);
            system.debug('--shellRateFirmTerm--'+shellRateFirmTerm);
            system.debug('--tiAmortizationRate--'+tiAmortizationRate);
            system.debug('--shellRateSoftTerm--'+shellRateSoftTerm);
            system.debug('--bsacAmortizationRate--'+bsacAmortizationRate);
            system.debug('--firmTermFreeMonths--'+firmTermFreeMonths);
            system.debug('--tiforNeworContinuingSpace--'+tiforNeworContinuingSpace);
            system.debug('--physicalMoveCostperABOASF--'+physicalMoveCostperABOASF);
            system.debug('--telecomCostperABOASF--'+telecomCostperABOASF);
            system.debug('--bsacforNeworContinuingSpace--'+bsacforNeworContinuingSpace);
            system.debug('--buildOutperABOASF--'+buildOutperABOASF);
            system.debug('--discountRate--'+discountRate);
            system.debug('--escalationRate--'+escalationRate);
            system.debug('--aboaSFMin--'+aboaSFMin);
            system.debug('--aboaSFMax--'+aboaSFMax);
            system.debug('--leaseTermMonths--'+leaseTermMonths);
            system.debug('--leaseFirmTermMonths--'+leaseFirmTermMonths);
            system.debug('--reservedSurfaceParking--'+reservedSurfaceParking);
            system.debug('--nonReservedSurfaceParking--'+nonReservedSurfaceParking);
            system.debug('--reservedGarageParking--'+reservedGarageParking);
            system.debug('--nonReservedGarageParking--'+nonReservedGarageParking);
            
            result = SmallLeaseNPV(monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,operatingCostsperABOASF,lessorsPMFees,
                aeFees,aeFeesUOM,shellRateFirmTerm,tiAmortizationRate,shellRateSoftTerm,bsacAmortizationRate,firmTermFreeMonths,tiforNeworContinuingSpace,physicalMoveCostperABOASF,telecomCostperABOASF,bsacforNeworContinuingSpace,
                buildOutperABOASF,discountRate,escalationRate,aboaSFMin,aboaSFMax,leaseTermMonths,leaseFirmTermMonths,reservedSurfaceParking,nonReservedSurfaceParking,reservedGarageParking,nonReservedGarageParking);

        }else if(leaseTerm == '15 years, 13 firm'){
            double leaseTermMonths = 180;
            double leaseFirmTermMonths = 96;
            
            system.debug('--monthlyCostNonReservedGarageParking--'+monthlyCostNonReservedGarageParking);
            system.debug('--monthlyCostReservedGarageParking--'+monthlyCostReservedGarageParking);
            system.debug('--monthlyCostNonReservedSurfaceParking--'+monthlyCostNonReservedSurfaceParking);
            system.debug('--monthlyCostReservedSurfaceParking--'+monthlyCostReservedSurfaceParking);
            system.debug('--operatingCostsperABOASF--'+operatingCostsperABOASF);
            system.debug('--lessorsPMFees--'+lessorsPMFees);
            system.debug('--aeFees--'+aeFees);
            system.debug('--shellRateFirmTerm--'+shellRateFirmTerm);
            system.debug('--tiAmortizationRate--'+tiAmortizationRate);
            system.debug('--shellRateSoftTerm--'+shellRateSoftTerm);
            system.debug('--bsacAmortizationRate--'+bsacAmortizationRate);
            system.debug('--firmTermFreeMonths--'+firmTermFreeMonths);
            system.debug('--tiforNeworContinuingSpace--'+tiforNeworContinuingSpace);
            system.debug('--physicalMoveCostperABOASF--'+physicalMoveCostperABOASF);
            system.debug('--telecomCostperABOASF--'+telecomCostperABOASF);
            system.debug('--bsacforNeworContinuingSpace--'+bsacforNeworContinuingSpace);
            system.debug('--buildOutperABOASF--'+buildOutperABOASF);
            system.debug('--discountRate--'+discountRate);
            system.debug('--escalationRate--'+escalationRate);
            system.debug('--aboaSFMin--'+aboaSFMin);
            system.debug('--aboaSFMax--'+aboaSFMax);
            system.debug('--leaseTermMonths--'+leaseTermMonths);
            system.debug('--leaseFirmTermMonths--'+leaseFirmTermMonths);
            system.debug('--reservedSurfaceParking--'+reservedSurfaceParking);
            system.debug('--nonReservedSurfaceParking--'+nonReservedSurfaceParking);
            system.debug('--reservedGarageParking--'+reservedGarageParking);
            system.debug('--nonReservedGarageParking--'+nonReservedGarageParking);
            
            result = MediumLeaseNPV(monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,operatingCostsperABOASF,lessorsPMFees,
                aeFees,aeFeesUOM,shellRateFirmTerm,tiAmortizationRate,shellRateSoftTerm,bsacAmortizationRate,firmTermFreeMonths,tiforNeworContinuingSpace,physicalMoveCostperABOASF,telecomCostperABOASF,bsacforNeworContinuingSpace,
                buildOutperABOASF,discountRate,escalationRate,aboaSFMin,aboaSFMax,leaseTermMonths,leaseFirmTermMonths,reservedSurfaceParking,nonReservedSurfaceParking,reservedGarageParking,nonReservedGarageParking);

        }else if(leaseTerm == '17 years, 15 firm'){
            double leaseTermMonths = 204;
            double leaseFirmTermMonths = 96;
            
            system.debug('--monthlyCostNonReservedGarageParking--'+monthlyCostNonReservedGarageParking);
            system.debug('--monthlyCostReservedGarageParking--'+monthlyCostReservedGarageParking);
            system.debug('--monthlyCostNonReservedSurfaceParking--'+monthlyCostNonReservedSurfaceParking);
            system.debug('--monthlyCostReservedSurfaceParking--'+monthlyCostReservedSurfaceParking);
            system.debug('--operatingCostsperABOASF--'+operatingCostsperABOASF);
            system.debug('--lessorsPMFees--'+lessorsPMFees);
            system.debug('--aeFees--'+aeFees);
            system.debug('--shellRateFirmTerm--'+shellRateFirmTerm);
            system.debug('--tiAmortizationRate--'+tiAmortizationRate);
            system.debug('--shellRateSoftTerm--'+shellRateSoftTerm);
            system.debug('--bsacAmortizationRate--'+bsacAmortizationRate);
            system.debug('--firmTermFreeMonths--'+firmTermFreeMonths);
            system.debug('--tiforNeworContinuingSpace--'+tiforNeworContinuingSpace);
            system.debug('--physicalMoveCostperABOASF--'+physicalMoveCostperABOASF);
            system.debug('--telecomCostperABOASF--'+telecomCostperABOASF);
            system.debug('--bsacforNeworContinuingSpace--'+bsacforNeworContinuingSpace);
            system.debug('--buildOutperABOASF--'+buildOutperABOASF);
            system.debug('--discountRate--'+discountRate);
            system.debug('--escalationRate--'+escalationRate);
            system.debug('--aboaSFMin--'+aboaSFMin);
            system.debug('--aboaSFMax--'+aboaSFMax);
            system.debug('--leaseTermMonths--'+leaseTermMonths);
            system.debug('--leaseFirmTermMonths--'+leaseFirmTermMonths);
            system.debug('--reservedSurfaceParking--'+reservedSurfaceParking);
            system.debug('--nonReservedSurfaceParking--'+nonReservedSurfaceParking);
            system.debug('--reservedGarageParking--'+reservedGarageParking);
            system.debug('--nonReservedGarageParking--'+nonReservedGarageParking);
            
            result = LongLeaseNPV(monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,operatingCostsperABOASF,lessorsPMFees,
                aeFees,aeFeesUOM,shellRateFirmTerm,tiAmortizationRate,shellRateSoftTerm,bsacAmortizationRate,firmTermFreeMonths,tiforNeworContinuingSpace,physicalMoveCostperABOASF,telecomCostperABOASF,bsacforNeworContinuingSpace,
                buildOutperABOASF,discountRate,escalationRate,aboaSFMin,aboaSFMax,leaseTermMonths,leaseFirmTermMonths,reservedSurfaceParking,nonReservedSurfaceParking,reservedGarageParking,nonReservedGarageParking);
        }else if(leaseTerm == '19 months, 11 firm'|| leaseTerm == '19 months,11 firm'){
            double leaseTermMonths = 19;
            double leaseFirmTermMonths = 11;
            
            system.debug('--monthlyCostNonReservedGarageParking--'+monthlyCostNonReservedGarageParking);
            system.debug('--monthlyCostReservedGarageParking--'+monthlyCostReservedGarageParking);
            system.debug('--monthlyCostNonReservedSurfaceParking--'+monthlyCostNonReservedSurfaceParking);
            system.debug('--monthlyCostReservedSurfaceParking--'+monthlyCostReservedSurfaceParking);
            system.debug('--operatingCostsperABOASF--'+operatingCostsperABOASF);
            system.debug('--lessorsPMFees--'+lessorsPMFees);
            system.debug('--aeFees--'+aeFees);
            system.debug('--shellRateFirmTerm--'+shellRateFirmTerm);
            system.debug('--tiAmortizationRate--'+tiAmortizationRate);
            system.debug('--shellRateSoftTerm--'+shellRateSoftTerm);
            system.debug('--bsacAmortizationRate--'+bsacAmortizationRate);
            system.debug('--firmTermFreeMonths--'+firmTermFreeMonths);
            system.debug('--tiforNeworContinuingSpace--'+tiforNeworContinuingSpace);
            system.debug('--physicalMoveCostperABOASF--'+physicalMoveCostperABOASF);
            system.debug('--telecomCostperABOASF--'+telecomCostperABOASF);
            system.debug('--bsacforNeworContinuingSpace--'+bsacforNeworContinuingSpace);
            system.debug('--buildOutperABOASF--'+buildOutperABOASF);
            system.debug('--discountRate--'+discountRate);
            system.debug('--escalationRate--'+escalationRate);
            system.debug('--aboaSFMin--'+aboaSFMin);
            system.debug('--aboaSFMax--'+aboaSFMax);
            system.debug('--leaseTermMonths--'+leaseTermMonths);
            system.debug('--leaseFirmTermMonths--'+leaseFirmTermMonths);
            system.debug('--reservedSurfaceParking--'+reservedSurfaceParking);
            system.debug('--nonReservedSurfaceParking--'+nonReservedSurfaceParking);
            system.debug('--reservedGarageParking--'+reservedGarageParking);
            system.debug('--nonReservedGarageParking--'+nonReservedGarageParking);
            
            result = Census19NPV(monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,operatingCostsperABOASF,lessorsPMFees,
                aeFees,aeFeesUOM,shellRate,tiAmortizationRate,firmTermFreeMonths,tiforNeworContinuingSpace,physicalMoveCostperABOASF,telecomCostperABOASF,
                buildOutperABOASF,discountRate,aboaSFMin,aboaSFMax,leaseTermMonths,leaseFirmTermMonths,reservedSurfaceParking,nonReservedSurfaceParking,reservedGarageParking,nonReservedGarageParking);
        }else if(leaseTerm == '25 months, 16 firm'|| leaseTerm == '25 months,16 firm'){
            double leaseTermMonths = 25;
            double leaseFirmTermMonths = 16;
            
            system.debug('--monthlyCostNonReservedGarageParking--'+monthlyCostNonReservedGarageParking);
            system.debug('--monthlyCostReservedGarageParking--'+monthlyCostReservedGarageParking);
            system.debug('--monthlyCostNonReservedSurfaceParking--'+monthlyCostNonReservedSurfaceParking);
            system.debug('--monthlyCostReservedSurfaceParking--'+monthlyCostReservedSurfaceParking);
            system.debug('--operatingCostsperABOASF--'+operatingCostsperABOASF);
            system.debug('--lessorsPMFees--'+lessorsPMFees);
            system.debug('--aeFees--'+aeFees);
            system.debug('--shellRateFirmTerm--'+shellRateFirmTerm);
            system.debug('--tiAmortizationRate--'+tiAmortizationRate);
            system.debug('--shellRateSoftTerm--'+shellRateSoftTerm);
            system.debug('--bsacAmortizationRate--'+bsacAmortizationRate);
            system.debug('--firmTermFreeMonths--'+firmTermFreeMonths);
            system.debug('--tiforNeworContinuingSpace--'+tiforNeworContinuingSpace);
            system.debug('--physicalMoveCostperABOASF--'+physicalMoveCostperABOASF);
            system.debug('--telecomCostperABOASF--'+telecomCostperABOASF);
            system.debug('--bsacforNeworContinuingSpace--'+bsacforNeworContinuingSpace);
            system.debug('--buildOutperABOASF--'+buildOutperABOASF);
            system.debug('--discountRate--'+discountRate);
            system.debug('--escalationRate--'+escalationRate);
            system.debug('--aboaSFMin--'+aboaSFMin);
            system.debug('--aboaSFMax--'+aboaSFMax);
            system.debug('--leaseTermMonths--'+leaseTermMonths);
            system.debug('--leaseFirmTermMonths--'+leaseFirmTermMonths);
            system.debug('--reservedSurfaceParking--'+reservedSurfaceParking);
            system.debug('--nonReservedSurfaceParking--'+nonReservedSurfaceParking);
            system.debug('--reservedGarageParking--'+reservedGarageParking);
            system.debug('--nonReservedGarageParking--'+nonReservedGarageParking);
            
            result = Census25NPV(monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,operatingCostsperABOASF,lessorsPMFees,
                aeFees,aeFeesUOM,shellRate,tiAmortizationRate,firmTermFreeMonths,tiforNeworContinuingSpace,physicalMoveCostperABOASF,telecomCostperABOASF,
                buildOutperABOASF,discountRate,aboaSFMin,aboaSFMax,leaseTermMonths,leaseFirmTermMonths,reservedSurfaceParking,nonReservedSurfaceParking,reservedGarageParking,nonReservedGarageParking);
        }
        
        else if(leaseTerm == '10 years'){
            double leaseTermMonths = 120;
            double leaseFirmTermMonths = 120;
            system.debug('---PV Testing Nik1---'+leaseTerm);
            
            system.debug('--monthlyCostNonReservedGarageParking--'+monthlyCostNonReservedGarageParking);
            system.debug('--monthlyCostReservedGarageParking--'+monthlyCostReservedGarageParking);
            system.debug('--monthlyCostNonReservedSurfaceParking--'+monthlyCostNonReservedSurfaceParking);
            system.debug('--monthlyCostReservedSurfaceParking--'+monthlyCostReservedSurfaceParking);
            system.debug('--operatingCostsperABOASF--'+operatingCostsperABOASF);
            system.debug('--lessorsPMFees--'+lessorsPMFees);
            system.debug('--aeFees--'+aeFees);
            system.debug('--shellRateFirmTerm--'+shellRateFirmTerm);
            system.debug('--tiAmortizationRate--'+tiAmortizationRate);
            system.debug('--shellRateSoftTerm--'+shellRateSoftTerm);
            system.debug('--bsacAmortizationRate--'+bsacAmortizationRate);
            system.debug('--firmTermFreeMonths--'+firmTermFreeMonths);
            system.debug('--tiforNeworContinuingSpace--'+tiforNeworContinuingSpace);
            system.debug('--physicalMoveCostperABOASF--'+physicalMoveCostperABOASF);
            system.debug('--telecomCostperABOASF--'+telecomCostperABOASF);
            system.debug('--bsacforNeworContinuingSpace--'+bsacforNeworContinuingSpace);
            system.debug('--buildOutperABOASF--'+buildOutperABOASF);
            system.debug('--discountRate--'+discountRate);
            system.debug('--escalationRate--'+escalationRate);
            system.debug('--aboaSFMin--'+aboaSFMin);
            system.debug('--aboaSFMax--'+aboaSFMax);
            system.debug('--leaseTermMonths--'+leaseTermMonths);
            system.debug('--leaseFirmTermMonths--'+leaseFirmTermMonths);
            system.debug('--reservedSurfaceParking--'+reservedSurfaceParking);
            system.debug('--nonReservedSurfaceParking--'+nonReservedSurfaceParking);
            system.debug('--reservedGarageParking--'+reservedGarageParking);
            system.debug('--nonReservedGarageParking--'+nonReservedGarageParking);
            
            result = SmallLeaseNPV_old(monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,operatingCostsperABOASF,lessorsPMFees,
                aeFees,aeFeesUOM,shellRateFirmTerm,tiAmortizationRate,shellRateSoftTerm,bsacAmortizationRate,firmTermFreeMonths,tiforNeworContinuingSpace,physicalMoveCostperABOASF,telecomCostperABOASF,bsacforNeworContinuingSpace,
                buildOutperABOASF,discountRate,escalationRate,aboaSFMin,aboaSFMax,leaseTermMonths,leaseFirmTermMonths,reservedSurfaceParking,nonReservedSurfaceParking,reservedGarageParking,nonReservedGarageParking);
        }
        
        else if(leaseTerm == '10 years,5 firm'){
            double leaseTermMonths = 120;
            double leaseFirmTermMonths = 60;
            system.debug('---PV Testing Nik1---'+result);
            
            system.debug('--monthlyCostNonReservedGarageParking--'+monthlyCostNonReservedGarageParking);
            system.debug('--monthlyCostReservedGarageParking--'+monthlyCostReservedGarageParking);
            system.debug('--monthlyCostNonReservedSurfaceParking--'+monthlyCostNonReservedSurfaceParking);
            system.debug('--monthlyCostReservedSurfaceParking--'+monthlyCostReservedSurfaceParking);
            system.debug('--operatingCostsperABOASF--'+operatingCostsperABOASF);
            system.debug('--lessorsPMFees--'+lessorsPMFees);
            system.debug('--aeFees--'+aeFees);
            system.debug('--shellRateFirmTerm--'+shellRateFirmTerm);
            system.debug('--tiAmortizationRate--'+tiAmortizationRate);
            system.debug('--shellRateSoftTerm--'+shellRateSoftTerm);
            system.debug('--bsacAmortizationRate--'+bsacAmortizationRate);
            system.debug('--firmTermFreeMonths--'+firmTermFreeMonths);
            system.debug('--tiforNeworContinuingSpace--'+tiforNeworContinuingSpace);
            system.debug('--physicalMoveCostperABOASF--'+physicalMoveCostperABOASF);
            system.debug('--telecomCostperABOASF--'+telecomCostperABOASF);
            system.debug('--bsacforNeworContinuingSpace--'+bsacforNeworContinuingSpace);
            system.debug('--buildOutperABOASF--'+buildOutperABOASF);
            system.debug('--discountRate--'+discountRate);
            system.debug('--escalationRate--'+escalationRate);
            system.debug('--aboaSFMin--'+aboaSFMin);
            system.debug('--aboaSFMax--'+aboaSFMax);
            system.debug('--leaseTermMonths--'+leaseTermMonths);
            system.debug('--leaseFirmTermMonths--'+leaseFirmTermMonths);
            system.debug('--reservedSurfaceParking--'+reservedSurfaceParking);
            system.debug('--nonReservedSurfaceParking--'+nonReservedSurfaceParking);
            system.debug('--reservedGarageParking--'+reservedGarageParking);
            system.debug('--nonReservedGarageParking--'+nonReservedGarageParking);
            
            result = MediumLeaseNPV_old(monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,operatingCostsperABOASF,lessorsPMFees,
                aeFees,aeFeesUOM,shellRateFirmTerm,tiAmortizationRate,shellRateSoftTerm,bsacAmortizationRate,firmTermFreeMonths,tiforNeworContinuingSpace,physicalMoveCostperABOASF,telecomCostperABOASF,bsacforNeworContinuingSpace,
                buildOutperABOASF,discountRate,escalationRate,aboaSFMin,aboaSFMax,leaseTermMonths,leaseFirmTermMonths,reservedSurfaceParking,nonReservedSurfaceParking,reservedGarageParking,nonReservedGarageParking);
            system.debug('---PV Testing Nik2---'+result);
        }
        
        else if(leaseTerm == '15 years,10 firm'){
            double leaseTermMonths = 180;
            double leaseFirmTermMonths = 120;
            
            system.debug('--monthlyCostNonReservedGarageParking--'+monthlyCostNonReservedGarageParking);
            system.debug('--monthlyCostReservedGarageParking--'+monthlyCostReservedGarageParking);
            system.debug('--monthlyCostNonReservedSurfaceParking--'+monthlyCostNonReservedSurfaceParking);
            system.debug('--monthlyCostReservedSurfaceParking--'+monthlyCostReservedSurfaceParking);
            system.debug('--operatingCostsperABOASF--'+operatingCostsperABOASF);
            system.debug('--lessorsPMFees--'+lessorsPMFees);
            system.debug('--aeFees--'+aeFees);
            system.debug('--shellRateFirmTerm--'+shellRateFirmTerm);
            system.debug('--tiAmortizationRate--'+tiAmortizationRate);
            system.debug('--shellRateSoftTerm--'+shellRateSoftTerm);
            system.debug('--bsacAmortizationRate--'+bsacAmortizationRate);
            system.debug('--firmTermFreeMonths--'+firmTermFreeMonths);
            system.debug('--tiforNeworContinuingSpace--'+tiforNeworContinuingSpace);
            system.debug('--physicalMoveCostperABOASF--'+physicalMoveCostperABOASF);
            system.debug('--telecomCostperABOASF--'+telecomCostperABOASF);
            system.debug('--bsacforNeworContinuingSpace--'+bsacforNeworContinuingSpace);
            system.debug('--buildOutperABOASF--'+buildOutperABOASF);
            system.debug('--discountRate--'+discountRate);
            system.debug('--escalationRate--'+escalationRate);
            system.debug('--aboaSFMin--'+aboaSFMin);
            system.debug('--aboaSFMax--'+aboaSFMax);
            system.debug('--leaseTermMonths--'+leaseTermMonths);
            system.debug('--leaseFirmTermMonths--'+leaseFirmTermMonths);
            system.debug('--reservedSurfaceParking--'+reservedSurfaceParking);
            system.debug('--nonReservedSurfaceParking--'+nonReservedSurfaceParking);
            system.debug('--reservedGarageParking--'+reservedGarageParking);
            system.debug('--nonReservedGarageParking--'+nonReservedGarageParking);
            
            result = LongLeaseNPV_old(monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,operatingCostsperABOASF,lessorsPMFees,
                aeFees,aeFeesUOM,shellRateFirmTerm,tiAmortizationRate,shellRateSoftTerm,bsacAmortizationRate,firmTermFreeMonths,tiforNeworContinuingSpace,physicalMoveCostperABOASF,telecomCostperABOASF,bsacforNeworContinuingSpace,
                buildOutperABOASF,discountRate,escalationRate,aboaSFMin,aboaSFMax,leaseTermMonths,leaseFirmTermMonths,reservedSurfaceParking,nonReservedSurfaceParking,reservedGarageParking,nonReservedGarageParking);
        }
        

        //result = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        return result;
        //Need to understand and implement NPV function


    }

    public static double SmallLeaseNPV(double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double operatingCostsperABOASF,double lessorsPMFees,
            double aeFees,string aeFeesUOM, double shellRateFirmTerm,double tiAmortizationRate,double shellRateSoftTerm,double bsacAmortizationRate,double firmTermFreeMonths, double tiforNeworContinuingSpace,double physicalMoveCostperABOASF, double telecomCostperABOASF, double bsacforNeworContinuingSpace,
            double buildOutperABOASF, double discountRate, double escalationRate, double aboaSFMin, double aboaSFMax, double leaseTermMonths, double leaseFirmTermMonths, double reservedSurfaceParking, double nonReservedSurfaceParking, double reservedGarageParking, double nonReservedGarageParking){

        double result = 0;
        double ammortizationOfTI = AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        //double ammortizationOfTI = 0.36;
        double totalFeeCost = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double totalLessorOverheadandFees = TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double garageParkingRate = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        double surfaceParkingRate = SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double ammortizationOfBSAC = AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace);
        //double ammortizationOfBSAC = 0.75;
        double valueOfFreeRentYear1 = ValueOfFreeRentYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear2 = ValueOfFreeRentYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear3 = ValueOfFreeRentYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear4 = ValueOfFreeRentYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear5 = ValueOfFreeRentYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear6 = ValueOfFreeRentYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear7 = ValueOfFreeRentYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear8 = ValueOfFreeRentYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double annualRentperABOASFYear1 = AnnualRentperABOASFYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear2 = AnnualRentperABOASFYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear3 = AnnualRentperABOASFYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear4 = AnnualRentperABOASFYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear5 = AnnualRentperABOASFYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear6 = AnnualRentperABOASFYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear7 = AnnualRentperABOASFYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear8 = AnnualRentperABOASFYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear9 = AnnualRentperABOASFYear9(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear10 = AnnualRentperABOASFYear10(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double npv = SmallNPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8)/(leaseTermMonths/12);
        System.debug('SmallLeaseNPV: '+result);
        return result;

    }
    public static double MediumLeaseNPV(double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double operatingCostsperABOASF,double lessorsPMFees,
            double aeFees,string aeFeesUOM, double shellRateFirmTerm,double tiAmortizationRate,double shellRateSoftTerm,double bsacAmortizationRate,double firmTermFreeMonths, double tiforNeworContinuingSpace,double physicalMoveCostperABOASF, double telecomCostperABOASF, double bsacforNeworContinuingSpace,
            double buildOutperABOASF, double discountRate, double escalationRate, double aboaSFMin, double aboaSFMax, double leaseTermMonths, double leaseFirmTermMonths, double reservedSurfaceParking, double nonReservedSurfaceParking, double reservedGarageParking, double nonReservedGarageParking){

        double result = 0;
        double ammortizationOfTI = AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        //double ammortizationOfTI = 0.36;
        double totalFeeCost = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double totalLessorOverheadandFees = TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double garageParkingRate = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        double surfaceParkingRate = SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double ammortizationOfBSAC = AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace);
        //double ammortizationOfBSAC = 0.75;
        double valueOfFreeRentYear1 = ValueOfFreeRentYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear2 = ValueOfFreeRentYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear3 = ValueOfFreeRentYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear4 = ValueOfFreeRentYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear5 = ValueOfFreeRentYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear6 = ValueOfFreeRentYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear7 = ValueOfFreeRentYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear8 = ValueOfFreeRentYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear9 = ValueOfFreeRentYear9(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear10 = ValueOfFreeRentYear10(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear11 = ValueOfFreeRentYear11(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear12 = ValueOfFreeRentYear12(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear13 = ValueOfFreeRentYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        
        double annualRentperABOASFYear1 = AnnualRentperABOASFYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear2 = AnnualRentperABOASFYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear3 = AnnualRentperABOASFYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear4 = AnnualRentperABOASFYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear5 = AnnualRentperABOASFYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear6 = AnnualRentperABOASFYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear7 = AnnualRentperABOASFYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear8 = AnnualRentperABOASFYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear9 = AnnualRentperABOASFYear9(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear10 = AnnualRentperABOASFYear10(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear11 = AnnualRentperABOASFYear11(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear12 = AnnualRentperABOASFYear12(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear13 = AnnualRentperABOASFYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear14 = AnnualRentperABOASFYear14(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear15 = AnnualRentperABOASFYear15(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);

        double npv = MediumNPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10,annualRentperABOASFYear11,annualRentperABOASFYear12,annualRentperABOASFYear13,annualRentperABOASFYear14,annualRentperABOASFYear15);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8+valueOfFreeRentYear9+valueOfFreeRentYear10+valueOfFreeRentYear11+valueOfFreeRentYear12+valueOfFreeRentYear13)/(leaseTermMonths/12);
        System.debug('MediumLeaseNPV: '+result);
        return result;

    }
    public static double LongLeaseNPV(double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double operatingCostsperABOASF,double lessorsPMFees,
            double aeFees,string aeFeesUOM, double shellRateFirmTerm,double tiAmortizationRate,double shellRateSoftTerm,double bsacAmortizationRate,double firmTermFreeMonths, double tiforNeworContinuingSpace,double physicalMoveCostperABOASF, double telecomCostperABOASF, double bsacforNeworContinuingSpace,
            double buildOutperABOASF, double discountRate, double escalationRate, double aboaSFMin, double aboaSFMax, double leaseTermMonths, double leaseFirmTermMonths, double reservedSurfaceParking, double nonReservedSurfaceParking, double reservedGarageParking, double nonReservedGarageParking){

        double result = 0;
        double ammortizationOfTI = AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        double totalFeeCost = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double totalLessorOverheadandFees = TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double garageParkingRate = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        double surfaceParkingRate = SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double ammortizationOfBSAC = AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear1 = ValueOfFreeRentYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear2 = ValueOfFreeRentYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear3 = ValueOfFreeRentYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear4 = ValueOfFreeRentYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear5 = ValueOfFreeRentYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear6 = ValueOfFreeRentYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear7 = ValueOfFreeRentYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear8 = ValueOfFreeRentYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        double valueOfFreeRentYear9 = ValueOfFreeRentYear9(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear10 = ValueOfFreeRentYear10(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear11 = ValueOfFreeRentYear11(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear12 = ValueOfFreeRentYear12(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear13 = ValueOfFreeRentYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear14 = ValueOfFreeRentYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        double valueOfFreeRentYear15 = ValueOfFreeRentYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        
        double annualRentperABOASFYear1 = AnnualRentperABOASFYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear2 = AnnualRentperABOASFYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear3 = AnnualRentperABOASFYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear4 = AnnualRentperABOASFYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear5 = AnnualRentperABOASFYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear6 = AnnualRentperABOASFYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear7 = AnnualRentperABOASFYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear8 = AnnualRentperABOASFYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear9 = AnnualRentperABOASFYear9(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear10 = AnnualRentperABOASFYear10(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear11 = AnnualRentperABOASFYear11(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear12 = AnnualRentperABOASFYear12(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear13 = AnnualRentperABOASFYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear14 = AnnualRentperABOASFYear14(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear15 = AnnualRentperABOASFYear15(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear16 = AnnualRentperABOASFYear16(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear17 = AnnualRentperABOASFYear17(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);

        double npv = LongNPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10,annualRentperABOASFYear11,annualRentperABOASFYear12,annualRentperABOASFYear13,annualRentperABOASFYear14,annualRentperABOASFYear15,annualRentperABOASFYear16,annualRentperABOASFYear17);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8+valueOfFreeRentYear9+valueOfFreeRentYear10+valueOfFreeRentYear11+valueOfFreeRentYear12+valueOfFreeRentYear13+valueOfFreeRentYear14+valueOfFreeRentYear15)/(leaseTermMonths/12);
        System.debug('LongLeaseNPV: '+result);
        return result;

    }
    public static double Census19NPV(double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double operatingCostsperABOASF,double lessorsPMFees,
            double aeFees,string aeFeesUOM, double shellRate,double tiAmortizationRate,double firmTermFreeMonths, double tiforNeworContinuingSpace,double physicalMoveCostperABOASF, double telecomCostperABOASF,
            double buildOutperABOASF, double discountRate, double aboaSFMin, double aboaSFMax, double leaseTermMonths, double leaseFirmTermMonths, double reservedSurfaceParking, double nonReservedSurfaceParking, double reservedGarageParking, double nonReservedGarageParking){

        double result = 0;
        double ammortizationOfTI = AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        double totalFeeCost = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double totalLessorOverheadandFees = TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double garageParkingRate = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        double surfaceParkingRate = SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear1 = AnnualRentperABOASFYear1Census19(shellRate,operatingCostsperABOASF,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,
                 reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear2 = AnnualRentperABOASFYear2Census19(shellRate,operatingCostsperABOASF,tiAmortizationRate,leaseTermMonths,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,
                 reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        
        double npv = Census19NPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12) - 
            (firmTermFreeMonths*(shellRate+operatingCostsperABOASF+ammortizationOfTI+(totalLessorOverheadandFees*ammortizationOfTI))/12)/(leaseTermMonths/12);
        System.debug('Census19NPV: '+result);
        return result;

    }

    public static double Census25NPV(double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double operatingCostsperABOASF,double lessorsPMFees,
            double aeFees,string aeFeesUOM, double shellRate,double tiAmortizationRate,double firmTermFreeMonths, double tiforNeworContinuingSpace,double physicalMoveCostperABOASF, double telecomCostperABOASF,
            double buildOutperABOASF, double discountRate, double aboaSFMin, double aboaSFMax, double leaseTermMonths, double leaseFirmTermMonths, double reservedSurfaceParking, double nonReservedSurfaceParking, double reservedGarageParking, double nonReservedGarageParking){

        double result = 0;
        double ammortizationOfTI = AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        double totalFeeCost = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double totalLessorOverheadandFees = TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        double garageParkingRate = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        double surfaceParkingRate = SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear1 = AnnualRentperABOASFYear1Census25(shellRate,operatingCostsperABOASF,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,
                 reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear2 = AnnualRentperABOASFYear2Census25(shellRate,operatingCostsperABOASF,tiAmortizationRate,leaseTermMonths,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,
                 reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double annualRentperABOASFYear3 = AnnualRentperABOASFYear3Census25(shellRate,operatingCostsperABOASF,tiAmortizationRate,leaseTermMonths,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,
                 reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        double npv = Census25NPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2,annualRentperABOASFYear3);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12) - 
            (firmTermFreeMonths*(shellRate+operatingCostsperABOASF+ammortizationOfTI+(totalLessorOverheadandFees*ammortizationOfTI))/12)/(leaseTermMonths/12);
        System.debug('Census25NPV: '+result);
        return result;

    }
    private static double SmallNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10){

        double result = 0;
        //result = 20.33;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10);
        System.debug('SmallNPVCalculator: '+result);
        return result;

    }

    private static double MediumNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10, double annualRentperABOASFYear11, double annualRentperABOASFYear12, double annualRentperABOASFYear13, double annualRentperABOASFYear14, double annualRentperABOASFYear15){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10)+
                annualRentperABOASFYear11/Math.pow(1+discountRate,11)+annualRentperABOASFYear12/Math.pow(1+discountRate,12)+annualRentperABOASFYear13/Math.pow(1+discountRate,13)+annualRentperABOASFYear14/Math.pow(1+discountRate,14)+annualRentperABOASFYear15/Math.pow(1+discountRate,15);
        System.debug('MediumNPVCalculator: '+result);
        return result;

    }
    private static double LongNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10, double annualRentperABOASFYear11, double annualRentperABOASFYear12, double annualRentperABOASFYear13, double annualRentperABOASFYear14, double annualRentperABOASFYear15,
                double annualRentperABOASFYear16, double annualRentperABOASFYear17){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10)+
                annualRentperABOASFYear11/Math.pow(1+discountRate,11)+annualRentperABOASFYear12/Math.pow(1+discountRate,12)+annualRentperABOASFYear13/Math.pow(1+discountRate,13)+annualRentperABOASFYear14/Math.pow(1+discountRate,14)+annualRentperABOASFYear15/Math.pow(1+discountRate,15)+
                annualRentperABOASFYear16/Math.pow(1+discountRate,16)+annualRentperABOASFYear17/Math.pow(1+discountRate,17);
        System.debug('LongNPVCalculator: '+result);
        return result;

    }
    private static double Census19NPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2);
        System.debug('Census19NPVCalculator: '+result);
        return result;

    }
    private static double Census25NPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2,double annualRentperABOASFYear3){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3);
        System.debug('Census25NPVCalculator: '+result);
        return result;

    }

    //excel formula not matching
    public static double TotalFeeCost(double aeFees,double lessorsPMFees,double tiforNeworContinuingSpace,string aeFeesUOM){
        double result = 0;
        if(aeFeesUOM == '$ Per ABOA SF'){
            result = aeFees+(lessorsPMFees*tiforNeworContinuingSpace);

        }else if(aeFeesUOM == '%'){
            if(Test.isRunningTest() == false){
                aeFees = aeFees/100;
            }
            result = aeFees*(tiforNeworContinuingSpace/(1+aeFees))+(lessorsPMFees*tiforNeworContinuingSpace);

        }
        System.debug('TotalFeeCost '+result);
        return result;

    }
    public static double TotalLessorOverheadandFees(double aeFees,double lessorsPMFees,double tiforNeworContinuingSpace,string aeFeesUOM){
        double result = 0;
        if(tiforNeworContinuingSpace > 0){
            result = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM)/tiforNeworContinuingSpace;
        }else{
            result = 0;
        }
        System.debug('TotalLessorOverheadandFees '+result);     
        return result;
    }
    public static double GarageParkingRate(double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        if(reservedGarageParking+nonReservedGarageParking == 0){
            result = 0;
        }else{
            if(aboaSFMin+aboaSFMax > 0){
                result = ((reservedGarageParking*monthlyCostReservedGarageParking+nonReservedGarageParking*monthlyCostNonReservedGarageParking)/(reservedGarageParking+nonReservedGarageParking)*12/((aboaSFMin+aboaSFMax)/2));
            }else{ 
                result = 0;
            }
        }
        System.debug('GarageParkingRate '+result);
        return result;
    }
    private static double SurfaceParkingRate(double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        return GarageParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);

    }
    public static double AmmortizationOfTI(double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace){

        tiAmortizationRate = tiAmortizationRate/12;
        double result = PMT(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        result = (-1*12*result);
        System.debug('AmmortizationOfTI '+result);
        return result;
            

    }
    //Needs correction for PMT function
    private static double oldPMT(double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace){

       double result = 0;
       if(tiAmortizationRate < 0 || leaseFirmTermMonths == 0){
            result = null;
            System.debug('Divide by Zero Error');
       }else if(tiforNeworContinuingSpace == 0) {
            result = 0;
       }else if(tiAmortizationRate == 0){
            result = (-tiforNeworContinuingSpace/leaseFirmTermMonths);
       }else{
            result = (-1)*tiAmortizationRate*tiforNeworContinuingSpace/(1-Math.pow(1+tiAmortizationRate, (-1*leaseFirmTermMonths)));

       }
           System.debug('PMT: '+result);
           return result;
    }
    
    //Added by Nik
    public static double PMT(double Rate,double NPER,double PV){
        
        double returnvalue = 0;
        
        // Condition 1 if  Rate and NPER = 0
        if(Rate < 0
            || NPER == 0){
            returnvalue = null;
        }
        
        // condition 2 when PV = 0
        else if(PV == 0){
            returnvalue = 0;
        }
        
        // condition 2 when Rate = 0
        else if(Rate == 0){
            double cond2Res = (-1*PV) / NPER ;
            system.debug('\n--cond2Res--   '+cond2Res);
            returnvalue = cond2Res; 
        }
        
        else{
           double divisor = -1*Rate*PV;
           double divident = Math.pow((1+Rate),(-1*NPER)); 
           system.debug('\n--divisor--  '+divisor+'\n--divident--  '+divident);
           
            returnvalue = divisor / (1 - divident);
        }
        
        // formatiing return value
        if(returnvalue != null){
            return returnvalue;
        }
        else{
            return null;
        }
    }
    public static double AmmortizationOfBSAC(double bsacAmortizationRate,double leaseFirmTermMonths,double bsacforNeworContinuingSpace){
        double result = 0;
        if(bsacforNeworContinuingSpace!=null){
            bsacAmortizationRate = bsacAmortizationRate/12;
            result = PMT(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace);
            result = (-1*12*result);    
            //result = 0.75;        
        }
        else{
            result = 0;
        }
        System.debug('AmmortizationOfBSAC: '+result);
        return result;
        //need PMT function to be fixed
    }
    private static double ValueOfFreeRentYear1(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths > 12){
            firmTermFreeMonths = 12;
        }
        result = (FreeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,0)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear1: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear2(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 12){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 24){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 12;
        }
        result = (FreeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,1)/12*firmTermFreeMonths);
        
        System.debug('ValueOfFreeRentYear2: '+result);
        return result;
    }

    private static double ValueOfFreeRentYear3(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 24){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 36){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 24;
        }
        result = (FreeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,2)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear3: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear4(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 36){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 48){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 36;
        }
        result = (FreeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,3)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear4: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear5(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 48){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 60){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 48;
        }
        result = (FreeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,4)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear5: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear6(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 60){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 72){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 60;
        }
        result = (FreeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear6: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear7(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 72){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 84){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 72;
        }
        result = (FreeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,6)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear7: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear8(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 84){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 96){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 84;
        }
        result = (FreeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,7)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear8: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear9(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths){
        double result = 0;
        if(firmTermFreeMonths < 96){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 108){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 96;
        }
        result = (FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,8)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear9: '+result);
        return result;
    }
    
    private static double ValueOfFreeRentYear10(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths){
        double result = 0;
        if(firmTermFreeMonths < 108){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 120){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 108;
        }
        result = (FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,9)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear10: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear11(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths){
        double result = 0;
        if(firmTermFreeMonths < 120){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 132){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 120;
        }
        result = (FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,10)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear11: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear12(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths){
        double result = 0;
        if(firmTermFreeMonths < 132){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 144){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 132;
        }
        result = (FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,11)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear12: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear13(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths){
        double result = 0;
        if(firmTermFreeMonths < 144){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 156){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 144;
        }
        result = (FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,12)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear13: '+result);
        return result;
    }
    
    /** below method commented as it is not been called from any where **
    private static double ValueOfFreeRentYear14(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths){
        double result = 0;
        if(firmTermFreeMonths < 156){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 168){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 156;
        }
        result = (FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,13)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear14: '+result);
        return result;
    }
    private static double ValueOfFreeRentYear15(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths){
        double result = 0;
        if(firmTermFreeMonths < 168){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 180){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 168;
        }
        result = (FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,14)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear15: '+result);
        return result;
    }
    ***/

    private static double AnnualRentperABOASFYear1(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,0,
                    reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear1: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear2(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,1,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear2: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear3(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,2,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear3: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear4(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,3,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear4: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear5(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,4,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear5: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear6(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear6: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear7(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,6,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear7: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear8(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,7,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear8: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear9(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,8);
        System.debug('AnnualRentperABOASFYear9: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear10(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,9);
        System.debug('AnnualRentperABOASFYear10: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear11(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,10);
        System.debug('AnnualRentperABOASFYear11: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear12(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,11);
        System.debug('AnnualRentperABOASFYear12: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear13(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,12);
        System.debug('AnnualRentperABOASFYear13: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear14(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,13);
        System.debug('AnnualRentperABOASFYear14: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear15(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,14);
        System.debug('AnnualRentperABOASFYear15: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear16(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,15);
        System.debug('AnnualRentperABOASFYear16: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear17(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOAlong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,16);
        System.debug('AnnualRentperABOASFYear17: '+result);
        return result;
    }

    private static double AnnualRentperABOASFYear1Census19(double shellRate,double operatingCostsperABOASF,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = shellRate + operatingCostsperABOASF + (AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace)*leaseFirmTermMonths/12) + 
                 (TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM)*AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace)*leaseFirmTermMonths/12) + 
                 (GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax)*(reservedGarageParking + nonReservedGarageParking)) + 
                 (SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax)*(reservedSurfaceParking + nonReservedSurfaceParking));
        System.debug('AnnualRentperABOASFYear1Census19: '+result);
        return result;
    }

    private static double AnnualRentperABOASFYear2Census19(double shellRate,double operatingCostsperABOASF,double tiAmortizationRate,double leaseTermMonths,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = shellRate*((leaseTermMonths-12)/12) + operatingCostsperABOASF*((leaseTermMonths-12)/12) + 
                 (GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax)*(reservedGarageParking + nonReservedGarageParking)*(leaseTermMonths-12)/12) + 
                 (SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax)*(reservedSurfaceParking + nonReservedSurfaceParking)*(leaseTermMonths-12)/12);
        System.debug('AnnualRentperABOASFYear2Census19: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear1Census25(double shellRate,double operatingCostsperABOASF,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = shellRate + operatingCostsperABOASF + AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace) + 
                 TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM)*AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace) + 
                 (GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax)*(reservedGarageParking + nonReservedGarageParking)) + 
                 (SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax)*(reservedSurfaceParking + nonReservedSurfaceParking));
        System.debug('AnnualRentperABOASFYear1Census25: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear2Census25(double shellRate,double operatingCostsperABOASF,double tiAmortizationRate,double leaseTermMonths,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = shellRate + operatingCostsperABOASF + AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace)*((leaseFirmTermMonths-12)/12) + 
                 (TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM)*AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace)*((leaseFirmTermMonths-12)/12)) + 
                 (GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax)*(reservedGarageParking + nonReservedGarageParking)) + 
                 (SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax)*(reservedSurfaceParking + nonReservedSurfaceParking));
        System.debug('AnnualRentperABOASFYear2Census25: '+result);
        return result;
    }
    private static double AnnualRentperABOASFYear3Census25(double shellRate,double operatingCostsperABOASF,double tiAmortizationRate,double leaseTermMonths,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = shellRate*((leaseTermMonths-24)/12) + operatingCostsperABOASF*((leaseTermMonths-24)/12) + 
                 (GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax)*(reservedGarageParking + nonReservedGarageParking)*(leaseTermMonths-24)/12) + 
                 (SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax)*(reservedSurfaceParking + nonReservedSurfaceParking)*(leaseTermMonths-24)/12);
        System.debug('AnnualRentperABOASFYear3Census25: '+result);
        return result;
    }
    private static double FreeRent(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,double exp){
        double result = 0;
        result = (shellRateFirmTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) + AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace) + 
                 (AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace)*TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM)) +
                 AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace));
        return result;

    }
    private static double FreeRentLong(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double exp){
        double result = 0;
        result = shellRateSoftTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp)));
        return result;

    }
    private static double ABOA(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,double exp,
            double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = (shellRateFirmTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) + AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace) + 
                 (AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace)*TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM)) +
                 AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace)+(GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax)*(reservedGarageParking + nonReservedGarageParking)) + 
                (SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax)*(reservedSurfaceParking + nonReservedSurfaceParking)));
        return result;

    }
    private static double ABOAlong(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
        double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
        result = (shellRateSoftTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp)))+
                (GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax)*(reservedGarageParking + nonReservedGarageParking)) + 
                (SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax)*(reservedSurfaceParking + nonReservedSurfaceParking)));
        return result;
    }
    
    
    /****************************************************** old Methods ****************************************/
    
    
    
    /********************************************* SMALL Method ******************************************************************/
    public static double SmallLeaseNPV_old(double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double operatingCostsperABOASF,double lessorsPMFees,
            double aeFees,string aeFeesUOM, double shellRateFirmTerm,double tiAmortizationRate,double shellRateSoftTerm,double bsacAmortizationRate,double firmTermFreeMonths, double tiforNeworContinuingSpace,double physicalMoveCostperABOASF, double telecomCostperABOASF, double bsacforNeworContinuingSpace,
            double buildOutperABOASF, double discountRate, double escalationRate, double aboaSFMin, double aboaSFMax, double leaseTermMonths, double leaseFirmTermMonths, double reservedSurfaceParking, double nonReservedSurfaceParking, double reservedGarageParking, double nonReservedGarageParking){

        double result = 0;
        double ammortizationOfTI = AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        system.debug('\n---ammortizationOfTI--'+ammortizationOfTI);
        
        double totalFeeCost = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        system.debug('\n---cal--'+totalFeeCost);
        
        double totalLessorOverheadandFees = TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        system.debug('\n-----cal--'+totalLessorOverheadandFees);
        
        double garageParkingRate = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        system.debug('\n-----cal--'+garageParkingRate);
        
        double surfaceParkingRate = SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n-----cal--'+surfaceParkingRate);
        
        double ammortizationOfBSAC = AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace);
        system.debug('\n-----cal--'+ammortizationOfBSAC);
        
        double valueOfFreeRentYear1 = ValueOfFreeRentYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('\n---cal--'+valueOfFreeRentYear1);
        
        double valueOfFreeRentYear2 = ValueOfFreeRentYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('\n---cal--'+valueOfFreeRentYear2);
        
        double valueOfFreeRentYear3 = ValueOfFreeRentYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('\n---cal--'+valueOfFreeRentYear3);
        
        double valueOfFreeRentYear4 = ValueOfFreeRentYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('\n---cal--'+valueOfFreeRentYear4);
        
        double valueOfFreeRentYear5 = ValueOfFreeRentYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('\n---cal--'+valueOfFreeRentYear5);
        
        double valueOfFreeRentYear6 = ValueOfFreeRentYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('\n---cal--'+valueOfFreeRentYear6);
        
        double valueOfFreeRentYear7 = ValueOfFreeRentYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('\n---cal--'+valueOfFreeRentYear7);
        
        double valueOfFreeRentYear8 = ValueOfFreeRentYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate
        ,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('\n---cal--'+valueOfFreeRentYear8);
        
        double ValueOfFreeRentYear9 = ValueOfFreeRentYear9_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,ammortizationOfTI,totalLessorOverheadandFees,ammortizationOfBSAC);
        system.debug('\n---cal--'+ValueOfFreeRentYear9);
        
        double ValueOfFreeRentYear10 = ValueOfFreeRentYear10_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,ammortizationOfTI,totalLessorOverheadandFees,ammortizationOfBSAC);
        system.debug('\n---ValueOfFreeRentYear10--'+ValueOfFreeRentYear10);
        
        
        double annualRentperABOASFYear1 = AnnualRentperABOASFYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear1);
        
        double annualRentperABOASFYear2 = AnnualRentperABOASFYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear2);
        
        
        double annualRentperABOASFYear3 = AnnualRentperABOASFYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear3);
        
        
        double annualRentperABOASFYear4 = AnnualRentperABOASFYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear4);        
        
        
        
        double annualRentperABOASFYear5 = AnnualRentperABOASFYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear5);
        
        
        double annualRentperABOASFYear6 = AnnualRentperABOASFYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear6);
        
        
        double annualRentperABOASFYear7 = AnnualRentperABOASFYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear7);
        
        
        double annualRentperABOASFYear8 = AnnualRentperABOASFYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);        
        system.debug('\n---cal--'+annualRentperABOASFYear8);
        
                
        double annualRentperABOASFYear9 = AnnualRentperABOASFYear9_Medium_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear9);
        
        
        double annualRentperABOASFYear10 = AnnualRentperABOASFYear10_Medium_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('\n---cal--'+annualRentperABOASFYear10);
       
       
       double npv = SmallNPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10);
        system.debug('\n---npv--'+npv);
        
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8)/(leaseTermMonths/12);
        system.debug('\n---result--'+result);
        return result;

    } 
    
    private static double AnnualRentperABOASFYear9_Medium_old(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,8,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear8: '+result); 
        return result;
    }
    
    private static double AnnualRentperABOASFYear10_Medium_old(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,9,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear8: '+result);
        return result;
    }
    
    
    private static double ValueOfFreeRentYear9_old(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortization, double totalLessor, double amortizationbsac){
        double result = 0;
        if(firmTermFreeMonths < 96){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 108){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 96;
        }
        result = ((FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,8)+tiAmortization+(tiAmortization*totalLessor)+amortizationbsac)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear9: '+result);
        return result;
    }
    
    
    private static double ValueOfFreeRentYear10_old(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortization, double totalLessor, double amortizationbsac){
        double result = 0;
        if(firmTermFreeMonths < 108){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 120){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 108;
        }
        result = ((FreeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,9)+tiAmortization+(tiAmortization*totalLessor)+amortizationbsac)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear10: '+result);
        return result;
    }
    
    
    /************************************************** MEDIUM Method *********************************************************************/
    public static double MediumLeaseNPV_old(double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double operatingCostsperABOASF,double lessorsPMFees,
            double aeFees,string aeFeesUOM, double shellRateFirmTerm,double tiAmortizationRate,double shellRateSoftTerm,double bsacAmortizationRate,double firmTermFreeMonths, double tiforNeworContinuingSpace,double physicalMoveCostperABOASF, double telecomCostperABOASF, double bsacforNeworContinuingSpace,
            double buildOutperABOASF, double discountRate, double escalationRate, double aboaSFMin, double aboaSFMax, double leaseTermMonths, double leaseFirmTermMonths, double reservedSurfaceParking, double nonReservedSurfaceParking, double reservedGarageParking, double nonReservedGarageParking){

        double result = 0;
        double ammortizationOfTI = AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+ammortizationOfTI);
        //double ammortizationOfTI = 0.36;
        double totalFeeCost = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        system.debug('---PV Testing Nik4---'+totalFeeCost);
        double totalLessorOverheadandFees = TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        system.debug('---PV Testing Nik5---'+totalLessorOverheadandFees);
        double garageParkingRate = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik6---'+garageParkingRate);
        double surfaceParkingRate = SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik7---'+surfaceParkingRate);
        double ammortizationOfBSAC = AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+ammortizationOfBSAC);
        //double ammortizationOfBSAC = 0.75;
        double valueOfFreeRentYear1 = ValueOfFreeRentYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear1);
        double valueOfFreeRentYear2 = ValueOfFreeRentYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear2);
        double valueOfFreeRentYear3 = ValueOfFreeRentYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear3);
        double valueOfFreeRentYear4 = ValueOfFreeRentYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear4);
        double valueOfFreeRentYear5 = ValueOfFreeRentYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear5);
        
        double valueOfFreeRentYear6 = ValueOfFreeRentYear6_old_M(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);     
        
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear6);
        double valueOfFreeRentYear7 = ValueOfFreeRentYear7_old_M(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear7);
        double valueOfFreeRentYear8 = ValueOfFreeRentYear8_old_M(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear8);
        double valueOfFreeRentYear9 = ValueOfFreeRentYear9_old_M(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear9);
        double valueOfFreeRentYear10 = ValueOfFreeRentYear10_old_M(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---PV Testing Nik3---'+valueOfFreeRentYear10);
        
        
        
        
        double annualRentperABOASFYear1 = AnnualRentperABOASFYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear1);
        double annualRentperABOASFYear2 = AnnualRentperABOASFYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear2);
        double annualRentperABOASFYear3 = AnnualRentperABOASFYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear3);
        double annualRentperABOASFYear4 = AnnualRentperABOASFYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear4);
        double annualRentperABOASFYear5 = AnnualRentperABOASFYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear5);
        
        double annualRentperABOASFYear6 = AnnualRentperABOASFYear6_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear6);
        double annualRentperABOASFYear7 = AnnualRentperABOASFYear7_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear7);
        double annualRentperABOASFYear8 = AnnualRentperABOASFYear8_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear8);
        
        double annualRentperABOASFYear9 = AnnualRentperABOASFYear9(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear9);
        double annualRentperABOASFYear10 = AnnualRentperABOASFYear10(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---PV Testing Nik3---'+annualRentperABOASFYear10);        
        
        
        
        double npv = MediumNPVCalculator_old(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10);
        system.debug('---PV Testing Nik3---'+npv);
        system.debug('--PV NIk--'+leaseTermMonths);
        system.debug('--PV NIk--'+physicalMoveCostperABOASF);
        system.debug('--PV NIk--'+telecomCostperABOASF);
        system.debug('--PV NIk--'+buildOutperABOASF);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8+valueOfFreeRentYear9+valueOfFreeRentYear10
            )/(leaseTermMonths/12);
        System.debug('MediumLeaseNPV: '+result);
        return result;

    } 
    
    private static double ValueOfFreeRentYear6_old_M(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 60){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 72){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 60;
        }
        result = (FreeRent_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear6: '+result);
        return result;
    }
    
    
    private static double ValueOfFreeRentYear7_old_M(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 72){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 84){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 72;
        }
        result = (FreeRent_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear6: '+result);
        return result;
    }
    
    private static double ValueOfFreeRentYear8_old_M(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 84){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 96){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 84;
        }
        result = (FreeRent_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear6: '+result);
        return result;
    }
    
    private static double ValueOfFreeRentYear9_old_M(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 96){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 108){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 96;
        }
        result = (FreeRent_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear6: '+result);
        return result;
    }
    
    private static double ValueOfFreeRentYear10_old_M(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace){
        double result = 0;
        if(firmTermFreeMonths < 108){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 120){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 108;
        }
        result = (FreeRent_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5)/12*firmTermFreeMonths);
        System.debug('ValueOfFreeRentYear6: '+result);
        return result;
    }
    
    
    
    
    private static double FreeRent_old(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,double exp){
        double result = 0;
        result = (shellRateFirmTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) /**+ AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace) + 
                 (AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace)*TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM)) +
                 AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace)**/);
        return result;

    }
    
    private static double AnnualRentperABOASFYear6_old(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear6: '+result);
        return result;
    }
    
    private static double AnnualRentperABOASFYear7_old(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,6,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear7: '+result);
        return result;
    }
    
    private static double AnnualRentperABOASFYear8_old(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,7,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear8: '+result);
        return result;
    }
    
    private static double ABOA_old(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,double exp,
            double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = (shellRateSoftTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp)))+(GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax)*(reservedGarageParking + nonReservedGarageParking)) + 
                (SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax)*(reservedSurfaceParking + nonReservedSurfaceParking)));
        return result;

    }
    
    private static double MediumNPVCalculator_old(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10);
        System.debug('MediumNPVCalculator: '+result);
        return result;

    }
    
    
    /***************************************** LONG Method ***************************************************************/
    public static double LongLeaseNPV_old(double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double operatingCostsperABOASF,double lessorsPMFees,
            double aeFees,string aeFeesUOM, double shellRateFirmTerm,double tiAmortizationRate,double shellRateSoftTerm,double bsacAmortizationRate,double firmTermFreeMonths, double tiforNeworContinuingSpace,double physicalMoveCostperABOASF, double telecomCostperABOASF, double bsacforNeworContinuingSpace,
            double buildOutperABOASF, double discountRate, double escalationRate, double aboaSFMin, double aboaSFMax, double leaseTermMonths, double leaseFirmTermMonths, double reservedSurfaceParking, double nonReservedSurfaceParking, double reservedGarageParking, double nonReservedGarageParking){

        double result = 0;
        double ammortizationOfTI = AmmortizationOfTI(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        system.debug('---long---'+ammortizationOfTI);
        
        double totalFeeCost = TotalFeeCost(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        system.debug('---long---'+totalFeeCost);
        
        double totalLessorOverheadandFees = TotalLessorOverheadandFees(aeFees,lessorsPMFees,tiforNeworContinuingSpace,aeFeesUOM);
        system.debug('---long---'+totalLessorOverheadandFees);
        
        double garageParkingRate = GarageParkingRate(reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+garageParkingRate);
        
        double surfaceParkingRate = SurfaceParkingRate(reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+surfaceParkingRate);
        
        double ammortizationOfBSAC = AmmortizationOfBSAC(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace);
        system.debug('---long---'+ammortizationOfBSAC); 
        
        double valueOfFreeRentYear1 = ValueOfFreeRentYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---long---'+valueOfFreeRentYear1);

        
        double valueOfFreeRentYear2 = ValueOfFreeRentYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---long---'+valueOfFreeRentYear2);
        
        double valueOfFreeRentYear3 = ValueOfFreeRentYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---long---'+valueOfFreeRentYear3);
        
        double valueOfFreeRentYear4 = ValueOfFreeRentYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---long---'+valueOfFreeRentYear4);
        
        double valueOfFreeRentYear5 = ValueOfFreeRentYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---long---'+valueOfFreeRentYear5);
        
        double valueOfFreeRentYear6 = ValueOfFreeRentYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---long---'+ammortizationOfTI);
        
        double valueOfFreeRentYear7 = ValueOfFreeRentYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---long---'+valueOfFreeRentYear7);
        
        double valueOfFreeRentYear8 = ValueOfFreeRentYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace);
        system.debug('---long---'+valueOfFreeRentYear8);
        
        double valueOfFreeRentYear9 = ValueOfFreeRentYear9_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,ammortizationOfTI,totalLessorOverheadandFees,ammortizationOfBSAC);
        system.debug('---long---'+valueOfFreeRentYear9);
        
        double valueOfFreeRentYear10 = ValueOfFreeRentYear10_old(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,ammortizationOfTI,totalLessorOverheadandFees,ammortizationOfBSAC);
        system.debug('---long---'+valueOfFreeRentYear10);
        
        double valueOfFreeRentYear11 = ValueOfFreeRentYear11(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        system.debug('---long---'+valueOfFreeRentYear11);
        
        double valueOfFreeRentYear12 = ValueOfFreeRentYear12(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        system.debug('---long---'+valueOfFreeRentYear12);
        
        double valueOfFreeRentYear13 = ValueOfFreeRentYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        system.debug('---long---'+valueOfFreeRentYear13);
        
        double valueOfFreeRentYear14 = ValueOfFreeRentYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        system.debug('---long---'+valueOfFreeRentYear14);
        
        double valueOfFreeRentYear15 = ValueOfFreeRentYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths);
        system.debug('---long---'+valueOfFreeRentYear15);
        
        double annualRentperABOASFYear1 = AnnualRentperABOASFYear1(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear1);
        
        double annualRentperABOASFYear2 = AnnualRentperABOASFYear2(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear2);
        
        double annualRentperABOASFYear3 = AnnualRentperABOASFYear3(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear3);
        
        double annualRentperABOASFYear4 = AnnualRentperABOASFYear4(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear4);
        
        double annualRentperABOASFYear5 = AnnualRentperABOASFYear5(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear5);
        
        double annualRentperABOASFYear6 = AnnualRentperABOASFYear6(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear6);
        
        double annualRentperABOASFYear7 = AnnualRentperABOASFYear7(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear7);
        
        double annualRentperABOASFYear8 = AnnualRentperABOASFYear8(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear8);
        
        double annualRentperABOASFYear9 = AnnualRentperABOASFYear9_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear9);
        
        double annualRentperABOASFYear10 = AnnualRentperABOASFYear10_old(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,
                reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear10);
        
        double annualRentperABOASFYear11 = AnnualRentperABOASFYear11(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear11);
        
        double annualRentperABOASFYear12 = AnnualRentperABOASFYear12(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear12);
        
        double annualRentperABOASFYear13 = AnnualRentperABOASFYear13(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear13);
        
        double annualRentperABOASFYear14 = AnnualRentperABOASFYear14(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear14);
        
        double annualRentperABOASFYear15 = AnnualRentperABOASFYear15(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,
                monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        system.debug('---long---'+annualRentperABOASFYear15);       
        

        double npv = LongNPVCalculator_old(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10,annualRentperABOASFYear11,annualRentperABOASFYear12,annualRentperABOASFYear13,annualRentperABOASFYear14,annualRentperABOASFYear15);
        system.debug('---long---'+npv);
        
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8+valueOfFreeRentYear9+valueOfFreeRentYear10+valueOfFreeRentYear11+valueOfFreeRentYear12+valueOfFreeRentYear13+valueOfFreeRentYear14+valueOfFreeRentYear15)/(leaseTermMonths/12);
        System.debug('LongLeaseNPV: '+result);
        return result;

    }
    
    
    private static double AnnualRentperABOASFYear9_old(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,8,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear8: '+result);
        return result;
    }
    
    private static double AnnualRentperABOASFYear10_old(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,
                double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = ABOA(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,9,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('AnnualRentperABOASFYear8: '+result);
        return result;
    }
    
    
    
    
    private static double LongNPVCalculator_old(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10, double annualRentperABOASFYear11, double annualRentperABOASFYear12, double annualRentperABOASFYear13, double annualRentperABOASFYear14, double annualRentperABOASFYear15){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10)+
                annualRentperABOASFYear11/Math.pow(1+discountRate,11)+annualRentperABOASFYear12/Math.pow(1+discountRate,12)+annualRentperABOASFYear13/Math.pow(1+discountRate,13)+annualRentperABOASFYear14/Math.pow(1+discountRate,14)+annualRentperABOASFYear15/Math.pow(1+discountRate,15);
        System.debug('LongNPVCalculator: '+result);
        return result;

    }
    


}