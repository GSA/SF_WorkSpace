public with sharing class NCMT_CustomLookUpController {

    @AuraEnabled 
    public static List<sObject> fetchLookUpValues(string searchKeyWord, string objectName, string fiscalYear){
        system.debug('searchKeyWord-->' + searchKeyWord);
        //searchKeyWord = 'test';
        string searchKey;
        if (searchKeyWord != null &&searchKeyWord != '') searchKey = '%' + String.escapeSingleQuotes(searchKeyWord) + '%';
        String oName = '';
        if (objectName != null &&objectName != '') oName = String.escapeSingleQuotes(objectName);
        String fYear = '';
        if (fiscalYear != null &&fiscalYear != '') fYear = String.escapeSingleQuotes(fiscalYear);
        
        string searchVar;
        string whereVar = '';
    
    
        if (oName == 'NCMT_Project__c'){
            if (searchKeyWord != null &&searchKeyWord != '' &&searchKeyWord.length() > 2){
                whereVar = ' where Name LIKE: searchKey';
            } else {
               whereVar = ' where LastViewedDate != null';
            }
        } else {
            if (searchKeyWord != '' &&searchKeyWord != null){
                whereVar = ' where Name LIKE: searchKey';
            } else {
                whereVar = ' where Id <> null';
            }
        }
    
        system.debug('whereVar-->' + whereVar);
        // List<sObject> returnList = new List<sObject>();
        if(fiscalYear != null) whereVar = whereVar + ' and Fiscal_Year__c = \'' + fYear+'\'';
        if(oName == 'NCMT_Assembly_Lookup_Detail__c'){
            searchVar = 'Level_2_Description__c, Level_3_Description__c, Level_4_Description__c,Description__c';
           
        }else if(oName == 'NCMT_Contractor__c'){
        	searchVar = 'name, Contractor_Description__c';
        }
        else{ 
            searchVar = 'name';
        } 
       
        string sQuery = 'select id, ' + searchVar + '  from ' + oName + ' '+ whereVar + ' order by ';
        
        if (oName == 'NCMT_Project__c'){
            if (searchKeyWord != null &&searchKeyWord != '' &&searchKeyWord.length() > 2){
                sQuery += 'Name limit 50';
            } else {
                sQuery += 'LastViewedDate DESC limit 50';
            }
        
        } else {
            sQuery += 'name';
        }
        
        system.debug('squery' + sQuery);

        List<sObject> returnList = Database.query(sQuery);
        
        
        return returnList;
 
    }

    @AuraEnabled 
    public static List<sObject> fetchMultiSelectLookup(string searchKeyWord, string objectName, string pageName, List<sObject> ExcludeitemsList){
        if (searchKeyWord != null &&searchKeyWord != '') searchKeyWord = String.escapeSingleQuotes(searchKeyWord);
        String oName = '';
        if (objectName != null &&objectName != '') oName = String.escapeSingleQuotes(objectName);
        
         string[] alreadyAdded = new string[]{};
        for(sObject item : ExcludeitemsList ){
            alreadyAdded.add(item.id);
        }
        system.debug('already added' + alreadyAdded);

        string tCORecordTypeName = 'New Construction - TCO';
        string searchKey = '%' + searchKeyWord + '%';
        string searchVar = 'name';
        string whereVar;
        if (searchKeyWord != null &&searchKeyWord != '' &&searchKeyWord.length() > 2){
            whereVar = ' where Name LIKE: searchKey';
        } else {
            whereVar = ' where LastViewedDate !=null';
        }

        // List<sObject> returnList = new List<sObject>();
        if(pageName == 'Project_Comparison'){
            whereVar = whereVar + ' and RecordType.Name = \''+ tCORecordTypeName +'\'' ;
            searchVar = searchVar  + ', End_Construction__c, Basis_Date_Of_Estimate__c, Prorated_ODC__c, TI_OPC__c, Coreshell_OPC__c, Prorated_OPC__c, Standard_Esc_Rate__c, Footprint_Area__c';
                }
        else{
            searchVar = 'name';
        } 
        string sQuery = 'select id, ' + searchVar + '  from ' + oName + ' '+ whereVar + ' AND Id NOT IN :alreadyAdded order by ';
        if (searchKeyWord != null &&searchKeyWord != '' &&searchKeyWord.length() > 2){
            sQuery += 'createdDate DESC';
        } else {
            sQuery += 'LastViewedDate DESC limit 10';
        }
        system.debug('squery' + sQuery);
        List<sObject> returnList = Database.query(sQuery);
        
        return returnList;
    }
}