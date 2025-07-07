global with sharing class PBS_AAAP_IdentifyWinnerController extends PBS_AAAP_PageBaseController {

    public string spaceIdsSet1 {get;set;}
    public string spaceIdsSet2 {get;set;}

    public string lstOffer {get;set;}
    public string folderId {get;set;}
    transient public string strImageBlob1 {get;set;}
    transient public string strImagename {get;set;}
    public Boolean isParkingRequirement {get;set;}
    public Boolean disableParkingOption {get; set;}
    public List<string> lstDocIds {get;set;}

    public PBS_AAAP_ImageCntrl imageObj {get;set;}
    public List<Building_Notes__c> lstBuilding {get; set;}
    public Set<Id> setBuildingProbIds {get; set;}

    // class to represent the form
    public class SubForm {
        public String offerId { get; set; }
        public String spaceId { get; set; }
        public String markerTitle { get; set; }
        public Double Lat { get; set; }
        public Double Lng { get; set; }
        public Boolean inBounds { get; set; }
        public String street {get;set;}
        public String city {get;set;}
        public string spaceName {get;set;}
        public String buildingName {get;set;}
        public Double pvCosts {get; set;}
        public Boolean isEnergyStar {get;set;}
        public Boolean isMetro {get;set;}
        public Boolean isHistoricProperty {get;set;}
        public Boolean isHUBZONEArea {get;set;}
        public Boolean isSelected {get;set;}
        public Boolean isAwarded {get;set;}
        public Boolean isBuildingProblem {get;set;}


        public SubForm() {
            inBounds = false;
        }   // end constructor

    }   // end SubForm

    // class to convert subform data into usable JSON
    public class FormObject {
        List<SubForm> formData = new List<SubForm>();

        public FormObject() {
        }   // end Constructor
    }   // end FormObj

    //    public List<SubForm> formData { get; set; }
    public FormObject formObj { get; set; }
    public String shape { get; set; }
    public String props { get; set; }
    public String propMods { get; set; }

    // rlp fields
    public double newLease { get; set; }
    public boolean newLeaseArchAndEng { get; set; }
    public double succeedingLease { get; set; }
    public boolean succLeaseArchAndEng { get; set; }
    public double physicalMoveCost { get; set; }
    public double telecommunicationsCost { get; set; }
    public double upfrontCostsPV { get; set; }
    public double BSACperABOA { get; set; } //vaishali
    public double bsacForContinuingSpace {get;set;}


    // agency requirement fields
    public string leaseTerm { get; set; }
    public List<String> leaseTermforRates {get;set;}
    public List<String> leaseTermforRatesContinuing {get;set;}
    public double asniboma_min { get; set; }
    public double asniboma_max { get; set; }
    public double Min_Contiguous_ABOASF { get; set; }
    public string delineatedAreaType { get; set; }
    public string altDelineatedArea { get; set; }
    public string altDelineatedAreaDesc { get; set; }
    public double numofparkingspaces { get; set; }
    public string metroproximity { get; set; }
    public boolean daytimeCleaning { get; set; }
    public double HVACOvertimeHours { get; set; }
    public boolean IncludeHVAC { get; set; }

    public PBS_AAAP_Agency_Requirement__c agencyRecord { get; set; }
    static public PBS_AAAP_Agency_Requirement__c agencyRecord2 { get; set; }
    public PBS_AAAP_Agency_Requirement__c modifyagencyRecord { get; set; }
    public PBS_AAAP_RLP__c rlpRecord { get; set; }

    public string strImageBlob {get;set;}


    public class IwfContainer
    {
        public string msg {get;set;}
        public List<PBS_AAAP_IdentifyWinnerForm> winners {get;set;}
        public IwfContainer(List<PBS_AAAP_IdentifyWinnerForm> f, string m){
            winners = f;
            msg = m;
        }
        public string ToJSON(){
            return JSON.serialize(this);
        }
    }

    public List<PBS_AAAP_IdentifyWinnerForm> identifyWinnerForm { get; set; }

    public string identifyWinnerFormJson {
        get {
            if (identifyWinnerForm==null){
                return null;
            }
            return new IwfContainer(identifyWinnerForm, 'autoprop').ToJSON();
        }
    }

    public string action { get; set; }
    public string agencyId { get; set; }
    //static public string agencyId2 { get; set; }

    public double parkingSpacesOnAgency { get; set; }

    public boolean showTable { get; set; }
    public boolean showSelectButton { get; set; }
    public boolean showSaveIdButton { get; set; }
    public String selectedHistorical {get;set;}
    public String selectedHistorical2 {get;set;}
    public boolean showHistOptions {get; set;}

    public string selectedSpaceId { get; set; }
    public string selectedOfferId { get; set; }
    public string selectedPV { get; set; }
    public Boolean rlpAfter2016 { get; set; }

    public PBS_AAAP_IdentifyWinnerController() {
        logConstructorStart('PBS_AAAP_IdentifyWinnerController');

        //formData = new List<SubForm>();
        formObj = new FormObject();
        props = 'false';
        propMods = 'false';
        selectedSpaceId = 'hello';
        isParkingRequirement = false;
        disableParkingOption = FALSE;
        identifyWinnerForm = new List<PBS_AAAP_IdentifyWinnerForm>();
        agencyId = ApexPages.currentPage().getParameters().get('agencyId');
        String historicalRecId = ApexPages.currentPage().getParameters().get('histId');
        agencyRecord = new PBS_AAAP_Agency_Requirement__c();
        if (agencyId != null) {
            parkingSpacesOnAgency = 0;
            agencyRecord = [
                    SELECT a.Id, a.Name, a.PBS_AAAP_WALKABLE_2640_FEET_METRO__c, a.PBS_AAAP_USF_REQ_MIN__c, a.PBS_AAAP_USF_REQ_MAX__c,
                            a.PBS_AAAP_Region__c, a.PBS_AAAP_RLP_Number__c, a.PBS_AAAP_OFFICIAL_NUM_PARKING_SPACES__c, a.PBS_AAAP_TYPE_OF_REQUIREMENT__c,
                            a.PBS_AAAP_MIN_CONT_USF__c, a.PBS_AAAP_LEASE_TERM__c, a.PBS_AAAP_HVAC_OVERTIME_HOURS__c, PBS_AAAP_Include_HVAC_Overtime__c,
                            a.PBS_AAAP_DELINEATED_DESCRIPTION__c, a.PBS_AAAP_DELINEATED_AREA_TYPE__c, a.PBS_AAAP_Polygon_Object_Id__c, a.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c,
                            a.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c, a.PBS_AAAP_DAY_TIME_CLEANING_REQ__c, a.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c,
                            a.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c, a.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c, a.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c,PBS_AAAP_Project_ID__c,
                            a.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c, a.PBS_AAAP_BSAC_per_ABOA__c, a.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c, a.BSAC_for_Continuing_Space_per_ABOA_SF__c,
                            a.PBS_AAAP_MOVE_DEFAULT__c, a.PBS_AAAP_TELCOMM_DEFAULT__c, a.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, a.Is_Historical__c, a.Cloned_Date__c, a.Master_Agency_Requirement__c
                    FROM PBS_AAAP_Agency_Requirement__c a
                    WHERE a.Id = :agencyId
                    LIMIT 1
            ];

            selectedHistorical = string.valueOf(historicalRecId);
            selectedHistorical2 = string.valueOf(historicalRecId);


            // Changes made by sguni on 10/29/2012 to show the correct value in picklist.
            if (agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != 'SubMarket' && agencyRecord.PBS_AAAP_DELINEATED_DESCRIPTION__c != null) {
                agencyRecord.PBS_AAAP_DELINEATED_DESCRIPTION__c = (agencyRecord.PBS_AAAP_DELINEATED_DESCRIPTION__c).toUpperCase();
            }
            // change ends

            parkingSpacesOnAgency = agencyRecord.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c + agencyRecord.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c +
                    agencyRecord.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c + agencyRecord.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c;

            if (agencyRecord.PBS_AAAP_RLP_Number__c != null) {
                //Vaishali RLP FY15 Add BSACperABOA to selection
                //Vaishali RLP FY17 add PBS_AAAP_Year__c to selection
                rlpRecord = [
                        SELECT r.Id, r.Name, r.PBS_AAAP_RLP_Number__c, r.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c,r.BSAC_for_Continuing_Space_per_ABOA_SF__c, r.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c,
                                r.PBS_AAAP_MOVE_DEFAULT__c, r.PBS_AAAP_TELCOMM_DEFAULT__c, r.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c, r.PBS_AAAP_MAX_TIUSED__c,
                                r.PBS_AAAP_DISCOUNT_RATE__c, r.PBS_AAAP_ESCALATION_RATE_PERCENT__c, r.PBS_AAAP_BSAC_per_ABOA__c, r.PBS_AAAP_Region__c,PBS_AAAP_Year__c
                        FROM PBS_AAAP_RLP__c r
                        WHERE r.PBS_AAAP_RLP_Number__c = :agencyRecord.PBS_AAAP_RLP_Number__c
                        LIMIT 1
                ];
                newLeaseArchAndEng = true; // always A&E is default to true for new space
                succLeaseArchAndEng = true; //Made change as part of the RITM0439963 // always A&E is default to false for new space Vaishali 09/16
                System.debug('rlpRecord is ***' + rlpRecord + ' agencyRecord is ***' + agencyRecord);
                rlpAfter2016 = (Integer.valueOf(rlpRecord.PBS_AAAP_Year__c) > 2016) ? true : false;
            }
            system.debug('<<<<<<NIK1>>>>>'+agencyRecord2);
            showHistOptions = FALSE;
            if(agencyRecord.Is_Historical__c == FALSE){
                showHistOptions = TRUE;
            }
        }

        // Section of code obtains the necessary poly object data for the agency requirement
        // First determine if the agency requirement contains a user delineated area
        System.debug('****** agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c: ' + agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c);
        System.debug('****** agencyRecord: ' + agencyRecord);
        try {
            if (agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c == PBS_AAAP_GlobalConstants.DEL_AREA_TYPE ||
                    (agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c == PBS_AAAP_GlobalConstants.ALT_DEL_AREA_TYPE && agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET)) {
                PBS_AAAP_PolyObject__c polyShape = null;
                List<PBS_AAAP_AgencyRequirementShape.PolygonPath> pPaths = new List<PBS_AAAP_AgencyRequirementShape.PolygonPath>();
                // obtain the shape data for the agency requirement
                if (agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c == PBS_AAAP_GlobalConstants.DEL_AREA_TYPE) {
                    //added by syam to get the latest updated single record
                    polyShape = [SELECT p.Polygon_Type__c, p.PBS_AAAP_legacy_id__c, p.PBS_AAAP_Shape_Type__c, p.PBS_AAAP_Circle_Radius__c, p.PBS_AAAP_Agency_Requirement__c, p.Name, p.Id FROM PBS_AAAP_PolyObject__c p WHERE p.PBS_AAAP_Agency_Requirement__c = :agencyId AND p.Polygon_Type__c = 'User Defined' ORDER BY lastmodifieddate DESC LIMIT 1];
                    //polyShape   =   [Select p.Polygon_Type__c, p.PBS_AAAP_legacy_id__c, p.PBS_AAAP_Shape_Type__c, p.PBS_AAAP_Circle_Radius__c, p.PBS_AAAP_Agency_Requirement__c, p.Name, p.Id From PBS_AAAP_PolyObject__c p Where p.PBS_AAAP_Agency_Requirement__c = :agencyId and p.Polygon_Type__c = 'User Defined'];
                    System.debug('****** polyShape: ' + polyShape);
                } else {
                    //added by syam to get the latest updated single record
                    polyShape = [SELECT p.Polygon_Type__c, p.PBS_AAAP_legacy_id__c, p.PBS_AAAP_Shape_Type__c, p.PBS_AAAP_Circle_Radius__c, p.PBS_AAAP_Agency_Requirement__c, p.Name, p.Id FROM PBS_AAAP_PolyObject__c p WHERE p.Id = :agencyRecord.PBS_AAAP_Polygon_Object_Id__c AND p.Polygon_Type__c = 'SubMarket' ORDER BY lastmodifieddate DESC LIMIT 1];
                    //polyShape   =   [Select p.Polygon_Type__c, p.PBS_AAAP_legacy_id__c, p.PBS_AAAP_Shape_Type__c, p.PBS_AAAP_Circle_Radius__c, p.PBS_AAAP_Agency_Requirement__c, p.Name, p.Id From PBS_AAAP_PolyObject__c p Where p.Id = :agencyRecord.PBS_AAAP_Polygon_Object_Id__c and p.Polygon_Type__c = 'SubMarket'];
                    System.debug('****** polyShape: ' + polyShape);
                }
                // there is a shape to use
                if (polyShape.Id != null) {
                    //Vaishali added order by to correct submarket drawings. 06/10/2016
                    List<PBS_AAAP_PolyPath__c> polyPaths = [SELECT p.ID, p.Poly_Object__c, p.longitude__c, p.latitude__c, p.Path_Index__c FROM PBS_AAAP_PolyPath__c p WHERE p.Poly_Object__c = :polyShape.Id ORDER BY p.Path_Index__c];
                    // create the paths
                    for (PBS_AAAP_PolyPath__c path : polyPaths) {
                        PBS_AAAP_AgencyRequirementShape.PolygonPath pPath = new PBS_AAAP_AgencyRequirementShape.PolygonPath(path.Path_Index__c, path.latitude__c, path.longitude__c);
                        pPaths.add(pPath);
                    }   // end for
                    System.debug('****** pPaths: ' + pPaths);


                    // get the shape details and generate the JSON that describes the shape data for the page's use
                    if (polyShape.PBS_AAAP_Shape_Type__c == 'circle') {
                        PBS_AAAP_AgencyRequirementShape.Circle circleToJSON = new PBS_AAAP_AgencyRequirementShape.Circle(polyshape.PBS_AAAP_Circle_Radius__c, pPaths.get(0));
                        // generate the JSON
                        JSONGenerator jsonGen = JSON.createGenerator(true);
                        jsonGen.writeStartObject();
                        jsonGen.writeFieldName(polyShape.PBS_AAAP_Shape_Type__c.toLowerCase());
                        jsonGen.writeObject(circleToJSON);
                        jsonGen.writeEndObject();

                        shape = jsonGen.getAsString();
                        System.debug('****** shape: ' + shape);

                    } else {
                        // create the polygon
                        PBS_AAAP_AgencyRequirementShape.Polygon poly = new PBS_AAAP_AgencyRequirementShape.Polygon(pPaths);

                        // generate the JSON
                        JSONGenerator jsonGen = JSON.createGenerator(true);
                        jsonGen.writeStartObject();
                        jsonGen.writeFieldName(polyShape.PBS_AAAP_Shape_Type__c.toLowerCase());
                        jsonGen.writeObject(poly);
                        jsonGen.writeEndObject();

                        shape = jsonGen.getAsString();
                        System.debug('****** shape: ' + shape);
                    }   // end if
                }
                /*
                        else {    // no shape to use: You will never get here
                            //TODO ::: need to create error message informing user that there isn't a shape defined for the agency requirement with type "user delineated area".
                            ApexPages.Message   msg =   new ApexPages.Message(ApexPages.Severity.FATAL, ' There is no user delineated shape defined for this agency requirement.');
                            ApexPages.addMessage(msg);
                            shape = 'false';
                        }   // end if
                */
            }


            else {   // not a user delineated area
                shape = 'false';
            }   // end if
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }   // end try/catch
        system.debug('*****'+identifyWinnerForm);
        logConstructorEnd('PBS_AAAP_IdentifyWinnerController');

        String isPrintPage = ApexPages.currentPage().getParameters().get('isImagePrintPage');
        if(isPrintPage == 'yes'){
            imageObj = new PBS_AAAP_ImageCntrl();
            imageObj.fetchDocument();
            lstDocIds = imageObj.lstDocIds;
        }

        lstBuilding = [SELECT Id, BuildingNotes__c FROM Building_Notes__c WHERE BuildingNotes__c != NULL and Closed_Removes_Flag_from_ID_Winner_Sea__c = false];
        setBuildingProbIds = new Set<Id>();
        for(Building_Notes__c building : lstBuilding){
            setBuildingProbIds.add(building.BuildingNotes__c);
        }
    }

    public void deleteImages(){
        imageObj.deleteImage();
    }

    public pageReference redirectHist(){
        system.debug('%%%NIk%%%'+selectedHistorical);
        PageReference hist = new PageReference('/apex/pbs_aaap_identifywinnersearch?agencyId='+agencyRecord.Id+'&histId='+selectedHistorical);
        hist.setRedirect(true);
        return hist;
    }

    public pageReference redirectHist2(){
        system.debug('%%%NIk%%%'+selectedHistorical2);
        PageReference hist = new PageReference('/apex/pbs_aaap_identifywinnersearch?agencyId='+agencyRecord.Id+'&histId='+selectedHistorical2);
        hist.setRedirect(true);
        return hist;
    }

    public List<SelectOption> getHistoricalOptions() {
        List<SelectOption> historicalOptions = new List<SelectOption>();
        List<PBS_AAAP_Offer_History__c> histList = new List<PBS_AAAP_Offer_History__c>();
        historicalOptions.add(new SelectOption('Master', 'Master'));
        histList = [
                SELECT
                        Id,
                        Name,
                        PBS_AAAP_Agency_Requirement__c,
                        PBS_AAAP_Cloned_Date_Time__c,
                        PBS_AAAP_Offer_Ids__c
                FROM PBS_AAAP_Offer_History__c
                WHERE PBS_AAAP_Agency_Requirement__c = :agencyRecord.Id
                ORDER BY PBS_AAAP_Cloned_Date_Time__c ASC
        ];

        for(PBS_AAAP_Offer_History__c hist : histList){
            historicalOptions.add(new SelectOption(hist.Id, hist.PBS_AAAP_Cloned_Date_Time__c));
        }

        return historicalOptions;
    }

    public PageReference actionReset() {
        logMethodStart('actionReset');
        PageReference pref = Page.PBS_AAAP_IdentifyWinnerSearch;
        pref.getParameters().put('agencyId', agencyId);
        pref.setRedirect(true);
        logMethodEnd('actionReset', pref);
        return pref;
    }

    public boolean modifyAgencyCriteria() {
        logMethodStart('modifyAgencyCriteria');
        boolean flag;
        modifyagencyRecord = [
                SELECT a.Id, a.Name, a.PBS_AAAP_WALKABLE_2640_FEET_METRO__c, a.PBS_AAAP_USF_REQ_MIN__c, a.PBS_AAAP_USF_REQ_MAX__c,
                        a.PBS_AAAP_Region__c, a.PBS_AAAP_RLP_Number__c, a.PBS_AAAP_OFFICIAL_NUM_PARKING_SPACES__c,
                        a.PBS_AAAP_MIN_CONT_USF__c, a.PBS_AAAP_LEASE_TERM__c, a.PBS_AAAP_HVAC_OVERTIME_HOURS__c, PBS_AAAP_Include_HVAC_Overtime__c,
                        a.PBS_AAAP_DELINEATED_DESCRIPTION__c, a.PBS_AAAP_DELINEATED_AREA_TYPE__c,
                        a.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c, a.PBS_AAAP_DAY_TIME_CLEANING_REQ__c
                FROM PBS_AAAP_Agency_Requirement__c a
                WHERE a.Id = :agencyId
                LIMIT 1
        ];
        if (modifyagencyRecord.PBS_AAAP_LEASE_TERM__c != agencyRecord.PBS_AAAP_LEASE_TERM__c ||
                modifyagencyRecord.PBS_AAAP_USF_REQ_MIN__c != agencyRecord.PBS_AAAP_USF_REQ_MIN__c ||
                modifyagencyRecord.PBS_AAAP_USF_REQ_MAX__c != agencyRecord.PBS_AAAP_USF_REQ_MAX__c ||
                modifyagencyRecord.PBS_AAAP_MIN_CONT_USF__c != agencyRecord.PBS_AAAP_MIN_CONT_USF__c ||
                modifyagencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c != agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c ||
                modifyagencyRecord.PBS_AAAP_DELINEATED_DESCRIPTION__c != agencyRecord.PBS_AAAP_DELINEATED_DESCRIPTION__c ||
                modifyagencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c ||
                //modifyagencyRecord.PBS_AAAP_OFFICIAL_NUM_PARKING_SPACES__c != agencyRecord.PBS_AAAP_OFFICIAL_NUM_PARKING_SPACES__c ||
                modifyagencyRecord.PBS_AAAP_WALKABLE_2640_FEET_METRO__c != agencyRecord.PBS_AAAP_WALKABLE_2640_FEET_METRO__c ||
                modifyagencyRecord.PBS_AAAP_DAY_TIME_CLEANING_REQ__c != agencyRecord.PBS_AAAP_DAY_TIME_CLEANING_REQ__c ||
                modifyagencyRecord.PBS_AAAP_HVAC_OVERTIME_HOURS__c != agencyRecord.PBS_AAAP_HVAC_OVERTIME_HOURS__c ||
                modifyagencyRecord.PBS_AAAP_Include_HVAC_Overtime__c != agencyRecord.PBS_AAAP_Include_HVAC_Overtime__c
                ) {
            flag = false;
        } else {
            flag = true;
        }
        logMethodEnd('modifyAgencyCriteria', flag);
        return flag;
    }

    public PageReference backtoAgencyReq() {
        logMethodStart('backtoAgencyReq');
        PageReference pagRef = new PageReference('/apex/PBS_AAAP_AgencyRequirement');
        pagRef.setRedirect(true);
        pagRef.getParameters().put('Id', agencyId);
        logMethodEnd('backtoAgencyReq', pagRef);
        return pagRef;
    }

    public PageReference actionSearch() {
        logMethodStart('actionSearch');
        showSelectButton = modifyAgencyCriteria();
        disableParkingOption = TRUE;
        identifyWinnerForm = new List<PBS_AAAP_IdentifyWinnerForm>();
        setSearchFormFields();

        List<PBS_AAAP_Space__c> continuingSpaceList;

        System.debug('*******rlpRecord ::::::::::::::::::   ' + rlpRecord.Id);
        System.debug('*******rlpRecord Name::::::::::::::::::   ' + rlpRecord.PBS_AAAP_RLP_Number__c);

        String rlpId = rlpRecord.Id;
        if (rlpId.length() > 15) {
            rlpId = rlpId.substring(0, 15);
        }


        System.debug('*******rlpRecord ::::::::::::::::::   ' + rlpId);
        System.debug('*******metroproximity ::::::::::::::::::   ' + metroproximity);
        System.debug('*******numofparkingspaces ::::::::::::::::::   ' + numofparkingspaces);
        System.debug('Lease terms :' + leaseTermforRates);
        //Update start by Snehith 04/05/2018 - to add Offer Name (s.PBS_AAAP_OFFER_NUMBER__r.Name) in the query
        List<PBS_AAAP_Space__c> spaceList;
        if(selectedHistorical == 'Master') {
            String qString = 'select s.Id, s.Name, s.PBS_AAAP_SF_OFFERED__c, s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, s.PBS_AAAP_City__c, s.PBS_AAAP_State__c, s.PBS_AAAP_Type_of_Space__c,' +
                    's.PBS_AAAP_County__c, s.PBS_AAAP_Congressional_District__c, s.PBS_AAAP_ZipCode__c, s.PBS_AAAP_MANAGEMENT_COORD_FEES__c, s.PBS_AAAP_Offer_Status__c, ' +
                    's.PBS_AAAP_RLP__c, s.PBS_AAAP_Building_Name__c, s.PBS_AAAP_Proximity_to_Metro__c, s.PBS_AAAP_Total_Parking_Spaces__c, s.PBS_AAAP_Street_Address__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c,' +
                    's.PBS_AAAP_X_lat__c, s.PBS_AAAP_Y_lng__c, s.PBS_AAAP_OFFER_NUMBER__c, s.PBS_AAAP_TOTAL_MARKUP__c, s.PBS_AAAP_ARCH_ENG_FEES__c, s.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,' +
                    's.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, s.PBS_AAAP_GC_CONDITIONS__c, s.PBS_AAAP_OFFER_NUMBER__r.Name, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_COST_PER_ABOA__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c,' +
                    's.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Number_of_gar_parking_spaces__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_gar_park__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_sur_park__c,' +
                    's.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_gar_park__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_sur_park__c, PBS_AAAP_MetroWalkableGoogle__c,' +
                    's.PBS_AAAP_Formula_Energy_Star__c, s.PBS_AAAP_Formula_Hist_Property__c, s.PBS_AAAP_Formula_HUB_ZONE__c, s.PBS_AAAP_Formula_Metro__c, PBS_AAAP_BuildingProblem__c, ' +
                    's.PBS_AAAP_NonSur_Reserved_Park__c, s.PBS_AAAP_NonRes_Gar_Park__c, s.PBS_AAAP_Surface_Res_Park__c, s.PBS_AAAP_Res_Garage_Parking__c,' +
                    '(Select r.Id, r.PBS_AAAP_OT_RATE_COOLING_HEAT__c, r.PBS_AAAP_LEASE_TERM__c, r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c, r.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,' +
                    'r.PBS_AAAP_BASE_RATE__c, r.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, r.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, r.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,' +
                    'r.PBS_AAAP_COST_FOR_TI__c, r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, r.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,' +
                    'r.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c, r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, r.PBS_AAAP_Vacant_Premise_Rate__c, r.PBS_AAAP_PV_Value__c, r.PBS_AAAP_PV_Value_Blended__c, r.PBS_AAAP_BSAC__c ' +
                    'From Rates__r r where r.PBS_AAAP_LEASE_TERM__c IN ' + leaseTermforRates + 'and r.PBS_AAAP_BASE_RATE__c > 0) ' +
                    'From PBS_AAAP_Space__c s ' +
                    'where s.PBS_AAAP_RLP__c = \'' + rlpId + '\'' +
                    ' and s.PBS_AAAP_OFFER_NUMBER__r.Master_Offer__c=null' +
                    ' and s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Is_Offer_Valid__c=true' +
                    ' and s.PBS_AAAP_Offer_Status__c in (\'Submitted\', \'Awarded/Submitted\', \'Awarded/Pending Review\',\'Pending Review\',\'Awarded\')' +   //OOLOP-1100
                    ' and s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true';
            if(leaseTermforRates.size() == 1 && leaseTermforRates.contains('\'10 years,5 firm\'')){
                qString += ' and s.PBS_AAAP_Rate_Records_Count__c = 1';
            }else{
                qString += ' and s.PBS_AAAP_Rate_Records_Count__c = 3';
            }
            //Changes end by Snehith
            if (metroproximity == 'Yes') {
                qString += ' AND s.PBS_AAAP_Proximity_to_Metro__c = \'' + String.escapesinglequotes(metroproximity) + '\'';
            }
            System.debug('@@isParkingRequirement::'+isParkingRequirement);
            if (!isParkingRequirement && numofparkingspaces != null) {
                qString += ' AND s.PBS_AAAP_Total_Parking_Spaces__c >= ' + numofparkingspaces;
            }
            if (!isParkingRequirement ) {
                qString += ' AND s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Total_Parking_Spaces__c >= ' + parkingSpacesOnAgency;
            }
            double usfREQMIN = agencyRecord.PBS_AAAP_USF_REQ_MIN__c;
            qString += ' AND s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Total_SF_Offered__c >= ' + usfREQMIN;
            if (delineatedAreaType == PBS_AAAP_GlobalConstants.ALT_DEL_AREA_TYPE) {
                if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_CITY) {
                    qString += ' AND s.PBS_AAAP_City__c = \'' + String.escapesinglequotes(altDelineatedAreaDesc) + '\'';
                }
                if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_ZIPCODE) {
                    qString += ' AND s.PBS_AAAP_ZipCode__c = \'' + String.escapesinglequotes(altDelineatedAreaDesc) + '\'';
                }
                if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_CONG_DIST) {
                    qString += ' AND s.PBS_AAAP_Congressional_District__c = \'' + String.escapesinglequotes(altDelineatedAreaDesc) + '\'';
                }
                if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_COUNTY) {
                    qString += ' AND s.PBS_AAAP_County__c = \'' + String.escapesinglequotes(altDelineatedAreaDesc) + '\'';
                }
            }
            qString += ' order by s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Total_Parking_Spaces__c ';
            System.debug('******* Soql Query:::::::::::::   ' + qString);

            //List<PBS_AAAP_Space__c> spaceList;
            spaceList = Database.query(qString);
        } else {
            Id tempId = Id.valueOf(selectedHistorical);
            PBS_AAAP_Offer_History__c oh = [
                    SELECT
                            Id,
                            Name,
                            PBS_AAAP_Agency_Requirement__c,
                            PBS_AAAP_Cloned_Date_Time__c,
                            PBS_AAAP_Offer_Ids__c
                    FROM PBS_AAAP_Offer_History__c
                    WHERE Id = :tempId
            ];
            List<String> idStrLst = oh.PBS_AAAP_Offer_Ids__c.split(',');
            Set<Id> idSet = new Set<Id>();
            for(String str : idStrLst){
                idSet.add(Id.valueOf(str));
            }
            system.debug('*****NIKILESH*****'+idSet);
            String qString = 'select s.Id, s.Name, s.PBS_AAAP_SF_OFFERED__c, s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, s.PBS_AAAP_City__c, s.PBS_AAAP_State__c, s.PBS_AAAP_Type_of_Space__c,' +
                    's.PBS_AAAP_County__c, s.PBS_AAAP_Congressional_District__c, s.PBS_AAAP_ZipCode__c, s.PBS_AAAP_MANAGEMENT_COORD_FEES__c, s.PBS_AAAP_Offer_Status__c, ' +
                    's.PBS_AAAP_RLP__c, s.PBS_AAAP_Building_Name__c, s.PBS_AAAP_Proximity_to_Metro__c, s.PBS_AAAP_Total_Parking_Spaces__c, s.PBS_AAAP_Street_Address__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c,' +
                    's.PBS_AAAP_X_lat__c, s.PBS_AAAP_Y_lng__c, s.PBS_AAAP_OFFER_NUMBER__c, s.PBS_AAAP_TOTAL_MARKUP__c, s.PBS_AAAP_ARCH_ENG_FEES__c, s.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,' +
                    's.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, s.PBS_AAAP_GC_CONDITIONS__c, s.PBS_AAAP_OFFER_NUMBER__r.Name, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_COST_PER_ABOA__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c,' +
                    's.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Number_of_gar_parking_spaces__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_gar_park__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_sur_park__c,' +
                    's.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_gar_park__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_sur_park__c, PBS_AAAP_MetroWalkableGoogle__c,' +
                    's.PBS_AAAP_Formula_Energy_Star__c, s.PBS_AAAP_Formula_Hist_Property__c, s.PBS_AAAP_Formula_HUB_ZONE__c, s.PBS_AAAP_Formula_Metro__c, PBS_AAAP_BuildingProblem__c, ' +
                    's.PBS_AAAP_NonSur_Reserved_Park__c, s.PBS_AAAP_NonRes_Gar_Park__c, s.PBS_AAAP_Surface_Res_Park__c, s.PBS_AAAP_Res_Garage_Parking__c,' +
                    '(Select r.Id, r.PBS_AAAP_OT_RATE_COOLING_HEAT__c, r.PBS_AAAP_LEASE_TERM__c, r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c, r.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,' +
                    'r.PBS_AAAP_BASE_RATE__c, r.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, r.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, r.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,' +
                    'r.PBS_AAAP_COST_FOR_TI__c, r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, r.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,' +
                    'r.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c, r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, r.PBS_AAAP_Vacant_Premise_Rate__c, r.PBS_AAAP_PV_Value__c, r.PBS_AAAP_PV_Value_Blended__c, r.PBS_AAAP_BSAC__c ' +
                    'From Rates__r r where r.PBS_AAAP_LEASE_TERM__c IN ' + leaseTermforRates + 'and r.PBS_AAAP_BASE_RATE__c > 0) ' +
                    'From PBS_AAAP_Space__c s ' +
                    'where s.PBS_AAAP_RLP__c = \'' + rlpId + '\'' +
                    ' and s.PBS_AAAP_OFFER_NUMBER__r.Master_Offer__c!=null' +
                    ' and s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = true' +
                    ' and s.PBS_AAAP_OFFER_NUMBER__c IN';

            qString+=':idSet';
            system.debug('*****NIKILESH*****'+qString);

            if (metroproximity == 'Yes') {
                qString += ' AND s.PBS_AAAP_Proximity_to_Metro__c = \'' + String.escapesinglequotes(metroproximity) + '\'';
            }
            System.debug('@@isParkingRequirement::'+isParkingRequirement);
            if (!isParkingRequirement && numofparkingspaces != null) {
                qString += ' AND s.PBS_AAAP_Total_Parking_Spaces__c >= ' + numofparkingspaces;
            }
            if (!isParkingRequirement ) {
                qString += ' AND s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Total_Parking_Spaces__c >= ' + parkingSpacesOnAgency;
            }
            double usfREQMIN = agencyRecord.PBS_AAAP_USF_REQ_MIN__c;
            qString += ' AND s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Total_SF_Offered__c >= ' + usfREQMIN;
            if (delineatedAreaType == PBS_AAAP_GlobalConstants.ALT_DEL_AREA_TYPE) {
                if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_CITY) {
                    qString += ' AND s.PBS_AAAP_City__c = \'' + String.escapesinglequotes(altDelineatedAreaDesc) + '\'';
                }
                if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_ZIPCODE) {
                    qString += ' AND s.PBS_AAAP_ZipCode__c = \'' + String.escapesinglequotes(altDelineatedAreaDesc) + '\'';
                }
                if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_CONG_DIST) {
                    qString += ' AND s.PBS_AAAP_Congressional_District__c = \'' + String.escapesinglequotes(altDelineatedAreaDesc) + '\'';
                }
                if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_COUNTY) {
                    qString += ' AND s.PBS_AAAP_County__c = \'' + String.escapesinglequotes(altDelineatedAreaDesc) + '\'';
                }
            }
            qString += ' order by s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Total_Parking_Spaces__c ';
            System.debug('******* Soql Query:::::::::::::   ' + qString);
            spaceList = Database.query(qString);



        }

        System.debug('*******Show Space size ::::::::::::::::::   ' + spaceList.size());
        System.debug('*******Show Space size ::::::::::::::::::   ' + spaceList);
        //added by syam to display search results even New & Succeed results are 0
        if (spaceList.size() >= 0) {
            PBS_AAAP_IdentifyWinnerForm form;
            List<string> lstSpaceIds = new List<string>();
            for (PBS_AAAP_Space__c s : spaceList) {
                System.debug('Rates size is ***' + s.Rates__r.size());
                if (s.Rates__r.size() > 0) {
                    form = new PBS_AAAP_IdentifyWinnerForm();
                    form = mapFormProperties(form, s);
                    identifyWinnerForm.add(form);
                }
                lstSpaceIds.add(s.Id);
            }
            spaceIdsSet1 = String.join(lstSpaceIds,',');
            system.debug('\n--spaceIdsSet1--'+spaceIdsSet1);

            //Vaishali RLP FY 15 added PBS_AAAP_BSAC__c
            if (agencyRecord.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c != null && agencyRecord.PBS_AAAP_TYPE_OF_REQUIREMENT__c == PBS_AAAP_GlobalConstants.TYPE_OF_REK_CONTINUING) {
                System.debug('inside continuingSpace list ****');
                //Update start by Snehith 04/05/2018 - to add s.PBS_AAAP_OFFER_NUMBER__r.Name in the query
                if(selectedHistorical == 'Master') {
                    continuingSpaceList = [
                            SELECT s.Id, s.Name, s.PBS_AAAP_SF_OFFERED__c, s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, s.PBS_AAAP_City__c, s.PBS_AAAP_State__c, s.PBS_AAAP_Type_of_Space__c,
                                    s.PBS_AAAP_County__c, s.PBS_AAAP_Congressional_District__c, s.PBS_AAAP_ZipCode__c, s.PBS_AAAP_MANAGEMENT_COORD_FEES__c, s.PBS_AAAP_Offer_Status__c,
                                    s.PBS_AAAP_RLP__c, s.PBS_AAAP_Building_Name__c, s.PBS_AAAP_Proximity_to_Metro__c, s.PBS_AAAP_Total_Parking_Spaces__c, s.PBS_AAAP_Street_Address__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.Name, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, s.PBS_AAAP_X_lat__c, s.PBS_AAAP_Y_lng__c, s.PBS_AAAP_OFFER_NUMBER__c, s.PBS_AAAP_TOTAL_MARKUP__c,
                                    s.PBS_AAAP_ARCH_ENG_FEES__c, s.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, s.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, s.PBS_AAAP_GC_CONDITIONS__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_COST_PER_ABOA__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Number_of_gar_parking_spaces__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_gar_park__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_sur_park__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_gar_park__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_sur_park__c, s.PBS_AAAP_Formula_Energy_Star__c, s.PBS_AAAP_Formula_Hist_Property__c,
                                    s.PBS_AAAP_Formula_HUB_ZONE__c, s.PBS_AAAP_Formula_Metro__c, s.PBS_AAAP_NonSur_Reserved_Park__c, s.PBS_AAAP_NonRes_Gar_Park__c, s.PBS_AAAP_Surface_Res_Park__c,
                                    s.PBS_AAAP_Res_Garage_Parking__c, PBS_AAAP_MetroWalkableGoogle__c, PBS_AAAP_BuildingProblem__c, (
                                    SELECT r.Id, r.PBS_AAAP_OT_RATE_COOLING_HEAT__c, r.PBS_AAAP_LEASE_TERM__c, r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c, r.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                                            r.PBS_AAAP_BASE_RATE__c, r.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, r.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, r.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,
                                            r.PBS_AAAP_COST_FOR_TI__c, r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, r.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                                            r.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c, r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, r.PBS_AAAP_Vacant_Premise_Rate__c, r.PBS_AAAP_PV_Value__c, r.PBS_AAAP_PV_Value_Blended__c, r.PBS_AAAP_BSAC__c
                                    FROM Rates__r r
                                    WHERE r.PBS_AAAP_LEASE_TERM__c IN :leaseTermforRatesContinuing AND r.PBS_AAAP_BASE_RATE__c > 0
                            )
                            FROM PBS_AAAP_Space__c s
                            WHERE s.PBS_AAAP_RLP__c = :rlpId
                            AND s.PBS_AAAP_Offer_Status__c IN ('Submitted', 'Awarded/Submitted', 'Awarded/Pending Review', 'Pending Review', 'Awarded')   //OOLOP-1100
                            //Task#:00008588
                            AND s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Is_Offer_Valid__c = TRUE
                            AND s.PBS_AAAP_OFFER_NUMBER__r.Master_Offer__c = NULL
                            // End Task#:00008588
                            AND s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = FALSE
                            AND s.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = :agencyRecord.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c.trim()
                            AND (s.PBS_AAAP_Rate_Records_Count__c = 3 OR s.PBS_AAAP_Rate_Records_Count__c = 1)
                    ];
                } else {
                    Id tempId = Id.valueOf(selectedHistorical);
                    PBS_AAAP_Offer_History__c oh = [
                            SELECT
                                    Id,
                                    Name,
                                    PBS_AAAP_Agency_Requirement__c,
                                    PBS_AAAP_Cloned_Date_Time__c,
                                    PBS_AAAP_Offer_Ids__c
                            FROM PBS_AAAP_Offer_History__c
                            WHERE Id = :tempId
                    ];
                    List<String> idStrLst = oh.PBS_AAAP_Offer_Ids__c.split(',');
                    Set<Id> idSet = new Set<Id>();
                    for(String str : idStrLst){
                        idSet.add(Id.valueOf(str));
                    }
                    continuingSpaceList = [
                            SELECT s.Id, s.Name, s.PBS_AAAP_SF_OFFERED__c, s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, s.PBS_AAAP_City__c, s.PBS_AAAP_State__c, s.PBS_AAAP_Type_of_Space__c,
                                    s.PBS_AAAP_County__c, s.PBS_AAAP_Congressional_District__c, s.PBS_AAAP_ZipCode__c, s.PBS_AAAP_MANAGEMENT_COORD_FEES__c, s.PBS_AAAP_Offer_Status__c,
                                    s.PBS_AAAP_RLP__c, s.PBS_AAAP_Building_Name__c, s.PBS_AAAP_Proximity_to_Metro__c, s.PBS_AAAP_Total_Parking_Spaces__c, s.PBS_AAAP_Street_Address__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.Name, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, s.PBS_AAAP_X_lat__c, s.PBS_AAAP_Y_lng__c, s.PBS_AAAP_OFFER_NUMBER__c, s.PBS_AAAP_TOTAL_MARKUP__c,
                                    s.PBS_AAAP_ARCH_ENG_FEES__c, s.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, s.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, s.PBS_AAAP_GC_CONDITIONS__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_COST_PER_ABOA__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Number_of_gar_parking_spaces__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_gar_park__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_sur_park__c, s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_gar_park__c,
                                    s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_sur_park__c, s.PBS_AAAP_Formula_Energy_Star__c, s.PBS_AAAP_Formula_Hist_Property__c,
                                    s.PBS_AAAP_Formula_HUB_ZONE__c, s.PBS_AAAP_Formula_Metro__c, s.PBS_AAAP_NonSur_Reserved_Park__c, s.PBS_AAAP_NonRes_Gar_Park__c, s.PBS_AAAP_Surface_Res_Park__c,
                                    s.PBS_AAAP_Res_Garage_Parking__c, PBS_AAAP_MetroWalkableGoogle__c, PBS_AAAP_BuildingProblem__c, (
                                    SELECT r.Id, r.PBS_AAAP_OT_RATE_COOLING_HEAT__c, r.PBS_AAAP_LEASE_TERM__c, r.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c, r.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                                            r.PBS_AAAP_BASE_RATE__c, r.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, r.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, r.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,
                                            r.PBS_AAAP_COST_FOR_TI__c, r.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, r.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, r.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                                            r.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c, r.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, r.PBS_AAAP_Vacant_Premise_Rate__c, r.PBS_AAAP_PV_Value__c, r.PBS_AAAP_PV_Value_Blended__c, r.PBS_AAAP_BSAC__c
                                    FROM Rates__r r
                                    WHERE r.PBS_AAAP_LEASE_TERM__c IN :leaseTermforRatesContinuing AND r.PBS_AAAP_BASE_RATE__c > 0
                            )
                            FROM PBS_AAAP_Space__c s
                            WHERE s.PBS_AAAP_RLP__c = :rlpId
                            AND s.PBS_AAAP_OFFER_NUMBER__r.Master_Offer__c != NULL
                            AND s.PBS_AAAP_OFFER_NUMBER__c IN :idSet
                            AND s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = FALSE
                            AND s.PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = :agencyRecord.PBS_AAAP_CURRENT_GSA_LEASE_NUM__c.trim()
                            AND (s.PBS_AAAP_Rate_Records_Count__c = 3 OR s.PBS_AAAP_Rate_Records_Count__c = 1)
                    ];
                }
                //Updates end - by Snehith

                if (continuingSpaceList.size() > 0) {
                    for (PBS_AAAP_Space__c s : continuingSpaceList) {
                        if (s.Rates__r.size() > 0) {
                            form = new PBS_AAAP_IdentifyWinnerForm();
                            form = mapFormProperties(form, s);
                            identifyWinnerForm.add(form);
                        }
                    }
                }

            }

            system.debug('<<<<<<NIK2>>>>>'+agencyRecord);
            system.debug('<<<<<<NIK3>>>>>'+agencyRecord2);
            agencyRecord2 = agencyRecord;
            if(selectedHistorical == 'Master' && !isParkingRequirement){
                showSaveIdButton = TRUE;
            } else {
                showSaveIdButton = FALSE;
            }

            if (delineatedAreaType == PBS_AAAP_GlobalConstants.DEL_AREA_TYPE ||
                    (delineatedAreaType == PBS_AAAP_GlobalConstants.ALT_DEL_AREA_TYPE && altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET)) {
                showSelectButton = false;
            }

            PBS_AAAP_CALCULATIONS calculations = new PBS_AAAP_CALCULATIONS();

            System.debug('identifyWinnerForm record: '+identifyWinnerForm);
            identifyWinnerForm = calculations.getManagerPV(identifyWinnerForm, agencyId);

            system.debug('!******'+identifyWinnerForm);

            if (identifyWinnerForm.size() > 0) {
                for (PBS_AAAP_IdentifyWinnerForm f : identifyWinnerForm) {
                    if (f.neworsucceedingOffer == true)
                        f.NewAndSucc = 'New'; else
                    //changed by syam succeed to Continuing 04/26
                    {
                        f.NewAndSucc = 'Continuing';
                    }
                }
                showTable = true;
            }
            System.debug('****** identifyWinnerForm size: ' + String.valueOf(identifyWinnerForm.size()));
            System.debug('ShowSelectButton: '+showselectbutton);
            List<SubForm> formData;
            formData = new List<SubForm>();

            // loop through the prospective properties to build the JSON representation of form data for use by javascript
            for (PBS_AAAP_IdentifyWinnerForm iwf : identifyWinnerForm) {
                SubForm sub = new SubForm();
                sub.offerId = iwf.offerId;
                sub.spaceId = iwf.spaceId;
                sub.markerTitle = iwf.buildingName;
                sub.lat = iwf.lat;
                sub.lng = iwf.lng;
                sub.spaceName = iwf.spaceName;
                sub.buildingName = iwf.buildingName;
                sub.street = iwf.street;
                sub.city = iwf.city;
                sub.pvCosts  = iwf.pvCosts;
                sub.isEnergyStar = iwf.isEnergyStar;
                sub.isMetro = iwf.isMetro;
                sub.isHistoricProperty = iwf.isHistoricProperty;
                sub.isHUBZONEArea = iwf.isHUBZONEArea;
                sub.isSelected = iwf.isSelected;
                sub.isAwarded = iwf.isAwarded;
                sub.isBuildingProblem = iwf.isBuildingProblem;
                System.debug('****** sub: ' + sub);
                formData.add(sub);
                System.debug('****** formData: ' + formData);
            }   // end for

            if (formData.size() > 0) {
                formObj.formData = formData;        // populate object used as basis for writing JSON
                System.debug('****** formObj: ' + this.formObj);

                // generate the JSON
                this.props = JSON.serializePretty(formObj);
                System.debug('****** props: ' + this.props);

                // clear the formData  and formObj variables once they have been written out as JSON
                formData = new List<SubForm>();
                formObj = new FormObject();

            } else {
                this.props = 'false';
            }   // end if

            System.debug('*******Show Space match size ::::::::::::::::::   ' + identifyWinnerForm);
            System.debug('##### End actionSearch');
        }
        if (spaceList == null) {
            spaceList = new List<PBS_AAAP_Space__c>();
        }
        if (continuingSpaceList == null) {
            continuingSpaceList = new List<PBS_AAAP_Space__c>();
        }
        // no records found
        System.debug('##### spaceList size is ****'+spaceList.size()+ 'continuingSpaceList size is '+continuingSpaceList.size());
        if (spaceList.size() == 0 && continuingSpaceList.size() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'No records for this agency requirement.');
            ApexPages.addMessage(msg);
        }

        logMethodEnd('actionSearch');
        return null;
    }

    public PageReference actionSelectSpace() {
        logMethodStart('actionSelectSpace');

        string iwfJson = getQueryParamAsString('iwfJson');
        System.debug('iwfJson='+iwfJson);
        if (iwfJson==null) {
            identifyWinnerForm = new List<PBS_AAAP_IdentifyWinnerForm>();
        }
        else {
            identifyWinnerForm = ((IwfContainer) JSON.deserialize(iwfJson, IwfContainer.class)).winners;
        }

        PageReference pref = null;
        // Need to copy the search List to PBS_AAAP_Offer_Select_Award_Info__c object.

        List<PBS_AAAP_Offer_Select_Award_Info__c> copyIdentifyWinnerList;
        copyIdentifyWinnerList = new List<PBS_AAAP_Offer_Select_Award_Info__c>();
        PBS_AAAP_Offer_Select_Award_Info__c offerspacerecord;

        System.debug('*********** Selected Space Id:::: ' + selectedSpaceId);
        System.debug('*********** Selected offer Id:::: ' + selectedOfferId);
        System.debug('*****identifyWinnerForm.size() is ' + identifyWinnerForm.size());


        PBS_AAAP_RLP__c rlp = [SELECT Id, PBS_AAAP_Year__c,PBS_AAAP_Region__c FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_RLP_Number__c = :agencyRecord.PBS_AAAP_RLP_Number__c LIMIT 1];
        boolean isCensus = rlp.PBS_AAAP_Region__c=='Census';
        System.debug('*********** IsCensus = ' + (isCensus?'1':'0'));

        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();

        try {

            if (identifyWinnerForm.size() > 0 && selectedSpaceId != null && selectedOfferId != null) {

                for (PBS_AAAP_IdentifyWinnerForm f : identifyWinnerForm) {

                    if ((isCensus||true) && (selectedSpaceId!=f.spaceId || selectedOfferId!=f.offerId)) continue;

                    offerspacerecord = new PBS_AAAP_Offer_Select_Award_Info__c();
                    System.debug('***********  Space Id:::: ' + f.spaceId);
                    System.debug('***********  offer Id:::: ' + f.offerId);
                    offerspacerecord.PBS_AAAP_Space_ID__c = f.spaceId;
                    //commented by syam updated the flag in pbs_aaap_selectedofferspace controller
                    /* if(f.spaceId == selectedSpaceId){
                         offerspacerecord.PBS_AAAP_isSelected__c = true;
                     }*/
                    offerspacerecord.PBS_AAAP_Offer_ID__c = f.offerId;
                    offerspacerecord.PBS_AAAP_AGENCY_REQUIREMENT_ID__c = agencyId;
                    offerspacerecord.PBS_AAAP_BASE_RATE__c = f.baseRate;
                    offerspacerecord.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = f.baseCostSrvcUtilPerABOA;
                    offerspacerecord.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = f.amortizRateT1Upto20;
                    offerspacerecord.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = f.amortizRateT1Above20;
                    offerspacerecord.PBS_AAAP_COST_FOR_TI__c = f.costForTI;
                    offerspacerecord.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = f.fullServiceRentFirm;
                    offerspacerecord.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = f.fullyServRentOptionTerm;
                    offerspacerecord.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = f.numOfMonthsFreeFirmTerm;
                    offerspacerecord.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c = f.numOfMonthsFreeOptionTerm;
                    offerspacerecord.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c = f.coopCommTogsaFirmTerm;
                    offerspacerecord.PBS_AAAP_VACANT_PREMISE_RATE_ADJ__c = f.vacantPremiseRate;
                    offerspacerecord.PBS_AAAP_OT_RATE_COOLING_HEAT__c = f.HVACCost;
                    offerspacerecord.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c = f.daytimeCleaningCost;
                    offerspacerecord.PBS_AAAP_ACTUAL_TI_AMORTIZED_INTO_RENT__c = f.annualAmortTICosts;
                    offerspacerecord.PBS_AAAP_TOTAL_MARKUP__c = f.totalMarkUpSpace;
                    offerspacerecord.PBS_AAAP_PV_RATE__c = Decimal.valueOf(selectedPV).setScale(2);
                    copyIdentifyWinnerList.add(offerspacerecord);
                }

                if (copyIdentifyWinnerList.size() > 0) {
                    insert copyIdentifyWinnerList;

                    for (PBS_AAAP_Offer_Select_Award_Info__c osai : copyIdentifyWinnerList) {
                        //if(osai.PBS_AAAP_isSelected__c == true){
                        if (osai.PBS_AAAP_Space_ID__c == selectedSpaceId) {
                            pref = page.PBS_AAAP_SelectedOfferSpace;
                            System.debug('*********** osai.Id is:::: ' + osai.Id);
                            pref.getParameters().put('selectedOfferSpaceId', osai.Id);
                            pref.getParameters().put('agencyId', agencyId);
                            pref.setRedirect(true);
                        }
                    //}
                    }
                // Need to update Agency Requirement Status from "Pending" to "Pending Selected".
                //PBS_AAAP_Agency_Requirement__c agency = [Select Id, PBS_AAAP_REQ_STATUS__c, Name from PBS_AAAP_Agency_Requirement__c where id=:agencyId];
                //agency.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDINGSELECTED;
                //update agency;
                }
            }
        } catch (Exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
        logMethodEnd('actionSelectSpace', pref);
        return pref;
    }

    public void setSearchFormFields() {
        logMethodStart('setSearchFormFields');

        if (agencyRecord.PBS_AAAP_LEASE_TERM__c != null) {
            leaseTerm = agencyRecord.PBS_AAAP_LEASE_TERM__c;
            leaseTermforRates = new List<String>();
            leaseTermforRatesContinuing = new List<String>();
            if(leaseTerm == '19 Months, 11 Firm' || leaseTerm == '19 Months,11 Firm'){
                leaseTermforRates.add('\'19 Months, 11 Firm\'');
                leaseTermforRates.add('\'19 Months,11 Firm\'');
                leaseTermforRatesContinuing.add('19 Months, 11 Firm');
                leaseTermforRatesContinuing.add('19 Months,11 Firm');

            }else if(leaseTerm == '25 Months,16 Firm' || leaseTerm == '25 Months, 16 Firm'){
                leaseTermforRates.add('\'25 Months,16 Firm\'');
                leaseTermforRates.add('\'25 Months, 16 Firm\'');
                leaseTermforRatesContinuing.add('25 Months, 16 Firm');
                leaseTermforRatesContinuing.add('25 Months,16 Firm');
            }else{
                String leaseterm = agencyRecord.PBS_AAAP_LEASE_TERM__c;
                leaseTermforRates.add('\''+String.escapesinglequotes(leaseterm)+'\'');
                leaseTermforRatesContinuing.add(agencyRecord.PBS_AAAP_LEASE_TERM__c);
            }
        }
        if (agencyRecord.PBS_AAAP_USF_REQ_MIN__c != null) {
            asniboma_min = agencyRecord.PBS_AAAP_USF_REQ_MIN__c;
        }
        if (agencyRecord.PBS_AAAP_USF_REQ_MAX__c != null) {
            asniboma_max = agencyRecord.PBS_AAAP_USF_REQ_MAX__c;
        }
        if (agencyRecord.PBS_AAAP_MIN_CONT_USF__c != null) {
            Min_Contiguous_ABOASF = agencyRecord.PBS_AAAP_MIN_CONT_USF__c;
        }
        if (agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c != null) { // user or alt. delin. type
            delineatedAreaType = agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE__c;
        }
        if (agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != null) {
            altDelineatedArea = agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c;
        }
        if (agencyRecord.PBS_AAAP_DELINEATED_DESCRIPTION__c != null) {
            altDelineatedAreaDesc = agencyRecord.PBS_AAAP_DELINEATED_DESCRIPTION__c;
        }
        if (agencyRecord.PBS_AAAP_WALKABLE_2640_FEET_METRO__c != null) {
            metroproximity = agencyRecord.PBS_AAAP_WALKABLE_2640_FEET_METRO__c;
        }
        if (agencyRecord.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c != null || agencyRecord.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c != null ||
                agencyRecord.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c != null || agencyRecord.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c != null) {

            numofparkingspaces = parkingSpacesOnAgency;
        }
        if (agencyRecord.PBS_AAAP_DAY_TIME_CLEANING_REQ__c != null) {
            daytimeCleaning = agencyRecord.PBS_AAAP_DAY_TIME_CLEANING_REQ__c;
        }
        if (agencyRecord.PBS_AAAP_HVAC_OVERTIME_HOURS__c != null) {
            HVACOvertimeHours = agencyRecord.PBS_AAAP_HVAC_OVERTIME_HOURS__c;
        }
        if (agencyRecord.PBS_AAAP_Include_HVAC_Overtime__c == true) {
            IncludeHVAC = agencyRecord.PBS_AAAP_Include_HVAC_Overtime__c;
        } else {
            IncludeHVAC = false;
        }
        if (agencyRecord.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c != null) {     //rlpRecord.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c
            newLease = agencyRecord.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c;
        }
        //added by syam 04/19 to default to 0.0 when it is null otherwise going to error screen.
        else {
            newLease = 0.0;
            agencyRecord.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 0.0;
        }
        if (agencyRecord.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c != null) {
            succeedingLease = agencyRecord.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c;
        }else{
            succeedingLease = 0.0;
        }
        if (agencyRecord.PBS_AAAP_MOVE_DEFAULT__c != null) {
            physicalMoveCost = agencyRecord.PBS_AAAP_MOVE_DEFAULT__c;
            //physicalMoveCost = 2000.00;
        }
        if (agencyRecord.PBS_AAAP_TELCOMM_DEFAULT__c != null) {
            telecommunicationsCost = agencyRecord.PBS_AAAP_TELCOMM_DEFAULT__c;
        }
        if (agencyRecord.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c != null) {
            upfrontCostsPV = agencyRecord.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c;
        }
        System.debug('upfrontCostsPV: '+upfrontCostsPV);
        //Vaishali RLP FY15 set BSACperABOA
        if (agencyRecord.PBS_AAAP_BSAC_per_ABOA__c != null) {
            BSACperABOA = agencyRecord.PBS_AAAP_BSAC_per_ABOA__c;
        }
        if (agencyRecord.BSAC_for_Continuing_Space_per_ABOA_SF__c != null) {
            bsacForContinuingSpace = agencyRecord.BSAC_for_Continuing_Space_per_ABOA_SF__c;
        }
        logMethodEnd('setSearchFormFields');
    }

    public PBS_AAAP_IdentifyWinnerForm mapFormProperties(PBS_AAAP_IdentifyWinnerForm form, PBS_AAAP_Space__c s) {
        logMethodStart('mapFormProperties');

        try {
            System.debug('inside mapFormProperties rates size is ' + s.Rates__r.size());
            if (s.Rates__r.size() > 0) {
                // Add records to PBS_AAAP_IdentifyWinnerForm list
                form.buildingName = s.PBS_AAAP_Building_Name__c;
                form.city = s.PBS_AAAP_City__c;
                form.street = s.PBS_AAAP_Street_Address__c;
                form.typeOfSpace = s.PBS_AAAP_Type_of_Space__c;
                form.SFOfSpace = s.PBS_AAAP_SF_OFFERED__c;
                form.neworsucceedingOffer = s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c;
                form.totalMarkUpSpace = s.PBS_AAAP_TOTAL_MARKUP__c;
                form.mgmtCoordFees = s.PBS_AAAP_MANAGEMENT_COORD_FEES__c;

                Id offerId = s.PBS_AAAP_OFFER_NUMBER__c;
                //List<Case> lstCase = new List<Case>();
                //lstCase = [SELECT Id FROM Case WHERE Building_Problems__c = :offerId];
                System.debug('=============>>>>> PBS_AAAP_IdentifyWinnerForm mapFormProperties space) ::: ' + s);
                //Changes start by Snehith 04/05/2018 - to capture offer name on to form
                form.offerName = s.PBS_AAAP_OFFER_NUMBER__r.Name;
                //Changes end
                if (s.PBS_AAAP_Formula_Energy_Star__c == 'Yes') {
                    form.isEnergyStar = true;
                } else {
                    form.isEnergyStar = false;
                }

                if (s.PBS_AAAP_Formula_Hist_Property__c == 'Yes') {
                    form.isHistoricProperty = true;
                } else {
                    form.isHistoricProperty = false;
                }
                if (s.PBS_AAAP_Formula_HUB_ZONE__c == 'Yes') {
                    form.isHUBZONEArea = true;
                } else {
                    form.isHUBZONEArea = false;
                }
                if (s.PBS_AAAP_Formula_Metro__c == 'Yes' && s.PBS_AAAP_MetroWalkableGoogle__c == false) {
                    form.isMetro = true;
                } else {
                    form.isMetro = false;
                }
                if(setBuildingProbIds.contains(offerId)){
                    form.isBuildingProblem = true;
                } else {
                    form.isBuildingProblem = false;
                }


                //system.debug('*********** offer status please ::::::::  '+ s.PBS_AAAP_Offer_Status__c);
                if (s.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED ||
                        s.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED ||
                        s.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED) {

                    form.isAwarded = true;
                } else {
                    form.isAwarded = false;
                }
                if (s.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED ||
                        s.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED) {
                    form.isSelected = true;
                } else {
                    form.isSelected = false;
                }


                form.lat = s.PBS_AAAP_X_lat__c;
                form.lng = s.PBS_AAAP_Y_lng__c;
                form.maxSqFt = agencyRecord.PBS_AAAP_USF_REQ_MIN__c;
                form.minSqFt = agencyRecord.PBS_AAAP_USF_REQ_MAX__c;
                form.numParkingSpaces = numofparkingspaces;
                form.rateResSrfcPrkSpace = s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_sur_park__c;
                form.rateResGargPrkSpace = s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_res_gar_park__c;
                form.rateNonResSrfcPrkSpace = s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_sur_park__c;
                form.rateNonResGargPrkSpace = s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_Monthly_cost_nonres_gar_park__c;
                form.numNonResGargPrkSpace = agencyRecord.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c;
                form.numNonResSrfcPrkSpace = agencyRecord.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c;
                form.numResGargPrkSpace = agencyRecord.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c;
                form.numResSrfcPrkSpace = agencyRecord.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c;

                form.aeFees = s.PBS_AAAP_ARCH_ENG_FEES__c;
                form.aeFeeUOM = s.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c;
                form.overheadProfFees = s.PBS_AAAP_GC_OVERHEAD_AND_PROF__c;
                form.gcConditions = s.PBS_AAAP_GC_CONDITIONS__c;
                form.costPerABOA = s.PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_COST_PER_ABOA__c;

                form.spaceId = s.Id;
                form.spaceName = s.Name;
                form.offerId = s.PBS_AAAP_OFFER_NUMBER__c;

                // assigning RLP Info for calculations
                form.newLease = newLease;
                form.succLease = succeedingLease;
                form.newLeaseIncludeAE = newLeaseArchAndEng;
                form.succLeaseIncludeAE = succLeaseArchAndEng;
                form.physicalcosts = physicalMoveCost;
                form.telecommcosts = telecommunicationsCost;

                if(agencyRecord.PBS_AAAP_TYPE_OF_REQUIREMENT__c == 'Continuing' && s.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c == false){
                    form.otherupfrontcosts = 0;
                }else{
                    form.otherupfrontcosts = upfrontCostsPV;
                }

                form.BSACperABOA = BSACperABOA;
                form.bsacForContinuingSpace = bsacForContinuingSpace;
                if (IncludeHVAC == true) {
                    form.includeHVACOverTime = IncludeHVAC;
                } else {
                    form.includeHVACOverTime = false;
                }
                form.HVACOvertimeHours = HVACOvertimeHours;
                form.maxTi = rlpRecord.PBS_AAAP_MAX_TIUSED__c;
                form.discountRate = rlpRecord.PBS_AAAP_DISCOUNT_RATE__c;
                form.escalRate = rlpRecord.PBS_AAAP_ESCALATION_RATE_PERCENT__c;
                form.leaseTerm = leaseTerm;
                form.rlpGT2016 = (Integer.valueOf(rlpRecord.PBS_AAAP_Year__c) > 2016) ? true : false;

                PBS_AAAP_Rate__c rate = s.Rates__r;

                form.baseRate = rate.PBS_AAAP_BASE_RATE__c;
                form.baseCostSrvcUtilPerABOA = rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c;
                form.amortizRateT1Upto20 = rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c;
                //as of 2016 Amortization rate same for both tiers Vaishali FY17..added check
                form.amortizRateT1Above20 = (form.rlpGT2016) ? rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c : rate.PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c;
                form.costForTI = rate.PBS_AAAP_COST_FOR_TI__c;
                form.fullServiceRentFirm = rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c;
                form.fullyServRentOptionTerm = rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c;
                form.numOfMonthsFreeFirmTerm = rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c;
                form.numOfMonthsFreeOptionTerm = rate.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c;
                form.coopCommTogsaFirmTerm = rate.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c;
                form.vacantPremiseRate = rate.PBS_AAAP_Vacant_Premise_Rate__c;
                form.HVACCost = rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c;
                form.daytimeCleaningCost = rate.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c;
                form.BSACCost = rate.PBS_AAAP_BSAC__c;
                form.annualAmortTICosts = rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c;
                form.pvCosts = null;
                if (rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIVEYR || rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.TENYR) {
                    form.ownerPvCosts = rate.PBS_AAAP_PV_Value__c;
                } else { //if(rate.PBS_AAAP_LEASE_TERM__c == PBS_AAAP_CALCULATIONS.FIVEFIVEYR){
                    form.ownerPvCosts = rate.PBS_AAAP_PV_Value_Blended__c;
                } // end if


                if (delineatedAreaType == PBS_AAAP_GlobalConstants.DEL_AREA_TYPE) {
                    form.isUserDelineatedArea = true;
                } else {
                    form.isUserDelineatedArea = false;
                    if (altDelineatedArea == PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET) {
                        form.altDelineatedAreaSubMarket = altDelineatedArea;
                        form.subMarketDescriptor = altDelineatedAreaDesc;
                        form.subMarketPolygonId = agencyRecord.PBS_AAAP_Polygon_Object_Id__c;
                    }
                }
            }

        } catch (Exception ex) {
            system.debug('\n--ex--'+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Your space has issue ' + form.spaceId));
            return null;
        }
        logMethodEnd('mapFormProperties', form);
        return form;
    }

    public List<SelectOption> getDelineatedAreaTypeDescList() {
        logMethodStart('getDelineatedAreaTypeDescList');

        List<SelectOption> options = new List<SelectOption>();


        List<PBS_AAAP_RLP_Regions_Map__c> statesList = new List<PBS_AAAP_RLP_Regions_Map__c>();
        List<PBS_AAAP_AlternateDelineatedArea__c> delineatedTypeList = new List<PBS_AAAP_AlternateDelineatedArea__c>();
        List<PBS_AAAP_PolyObject__c> subMarketList = new List<PBS_AAAP_PolyObject__c>();
        List<String> valueList = new List<String>();
        Set<String> valueSet = new Set<String>();

        if (agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != null && agencyRecord.PBS_AAAP_Region__c != null) {

            statesList = [
                    SELECT id, name, PBS_AAAP_RLP_State__c, PBS_AAAP_RLP_State_Abbrevation__c, PBS_AAAP_Region_Name__c
                    FROM PBS_AAAP_RLP_Regions_Map__c
                    WHERE PBS_AAAP_Region_Name__c = :agencyRecord.PBS_AAAP_Region__c
            ];
            System.debug('************ statesList::: ' + statesList);

            Set<String> regionStatesList = new Set<String>();
            if (statesList.size() > 0) {
                for (PBS_AAAP_RLP_Regions_Map__c s : statesList) {
                    regionStatesList.add(s.PBS_AAAP_RLP_State_Abbrevation__c);
                }
                System.debug('************ regionsStateList::: ' + regionStatesList);
            }

            // Logic to pull records from delineated area for other than "SubMarket".
            if (agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c != PBS_AAAP_GlobalConstants.ALT_DEL_TYPE_DESC_SUBMARKET) {
                delineatedTypeList = [
                        SELECT DilneatedAreaType__c, State__c, Value__c
                        FROM PBS_AAAP_AlternateDelineatedArea__c
                        WHERE State__c IN :regionStatesList
                        AND DilneatedAreaType__c = :agencyRecord.PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c
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

                if (subMarketList.size() > 0) {
                    for (PBS_AAAP_PolyObject__c s : subMarketList) {
                        options.add(new SelectOption(s.Name, s.Name));
                    }
                    options.sort();
                }
            }
        }

        logMethodEnd('getDelineatedAreaTypeDescList', options);
        return options;
    }

    public List<SelectOption> getLeaseTermsList() {
        logMethodStart('getLeaseTermsList');

        System.debug('agencyRecord.PBS_AAAP_RLP_Number__c is' + agencyRecord.PBS_AAAP_RLP_Number__c);
        PBS_AAAP_RLP__c rlp = [SELECT Id, PBS_AAAP_Year__c,PBS_AAAP_Region__c FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_RLP_Number__c = :agencyRecord.PBS_AAAP_RLP_Number__c LIMIT 1];
        String rlpFYYear = rlp.PBS_AAAP_Year__c;
        String region = rlp.PBS_AAAP_Region__c;
        System.debug('rlpFYYear is ***' + rlpFYYear);
        Integer rlpBaseYear = Integer.valueOf(rlpFYYear);
        List<SelectOption> options = new List<SelectOption>();
        //PBS_AAAP_Year__c   PBS_AAAP_RLP_Number__c
        if (region == 'Census') {
            options.add(new SelectOption('19 months,11 firm', '19 months,11 firm'));
            options.add(new SelectOption('25 months,16 firm', '25 months,16 firm'));
        } else if (rlpBaseYear < 2017) {
            options.add(new SelectOption('5 years', '5 years'));
            options.add(new SelectOption('5+5 years', '5+5 years'));
            options.add(new SelectOption('10 years', '10 years'));
        } else if (rlpBaseYear < 2018){
            options.add(new SelectOption('10 years', '10 years'));
            options.add(new SelectOption('10 years,5 firm', '10 years,5 firm'));
            options.add(new SelectOption('15 years,10 firm', '15 years,10 firm'));
        } else{
            options.add(new SelectOption('10 years, 8 firm', '10 years,8 firm'));
            options.add(new SelectOption('15 years,13 firm', '15 years,13 firm'));
            options.add(new SelectOption('17 years,15 firm', '17 years,15 firm'));
        }
        logMethodEnd('getLeaseTermsList', options);
        return options;
    }


    public PageReference callCloningClass() {

        String para = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('node'));
        String offId = Apexpages.currentPage().getParameters().get('list');
		List<PBS_AAAP_Agency_Requirement__c> agencyRecords = [SELECT Id FROM PBS_AAAP_Agency_Requirement__c where Id=:para];
        String agencyId = '';
        if(agencyRecords.size() > 0){
            agencyId = agencyRecords[0].Id;
        }
        List<String> offerIdsStr = New List<String>();

        if(!String.isBlank(offId)){
            offerIdsStr.addAll(offId.split(','));
        }

        //PBS_AAAP_saveVersionClass.cloneRecords(para);
        actionSearch();

        Set<Id> offerIds = new Set<Id>();
        if(!offerIdsStr.isEmpty()){
            for(String s : offerIdsStr){
                offerIds.add(Id.valueOf(s));
            }
        }

        if(!offerIds.isEmpty()){
            PBS_AAAP_saveVersionClass.cloneOffers2(offerIds, para);
        }
        //return null;
        PageReference pageRef = new PageReference('/apex/pbs_aaap_identifywinnersearch?agencyId='+agencyId);
        pageRef.setRedirect(true);
        return pageRef;
    }


    public class imagWrapper{
        public string src {get;set;}
        public string name {get;set;}
    }



    @RemoteAction
    global static string fetchCookieData(String selectedofferdIds, string selectedSpacedIds) {
        system.debug('\n--selectedofferdIds--'+selectedofferdIds+'\n--selectedSpacedIds--'+selectedSpacedIds);

        // saving the list of ids in sequence of Offer,space and rate
        List<string> lstReturnIds = new List<string>();
        integer offerCount = 0;
        integer spaceCount = 0;
        integer rateCount = 0;
        if(!string.isBlank(selectedofferdIds)){
            List<string> lstOfferIds = selectedofferdIds.split(',');
            List<string> lstSpaceIds = selectedSpacedIds.split(',');
            system.debug('\n--lstOfferIds--'+lstOfferIds+'\n--lstSpaceIds--'+lstSpaceIds);

            // this will store the
            set<string> setSpacesIds = new set<string>();
            setSpacesIds.addAll(lstSpaceIds);

            // setting space count
            spaceCount = setSpacesIds.size();

            // setting offer count
            offerCount = lstOfferIds.size();

            List<PBS_AAAP_Offer__c> lstOffer = [SELECT ID,
            (SELECT ID
            FROM Spaces__r
            WHERE ID IN: setSpacesIds)
            FROM PBS_AAAP_Offer__c
            WHERE ID IN: lstOfferIds];

            system.debug('\n--setSpacesIds--'+setSpacesIds+'\n--lstOfferIds--'+lstOfferIds);


            // saving spance ids and related rates
            map<id,List<PBS_AAAP_Rate__c>> mapRates = new map<id,List<PBS_AAAP_Rate__c>>();

            // getting data of rates
            for(PBS_AAAP_Rate__c rate : [SELECT ID,
                    PBS_AAAP_SPACE__c
            FROM PBS_AAAP_Rate__c
            WHERE PBS_AAAP_SPACE__c IN: setSpacesIds]){
                rateCount++;
                if(mapRates.containsKey(rate.PBS_AAAP_SPACE__c)){
                    List<PBS_AAAP_Rate__c> lstRates = mapRates.get(rate.PBS_AAAP_SPACE__c);
                    lstRates.add(rate);
                    mapRates.put(rate.PBS_AAAP_SPACE__c,lstRates);
                }
                else{
                    List<PBS_AAAP_Rate__c> lstRates = new List<PBS_AAAP_Rate__c>();
                    lstRates.add(rate);
                    mapRates.put(rate.PBS_AAAP_SPACE__c,lstRates);
                }
            }

            // preparing list to make ids in order
            for(PBS_AAAP_Offer__c offer : lstOffer){
                lstReturnIds.add(offer.Id);

                // adding space
                for(PBS_AAAP_Space__c space :  offer.Spaces__r){
                    lstReturnIds.add(space.Id);

                    // adding rates
                    if(mapRates.containsKey(space.Id)){

                        // for each rates
                        for(PBS_AAAP_Rate__c rate : mapRates.get(space.Id)){
                            lstReturnIds.add(rate.Id);
                        }
                    }
                }
            }
        }

        return (offerCount+';'+spaceCount+';'+rateCount+';'+string.join(lstReturnIds,','));
    }

    public void captureImage()
    {
        string folderId = [SELECT ID
        FROM Folder
        WHERE NAME = 'AAAP Folder'].Id;
        Document d = new Document();
        d.Name = strImagename+'.png';

        Integer strLen = strImageBlob1.length() / 2;
        String first = strImageBlob1.substring(0, strLen);
        String second = strImageBlob1.substring(strLen);
        String first1 = first.replaceFirst('data:image/png;base64,','');
        String concat = first1 + second;
        d.Body = EncodingUtil.base64Decode(concat);

        //d.Body = EncodingUtil.base64Decode(strImageBlob1.replaceFirst('data:image/png;base64,',''));
        d.ContentType = 'image/png';
        d.FolderId = folderId;
        d.IsPublic = true;
        insert d;
        system.debug('\n--d---'+d);
    }

}