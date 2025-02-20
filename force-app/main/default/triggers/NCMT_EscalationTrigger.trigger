trigger NCMT_EscalationTrigger on NCMT_Escalation__c (after update) {
    
    System.debug('RUN ESCALATION TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {
    
    if(trigger.new.size() > 1){
        // Bulk updates are not supported in Release 1.0, although you could do bulk load with a batch size of 1 ...
        If (NCMT_ProjectTriggerValue.firstRun){ for (NCMT_Escalation__c objEscalation:Trigger.new){ objEscalation.adderror('Please have an administrator set the batch size to 1 if you need to bulk load records.'); } }      
    } else {
        NCMT_ProjectTriggerValue.firstRun = false;
        
        if (Trigger.isAfter && Trigger.isUpdate) {
            ID      ProjectID;
            string  strFY;
            Decimal dblStartRate, dblStandardRate;
            Date    dtConstructionEndDate;
            string  strConstructionEndDateFY;
            
            //Locate the row that was updated
            for (NCMT_Escalation__c objRecord:Trigger.new){
                ProjectID = objRecord.Project__c;
                strFY = objRecord.FY__c;
                dblStartRate = objRecord.Escalation_Percentage__c;
            }
            
            //Update or adjust the escalations records for this project ...
            
//SFWS 1774 starts here (Developer: Ozlem Ece)
            // This code is commented out because of Internal Salesforce.com error on NCMT_GenerateProjectDetailsExt Line 1593
            //(Analysis:Recursion occurrs on the trigger)
            /*NCMT_GenerateProjectDetailsExt objGenerateData = new NCMT_GenerateProjectDetailsExt();
            objGenerateData.AdjustEscalationData(ProjectID);
            */
            
            //Solution:
            
            If(!NCMT_GenerateProjectDetailsExt.firstCall){
               NCMT_GenerateProjectDetailsExt.firstCall=true;
                NCMT_GenerateProjectDetailsExt objGenerateData=new NCMT_GenerateProjectDetailsExt();
                objGenerateData.AdjustEscalationData(ProjectID);
                System.debug('test');
                

            }
//SFWS 1774 solution ends here          
        }
    }
    }
    
}