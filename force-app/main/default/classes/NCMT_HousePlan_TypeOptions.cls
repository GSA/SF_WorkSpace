public class NCMT_HousePlan_TypeOptions{
    @AuraEnabled public String groupName {get;set;}
    //@AuraEnabled public String housingPlanId {get;set;}
    @AuraEnabled public List<HousingPlan_Recurrence> recurrences {get;set;}
    @AuraEnabled public Integer selectedRecurrence {get;set;}
    @AuraEnabled public Boolean isTCO {get;set;}

    public NCMT_HousePlan_TypeOptions(){
        recurrences = new List<HousingPlan_Recurrence>();
        selectedRecurrence = 1;
        isTCO = false;
    }

    public NCMT_HousePlan_TypeOptions(String n){
        recurrences = new List<HousingPlan_Recurrence>();
        groupName = n; 
        selectedRecurrence = 1;
        isTCO = false;
        //housingPlanId = hpId;
    }

    public class HousingPlan_Recurrence {
        @AuraEnabled public Integer num {get;set;}
        @AuraEnabled public List<HousingPlan_SubType> subTypes {get;set;}

        public HousingPlan_Recurrence(){
            subTypes = new List<HousingPlan_SubType>();
        }
        public HousingPlan_Recurrence(Integer n, List<HousingPlan_SubType> subs){
            subTypes = subs;
            num = n; 
        }
    }

    public class HousingPlan_SubType {
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public List<HousingPlan_Option> options {get;set;}

        public HousingPlan_SubType(){
            options = new List<HousingPlan_Option>();
        }
        public HousingPlan_SubType(String n, List<HousingPlan_Option> opts){
            options = opts;
            name = n; 
        }
    }

    public class HousingPlan_Option {
    
        @AuraEnabled public NCMT_Housing_Plan_Option__c record {get;set;}
        //@AuraEnabled public NCMT_TI_TRCS_Cost_Detail__c titrcsDetail {get;set;}
        //TODO: other cost detail records here
        @AuraEnabled public Boolean selected {get;set;}
        @AuraEnabled public NCMT_Housing_Plan_Option_Selection__c optSelect {get;set;}
        
        public HousingPlan_Option(){
            selected = false;
        }
        public HousingPlan_Option(NCMT_Housing_Plan_Option__c planOpt) {
            record = planOpt;
            selected = false;
        }
    
    
    }
}