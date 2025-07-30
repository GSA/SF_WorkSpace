//Class Updated by Henry Dennis 7/6/22

public with sharing class PBS_AAAP_AgencyRequirement_Ext extends PBS_AAAP_PageBaseController {

    public PBS_AAAP_Agency_Requirement__c currentObj;
    private ApexPages.StandardController stdController;
    public String polyName { get; set; }        // added 05/24/2012 CHenson: provides access to polygon name
    public String polyId { get; set; }        // added 05/24/2012 CHenson: provides access to polygon ID

    //public decimal pvDefault_TIUSED_FIRM_TERM_NEW { get; set; }        // added 10/25/2018 BHoque: value comes from RLP and saved at Agency Requirement.
    public string pvDefault_TIUSED_FIRM_TERM_NEW_STR { get; set; }

    //public string pvDefault_TIUSED_FIRM_TERM_NEW_Edit { get; set; }        // added 10/25/2018 BHoque: value comes from RLP and saved at Agency Requirement.
    //public string pvDefault_TIUSED_FIRM_TERM_NEW_Edit_STR { get; set; }        // added 10/25/2018 BHoque: value comes from RLP and saved at Agency Requirement.

    public string pvDefault_BSAC_per_ABOA { get; set; }
    //public string pvDefault_BSAC_per_ABOA_STR { get; set; }

    //public string pvDefault_BSAC_per_ABOA_Edit { get; set; }

    public string pvDefault_TIUSED_FOR_FIRM_TERM_SUCC { get; set; }
    //public string pvDefault_TIUSED_FOR_FIRM_TERM_SUCC_Edit { get; set; }
    
    public string pvDefault_BSAC_for_Continuing_Space_per_ABOA_SF { get; set; }

    //public string pvDefault_BSAC_for_Continuing_Space_per_ABOA_SF_Edit { get; set; }
    public string pvDefault_PBS_AAAP_MOVE_DEFAULT { get; set; }
    //public string pvDefault_PBS_AAAP_MOVE_DEFAULT_Edit { get; set; }
    public string pvDefault_PBS_AAAP_TELCOMM_DEFAULT { get; set; }
    //public string pvDefault_PBS_AAAP_TELCOMM_DEFAULT_Edit { get; set; }
    public string pvDefault_PBS_AAAP_PV_OTHER_UPFRONT_COSTS { get; set; }
    //public string pvDefault_PBS_AAAP_PV_OTHER_UPFRONT_COSTS_Edit { get; set; }

    public string selectedRlpNumber { get; set; }
    public string selectedRegion { get; set; }
    public boolean showLeaseSection { get; set; }
    //public boolean showModifyRequirement { get; set; }
    public boolean editRequirement { get; set; }
    public List<PBS_AAAP_RLP__c> rlps = new List<PBS_AAAP_RLP__c>();
    public List<PBS_AAAP_RLP__c> rlpForPvDefaults = new List<PBS_AAAP_RLP__c>();
    public List<PBS_AAAP_RLP__c> rlpforLeaseTerm = new List<PBS_AAAP_RLP__c>();
    List<PBS_AAAP_Agency_Requirement__c> agencyRequirement = new List<PBS_AAAP_Agency_Requirement__c> ();
    public String rlpFYYear = '2016';

    Boolean newAG {get; set;}

    public boolean displayPopup {get; set;}
    public string cancellationReason {get; set;}
    public boolean showCancelError {get; set;}

    public boolean displayPopup2 {get; set;}
    public string reactivationReason {get; set;}
    public boolean showReactivationError {get; set;}

    public string canErr {get; set;}
    public string reactErr {get; set;}
    
    //Julia Kantarovsky changes 11/2020 start here
    public string rexusProjectId {get; set;} //Rexus project Id user input
    public boolean displayRexusPopup {get; set;} //flag for Rexus popup
    public boolean isNewRecord {get; set;} //flag for showing/hiding the Import from Rexus button. Similar to newAG variable above, but I created a new one so as not to affect current logic
    public String rexusDataStr {get; set;} //string to pass back to JS to fill in the fields on the page
    public String runningUserName {get; set;}
    public String AAAPCustomerPortalAccountName {get; set;}
    public String errorStyle {get; set;}
    public Boolean responseFlag {get; set;}
    public Boolean redErrorOnly {get; set;}
    //Mule API variables:
    private static APIMuleHelper.APIAttributes apiAttributes = null;
    //private static String vfilters = 'lop/agencyRequirement/';
    private static String endpoint = '';
    private static List<Log__e> allLogs = new List<Log__e>();

    //JK changes end

    public PBS_AAAP_AgencyRequirement_Ext(ApexPages.StandardController stdController) {
        logMethodStart('PBS_AAAP_AgencyRequirement_Ext controller');
        system.debug('PBS_AAAP_AgencyRequirement_Ext controller');
        
        //Julia Kantarovsky changes 11/2020 start here
        //System.debug('JK onload displayRexusPopup ' + displayRexusPopup);
        System.debug('JK showCancelError ' + showCancelError);
        //get running user:
        runningUserName = UserInfo.getName();
        //JK changes end
        
        //stdController.addFields(new List<String>{'PBS_AAAP_RLP_Number__c'});
        this.stdController = stdController;
        this.currentObj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        //currentObj.PBS_AAAP_Region__c = 'National Capital Region';

        displayPopup = FALSE;
        showCancelError = FALSE;
        displayPopup2 = FALSE;
        showReactivationError = FALSE;

        agencyRequirement = [SELECT id, name, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, 
                    PBS_AAAP_BSAC_per_ABOA__c, BSAC_for_Continuing_Space_per_ABOA_SF__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c,
                    PBS_AAAP_MOVE_DEFAULT__C, PBS_AAAP_TELCOMM_DEFAULT__c, PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c                    //, Is_Historical__c
                    FROM PBS_AAAP_Agency_Requirement__c WHERE id = :this.currentObj.id ];

        if (agencyRequirement.size() > 0) {
            //Julia Kantarovsky changes 11/2020 start here
            isNewRecord = false;
            //JK changes to here
            selectedRegion = agencyRequirement[0].PBS_AAAP_Region__c;
            selectedRlpNumber = agencyRequirement[0].PBS_AAAP_RLP_Number__c;

            pvDefault_TIUSED_FIRM_TERM_NEW_STR = string.valueof( agencyRequirement[0].PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c );
            //pvDefault_TIUSED_FIRM_TERM_NEW_Edit_STR = string.valueof(agencyRequirement[0].PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c);

            pvDefault_BSAC_per_ABOA = string.valueof(agencyRequirement[0].PBS_AAAP_BSAC_per_ABOA__c);
            pvDefault_TIUSED_FOR_FIRM_TERM_SUCC = string.valueof(agencyRequirement[0].PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c);
            pvDefault_BSAC_for_Continuing_Space_per_ABOA_SF = string.valueof(agencyRequirement[0].BSAC_for_Continuing_Space_per_ABOA_SF__c);
            pvDefault_PBS_AAAP_MOVE_DEFAULT = string.valueof(agencyRequirement[0].PBS_AAAP_MOVE_DEFAULT__C) ;
            pvDefault_PBS_AAAP_TELCOMM_DEFAULT = string.valueof(agencyRequirement[0].PBS_AAAP_TELCOMM_DEFAULT__c) ;
            pvDefault_PBS_AAAP_PV_OTHER_UPFRONT_COSTS = string.valueof(agencyRequirement[0].PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c);

            newAG = FALSE;
            //if(agencyRequirement[0].Is_Historical__c == TRUE){
                //isHist = TRUE;
            //}
        } else {
            //Julia Kantarovsky changes 11/2020 start here
            isNewRecord = true;
            //JK changes end
            pvDefault_TIUSED_FIRM_TERM_NEW_STR = '0.00';
            pvDefault_BSAC_per_ABOA = '0.00';
            pvDefault_TIUSED_FOR_FIRM_TERM_SUCC = '0.00';
            pvDefault_BSAC_for_Continuing_Space_per_ABOA_SF = '0.00';
            pvDefault_PBS_AAAP_MOVE_DEFAULT = '0.00';
            pvDefault_PBS_AAAP_TELCOMM_DEFAULT = '0.00';
            pvDefault_PBS_AAAP_PV_OTHER_UPFRONT_COSTS = '0.00';

            newAG = TRUE;
        }        

        //system.debug( 'PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c=> ' + pvDefault_TIUSED_FIRM_TERM_NEW_Edit );

       //showModifyRequirement = currentObj.PBS_AAAP_REQ_STATUS__c == PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING;

        // Changes made by sguni on 10/29/2012 to show the correct value in picklist.
        if (currentObj.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != 'SubMarket' && currentObj.PBS_AAAP_DELINEATED_DESCRIPTION__c != null && currentObj.PBS_AAAP_DELINEATED_DESCRIPTION__c.trim() != '') {
            currentObj.PBS_AAAP_DELINEATED_DESCRIPTION__c = (currentObj.PBS_AAAP_DELINEATED_DESCRIPTION__c).toUpperCase();
        }
        this.editRequirement = true;

        // added 05/24/2012 CHenson: provides access to polygon ID
        if (ApexPages.currentPage().getParameters().get('polyId') != null) {
            this.polyId = ApexPages.currentPage().getParameters().get('polyId');
            if (ApexPages.currentPage().getParameters().containsKey('polyName')) {        // cannot use urlDecode on null values, so must check if key exists
                this.polyName = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('polyName'), 'UTF-8');
                System.debug('****** this.polyName: ' + this.polyName);
            }    // end if

            System.debug('***** IF polyId: ' + this.polyId + '***** polyName: ' + this.polyName);
        } else {
            if (this.currentObj.Id != null) {
                try {
                    System.debug('***** IF #2 this.currentObj.Id: ' + this.currentObj.Id);
                    PBS_AAAP_PolyObject__c pObj = [SELECT p.Id, p.Name, p.PBS_AAAP_Agency_Requirement__c FROM PBS_AAAP_PolyObject__c p WHERE p.PBS_AAAP_Agency_Requirement__c = :THIS.currentObj.Id LIMIT 1];
                    this.polyId = pObj.Id;
                    this.polyName = pObj.Name;
                    System.debug('***** IF #2 polyId: ' + this.polyId + '---' + '***** polyName: ' + this.polyName);
                } catch (Exception e) {
                    this.polyId = '';
                    this.polyName = '';
                    System.debug('***** Else #2 polyId: ' + this.polyId + '---' + '***** polyName: ' + this.polyName);
                }    // end try/catch
            }    // end if

        }    // end if


        if (currentObj.PBS_AAAP_TYPE_OF_REQUIREMENT__c == 'Continuing') {
            showLeaseSection = true;
        }
    }


    public PageReference shapeCreation() {
        logMethodStart('shapeCreation');
        PageReference pgShapeCreation = Page.PBS_AAAP_AgencyRequirementShape;

        actionSaveAgencyRequirement();
        pgShapeCreation.getParameters().put('id', stdController.getId());
        System.debug('***** this.polyId' + this.polyId);
        if (this.polyId != null) {
            pgShapeCreation.getParameters().put('polyId', this.polyId);
        }        // there is a polygon ID, so put that into the URL
        System.debug('***** this.polyId.length:' + this.polyId);
        System.debug('***** this.polyName:' + this.polyName);
        if (this.polyName != null) {
            pgShapeCreation.getParameters().put('polyName', EncodingUtil.urlEncode(this.polyName, 'UTF-8'));
        }        // there is a polygon Name, so put that into the URL
        pgShapeCreation.getParameters().put('copy', 'false');
        pgShapeCreation.setRedirect(true);
        System.debug('***** pgShapeCreation:' + pgShapeCreation);
        return pgShapeCreation;
    }    // end shapeCreation


    public List<SelectOption> getRLPList() {
        logMethodStart('getRLPList');

        PBS_AAAP_Agency_Requirement__c obj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        PageReference ref = null;
        List<SelectOption> options = new List<SelectOption>();

        if (obj.PBS_AAAP_Region__c != null) {

            if(newAG == FALSE) {
                rlps = [
                        SELECT id, name, PBS_AAAP_RLP_Number__c
                        FROM PBS_AAAP_RLP__c
                        WHERE PBS_AAAP_Region__c = :obj.PBS_AAAP_Region__c
                        //AND PBS_AAAP_STATUS__c = :PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE
                ];
            } else {
                rlps = [
                        SELECT id, name, PBS_AAAP_RLP_Number__c
                        FROM PBS_AAAP_RLP__c
                        WHERE PBS_AAAP_Region__c = :obj.PBS_AAAP_Region__c
                        AND PBS_AAAP_STATUS__c = :PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE
                ];
            }
            
            if(!rlps.isEmpty()){
                for (PBS_AAAP_RLP__c r : rlps) {
                    options.add(new SelectOption(r.PBS_AAAP_RLP_Number__c, r.PBS_AAAP_RLP_Number__c));
                }
            } else {
                options.add(new SelectOption('', ''));
            }
        }

        system.debug( 'gettestRLP' );
        //system.debug('*********1'+showModifyRequirement);
        system.debug('*********2'+showLeaseSection);
        

        return options;
    }


  //REGION SELECTION PICKLIST METHOD START Henry Dennis UPDATE.
   public List<SelectOption> getRegionList() {
        logMethodStart('getRegionList');

       // Todd Brown 05/05/2021 SFWS-1236 replaced hardcoding of regions with dynamic logic to pull from Agency Rqmt object picklist field
        List<SelectOption> options = new List<SelectOption>();
        
        //--None-- value add by Henry Dennis 7/6/22
        options.add(new SelectOption('', '--None--'));
        /*options.add(new SelectOption('National Capital Region', 'National Capital Region'));
        options.add(new SelectOption('Region 1', 'Region 1'));
        options.add(new SelectOption('Region 2', 'Region 2'));
        options.add(new SelectOption('Region 3', 'Region 3'));
        options.add(new SelectOption('Region 4', 'Region 4'));
        options.add(new SelectOption('Region 5', 'Region 5'));
        options.add(new SelectOption('Region 6', 'Region 6'));
        options.add(new SelectOption('Region 7', 'Region 7'));
        options.add(new SelectOption('Region 8', 'Region 8'));
        options.add(new SelectOption('Region 9', 'Region 9'));
        options.add(new SelectOption('Region 10', 'Region 10'));
        //added by syam on 12/28/2016 for Census release 
        //options.add(new SelectOption('Census', 'Census'));
        //*/
        
        Schema.DescribeFieldResult fieldResult = PBS_AAAP_Agency_Requirement__c.PBS_AAAP_Region__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        //List<SelectOption> options = new List<SelectOption>();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
            
        } 

        return options;
    }
    
    //REGION SELECTION PICKLIST METHOD ENDS.
    
    

    public List<SelectOption> getLeaseTermList() {
        logMethodStart('getLeaseTermList');
        PBS_AAAP_Agency_Requirement__c obj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        PageReference ref = null;
        List<SelectOption> options = new List<SelectOption>();
        System.debug('options1: '+options);

        // PBS_AAAP_Region__c == null || obj.PBS_AAAP_RLP_Number__c

        List<PBS_AAAP_Agency_Requirement__c> agencyRequirement = [

                        SELECT id, name, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c 
                        FROM PBS_AAAP_Agency_Requirement__c WHERE id = :obj.id 
                    ];

        if (agencyRequirement.size() > 0) {

            //selectedRegion = agencyRequirement[0].PBS_AAAP_Region__c;
            //selectedRlpNumber = agencyRequirement[0].PBS_AAAP_RLP_Number__c;
            system.debug('%%%%%'+selectedRegion);
            system.debug('%%%%%'+selectedRlpNumber);
        }       
        options.clear();
        System.debug('options2: '+options);
         if (selectedRlpNumber != null)
         {
            System.debug('options#: '+selectedRlpNumber);
            System.debug('options#: '+selectedRegion);
            for (PBS_AAAP_RLP__c r : [ Select PBS_AAAP_Year__c FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_RLP_Number__c = : selectedRlpNumber]) {

                if(Integer.valueOf(r.PBS_AAAP_Year__c) < 2019){
                    options.add(new SelectOption('', '--None--'));
                    options.add(new SelectOption('10 years,5 firm', '10 years,5 firm'));
                    options.add(new SelectOption('15 years,10 firm', '15 years,10 firm'));
                    options.add(new SelectOption('10 years', '10 years'));
                    //options.add(new SelectOption('19 months,11 firm', '19 months,11 firm'));
                    //options.add(new SelectOption('25 months,16 firm', '25 months,16 firm'));
                    System.debug('options3: '+options);
                }else {
                
                    if(currentObj.PBS_AAAP_Region__c == '10/5 Term - All Regions'){
                         options.add(new SelectOption('', '--None--'));
                         options.add(new SelectOption('10 years,5 firm', '10 years, 5 firm'));
                    }else if (Integer.valueOf(r.PBS_AAAP_Year__c) > 2021){
                        options.add(new SelectOption('', '--None--'));
                        options.add(new SelectOption('10 years, 8 firm', '10 years, 8 firm'));
                        options.add(new SelectOption('15 years, 13 firm', '15 years, 13 firm'));
                        options.add(new SelectOption('17 years, 15 firm', '17 years, 15 firm'));
                        System.debug('options3: '+options);
                    }else{

                        options.add(new SelectOption('', '--None--'));
                        //options.add(new SelectOption('10 years,5 firm', '10 years,5 firm'));
                        //options.add(new SelectOption('15 years,10 firm', '15 years,10 firm'));
                        //options.add(new SelectOption('10 years', '10 years'));
                        options.add(new SelectOption('10 years, 8 firm', '10 years, 8 firm'));
                        options.add(new SelectOption('15 years, 13 firm', '15 years, 13 firm'));
                        options.add(new SelectOption('17 years, 15 firm', '17 years, 15 firm'));
                        //options.add(new SelectOption('19 months, 11 firm', '19 months, 11 firm'));
                        //options.add(new SelectOption('25 months, 16 firm', '25 months, 16 firm'));
                        System.debug('options4: '+options);
    
                    }
                }
            }
            System.debug('options5: '+options);
        }else{
            System.debug('options6: '+options);
            //List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--None--'));
             if(currentObj.PBS_AAAP_Region__c == '10/5 Term - All Regions'){
            options.add(new SelectOption('10 years,5 firm', '10 years, 5 firm'));
             }else{
            //options.add(new SelectOption('15 years,10 firm', '15 years,10 firm'));
            //options.add(new SelectOption('10 years', '10 years'));
            options.add(new SelectOption('10 years, 8 firm', '10 years, 8 firm'));
            options.add(new SelectOption('15 years, 13 firm', '15 years, 13 firm'));
            options.add(new SelectOption('17 years, 15 firm', '17 years, 15 firm'));
            //options.add(new SelectOption('19 months, 11 firm', '19 months, 11 firm'));
            //options.add(new SelectOption('25 months, 16 firm', '25 months, 16 firm'));
            System.debug('options7: '+options);
             }
         }
         System.debug('options8: '+options);
         //system.debug('*********1'+showModifyRequirement);
         system.debug('*********2'+showLeaseSection);

        return options;
    }
    
    
    public void getPVValuesForRLP() {
        system.debug('#######getPVValuesForRLP');
        List<PBS_AAAP_RLP__c> rlps = new List<PBS_AAAP_RLP__c>();
        if (currentObj.PBS_AAAP_Region__c != null) {
            system.debug('#######getPVValuesForRLP, currentObj region: ' + currentObj.PBS_AAAP_Region__c);
            rlps = [
                    SELECT id, name, PBS_AAAP_RLP_Number__c
                    FROM PBS_AAAP_RLP__c
                    WHERE PBS_AAAP_Region__c = :currentObj.PBS_AAAP_Region__c
                    AND PBS_AAAP_STATUS__c = :PBS_AAAP_GlobalConstants.RLPSTATUS_POSTED_ACTIVE
                    LIMIT 1
            ];
                
        }        
        system.debug('#######getPVValuesForRLP, RLPs retrieved: '+rlps);
        string firstRLP = '';
        if(!rlps.isEmpty()){
            firstRLP = rlps[0].PBS_AAAP_RLP_Number__c;
        }
        
    }


    
    public PageReference getPVValuesFromRLP() {
        return null;
    }    
    

    public List<SelectOption> getDelineatedAreaTypeDescList() {
        logMethodStart('getDelineatedAreaTypeDescList');
        PBS_AAAP_Agency_Requirement__c obj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        PageReference ref = null;
        List<SelectOption> options = new List<SelectOption>();

        List<PBS_AAAP_RLP_Regions_Map__c> statesList = new List<PBS_AAAP_RLP_Regions_Map__c>();
        //Set<PBS_AAAP_AlternateDelineatedArea__c> distinctdelineatedTypeList = new Set<PBS_AAAP_AlternateDelineatedArea__c>();
        List<PBS_AAAP_AlternateDelineatedArea__c> delineatedTypeList = new List<PBS_AAAP_AlternateDelineatedArea__c>();
        List<PBS_AAAP_PolyObject__c> subMarketList = new List<PBS_AAAP_PolyObject__c>();
        List<String> valueList = new List<String>();
        Set<String> valueSet = new Set<String>();
        
        
        /*if(currentObj.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET ){
            showMultiPickList = true;
        }
        else{
            showMultiPickList = false;
        }*/
        
        
        if (obj.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != null && obj.PBS_AAAP_Region__c != null) {

            statesList = [
                    SELECT id, name, PBS_AAAP_RLP_State__c, PBS_AAAP_RLP_State_Abbrevation__c, PBS_AAAP_Region_Name__c
                    FROM PBS_AAAP_RLP_Regions_Map__c
                    WHERE PBS_AAAP_Region_Name__c = :obj.PBS_AAAP_Region__c
            ];
            System.debug('************ statesList::: ' + statesList);

            Set<String> regionStatesList = new Set<String>();
            List<String> delineatedTypeCriteriaList = new List<String>();
            if (statesList.size() > 0) {
                for (PBS_AAAP_RLP_Regions_Map__c s : statesList) {
                    regionStatesList.add(s.PBS_AAAP_RLP_State_Abbrevation__c);
                }
                System.debug('************ regionsStateList::: ' + regionStatesList);
            }

            // Logic to pull records from delineated area for other than "SubMarket".
            if (obj.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET) {
                delineatedTypeList = [
                        SELECT DilneatedAreaType__c, State__c, Value__c
                        FROM PBS_AAAP_AlternateDelineatedArea__c
                        WHERE State__c IN :regionStatesList
                        AND DilneatedAreaType__c = :obj.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c
                        ORDER BY Value__c
                        LIMIT 1000
                ];
                System.debug('************ delineatedTypeList::: ' + delineatedTypeList);

                if (delineatedTypeList.size() > 0) {
                    for (PBS_AAAP_AlternateDelineatedArea__c d : delineatedTypeList) {
                        valueList.add(d.Value__c);
                    }
                    valueList.sort();
                    System.debug('************ valueList::: ' + valueList);
                    for (string s : valueList) {
                        valueSet.add(s);
                    }
                    System.debug('************ valueSet::: ' + valueSet);

                    for (String d : valueSet) {

                        options.add(new SelectOption(d, d));
                    }
                    options.sort();
                }
            } else { // logic to pull records for "SubMarket" from PBS_AAAP_PolyObject__c.

                subMarketList = [
                        SELECT p.Polygon_Type__c, p.Name, p.Id
                        FROM PBS_AAAP_PolyObject__c p
                        WHERE p.Polygon_Type__c = :PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET
                        ORDER BY p.Name
                ];

                System.debug('************ subMarketList::: ' + subMarketList);

                for (PBS_AAAP_PolyObject__c s : subMarketList) {
                    options.add(new SelectOption(s.Name, s.Name));
                }
                options.sort();
            }
        } else {
            options = null;
        }

        return options;
    }

    public PageReference actionEdit() {
        logMethodStart('actionEdit');
        PageReference ref = null;
        editRequirement = false;

        selectedRlpNumber = this.currentObj.PBS_AAAP_RLP_Number__c;

        String msg = '';
        try {
            if (currentObj.PBS_AAAP_REQ_STATUS__c != PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING) {
                msg = 'You cannot modify an Agency Requirement that is not in Pending Status';
                throw new PBS_AAAP_Exception(msg);
            }
            ref = stdController.edit();
        } catch (Exception ex) {
            ApexPages.addMessages(ex);

            ref = null;
        }
        return ref;
    }



  //THIS METHOD WILL SAVE THE PAGE WITH ALL DALL ENTER ALONE WITH ERROR MESSAGES, Henry Dennis.

    public PageReference actionSaveAgencyRequirement() {

        logMethodStart('actionSaveAgencyRequirement');
        Savepoint sp0 = Database.setSavepoint();
        String msg = '';
        PageReference ref = null;
        PBS_AAAP_Agency_Requirement__c obj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();

        system.debug( 'obj.PBS_AAAP_LEASE_TERM__c ' + obj.PBS_AAAP_LEASE_TERM__c );

        List<PBS_AAAP_Agency_Requirement__c> agencyRequirement = [SELECT id, name, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c FROM PBS_AAAP_Agency_Requirement__c WHERE id = :obj.id ];
        
        
        
        
        //system.debug( '1obj.PBS_AAAP_Region__c ' + obj.PBS_AAAP_Region__c + ' obj.PBS_AAAP_RLP_Number__c ' + obj.PBS_AAAP_RLP_Number__c );
        
        
        

        if( ( agencyRequirement.size() > 0 ) && ( obj.PBS_AAAP_Region__c== null ))
            obj.PBS_AAAP_Region__c = agencyRequirement[0].PBS_AAAP_Region__c;

        //if( obj.PBS_AAAP_RLP_Number__c == null )

        if( selectedRlpNumber <> null )
            obj.PBS_AAAP_RLP_Number__c = selectedRlpNumber;
        else
        if( ( agencyRequirement.size() > 0 ) && ( obj.PBS_AAAP_RLP_Number__c == null ))
           obj.PBS_AAAP_RLP_Number__c = agencyRequirement[0].PBS_AAAP_RLP_Number__c;

        system.debug( '2obj.PBS_AAAP_Region__c ' + obj.PBS_AAAP_Region__c + ' obj.PBS_AAAP_RLP_Number__c ' + obj.PBS_AAAP_RLP_Number__c + ' obj.id  ' + obj.id +
         ' PBS_AAAP_Agency_Requirement__c.PBS_AAAP_Region__c ' + obj.PBS_AAAP_Region__c + ' obj.PBS_AAAP_RLP_Number__c  ' + obj.PBS_AAAP_RLP_Number__c +
         ' selectedRlpNumber ' + selectedRlpNumber );


        List<PBS_AAAP_Agency_Requirement__c> lstobj = new List<PBS_AAAP_Agency_Requirement__c>();
        try {

            if (obj.PBS_AAAP_Region__c == null || obj.PBS_AAAP_RLP_Number__c == null) {

                msg = 'Please select Region and RLP';
                throw new PBS_AAAP_Exception(msg);
            }
            System.debug('************ PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c ::: ' + obj.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c);
            System.debug('************ PBS_AAAP_DELINEATED_DESCRIPTION__c ::: ' + obj.PBS_AAAP_DELINEATED_DESCRIPTION__c);
            if (obj.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != null && (obj.PBS_AAAP_DELINEATED_DESCRIPTION__c == '[]')) {
                msg = 'Please select Alternate Delineated Area Descriptor';
                throw new PBS_AAAP_Exception(msg);
            }
            System.debug('************ PBS_AAAP_DELINEATED_DESCRIPTION__c ::: ' + obj.PBS_AAAP_DELINEATED_DESCRIPTION__c);
            if (obj.PBS_AAAP_DELINEATED_DESCRIPTION__c != null && obj.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET) {
                obj.PBS_AAAP_Polygon_Object_Id__c = [SELECT Id, Name FROM PBS_AAAP_PolyObject__c WHERE Name = :obj.PBS_AAAP_DELINEATED_DESCRIPTION__c].Id;
            } else {
                obj.PBS_AAAP_Polygon_Object_Id__c = null;
            }
            obj.PBS_AAAP_Include_HVAC_Overtime__c = true;
            obj.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING;
            
            
            //added by syam on 06/24/2016 if the metro field is disabled then set the value for Non NCR regions.
            
            
            //REGION SELECT PICKLIST THIS WAS UPDATED 0N 7/6/22 BY HENRY DENNIS.
            if (obj.PBS_AAAP_Region__c == 'National Capital Region') {
                if (obj.PBS_AAAP_WALKABLE_2640_FEET_METRO__c == null || obj.PBS_AAAP_WALKABLE_2640_FEET_METRO__c == '') {
                    msg = 'Proximity to Metro within 2640 ft : You must enter a value';
                    throw new PBS_AAAP_Exception(msg);
                }
            }
            
            
           else {
                obj.PBS_AAAP_WALKABLE_2640_FEET_METRO__c = 'No';
            }
            if(obj.PBS_AAAP_Project_ID__c != null)
            {
                lstobj = [SELECT Id FROM PBS_AAAP_Agency_Requirement__c WHERE PBS_AAAP_Project_ID__c = :obj.PBS_AAAP_Project_ID__c AND Id != :obj.Id];
                if(lstobj.size() >0)
                {
                    msg = 'Project Number: You have entered a project number that already exists. Please use a different project number or Cancel this operation and edit the existing project with the number you attempted to use.';
                    throw new PBS_AAAP_Exception(msg);
                }
            }

            system.debug( 'actionSaveAgencyRequirement->editRequirement ' + editRequirement + ' pvDefault_TIUSED_FIRM_TERM_NEW_STR ' + pvDefault_TIUSED_FIRM_TERM_NEW_STR +
                ' pvDefault_TIUSED_FOR_FIRM_TERM_SUCC ' + pvDefault_TIUSED_FOR_FIRM_TERM_SUCC);

            //if( !editRequirement )
            if( ( pvDefault_TIUSED_FIRM_TERM_NEW_STR <> null ) || ( pvDefault_TIUSED_FOR_FIRM_TERM_SUCC <> null ) || ( pvDefault_PBS_AAAP_MOVE_DEFAULT <> null ) 
                || ( pvDefault_BSAC_per_ABOA <> null ) || ( pvDefault_BSAC_for_Continuing_Space_per_ABOA_SF <> null ) || ( pvDefault_PBS_AAAP_TELCOMM_DEFAULT <> null )
                || ( pvDefault_PBS_AAAP_PV_OTHER_UPFRONT_COSTS <> null )  )
            {
                //obj.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = pvDefault_TIUSED_FIRM_TERM_NEW;
                obj.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = decimal.valueof(pvDefault_TIUSED_FIRM_TERM_NEW_STR);

                obj.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = decimal.valueof( pvDefault_TIUSED_FOR_FIRM_TERM_SUCC );
                obj.PBS_AAAP_MOVE_DEFAULT__C = decimal.valueof( pvDefault_PBS_AAAP_MOVE_DEFAULT );
                
                obj.PBS_AAAP_BSAC_PER_ABOA__c = decimal.valueof(pvDefault_BSAC_per_ABOA);
                
                obj.BSAC_for_Continuing_Space_per_ABOA_SF__c = decimal.valueof( pvDefault_BSAC_for_Continuing_Space_per_ABOA_SF );
                obj.PBS_AAAP_TELCOMM_DEFAULT__c = decimal.valueof( pvDefault_PBS_AAAP_TELCOMM_DEFAULT );
                obj.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = decimal.valueof( pvDefault_PBS_AAAP_PV_OTHER_UPFRONT_COSTS );
            }

            saveAgencyRequirement();
            ref = Page.PBS_AAAP_AgencyRequirement;
            ref.getParameters().put('id', stdController.getId());
            ref.setRedirect(true);

        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            Database.rollback(sp0);
            ref = null;
        }
        return ref;
    }
    
    //THIS WILL END THE PAGE SAVE.
    
    
    private String sanitizeRexusProjectId(String value) {
        if (value != null) {
            // Pattern: exactly 7 alphanumeric characters (letters and numbers only)
            Pattern pattern = Pattern.compile('^[a-zA-Z0-9]{7}$');
            Matcher matcher = pattern.matcher(value.trim());
            if (matcher.matches()) {
                return value.trim();
            }
        }
        return null; // return null if invalid
    }

    //Julia Kantarovsky changes 11/2020 start here
    public void getRexusData() {
        System.debug('JK getRexusData');
        canErr = null;//set to null here instead of in closeRexusPopup()
        showCancelError = false;
        //reset responseFlag every time user clicks okay?
        responseFlag = false;
        List<RexusData> rexusDataList = new List<RexusData>();
        RexusData rexData = new RexusData();

        //If not test, set rexusProjectId to user input
        if (!Test.isRunningTest()) {
            Map<String, String> params = System.currentPageReference().getParameters();
            if (params.get('firstParam') != null) {
                rexusProjectId = sanitizeRexusProjectId(params.get('firstParam'));
            }
            //rexusProjectId = Apexpages.currentPage().getParameters().get('firstParam');
        }
        System.debug('jmd rexusProjectId '+rexusProjectId);
        //Error message to end user
        if(rexusProjectId == '' || rexusProjectId == null){
            redErrorOnly = true;
            showCancelError = true;
            errorStyle = 'color: red';
            canErr = 'You must specify a Rexus Project Number.';
        }
        
        //Error message to end user
        else if(rexusProjectId.length() != 7){
            redErrorOnly = true;
            showCancelError = true;
            errorStyle = 'color: red';
            canErr = 'Please enter a valid 7 digit alpha-numeric Rexus Project Number.';
        
        //Valid Project ID. Log starting:
        }else{    
        System.debug('JK Valid Project Id, Log starting');//the green message is not showing until this method completes and the 'oncomplete' in the VFpage JS is called and the window.history line runs.
            /*showCancelError = true;
            errorStyle = 'color: green';
            canErr = 'Rexus data pull in progress, please wait...';*/
            allLogs.add(
                new Log__e(
                    Apex_Class_Name__c = 'PBS_AAAP_AgencyRequirement_Ext.getRexusData()',
                    Username__c = Userinfo.getUserName(),
                    Message__c = 'PBS_AAAP_AgencyRequirement_Ext.getRexusData() starting, rexusProjectId: '+rexusProjectId
                ));          
            String errorEmail = '';
            //set endpoint API attributes
            String apiModel = APIMuleHelper.runningInSandbox() ? 'LOP_API_Dev' : 'LOP_API_Prod';
            apiAttributes = APIMuleHelper.populateAPIAttributes(apiModel);
            HttpResponse response = null;
            endpoint = apiAttributes.baseEndPoint + apiAttributes.vfilters + rexusProjectId.toUpperCase() + '?result=detail'; 
            System.debug('JK PBS_AAAP_AgencyRequirement_Ext.getRexusData(), endPoint: ' + endPoint);
            
            //Callout:
            response = APIMuleHelper.executeAPI('PBS_AAAP_AgencyRequirement_Ext', endpoint, null, apiAttributes.httpHeaders, 'GET', apiAttributes.additionalParams);
            //System.debug('JK RESPONSE ' + response);
            //System.debug('JK PBS_AAAP_AgencyRequirement_Ext.getRexusData(), response body: ' + response.getBody()); 
            if(response != null && response.getStatusCode() == 200){//NEED 201?
                
                //Response is not null and status code is 200:
                //System.debug('JK response is NOT null and status code == 200');
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('JK Rexus deserialized results ' + results);
                
                //if status code is 200 but gets 0 or more than 1 record:
                if ((Integer)results.get('totalSize') != 1){
                    System.debug('JK status code is 200 but gets 0 or more than 1 record ');
                    //Error message to end user
                    showCancelError = true;
                    errorStyle = 'color: red';
                    canErr = 'REXUS does not recognize the project number, or is experiencing technical difficulties.  Try again with a verified project number or manually create the Agency Requirement without importing REXUS data.';
                    //Add Error Log:
                    allLogs.add(
                        new Log__e(
                            Apex_Class_Name__c = 'PBS_AAAP_AgencyRequirement_Ext.getRexusData()',                        
                            Username__c = Userinfo.getUserName(),
                            Message__c = 'PBS_AAAP_AgencyRequirement_Ext.getRexusData() , successful call to Rexus but 0 or more than 1 records returned, response: ' + response,
                            Log_Type__c = 'Exception'
                        ));   
                    if (errorEmail.length() > 0) errorEmail += ', '; 
                    errorEmail += 'Rexus data response: ' + response;    
                    }else{
                        //Response is 200 and exactly 1 record is returned:
                        System.debug('JK Response is 200 and exactly 1 record is returned');
                        //set responseFlag to true:
                        responseFlag = true;
                        List<Object> rexDataRecords = (List<Object>) results.get('records');
                        //System.debug('JK rexDataRecords ' + rexDataRecords);
                        Map<String, Object> rexRecord = null;
                        
                        
                        for (Object r: rexDataRecords) {
                            rexRecord = (Map<String, Object>)r;
                            rexData.abCode = (String)rexRecord.get('AB_CD');//add to rexData RexusData object instantiated at top of method
                            rexData.agencyName = (String)rexRecord.get('AB_NAME');//changed to new name
                            rexData.spaceType = (String)rexRecord.get('SPACE_TYPE_CD');
                            rexData.projectId = (String)rexRecord.get('PROJECT_NUM');
                            rexData.city = (String)rexRecord.get('CITY');
                            rexData.state = (String)rexRecord.get('STATE_CD');
                            rexData.region = String.valueOf((Integer)rexRecord.get('REGION_CD'));
                            
                            
                            //SETTING THE REGION UPDATED BY HENRY DENNIS 7/6/22
                            if(rexData.region != null) {
                                if (rexData.region == '11') {
                                    rexData.region = 'National Capital Region';
                                } 
                                 else {
                                    rexData.region = 'Region ' + rexData.region;
                                }
                            }
                            currentObj.PBS_AAAP_Region__c = rexData.region;
                            getPVValuesForRLP();
                            
                            
                            //if(rexData.region == ''National Capital Region' && rexData.region != null)rexData.region = 'Region ' + rexData.region;
                            rexData.aboaSFMin = (Integer)rexRecord.get('PRJ_REQ_USF');
                            rexData.minimumContiguousABOA = (Integer)rexRecord.get('PRJ_REQ_USF');
                            rexData.leaseTerm = (Integer)rexRecord.get('LEASE_TERM');
                                if(rexData.leaseTerm == 120) rexData.leaseTermStr = '10 years, 8 firm';
                                if(rexData.leaseTerm == 180) rexData.leaseTermStr = '15 years, 13 firm';
                                if(rexData.leaseTerm == 204) rexData.leaseTermStr = '17 years, 15 firm';
                            rexData.surfaceParking = (Integer)rexRecord.get('PRJ_REQ_SU_PRKG');
                            rexData.garageParking = (Integer)rexRecord.get('PRJ_REQ_ST_PRKG');
                            rexData.hvac = (Integer)rexRecord.get('AFTER_HOURS_HVAC_RPH');
                            if(rexData.city != null && rexData.state != null)rexData.nickname = rexData.city + ', ' + rexData.state;
                            List<Account> accNames = [SELECT name, PBS_AAAP_AB_Code__c FROM Account Where PBS_AAAP_AB_Code__c = :rexData.abCode LIMIT 1];
                            if(accNames.size() > 0)rexData.agencyName = accNames[0].Name;
                            }
                            //rexusDataList.add(rexData);
                            System.debug('JK rexData::: ' + rexData);
                            rexusDataStr = JSON.serialize(rexData);
                            System.debug('JK rexusDataString ' + rexusDataStr);
                            if (responseFlag == true) closeRexusPopup();
                    }
         }else{
            //response is null OR response !== 200:
            //System.debug('JK The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            //ERROR HANDLING HERE IF != 200. OR IF THE PROJECT IS NOT FOUND,FROM REXUS IN JSON, ASK MADHU WHAT THIS WILL LOOK like 
            //showWaitingMessage = false;
            showCancelError = true;
            errorStyle = 'color: red';
            canErr = 'REXUS does not recognize the project number, or is experiencing technical difficulties.  Try again with a verified project number or manually create the Agency Requirement without importing REXUS data.';
            //add to log:
            allLogs.add(
                new Log__e(
                    Apex_Class_Name__c = 'PBS_AAAP_AgencyRequirement_Ext.getRexusData()',                        
                    Username__c = Userinfo.getUserName(),
                    Message__c = 'PBS_AAAP_AgencyRequirement_Ext.getRexusData() ,  Rexus response is null or status code was not 200, response: ' + response,
                    Log_Type__c = 'Exception'
                ));   
            if (errorEmail.length() > 0) errorEmail += ', '; 
            errorEmail += 'Rexus data response: ' + response;    
         }
         //Log ending message
                System.debug('PBS_AAAP_AgencyRequirement_Ext.getRexusData() ending, rexusProjectId: ' + rexusProjectId + ' data retrieved from rexus: ' + rexusDataStr);
                allLogs.add(
                    new Log__e(
                        Apex_Class_Name__c = 'RET_LeaseDetailsController.getLeaseDetails()',
                        Username__c = Userinfo.getUserName(),
                        Message__c = 'PBS_AAAP_AgencyRequirement_Ext.getRexusData() ending, rexusProjectId: ' + rexusProjectId + ' Data retrieved from REXUS: ' + rexusDataStr
                    ));
                System.debug('JK Platform Event allLogs ' + allLogs);            
                LogEventsPublishHandler.publishLogEvents(allLogs);
                
                if (errorEmail.length() > 0)
                    APIMuleHelper.sendIntegrationErrorEmail(apiAttributes, 'User ' + UserInfo.getName() + '(username: ' + UserInfo.getUserName() + '), responses: ' + errorEmail);
            }
        System.debug('JK showCancelError at end of method ' + showCancelError);
         
         
    }
    
    //Rexus Data Wrapper Class    
    public class RexusData{
        public Integer aboaSFMin {get; set;}
        public Integer minimumContiguousABOA {get; set;}
        public Integer leaseTerm {get; set;}
        public Integer surfaceParking {get; set;}
        public Integer garageParking {get; set;}
        public Integer hvac {get; set;}
        public String leaseTermStr {get; set;}
        public String abCode {get; set;}
        public String agencyName {get; set;}
        public String spaceType {get; set;}
        public String projectId {get; set;}
        public String nickname {get; set;}
        public String region {get; set;}
        public String city {get; set;}
        public String state {get; set;}
        
        public RexusData(){  
        }
    }
    //JK changes to here


    public PageReference actionCancelAgencyRequirement() {
        logMethodStart('actionCancelAgencyRequirement');
        if(cancellationReason == NULL || cancellationReason == ''){
            showCancelError = true;
            //Julia Kantarovsky changes 11/2020 start here
            errorStyle = 'color: red';
            //JK changes end 
            canErr = 'You must specify a cancellation reason.';
            return null;
        }
        Savepoint sp0 = Database.setSavepoint();
        PageReference ref = null;
        PBS_AAAP_Agency_Requirement__c obj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        system.debug('*******VVV'+obj);
        Datetime createdDate = [SELECT CreatedDate FROM PBS_AAAP_Agency_Requirement__c WHERE Id = :obj.Id LIMIT 1].CreatedDate;
        system.debug('*******VVV'+createdDate);
        try {
            if (obj.PBS_AAAP_REQ_STATUS__c == PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING) {
                obj.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_CANCELED;
                saveAgencyRequirement();
                PBS_AAAP_AR_Cancellation_Info__c arCancel = new PBS_AAAP_AR_Cancellation_Info__c();
                arCancel.Agency_Requirement__c = obj.Id;
                arCancel.PBS_AAAP_Agency_Requirement_Created_Date__c = date.newinstance(createdDate.year(), createdDate.month(), createdDate.day());
                arCancel.PBS_AAAP_Cancellation_Reason__c = cancellationReason;
                arCancel.PBS_AAAP_Cancelled_Date__c = date.newinstance(System.now().year(), System.now().month(), System.now().day());
                arCancel.PBS_AAAP_Executed_By__c = UserInfo.getUserId();
                insert arCancel;
                ref = Page.PBS_AAAP_AgencyRequirement;
                ref.getParameters().put('id', stdController.getId());
                ref.setRedirect(true);
            } else {
                String msg = '';
                msg = 'You cannot Cancel an Agency Requirement that is not in Pending Status';
                 //Julia Kantarovsky changes 11/2020 start here
                errorStyle = 'color: red';
                //JK changes end 
                canErr = 'You cannot Cancel an Agency Requirement that is not in Pending Status';
                throw new PBS_AAAP_Exception(msg);
            }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            Database.rollback(sp0);
            ref = null;
        }
        return ref;
    }

    public PageReference actionReActivateAgencyRequirement() {
        logMethodStart('actionReActivateAgencyRequirement');
        if(reactivationReason == NULL || reactivationReason == ''){
            showReactivationError = true;
            reactErr = 'You must specify a re-activation reason.';
            return null;
        }
        Savepoint sp0 = Database.setSavepoint();
        PageReference ref = null;
        PBS_AAAP_Agency_Requirement__c obj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        Datetime createdDate = [SELECT CreatedDate FROM PBS_AAAP_Agency_Requirement__c WHERE Id = :obj.Id LIMIT 1].CreatedDate;
        try {
            if (obj.PBS_AAAP_REQ_STATUS__c == PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_CANCELED) {
                obj.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDING;
                saveAgencyRequirement();
                PBS_AAAP_AR_Cancellation_Info__c arCancel = new PBS_AAAP_AR_Cancellation_Info__c();
                arCancel.Agency_Requirement__c = obj.Id;
                arCancel.PBS_AAAP_Agency_Requirement_Created_Date__c = date.newinstance(createdDate.year(), createdDate.month(), createdDate.day());
                arCancel.PBS_AAAP_Cancellation_Reason__c = reactivationReason;
                arCancel.PBS_AAAP_Re_Activated_Date__c = date.newinstance(System.now().year(), System.now().month(), System.now().day());
                arCancel.PBS_AAAP_Executed_By__c = UserInfo.getUserId();
                insert arCancel;
                ref = Page.PBS_AAAP_AgencyRequirement;
                ref.getParameters().put('id', stdController.getId());
                ref.setRedirect(true);
            } else {
                String msg = '';
                msg = 'You cannot Re-Activate an Agency Requirement that is not in Cancelled Status';
                reactErr = 'You cannot Re-Activate an Agency Requirement that is not in Cancelled Status';
                //throw new PBS_AAAP_Exception(msg);
                return null;
            }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            Database.rollback(sp0);
            ref = null;
        }

        return ref;
    }

    private PageReference saveAgencyRequirement() {
        logMethodStart('saveAgencyRequirement');
        return stdController.save();
    }

    public PageReference showExistingLeaseInformation() {
        logMethodStart('showExistingLeaseInformation');
        system.debug( 'showExistingLeaseInformation' );

        PBS_AAAP_Agency_Requirement__c obj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        if (obj.PBS_AAAP_TYPE_OF_REQUIREMENT__c == 'Continuing') {
            showLeaseSection = true;
            obj.isNewRequirement__c = true;
        } else {
            showLeaseSection = false;
            obj.isNewRequirement__c = false;
        }

        return null;
    }

    public PageReference actionCancel() {
        logMethodStart('actionCancel');

        // on a new record where they cancel, throw them back to
        // the Agency Requirement
        Id objId;
        PageReference ref;
        System.debug(' url is - ' + ApexPages.currentPage().getUrl());
        System.debug(' ret url is - ' + ApexPages.currentPage().getParameters().get('retURL'));
        ref = stdController.cancel();
        System.debug(' ref is - ' + ref);

        return ref;
    }

    public PageReference actionIdentifyWinner() {
        logMethodStart('actionIdentifyWinner');

        PageReference pref = null;
        PBS_AAAP_Agency_Requirement__c obj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        List<PBS_AAAP_PolyObject__c> polyShapeList = null;


        polyShapeList = [
                SELECT p.Polygon_Type__c, p.PBS_AAAP_legacy_id__c, p.PBS_AAAP_Shape_Type__c, p.PBS_AAAP_Circle_Radius__c,
                        p.PBS_AAAP_Agency_Requirement__c, p.Name, p.Id
                FROM PBS_AAAP_PolyObject__c p
                WHERE p.PBS_AAAP_Agency_Requirement__c = :obj.Id
        ];
        List<PBS_AAAP_Offer_Select_Award_Info__c> osais = [
                SELECT id, PBS_AAAP_AGENCY_REQUIREMENT_ID__c
                FROM PBS_AAAP_Offer_Select_Award_Info__c
                WHERE PBS_AAAP_AGENCY_REQUIREMENT_ID__c = :obj.Id
                AND PBS_AAAP_isSelected__c = TRUE
        ];
        system.debug('*******=========>>>>>>>>>>  polyShapeList  ::: ' + polyShapeList.size());
        system.debug('*******=========>>>>>>>>>>  polyShapeList  ::: ' + obj.PBS_AAAP_DELINEATED_AREA_TYPE__c);
        if (polyShapeList.size() <= 0 && obj.PBS_AAAP_DELINEATED_AREA_TYPE__c == PBS_AAAP_GlobalConstants.DEL_AREA_TYPE) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'There is no User Delineated Area created for this agency requirement.'));

        } else if (osais.size() > 0) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.IDENTIFY_WINNER_ERROR));

        } else {
            pref = Page.PBS_AAAP_IdentifyWinnerSearch;
            pref.getParameters().put('agencyId', obj.Id);
            pref.setRedirect(true);

        }
        return pref;
    }

    public void closePopup() {
        displayPopup = false;
    }
    
    public void showPopup() {
        displayPopup = true;
    }

    public void closePopup2() {
        displayPopup2 = false;
        reactErr = null;
    }
    
    public void showPopup2() {
        displayPopup2 = true;
    }
    
    //Julia Kantarovsky changes 11/2020 start
    public void closeRexusPopup() { 
         System.debug('JK closeRexusPopup start');
         displayRexusPopup = false;//causes the popup to be rerendered on the front end, and therefore the message changes.
         canErr = null;//this removes the message, and if it runs before the response comes back, there is no message.
         System.debug('JK closeRexusPopup end');
    } 
    
    public void showRexusPopup() { 
         System.debug('JK showRexusPopup');
         displayRexusPopup = true;    
    }
    //JK changes end

}