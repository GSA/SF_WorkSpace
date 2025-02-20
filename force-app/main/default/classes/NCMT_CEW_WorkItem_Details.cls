public with sharing class NCMT_CEW_WorkItem_Details {
    
    public static void CEWAgencyinfo(set<id> AgencyIds,set<id> NCMTIdsset,set<id> CEW_WI_Ids){
        map<string,decimal> totalcost6Map = new map<string,decimal>();
        map<string,decimal> totalcost7Map = new map<string,decimal>();
        map<string,decimal> totalcost8Map = new map<string,decimal>();
        string strNumber;
        
        for (AggregateResult ar : [SELECT sum(Total_Direct_Cost__c) totalcost,CEW_Project_Agency__c projagency,NCMT_CEW_Work_Description__r.Number__c number
                                         FROM NCMT_CEW_Work_Item__c 
                                        WHERE CEW_Project_Agency__c IN : AgencyIds
                                         and WorkDescNumber__c IN (6,7,8)
                                        GROUP BY CEW_Project_Agency__c,NCMT_CEW_Work_Description__r.Number__c]) {
                                        
                 strNumber = (string) ar.get('number');                      
                                        
                 if(strNumber == '6'){
                     totalcost6Map.put(string.valueof(ar.get('projagency')),(Decimal) ar.get('totalcost'));
                 }else if(strNumber == '7'){
                     totalcost7Map.put(string.valueof(ar.get('projagency')),(Decimal) ar.get('totalcost'));
                 }else if(strNumber == '8'){
                     totalcost8Map.put(string.valueof(ar.get('projagency')),(Decimal) ar.get('totalcost'));
                 }                       
                                           
           }  
           
           list<NCMT_CEW_Project_Agency__c> CEWAgencyList = [SELECT Totals_RWA_Direct_Cost__c,Totals_TI_Fit_Out_Direct_Cost__c,Total_Security_Direct_Cost__c
                                                                FROM NCMT_CEW_Project_Agency__c
                                                                WHERE id In :AgencyIds];
              //system.debug('CEWAgencyList  =='+CEWAgencyList  );                                                  
            list<NCMT_CEW_Project_Agency__c> CEWAgencyUpdateList = new list<NCMT_CEW_Project_Agency__c>();
            
            for(NCMT_CEW_Project_Agency__c CEWAgency : CEWAgencyList){
                    
                if(totalcost6Map.size()>0){
                    CEWAgency.Totals_TI_Fit_Out_Direct_Cost__c = totalcost6Map.get(CEWAgency.Id);
                }else{
                    CEWAgency.Totals_TI_Fit_Out_Direct_Cost__c = 0;
                }
                if(totalcost7Map.size()>0){
                    CEWAgency.Total_Security_Direct_Cost__c = totalcost7Map.get(CEWAgency.Id);
                }else{   
                    CEWAgency.Total_Security_Direct_Cost__c =0;
                }
                if(totalcost8Map.size()>0){
                    CEWAgency.Totals_RWA_Direct_Cost__c = totalcost8Map.get(CEWAgency.Id);
                }else{   
                    CEWAgency.Totals_RWA_Direct_Cost__c =0;
                }
                
                
                    CEWAgencyUpdateList.add(CEWAgency);
            }
            upsert CEWAgencyUpdateList;
        
    }

}