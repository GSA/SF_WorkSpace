/*
 * 		Name		:	PBS_AAAP_PV_Calculations_2021
 * 		Date		:	11 Sep 2020
 * 		Author		:	Santhosh Kanthula Jagadeesan 
 * 		Description	:	This class is used for PV Calculations of 2021 year
*/
public class PBS_AAAP_PV_Calculations_2021 extends PBS_AAAP_PV_CalculationsBaseClass implements PBS_AAAP_PV_Calculations_Interface{
    // This method is using to initiate the Calculations 
    public double npvCalculator(PBS_AAAP_Agency_Requirement__c agency,PBS_AAAP_Offer__c offer, PBS_AAAP_RLP__c rlp,PBS_AAAP_Space__c space, PBS_AAAP_Rate__c rate){
        System.debug('New_calculation npvCalculator 2021');
        double result = 0;
        System.debug('agency : '+agency);
        System.debug('Offer : '+offer);
        System.debug('rlp : '+rlp);
        System.debug('space : '+space);
        System.debug('rate : '+rate);
        //Setting the calculation Parameters
        setThePVCalculationParameters(agency, offer, rlp, space, rate);
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
}