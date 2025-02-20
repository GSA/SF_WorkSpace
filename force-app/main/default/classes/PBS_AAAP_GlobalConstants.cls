public class PBS_AAAP_GlobalConstants {

    /*** Offer Statuses ***/
    public static final String OFFERSTATUS_DRAFT = 'Draft';
    public static final String OFFERSTATUS_SUBMITTED = 'Submitted';
    //added by syam on 02/25 changed from 'Selected' to 'Pending Review'
    // public static final String OFFERSTATUS_SELECTED = 'Selected';
    public static final String OFFERSTATUS_SELECTED = 'Pending Review';
    public static final String OFFERSTATUS_AWARDED = 'Awarded';
    //added by syam on 02/26 changed from 'Awarded/Selected' to 'Awarded/Pending Review'
    public static final String OFFERSTATUS_AWARDED_SELECTED = 'Awarded/Pending Review';
    public static final String OFFERSTATUS_AWARDED_SUBMITTED = 'Awarded/Submitted';
    public static final String OFFERSTATUS_WITHDRAWN = 'Withdrawn';
    public static final String OFFERSTATUS_PENDINGMODIFICATION = 'Pending Modification';


    /*** RLP Statuses ***/
    public static String RLPSTATUS_DRAFT = 'Draft';
    public static String RLPSTATUS_CANCELED = 'Canceled';
    public static String RLPSTATUS_REPLACED = 'Replaced';
    public static String RLPSTATUS_POSTED_ACTIVE = 'Posted/Active';

    /*** Attachment Types for RLP ***/
    public static String RLP_ATTACHMENT_TYPE = 'Amendment';

    /*** Agency Requirement Statuses ***/
    public static String AGENCYREQSTATUS_PENDING = 'Pending';
    public static String AGENCYREQSTATUS_PENDINGSELECTED = 'Pending Selected';
    public static String AGENCYREQSTATUS_CANCELED = 'Canceled';
    public static String AGENCYREQSTATUS_AWARDED = 'Awarded';

    /*** Agency Requirement Constants ***/
    public static String DEL_AREA_TYPE = 'User Delineated Area';
    public static String ALT_DEL_AREA_TYPE = 'Alternate Delineated Area';
    public static String ALT_DEL_TYPE_DESC_SUBMARKET = 'SubMarket';
    public static String ALT_DEL_TYPE_DESC_CITY = 'City';
    public static String ALT_DEL_TYPE_DESC_ZIPCODE = 'Zip Code';
    public static String ALT_DEL_TYPE_DESC_CONG_DIST = 'Congressional District';
    public static String ALT_DEL_TYPE_DESC_COUNTY = 'County';
    public static String TYPE_OF_REK_NEW = 'New';
    public static String TYPE_OF_REK_CONTINUING = 'Continuing';

    // Customer Portal Account Name
    public static String CUSTOMER_PORTAL_ACCOUNT = 'AAAP PORTAL';
    public static String PORTAL_ACCOUNT_ID = '001V0000007wjJP';
    public static String CUSTOMER_PORTAL_ACCOUNT_Name = 'AAAP Customer Portal';

    // Constants used for cloning
    public static String OFFER_COPY = 'copy';
    public static String OFFER_MODIFY = 'modify';
    public static String OFFER_WITHDRAWN = 'Withdrawn';

    public static String YES = 'Yes';
    public static String NO = 'No';

    public static String BUILDING_COUNTRY = 'United States';

    public static String REPS_AND_CERTS_SMALL_BUSINESS = 'Small Business';
    public static String REPS_AND_CERTS_NOT_A_SMALL_BUSINESS = 'Not a Small Business';

    public static String REPS_AND_CERTS_WOSB = 'Women Owned Small Business';
    public static String REPS_AND_CERTS_NOT_A_WOSB = 'Not a Women Owned Small Business';

    public static String REPS_AND_CERTS_EDWOSB = 'Economically Disadvantaged Women Owned Small Business';
    public static String REPS_AND_CERTS_NOT_A_EDWOSB = 'Not an Economically Disadvantaged Women Owned Small Business';


    // Error message shown when user tries to register with an email which is already being registered.
    public static String ERROR_DUPLICATE_USER = 'A registered account has already been created using this email address.  Use the links at the top of the page to navigate to the AAAP or RSAP home page, where you can log-in or use the \'Forgot Your Password?\' feature.';

    // Error message for restricting user to see the other user offers
    public static String ERROR_INAVLID_ACCESS_OWNERSHIP = 'You are not authorised to view this offer. Please contact AAAP Manager if any questions.';


    // Building Page Error Messages
    public static String BUILDING_RLP_REQUIRED = '1. RLP field is required.';
    public static String BUILDING_NAME_REQUIRED = '2. Building Name field is required.';
    public static String PARKING_ON_SITE_REQUIRED = '2. Onsite parking response is required.';
    public static String BUILDING_STREET_REQUIRED = '3. Street Address field is required.';
    public static String BUILDING_CITY_REQUIRED = '4. City field is required.';
    public static String BUILDING_STATE_REQUIRED = '5. State field is required.';
    public static String BUILDING_ZIP_REQUIRED = '6. Zip Code is required.';
    //public static String BUILDING_SPRINKLED_REQUIRED = '1. Identify whether the building is fully sprinklered field is required.';
    //public static String BUILDING_STAIRWELL_REQUIRED = '2. At least 2 physically remote stairwells are required in the building.';
    //public static String BUILDING_ALARM_REQUIRED = '3. Identify whether the building has building wide alarm system field is required.';
    public static String BUILDING_ENERGY_STAR_REQUIRED = '6. Identify whether the building has earned ENERGY STAR Label field is required. ';
    public static String BUILDING_ENERGY_STAR_NO_REQUIRED = '6.  Input "TBD" if you have no energy efficiency information at this time.';
    public static String BUILDING_ENERGY_STAR_DATE_OF_CERTIFICATION_REQUIRED = '6. Date of Certification for Energy Star label is missing.';
    public static String BUILDING_NUM_OF_FLOORS = '7. Number of floors is required and cannot be a negative number.';//JK changed 7/2021
    public static String BUILDING_TOTAL_RSF = '4. Total amount of rentable square feet (RSF) in the building is required.';//JK changed 7/2021
    public static String BUILDING_ANSI_BOMA_SF = '5. Total ANSI/BOMA Office Area Square Feet (ABOA) in the building is required.';//JK changed 7/2021
    public static String BUILDING_STRUCTURAL_FRAME = '15. Type of construction - structural frame field is missing.';
    public static String BUILDING_EXTERIOR_WALLS = '12. Year building constructed is required information.';
    public static String BUILDING_ROOFING_MATERIAL = '17. Type of construction - roofing material field is missing.';
    public static String BUILDING_YEAR_CONSTRUCTED = '8. Year building constructed is required information.';//JK changed 7/2021
    public static String BUILDING_METRO = '5. Proximity to public transportation field is required.';
    //public static String BUILDING_METRO_STATION = '18 a. Identify type and/or location of nearest public transportation.';
    public static String BUILDING_HVAC_M_F_START = '10. HVAC Hours of operation start (M-F) field is missing.';//JK changed 7/2021
    public static String BUILDING_HVAC_M_F_END = '10. HVAC Hours of operation end (M-F) field is missing.';//JK changed 7/2021
    public static String BUILDING_HVAC_SAT = '19. HVAC available on Saturday field is missing.';
    public static String BUILDING_HVAC_SUN = '19. HVAC available on Sunday field is missing. ';
    public static String BUILDING_HPHD = '7. Identify whether the property offered is a historic property is required.';
    public static String BUILDING_NHP_WITHIN_HD = '8. Identify whether the property offered is within a historic district is required.';
    //public static String BUILDING_HP_OUTSIDE_HD = '22. Identify whether the property offered is a historic property outside of a historic district.';
    public static String BUILDING_SEISMIC_ZONE = '11. Building location in relation to seismic zones must be indicated before you can proceed.';
    public static String SEISMIC_SAFETY_REQUIRED = '11a. Please select an option for the Seismic Safety question.';
    public static String SEISMIC_ZONE_BUILDING_TYPE = '11b. Selecting "None" is not allowed for the Seismic Zone responses. Please select "Unknown/Not Listed" if you are not yet able to identify with the other options listed.';
    public static string BUILDING_COUNTY_REQUIRED = '6a. County is required';
    public static String SITE_AREA_TYPE_REQ = '9. Site Size radio button required.';
    //public static string BUILDING_LIVE_FLOOR_LOAD_REQUIRED = '11. Live floor load is required.  Enter TBD if information is not readily available.';
    public static string BUILDING_SITE_SIZE_REQUIRED = '9. Site Size is missing.  "Square Feet" or "Acres" must be selected.';
    public static string BUILDING_RENNOVATION_REQUIRED = '9. Year of most recent building renovation is required information.';
    public static string BUILDING_HUBZONE_SBC_STATUS = '9. Hubzone SBC status is required.';
    public static string BUILDING_HUBZONE_SBC_PREFERENCE = '9a. Select price evaluation waiver preference.';
    public static string BUILDING_REHABILITATION = '10. Indicate if a complete rehabilitation or extensive renovation is proposed.';
//SGanti renumbered 8/2021    
    public static string BUILDING_REHABILITATION_ACKNOWLEDGEMENT = '10a. If you select "Yes" to question #10, you must check the acknowledgement box to proceed.';
    public static string BUILDING_REAL_ESTATE_TAXES_REQ = '11. Annual Real Estate Taxes is required.';//JK changed 7/2021
    public static string BUILDING_INSURANCE_REQ = '12. Annual Insurance amount is required.';//JK changed 7/2021
    public static string BUILDING_BUILDING_MAINTENANCE_REQ = '13. Annual building maintenance is required.';//JK changed 7/2021
    public static string BUILDING_LEASE_COMMISSION_REQ = '14. Lease commision is required.';//JK changed 7/2021
    public static string BUILDING_MANAGEMENT = '15. Annual management cost is required';//JK changed 7/2021
//SGanti added 8/2021
    public static String BUILDING_FIRE_LIFE_MEETS = '1. Fire Protection & Life Safety field is required. ';
    public static String BUILDING_ACCESSIBILITY = '2. Accessibility field is required. ';
    public static String BUILDING_ASBESTOS = '3. Asbestos Containing Material (ACM) field is required. ';
    public static String BUILDING_FLOOD_PLAINS = '4. Flood Plains field is required.';

    public static String LOP_BUILDING_NAME_REQUIRED = '1. Building Name field is required.';
    public static String LOP_BUILDING_STREET_REQUIRED = '2. Street Address field is required.';
    public static String LOP_BUILDING_CITY_REQUIRED = '3. City field is required.';
    public static String LOP_BUILDING_STATE_REQUIRED = '4. State field is required.';
    public static String LOP_BUILDING_ZIP_REQUIRED = '5. 9-Digit Zip Code is required.';
    public static String LOP_BUILDING_NUM_OF_FLOORS = '6. Number of floors is required and cannot be a negative number';
    public static String LOP_BUILDING_SPRINKLED_REQUIRED = '8. Identify whether the building is fully sprinklered field is required.';
    public static String LOP_BUILDING_STAIRWELL_REQUIRED = '9. At least 2 physically remote stairwells are required in the building.';
    public static String LOP_BUILDING_ALARM_REQUIRED = '10. Identify whether the building has building wide alarm system field is required.';
    public static String LOP_BUILDING_YEAR_CONSTRUCTED = '10. Year constructed field is missing. ';
    public static String LOP_BUILDING_ENERGY_STAR_REQUIRED = 'Building Information Page: 17. Energy Star response is required.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_ENERGY_STAR_NO_REQUIRED = 'Building Information Page: 17a. Energy Star certification date is required.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_ENERGY_STAR_DATE_OF_CERTIFICATION_REQUIRED = 'Building Information Page: 17a. Energy Star declaration is required.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_TOTAL_RSF = '4. Total amount of rentable square feet (RSF) in the building is required';
    public static String LOP_BUILDING_HVAC_M_F_START = '11. HVAC Hours of operation start (M-F) field is missing.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_HVAC_M_F_END = '11. HVAC Hours of operation end (M-F) field is missing.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_HISTORIC_QUALIFICATION = '15. Select Historic qualification of the building.';
    public static String LOP_BUILDING_ACCESSIBILITY_STANDARDS = 'Building Information Page: 13. Accessibility standards information is required.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_ACM_STANDARDS = '14. Select Asbestos-Containing Materials (ACM) standards of the building.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_SEISMIC_SAFETY_REQ = '16. Select RLP seismic  safety requirement for the lease.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_SEISMIC_SAFETY_QUAL = '16a. Select seismic  safety qualification of the building.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_FLOOD_PLAINS = '15. Select Flood Plains qualification of the building.';//SGanti renumbered 11/2021
    public static String LOP_BUILDING_FIRE_PROTECTION = '12. Select  Fire Protection and Life Safety qualification of the building.';//SGanti renumbered 11/2021
    public static String LOP_GEN_PURPOSE_RENTABLE_SUM_MSG = '7. Total amount of rentable square feet (RSF) in the building should equal to Total of 7a. General Purpose, 7b. Warehouse and 7c. Other SQFT.';
    //SGanti added 11/2021
    public static String LOP_BUILDING_HISTORIC_PROPERTY = '18. Identify whether the building is a historic property.';
    public static String LOP_BUILDING_HISTORIC_DISTRICT = '19. Identify whether the building is in a historic district.';
    
    public static String LOP_BUILDING_ENERGY_STAR_NO_CATEGORY_REQUIRED = '17a. Energy Star category is required.';
    public static String LOP_BUILDING_ENERGY_STAR_NO_STATUTORY_EXCEPTION_REQUIRED = '17a. Energy Star statutory exception information is required.';
    //added by syam 03/14
    public static String PBS_AAAP_X_CO_ORD_REQ = 'Latitude is required, Please validate the address again.';
    public static String PBS_AAAP_Y_CO_ORD_REQ = 'Longitude is required, Please validate the address again.';

    
    
    // Parking page Error Messages  
    public static String PARKING_OPTION_REQUIRED = '5. Option for parking (Parking Page) field is missing.';

    // Property Owner page Error Messages

    public static String PROP_OWNER_NAME_REQUIRED = '1. Property owner name field is required.';
    public static String PROP_OWNER_ADDRESS = '2. Property owner address field is required.';
    public static String PROP_OWNER_COUNTRY = '3. Property Owner country  is required.';
    public static String PROP_OWNER_CITY = '3. Property Owner City is required.';
    public static String PROP_OWNER_STATE = '4. Property Owner State is required.';
    public static String PROP_OWNER_ZIP = '5. Property Owner Zip is required.';
    public static String PROP_OWNER_PHONE = '7. Property owner main phone number field is required.';
    public static String PROP_OWNER_TYPE = '8. Property owner relationship to Offeror field is required.';
    public static String PROP_OWNER_TYPE_LOP = '6. Property owner relationship to Offeror field is required.';
    public static String PROP_OWNER_EID_LOP = '7. Property owner Unique Entity Identifier (UEI) is required.';
    public static String PROP_OWNER_ORG_TYPE = '9. Type of organization field is required.';
    public static String PROP_OWNER_OFFEROR_INTEREST = '12. Offeror interest indicator field is required.';
    public static String PROP_OWNER_CONTROL_PARENT = '13. Controlled by parent indicator field is required.';
    public static String PROP_OWNER_COMMON_PARENT = '13a. Name of common parent is required.';
    public static String PROP_OWNER_PARENT_TIN = '13b. Common parent TIN # is required.';
    public static String PROP_OWNER_DUNS = '9. DUNS # field is required.';
    public static String PROP_OWNER_TIN_STATUS = '15. Property owner TIN Status field is required.';
    public static String PROP_OWNER_TIN_NUM = '15a. Property owner TIN # field is required.';
    public static String PROP_OWNER_COMPANY_REQUIRED = '1. Name of the property recorded owner is required.';
    //Lease Terms Error Messages
    //public static String CONFIRM_NO_OF_YEARS_OFFERED_REQUIRED = 'Lease Terms and Conditions Page: Number of years offered  field is missing (#1 Initial Lease Term section).';
    //public static String CONFIRM_YEARS_FIRM_REQUIRED = 'Lease Terms and Conditions Page: Number of years firm field is missing (#2 Initial Lease Term section).';

    // Reps and Certs Error Messages

    public static String REPSCERTS_REPRESENTATION_REQUIRED = '1. Representation (Small business/Not a small business) (REPS & CERTS Page) field is missing.';
    public static String REPSCERTS_WOMEN_OWNED = '1b. Woman owned identifier (Property Owner Page) field is missing.';
    public static String REPSCERTS_WOSB_DOC_COMPLETE = '1b1. WOSB documentation completion field is missing.';
    public static String REPSCERTS_WOSB_JOINT_VENTURE = '1b2. WOSB Joint venture field is missing.';
    public static String REPSCERTS_EDWOSB_DOC_COMPLETE = '1b3. WOSB documentation completion field is missing.';
    public static String REPSCERTS_EDWOSB_JOINT_VENTURE = '1b4. WOSB Joint venture field is missing.';
    public static String REPSCERTS_EEO_CLAUSE = '2. EEO Clause indicator field is required.';
    public static String REPSCERTS_AFFIRMATIVE_ACTION = '3. Affirmative action program indicator field is required.';
    public static String REPSCERTS_CERTIFICATE_OF_SIGNATORY = '4. Certification of signatory indicator field is missing.';
    public static String REPSCERTS_CONFIRM_OWNER_STATUS = '5. Confirm on property owner status indicator field is required.';
    public static String REPSCERTS_OWNER_CONVICTION = '6. Property owner conviction indicator field is required.';
    public static String REPSCERTS_OWNER_INDICTMENT = '7. Property owner indictment indicator field is required.';
    public static String REPSCERTS_OWNER_FEDTAX_DEFAULT = '8. Property owner federal tax delinquency field is required.';
    public static String REPSCERTS_OWNER_CONTRACT_DEFAULT = '10. Property owner contract default indicator field is required.';
    public static String REPSCERTS_CCR_REGISTRATION = '11. CCR registration active status field is required.';
    public static String REPSCERTS_SMALL_BUSINESS_YES = 'You must select "YES" for at least one of these questions (1a, 1b, 1c and 1e).';
    public static String REPSCERTS_CORP_FELONY_CONVICTION = '2a. Corporation federal tax delinquency field is required.';
    public static String REPSCERTS_CORP_FEDTAX_DEFAULT = '2b. Corporation criminal conviction field is required.';
    // Space and Rates error messages
    public static String OFFER_SPACE_MAX_OFFERED_SPACE = 'Please provide a value for "Total SF available" and "Max contiguous ABOA available".';
    public static String OFFER_ABOA_SPACE_MAX_OFFERED = 'The value for the total ANSI/BOMA Office Area SF available for lease to the Government (Question 1 on this Space Summary Page) cannot exceed the total ANSI/BOMA Office Area SF in the building (Question 8 on the Building Fundamentals tab).';
    public static String OFFER_SPACE_MAX_SPACE_VS_BOMA = '2. The amount of contiguous ABOA SF available entered in question #2 cannot exceed the amount of total ABOA SF available for lease entered in question #1.';
    public static String LOP_SPACE_RATES_ANSI_BOMA_SF = 'Space and Parking Page: Space Offered: 1. Please provide a value for ANSI/BOMA Office Area Square Feet (ABOA SF) offered.';
    public static String LOP_SPACE_RATES_RSF = 'Space and Parking Page: Space Offered: 2. Please provide a value for Rentable Square Feet (RSF) offered.';
    public static String LOP_SPACE_RATES_ONSITE = 'Space and Parking Page: Parking Offered: 2. Please enter Yes or No for whether all parking is onsite.';
    public static String LOP_SPACE_RATES_ALLPARKING = 'Space and Parking Page: Parking Offered: 4. Please provide a value or 0 for all monthly parking rates.';
    //public static String LOP_SPACE_RATES_RSF_GT_ABOA = 'Space and Parking Page: #2. Rentable Square Feet (RSF) offered should be greater than #1. ANSI/BOMA Office Area Square Feet (ABOA SF) Offered.';
    public static String LOP_SPACE_RATES_SHELL_RENT_PER_RSF = 'Space and Rates Page : Please enter the value for Shell Rate (Annual Rent per RSF).';
    public static String LOP_SPACE_RATES_SHELL_RATE_YRS_EFFECTIVE = 'Space and Rates Page : Please enter the value for Shell Rate (#Yrs Effective).';
    //public static String LOP_SPACE_RATES_ANNUAL_RENT_PARKING = 'Space and Rates Page: Please select value for \'Does annual Rent include Parking?\'';
    // Constants
    public static String TIN_KNOWN = 'KNOWN';

    // Identify Winner Error Messages
    public static String IDENTIFY_WINNER_ERROR = 'You already have an Offer selected for this Agency Requirement. You need to "Deselect" first and then perform Identify Winner.';

    public static String DESELECT_REASON_REQUIRED = 'Reason is required.';
    public static String DESELECT_COMMENTS_REQUIRED = 'Comments are required.';

    // modified 5-10-2012 by CRH, to include selection of County and Congressional Districts    
    //*** Vaishali added p.PBS_AAAP_WOSB_Joint_Venture__c,P.PBS_AAAP_WOSB_Docs_Complete__c,P.PBS_AAAP_EDWOSB_Joint_Venture__c,P.PBS_AAAP_EDWOSB_Docs_Complete__c,p.PBS_AAAP_FederalTax_Delinquent__c,
    //***Vaishali added p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Posted_Date__c so that whenever there is a new RLP, user is forced to review rates and save
    ///Syam added 2 fields as part of FY16 PBS_AAAP_Certification_Date__c,PBS_AAAP_SITE_SIZE_SQFT__c, PBS_AAAP_SITE_AREA_TYPE__c,PBS_AAAP_Sam_Registered__c
    //7.26.2020 Julia added 1 field PBS_AAAP_Rental_Concessions__c
    //SGanti added fields to the query 08/2021 for AAAP
    //SGanti added fields to the query 09/2021 for RSAP
    public static PBS_AAAP_Offer__c getOfferDetail(string ofrid) {

        PBS_AAAP_Offer__c offer = [
                SELECT p.SystemModstamp,p.LastModifiedById, p.PBS_AAAP_can_withdraw__c,p.PBS_AAAP_Solicitation_Number__c,p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Year_Built__c, p.PBS_AAAP_Y_CO_ORD__c,
                        p.PBS_AAAP_X_CO_ORD__c, p.PBS_AAAP_Women_Owned_Identifier__c, p.PBS_AAAP_Veteran_Owned_Identifier__c,p.PBS_AAAP_Approximate_Construction_Level__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c,
                        p.PBS_AAAP_Total_Withdraw_Space_Available__c, p.PBS_AAAP_Total_Parking_Spaces__c, p.PBS_AAAP_Total_Park_Spaces_Offered__c,
                        p.PBS_AAAP_Temp_Offer_ID__c, p.PBS_AAAP_TYPE_OF_ROOFING_MATERIAL__c, p.PBS_AAAP_TYPE_OF_ORG__c, p.PBS_AAAP_TYPE_OF_ORG_OTHER__c,
                        p.PBS_AAAP_TYPE_OF_CONS_STRUCT__c, p.PBS_AAAP_TYPE_OF_CONS_STRUCT_OTHER__c, p.PBS_AAAP_TYPE_OF_CONS_ROOFING_MAT_OTHER__c,
                        p.PBS_AAAP_TYPE_OF_CONS_EXTERIOR__c, p.PBS_AAAP_TYPE_OF_CONS_EXTERIOR_OTHER__c, p.PBS_AAAP_TOTAL_OTHER_COSTS__c, p.PBS_AAAP_Common_Parent_TIN__c,
                        p.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c, p.PBS_AAAP_Street_Address__c, p.PBS_AAAP_State__c, p.PBS_AAAP_Signature_First_Name__c,
                        p.PBS_AAAP_SSTAX_WORKCOMP__c, p.PBS_AAAP_SRVC_UTIL_TOTAL__c, p.PBS_AAAP_SMALL_DISADVANTAGED_IDENTIFIER__c, p.PBS_AAAP_SIGNATURE_PIN__c,
                        p.PBS_AAAP_SIGNATURE_MIDDLE_NAME__c, p.PBS_AAAP_SIGNATURE_LAST_NAME__c, p.PBS_AAAP_SIGNATURE_LAST_4DIGITS_SSN__c, p.PBS_AAAP_SIGNATURE_DOB__c,
                        p.PBS_AAAP_SIGNATURE_DATE__c, p.PBS_AAAP_SERVICE_DISABLED_IDENTIFIER__c, p.PBS_AAAP_SECURITY__c, p.PBS_AAAP_SECT2_TOTAL__c,
                        p.PBS_AAAP_Representation__c, p.PBS_AAAP_Renovation_Year__c, p.PBS_AAAP_RU_FACTOR__c, p.PBS_AAAP_RLP_TI_New_Space__c, p.PBS_AAAP_RLP_Region__c,
                        p.PBS_AAAP_RLP_TI_Additional_Space__c, p.PBS_AAAP_RLP_Number__c, p.PBS_AAAP_RLP_MAX_TIA__c, p.PBS_AAAP_RETAIL_SPACE_RSF__c,
                        p.PBS_AAAP_REAL_ESTATE_TAXES__c, p.PBS_AAAP_Property_Phone_Extn__c, p.PBS_AAAP_Partial_Secured_GAR_PARK_SPACE__c, p.PBS_AAAP_Parent_Offer__c,
                        p.PBS_AAAP_PROPERTY_OWNER_TYPE__c, p.PBS_AAAP_PLUMBING_WATER__c, p.PBS_AAAP_PLUMBING_SUPPLIES__c, p.PBS_AAAP_PLUMBING_MAINTENANCE__c,
                        p.PBS_AAAP_PARENT_NAME__c, p.PBS_AAAP_Owner_Zip__c, p.PBS_AAAP_Owner_TIN_Status__c, p.PBS_AAAP_Owner_TIN_Assigned__c, p.PBS_AAAP_Owner_State__c,
                        p.PBS_AAAP_Owner_State_Reg__c, p.PBS_AAAP_Owner_Name__c, p.PBS_AAAP_Owner_Main_Phone__c, p.PBS_AAAP_Owner_Country__c,
                        p.PBS_AAAP_Owner_Country_Reg__c, p.PBS_AAAP_Owner_City__c, p.PBS_AAAP_Owner_Alt_Phone__c, p.PBS_AAAP_Owner_Address__c,
                        p.PBS_AAAP_Option_Parking__c, p.PBS_AAAP_Offer_Status__c, p.PBS_AAAP_OWN_NOT_REQ_REASON__c, p.PBS_AAAP_OWNER_INDICTMENT__c,
                        p.PBS_AAAP_OWNER_CONVICTION__c, p.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c, p.PBS_AAAP_OFFICE_SPACE_RSF__c, p.PBS_AAAP_OFFICE_SF_OFFERED_MIN__c,
                        p.PBS_AAAP_OFFICE_SF_OFFERED_MAX__c, p.PBS_AAAP_OFFER_NUMBER__c, p.PBS_AAAP_OFFEROR_INTEREST__c, p.PBS_AAAP_OFFEROR_INTEREST_OTHER__c,
                        p.PBS_AAAP_Number_of_gar_parking_spaces__c, p.PBS_AAAP_Number_of_floors__c, p.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c,
                        p.PBS_AAAP_NAMES_RESP_FOR_DET_PRICES__c, p.PBS_AAAP_Monthly_cost_res_sur_park__c, p.PBS_AAAP_Monthly_cost_res_gar_park__c,
                        p.PBS_AAAP_Monthly_cost_nonres_sur_park__c, p.PBS_AAAP_Monthly_cost_nonres_gar_park__c, p.PBS_AAAP_MetroRail_Station__c,
                        p.PBS_AAAP_MAX_CONT_ABOA_AVAIL__c, p.PBS_AAAP_MANAGEMENT__c, p.PBS_AAAP_LIVE_FLOOR_LOAD__c, p.PBS_AAAP_LEGACY_SFO_ID__c,
                        p.PBS_AAAP_LEGACY_PARENT_ID__c, p.PBS_AAAP_LEGACY_OFFER_NUMBER__c, p.PBS_AAAP_LEASE_COMMISSION__c, p.PBS_AAAP_LANDSCAPING_MAINTENANCE__c,
                        p.PBS_AAAP_Is_Offer_Valid__c, p.PBS_AAAP_IS_HVAC_AVAIL_ON_SUN__c, p.PBS_AAAP_IS_HVAC_AVAIL_ON_SAT__c, p.PBS_AAAP_INSURANCE__c,
                        p.PBS_AAAP_HVAC_HRS_ON_SUN_START__c, p.PBS_AAAP_HVAC_HRS_ON_SUN_END__c, p.PBS_AAAP_HVAC_HRS_ON_SAT_START__c, p.PBS_AAAP_HVAC_HRS_ON_SAT_END__c,
                        p.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c, p.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c, p.PBS_AAAP_HUBZONE_JOINT_VENTURE__c,
                        p.PBS_AAAP_HUBZONE_JOINT_VENTURE_NAMES__c, p.PBS_AAAP_HUBZONE_IDENTIFIER__c, p.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c,
                        p.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c, p.PBS_AAAP_HEATING_SALARIES__c, p.PBS_AAAP_HEATING_MAINTENANCE__c, p.PBS_AAAP_HEATING_FUEL__c,
                        p.PBS_AAAP_HEATING_FUEL_COST__c, p.PBS_AAAP_GEN_PURPOSE_RENTABLE__c, p.PBS_AAAP_GARAGE_SPACE_RSF__c, p.PBS_AAAP_Free_Parking_Spaces_Offered__c,
                        p.PBS_AAAP_FIRE_SAFETY_REQ_FLOORS1TO6__c, p.PBS_AAAP_FIRE_SAFETY_CERT__c, p.PBS_AAAP_Energy_Star__c, p.PBS_AAAP_Energy_Star_Reason__c,
                        p.PBS_AAAP_ELEVATOR_SALARIES__c, p.PBS_AAAP_ELEVATOR_MAINTENANCE__c, p.PBS_AAAP_ELECTRICAL_SPECIALEQUIP__c, p.PBS_AAAP_ELECTRICAL_REPLACEMENT__c,
                        p.PBS_AAAP_ELECTRICAL_POWER__c, p.PBS_AAAP_ELECTRICAL_MAINTENANCE__c, p.PBS_AAAP_EEO_CLAUSE__c, p.PBS_AAAP_Default_Start__c,
                        p.PBS_AAAP_Default_End__c, p.PBS_AAAP_DUNS_Number__c, p.PBS_AAAP_Country__c, p.PBS_AAAP_Close_To_Metro__c, p.PBS_AAAP_City__c,
                        p.PBS_AAAP_COST_TYPE__c, p.PBS_AAAP_COST_PER_ABOA__c, p.PBS_AAAP_CONTROLLED_BY_PARENT__c, p.PBS_AAAP_COMPLIANCE_REPORT__c,
                        p.PBS_AAAP_CLEANING_SUPPLIES__c, p.PBS_AAAP_CLEANING_SALARIES__c, p.PBS_AAAP_CLEANING_CONTRACT_SERVICES__c, p.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c,
                        p.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c, p.PBS_AAAP_Building_Sprinklered__c, p.PBS_AAAP_Building_Name__c, p.PBS_AAAP_BUILDING_MAINTENANCE__c,
                        p.PBS_AAAP_BLD_INCOME_PERCENT_RET_SPACE__c, p.PBS_AAAP_BLD_INCOME_PERCENT_OFF_SPACE__c, p.PBS_AAAP_BLD_INCOME_PERCENT_GAR_SPACE__c,
                        p.PBS_AAAP_BLDG_Wide_Alarm_System__c, p.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c, p.PBS_AAAP_BLDG_ENGINEERCOST__c, p.PBS_AAAP_Confirm_Owner_Status__c,
                        p.PBS_AAAP_Annual_cost_entire_garage_park__c, p.PBS_AAAP_AUTHORIZED_SIGNATORY__c, p.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c,
                        p.PBS_AAAP_AFFIRMATIVE_ACTION_CONTRACTS__c, p.PBS_AAAP_AC_UTILITIES__c, p.PBS_AAAP_AC_MAINTENANCE__c, p.PBS_AAAP_ACK_REPRESENT_OTHERS__c,
                        p.PBS_AAAP_ACK_REPRESENT_MULT_OWNERS__c, p.PBS_AAAP_ACK_LTR_COMPLETED__c, p.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c, p.PBS_AAAP_Offer_Submission_Date__c,
                        p.PBS_AAAP_ACCEPTED_REP_CERT_FORM_3518__c, p.PBS_AAAP_ACCEPTED_PROV_FORM_3516__c, p.PBS_AAAP_ACCEPTED_GEN_FORM_3517__c, p.OwnerId, p.Name, p.Id,
                        p.PBS_AAAP_WOSB_Joint_Venture__c,P.PBS_AAAP_WOSB_Docs_Complete__c,P.PBS_AAAP_EDWOSB_Joint_Venture__c,P.PBS_AAAP_EDWOSB_Docs_Complete__c,
                        p.EDWOSB_Joint_Venture_Names__c, p.WOSB_Joint_Venture_Names__c,p.PBS_AAAP_FederalTax_Delinquent__c,p.PBS_AAAP_Corporation_not_tax_felon__c,
                        p.PBS_AAAP_Corp_Not_Convicted_Felon__c, p.PBS_AAAP_County__c, p.PBS_AAAP_Congressional_District__c,
                        p.PBS_AAAP_HUBZone_SBC_Offeror__c, p.Property__r.PBS_AAAP_MetroWalkable__c, p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Region__c,
                        p.PBS_AAAP_RLP_Number__r.PBS_AAAP_Posted_Date__c,p.lastmodifieddate, p.PBS_AAAP_Certification_Date__c,p.PBS_AAAP_SITE_SIZE_SQFT__c, p.PBS_AAAP_SITE_AREA_TYPE__c,
                        p.PBS_AAAP_Total_Struct_Park_Space_Offered__c, p.PBS_AAAP_Total_Surface_Parking_Spaces__c, p.PBS_AAAP_Total_Structured_Parking_Spaces__c, p.PBS_AAAP_Total_Surf_Park_Space_Offered__c,
                        p.PBS_AAAP_Sam_Registered__c,p.PBS_AAAP_Vacant_Premise_Rate__c,p.CREATEDBYID,
                        p.PBS_AAAP_isMetroProximity__c,p.PBS_AAAP_isHistoricProperty__c,p.PBS_AAAP_isEnergyStar__c,p.Formula_RLP_Num__c,
                        p.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c,p.PBS_AAAP_BUILDING_CODE__c,p.PBS_AAAP_BUILDING_CODE_YEAR__c,p.PBS_AAAP_BUILDING_TYPE__c,p.PBS_AAAP_HubZone_SBC__c,p.PBS_AAAP_HubZone_SBC_Preference__c,
                        p.PBS_AAAP_Reconstruction__c,p.PBS_AAAP_Reconstruction_Acknowledgement__c,p.PBS_AAAP_Offeror__r.Name,p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c,
                        p.PBS_RSAP_Year_Built__c,p.PBS_RSAP_Accessibility_Standards_Met__c,p.PBS_RSAP_Asbestos_Declaration__c,p.PBS_RSAP_Are_you_offering_renewal_option__c,p.PBS_RSAP_Offeror_Seismic_Declaration__c,p.PBS_RSAP_Flood_Plain_Declaration__c,
                        p.PBS_AAAP_Offeror__r.Email,p.PBS_RSAP_Emp_Visitor_Surface_Spaces__c,p.PBS_RSAP_Emp_Visitor_Structured_Spaces__c,p.PBS_RSAP_GOV_Surface_Spaces__c,p.PBS_RSAP_GOV_Structured_Spaces__c,
                        p.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c,p.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c,p.PBS_RSAP_Property_Owner_Same_as_Offeror__c,p.PBS_AAAP_Government_Occupancy_Pct__c,p.PBS_AAAP_SHELL_Build_out_Costs__c,
                        p.PBS_AAAP_TI_Total_Build_out_Costs__c,p.PBS_AAAP_TI_Amorization_in_Years__c,p.PBS_AAAP_TI_Amorti_Interest_Rate__c,p.PBS_AAAP_BSAC_Total_Build_out_Costs__c,
                        p.PBS_AAAP_BSAC_Amorization_in_Years__c,p.PBS_AAAP_BSAC_Amorti_Interest_Rate__c,p.PBS_AAAP_RLP_Parking_Cost_Incl__c,p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c,p.PBS_AAAP_Renewal_Shell_Rate__c,
                        p.PBS_AAAP_Renewal_YEARS_EACH__c,p.PBS_AAAP_Renewal_NO_OF_OPTIONS__c,p.PBS_AAAP_Renewal_Days_Exercise_Option__c,p.PBS_AAAP_Is_Shell_Rent_Stepped__c,p.PBS_AAAP_Step_1_Start__c,
                        p.PBS_AAAP_Step_1_End__c,p.PBS_AAAP_Step_2_Start__c,p.PBS_AAAP_Step_2_End__c,p.PBS_AAAP_Step_3_Start__c,p.PBS_AAAP_Step_3_End__c,p.PBS_AAAP_Step_1_Rent_Per_RSF__c,
                        p.PBS_AAAP_Step_2_Rent_Per_RSF__c,p.PBS_AAAP_Step_3_Rent_Per_RSF__c,p.PBS_AAAP_Step_1_Rent_Per_ABOA__c,p.PBS_AAAP_Step_2_Rent_Per_ABOA__c,p.PBS_AAAP_Step_3_Rent_Per_ABOA__c,
                        p.PBS_AAAP_Annual_TI_Rent__c,p.PBS_AAAP_Anual_BSAC_Rent__c,p.PBS_RSAP_TIA_Or_Turnkey__c,p.PBS_AAAP_Building_Common_Area_Factor__c,p.PBS_AAAP_TI_Buildout_as_in_RLP__c,p.PBS_AAAP_BSAC_Years_Rate_Effective__c,
                        p.PBS_AAAP_TI_Years_Rate_Effective__c,p.PBS_AAAP_Total_Ofc_ABOA_offered__c,p.PBS_RSAP_Total_TI_Turnkey__c,p.PBS_AAAP_Office_RSF_OFFERED__c,p.PBS_RSAP_Shell_Initial_Annual__c,p.PBS_RSAP_Shell_Rent_Per_RSF_Initial__c,p.PBS_RSAP_Shell_Rent_Per_ABOA_Initial__c,
                        p.PBS_AAAP_OP_COST_COST_PER_RSF__c,p.PBS_AAAP_OP_COST_COST_PER_ABOA__c,p.PBS_AAAP_TI_Annual_Rent_Per_RSF__c,p.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c,p.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c,p.PBS_RSAP_BSAC_Rate_from_RLP__c,
                        p.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c,p.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c,p.PBS_RSAP_Total_Parking_Annual_Amount__c,p.PBS_RSAP_Lease_Annual_Rent__c,p.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c,p.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c,p.PBS_AAAP_Lease_Has_Renewal_Options__c,p.PBS_RSAP_BSAC_Calc_from_Rate__c,
                        p.PBS_AAAP_Years_Annual_Rate_Effective__c,p.PBS_AAAP_floors_Suites_in_Offered_Space__c,p.PBS_RSAP_HubZone_Waiver__c,p.PBS_RSAP_Historical_Property_Description__c,
                        p.PBS_AAAP_CLEANING_SALARIES_GOV__c,p.PBS_AAAP_CLEANING_SUPPLIES_GOV__c,p.PBS_AAAP_CLEANING_CONTRACT_SERVICES_GOV__c,p.PBS_AAAP_HEATING_SALARIES_GOV__c,
                        p.PBS_AAAP_HEATING_FUEL_COST_GOV__c,p.PBS_AAAP_HEATING_MAINTENANCE_GOV__c,p.PBS_AAAP_ELECTRICAL_POWER_GOV__c,p.PBS_AAAP_ELECTRICAL_REPLACEMENT_GOV__c,p.PBS_AAAP_ELECTRICAL_SPECIALEQUIP_GOV__c,
                        p.PBS_AAAP_ELECTRICAL_MAINTENANCE_GOV__c,p.PBS_AAAP_PLUMBING_WATER_GOV__c,p.PBS_AAAP_PLUMBING_SUPPLIES_GOV__c,p.PBS_AAAP_PLUMBING_MAINTENANCE_GOV__c,
                        p.PBS_AAAP_AC_UTILITIES_GOV__c,p.PBS_AAAP_AC_MAINTENANCE_GOV__c,p.PBS_AAAP_ELEVATOR_SALARIES_GOV__c,p.PBS_AAAP_ELEVATOR_MAINTENANCE_GOV__c,p.PBS_AAAP_BLDG_ENGINEERCOST_GOV__c,
                        p.PBS_AAAP_SECURITY_GOV__c,p.PBS_AAAP_SSTAX_WORKCOMP_GOV__c,p.PBS_AAAP_LANDSCAPING_MAINTENANCE_GOV__c,p.PBS_AAAP_TOTAL_OTHER_COSTS_GOV__c,p.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c,
                        p.PBS_AAAP_REAL_ESTATE_TAXES_GOV__c,p.PBS_AAAP_INSURANCE_GOV__c,p.PBS_AAAP_BUILDING_MAINTENANCE_GOV__c,p.PBS_AAAP_LEASE_COMMISSION_GOV__c,p.PBS_AAAP_MANAGEMENT_GOV__c,p.PBS_AAAP_SECT2_TOTAL_GOV__c,
                        p.PBS_AAAP_INITIAL_NO_OF_YEARS__c,p.PBS_AAAP_Initial_YEARS_FIRM__c,p.PBS_AAAP_Initial_Day_Terminate_Lease__c,p.PBS_AAAP_BROKER_TENANT_REP_COMM__c,
                        p.PBS_AAAP_BROKER_OWNER_REP_COMM__c,p.PBS_AAAP_Schedule_Commission_LeaseAward__c,p.PBS_AAAP_Schedule_Commission_Occupancy__c,p.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c,
                        p.PBS_AAAP_Lessor_Prj_Fees__c,p.PBS_AAAP_Offer_Basis_Of_Fees__c,p.PBS_AAAP_HVAC_OT_Rate__c,p.PBS_AAAP_HVAC_OT_Rate_Type__c,p.PBS_AAAP_Number_of_zones__c,
                        p.PBS_AAAP_24_HR_HVAC_Cost_Per_ABOA__c,p.PBS_AAAP_Current_Year_Taxes_1364_28__c,p.PBS_AAAP_Taxes_Fully_Assessed_Value__c,p.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c,
                        p.PBS_AAAP_Total_Land_Cost__c,p.PBS_AAAP_Offer_Additional_Remarks__c,p.PBS_AAAP_Architectural_Fees_Percent__c, p.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c, p.PBS_AAAP_Architectural_Fees_Flat__c,
                        p.PBS_AAAP_Adj_for_Reduced_Services_Rate__c, PBS_AAAP_floors_and_suites_offered__c, p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Project_Number__c, p.PBS_AAAP_Government_Occupancy_Percentage__c,
                        p.PBS_AAAP_User_Defined_Address__c, p.PBS_AAAP_Submission_DateTime__c, p.PBS_AAAP_Energy_Star_Evaluation__c, p.PBS_AAAP_Rental_Concessions__c, p.PBS_RSAP_Tax_Parcel_RSF__c, p.PBS_RSAP_HVAC_Example__c,
                        p.PBS_AAAP_RLP_Number__r.Default_Start_Time_ET__c,p.PBS_AAAP_RLP_Number__r.Default_Start_Time_AM_PM__c,p.PBS_AAAP_RLP_Number__r.Default_End_Time_ET__c,p.PBS_AAAP_RLP_Number__r.Default_End_Time_AM_PM__c,
                        p.PBS_AAAP_RLP_Number__r.PBS_AAAP_DEFAULT_MONTH_BEGIN__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_DEFAULT_MONTH_END__c,p.PBS_AAAP_Parking_Onsite__c, p.PBS_AAAP_Fire_Life_Meets__c, p.PBS_AAAP_Accessibility__c, PBS_AAAP_Flood_Plains__c, p.PBS_AAAP_Asbestos__c,
                        p.PBS_AAAP_Seismic_Statement__c, p.PBS_AAAP_Common_Area_Factor__c, PBS_RSAP_Renovation_Year__c, p.PBS_RSAP_Energy_Star_Meets_Exceptions__c,p.PBS_RSAP_Energy_Star_Response_No__c, p.PBS_AAAP_Free_Space_Offered__c, p.PBS_RSAP_Surf_Resv_Parking__c, p.PBS_RSAP_Surf_NonResv_Parking__c,
                        p.PBS_RSAP_Struct_Resv_Parking__c, p.PBS_RSAP_Struct_NonResv_Parking__c, p.PBS_RSAP_Building_is_a_historic_property__c, p.PBS_RSAP_Bldg_within_a_historic_district__c, p.Confirm_Full_Term_Lease_Months__c, p.Confirm_Firm_Term_Lease_Months__c, p.PBS_AAAP_Shell_Rate_Years_Effective__c, p.PBS_AAAP_Op_Cost_Years_Effective__c,
                        p.PBS_AAAP_Shell_Rent_Per_RSF__c, p.PBS_AAAP_Shell_Rent_Per_ABOA__c, p.PBS_RSAP_Free_Shell_Is_Offered__c, p.PBS_RSAP_Free_Operating_Is_Offered__c, p.PBS_RSAP_Free_TI_Is_Offered__c, p.PBS_RSAP_Free_BSAC_Is_Offered__c, p.PBS_RSAP_Free_Parking_Is_Offered__c, p.PBS_RSAP_Free_Non_Standard_is_Offered__c,p.PBS_AAAP_RLP_Number__r.name
                FROM PBS_AAAP_Offer__c p
                WHERE p.id = :ofrid
        ];
        System.debug('PBS_AAAP_GlobalConstants.getOfferDetail(), PBS_AAAP_floors_Suites_in_Offered_Space__c = ' + offer.PBS_AAAP_floors_Suites_in_Offered_Space__c);
        System.debug('PBS_AAAP_GlobalConstants.getOfferDetail(), PBS_AAAP_Parking_Onsite__c = ' + offer.PBS_AAAP_Parking_Onsite__c);
        System.debug('PBS_AAAP_GlobalConstants.getOfferDetail(), PBS_AAAP_Fire_Life_Meets__c = ' + offer.PBS_AAAP_Fire_Life_Meets__c);
        System.debug('PBS_AAAP_GlobalConstants.getOfferDetail(), PBS_AAAP_Accessibility__c = ' + offer.PBS_AAAP_Accessibility__c);
        System.debug('PBS_AAAP_GlobalConstants.getOfferDetail(), PBS_AAAP_Flood_Plains__c = ' + offer.PBS_AAAP_Flood_Plains__c);
        System.debug('PBS_AAAP_GlobalConstants.getOfferDetail(), PBS_AAAP_Asbestos__c = ' + offer.PBS_AAAP_Asbestos__c);
        System.debug('PBS_AAAP_GlobalConstants.getOfferDetail(), PBS_AAAP_Seismic_Statement__c = ' + offer.PBS_AAAP_Seismic_Statement__c);
        return offer;
    }

    //added by syam on 10/07/2016 for LOP Offer
    public static PBS_LOP_OFFER__c getLOPOfferDetail(string ofrid) {
        PBS_LOP_OFFER__c offer = [
                SELECT Id,OwnerId, LOP_ACCEPTED_REP_CERT_FORM_3518__c,LOP_ACCEPTED_LEASE_FORM_1364__c, LOP_ACCEPTED_TERMS_AND_COND__c,
                        LOP_ACK_READ_RLP_REQ_NO_CHANGE__c, LOP_AC_MAINTENANCE_GOV__c, LOP_AC_MAINTENANCE__c, LOP_AC_UTILITIES_GOV__c,
                        LOP_AC_UTILITIES__c, LOP_ARCHITECTURAL_AND_ENG_FEES_UOM__c, LOP_ARCH_ENG_FEES_PER_USF__c, LOP_Accessibility_Standards_Met__c,
                        LOP_Architectural_Fees_Flat__c, LOP_Architectural_Fees_Percent__c, LOP_Asbestos_Declaration__c,
                        LOP_BLDG_ENGINEERCOST_GOV__c, LOP_BLDG_ENGINEERCOST__c, LOP_BROKER_OWNER_REP_COMM__c, LOP_BROKER_TENANT_REP_COMM__c,
                        LOP_BSAC_Amorization_in_Years__c, LOP_BSAC_Amorti_Interest_Rate__c, LOP_BSAC_Annual_Rent_Per_ABOA__c,
                        LOP_BSAC_Annual_Rent_Per_RSF__c, LOP_BSAC_Total_Build_out_Costs__c, LOP_BSAC_Years_Rate_Effective__c,
                        LOP_BUILDING_MAINTENANCE_GOV__c, LOP_BUILDING_MAINTENANCE__c, LOP_Building_Name__c, LOP_CERTIFICATION_DATE__c,
                        LOP_CLEANING_CONTRACT_SERVICES_GOV__c, LOP_CLEANING_CONTRACT_SERVICES__c, LOP_CLEANING_SALARIES_GOV__c,
                        LOP_CLEANING_SALARIES__c, LOP_CLEANING_SUPPLIES_GOV__c, LOP_CLEANING_SUPPLIES__c, LOP_City__c, LOP_Common_Area_Factor__c,
                        LOP_Corp_Not_Convicted_Felon__c, LOP_Corporation_not_tax_felon__c, LOP_ELECTRICAL_MAINTENANCE_GOV__c, LOP_ELECTRICAL_MAINTENANCE__c,
                        LOP_ELECTRICAL_POWER_GOV__c, LOP_ELECTRICAL_POWER__c, LOP_ELECTRICAL_REPLACEMENT_GOV__c, LOP_ELECTRICAL_REPLACEMENT__c,
                        LOP_ELECTRICAL_SPECIALEQUIP_GOV__c, LOP_ELECTRICAL_SPECIALEQUIP__c, LOP_ELEVATOR_MAINTENANCE_GOV__c, LOP_ELEVATOR_MAINTENANCE__c,
                        LOP_ELEVATOR_SALARIES_GOV__c, LOP_ELEVATOR_SALARIES__c, LOP_Emp_Visitor_Structured_Spaces__c, LOP_Emp_Visitor_Surface_Spaces__c,
                        LOP_Energy_Star_Reason__c, LOP_Energy_Star__c, LOP_Fire_Safety_Declaration__c, LOP_Flood_Plain_Declaration__c,
                        LOP_Formula_Hist_Property__c, LOP_Free_Rent_Other__c, LOP_GEN_PURPOSE_RENTABLE__c, LOP_GOV_Structured_Spaces__c,
                        LOP_GOV_Surface_Spaces__c, LOP_Government_Occupancy_Pct__c, LOP_HEATING_FUEL_COST_GOV__c, LOP_HEATING_FUEL_COST__c,
                        LOP_HEATING_FUEL__c, LOP_HEATING_MAINTENANCE_GOV__c, LOP_HEATING_MAINTENANCE__c, LOP_HEATING_SALARIES_GOV__c,
                        LOP_HEATING_SALARIES__c, LOP_HIST_PROP_IN_HIST_DIST__c, LOP_HIST_PROP_IN_NON_HIST_DIST__c, LOP_HUBZone_SBC_Waive_Pref__c,
                        LOP_HVAC_HRS_MON_TO_FRI_END__c, LOP_HVAC_HRS_MON_TO_FRI_START__c, LOP_HVAC_HRS_ON_SAT_END__c, LOP_HVAC_HRS_ON_SAT_START__c,
                        LOP_HVAC_HRS_ON_SUN_END__c, LOP_HVAC_HRS_ON_SUN_START__c, LOP_HVAC_OT_Rate_GOV__c, LOP_HVAC_OT_Rate_Type_GOV__c,
                        LOP_HVAC_OT_Rate_Type__c, LOP_HVAC_OT_Rate__c, LOP_DUNS_Number__c, LOP_INITIAL_NO_OF_YEARS__c, LOP_INSURANCE_GOV__c,
                        LOP_INSURANCE__c, LOP_IS_HVAC_AVAIL_ON_SAT__c, LOP_IS_HVAC_AVAIL_ON_SUN__c, LOP_Initial_No_Of_Days_Terminate_Lease__c,
                        LOP_Initial_YEARS_FIRM__c, LOP_Is_Shell_Rent_Stepped__c, LOP_LANDSCAPING_MAINTENANCE_GOV__c, LOP_LANDSCAPING_MAINTENANCE__c,
                        LOP_LEASE_COMMISSION_GOV__c, LOP_LEASE_COMMISSION__c, LOP_LIVE_FLOOR_LOAD__c, LOP_Lease_Annual_Rent_Per_ABOA__c,
                        LOP_Lease_Annual_Rent_Per_RSF__c, LOP_Lease_Has_Renewal_Options__c, LOP_Lessor_Prj_Fees__c, LOP_MANAGEMENT_GOV__c,
                        LOP_MANAGEMENT__c, LOP_NON_HIST_PROP_IN_HIST_DIST__c, LOP_NO_OF_MONTHS_FREE_FIRM_TERM__c,
                        LOP_Num_Years_Annual_Rate_is_Effective__c, LOP_Number_of_floors__c, LOP_OFFEROR_INTEREST_OTHER__c,
                        LOP_OFFEROR_INTEREST__c, LOP_OFFICE_SPACE_RSF__c, LOP_OP_COST_COST_PER_ABOA__c, LOP_OP_COST_COST_PER_RSF__c,
                        LOP_OTHER_SPACE_RSF__c, LOP_Offer_Additional_Remarks__c, LOP_Offer_Status__c, LOP_Offer_Submission_Date__c,
                        LOP_Offer_Updated_since_last_import__c, LOP_Offeror_Address__c, LOP_Offeror_Company_Name__c, LOP_Offeror_FLS_Declaration__c,
                        LOP_Offeror_First_Name__c, LOP_Offeror_Last_Name__c, LOP_Offeror_Phone_Number__c, LOP_Offeror_Seismic_Declaration__c,
                        LOP_Offeror__c, LOP_Office_RSF_OFFERED__c, LOP_Owner_Address__c, LOP_Owner_City__c, LOP_Owner_Email_Address__c,
                        LOP_Owner_FirstName__c, LOP_Owner_LastName__c, LOP_Owner_Main_Phone__c, LOP_Owner_State__c, LOP_Owner_Zip__c,
                        LOP_PLUMBING_MAINTENANCE_GOV__c, LOP_PLUMBING_MAINTENANCE__c, LOP_PLUMBING_SUPPLIES_GOV__c, LOP_PLUMBING_SUPPLIES__c,
                        LOP_PLUMBING_WATER_GOV__c, LOP_PLUMBING_WATER__c, LOP_Property_Owner_Company__c, LOP_Property_Owner_Email__c,
                        LOP_Property_Owner_Same_as_Offeror__c, LOP_REAL_ESTATE_TAXES_GOV__c, LOP_REAL_ESTATE_TAXES__c, LOP_RETAIL_SPACE_RSF__c,
                        LOP_RLP_Contains_Seismic_Requirement__c, LOP_RLP_Parking_Cost_Incl__c, LOP_Renewal_NO_OF_OPTIONS__c,
                        LOP_Renewal_No_Of_Days_Exercise_Option__c, LOP_Renewal_Shell_Rate__c, LOP_Renewal_YEARS_EACH__c,
                        LOP_Renovation_Year__c, LOP_Representation_Business__c, LOP_SECURITY_GOV__c, LOP_SECURITY__c,LOP_TI_Buildout_as_in_RLP__c,
                        LOP_SHELL_Build_out_Costs__c, LOP_SITE_AREA_TYPE__c, LOP_SITE_SIZE_SQFT__c, LOP_SRVC_UTIL_TOTAL_GOV__c,
                        LOP_SRVC_UTIL_TOTAL__c, LOP_SSTAX_WORKCOMP_GOV__c, LOP_SSTAX_WORKCOMP__c, LOP_STRUCT_PARKING_ANNUAL_COST__c,
                        LOP_SURFACE_PARKING_ANNUAL_COST__c, LOP_Sam_Registered__c, LOP_Schedule_Of_Commission_Payment__c, LOP_Scheduled_Comm_Payment__c,
                        LOP_State__c, LOP_Step_1_End__c, LOP_Step_1_Rent_Per_ABOA__c, LOP_Step_1_Rent_Per_RSF__c, LOP_Step_1_Start__c,
                        LOP_Step_2_End__c, LOP_Step_2_Rent_Per_ABOA__c, LOP_Step_2_Rent_Per_RSF__c, LOP_Step_2_Start__c, LOP_Step_3_End__c,
                        LOP_Step_3_Rent_Per_ABOA__c, LOP_Step_3_Rent_Per_RSF__c, LOP_Step_3_Start__c, LOP_Street_Address_Line_2__c,
                        LOP_Street_Address__c, LOP_Structured_Spaces_Controlled__c, LOP_TI_Amorization_in_Years__c, LOP_TI_Amorti_Interest_Rate__c,
                        LOP_TI_Annual_Rent_Per_ABOA__c, LOP_TI_Annual_Rent_Per_RSF__c, LOP_TI_Total_Build_out_Costs__c, LOP_TI_Years_Rate_Effective__c,
                        LOP_TOTAL_ABOA_OFFERED__c, LOP_TOTAL_OTHER_COSTS_GOV__c, LOP_TOTAL_OTHER_COSTS__c, LOP_Total_Build_Out_Costs__c,
                        LOP_Total_Ofc_ABOA_offered__c, LOP_Total_Struct_Park_Offered_Per_Code__c, LOP_Total_Surf_Park_Offered_Per_Code__c,
                        LOP_Surface_Spaces_Controlled__c, LOP_Vacant_Premise_Rate_GOV__c, LOP_Vacant_Premise_Rate__c, LOP_Year_Built__c,
                        LOP_Zip__c, LOP_isHistoricProperty__c, Project_ABOA__c, Project_City__c, Project_Contact_Email__c, Project_EOI_ID__c,
                        Project_Lease_Model__c, Project_Number__c, Project_Offer_Due_Date__c, Project_State__c, LOP_Historic_Property_Tier__c,
                        LOP_SECT2_TOTAL__c, LOP_SECT2_TOTAL_GOV__c, LOP_Option_Parking__c,LOP_Op_Cost_Years_Effective__c,LOP_Annual_TI_Rent__c,
                        LOP_Shell_Rent_Per_RSF__c,LOP_Shell_Rent_Per_ABOA__c,LOP_Shell_Rate_Years_Effective__c,Project_EOI_ID__r.Project_Termination_Flag__c,
                        LOP_ACCEPTED_PROV_FORM_3516__c, LOP_Schedule_Of_Commission_LeaseAward__c, LOP_Schedule_Of_Commission_Occupancy__c,LOP_Anual_BSAC_Rent__c,
                        LOP_Offer_Basis_Of_Fees__c,LOP_24_HR_HVAC_Cost_Per_ABOA__c,LOP_Current_Year_Taxes_1364_28__c,LOP_Total_Land_Cost__c,
                        LOP_Offered_Space_Part_of_Mult_Tax_Bills__c,LOP_Taxes_Based_On_Fully_Assessed_Value__c,LOP_Number_of_zones__c,LOP_Lease_total_Annual_Rent__c
                FROM PBS_LOP_OFFER__c p
                WHERE p.id = :ofrid
        ];

        return offer;

    }

    public static List<PBS_AAAP_Rate__c> getRates(string spaceId) {
        List<PBS_AAAP_Rate__c> rateList = [
                SELECT id, PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, PBS_AAAP_LEASE_TERM__c,
                        PBS_AAAP_BASE_RATE__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,
                        PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                        PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                        PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                        PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c
                FROM PBS_AAAP_Rate__c
                WHERE PBS_AAAP_SPACE__c = :spaceId
        ];
        return rateList;
    }

    public static List<PBS_AAAP_Space__c> getSpaces(String ofrid) {
        List<PBS_AAAP_Space__c> spaceList = [
                SELECT id, PBS_AAAP_NEW_SUCCEED_LEASE_IND__c,
                        PBS_AAAP_MAX_OFFERABLE_SPACE__c, PBS_AAAP_TOTAL_MARKUP__c,
                        PBS_AAAP_SF_OFFERED__c, Name,PBS_AAAP_Total_ABOA_Available__c,PBS_AAAP_MIN_OFFERABLE_SPACE__c,
                        PBS_AAAP_Max_Contiguous_Space__c,PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,PBS_AAAP_GC_OVERHEAD_AND_PROF__c,
                        PBS_AAAP_ARCH_ENG_FEES__c,PBS_AAAP_OFFER_NUMBER__r.PBS_AAAP_RLP_Region__c,PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c, 
                        PBS_AAAP_DATE_SPACE_AVAILABILITY__c, PBS_AAAP_GSA_EXPIRE_LEASE_NUMBER__c, PBS_AAAP_MANAGEMENT_COORD_FEES__c,
                        (
                        SELECT PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, PBS_AAAP_LEASE_TERM__c,
                                PBS_AAAP_BASE_RATE__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,
                                PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                                PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                                PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                                PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,PBS_AAAP_OT_RATE_COOLING_HEAT__c,PBS_AAAP_Vacant_Premise_Rate__c
                        FROM Rates__r ORDER BY PBS_AAAP_LEASE_TERM__c DESC
                        )
                FROM PBS_AAAP_Space__c
                WHERE PBS_AAAP_OFFER_NUMBER__c = :ofrid
        ];
        System.debug('PBS_AAAP_GlobalConstants.getSpaces(), spacelist = ' + spaceList);
        return spaceList;
    }


    //added PBS_AAAP_PV_Value__c on ratelist columns
    //*** Added BSAC Rate and BSAC Amounts
    public static List<PBS_AAAP_Rate__c> getRatesandSpace(String ofrid) {
        List<PBS_AAAP_Rate__c> rateList = [
                SELECT p.PBS_AAAP_SPACE__r.PBS_AAAP_TOTAL_MARKUP__c, p.PBS_AAAP_SPACE__r.PBS_AAAP_MAX_OFFERABLE_SPACE__c,
                        p.PBS_AAAP_SPACE__r.PBS_AAAP_NEW_SUCCEED_LEASE_IND__c, p.PBS_AAAP_SPACE__r.PBS_AAAP_OFFER_NUMBER__c,
                        p.PBS_AAAP_SPACE__r.Name, p.PBS_AAAP_SPACE__c, p.PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                        p.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, p.PBS_AAAP_LEASE_TERM__c, p.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                        p.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, p.PBS_AAAP_COST_FOR_TI__c, p.PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c,
                        p.PBS_AAAP_BASE_RATE__c, p.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, p.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                        p.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, p.PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, p.PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                        p.Id, p.PBS_AAAP_SPACE__r.PBS_AAAP_SF_OFFERED__c, PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,PBS_AAAP_PV_Value__c, PBS_AAAP_BSAC_RATE__c, PBS_AAAP_BSAC__c,
                        p.PBS_AAAP_OT_RATE_COOLING_HEAT__c, p.PBS_AAAP_SPACE__r.PBS_AAAP_ARCH_ENG_FEES__c,
                        p.PBS_AAAP_SPACE__r.PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c,
                        p.PBS_AAAP_SPACE__r.PBS_AAAP_GC_OVERHEAD_AND_PROF__c, p.PBS_AAAP_SPACE__r.PBS_AAAP_Enhanced_Clean_Disinfect_Rate__c
                FROM PBS_AAAP_Rate__c p
                WHERE p.PBS_AAAP_SPACE__r.PBS_AAAP_OFFER_NUMBER__c = :ofrid
                ORDER BY p.CreatedDate
                LIMIT 45
        ];

        System.debug('PBS_AAAP_GlobalConstants.getRatesandSpace(), ratelist = ' + rateList);
        return rateList;
    }

    public static boolean checkOfferBuildingValidations(PBS_AAAP_Offer__c offerBuilding) {
        system.debug('*************offerBuilding.PBS_AAAP_County__c************** ::: ' + offerBuilding);
        boolean flag;

        if (offerBuilding.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 7. Total amount of rentable square feet (RSF) in the building is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 8. Total ANSI/BOMA Office Area Square Feet (ABOA) in the building is required.'));
            flag = true;
        }
         //SGanti commented out on 8/2/2021 
    
     //   if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c != null) {   
        //    if (offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c == null) {   
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 9. Site Size radio button required.'));    
        //        flag = true;  
       //     } 
     //   } 
   //SGanti commented out on 8/2/2021   
      //  if (offerBuilding.PBS_AAAP_SITE_SIZE_SQFT__c == null) {   
            //if (offerBuilding.PBS_AAAP_SITE_AREA_TYPE__c == null) {   
       //     ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 9. Site Size is missing.  "Square Feet" or "Acres" must be selected.'));   
       //     flag = true;  
            //} 
      //}
        if (offerBuilding.PBS_AAAP_Number_of_floors__c == null || offerBuilding.PBS_AAAP_Number_of_floors__c <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 10. Number of floors is required and cannot be a negative number.'));
            flag = true;
        }

        /*if (offerBuilding.PBS_AAAP_LIVE_FLOOR_LOAD__c == null) {
//SGanti changed 7/16/2021
       offerBuilding.PBS_AAAP_LIVE_FLOOR_LOAD__c = '';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 11. Live floor load is required.  Enter TBD if information is not readily available.'));
            flag = true;
        }*/

        if (offerBuilding.PBS_AAAP_Year_Built__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 12. Year building constructed is required information.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Renovation_Year__c == null || offerBuilding.PBS_AAAP_Renovation_Year__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 13. Year of most recent building renovation is required information.'));
            flag = true;
        }

        if (offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 10. HVAC Hours of operation start (M-F) field is missing.'));//JK changed 7/2021
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 14. HVAC Hours of operation end (M-F) field is missing.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_REAL_ESTATE_TAXES__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 15. Annual Real Estate Taxes is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_INSURANCE__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 16. Annual Insurance amount is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_BUILDING_MAINTENANCE__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 17. Annual building maintenance is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_LEASE_COMMISSION__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Fundamentals Page : 18. Lease commision is required.'));
            flag = true;
        }
   //SGanti commented out on 8/2/2021

    /*    if (offerBuilding.PBS_AAAP_Building_Sprinklered__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 1. Identify whether the building is fully sprinklered field is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 2. At least 2 physically remote stairwells are required in the building.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_BLDG_Wide_Alarm_System__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 3. Identify whether the building has building wide alarm system field is required.'));
            flag = true;
        }
    */
         //SGanti renumbered error messages on 8/2/2021
//SGanti added 8/2021
        if (offerBuilding.PBS_AAAP_Fire_Life_Meets__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 1. Fire Protection & Safety information is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Accessibility__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 2. Accessibility information is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Asbestos__c == '' || offerBuilding.PBS_AAAP_Asbestos__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 3. Asbestos information is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Flood_Plains__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 4. Flood Plains information is required.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Close_To_Metro__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 5. Proximity to metro indicator field is missing.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Energy_Star__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 6. Identify whether the building has earned ENERGY STAR Label field is required.'));
            flag = true;
        }
      //SGanti left error message numbering as "6a" until further clarification is received
        if (offerBuilding.PBS_AAAP_Energy_Star__c == 'No') {
            if (offerBuilding.PBS_AAAP_Energy_Star_Reason__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 6a. Indicate why no energy efficiency and conservation improvements are cost effective.'));
                flag = true;
            }
        }


        if (offerBuilding.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 7. Identify whether the property offered is a historic property within a historic district'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 8. Identify whether the property offered is a non-historic developed or undeveloped site within a historic district.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_HubZone_SBC__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 9. Indicate Hubzone SBC status.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_HubZone_SBC__c == 'Yes') {
            if (offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 9a. Select price evaluation waiver preference.'));
                flag = true;
            }
        }
        if (offerBuilding.PBS_AAAP_Reconstruction__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 10a. If you select "Yes" to question #10, you must check the acknowledgement box to proceed.'));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Reconstruction__c == 'Yes') {
            if (offerBuilding.PBS_AAAP_Reconstruction_Acknowledgement__c == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 10a. If you select "Yes" to question #10, you must check the acknowledgement box to proceed.'));
                flag = true;
            }
        }

        if (offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Details Page : 11. Seismic Zone field is required.'));
            flag = true;
        }

        return flag;
    }

    public static boolean checkOfferParkingValidations(PBS_AAAP_Offer__c offerParking) {
        /*
           boolean flag;
           if(offerParking.PBS_AAAP_Option_Parking__c == null){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Parking Page : 5. Option for parking (Parking Page) field is missing.'));
               flag=true;
           }
           if(offerParking.PBS_AAAP_Total_Parking_Spaces__c == null){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Parking Page : 1. Number of parking spaces for the entire building under control of the offeror: Total is a required field.'));
               flag=true;
           }
           if(offerParking.PBS_AAAP_Total_Park_Spaces_Offered__c == null){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Parking Page : 2. Number of parking spaces required by local code: Total is a required field.'));
               flag=true;
           } */
        //return false; //weston: steve cut all this out
        boolean flag;
        if (offerParking.PBS_AAAP_Total_Structured_Parking_Spaces__c == null ||
                offerParking.PBS_AAAP_Total_Surface_Parking_Spaces__c == null ||
                offerParking.PBS_AAAP_Total_Struct_Park_Space_Offered__c == null ||
                offerParking.PBS_AAAP_Total_Surf_Park_Space_Offered__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    'Parking Page: Number of parking spaces is a required field.'));
            flag = true;

        }

        if (offerParking.PBS_AAAP_Monthly_cost_res_gar_park__c == null ||
                offerParking.PBS_AAAP_Monthly_cost_nonres_gar_park__c == null ||
                offerParking.PBS_AAAP_Monthly_cost_res_sur_park__c == null ||
                offerParking.PBS_AAAP_Monthly_cost_nonres_sur_park__c == null) {
                    //JK changed this question to number 4, 7/2021
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    'Parking Page: 4. Please enter rates for all types of parking. Please put $0.00 if you are either not charging for, or not offering, that type of parking space. You may not leave any fields blank.'));
            flag = true;

        }


        return flag;
    }

    public static boolean checkOfferPropOwnerValidations(PBS_AAAP_Offer__c offerPropOwner) {

        boolean flag;
        if (offerPropOwner.PBS_AAAP_Owner_Name__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page: 1. Property owner name field is required.'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Address__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page: 2. Property owner address field is required.'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Country__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page: 3. Properrty owner country  is required.'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_City__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page: 4. Property owner city field is required'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_Country__c == 'United States' && offerPropOwner.PBS_AAAP_Owner_State__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page: 5. Property owner state field is required.'));
            flag = true;
        }
       /* SGanti reworded error message on 7/14/2021 */
 
        if (offerPropOwner.PBS_AAAP_Owner_Country__c == 'United States' && offerPropOwner.PBS_AAAP_Owner_Zip__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page: 6. Property owner 9-Digit Zip Code field is required.'));
            flag = true;
        }
       /*SGanti commented out on 7/14/2021 if (offerPropOwner.PBS_AAAP_Owner_Main_Phone__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page: 7. Property owner main phone number field is required.'));
            flag = true;
        }*/
        /* SGanti renumbered error message on 7/14/2021 */
        if (offerPropOwner.PBS_AAAP_OFFEROR_INTEREST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page: 7. Property owner type field is required.'));
            flag = true; 
        }

        if (offerPropOwner.PBS_AAAP_CONTROLLED_BY_PARENT__c == 'Yes' && offerPropOwner.PBS_AAAP_PARENT_NAME__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : 13a. Name of common parent is required.'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_CONTROLLED_BY_PARENT__c == 'Yes' && offerPropOwner.PBS_AAAP_Common_Parent_TIN__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : 13b. Common parent TIN # is required.'));
            flag = true;
        }
        if (offerPropOwner.PBS_AAAP_Owner_TIN_Status__c == PBS_AAAP_GlobalConstants.TIN_KNOWN && offerPropOwner.PBS_AAAP_Owner_TIN_Assigned__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : 15a. Property owner TIN # field is required.'));
            flag = true;
        }
        return flag;
    }

    public static boolean checkOfferRepsAndCertsValidations(PBS_AAAP_Offer__c offerRepsAndCerts) {

        boolean flag;
        flag = false;
        /* if(offerRepsAndCerts.PBS_AAAP_Representation__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 1. Representation (Small business/Not a small business) (Property Owner Page) field is missing.'));
             flag=true;
         } */
        /*if(offerRepsAndCerts.PBS_AAAP_Women_Owned_Identifier__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 1b. Woman owned identifier (Property Owner Page) field is missing.'));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_EEO_CLAUSE__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 2. EEO Clause indicator field is required.'));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_AFFIRMATIVE_ACTION_PROGRAMS__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 3. Affirmative action program indicator field is required.'));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_CERTIFICATE_OF_SIGNATORY__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 4. Certification of signatory indicator field is missing.'));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_Confirm_Owner_Status__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 5. Confirm on property owner status indicator field is required.'));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_OWNER_CONVICTION__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 6. Property owner conviction indicator field is required.'));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_OWNER_INDICTMENT__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 7. Property owner indictment indicator field is required.'));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_FederalTax_Delinquent__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,REPSCERTS_OWNER_FEDTAX_DEFAULT));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_OWNER_CONTRACT_DEFAULT__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 9. Property owner contract default indicator field is required.'));
            flag=true;
        }
        if(offerRepsAndCerts.PBS_AAAP_CCR_REGISTRATION_ACTIVE_STATUS__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : 10. CCR registration active status field is required.'));
            flag=true;
        }*/
        //added by Syam for FY16
        /*if(offerRepsAndCerts.PBS_AAAP_Corporation_not_tax_felon__c == null){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Reps&Certs Page : '+PBS_AAAP_GlobalConstants.REPSCERTS_CORP_FELONY_CONVICTION));
           flag=true;
       }
       if(offerRepsAndCerts.PBS_AAAP_Corp_Not_Convicted_Felon__c == null){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Reps&Certs Page : '+PBS_AAAP_GlobalConstants.REPSCERTS_CORP_FEDTAX_DEFAULT));
           flag=true;
       } */
        return flag;
    }

    //added by syam  
    public static boolean checkOperatingCostsValidations(PBS_AAAP_Offer__c operatingCosts) {

        boolean flag;
        flag = false;

        if (operatingCosts.PBS_AAAP_COST_PER_ABOA__c <= 0.005) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Operating Costs Page : 4. Cost per ABOA SF must be > 0.00');
            Apexpages.addMessage(myMsg);
            flag = true;
        }
        if (operatingCosts.PBS_AAAP_Vacant_Premise_Rate__c == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Adjustment for Vacant premises must be entered.');
            Apexpages.addMessage(myMsg);
            flag = true;
        }
        return flag;
    }

    //added by syam on 10/12/2016 to get the GREX project details
    public static PBS_GREX_Project_EOI__c getProjectDetails(string projectEoiId) {
        PBS_GREX_Project_EOI__c project = [
                SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                        SystemModstamp, Project_ABOA__c, Project_City__c, Project_Contact_Email__c, Project_Due_Timezone__c, 
                        Project_EOI_ID__c, Project_Lease_Model__c, Project_Number__c, Project_Offer_Due_Date__c, Project_State__c, Project_Termination_Flag__c
                FROM PBS_GREX_Project_EOI__c
                WHERE id = :projectEoiId
        ];
        //where Project_EOI_ID__c = :projectEoiId];

        return project;
    }
    /*
    public static boolean checkOfferBuildingValidations(PBS_LOP_Offer__c lopOffer) {

        boolean flag;

        if (lopOffer.LOP_Building_Name__c == null || lopOffer.LOP_Building_Name__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_NAME_REQUIRED));
            flag = true;
        }
        if (lopOffer.LOP_Street_Address__c == null || lopOffer.LOP_Street_Address__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_STREET_REQUIRED));
            flag = true;
        }
        if (lopOffer.LOP_City__c == null || lopOffer.LOP_City__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_CITY_REQUIRED));
            flag = true;
        }
        if (lopOffer.LOP_State__c == null || lopOffer.LOP_State__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_STATE_REQUIRED));
            flag = true;
        }
        if (lopOffer.LOP_Zip__c == null || lopOffer.LOP_Zip__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_ZIP_REQUIRED));
            flag = true;
        }

        if (lopOffer.LOP_Energy_Star__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_ENERGY_STAR_REQUIRED));
            flag = true;
        }
        if (lopOffer.LOP_Energy_Star__c == 'No') {
            String reason = lopOffer.LOP_Energy_Star_Reason__c;
            if (reason == null || reason.length() <= 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_ENERGY_STAR_NO_REQUIRED));
                flag = true;
            }
        }

        if (lopOffer.LOP_Energy_Star__c == 'Yes') {
            Date certificationDate = lopOffer.LOP_CERTIFICATION_DATE__c;
            if (certificationDate == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_ENERGY_STAR_DATE_OF_CERTIFICATION_REQUIRED));
                flag = true;
            }
        }


        if (lopOffer.LOP_Number_of_floors__c == null || lopOffer.LOP_Number_of_floors__c <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_NUM_OF_FLOORS));
            flag = true;
        }
        if (lopOffer.LOP_GEN_PURPOSE_RENTABLE__c == null || lopOffer.LOP_GEN_PURPOSE_RENTABLE__c <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_TOTAL_RSF));
            flag = true;
        }

        lopOffer.LOP_OFFICE_SPACE_RSF__c = lopOffer.LOP_OFFICE_SPACE_RSF__c == null ? 0.00 : lopOffer.LOP_OFFICE_SPACE_RSF__c;
        lopOffer.LOP_RETAIL_SPACE_RSF__c = lopOffer.LOP_RETAIL_SPACE_RSF__c == null ? 0.00 : lopOffer.LOP_RETAIL_SPACE_RSF__c;
        lopOffer.LOP_OTHER_SPACE_RSF__c = lopOffer.LOP_OTHER_SPACE_RSF__c == null ? 0.00 : lopOffer.LOP_OTHER_SPACE_RSF__c;

        Decimal total = lopOffer.LOP_OFFICE_SPACE_RSF__c + lopOffer.LOP_RETAIL_SPACE_RSF__c + lopOffer.LOP_OTHER_SPACE_RSF__c;

        if (total != lopOffer.LOP_GEN_PURPOSE_RENTABLE__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_GEN_PURPOSE_RENTABLE_SUM_MSG));
            flag = true;
        }*/

