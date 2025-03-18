public with sharing class NCMT_Report_Section {
    @AuraEnabled public String headerLabel {get;set;}
    @AuraEnabled public Boolean defaultExpanded {get;set;}
    @AuraEnabled public String objectName {get;set;}
    @AuraEnabled public List<NCMT_Report_ProjectComparisonRow> rows {get;set;}
    //@AuraEnabled public List<NCMT_Report_ValueMetaData> memberList {get;set;}
    @AuraEnabled public List<NCMT_Report_DataCell> dataCells {get;set;}
    @AuraEnabled public List<NCMT_Chart_JS> charts {get;set;}

    public NCMT_Report_Section(String h){
        headerLabel = h;
        dataCells = new List<NCMT_Report_DataCell>();
        rows = new List<NCMT_Report_ProjectComparisonRow>();
        charts = new List<NCMT_Chart_JS>(); 
        defaultExpanded = false;
    }
    
}