trigger NCMT_ProfessionalServiceEstimateTrigger on Professional_Service_Estimate__c (after insert, after update, before insert, before update) {
    String strstate;
    String strlocation;
    String strBuilding_Type; 
    String strProject_Type;
    String strDelivery_Method;
    String strCM_Role;
    String strDesign_Build_Leased_Delivery_Only;
    ID ProfServEstRecordID;
    Decimal dblECC;
    Decimal dblEstimated_Total_GSF;
    Date Anticipated_Date_of_Design_Award;
    Date Base_Date_of_Estimate;
    ID ProfServEstCECCID;
    ID ProfServEstECCID;
    string strFor_Design_Build_Owned_Stipend_Compl;
    string strFor_Design_Build_Owned_Stipend_Detail;
    String strScope, strEstimatedNumberofPhases;
    Decimal dblCECC;
    
    Professional_Service_Estimate__c OldValues;
    NCMT_ProfessionalServiceEstimate ProfServEst = new NCMT_ProfessionalServiceEstimate();
    
        for (Professional_Service_Estimate__c  objProfServEst:Trigger.new){
            strstate = objProfServEst.State__c;
            strlocation = objProfServEst.Location_Parameter_Name__c;
            strBuilding_Type = objProfServEst.Building_Type__c;
            strProject_Type = objProfServEst.Project_Type__c;
            strDelivery_Method = objProfServEst.Delivery_Method__c;  
            strCM_Role = objProfServEst.CM_Role__c;  
            strDesign_Build_Leased_Delivery_Only = objProfServEst.Design_Build_Leased_Delivery_Only__c;  
            
            ProfServEstRecordID = objProfServEst.ID;
            ProfServEstCECCID = objProfServEst.AE_CMa_CMc_Cx_CECC__c;
            ProfServEstECCID = objProfServEst.AE_CMa_CMc_Cx_ECC__c;
            dblCECC = objProfServEst.CECC__c;
            dblECC = objProfServEst.ECC__c;
            
            dblEstimated_Total_GSF = objProfServEst.Estimated_Total_GSF__c;
            Anticipated_Date_of_Design_Award = objProfServEst.Anticipated_Date_of_Design_Award__c;
            Base_Date_of_Estimate = objProfServEst.Base_Date_of_Estimate__c;
            strFor_Design_Build_Owned_Stipend_Compl = objProfServEst.For_Design_Build_Owned_Stipend_Compl__c;
            strFor_Design_Build_Owned_Stipend_Detail = objProfServEst.For_Design_Build_Owned_Stipend_Detail__c;
            strScope = objProfServEst.Scope__c;
            strEstimatedNumberofPhases = objProfServEst.Estimated_Number_of_Phases__c;
        }
            
    System.debug('RUN PROF SERVICE EST TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers) {
        
        if (Trigger.isInsert && Trigger.isBefore) {
            //update Prof Serv Est with Cost Paramter lookup
            ProfServEst.UpdateCostParameterDate(trigger.new);                
            ProfServEst.UpdateProfServEstData(trigger.new, strstate, strlocation, strBuilding_Type, strProject_Type, strDelivery_Method, strCM_Role, strDesign_Build_Leased_Delivery_Only, strScope, strEstimatedNumberofPhases); 
        }
        
        if (Trigger.isInsert && Trigger.isAfter) {
            NCMT_ProfSevEstTriggerValue.firstRun = false;
            //generate ProfServEstList records
            ProfServEst.GenerateProfServEstListData (ProfServEstRecordID, ProfServEstCECCID, ProfServEstECCID, dblCECC, dblECC); 
        }
        
        if (Trigger.isUpdate && Trigger.isBefore && NCMT_ProfSevEstTriggerValue.firstRun == true) {

            OldValues = Trigger.oldMap.get(ProfServEstRecordID);
            
            if (strstate != OldValues.State__c || strlocation != OldValues.Location_Parameter_Name__c
                            || strBuilding_Type != OldValues.Building_Type__c || strProject_Type != OldValues.Project_Type__c 
                            || strDelivery_Method != OldValues.Delivery_Method__c || strCM_Role!= OldValues.CM_Role__c
                            || dblECC != OldValues.ECC__c || dblEstimated_Total_GSF != OldValues.Estimated_Total_GSF__c
                            || Anticipated_Date_of_Design_Award != OldValues.Anticipated_Date_of_Design_Award__c
                            || Base_Date_of_Estimate != OldValues.Base_Date_of_Estimate__c
                            || strDesign_Build_Leased_Delivery_Only != OldValues.Design_Build_Leased_Delivery_Only__c
                            || strFor_Design_Build_Owned_Stipend_Compl != OldValues.For_Design_Build_Owned_Stipend_Compl__c
                            || strFor_Design_Build_Owned_Stipend_Detail != OldValues.For_Design_Build_Owned_Stipend_Detail__c
                            || strScope != OldValues.Scope__c
                            || strEstimatedNumberofPhases != OldValues.Estimated_Number_of_Phases__c) {

                ProfServEst.UpdateProfServEstData(trigger.new, strstate, strlocation, strBuilding_Type, strProject_Type, strDelivery_Method, strCM_Role, strDesign_Build_Leased_Delivery_Only, strScope, strEstimatedNumberofPhases);                 
            }   
        }
        
        if (Trigger.isUpdate && Trigger.isAfter && NCMT_ProfSevEstTriggerValue.firstRun == true) {
            NCMT_ProfSevEstTriggerValue.firstRun = false;
       
            OldValues = Trigger.oldMap.get(ProfServEstRecordID);
            
            if (strstate != OldValues.State__c || strlocation != OldValues.Location_Parameter_Name__c
                            || strBuilding_Type != OldValues.Building_Type__c || strProject_Type != OldValues.Project_Type__c 
                            || strDelivery_Method != OldValues.Delivery_Method__c || strCM_Role!= OldValues.CM_Role__c
                            || dblECC != OldValues.ECC__c || dblEstimated_Total_GSF != OldValues.Estimated_Total_GSF__c
                            || Anticipated_Date_of_Design_Award != OldValues.Anticipated_Date_of_Design_Award__c
                            || Base_Date_of_Estimate != OldValues.Base_Date_of_Estimate__c
                            || strDesign_Build_Leased_Delivery_Only != OldValues.Design_Build_Leased_Delivery_Only__c) {
                            
                //generate ProfServEstList records
                ProfServEst.DeleteProfServEstListData(ProfServEstRecordID);
                ProfServEst.GenerateProfServEstListData (ProfServEstRecordID, ProfServEstCECCID, ProfServEstECCID, dblCECC, dblECC);
            }       
        }
    }
}