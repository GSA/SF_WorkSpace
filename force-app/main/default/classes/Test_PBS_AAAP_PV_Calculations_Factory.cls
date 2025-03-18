/*
 * 		Name		:	Test_PBS_AAAP_PV_Calculations_Factory
 * 		Date		:	16 Sep 2020
 * 		Author		:	Santhosh Kanthula Jagadeesan 
 * 		Description	:	This test class is using to cover PBS_AAAP_PV_Calculations_Factory Class
*/
@isTest
public class Test_PBS_AAAP_PV_Calculations_Factory {
    /*
       There is a record available for 2021 year in PBS_AAAP_PV_Calculation_Setting__mdt meadata so the  
       getPVCalculatorFromMetadataRecord method is getting class instance for 2021 year of "PBS_AAAP_PV_Calculations_2021"
    */
    @isTest
    public static void getPVCalculatorFromMetadataRecord(){
        PBS_AAAP_PV_Calculations_Factory factoryClass = new PBS_AAAP_PV_Calculations_Factory();
        PBS_AAAP_PV_Calculations_Interface classInstance = factoryClass.getPVCalculator('2021', false);
        
        Boolean isCorrectInstance = classInstance instanceof PBS_AAAP_PV_Calculations_2021;
        System.assert(isCorrectInstance);
        
    }
    /*
       There is no record available for 2024 year in PBS_AAAP_PV_Calculation_Setting__mdt meadata so the  
       getPVCalculatorFromMetadataRecord method is getting class instance for 2023 year of "PBS_AAAP_PV_Calculations_2023"
    */
    @isTest
    public static void getPVCalculatorFromPreviousYearMetadataRecord(){
        PBS_AAAP_PV_Calculations_Factory factoryClass = new PBS_AAAP_PV_Calculations_Factory();
        PBS_AAAP_PV_Calculations_Interface classInstance = factoryClass.getPVCalculator('2024',true);
        Boolean isCorrectInstance = classInstance instanceof PBS_AAAP_PV_Calculations_ShortTerm_2023;
        System.assert(isCorrectInstance);
    }
 
}