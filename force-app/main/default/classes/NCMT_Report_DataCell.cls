public with sharing class NCMT_Report_DataCell {

    @AuraEnabled public Object value {get;set;}
    @AuraEnabled public NCMT_Report_ValueMetaData valueMeta {get;set;}
    /*Maybe useful?
    @AuraEnabled
    public String toolTip {get;set;}*/

    public NCMT_Report_DataCell(SObject sobj, NCMT_Report_ValueMetaData meta, Boolean storeMeta){
        
        Object cellVal = sobj.get(meta.fieldAPIName);
        //Percent fix
        if (cellVal != null &&meta.dataType == 'number' &&meta.numberStyle == 'percent'){
            Double dbl = Double.valueOf(cellVal);
            dbl = dbl / 100;
            cellVal = dbl;
        }
        
        value = cellVal;
        //Comparison report rows don't need meta at the cell level, only store if needed
        if (storeMeta)
            valueMeta = meta;
    }

    //For calculated values that are input in the logic
    public NCMT_Report_DataCell(){
        
    }
}