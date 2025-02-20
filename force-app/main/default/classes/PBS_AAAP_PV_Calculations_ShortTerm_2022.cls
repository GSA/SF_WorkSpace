public class PBS_AAAP_PV_Calculations_ShortTerm_2022 extends PBS_AAAP_PV_CalculationsBaseClass implements PBS_AAAP_PV_Calculations_Interface{
	public double routineCleaningAndDisinfecting;
    public double npvCalculator(PBS_AAAP_Agency_Requirement__c agency,PBS_AAAP_Offer__c offer, PBS_AAAP_RLP__c rlp,PBS_AAAP_Space__c space, PBS_AAAP_Rate__c rate){
    	System.debug('New_calculation npvCalculator 2022');
        double result = 0;
        System.debug('agency : '+agency);
        System.debug('Offer : '+offer);
        System.debug('rlp : '+rlp);
        System.debug('space : '+space);
        System.debug('rate : '+rate);
        //Setting the calculation Parameters
        setThePVCalculationParameters(agency, offer, rlp, space, rate);
        routineCleaningAndDisinfecting = 0;//space.PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c == Null ? 0 : space.PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c;
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
        system.debug('--routineCleaningAndDisinfecting--'+routineCleaningAndDisinfecting);
        if(leaseTerm == '10 years,5 firm'){
            //Here leaseTermMonths and leaseFirmTermMonths is setting for "10 years, 5 firm" and calling shortTermLeaseNPV for calculations
            leaseTermMonths = 120;
            leaseFirmTermMonths = 60;
            result = shortTermLeaseNPV();
        }
        System.debug('NPV '+result);
        return result;
    }
    // This method is used for "10 years,5 firm" Lease term to get all requiered values for final PV Cost
    public double shortTermLeaseNPV(){
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
        double npv = shortTermNPVCalculator(discountRate,annualRentperABOASFYear1,annualRentperABOASFYear2, annualRentperABOASFYear3, annualRentperABOASFYear4,annualRentperABOASFYear5, annualRentperABOASFYear6,
                annualRentperABOASFYear7, annualRentperABOASFYear8, annualRentperABOASFYear9, annualRentperABOASFYear10);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12)-
            (valueOfFreeRentYear1+valueOfFreeRentYear2+valueOfFreeRentYear3+valueOfFreeRentYear4+valueOfFreeRentYear5)/(leaseTermMonths/12);
        System.debug('shortTermLeaseNPV: '+result);
        return result;

    }
    public virtual double shortTermNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10);
        System.debug('shortTermNPVCalculator: '+result);
        return result;

    }
    // This method is used to calculate "FreeRent (ValueOfFreeRentYear1 to ValueOfFreeRentYear5)" value
    public override double freeRent(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,
            double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
                System.debug('freeRent: '+garageParkingRate());
                System.debug('freeRent: '+reservedGarageParking);
                System.debug('freeRent: '+nonReservedGarageParking);
                System.debug('freeRent: '+surfaceParkingRate());
                System.debug('freeRent: '+reservedSurfaceParking);
                System.debug('freeRent: '+nonReservedSurfaceParking);
                System.debug('freeRent: '+ (ammortizationOfTI()*totalLessorOverheadandFees()));
        result = (shellRateFirmTerm + routineCleaningAndDisinfecting + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) + ammortizationOfTI() + 
                 (ammortizationOfTI()*totalLessorOverheadandFees()) +
                 ammortizationOfBSAC()+(garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                 (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('freeRent: '+result);
        return result;

    }
    // This method is used to calculate "aboa (AnnualRentperABOASFYear1 to AnnualRentperABOASFYear5)" value
    public override double aboa(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,double exp,
            double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = (shellRateFirmTerm + routineCleaningAndDisinfecting + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) + ammortizationOfTI() + 
                 (ammortizationOfTI()*totalLessorOverheadandFees()) +
                 ammortizationOfBSAC()+(garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                 (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('aboa: '+result);
        return result;
    }
    // This method is used to calculate "aboaLong (AnnualRentperABOASFYear6 to AnnualRentperABOASFYear10)" value
    public override double aboaLong(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
        double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
        result = (shellRateSoftTerm + routineCleaningAndDisinfecting + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp)))+
                (garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('aboaLong: '+result);
        return result;
   }
    // This method is used to calculate "Annual Rent per ABOA SF Year 6" value
    public override double annualRentperABOASFYear6(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,5);
        System.debug('annualRentperABOASFYear6: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 7" value
    public override double annualRentperABOASFYear7(){
        double result = 0;
       result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,6);
        System.debug('annualRentperABOASFYear7: '+result);
        return result;
    }
    // This method is used to calculate "Annual Rent per ABOA SF Year 8" value
    public override double annualRentperABOASFYear8(){
        double result = 0;
        result = aboaLong(shellRateSoftTerm,operatingCostsperABOASF,escalationRate,reservedGarageParking,nonReservedGarageParking,monthlyCostNonReservedGarageParking,monthlyCostReservedGarageParking,reservedSurfaceParking,nonReservedSurfaceParking,monthlyCostNonReservedSurfaceParking,monthlyCostReservedSurfaceParking,aboaSFMin,aboaSFMax,7);
        System.debug('annualRentperABOASFYear8: '+result);
        return result;
    }
}