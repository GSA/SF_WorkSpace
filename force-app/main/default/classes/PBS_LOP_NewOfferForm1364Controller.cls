public class PBS_LOP_NewOfferForm1364Controller extends PBS_AAAP_PageBaseController {
    public Id offerId { get; set; }
    public User userdetail { get; set; }
    public String sysDate { get; set; }
    public String email { get; set; }
    public String offerCreatedBy { get; set; }

    public List<PBS_RSAP_Step_Rent_Wrapper> stepFreeRentRecords { get; set; }
    public List<PBS_RSAP_Renewal_Options_Wrapper> renewalOptionsRecords { get; set; }
    public List<PBS_RSAP_Additional_Tax_Parcel_Info_Wrapper> additionalTaxParcelInfoRecords { get; set; }

    public PBS_AAAP_Offer__c offer ;
    public PBS_LOP_Offer_Wrapper offerWrapper {get; set;}


    public PBS_LOP_NewOfferForm1364Controller(){
        
        logConstructorStart('PBS_LOP_NewOfferForm1364Controller started...');
        offer = new PBS_AAAP_Offer__c();
        offerWrapper = new PBS_LOP_Offer_Wrapper();

        offerId = ApexPages.currentPage().getParameters().get('offerId');

        

        if (offerId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Missing Offer ID. Please try again.'));
            
            return;
        } else {
            try {
                offer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
                buildWrappers();

                offerCreatedBy = offer.CreatedById;
                userdetail = [SELECT u.Title, u.Street, u.State, u.PostalCode, u.Phone, u.Name, u.Id, u.Email, u.City,u.Contact.PBS_AAAP_Company__c FROM User u WHERE u.id = :offerCreatedBy];
                email = userDetail.Email;
                List<String> emailChars = new List<String>();
                emailChars = email.split('');
                String tempEmail = '';
                for(Integer index = 0; index < emailChars.size(); index++){
                    tempEmail += emailChars[index];
                    if(math.mod(index+1,25) == 0){
                        tempEmail += ' ';
                    }
                }
                email = tempEmail.substring(0,50);
                sysDate = (offer.PBS_AAAP_Offer_Submission_Date__c != null) ? (offer.PBS_AAAP_Offer_Submission_Date__c.month() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.day() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.year()) : '';
 
            } catch (Exception ex) {
                System.debug(ex.getCause() + ' with message ' + ex.getMessage() + ' caught calling PBS_AAAP_GlobalContstants.getOfferDetail().');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect Offer ID. Please try agai;n.'));
                return;
            }

            logConstructorEnd('PBS_LOP_NewOfferForm1364Controller ended...');        }
    }
    public Integer getIntegerValue(Decimal val){
        integer iVal;
        if(val != null){
            iVal = integer.valueOf(val);
        }
        return ival;
    }

    public void buildWrappers(){
        offerWrapper.PBS_AAAP_RLP_Number  = Offer.PBS_AAAP_RLP_Number__r.Name;
        offerWrapper.PBS_AAAP_Solicitation_Number= Offer.PBS_AAAP_Solicitation_Number__c;
        offerWrapper.PBS_AAAP_Building_Name  = Offer.PBS_AAAP_Building_Name__c;
        offerWrapper.PBS_AAAP_Street_Address  = Offer.PBS_AAAP_Street_Address__c;
        offerWrapper.PBS_AAAP_City  = Offer.PBS_AAAP_City__c;
        offerWrapper.PBS_AAAP_State  = Offer.PBS_AAAP_State__c;
        offerWrapper.PBS_AAAP_ZipCode  = Offer.PBS_AAAP_ZipCode__c;
        offerWrapper.PBS_AAAP_floors_Suites_in_Offered_Space  =  getIntegerValue(Offer.PBS_AAAP_floors_Suites_in_Offered_Space__c);
        offerWrapper.PBS_AAAP_GEN_PURPOSE_RENTABLE  = Offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c;
        offerWrapper.PBS_AAAP_OFFICE_SPACE_RSF  = Offer.PBS_AAAP_OFFICE_SPACE_RSF__c;
        offerWrapper.PBS_AAAP_RETAIL_SPACE_RSF  = Offer.PBS_AAAP_RETAIL_SPACE_RSF__c;
        offerWrapper.PBS_AAAP_GARAGE_SPACE_RSF  = Offer.PBS_AAAP_GARAGE_SPACE_RSF__c;
        offerWrapper.PBS_AAAP_Total_Surface_Parking_Spaces  =  (Integer) Offer.PBS_AAAP_Total_Surface_Parking_Spaces__c;
        offerWrapper.PBS_AAAP_Total_Structured_Parking_Spaces  =  (Integer) Offer.PBS_AAAP_Total_Structured_Parking_Spaces__c;
        offerWrapper.PBS_AAAP_Parking_Onsite  = Offer.PBS_AAAP_Parking_Onsite__c;
        offerWrapper.PBS_AAAP_Total_Park_Spaces_Offered  = Offer.PBS_AAAP_Total_Park_Spaces_Offered__c;
        offerWrapper.PBS_AAAP_Total_Ofc_ABOA_offered  = Offer.PBS_AAAP_Total_Ofc_ABOA_offered__c;
        offerWrapper.PBS_AAAP_Office_RSF_OFFERED  = Offer.PBS_AAAP_Office_RSF_OFFERED__c;
        offerWrapper.PBS_AAAP_Common_Area_Factor  = Offer.PBS_AAAP_Common_Area_Factor__c;
        offerWrapper.PBS_AAAP_floors_and_suites_offered  = Offer.PBS_AAAP_floors_and_suites_offered__c;
        offerWrapper.Confirm_Full_Term_Lease_Months  =  (Integer) Offer.Confirm_Full_Term_Lease_Months__c;
        offerWrapper.Confirm_Firm_Term_Lease_Months  =  (Integer) Offer.Confirm_Firm_Term_Lease_Months__c;
        offerWrapper.PBS_AAAP_Initial_Day_Terminate_Lease  =  (Integer) Offer.PBS_AAAP_Initial_Day_Terminate_Lease__c;
        offerWrapper.PBS_AAAP_Is_Shell_Rent_Stepped  =  Offer.PBS_AAAP_Is_Shell_Rent_Stepped__c;
        offerWrapper.PBS_RSAP_Shell_Initial_Annual  = Offer.PBS_RSAP_Shell_Initial_Annual__c;
        offerWrapper.PBS_RSAP_Shell_Rent_Per_RSF_Initial  = Offer.PBS_RSAP_Shell_Rent_Per_RSF_Initial__c;
        offerWrapper.PBS_RSAP_Shell_Rent_Per_ABOA_Initial  = Offer.PBS_RSAP_Shell_Rent_Per_ABOA_Initial__c;
        offerWrapper.PBS_AAAP_SRVC_UTIL_TOTAL_GOV  = Offer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c;
        offerWrapper.PBS_AAAP_OP_COST_COST_PER_RSF  = Offer.PBS_AAAP_OP_COST_COST_PER_RSF__c;
        offerWrapper.PBS_AAAP_OP_COST_COST_PER_ABOA  = Offer.PBS_AAAP_OP_COST_COST_PER_ABOA__c;
        offerWrapper.PBS_RSAP_TIA_Or_Turnkey  = Offer.PBS_RSAP_TIA_Or_Turnkey__c;
        offerWrapper.PBS_AAAP_TI_Buildout_as_in_RLP  = Offer.PBS_AAAP_TI_Buildout_as_in_RLP__c;
        offerWrapper.PBS_RSAP_TIA_Or_Turnkey  = Offer.PBS_RSAP_TIA_Or_Turnkey__c;
        offerWrapper.PBS_AAAP_TI_Total_Build_out_Costs  = Offer.PBS_AAAP_TI_Total_Build_out_Costs__c;
        offerWrapper.PBS_RSAP_Total_TI_Turnkey  = Offer.PBS_RSAP_Total_TI_Turnkey__c;
        offerWrapper.PBS_AAAP_TI_Amorti_Interest_Rate  = Offer.PBS_AAAP_TI_Amorti_Interest_Rate__c;
        offerWrapper.PBS_AAAP_TI_Amorization_in_Years  =  (Integer) Offer.PBS_AAAP_TI_Amorization_in_Years__c;
        offerWrapper.PBS_AAAP_Annual_TI_Rent  = Offer.PBS_AAAP_Annual_TI_Rent__c;
        offerWrapper.PBS_AAAP_TI_Annual_Rent_Per_RSF  = Offer.PBS_AAAP_TI_Annual_Rent_Per_RSF__c;
        offerWrapper.PBS_AAAP_TI_Annual_Rent_Per_ABOA  = Offer.PBS_AAAP_TI_Annual_Rent_Per_ABOA__c;
        offerWrapper.PBS_RSAP_BSAC_Rate_ABOA_or_Total  = Offer.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c;
        offerWrapper.PBS_RSAP_BSAC_Rate_from_RLP  = Offer.PBS_RSAP_BSAC_Rate_from_RLP__c;
        offerWrapper.PBS_RSAP_BSAC_Rate_ABOA_or_Total  = Offer.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c;
        offerWrapper.PBS_AAAP_BSAC_Total_Build_out_Costs  = Offer.PBS_AAAP_BSAC_Total_Build_out_Costs__c;
        offerWrapper.PBS_RSAP_BSAC_Rate_ABOA_or_Total  = Offer.PBS_RSAP_BSAC_Rate_ABOA_or_Total__c;
        offerWrapper.PBS_RSAP_BSAC_Calc_from_Rate  = Offer.PBS_RSAP_BSAC_Calc_from_Rate__c;
        offerWrapper.PBS_AAAP_BSAC_Amorti_Interest_Rate  = Offer.PBS_AAAP_BSAC_Amorti_Interest_Rate__c;
        offerWrapper.PBS_AAAP_BSAC_Amorization_in_Years  =  (Integer) Offer.PBS_AAAP_BSAC_Amorization_in_Years__c;
        offerWrapper.PBS_AAAP_Anual_BSAC_Rent  = Offer.PBS_AAAP_Anual_BSAC_Rent__c;
        offerWrapper.PBS_AAAP_BSAC_Annual_Rent_Per_RSF  = Offer.PBS_AAAP_BSAC_Annual_Rent_Per_RSF__c;
        offerWrapper.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA  = Offer.PBS_AAAP_BSAC_Annual_Rent_Per_ABOA__c;
        offerWrapper.PBS_AAAP_Monthly_cost_nonres_sur_park  = Offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c;
        offerWrapper.PBS_RSAP_Surf_NonResv_Parking  =  (Integer) Offer.PBS_RSAP_Surf_NonResv_Parking__c;
        offerWrapper.PBS_AAAP_Monthly_cost_nonres_gar_park  = Offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c;
        offerWrapper.PBS_RSAP_Struct_NonResv_Parking  = (Integer)  Offer.PBS_RSAP_Struct_NonResv_Parking__c;
        offerWrapper.PBS_AAAP_Monthly_cost_res_sur_park  = Offer.PBS_AAAP_Monthly_cost_res_sur_park__c;
        offerWrapper.PBS_RSAP_Surf_Resv_Parking  =  (Integer) Offer.PBS_RSAP_Surf_Resv_Parking__c;
        offerWrapper.PBS_AAAP_Monthly_cost_res_gar_park  = Offer.PBS_AAAP_Monthly_cost_res_gar_park__c;
        offerWrapper.PBS_RSAP_Struct_Resv_Parking  =  (Integer) Offer.PBS_RSAP_Struct_Resv_Parking__c;
        offerWrapper.PBS_RSAP_Total_Parking_Annual_Amount  = Offer.PBS_RSAP_Total_Parking_Annual_Amount__c;
        offerWrapper.PBS_RSAP_Lease_Annual_Rent  = Offer.PBS_RSAP_Lease_Annual_Rent__c;
        offerWrapper.PBS_AAAP_Lease_Annual_Rent_Per_RSF  = Offer.PBS_AAAP_Lease_Annual_Rent_Per_RSF__c;
        offerWrapper.PBS_AAAP_Lease_Annual_Rent_Per_ABOA  = Offer.PBS_AAAP_Lease_Annual_Rent_Per_ABOA__c;
        offerWrapper.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM  = Offer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c;
        offerWrapper.PBS_AAAP_Architectural_Fees_Percent  = Offer.PBS_AAAP_Architectural_Fees_Percent__c;
        offerWrapper.PBS_AAAP_ARCH_ENG_FEES_PER_USF  = Offer.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c;
        offerWrapper.PBS_AAAP_Architectural_Fees_Flat  = Offer.PBS_AAAP_Architectural_Fees_Flat__c;
        offerWrapper.PBS_AAAP_Lessor_Prj_Fees  = Offer.PBS_AAAP_Lessor_Prj_Fees__c;
        offerWrapper.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM  =  (Integer) Offer.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c;
        offerWrapper.PBS_RSAP_Free_Shell_Is_Offered  = Offer.PBS_RSAP_Free_Shell_Is_Offered__c;
        offerWrapper.PBS_RSAP_Free_Operating_Is_Offered  = Offer.PBS_RSAP_Free_Operating_Is_Offered__c;
        offerWrapper.PBS_RSAP_Free_TI_Is_Offered  = Offer.PBS_RSAP_Free_TI_Is_Offered__c;
        offerWrapper.PBS_RSAP_Free_BSAC_Is_Offered  = Offer.PBS_RSAP_Free_BSAC_Is_Offered__c;
        offerWrapper.PBS_RSAP_Free_Parking_Is_Offered  = Offer.PBS_RSAP_Free_Parking_Is_Offered__c;
        offerWrapper.PBS_RSAP_Free_Non_Standard_is_Offered  = Offer.PBS_RSAP_Free_Non_Standard_is_Offered__c;
        offerWrapper.PBS_AAAP_Free_Space_Offered  = Offer.PBS_AAAP_Free_Space_Offered__c;
        offerWrapper.PBS_RSAP_Are_you_offering_renewal_option  = Offer.PBS_RSAP_Are_you_offering_renewal_option__c;
        offerWrapper.PBS_AAAP_BROKER_TENANT_REP_COMM  = Offer.PBS_AAAP_BROKER_TENANT_REP_COMM__c;
        offerWrapper.PBS_AAAP_BROKER_OWNER_REP_COMM  = Offer.PBS_AAAP_BROKER_OWNER_REP_COMM__c;
        offerWrapper.PBS_AAAP_Vacant_Premise_Rate  = Offer.PBS_AAAP_Vacant_Premise_Rate__c;
        offerWrapper.PBS_AAAP_Adj_for_Reduced_Services_Rate  = Offer.PBS_AAAP_Adj_for_Reduced_Services_Rate__c;
        offerWrapper.PBS_RSAP_Tax_Parcel_RSF  = Offer.PBS_RSAP_Tax_Parcel_RSF__c;
        offerWrapper.PBS_AAAP_Government_Occupancy_Percentage  = Offer.PBS_AAAP_Government_Occupancy_Percentage__c;
        offerWrapper.PBS_AAAP_HVAC_OT_Rate  = Offer.PBS_AAAP_HVAC_OT_Rate__c;
        offerWrapper.PBS_AAAP_HVAC_OT_Rate_Type  = Offer.PBS_AAAP_HVAC_OT_Rate_Type__c;
        offerWrapper.PBS_AAAP_Number_of_zones  =  (Integer) Offer.PBS_AAAP_Number_of_zones__c;
        offerWrapper.PBS_RSAP_HVAC_Example  = Offer.PBS_RSAP_HVAC_Example__c;
        offerWrapper.PBS_RSAP_Year_Built  = Offer.PBS_RSAP_Year_Built__c;
        offerWrapper.PBS_RSAP_Renovation_Year  = Offer.PBS_RSAP_Renovation_Year__c;
        offerWrapper.PBS_AAAP_Approximate_Construction_Level  = Offer.PBS_AAAP_Approximate_Construction_Level__c;
        offerWrapper.PBS_AAAP_SHELL_Build_out_Costs  = Offer.PBS_AAAP_SHELL_Build_out_Costs__c;
        offerWrapper.PBS_AAAP_Approximate_Construction_Level  = Offer.PBS_AAAP_Approximate_Construction_Level__c;
        offerWrapper.PBS_AAAP_SITE_SIZE_SQFT  = Offer.PBS_AAAP_SITE_SIZE_SQFT__c;
        offerWrapper.PBS_AAAP_SITE_AREA_TYPE  = Offer.PBS_AAAP_SITE_AREA_TYPE__c;
        offerWrapper.PBS_AAAP_Total_Land_Cost  = Offer.PBS_AAAP_Total_Land_Cost__c;
        offerWrapper.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START  = Offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c;
        offerWrapper.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END  = Offer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c;
        offerWrapper.PBS_AAAP_HVAC_HRS_ON_SAT_START  = Offer.PBS_AAAP_HVAC_HRS_ON_SAT_START__c;
        offerWrapper.PBS_AAAP_HVAC_HRS_ON_SAT_END  = Offer.PBS_AAAP_HVAC_HRS_ON_SAT_END__c;
        offerWrapper.PBS_AAAP_HVAC_HRS_ON_SUN_START  = Offer.PBS_AAAP_HVAC_HRS_ON_SUN_START__c;
        offerWrapper.PBS_AAAP_HVAC_HRS_ON_SUN_END  = Offer.PBS_AAAP_HVAC_HRS_ON_SUN_END__c;
        offerWrapper.PBS_AAAP_FIRE_SAFETY_CERT  = Offer.PBS_AAAP_FIRE_SAFETY_CERT__c;
        offerWrapper.PBS_RSAP_Accessibility_Standards_Met  = Offer.PBS_RSAP_Accessibility_Standards_Met__c;
        offerWrapper.PBS_AAAP_Asbestos  = Offer.PBS_AAAP_Asbestos__c;
        offerWrapper.PBS_RSAP_Flood_Plain_Declaration  = Offer.PBS_RSAP_Flood_Plain_Declaration__c;
        offerWrapper.PBS_RSAP_Offeror_Seismic_Declaration  = Offer.PBS_RSAP_Offeror_Seismic_Declaration__c;
        offerWrapper.PBS_RSAP_Offeror_Seismic_Declaration_YES_NO  = Offer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c;
        offerWrapper.PBS_AAAP_Energy_Star  = Offer.PBS_AAAP_Energy_Star__c; 
        offerWrapper.PBS_AAAP_CERTIFICATION_DATE  = Offer.PBS_AAAP_CERTIFICATION_DATE__c == null ? null : Offer.PBS_AAAP_CERTIFICATION_DATE__c.format();
        offerWrapper.PBS_RSAP_Energy_Star_Response_No  = Offer.PBS_RSAP_Energy_Star_Response_No__c; 
        offerWrapper.PBS_RSAP_Energy_Star_Meets_Exceptions  = Offer.PBS_RSAP_Energy_Star_Meets_Exceptions__c;
        offerWrapper.PBS_AAAP_Energy_Star_Evaluation  = Offer.PBS_AAAP_Energy_Star_Evaluation__c;
        offerWrapper.PBS_RSAP_Building_is_a_historic_property  = Offer.PBS_RSAP_Building_is_a_historic_property__c;
        offerWrapper.PBS_RSAP_Bldg_within_a_historic_district  = Offer.PBS_RSAP_Bldg_within_a_historic_district__c;
        offerWrapper.PBS_RSAP_HubZone_Waiver  = Offer.PBS_RSAP_HubZone_Waiver__c;
        offerWrapper.PBS_AAAP_Owner_Name  = Offer.PBS_AAAP_Owner_Name__c;
        offerWrapper.PBS_AAAP_Owner_Address  = Offer.PBS_AAAP_Owner_Address__c;
        offerWrapper.PBS_AAAP_Owner_City  = Offer.PBS_AAAP_Owner_City__c;
        offerWrapper.PBS_AAAP_Owner_State  = Offer.PBS_AAAP_Owner_State__c;
        offerWrapper.PBS_AAAP_Owner_Zip  = Offer.PBS_AAAP_Owner_Zip__c;
        offerWrapper.PBS_AAAP_DUNS_Number  = Offer.PBS_AAAP_DUNS_Number__c;
        offerWrapper.PBS_AAAP_OFFEROR_INTEREST  = Offer.PBS_AAAP_OFFEROR_INTEREST__c;
        offerWrapper.PBS_AAAP_OFFEROR_INTEREST_OTHER  = Offer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
        offerWrapper.PBS_AAAP_ACCEPTED_TERMS_AND_COND  = Offer.PBS_AAAP_ACCEPTED_TERMS_AND_COND__c;
        offerWrapper.PBS_AAAP_Offer_Status  = Offer.PBS_AAAP_Offer_Status__c;
        offerWrapper.PBS_AAAP_Offered_Space_Mul_Tax_Bills  = Offer.PBS_AAAP_Offered_Space_Mul_Tax_Bills__c;
        offerWrapper.PBS_AAAP_Offer_Additional_Remarks  = Offer.PBS_AAAP_Offer_Additional_Remarks__c;
        offerWrapper.sysDate = (offer.PBS_AAAP_Offer_Submission_Date__c != null) ? (offer.PBS_AAAP_Offer_Submission_Date__c.month() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.day() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.year()) : '';

        // build wrappers for other tables

        stepFreeRentRecords = new List<PBS_RSAP_Step_Rent_Wrapper>();
        for (PBS_RSAP_Step_Rent__c rec :[SELECT Id, PBS_RSAP_Step_Annual_Rent__c, PBS_RSAP_Step_End__c, PBS_RSAP_Step_Payment_Basis__c, PBS_RSAP_Step_Rent_Type__c, PBS_RSAP_Step_Start__c, PBS_AAAP_Offer__c, PBS_RSAP_Rent_Number__c 
                                                FROM PBS_RSAP_Step_Rent__c 
                                                WHERE PBS_AAAP_Offer__c =:offerId AND PBS_AAAP_Offer__c != null AND (PBS_RSAP_Step_Annual_Rent__c  != null OR PBS_RSAP_Step_End__c  != null OR PBS_RSAP_Step_Payment_Basis__c  != null OR PBS_RSAP_Step_Rent_Type__c != null OR  PBS_RSAP_Step_Start__c != null) order by PBS_RSAP_Rent_Number__c]){
            stepFreeRentRecords.add(new PBS_RSAP_Step_Rent_Wrapper(rec));
        }

        
        renewalOptionsRecords = new List<PBS_RSAP_Renewal_Options_Wrapper>();
        for (PBS_RSAP_Renewal_Options__c rec :[SELECT Id,PBS_RSAP_Option_Duration__c, PBS_RSAP_Option_RSF_Rate__c, PBS_RSAP_Option_Days_Notice_to_Exercise__c, PBS_RSAP_Option_Number__c 
                                        FROM PBS_RSAP_Renewal_Options__c 
                                        WHERE PBS_AAAP_Offer__c =:offerId AND (PBS_RSAP_Option_Duration__c !=null Or PBS_RSAP_Option_RSF_Rate__c != null Or PBS_RSAP_Option_Days_Notice_to_Exercise__c != null) order by PBS_RSAP_Option_Number__c]){
            renewalOptionsRecords.add(new PBS_RSAP_Renewal_Options_Wrapper(rec));
        }
        
        additionalTaxParcelInfoRecords = new List<PBS_RSAP_Additional_Tax_Parcel_Info_Wrapper>();
        for (PBS_RSAP_Additional_Tax_Parcel_Info__c rec :[SELECT Id, PBS_RSAP_Sub_Tax_Parcel_Building_ID__c, PBS_RSAP_Sub_Tax_Parcel_Building_RSF__c, PBS_RSAP_Sub_Tax_Parcel_ID__c, PBS_RSAP_Sub_Tax_Parcel_ID_Number__c, PBS_AAAP_Offer__c, PBS_RSAP_Building_Number__c 
                                        FROM PBS_RSAP_Additional_Tax_Parcel_Info__c 
                                        WHERE PBS_AAAP_Offer__c =:offerId order by PBS_RSAP_Building_Number__c]){
            additionalTaxParcelInfoRecords.add(new PBS_RSAP_Additional_Tax_Parcel_Info_Wrapper(rec));
        }

        if(renewalOptionsRecords.size() == 0){
            renewalOptionsRecords.add(new PBS_RSAP_Renewal_Options_Wrapper(new PBS_RSAP_Renewal_Options__c()));                    
        }
        if(stepFreeRentRecords.size() == 0){
            stepFreeRentRecords.add(new PBS_RSAP_Step_Rent_Wrapper(new PBS_RSAP_Step_Rent__c()));                    
        }
        if(additionalTaxParcelInfoRecords.size() == 0){
            additionalTaxParcelInfoRecords.add(new PBS_RSAP_Additional_Tax_Parcel_Info_Wrapper(new PBS_RSAP_Additional_Tax_Parcel_Info__c()));                    
        }
    
    }

    public class PBS_RSAP_Step_Rent_Wrapper {
        public Double PBS_RSAP_Step_Annual_Rent {get; set;}
        public String PBS_RSAP_Step_End {get; set;}
        public String PBS_RSAP_Step_Start {get; set;}
        public String PBS_RSAP_Step_Payment_Basis {get; set;}
        public String PBS_RSAP_Step_Rent_Type {get; set;}
        public String PBS_AAAP_Offer {get; set;}
        public Integer PBS_RSAP_Rent_Number {get; set;}
        public PBS_RSAP_Step_Rent_Wrapper (PBS_RSAP_Step_Rent__c rec){
            PBS_RSAP_Step_Annual_Rent = rec.PBS_RSAP_Step_Annual_Rent__c;
            PBS_RSAP_Step_End = rec.PBS_RSAP_Step_End__c;
            PBS_RSAP_Step_Start = rec.PBS_RSAP_Step_Start__c;
            PBS_RSAP_Step_Payment_Basis = rec.PBS_RSAP_Step_Payment_Basis__c;
            PBS_RSAP_Step_Rent_Type = rec.PBS_RSAP_Step_Rent_Type__c;
            PBS_AAAP_Offer = rec.PBS_AAAP_Offer__c;
            PBS_RSAP_Rent_Number = (Integer) rec.PBS_RSAP_Rent_Number__c;
        }
    }

    public class PBS_RSAP_Renewal_Options_Wrapper {
        public Integer PBS_RSAP_Option_Number {get; set;}
        public String PBS_RSAP_Option_Duration {get; set;}
        public Double PBS_RSAP_Option_RSF_Rate {get; set;}
        public Integer PBS_RSAP_Option_Days_Notice_to_Exercise {get; set;}
        public PBS_RSAP_Renewal_Options_Wrapper (PBS_RSAP_Renewal_Options__c rec){
            PBS_RSAP_Option_Number =  (Integer) rec.PBS_RSAP_Option_Number__c;
            PBS_RSAP_Option_Duration = rec.PBS_RSAP_Option_Duration__c;
            PBS_RSAP_Option_RSF_Rate = rec.PBS_RSAP_Option_RSF_Rate__c;
            PBS_RSAP_Option_Days_Notice_to_Exercise =  (Integer) rec.PBS_RSAP_Option_Days_Notice_to_Exercise__c;
        }
    }

    public class PBS_RSAP_Additional_Tax_Parcel_Info_Wrapper {
        public String PBS_RSAP_Sub_Tax_Parcel_Building_ID {get; set;}
        public String PBS_AAAP_Offer {get; set;}
        public Integer PBS_RSAP_Building_Number {get; set;}
        public Double PBS_RSAP_Sub_Tax_Parcel_Building_RSF {get; set;}
        public String PBS_RSAP_Sub_Tax_Parcel_ID {get; set;}
        public String PBS_RSAP_Sub_Tax_Parcel_ID_Number {get; set;}
        public PBS_RSAP_Additional_Tax_Parcel_Info_Wrapper(PBS_RSAP_Additional_Tax_Parcel_Info__c rec){
            PBS_RSAP_Sub_Tax_Parcel_Building_ID = rec.PBS_RSAP_Sub_Tax_Parcel_Building_ID__c;
            PBS_AAAP_Offer = rec.PBS_AAAP_Offer__c;
            PBS_RSAP_Building_Number =  (Integer) rec.PBS_RSAP_Building_Number__c;
            PBS_RSAP_Sub_Tax_Parcel_Building_RSF = rec.PBS_RSAP_Sub_Tax_Parcel_Building_RSF__c;
            PBS_RSAP_Sub_Tax_Parcel_ID = rec.PBS_RSAP_Sub_Tax_Parcel_ID__c;
            PBS_RSAP_Sub_Tax_Parcel_ID_Number = rec.PBS_RSAP_Sub_Tax_Parcel_ID_Number__c;
        }
    }
}