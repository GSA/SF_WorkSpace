/**
* @Description Append unique identifier to PBS_Project Name field. 
**/
trigger PBS_ProjectNameTrigger on PBS_Project__c (before insert) {
  try{
      //get the config doc
      soptConfig__c config = [SELECT Name, txtaLabel_1__c, txtaLabel_2__c FROM soptConfig__c WHERE Name = 'PBS Project Auto Numbers' LIMIT 1 FOR UPDATE];
      for (PBS_Project__c proj: Trigger.new) {
        //Get the record type
        String recType = proj.txtCreatedIn__c;
        //Continue if this is not an epm project or txtCreatedIn is not empty
        if (recType.toLowercase() != 'epm' && recType != '') {
            //Get record count to increment
            //// cannot use count() in triggers, hits governor limits
            ////Integer recCount = [Select count() FROM PBS_Project__c WHERE txtCreatedIn__c = :recType];
            Integer recCount;
            if (recType.toLowercase() == 'sopt'){
            //assign recCount
            recCount = Integer.valueOf(config.txtaLabel_1__c);
            //update the config record  
            config.txtaLabel_1__c = String.valueOf(recCount+1);                
            } else if (recType.toLowercase() == 'gbuild'){
            //assign recCount to use
            recCount = Integer.valueOf(config.txtaLabel_2__c);
            //update the config record to next record to use
            config.txtaLabel_2__c = String.valueOf(recCount+1);                            
            }
            //Assemble the new number
            String prefix = recType.toLowercase().substring(0,2);

            String newNumberStr;
            //Seven digits minus the length of the actual number, gives us how many zeros
            Integer lenNumber = 7 - String.valueOf(recCount).length();
            String zeroStr = '';
            if (lenNumber > 0){
                for(Integer x=0; x<lenNumber; x++){
                  zeroStr = zeroStr + '0';
                } //end for
            } //end if
            newNumberStr = zeroStr+String.valueOf(recCount);

            //Truncate the long project name field
            Integer nmLen = proj.txtLongName__c.length();
            if (nmLen > 71) {
              nmLen = 71;
            }      
            String longName = proj.txtLongName__c.subString(0,nmLen);

            //Assign concatination to name field
            String newName = longName+prefix+newNumberStr;          
            proj.Name = newName;  
        } //end if
      } //end for
      upsert config;
    }catch(Exception e){
        system.debug('Error in PBS_ProjectNameTrigger: ' + e);
    } //end try catch
}