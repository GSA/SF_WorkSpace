public class PBS_Leasing_OfferPropertyWrapper {


    @AuraEnabled
    public static void saveUserDetails(objectWrapper obj) {
        
        SObjectType objectType = obj.Id.getsobjecttype(); 
        String objectTypeName = objectType.getDescribe().getName();
        System.debug('Object Type: ' + objectTypeName);  
        
        if (objectTypeName == 'PBS_AAAP_Property__c') {
            PBS_AAAP_Property__c propertyRec = [SELECT Id, PBS_AAAP_Owner_Name__c, PBS_AAAP_Owner_Address__c, PBS_AAAP_Owner_City__c, PBS_AAAP_Owner_State__c, 
                                                PBS_AAAP_Owner_Zip__c, PBS_RSAP_Property_Owner_Same_as_Offeror__c, PBS_AAAP_OFFEROR_INTEREST__c, PBS_AAAP_OFFEROR_INTEREST_OTHER__c
                                                FROM PBS_AAAP_Property__c  WHERE Id = :obj.Id LIMIT 1][0];
            propertyRec.PBS_AAAP_Owner_Name__c = obj.PBS_AAAP_Owner_Name;
            propertyRec.PBS_AAAP_Owner_Address__c = obj.PBS_AAAP_Owner_Address;
            propertyRec.PBS_AAAP_Owner_City__c = obj.PBS_AAAP_Owner_City;
            propertyRec.PBS_AAAP_Owner_State__c = obj.PBS_AAAP_Owner_State;
            propertyRec.PBS_AAAP_Owner_Zip__c = obj.PBS_AAAP_Owner_Zip;
            propertyRec.PBS_RSAP_Property_Owner_Same_as_Offeror__c = obj.PBS_RSAP_Property_Owner_Same_as_Offeror;
            propertyRec.PBS_AAAP_OFFEROR_INTEREST__c = obj.PBS_AAAP_OFFEROR_INTEREST;
            propertyRec.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = obj.PBS_AAAP_OFFEROR_INTEREST_OTHER;
            update propertyRec;
        } else {
            if (objectTypeName == 'PBS_AAAP_Offer__c') {
                PBS_AAAP_Offer__c offerRec = [SELECT Id, PBS_AAAP_Owner_Name__c, PBS_AAAP_Owner_Address__c, PBS_AAAP_Owner_City__c, PBS_AAAP_Owner_State__c, 
                                                 PBS_AAAP_Owner_Zip__c, PBS_RSAP_Property_Owner_Same_as_Offeror__c, PBS_AAAP_OFFEROR_INTEREST__c, PBS_AAAP_OFFEROR_INTEREST_OTHER__c,
                                                 PBS_AAAP_Signature_First_Name__c, PBS_AAAP_SIGNATURE_LAST_NAME__c, PBS_AAAP_Owner_Country__c
                                                 FROM PBS_AAAP_Offer__c  WHERE Id = :obj.Id LIMIT 1][0];
                offerRec.PBS_AAAP_Owner_Name__c = obj.PBS_AAAP_Owner_Name;
                offerRec.PBS_AAAP_Owner_Address__c = obj.PBS_AAAP_Owner_Address;
                offerRec.PBS_AAAP_Owner_City__c = obj.PBS_AAAP_Owner_City;
                offerRec.PBS_AAAP_Owner_State__c = obj.PBS_AAAP_Owner_State;
                offerRec.PBS_AAAP_Owner_Zip__c = obj.PBS_AAAP_Owner_Zip;
                offerRec.PBS_RSAP_Property_Owner_Same_as_Offeror__c = obj.PBS_RSAP_Property_Owner_Same_as_Offeror;
                offerRec.PBS_AAAP_OFFEROR_INTEREST__c = obj.PBS_AAAP_OFFEROR_INTEREST;
                offerRec.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = obj.PBS_AAAP_OFFEROR_INTEREST_OTHER;
                offerRec.PBS_AAAP_Signature_First_Name__c = obj.PBS_AAAP_Signature_First_Name;
                offerRec.PBS_AAAP_SIGNATURE_LAST_NAME__c = obj.PBS_AAAP_SIGNATURE_LAST_NAME;
                offerRec.PBS_AAAP_Owner_Country__c = obj.PBS_AAAP_Owner_Country;
                update offerRec;
            }
        }  
    }
        
    @AuraEnabled
    public static objectWrapper getPropertyDetails(String Id) { 
        objectWrapper obj = new objectWrapper();
        String RecordType;
        String prefixId;
        PBS_AAAP_Offer__c offer;
        PBS_AAAP_Property__c propDetails;
        
        try
        {
            if(Id != null)
            {
                prefixId = Id.substring(0, 3);
                if(prefixId == 'a05')
                {
                    
                    RecordType = 'Property';
                }
                else if(prefixId == 'a03')
                {
                    
                    RecordType = 'Offer';
                    
                }
            }
            if(RecordType == 'Property')
            {
                
              
              List<PBS_AAAP_Property__c> propertyrecords = [SELECT Id, PBS_AAAP_Building_Name__c,PBS_AAAP_State__c,PBS_AAAP_Street_Address__c,PBS_AAAP_City__c,PBS_AAAP_Common_Area_Factor__c,PBS_AAAP_Country__c,PBS_AAAP_County__c,PBS_AAAP_OFFICE_SPACE_RSF__c,PBS_AAAP_isBuildingProblem__c,PBS_AAAP_LEGACY_X_CO_ORD__c,PBS_AAAP_User_Defined_Address__c,PBS_AAAP_Legacy_Y_CO_ORD__c,PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c,PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c,PBS_AAAP_Monthly_cost_nonres_gar_park__c,PBS_AAAP_Monthly_cost_nonres_sur_park__c,PBS_AAAP_Monthly_cost_res_gar_park__c,PBS_AAAP_Monthly_cost_res_sur_park__c,PBS_AAAP_floors_Suites_in_Offered_Space__c,PBS_AAAP_OFFEROR_INTEREST__c,PBS_AAAP_OFFEROR_INTEREST_OTHER__c,PBS_AAAP_GARAGE_SPACE_RSF__c,OwnerId,PBS_AAAP_Parking_Onsite__c,Name,PBS_AAAP_Owner_City__c,PBS_AAAP_Owner_Name__c,PBS_RSAP_Property_Owner_Same_as_Offeror__c,PBS_AAAP_Owner_State__c,PBS_AAAP_Owner_Address__c,PBS_AAAP_Owner_Zip__c,PBS_AAAP_HVAC_HRS_ON_SAT_END__c,PBS_AAAP_HVAC_HRS_ON_SAT_START__c,PBS_AAAP_HVAC_HRS_ON_SUN_END__c,PBS_AAAP_HVAC_HRS_ON_SUN_START__c,PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c,PBS_AAAP_GEN_PURPOSE_RENTABLE__c,PBS_AAAP_Total_Park_Spaces_Offered__c,PBS_AAAP_Total_Structured_Parking_Spaces__c,PBS_AAAP_Total_Surface_Parking_Spaces__c,PBS_AAAP_DUNS_Number__c,PBS_AAAP_RETAIL_SPACE_RSF__c,PBS_AAAP_X_CO_ORD__c,PBS_AAAP_Y_CO_ORD__c,PBS_AAAP_Renovation_Year__c
                             ,PBS_AAAP_Year_Built__c,PBS_AAAP_ZipCode__c FROM PBS_AAAP_Property__c  WHERE Id = :Id  LIMIT 1];
                    
                    if(!propertyrecords.isEmpty())
                    {
                    propDetails = propertyRecords[0];
                    obj.Id = propDetails.Id;
                    obj.PBS_AAAP_Building_Name = propdetails.PBS_AAAP_Building_Name__c;
                    obj.PBS_AAAP_State = propdetails.PBS_AAAP_State__c;
                    obj.PBS_AAAP_Street_Address = propdetails.PBS_AAAP_Street_Address__c;
                    obj.PBS_AAAP_City = propdetails.PBS_AAAP_City__c;
                    obj.PBS_AAAP_Common_Area_Factor = propdetails.PBS_AAAP_Common_Area_Factor__c;
                    obj.PBS_AAAP_Country = propdetails.PBS_AAAP_Country__c;
                    obj.PBS_AAAP_County = propdetails.PBS_AAAP_County__c;
                    obj.PBS_AAAP_OFFICE_SPACE_RSF = propdetails.PBS_AAAP_OFFICE_SPACE_RSF__c;
                    obj.PBS_AAAP_isBuildingProblem = propdetails.PBS_AAAP_isBuildingProblem__c;
                    obj.PBS_AAAP_LEGACY_X_CO_ORD = propdetails.PBS_AAAP_LEGACY_X_CO_ORD__c;
                    obj.PBS_AAAP_Legacy_Y_CO_ORD = propdetails.PBS_AAAP_Legacy_Y_CO_ORD__c;
                    obj.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END = propdetails.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c;
                    obj.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START = propdetails.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c;
                    obj.PBS_AAAP_Monthly_cost_nonres_gar_park = propdetails.PBS_AAAP_Monthly_cost_nonres_gar_park__c;
                    obj.PBS_AAAP_Monthly_cost_nonres_sur_park = propdetails.PBS_AAAP_Monthly_cost_nonres_sur_park__c;
                    obj.PBS_AAAP_Monthly_cost_res_gar_park = propdetails.PBS_AAAP_Monthly_cost_res_gar_park__c;
                    obj.PBS_AAAP_Monthly_cost_res_sur_park = propdetails.PBS_AAAP_Monthly_cost_res_sur_park__c;
                    obj.PBS_AAAP_floors_Suites_in_Offered_Space = propdetails.PBS_AAAP_floors_Suites_in_Offered_Space__c;
                    obj.PBS_AAAP_OFFEROR_INTEREST = propdetails.PBS_AAAP_OFFEROR_INTEREST__c;
                    obj.PBS_AAAP_OFFEROR_INTEREST_OTHER = propdetails.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
                    obj.PBS_AAAP_GARAGE_SPACE_RSF = propdetails.PBS_AAAP_GARAGE_SPACE_RSF__c;
                    obj.OwnerId = Propdetails.OwnerId;
                    obj.Name = propdetails.Name;
                    obj.PBS_AAAP_Owner_City = propdetails.PBS_AAAP_Owner_City__c;
                    obj.PBS_AAAP_Owner_Name = propdetails.PBS_AAAP_Owner_Name__c;
                    obj.PBS_RSAP_Property_Owner_Same_as_Offeror = propdetails.PBS_RSAP_Property_Owner_Same_as_Offeror__c;
                    obj.PBS_AAAP_Parking_Onsite = propdetails.PBS_AAAP_Parking_Onsite__c;
                    obj.PBS_AAAP_Owner_State = propdetails.PBS_AAAP_Owner_State__c;
                    obj.PBS_AAAP_Owner_Address = propdetails.PBS_AAAP_Owner_Address__c;
                    obj.PBS_AAAP_Owner_Zip = propdetails.PBS_AAAP_Owner_Zip__c;
                    obj.PBS_AAAP_HVAC_HRS_ON_SAT_END = propdetails.PBS_AAAP_HVAC_HRS_ON_SAT_END__c;
                    obj.PBS_AAAP_HVAC_HRS_ON_SAT_START = propdetails.PBS_AAAP_HVAC_HRS_ON_SAT_START__c;
                    obj.PBS_AAAP_HVAC_HRS_ON_SUN_END = propdetails.PBS_AAAP_HVAC_HRS_ON_SUN_END__c;
                    obj.PBS_AAAP_HVAC_HRS_ON_SUN_START = propdetails.PBS_AAAP_HVAC_HRS_ON_SUN_START__c;
                    obj.PBS_AAAP_TOTAL_BOMA_USF_OFFERED = propdetails.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
                    obj.PBS_AAAP_GEN_PURPOSE_RENTABLE = propdetails.PBS_AAAP_GEN_PURPOSE_RENTABLE__c;
                    obj.PBS_AAAP_Total_Park_Spaces_Offered = propdetails.PBS_AAAP_Total_Park_Spaces_Offered__c;
                    obj.PBS_AAAP_Total_Structured_Parking_Spaces = propdetails.PBS_AAAP_Total_Structured_Parking_Spaces__c;
                    obj.PBS_AAAP_Total_Surface_Parking_Spaces = propdetails.PBS_AAAP_Total_Surface_Parking_Spaces__c;
                    obj.PBS_AAAP_DUNS_Number = propdetails.PBS_AAAP_DUNS_Number__c;
                    obj.PBS_AAAP_RETAIL_SPACE_RSF = propdetails.PBS_AAAP_RETAIL_SPACE_RSF__c;
                    obj.PBS_AAAP_X_CO_ORD = propdetails.PBS_AAAP_X_CO_ORD__c;
                    obj.PBS_AAAP_Y_CO_ORD = propdetails.PBS_AAAP_Y_CO_ORD__c;
                    obj.PBS_AAAP_Renovation_Year = propdetails.PBS_AAAP_Renovation_Year__c;
                    obj.PBS_AAAP_Year_Built = propdetails.PBS_AAAP_Year_Built__c; 
                    obj.PBS_AAAP_ZipCode = propdetails.PBS_AAAP_ZipCode__c;
                    obj.PBS_AAAP_User_Defined_Address = propdetails.PBS_AAAP_User_Defined_Address__c;
                    obj.isSuccess = true;
                    obj.errorMessages = '';
                    }
                else
                {
                    obj.isSuccess = false;
                    obj.errorMessages = 'Property record not found';
                }
            }
            else if(RecordType == 'Offer')
            {
              
                
                List<PBS_AAAP_Offer__c> offerrecords = [SELECT p.SystemModstamp,p.LastModifiedById, p.PBS_AAAP_can_withdraw__c,p.RecordType.Name,p.PBS_AAAP_Solicitation_Number__c,p.PBS_AAAP_ZipCode__c, p.PBS_AAAP_Year_Built__c, p.PBS_AAAP_Y_CO_ORD__c,
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
                            p.PBS_AAAP_Adj_for_Reduced_Services_Rate__c, p.PBS_AAAP_floors_and_suites_offered__c, p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Project_Number__c, p.PBS_AAAP_Government_Occupancy_Percentage__c,
                            p.PBS_AAAP_User_Defined_Address__c, p.PBS_AAAP_Submission_DateTime__c, p.PBS_AAAP_Energy_Star_Evaluation__c, p.PBS_AAAP_Rental_Concessions__c, p.PBS_RSAP_Tax_Parcel_RSF__c, p.PBS_RSAP_HVAC_Example__c,
                            p.PBS_AAAP_RLP_Number__r.Default_Start_Time_ET__c,p.PBS_AAAP_RLP_Number__r.Default_Start_Time_AM_PM__c,p.PBS_AAAP_RLP_Number__r.Default_End_Time_ET__c,p.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c,p.PBS_AAAP_RLP_Number__r.Default_End_Time_AM_PM__c,
                            p.PBS_AAAP_RLP_Number__r.PBS_AAAP_DEFAULT_MONTH_BEGIN__c,p.PBS_AAAP_RLP_Number__r.PBS_AAAP_DEFAULT_MONTH_END__c,p.PBS_AAAP_Parking_Onsite__c, p.PBS_AAAP_Fire_Life_Meets__c, p.PBS_AAAP_Accessibility__c, PBS_AAAP_Flood_Plains__c, p.PBS_AAAP_Asbestos__c,
                            p.PBS_AAAP_Seismic_Statement__c, p.PBS_AAAP_Common_Area_Factor__c, p.PBS_RSAP_Renovation_Year__c, p.PBS_RSAP_Energy_Star_Meets_Exceptions__c,p.PBS_RSAP_Energy_Star_Response_No__c, p.PBS_AAAP_Free_Space_Offered__c, p.PBS_RSAP_Surf_Resv_Parking__c, p.PBS_RSAP_Surf_NonResv_Parking__c,
                            p.PBS_RSAP_Struct_Resv_Parking__c, p.PBS_RSAP_Struct_NonResv_Parking__c, p.PBS_RSAP_Building_is_a_historic_property__c, p.PBS_RSAP_Bldg_within_a_historic_district__c, p.Confirm_Full_Term_Lease_Months__c, p.Confirm_Firm_Term_Lease_Months__c, p.PBS_AAAP_Shell_Rate_Years_Effective__c, p.PBS_AAAP_Op_Cost_Years_Effective__c,
                            p.PBS_AAAP_Shell_Rent_Per_RSF__c, p.PBS_AAAP_Shell_Rent_Per_ABOA__c, p.PBS_RSAP_Free_Shell_Is_Offered__c, p.PBS_RSAP_Free_Operating_Is_Offered__c, p.PBS_RSAP_Free_TI_Is_Offered__c, p.PBS_RSAP_Free_BSAC_Is_Offered__c, p.PBS_RSAP_Free_Parking_Is_Offered__c, p.PBS_RSAP_Free_Non_Standard_is_Offered__c,p.PBS_AAAP_RLP_Number__r.name
                    FROM PBS_AAAP_Offer__c p
                    WHERE p.id = :Id LIMIT 1
            ];
                if(!offerrecords.isEmpty())
                {
                    offer = offerrecords[0];
                    System.debug('Renovation '+offer.PBS_AAAP_Renovation_Year__c);
                    obj.Id = offer.Id;
                    obj.PBS_AAAP_Building_Name = offer.PBS_AAAP_Building_Name__c;
                    obj.PBS_AAAP_State = offer.PBS_AAAP_State__c;
                    obj.PBS_AAAP_Street_Address = offer.PBS_AAAP_Street_Address__c;
                    obj.PBS_AAAP_User_Defined_Address = offer.PBS_AAAP_User_Defined_Address__c;
                    obj.PBS_AAAP_City = offer.PBS_AAAP_City__c;
                    obj.PBS_AAAP_Common_Area_Factor = offer.PBS_AAAP_Common_Area_Factor__c;
                    obj.PBS_AAAP_Building_Common_Area_Factor = offer.PBS_AAAP_Building_Common_Area_Factor__c;
                    obj.PBS_AAAP_Country = offer.PBS_AAAP_Country__c;
                    obj.PBS_AAAP_County = offer.PBS_AAAP_County__c;
                    obj.PBS_AAAP_OFFICE_SPACE_RSF = offer.PBS_AAAP_OFFICE_SPACE_RSF__c;
                    
                    obj.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END = offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c;
                    obj.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START = offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c;
                    obj.PBS_AAAP_Monthly_cost_nonres_gar_park = offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c;
                    obj.PBS_AAAP_Monthly_cost_nonres_sur_park = offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c;
                    obj.PBS_AAAP_Monthly_cost_res_gar_park = offer.PBS_AAAP_Monthly_cost_res_gar_park__c;
                    obj.PBS_AAAP_Monthly_cost_res_sur_park = offer.PBS_AAAP_Monthly_cost_res_sur_park__c;
                    
                    obj.PBS_AAAP_OFFEROR_INTEREST = offer.PBS_AAAP_OFFEROR_INTEREST__c;
                    obj.PBS_AAAP_OFFEROR_INTEREST_OTHER = offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
                    obj.PBS_AAAP_GARAGE_SPACE_RSF = offer.PBS_AAAP_GARAGE_SPACE_RSF__c;
                    obj.OwnerId = offer.OwnerId;
                    obj.Name = offer.Name;
                    obj.PBS_AAAP_Owner_City = offer.PBS_AAAP_Owner_City__c;
                    obj.PBS_AAAP_Owner_Name = offer.PBS_AAAP_Owner_Name__c;
                    obj.PBS_RSAP_Property_Owner_Same_as_Offeror = offer.PBS_RSAP_Property_Owner_Same_as_Offeror__c;
                    obj.PBS_AAAP_Parking_Onsite = offer.PBS_AAAP_Parking_Onsite__c;
                    obj.PBS_AAAP_Owner_State = offer.PBS_AAAP_Owner_State__c;
                    obj.PBS_AAAP_Owner_Address = offer.PBS_AAAP_Owner_Address__c;
                    obj.PBS_AAAP_Owner_Zip = offer.PBS_AAAP_Owner_Zip__c;
                    obj.PBS_AAAP_HVAC_HRS_ON_SAT_END = offer.PBS_AAAP_HVAC_HRS_ON_SAT_END__c;
                    obj.PBS_AAAP_HVAC_HRS_ON_SAT_START =offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c;
                    obj.PBS_AAAP_HVAC_HRS_ON_SUN_END = offer.PBS_AAAP_HVAC_HRS_ON_SUN_END__c;
                    obj.PBS_AAAP_HVAC_HRS_ON_SUN_START =offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c;
                    obj.PBS_AAAP_TOTAL_BOMA_USF_OFFERED = offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
                    obj.PBS_AAAP_GEN_PURPOSE_RENTABLE = offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c;
                    obj.PBS_AAAP_Total_Park_Spaces_Offered = offer.PBS_AAAP_Total_Park_Spaces_Offered__c;
                    obj.PBS_AAAP_Total_Structured_Parking_Spaces = offer.PBS_AAAP_Total_Structured_Parking_Spaces__c;
                    obj.PBS_AAAP_Total_Surface_Parking_Spaces = offer.PBS_AAAP_Total_Surface_Parking_Spaces__c;
                    obj.PBS_AAAP_DUNS_Number = offer.PBS_AAAP_DUNS_Number__c;
                    obj.PBS_AAAP_RETAIL_SPACE_RSF = offer.PBS_AAAP_RETAIL_SPACE_RSF__c;
                    obj.PBS_AAAP_X_CO_ORD = offer.PBS_AAAP_X_CO_ORD__c;
                    obj.PBS_AAAP_Y_CO_ORD = offer.PBS_AAAP_Y_CO_ORD__c;
                    obj.PBS_AAAP_Renovation_Year = offer.PBS_AAAP_Renovation_Year__c;
                    
                    obj.PBS_AAAP_ZipCode = offer.PBS_AAAP_ZipCode__c;
                    obj.PBS_AAAP_Offer_Status = offer.PBS_AAAP_Offer_Status__c;
                    obj.PBS_AAAP_Signature_First_Name = offer.PBS_AAAP_Signature_First_Name__c;
                    obj.PBS_AAAP_SIGNATURE_LAST_NAME = offer.PBS_AAAP_SIGNATURE_LAST_NAME__c;
                    obj.PBS_AAAP_Owner_Country = offer.PBS_AAAP_Owner_Country__c;
                    obj.offerRecordType = offer.RecordType.Name;
                    obj.offerPropertyId = offer.property__c;
                    
                    obj.PBS_AAAP_RLPNumber= offer.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
                    obj.PBS_RSAP_RLPNumber= offer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c;
                    if(offer.RecordType.Name == 'AAAP')
                    {
                        obj.PBS_RLPORSolicitation_Number = offer.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
                        obj.PBS_AAAP_Renovation_Year = offer.PBS_AAAP_Renovation_Year__c;
                        obj.PBS_AAAP_floors_Suites_in_Offered_Space = offer.PBS_AAAP_Number_of_floors__c;
                        obj.PBS_AAAP_Year_Built = offer.PBS_AAAP_Year_Built__c;
                    }
                    else if(offer.RecordType.Name == 'RSAP')
                    {
                        obj.PBS_RLPORSolicitation_Number = offer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c;
                        obj.PBS_AAAP_Renovation_Year = offer.PBS_RSAP_Renovation_Year__c;
                        obj.PBS_AAAP_floors_Suites_in_Offered_Space = offer.PBS_AAAP_floors_Suites_in_Offered_Space__c;
                        obj.PBS_AAAP_Year_Built = offer.PBS_RSAP_Year_Built__c;
                    }
                    obj.isSuccess = true;
                    obj.errorMessages = '';
                    obj.isNewFlag = false;
                }
                else
                {
                   obj.isNewFlag = true;
                   obj.isSuccess = false;
                   obj.errorMessages = 'Offer record not found';
                }
            }
        }//end of try
        catch (Exception e) {
        obj.isSuccess = false;
        obj.errorMessages = 'An error occurred: ' + e.getMessage(); 
        }
        System.debug('About to return offerRecord: ' + obj);
        return obj;
    }
 @AuraEnabled
    public static ResponseWrapper validateProperty(PBS_AAAP_Property__c submitProperty, String pageName) {
        ResponseWrapper response = new ResponseWrapper();
        System.debug('submitProperty>>>>>>>'+submitProperty);
        List<PBS_Leasing_Required_Offer_Fields__mdt> requiredPropertyFields = [SELECT Id, Object_Name__c, Order_Number__c, Error_Message__c, Filter__c FROM PBS_Leasing_Required_Offer_Fields__mdt WHERE Object_Name__c =:'PBS_AAAP_Property__c' AND DeveloperName != Null AND Page_name__c=:pageName Order By Order_Number__c];
        System.debug('requiredPropertyFields>>>>>>'+requiredPropertyFields);
        for(PBS_Leasing_Required_Offer_Fields__mdt requiredPropertyField : requiredPropertyFields){
            Integer countOfPassedConditions = 0;
            
                    if(requiredPropertyField.Filter__c.contains('==')){
                        List<String> conditionParts = requiredPropertyField.Filter__c.split('==');
                        Object obj;
                        if(conditionParts[1].trim() == 'null' && submitProperty.get(conditionParts[0].trim()) == obj){
                            countOfPassedConditions++;
                        }else if(submitProperty.get(conditionParts[0].trim()) == conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }
                    else if(requiredPropertyField.Filter__c.contains('<=')){
                        List<String> conditionParts = requiredPropertyField.Filter__c.split('<=');
                        if(submitProperty.get(conditionParts[0].trim()) == conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }
                
                if(countOfPassedConditions > 0){
                    response.addErrorMessage(requiredPropertyField.Error_Message__c);
                }
           
        }
        if(pageName != 'Offer-Location')
        {
        if(submitProperty.PBS_AAAP_Renovation_Year__c == Null || submitProperty.PBS_AAAP_Renovation_Year__c == ''){
            response.addErrorMessage('Overview Page: 7. Provide the year and a brief description of the last major building renovation, if applicable is required');
        }
        if(submitProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c  == Null || submitProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c  == ''){
            response.addErrorMessage('Overview Page: Monday - Friday Hours Start is required.');
        }
        if(submitProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == Null || submitProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == ''){
            response.addErrorMessage('Overview Page: Monday - Friday Hours End is required');
        }
     }
        return response;
    }   
public class objectWrapper {   
@AuraEnabled public Id Id { get; set; }
@AuraEnabled public String PBS_AAAP_Building_Name { get; set; }
@AuraEnabled public String PBS_AAAP_State { get; set; }
@AuraEnabled public String PBS_AAAP_Street_Address { get; set; }
@AuraEnabled public String PBS_AAAP_City { get; set; }
@AuraEnabled public Decimal PBS_AAAP_Common_Area_Factor { get; set; }
@AuraEnabled public Decimal PBS_AAAP_Building_Common_Area_Factor { get; set; }
@AuraEnabled public String PBS_AAAP_Country { get; set; }
@AuraEnabled public String PBS_AAAP_County { get; set; }
@AuraEnabled public Double PBS_AAAP_OFFICE_SPACE_RSF { get; set; }
@AuraEnabled public Boolean PBS_AAAP_isBuildingProblem { get; set; }
@AuraEnabled public Boolean PBS_AAAP_isNewOffer { get; set; }
@AuraEnabled public Decimal PBS_AAAP_LEGACY_X_CO_ORD { get; set; }
@AuraEnabled public Decimal PBS_AAAP_Legacy_Y_CO_ORD { get; set; }
@AuraEnabled public string PBS_AAAP_HVAC_HRS_MON_TO_FRI_END { get; set; }
@AuraEnabled public string PBS_AAAP_HVAC_HRS_MON_TO_FRI_START { get; set; }
@AuraEnabled public Double PBS_AAAP_Monthly_cost_nonres_gar_park { get; set; }
@AuraEnabled public Double PBS_AAAP_Monthly_cost_nonres_sur_park { get; set; }
@AuraEnabled public Double PBS_AAAP_Monthly_cost_res_gar_park { get; set; }
@AuraEnabled public Double PBS_AAAP_Monthly_cost_res_sur_park { get; set; }
@AuraEnabled public Decimal PBS_AAAP_floors_Suites_in_Offered_Space { get; set; }
@AuraEnabled public String PBS_AAAP_OFFEROR_INTEREST { get; set; }
@AuraEnabled public String PBS_AAAP_OFFEROR_INTEREST_OTHER { get; set; }
@AuraEnabled public Double PBS_AAAP_GARAGE_SPACE_RSF { get; set; }
@AuraEnabled public String OwnerId { get; set; }
@AuraEnabled public String PBS_AAAP_Parking_Onsite { get; set; }
@AuraEnabled public String Name { get; set; }
@AuraEnabled public String PBS_AAAP_Owner_City { get; set; }
@AuraEnabled public String PBS_AAAP_Owner_Name { get; set; }
@AuraEnabled public Boolean PBS_RSAP_Property_Owner_Same_as_Offeror { get; set; }
@AuraEnabled public String PBS_AAAP_Owner_State { get; set; }
@AuraEnabled public String PBS_AAAP_Owner_Address { get; set; }
@AuraEnabled public String PBS_AAAP_User_Defined_Address { get; set; }
@AuraEnabled public String PBS_AAAP_Owner_Zip { get; set; }
@AuraEnabled public String PBS_AAAP_HVAC_HRS_ON_SAT_END { get; set; }
@AuraEnabled public String PBS_AAAP_HVAC_HRS_ON_SAT_START { get; set; }
@AuraEnabled public String PBS_AAAP_HVAC_HRS_ON_SUN_END { get; set; }
@AuraEnabled public String PBS_AAAP_HVAC_HRS_ON_SUN_START { get; set; }
@AuraEnabled public Decimal PBS_AAAP_TOTAL_BOMA_USF_OFFERED { get; set; }
@AuraEnabled public Double PBS_AAAP_GEN_PURPOSE_RENTABLE { get; set; }
@AuraEnabled public Double PBS_AAAP_Total_Park_Spaces_Offered { get; set; }
@AuraEnabled public Decimal PBS_AAAP_Total_Structured_Parking_Spaces { get; set; }
@AuraEnabled public Decimal PBS_AAAP_Total_Surface_Parking_Spaces { get; set; }
@AuraEnabled public String PBS_AAAP_DUNS_Number { get; set; }
@AuraEnabled public Double PBS_AAAP_RETAIL_SPACE_RSF { get; set; }
@AuraEnabled public Decimal PBS_AAAP_X_CO_ORD { get; set; }
@AuraEnabled public Decimal PBS_AAAP_Y_CO_ORD { get; set; }
@AuraEnabled public String PBS_AAAP_Renovation_Year { get; set; }
@AuraEnabled public String PBS_AAAP_Year_Built { get; set; }
@AuraEnabled public String PBS_AAAP_ZipCode { get; set; }
@AuraEnabled public String PBS_AAAP_RLPNumber { get; set; }
@AuraEnabled public String PBS_RSAP_RLPNumber { get; set; }
@AuraEnabled public String PBS_RLPORSolicitation_Number { get; set; }
@AuraEnabled public String PBS_AAAP_Offer_Status { get; set;}
@AuraEnabled public Decimal PBS_AAAP_Number_of_floors{ get; set;}
@AuraEnabled public String PBS_AAAP_Signature_First_Name { get; set;}
@AuraEnabled public String PBS_AAAP_SIGNATURE_LAST_NAME { get; set;}
@AuraEnabled public String PBS_AAAP_Owner_Country { get; set;}
@AuraEnabled public String recordType { get; set; } 
@AuraEnabled public String offerRecordType { get; set; }
@AuraEnabled public String offerPropertyId { get; set; }
@AuraEnabled public SObject record { get; set; }
@AuraEnabled public Boolean isSuccess { get; set; }
@AuraEnabled public Boolean isNewFlag { get; set; }
@AuraEnabled public String errorMessages { get; set; }
    
 public objectWrapper(){
        this.isSuccess = false;
        this.isNewFlag = true;
        this.errorMessages = '';
        
        }
     }
    
 public class ResponseWrapper {
        @AuraEnabled public Boolean isSuccess { get; set; }
        @AuraEnabled public List<String> errorMessages { get; set; }
        @AuraEnabled public String propId { get; set; }
        @AuraEnabled public String offerId { get; set; }
        // Constructor to initialize the response object
        public ResponseWrapper() {
            this.isSuccess = false;
            this.errorMessages = new List<String>();
        }
        // Method to add an error message to the response
        public void addErrorMessage(String message) {
            this.errorMessages.add(message);
        }
    }
 
}