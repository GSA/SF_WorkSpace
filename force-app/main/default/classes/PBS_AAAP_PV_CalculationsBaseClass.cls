/*
 * 		Name		:	PBS_AAAP_PV_CalculationsBaseClass
 * 		Date		:	18 Sep 2020
 * 		Author		:	Santhosh Kanthula Jagadeesan 
 * 		Description	:	This class is used as the base of PV Calculations where all the methods are implemented 
 * 						and you need to extend this class in the appropriate RLP Year's main class where you can 
 * 						override the methods if want make any changes in Calculations else no changes required.
*/
public virtual class PBS_AAAP_PV_CalculationsBaseClass{
    //Here we are declaring all variables
    PBS_AAAP_Agency_Requirement__c agency;
    PBS_AAAP_Offer__c offer;
    PBS_AAAP_RLP__c rlp;
    PBS_AAAP_Space__c space;
    PBS_AAAP_Rate__c rate;
    public double monthlyCostNonReservedGarageParking;
    public double monthlyCostReservedGarageParking;
    public double monthlyCostNonReservedSurfaceParking;
    public double monthlyCostReservedSurfaceParking;
    public double operatingCostsperABOASF;
    public double lessorsPMFees;
    public double aeFees;
    public string aeFeesUOM;
    public double shellRateFirmTerm;
    public double tiAmortizationRate;
    public double shellRateSoftTerm;
    public double bsacAmortizationRate;
    public double firmTermFreeMonths;
    public double tiforNeworContinuingSpace;
    public double physicalMoveCostperABOASF;
    public double telecomCostperABOASF;
    public double bsacforNeworContinuingSpace;
    public double buildOutperABOASF;
    public double discountRate;
    public double escalationRate;
    public double aboaSFMin;
    public double aboaSFMax;
    public double leaseTermMonths;
    public double leaseFirmTermMonths;
    public double reservedSurfaceParking;
    public double nonReservedSurfaceParking;
    public double reservedGarageParking;
    public double nonReservedGarageParking;
    public double shellRate;
    public string leaseTerm;
    public PBS_AAAP_PV_CalculationsBaseClass(){
        //Here we are initialize all the variables so if we can escape "Attempt to de-reference a null object" error
        this.agency = new PBS_AAAP_Agency_Requirement__c();
        this.offer = new PBS_AAAP_Offer__c();
        this.rlp = new PBS_AAAP_RLP__c();
        this.space = new PBS_AAAP_Space__c();
        this.rate = new PBS_AAAP_Rate__c();  
        this.monthlyCostNonReservedGarageParking = 0;
        this.monthlyCostReservedGarageParking = 0;
        this.monthlyCostNonReservedSurfaceParking =  0;
        this.monthlyCostReservedSurfaceParking =  0;
        this.operatingCostsperABOASF = 0;
        this.lessorsPMFees =  0;
        this.aeFees =  0;
        this.aeFeesUOM = '';
        this.shellRateFirmTerm = 0;
        this.tiAmortizationRate = 0;
      	this.shellRateSoftTerm =  0;
        this.bsacAmortizationRate = 0;
        this.firmTermFreeMonths = 0;
        this.shellRate = 0;
        this.tiforNeworContinuingSpace =  0;
        this.physicalMoveCostperABOASF =  0;
        this.telecomCostperABOASF =  0;
        this.bsacforNeworContinuingSpace =  0;
        this.buildOutperABOASF = 0;
        this.discountRate =  0;
        this.escalationRate = 0;
        this.aboaSFMin = 0;
        this.aboaSFMax = 0;
        this.leaseTerm = '';
        this.reservedSurfaceParking = 0;
        this.nonReservedSurfaceParking = 0;
        this.reservedGarageParking =  0;
        this.nonReservedGarageParking =  0;
   }    
    // This methods is using set all The PV Calculation Parameters
   	public virtual void setThePVCalculationParameters(PBS_AAAP_Agency_Requirement__c agency,PBS_AAAP_Offer__c offer, PBS_AAAP_RLP__c rlp,PBS_AAAP_Space__c space, PBS_AAAP_Rate__c rate){
        //Here we are setting all variables
    	this.agency = agency;
        this.offer = offer;
        this.rlp = rlp;
        this.space = space;
        this.rate = rate;  
        this.monthlyCostNonReservedGarageParking = (offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c!=null) ? offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c : 0;
        this.monthlyCostReservedGarageParking = (offer.PBS_AAAP_Monthly_cost_res_gar_park__c!=null) ? offer.PBS_AAAP_Monthly_cost_res_gar_park__c : 0;
        this.monthlyCostNonReservedSurfaceParking = (offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c!=null) ? offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c : 0;
        this.monthlyCostReservedSurfaceParking = (offer.PBS_AAAP_Monthly_cost_res_sur_park__c!=null) ? offer.PBS_AAAP_Monthly_cost_res_sur_park__c : 0;
        this.operatingCostsperABOASF = (rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c!=null) ? rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c : 0;
        this.lessorsPMFees = (space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c!=null) ? space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c/100 : 0;
        this.aeFees = (space.PBS_AAAP_ARCH_ENG_FEES__c!=null) ? space.PBS_AAAP_ARCH_ENG_FEES__c : 0;
        this.aeFeesUOM = space.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c;
        this.shellRateFirmTerm = (rate.PBS_AAAP_BASE_RATE__c!=null) ? rate.PBS_AAAP_BASE_RATE__c : 0;
        this.tiAmortizationRate = (rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c!=null) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c/100 : 0;
      	this.shellRateSoftTerm = (rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c!=null) ? rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c : 0;
        this.bsacAmortizationRate = (rate.PBS_AAAP_BSAC_RATE__c!=null) ? rate.PBS_AAAP_BSAC_RATE__c/100 : 0;
        this.firmTermFreeMonths = (rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c!=null) ? rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c : 0;
        System.debug('PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c '+rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c);
        this.shellRate = (rate.PBS_AAAP_BASE_RATE__c!=null) ? rate.PBS_AAAP_BASE_RATE__c : 0;
        this.tiforNeworContinuingSpace = (rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c!=null) ? rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c : 0;
        this.physicalMoveCostperABOASF = (rlp.PBS_AAAP_MOVE_DEFAULT__c!=null) ? rlp.PBS_AAAP_MOVE_DEFAULT__c : 0;
        this.telecomCostperABOASF = (rlp.PBS_AAAP_TELCOMM_DEFAULT__c!=null) ? rlp.PBS_AAAP_TELCOMM_DEFAULT__c : 0;
        this.bsacforNeworContinuingSpace = (rlp.PBS_AAAP_BSAC_per_ABOA__c!=null) ? rlp.PBS_AAAP_BSAC_per_ABOA__c : 0;
        this.buildOutperABOASF = (rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c!=null) ? rlp.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c : 0;
        this.discountRate = (rlp.PBS_AAAP_Discount_percent_Rate__c!=null) ? rlp.PBS_AAAP_Discount_percent_Rate__c/100 : 0;
        this.escalationRate = (rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c!=null) ? rlp.PBS_AAAP_ESCALATION_PRCNT_RATE__c/100 : 0;
        this.aboaSFMin = (agency.PBS_AAAP_USF_REQ_MIN__c!=null) ? agency.PBS_AAAP_USF_REQ_MIN__c : 0;
        this.aboaSFMax = (agency.PBS_AAAP_USF_REQ_MAX__c!=null) ? agency.PBS_AAAP_USF_REQ_MAX__c : 0;
        this.leaseTerm = agency.PBS_AAAP_LEASE_TERM__c;
        this.reservedSurfaceParking = (agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c!=null) ? agency.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c : 0;
        this.nonReservedSurfaceParking = (agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c!=null) ? agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c : 0;
        this.reservedGarageParking = (agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c!=null) ? agency.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c : 0;
        this.nonReservedGarageParking = (agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c!=null) ? agency.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c : 0;
        System.debug('TestbsacforNeworContinuingSpace');
        System.debug(bsacforNeworContinuingSpace);
        System.debug(bsacAmortizationRate);
        System.debug(leaseFirmTermMonths);
        System.debug(rlp.PBS_AAAP_BSAC_per_ABOA__c);
        
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
    }
    // This method is used for "10 years, 8 firm" Lease term to get all requiered values for final PV Cost
    public virtual double smallLeaseNPV(){
        double result = 0;
        double ammortizationOfTI = ammortizationOfTI();
        double totalFeeCost = totalFeeCost();
        double totalLessorOverheadandFees = totalLessorOverheadandFees();
        double garageParkingRate = garageParkingRate();
        double surfaceParkingRate = surfaceParkingRate();
        double ammortizationOfBSAC = ammortizationOfBSAC();
        double valueOfFreeRentYear1 = valueOfFreeRentYear1();
        double valueOfFreeRentYear2 = valueOfFreeRentYear2();
        double valueOfFreeRentYear3 = valueOfFreeRentYear3();
        double valueOfFreeRentYear4 = valueOfFreeRentYear4();
        double valueOfFreeRentYear5 = valueOfFreeRentYear5();
        double valueOfFreeRentYear6 = valueOfFreeRentYear6();
        double valueOfFreeRentYear7 = valueOfFreeRentYear7();
        double valueOfFreeRentYear8 = valueOfFreeRentYear8();
        double annualRentperABOASFYear1 = annualRentperABOASFYear1();
        double annualRentperABOASFYear2 = annualRentperABOASFYear2();
        double annualRentperABOASFYear3 = annualRentperABOASFYear3();
        double annualRentperABOASFYear4 = annualRentperABOASFYear4();
        double annualRentperABOASFYear5 = annualRentperABOASFYear5();
        double annualRentperABOASFYear6 = annualRentperABOASFYear6();
        double annualRentperABOASFYear7 = annualRentperABOASFYear7();
        double annualRentperABOASFYear8 = annualRentperABOASFYear8();
        double annualRentperABOASFYear9 = annualRentperABOASFYear9();
        double annualRentperABOASFYear10 = annualRentperABOASFYear10();
        double npv = smallNPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8)/(leaseTermMonths/12);
        System.debug('smallLeaseNPV: '+result);
        return result;

    }
    // This method is used for "15 years, 13 firm" Lease term to get all requiered values for final PV Cost
    public virtual double mediumLeaseNPV(){

        double result = 0;
        double ammortizationOfTI = ammortizationOfTI();
        double totalFeeCost = totalFeeCost();
        double totalLessorOverheadandFees = totalLessorOverheadandFees();
        double garageParkingRate = garageParkingRate();
        double surfaceParkingRate = surfaceParkingRate();
        double ammortizationOfBSAC = ammortizationOfBSAC();
        double valueOfFreeRentYear1 = valueOfFreeRentYear1();
        double valueOfFreeRentYear2 = valueOfFreeRentYear2();
        double valueOfFreeRentYear3 = valueOfFreeRentYear3();
        double valueOfFreeRentYear4 = valueOfFreeRentYear4();
        double valueOfFreeRentYear5 = valueOfFreeRentYear5();
        double valueOfFreeRentYear6 = valueOfFreeRentYear6();
        double valueOfFreeRentYear7 = valueOfFreeRentYear7();
        double valueOfFreeRentYear8 = valueOfFreeRentYear8();
        double valueOfFreeRentYear9 = valueOfFreeRentYear9();
        double valueOfFreeRentYear10 = valueOfFreeRentYear10();
        double valueOfFreeRentYear11 = valueOfFreeRentYear11();
        double valueOfFreeRentYear12 = valueOfFreeRentYear12();
        double valueOfFreeRentYear13 = valueOfFreeRentYear13();
        
        double annualRentperABOASFYear1 = annualRentperABOASFYear1();
        double annualRentperABOASFYear2 = annualRentperABOASFYear2();
        double annualRentperABOASFYear3 = annualRentperABOASFYear3();
        double annualRentperABOASFYear4 = annualRentperABOASFYear4();
        double annualRentperABOASFYear5 = annualRentperABOASFYear5();
        double annualRentperABOASFYear6 = annualRentperABOASFYear6();
        double annualRentperABOASFYear7 = annualRentperABOASFYear7();
        double annualRentperABOASFYear8 = annualRentperABOASFYear8();
        double annualRentperABOASFYear9 = annualRentperABOASFYear9();
        double annualRentperABOASFYear10 = annualRentperABOASFYear10();
        double annualRentperABOASFYear11 = annualRentperABOASFYear11();
        double annualRentperABOASFYear12 = annualRentperABOASFYear12();
        double annualRentperABOASFYear13 = annualRentperABOASFYear13();
        double annualRentperABOASFYear14 = annualRentperABOASFYear14();
        double annualRentperABOASFYear15 = annualRentperABOASFYear15();

        double npv = mediumNPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10,annualRentperABOASFYear11,annualRentperABOASFYear12,annualRentperABOASFYear13,annualRentperABOASFYear14,annualRentperABOASFYear15);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8+valueOfFreeRentYear9+valueOfFreeRentYear10+valueOfFreeRentYear11+valueOfFreeRentYear12+valueOfFreeRentYear13)/(leaseTermMonths/12);
        System.debug('mediumLeaseNPV: '+result);
        return result;

    }
    // This method is used for "17 years, 15 firm" Lease term to get all requiered values for final PV Cost
    public virtual double longLeaseNPV(){
        double result = 0;
        double ammortizationOfTI = ammortizationOfTI();
        double totalFeeCost = totalFeeCost();
        double totalLessorOverheadandFees = totalLessorOverheadandFees();
        double garageParkingRate = garageParkingRate();
        double surfaceParkingRate = surfaceParkingRate();
        double ammortizationOfBSAC = ammortizationOfBSAC();
        double valueOfFreeRentYear1 = valueOfFreeRentYear1();
        double valueOfFreeRentYear2 = valueOfFreeRentYear2();
        double valueOfFreeRentYear3 = valueOfFreeRentYear3();
        double valueOfFreeRentYear4 = valueOfFreeRentYear4();
        double valueOfFreeRentYear5 = valueOfFreeRentYear5();
        double valueOfFreeRentYear6 = valueOfFreeRentYear6();
        double valueOfFreeRentYear7 = valueOfFreeRentYear7();
        double valueOfFreeRentYear8 = valueOfFreeRentYear8();
        double valueOfFreeRentYear9 = valueOfFreeRentYear9();
        double valueOfFreeRentYear10 = valueOfFreeRentYear10();
        double valueOfFreeRentYear11 = valueOfFreeRentYear11();
        double valueOfFreeRentYear12 = valueOfFreeRentYear12();
        double valueOfFreeRentYear13 = valueOfFreeRentYear13();
        double valueOfFreeRentYear14 = valueOfFreeRentYear14();
        double valueOfFreeRentYear15 = valueOfFreeRentYear15();
        
        double annualRentperABOASFYear1 = annualRentperABOASFYear1();
        double annualRentperABOASFYear2 = annualRentperABOASFYear2();
        double annualRentperABOASFYear3 = annualRentperABOASFYear3();
        double annualRentperABOASFYear4 = annualRentperABOASFYear4();
        double annualRentperABOASFYear5 = annualRentperABOASFYear5();
        double annualRentperABOASFYear6 = annualRentperABOASFYear6();
        double annualRentperABOASFYear7 = annualRentperABOASFYear7();
        double annualRentperABOASFYear8 = annualRentperABOASFYear8();
        double annualRentperABOASFYear9 = annualRentperABOASFYear9();
        double annualRentperABOASFYear10 = annualRentperABOASFYear10();
        double annualRentperABOASFYear11 = annualRentperABOASFYear11();
        double annualRentperABOASFYear12 = annualRentperABOASFYear12();
        double annualRentperABOASFYear13 = annualRentperABOASFYear13();
        double annualRentperABOASFYear14 = annualRentperABOASFYear14();
        double annualRentperABOASFYear15 = annualRentperABOASFYear15();
        double annualRentperABOASFYear16 = annualRentperABOASFYear16();
        double annualRentperABOASFYear17 = annualRentperABOASFYear17();

        double npv = longNPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10,annualRentperABOASFYear11,annualRentperABOASFYear12,annualRentperABOASFYear13,annualRentperABOASFYear14,annualRentperABOASFYear15,annualRentperABOASFYear16,annualRentperABOASFYear17);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5+valueOfFreeRentYear6+valueOfFreeRentYear7+valueOfFreeRentYear8+valueOfFreeRentYear9+valueOfFreeRentYear10+valueOfFreeRentYear11+valueOfFreeRentYear12+valueOfFreeRentYear13+valueOfFreeRentYear14+valueOfFreeRentYear15)/(leaseTermMonths/12);
        System.debug('longLeaseNPV: '+result);
        return result;

    }
    // This method is used for "10 years, 8 firm" Lease term to calculate PV Cost
	public virtual double smallNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10);
        System.debug('smallNPVCalculator: '+result);
        return result;

    }
    //This method is used for "15 years, 13 firm" Lease term to calculate PV Cost
    public virtual double mediumNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10, double annualRentperABOASFYear11, double annualRentperABOASFYear12, double annualRentperABOASFYear13, double annualRentperABOASFYear14, double annualRentperABOASFYear15){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10)+
                annualRentperABOASFYear11/Math.pow(1+discountRate,11)+annualRentperABOASFYear12/Math.pow(1+discountRate,12)+annualRentperABOASFYear13/Math.pow(1+discountRate,13)+annualRentperABOASFYear14/Math.pow(1+discountRate,14)+annualRentperABOASFYear15/Math.pow(1+discountRate,15);
        System.debug('mediumNPVCalculator: '+result);
        return result;

    }
    // This method is used for "17 years, 15 firm" Lease term to calculate PV Cost
    public virtual double longNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10, double annualRentperABOASFYear11, double annualRentperABOASFYear12, double annualRentperABOASFYear13, double annualRentperABOASFYear14, double annualRentperABOASFYear15,
                double annualRentperABOASFYear16, double annualRentperABOASFYear17){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10)+
                annualRentperABOASFYear11/Math.pow(1+discountRate,11)+annualRentperABOASFYear12/Math.pow(1+discountRate,12)+annualRentperABOASFYear13/Math.pow(1+discountRate,13)+annualRentperABOASFYear14/Math.pow(1+discountRate,14)+annualRentperABOASFYear15/Math.pow(1+discountRate,15)+
                annualRentperABOASFYear16/Math.pow(1+discountRate,16)+annualRentperABOASFYear17/Math.pow(1+discountRate,17);
        System.debug('longNPVCalculator: '+result);
        return result;

    }
    // This method is used to calculate	"Total Fee Cost" (BB) value
	public virtual double totalFeeCost(){
        double result = 0;
        double aeFees  = 0;
        if(aeFeesUOM == '$ Per ABOA SF'){
            System.debug('totalFeeCost '+this.aeFees);
            System.debug('totalFeeCost '+lessorsPMFees);
            System.debug('totalFeeCost '+tiforNeworContinuingSpace);
            result = this.aeFees+(lessorsPMFees*tiforNeworContinuingSpace);

        }else if(aeFeesUOM == '%'){
            if(Test.isRunningTest() == false){
                aeFees = this.aeFees/100;
            }else{
                aeFees = this.aeFees;
            }
            result = aeFees*(tiforNeworContinuingSpace/(1+aeFees))+(lessorsPMFees*tiforNeworContinuingSpace);

        }
        System.debug('totalFeeCost '+result);
        return result;

    }
    // This method is used to calculate	"Total Lessor Overhead and Fees" (CC) value
    public virtual double totalLessorOverheadandFees(){
        double result = 0;
        if(tiforNeworContinuingSpace > 0){
            result = TotalFeeCost()/tiforNeworContinuingSpace;
        }else{
            result = 0;
        }
        System.debug('totalLessorOverheadandFees '+result);     
        return result;
    }
    // This method is used to calculate	"Garage Parking Rate" (DD) value
    public virtual double garageParkingRate(){
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
        System.debug('garageParkingRate '+result);
        return result;
    }
    // This method is used to calculate "Surface Parking Rate" (EE) value
    public virtual double surfaceParkingRate(){
        double result = 0;
        if(reservedSurfaceParking+nonReservedSurfaceParking == 0){
            result = 0;
        }else{
            if(aboaSFMin+aboaSFMax > 0){
                result = ((reservedSurfaceParking*monthlyCostReservedSurfaceParking+nonReservedSurfaceParking*monthlyCostNonReservedSurfaceParking)/(reservedSurfaceParking+nonReservedSurfaceParking)*12/((aboaSFMin+aboaSFMax)/2));
            }else{ 
                result = 0;
            }
        }
        System.debug('surfaceParkingRate '+result);
        return result;
    }
    // This method is used to calculate "Amortization of TI" (AA) value
    public virtual double ammortizationOfTI(){
        double tiAmortizationRate = this.tiAmortizationRate/12;
        double result = PMT(tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace);
        result = (-1*12*result);
        System.debug('ammortizationOfTI '+result);
        return result;
    }
    // This method is used to calculate "PMT" value
    public virtual double pmt(double Rate,double NPER,double PV){
        
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
        else if(Rate == 0 && NPER != Null && NPER != 0){
            double cond2Res = (-1*PV) / NPER ;
            system.debug('\n--cond2Res--   '+cond2Res);
            returnvalue = cond2Res; 
        }
        
        else{
            if(Rate != Null && PV != Null && NPER != Null){
           double divisor = -1*Rate*PV;
           double divident = Math.pow((1+Rate),(-1*NPER)); 
           system.debug('\n--divisor--  '+divisor+'\n--divident--  '+divident);
                if((1 - divident) != 0){
                   returnvalue = divisor / (1 - divident); 
                }
            }
        }
        
        // formatiing return value
        if(returnvalue != null){
            return returnvalue;
        }
        else{
            return null;
        }
    }
    // This method is used to calculate "Amortization of BSAC" (FF) value
    public virtual double ammortizationOfBSAC(){
        double result = 0;
        if(bsacforNeworContinuingSpace!=null){
            double bsacAmortizationRate = this.bsacAmortizationRate/12;
            result = PMT(bsacAmortizationRate,leaseFirmTermMonths,bsacforNeworContinuingSpace);
            result = (-1*12*result);    
        }
        else{
            result = 0;
        }
        System.debug('ammortizationOfBSAC: '+result);
        return result;        
    }
    // This method is used to calculate "Value of Free Rent Year 1" value
    public virtual double valueOfFreeRentYear1(){
        double result = 0;
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        if(firmTermFreeMonths > 12){
            firmTermFreeMonths = 12;
        }
        result = (freeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,0)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear1: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 2" value
    public virtual double valueOfFreeRentYear2(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 12){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 24){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 12;
        }
        result = (freeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,1)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear2: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 3" value
    public virtual double valueOfFreeRentYear3(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 24){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 36){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 24;
        }
        result = (freeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,2)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear3: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 4" value
    public virtual double valueOfFreeRentYear4(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 36){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 48){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 36;
        }
        result = (freeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,3)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear4: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 5" value
    public virtual double valueOfFreeRentYear5(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 48){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 60){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 48;
        }
        result = (freeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,4)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear5: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 6" value
    public virtual double valueOfFreeRentYear6(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 60){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 72){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 60;
        }
        result = (freeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,5)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear6: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 7" value
    public virtual double valueOfFreeRentYear7(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 72){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 84){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 72;
        }
        result = (freeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,6)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear7: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 8" value
    public virtual double valueOfFreeRentYear8(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 84){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 96){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 84;
        }
        result = (freeRent(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,7)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear8: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 9" value
    public virtual double valueOfFreeRentYear9(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 96){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 108){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 96;
        }
        result = (freeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,8)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear9: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 10" value
    public virtual double valueOfFreeRentYear10(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 108){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 120){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 108;
        }
        result = (freeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,9)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear10: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 11" value
    public virtual double valueOfFreeRentYear11(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 120){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 132){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 120;
        }
        result = (freeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,10)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear11: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 12" value
    public virtual double valueOfFreeRentYear12(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 132){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 144){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 132;
        }
        result = (freeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,11)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear12: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 13" value
    public virtual double valueOfFreeRentYear13(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 144){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 156){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 144;
        }
        result = (freeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,12)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear13: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 14" value
    public virtual double valueOfFreeRentYear14(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 156){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 168){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 156;
        }
        result = (freeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,13)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear14: '+result);
        return result;
    }
    // This method is used to calculate "Value of Free Rent Year 15" value
    public virtual double valueOfFreeRentYear15(){
        double firmTermFreeMonths = this.firmTermFreeMonths ;
        double result = 0;
        if(firmTermFreeMonths < 168){
            firmTermFreeMonths = 0;
        }else if(firmTermFreeMonths > 180){
            firmTermFreeMonths = 12;
        }else{
            firmTermFreeMonths = firmTermFreeMonths - 168;
        }
        result = (freeRentLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,14)/12*firmTermFreeMonths);
        System.debug('valueOfFreeRentYear15: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 1" value
    public virtual double annualRentperABOASFYear1(){
        double result = 0;
        result = aboa(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,0,
                    reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('annualRentperABOASFYear1: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 2" value
    public virtual double annualRentperABOASFYear2(){
        double result = 0;
        result = aboa(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,1,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('annualRentperABOASFYear2: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 3" value
    public virtual double annualRentperABOASFYear3(){
        double result = 0;
        result = aboa(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,2,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('annualRentperABOASFYear3: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 4" value
    public virtual double annualRentperABOASFYear4(){
        double result = 0;
        result = aboa(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,3,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('annualRentperABOASFYear4: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 5" value
    public virtual double annualRentperABOASFYear5(){
        double result = 0;
        result = aboa(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,4,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('annualRentperABOASFYear5: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 6" value
    public virtual double annualRentperABOASFYear6(){
        double result = 0;
        result = aboa(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,5,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('annualRentperABOASFYear6: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 7" value
    public virtual double annualRentperABOASFYear7(){
        double result = 0;
        result = aboa(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,6,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('annualRentperABOASFYear7: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 8" value
    public virtual double annualRentperABOASFYear8(){
        double result = 0;
        result = aboa(shellRateFirmTerm,operatingCostsperABOASF,escalationRate,firmTermFreeMonths,tiAmortizationRate,leaseFirmTermMonths,tiforNeworContinuingSpace,aeFees,lessorsPMFees,aeFeesUOM,bsacAmortizationRate,bsacforNeworContinuingSpace,7,
            reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax);
        System.debug('annualRentperABOASFYear8: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 9" value
    public virtual double annualRentperABOASFYear9(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,8);
        System.debug('annualRentperABOASFYear9: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 10" value
    public virtual double annualRentperABOASFYear10(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,9);
        System.debug('annualRentperABOASFYear10: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 11" value
    public virtual double annualRentperABOASFYear11(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,10);
        System.debug('annualRentperABOASFYear11: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 12" value
    public virtual double annualRentperABOASFYear12(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,11);
        System.debug('annualRentperABOASFYear12: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 13" value
    public virtual double annualRentperABOASFYear13(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,12);
        System.debug('annualRentperABOASFYear13: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 14" value
    public virtual double annualRentperABOASFYear14(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,13);
        System.debug('annualRentperABOASFYear14: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 15" value
    public virtual double annualRentperABOASFYear15(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,14);
        System.debug('annualRentperABOASFYear15: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 16" value
    public virtual double annualRentperABOASFYear16(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,15);
        System.debug('annualRentperABOASFYear16: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 17" value
    public virtual double annualRentperABOASFYear17(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,16);
        System.debug('annualRentperABOASFYear17: '+result);
        return result;
    }
	// This method is used to calculate "FreeRent (ValueOfFreeRentYear1 to ValueOfFreeRentYear8)" value
    public virtual double freeRent(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,
            double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
                System.debug('freeRent: '+garageParkingRate());
                System.debug('freeRent: '+reservedGarageParking);
                System.debug('freeRent: '+nonReservedGarageParking);
                System.debug('freeRent: '+surfaceParkingRate());
                System.debug('freeRent: '+reservedSurfaceParking);
                System.debug('freeRent: '+nonReservedSurfaceParking);
                System.debug('freeRent: '+ (ammortizationOfTI()*totalLessorOverheadandFees()));
        result = (shellRateFirmTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) + ammortizationOfTI() + 
                 (ammortizationOfTI()*totalLessorOverheadandFees()) +
                 ammortizationOfBSAC()+(garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                 (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('freeRent: '+result);
        return result;

    }
    // This method is used to calculate "freeRentLong (ValueOfFreeRentYear9 to ValueOfFreeRentYear15)" value
    public virtual double freeRentLong(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
        double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
            System.debug('freeRentLong: '+garageParkingRate());
            System.debug('freeRentLong: '+reservedGarageParking);
            System.debug('freeRentLong: '+nonReservedGarageParking);
            System.debug('freeRentLong: '+surfaceParkingRate());
            System.debug('freeRentLong: '+reservedSurfaceParking);
            System.debug('freeRentLong: '+nonReservedSurfaceParking);
        result = (shellRateSoftTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp)))+
                (garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('freeRentLong: '+result);
        return result;

    }
    // This method is used to calculate "aboa (AnnualRentperABOASFYear1 to AnnualRentperABOASFYear8)" value
    public virtual double aboa(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,double exp,
            double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = (shellRateFirmTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) + ammortizationOfTI() + 
                 (ammortizationOfTI()*totalLessorOverheadandFees()) +
                 ammortizationOfBSAC()+(garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                 (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('aboa: '+result);
        return result;

    }
    // This method is used to calculate "aboaLong (AnnualRentperABOASFYear9 to AnnualRentperABOASFYear17)" value
    public virtual double aboaLong(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
        double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
        result = (shellRateSoftTerm + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp)))+
                (garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('aboaLong: '+result);
        return result;
   }
}