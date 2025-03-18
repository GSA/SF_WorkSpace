public with sharing class NCMT_Report_ValueMetaData {
    @AuraEnabled public String fieldLabel { get; set; }
    @AuraEnabled public String fieldAPIName { get; set; }
    @AuraEnabled public String dataType {get;set;} //datetime, number, text (corresponds to lightning formatted components)
    @AuraEnabled public String numberStyle {get;set;} //decimal, currency, percent
    @AuraEnabled public Integer maximumFractionDigits {get;set;}//can always adjust this, here or in javascript
    @AuraEnabled public Integer minimumFractionDigits {get;set;}//can always adjust this, here or in javascript
    
    //TODO Datetime formatting options

    /*
    @AuraEnabled
    public Boolean isRequired { get; set; }
    @AuraEnabled 
    public List<Schema.PicklistEntry> pickListValues { get; set; }
    */

    public NCMT_Report_ValueMetaData(){

    }

    public NCMT_Report_ValueMetaData(Schema.FieldSetMember fieldMember){
        switch on fieldMember.getType() {
            when Currency{
                dataType = 'number';
                numberStyle = 'currency';
                maximumFractionDigits = 0;
                minimumFractionDigits = 0;
            }
            /*Not currently used so commenting out for test coverage
            when Integer{
                dataType = 'number';
                numberStyle = 'decimal';
                maximumFractionDigits = 0;
            }*/
            when Double{
                dataType = 'number';
                numberStyle = 'decimal';
                maximumFractionDigits = 0;
                minimumFractionDigits = 0;
            }
            when PERCENT{
                dataType = 'number';
                numberStyle = 'percent';
                maximumFractionDigits = 2;
                minimumFractionDigits = 0;
            }
            when Date{
                dataType = 'datetime';
            }
            /*Not currently used so commenting out for test coverage
            when DATETIME{
                dataType = 'datetime';
            }*/
            
            when BOOLEAN {
                dataType = 'boolean';
            }
            when else {
                dataType = 'text';
            }
        }
        
        fieldLabel = fieldMember.getLabel();
        fieldAPIName = fieldMember.getFieldPath();

        /* Unnecessary for reports but could be handy later
        if(String.valueOf(fieldMember.getType()) == 'PICKLIST' || 
                            String.valueOf(fieldMember.getType()) == 'MULTIPICKLIST'){
            m.pickListValues = sObj.getDescribe().fields.getMap().get(fieldMember.getFieldPath())
                                                        .getDescribe().getPicklistValues();
        }
        */
    }
}