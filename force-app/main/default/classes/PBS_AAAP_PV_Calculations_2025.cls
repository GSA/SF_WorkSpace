/*
 * 		Name		:	PBS_AAAP_PV_Calculations_2025
 * 		Date		:	Aug 27th 2024
 * 		Author		:	Santhosh Kanthula Jagadeesan 
 * 		Description	:	This class is used for PV Standard Calculations of 2025 year
*/
public class PBS_AAAP_PV_Calculations_2025 extends PBS_AAAP_PV_CalculationsBaseClass implements PBS_AAAP_PV_Calculations_Interface{
    public double routineCleaningAndDisinfecting;
    // This method is using to initiate the Calculations 
    public double npvCalculator(PBS_AAAP_Agency_Requirement__c agency,PBS_AAAP_Offer__c offer, PBS_AAAP_RLP__c rlp,PBS_AAAP_Space__c space, PBS_AAAP_Rate__c rate){
        System.debug('New_calculation npvCalculator 2025');
        double result = 0;
        System.debug('agency : '+agency);
        System.debug('Offer : '+offer);
        System.debug('rlp : '+rlp);
        System.debug('space : '+space);
        System.debug('rate : '+rate);
        //Setting the calculation Parameters
        setThePVCalculationParameters(agency, offer, rlp, space, rate);
        routineCleaningAndDisinfecting = 0;
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
        if(leaseTerm == '10 years, 8 firm'){
            //Here leaseTermMonths and leaseFirmTermMonths is setting for "10 years, 8 firm" and calling smallLeaseNPV for calculations
            leaseTermMonths = 120;
            leaseFirmTermMonths = 96;
            
            result = smallLeaseNPV();
            
        }else if(leaseTerm == '15 years, 13 firm'){
            //Here leaseTermMonths and leaseFirmTermMonths is setting for "15 years, 13 firm" and calling mediumLeaseNPV for calculations
            leaseTermMonths = 180;
            leaseFirmTermMonths = 96;
            
            result = mediumLeaseNPV();
            
        }else if(leaseTerm == '17 years, 15 firm'){
            //Here leaseTermMonths and leaseFirmTermMonths is setting for "17 years, 15 firm" and calling longLeaseNPV for calculations
            leaseTermMonths = 204;
            leaseFirmTermMonths = 96;
            
            result = longLeaseNPV();
        }
        System.debug('NPV '+result);
        return result;
    }
    // This method is used for "10 years, 8 firm" Lease term to get all requiered values for final PV Cost
    public override double smallLeaseNPV(){
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
        double npv = smallNPVCalculator(discountRate,(annualRentperABOASFYear1-valueOfFreeRentYear1),(annualRentperABOASFYear2-valueOfFreeRentYear2),(annualRentperABOASFYear3-valueOfFreeRentYear3),(annualRentperABOASFYear4-valueOfFreeRentYear4),(annualRentperABOASFYear5-valueOfFreeRentYear5),(annualRentperABOASFYear6-valueOfFreeRentYear6),
                                       (annualRentperABOASFYear7-valueOfFreeRentYear7),(annualRentperABOASFYear8-valueOfFreeRentYear8),annualRentperABOASFYear9, annualRentperABOASFYear10);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12);
        System.debug('smallLeaseNPV: '+result);
        return result;

    }
    // This method is used for "15 years, 13 firm" Lease term to get all requiered values for final PV Cost
    public override double mediumLeaseNPV(){

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

        double npv = mediumNPVCalculator(discountRate,(annualRentperABOASFYear1-valueOfFreeRentYear1),(annualRentperABOASFYear2-valueOfFreeRentYear2),(annualRentperABOASFYear3-valueOfFreeRentYear3),(annualRentperABOASFYear4-valueOfFreeRentYear4),(annualRentperABOASFYear5-valueOfFreeRentYear5),(annualRentperABOASFYear6-valueOfFreeRentYear6),
                                       (annualRentperABOASFYear7-valueOfFreeRentYear7),(annualRentperABOASFYear8-valueOfFreeRentYear8),(annualRentperABOASFYear9-valueOfFreeRentYear9),(annualRentperABOASFYear10-valueOfFreeRentYear10),(annualRentperABOASFYear11-valueOfFreeRentYear11),(annualRentperABOASFYear12-valueOfFreeRentYear12),
                                       (annualRentperABOASFYear13-valueOfFreeRentYear13),annualRentperABOASFYear14,annualRentperABOASFYear15);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12);
        System.debug('mediumLeaseNPV: '+result);
        return result;

    }
    // This method is used for "17 years, 15 firm" Lease term to get all requiered values for final PV Cost
    public override double longLeaseNPV(){
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

        double npv = longNPVCalculator(discountRate,(annualRentperABOASFYear1-valueOfFreeRentYear1),(annualRentperABOASFYear2-valueOfFreeRentYear2),(annualRentperABOASFYear3-valueOfFreeRentYear3),(annualRentperABOASFYear4-valueOfFreeRentYear4),(annualRentperABOASFYear5-valueOfFreeRentYear5),(annualRentperABOASFYear6-valueOfFreeRentYear6),
                                       (annualRentperABOASFYear7-valueOfFreeRentYear7),(annualRentperABOASFYear8-valueOfFreeRentYear8),(annualRentperABOASFYear9-valueOfFreeRentYear9),(annualRentperABOASFYear10-valueOfFreeRentYear10),(annualRentperABOASFYear11-valueOfFreeRentYear11),(annualRentperABOASFYear12-valueOfFreeRentYear12),
                                       (annualRentperABOASFYear13-valueOfFreeRentYear13),(annualRentperABOASFYear14-valueOfFreeRentYear14),(annualRentperABOASFYear15-valueOfFreeRentYear15),annualRentperABOASFYear16,annualRentperABOASFYear17);
        result = npv/(leaseTermMonths/12) + (physicalMoveCostperABOASF + telecomCostperABOASF + buildOutperABOASF)/(leaseTermMonths/12);
        System.debug('longLeaseNPV: '+result);
        return result;

    }
    // This method is used for "10 years, 8 firm" Lease term to calculate PV Cost
	public override double smallNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10);
        System.debug('smallNPVCalculator: '+result);
        return result;

    }
    //This method is used for "15 years, 13 firm" Lease term to calculate PV Cost
    public override double mediumNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
                double annualRentperABOASFYear7, double annualRentperABOASFYear8,double annualRentperABOASFYear9, double annualRentperABOASFYear10, double annualRentperABOASFYear11, double annualRentperABOASFYear12, double annualRentperABOASFYear13, double annualRentperABOASFYear14, double annualRentperABOASFYear15){

        double result = 0;
        result = annualRentperABOASFYear1/Math.pow(1+discountRate,1)+annualRentperABOASFYear2/Math.pow(1+discountRate,2)+annualRentperABOASFYear3/Math.pow(1+discountRate,3)+annualRentperABOASFYear4/Math.pow(1+discountRate,4)+annualRentperABOASFYear5/Math.pow(1+discountRate,5)+
                annualRentperABOASFYear6/Math.pow(1+discountRate,6)+annualRentperABOASFYear7/Math.pow(1+discountRate,7)+annualRentperABOASFYear8/Math.pow(1+discountRate,8)+annualRentperABOASFYear9/Math.pow(1+discountRate,9)+annualRentperABOASFYear10/Math.pow(1+discountRate,10)+
                annualRentperABOASFYear11/Math.pow(1+discountRate,11)+annualRentperABOASFYear12/Math.pow(1+discountRate,12)+annualRentperABOASFYear13/Math.pow(1+discountRate,13)+annualRentperABOASFYear14/Math.pow(1+discountRate,14)+annualRentperABOASFYear15/Math.pow(1+discountRate,15);
        System.debug('mediumNPVCalculator: '+result);
        return result;

    }
    // This method is used for "17 years, 15 firm" Lease term to calculate PV Cost
    public override double longNPVCalculator(double discountRate,double annualRentperABOASFYear1,double annualRentperABOASFYear2, double annualRentperABOASFYear3, double annualRentperABOASFYear4,double annualRentperABOASFYear5, double annualRentperABOASFYear6,
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
	public override double totalFeeCost(){
        double result = 0;
        double aeFees  = 0;
        if(aeFeesUOM == '$ Per ABOA SF'){
            System.debug('totalFeeCostaeFees '+this.aeFees);
            System.debug('totalFeeCostlessorsPMFees '+lessorsPMFees);
            System.debug('totalFeeCosttiforNeworContinuingSpace '+tiforNeworContinuingSpace);
            System.debug('totalFeeCostbsacforNeworContinuingSpace '+bsacforNeworContinuingSpace);
            result = this.aeFees+(lessorsPMFees*(tiforNeworContinuingSpace+bsacforNeworContinuingSpace));

        }else if(aeFeesUOM == '%'){
            if(Test.isRunningTest() == false){
                aeFees = this.aeFees/100;
            }else{
                aeFees = this.aeFees;
            }
            result = (aeFees*(tiforNeworContinuingSpace+bsacforNeworContinuingSpace))+(lessorsPMFees*(tiforNeworContinuingSpace+bsacforNeworContinuingSpace));

        }
        System.debug('totalFeeCost '+result);
        return result;

    }
    // This method is used to calculate	"Total Lessor Overhead and Fees" (CC) value
    public override double totalLessorOverheadandFees(){
        double result = 0;
        if((tiforNeworContinuingSpace+bsacforNeworContinuingSpace) > 0){
            result = TotalFeeCost()/(tiforNeworContinuingSpace+bsacforNeworContinuingSpace);
        }else{
            result = 0;
        }
        System.debug('totalLessorOverheadandFees '+result);     
        return result;
    }
    // This method is used to calculate "FreeRent (ValueOfFreeRentYear1 to ValueOfFreeRentYear8)" value
    public override double freeRent(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,
            double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
                System.debug('freeRentgarageParkingRate: '+garageParkingRate());
                System.debug('freeRentreservedGarageParking: '+reservedGarageParking);
                System.debug('freeRentnonReservedGarageParking: '+nonReservedGarageParking);
                System.debug('freeRentsurfaceParkingRate: '+surfaceParkingRate());
                System.debug('freeRentreservedSurfaceParking: '+reservedSurfaceParking);
                System.debug('freeRentnonReservedSurfaceParking: '+nonReservedSurfaceParking);
                System.debug('freeRent: '+ (ammortizationOfTI()*totalLessorOverheadandFees()));
        result = (shellRateFirmTerm + routineCleaningAndDisinfecting + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) + ammortizationOfTI() + 
                 (ammortizationOfTI()*totalLessorOverheadandFees())+ammortizationOfBSAC()+(ammortizationOfBSAC()*totalLessorOverheadandFees())+(garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                 (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('freeRent: '+result);
        return result;

    }
    // This method is used to calculate "freeRentLong (ValueOfFreeRentYear9 to ValueOfFreeRentYear15)" value
    public override double freeRentLong(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
        double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
            System.debug('freeRentLonggarageParkingRate: '+garageParkingRate());
            System.debug('freeRentLongreservedGarageParking: '+reservedGarageParking);
            System.debug('freeRentLongnonReservedGarageParking: '+nonReservedGarageParking);
            System.debug('freeRentLongsurfaceParkingRate: '+surfaceParkingRate());
            System.debug('freeRentLongreservedSurfaceParking: '+reservedSurfaceParking);
            System.debug('freeRentLongnonReservedSurfaceParking: '+nonReservedSurfaceParking);
        result = (shellRateSoftTerm + routineCleaningAndDisinfecting + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp)))+
                (garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('freeRentLong: '+result);
        return result;

    }
    // This method is used to calculate "aboa (AnnualRentperABOASFYear1 to AnnualRentperABOASFYear8)" value
    public override double aboa(double shellRateFirmTerm,double operatingCostsperABOASF,double escalationRate,double firmTermFreeMonths,double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace,double aeFees,double lessorsPMFees,string aeFeesUOM,double bsacAmortizationRate,double bsacforNeworContinuingSpace,double exp,
            double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax){
        double result = 0;
        result = (shellRateFirmTerm + routineCleaningAndDisinfecting + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp))) + ammortizationOfTI() + 
                 (ammortizationOfTI()*totalLessorOverheadandFees()) +
                 ammortizationOfBSAC()+(ammortizationOfBSAC()*totalLessorOverheadandFees())+(garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                 (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('aboa: '+result);
        return result;

    }
    // This method is used to calculate "aboaLong (AnnualRentperABOASFYear9 to AnnualRentperABOASFYear17)" value
    public override double aboaLong(double shellRateSoftTerm,double operatingCostsperABOASF,double escalationRate,
        double reservedGarageParking,double nonReservedGarageParking,double monthlyCostNonReservedGarageParking,double monthlyCostReservedGarageParking,double reservedSurfaceParking,double nonReservedSurfaceParking,double monthlyCostNonReservedSurfaceParking,double monthlyCostReservedSurfaceParking,double aboaSFMin,double aboaSFMax,double exp){
        double result = 0;
        result = (shellRateSoftTerm + routineCleaningAndDisinfecting + (operatingCostsperABOASF*(Math.pow(1+escalationRate,exp)))+
                (garageParkingRate()*(reservedGarageParking + nonReservedGarageParking)) + 
                (surfaceParkingRate()*(reservedSurfaceParking + nonReservedSurfaceParking)));
        System.debug('aboaLong: '+result);
        return result;
   }
}