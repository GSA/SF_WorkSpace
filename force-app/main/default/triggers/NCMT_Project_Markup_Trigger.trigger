trigger NCMT_Project_Markup_Trigger on NCMT_Project_Markup__c (after update) {

    String strProjectRecordID;
    ID projMarkupID;
    decimal dblSalesTax = 0;
    decimal dblLaborMarkup = 0;
    decimal dblEquipmentMarkup = 0;
    decimal dblMaterialMarkup = 0;
    NCMT_Project_Markup__c OldValues;
    if(trigger.isAfter && trigger.isUpdate){
        for(NCMT_Project_Markup__c obj :trigger.new){
        
            strProjectRecordID = obj.Project_Name__c;
            projMarkupID = obj.ID;
            dblSalesTax = obj.Sales_Tax__c;
            dblLaborMarkup = obj.Labor_Project_Premium_Markup__c;
            dblEquipmentMarkup = obj.Equipment_Project_Premium_Markup__c; 
            dblMaterialMarkup = obj.Material_Project_Premium_Markup__c;
        }
         OldValues = Trigger.oldMap.get(projMarkupID);
         strProjectRecordID = strProjectRecordID.substring(0,strProjectRecordID.length()-3);
         
         List<NCMT_DES_Items__c> DESItemsList = [Select ID, Name,Sales_Tax__c,Equipment_Project_Premium_Markup__c,Labor_Project_Premium_Markup__c,Material_Project_Premium_Markup__c
                                                From NCMT_DES_Items__c 
                                                where NCMT_Project_ID__c = :strProjectRecordID];
         //Added for SFWS-2018 for Project Premium Markups
        if(dblSalestax != OldValues.Sales_Tax__c || dblMaterialMarkup != OldValues.Material_Project_Premium_Markup__c || dblEquipmentMarkup != OldValues.Equipment_Project_Premium_Markup__c || dblLaborMarkup != OldValues.Labor_Project_Premium_Markup__c){
         //  if(dblSalestax != OldValues.Sales_Tax__c){
             for(NCMT_DES_Items__c DESILst :DESItemsList){
                 DESILst.Sales_Tax__c = dblSalesTax;
                 DESILst.Labor_Project_Premium_Markup__c = dblLaborMarkup; 
                 DESILst.Material_Project_Premium_Markup__c = dblMaterialMarkup;
                 DESILst.Equipment_Project_Premium_Markup__c = dblEquipmentMarkup; 
                
             }
             
             update DESItemsList;
             
         }
         
  
    }
}