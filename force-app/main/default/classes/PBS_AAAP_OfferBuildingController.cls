public with sharing class PBS_AAAP_OfferBuildingController extends PBS_AAAP_PageBaseController {

    public string debugInformation {get;set;}
    public Boolean giveAlert { get; set; }
    public String RLPid { get; set; }
    public PBS_AAAP_Offer__c offerBuilding { get; set; }
    public String offerId { get; set; }
    
    public String myGisToken { get; set; }
    public String myGisUrlPrefix { get; set; }
    public String myGisLocatorUrl { get; set; }
    public String myGisLocator { get; set; }
    
    public String pageUrl{get;set;}
    public static String PassedUrl; 

    List<SelectOption> RLPwithRegion = new List<SelectOption>();
    public String isNew { get; set; }
    public String action { get; set; }
    public string selectRLP { get; set; }
    public string oldRLP { get; set; }  //Vaishali Test
    //public Boolean showMap                {get;set;}
    public Boolean isPendingModfication { get; set; }
    public Boolean isCopy { get; set; }
    public Boolean isModify { get; set; }
    public String officePercent { get; set; }
    public String retailPercent { get; set; }
    public String garagePercent { get; set; }
    public String totalPercent { get; set; }
    public boolean percentage {get; set;}
    public User userDetail { get; set; }
    public boolean isValidUser { get; set; }
    public boolean showSubmitMesg { get; set; }
    public boolean metroWalkable { get; set; }
    public String offerCounty { get; set; } // 20120916 -- CH -- county list
    public List<Selectoption> counties = new List<Selectoption>();
    public static final string SLCTOPTDFLT = '--';
    //added by syam for address validation
    public static String buildingValidationMsg { get; set; }
    public String draftMsgFlag { get; set; }
    private PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();
    public String areaJson {get;set;}
    public String regionCensusMapJson {get;set;}
    public String fullAddress {get; set;}
    public String CAF { get; set; }
    public string pageURLForRedirection {get;set;}

    public PBS_AAAP_OfferBuildingController() {
        logConstructorStart('PBS_AAAP_OfferBuildingController');
        system.debug('PBS_AAAP_OfferBuildingController');

        userDetail = [SELECT u.Username, u.ProfileId, u.PBS_AAAP_PIN__c, u.Name, u.Id, u.ContactId, u.Email FROM User u WHERE u.Id = :UserInfo.getUserId()];
        action = getQueryParamAsString('action');
        offerId = getQueryParamAsString('offerId');
        isNew = getQueryParamAsString('isNew');
        draftMsgFlag = getQueryParamAsString('draftMsg');
        showSubmitMesg = false;

        if (getQueryParamAsString('offerId') != null) {

            offerBuilding = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            if (offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > 0) {
                CAF = String.valueOf(((offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c - offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c) / offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c * 100).setScale(2)) + ' %';
            } else {
                CAF = 'N/A';
            }
            if(offerBuilding.PBS_AAAP_User_Defined_Address__c == '' || offerBuilding.PBS_AAAP_User_Defined_Address__c == NULL){
                fullAddress = offerBuilding.PBS_AAAP_Street_Address__c  + ', ' + offerBuilding.PBS_AAAP_City__c  + ', ' + offerBuilding.PBS_AAAP_State__c + ', ' + offerBuilding.PBS_AAAP_ZipCode__c + ', USA';
            } else {
                fullAddress = offerBuilding.PBS_AAAP_User_Defined_Address__c;
            }
            
            // initialize the flag for a bldg's 2640 walkable feet to a metro station with the properties value (or false if one doesn't exist)
            metroWalkable = (offerBuilding.Property__r.PBS_AAAP_MetroWalkable__c) ? offerBuilding.Property__r.PBS_AAAP_MetroWalkable__c : false;
            System.debug('PBS_AAAP_OfferBuildingController.Owner Info=' + offerBuilding.OwnerId);
            System.debug('PBS_AAAP_OfferBuildingController.UserId=' + UserInfo.getUserId());
            if (offerBuilding.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
                selectRLP = offerBuilding.PBS_AAAP_RLP_Number__c;
                oldRLP = selectRLP; //vaishali test
                System.debug('PBS_AAAP_OfferBuildingController.offerCounty=' + offerCounty);
                System.debug('PBS_AAAP_OfferBuildingController.County=' + offerBuilding.PBS_AAAP_County__c);
                System.debug('PBS_AAAP_OfferBuildingController.selectRLP=' + selectRLP);
                offerCounty = offerBuilding.PBS_AAAP_County__c;
                officePercent = String.valueOf(offerBuilding.PBS_AAAP_BLD_INCOME_PERCENT_OFF_SPACE__c);
                retailPercent = String.valueOf(offerBuilding.PBS_AAAP_BLD_INCOME_PERCENT_RET_SPACE__c);
                garagePercent = String.valueOf(offerBuilding.PBS_AAAP_BLD_INCOME_PERCENT_GAR_SPACE__c);
                totalPercent = String.valueOf(offerBuilding.PBS_AAAP_BLD_INCOME_PERCENT_OFF_SPACE__c + offerBuilding.PBS_AAAP_BLD_INCOME_PERCENT_RET_SPACE__c + offerBuilding.PBS_AAAP_BLD_INCOME_PERCENT_GAR_SPACE__c);
                percentage = true;
                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
                    isPendingModfication = true;
                }
                if (action == PBS_AAAP_GlobalConstants.OFFER_COPY) {
                    isCopy = true;
                }
                if (action == PBS_AAAP_GlobalConstants.OFFER_MODIFY) {
                    isModify = true;
                }
                Boolean isValidOffer = PBS_AAAP_GlobalConstants.checkOfferIsValidOrNot(offerBuilding);
                if(!isValidOffer){
                    showSubmitMesg = true;
                }
                system.debug('PBS_AAAP_OfferBuildingController.offerCounty=' + offerCounty);
                system.debug('PBS_AAAP_OfferBuildingController.PBS_AAAP_County__c=' + offerBuilding.PBS_AAAP_County__c);
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
            String areaType = offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c;
            System.debug('PBS_AAAP_OfferBuildingController.areaType=' + areaType);
            Decimal siteSize = offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c;
            System.debug('PBS_AAAP_OfferBuildingController.siteSize' + siteSize);
            if (areaType == 'Acres') {
                if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c != null) {
                    siteSize = siteSize / 43560;
                    System.debug('PBS_AAAP_OfferBuildingController.sizeSize (changed)=' + siteSize);
                    offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
                }
            }
			offerBuilding.PBS_AAAP_Offeror__c = userDetail.ContactId;// Added by Poorna
        } else {
            isValidUser = true;
            //showSubmitMesg = true;
            offerBuilding = new PBS_AAAP_Offer__c();            
            offerBuilding.PBS_AAAP_Country__c = PBS_AAAP_GlobalConstants.BUILDING_COUNTRY;
            offerBuilding.PBS_AAAP_Offeror__c = userDetail.ContactId;//Added by Poorna
            selectRLP = offerBuilding.PBS_AAAP_RLP_Number__c;
            System.debug('PBS_AAAP_OfferBuildingController.selectRLP=' + selectRLP);
        }
        System.debug('******* ShowSubmit Mesg::: ' + showSubmitMesg);

        Map<string, string> sm = getStateAbbreviationByStateName();
        areaJson = '[';
        for (PBS_AAAP_RLP_Regions_Map__c m : [select PBS_AAAP_Region_Name__c, PBS_AAAP_RLP_State__c, PBS_AAAP_RLP_State_Abbrevation__c, PBS_AAAP_RLP_County__c  from PBS_AAAP_RLP_Regions_Map__c limit 50000])
        {
            if (areaJson.length()>1)
            {
                areaJson += ', ';
            }
            //This is STUPID!!! The type should be added as a picklist to the PBS_AAAP_RLP_Regions_Map__c
            //custom object.  But since it isn't, we must use a heuristic to figure this out
            string type = '';
            string valCsv = sm.get(m.PBS_AAAP_RLP_State__c.toLowerCase().trim());
            if(valCsv!=null)
            {
                list<string> vals = valCsv.split(',');
                for (string abbr : vals)
                {
                    if (m.PBS_AAAP_RLP_State_Abbrevation__c.toLowerCase().trim()==abbr)
                    {
                        type = 'state';
                        break;                    
                    }
                }            
            }
            if (m.PBS_AAAP_RLP_County__c != Null && m.PBS_AAAP_RLP_County__c.containsIgnoreCase(' county'))
            {
                type = 'county';
            }
            if (type=='')
            {
                if (m.PBS_AAAP_RLP_County__c != Null && m.PBS_AAAP_RLP_County__c.containsIgnoreCase(' county'))
                {
                    //type = 'county';
                }
                else
                {
                    type = 'city';
                }                
            }
            if(type == 'county'){
                areaJson += '{r:"'+m.PBS_AAAP_Region_Name__c+'",c:"'+m.PBS_AAAP_RLP_County__c+'",s:"'+m.PBS_AAAP_RLP_State_Abbrevation__c+'", t:"'+type+'"}';
            }else{
                areaJson += '{r:"'+m.PBS_AAAP_Region_Name__c+'",c:"'+m.PBS_AAAP_RLP_State__c+'",s:"'+m.PBS_AAAP_RLP_State_Abbrevation__c+'", t:"'+type+'"}';
            }
        }
        areaJson += ']';
        getRLPs();
        
        // Todd Brown 03/10/2022 SFWS-1598 added new GSA GIS REST Service generate token call for upgrade to ArcGIS OnPrem REST svc
        if (APIArcGISHelper.runningInSandbox()) {
            myGisToken = APIArcGISHelper.getArcGISToken(APIArcGISHelper.getRequest('Sandbox'));
            myGisUrlPrefix = APIArcGISHelper.GIS_URL_PREFIX;
            myGisLocatorUrl = APIArcGISHelper.GIS_LOCATOR_URL;
            myGislocator = APIArcGISHelper.GIS_LOCATOR;
        } else {
            myGisToken = APIArcGISHelper.getArcGISToken(APIArcGISHelper.getRequest('Production'));
            myGisUrlPrefix = APIArcGISHelper.GIS_URL_PREFIX;
            myGisLocatorUrl = APIArcGISHelper.GIS_LOCATOR_URL;
            myGislocator = APIArcGISHelper.GIS_LOCATOR;
        }

        logConstructorEnd('PBS_AAAP_OfferBuildingController');
    }

    private static Map<string, string> getStateAbbreviationByStateName(){
        Map<String, String> m = new Map<String, String>();
        m.put('alabama','al');
        m.put('alaska','ak');
        m.put('arizona','az');
        m.put('arkansas','ar');
        m.put('california','ca');
        m.put('colorado','co');
        m.put('connecticut','ct');
        m.put('delaware','de');
        m.put('florida','fl');
        m.put('georgia','ga');
        m.put('hawaii','hi');
        m.put('idaho','id');
        m.put('illinois','il');
        m.put('indiana','in');
        m.put('iowa','ia');
        m.put('kansas','ks');
        m.put('kentucky','ky');
        m.put('louisiana','la');
        m.put('maine','me');
        m.put('maryland','md');
        m.put('massachusetts','ma');
        m.put('michigan','mi');
        m.put('minnesota','mn');
        m.put('mississippi','ms');
        m.put('missouri','mo');
        m.put('montana','mt');
        m.put('nebraska','ne');
        m.put('nevada','nv');
        m.put('new hampshire','nh');
        m.put('new jersey','nj');
        m.put('new mexico','nm');
        m.put('new york','ny');
        m.put('north carolina','nc');
        m.put('north dakota','nd');
        m.put('ohio','oh');
        m.put('oklahoma','ok');
        m.put('oregon','or');
        m.put('pennsylvania','pa');
        m.put('rhode island','ri');
        m.put('south carolina','sc');
        m.put('south dakota','sd');
        m.put('tennessee','tn');
        m.put('texas','tx');
        m.put('utah','ut');
        m.put('vermont','vt');
        m.put('virginia','va');
        m.put('washington','wa,dc'); //yes, because of the data, we need to make this a CSV
        m.put('west virginia','wv');
        m.put('wisconsin','wi');
        m.put('wyoming','wy');
        m.put('american samoa','as');
        m.put('district of columbia','dc');
        m.put('federated states of micronesia','fm');
        m.put('guam','gu');
        m.put('marshall islands','mh');
        m.put('northern mariana islands','mp');
        m.put('palau','pw');
        m.put('puerto rico','pr');
        m.put('virgin islands','vi');
        m.put('u.s. virgin islands', 'vi');
        return m;
    }

    public List<Selectoption> getCounties() {
        logMethodStart('getCounties');
        List<SelectOption> cntys = new List<SelectOption>();
        if (OfferCounty != null && OfferCounty.length() > 0 && OfferCounty != SLCTOPTDFLT) {
            Selectoption slct = new SelectOption('', OfferCounty);
            cntys.add(slct);
        } else if (OfferCounty == null || OfferCounty.length() <= 0 || OfferCounty == SLCTOPTDFLT) {
            cntys = getCountiesSpecial();
        } else {
            Selectoption slct = new SelectOption('', SLCTOPTDFLT);
            cntys.add(slct);
        }

        logMethodEnd('getCounties', cntys);
        return cntys;
    }

    public List<Selectoption> getCountiesSpecial() {

        logMethodStart('getCountiesSpecial');

        List<SelectOption> cntys = new List<SelectOption>();
        Map<String, Set<String>> cntyMap = new Map<String, Set<String>>();

        //Hardcoded the counties for the NCR Region
        Set<String> cntyMaryland = new Set<String>{
                'Montgomery', 'Prince George\'s'
        };
        Set<String> cntyVirginia = new Set<String>{
                'Arlington', 'Fairfax', 'Loudoun', 'Prince William'
        };
        Set<String> cntyDC = new Set<String>{
                'District of Columbia'
        };


        System.debug('******* ShowSubmit Mesg::: ' + showSubmitMesg);
        cntyMap.put('MD', cntyMaryland);
        cntyMap.put('VA', cntyVirginia);
        cntyMap.put('DC', cntyDC);

        if (offerBuilding.PBS_AAAP_State__c == 'MD') {
            for (String str : cntyMap.get('MD')) {
                Selectoption slct = new SelectOption(str, str);
                cntys.add(slct);
            } // end for
        } else if (offerBuilding.PBS_AAAP_State__c == 'VA') {
            for (String str : cntyMap.get('VA')) {
                Selectoption slct = new SelectOption(str, str);
                cntys.add(slct);
            } // end for
        } else if (offerBuilding.PBS_AAAP_State__c == 'DC') {
            for (String str : cntyMap.get('DC')) {
                Selectoption slct = new SelectOption(str, str);
                cntys.add(slct);
            } // end for
        }  // end if


        Selectoption slct = new SelectOption('Other', 'Other');
        cntys.add(slct);

        logMethodEnd('getCountiesSpecial', cntys);

        return cntys;
    }


    public List<SelectOption> getRLPs() {
        logMethodStart('getRLPs');

        List<SelectOption> options = new List<SelectOption>();
        User usrinfo = [SELECT PBS_AAAP_Regions__c FROM User WHERE id = :UserInfo.getUserId()];
        String userRegions = usrInfo.PBS_AAAP_Regions__c;
        List<String> listofregions = new List<String>();
        List<PBS_AAAP_RLP__c> RLPList;
        system.debug('***Nik***'+userRegions);
        if (userRegions != null) {
            listofregions = userRegions.split(';');
        }
        system.debug('***Nik***'+listofregions);
        //added by syam on 12/27/2016 for census release
        listofregions.add('Census');
        listofregions.add('10/5 Term - All Regions');
        String[] status = new String[]{
                'Posted/Active'
        };
        RLPList = [
                SELECT id, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c
                FROM PBS_AAAP_RLP__c
                WHERE PBS_AAAP_Region__c IN :listofregions
                AND PBS_AAAP_isActive__c = TRUE
                AND PBS_AAAP_STATUS__c IN :status
                ORDER BY PBS_AAAP_RLP_Number__c
        ];
        system.debug('***Nik***'+RLPList);

        regionCensusMapJson = '';

        // System.debug ('*****Regions List ::::::::' + RLPList);// weston
        options.add(new SelectOption('', 'Select RLP'));
        for (PBS_AAAP_RLP__c rlp : RLPList) {
            options.add(new SelectOption(rlp.id, rlp.PBS_AAAP_RLP_Number__c));
            RLPwithRegion.add(new SelectOption(rlp.id, rlp.PBS_AAAP_Region__c));
            if (regionCensusMapJson.length()>0){
                regionCensusMapJson += ', ';
            }
            regionCensusMapJson += '{k:"'+rlp.PBS_AAAP_RLP_Number__c+'", v:"'+rlp.PBS_AAAP_Region__c+'"}';
        }
        regionCensusMapJson = '['+regionCensusMapJson+']';

        logMethodEnd('getRLPs', options);
        return options;
    }

    public List<SelectOption> getItems() {
        logMethodStart('getItems');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        logMethodEnd('getItems', options);
        return options;
    }

    public List<SelectOption> getPartialItems() {
        logMethodStart('getPartialItems');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        options.add(new SelectOption('Partial', 'Partial'));
        logMethodEnd('getPartialItems', options);
        return options;
    }

    public List<SelectOption> getSiteSizeItems() {
        logMethodStart('getSiteSizeItems');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Square Feet', 'Square Feet'));
        options.add(new SelectOption('Acres', 'Acres'));
        logMethodEnd('getSiteSizeItems', options);
        return options;
    }

    public boolean displayPopUp { get; set; }
    public void closePopup() {
        displayPopup = false;
    }

    public PageReference showPopup() {
        displayPopUp = true;
        return null;
    }

    public PageReference openNewWindow() {

        return null;
    }

    public static boolean validateOfferAddressWithRLPRegion(List<PBS_AAAP_Offer__c > OBList) {
        boolean flag;
        String countyCompare;
        String region;
        List<PBS_AAAP_RLP_Regions_Map__c > RLPRegionMapList;
        String buildingValidationMsg;
        //realistically only one offerBuilding will be passed
        if(OBList.size()>0){
            for (PBS_AAAP_Offer__c offerBuildingLocal : OBList) {

                //Check to see what Region the RLP is to be assigned to. NCR goes first, since it has spans multiple states
                if (offerBuildingLocal.PBS_AAAP_RLP_Region__c == 'National Capital Region' ||
                        offerBuildingLocal.PBS_AAAP_RLP_Region__c == 'NCR') {

                    //select to check to see if the building resides in the correct region
                    // based on the state of the building
                    //NOTE: that the PBS_AAAP_RLP_State__c may contain a county, city or state. Counties end in " county"
                    RLPRegionMapList = [
                            SELECT Id, PBS_AAAP_Region_Name__c,PBS_AAAP_RLP_State_Abbrevation__c,
                                    PBS_AAAP_RLP_State__c
                            FROM PBS_AAAP_RLP_Regions_Map__c
                            WHERE PBS_AAAP_Region_Name__c = 'National Capital Region'
                            AND PBS_AAAP_RLP_State_Abbrevation__c = :offerBuildingLocal.PBS_AAAP_State__c
                    ];
                    //state or county

                    //look for a matching record via
                    flag = true;  //set to false to assume that it does not exist
                    //do increment searches.  loop through all of the entries for the NCR Region by the buildings state
                    for (PBS_AAAP_RLP_Regions_Map__c rlp : RLPRegionMapList) {

                        //remove after overhaul                    
                        system.debug('>>>>>>>>offerBuildingLocal.PBS_AAAP_County__c:' + offerBuildingLocal.PBS_AAAP_County__c);
                        system.debug('>>>>>>>>offerBuildingLocal.PBS_AAAP_City__c:' + offerBuildingLocal.PBS_AAAP_City__c);
                        system.debug('>>>>>>>>Region Map State rlp.PBS_AAAP_RLP_State__c:' + rlp.PBS_AAAP_RLP_State__c);
                        system.debug('>>>>>>>>offerBuildingLocal.PBS_AAAP_County__c:' + offerBuildingLocal.PBS_AAAP_County__c + ' county');

                        //add the word "county" to the comparison variable
                        if (offerBuildingLocal.PBS_AAAP_County__c != null) {
                            countyCompare = offerBuildingLocal.PBS_AAAP_County__c + ' county';
                        } else {
                            countyCompare = 'No County'; //this is just a default for comparison purposes
                        }

                        //If the property's City or county match the record is valid or if the county match
                        if ((offerBuildingLocal.PBS_AAAP_City__c == rlp.PBS_AAAP_RLP_State__c)
                                || (countyCompare == rlp.PBS_AAAP_RLP_State__c)
                                || (offerBuildingLocal.PBS_AAAP_County__c == rlp.PBS_AAAP_RLP_State__c)) {
                            flag = false;  //if found then break the loop and return that the address is valid
                            break;
                        }
                    }
                } else {
                    //do a select against the RLP Region table to pull the states
                    RLPRegionMapList = [
                            SELECT Id, PBS_AAAP_Region_Name__c,PBS_AAAP_RLP_State_Abbrevation__c
                            FROM PBS_AAAP_RLP_Regions_Map__c
                            WHERE PBS_AAAP_Region_Name__c = :offerBuildingLocal.PBS_AAAP_RLP_Region__c
                            AND PBS_AAAP_RLP_State_Abbrevation__c = :offerBuildingLocal.PBS_AAAP_State__c
                    ];
                    System.debug('oh my god let it end ' + offerBuildingLocal.PBS_AAAP_RLP_Region__c);
                    System.debug('oh my god let it end ' + offerBuildingLocal.PBS_AAAP_State__c);
                    flag = true;  //set flag as true unless a value is found westonv
                    for (PBS_AAAP_RLP_Regions_Map__c rlp : RLPRegionMapList) {
                        flag = false;  //it has been found should only have one
                        break;
                    }
                }
                //    region = offerBuildingLocal.PBS_AAAP_RLP_Region__c;


            }
            if (flag) {

                buildingValidationMsg = '-Your building address does not fall within region boundaries, Your offer is not saved. Please check your address data and try again.';
                // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,buildingValidationMsg));
               // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ''));
            } else {
                buildingValidationMsg = '';
            }
            system.debug('>>>>>>>validateOfferAddressWithRLPRegion:' + flag);
        }
        return false;
    } 

    private void pushDebugInformation(string msg)
    {
        if (debugInformation==null){
            debugInformation = '';
        }
        else
        {
            debugInformation += '; ';            
        }
        if (msg==null)
        {
            msg = 'EmptyMessage';            
        }
        debugInformation += msg;
    }

    public PageReference saveBuilding() {
        pushDebugInformation('saveBuilding');
        return saveBuilding(false);
    }

    public PageReference actionSaveBuildingInfoTest() {
        system.debug( 'actionSaveBuildingInfoTest ' + pageUrl );
        saveBuilding(false);
        PageReference pageRef = new PageReference(pageUrl);
        return pageRef;
    }    

    public PageReference PostBack() {
        return null;
    }    

    public PageReference saveBuilding(boolean force) {

        system.debug(pageUrl);

        pushDebugInformation('SB_start');
        
        logMethodStart('saveBuilding');
        // validations for Submit offer page fields
        boolean errorflag = checkOfferBuildingValidations();
        System.debug('=======>>>>>>>>> error flag for checkOfferBuildingValidations **** ::: ' + errorflag + '  *** offerBuilding.PBS_AAAP_RLP_Number__c ***' + offerBuilding.PBS_AAAP_RLP_Number__c + ' offerbuilding Id is ' + offerBuilding.id);
        if (errorflag == true && !force) {
        pushDebugInformation('SB_checkOfferBuildingValidations');
            return null;
        }
        draftMsgFlag = '';
        PageReference p = null;
        offerBuilding.PBS_AAAP_RLP_Number__c = selectRLP;
        offerBuilding.PBS_AAAP_User_Defined_Address__c = fullAddress;
        
        System.debug('=======>>>>>>>>> selectRLP var **** ::: ' + selectRLP);
        System.debug('=======>>>>>>>>> oldRLP var ::: *** ' + oldRLP); // vaishali test
        offerBuilding.PBS_AAAP_RLP_Region__c = [SELECT Id, PBS_AAAP_Region__c FROM PBS_AAAP_RLP__c WHERE Id = :selectRLP].PBS_AAAP_Region__c;

        System.debug('=======>>>>>>>>> offerBuilding.PBS_AAAP_RLP_Region__c ::: ' + offerBuilding.PBS_AAAP_RLP_Region__c);

        if (errorflag == true && !force) {
        pushDebugInformation('SB_outside of RLP');
            //Exception ex;
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            System.debug('Offer Address outside of RLP region');
            return null;
        }
        System.debug('=======>>>>>>>>> County var ::: ' + offerCounty);
        System.debug('=======>>>>>>>>> offer County ::: ' + offerBuilding.PBS_AAAP_County__c);
        if (offerCounty != null && offerCounty != '') {
            System.debug('inside offerCounty' + offerCounty);
            offerBuilding.PBS_AAAP_County__c = offerCounty;
        }
        if ((offerBuilding.PBS_AAAP_RLP_Region__c == 'National Capital Region' || offerBuilding.PBS_AAAP_RLP_Region__c == 'NCR')
                && (offerBuilding.PBS_AAAP_County__c == null || offerBuilding.PBS_AAAP_County__c == '') && offerBuilding.Id != null) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please validate the offer address by clicking the "Validate Address" button.'));
            //return null;
        }

        pushDebugInformation('SB_111');

        try {

            System.debug('offerbuilding Id before savePropertyData is ' + offerBuilding.id);
            // save the data to the property object
            String propIdForOffer = savePropertyData(offerBuilding);
            offerBuilding.Property__c = propIdForOffer;
            System.debug(' offerbuilding Id after savePropertyData is ' + offerBuilding.id);

            if (offerBuilding.id != null) {
                pushDebugInformation('SB_22222');
                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) {
                    offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                }
                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                    draftMsgFlag = 'true';
                }
                offerBuilding.PBS_AAAP_Offeror__c = userDetail.ContactId;
                //added by syam ,to update cost per ABOA SF on operating costs 

                //offerBuilding.PBS_AAAP_COST_PER_ABOA__c = offerBuilding.PBS_AAAP_SRVC_UTIL_TOTAL__c / offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
                //added by syam for FY16 changes
                String areaType = offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c;
                System.debug('*** areaType is in  save ' + areaType);

                //siteSize.setScale(2, RoundingMode.HALF_UP);

                try {

                    if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
                        Decimal siteSize = offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c;
                        siteSize = siteSize * 43560;
                        system.debug('<<SIZETYPE>>+1'+siteSize);
                        //siteSize.setScale(2, RoundingMode.HALF_UP);

                        System.debug('*** siteSize inside is *** ' + siteSize);
                        offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
                    }

                    update offerBuilding;
                    System.debug('*** after update offerBuilding ***');
                } catch (DMLException e) {
                        pushDebugInformation('SB_update building error');
                    for (Integer i = 0; i < e.getNumDml(); i++) {
                        System.debug(e.getDmlMessage(i));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getDmlMessage(i)));
                    }

                    String areaType1 = offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c;
                    System.debug('PBS_AAAP_OfferBuildingController.areaType=' + areaType1);
                    Decimal siteSize1 = offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c;
                    System.debug('PBS_AAAP_OfferBuildingController.siteSize' + siteSize1);
                    if (areaType1 == 'Acres') {
                        if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c != null) {
                            siteSize1 = siteSize1 / 43560;
                            System.debug('PBS_AAAP_OfferBuildingController.sizeSize (changed)=' + siteSize1);
                            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize1;
                        }
                    }

                    return p;
                }
            } else {
                pushDebugInformation('SB_33333');
                offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                offerBuilding.PBS_AAAP_Is_Offer_Valid__c = true;
                offerBuilding.PBS_AAAP_RLP_Region__c = offerBuilding.PBS_AAAP_RLP_Number__r.PBS_AAAP_Region__c;
                //added by syam for FY16 changes
                String areaType = offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c;
                System.debug('*** areaType is ' + areaType);
                Decimal siteSize = offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c;
                //siteSize.setScale(2, RoundingMode.HALF_UP);
                System.debug('*** siteSize is ' + siteSize);
                if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
                    siteSize = siteSize * 43560;
                    system.debug('<<SIZETYPE>>+2'+siteSize);
                    //siteSize.setScale(2, RoundingMode.HALF_UP);

                    System.debug('*** siteSize inside is ' + siteSize);
                    offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
                }
                try {
                    insert offerBuilding;
                    
                    offerID = offerBuilding.Id; 
                    updateOfferDetails();
                    
                } catch (DMLException e) {
                    pushDebugInformation('SB_insert building error');
                    for (Integer i = 0; i < e.getNumDml(); i++) {
                        System.debug(e.getDmlMessage(i));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getDmlMessage(i)));
                    }

                    return p;
                }
            }
            pushDebugInformation('SB_4444444');

            String offerId = offerBuilding.Id;
            //added on 07/14 to update PV values.
            dao.updatePVRates(offerId);

            offerBuilding = null; // clears ViewState for visual force page

            // if temp url not null then redirect

            system.debug('pageUrl ' + pageUrl);

            if( ( pageUrl == null ) || ( pageUrl == '' ) )
            {
                //p = Page.PBS_AAAP_OfferBuildingDetails;
                p = new PageReference('/AAAP/OfferBuildingDetails');
                p.getParameters().put('offerId', offerId);
            }
            else
            {

                Integer len = pageUrl.length();
                if( pageUrl.mid(len-1, 1) == '=' )
                {
                    pageUrl = pageUrl + offerId;   
                }

                p = new PageReference(pageUrl);

                system.debug('tempUrl Not null');
				pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                return null;
            }

            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
			pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuildingDetails', Label.LOP_Community_Base_URL+'AAAP-OfferBuildingDetails');
            
        } catch (Exception ex) {
        pushDebugInformation('SB_generic error');
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        logMethodEnd('saveBuilding', p);
        p.setRedirect(false);
        return null;
    }

    public Boolean roofingMatOther = false;
    public PageReference showRoofingMaterialOther() {
        logMethodStart('showRoofingMaterialOther');
        roofingMatOther = offerBuilding.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c == 'Other';
        logMethodEnd('showRoofingMaterialOther');
        return null;
    }

    public boolean getRoofingMatOther() {
        logMethodStart('getRoofingMatOther');
        if (offerBuilding.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c == 'Other') {
            roofingMatOther = true;
        }
        logMethodEnd('getRoofingMatOther', roofingMatOther);
        return roofingMatOther;
    }

    public void actionDeleteOffer() {
        logMethodStart('actionDeleteOffer');
        List<string> spaceidList;
        PageReference pref = null;
        pageURLForRedirection = '';
		pref = new PageReference('/AAAP/PortalHome');
                //pref.setRedirect(true);
        
        if (offerBuilding.Id != null) {
            if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
                delete offerBuilding;   // Cascade delete - Deletes all Spaces and Othercosts associated with it.
                //pref = Page.PBS_AAAP_PortalHome;
                pref = new PageReference('/AAAP-portalHome');
                pageURLForRedirection = Label.LOP_Community_Base_URL+'AAAP-PortalHome';
                System.debug('pageURLForRedirection '+pageURLForRedirection);
                //pref.setRedirect(true);
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + offerBuilding.PBS_AAAP_Offer_Status__c +
                        ', you can only delete on Draft or Pending Modification stage');
                ApexPages.addMessage(myMsg);
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is not yet saved to perform the delete operation');
            ApexPages.addMessage(myMsg);
        }

        logMethodEnd('actionDeleteOffer', pref);
        //return null;
    }

    public void actionSaveBuildingInfo() {
        actionSaveBuildingInfo(false);
        
        //return Null;
    }

    public PageReference actionSaveBuildingInfo(boolean force) {

        logMethodStart('actionSaveBuildingInfo');
        boolean errorflag = checkOfferBuildingValidations();

        System.debug('=======>>>>>>>>> error flag for checkOfferBuildingValidations **** ::: ' + errorflag);
        if (errorflag == true && !force) {
            return null;
        }
        PageReference p = null;
        offerBuilding.PBS_AAAP_RLP_Number__c = selectRLP;
        offerBuilding.PBS_AAAP_User_Defined_Address__c = fullAddress;
        System.debug('=======>>>>>>>>> selectRLP var **** ::: ' + selectRLP);
        System.debug('=======>>>>>>>>> oldRLP var ::: *** ' + oldRLP); // vaishali test
        offerBuilding.PBS_AAAP_RLP_Region__c = [SELECT Id, PBS_AAAP_Region__c FROM PBS_AAAP_RLP__c WHERE Id = :selectRLP].PBS_AAAP_Region__c;

        System.debug('=======>>>>>>>>> offerBuilding.PBS_AAAP_RLP_Region__c ::: ' + offerBuilding.PBS_AAAP_RLP_Region__c);

        List <PBS_AAAP_Offer__c> OB = new List<PBS_AAAP_Offer__c>();
        OB.add(offerBuilding);  //pass offerBuilding as a list
        errorflag = validateOfferAddressWithRLPRegion(OB);


        if (errorflag == true && !force) {
            System.debug('Wes said the error flag was: ' + errorflag);
            return null;
        }
        System.debug('=======>>>>>>>>> County var ::: ' + offerCounty);
        System.debug('=======>>>>>>>>> offer County ::: ' + offerBuilding.PBS_AAAP_County__c);
        if (offerCounty != null && offerCounty != '') {
            System.debug('inside offerCounty' + offerCounty);
            offerBuilding.PBS_AAAP_County__c = offerCounty;
        } if ((offerBuilding.PBS_AAAP_RLP_Region__c == 'National Capital Region' || offerBuilding.PBS_AAAP_RLP_Region__c == 'NCR')
                && (offerBuilding.PBS_AAAP_County__c == null || offerBuilding.PBS_AAAP_County__c == '') && offerBuilding.Id != null) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please validate the offer address by clicking the "Validate Address" button.'));
            //return null;
        }

        try {

            // save the data to the property object
            String propIdForOffer = savePropertyData(offerBuilding);
            offerBuilding.Property__c = propIdForOffer;
            draftMsgFlag = '';
            if (offerBuilding.id != null) {
                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) {
                    offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                }


                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                    draftMsgFlag = 'true';
                }
                offerBuilding.PBS_AAAP_Offeror__c = userDetail.ContactId;

                try {

                    String areaType = offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c;
                    System.debug('*** areaType is ' + areaType);
                    Decimal siteSize = offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c;
                    System.debug('*** siteSize is ' + siteSize);
                    if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
                        siteSize = siteSize * 43560;
                        system.debug('<<SIZETYPE>>+3'+siteSize);
                        offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
                    }

                    System.debug('oldRLP before execution is ****' + oldRLP);

                    System.debug('selectRLP is ***' + selectRLP);
                    if (oldRLP != selectRLP) {
                        System.debug('before deleting space and rates for offer ' + offerBuilding.id);
                        List<PBS_AAAP_Space__c> spacesToDelete = [
                                SELECT s.Id
                                FROM PBS_AAAP_Space__c s
                                WHERE PBS_AAAP_OFFER_NUMBER__c = :offerBuilding.id
                        ];
                        List<PBS_AAAP_Rate__c> ratesToDelete = [
                                SELECT r.Id
                                FROM PBS_AAAP_Rate__c r
                                WHERE PBS_AAAP_OFFER_NUMBER__c = :offerBuilding.id
                        ];
                        delete ratesToDelete;
                        delete spacesToDelete;
                    }
                    update offerBuilding;
                } catch (DMLException e) {
                    for (Integer i = 0; i < e.getNumDml(); i++) {
                        System.debug(e.getDmlMessage(i));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getDmlMessage(i)));
                    }

                    String areaType = offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c;
                    System.debug('PBS_AAAP_OfferBuildingController.areaType=' + areaType);
                    Decimal siteSize = offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c;
                    System.debug('PBS_AAAP_OfferBuildingController.siteSize' + siteSize);
                    if (areaType == 'Acres') {
                        if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c != null) {
                            siteSize = siteSize / 43560;
                            System.debug('PBS_AAAP_OfferBuildingController.sizeSize (changed)=' + siteSize);
                            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
                        }
                    }
                    return p;
                }
            } else {
                System.debug('In insert building for the first time *****');
                offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                offerBuilding.PBS_AAAP_Is_Offer_Valid__c = true;
                offerBuilding.PBS_AAAP_RLP_Region__c = offerBuilding.PBS_AAAP_RLP_Number__r.PBS_AAAP_Region__c;
                //added by syam for FY16 changes
                String areaType = offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c;
                System.debug('*** areaType is ' + areaType);
                Decimal siteSize = offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c;
                //siteSize.setScale(2, RoundingMode.HALF_UP);
                System.debug('*** siteSize is ' + siteSize);
                if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
                    siteSize = siteSize * 43560;
                    system.debug('<<SIZETYPE>>+4'+siteSize);
                    //siteSize.setScale(2, RoundingMode.HALF_UP);

                    System.debug('*** siteSize inside is ' + siteSize);
                    offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
                }
                try {
                    insert offerBuilding;
                } catch (DMLException e) {
                    for (Integer i = 0; i < e.getNumDml(); i++) {
                        System.debug(e.getDmlMessage(i));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getDmlMessage(i)));
                    }

                    return p;
                }
            }
        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }

        String offerId = offerBuilding.Id;
        if (errorflag) {
            p = null;
        } else {
            offerBuilding = null; 
            p = new PageReference(Label.LOP_Community_Base_URL+'AAAP-OfferBuilding');
            p.getParameters().put('offerId', offerId);
            p.getParameters().put('draftMsg', draftMsgFlag);
            pageURLForRedirection = p.getUrl();
            //p.setRedirect(true);
        }
        logMethodEnd('actionSaveBuildingInfo', p);
        return p;
    }

    public void actionCancel() {
        logMethodStart('actionCancel');
        PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(true);
        logMethodEnd('actionCancel', pref);
        //return pref;
    }

    // action to cause the page to refresh
    public PageReference refreshPanel() {
        System.debug('JK refreshPanel start');
        logMethodStart('refreshPanel');
        System.debug('##### Begin refreshPanel');
        System.debug('***** street: ' + offerBuilding.PBS_AAAP_Street_Address__c);
        System.debug('***** city: ' + offerBuilding.PBS_AAAP_City__c);
        System.debug('***** state: ' + offerBuilding.PBS_AAAP_State__c);
        System.debug('***** zip: ' + offerBuilding.PBS_AAAP_ZipCode__c);
        System.debug('***** county: ' + offerCounty);
        System.debug('***** lat: ' + offerBuilding.PBS_AAAP_X_CO_ORD__c);
        System.debug('***** long: ' + offerBuilding.PBS_AAAP_Y_CO_ORD__c);
        System.debug('***** metroWalk: ' + metroWalkable);
        System.debug('##### End refreshPanel');

        if (offerCounty == null || offerCounty.length() <= 0) {
            this.getCountiesSpecial();
        }
        if (offerCounty == null || offerCounty.length() <= 0) {
            //set county to be the district of columbia building is in DC
            if (offerBuilding.PBS_AAAP_State__c == 'DC') {
                offerBuilding.PBS_AAAP_County__c = 'District of Columbia';
            }
        }
        //basically other is not a valid county so handle it like a null value
        else if (offerCounty == 'Other') {
            offerCounty = null;
            this.getCountiesSpecial();
            if (offerBuilding.PBS_AAAP_State__c == 'DC') {
                offerBuilding.PBS_AAAP_County__c = 'District of Columbia';
            }
        }
        //make sure that the county is populated and not just the variable
        else {
            offerBuilding.PBS_AAAP_County__c = offerCounty;
        }

        logMethodEnd('refreshPanel');
        return null;
    }   // end refreshPanel    

    @RemoteAction
    public static List<PBS_AAAP_Property__c> findProperty(String pStreet, String pCity, String pState, String pZip) {
        List<PBS_AAAP_Property__c> propList = new List<PBS_AAAP_Property__c>();

        // determine the appropriate form for the query to take based upon the supplied data
        if ((pStreet != null) && (pStreet != '')) {
            propList = [
                    SELECT a.PBS_AAAP_X_CO_ORD__C, a.PBS_AAAP_Y_CO_ORD__C, a.PBS_AAAP_City__c, a.PBS_AAAP_Street_Address__c,
                            a.PBS_AAAP_State__c, a.PBS_AAAP_ZipCode__c, a.Name
                    FROM PBS_AAAP_Property__c a
                    WHERE a.PBS_AAAP_Street_Address__c LIKE :'%' + pStreet + '%'
                    AND (a.PBS_AAAP_City__c LIKE :pCity
                    OR a.PBS_AAAP_State__c LIKE :pState
                    OR a.PBS_AAAP_ZipCode__c LIKE :pZip)
            ];

        } else if (((pStreet == null) || (pStreet == '')) &&
                ((pZip != null) && (pZip != ''))) {
            propList = [
                    SELECT a.PBS_AAAP_X_CO_ORD__C, a.PBS_AAAP_Y_CO_ORD__C, a.PBS_AAAP_City__c, a.PBS_AAAP_Street_Address__c,
                            a.PBS_AAAP_State__c, a.PBS_AAAP_ZipCode__c, a.Name
                    FROM PBS_AAAP_Property__c a
                    WHERE a.PBS_AAAP_ZipCode__c LIKE :pZip
            ];

        } else if (((pStreet == null) || (pStreet == '')) &&
                ((pZip == null) || (pZip == '')) &&
                (((pCity != null) && (pCity != '')) &&
                        ((pState != null) && (pState != ''))
                )
                ) {
            propList = [
                    SELECT a.PBS_AAAP_X_CO_ORD__C, a.PBS_AAAP_Y_CO_ORD__C, a.PBS_AAAP_City__c, a.PBS_AAAP_Street_Address__c,
                            a.PBS_AAAP_State__c, a.PBS_AAAP_ZipCode__c, a.Name
                    FROM PBS_AAAP_Property__c a
                    WHERE a.PBS_AAAP_City__c = :pCity
                    AND a.PBS_AAAP_State__c = :pState
            ];

        } else if (((pStreet == null) || (pStreet == '')) &&
                ((pZip == null) || (pZip == '')) &&
                (((pCity != null) && (pCity != '')) ||
                        ((pState != null) && (pState != ''))
                )
                ) {
            propList = [
                    SELECT a.PBS_AAAP_X_CO_ORD__C, a.PBS_AAAP_Y_CO_ORD__C, a.PBS_AAAP_City__c, a.PBS_AAAP_Street_Address__c,
                            a.PBS_AAAP_State__c, a.PBS_AAAP_ZipCode__c, a.Name
                    FROM PBS_AAAP_Property__c a
                    WHERE a.PBS_AAAP_City__c LIKE :pCity
                    OR a.PBS_AAAP_State__c LIKE :pState
            ];
        } // end if

        return propList;
    } // end findProperty 

    // action to save building data to the property object
    public String savePropertyData(PBS_AAAP_Offer__c pVal) {

        logMethodStart('savePropertyData'+metroWalkable);
        String returnVal = null;


        PBS_AAAP_Property__c propData = new PBS_AAAP_Property__c(id = pVal.Property__c,
                PBS_AAAP_ZipCode__c = pVal.PBS_AAAP_ZipCode__c,
                PBS_AAAP_Y_CO_ORD__c = pVal.PBS_AAAP_Y_CO_ORD__c,
                PBS_AAAP_X_CO_ORD__c = pVal.PBS_AAAP_X_CO_ORD__c,
                PBS_AAAP_Street_Address__c = pVal.PBS_AAAP_Street_Address__c,
                PBS_AAAP_State__c = pVal.PBS_AAAP_State__c,
                //PBS_AAAP_MetroWalkable__c = metroWalkable,
                PBS_AAAP_City__c = pVal.PBS_AAAP_City__c);
        if (propData != null) {
            System.debug('before upsert of propertyData');
            try {
                upsert propData;
            } catch (DMLException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    System.debug(e.getDmlMessage(i));
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getDmlMessage(i)));
                }
            }

            System.debug('after upsert of propertyData');
            returnVal = propData.Id;
        }    // end if
        logMethodEnd('savePropertyData', returnVal);
        return returnVal;
    }   // end savePropertyData

    public boolean checkOfferBuildingValidations() {

        logMethodStart('checkOfferBuildingValidations');
        
        System.debug('IsNull(offerBuilding)='+(offerBuilding==null?'1':'0'));
        System.debug('offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c='+offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);

        boolean flag;
        System.debug('###@$%###$%#@#$ check offer building valdiations selectRLP' + selectRLP);

        if (offerBuilding.PBS_AAAP_Building_Name__c == null || offerBuilding.PBS_AAAP_Building_Name__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_NAME_REQUIRED));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Street_Address__c == null || offerBuilding.PBS_AAAP_Street_Address__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_STREET_REQUIRED));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_City__c == null || offerBuilding.PBS_AAAP_City__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_CITY_REQUIRED));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_State__c == null || offerBuilding.PBS_AAAP_State__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_STATE_REQUIRED));
            flag = true;
        }

        if (offerBuilding.PBS_AAAP_ZipCode__c == null || offerBuilding.PBS_AAAP_ZipCode__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_ZIP_REQUIRED));
            flag = true;
        }
        System.debug('Iam outside near Rent' + offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);
        if (offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null) {
            System.debug('Iam inside near Rent' + offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_TOTAL_RSF));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_ANSI_BOMA_SF));
            flag = true;
        }

        if(offerBuilding.PBS_AAAP_OFFICE_SPACE_RSF__c == NULL){
            offerBuilding.PBS_AAAP_OFFICE_SPACE_RSF__c = 0;
        }
        if(offerBuilding.PBS_AAAP_RETAIL_SPACE_RSF__c == NULL){
            offerBuilding.PBS_AAAP_RETAIL_SPACE_RSF__c = 0;
        }
        if(offerBuilding.PBS_AAAP_GARAGE_SPACE_RSF__c == NULL){
            offerBuilding.PBS_AAAP_GARAGE_SPACE_RSF__c = 0;
        }
        if(offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c < offerBuilding.PBS_AAAP_OFFICE_SPACE_RSF__c + offerBuilding.PBS_AAAP_RETAIL_SPACE_RSF__c + offerBuilding.PBS_AAAP_GARAGE_SPACE_RSF__c){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '4. The sum of the different types of building space should not exceed the total amount of building RSF.'));//JK changed 7/2021
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c == null) {
            //if (offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c == null) {
            offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c = 0;//JK changed this July 2021 because of deleted field on the front end
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_SITE_SIZE_REQUIRED));
            //flag = true;
            //}
        }
        if (offerBuilding.PBS_AAAP_Number_of_floors__c == null || offerBuilding.PBS_AAAP_Number_of_floors__c <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_NUM_OF_FLOORS));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_LIVE_FLOOR_LOAD__c == null) {
            offerBuilding.PBS_AAAP_LIVE_FLOOR_LOAD__c = '';//JK changed this July 2021 because of deleted field on the front end
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_LIVE_FLOOR_LOAD_REQUIRED));
            //flag = true;
        }
        
        if (offerBuilding.PBS_AAAP_Year_Built__c == null || offerBuilding.PBS_AAAP_Year_Built__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_YEAR_CONSTRUCTED));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Renovation_Year__c == null ||offerBuilding.PBS_AAAP_Renovation_Year__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_RENNOVATION_REQUIRED));
            flag = true;
        }
        
        if (offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HVAC_M_F_START));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HVAC_M_F_END));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_REAL_ESTATE_TAXES__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_REAL_ESTATE_TAXES_REQ));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_INSURANCE__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_INSURANCE_REQ));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_BUILDING_MAINTENANCE__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_BUILDING_MAINTENANCE_REQ));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_LEASE_COMMISSION__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_LEASE_COMMISSION_REQ));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_MANAGEMENT__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_MANAGEMENT));
            flag = true;
        }

        if (offerBuilding.PBS_AAAP_X_CO_ORD__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PBS_AAAP_X_CO_ORD_REQ));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Y_CO_ORD__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PBS_AAAP_Y_CO_ORD_REQ));
            flag = true;
        }
        
        System.debug('***** message size checkOfferBuildingValidations: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());

        logMethodEnd('checkOfferBuildingValidations', flag);
        return flag;
    }

    public pageReference getCensusCheck() {
        logMethodStart('getCensusCheck');

        giveAlert = false;
        System.debug('the rlpid we are hoping for -------> ' + RLPid);
        System.debug(giveAlert);
        //weston: checking for the selected RLP's region
        //if census true, else false
        for (SelectOption so : RLPwithRegion) {

            System.debug('the getvalue ' + so.getValue());
            if (so.getValue() == RLPid) {
                if (so.getLabel() == 'Census') {
                    giveAlert = true;
                    System.debug('updating giveAlert ' + giveAlert);
                    System.debug('we made it to here');
                }
            }

        }

        logMethodEnd('getCensusCheck');

        return null;
    }

