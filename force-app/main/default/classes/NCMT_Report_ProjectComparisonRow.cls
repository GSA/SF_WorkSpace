public with sharing class NCMT_Report_ProjectComparisonRow {

    @AuraEnabled public String headerCol {get;set;} //Value in the leftmost column
    @AuraEnabled public List<NCMT_Report_DataCell> cells {get;set;}
    @AuraEnabled public List<NCMT_Chart_JS> charts {get;set;}
    @AuraEnabled public NCMT_Report_ValueMetaData valueMeta {get;set;} //Sets the formatting for all cells after the header column
    @AuraEnabled public Boolean isGroupdProjectRow {get;set;}

    public NCMT_Report_ProjectComparisonRow(){
        charts = new List<NCMT_Chart_JS>();
        cells = new List<NCMT_Report_DataCell>();
        isGroupdProjectRow = false;
    }

}