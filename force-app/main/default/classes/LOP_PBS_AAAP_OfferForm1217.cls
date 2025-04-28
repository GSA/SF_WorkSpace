//public with sharing class LOP_PBS_AAAP_OfferForm1217 extends PBS_AAAP_PageBaseController {//JK removed 12.1.2020
public class LOP_PBS_AAAP_OfferForm1217 extends PBS_AAAP_PageBaseController {

    public string folderId {get;set;}    
    transient public string strImageBlob {get;set;}
    transient public string strImagename {get;set;}
    
    public PBS_AAAP_Offer__c offer { get; set; }
    //public PBS_LOP_Offer__c lopoffer { get; set; }
    //public PBS_AAAP_RLP__c rlp { get; set; }
    //public List<PBS_AAAP_Other_Costs__c> othercosts {get;set;}
    public ID offerId { get; set; }
    public User userdetail { get; set; }
    public string formtype { get; set; }
    public string RLPNumber { get; set; }
    public String sysDate { get; set; }
    public string xownerType { get; set; }
    public string legalAgentType { get; set; }
    public string userName { get; set; }
    public boolean isValidUser { get; set; }
    // variables for offerform1217attachment (operating costs fields)
    public List<PBS_AAAP_Other_Costs__c> otherCostList = new List<PBS_AAAP_Other_Costs__c>();
    //public List<OtherCostsClass> otherCosts { get; set; }
    //public integer countsize { get; set; }
    public string offerCreatedBy { get; set; }

    // variables for offerform3518 (reps and certs fields)
    /**
    public string smallBusiness { get; set; }
    public string notsmallBusiness { get; set; }

    public string yes1A { get; set; }
    public string no1A { get; set; }
    public string yes1B { get; set; }
    public string no1B { get; set; }
    //*** Vaishali Start
    public string yes1B1 { get; set; }
    public string no1B1 { get; set; }
    public string yes1B2 { get; set; }
    public string no1B2 { get; set; }
    public string yes1B3 { get; set; }
    public string no1B3 { get; set; }
    public string yes1B4 { get; set; }
    public string no1B4 { get; set; }
    public string yes10 { get; set; }
    public string no10 { get; set; }
    public string yes11a { get; set; }
    public string no11a { get; set; }
    public string yes11b { get; set; }
    public string no11b { get; set; }
    public string WOSBNames { get; set; }
    public string EDWOSBNames { get; set; }

    //*** Vaishali End
    public string yes1C { get; set; }
    public string no1C { get; set; }
    public string yes1D { get; set; }
    public string no1D { get; set; }
    public string yes1E { get; set; }
    public string no1E { get; set; }
    public string yes1F { get; set; }
    public string no1F { get; set; }
    public string names1G { get; set; }
    public string yes1H { get; set; }
    public string no1H { get; set; }
    public string yes2 { get; set; }
    public string no2 { get; set; }
    public string yes2A { get; set; }
    public string no2A { get; set; }
    public string yes3 { get; set; }
    public string no3 { get; set; }
    public string yes3A { get; set; }
    //public string no2A {get;set;}
    public string name4b { get; set; }
    public string yes5 { get; set; }
    public string no5 { get; set; }
    public string yes6 { get; set; }
    public string no6 { get; set; }
    public string yes7 { get; set; }
    public string no7 { get; set; }
    public string yes8 { get; set; }
    public string no8 { get; set; }

    public string yesTINKnown { get; set; }
    public string TINNumber { get; set; }
    public string yesTINAppliedFor { get; set; }
    public string yesTINNotRequired { get; set; }
    public string TINReasonA { get; set; }
    public string TINReasonB { get; set; }
    public string TINReasonC { get; set; }
    public string SAMCertified { get; set; }

    public string soleproprietorship { get; set; }
    public string partnership { get; set; }
    public string corporateentitynottax { get; set; }
    public string govtentity { get; set; }
    public string foreigngovt { get; set; }
    public string internationalorg { get; set; }
    public string corporateentitytax { get; set; }
    public string other { get; set; }
    public string otherName { get; set; }

    public string commonParentYes { get; set; }
    public string commonParentName { get; set; }
    **/
    public string DUNSNumber { get; set; }
    /**
    public string commonParentNo { get; set; }

    public string activeYes { get; set; }
    public string activeNo { get; set; }

    // Variables for 1364 Attachment (Building Info)
    public string sprinkledYes { get; set; }
    public string sprinkledNo { get; set; }
    public string sprinkledPartially { get; set; }
    public string remotestairwelYes { get; set; }
    public string remotestairwelNo { get; set; }
    public string alarmYes { get; set; }
    public string alarmNo { get; set; }
    public string exteriorwall { get; set; }
    public string exteriorother { get; set; }
    public string roofingmaterial { get; set; }
    public string roofingother { get; set; }
    public string buildingRenovationYear { get; set; }
    public string metrorailYes { get; set; }
    public string metrorailNo { get; set; }
    public string metrorailName { get; set; }
    public string officeSpaceRSF { get; set; }
    public string retailSpaceRSF { get; set; }
    public string garageSpaceRSF { get; set; }
    public string officeSpacePercent { get; set; }
    public string retailSpacePercent { get; set; }
    public string garageSpacePercent { get; set; }
    public string totalRSF { get; set; }
    public string totalANSIBOMAMax { get; set; }
    public string totalANSIBOMAMin { get; set; }
    public string totalANSIBOMA { get; set; }
    public string totalANSIBOMABuilding { get; set; }
    public string totalParkingSpacesOffered { get; set; }
    public string totalfreeParkingSpaces { get; set; }
    public string garageReserved { get; set; }
    public string garageNonReserved { get; set; }
    public string surfacelotReserved { get; set; }
    public string surfacelotNonReserved { get; set; }
    public string optionParkingYes { get; set; }
    public string optionParkingNo { get; set; }
    public string optionParkingPartial { get; set; }
    public string annuallumpsum { get; set; }
    public string totalgarageparkingspaces { get; set; }
    public string SFOYes { get; set; }
    public string SFONo { get; set; }
    public string solicitationYes { get; set; }
    public string solicitationNo { get; set; }
    public string generalClauseYes { get; set; }
    public string generalClauseNo { get; set; }
    public string repsandcertsYes { get; set; }
    public string repsandcertsNo { get; set; }
    **/
    public string userType { get; set; }

//1217 fields 10/26/2016
    public string bldgName { get; set; }
    public string bldgStreet { get; set; }
    public string bldgCity { get; set; }
    public string bldgState { get; set; }
    public string bldgZip { get; set; }
    public string ownerName { get; set; }
    public string ownerMainPhone { get; set; }

//1217 Op Costs

