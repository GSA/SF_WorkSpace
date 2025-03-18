/**
 * Created by nkopparthi on 8/29/19.
 */

public with sharing class PBS_LOP_RSAPpvController {

    Boolean showContacts ;
    Boolean showScheduleItems ;
    Boolean showRegistrationItems ;
    Boolean showFormResponses ;

    static String recId = ApexPages.currentPage().getParameters().get('offerId'); //'a03r00000030up9';
    public PBS_AAAP_Offer__c OfferRec {get; set;}
    public List<Decimal> stepRents {get; set;}
    Public Decimal rsapFreeMonths {get; set;}
    Public Decimal fR1 {get; set;}
    Public Decimal fR2 {get; set;}
    Public Decimal fR3 {get; set;}
    Public Decimal fR4 {get; set;}
    Public Decimal fR5 {get; set;}
    Public Decimal fR6 {get; set;}
    Public Decimal fR7 {get; set;}
    Public Decimal fR8 {get; set;}
    Public Decimal fR9 {get; set;}
    Public Decimal fR10 {get; set;}
    Public Decimal fR11 {get; set;}
    Public Decimal fR12 {get; set;}
    Public Decimal fR13 {get; set;}
    Public Decimal fR14 {get; set;}
    Public Decimal fR15 {get; set;}
    Public Decimal fR16 {get; set;}
    Public Decimal fR17 {get; set;}
    Public Decimal fR18 {get; set;}
    Public Decimal fR19 {get; set;}
    Public Decimal fR20 {get; set;}

    public Decimal calc1 {get; set;}
    public Decimal calc2 {get; set;}

    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';

            return strHeader;
        }
    }

    // constructor
    public PBS_LOP_RSAPpvController(){

        String objectName = 'PBS_AAAP_Offer__c';
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = new Map<String, Schema.SObjectField>();
        objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        for(String s : objectFields.keySet()) {
            query += ' ' + s + ',';
        }

        // Manually add related object's fields that are needed.
        //query += 'Account.Name,'; // modify as needed

        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }

        query += ' FROM ' + objectName;

        query += ' WHERE Id =: recId'; // modify as needed

        OfferRec = database.query(query);

        stepRents = new List<Decimal>();

        if(OfferRec.PBS_AAAP_Step_1_Start__c != 0 && OfferRec.PBS_AAAP_Step_1_Start__c != NULL && OfferRec.PBS_AAAP_Step_1_End__c != 0 && OfferRec.PBS_AAAP_Step_1_End__c != NULL){
            Integer iniVal1 = Integer.valueOf(OfferRec.PBS_AAAP_Step_1_Start__c);
            Integer endVAl1 = Integer.valueOf(OfferRec.PBS_AAAP_Step_1_End__c);
            system.debug('***'+iniVal1+'***'+endVAl1);
            for(Integer i = iniVal1; i <= endVAl1; i++){
                system.debug('---'+OfferRec.PBS_AAAP_Step_1_Rent_Per_ABOA__c);
                stepRents.add(OfferRec.PBS_AAAP_Step_1_Rent_Per_ABOA__c);
            }
        }

        if(OfferRec.PBS_AAAP_Step_2_Start__c != 0 && OfferRec.PBS_AAAP_Step_2_Start__c != NULL && OfferRec.PBS_AAAP_Step_2_End__c != 0 && OfferRec.PBS_AAAP_Step_2_End__c != NULL){
            Integer iniVal2 = Integer.valueOf(OfferRec.PBS_AAAP_Step_2_Start__c);
            Integer endVAl2 = Integer.valueOf(OfferRec.PBS_AAAP_Step_2_End__c);
            system.debug('***'+iniVal2+'***'+endVAl2);
            for(Integer i = iniVal2; i <= endVAl2; i++){
                system.debug('---'+OfferRec.PBS_AAAP_Step_2_Rent_Per_ABOA__c);
                stepRents.add(OfferRec.PBS_AAAP_Step_2_Rent_Per_ABOA__c);
            }
        }

        if(OfferRec.PBS_AAAP_Step_3_Start__c != 0 && OfferRec.PBS_AAAP_Step_3_Start__c != NULL && OfferRec.PBS_AAAP_Step_3_End__c != 0 && OfferRec.PBS_AAAP_Step_3_End__c != NULL){
            Integer iniVal3 = Integer.valueOf(OfferRec.PBS_AAAP_Step_3_Start__c);
            Integer endVAl3 = Integer.valueOf(OfferRec.PBS_AAAP_Step_3_End__c);
            system.debug('***'+iniVal3+'***'+endVAl3);
            for(Integer i = iniVal3; i <= endVAl3; i++){
                system.debug('---'+OfferRec.PBS_AAAP_Step_3_Rent_Per_ABOA__c);
                stepRents.add(OfferRec.PBS_AAAP_Step_3_Rent_Per_ABOA__c);
            }
        }

        rsapFreeMonths = OfferRec.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c == null ? 0 : OfferRec.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c;

        fR1 = rsapFreeMonths > 12 ? 12 : rsapFreeMonths;
        fr2 = fR1 < 12 ? 0 : rsapFreeMonths > 24 ? 12 : rsapFreeMonths-12;
        fr3 = fR2 < 12 ? 0 : rsapFreeMonths > 36 ? 12 : rsapFreeMonths-24;
        fr4 = fR3 < 12 ? 0 : rsapFreeMonths > 48 ? 12 : rsapFreeMonths-36;
        fr5 = fR4 < 12 ? 0 : rsapFreeMonths > 60 ? 12 : rsapFreeMonths-48;
        fr6 = fR5 < 12 ? 0 : rsapFreeMonths > 72 ? 12 : rsapFreeMonths-60;
        fr7 = fR6 < 12 ? 0 : rsapFreeMonths > 84 ? 12 : rsapFreeMonths-72;
        fr8 = fR7 < 12 ? 0 : rsapFreeMonths > 96 ? 12 : rsapFreeMonths-84;
        fr9 = fR8 < 12 ? 0 : rsapFreeMonths > 108 ? 12 : rsapFreeMonths-96;
        fr10 = fR9 < 12 ? 0 : rsapFreeMonths > 120 ? 12 : rsapFreeMonths-108;
        fr11 = fR10 < 12 ? 0 : rsapFreeMonths > 132 ? 12 : rsapFreeMonths-120;
        fr12 = fR11 < 12 ? 0 : rsapFreeMonths > 144 ? 12 : rsapFreeMonths-132;
        fr13 = fR12 < 12 ? 0 : rsapFreeMonths > 156 ? 12 : rsapFreeMonths-144;
        fr14 = fR13 < 12 ? 0 : rsapFreeMonths > 168 ? 12 : rsapFreeMonths-156;
        fr15 = fR14 < 12 ? 0 : rsapFreeMonths > 180 ? 12 : rsapFreeMonths-168;
        fr16 = fR15 < 12 ? 0 : rsapFreeMonths > 192 ? 12 : rsapFreeMonths-180;
        fr17 = fR16 < 12 ? 0 : rsapFreeMonths > 204 ? 12 : rsapFreeMonths-192;
        fr18 = fR17 < 12 ? 0 : rsapFreeMonths > 216 ? 12 : rsapFreeMonths-204;
        fr19 = fR18 < 12 ? 0 : rsapFreeMonths > 228 ? 12 : rsapFreeMonths-216;
        fr20 = fR19 < 12 ? 0 : rsapFreeMonths > 240 ? 12 : rsapFreeMonths-228;

        calc1 = OfferRec.PBS_AAAP_Shell_Rent_Per_ABOA__c.setScale(2);
        calc2 = OfferRec.PBS_AAAP_OP_COST_COST_PER_ABOA__c.setScale(2);

    }




}