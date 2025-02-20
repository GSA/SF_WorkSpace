/*
 * 		Name		:	PBS_AAAP_PV_Calculations_Factory
 * 		Date		:	14 Sep 2020
 * 		Author		:	Santhosh Kanthula Jagadeesan 
 * 		Description	:	This class is used to get the correct class instance according to year
*/
public with sharing class PBS_AAAP_PV_Calculations_Factory {
	private  Map<String, PBS_AAAP_PV_Calculations_Interface> yearMap = new Map<String, PBS_AAAP_PV_Calculations_Interface>();
	private  Map<String, PBS_AAAP_PV_Calculations_Interface> yearMapForShortTerm = new Map<String, PBS_AAAP_PV_Calculations_Interface>();
	private List<Integer> yearsList = new List<Integer>();
    public PBS_AAAP_PV_Calculations_Factory() {
        //Here we are querying the metadata records and filling map and a list based on RLP Year.
        for(PBS_AAAP_PV_Calculation_Setting__mdt settingRecord : [Select Class_Name__c, RLP_FY_Year__c, Short_Term_Class_Name__c From PBS_AAAP_PV_Calculation_Setting__mdt Where RLP_FY_Year__c != Null AND Class_Name__c != Null]){
            //Here we are dynamically creating an instance of main PV calculation class according to their RLP Year.
            PBS_AAAP_PV_Calculations_Interface classInstance = (PBS_AAAP_PV_Calculations_Interface)Type.forName(settingRecord.Class_Name__c).newInstance();
			yearMap.put(String.valueOf(Integer.valueOf(settingRecord.RLP_FY_Year__c)), classInstance);
            
            PBS_AAAP_PV_Calculations_Interface classInstanceShortTerm = (PBS_AAAP_PV_Calculations_Interface)Type.forName(settingRecord.Short_Term_Class_Name__c).newInstance();
			yearMapForShortTerm.put(String.valueOf(Integer.valueOf(settingRecord.RLP_FY_Year__c)), classInstanceShortTerm);
            
            yearsList.add(Integer.valueOf(settingRecord.RLP_FY_Year__c));
        }
    }
	//This method is used to get the correct class instance according to year
    public PBS_AAAP_PV_Calculations_Interface getPVCalculator(String year, Boolean isFormShortTerm) {
        PBS_AAAP_PV_Calculations_Interface interfaceInstance;
        Map<String, PBS_AAAP_PV_Calculations_Interface> yearMapWithClassInstance = new Map<String, PBS_AAAP_PV_Calculations_Interface>();
        if(isFormShortTerm){
            yearMapWithClassInstance = yearMapForShortTerm;
        }else{
            yearMapWithClassInstance = yearMap;
        }
        //If the record is available for a current RLP year, then we are getting class instance from metadata record.
        if(yearMapWithClassInstance.containsKey(year)){
            interfaceInstance = yearMapWithClassInstance.get(year);
        }else{
            //If the record is not available in metadata for a current RLP year, then we are getting a class instance of previously available record in metadata. 
            yearsList.sort();
            List<Integer> reversed = new List<Integer>();        
            for(Integer i = yearsList.size() - 1; i >= 0; i--){
                reversed.add(yearsList[i]);
            }
            System.debug(reversed);
            //Here we are looping through all the available record in metadata in reverse order to get the previously available record.
            for(Integer rlpYear : reversed){
                if(rlpYear < Integer.valueOf(year)){
                    interfaceInstance = yearMapWithClassInstance.get(String.valueOf(rlpYear));
                    break;
                }
            }
        }
        return interfaceInstance;
    }
    
}