    public string opCost3 { get; set; }
    public string opCost3a { get; set; }
    public string opCost3b { get; set; }
    public string opCost4 { get; set; }
    public string opCost5 { get; set; }
    public string opCost6 { get; set; }
    public string opCost7 { get; set; }
    public string opCost8 { get; set; }
    public string opCost9 { get; set; }
    public string opCost10 { get; set; }
    public string opCost11 { get; set; }
    public string opCost12 { get; set; }
    public string opCost13 { get; set; }
    public string opCost14 { get; set; }
    public string opCost15 { get; set; }
    public string opCost16 { get; set; }
    public string opCost17 { get; set; }
    public string opCost18 { get; set; }
    public string opCost19 { get; set; }
    public string opCost20 { get; set; }
    public string opCost21 { get; set; }
    public string opCost22 { get; set; }
    public string opCost23 { get; set; }
    public string opCost24 { get; set; }
    public string opCost25 { get; set; }
    public string opCost26 { get; set; }
    public string opCost27 { get; set; }
    public string opCost28 { get; set; }
    public string opCost29 { get; set; }
    public string opCost30 { get; set; }
    public string opCost31 { get; set; }
    public string opCost32 { get; set; }
    public string opCost33 { get; set; }
//1217 Government occupied Op costs  
    public string opCostGov4 { get; set; }
    public string opCostGov5 { get; set; }
    public string opCostGov6 { get; set; }
    public string opCostGov7 { get; set; }
    public string opCostGov8 { get; set; }
    public string opCostGov9 { get; set; }
    public string opCostGov10 { get; set; }
    public string opCostGov11 { get; set; }
    public string opCostGov12 { get; set; }
    public string opCostGov13 { get; set; }
    public string opCostGov14 { get; set; }
    public string opCostGov15 { get; set; }
    public string opCostGov16 { get; set; }
    public string opCostGov17 { get; set; }
    public string opCostGov18 { get; set; }
    public string opCostGov19 { get; set; }
    public string opCostGov20 { get; set; }
    public string opCostGov21 { get; set; }
    public string opCostGov22 { get; set; }
    public string opCostGov23 { get; set; }
    public string opCostGov24 { get; set; }
    public string opCostGov25 { get; set; }
    public string opCostGov26 { get; set; }
    public string opCostGov27 { get; set; }
    public string opCostGov28 { get; set; }
    public string opCostGov29 { get; set; }
    public string opCostGov30 { get; set; }
    public string opCostGov31 { get; set; }
    public string opCostGov32 { get; set; }
    public string opCostGov33 { get; set; }
//1217 Op costs end 10/26/2016  
    public string oil { get; set; }
    public string gas { get; set; }
    public string coal { get; set; }
    public string electric { get; set; }
    //added by syam on 01/14/2016 to show the old & new forms dynamically user will append the &formAge=old param
    public string formage { get; set; }
    public boolean isNew { get; set; }
    public boolean isOld { get; set; }
    public User usrinfo { get; set; }
    public LOP_PBS_AAAP_OfferForm1217() {


    system.debug('In class LOP_PBS_AAAP_OfferForm1217');
        offerId = getQueryParamAsString('offerId');
        system.debug('\n--offerId--'+offerId);
        if(!isValidUser()){ 
            return; 
        }
        Date currentDate = Date.today();
        formtype = getQueryParamAsString('formtype');
        formage = getQueryParamAsString('formage');
        
        system.debug('\n--formtype--'+formtype);
        system.debug('\n--formage--'+formage);

        if (formage == 'old') {
            isOld = true;
        } else {
            isNew = true;
        }
        System.debug('Jk before tempUsrinfo');
        List<User> tempUsrinfo = [
                SELECT id, email, Name, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                        street, city, country, CompanyName, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email, contact.PBS_AAAP_Website__c,
                        PBS_AAAP_StatesOfInterest__c, PBS_AAAP_PIN__c,PBS_AAAP_Regions__c, PBS_AAAP_Alternate_Phone__c
                FROM User
                WHERE id = :UserInfo.getUserId()
        ];
                System.debug('Jk after tempUsrinfo');



        for (User u : tempUsrinfo) {
            usrinfo = u;
        }
        userType = UserInfo.getUserType();

        userName = UserInfo.getName();
        if (formtype == 'LOP') {
            //setLOP1217Fields();
            //setLOP3518Fields();
        } else {
            set1217Fields();
        }
    }

