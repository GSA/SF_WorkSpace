public with sharing class PBS_AAAP_AwardSelectedOfferController extends PBS_AAAP_PageBaseController {

    public PBS_AAAP_Offer_Select_Award_Info__c currentObj { get; set; }
    public string agencyRequirementId { get; set; }
    public string selectedOfferId { get; set; }
    public string selectedSpaceId { get; set; }
    public PBS_AAAP_Offer__c offer { get; set; }
    public PBS_AAAP_Agency_Requirement__c agency { get; set; }
    public PBS_AAAP_Space__c space { get; set; }
    public PBS_AAAP_Rate__c rate {get;set;}
    //public string offerSelectAwardID { get; set; }
    public string leaseTerm { get; set; }
    public List<String> leaseTermforRates {get;set;}

    public Double awardedCommonAreaFactor {get;set;}
    public Double awardTotalContractValue {get;set;}

    public Double shellRentperYear_FT {get;set;}
    public Double shellRentperRSF_FT {get;set;}
    public Double shellRentperYear_NFT {get;set;}
    public Double shellRentperRSF_NFT {get;set;}
    public Double operatingCostsperYear_FT {get;set;}
    public Double operatingCostsperRSF_FT {get;set;}
    public Double operatingCostsperYear_NFT {get;set;}
    public Double operatingCostsperRSF_NFT {get;set;}
    public Double tenantImprovementperYear_FT {get;set;}
    public Double tenantImprovementperRSF_FT {get;set;}

    public Double bsacperYear_FT {get;set;}
    public Double bsacperRSF_FT {get;set;}
    public Double parkingperYear_FT {get;set;}
    public Double parkingperRSF_FT {get;set;}
    public Double parkingperABOA_FT {get;set;}
    public Double parkingperYear_NFT {get;set;}
    public Double parkingperRSF_NFT {get;set;}
    public Double parkingperABOA_NFT {get;set;}
    //public Double operatingCostsperYear_FT {get;set;}
    //public Double operatingCostsperYear_NFT {get;set;}
    public Double totalAnnualRentperYear_FT {get;set;}
    public Double totalAnnualRentperRSF_FT {get;set;}
    public Double totalAnnualRentperABOA_FT {get;set;}
    public Double totalAnnualRentperYear_NFT {get;set;}
    public Double totalAnnualRentperRSF_NFT {get;set;}
    public Double totalAnnualRentperABOA_NFT {get;set;}
    public Double percentageOccupancyByRSF {get;set;}


    public Boolean rlp2019 {get;set;}
    public String title1 {get;set;}
    public String title2 {get;set;}
    public Double tiAmortizationTerm {get;Set;}
    public Double bsacAmortizationTerm {get;Set;}

    public Double TIRperABOA {get;set;}
    public Double BSACperABOA {get;set;}

    public Boolean showEdit {get;set;}

    public Decimal totTIammountRef {get;set;}
    public String totTIammountRefStr {get;set;}


    //public List<String> leaseTermforRatesContinuing {get;set;}

    public PBS_AAAP_AwardSelectedOfferController() {
        /*constructor code moved to actionMethod*/
    }

    public static void setFields(){

    }

    public PageReference actionSave() {
        logMethodStart('actionSave');

        Savepoint sp0 = Database.setSavepoint();
        String msg = '';
        PageReference ref = null;
        try {
            currentObj.PBS_AAAP_isSelected__c = true;
            currentObj.PBS_AAAP_IsAwarded__c = false;
            currentObj.PBS_AAAP_Awarded_Common_Area_Factor_as__c = awardedCommonAreaFactor;
            currentObj.PBS_AAAP_Awarded_Total_Contract_Value__c = awardTotalContractValue;
            //currentObj.PBS_AAAP_Total_Contract_Amount_Temp__c = awardTotalContractValue;
            //currentObj.PBS_AAAP_AWARDED_USF_Temp__c = currentObj.PBS_AAAP_SELECTED_USF__c;
            currentObj.PBS_AAAP_Shell_Rent_Per_Year_FT__c = shellRentperYear_FT;
            currentObj.PBS_AAAP_Shell_Rent_Per_RSF_FT__c = shellRentperRSF_FT;
            currentObj.PBS_AAAP_Operating_Costs_Per_Year__c = operatingCostsperYear_FT;
            currentObj.PBS_AAAP_Operating_Costs_Per_RSF__c = operatingCostsperRSF_FT;
            currentObj.PBS_AAAP_Tenant_Improvement_Rent_PerYear__c = tenantImprovementperYear_FT;
            currentObj.PBS_AAAP_Tenant_Improvement_Rent_Per_RSF__c = tenantImprovementperRSF_FT;
            currentObj.PBS_AAAP_BSAC_Per_Year__c = bsacperYear_FT;
            currentObj.PBS_AAAP_BSAC_Per_RSF__c = bsacperRSF_FT;
            currentObj.PBS_AAAP_Parking_Per_Year__c = parkingperYear_FT;
            currentObj.PBS_AAAP_Parking_Per_RSF__c = parkingperRSF_FT;
            currentObj.PBS_AAAP_Parking_Per_ABOA__c = parkingperABOA_FT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_Year_FT__c = totalAnnualRentperYear_FT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_RSF_FT__c = totalAnnualRentperRSF_FT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_ABOA_FT__c = totalAnnualRentperABOA_FT;

            currentObj.PBS_AAAP_Shell_Rent_Per_Year_NFT__c = shellRentperYear_NFT;
            currentObj.PBS_AAAP_Shell_Rent_Per_RSF_NFT__c = shellRentperRSF_NFT;
            currentObj.PBS_AAAP_Operating_Costs_Per_Year_NFT__c = operatingCostsperYear_NFT;
            currentObj.PBS_AAAP_Operating_Costs_Per_RSF_NFT__c = operatingCostsperRSF_NFT;
            currentObj.PBS_AAAP_Parking_Per_Year_NFT__c = parkingperYear_NFT;
            currentObj.PBS_AAAP_Parking_Per_RSF_NFT__c = parkingperRSF_NFT;
            currentObj.PBS_AAAP_Parking_Per_ABOA_NFT__c = parkingperABOA_NFT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_Year_NFT__c = totalAnnualRentperYear_NFT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_RSF_NFT__c = totalAnnualRentperRSF_NFT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_ABOA_NFT__c = totalAnnualRentperABOA_NFT;

            currentObj.PBS_AAAP_TI_Amortization_Term__c = String.valueOf(tiAmortizationTerm);
            currentObj.PBS_AAAP_BSAC_Amortization_Term__c = String.valueOf(bsacAmortizationTerm);
            currentObj.Percentage_Occupancy_by_RSF__c = percentageOccupancyByRSF;

            update currentObj;

            if (offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED ||
                    offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED) {
                if(currentObj.PBS_AAAP_AWARDED_USF__c!=null){
                space.PBS_AAAP_Total_ABOA_Awarded__c = space.PBS_AAAP_Total_ABOA_Awarded__c + currentObj.PBS_AAAP_AWARDED_USF__c;
                }
                if(currentObj.PBS_AAAP_SELECTED_USF__c!=null){
                space.PBS_AAAP_Total_ABOA_Selected__c = space.PBS_AAAP_Total_ABOA_Selected__c - currentObj.PBS_AAAP_SELECTED_USF__c;
                }
                space.PBS_AAAP_Total_ABOA_Available__c = space.PBS_AAAP_SF_OFFERED__c - space.PBS_AAAP_Total_ABOA_Awarded__c;

                // Changes made by sguni on 10/29/2012, to not fire the trigger while AAAP manger is Awarding offer.
                PBS_AAAP_OfferHelper.triggerupdate(true);
                update space;
                system.debug('Updated Space'+space);
                PBS_AAAP_OfferHelper.triggerupdate(false);
                // change ends

            }

            offer = [
                SELECT Id, Name, PBS_AAAP_Building_Name__c, PBS_AAAP_Street_Address__c, PBS_AAAP_City__c, PBS_AAAP_State__c, PBS_AAAP_ZipCode__c,
                        PBS_AAAP_Total_SF_Offered__c, PBS_AAAP_Total_Space_Selected__c, PBS_AAAP_Total_Withdraw_Space_Available__c, PBS_AAAP_Offer_Status__c,
                        PBS_AAAP_Monthly_cost_nonres_gar_park__c, PBS_AAAP_Monthly_cost_nonres_sur_park__c,
                        PBS_AAAP_Monthly_cost_res_gar_park__c, PBS_AAAP_Monthly_cost_res_sur_park__c,
                        PBS_AAAP_Owner_Address__c,PBS_AAAP_Owner_State__c,PBS_AAAP_Owner_City__c, PBS_AAAP_Owner_Zip__c, PBS_AAAP_Owner_Main_Phone__c, 
                        PBS_AAAP_Email__c, PBS_AAAP_GEN_PURPOSE_RENTABLE__c,PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c, PBS_AAAP_Number_of_floors__c, PBS_AAAP_Vacant_Premise_Rate__c, PBS_AAAP_Owner_Name__c, PBS_AAAP_Total_ABOA_Space_Available__c
                FROM PBS_AAAP_Offer__c
                WHERE id = :currentObj.PBS_AAAP_Offer_ID__c
            ];

            system.debug('Offer details before updating status in actionSave() method: ');
            system.debug('**** PBS_AAAP_Offer_Status__c: ' + offer.PBS_AAAP_Offer_Status__c);
            system.debug('**** PBS_AAAP_Total_ABOA_Space_Available__c: ' + offer.PBS_AAAP_Total_ABOA_Space_Available__c);
            system.debug('**** PBS_AAAP_Total_SF_Offered__c: ' + offer.PBS_AAAP_Total_SF_Offered__c);
            system.debug('**** PBS_AAAP_Total_Space_Selected__c: ' + offer.PBS_AAAP_Total_Space_Selected__c);   
    
            if (offer.PBS_AAAP_Total_ABOA_Space_Available__c < offer.PBS_AAAP_Total_SF_Offered__c) {
                system.debug('**** PBS_AAAP_Total_ABOA_Space_Available__c is less than PBS_AAAP_Total_Total_SF_Offered__c');
                if (offer.PBS_AAAP_Total_Space_Selected__c == 0) {
                    system.debug('*** PBS_AAAP_Total_Space_Selected equals zero');
                    if(offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED){        
                        system.debug('**** PBS_AAAP_Offer_Status__c equals Submitted so set status to Pending Review');
                        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED;
                    } else if(offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED || 
                              offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED){
                        system.debug('**** PBS_AAAP_Offer_Status__c equals Awarded or PBS_AAAP_Offer_Status__c equals Awarded/Submitted so set status to Awarded/Pending Review'); 
                        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
                    } else {
                        system.debug('**** PBS_AAAP_Offer_Status__c is not updated because of the above offer field settings1');
                    }
                } else if (offer.PBS_AAAP_Total_Space_Selected__c > 0) {
                    system.debug('**** PBS_AAAP_Total_Space_Selected is greater than zero');
                    if(offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED){
                        system.debug('**** PBS_Offer_Status__c equals Submitted so set status to Pending Review');
                        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED;
                    } else if(offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED || 
                              offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED){
                        system.debug('**** PBS_AAAP_Offer_Status__c equals Awarded or PBS_AAAP_Offer_Status__c equals Awarded/Submitted so set status to Awarded/Pending Review');
                        offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
                    }
                } else {
                    system.debug('**** PBS_Offer_Status__c is not updated because of the above offer field settings2');
                }
            } else {
                system.debug('**** PBS_AAAP_Total_ABOA_Space_Available__c is NOT less than PBS_AAAP_Total_Total_SF_Offered__c');
                if(offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED){
                    system.debug('**** PBS_AAAP_Offer_Status__c equals Submitted so set status to Pending Review');
                    offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SELECTED;
                } else if(offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED || 
                          offer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED){
                    system.debug('**** PBS_AAAP_Offer_Status__c equals Awarded or PBS_AAAP_Offer_Status__c equals Awarded/Submitted so set status to Awarded/Pending Review');
                    offer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
                } else {
                    system.debug('**** PBS_AAAP_Offer_Status__c is not updated because of the above offer field settings3');
                }                
            }

            // Changes made by sguni on 10/29/2012, to not fire the trigger while AAAP manger is Awarding offer.
            PBS_AAAP_OfferHelper.triggerupdate(true);
            system.debug('Updated offer'+offer);
            update offer;
            PBS_AAAP_OfferHelper.triggerupdate(false);
            // change ends

            //Changed by Nik for OOLOP-694

            agency.PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_PENDINGSELECTED;
            update agency;

            ref = Page.PBS_AAAP_AwardSelectedOfferInfo;
            ref.getParameters().put('id', currentObj.Id);
            ref.setRedirect(true);


        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            Database.rollback(sp0);
            ref = null;
        }

        logMethodEnd('actionSave', ref);
        return ref;
    }

    public PageReference actionCancel() {
        logMethodStart('actionCancel');

        PageReference pref = null;
        pref = Page.PBS_AAAP_AgencyRequirement;
        pref.getParameters().put('id', currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__c);
        pref.setRedirect(true);

        logMethodEnd('actionCancel', pref);
        return pref;
    }

    public PageReference actionEdit() {
        logMethodStart('actionEdit');

        PageReference pref = null;
        pref = Page.PBS_AAAP_AwardSelectedOfferInfoEdit;
        pref.getParameters().put('id', currentObj.Id);
        pref.setRedirect(true);

        logMethodEnd('actionEdit', pref);
        return pref;
    }

    public void actionMethod(){
        logMethodStart('PBS_AAAP_AwardSelectedOfferController constructor');

        //offerSelectAwardID = ApexPages.currentPage().getParameters().get('id');// offerSelectAwardID (PBS_AAAP_Offer_Select_Award_Info__c id)
        awardedCommonAreaFactor = 0;
        awardTotalContractValue = 0;
        shellRentperYear_FT = 0;
        shellRentperRSF_FT = 0;
        shellRentperYear_NFT = 0;
        shellRentperRSF_NFT = 0;
        operatingCostsperYear_FT = 0;
        operatingCostsperRSF_FT = 0;
        operatingCostsperYear_NFT = 0;
        operatingCostsperRSF_NFT = 0;
        tenantImprovementperYear_FT = 0;
        tenantImprovementperRSF_FT = 0;
        bsacperYear_FT = 0;
        bsacperRSF_FT = 0;
        parkingperYear_FT = 0;
        parkingperRSF_FT = 0;
        parkingperABOA_FT = 0;
        parkingperYear_NFT = 0;
        parkingperRSF_NFT = 0;
        parkingperABOA_NFT = 0;
        operatingCostsperYear_FT = 0;
        operatingCostsperYear_NFT = 0;
        totalAnnualRentperYear_FT = 0;
        totalAnnualRentperRSF_FT = 0;
        totalAnnualRentperABOA_FT = 0;
        totalAnnualRentperYear_NFT = 0;
        totalAnnualRentperRSF_NFT = 0;
        totalAnnualRentperABOA_NFT = 0;
        percentageOccupancyByRSF = 0;
        title1 = 'Annual Rent (Firm Term)';
        title2 = 'Annual Rent (Non-Firm Term)';

        TIRperABOA = 0.0;
        BSACperABOA = 0.0;

        currentObj = [
                SELECT Id, PBS_AAAP_Offer_ID__c, PBS_AAAP_Space_ID__c, PBS_AAAP_AGENCY_REQUIREMENT_ID__c, PBS_AAAP_NEW_GSA_LEASE_NUM__c,
                        PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c,PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c,
                        PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c,PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c,
                        PBS_AAAP_Total_Contract_Amount__c, PBS_AAAP_AWARDED_USF__c, PBS_AAAP_LEASE_EXPIRATION_DATE__c, PBS_AAAP_CONTRACT_AWARD_DATE__c,
                        PBS_AAAP_Parking_for_govt_owned_vehicles__c, PBS_AAAP_BASE_RATE__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c, PBS_AAAP_TOTAL_MARKUP__c,
                        PBS_AAAP_COST_FOR_TI__c, PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c, PBS_AAAP_FULLY_SRVC_FIRM_TERM__c,
                        PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c, PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                        PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c, PBS_AAAP_OT_RATE_COOLING_HEAT__c, PBS_AAAP_ACTUAL_TI_AMORTIZED_INTO_RENT__c,
                        CreatedById, LastModifiedById, OwnerId, PBS_AAAP_SELECTED_USF__c,PBS_AAAP_isSelected__c,PBS_AAAP_IsAwarded__c,
                        CreatedDate, LastModifiedDate, PBS_AAAP_Awarded_RSF__c, PBS_AAAP_Awarded_Common_Area_Factor_as__c, PBS_AAAP_PV_RATE__c,
                        PBS_AAAP_LCRM_PRE_AWARD__c, PBS_AAAP_Shell_Rent_Per_RSF_FT__c, PBS_AAAP_Shell_Rent_Per_Year_FT__c, PBS_AAAP_Operating_Costs_Per_Year__c,
                        PBS_AAAP_Operating_Costs_Per_RSF__c, PBS_AAAP_Tenant_Improvement_Rent_PerYear__c, PBS_AAAP_Tenant_Improvement_Rent_Per_RSF__c, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                        PBS_AAAP_Total_Annual_Rent_Per_ABOA_FT__c, PBS_AAAP_Total_Annual_Rent_Per_RSF_FT__c, PBS_AAAP_Total_Annual_Rent_Per_Year_FT__c, PBS_AAAP_Parking_Per_Year__c, PBS_AAAP_Parking_Per_RSF__c, PBS_AAAP_Parking_Per_ABOA__c,
                        PBS_AAAP_BSAC_Per_Year__c, PBS_AAAP_BSAC_Per_RSF__c, PBS_AAAP_BSAC_Per_ABOA__c, PBS_AAAP_Total_Annual_Rent_Per_ABOA_NFT__c, PBS_AAAP_Total_Annual_Rent_Per_RSF_NFT__c, PBS_AAAP_Total_Annual_Rent_Per_Year_NFT__c,
                        PBS_AAAP_Parking_Per_ABOA_NFT__c, PBS_AAAP_Parking_Per_RSF_NFT__c, PBS_AAAP_Parking_Per_Year_NFT__c, PBS_AAAP_Operating_Costs_Per_RSF_NFT__c,PBS_AAAP_TI_Allowance__c,PBS_AAAP_BSAC_Placeholder__c,
                        PBS_AAAP_Operating_Costs_Per_Year_NFT__c, PBS_AAAP_Shell_Rent_Per_RSF_NFT__c, PBS_AAAP_Shell_Rent_Per_Year_NFT__c, Non_reserved_surface_Spaces_for_GOVs__c, Unreserved_Structured_spaces_for_GOVs__c, Reserved_Surface_Spaces_for_GOVs__c,
                        Reserved_Structured_Spaces_for_GOVs__c, Percentage_Occupancy_by_RSF__c, LastModifiedBy.Name, PBS_AAAP_Rate_ID__c, PBS_AAAP_BSAC_Amortization_Rate__c,PBS_AAAP_BSAC_Amortization_Term__c,PBS_AAAP_TI_Amortization_Term__c, PBS_AAAP_Recorded_Owner_Email__c,
                        PBS_AAAP_Shell_Rent_Per_Year_ABOA__c,PBS_AAAP_Shell_Rent_Per_ABOA_NFT__c, PBS_AAAP_Operating_Costs_Per_ABOA_NFT__c, PBS_AAAP_Operating_Costs_Per_ABOA__c,
                        PBS_AAAP_TI_Amortization_Rate__c,PBS_AAAP_Reserved_Structured__c,PBS_AAAP_Reserved_Surface__c,PBS_AAAP_Unreserved_Structured__c,PBS_AAAP_Unreserved_Surface__c,
                        PBS_AAAP_A_E_Fees__c,PBS_AAAP_Adjustment_for_Vacant_Premises__c,PBS_AAAP_Free_Rent__c,PBS_AAAP_HVAC_Overtime_Rate_per_Hour__c,PBS_AAAP_Lessor_PM_Fee__c,
                        PBS_AAAP_AWARDED_USF_Temp__c,PBS_AAAP_Total_Contract_Amount_Temp__c
                FROM PBS_AAAP_Offer_Select_Award_Info__c
                WHERE Id = :ApexPages.currentPage().getParameters().get('id')    //offerSelectAwardID
        ];
        
        if(currentObj.Non_reserved_surface_Spaces_for_GOVs__c == NULL){
            //currentObj.Non_reserved_surface_Spaces_for_GOVs__c = currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c;
            currentObj.Non_reserved_surface_Spaces_for_GOVs__c = currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c;
        }
        
        if(currentObj.Unreserved_Structured_spaces_for_GOVs__c == NULL){
            //currentObj.Unreserved_Structured_spaces_for_GOVs__c = currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_NONRESV_PARK_SPACES_SURLOT__c;
            currentObj.Unreserved_Structured_spaces_for_GOVs__c = currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c;
        }
        
        if(currentObj.Reserved_Surface_Spaces_for_GOVs__c == NULL){
            //currentObj.Reserved_Surface_Spaces_for_GOVs__c = currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c;
            currentObj.Reserved_Surface_Spaces_for_GOVs__c = currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_RESEV_PARK_SPACES_SUR_LOT__c;
        }
        
        if(currentObj.Reserved_Structured_Spaces_for_GOVs__c == NULL){
            //currentObj.Reserved_Structured_Spaces_for_GOVs__c = currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_NONRESV_PARK_SPACES_GARAGE__c;
            currentObj.Reserved_Structured_Spaces_for_GOVs__c = currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__r.PBS_AAAP_TOT_RESV_PARKING_SPACES_GARAGE__c;
        }

        showEdit = currentObj.PBS_AAAP_IsAwarded__c;
        system.debug('****showEdit'+showEdit);

        //if (currentObj.PBS_AAAP_ACTUAL_TI_AMORTIZED_INTO_RENT__c < 0) {
        //    currentObj.PBS_AAAP_ACTUAL_TI_AMORTIZED_INTO_RENT__c = currentObj.PBS_AAAP_ACTUAL_TI_AMORTIZED_INTO_RENT__c * -1;
        //}
        //if (currentObj.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c != null) {
        //    currentObj.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c = (currentObj.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c).setScale(2);
        //}
        offer = [
                SELECT Id, Name, PBS_AAAP_Building_Name__c, PBS_AAAP_Street_Address__c, PBS_AAAP_City__c, PBS_AAAP_State__c, PBS_AAAP_ZipCode__c,
                        PBS_AAAP_Total_SF_Offered__c, PBS_AAAP_Total_Space_Selected__c, PBS_AAAP_Total_Withdraw_Space_Available__c, PBS_AAAP_Offer_Status__c,
                        PBS_AAAP_Monthly_cost_nonres_gar_park__c, PBS_AAAP_Monthly_cost_nonres_sur_park__c,PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c,
                        PBS_AAAP_Monthly_cost_res_gar_park__c, PBS_AAAP_Monthly_cost_res_sur_park__c,PBS_AAAP_RLP_Number__c,
                        PBS_AAAP_Owner_Address__c,PBS_AAAP_Owner_State__c,PBS_AAAP_Owner_City__c, PBS_AAAP_Owner_Zip__c, PBS_AAAP_Owner_Main_Phone__c,
                        PBS_AAAP_Email__c, PBS_AAAP_GEN_PURPOSE_RENTABLE__c,PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c, PBS_AAAP_Number_of_floors__c, PBS_AAAP_Vacant_Premise_Rate__c, PBS_AAAP_Owner_Name__c,PBS_AAAP_Total_ABOA_Space_Available__c
                FROM PBS_AAAP_Offer__c
                WHERE id = :currentObj.PBS_AAAP_Offer_ID__c
        ];

        //if(currentObj.PBS_AAAP_AWARDED_USF__c == null){
        //    currentObj.PBS_AAAP_AWARDED_USF__c = Offer.PBS_AAAP_SELECTED_USF__c;
        //}


        agency = [SELECT Id, PBS_AAAP_REQ_STATUS__c, Name, PBS_AAAP_Lease_Term__c, PBS_AAAP_Project_ID__c, PBS_AAAP_AASN_AAAP_MANAGER__c, PBS_AAAP_NICKNAME__c FROM PBS_AAAP_Agency_Requirement__c WHERE id = :currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__c];

        if(Integer.valueOf(offer.PBS_AAAP_RLP_Number__r.PBS_AAAP_Year__c) >2018){
            rlp2019 = true;
            if(rlp2019 && (agency.PBS_AAAP_Lease_Term__c=='17 years, 15 firm'||agency.PBS_AAAP_Lease_Term__c=='15 years, 13 firm'||agency.PBS_AAAP_Lease_Term__c=='10 years, 8 firm')){
                title1 = 'Annual Rent Initial Term (Years 1-8)';
                title2 = 'Annual Rent Secondary Term (Years 9 to End of Lease)';
            }
            if(agency.PBS_AAAP_Lease_Term__c=='10 years,5 firm'){   
                title1 = 'Annual Rent Initial Term (Years 1 - 5)';  
                title2 = 'Annual Rent Secondary Term (Years 6 - 10)';   
            }   

        }

        space = [
                SELECT Id, PBS_AAAP_Total_ABOA_Available__c, PBS_AAAP_Total_ABOA_Awarded__c, PBS_AAAP_Total_ABOA_Edited__c, PBS_AAAP_TOT_EXP_ABOA__c,
                        PBS_AAAP_Total_ABOA_Selected__c, PBS_AAAP_Total_ABOA_Withdrawn__c, PBS_AAAP_SF_OFFERED__c, PBS_AAAP_GC_OVERHEAD_AND_PROF__c, PBS_AAAP_ARCH_ENG_FEES__c, PBS_AAAP_ARCHITECTURAL_AND_ENG_FEES_UOM__c
                FROM PBS_AAAP_Space__c
                WHERE id = :currentObj.PBS_AAAP_Space_ID__c
        ];
        System.debug('Agenc lease: '+agency.PBS_AAAP_LEASE_TERM__c);
        System.debug('space: '+space);
        if (agency.PBS_AAAP_LEASE_TERM__c != null) {

            List<PBS_AAAP_Rate__c> ratelst = new List<PBS_AAAP_Rate__c>();
            ratelst = [SELECT PBS_AAAP_TWO_YEAR_EXTENSION__c, PBS_AAAP_SPACE__c,
                    PBS_AAAP_OT_RATE_COOLING_HEAT__c, PBS_AAAP_ONE_YEAR_EXTENSION__c,
                    PBS_AAAP_OFFER_NUMBER__c, PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                    PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, PBS_AAAP_LEASE_TERM__c,
                    PBS_AAAP_IDENTIFIER_ID__c, PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                    PBS_AAAP_COST_FOR_TI__c, PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c,
                    PBS_AAAP_BASE_RATE__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,
                    PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,
                    PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                    PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                    PBS_AAAP_PV_Value__c, PBS_AAAP_PV_Value_Blended__c,
                    Id,PBS_AAAP_BSAC__c,PBS_AAAP_BSAC_RATE__c,Name
            FROM PBS_AAAP_Rate__c
            WHERE PBS_AAAP_SPACE__c = :currentObj.PBS_AAAP_Space_ID__c
            AND PBS_AAAP_LEASE_TERM__c = :agency.PBS_AAAP_LEASE_TERM__c
            ];

            leaseTerm = agency.PBS_AAAP_LEASE_TERM__c;
            if(ratelst.size() == 0){
                //String leasekey = iform.leaseTerm;
                System.debug('rate null lease term: '+leaseTerm);
                if(leaseTerm.contains('ths, ')){
                    leaseTerm = leaseTerm.replace('ths, ', 'ths,');
                    System.debug('leasekey post update: '+leaseTerm);
                }else{
                    leaseTerm = leaseTerm.replace('ths,', 'ths, ');
                    System.debug('leasekey post update: '+leaseTerm);
                }
                //rateKey = (String.valueOf(iform.spaceId).substring(0, 15) + '' + String.valueOf(iform.offerId).substring(0, 15)+(leasekey).toLowercase()).trim();
                //rate = mapRate19.get(rateKey);
                //system.debug('Final Rate object after key update: ' + rate + ' Rate Key: ' +rateKey);
                rate = [SELECT PBS_AAAP_TWO_YEAR_EXTENSION__c, PBS_AAAP_SPACE__c,
                        PBS_AAAP_OT_RATE_COOLING_HEAT__c, PBS_AAAP_ONE_YEAR_EXTENSION__c,
                        PBS_AAAP_OFFER_NUMBER__c, PBS_AAAP_NO_OF_MONTHS_FREE_OPTION_TERM__c,
                        PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c, PBS_AAAP_LEASE_TERM__c,
                        PBS_AAAP_IDENTIFIER_ID__c, PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c,
                        PBS_AAAP_COST_FOR_TI__c, PBS_AAAP_COOP_COMM_TOGSA_FIRM_TERM__c,
                        PBS_AAAP_BASE_RATE__c, PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c,
                        PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c, PBS_AAAP_AMORTIZ_RATE_T1_ABOVE_20__c,
                        PBS_AAAP_ADDTL_AMT_FOR_GOVT_OWNED_EQUIP__c, PBS_AAAP_ADDTL_AMT_DAY_CLEANING__c,
                        PBS_AAAP_FULLY_SRVC_FIRM_TERM__c, PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c,
                        PBS_AAAP_PV_Value__c, PBS_AAAP_PV_Value_Blended__c,
                        Id,PBS_AAAP_BSAC__c,PBS_AAAP_BSAC_RATE__c,Name
                FROM PBS_AAAP_Rate__c
                WHERE PBS_AAAP_SPACE__c = :currentObj.PBS_AAAP_Space_ID__c
                AND PBS_AAAP_LEASE_TERM__c = :leaseTerm
                ];

            }else{

                rate = ratelst[0];
            }
        }
        if(rate != null){
            System.debug('Rates: '+rate);

            if(currentObj.PBS_AAAP_Shell_Rent_Per_Year_ABOA__c == NULL){
                currentObj.PBS_AAAP_Shell_Rent_Per_Year_ABOA__c = rate.PBS_AAAP_BASE_RATE__c.setScale(2);
            }
            if(currentObj.PBS_AAAP_Shell_Rent_Per_ABOA_NFT__c == NULL){
                currentObj.PBS_AAAP_Shell_Rent_Per_ABOA_NFT__c = rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c.setScale(2);
            }
            if(currentObj.PBS_AAAP_Operating_Costs_Per_ABOA__c == NULL){
                currentObj.PBS_AAAP_Operating_Costs_Per_ABOA__c = rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c.setScale(2);
            }
            if(currentObj.PBS_AAAP_Operating_Costs_Per_ABOA_NFT__c == NULL){
                currentObj.PBS_AAAP_Operating_Costs_Per_ABOA_NFT__c = rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c.setScale(2);
            }
            if(currentObj.PBS_AAAP_TI_Amortization_Rate__c == NULL){
                currentObj.PBS_AAAP_TI_Amortization_Rate__c = rate.PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c;
            }
            if(currentObj.PBS_AAAP_BSAC_Amortization_Rate__c == NULL){
                currentObj.PBS_AAAP_BSAC_Amortization_Rate__c = rate.PBS_AAAP_BSAC_RATE__c;
            }
            //PBS_AAAP_Reserved_Structured__c,PBS_AAAP_Reserved_Surface__c,PBS_AAAP_Unreserved_Structured__c,PBS_AAAP_Unreserved_Surface__c
            if(currentObj.PBS_AAAP_Reserved_Structured__c == NULL){
                if(offer.PBS_AAAP_Monthly_cost_res_gar_park__c != NULL){
                    currentObj.PBS_AAAP_Reserved_Structured__c = offer.PBS_AAAP_Monthly_cost_res_gar_park__c;
                } else {
                    currentObj.PBS_AAAP_Reserved_Structured__c = 0;
                }
            }
            if(currentObj.PBS_AAAP_Reserved_Surface__c == NULL){
                if(offer.PBS_AAAP_Monthly_cost_res_sur_park__c != NULL){
                    currentObj.PBS_AAAP_Reserved_Surface__c = offer.PBS_AAAP_Monthly_cost_res_sur_park__c;
                } else {
                    currentObj.PBS_AAAP_Reserved_Surface__c = 0;  
                }
            }
            if(currentObj.PBS_AAAP_Unreserved_Structured__c == NULL){
                if(offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c != NULL){
                    currentObj.PBS_AAAP_Unreserved_Structured__c = offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c;
                } else {
                    currentObj.PBS_AAAP_Unreserved_Structured__c = 0;
                }
            }
            if(currentObj.PBS_AAAP_Unreserved_Surface__c == NULL){
                if(offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c != NULL){
                    currentObj.PBS_AAAP_Unreserved_Surface__c = offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c;
                } else {
                    currentObj.PBS_AAAP_Unreserved_Surface__c = 0;
                }
            }
            //PBS_AAAP_A_E_Fees__c,PBS_AAAP_Adjustment_for_Vacant_Premises__c,PBS_AAAP_Free_Rent__c,PBS_AAAP_HVAC_Overtime_Rate_per_Hour__c,PBS_AAAP_Lessor_PM_Fee__c
            if(currentObj.PBS_AAAP_A_E_Fees__c == NULL){
                currentObj.PBS_AAAP_A_E_Fees__c = space.PBS_AAAP_ARCH_ENG_FEES__c;
            }
            if(currentObj.PBS_AAAP_Adjustment_for_Vacant_Premises__c == NULL){
                currentObj.PBS_AAAP_Adjustment_for_Vacant_Premises__c = offer.PBS_AAAP_Vacant_Premise_Rate__c;
            }
            if(currentObj.PBS_AAAP_Free_Rent__c == NULL){
                currentObj.PBS_AAAP_Free_Rent__c = rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c;
            }
            if(currentObj.PBS_AAAP_HVAC_Overtime_Rate_per_Hour__c == NULL){
                currentObj.PBS_AAAP_HVAC_Overtime_Rate_per_Hour__c = rate.PBS_AAAP_OT_RATE_COOLING_HEAT__c;
            }
            if(currentObj.PBS_AAAP_Lessor_PM_Fee__c == NULL){
                currentObj.PBS_AAAP_Lessor_PM_Fee__c = space.PBS_AAAP_GC_OVERHEAD_AND_PROF__c;
            }
            //update currentObj;

            //if(currentObj.PBS_AAAP_TI_Amortization_Term__c == null){
            if(leaseTerm == '19 months, 11 firm'|| leaseTerm == '19 months,11 firm'){
                tiAmortizationTerm = 11;
                bsacAmortizationTerm = 11;

            }else if(leaseTerm == '25 months, 16 firm'|| leaseTerm == '25 months,16 firm') {
                tiAmortizationTerm = 16;
                bsacAmortizationTerm = 16;
            }else if(leaseTerm == '10 years,5 firm'){
                tiAmortizationTerm = 60;
                bsacAmortizationTerm = 60;
            }else if(leaseTerm == '15 years,10 firm') {
                tiAmortizationTerm = 120;
                bsacAmortizationTerm = 120;
            }else if(leaseTerm == '10 years') {
                tiAmortizationTerm = 120;
                bsacAmortizationTerm = 120;
            }else{
                tiAmortizationTerm = 96;
                bsacAmortizationTerm = 96;
            }
            //}

            if(currentObj.PBS_AAAP_TI_Amortization_Rate__c != NULL || tiAmortizationTerm != NULL || currentObj.PBS_AAAP_TI_Allowance__c != NULL){
                Double result1 = 0;
                Double TIamoRate = 0;
                Double TIallowance = 0;
                if(currentobj.PBS_AAAP_TI_Amortization_Rate__c != NULL) {
                    TIamoRate = currentobj.PBS_AAAP_TI_Amortization_Rate__c;
                }
                if(currentObj.PBS_AAAP_TI_Allowance__c != NUll) {
                    TIallowance = currentObj.PBS_AAAP_TI_Allowance__c;
                }
                result1 = PBS_AAAP_CalculationHelper.PMT((TIamoRate/100)/12, tiAmortizationTerm, TIallowance);
                system.debug('^^^^'+TIamoRate);
                system.debug('^^^^'+tiAmortizationTerm);
                system.debug('^^^^'+TIallowance);
                system.debug('^^^^'+result1);
                if(result1 == NULL){
                    TIRperABOA = 0;
                } else {
                    TIRperABOA = -12 * result1;
                }
            }

            if(currentObj.PBS_AAAP_BSAC_Amortization_Rate__c != NULL || bsacAmortizationTerm != NULL || currentObj.PBS_AAAP_BSAC_Placeholder__c != NULL){
                Double result2 = 0;
                Double BSACamoRate = 0;
                Double BSACallowance = 0;
                if(currentobj.PBS_AAAP_BSAC_Amortization_Rate__c != NULL){
                    BSACamoRate = currentobj.PBS_AAAP_BSAC_Amortization_Rate__c;
                }
                if(currentObj.PBS_AAAP_BSAC_Placeholder__c != NULL){
                    BSACallowance = currentObj.PBS_AAAP_BSAC_Placeholder__c;
                }
                result2 = PBS_AAAP_CalculationHelper.PMT((BSACamoRate/100)/12, bsacAmortizationTerm, BSACallowance);
                if(result2 == NULL){
                    BSACperABOA = 0;
                } else {
                    BSACperABOA = -12 * result2;
                }
            }

            rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c = (rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c).setScale(2);
            rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = (rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c).setScale(2);
            rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = (rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c).setScale(2);
            rate.PBS_AAAP_BSAC__c = (rate.PBS_AAAP_BSAC__c).setScale(2);

            rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c = (rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c).setScale(2);
            //rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c = (rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c).setScale(2);
            //rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c = (rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c).setScale(2);
            //rate.PBS_AAAP_BSAC__c = (rate.PBS_AAAP_BSAC__c).setScale(2);

            offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c = (offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c !=null) ? (offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c).setScale(2) : 0;
            offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c = (offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c != null) ?(offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c).setScale(2) : 0;
            offer.PBS_AAAP_Monthly_cost_res_sur_park__c = (offer.PBS_AAAP_Monthly_cost_res_sur_park__c != null) ? (offer.PBS_AAAP_Monthly_cost_res_sur_park__c).setScale(2) : 0;
            offer.PBS_AAAP_Monthly_cost_res_gar_park__c = (offer.PBS_AAAP_Monthly_cost_res_gar_park__c != null) ? (offer.PBS_AAAP_Monthly_cost_res_gar_park__c).setScale(2) : 0;

            if(currentObj.PBS_AAAP_Awarded_RSF__c != null && currentObj.PBS_AAAP_SELECTED_USF__c > 0){
                awardedCommonAreaFactor = (currentObj.PBS_AAAP_Awarded_RSF__c - currentObj.PBS_AAAP_SELECTED_USF__c)*100/currentObj.PBS_AAAP_SELECTED_USF__c;
            }
            shellRentperYear_FT = (currentObj.PBS_AAAP_SELECTED_USF__c*currentObj.PBS_AAAP_Shell_Rent_Per_Year_ABOA__c).setScale(2);  //rate.PBS_AAAP_FULLY_SRVC_FIRM_TERM__c - Nik
            operatingCostsperYear_FT = (currentObj.PBS_AAAP_SELECTED_USF__c*currentObj.PBS_AAAP_Operating_Costs_Per_ABOA__c).setScale(2); //rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c - Nik
            tenantImprovementperYear_FT = (currentObj.PBS_AAAP_SELECTED_USF__c*TIRperABOA).setScale(2);  //rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c change rate to currentObj
            bsacperYear_FT = (currentObj.PBS_AAAP_SELECTED_USF__c*BSACperABOA).setScale(2);
            if(currentObj.Non_reserved_surface_Spaces_for_GOVs__c!=null && currentObj.Unreserved_Structured_spaces_for_GOVs__c!=null && currentObj.Reserved_Surface_Spaces_for_GOVs__c!=null && currentObj.Reserved_Structured_Spaces_for_GOVs__c!=null){
                parkingperYear_FT = ((currentObj.PBS_AAAP_Unreserved_Surface__c*currentObj.Non_reserved_surface_Spaces_for_GOVs__c +
                        currentObj.PBS_AAAP_Unreserved_Structured__c*currentObj.Unreserved_Structured_spaces_for_GOVs__c+
                        currentObj.PBS_AAAP_Reserved_Surface__c*currentObj.Reserved_Surface_Spaces_for_GOVs__c+
                        currentObj.PBS_AAAP_Reserved_Structured__c*currentObj.Reserved_Structured_Spaces_for_GOVs__c)*12).setScale(2);
                /*parkingperYear_FT = ((offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c*currentObj.Non_reserved_surface_Spaces_for_GOVs__c
                        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c*currentObj.Unreserved_Structured_spaces_for_GOVs__c+
                        offer.PBS_AAAP_Monthly_cost_res_sur_park__c*currentObj.Reserved_Surface_Spaces_for_GOVs__c+
                        offer.PBS_AAAP_Monthly_cost_res_gar_park__c*currentObj.Reserved_Structured_Spaces_for_GOVs__c)*12).setScale(2);  - Nik */
                parkingperYear_NFT = ((currentObj.PBS_AAAP_Unreserved_Surface__c*currentObj.Non_reserved_surface_Spaces_for_GOVs__c +
                        currentObj.PBS_AAAP_Unreserved_Structured__c*currentObj.Unreserved_Structured_spaces_for_GOVs__c+
                        currentObj.PBS_AAAP_Reserved_Surface__c*currentObj.Reserved_Surface_Spaces_for_GOVs__c+
                        currentObj.PBS_AAAP_Reserved_Structured__c*currentObj.Reserved_Structured_Spaces_for_GOVs__c)*12).setScale(2);
                /*parkingperYear_NFT = ((offer.PBS_AAAP_Monthly_cost_nonres_sur_park__c*currentObj.Non_reserved_surface_Spaces_for_GOVs__c +
                        offer.PBS_AAAP_Monthly_cost_nonres_gar_park__c*currentObj.Unreserved_Structured_spaces_for_GOVs__c+
                        offer.PBS_AAAP_Monthly_cost_res_sur_park__c*currentObj.Reserved_Surface_Spaces_for_GOVs__c+
                        offer.PBS_AAAP_Monthly_cost_res_gar_park__c*currentObj.Reserved_Structured_Spaces_for_GOVs__c)*12).setScale(2); - Nik */
            }
            totalAnnualRentperYear_FT = (shellRentperYear_FT + operatingCostsperYear_FT + tenantImprovementperYear_FT + bsacperYear_FT + parkingperYear_FT);
            //totalAnnualRentperYear_FT = totalAnnualRentperYear_FT.setScale(2);
            if(currentObj.PBS_AAAP_Awarded_RSF__c > 0){
                shellRentperRSF_FT = (shellRentperYear_FT/currentObj.PBS_AAAP_Awarded_RSF__c).setScale(6);
                operatingCostsperRSF_FT = (operatingCostsperYear_FT/currentObj.PBS_AAAP_Awarded_RSF__c).setScale(6);
                tenantImprovementperRSF_FT = (tenantImprovementperYear_FT/currentObj.PBS_AAAP_Awarded_RSF__c).setScale(6);
                bsacperRSF_FT = (bsacperYear_FT/currentObj.PBS_AAAP_Awarded_RSF__c).setScale(6);
                parkingperRSF_FT = (parkingperYear_FT/currentObj.PBS_AAAP_Awarded_RSF__c).setScale(6);
                totalAnnualRentperRSF_FT = (shellRentperRSF_FT + operatingCostsperRSF_FT + tenantImprovementperRSF_FT + bsacperRSF_FT + parkingperRSF_FT);

            }

            shellRentperYear_NFT = (currentObj.PBS_AAAP_SELECTED_USF__c*currentObj.PBS_AAAP_Shell_Rent_Per_ABOA_NFT__c).setScale(2);  // rate.PBS_AAAP_FULL_SERV_RENT_OPTION_TERM__c - Nik
            operatingCostsperYear_NFT = (currentObj.PBS_AAAP_SELECTED_USF__c*currentObj.PBS_AAAP_Operating_Costs_Per_ABOA_NFT__c).setScale(2);  // rate.PBS_AAAP_BASE_COST_SRVC_UTIL_PER_ABOA__c - Nik

            totalAnnualRentperYear_NFT = (shellRentperYear_NFT + operatingCostsperYear_NFT + parkingperYear_NFT);
            //totalAnnualRentperYear_FT = totalAnnualRentperYear_FT.setScale(2);
            if(currentObj.PBS_AAAP_Awarded_RSF__c > 0){
                shellRentperRSF_NFT = (shellRentperYear_NFT/currentObj.PBS_AAAP_Awarded_RSF__c).setScale(6);
                operatingCostsperRSF_NFT = (operatingCostsperYear_NFT/currentObj.PBS_AAAP_Awarded_RSF__c).setScale(6);
                parkingperRSF_NFT = (parkingperYear_NFT/currentObj.PBS_AAAP_Awarded_RSF__c).setScale(6);
                totalAnnualRentperRSF_NFT = (shellRentperRSF_NFT + operatingCostsperRSF_NFT + parkingperRSF_NFT);

            }
            if(currentObj.PBS_AAAP_SELECTED_USF__c > 0){
                parkingperABOA_FT = (parkingperYear_FT/currentObj.PBS_AAAP_SELECTED_USF__c).setScale(6);
                parkingperABOA_NFT = (parkingperYear_NFT/currentObj.PBS_AAAP_SELECTED_USF__c).setScale(6);
            }
            totalAnnualRentperABOA_FT = (currentObj.PBS_AAAP_Shell_Rent_Per_Year_ABOA__c + currentObj.PBS_AAAP_Operating_Costs_Per_ABOA__c + TIRperABOA + BSACperABOA + parkingperABOA_FT).setScale(6);  //rate.PBS_AAAP_ANNUAL_AMORT_TI_COSTS__c + rate.PBS_AAAP_BSAC__c + parkingperABOA_FT
            totalAnnualRentperABOA_NFT = (currentObj.PBS_AAAP_Shell_Rent_Per_ABOA_NFT__c + currentObj.PBS_AAAP_Operating_Costs_Per_ABOA_NFT__c + parkingperABOA_NFT).setScale(6);
            if(offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c > 0 && currentObj.PBS_AAAP_Awarded_RSF__c > 0){
                percentageOccupancyByRSF = ((currentObj.PBS_AAAP_Awarded_RSF__c/offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c)*100).setScale(2);
            }
            Double initialTerm = 0.00;
            Double secondaryTerm = 0.00;
            if(leaseTerm == '10 years, 8 firm'){
                initialTerm = 8;
                secondaryTerm = 2;
            }else if(leaseTerm == '15 years, 13 firm'){
                initialTerm = 8;
                secondaryTerm = 7;
            }else if(leaseTerm == '17 years, 15 firm'){
                initialTerm = 8;
                secondaryTerm = 9;
            }else if(leaseTerm == '15 years,10 firm'){
                initialTerm = 10;
                secondaryTerm = 5;
            }else if(leaseTerm == '10 years,5 firm'){
                initialTerm = 5;
                secondaryTerm = 5;
            }else{
                initialTerm = 10;
                secondaryTerm = 0;
            }

            system.debug('*#*#'+totalAnnualRentperYear_FT);
            system.debug('*#*#'+initialTerm);
            system.debug('*#*#'+totalAnnualRentperYear_NFT);
            system.debug('*#*#'+secondaryTerm);

            system.debug('*#*#'+leaseTerm);

            awardTotalContractValue = (totalAnnualRentperYear_FT*initialTerm+totalAnnualRentperYear_NFT*secondaryTerm);

            if(leaseTerm == '25 months, 16 firm' || leaseTerm == '25 months,16 firm') {
                awardTotalContractValue = (totalAnnualRentperYear_FT*16/12+totalAnnualRentperYear_NFT*9/12);
            }else if(leaseTerm == '19 months, 11 firm' || leaseTerm == '19 months,11 firm') {
                awardTotalContractValue = (totalAnnualRentperYear_FT*11/12+totalAnnualRentperYear_NFT*8/12);
            }

            system.debug('*#*#'+awardTotalContractValue);

            //PBS_AAAP_AMORTIZ_RATE_T1_UPTO_20__c
            //Added by Nik for OOLOP-695
            //if(currentObj.PBS_AAAP_IsAwarded__c == TRUE) {

            if(ApexPages.currentPage().getUrl().indexOf('pbs_aaap_awardselectedofferinfo') != -1) {
                currentObj.PBS_AAAP_AWARDED_USF_Temp__c = currentObj.PBS_AAAP_SELECTED_USF__c;
                currentObj.PBS_AAAP_Total_Contract_Amount_Temp__c = awardTotalContractValue;
                system.debug('+*+&&&*+*'+currentObj);
                update currentObj;
                system.debug('+*+&&&*+*'+currentObj);
            }
            //}
        }

        if(currentObj.PBS_AAAP_SELECTED_USF__c != null && currentObj.PBS_AAAP_TI_Allowance__c != null) {
            totTIammountRef = currentObj.PBS_AAAP_SELECTED_USF__c * currentObj.PBS_AAAP_TI_Allowance__c;
            totTIammountRef = totTIammountRef.setScale(2);
        }
        logMethodEnd('PBS_AAAP_AwardSelectedOfferController constructor');
    }
    
    //Method to generate Awarded Offer Due Diligence Word Document
    /* public PageReference downloadDueDiligenceLetter() {

        logMethodStart('downloadDueDiligenceLetter');

        PageReference pref = null;
        pref = Page.PBS_AAAP_AwardSelectedOfferWord;
        pref.getParameters().put('id', currentObj.Id);
        pref.setRedirect(false);

        logMethodEnd('downloadDueDiligenceLetter', pref);
        return pref;    
        
    } */
    
    //New method for Award offer button
    public PageReference prepareDocument() {

        logMethodStart('prepareDocument');

        Savepoint sp0 = Database.setSavepoint();
        String msg = '';
        PageReference ref = null;
        try {
        if(currentObj.PBS_AAAP_SELECTED_USF__c == null || currentObj.PBS_AAAP_SELECTED_USF__c == 0) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Awarded ABOA SF: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
                    //System.debug('Error to be captured' +myMsg);
            }

            currentObj.PBS_AAAP_IsAwarded__c = TRUE;
            currentObj.PBS_AAAP_isSelected__c = FALSE;
            currentObj.PBS_AAAP_AWARDED_USF__c = currentObj.PBS_AAAP_AWARDED_USF_Temp__c;
            currentObj.PBS_AAAP_Total_Contract_Amount__c = currentObj.PBS_AAAP_Total_Contract_Amount_Temp__c;
            currentObj.PBS_AAAP_Awarded_Common_Area_Factor_as__c = awardedCommonAreaFactor;
            currentObj.PBS_AAAP_Awarded_Total_Contract_Value__c = awardTotalContractValue;
            //currentObj.PBS_AAAP_Total_Contract_Amount_Temp__c = awardTotalContractValue;
            //currentObj.PBS_AAAP_AWARDED_USF_Temp__c = currentObj.PBS_AAAP_SELECTED_USF__c;
            currentObj.PBS_AAAP_Shell_Rent_Per_Year_FT__c = shellRentperYear_FT;
            currentObj.PBS_AAAP_Shell_Rent_Per_RSF_FT__c = shellRentperRSF_FT;
            currentObj.PBS_AAAP_Operating_Costs_Per_Year__c = operatingCostsperYear_FT;
            currentObj.PBS_AAAP_Operating_Costs_Per_RSF__c = operatingCostsperRSF_FT;
            currentObj.PBS_AAAP_Tenant_Improvement_Rent_PerYear__c = tenantImprovementperYear_FT;
            currentObj.PBS_AAAP_Tenant_Improvement_Rent_Per_RSF__c = tenantImprovementperRSF_FT;
            currentObj.PBS_AAAP_BSAC_Per_Year__c = bsacperYear_FT;
            currentObj.PBS_AAAP_BSAC_Per_RSF__c = bsacperRSF_FT;
            currentObj.PBS_AAAP_Parking_Per_Year__c = parkingperYear_FT;
            currentObj.PBS_AAAP_Parking_Per_RSF__c = parkingperRSF_FT;
            currentObj.PBS_AAAP_Parking_Per_ABOA__c = parkingperABOA_FT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_Year_FT__c = totalAnnualRentperYear_FT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_RSF_FT__c = totalAnnualRentperRSF_FT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_ABOA_FT__c = totalAnnualRentperABOA_FT;

            currentObj.PBS_AAAP_Shell_Rent_Per_Year_NFT__c = shellRentperYear_NFT;
            currentObj.PBS_AAAP_Shell_Rent_Per_RSF_NFT__c = shellRentperRSF_NFT;
            currentObj.PBS_AAAP_Operating_Costs_Per_Year_NFT__c = operatingCostsperYear_NFT;
            currentObj.PBS_AAAP_Operating_Costs_Per_RSF_NFT__c = operatingCostsperRSF_NFT;
            currentObj.PBS_AAAP_Parking_Per_Year_NFT__c = parkingperYear_NFT;
            currentObj.PBS_AAAP_Parking_Per_RSF_NFT__c = parkingperRSF_NFT;
            currentObj.PBS_AAAP_Parking_Per_ABOA_NFT__c = parkingperABOA_NFT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_Year_NFT__c = totalAnnualRentperYear_NFT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_RSF_NFT__c = totalAnnualRentperRSF_NFT;
            currentObj.PBS_AAAP_Total_Annual_Rent_Per_ABOA_NFT__c = totalAnnualRentperABOA_NFT;

            currentObj.PBS_AAAP_TI_Amortization_Term__c = String.valueOf(tiAmortizationTerm);
            currentObj.PBS_AAAP_BSAC_Amortization_Term__c = String.valueOf(bsacAmortizationTerm);
            currentObj.Percentage_Occupancy_by_RSF__c = percentageOccupancyByRSF;

            if(currentObj.PBS_AAAP_CONTRACT_AWARD_DATE__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Contract Award Date: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
                    //System.debug('Error to be captured' +myMsg);
            }

            if(currentObj.PBS_AAAP_NEW_GSA_LEASE_NUM__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'New GSA Lease #: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
                    //System.debug('Error to be captured' +myMsg);
            }

            if(currentObj.PBS_AAAP_Awarded_RSF__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Awarded RSF: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
                    //System.debug('Error to be captured' +myMsg);
            }

            if(currentObj.PBS_AAAP_PV_RATE__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'PV Rate: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.PBS_AAAP_TI_Allowance__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'TI Allowance: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.PBS_AAAP_BSAC_Placeholder__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'BSAC Amount: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.PBS_AAAP_Unreserved_Surface__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unreserved Surface: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.Non_reserved_surface_Spaces_for_GOVs__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Non-reserved surface Spaces for GOVs: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.PBS_AAAP_Unreserved_Structured__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unreserved Structured: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.Unreserved_Structured_spaces_for_GOVs__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unreserved Structured spaces for GOVs: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.PBS_AAAP_Reserved_Surface__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reserved Surface: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.Reserved_Surface_Spaces_for_GOVs__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reserved Surface Spaces for GOVs: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.PBS_AAAP_Reserved_Structured__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reserved Structured: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }
            if(currentObj.Reserved_Structured_Spaces_for_GOVs__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reserved Structured Spaces for GOVs: You must enter a value');
                    Apexpages.addMessage(myMsg);
                    return null;
            }

            update currentObj;

        /*PageReference pref = null;
        List<PBS_AAAP_Offer_Select_Award_Info__c> updList = new List<PBS_AAAP_Offer_Select_Award_Info__c>();
        List<PBS_AAAP_Offer_Select_Award_Info__c> targetRec = [SELECT Id,
                                                                      PBS_AAAP_Offer_ID__c,
                                                                      PBS_AAAP_AGENCY_REQUIREMENT_ID__c,
                                                                      PBS_AAAP_IsAwarded__c,
                                                                      PBS_AAAP_isSelected__c,
                                                                      PBS_AAAP_AWARDED_USF__c,
                                                                      PBS_AAAP_Total_Contract_Amount__c,
                                                                      PBS_AAAP_AWARDED_USF_Temp__c,
                                                                      PBS_AAAP_Total_Contract_Amount_Temp__c
                                                                      FROM PBS_AAAP_Offer_Select_Award_Info__c
                                                                      WHERE Id =: offerSelectAwardID];
        for(PBS_AAAP_Offer_Select_Award_Info__c rec : targetRec){
            rec.PBS_AAAP_IsAwarded__c = TRUE;
            rec.PBS_AAAP_isSelected__c = FALSE;
            rec.PBS_AAAP_AWARDED_USF__c = rec.PBS_AAAP_AWARDED_USF_Temp__c;
            rec.PBS_AAAP_Total_Contract_Amount__c = rec.PBS_AAAP_Total_Contract_Amount_Temp__c;
            updList.add(rec);
        }
        if(!updList.isEmpty()){
            update updList;
        }*/

        List<PBS_AAAP_Offer__c> updOffer = new List<PBS_AAAP_Offer__c>();
        List<PBS_AAAP_Offer__c> offer = new List<PBS_AAAP_Offer__c>();
        offer = [
                SELECT Id, Name, PBS_AAAP_Building_Name__c, PBS_AAAP_Street_Address__c, PBS_AAAP_City__c, PBS_AAAP_State__c, PBS_AAAP_ZipCode__c,
                        PBS_AAAP_Total_SF_Offered__c, PBS_AAAP_Total_Space_Selected__c, PBS_AAAP_Total_Withdraw_Space_Available__c, PBS_AAAP_Offer_Status__c,
                        PBS_AAAP_Monthly_cost_nonres_gar_park__c, PBS_AAAP_Monthly_cost_nonres_sur_park__c,
                        PBS_AAAP_Monthly_cost_res_gar_park__c, PBS_AAAP_Monthly_cost_res_sur_park__c,
                        PBS_AAAP_Owner_Address__c,PBS_AAAP_Owner_State__c,PBS_AAAP_Owner_City__c, PBS_AAAP_Owner_Zip__c, PBS_AAAP_Owner_Main_Phone__c,
                        PBS_AAAP_Email__c, PBS_AAAP_GEN_PURPOSE_RENTABLE__c,PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c, PBS_AAAP_Number_of_floors__c,
                        PBS_AAAP_Vacant_Premise_Rate__c, PBS_AAAP_Owner_Name__c, PBS_AAAP_Total_ABOA_Space_Available__c
                FROM PBS_AAAP_Offer__c
                WHERE id = :currentObj.PBS_AAAP_Offer_ID__c
        ];

        system.debug('Offer details before updating status in prepareDocument() method: ');
        system.debug('**** PBS_AAAP_Offer_Status__c: ' + offer[0].PBS_AAAP_Offer_Status__c);
        system.debug('**** PBS_AAAP_Total_ABOA_Space_Available__c: ' + offer[0].PBS_AAAP_Total_ABOA_Space_Available__c);
        system.debug('**** PBS_AAAP_Total_SF_Offered__c: ' + offer[0].PBS_AAAP_Total_SF_Offered__c);
        system.debug('**** PBS_AAAP_Total_Space_Selected__c: ' + offer[0].PBS_AAAP_Total_Space_Selected__c);   

        if (offer[0].PBS_AAAP_Total_ABOA_Space_Available__c < offer[0].PBS_AAAP_Total_SF_Offered__c) {
            system.debug('**** total ABOA space available is less than total SF offered!!');
            if (offer[0].PBS_AAAP_Total_Space_Selected__c == 0) {
                system.debug('**** total space selected equals zero so set status to Awarded/Submitted!!');
                offer[0].PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;
            } else if (offer[0].PBS_AAAP_Total_Space_Selected__c > 0) {
                system.debug('**** total space selected is greater than zero so set status to Awarded/Pending Review!!');
                offer[0].PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SELECTED;
            } else {
                
                 offer[0].PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;//Added by Poorna
                //system.debug('**** because of above three space field values, logic will not update offer status from ' + offer[0].PBS_AAAP_Offer_Status__c);
            }
            updOffer.add(offer[0]);
        } else {
            //offer[0].PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED;
            system.debug('**** total ABOA space available is NOT less than total SF offered so set status to Awarded/Submitted!!');
            offer[0].PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_AWARDED_SUBMITTED;    //OOLOP-1100
            updOffer.add(offer[0]);
        }

        // Changes made by sguni on 10/29/2012, to not fire the trigger while AAAP manger is Awarding offer.
        PBS_AAAP_OfferHelper.triggerupdate(true);
        system.debug('Updated offer record before DML update command: ' + offer[0].PBS_AAAP_Offer_Status__c);
        update updOffer;
        system.debug('Updated offer record after DML update command: ' + offer[0].PBS_AAAP_Offer_Status__c);
        PBS_AAAP_OfferHelper.triggerupdate(false);
        // change ends

        //List<PBS_AAAP_Agency_Requirement__c> updAgency = new List<PBS_AAAP_Agency_Requirement__c>();
        List<PBS_AAAP_Agency_Requirement__c> agency = new List<PBS_AAAP_Agency_Requirement__c>();
        agency = [SELECT Id, PBS_AAAP_REQ_STATUS__c FROM PBS_AAAP_Agency_Requirement__c WHERE Id = :currentObj.PBS_AAAP_AGENCY_REQUIREMENT_ID__c];
        agency[0].PBS_AAAP_REQ_STATUS__c = PBS_AAAP_GlobalConstants.AGENCYREQSTATUS_AWARDED;
        update agency[0];
        
            ref = Page.PBS_AAAP_AwardSelectedOfferInfo;
            ref.getParameters().put('id', currentObj.Id);
            ref.setRedirect(true);

        system.debug('****currentObj.PBS_AAAP_NEW_GSA_LEASE_NUM__c'+currentObj.PBS_AAAP_NEW_GSA_LEASE_NUM__c);

        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            Database.rollback(sp0);
            ref = null;
        }

        logMethodEnd('prepareDocument', ref);
        return ref;
    }
    /*
    private static double PMT(double tiAmortizationRate,double leaseFirmTermMonths,double tiforNeworContinuingSpace){

        double result = 0;
        if(tiAmortizationRate < 0 || leaseFirmTermMonths == 0 || leaseFirmTermMonths == NULL){
            result = null;
            System.debug('Divide by Zero Error');
        }else if(tiforNeworContinuingSpace == 0) {
            result = 0;
        }else if(tiAmortizationRate == 0){
            result = (-tiforNeworContinuingSpace/leaseFirmTermMonths);
        }else{
            System.debug('***********');
            System.debug(tiAmortizationRate);
            System.debug(tiforNeworContinuingSpace);
            System.debug(tiAmortizationRate);
            System.debug(leaseFirmTermMonths);
            result = (-1)*tiAmortizationRate*tiforNeworContinuingSpace/(1-Math.pow(1+tiAmortizationRate, (-1*leaseFirmTermMonths)));

        }
        System.debug('PMT: '+result);
        return result;
    }
    */
}