/*          if(lopOffer.LOP_OFFICE_SPACE_RSF__c == null || lopOffer.LOP_OFFICE_SPACE_RSF__c <= 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, '8a. Please Enter the value for the General Purpose (Office).'));
            flag=true;
        }
        
          if(lopOffer.LOP_RETAIL_SPACE_RSF__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, '8b. Please Enter the value for the Warehouse.'));
            flag=true;
        }
         
          if(lopOffer.LOP_OTHER_SPACE_RSF__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, '8c. Please Enter the value for Other.'));
            flag=true;
        } 
       
  */
       /* if (lopOffer.LOP_Year_Built__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_YEAR_CONSTRUCTED));
            flag = true;
        }

        if (lopOffer.LOP_HVAC_HRS_MON_TO_FRI_START__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_HVAC_M_F_START));
            flag = true;
        }
        if (lopOffer.LOP_HVAC_HRS_MON_TO_FRI_END__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_HVAC_M_F_END));
            flag = true;
        }*/
        /*  if(lopOffer.LOP_HIST_PROP_IN_HIST_DIST__c == null){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HPHD));
              flag=true;
          }
           if(lopOffer.LOP_NON_HIST_PROP_IN_HIST_DIST__c == null){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_NHP_WITHIN_HD));
              flag=true;
          }
          if(lopOffer.LOP_HIST_PROP_IN_NON_HIST_DIST__c == null){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HP_OUTSIDE_HD));
              flag=true;
          } */

        /*if (lopOffer.LOP_SITE_SIZE_SQFT__c != null) {
            if (lopOffer.LOP_SITE_AREA_TYPE__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.SITE_AREA_TYPE_REQ));
                flag = true;
            }
        }

        if (lopOffer.LOP_Historic_Property_Tier__c == null || lopOffer.LOP_Historic_Property_Tier__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_HISTORIC_QUALIFICATION));
            flag = true;
        }

        if (lopOffer.LOP_Accessibility_Standards_Met__c == null || lopOffer.LOP_Accessibility_Standards_Met__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_ACCESSIBILITY_STANDARDS));
            flag = true;
        }

        if (lopOffer.LOP_Asbestos_Declaration__c == null || lopOffer.LOP_Asbestos_Declaration__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_ACM_STANDARDS));
            flag = true;
        }

        if (lopOffer.LOP_RLP_Contains_Seismic_Requirement__c == null || lopOffer.LOP_RLP_Contains_Seismic_Requirement__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_SEISMIC_SAFETY_REQ));
            flag = true;
        }
        if (lopOffer.LOP_RLP_Contains_Seismic_Requirement__c == 'The RLP contains seismic requirements.') {
            if (lopOffer.LOP_Offeror_Seismic_Declaration__c == null || lopOffer.LOP_Offeror_Seismic_Declaration__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_SEISMIC_SAFETY_QUAL));
                flag = true;
            }
        }
        if (lopOffer.LOP_Flood_Plain_Declaration__c == null || lopOffer.LOP_Flood_Plain_Declaration__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_FLOOD_PLAINS));
            flag = true;
        }

        if (lopOffer.LOP_Fire_Safety_Declaration__c == null || lopOffer.LOP_Fire_Safety_Declaration__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_BUILDING_FIRE_PROTECTION));
            flag = true;
        }


        System.debug('***** message size checkOfferBuildingValidations: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());

        return flag;
    }*/

    /* public static boolean checkOfferParkingValidations(PBS_LOP_Offer__c lopOffer){
        
        boolean flag;
        if(lopOffer.LOP_Option_Parking__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PARKING_OPTION_REQUIRED));
            flag=true;
        }
        return flag;
    }*/

    /*
    public static boolean checkOfferPropOwnerValidations(PBS_LOP_Offer__c lopOffer) {

        boolean flag;

        if (lopOffer.LOP_Property_Owner_Company__c == null || lopOffer.LOP_Property_Owner_Company__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_COMPANY_REQUIRED));
            flag = true;
        }
        if (lopOffer.LOP_Owner_Address__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_ADDRESS));
            flag = true;
        }

        if (lopOffer.LOP_Owner_City__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_CITY));
            flag = true;
        }


        if (lopOffer.LOP_OFFEROR_INTEREST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.PROP_OWNER_TYPE));
            flag = true;
        }


        return flag;
    }
    */
    /*
    public static boolean checkLOPOfferLeaseTerms(PBS_AAAP_Offer__c lopOffer) {

        boolean flag;
        if (lopOffer.PBS_AAAP_INITIAL_NO_OF_YEARS__c == null || lopOffer.PBS_AAAP_INITIAL_NO_OF_YEARS__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.CONFIRM_NO_OF_YEARS_OFFERED_REQUIRED));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Initial_YEARS_FIRM__c == null || lopOffer.PBS_AAAP_Initial_YEARS_FIRM__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.CONFIRM_YEARS_FIRM_REQUIRED));
            flag = true;
        }


        return flag;
    } */
    /*
    public static boolean checkLOPOfferRepsAndCertsValidations(PBS_LOP_Offer__c lopOffer) {

        boolean flag;
        /* if(lopOffer.LOP_Representation_Business__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_REPRESENTATION_REQUIRED));
             flag=true;
         }

         if(lopOffer.LOP_Corporation_not_tax_felon__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_CORP_FELONY_CONVICTION));
             flag=true;
         }
         if(lopOffer.LOP_Corp_Not_Convicted_Felon__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.REPSCERTS_CORP_FEDTAX_DEFAULT));
             flag=true;
         } 
        return flag;
    }*/

    //set the LOP offer status to draft from submitted
    public static void updateOfferToDraft(PBS_AAAP_Offer__c lopOffer) {
        lopOffer.PBS_AAAP_Offer_Status__c = 'Draft';
        lopOffer.PBS_AAAP_Offer_Submission_Date__c = null;
        //lopOffer.LOP_ACK_READ_RLP_REQ_NO_CHANGE__c = '';
        //lopOffer.LOP_ACCEPTED_PROV_FORM_3516__c = '';
        //lopOffer.LOP_ACCEPTED_REP_CERT_FORM_3518__c = '';
        //lopOffer.LOP_ACCEPTED_LEASE_FORM_1364__c = '';
        //lopOffer.LOP_ACCEPTED_TERMS_AND_COND__c = '';
    }

    public static boolean checkLOPOfferSpaceRates(PBS_AAAP_Offer__c lopOffer) {

        Boolean flag = false;
        /**
        if (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == null || lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_ANSI_BOMA_SF));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == null || lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_RSF));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == null) {
            lopOffer.PBS_AAAP_Office_RSF_OFFERED__c = 0;
        }
        if (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == null) {
            lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 0;
        }

        if (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c <= lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_RSF_GT_ABOA));
            flag = true;
        }**/

        /*if (lopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c == null || lopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c == 0.00) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_SHELL_RENT_PER_RSF));
            flag = true;
        }*/
        /*if (lopOffer.PBS_AAAP_Shell_Rate_Years_Effective__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_SHELL_RATE_YRS_EFFECTIVE));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_RLP_Parking_Cost_Incl__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_ANNUAL_RENT_PARKING));
            flag = true;
        }*/

        return flag;
    }
    /** 
     * added by syam on 12/01/2016
    check all the errors on all the screens before submission and alert the user.*/
    public static Boolean validateOfferSubmission(PBS_AAAP_Offer__c lopOffer, boolean rlpFlag) {
        Boolean flag = false;

        System.debug('inside validateOfferSubmission ******');
        boolean buildingflag = PBS_AAAP_GlobalConstants.checkFinalOfferBuildingValidations(lopOffer);
        System.debug('buildingflag is ' + buildingflag);
        //boolean repsflag = PBS_AAAP_GlobalConstants.checkFinalLOPOfferRepsAndCertsValidations(lopOffer);
        boolean repsflag = FALSE;
        System.debug('repsflag is ' + repsflag);
        boolean propOwnerflag = PBS_AAAP_GlobalConstants.checkFinalOfferPropOwnerValidations(lopOffer);
        System.debug('propOwnerflag is ' + propOwnerflag);
        boolean spaceRatesFlag = PBS_AAAP_GlobalConstants.checkFinalLOPOfferSpaceRates(lopOffer);

        if (buildingflag == true || repsflag == true || propOwnerflag == true || spaceRatesFlag == true) {
            flag = true;
        }

        if (lopOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You must confirm you have read the RLP and declare your deviation intentions.'));
            return true;
        }
        if (rlpFlag == null) {
            rlpFlag = true;
        }
        if (!rlpFlag && lopOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == FALSE) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You must confirm you have read the RLP and declare your deviation intentions.'));
            flag = true;
        }
        return flag;
    }

    public static Boolean validateOfferSubmissionBefore(PBS_AAAP_Offer__c lopOffer) {
        Boolean flag = false;

        System.debug('inside validateOfferSubmissionBefore ******');
        boolean buildingflag = PBS_AAAP_GlobalConstants.checkFinalOfferBuildingValidations(lopOffer);
        System.debug('buildingflag is ' + buildingflag);
        //boolean repsflag = PBS_AAAP_GlobalConstants.checkFinalLOPOfferRepsAndCertsValidations(lopOffer);
        //boolean repsflag = FALSE;
        //System.debug('repsflag is ' + repsflag);
        boolean spaceAndParkingFlag = PBS_AAAP_GlobalConstants.checkFinalLOPOfferSpaceAndParking(lopOffer);
        System.debug('spaceAndParkingFlag is ' + spaceAndParkingFlag);
        boolean leaseTermflag = PBS_AAAP_GlobalConstants.checkFinalLOPOfferLeaseTerms(lopOffer);
        System.debug('leaseTermflag is ' + leaseTermflag);
        boolean propOwnerflag = PBS_AAAP_GlobalConstants.checkFinalLOPOfferPropOwnerValidations(lopOffer);
        System.debug('propOwnerflag is ' + propOwnerflag);
        //boolean spaceRatesFlag = PBS_AAAP_GlobalConstants.checkFinalLOPOfferSpaceRates(lopOffer);

        if (buildingflag == true || spaceAndParkingFlag || propOwnerflag == true || leaseTermflag == true) {
            flag = true;
        }

        if (lopOffer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select I have read the RLP with attachments in its entirety.'));
            return true;
        }
        return flag;
    }

    public static boolean checkFinalOfferBuildingValidations(PBS_AAAP_Offer__c lopOffer) {

        boolean flag = false;

        if (lopOffer.PBS_AAAP_Building_Name__c == null || lopOffer.PBS_AAAP_Building_Name__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_NAME_REQUIRED));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Street_Address__c == null || lopOffer.PBS_AAAP_Street_Address__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_STREET_REQUIRED));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_City__c == null || lopOffer.PBS_AAAP_City__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_CITY_REQUIRED));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_State__c == null || lopOffer.PBS_AAAP_State__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_STATE_REQUIRED));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_ZipCode__c == null || lopOffer.PBS_AAAP_ZipCode__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ZIP_REQUIRED));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_Energy_Star__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ENERGY_STAR_REQUIRED));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Energy_Star__c == 'No') {
//SGanti 11/2021 
            //String reason = lopOffer.PBS_AAAP_Energy_Star_Evaluation__c; 
            //if (reason == null || reason.length() <= 0) {
              //  ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ENERGY_STAR_NO_REQUIRED));
                //flag = true;
            //}
//SGanti 11/2021
            if (lopOffer.PBS_RSAP_Energy_Star_Response_No__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ENERGY_STAR_NO_CATEGORY_REQUIRED));
                flag = true;
            } 
            if (lopOffer.PBS_RSAP_Energy_Star_Response_No__c == 'Statutory Exception' && lopOffer.PBS_RSAP_Energy_Star_Meets_Exceptions__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ENERGY_STAR_NO_STATUTORY_EXCEPTION_REQUIRED));
                flag = true;
            } 
        }
