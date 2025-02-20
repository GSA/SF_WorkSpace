/*
 * 		Name		:	PBS_AAAP_PV_Calculations_Interface
 * 		Date		:	11 Sep 2020
 * 		Author		:	Santhosh Kanthula Jagadeesan 
 * 		Description	:	This interface is used to set structure for PV Calculation main classes like PBS_AAAP_PV_Calculations_2021
*/
Public interface PBS_AAAP_PV_Calculations_Interface{
    //This method is need to implement in main classes like PBS_AAAP_PV_Calculations_2021
    double npvCalculator(PBS_AAAP_Agency_Requirement__c agency,PBS_AAAP_Offer__c offer, PBS_AAAP_RLP__c rlp,PBS_AAAP_Space__c space, PBS_AAAP_Rate__c rate);
}