    /**
    public void setLOP3518Fields() {
        if (getQueryParamAsString('offerId') != null) {
            lopoffer = PBS_AAAP_GlobalConstants.getLOPOfferDetail(offerId);
            System.debug('********** lopoffer size::: ' + lopoffer);
            sysDate = lopoffer.LOP_Offer_Submission_Date__c == null ? '' : lopoffer.LOP_Offer_Submission_Date__c.format('MM/dd/yyyy') ;
            if (userType.contains('Portal')) {
                if (lopoffer.OwnerId == UserInfo.getUserId()) {
                    isValidUser = true;
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                    Apexpages.addMessage(myMsg);
                    isValidUser = false;
                    return;
                }
            } else {
                isValidUser = true;
            }**/
            /* ownerName = lopoffer.LOP_Owner_FirstName__c +''+lopoffer.LOP_Owner_LastName__c;
             ownerMainPhone = lopoffer.LOP_Owner_Main_Phone__c;
             RLPNumber = lopoffer.Project_Number__c;
             bldgName = lopoffer.LOP_Building_Name__c;
             bldgStreet = lopoffer.LOP_Street_Address__c;
             bldgCity = lopoffer.LOP_City__c;
             bldgState = lopoffer.LOP_State__c;
             bldgZip = lopoffer.LOP_Zip__c;*/
    /**
            ownerName = usrinfo.firstname + ' ' + usrinfo.LastName;
            ownerMainPhone = usrinfo.phone;
            RLPNumber = lopoffer.Project_Number__c;
            bldgName = lopoffer.LOP_Building_Name__c;
            bldgStreet = usrinfo.street;
            bldgCity = usrinfo.city;
            bldgState = usrinfo.state;
            bldgZip = usrinfo.postalcode;
            if (lopoffer.LOP_Sam_Registered__c == 'Registration Active and Copy Attached in Attachments Tab') {
                SAMCertified = 'X';
            } else {
                SAMCertified = ' ';
            }
            if (lopoffer.LOP_Corporation_not_tax_felon__c == 'Yes') {
                yes11a = 'X';
                no11a = ' ';
            } else {
                yes11a = ' ';
                no11a = 'X';
            }
            if (lopoffer.LOP_Corp_Not_Convicted_Felon__c == 'Yes') {
                yes11b = 'X';
                no11b = ' ';
            } else {
                yes11b = ' ';
                no11b = 'X';
            }
        }
    }
    **/
    /**
    public void setLOP1217Fields() {

        if (getQueryParamAsString('offerId') != null) {
            system.debug('\n--offerId--'+offerId);
            lopoffer = PBS_AAAP_GlobalConstants.getLOPOfferDetail(offerId);
            System.debug('********** lopoffer size::: ' + lopoffer);
            if (userType.contains('Portal')) {
                if (lopoffer.OwnerId == UserInfo.getUserId()) {
                    isValidUser = true;
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                    Apexpages.addMessage(myMsg);
                    isValidUser = false;
                    return;
                }
            } else {
                isValidUser = true;
            }

            ownerName = usrinfo.firstname + ' ' + usrinfo.LastName;
            ownerMainPhone = usrinfo.phone;
            RLPNumber = lopoffer.Project_Number__c;
            bldgName = lopoffer.LOP_Building_Name__c;
            bldgStreet = usrinfo.street;
            bldgCity = usrinfo.city;
            bldgState = usrinfo.state;
            bldgZip = usrinfo.postalcode;
            DUNSNumber = String.valueOf(lopoffer.LOP_DUNS_Number__c);

            opCost3 = String.valueOf(lopoffer.LOP_GEN_PURPOSE_RENTABLE__c);
            opCost3a = String.valueOf(lopoffer.LOP_Office_RSF_OFFERED__c);

            opCost5 = getStringCurrency(lopoffer.LOP_CLEANING_SALARIES__c);
            opCost6 = getStringCurrency(lopoffer.LOP_CLEANING_SUPPLIES__c);
            opCost7 = getStringCurrency(lopoffer.LOP_CLEANING_CONTRACT_SERVICES__c);

            opCost8 = getStringCurrency(lopoffer.LOP_HEATING_SALARIES__c);
            opCost9 = getStringCurrency(lopoffer.LOP_HEATING_FUEL_COST__c);
            opCost10 = getStringCurrency(lopoffer.LOP_HEATING_MAINTENANCE__c);

            opCost11 = getStringCurrency(lopoffer.LOP_ELECTRICAL_POWER__c);
            opCost12 = getStringCurrency(lopoffer.LOP_ELECTRICAL_REPLACEMENT__c);
            opCost13 = getStringCurrency(lopoffer.LOP_ELECTRICAL_SPECIALEQUIP__c);
            opCost14 = getStringCurrency(lopoffer.LOP_ELECTRICAL_MAINTENANCE__c);

            opCost15 = getStringCurrency(lopoffer.LOP_PLUMBING_WATER__c);
            opCost16 = getStringCurrency(lopoffer.LOP_PLUMBING_SUPPLIES__c);
            opCost17 = getStringCurrency(lopoffer.LOP_PLUMBING_MAINTENANCE__c);

            opCost18 = getStringCurrency(lopoffer.LOP_AC_UTILITIES__c);
            opCost19 = getStringCurrency(lopoffer.LOP_AC_MAINTENANCE__c);

            opCost20 = getStringCurrency(lopoffer.LOP_ELEVATOR_SALARIES__c);
            opCost21 = getStringCurrency(lopoffer.LOP_ELEVATOR_MAINTENANCE__c);

            opCost22 = getStringCurrency(lopoffer.LOP_BLDG_ENGINEERCOST__c);
            opCost23 = getStringCurrency(lopoffer.LOP_SECURITY__c);
            opCost24 = getStringCurrency(lopoffer.LOP_SSTAX_WORKCOMP__c);
            opCost25 = getStringCurrency(lopoffer.LOP_LANDSCAPING_MAINTENANCE__c);
            opCost26 = getStringCurrency(lopoffer.LOP_TOTAL_OTHER_COSTS__c);
            opCost27 = getStringCurrency(lopoffer.LOP_SRVC_UTIL_TOTAL__c);

            opCost28 = getStringCurrency(lopoffer.LOP_REAL_ESTATE_TAXES__c);
            opCost29 = getStringCurrency(lopoffer.LOP_INSURANCE__c);
            opCost30 = getStringCurrency(lopoffer.LOP_BUILDING_MAINTENANCE__c);
            opCost31 = getStringCurrency(lopoffer.LOP_LEASE_COMMISSION__c);
            opCost32 = getStringCurrency(lopoffer.LOP_MANAGEMENT__c);
            opCost33 = getStringCurrency(lopoffer.LOP_SECT2_TOTAL__c);
//Gov costs
            opCostGov5 = getStringCurrency(lopoffer.LOP_CLEANING_SALARIES_GOV__c);
            opCostGov6 = getStringCurrency(lopoffer.LOP_CLEANING_SUPPLIES_GOV__c);
            opCostGov7 = getStringCurrency(lopoffer.LOP_CLEANING_CONTRACT_SERVICES_GOV__c);

            opCostGov8 = getStringCurrency(lopoffer.LOP_HEATING_SALARIES_GOV__c);
            opCostGov9 = getStringCurrency(lopoffer.LOP_HEATING_FUEL_COST_GOV__c);
            opCostGov10 = getStringCurrency(lopoffer.LOP_HEATING_MAINTENANCE_GOV__c);

            opCostGov11 = getStringCurrency(lopoffer.LOP_ELECTRICAL_POWER_GOV__c);
            opCostGov12 = getStringCurrency(lopoffer.LOP_ELECTRICAL_REPLACEMENT_GOV__c);
            opCostGov13 = getStringCurrency(lopoffer.LOP_ELECTRICAL_SPECIALEQUIP_GOV__c);
            opCostGov14 = getStringCurrency(lopoffer.LOP_ELECTRICAL_MAINTENANCE_GOV__c);

            opCostGov15 = getStringCurrency(lopoffer.LOP_PLUMBING_WATER_GOV__c);
            opCostGov16 = getStringCurrency(lopoffer.LOP_PLUMBING_SUPPLIES_GOV__c);
            opCostGov17 = getStringCurrency(lopoffer.LOP_PLUMBING_MAINTENANCE_GOV__c);

            opCostGov18 = getStringCurrency(lopoffer.LOP_AC_UTILITIES_GOV__c);
            opCostGov19 = getStringCurrency(lopoffer.LOP_AC_MAINTENANCE_GOV__c);

            opCostGov20 = getStringCurrency(lopoffer.LOP_ELEVATOR_SALARIES_GOV__c);
            opCostGov21 = getStringCurrency(lopoffer.LOP_ELEVATOR_MAINTENANCE_GOV__c);

            opCostGov22 = getStringCurrency(lopoffer.LOP_BLDG_ENGINEERCOST_GOV__c);
            opCostGov23 = getStringCurrency(lopoffer.LOP_SECURITY_GOV__c);
            opCostGov24 = getStringCurrency(lopoffer.LOP_SSTAX_WORKCOMP_GOV__c);
            opCostGov25 = getStringCurrency(lopoffer.LOP_LANDSCAPING_MAINTENANCE_GOV__c);
            opCostGov26 = getStringCurrency(lopoffer.LOP_TOTAL_OTHER_COSTS_GOV__c);
            opCostGov27 = getStringCurrency(lopoffer.LOP_SRVC_UTIL_TOTAL_GOV__c);

            opCostGov28 = getStringCurrency(lopoffer.LOP_REAL_ESTATE_TAXES_GOV__c);
            opCostGov29 = getStringCurrency(lopoffer.LOP_INSURANCE_GOV__c);
            opCostGov30 = getStringCurrency(lopoffer.LOP_BUILDING_MAINTENANCE_GOV__c);
            opCostGov31 = getStringCurrency(lopoffer.LOP_LEASE_COMMISSION_GOV__c);
            opCostGov32 = getStringCurrency(lopoffer.LOP_MANAGEMENT_GOV__c);
            opCostGov33 = getStringCurrency(lopoffer.LOP_SECT2_TOTAL_GOV__c);

            if (lopoffer.LOP_OFFEROR_INTEREST__c == 'Owner') {
                xownerType = 'X';
            } else {
                legalAgentType = 'X';
            }

            if (lopoffer.LOP_HEATING_FUEL__c == 'Electric') {
                electric = 'X';
                oil = '';
                gas = '';
                coal = '';
            }
            if (lopoffer.LOP_HEATING_FUEL__c == 'Gas') {
                electric = '';
                oil = '';
                gas = 'X';
                coal = '';
            }
            if (lopoffer.LOP_HEATING_FUEL__c == 'Oil') {
                electric = '';
                oil = 'X';
                gas = '';
                coal = '';
            }
            if (lopoffer.LOP_HEATING_FUEL__c == 'Coal') {
                electric = '';
                oil = '';
                gas = '';
                coal = 'X';
            }
        }


        return;
    }**/
    public void set1217Fields() {
        System.debug('********** Method Called');
        if (getQueryParamAsString('offerId') != null) {
            System.debug('********** Method Called not null');
            System.debug('jk before in set1217fields offer query');
            //JK added return here
            //return;
            offer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            System.debug('jk after in set1217fields offer query');
            sysDate = offer.PBS_AAAP_Offer_Submission_Date__c == null ? '' : offer.PBS_AAAP_Offer_Submission_Date__c.format() ;
            DUNSNumber = String.valueOf(offer.PBS_AAAP_DUNS_Number__c);
            //added this condition because it is only applicable for extranet users , intranet users can see the page. extranet users always have portal in the userType
            if (userType.contains('Portal')) {
                if (offer.OwnerId == UserInfo.getUserId()) {
                    isValidUser = true;
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                    Apexpages.addMessage(myMsg);
                    isValidUser = false;
                    return;
                }
            } else {
                isValidUser = true;
            }
            System.debug('********** isValid'+isValidUser);
            /*ownerName = offer.PBS_AAAP_Owner_Name__c;
            ownerMainPhone = offer.PBS_AAAP_Owner_Main_Phone__c;  
            RLPNumber = offer.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
            bldgName = offer.PBS_AAAP_Building_Name__c;
            bldgStreet = offer.PBS_AAAP_Street_Address__c;
            bldgCity = offer.PBS_AAAP_City__c;
            bldgState = offer.PBS_AAAP_State__c;
            bldgZip = offer.PBS_AAAP_ZipCode__c;*/
            offerCreatedBy = offer.OwnerId;
                    System.debug('Jk before userdetail');//This query is OKAY//JK

            userdetail = [SELECT u.Title, u.Street, u.State, u.PostalCode, u.Phone, u.firstname, u.LastName, u.Id, u.Email, u.City FROM User u WHERE u.id = :offerCreatedBy];
                    System.debug('Jk after userdetail');

            ownerName = userdetail.firstname + ' ' + userdetail.LastName;
            ownerMainPhone = userdetail.phone;
            RLPNumber = offer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Project_Number__c;
            bldgName = offer.PBS_AAAP_Building_Name__c;
            bldgStreet = offer.PBS_AAAP_Street_Address__c;
            bldgCity = offer.PBS_AAAP_City__c;
            bldgState = offer.PBS_AAAP_State__c;
            bldgZip = offer.PBS_AAAP_ZipCode__c;


            opCost3 = String.valueOf(offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);
            opCost3a = string.valueOf(offer.PBS_AAAP_Office_RSF_OFFERED__c); //String.valueOf(offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c);

            opCost5 = getStringCurrency(offer.PBS_AAAP_CLEANING_SALARIES__c);
            opCostGov5 = getStringCurrency(offer.PBS_AAAP_CLEANING_SALARIES_GOV__c);
            opCost6 = getStringCurrency(offer.PBS_AAAP_CLEANING_SUPPLIES__c);
            opCostGov6 = getStringCurrency(offer.PBS_AAAP_CLEANING_SUPPLIES_GOV__c);
            opCost7 = getStringCurrency(offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c);
            opCostGov7 = getStringCurrency(offer.PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c);

            opCost8 = getStringCurrency(offer.PBS_AAAP_HEATING_SALARIES__c);
            opCostGov8 = getStringCurrency(offer.PBS_AAAP_HEATING_SALARIES_GOV__c);
            opCost9 = getStringCurrency(offer.PBS_AAAP_HEATING_FUEL_COST__c);
            opCostGov9 = getStringCurrency(offer.PBS_AAAP_HEATING_FUEL_COST_GOV__c);
            opCost10 = getStringCurrency(offer.PBS_AAAP_HEATING_MAINTENANCE__c);
            opCostGov10 = getStringCurrency(offer.PBS_AAAP_HEATING_MAINTENANCE_GOV__c);

            opCost11 = getStringCurrency(offer.PBS_AAAP_ELECTRICAL_POWER__c);
            opCostGov11 = getStringCurrency(offer.PBS_AAAP_ELECTRICAL_POWER_GOV__c);
            opCost12 = getStringCurrency(offer.PBS_AAAP_ELECTRICAL_REPLACEMENT__c);
            opCostGov12 = getStringCurrency(offer.PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c);
            opCost13 = getStringCurrency(offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c);
            opCostGov13 = getStringCurrency(offer.PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c);
            opCost14 = getStringCurrency(offer.PBS_AAAP_ELECTRICAL_MAINTENANCE__c);
            opCostGov14 = getStringCurrency(offer.PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c);

            opCost15 = getStringCurrency(offer.PBS_AAAP_PLUMBING_WATER__c);
            opCostGov15 = getStringCurrency(offer.PBS_AAAP_PLUMBING_WATER_GOV__c);
            opCost16 = getStringCurrency(offer.PBS_AAAP_PLUMBING_SUPPLIES__c);
            opCostGov16 = getStringCurrency(offer.PBS_AAAP_PLUMBING_SUPPLIES_GOV__c);
            opCost17 = getStringCurrency(offer.PBS_AAAP_PLUMBING_MAINTENANCE__c);
            opCostGov17 = getStringCurrency(offer.PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c);

            opCost18 = getStringCurrency(offer.PBS_AAAP_AC_UTILITIES__c);
            opCostGov18 = getStringCurrency(offer.PBS_AAAP_AC_UTILITIES_GOV__c);
            opCost19 = getStringCurrency(offer.PBS_AAAP_AC_MAINTENANCE__c);
            opCostGov19 = getStringCurrency(offer.PBS_AAAP_AC_MAINTENANCE_GOV__c);

            opCost20 = getStringCurrency(offer.PBS_AAAP_ELEVATOR_SALARIES__c);
            opCostGov20 = getStringCurrency(offer.PBS_AAAP_ELEVATOR_SALARIES_GOV__c);
            opCost21 = getStringCurrency(offer.PBS_AAAP_ELEVATOR_MAINTENANCE__c);
            opCostGov21 = getStringCurrency(offer.PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c);

            opCost22 = getStringCurrency(offer.PBS_AAAP_BLDG_ENGINEERCOST__c);
            opCostGov22 = getStringCurrency(offer.PBS_AAAP_BLDG_ENGINEERCOST_GOV__c);
            opCost23 = getStringCurrency(offer.PBS_AAAP_SECURITY__c);
            opCostGov23 = getStringCurrency(offer.PBS_AAAP_SECURITY_GOV__c  );
            opCost24 = getStringCurrency(offer.PBS_AAAP_SSTAX_WORKCOMP__c);
            opCostGov24 = getStringCurrency(offer.PBS_AAAP_SSTAX_WORKCOMP_GOV__c);
            opCost25 = getStringCurrency(offer.PBS_AAAP_LANDSCAPING_MAINTENANCE__c);
            opCostGov25 = getStringCurrency(offer.PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c);
            opCost26 = getStringCurrency(offer.PBS_AAAP_TOTAL_OTHER_COSTS__c);
            opCostGov26 = getStringCurrency(offer.PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c);
            opCost27 = getStringCurrency(offer.PBS_AAAP_SRVC_UTIL_TOTAL__c);
            opCostGov27 = getStringCurrency(offer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c);

            opCost28 = getStringCurrency(offer.PBS_AAAP_REAL_ESTATE_TAXES__c);
            opCostGov28 = getStringCurrency(offer.PBS_AAAP_REAL_ESTATE_TAXES_GOV__c);
            opCost29 = getStringCurrency(offer.PBS_AAAP_INSURANCE__c);
            opCostGov29 = getStringCurrency(offer.PBS_AAAP_INSURANCE_GOV__c);
            opCost30 = getStringCurrency(offer.PBS_AAAP_BUILDING_MAINTENANCE__c);
            opCostGov30 = getStringCurrency(offer.PBS_AAAP_BUILDING_MAINTENANCE_GOV__c);
            opCost31 = getStringCurrency(offer.PBS_AAAP_LEASE_COMMISSION__c);
            opCostGov31 = getStringCurrency(offer.PBS_AAAP_LEASE_COMMISSION_GOV__c);
            opCost32 = getStringCurrency(offer.PBS_AAAP_MANAGEMENT__c);
            opCostGov32 = getStringCurrency(offer.PBS_AAAP_MANAGEMENT_GOV__c);
            opCost33 = getStringCurrency(offer.PBS_AAAP_SECT2_TOTAL__c);
            opCostGov33 = getStringCurrency(offer.PBS_AAAP_SECT2_TOTAL_GOV__c);
                    System.debug('Jk before tempUsrinfo2');
                    //COULD NOT TEST THIS QUERY//JK
            userdetail = [SELECT u.Title, u.Street, u.State, u.PostalCode, u.Phone, u.Name, u.Id, u.Email, u.City FROM User u WHERE u.id = :offerCreatedBy];
                    System.debug('Jk after tempUsrinfo2');

            System.debug('********** Method Called'+formtype);
            if (offer.PBS_AAAP_OFFEROR_INTEREST__c == 'Owner') {
                xownerType = 'X';
            } else if(offer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other'){
                //legalAgentType = 'X';
            } else {
                legalAgentType = 'X';
            }
            electric = '';
            oil = '';
            gas = '';
            coal = '';
            if (offer.PBS_AAAP_HEATING_FUEL__c == 'Electric') {
                electric = 'X';
                //oil = '';
                //gas = '';
                //coal = '';
            }
            if (offer.PBS_AAAP_HEATING_FUEL__c == 'Gas') {
                //electric = '';
                //oil = '';
                gas = 'X';
                //coal = '';
            }
            if (offer.PBS_AAAP_HEATING_FUEL__c == 'Oil') {
                electric = '';
                oil = 'X';
                gas = '';
                coal = '';
            }
            if (offer.PBS_AAAP_HEATING_FUEL__c == 'Coal') {
                electric = '';
                oil = '';
                gas = '';
                coal = 'X';
            }
            /**
            if (formtype == 'offerform1217') {
                if (offer.PBS_AAAP_PROPERTY_OWNER_TYPE__c == 'Owner') {
                    xownerType = 'X';
                } else {
                    legalAgentType = 'X';
                }

                if (offer.PBS_AAAP_HEATING_FUEL__c == 'Electric') {
                    electric = 'X';
                    oil = '';
                    gas = '';
                    coal = '';
                }
                if (offer.PBS_AAAP_HEATING_FUEL__c == 'Gas') {
                    electric = '';
                    oil = '';
                    gas = 'X';
                    coal = '';
                }
                if (offer.PBS_AAAP_HEATING_FUEL__c == 'Oil') {
                    electric = '';
                    oil = 'X';
                    gas = '';
                    coal = '';
                }
                if (offer.PBS_AAAP_HEATING_FUEL__c == 'Coal') {
                    electric = '';
                    oil = '';
                    gas = '';
                    coal = 'X';
                }

            } else if (formtype == 'offerform1217Attachment') {
                otherCosts = new List<OtherCostsClass>();
                countsize = 0;
                otherCostList = [
                        SELECT id, PBS_AAAP_COST_TYPE__c, PBS_AAAP_SHORT_DESC__c, PBS_AAAP_COST__c
                        FROM PBS_AAAP_Other_Costs__c
                        WHERE PBS_AAAP_OFFER_NUMBER__c = :offerId
                        ORDER BY CreatedDate
                ];
                System.debug('********** rateList size::: ' + otherCostList.size());
                System.debug('********** rateList 1::: ' + otherCostList);
                if (otherCostList.size() > 0) {
                    for (PBS_AAAP_Other_Costs__c ocost : otherCostList) {
                        otherCosts.add(new OtherCostsClass(ocost, true));
                    }
                }
                if (otherCostList.size() < 10) {
                    countsize = 10 - otherCostList.size();
                    PBS_AAAP_Other_Costs__c ocost = new PBS_AAAP_Other_Costs__c();
                    for (integer i = otherCostList.size() - 1; i <= 45; i++) {
                        otherCosts.add(new OtherCostsClass(ocost, false));
                    }
                }
            } else if (formtype == 'offerform3518') {
                if (offer.PBS_AAAP_Representation__c == 'Small Business') {
                    smallBusiness = 'X';
                    notsmallBusiness = ' ';
                } else {
                    smallBusiness = ' ';
                    notsmallBusiness = 'X';
                }

                if (offer.PBS_AAAP_SMALL_DISADVANTAGED_IDENTIFIER__c == 'Yes') {
                    yes1A = 'X'; no1A = ' ';
                } else {
                    yes1A = ' '; no1A = 'X';
                }
                if (offer.PBS_AAAP_Women_Owned_Identifier__c == 'Yes') {
                    yes1B = 'X'; no1B = ' ';
                } else {
                    yes1B = ' '; no1B = 'X';
                }
                if (offer.PBS_AAAP_Veteran_Owned_Identifier__c == 'Yes') {
                    yes1C = 'X'; no1C = ' ';
                } else {
                    yes1C = ' '; no1C = 'X';
                }
                if (offer.PBS_AAAP_SERVICE_DISABLED_IDENTIFIER__c == 'Yes') {
                    yes1D = 'X'; no1D = ' ';
                } else {
                    yes1D = ' '; no1D = 'X';
                }
                if (offer.PBS_AAAP_HUBZONE_IDENTIFIER__c == 'Yes') {
                    yes1E = 'X'; no1E = ' ';
                } else {
                    yes1E = ' '; no1E = 'X';
                }
                if (offer.PBS_AAAP_HUBZONE_JOINT_VENTURE__c == 'Yes') {
                    yes1F = 'X'; no1F = ' ';
                } else {
                    yes1F = ' '; no1F = 'X';
                }
                if (offer.PBS_AAAP_HUBZONE_JOINT_VENTURE_NAMES__c != null) {
                    names1G = offer.PBS_AAAP_HUBZONE_JOINT_VENTURE_NAMES__c;
                } else {
                    names1G = '________';
                }
                if (offer.PBS_AAAP_Women_Owned_Identifier__c == 'Yes') {
                    yes1H = 'X'; no1H = ' ';
                } else {
                    yes1H = ' '; no1H = 'X';
                }

                if (offer.PBS_AAAP_EEO_CLAUSE__c == 'Yes') {
                    yes2 = 'X'; no2 = ' ';
                } else {
                    yes2 = ' '; no2 = 'X';
                }
                if (offer.PBS_AAAP_COMPLIANCE_REPORT__c == 'Yes') {
                    yes2A = 'X'; no2A = ' ';
                } else {
                    yes2A = ' '; no2A = 'X';
                }

                if (offer.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c == 'Yes') {
                    yes3 = 'X'; no3 = ' ';
                } else {
                    yes3 = ' '; no3 = 'X';
                }

                if (offer.PBS_AAAP_AFFIRMATIVE_ACTION_CONTRACTS__c == 'Yes') {
                    yes3a = 'X';
                } else {
                    yes3a = ' ';
                }

                if (offer.PBS_AAAP_NAMES_RESP_FOR_DET_PRICES__c != null) {
                    name4b = offer.PBS_AAAP_NAMES_RESP_FOR_DET_PRICES__c;
                } else {
                    name4b = '____________________';
                }

                if (offer.PBS_AAAP_Confirm_Owner_Status__c == 'Yes') {
                    yes5 = 'X'; no5 = ' ';
                } else {
                    yes5 = ' '; no5 = 'X';
                }
                if (offer.PBS_AAAP_OWNER_CONVICTION__c == 'Yes') {
                    yes6 = 'X'; no6 = ' ';
                } else {
                    yes6 = ' '; no6 = 'X';
                }
                if (offer.PBS_AAAP_OWNER_INDICTMENT__c == 'Yes') {
                    yes7 = 'X'; no7 = ' ';
                } else {
                    yes7 = ' '; no7 = 'X';
                }

                if (offer.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c == 'Yes') {
                    yes8 = 'X'; no8 = ' ';
                } else {
                    yes8 = ' '; no8 = 'X';
                }
//SAM Certification 09/22/2015                
                if (offer.PBS_AAAP_Sam_Registered__c == 'Registration Active and Copy Attached in Attachments Tab') {
                    SAMCertified = 'X';
                }

                else {
                    SAMCertified = ' ';
                }

                if (offer.PBS_AAAP_Owner_TIN_Status__c == 'KNOWN') {
                    yesTINKnown = 'X';
                    TINNumber = offer.PBS_AAAP_Owner_TIN_Assigned__c;
                } else {
                    yesTINKnown = ' ';
                }

                if (offer.PBS_AAAP_Owner_TIN_Status__c == 'Applied For') {
                    yesTINAppliedFor = 'X';
                } else {
                    yesTINAppliedFor = ' ';
                }
                if (offer.PBS_AAAP_Owner_TIN_Status__c == 'Not required') {
                    yesTINNotRequired = 'X';
                    if (offer.PBS_AAAP_OWN_NOT_REQ_REASON__c == 'Property owner is an agency of a foreign government') {
                        TINReasonB = 'X';
                    }
                    if (offer.PBS_AAAP_OWN_NOT_REQ_REASON__c == 'Property owner is an agency of the Federal governament') {
                        TINReasonC = 'X';
                    }
                    if (offer.PBS_AAAP_OWN_NOT_REQ_REASON__c == 'Property Owner is a nonresident alien, foreign corporation, or foreign partnership that does not have income') {
                        TINReasonA = 'X';
                    }
                } else {
                    yesTINNotRequired = ' ';
                }

                if (offer.PBS_AAAP_TYPE_OF_ORG__c == 'Other') {
                    other = 'X';
                    otherName = offer.PBS_AAAP_TYPE_OF_ORG_OTHER__c;
                }
                if (offer.PBS_AAAP_TYPE_OF_ORG__c == 'Sole Proprietorship') {
                    soleproprietorship = 'X';
                }
                if (offer.PBS_AAAP_TYPE_OF_ORG__c == 'Partnership') {
                    partnership = 'X';
                }
                if (offer.PBS_AAAP_TYPE_OF_ORG__c == 'Corporate entity (not tax-exempt)') {
                    corporateentitynottax = 'X';
                }
                if (offer.PBS_AAAP_TYPE_OF_ORG__c == 'Corporate entity (tax-exempt)') {
                    corporateentitytax = 'X';
                }
                if (offer.PBS_AAAP_TYPE_OF_ORG__c == 'Government entity(Federal,State,or local)') {
                    govtentity = 'X';
                }
                if (offer.PBS_AAAP_TYPE_OF_ORG__c == 'Foreign government') {
                    foreigngovt = 'X';
                }
                if (offer.PBS_AAAP_TYPE_OF_ORG__c == 'International organization per 26 CFR 1.6049-4') {
                    internationalorg = 'X';
                }

                if (offer.PBS_AAAP_CONTROLLED_BY_PARENT__c == 'No') {
                    commonParentNo = 'X';
                }
                if (offer.PBS_AAAP_CONTROLLED_BY_PARENT__c == 'Yes') {
                    commonParentYes = 'X';
                    commonParentName = offer.PBS_AAAP_PARENT_NAME__c;
                    DUNSNumber = String.valueOf(offer.PBS_AAAP_DUNS_Number__c);
                }
                if (offer.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c == 'Yes') {
                    activeYes = 'X';
                    activeNo = ' ';
                } else {
                    activeYes = ' ';
                    activeNo = 'X';
                }
                if (offer.PBS_AAAP_FederalTax_Delinquent__c == 'Yes') {
                    yes10 = 'X';
                    no10 = ' ';
                } else {
                    yes10 = ' ';
                    no10 = 'X';
                }
                if (offer.PBS_AAAP_Corporation_not_tax_felon__c == 'Yes') {
                    yes11a = 'X';
                    no11a = ' ';
                } else {
                    yes11a = ' ';
                    no11a = 'X';
                }
                if (offer.PBS_AAAP_Corp_Not_Convicted_Felon__c == 'Yes') {
                    yes11b = 'X';
                    no11b = ' ';
                } else {
                    yes11b = ' ';
                    no11b = 'X';
                }
                if (offer.PBS_AAAP_WOSB_Docs_Complete__c == 'Yes') {
                    yes1B1 = 'X';
                    no1B1 = ' ';
                } else {
                    yes1B1 = ' ';
                    no1B1 = 'X';
                }
                if (offer.PBS_AAAP_WOSB_Joint_Venture__c == 'Yes') {
                    yes1B2 = 'X';
                    no1B2 = ' ';
                } else {
                    yes1B2 = ' ';
                    no1B2 = 'X';
                }
                if (offer.PBS_AAAP_EDWOSB_Docs_Complete__c == 'Yes') {
                    yes1B3 = 'X';
                    no1B3 = ' ';
                } else {
                    yes1B3 = ' ';
                    no1B3 = 'X';
                }
                if (offer.PBS_AAAP_EDWOSB_Joint_Venture__c == 'Yes') {
                    yes1B4 = 'X';
                    no1B4 = ' ';
                } else {
                    yes1B4 = ' ';
                    no1B4 = 'X';
                }
                if (offer.EDWOSB_Joint_Venture_Names__c != '') {
                    EDWOSBNames = offer.EDWOSB_Joint_Venture_Names__c;
                } else {
                    EDWOSBNames = '              ';
                }
                if (offer.WOSB_Joint_Venture_Names__c != '') {
                    WOSBNames = offer.WOSB_Joint_Venture_Names__c;
                } else {
                    WOSBNames = '             ';
                }

            } else if (formtype == 'offerform1364Attachment') {
                if (offer.PBS_AAAP_Building_Sprinklered__c == 'Yes') {
                    sprinkledYes = 'X';
                    sprinkledNo = ' ';
                    sprinkledPartially = ' ';
                } else if (offer.PBS_AAAP_Building_Sprinklered__c == 'No') {
                    sprinkledYes = ' ';
                    sprinkledNo = 'X';
                    sprinkledPartially = ' ';
                } else if (offer.PBS_AAAP_Building_Sprinklered__c == 'Partial') {
                    sprinkledYes = ' ';
                    sprinkledNo = ' ';
                    sprinkledPartially = 'X';
                } else {
                    sprinkledYes = ' ';
                    sprinkledNo = ' ';
                    sprinkledPartially = ' ';
                }

                if (offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c == 'Yes') {
                    remotestairwelYes = 'X';
                    remotestairwelNo = ' ';
                } else if (offer.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c == 'No') {
                    remotestairwelYes = ' ';
                    remotestairwelNo = 'X';
                } else {
                    remotestairwelYes = ' ';
                    remotestairwelNo = ' ';
                }
                if (offer.PBS_AAAP_BLDG_Wide_Alarm_System__c == 'Yes') {
                    alarmYes = 'X';
                    alarmNo = ' ';
                } else if (offer.PBS_AAAP_BLDG_Wide_Alarm_System__c == 'No') {
                    alarmYes = ' ';
                    alarmNo = 'X';
                } else {
                    alarmYes = ' ';
                    alarmNo = ' ';
                }
                if (offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c != 'Other') {
                    exteriorwall = offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c;
                } else {
                    exteriorwall = offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c;
                    exteriorother = offer.PBS_AAAP_TYPE_OF_CONS_EXTERIOR_OTHER__c;
                }
                if (offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c != 'Other') {
                    roofingmaterial = offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c;
                } else {
                    roofingmaterial = offer.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c;
                    roofingother = offer.PBS_AAAP_TYPE_OF_CONS_ROOFING_MAT_OTHER__c;
                }
                buildingRenovationYear = offer.PBS_AAAP_Renovation_Year__c;
                if (offer.PBS_AAAP_Close_To_Metro__c == 'Yes') {
                    metrorailYes = 'X';
                    metrorailNo = ' ';
                } else {
                    metrorailYes = ' ';
                    metrorailNo = 'X';
                    metrorailName = offer.PBS_AAAP_MetroRail_Station__c;
                }

                officeSpaceRSF = String.valueOf(offer.PBS_AAAP_OFFICE_SPACE_RSF__c);
                retailSpaceRSF = String.valueOf(offer.PBS_AAAP_RETAIL_SPACE_RSF__c);
                garageSpaceRSF = String.valueOf(offer.PBS_AAAP_GARAGE_SPACE_RSF__c);
                // officeSpacePercent = String.valueOf(offer.PBS_AAAP_BLD_INCOME_PERCENT_OFF_SPACE__c);
                // retailSpacePercent = String.valueOf(offer.PBS_AAAP_BLD_INCOME_PERCENT_RET_SPACE__c);
                // garageSpacePercent = String.valueOf(offer.PBS_AAAP_BLD_INCOME_PERCENT_GAR_SPACE__c);
                totalRSF = String.valueOf(offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c);

                totalANSIBOMAMax = String.valueOf(offer.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c);
                totalANSIBOMAMin = String.valueOf(offer.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c);
                totalANSIBOMA = String.valueOf(offer.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c);
                totalANSIBOMABuilding = String.valueOf(offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c);

                totalParkingSpacesOffered = String.valueOf(offer.PBS_AAAP_Total_Park_Spaces_Offered__c);
                totalfreeParkingSpaces = String.valueOf(offer.PBS_AAAP_Free_Parking_Spaces_Offered__c);

                garageReserved = String.valueOf(offer.PBS_AAAP_Monthly_cost_res_gar_park__c);
                garageNonReserved = String.valueOf(offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c);
                surfacelotReserved = String.valueOf(offer.PBS_AAAP_Monthly_cost_res_sur_park__c);
                surfacelotNonReserved = String.valueOf(offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c);


                if (offer.PBS_AAAP_Option_Parking__c == 'Yes') {
                    optionParkingYes = 'X';
                    optionParkingNo = ' ';
                    optionParkingPartial = ' ';
                    annuallumpsum = String.valueOf(offer.PBS_AAAP_Annual_cost_entire_garage_park__c);
                    totalgarageparkingspaces = String.valueOf(offer.PBS_AAAP_Number_of_gar_parking_spaces__c);
                } else if (offer.PBS_AAAP_Option_Parking__c == 'No') {
                    optionParkingYes = ' ';
                    optionParkingNo = 'X';
                    optionParkingPartial = ' ';
                } else if (offer.PBS_AAAP_Option_Parking__c == 'Partial') {
                    optionParkingYes = ' ';
                    optionParkingNo = ' ';
                    optionParkingPartial = 'X';
                }

                if (offer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == true) {
                    SFOYes = 'X';
                    SFONo = ' ';
                } else if (offer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == false) {
                    SFOYes = ' ';
                    SFONo = 'X';
                }
                if (offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c == 'Yes') {
                    solicitationYes = 'X';
                    solicitationNo = ' ';
                } else if (offer.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c == 'No') {
                    solicitationYes = ' ';
                    solicitationNo = 'X';
                }
                if (offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c == 'Yes') {
                    generalClauseYes = 'X';
                    generalClauseNo = ' ';
                } else if (offer.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c == 'No') {
                    generalClauseYes = ' ';
                    generalClauseNo = 'X';
                }
                if (offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c == 'Yes') {
                    repsandcertsYes = 'X';
                    repsandcertsNo = ' ';
                } else if (offer.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c == 'No') {
                    repsandcertsYes = ' ';
                    repsandcertsNo = 'X';
                }
            }**/
            return;
        }
    }
    public string getStringCurrency(decimal pCost) {
       
     String returnString = '0.00';
    if(pCost != null){
    Decimal pCostVal = pCost.setScale(2);
    Long downVal = pCost.round(System.RoundingMode.DOWN);
    Decimal rem = pCostVal - downVal;
        String formattedVal = downVal.format();
    system.debug('After Format' +formattedVal);
    system.debug('rem' +rem);
    if(rem == 0){
        returnString = formattedVal+'.00';
    }
    else{
        String decimalPlaceStr = String.valueOf(rem).substringAfter('.');
        returnString = formattedVal+'.'+decimalPlaceStr;
    }
}

    system.debug(returnString);
    return returnString;
    }
    /**
    public class OtherCostsClass {
        public string field1 { get; set; }
        public string field2 { get; set; }

        public OtherCostsClass(PBS_AAAP_Other_Costs__c cost, boolean flag) {
            if (flag == true) {

                field1 = cost.PBS_AAAP_SHORT_DESC__c;
                field2 = String.valueOf(cost.PBS_AAAP_COST__c);
            } else {
                field1 = '';
                field2 = '';
            }
        }
    }**/

