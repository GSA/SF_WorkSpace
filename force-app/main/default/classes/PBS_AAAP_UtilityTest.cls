public with sharing class PBS_AAAP_UtilityTest {


    public static User createPortalUser() {
        return createPortalUser('');
    }

    private static integer AliasNum = 1;

    public static User createPortalUser(string suffix) {
        Profile p = [
                SELECT Name
                FROM Profile
                WHERE Name LIKE '%AAAP Customer Portal%'                
                LIMIT 1
        ];

        UserRole ur = [
                SELECT Name
                FROM UserRole
                WHERE Name LIKE '%GSA_Enterprise%'
                LIMIT 1
        ];

        User currentUser = [
                SELECT FirstName, LastName, Email
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];
        Account testAccount = new Account(Name = 'test'+suffix);
        insert testAccount;
        Contact c = new Contact(FirstName = 'test', LastName = 'test'+suffix, accountId = testAccount.Id);
        insert c;

           User u = new User(firstname = 'firstname', lastname = 'testlastname'+suffix, alias = 'testa'+string.valueOf(AliasNum++), email = 'test'+suffix+'@testorg.com', emailencodingkey = 'UTF-8',
                languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, timezonesidkey = 'America/Los_Angeles', //userroleid=ur.id,
                username = 'test'+suffix+'@testorg.com', street = '123 street', city = 'Vienna', state = 'Virginia', country = 'USA', postalcode = '22102', PBS_AAAP_PIN__c = '123456',
                phone = '202-202-2202', PBS_AAAP_StatesOfInterest__c = 'NCR',PBS_AAAP_Regions__c = 'National Capital Region;', contactId = c.Id);                
      
                
        insert u;  //Vaishali added 02/17/2016
        u.ManagerId = currentUser.Id;
        system.debug('*** testing PBS_AAAP_UtilityTest New User***' + u.Id); //Vaishali added 02/17/2016

        return u;
    }

// Vaishali added PBS_AAAP_ALLOW_TIER2_AMMORT__c in the select
    public static PBS_AAAP_RLP__c createRLP() {
        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c(PBS_AAAP_Category__c = 'Office', PBS_AAAP_DEFAULT_MONTH_END__c = '10',
                PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1', PBS_AAAP_DISCOUNT_RATE__c = 12.00,
                PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00,
                PBS_AAAP_Discount_percent_Rate__c = 5.00,
                PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50,
                PBS_AAAP_isActive__c = TRUE,
                PBS_AAAP_MOVE_DEFAULT__c = 2.00,
                PBS_AAAP_TELCOMM_DEFAULT__c = 2.00, PBS_AAAP_MAX_TIUSED__c = 52.00,
                PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 2.00, PBS_AAAP_Year__c = '2012',
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/Active',
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 20.00, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 4.00,
                PBS_AAAP_Title__c = 'Washington DC', PBS_AAAP_RLP_Number__c = '12-NCR', PBS_AAAP_ALLOW_TIER2_AMMORT__c = true, PBS_AAAP_BSAC_per_ABOA__c = 0);

        return rlp;
    }
    public static PBS_AAAP_RLP__c createFY17RLP() {
        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c(PBS_AAAP_Category__c = 'Office', PBS_AAAP_DEFAULT_MONTH_END__c = '10',
                PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1', PBS_AAAP_DISCOUNT_RATE__c = 12.00,
                PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00,
                PBS_AAAP_Discount_percent_Rate__c = 5.00,
                PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50,
                PBS_AAAP_MOVE_DEFAULT__c = 2.00,
                PBS_AAAP_isActive__c = TRUE,
                PBS_AAAP_TELCOMM_DEFAULT__c = 2.00, PBS_AAAP_MAX_TIUSED__c = 52.00,
                PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 2.00, PBS_AAAP_Year__c = '2017',
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/Active',
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 20.00, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 4.00,
                PBS_AAAP_Title__c = 'Washington DC', PBS_AAAP_RLP_Number__c = '17-NCR', PBS_AAAP_ALLOW_TIER2_AMMORT__c = true, PBS_AAAP_BSAC_per_ABOA__c = 0);

        return rlp;
    }
    public static PBS_AAAP_RLP__c createFY19RLP() {
        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c(PBS_AAAP_Category__c = 'Office', PBS_AAAP_DEFAULT_MONTH_END__c = '10',
                PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1', PBS_AAAP_DISCOUNT_RATE__c = 12.00,
                PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00,
                PBS_AAAP_Discount_percent_Rate__c = 5.00,
                PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50,
                PBS_AAAP_MOVE_DEFAULT__c = 2.00,
                PBS_AAAP_TELCOMM_DEFAULT__c = 2.00, PBS_AAAP_MAX_TIUSED__c = 52.00,
                PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 2.00, PBS_AAAP_Year__c = '2019',
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/Active',
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 20.00, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 4.00,
                PBS_AAAP_Title__c = 'Washington DC', PBS_AAAP_RLP_Number__c = '19-NCR', PBS_AAAP_ALLOW_TIER2_AMMORT__c = true, PBS_AAAP_BSAC_per_ABOA__c = 0,BSAC_for_Continuing_Space_per_ABOA_SF__c = 0);

        return rlp;
    }
//SGanti added method for RLP Year = 2022
  public static PBS_AAAP_RLP__c createFY22RLP() {
        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c(PBS_AAAP_Category__c = 'Office', PBS_AAAP_DEFAULT_MONTH_END__c = '3',
                PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1', PBS_AAAP_DISCOUNT_RATE__c = 12.00,
                PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00,
                PBS_AAAP_Discount_percent_Rate__c = 5.00,
                PBS_AAAP_ESCALATION_PRCNT_RATE__c = 2.50,
                PBS_AAAP_MOVE_DEFAULT__c = 2.00,
                PBS_AAAP_TELCOMM_DEFAULT__c = 2.00, PBS_AAAP_MAX_TIUSED__c = 52.00,
                PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 2.00, PBS_AAAP_Year__c = '2022',
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/Active',
                PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 20.00, PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 4.00,
                PBS_AAAP_Title__c = 'Washington DC', PBS_AAAP_RLP_Number__c = '19-NCR', PBS_AAAP_ALLOW_TIER2_AMMORT__c = true, PBS_AAAP_BSAC_per_ABOA__c = 0,BSAC_for_Continuing_Space_per_ABOA_SF__c = 0);

        return rlp;
    }    
    
    public static PBS_AAAP_Offer__c createOfferInfo() {
        return createOfferInfo('');
    }

    public static PBS_AAAP_Offer__c createOfferInfo(string suffix) {
        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Westin'+suffix, PBS_AAAP_Street_Address__c = '2521 Wasser Ter',
                PBS_AAAP_City__c = 'Herndon', PBS_AAAP_ZipCode__c = '20171', PBS_AAAP_State__c = 'VA', PBS_AAAP_County__c = 'Fairfax',
                PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Fee Simple', PBS_AAAP_HEATING_FUEL__c = 'Nuclear',
                PBS_AAAP_Representation__c = 'Small Business', PBS_AAAP_SMALL_DISADVANTAGED_IDENTIFIER__c = 'Yes',
                PBS_AAAP_Women_Owned_Identifier__c = 'Yes', PBS_AAAP_Veteran_Owned_Identifier__c = 'Yes',
                PBS_AAAP_SERVICE_DISABLED_IDENTIFIER__c = 'Yes', PBS_AAAP_HUBZONE_IDENTIFIER__c = 'Yes',
                PBS_AAAP_HUBZONE_JOINT_VENTURE__c = 'Yes', PBS_AAAP_HUBZONE_JOINT_VENTURE_NAMES__c = 'Other Names',
                PBS_AAAP_EEO_CLAUSE__c = 'Yes', PBS_AAAP_COMPLIANCE_REPORT__c = 'Yes', PBS_AAAP_Congressional_District__c = 'DC01',
                PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes', PBS_AAAP_AFFIRMATIVE_ACTION_CONTRACTS__c = 'Yes',
                PBS_AAAP_NAMES_RESP_FOR_DET_PRICES__c = 'Other Names', PBS_AAAP_Confirm_Owner_Status__c = 'Yes',
                PBS_AAAP_OWNER_CONVICTION__c = 'Yes', PBS_AAAP_OWNER_INDICTMENT__c = 'Yes', PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = 'Yes',
                PBS_AAAP_Owner_TIN_Status__c = 'KNOWN', PBS_AAAP_Owner_TIN_Assigned__c = '676786789',
                PBS_AAAP_TYPE_OF_ORG__c = 'Other', PBS_AAAP_TYPE_OF_ORG_OTHER__c = 'Other',
                PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes', PBS_AAAP_PARENT_NAME__c = 'Sam', PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = 'Yes',
                PBS_AAAP_Building_Sprinklered__c = 'Yes', PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes',
                PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes', PBS_AAAP_Year_Built__c = '2001', PBS_AAAP_OFFEROR_INTEREST__c = 'Owner',
                PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Other', PBS_AAAP_TYPE_OF_CONS_EXTERIOR_OTHER__c = 'Brick',
                PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Other', PBS_AAAP_TYPE_OF_CONS_ROOFING_MAT_OTHER__c = 'Roofing Brick',
                PBS_AAAP_Renovation_Year__c = '2001', PBS_AAAP_Close_To_Metro__c = 'Yes', PBS_AAAP_MetroRail_Station__c = 'Vienna',
                PBS_AAAP_OFFICE_SPACE_RSF__c = 2000.00, PBS_AAAP_RETAIL_SPACE_RSF__c = 2000.00, PBS_AAAP_GARAGE_SPACE_RSF__c = 1000.00,
                PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 14000.00, PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 12000.00,
                PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = 2000.00, PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = 3000.00, PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 13000.00,
                PBS_AAAP_Total_Park_Spaces_Offered__c = 100, PBS_AAAP_Free_Parking_Spaces_Offered__c = 20,
                PBS_AAAP_Option_Parking__c = 'Yes', PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true,
                PBS_AAAP_Owner_Name__c = 'Jack', PBS_AAAP_Owner_Address__c = '999 N Capitol St NE', PBS_AAAP_Owner_Country__c = 'United States',
                PBS_AAAP_Owner_City__c = 'Washington', PBS_AAAP_Owner_State__c = 'District of Columbia', PBS_AAAP_Owner_Zip__c = '20002',
                PBS_AAAP_Owner_Main_Phone__c = '201-222-1222', PBS_AAAP_Common_Parent_TIN__c = '23232323', PBS_AAAP_DUNS_Number__c = '123456789',
                PBS_AAAP_X_CO_ORD__c = -77.00896157, PBS_AAAP_Y_CO_ORD__c = 38.90251766, PBS_AAAP_COST_PER_ABOA__c = 0.0, PBS_AAAP_CERTIFICATION_DATE__c = Date.today(),
                PBS_AAAP_Number_of_floors__c = 4,PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM',
                PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 AM'
        );

        return offer;
    }
    public static PBS_AAAP_Offer__c createOfferInfo1() {
        PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c(PBS_AAAP_Building_Name__c = 'Westin', PBS_AAAP_Street_Address__c = '2521 Wasser Ter',
                PBS_AAAP_City__c = 'Herndon', PBS_AAAP_ZipCode__c = '20171', PBS_AAAP_State__c = 'VA', PBS_AAAP_County__c = 'Fairfax',
                PBS_AAAP_PROPERTY_OWNER_TYPE__c = 'Fee Simple', PBS_AAAP_HEATING_FUEL__c = 'Nuclear',
                PBS_AAAP_Representation__c = 'Small Business', PBS_AAAP_SMALL_DISADVANTAGED_IDENTIFIER__c = 'Yes',
                PBS_AAAP_Women_Owned_Identifier__c = 'Yes', PBS_AAAP_Veteran_Owned_Identifier__c = 'Yes',
                PBS_AAAP_SERVICE_DISABLED_IDENTIFIER__c = 'Yes', PBS_AAAP_HUBZONE_IDENTIFIER__c = 'Yes',
                PBS_AAAP_HUBZONE_JOINT_VENTURE__c = 'Yes', PBS_AAAP_HUBZONE_JOINT_VENTURE_NAMES__c = 'Other Names',
                PBS_AAAP_EEO_CLAUSE__c = 'Yes', PBS_AAAP_COMPLIANCE_REPORT__c = 'Yes', PBS_AAAP_Congressional_District__c = 'DC01',
                PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c = 'Yes', PBS_AAAP_AFFIRMATIVE_ACTION_CONTRACTS__c = 'Yes',
                PBS_AAAP_NAMES_RESP_FOR_DET_PRICES__c = 'Other Names', PBS_AAAP_Confirm_Owner_Status__c = 'Yes',
                PBS_AAAP_OWNER_CONVICTION__c = 'Yes', PBS_AAAP_OWNER_INDICTMENT__c = 'Yes', PBS_AAAP_OWNER_CONTRACT_DEFAULT__c = 'Yes',
                PBS_AAAP_Owner_TIN_Status__c = 'KNOWN', PBS_AAAP_Owner_TIN_Assigned__c = '676786789',
                PBS_AAAP_TYPE_OF_ORG__c = 'Other', PBS_AAAP_TYPE_OF_ORG_OTHER__c = 'Other',
                PBS_AAAP_CONTROLLED_BY_PARENT__c = 'Yes', PBS_AAAP_PARENT_NAME__c = 'Sam', PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c = 'Yes',
                PBS_AAAP_Building_Sprinklered__c = 'Yes', PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = 'Yes',
                PBS_AAAP_BLDG_Wide_Alarm_System__c = 'Yes', PBS_AAAP_Year_Built__c = '2001', PBS_AAAP_OFFEROR_INTEREST__c = 'Owner',
                PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c = 'Other', PBS_AAAP_TYPE_OF_CONS_EXTERIOR_OTHER__c = 'Brick',
                PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c = 'Other', PBS_AAAP_TYPE_OF_CONS_ROOFING_MAT_OTHER__c = 'Roofing Brick',
                PBS_AAAP_Renovation_Year__c = '2001', PBS_AAAP_Close_To_Metro__c = 'Yes', PBS_AAAP_MetroRail_Station__c = 'Vienna',
                PBS_AAAP_OFFICE_SPACE_RSF__c = 2000.00, PBS_AAAP_RETAIL_SPACE_RSF__c = 2000.00, PBS_AAAP_GARAGE_SPACE_RSF__c = 1000.00,
                PBS_AAAP_GEN_PURPOSE_RENTABLE__c = 14000.00, PBS_AAAP_OFFICE_SF_OFFERED_MAX__c = 12000.00,
                PBS_AAAP_OFFICE_SF_OFFERED_MIN__c = 2000.00, PBS_AAAP_MAX_CONT_ABOA_AVAIL__c = 3000.00, PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = 13000.00,
                PBS_AAAP_Total_Park_Spaces_Offered__c = 100, PBS_AAAP_Free_Parking_Spaces_Offered__c = 20,
                PBS_AAAP_Option_Parking__c = 'Yes', PBS_AAAP_ACCEPTED_TERMS_AND_COND__c = true,
                PBS_AAAP_Owner_Name__c = 'Jack', PBS_AAAP_Owner_Address__c = '999 N Capitol St NE', PBS_AAAP_Owner_Country__c = 'United States',
                PBS_AAAP_Owner_City__c = 'Washington', PBS_AAAP_Owner_State__c = 'District of Columbia', PBS_AAAP_Owner_Zip__c = '20002',
                PBS_AAAP_Owner_Main_Phone__c = '201-222-1222', PBS_AAAP_Common_Parent_TIN__c = '23232323', PBS_AAAP_DUNS_Number__c = '123456789',
                PBS_AAAP_X_CO_ORD__c = -77.00896157, PBS_AAAP_Y_CO_ORD__c = 38.90251766,
                PBS_AAAP_Energy_Star__c = 'Yes',
                PBS_AAAP_Number_of_floors__c = 50,
                PBS_AAAP_TYPE_OF_CONS_STRUCT__c = 'WOOD',
                PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = '8:00 AM',
                PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = '12:00 AM',
                PBS_AAAP_HIST_PROP_IN_HIST_DIST__c = 'Yes',
                PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c = 'No',
                PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c = 'Yes',
                PBS_AAAP_CERTIFICATION_DATE__c = Date.today(),
                PBS_AAAP_SITE_SIZE_SQFT__c = 10,
                PBS_AAAP_SITE_AREA_TYPE__c = 'Acres'
        );

        return offer;
    }

    public static PBS_AAAP_Space__c createSpace() {
        PBS_AAAP_Space__c space = new PBS_AAAP_Space__c(PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c = '$ Per ABOA SF', PBS_AAAP_ARCH_ENG_FEES__c = 20.00,
                PBS_AAAP_BASE_OPERATING_COSTS__c = 20.00, PBS_AAAP_DATE_SPACE_AVAILABILITY__c = Date.today(),
                PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c = 'VADCMA1234', PBS_AAAP_SF_OFFERED__c = 12000.00,
                PBS_AAAP_NEW_SUCCEED_LEASE_IND__c = false, PBS_AAAP_Total_ABOA_Awarded__c = 0,
                PBS_AAAP_Total_ABOA_Selected__c = 0, PBS_AAAP_Total_ABOA_Withdrawn__c = 0,
                PBS_AAAP_Total_ABOA_Edited__c = 0);

        return space;
    }

    public static PBS_AAAP_Other_Costs__c createOtherCosts() {
        PBS_AAAP_Other_Costs__c othercosts = new PBS_AAAP_Other_Costs__c(PBS_AAAP_COST__c = 10.00, PBS_AAAP_COST_TYPE__c = 'Other', PBS_AAAP_SHORT_DESC__c = 'Other Desc');

        return othercosts;
    }