//SGanti 11/2021        
        if (lopOffer.PBS_RSAP_Building_is_a_historic_property__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_HISTORIC_PROPERTY));
            flag = true;
        }
//SGanti 11/2021        
        
        if (lopOffer.PBS_RSAP_Bldg_within_a_historic_district__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_HISTORIC_DISTRICT));
            flag = true;
        }
        
        if (lopOffer.PBS_AAAP_Energy_Star__c == 'Yes') {
            Date certificationDate = lopOffer.PBS_AAAP_CERTIFICATION_DATE__c;
            if (certificationDate == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ENERGY_STAR_DATE_OF_CERTIFICATION_REQUIRED));
                flag = true;
            }
        }


        if (lopOffer.PBS_AAAP_floors_Suites_in_Offered_Space__c == null || lopOffer.PBS_AAAP_floors_Suites_in_Offered_Space__c <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_NUM_OF_FLOORS));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == null || lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_TOTAL_RSF));
            flag = true;
        }

        lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c = lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c;
        lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c = lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c;
        lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c = lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c;

        Decimal total = lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c + lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c + lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c;

        if (total != lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_GEN_PURPOSE_RENTABLE_SUM_MSG));
            flag = true;
        }

        /*  if(lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c == null || lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c <= 0){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Building Page : 8a. Please Enter the value for the General Purpose (Office)'));
             flag=true;
         }

           if(lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Building Page : 8b. Please Enter the value for the Warehouse'));
             flag=true;
         }

           if(lopOffer.PBS_AAAP_OTHER_SPACE_RSF__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Building Page : 8c. Please Enter the value for Other'));
             flag=true;
         } */

        if (lopOffer.PBS_RSAP_Year_Built__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_YEAR_CONSTRUCTED));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_HVAC_M_F_START));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_HVAC_M_F_END));
            flag = true;
        }
        /*  if(lopOffer.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c == null){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HPHD));
              flag=true;
          }
           if(lopOffer.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c == null){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_NHP_WITHIN_HD));
              flag=true;
          }
          if(lopOffer.PBS_AAAP_HIST_PROP_IN_NON_HIST_DIST__c == null){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HP_OUTSIDE_HD));
              flag=true;
          } */
