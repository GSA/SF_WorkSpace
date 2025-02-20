trigger NCMT_CEW_Work_Desc_trigger on NCMT_Work_Description__c (after update) {

    set<id> WI_Desc_Ids = new  set<id>();
    map<Id,string> numberMap = new map<Id,string>();
    string strNewNumber, strOldNumber;

    if(trigger.isAfter && trigger.isUpdate){
    
        for(NCMT_Work_Description__c iter :trigger.new){
            
            WI_Desc_Ids.add(iter.Id);
            numberMap.put(iter.Id,iter.Number__c);
            strOldNumber = trigger.oldmap.get(iter.id).Number__c;
            strNewNumber = iter.Number__c;
        }
        if(trigger.isupdate &&  (strOldNumber != strNewNumber) ){
            list<NCMT_CEW_Work_Item__c> CEWWIList = [SELECT Id, WorkDescNumber__c,NCMT_CEW_Work_Description__c,CEW_Project_Agency__c
                                                        FROM NCMT_CEW_Work_Item__c
                                                        WHERE NCMT_CEW_Work_Description__c = :WI_Desc_Ids];
                                                        
             if(CEWWIList.size()>0){
                 for(NCMT_CEW_Work_Item__c WILst :CEWWIList ){
                         WILst.WorkDescNumber__c = integer.valueof(numberMap.get(WILst.NCMT_CEW_Work_Description__c));
                      
                      if((strOldNumber == '6' || strOldNumber == '7' || strOldNumber == '8') && (strNewNumber !='6' && strNewNumber !='7' && strNewNumber !='8')){
                         WILst.CEW_Project_Agency__c = null;
                      }
                     
                 }  
                 update CEWWIList;
             } 
        }                                        
    }

}