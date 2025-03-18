//public with sharing class PBS_AAAP_AwardedOffersInfo {//JK removed with sharing on 2.3.21
public class PBS_AAAP_AwardedOffersInfo {

    public List<PBS_AAAP_Offer_Select_Award_Info__c> awardOffers { get; set;}
    
    public PBS_AAAP_AwardedOffersInfo() {
        /**
        awardOffers = [
            SELECT  p.PBS_AAAP_Total_Contract_Amount__c, p.PBS_AAAP_Offer_ID__r.PBS_AAAP_Street_Address__c, p.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_Lease_Term__c,
            p.PBS_AAAP_Offer_ID__r.PBS_AAAP_City__c, p.PBS_AAAP_Offer_ID__r.PBS_AAAP_State__c, p.PBS_AAAP_Offer_ID__r.PBS_AAAP_ZipCode__c,
            p.PBS_AAAP_Offer_ID__r.PBS_AAAP_Owner_Name__c, p.PBS_AAAP_Offer_ID__r.PBS_AAAP_Building_Name__c, p.PBS_AAAP_Offer_ID__c, p.PBS_AAAP_NEW_GSA_LEASE_NUM__c, 
            p.PBS_AAAP_CONTRACT_AWARD_DATE__c, p.PBS_AAAP_AWARDED_USF__c, p.PBS_AAAP_Offer_ID__r.Formula_RLP_Region__c
            FROM PBS_AAAP_Offer_Select_Award_Info__c p
            WHERE p.PBS_AAAP_IsAwarded__c = TRUE 
            ORDER BY p.PBS_AAAP_CONTRACT_AWARD_DATE__c DESC limit 500
        ];**/
        
        awardOffers = [
            SELECT  PBS_AAAP_Total_Contract_Amount__c, PBS_AAAP_Offer_ID__r.PBS_AAAP_Street_Address__c, PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_Lease_Term__c,
            PBS_AAAP_Offer_ID__r.PBS_AAAP_City__c, PBS_AAAP_Offer_ID__r.PBS_AAAP_State__c, PBS_AAAP_Offer_ID__r.PBS_AAAP_ZipCode__c,
            PBS_AAAP_Offer_ID__r.PBS_AAAP_Owner_Name__c, PBS_AAAP_Offer_ID__r.PBS_AAAP_Building_Name__c, PBS_AAAP_Offer_ID__c, PBS_AAAP_NEW_GSA_LEASE_NUM__c, 
            PBS_AAAP_CONTRACT_AWARD_DATE__c, PBS_AAAP_AWARDED_USF__c, PBS_AAAP_Offer_ID__r.Formula_RLP_Region__c
            FROM PBS_AAAP_Offer_Select_Award_Info__c 
            WHERE PBS_AAAP_IsAwarded__c = TRUE 
            ORDER BY PBS_AAAP_CONTRACT_AWARD_DATE__c DESC limit 500
        ];

        system.debug('JK user ' + UserInfo.getName());
        system.debug('<<<NIKILESH>>>'+awardOffers);
        system.debug('JK street address ' + awardOffers[0].PBS_AAAP_Offer_ID__r.PBS_AAAP_Street_Address__c);
        system.debug('JK city ' + awardOffers[0].PBS_AAAP_Offer_ID__r.PBS_AAAP_City__c);
        system.debug('JK state ' + awardOffers[0].PBS_AAAP_Offer_ID__r.PBS_AAAP_State__c);
        system.debug('JK zip ' + awardOffers[0].PBS_AAAP_Offer_ID__r.PBS_AAAP_ZipCode__c);
        system.debug('JK owner name ' + awardOffers[0].PBS_AAAP_Offer_ID__r.PBS_AAAP_Owner_Name__c);
        system.debug('JK region ' + awardOffers[0].PBS_AAAP_Offer_ID__r.Formula_RLP_Region__c);
        
        for(PBS_AAAP_Offer_Select_Award_Info__c a : awardOffers){
            String i = a.PBS_AAAP_Offer_ID__r.PBS_AAAP_Building_Name__c;
            System.debug('JK i ' + i);
            if(i != '' && i != null){            
                system.debug('%%%NIK%%%1'+i);
                List<String> words = i.split(' ');
                system.debug('%%%NIK%%%2'+words);
                List<String> newwords = new List<String>();
                for(String w : words){
                    system.debug('%%%NIK%%%3'+w);
                    Integer j = w.length();
                    system.debug('%%%NIK%%%4'+j);
                    if(j>15){
                        w = w.substring(0, 8) + '-' + w.substring(9, w.length());
                        //w = w.substring(0,6);
                        //w = w+'...';
                    }
                    system.debug('%%%NIK%%%5'+w);
                    newWords.add(w);
                }
                string newi = string.join(newwords,' ');
                system.debug('%%%NIK%%%6'+newi);
                a.PBS_AAAP_Offer_ID__r.PBS_AAAP_Building_Name__c = newi;
            }
													
											
																	
        }   
        
        for(PBS_AAAP_Offer_Select_Award_Info__c a : awardOffers){
            String i = a.PBS_AAAP_Offer_ID__r.PBS_AAAP_Street_Address__c;      
            if(i != '' && i != null){     
                system.debug('%%%NIK%%%1'+i);
                List<String> words = i.split(' ');
                system.debug('%%%NIK%%%2'+words);
                List<String> newwords = new List<String>();
                for(String w : words){
                    system.debug('%%%NIK%%%3'+w);
                    Integer j = w.length();
                    system.debug('%%%NIK%%%4'+j);
                    if(j>15){
                        w = w.substring(0, 8) + '-' + w.substring(9, w.length());
                        //w = w.substring(0,6);
                        //w = w+'...';
                    }
                    system.debug('%%%NIK%%%5'+w);
                    newWords.add(w);
                }
                string newi = string.join(newwords,' ');
                system.debug('%%%NIK%%%6'+newi);
                a.PBS_AAAP_Offer_ID__r.PBS_AAAP_Street_Address__c = newi;
            }
													
											
																	 
        }   
        
        for(PBS_AAAP_Offer_Select_Award_Info__c a : awardOffers){
            String i = a.PBS_AAAP_Offer_ID__r.PBS_AAAP_Owner_Name__c;  
            if(i != '' && i != null){          
                system.debug('%%%NIK%%%1'+i);
                List<String> words = i.split(' ');
                system.debug('%%%NIK%%%2'+words);
                List<String> newwords = new List<String>();
                for(String w : words){
                    system.debug('%%%NIK%%%3'+w);
                    Integer j = w.length();
                    system.debug('%%%NIK%%%4'+j);
                    if(j>15){
                        w = w.substring(0, 8) + '-' + w.substring(9, w.length());
                        //w = w.substring(0,6);
                        //w = w+'...';
                    }
                    system.debug('%%%NIK%%%5'+w);
                    newWords.add(w);
                }
											 
								
			 
                string newi = string.join(newwords,' ');
                system.debug('%%%NIK%%%6'+newi);
                a.PBS_AAAP_Offer_ID__r.PBS_AAAP_Owner_Name__c = newi;
           }
       }        
        
    }


}