//Vaishali added     PBS_AAAP_BSAC_RATE__c=0,PBS_AAAP_BSAC__c=0,PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c=0
    public static PBS_AAAP_Rate__c createRate() {
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c(PBS_AAAP_BASE_RATE__c = 10.00, PBS_AAAP_COST_FOR_TI__c = 10.00, PBS_AAAP_Vacant_Premise_Rate__c = 10.00,
                PBS_AAAP_LEASE_TERM__c = 'FiveYear', PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 10.00, PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 10.00,
                PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 10.00,
                PBS_AAAP_BSAC_RATE__c = 0, PBS_AAAP_BSAC__c = 0,
                PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 0,
                PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0,
                PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 3
        );

        return rate;
    }

    public static PBS_AAAP_Rate__c createRateFY19() {
        PBS_AAAP_Rate__c rate = new PBS_AAAP_Rate__c(PBS_AAAP_BASE_RATE__c = 10.00, PBS_AAAP_COST_FOR_TI__c = 10.00, PBS_AAAP_Vacant_Premise_Rate__c = 10.00,
                PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm', PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = 10.00, PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = 10.00,PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c = 10,
                PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = 10.00,
                PBS_AAAP_BSAC_RATE__c = 0, PBS_AAAP_BSAC__c = 0,
                PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c = 0,
                PBS_AAAP_OT_RATE_COOLING_HEAT__c = 0
        );

        return rate;
    }

    public static PBS_AAAP_Agency_Requirement__c createAgencyRequirement() {
        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c(PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1, PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 1,
                PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 1, PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 1,
                PBS_AAAP_LEASE_TERM__c = '5 Years', PBS_AAAP_MIN_CONT_USF__c = 10000, PBS_AAAP_OFFICIAL_NUM_PARKING_SPACES__c = 200,
                PBS_AAAP_WALKABLE_2640_FEET_METRO__c = 'Yes', PBS_AAAP_USF_REQ_MAX__c = 20000, PBS_AAAP_USF_REQ_MIN__c = 10000,
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_NICKNAME__c = 'Nick Name', PBS_AAAP_TYPE_OF_SPACE__c = 'Office',
                PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'New', PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'City', PBS_AAAP_RLP_Number__c = '12-NCR'
        );

        return agency;
    }
    public static PBS_AAAP_Agency_Requirement__c createAgencyRequirementFY19() {
        PBS_AAAP_Agency_Requirement__c agency = new PBS_AAAP_Agency_Requirement__c(PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c = 1, PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c = 1,
                PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c = 1, PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c = 1,
                PBS_AAAP_LEASE_TERM__c = '17 years, 15 firm', PBS_AAAP_MIN_CONT_USF__c = 10000, PBS_AAAP_OFFICIAL_NUM_PARKING_SPACES__c = 200,
                PBS_AAAP_WALKABLE_2640_FEET_METRO__c = 'Yes', PBS_AAAP_USF_REQ_MAX__c = 20000, PBS_AAAP_USF_REQ_MIN__c = 10000,
                PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_NICKNAME__c = 'Nick Name', PBS_AAAP_TYPE_OF_SPACE__c = 'Office',
                PBS_AAAP_TYPE_OF_REQUIREMENT__c = 'New', PBS_AAAP_DELINEATED_AREA_TYPE_DESC__c = 'City', PBS_AAAP_RLP_Number__c = '12-NCR'
        );

        return agency;
    }


}