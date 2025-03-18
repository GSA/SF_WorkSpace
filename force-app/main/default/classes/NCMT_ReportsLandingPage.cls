public with sharing class NCMT_ReportsLandingPage {
	
	string strSOQLSelect = 'Select r.Name, r.IsDeleted, r.Id, r.Description From Report r Where r.Description = ';
    string strSOQLWhere = ' and IsDeleted = false Order By r.Name';
    
    // **** Retrieve the Project Reports . ****//
    public Report[] getProjectReports() {
        string strSOQL = strSOQLSelect + '\'NCMT REPORTS\'' + strSOQLWhere;
        return Database.query(strSOQL);
    }  
    
    // **** Retrieve the Project Costs Look Ups . ****//
    public Report[] getProjectLookUpReports() {
        string strSOQL = strSOQLSelect + '\'NCMT LOOKUP\'' + strSOQLWhere;
        return Database.query(strSOQL);
    }   
    
    // **** Retrieve the Regional reports from the Reports object. ****//
    public Report[] getRegionalReports() {
        string strSOQL = strSOQLSelect + '\'NCMT PROJECTS REGION\'' + strSOQLWhere;
        return Database.query(strSOQL);
    }
    
    // **** Retrieve the dropdowns values for "Region" dropdown. ****//
    public List<SelectOption> getRegions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('\'1\',\'2\',\'3\',\'4\',\'5\',\'6\',\'7\',\'8\',\'9\',\'10\',\'11\'', '- All Regions -'));
        options.add(new SelectOption('\'1\'', 'Region 01'));
        options.add(new SelectOption('\'2\'', 'Region 02'));
        options.add(new SelectOption('\'3\'', 'Region 03'));
        options.add(new SelectOption('\'4\'', 'Region 04'));
        options.add(new SelectOption('\'5\'', 'Region 05'));
        options.add(new SelectOption('\'6\'', 'Region 06'));
        options.add(new SelectOption('\'7\'', 'Region 07'));
        options.add(new SelectOption('\'8\'', 'Region 08'));
        options.add(new SelectOption('\'9\'', 'Region 09'));
        options.add(new SelectOption('\'10\'', 'Region 10'));
        options.add(new SelectOption('\'11\'', 'Region 11'));
        return options;
    }
    
    public String getCurrentFY() {
     	Integer intCurrentFy = date.today().Year(); //Current Fiscal Year, add +1 after September 
        Integer intCurrentYearMonth = date.today().Month();
        if (intCurrentYearMonth > 9){
            intCurrentFy +=1;
        }
        return string.valueOf(intCurrentFy);
    }
    
     public void setCurrentFY(String s) {
        
    }
    
    // **** Retrieve the dropdowns for "Fiscal Year" dropdown. ****//
    public List<SelectOption> getFiscalYears(){
        List<SelectOption> options = new List<SelectOption>();
        
        Integer intFy; 
                
        Integer intCurrentFy = date.today().Year(); //Current Fiscal Year, add +1 after September 
        Integer intCurrentYearMonth = date.today().Month();
        if (intCurrentYearMonth > 9){
            intCurrentFy +=1;
        }
         
        for (intFy = intCurrentFy -1; intFy <= intCurrentFy; intFy ++) {
            //System.debug('intFy = ' + intFy);
            options.add(new SelectOption(String.valueOf(intFy), String.valueOf(intFy)));
        }
        return options;
    }
    
     // **** Get the REGION associated with the Current Logged in User ... ****//
    String strUserRegionValue = [Select PBS_AAAP_Regions__c from User where id = :UserInfo.getUserId()].PBS_AAAP_Regions__c;
    //String strUserRegionValue = String.valueOf(dcmUserRegion); //Use this line of code if region is a drop-down in the USER Object.
        
    public String getUserRegionValue() {
        return '\'' + strUserRegionValue + '\'';
    }
    
    public void setUserRegionValue(String s) {
        this.strUserRegionValue = s;
    }
    
}