//SGanti 10/2021
        //if (lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c != null) {
          //  if (lopOffer.PBS_AAAP_SITE_AREA_TYPE__c == null) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.SITE_AREA_TYPE_REQ));
              //  flag = true;
            //}
        //}

        /*if (lopOffer.PBS_RSAP_Historical_Property_Description__c == null || lopOffer.PBS_RSAP_Historical_Property_Description__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_HISTORIC_QUALIFICATION));
            flag = true;
        }*/

        if (lopOffer.PBS_RSAP_Accessibility_Standards_Met__c == null || lopOffer.PBS_RSAP_Accessibility_Standards_Met__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ACCESSIBILITY_STANDARDS));
            flag = true;
        }
//SGanti 11/2021

        //if (lopOffer.PBS_RSAP_Asbestos_Declaration__c == null || lopOffer.PBS_RSAP_Asbestos_Declaration__c == '') {
          //  ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ACM_STANDARDS));
            //flag = true;
        //}
        if (lopOffer.PBS_AAAP_Asbestos__c == null || lopOffer.PBS_AAAP_Asbestos__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_ACM_STANDARDS));
            flag = true;
        }

        /**
        if (lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c == null || lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_SEISMIC_SAFETY_REQ));
            flag = true;
        }
        **/

        if (lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == NULL || lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page : 17. Seismic information is required'));
            flag = TRUE;
        }
        if (lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'Yes' && (lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c == '' || lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c == NULL)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page : 17a. Seismic declaration is required'));
            flag = TRUE;
        }

        /**
        if (lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'Yes') {
            if (lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c == null || lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_SEISMIC_SAFETY_QUAL));
                flag = true;
            }
        }
        **/
        if (lopOffer.PBS_RSAP_Flood_Plain_Declaration__c == null || lopOffer.PBS_RSAP_Flood_Plain_Declaration__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_FLOOD_PLAINS));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_FIRE_SAFETY_CERT__c == null || lopOffer.PBS_AAAP_FIRE_SAFETY_CERT__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Page : ' + PBS_AAAP_GlobalConstants.LOP_BUILDING_FIRE_PROTECTION));
            flag = true;
        }


        System.debug('***** message size checkOfferBuildingValidations: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());

        return flag;
    }
    
    /*
    public static boolean checkFinalLOPOfferRepsAndCertsValidations(PBS_LOP_Offer__c lopOffer) {

        boolean flag;
        flag = false;
        /* if(lopOffer.LOP_Representation_Business__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reps&Certs Page : '+PBS_AAAP_GlobalConstants.REPSCERTS_REPRESENTATION_REQUIRED));
             flag=true;
         }

         if(lopOffer.LOP_Corporation_not_tax_felon__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Reps&Certs Page : '+PBS_AAAP_GlobalConstants.REPSCERTS_CORP_FELONY_CONVICTION));
             flag=true;
         }
         if(lopOffer.LOP_Corp_Not_Convicted_Felon__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Reps&Certs Page : '+PBS_AAAP_GlobalConstants.REPSCERTS_CORP_FEDTAX_DEFAULT));
             flag=true;
         } 
        return flag;
    }*/

    public static boolean checkFinalOfferPropOwnerValidations(PBS_AAAP_Offer__c lopOffer) {

        boolean flag = false;
        //Todo add first name and last name
        if (lopOffer.PBS_AAAP_Owner_Name__c == null || lopOffer.PBS_AAAP_Owner_Name__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_COMPANY_REQUIRED));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Owner_Address__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_ADDRESS));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_Owner_City__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_CITY));
            flag = true;
        }


        if (lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_TYPE));
            flag = true;
        }


        return flag;
    }

    public static boolean checkFinalLOPOfferPropOwnerValidations(PBS_AAAP_Offer__c lopOffer) {

        boolean flag = false;
        //Todo add first name and last name
        if (lopOffer.PBS_AAAP_Owner_Name__c == null || lopOffer.PBS_AAAP_Owner_Name__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_COMPANY_REQUIRED));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Owner_Address__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_ADDRESS));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_Owner_City__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_CITY));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_Owner_State__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_STATE));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_Owner_Zip__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_ZIP));
            flag = true;
        }


        if (lopOffer.PBS_AAAP_OFFEROR_INTEREST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_TYPE_LOP));
            flag = true;
        }

        if (lopOffer.PBS_AAAP_DUNS_Number__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Property Page : ' + PBS_AAAP_GlobalConstants.PROP_OWNER_EID_LOP));
            flag = true;
        }

        return flag;
    }
    
    public static boolean checkFinalLOPOfferLeaseTerms(PBS_AAAP_Offer__c lopOffer) {
        
        boolean flag = false;
        if (lopOffer.Confirm_Full_Term_Lease_Months__c == null || lopOffer.Confirm_Full_Term_Lease_Months__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lease Terms Page: Initial Lease Term section: 1. Confirm the full term of the lease, in months.'));
            flag = true;
        }
        if (lopOffer.Confirm_Firm_Term_Lease_Months__c == null || lopOffer.Confirm_Firm_Term_Lease_Months__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lease Terms Page: Initial Lease Term section: 2. Confirm the firm term of the lease, in months.'));
            flag = true;
        }
        if(lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == NULL){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lease Terms Page: Offeror\'s Fee Schedule section: 1. Make sure an Architectural/Engineering Unit of Measure is selected.'));
            flag = true;
        } else {
            if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Per ABOA Square Feet ($)' && lopOffer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lease Terms Page: Offeror\'s Fee Schedule section: 1. Make sure an Architectural/Engineering square footage amount or 0 is entered.'));
                flag = true;
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Percent of Total Construction Costs (%)' && lopOffer.PBS_AAAP_Architectural_Fees_Percent__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lease Terms Page: Offeror\'s Fee Schedule section: 1. Make sure an Architectural/Engineering percentage amount or 0 is entered.'));
                flag = true;
            } else if (lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c == 'Flat Fee ($)' && lopOffer.PBS_AAAP_Architectural_Fees_Flat__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lease Terms Page: Offeror\'s Fee Schedule section: 1. Make sure an Architectural/Engineering flat fee amount or 0 is entered.'));
                flag = true;
            }
        
        }
        if (lopOffer.PBS_AAAP_Lessor_Prj_Fees__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lease Terms Page: Offeror\'s Fee Schedule section: 2. Lessor\'s Project Management Fee is required.'));
            flag = true;
        }        

        return flag;
        
    }

    public static boolean checkFinalLOPOfferSpaceAndParking(PBS_AAAP_Offer__c lopOffer) {
        Boolean flag = false;
        if (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == null || lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_ANSI_BOMA_SF));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == null || lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_RSF));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Parking_Onsite__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_ONSITE));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_Monthly_cost_res_sur_park__c == null || lopOffer.PBS_AAAP_Monthly_cost_nonres_sur_park__c == null || 
            lopOffer.PBS_AAAP_Monthly_cost_res_gar_park__c == null || lopOffer.PBS_AAAP_Monthly_cost_nonres_gar_park__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_ALLPARKING));
            flag = true;
        }
        return flag;
    }

    public static boolean checkFinalLOPOfferSpaceRates(PBS_AAAP_Offer__c lopOffer) {
        Boolean flag = false;
        //if (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == null || lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == 0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_ANSI_BOMA_SF));
        //    flag = true;
        //}
        //if (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == null || lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == 0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_RSF));
        //    flag = true;
        //}
        //if (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c == null) {
        //    lopOffer.PBS_AAAP_Office_RSF_OFFERED__c = 0;
        //}
        //if (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c == null) {
        //    lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 0;
        //}

        /*if (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c <= lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_RSF_GT_ABOA));
            flag = true;
        }*/

        /*if (lopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c == null || lopOffer.PBS_AAAP_Shell_Rent_Per_RSF__c == 0.00) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_SHELL_RENT_PER_RSF));
            flag = true;
        }*/
        /*if (lopOffer.PBS_AAAP_Shell_Rate_Years_Effective__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_SHELL_RATE_YRS_EFFECTIVE));
            flag = true;
        }
        if (lopOffer.PBS_AAAP_RLP_Parking_Cost_Incl__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_ANNUAL_RENT_PARKING));
            flag = true;
        }*/

        return flag;
    }
    /**
    public static String convertToTimeZone(PBS_GREX_Project_EOI__c project) {

        String offerDueDtStr = null;
        DateTime offerDueDt = project.Project_Offer_Due_Date__c;
        String timeZone = project.Project_Due_Timezone__c;
        System.debug('offerDueDt is ***' + offerDueDt);
        if (timeZone == null || timeZone == '') {
            timeZone = 'Eastern Time';
        }
        if (timeZone.contains('Atlantic Time')) {
            offerDueDtStr = offerDueDt.format('MM/dd/yyyy h:mm a', 'America/Puerto_Rico');
            offerDueDtStr = offerDueDtStr + ' Atlantic Time (Canada)';

        } else if (timeZone.contains('Eastern Time')) {
            offerDueDtStr = offerDueDt.format('MM/dd/yyyy h:mm a', 'America/New_York');
            offerDueDtStr = offerDueDtStr + ' Eastern Time (US & Canada)';

        } else if (timeZone.contains('Central Time')) {
            offerDueDtStr = offerDueDt.format('MM/dd/yyyy h:mm a', 'America/Chicago');
            offerDueDtStr = offerDueDtStr + ' Central Time (US & Canada)';


        } else if (timeZone.contains('Mountain Time')) {
            offerDueDtStr = offerDueDt.format('MM/dd/yyyy h:mm a', 'America/Denver');
            offerDueDtStr = offerDueDtStr + ' Mountain Time (US & Canada)';

        } else if (timeZone.contains('Pacific Time')) {
            offerDueDtStr = offerDueDt.format('MM/dd/yyyy h:mm a', 'America/Los_Angeles');
            offerDueDtStr = offerDueDtStr + ' Pacific Time (US & Canada)';

        } else if (timeZone.contains('Guam')) {
            offerDueDtStr = offerDueDt.format('MM/dd/yyyy h:mm a', 'Australia/Brisbane');
            offerDueDtStr = offerDueDtStr + ' Guam, Port Moresby';
        } else {

            System.debug('inside Hawaii ***' + offerDueDt);
            offerDueDtStr = offerDueDt.format('MM/dd/yyyy h:mm a', 'Pacific/Honolulu');
            offerDueDtStr = offerDueDtStr + ' Hawaii';

            System.debug('inside Hawaii ***' + offerDueDtStr);
        }

        return offerDueDtStr;
    }
    **/

    //Syed Start
    public static Boolean checkOfferIsValidOrNot(PBS_AAAP_Offer__c offerBuilding)
    {
        Boolean isOfferValid = true;
        /*Date dt = Date.today();
        integer day = dt.day();
        if ((day > endRLPDay) || (day < startRLPDay)) {
            showSubmitMesg = true;
        }*/
        
        DateTime dtimeToday = System.now();
        DateTime beginDateTime = null;   DateTime endDateTime = null;
        if(offerBuilding.PBS_AAAP_RLP_Number__r != null)
        {
            PBS_AAAP_RLP__c rlp1 = offerBuilding.PBS_AAAP_RLP_Number__r;
            Integer startRLPDay = Integer.valueOf(offerBuilding.PBS_AAAP_Default_Start__c);
            if(rlp1.Default_Start_Time_ET__c != null && rlp1.Default_Start_Time_AM_PM__c != null)   
            {
                String btm = rlp1.Default_Start_Time_ET__c + ':00' + ' ' + rlp1.Default_Start_Time_AM_PM__c;
                Time beginTime = getConvertedTime(btm);
                beginDateTime = DateTime.newInstance(Date.newInstance(dtimeToday.year(), dtimeToday.month(), startRLPDay), Time.newInstance(beginTime.hour(), beginTime.minute(), 0 ,0));
                System.debug('beginDateTime step 1 ### ' + beginDateTime); 
            }
            
            integer endRLPDay = Integer.valueOf(offerBuilding.PBS_AAAP_Default_End__c);
            if(rlp1.Default_End_Time_ET__c != null && rlp1.Default_End_Time_AM_PM__c != null) 
            {
                String etm = rlp1.Default_End_Time_ET__c + ':00' + ' ' + rlp1.Default_End_Time_AM_PM__c;
                Time endTime = getConvertedTime(etm);
                endDateTime = DateTime.newInstance(Date.newInstance(dtimeToday.year(), dtimeToday.month(), endRLPDay), Time.newInstance(endTime.hour(), endTime.minute(), 0 ,0));
                System.debug('endDateTime step 1 ### ' + endDateTime); 
            }
            
        }
        
        System.debug('dateTimeToday final ########## ' + dtimeToday); 
        System.debug('startDateTime final ######### ' + beginDateTime + ' endDateTime final ########## ' + endDateTime); 
        if (!(beginDateTime != null && endDateTime != null && dtimeToday >= beginDateTime && dtimeToday <= endDateTime))
        {
            isOfferValid = false;
        }
        return isOfferValid;
    }
    
    public static Time getConvertedTime(String strTime)
    {
        String TimeString = strTime;
        String Regex  = '(\\d{1,2}):(\\d{1,2}):(\\d{1,2}) ([PA]M)';
        Pattern p = Pattern.compile( Regex );
        Matcher m = p.matcher( TimeString );
        Time tm = null;
        if ( m.matches() ){
            Integer Hours = Integer.valueOf( m.group(1) )
                , Minutes = Integer.valueOf( m.group(2) )
                , Seconds = Integer.valueOf( m.group(3) )
                , PmShift = m.group(4) == 'PM' ? 12 : 0 
                    ;
            
            tm = Time.newInstance( Hours + PmShift , Minutes , 0 , 0 );
            System.debug( (''+tm).substring(0,(''+tm).indexOf('.')) );
        }
        System.debug('converted time ### ' + tm);
        return tm;
    }
    //Syed End
}