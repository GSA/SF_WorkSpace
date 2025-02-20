trigger NCMT_CEW_Project_Agency_trigger on NCMT_CEW_Project_Agency__c (before insert, before update) {
    
    set<id> AgencyIds = new set<id>();
    List<string> AgencyTierLst = new List<string>();
    
    //get current year and convert to string for comparison to fiscal year
    NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
    Date CostParameterDate = ncmt_customsettings.Cost_Parameter_Date__c;
    string CostParameterYear = string.valueof(CostParameterDate.year()+1); 

    if((trigger.isInsert && trigger.isBefore) || (trigger.isUpdate && trigger.IsBefore)) {
        map<string,decimal> TierAllowMap = new map<string,decimal>();
        
         for(NCMT_CEW_Project_Agency__c iter :trigger.new){
             AgencyIds.add(iter.id);
             AgencyTierLst.add(iter.Agency_Tier__c);      
         }
         //system.debug('AgencyTierLst=='+AgencyTierLst);
        
        List <NCMT_CEW_Parameter__c> CEWParamlst = [SELECT Id,Name,Fiscal_Year__c,Criteria_1__c,Type__c,Value__c 
                                                      FROM NCMT_CEW_Parameter__c 
                                                     WHERE Criteria_1__c IN :AgencyTierLst
                                                       and Name = 'Tier'
                                                       and Fiscal_year__c = :CostParameterYear];
               //system.debug('CEWParamlst =='+CEWParamlst );                                        
                                                       
            for(NCMT_CEW_Parameter__c CEWlist :CEWParamlst ){    
                TierAllowMap.put(CEWlist.Criteria_1__c,CEWlist.Value__c);
            }
            for(NCMT_CEW_Project_Agency__c iter :trigger.new){
               
                if(trigger.isinsert || (trigger.isupdate && trigger.oldmap.get(iter.id).Agency_Tier__c != iter.Agency_Tier__c)){
                    iter.Tier_Allowance__c = TierAllowMap.get(iter.Agency_Tier__c);
                }
          }     
    
    
    }
}