    /**
    public void captureImage()
    {
        folderId = [SELECT ID 
                        FROM Folder 
                        WHERE NAME = 'AAAP Folder'].Id;
        Document d = new Document(); 
        d.Name = strImagename+'.png';         
        d.Body = EncodingUtil.base64Decode(strImageBlob.replaceFirst('data:image/png;base64,','')); 
        d.ContentType = 'image/png';
        d.FolderId = folderId;
        d.IsPublic = true;
        insert d;
        PBS_AAAP_relateListSnapCntrl.saveRecIdinCookie(d.Id);
        system.debug('\n--d---'+d);
    }
    **/
    
    public void captureImage(){
                System.debug('Jk before captureImage');

        folderId = [SELECT ID 
                        FROM Folder 
                        WHERE NAME = 'AAAP Folder'].Id;
                System.debug('Jk after captureImage');

        Document d = new Document(); 
        d.Name = strImagename+'.png';

        Integer strLen = strImageBlob.length() / 2;
        String first = strImageBlob.substring(0, strLen);
        String second = strImageBlob.substring(strLen);
        String first1 = first.replaceFirst('data:image/png;base64,','');
        String concat = first1 + second;
        d.Body = EncodingUtil.base64Decode(concat);


        //d.Body = EncodingUtil.base64Decode(strImageBlob.replaceFirst('data:image/png;base64,',''));
        d.ContentType = 'image/png';
        d.FolderId = folderId;
        d.IsPublic = true;
        insert d;
        PBS_AAAP_relateListSnapCntrl.saveRecIdinCookie(d.Id);
        system.debug('\n--d---'+d);
    }
    
    string fetchOfferKey(){ 
        string ofId = getQueryParamAsString('offerId'); 
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_Key__c; 
        //return 'teststring';
    }   
    boolean isValidUser(){  
        //return true;
        // getting session id   
        string paramSessionKey = getQueryParamAsString('sesid');    
        string sessionOfferKey = fetchOfferKey();   
        System.debug('JK 1217 sessionOfferKey ' + sessionOfferKey);
        if(UserInfo.getUserType() == 'Standard'){   
            return true;    
        }   
        else if(paramSessionKey != sessionOfferKey  
                || string.isBlank(sessionOfferKey)  
                || string.isBlank(paramSessionKey)) 
        {   
            return false;   
        } else {   
            return true;    
        }   
    }   
    public pageReference isValidUserAction(){   
        if(!isValidUser()){ 
            return new pageReference('/apex/GenricErrorPage?errormessage=Not Authorized to see this page'); 
        }   
        return null;    
    }

}