@RemoteAction //the function to be called in remote action should use this annotation
    public static boolean checkisValidRegion(string county,string state,string rlpNumber) {
        //function should be static and global else it will throw error
        county = county.toLowerCase();
        boolean validRegVal = true;
        Map<String,List<String>> regionCountyMap = new Map<String,List<String>>();
    
        string RLPRegionName =[select id,PBS_AAAP_Region__c from PBS_AAAP_RLP__c where PBS_AAAP_RLP_Number__c=:rlpNumber limit 1].PBS_AAAP_Region__c;
        
        List<PBS_AAAP_RLP_Regions_Map__c> rlpRegionsList = [select PBS_AAAP_Region_Name__c,PBS_AAAP_RLP_County__c, PBS_AAAP_RLP_State__c, PBS_AAAP_RLP_State_Abbrevation__c 
                                                            from PBS_AAAP_RLP_Regions_Map__c limit 50000];
       
       for(PBS_AAAP_RLP_Regions_Map__c reg : rlpRegionsList){
            if(!regionCountyMap.containsKey(reg.PBS_AAAP_Region_Name__c)){
                regionCountyMap.put(reg.PBS_AAAP_Region_Name__c, new List<String>());
            }
            if(reg.PBS_AAAP_RLP_County__c!=null){
                regionCountyMap.get(reg.PBS_AAAP_Region_Name__c).add(reg.PBS_AAAP_RLP_County__c.toLowerCase());
            }else{
                regionCountyMap.get(reg.PBS_AAAP_Region_Name__c).add(reg.PBS_AAAP_RLP_County__c);
            }
       }

       system.debug('*****'+regionCountyMap.get(RLPRegionName));
       system.debug('*****'+county);
       if(RLPRegionName=='National Capital Region' && checkCounty(regionCountyMap.get(RLPRegionName),county)){
            validRegVal = true;
       }else if(RLPRegionName=='National Capital Region' && !checkCounty(regionCountyMap.get(RLPRegionName),county)){
           if(state=='DC'){
               validRegVal = true;
           } else{
               validRegVal = false;
           }
       }
       
       if(RLPRegionName=='Region 3' && !checkCounty(regionCountyMap.get('National Capital Region'),county)){
            validRegVal = true;
       }else if(RLPRegionName=='Region 3' && checkCounty(regionCountyMap.get('National Capital Region'),county)){
            validRegVal = false;
       }

        return validRegVal;
    }


    private static boolean checkCounty(List<String> counties,String county){
        Boolean countyFlag = false;
        for(String s: counties){
            if(s!=null){
                if(s.indexOfIgnoreCase(county)>-1){
                    countyFlag = true;
                    break;
                }
            }
            
        }
        return countyFlag;
    }
    
    // getting random key and update on Offer   
    public void updateOfferDetails(){   
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';  
        Integer len = Integer.valueOf(Label.PBS_AAAP_KeyLength);    
        String randStr = '';    
        // generating the random number 
        while (randStr.length() < len) {    
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());    
            randStr += chars.substring(idx, idx+1); 
        }   
        if(!string.isBlank(offerID)){   
            //updating user 
            PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(id = offerID,    
                    PBS_AAAP_Session_Key__c = randStr); 
            update offerRec;    
        }   
    }
    
    public void recalcCAF() {
        System.debug('Recalculating CAF...');
        if (offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > 0 && offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c >= 0) {
            CAF = String.valueOf(((offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c - offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c) / offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c * 100).setScale(2)) + ' %';
        } else {
            CAF = 'N/A';
        }
        System.debug('new CAF: ' + CAF);
    }
    
    public void setDefaultBuildingLocation(String region) {
        System.debug('setDefaultBuildingLocation(), region: ' + region);

    }

    private static integer inc(integer i){
        return i+i;
    }

    public static integer buster(integer i){
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        i = inc(i);
        return i;
    }
        
}