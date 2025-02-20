public with sharing class NCMT_DataUpload_TriggerHandler {
    private final List<NCMT_Data_Upload__c> oldList { get; set; }
    private final List<NCMT_Data_Upload__c> newList { get; set; }
    private final Map<Id, NCMT_Data_Upload__c> oldMap { get; set; }
    private final Map<Id, NCMT_Data_Upload__c> newMap { get; set; }
    //private final String fiscalYear = '2021';
    //private final String prevFiscalYear = '2020';
    public static String fiscalYear ;
    static String prevFiscalYear;
     /*NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
     String fiscalYear = ncmt_customsettings.Data_Load_Current_FY__c;
     String prevFiscalYear = ncmt_customsettings.Data_Load_Previous_FY__c;*/
                    

    public NCMT_DataUpload_TriggerHandler(List<NCMT_Data_Upload__c> oldLst, List<NCMT_Data_Upload__c> newLst, Map<Id, NCMT_Data_Upload__c> oldMp, Map<Id, NCMT_Data_Upload__c> newMp) {
        oldList = (oldLst == null ? new List<NCMT_Data_Upload__c>() : oldLst);          
        newList = (newLst == null ? new List<NCMT_Data_Upload__c>() : newLst);
        System.debug('newList is ' + newList);
        oldMap = (oldMp == null ? new Map<Id, NCMT_Data_Upload__c>() : oldMp);
        newMap = (newMp == null ? new Map<Id, NCMT_Data_Upload__c>() : newMp);
        List<NCMT_CustomSettings__c> fy1 = [SELECT Data_Load_Current_FY__c,Data_Load_Previous_FY__c FROM NCMT_CustomSettings__c Limit 1];
        fiscalYear = fy1[0].Data_Load_Current_FY__c;
        prevFiscalYear = fy1[0].Data_Load_Previous_FY__c;
        System.debug('fiscalYear is ' + fiscalYear +'prevFiscalYear is' + prevFiscalYear  );
    }

    public void annual_des_dataload(){
        
        //Assemblies
        
        List<NCMT_Data_Upload__c> ass_masters = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> ass_masters_mr = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> ass_masters_pm = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> ass_lines = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> des_detail = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> labor = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> labor_aio = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> eqCrew = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> crew = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> freqs = new List<NCMT_Data_Upload__c>();
        Set<String> importMasters = new Set<String>();
        Map<String, Id> relatedAssMasters = new Map<String, Id>();
        Map<String, NCMT_DES_Lookup_details__c> relatedDES = new Map<String, NCMT_DES_Lookup_details__c>();
        List<NCMT_Data_Upload__c> locMarkups = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> express = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> subcon = new List<NCMT_Data_Upload__c>();
        
        Map<String, Decimal> dupeCheck = new Map<String, Decimal>();
        List<String> dupeCheck_DES = new List<String>();
        Map<String, Decimal> dupeCheck_items = new Map<String, Decimal>();

        Boolean need16;
        Boolean needFAC16;
        Boolean needFACL16;
        Boolean needGM16;
        Boolean needFacilityDescrip;
        
        List<NCMT_Assembly_Lookup_detail__c> last = [SELECT Name FROM NCMT_Assembly_Lookup_detail__c 
                                                         ORDER BY CreatedDate DESC Limit 1];
        System.debug(last);
        String last_asm = '';
        if(!last.isEmpty())
            last_asm = last[0].Name;
        System.debug('last_asm: ' + last_asm);
            
        
        for (NCMT_Data_Upload__c d : newList){
        //  SFWS-1599 - Changing GSA_2021_ASMDESC to GSA_ASMDESC
        //  SFWS-1602 - changing GSA_2021_FAC_ASMDES to GSA_FAC_ASMDES
            if (d.Upload__c == 'GSA_ASMDESC' || d.Upload__c == 'GSA_FAC_ASMDES'
            
            ){
                //Check if record with same Assembly SKey has already been added to list
                if(!dupeCheck.containsKey(d.Text_1__c))
                {
                   if(d.Text_1__c != last_asm)
                   {
                       ass_masters.add(d);
                       dupeCheck.put(d.Text_1__c, d.Number_3__c);
                       //System.debug(dupeCheck);  
                   }
                    else
                        System.debug('New batch duplicate!');
                }
                else { //It's a duplicate! Check if totals match...
                    
                    /*if(d.Number_3__c != dupeCheck.get(d.Text_1__c)){
                        ass_masters.add(d); //Totals don't match, add the duplicate
                        System.debug('Duplicate with different total');
                    }
                    else{*/
                        //Do nothing. Skip this line
                        System.debug('Duplicate found!');
                    //}
                        
                }
            }
            // SFWS-1652 - changing Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook_12092020 to Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook
           // SFWS-1654 - changing GSA_2021_FAC_ASSM to GSA_FAC_ASSM
           //SFWS-1653 - changing GSA_2021_ASSM to GSA_ASSM
           //SFWS-1655 - changing GSA_2021_M&R Component Assembly to GSA_M&R Component Assembly


            if (d.Upload__c == 'GSA_ASSM' || d.Upload__c == 'GSA_FAC_ASSM'
                || d.Upload__c == 'GSA_M&R Component Assembly'
                || d.Upload__c == 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook'
            ){
                ass_lines.add(d);
                relatedAssMasters.put(d.Text_2__c, null);
                if (d.Upload__c == 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook'){
                    relatedDES.put(d.Text_3__c, null);
                } else {
                    relatedDES.put(d.Text_4__c, null);
                }

            } 
            // SFWS-1645 - Changing  GSA_2021_ASSMUP to GSA_ASSMUP
            // SFWS-1646 - Changing  GSA_2021_FAC_ASSMUP to GSA_FAC_ASSMUP 
            // SFWS-1647 - Changing  GSA_2021_FACL_DAT to GSA_FACL_DAT  
            // SFWS-1648 - Changing  GSA_2021_FACL_SEQ to GSA_FACL_SEQ  
            // SFWS-1649 - Changing  GSA_2021_GM Unit Cost to GSA_GM Unit Cost 
           // SFWS-1650 - Changing  GSA_2021_M&R Unit Price Data  to GSA_M&R Unit Price Data
           //  SFWS-1652 - changing Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook_12092020 to Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook

            if (d.Upload__c == 'GSA_ASSMUP' || d.Upload__c == 'GSA_FAC_ASSMUP'
                || d.Upload__c == 'GSA_FACL_DAT' || d.Upload__c == 'GSA_FACL_SEQ'
                || d.Upload__c == 'GSA_GM Unit Cost' || d.Upload__c == 'GSA_M&R Unit Price Data'
                || d.Upload__c == 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook' 
            ){
                //System.debug('dupeCheck_DES: ' + dupeCheck_DES);
                if((d.Upload__c != 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook' && !dupeCheck_DES.contains(d.Text_2__c))
                   || (d.Upload__c == 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook' && !dupeCheck_DES.contains(d.Text_3__c)))
                {
                    //Not a duplicate
                    des_detail.add(d);
                    need16 = true;//(d.Upload__c == 'GSA_2021_ASSMUP');
                    needFAC16 = true;//(d.Upload__c == 'GSA_2021_FAC_ASSMUP');
                    needFACL16 = true;//(d.Upload__c == 'GSA_FACL_SEQ');
                    needFacilityDescrip = true;//d.Upload__c == 'GSA_2021_FACL_DAT';
                    needGM16 = true;//(d.Upload__c == 'GSA_GM Unit Cost');
                 //  SFWS-1652 - changing Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook_12092020 to Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook
                    if(d.Upload__c == 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook')
                        dupeCheck_DES.add(d.Text_3__c);
                    else
                        dupeCheck_DES.add(d.Text_2__c);
                } else {
                    //Duplicate. Skip this line.
                    System.debug('Duplicate: ' + d);
                }
            }
            //SFWS-1607 changing GSA_2021_M&R Assembly Data to GSA_M&R Assembly Data
            if (d.Upload__c == 'GSA_M&R Assembly Data'){
                ass_masters_mr.add(d);
            }
            //SFWS-1611 Changing GSA_2021_PM_SEQ to GSA_PM_SEQ
            if (d.Upload__c == 'GSA_PM_SEQ'){
                ass_masters_pm.add(d);
            }
            //SFWS-1642 Changing GSA_2021_STD_LAB to GSA_STD_LAB
            if (d.Upload__c == 'GSA_STD_LAB'){
                labor.add(d);
            }
            //SFWS-1643 Changing GSA_2021_STD_LAB_AIO to GSA_STD_LAB_AIO
            if (d.Upload__c == 'GSA_STD_LAB_AIO'){
                labor_aio.add(d);
            }
             //SFWS-1644 Changing GSA_2021_EQ_CREW  to GSA_EQ_CREW

            if (d.Upload__c == 'GSA_EQ_CREW'){
                eqCrew.add(d);
            }
            //SFWS-1651 Changing GSA_2021_STD_CREW  to GSA_STD_CREW

            if (d.Upload__c == 'GSA_STD_CREW'){
                crew.add(d);
                importMasters.add(d.Text_1__c);
            }
            //SFWS-1657 Changing GSA_2021_PM_PRN to GSA_PM_PRN  
            if (d.Upload__c == 'GSA_PM_PRN'){
                freqs.add(d);
                relatedAssMasters.put(d.Text_2__c, null);
            }
            if (d.Upload__c == 'LocationMarkup'){
                locMarkups.add(d);
            }
            if (d.Upload__c == 'Express'){
                express.add(d);
            }
            if (d.Upload__c == 'Subcon'){
                subcon.add(d);
            }
        }

        List<String> dupeCatNames = new List<String>{'E20','G30','G40'};
        Map<String, Id> costCatMap = new Map<String, Id>();
        for (NCMT_Cost_Category__c cat : [Select Id, Name, Category_Description__c, Estimate_Format__c
                from NCMT_Cost_Category__c where Category_Description__c <> null]
        ){
            if(dupeCatNames.contains(cat.Name) && cat.Estimate_Format__c == 'Uniformat')
                System.debug('Skip duplicate category for DES');
            else
            costCatMap.put(cat.Name, cat.Id);
        }
        
        System.debug('costCatMap is ' +costCatMap);

        //ass_muni and ass_mix are both used as reference to build the
        //tree structure for assembly masters 
        //so no logic for them

        //Assembly Master Records GSA 2021
        if (ass_masters.size() > 0){ 
            Map<String, NCMT_Data_Upload__c> fac_asmuni = new Map<String, NCMT_Data_Upload__c>();
            Map<String, NCMT_Data_Upload__c> asmuni = new Map<String, NCMT_Data_Upload__c>();

            
            //These obviously need to come first in the import for this to work
            //Limiting to 15 minutes in case there's a data load issue and it has to be redone
            //SFWS-1604- changing GSA_2021_ASMUNIto GSA_ASMUNI
            // SFWS-1606- changingGSA_2021_FAC_ASMUNIto GSA_FAC_ASMUNI 
            for (NCMT_Data_Upload__c d : [Select Id, Text_1__c, Text_2__c, Text_3__c, Upload__c from NCMT_Data_Upload__c
                where (Upload__c = 'GSA_ASMUNI'
                OR Upload__c = 'GSA_FAC_ASMUNI' 
                //OR Upload__c = 'GSA_2021_PM_ASMUNI'
                )
            ]){
                if (d.Upload__c == 'GSA_ASMUNI') asmuni.put(d.Text_1__c, d);
                if (d.Upload__c == 'GSA_FAC_ASMUNI') fac_asmuni.put(d.Text_1__c, d);
            }

            List<NCMT_Assembly_Lookup_Detail__c> assMasters = new List<NCMT_Assembly_Lookup_Detail__c>();
            for (NCMT_Data_Upload__c u : ass_masters){
                String cat = u.Text_2__c.substring(0,3);
                String level3 = u.Text_2__c.substring(0,5);
                String level4 = u.Text_2__c.substring(0,8);
                System.debug('u.Text_2__c ========== ' +u.Text_2__c +' level3 ==== ' +level3 +' level4 === ' +level4);
                //System.debug('ASM:' + asmuni);
                //System.debug('FAC:' + fac_asmuni);
                System.debug('Cost Category === ' + costCatMap.get(cat));
                NCMT_Assembly_Lookup_Detail__c details = new NCMT_Assembly_Lookup_Detail__c(
                    Fiscal_Year__c = fiscalYear,
                    Name = u.Text_1__c,
                    Assembly_Number__c = u.Text_2__c,
                    Description__c = u.Text_3__c,
                    Unit__c = u.Text_4__c,
                    Level_2__c = costCatMap.get(cat),
                    Level_3__c = level3,
                    Level_3_Description__c = (u.Upload__c == 'GSA_ASMDESC' ? asmuni.get(level3).Text_2__c : fac_asmuni.get(level3).Text_2__c),
                    Level_4__c = level4,
                    Level_4_Description__c = (u.Upload__c == 'GSA_ASMDESC' ? asmuni.get(level4).Text_2__c : fac_asmuni.get(level4).Text_2__c),
                    File_Type__c = (u.Upload__c == 'GSA_ASMDESC' ? 'GSA_ 2020 ASMDESC.xlsx' : 'GSA_ 2020 FAC_ASMDES.xlsx'),
                    Material_Cost_OP__c = u.Number_1__c,
                    Installation_Cost_OP__c = u.Number_2__c,
                    Total_Cost_OP__c = u.Number_3__c
                );
                assMasters.add(details);
            }
            insert assMasters;
        }

        if (ass_masters_mr.size() > 0){
            Map<String, NCMT_Data_Upload__c> mrmuni = new Map<String, NCMT_Data_Upload__c>();

            //These obviously need to come first in the import for this to work
            //Limiting to 15 minutes in case there's a data load issue and it has to be redone
            //SFWS-1609 changing GSA_2021_M&R ASMUNI to GSA_M&R ASMUNI
            for (NCMT_Data_Upload__c d : [Select Id, Text_1__c, Text_2__c, Text_3__c, Upload__c from NCMT_Data_Upload__c
                where (Upload__c = 'GSA_M&R ASMUNI')
            ]){
                mrmuni.put(d.Text_1__c, d);
            }

            List<NCMT_Assembly_Lookup_Detail__c> assMasters = new List<NCMT_Assembly_Lookup_Detail__c>();
            for (NCMT_Data_Upload__c u : ass_masters_mr){
                String cat = u.Text_2__c.substring(0,3);
                System.debug('cat is ' + cat);
                System.debug('costCatMap.get(cat) ' +costCatMap.get(cat));
                String level3 = u.Text_2__c.substring(0,5);
                String level4 = u.Text_2__c.substring(0,8);
                NCMT_Assembly_Lookup_Detail__c details = new NCMT_Assembly_Lookup_Detail__c(
                    Fiscal_Year__c = fiscalYear,
                    Name = u.Text_1__c,
                    Assembly_Number__c = u.Text_2__c,
                    Description__c = u.Text_3__c, //Note that u.Text_4__c is skipped because it's crew, which isn't stored in Assembly Master records
                    Unit__c = u.Text_5__c,
                    Level_2__c = costCatMap.get(cat),
                    Level_3__c = level3,
                    Level_3_Description__c = mrmuni.get(level3).Text_2__c,
                    Level_4__c = level4,
                    Level_4_Description__c = mrmuni.get(level4).Text_2__c,
                    File_Type__c = 'GSA_ 2020 MR Assembly Data.xlsx',
                    Material_Cost_OP__c = u.Number_3__c,
                    Installation_Cost_OP__c = u.Number_2__c * u.Number_4__c,
                    
                    //????????????? Is installation correct and does in-house total go somewhere?

                    Total_Cost_OP__c = u.Number_7__c
                );
                assMasters.add(details);
            }
            insert assMasters;
        }

        if (ass_masters_pm.size() > 0){
            Map<String, NCMT_Data_Upload__c> pmmuni = new Map<String, NCMT_Data_Upload__c>();

            //These obviously need to come first in the import for this to work
            //Limiting to 15 minutes in case there's a data load issue and it has to be redone
            //changing GSA_2021_PM_ASMUNI to GSA_PM_ASMUNI - SFWS-1614
            for (NCMT_Data_Upload__c d : [Select Id, Text_1__c, Text_2__c, Text_3__c from NCMT_Data_Upload__c
                where (Upload__c = 'GSA_PM_ASMUNI')
            ]){
                pmmuni.put(d.Text_1__c, d);
            }

            List<NCMT_Assembly_Lookup_Detail__c> assMasters = new List<NCMT_Assembly_Lookup_Detail__c>();
            for (NCMT_Data_Upload__c u : ass_masters_pm){
                String cat = u.Text_2__c.substring(0,3);
                String level3 = u.Text_2__c.substring(0,5);
                String level4 = u.Text_2__c.substring(0,8);
                NCMT_Assembly_Lookup_Detail__c details = new NCMT_Assembly_Lookup_Detail__c(
                    Fiscal_Year__c = fiscalYear,
                    Name = u.Text_1__c,
                    Assembly_Number__c = u.Text_2__c,
                    Description__c = u.Text_3__c, //Note that u.Text_4__c is skipped because it's crew, which isn't stored in Assembly Master records
                    Unit__c = u.Text_4__c,
                    Level_2__c = costCatMap.get(cat),
                    Level_3__c = level3,
                    Level_3_Description__c = pmmuni.get(level3).Text_2__c,
                    Level_4__c = level4,
                    Level_4_Description__c = pmmuni.get(level4).Text_2__c,
                    File_Type__c = 'GSA_ 2020 PM_SEQ.xlsx',
                    Material_Cost_OP__c = u.Number_2__c,
                    Installation_Cost_OP__c = u.Number_1__c * u.Number_3__c,
                    
                    //????????????? Is installation correct and does in-house total go somewhere?

                    Total_Cost_OP__c = u.Number_6__c
                );
                assMasters.add(details);
            }
            insert assMasters;
        }

        if (labor.size() > 0){
            List<NCMT_Labor_Resource__c> laborRecs = new List<NCMT_Labor_Resource__c>();
            for (NCMT_Data_Upload__c u : labor){
                NCMT_Labor_Resource__c item = new NCMT_Labor_Resource__c(
                    Fiscal_Year__c = fiscalYear,
                    Name = u.Text_1__c,
                    Labor_Resource_Name__c = u.Text_2__c,
                    Hourly_Rate__c = u.Number_1__c,
                    O_P_Cost__c = u.Number_2__c
                );
                laborRecs.add(item);
            }
            insert laborRecs;
        }

        if (labor_aio.size() > 0){
            List<NCMT_Labor_Resource__c> laborRecs = new List<NCMT_Labor_Resource__c>();
            Set<String> labRecs = new Set<String>();
            for (NCMT_Labor_Resource__c lr : [Select Id, Name from NCMT_Labor_Resource__c where Fiscal_Year__c =: fiscalYear])
                labRecs.add(lr.Name);

            for (NCMT_Data_Upload__c u : labor_aio){
                if (!labRecs.contains(u.Text_2__c)){//labor file has more details but is missing resources
                    NCMT_Labor_Resource__c item = new NCMT_Labor_Resource__c(
                        Fiscal_Year__c = fiscalYear,
                        Name = u.Text_2__c,
                        Hourly_Rate__c = u.Number_1__c
                    );
                    laborRecs.add(item);
                }
            }
            insert laborRecs;
        }

        if (eqCrew.size() > 0){
            List<NCMT_Equipment__c> equip = new List<NCMT_Equipment__c>();
            for (NCMT_Data_Upload__c u : eqCrew){
                NCMT_Equipment__c item = new NCMT_Equipment__c(
                    Fiscal_Year__c = fiscalYear,
                    Name = u.Text_2__c,
                    Equipment_Key__c = u.Text_3__c, 
                    Equipment_Description__c = u.Text_4__c,
                    Rental_Rate_per_hour__c = u.Number_1__c
                );
                equip.add(item);
            }
            insert equip;
        }

        
        Map<String, Id> laborMap = new Map<String, Id>();
        Map<String, Id> crewMasters = new Map<String, Id>();
        //CREW DETAILS, CREATE CREW MASTERS AS NEEDED
        if (crew.size() > 0 || des_detail.size() > 0){
            

            for (NCMT_Labor_Resource__c lr : [Select Id, Name from NCMT_Labor_Resource__c where Fiscal_Year__c =: fiscalYear]){
                laborMap.put(lr.Name, lr.Id);
                System.debug('I am the Crewmaster :::::: ' +lr.Name);
            }
            for (NCMT_Crew_Master__c cm : [Select Id, Name from NCMT_Crew_Master__c where Name <> null]){
                importMasters.remove(cm.Name);
                crewMasters.put(cm.Name, cm.Id);
                System.debug('I am the Crewmaster :::::: ' +cm.Name);
            }
        }

        if (crew.size() > 0){
            Map<String, Id> equipMap = new Map<String, Id>();
            for (NCMT_Equipment__c e : [Select Id, Name, Equipment_Key__c from NCMT_Equipment__c where Fiscal_Year__c =: fiscalYear])
                equipMap.put(e.Equipment_Key__c, e.Id);
                
            //Means there are new crew masters. The only info stored about these is the Crew Key, 
            //so create
            if (importMasters.size() > 0){
                List<NCMT_Crew_Master__c> masters = new List<NCMT_Crew_Master__c>();

                for (String m : importMasters){
                    NCMT_Crew_Master__c cm = new NCMT_Crew_Master__c(
                        Name = m,
                        Description__c = m
                    );
                    masters.add(cm);
                }
                insert masters;

                for (NCMT_Crew_Master__c cm : [Select Id, Name from NCMT_Crew_Master__c where Name IN: importMasters]){
                    crewMasters.put(cm.Name, cm.Id);
                    System.debug('I am the Crewmaster2 :::::: ' +cm.Name);
                }
            }

            List<NCMT_Crew_Details__c> crewDetails = new List<NCMT_Crew_Details__c>();
            for (NCMT_Data_Upload__c u : crew){
                Boolean isEquip = (equipMap.get(u.Text_2__c) != null);
                Boolean isLabor = (laborMap.get(u.Text_2__c) != null);
                if (isEquip || isLabor){

                    
                    NCMT_Crew_Details__c item = new NCMT_Crew_Details__c(
                        Fiscal_Year__c = fiscalYear,
                        Crew_ID__c = crewMasters.get(u.Text_1__c),
                        Description__c = u.Text_4__c,
                        Quantity__c = u.Number_1__c,
                        Equipment__c = equipMap.get(u.Text_2__c),
                        Labor_Resource__c = laborMap.get(u.Text_2__c)
                    );
                    crewDetails.add(item);
                } else {
                    u.addError('No matching Equipment or Labor Resource found for Text 2: ' +u.Text_2__c);
                }
            }
            insert crewDetails;
        }
        // changing GSA_2021_ASMCSI16 to GSA_ASMCSI16
        if (des_detail.size() > 0){
            Map<String, String> gsaDescMap = new Map<String, String>();
            if (need16){
                for (NCMT_Data_Upload__c d : [Select Id, Text_1__c, Text_2__c, Text_3__c from NCMT_Data_Upload__c
                    where Upload__c = 'GSA_ASMCSI16'
                ]){
                    gsaDescMap.put(d.Text_1__c, d.Text_2__c);
                }
            }

            Map<String, String> facDescMap = new Map<String, String>();
            if (needFAC16){//updated GSA_2021_FAC_ASMCSI16 to GSA_FAC_ASMCSI16
                for (NCMT_Data_Upload__c d : [Select Id, Text_1__c, Text_2__c, Text_3__c from NCMT_Data_Upload__c
                    where Upload__c = 'GSA_FAC_ASMCSI16'
                ]){
                    facDescMap.put(d.Text_1__c, d.Text_2__c);
                }
            }
//Changing GSA_2021_GM MF2014 CSI to GSA_GM MF2014 CSI
            Map<String, String> gmDescMap = new Map<String, String>();
            if (needGM16){
                for (NCMT_Data_Upload__c d : [Select Id, Text_1__c, Text_2__c, Text_3__c from NCMT_Data_Upload__c
                    where Upload__c = 'GSA_GM MF2014 CSI'
                ]){
                    gmDescMap.put(d.Text_1__c +d.Text_2__c, d.Text_3__c);
                }
            }
// Changing GSA_2021_FACLMF16_CSI to GSA_FACLMF16_CSI
            Map<String, String> faclDescMap = new Map<String, String>();
            if (needFACL16){
                for (NCMT_Data_Upload__c d : [Select Id, Text_1__c, Text_2__c, Text_3__c from NCMT_Data_Upload__c
                    where Upload__c = 'GSA_FACLMF16_CSI'
                ]){
                    faclDescMap.put(d.Text_1__c, d.Text_2__c);
                }
            }

            Map<String, String> facilityDescrip = new Map<String, String>();
            if (needFacilityDescrip){
     // Changing GSA_2021_Facility_Descriptions to GSA_Facility_Descriptions
                for (NCMT_Data_Upload__c d : [Select Id, Text_1__c, Text_2__c, Text_3__c from NCMT_Data_Upload__c
                    where Upload__c = 'GSA_Facility_Descriptions'
                ]){
                    facilityDescrip.put(d.Text_2__c, d.Text_3__c);
                }
            }

            List<NCMT_DES_Lookup_details__c> des = new List<NCMT_DES_Lookup_details__c>();
            for (NCMT_Data_Upload__c u : des_detail){
                
                NCMT_DES_Lookup_details__c item = new NCMT_DES_Lookup_details__c(
                    Fiscal_Year__c = fiscalYear,
                    Name = u.Text_2__c,
                    NCMT_Crew_Master__c = crewMasters.get(u.Text_5__c),
                    NCMT_Labor__c = laborMap.get(u.Text_5__c), //Text 5 is either crew or labor
                    //NCMT_Contractor_ID__c = conMap.get(), Don't have this?
                    Description__c = u.Text_4__c,
                    Line_Item_Number__c = u.Text_3__c,
                    Unit__c = u.Text_6__c,
                    Quantity__c = 0,//u.Number_1__c,
                    Daily_Output__c = u.Number_2__c,
                    Labor_Hours_txt__c = u.Number_3__c,
                    Material_Unit_Cost__c = u.Number_4__c, 
                    Hourly_Rate_txt__c = u.Number_5__c,
                    Equipment_Unit_Cost__c = u.Number_6__c,
                    In_house_Unit_Total__c = u.Number_7__c,
                    O_P_Unit_Total__c = u.Number_8__c//,
                    
                    //O&P Labor/Material/Equipment costs. Are there values for these in data???
                    //Labor_Unit_O_P_Cost__c = 0,
                    //Material_Unit_O_P_Cost__c = 0,
                    //Equipment_Unit_O_P_Cost__c = 0
                );
                
                //O&P Costs
                if(u.Number_9__c != null)
                    item.Labor_Unit_O_P_Cost__c = u.Number_9__c;
                else
                    item.Labor_Unit_O_P_Cost__c = 0;
                if(u.Number_10__c != null)
                    item.Material_Unit_O_P_Cost__c = u.Number_10__c;
                else
                    item.Material_Unit_O_P_Cost__c = 0;
                if(u.Number_11__c != null)
                    item.Equipment_Unit_O_P_Cost__c = u.Number_11__c;
                else
                    item.Equipment_Unit_O_P_Cost__c = 0;

                String level2 = u.Text_3__c.substring(0, 2) +'0000001';
                item.Level_2__c = costCatMap.get(level2);
           // SFWS-1650 - Changing  GSA_2021_M&R Unit Price Data  to GSA_M&R Unit Price Data
            //  SFWS-1652 - changing Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook_12092020 to Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook

                //Add hierarchy and descriptions
                if (u.Upload__c != 'GSA_M&R Unit Price Data' && u.Upload__c != 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook'){
                    Map<String, String> descMap;
                    // SFWS-1645 - Changing  GSA_2021_ASSMUP to GSA_ASSMUP
                    if (u.Upload__c == 'GSA_ASSMUP') descMap = gsaDescMap;
                    // SFWS-1646 - Changing  GSA_2021_FAC_ASSMUP to GSA_FAC_ASSMUP 
                    if (u.Upload__c == 'GSA_FAC_ASSMUP') descMap = facDescMap;
                    // SFWS-1648 - Changing  GSA_2021_FACL_SEQ to GSA_FACL_SEQ 
                    if (u.Upload__c == 'GSA_FACL_SEQ')
                        descMap = faclDescMap;
                    // SFWS-1647 - Changing  GSA_2021_FACL_DAT to GSA_FACL_DAT  
                    if (u.Upload__c == 'GSA_FACL_DAT' )
                        descMap = facilityDescrip;
                  // SFWS-1649 - Changing  GSA_2021_GM Unit Cost to GSA_GM Unit Cost  
                    if (u.Upload__c == 'GSA_GM Unit Cost')
                        descMap = gmDescMap;

                    
                    String level3 = u.Text_3__c.substring(0, 4) +'00002';
                    String level4 = u.Text_3__c.substring(0, 6) +'003';
                    String level5 = u.Text_3__c.substring(0, 8) +'4';
                   // SFWS-1647 - Changing  GSA_2021_FACL_DAT to GSA_FACL_DAT  
                    if (u.Upload__c == 'GSA_FACL_DAT' ){
                        level3 = u.Text_3__c.substring(0, 4) +'00000000';
                        level4 = u.Text_3__c.substring(0, 6) +'000000';
                        level5 = u.Text_3__c.substring(0, 8) +'0000';
                    }

                    item.Level_3_Line_Item__c = level3;
                    item.Level_3_Description__c = descMap.get(level3);
                    item.Level_4_Line_Item__c = level4;
                    item.Level_4_Description__c = descMap.get(level4);
                    item.Level_5_Line_Item__c = level5;
                    item.Level_5_Description__c = descMap.get(level5);
                }

                //I hate that these file types have the year in them but it's out of scope to update those references
               // SFWS-1645 - Changing  GSA_2021_ASSMUP to GSA_ASSMUP
                if (u.Upload__c == 'GSA_ASSMUP') item.File_Name__c = 'GSA_ 2020 ASSMUP.xlsx';
               // SFWS-1647 - Changing  GSA_2021_FACL_DAT to GSA_FACL_DAT  
                if (u.Upload__c == 'GSA_FACL_DAT') item.File_Name__c = 'GSA_2020 FACL2020 DAT.xlsx';
              // SFWS-1649 - Changing  GSA_2021_GM Unit Cost to GSA_GM Unit Cost  
                if (u.Upload__c == 'GSA_GM Unit Cost') item.File_Name__c = 'GSA_ 2020 GM Unit Cost.xlsx';
                // SFWS-1648 - Changing  GSA_2021_FACL_SEQ to GSA_FACL_SEQ 
                if (u.Upload__c == 'GSA_FACL_SEQ') item.File_Name__c = 'GSA_2020 FACLSEQ.xlsx';
                // SFWS-1648 - Changing  GSA_2021_M&R Unit Price Data to GSA_M&R Unit Price Data 
                if (u.Upload__c == 'GSA_M&R Unit Price Data') item.File_Name__c = 'GSA_ 2020 M&R Unit Price Data.xlsx';
                // SFWS-1646 - Changing  GSA_2021_FAC_ASSMUP to GSA_FAC_ASSMUP
                if (u.Upload__c == 'GSA_FAC_ASSMUP') item.File_Name__c = 'GSA 2020 FAC_ASSMUP.xlsx';
                //  SFWS-1652 - changing Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook_12092020 to Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook
                if (u.Upload__c == 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook'){ 
                    item.File_Name__c = 'GSA 2020 FMR_PM_ASSMUP.xlsx';
                    item.Name = u.Text_3__c;
                }

                des.add(item);
            }
            insert des;
        }

        //Assembly Line Items GSA 2021
        //NCMT_Assembly_Lookup_Item__c
        if (ass_lines.size() > 0){
            System.debug('Assembly Line Item begin');
            for (NCMT_Assembly_Lookup_Detail__c m : [Select Id, Assembly_Number__c from NCMT_Assembly_Lookup_Detail__c 
                where Fiscal_Year__c =: fiscalYear AND Assembly_Number__c IN: relatedAssMasters.keySet()]
            ){
                relatedAssMasters.put(m.Assembly_Number__c, m.Id);
            }
            //System.debug('relatedAssMasters: ' + relatedAssMasters);
           
            Map<String, NCMT_DES_Lookup_details__c> mrDES = new Map<String, NCMT_DES_Lookup_details__c>();
            //Map<String, NCMT_DES_Lookup_details__c> facDES = new Map<String, NCMT_DES_Lookup_details__c>();
            Map<String, NCMT_DES_Lookup_details__c> fmrDES = new Map<String, NCMT_DES_Lookup_details__c>();
            for (NCMT_DES_Lookup_details__c d : [Select Id, Line_Item_Number__c, Daily_Output__c,
                Labor_Hours_txt__c, Material_Unit_Cost__c, Hourly_Rate_txt__c, Equipment_Unit_Cost__c, O_P_Unit_Total__c,
                File_name__c
                from NCMT_DES_Lookup_details__c
                Where Fiscal_Year__c =: fiscalYear AND Line_Item_Number__c IN: relatedDES.keySet()
                AND File_Name__c = 'GSA_ 2020 ASSMUP.xlsx'
                ]
            ){
                
                    if (d.File_Name__c == 'GSA_ 2020 ASSMUP.xlsx')
                        relatedDES.put(d.Line_Item_Number__c, d);
                    
            }
            for (NCMT_DES_Lookup_details__c d : [Select Id, Line_Item_Number__c, Daily_Output__c,
                Labor_Hours_txt__c, Material_Unit_Cost__c, Hourly_Rate_txt__c, Equipment_Unit_Cost__c, O_P_Unit_Total__c,
                File_name__c
                from NCMT_DES_Lookup_details__c
                Where Fiscal_Year__c =: fiscalYear AND Line_Item_Number__c IN: relatedDES.keySet()
                //AND File_Name__c = 'GSA_ 2020 M&R Unit Price Data.xlsx'
                ]
            ){
                
                    //if (d.File_Name__c == 'GSA_ 2020 M&R Unit Price Data.xlsx')
                        mrDES.put(d.Line_Item_Number__c, d);
                    System.debug('mrDES: ' + mrDES);
            
            }
            for (NCMT_DES_Lookup_details__c d : [Select Id, Line_Item_Number__c, Daily_Output__c,
                Labor_Hours_txt__c, Material_Unit_Cost__c, Hourly_Rate_txt__c, Equipment_Unit_Cost__c, O_P_Unit_Total__c,
                File_name__c
                from NCMT_DES_Lookup_details__c
                Where Fiscal_Year__c =: fiscalYear AND Line_Item_Number__c IN: relatedDES.keySet()
                AND File_Name__c = 'GSA 2020 FAC_ASSMUP.xlsx'
                ]
            ){
                
                    if (d.File_Name__c == 'GSA 2020 FAC_ASSMUP.xlsx')
                        relatedDES.put(d.Line_Item_Number__c, d);
                
            }
            for (NCMT_DES_Lookup_details__c d : [Select Id, Line_Item_Number__c, Daily_Output__c,
                Labor_Hours_txt__c, Material_Unit_Cost__c, Hourly_Rate_txt__c, Equipment_Unit_Cost__c, O_P_Unit_Total__c,
                File_name__c
                from NCMT_DES_Lookup_details__c
                Where Fiscal_Year__c =: fiscalYear AND Line_Item_Number__c IN: relatedDES.keySet()
                AND File_Name__c = 'GSA 2020 FMR_PM_ASSMUP.xlsx'
                ]
            ){
                
                    if (d.File_Name__c == 'GSA 2020 FMR_PM_ASSMUP.xlsx')
                        fmrDES.put(d.Line_Item_Number__c, d);
                    //System.debug('fmrDES: ' + fmrDES);
                
            }

            List<NCMT_Assembly_Lookup_Item__c> assLines = new List<NCMT_Assembly_Lookup_Item__c>();
            //Needs conversion factor to avoid error, default 1
            for (NCMT_Data_Upload__c d : ass_lines){
                NCMT_Assembly_Lookup_Item__c item = new NCMT_Assembly_Lookup_Item__c(
                    Conversion_Factor__c = d.Number_2__c,
                    Quantity__c = d.Number_1__c, 
                    Assembly_Lookup_Detail__c = relatedAssMasters.get(d.Text_2__c),
                    Unit_Cost_Skey__c = d.Text_3__c
                );
                NCMT_DES_Lookup_details__c des;
           //  SFWS-1652 - changing Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook_12092020 to Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook
                //Same file for des and assembly, little different
                if (d.Upload__c == 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook'){
                    item.Master_Format_Line_Item_Number__c = d.Text_3__c;
                    item.Conversion_Factor__c = 1;
                    des = fmrDES.get(d.Text_3__c);
                    
                } else {
                    item.Master_Format_Line_Item_Number__c = d.Text_4__c;
                    
                    
                }
            //SFWS-1653 - changing GSA_2021_ASSM to GSA_ASSM 
                if (d.Upload__c == 'GSA_ASSM')
                    des = relatedDES.get(d.Text_4__c);
              //SFWS-1654 - changing GSA_2021_FAC_ASSM to GSA_FAC_ASSM
              //SFWS-1655 - changing GSA_2021_M&R Component Assembly to GSA_M&R Component Assembly

                if (d.Upload__c == 'GSA_FAC_ASSM')
                    des = relatedDES.get(d.Text_4__c);
                if (d.Upload__c == 'GSA_M&R Component Assembly'){
                    //System.debug('M&R line ' + d.Text_4__c);
                    des = mrDES.get(d.Text_4__c);
                }
             //SFWS-1655 - changing GSA_2021_M&R Component Assembly to GSA_M&R Component Assembly


                if (d.Upload__c == 'GSA_M&R Component Assembly') item.Conversion_Factor__c = 1;

                item.NCMT_Master_Format_Lookup__c = des.Id;
                item.Labor_Hours_F__c = des.Labor_Hours_txt__c;
                item.Material_Unit_Cost__c = des.Material_Unit_Cost__c;
                item.Labor_Unit_Cost__c = des.Hourly_Rate_txt__c;
                item.Equipment_Unit_Cost__c = des.Equipment_Unit_Cost__c;
                item.Total_Cost_OP__c = des.O_P_Unit_Total__c;
                item.Fiscal_Year__c = fiscalYear;
              //SFWS-1653 - changing GSA_2021_ASSM to GSA_ASSM
                if (d.Upload__c == 'GSA_ASSM')
              //SFWS-1654 - changing GSA_2021_FAC_ASSM to GSA_FAC_ASSM
                    item.File_Name__c = 'GSA_ 2020 ASSM.xlsx';
                if (d.Upload__c == 'GSA_FAC_ASSM')
                    item.File_Name__c = 'GSA_ 2020 FAC_ASSM.xlsx';
              //SFWS-1655 - changing GSA_2021_M&R Component Assembly to GSA_M&R Component Assembly
                if (d.Upload__c == 'GSA_M&R Component Assembly')
                    item.File_Name__c = 'GSA_ 2020 M&R Component Assembly.xlsx';
                         //  SFWS-1652 - changing Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook_12092020 to Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook
                if (d.Upload__c == 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook')
                    item.File_Name__c = 'GSA_ 2020 PM_ASSM.xlsx';
                assLines.add(item);
            }
            insert assLines;
        }

        if (freqs.size() > 0){
            for (NCMT_Assembly_Lookup_Detail__c m : [Select Id, Assembly_Number__c from NCMT_Assembly_Lookup_Detail__c 
                where Fiscal_Year__c =: fiscalYear AND Assembly_Number__c IN: relatedAssMasters.keySet()]
            ){
                relatedAssMasters.put(m.Assembly_Number__c, m.Id);
            }

            List<NCMT_Assembly_Lookup_Frequency__c> assFreqs = new List<NCMT_Assembly_Lookup_Frequency__c>();
            //Needs conversion factor to avoid error, default 1
            for (NCMT_Data_Upload__c d : freqs){
                NCMT_Assembly_Lookup_Frequency__c freq = new NCMT_Assembly_Lookup_Frequency__c(
                    NCMT_Assembly_Lookup_Master__c = relatedAssMasters.get(d.Text_2__c),
                    Fiscal_Year__c = fiscalYear,
                    Annual_Frequency__c = d.Number_7__c,
                    Description__c = d.Text_3__c,
                    File_Name__c = 'GSA_ 2020 PM_PRN.xlsx',
                    Man_Hours__c = d.Number_2__c,
                    Monthly_Frequency__c = d.Number_4__c,
                    Quaterly_Frequency__c = d.Number_5__c,
                    Semi_Annual_Frequency__c = d.Number_6__c,
                    Task_Number__c = d.Number_1__c,
                    Weekly_Frequency__c = d.Number_3__c
                );
                assFreqs.add(freq);
            }
            insert assFreqs;
        }
        
        if(subcon.size() > 0)
        {
            List<NCMT_Contractor__c> subs = new List<NCMT_Contractor__C>();
            
            for(NCMT_Data_Upload__c d : subcon)
            {
                NCMT_Contractor__c s = new NCMT_Contractor__c(
                    Name = d.Text_1__c,
                    Contractor_Description__c = d.Text_2__c,
                    Bond__c = d.Number_1__c,
                    Overhead__c = d.Number_2__c,
                    Profit__c = d.Number_3__c,
                    Fiscal_Year__c = fiscalYear
                );
                subs.add(s);
            }
            insert subs;
        }

        if (express.size() > 0){
            Boolean go = false;
            for (NCMT_Data_Upload__c d : express){
                //This should be the final row in the spreadsheet for express new line item mapping
                //This way the future method isn't set off before they're fully loaded
                if (d.Text_1__c == 'go') go = true;
            }

            if (go){
                
                Set<Id> batchIds = new Set<Id>();
                for (NCMT_Assembly_Lookup_Detail__c m : [Select Id from NCMT_Assembly_Lookup_Detail__c 
                    where Fiscal_Year__c =: prevFiscalYear AND File_Type__c = 'GSAAssemblies']
                ){
                    batchIds.add(m.Id);
                    //if (batchIds.size() == 100){
                    //    NCMT_DataUpload_TriggerHandler.createExpressData(batchIds, fiscalYear, prevFiscalYear);
                    //    batchIds.clear();
                    //}
                }
                if (batchIds.size() > 0)
                    NCMT_DataUpload_TriggerHandler.createExpressData(batchIds, fiscalYear, prevFiscalYear);
                    
            }
        }

        //Location Markup
        if (locMarkups.size() > 0){
            for (NCMT_Labor_Resource__c lr : [Select Id, Name from NCMT_Labor_Resource__c where Fiscal_Year__c =: fiscalYear])
                laborMap.put(lr.Name, lr.Id);

            List<NCMT_Labor_Location_Markup__c> markups = new List<NCMT_Labor_Location_Markup__c>();
            for (NCMT_Data_Upload__c d : locMarkups){
                
                NCMT_Labor_Location_Markup__c loc = new NCMT_Labor_Location_Markup__c(
                    Fiscal_Year__c = fiscalYear,
                    NCMT_Labor_Resource__c = laborMap.get(d.Text_1__c),
                    Per_State_Territory__c = d.Text_2__c,
                    Labor_Burden_Tax__c = d.Number_1__c
                );
                markups.add(loc);
            }
            insert markups;
        }
        
    }

    @future
    public static void createExpressData(Set<Id> batchIds, String fiscalYear, String prevFiscalYear){
        Map<String, NCMT_Assembly_Lookup_Detail__c> masters = new Map<String, NCMT_Assembly_Lookup_Detail__c>();
        Map<String, List<NCMT_Assembly_Lookup_Item__c>> itemsMap = new Map<String, List<NCMT_Assembly_Lookup_Item__c>>();
        Map<String, NCMT_DES_Lookup_details__c> desMap = new Map<String, NCMT_DES_Lookup_details__c>();
        Map<String, Id> numDesMap = new Map<String, Id>();
        for (NCMT_Assembly_Lookup_Detail__c a : [Select Id, Description__c, Assembly_Number__c, File_Type__c, Fiscal_Year__c,
            Item_Type__c, Level_1__c, Level_1_Description__c, Level_2__c, Level_3__c, Level_3_Description__c, 
            Level_4__c, Level_4_Description__c, Level_5__c, Level_5_Description__c, Level_6__c, Level_6_Description__c, 
            MinID__c, Unit__c, Quantity__c, 
                (Select Id, Conversion_Factor__c, Equipment_Unit_Cost__c, File_Name__c, Fiscal_Year__c, 
                Labor_Hours_F__c, Master_Format_Line_Item_Number__c, Material_Conversion_Factor__c, Material_Unit_Cost__c, 
                Quantity__c, Unit_Cost_Skey__c, NCMT_Master_Format_Lookup__c, 
                NCMT_Master_Format_Lookup__r.Line_Item_Number__c
                from Assembly_Lookup_Items__r) 
            from NCMT_Assembly_Lookup_Detail__c where Id IN: batchIds]
        ){
            NCMT_Assembly_Lookup_Detail__c master = a.clone(false, true);
            master.Fiscal_Year__c = fiscalYear;
            master.Name = a.Assembly_Number__c;
            masters.put(a.Assembly_Number__c, master);

            if (itemsMap.get(a.Assembly_Number__c) == null)
                itemsMap.put(a.Assembly_Number__c, new List<NCMT_Assembly_Lookup_Item__c>());

            for (NCMT_Assembly_Lookup_Item__c i : a.Assembly_Lookup_Items__r){
                desMap.put(i.Master_Format_Line_Item_Number__c, null);
                
                
                NCMT_Assembly_Lookup_Item__c clone = i.clone(false, true);
                clone.Fiscal_Year__c = fiscalYear;
                if (clone.Conversion_Factor__c == 0) clone.Conversion_Factor__c = 1;
                clone.NCMT_Master_Format_Lookup__c = null;
                itemsMap.get(a.Assembly_Number__c).add(
                    clone
                );
            }
        }
        System.debug('masters: ' + masters.values());
        insert masters.values();

        for (NCMT_DES_Lookup_details__c d : [Select Id, Line_Item_Number__c, Daily_Output__c, Labor_Hours_txt__c, Material_Unit_Cost__c, 
            Hourly_Rate_txt__c, Equipment_Unit_Cost__c, O_P_Unit_Total__c
                from NCMT_DES_Lookup_details__c where Line_Item_Number__c IN: desMap.keySet() AND Fiscal_Year__c=:fiscalYear]
        ){
            desMap.put(d.Line_Item_Number__c, d);
        }

        List<NCMT_Assembly_Lookup_Item__c> finalItems = new List<NCMT_Assembly_Lookup_Item__c>();
        List<NCMT_Data_Upload__c> misMatches = new List<NCMT_Data_Upload__c>();
        for (String assNum : itemsMap.keySet()){
            for (NCMT_Assembly_Lookup_Item__c item : itemsMap.get(assNum)){
                item.Assembly_Lookup_Detail__c = masters.get(assNum).Id;
                NCMT_DES_Lookup_details__c des = desMap.get(item.Master_Format_Line_Item_Number__c);
                if (des != null){
                    item.NCMT_Master_Format_Lookup__c = des.Id;
                    item.Labor_Hours_F__c = des.Labor_Hours_txt__c;
                    item.Material_Unit_Cost__c = des.Material_Unit_Cost__c;
                    item.Labor_Unit_Cost__c = des.Hourly_Rate_txt__c;
                    item.Equipment_Unit_Cost__c = des.Equipment_Unit_Cost__c;
                    item.Total_Cost_OP__c = des.O_P_Unit_Total__c;
                    item.Fiscal_Year__c = fiscalYear;
                    finalItems.add(item);
                } else {
                    NCMT_Data_Upload__c d = new NCMT_Data_Upload__c(
                        Upload__c = 'DES Mismatch',
                        Text_1__c = item.Master_Format_Line_Item_Number__c,
                        Text_2__c = item.Assembly_Lookup_Detail__c
                    );
                    misMatches.add(d);
                }
            }
        }
        System.debug('finalItems: ' + finalItems);
        System.debug('misMatches: ' + misMatches);
        insert finalItems;
        insert misMatches;

        
    }

    public void annual_param_dataload(){
        Map<String, NCMT_Data_Upload__c> tiMap = new Map<String, NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> hpcosts = new List<NCMT_Data_Upload__c>();
        Map<String, NCMT_Data_Upload__c> coreMap = new Map<String, NCMT_Data_Upload__c>();
        Map<String, NCMT_Data_Upload__c> securityMap = new Map<String, NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> locations = new List<NCMT_Data_Upload__c>();
        Map<String, NCMT_Data_Upload__c> lpoeSpace = new Map<String, NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> lpoeCosts = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> triage = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> ae_cma_cmc_cx = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> cewParam = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> core2 = new List<NCMT_Data_Upload__c>();
        //ADD THESE!!!!!!!!!!!!!
        List<NCMT_Data_Upload__c> p100 = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> leed = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> raMod = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> raOverhead = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> raWI = new List<NCMT_Data_Upload__c>();
        List<NCMT_Data_Upload__c> raQuality = new List<NCMT_Data_Upload__c>();
        

        //Create Map of Data Upload objects from file input
        for (NCMT_Data_Upload__c d : newList){
            if (d.Upload__c == 'TI_TRCS'){
                tiMap.put(d.Text_3__c+d.Text_2__c, d);
            }
            if (d.Upload__c == 'Move_Cost'){
                hpcosts.add( d);
            }
            if (d.Upload__c == 'coreshell'){
                coreMap.put(d.Text_2__c, d);
            }
            if (d.Upload__c == 'coreUpdate'){
                core2.add(d);
            }
            if (d.Upload__c == 'Security'){
                securityMap.put(d.Text_1__c, d);
            }
            if (d.Upload__c == 'Location'){
                locations.add(d);
            }
            if (d.Upload__c == 'LPOE_SPACE'){
                lpoeSpace.put(d.Text_2__c +d.Text_3__c, d);
            }
            if (d.Upload__c == 'LPOE_Costs'){
                lpoeCosts.add(d);
            }
            if (d.Upload__c == 'Triage'){
                triage.add(d);
            }
            if(d.Upload__c == 'CEW') {
                cewParam.add(d);
            }
            if(d.Upload__c == 'AE_CMa_CMc_Cx') {
                ae_cma_cmc_cx.add(d);
            }
            if(d.Upload__c == 'P100') {
                p100.add(d);
            }
            if(d.Upload__c == 'LEED') {
                leed.add(d);
            }
            if(d.Upload__c == 'raMOD') {
                raMod.add(d);
            }
            if(d.Upload__c == 'raOverhead') {
                raOverhead.add(d);
            }
            if(d.Upload__c == 'raWI') {
                raWI.add(d);
            }
            if(d.Upload__c == 'raQuality') {
                raQuality.add(d);
            }
            if(d.Upload__c == 'ae_cma_cmc_cx')
            {
                ae_cma_cmc_cx.add(d);
            }
        }
        
        Map<String, Id> costCatMap = new Map<String, Id>();
        for (NCMT_Cost_Category__c cat : [Select Id, Name, Category_Description__c
                from NCMT_Cost_Category__c where Category_Description__c <> null]
        ){
            costCatMap.put(cat.Name, cat.Id);
        }
        
        if (tiMap.size() > 0){
            List<TI_TRCS_Cost_Parameter__c> tiTRCS = new List<TI_TRCS_Cost_Parameter__c>();
            
            //If Cost Category from Data Upload object does not exist, create new Cost Category and add to Map
            for(NCMT_Data_Upload__c d : tiMap.values())
            {
                /*System.debug(costCatMap);
                if(!costCatMap.containsKey(d.Text_1__c))
                {
                    System.debug('Cost Category Not Found: ' + d.Text_1__c);
                    NCMT_Cost_Category__c newCat = new NCMT_Cost_Category__c(
                                                        Name = d.Text_1__c,
                                                        Category_Description__c = desCatMap.get(d.Text_1__c).Category_Description__c,
                                                        Sort_Order__c = desCatMap.get(d.Text_1__c).Sort_Order__c,
                                                        Estimate_Format__c = 'Uniformat',
                                                        Cost_Category_Type__c = 'New Construction');
                    
                    insert newCat;
                    System.debug('Created New Cost Category ' + newCat.Name);
                    costCatMap.put(newCat.Name, newCat.Id);
                }*/
                
                //Create new TI-TRCS record from Data Upload object and add to list
                tiTRCS.add(new TI_TRCS_Cost_Parameter__c(Fiscal_Year__c = fiscalYear,
                                                         Level_3__c = d.Text_3__c,
                                                         Level_3_Description__c = d.Text_4__c,
                                                         Space_Type__c = d.Text_2__c,
                                                         Cost_Category__c = costCatMap.get(d.Text_1__c),
                                                         Unit_TI_Cost__c = d.Number_1__c,
                                                         RA_Unit_Refresh_Cost__c = d.Number_2__c,
                                                         RA_Unit_Renovate_Cost__c = d.Number_3__c,
                                                         RA_Unit_Core_Shell_Cost__c = d.Number_4__c,
                                                         Unit_TRCS_Cost__c = d.Number_5__c,
                                                         Unit_TI_Utilities_Cost__C = 0));

            }
            //Insert new TI-TRCS records
            insert tiTRCS;
        }

        if (hpcosts.size() > 0){
            Map<String, NCMT_Housing_Plan_Option__c> optMap = new Map<String, NCMT_Housing_Plan_Option__c>();
            for (NCMT_Housing_Plan_Option__c opt : [Select Id, NCMT_Housing_Plan_Option_Template__r.Sub_Type__c,
                CHOICE_TEXT__C from NCMT_Housing_Plan_Option__c where Choice_Text__c <> null
            ]){
                optMap.put(opt.NCMT_Housing_Plan_Option_Template__r.Sub_Type__c +opt.Choice_Text__c, opt);
            }

            List<NCMT_Housing_Plan_Cost_Parameter__c> movingCosts = new List<NCMT_Housing_Plan_Cost_Parameter__c>();
            for (NCMT_Data_Upload__c d : hpcosts){
                
                movingCosts.add(new NCMT_Housing_Plan_Cost_Parameter__c(
                    NCMT_Housing_Plan_Option__c = optMap.get(d.Text_2__c).Id,
                    Space_Type__c = d.Text_1__c,
                    Cost__c = d.Number_1__c,
                    Fiscal_Year__c = fiscalYear
                ));
            }
            insert movingCosts;
        }

        if (coreMap.size() > 0){
  
            List<NCMT_Core_Shell_Cost_Parameter__c> coreParams = new List<NCMT_Core_Shell_Cost_Parameter__c>();

          
            List<NCMT_Core_Shell_Cost_Parameter__c> newCore = new List<NCMT_Core_Shell_Cost_Parameter__c>();
            //List<NCMT_Core_Shell_Cost_Parameter__c> core2 = new List<NCMT_Core_Shell_Cost_Parameter__c>();
            for (String coreId : coreMap.keySet()){
                NCMT_Data_Upload__c d = coreMap.get(coreId);
                //NCMT_Core_Shell_Cost_Parameter__c t = existingCore.get(coreId);
                NCMT_Core_Shell_Cost_Parameter__c t = new NCMT_Core_Shell_Cost_Parameter__c(

                    OTHER_SPACE_UNIT_COST__C = d.Number_1__c,
                    PARKING_SPACE_UNIT_COST__C = d.Number_2__c,
                    Cost_Category__c = costCatMap.get(d.Text_1__c),
                    CORE_SHELL_COST_PARAMETER_IDENTIFIER__C = d.Text_2__c,
                    COST_SUB_TYPE__C = d.Text_3__c,
                    COST_SUB_TYPE_DESCRIPTION__C = d.Text_4__c,
                    OTHER_SPACE_UNIT__C = d.Text_5__c,
                    PARKING_SPACE_UNIT__C = d.Text_6__c,
                    Parking_Space_Size__c = d.Text_7__c,
                    Other_Space_Size__c = d.Text_8__c,
                    LEVEL_3__C = d.Text_9__c,
                    LEVEL_3_DESCRIPTION__C = d.Text_10__c,
                    Pct__c = d.Number_3__c,
                    Period__c = d.Number_4__c,
                    Sub__c = d.Number_5__c,
                    Duplicate_Maintenance_Related__c = (d.Text_11__c == 'TRUE' ? true : false),
                    Fiscal_Year__c = fiscalYear
                    
                );
                newCore.add(t);
                
                //Add records to update 
                //if(d.Text_11__c == 'udpate')
                //   core2.add(t);
            }
            insert newCore;
            
            //After inserting Core Shell, update the ones with TCO values
            System.debug('core2 === ' + core2.size());
            if(core2.size() > 0)
            {
                //List<NCMT_Core_Shell_Cost_Parameter__c> coresToUpdate = new List<NCMT_Core_Shell_Cost_Parameter__c>();
                Map<String, NCMT_Data_Upload__c> coreIds = new Map<String, NCMT_Data_Upload__C>();
                
                for(NCMT_Data_Upload__C d : core2)
                {
                    coreIds.put(d.Text_1__c, d);
                }
                
                List<NCMT_Core_Shell_Cost_Parameter__c> coresToUpdate = [SELECT Id, Core_Shell_Cost_Parameter_Identifier__c
                                                                         FROM NCMT_Core_Shell_Cost_Parameter__c
                                                                         WHERE Fiscal_Year__c =: fiscalYear
                                                                         AND Core_Shell_Cost_Parameter_Identifier__c IN: coreIds.keySet()];
                
                for(NCMT_Core_Shell_Cost_Parameter__c c : coresToUpdate)
                {
                    NCMT_Data_Upload__c d = coreIds.get(c.Core_Shell_Cost_Parameter_Identifier__c);
                    c.Type__c = d.Text_2__c;
                    c.Type1__c = d.Text_3__c;
                    c.Type2__c = d.Text_4__c;
                    c.Type3__c = d.Text_5__c;
                    c.Material_Unit_Cost__c = d.Number_1__c;
                    c.Equipment_Unit_Cost__c = d.Number_2__c;
                }
                
                System.debug('Updating! ' + coresToUpdate);
                update coresToUpdate;
            }
        }
        

        //Security params
        if (securityMap.size() > 0){
            List<NCMT_Security_Parameters__c> secParams = new List<NCMT_Security_Parameters__c>();
            for (String coreId : securityMap.keySet()){
                NCMT_Data_Upload__c d = securityMap.get(coreId);
            
                NCMT_Security_Parameters__c sec = new NCMT_Security_Parameters__c(
                    Fiscal_Year__c = fiscalYear,
                    SECURITY_CRITERION__C = d.Text_1__c,
                    Cost_Category__c = costCatMap.get(d.Text_2__c),
                    Level_3__c = d.Text_3__c,
                    Level_3_Description__c = d.Text_4__c,
                    //COST_DESCRIPTION__C = d.Text_4__c,
                    Primary_Impact__c = d.Text_5__c,
                    Cost_Unit__c = d.Text_6__c,
                    Level_I_Minimum__c = d.Number_1__c,
                    Level_II_Low__c = d.Number_2__c,
                    Level_III_Medium__c = d.Number_3__c,
                    Level_IV_High__c = d.Number_4__c,
                    Level_V_Very_High__c = d.Number_5__c
                );
                secParams.add(sec);
            }
            insert secParams;
        }

        //Location parameters
        if (locations.size() > 0){
            List<NCMT_Location_Parameters__c> locParams = new List<NCMT_Location_Parameters__c>();
            for (NCMT_Data_Upload__c d : locations){
                
                NCMT_Location_Parameters__c loc = new NCMT_Location_Parameters__c(
                    Fiscal_Year__c = fiscalYear,
                    City__c = d.Text_2__c,
                    State__c = d.Text_1__c,
                    Name = d.Text_2__c,
                    LPOE_Tier__c = d.Text_3__c,
                    Climate_Zone__c = d.Text_4__c,
                    Location_Based_SIF__c = d.Text_5__c,
                    Location_Tier_for_Quality__c = d.Text_6__c,
                    GSA_Region__c = d.Text_7__c,
                    State_Text__c = d.Text_8__c,
                    Salary_Locality_Area__c = d.Text_9__c,
                    M_S_A__c = d.Number_1__c,
                    M_S_B__c = d.Number_2__c,
                    Location_Adjustment_DC__c = d.Number_3__c,
                    Standard_Escalation__c = d.Number_4__c,
                    Freeze_Depth__c = d.Number_5__c,
                    PLA__c = d.Number_6__c,
                    SB_HUB__c = d.Number_7__c,
                    Tax_Override__c = d.Number_8__c,
                    TI_Cost_Adjustment__c = d.Number_9__c,
                    Composite_Shell_TI__c = d.Number_10__c,
                    Salary_Locality_Rate_DC_as_1__c = d.Number_11__c
                );
                locParams.add(loc);
            }
            insert locParams;
        }

        if (lpoeSpace.size() > 0){
            List<NCMT_LPOE_Parametric_Default_SpaceLookup__c> spaceParams = [Select Id, 
                LPOE_Line_Item__c, LPOE_Type__c, GSF_MX__C, GSF_C__C, SITE_VEH__C, SITE_PED__C
                from NCMT_LPOE_Parametric_Default_SpaceLookup__c where Name <> null];
            for (NCMT_LPOE_Parametric_Default_SpaceLookup__c s : spaceParams){
                System.debug(lpoeSpace);
                NCMT_Data_Upload__c d = lpoeSpace.get(s.LPOE_Type__c +s.LPOE_Line_Item__c);
                System.debug(s.LPOE_Type__c + s.LPOE_Line_Item__c);
                System.debug('d : ' + d);
                if (d != null){
                    s.GSF_MX__C = d.Number_1__c;
                    s.GSF_C__C = d.Number_2__c;
                    s.SITE_VEH__C = d.Number_3__c;
                    s.SITE_PED__C = d.Number_4__c;
                } else {
                    s.addError('Unable to find an existing LPOE Space Type record for ' +d.Text_2__c +': ' +d.Text_3__c);
                }
            }
            //System.debug('spaceParams: ' + spaceParams);
            //insert spaceParams;
            update spaceParams;
        }

        if (lpoeCosts.size() > 0){
            List<NCMT_LPOE_Parametric_Cost_Data__c> spaceParams = new List<NCMT_LPOE_Parametric_Cost_Data__c>();
            for (NCMT_Data_Upload__c d : lpoeCosts){
System.debug('LPOE Cost' + d );            
                NCMT_LPOE_Parametric_Cost_Data__c s = new NCMT_LPOE_Parametric_Cost_Data__c(
                    Fiscal_Year__c = fiscalYear,
                    COST_CATEGORY__C = d.Text_1__c,
                    BORDER_TYPE__C = d.Text_2__c, 
                    PORT_SIZE__C = d.Text_3__c,
                    POV_COMMERCIAL_TYPE__C = d.Text_4__c,
                    Site_Related__c = (d.Text_5__c == 'TRUE'),
                    Building_Group__c = d.Text_6__c,
                    Core_Shell_Cost__c = d.Number_1__c,
                    TI_Cost__c = d.Number_2__c,
                    Security_Cost__c = d.Number_3__c, 
                    TI_Percentage__c = d.Number_4__c
                );
                spaceParams.add(s);
            }
            insert spaceParams;
        }

        //Triage
        if (triage.size() > 0){
            List<NCMT_Project_Deliverable__c> delivs = [Select Id, Fiscal_Year__c 
                from NCMT_Project_Deliverable__c where Fiscal_Year__c = null];

            for (NCMT_Project_Deliverable__c d : delivs) d.Fiscal_Year__c = prevFiscalYear;

            update delivs;
            
            delivs = new List<NCMT_Project_Deliverable__c>();
            for (NCMT_Data_Upload__c d : triage){
                
                NCMT_Project_Deliverable__c del = new NCMT_Project_Deliverable__c(
                    Fiscal_Year__c = fiscalYear,
                    Project_type__c = d.Text_2__c,
                    Funding_Type__c = d.Text_1__c,
                    Project_Delivery_Method__c = d.Text_3__c,
                    Project_Budget__c = d.Text_4__c,
                    Project_Phases__c = d.Text_5__c,
                    Project_SubPhase__c = d.Text_6__c,
                    Name = d.Text_7__c,
                    Status__c = d.Text_8__c,
                    Sort_Order__c = d.Number_1__c
                );
                delivs.add(del);
            }
            insert delivs;
        }
        
        //CEW Parameters
        if(cewParam.size() > 0) 
        {
            List<NCMT_CEW_Parameter__c> cew = new List<NCMT_CEW_Parameter__c>();
            for(NCMT_Data_Upload__c d : cewParam)
            {
                NCMT_CEW_Parameter__c c = new NCMT_CEW_Parameter__c(
                    Name = d.Text_1__c,
                    Criteria_1__c = d.Text_2__c,
                    Criteria_2__c = d.Text_3__c,
                    Type__c = d.Text_4__c,
                    Value__c = d.Number_1__c,
                    Fiscal_Year__c = fiscalYear
                );
                
                cew.add(c);
            }
            insert cew;
        }
        
        //P100
        if(p100.size() > 0)
        {
            List<NCMT_P100_Parameter__c> p100s = new List<NCMT_P100_Parameter__c>();
            for(NCMT_Data_Upload__c d : p100)
            {
                NCMT_P100_Parameter__c p = new NCMT_P100_Parameter__c(
                    Cost_Category__C = costCatMap.get(d.Text_1__c),
                    PI00_CATEGORY__C = d.Text_2__c,
                    BASELINE__C = d.Number_1__c,
                    P100TIER1__C = d.Number_2__c,
                    P100TIER2__C = d.Number_3__c,
                    P100TIER3__C = d.Number_4__c,
                    Fiscal_Year__c = fiscalYear
                );
                
                p100s.add(p);
            }
            insert p100s;
        }
        
        //LEED
        if(leed.size() > 0)
        {
            List<NCMT_LEED_Parameter__c> leeds = new List<NCMT_LEED_Parameter__c>();
            for(NCMT_Data_Upload__c d : leed)
            {
                NCMT_LEED_Parameter__c l = new NCMT_LEED_Parameter__C(
                    Cost_Category__c = costCatMap.get(d.Text_1__c),
                    LEED_GROUPING__C = d.Text_2__c,
                    PARAMETER_TYPE__C = d.Text_3__c,
                    LEED_CATEGORY__C = d.Text_4__c,
                    LEED_MAX_POINTS__C = d.Number_1__c,
                    CLASS_A_PERCENT__C = d.Number_2__c,
                    CODE_MINIMUM_PERCENT__C = d.Number_3__c,
                    P100_PERCENT__C = d.Number_5__c,
                    TOTAL_POINTS__C = d.Number_4__c,                    
                    Fiscal_Year__C = fiscalYear
                );
                
                leeds.add(l);
            }
            insert leeds;
        }
        
        //RA Mods
        if(raMod.size() > 0)
        {
            List<NCMT_RA_Mods__c> mods = new List<NCMT_RA_Mods__c>();
            for(NCMT_Data_Upload__c d : raMod)
            {
                NCMT_RA_Mods__c m = new NCMT_RA_Mods__c(
                    Cost_Category__c = costCatMap.get(d.Text_1__c),
                    RA_CATEGORY_TYPE__C = d.Text_2__c,
                    RA_CATEGORY__C = d.Text_3__c,
                    VERY_GOOD__C = d.Number_1__c,
                    GOOD__C = d.Number_2__c,
                    MODERATE__C = d.Number_3__c,
                    POOR__C = d.Number_4__c,
                    VERY_POOR__C = d.Number_5__c,
                    Fiscal_Year__c = fiscalYear
                );
                
                mods.add(m);
            }
            insert mods;
        }
        
        //RA Overhead Analysis
        if(raOverhead.size() > 0)
        {
            List<NCMT_RA_Overhead_Analysis__c> overheads = new List<NCMT_RA_Overhead_Analysis__c>();
            for(NCMT_Data_Upload__C d : raOverhead)
            {
                NCMT_RA_Overhead_Analysis__c o = new NCMT_RA_Overhead_Analysis__c(
                    OVERHEAD_TYPE__C = d.Text_1__c,
                    CONTRACT_AMOUNT__C = d.Number_1__c,
                    FULLY_OCCUPIED__C = d.Number_2__c,
                    FULLY_VACANT_BUILDING__C = d.Number_3__c,
                    NEW__C = d.Number_4__c,
                    PARTIALLY_VACANT_WORK_AREA__C = d.Number_5__c,
                    VACANT_WORK_AREA_CLEAR_PATH_TRAVEL__C = d.Number_6__c,
                    VACANT_WORK_AREA_DIFFICULT_PATH_TRAVEL__C = d.Number_7__c,
                    Fiscal_Year__c = fiscalYear
                );
                overheads.add(o);
            }
            insert overheads;
        }
        
        //RA Work Item Lookup Detail
        if(raWI.size() > 0)
        {
            List<NCMT_RA_WI_Lookup_Details__c> wiDetails = new List<NCMT_RA_WI_Lookup_Details__c>();
            for(NCMT_Data_Upload__c d : raWI)
            {
                NCMT_RA_WI_Lookup_Details__c wi = new NCMT_RA_WI_Lookup_Details__c(
                    Cost_Category__c = costCatMap.get(d.Text_1__c),
                    UOM__c = d.Text_2__c,
                    WI_CATEGORY_CODE__C = d.Text_3__c,
                    WI_CATEGORY_DESCRIPTION__C = d.Text_4__c,
                    WI_CATEGORY_SUB_DESCRIPTION__C = d.Text_5__c,
                    WI_CATEGORY_SUB_TYPE__C = d.Text_6__c,
                    WORK_ITEM_CATEGORY_TYPE__C = d.Text_7__c,
                    WORK_ITEM_TYPE__C = d.Text_8__c,
                    Flag1__c = d.Number_1__c,
                    Flag2__c = d.Number_2__c,
                    High__c = d.Number_3__c,
                    Low__c = d.Number_4__c,
                    Parking__c = d.Number_5__c,
                    Quantity_SF__c = d.Number_6__c,
                    Rate__c = d.Number_7__c,
                    Fiscal_Year__c = fiscalYear
                );
            }
        }
        
        //RA Quality Code Lookup
        if(raQuality.size() > 0)
        {
            //DON'T NEED!
            /*List<NCMT_RA_Quality_Code_Lookup__c> raQuals = new List<NCMT_RA_Quality_Code_Lookup__c>();
            for(NCMT_Data_Upload__c d : raQuality)
            {
                NCMT_RA_Quality_Code_Lookup__c q = new NCMT_RA_Quality_Code_Lookup__c(
                    //Fiscal_Year__c = '2021'
                );
                raQuals.add(q);
            }
            insert raQuals;*/
        }
        
        //AE_CMa_CMx_Cx
        if(ae_cma_cmc_cx.size() > 0)
        {
          List<AE_CMa_CMc_Cx__c> ae = new List<AE_CMa_CMc_Cx__c>();
          ae = [SELECT Name, Building_Type__c, Build_to_Suit_Tenant_Fit_out_w_Redesign__c,
                        CM_Role__c,Construction_CM_Role_Adj_CMa_and_CMc__c,Construction_CM_Role_Adjustment_CMa__c,  
                        Construction_CM_Role_Adjustment_CMc__c,Construction_Constant_A_E__c,Construction_Constant_CMa__c,
                        Construction_Constant_Cx__c,Construction_Delivery_Method_Adj_A_E__c,Construction_Exponent_A_E__c,
                        Construction_Exponent_CMa__c,Construction_Exponent_Cx__c,Construction_Value_A_E__c, 
                        Construction_Value_CMa__c, Construction_Value_CMa_and_CMc__c,Construction_Value_CMc__c,
                        Construction_Value_Cx__c, Delivery_Type__c,Design_CM_Role_Adjustment_CMa__c,Design_CM_Role_Adjustment_CMa_and_CMc__c,
                        Design_CM_Role_Adjustment_CMc__c,Design_Constant_A_E__c,Design_Constant_CMa__c,Design_Constant_Cx__c,
                        Design_Delivery_Method_Adjustment_A_E__c,Design_Exponent_A_E__c,Design_Exponent_CMa__c,Design_Exponent_Cx__c,
                        Design_Value_A_E__c,Design_Value_CMa__c,Design_Value_CMa_and_CMc__c,Design_Value_CMc__c,
                        Design_Value_Cx__c,Fiscal_Year__c,Project_Type__c,Tenant_Fit_Out__c,Type__c
                FROM AE_CMa_CMc_Cx__c WHERE Fiscal_Year__c = :decimal.valueOf(prevFiscalYear)];
         
         List<AE_CMa_CMc_Cx__c> ae_fy= new List<AE_CMa_CMc_Cx__c>();
         for(AE_CMa_CMc_Cx__c a : ae)
         {
            a.Id = null;
            a.Fiscal_Year__c = decimal.valueOf(fiscalYear);
            ae_fy.add(a);
         }
            insert ae_fy;
            
            
            List<Professional_Service_Estimate_Parameter__c> psParam = [SELECT A_E_SUM_75_Average__c,A_E_SUM_90_Average__c,
                                                                        CM_75_Average__c,CM_90_Average__c,Const_Bldg_Inspectors_Cx_75_Average__c,
                                                                        Const_Bldg_Inspectors_Cx_90_Average__c,Complexity_High_Detail_High__c,
                                                                        Complexity_High_Detail_Low__c,Complexity_High_Detail_Medium__c,
                                                                        Complexity_Low_Detail_High__c,Complexity_Low_Detail_Low__c,Complexity_Low_Detail_Medium__c,
                                                                        Complexity_Medium_Detail_High__c,Complexity_Medium_Detail_Low__c,Complexity_Medium_Detail_Medium__c,
                                                                        Cost_Advantage_ECCA_GT500_000_000__c,Cost_Advantage_ECCA_100_000_000__c,Cost_Advantage_ECCA_25_000_000__c,
                                                                        Cost_Advantage_ECCA_250_000_000__c,Cost_Advantage_ECCA_50_000_000__c,Cost_Advantage_ECCA_500_000_000__c,
                                                                        Distributed_Scope_Category_1__c,Distributed_Scope_Category_2__c,Distributed_Scope_Category_3__c,
                                                                        Distributed_Scope_Category_4__c,Distributed_Scope_Category_5__c,ECC_Ranges_constant_100_000_000__c,
                                                                        ECC_Ranges_constant_100_000_0000__c,ECC_Ranges_constant_150_000_000__c,ECC_Ranges_constant_200_000_000__c,
                                                                        ECC_Ranges_constant_25_000_000__c,ECC_Ranges_constant_50_000_000__c,ECC_Ranges_exponent_100_000_000__c,
                                                                        ECC_Ranges_exponent_100_000_0000__c,ECC_Ranges_exponent_150_000_000__c,ECC_Ranges_exponent_200_000_000__c,
                                                                        ECC_Ranges_exponent_25_000_000__c,ECC_Ranges_exponent_50_000_000__c,Full_Modernization_Category_1__c,
                                                                        Full_Modernization_Category_2__c,Full_Modernization_Category_3__c,Full_Modernization_Category_4__c,
                                                                        Full_Modernization_Category_5__c,GSA_CM_Construction_Constant__c,GSA_CM_Construction_Slope__c,
                                                                        GSA_CM_Design_Constant__c,GSA_CM_Design_Slope__c,Limited_Scope_Category_1__c,   Limited_Scope_Category_2__c,
                                                                        Limited_Scope_Category_3__c,Limited_Scope_Category_4__c,Limited_Scope_Category_5__c,Number_of_Phases_2_ECC_Range_1__c,
                                                                        Number_of_Phases_2_ECC_Range_2__c,Number_of_Phases_2_ECC_Range_3__c,Number_of_Phases_2_ECC_Range_4__c,
                                                                        Number_of_Phases_2_ECC_Range_5__c,Number_of_Phases_2_ECC_Range_6__c,Number_of_Phases_2_ECC_Range_7__c,
                                                                        Number_of_Phases_2_ECC_Range_8__c,Number_of_Phases_2_ECC_Range_9__c,Number_of_Phases_3_ECC_Range_1__c,
                                                                        Number_of_Phases_3_ECC_Range_2__c,Number_of_Phases_3_ECC_Range_3__c,Number_of_Phases_3_ECC_Range_4__c,
                                                                        Number_of_Phases_3_ECC_Range_5__c,Number_of_Phases_3_ECC_Range_6__c,Number_of_Phases_3_ECC_Range_7__c,
                                                                        Number_of_Phases_3_ECC_Range_8__c,Number_of_Phases_3_ECC_Range_9__c,Number_of_Phases_4Plus_ECC_Range_1__c,
                                                                        Number_of_Phases_4Plus_ECC_Range_2__c,Number_of_Phases_4Plus_ECC_Range_3__c,Number_of_Phases_4Plus_ECC_Range_4__c,
                                                                        Number_of_Phases_4Plus_ECC_Range_5__c,Number_of_Phases_4Plus_ECC_Range_6__c,Number_of_Phases_4Plus_ECC_Range_7__c,
                                                                        Number_of_Phases_4Plus_ECC_Range_8__c,Number_of_Phases_4Plus_ECC_Range_9__c,Number_of_Phases_4_ECC_Range_1__c,
                                                                        Number_of_Phases_4_ECC_Range_2__c,Number_of_Phases_4_ECC_Range_3__c,Number_of_Phases_4_ECC_Range_4__c,
                                                                        Number_of_Phases_4_ECC_Range_5__c,Number_of_Phases_4_ECC_Range_6__c,Number_of_Phases_4_ECC_Range_7__c,
                                                                        Number_of_Phases_4_ECC_Range_8__c,Number_of_Phases_4_ECC_Range_9__c 
                                                                    FROM Professional_Service_Estimate_Parameter__C WHERE Name =:prevFiscalYear];
            //There should be only one Prof Serv Est Param record
            // changing ps_2021.Name
            if (psParam.size() == 1)
            {
                Professional_Service_Estimate_Parameter__c ps = psParam[0];
                ps.Id = null;
                ps.Name = fiscalYear;
                insert ps;
            }
        }
    }

    /*public void tempMove(){
        Map<String, NCMT_Data_Upload__c> hpTempMap = new Map<String, NCMT_Data_Upload__c>();
        Map<String, NCMT_Data_Upload__c> securityMap = new Map<String, NCMT_Data_Upload__c>();
        Map<String, NCMT_Data_Upload__c> hpchoiceMap = new Map<String, NCMT_Data_Upload__c>();
        Map<String, NCMT_Data_Upload__c> hpcostMap = new Map<String, NCMT_Data_Upload__c>();
        Map<String, NCMT_Data_Upload__c> coreMap = new Map<String, NCMT_Data_Upload__c>();
        for (NCMT_Data_Upload__c d : newList){
            if (d.Upload__c == 'template'){
                hpTempMap.put(d.Text_1__c, d);
            }
            if (d.Upload__c == 'choice'){
                hpchoiceMap.put(d.Text_1__c +d.Text_3__c, d);
            }
           
        }

        Map<String, Id> costCatMap = new Map<String, Id>();
        for (NCMT_Cost_Category__c cat : [Select Id, Name, Category_Description__c
                from NCMT_Cost_Category__c where Category_Description__c <> null]
        ){
            costCatMap.put(cat.Name, cat.Id);
        }

        if (hpTempMap.size() > 0){
            List<NCMT_Housing_Plan_Option_Template__c> temps = new List<NCMT_Housing_Plan_Option_Template__c>();

            for (NCMT_Data_Upload__c d : hpTempMap.values()){
                temps.add(new NCMT_Housing_Plan_Option_Template__c(
                    TYPE__C = d.Text_2__c, 
                    SUB_TYPE__C = d.Text_3__c,
                    SORT_ORDER__C = d.Number_1__c
                ));
            }
            insert temps;
        }
        

        if (hpchoiceMap.size() > 0){
            Map<String, Id> mapTemps = new Map<String, Id>();
            for (NCMT_Housing_Plan_Option_Template__c hp : [Select Id, Sub_type__c from NCMT_Housing_Plan_Option_Template__c where Sub_Type__c <> null]){
                mapTemps.put(hp.Sub_Type__c, hp.Id);
            }
            List<NCMT_Housing_Plan_Option__c> choices = new List<NCMT_Housing_Plan_Option__c>();

            for (NCMT_Data_Upload__c d : hpchoiceMap.values()){
                choices.add(new NCMT_Housing_Plan_Option__c(
                    NCMT_Housing_Plan_Option_Template__c = mapTemps.get(d.Text_1__c),
                    DESCRIPTION__C = d.Text_2__c, 
                    CHOICE_TEXT__C = d.Text_3__c,
                    SORT_ORDER__C = d.Number_1__c,
                    TCO_DEFAULT_REPAIR_COST_PERCENTAGE__C = d.Number_2__c,
                    TCO_DEFAULT_REPAIR_EVERY_X_YEARS__C = d.Number_3__c,
                    TCO_DEFAULT_REPLACEMENT_EVERY_X_YEARS__C = d.Number_4__c,
                    RECURS_ON_TCO_TENANT_RENEWAL_YEARS__C = (d.Text_4__c == 'TRUE')
                ));
            }
            insert choices;
        }

    }*/

    //NCMT_DataUpload_TriggerHandler.removeAssemblyLookupDetailDuplicates();
    @ReadOnly @RemoteAction
    public static void removeAssemblyLookupDetailDuplicates(){
        List<NCMT_CustomSettings__c> fy1 = [SELECT Data_Load_Current_FY__c,Data_Load_Previous_FY__c FROM NCMT_CustomSettings__c Limit 1];
        String fiscalYear1 = fy1[0].Data_Load_Current_FY__c;
        
        AggregateResult[] aggregateResultRecords = [SELECT Count(Id), Name FROM NCMT_Assembly_Lookup_detail__c WHERE Fiscal_Year__c = : fiscalYear1
                                                    GROUP BY Name HAVING Count(Id) > 1];
        Database.executeBatch(new NCMT_RemoveDuplicatesBatch('NCMT_Assembly_Lookup_detail__c',fiscalYear1, aggregateResultRecords), 200);
    }
    
    //NCMT_DataUpload_TriggerHandler.removeDESLookupDetailsDuplicates();
    @ReadOnly @RemoteAction
    public static void removeDESLookupDetailsDuplicates(){ 
        List<NCMT_CustomSettings__c> fy1 = [SELECT Data_Load_Current_FY__c,Data_Load_Previous_FY__c FROM NCMT_CustomSettings__c Limit 1];
        String fiscalYear1 = fy1[0].Data_Load_Current_FY__c;
        
        AggregateResult[] aggregateResultRecords = [SELECT Count(Id), Name FROM NCMT_DES_Lookup_details__c WHERE Fiscal_Year__c = : fiscalYear1
                                     GROUP BY Name HAVING Count(Id) > 1 Limit 10000];
        Database.executeBatch(new NCMT_RemoveDuplicatesBatch('NCMT_DES_Lookup_details__C',fiscalYear1, aggregateResultRecords), 200);
    }

    //NCMT_DataUpload_TriggerHandler.removeAssemblyLookupItemDuplicates();
    @ReadOnly @RemoteAction
    public static void removeAssemblyLookupItemDuplicates(){
        List<NCMT_CustomSettings__c> fy1 = [SELECT Data_Load_Current_FY__c,Data_Load_Previous_FY__c FROM NCMT_CustomSettings__c Limit 1];
        String fiscalYear1 = fy1[0].Data_Load_Current_FY__c;
        
        AggregateResult[] aggregateResultRecords = [SELECT Count(ID), Assembly_Lookup_Detail__r.Name ass, Master_Format_Line_Item_Number__c 
                                      FROM NCMT_Assembly_Lookup_Item__c 
                                      WHERE File_Name__c != 'GSAAssemblies' AND Fiscal_Year__c =  : fiscalYear1
                                      GROUP BY Master_Format_Line_Item_Number__c,Assembly_Lookup_Detail__r.Name 
                                      HAVING Count(Id) > 1 ORDER BY Assembly_Lookup_Detail__r.Name LIMIT 50000];
        Database.executeBatch(new NCMT_RemoveDuplicatesBatch('NCMT_Assembly_Lookup_Item__c',fiscalYear1, aggregateResultRecords), 200);
    }
}