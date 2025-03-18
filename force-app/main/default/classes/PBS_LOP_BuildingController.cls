/**
 * Created by nkopparthi on 5/20/19.
 */

public with sharing class PBS_LOP_BuildingController {

    public String offerId { get; set; }
    public String isNew { get; set; }
    public String action { get; set; }
    public string isEditable { get; set; }
    public User userDetail { get; set; }
    public Boolean viewOnly { get; set; }
    public string viewMsg { get; set; }
    public boolean isValidUser { get; set; }
    public PBS_AAAP_Offer__c lopOffer { get; set; }
    public PBS_AAAP_RLP__c rlp { get; set; }
    public Boolean isTerminated { get; set; }
    public String draftMsgFlag { get; set; }
    public String hisString { get; set; }
    public String hubZoneStr { get; set; }
    public String pageURL {get; set;}
    public String selectedASL {get; set;}
    public String selectedAreaType{get; set;} 
    public String pageURLForRedirection{get;set;}    // j.rogers 1/18/2023  SFWS-2105

    public PBS_LOP_BuildingController() {
        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.Contact.Phone, u.Contact.Email, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode FROM User u WHERE u.Id = :UserInfo.getUserId()];
        action = ApexPages.currentPage().getParameters().get('action');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        isNew = ApexPages.currentPage().getParameters().get('isNew');
        isEditable = ApexPages.currentPage().getParameters().get('edit');
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');

        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in a View mode';
        } else {
            viewOnly = false;
        }

        if (ApexPages.currentPage().getParameters().get('offerId') != null) {

            lopOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            /* Added by Ramya to populate approximate construction level and Sales Area Type */
            selectedASL=lopoffer.PBS_AAAP_Approximate_Construction_Level__c;
            selectedAreaType=lopoffer.PBS_AAAP_SITE_AREA_TYPE__c;
            system.debug('*****OFFER' + lopOffer);
            String rlpId = lopOffer.PBS_AAAP_RLP_Number__c;
            rlp = [
                    SELECT PBS_RSAP_Solicitation_G_REX_ID__c,PBS_RSAP_Solicitation_Number__c,PBS_RSAP_Solicitation_Status__c,PBS_RSAP_State__c,
                            PBS_RSAP_Project_Number__c,PBS_RSAP_City__c, PBS_RSAP_Broker__c, PBS_RSAP_Lease_Contracting_Officer__c, PBS_RSAP_Leasing_Specialist__c  //JK 2.9.21 added 3 new GREX contact email fields on RLP here
                    FROM PBS_AAAP_RLP__c
                    WHERE Id = :rlpId
                    LIMIT 1
            ];
            system.debug('JK *****RLP' + rlp);
            if (lopOffer.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
                if (lopOffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                    isTerminated = false;
                } else {
                    isTerminated = true;
                }
                if (isTerminated) {
                    viewOnly = true;
                    viewMsg = 'Project is terminated. Offer opened in a view mode';
                    System.debug('*** isEditable ***' + isEditable);
                } else if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    //viewOnly = true;
                    //viewMsg = 'Project due date has elapsed. Offer opened in a view mode';
                }
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
            if (lopOffer.PBS_RSAP_Historical_Property_Description__c == 'Historic property within a historic district') {
                hisString = 'Historic property within a historic district';
            }
            if (lopOffer.PBS_RSAP_Historical_Property_Description__c == 'Non-historic property or underdeveloped site within a historic district') {
                hisString = 'Non-historic property or underdeveloped site within a historic district';
            }
            if (lopOffer.PBS_RSAP_Historical_Property_Description__c == 'Historic properties outside of historic district') {
                hisString = 'Historic properties outside of historic district';
            }
            if (lopOffer.PBS_RSAP_Historical_Property_Description__c == 'Non-historic property') {
                hisString = 'Non-historic property';
            }
            if (lopOffer.PBS_RSAP_HubZone_Waiver__c == 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference') {
                hubZoneStr = 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference';
            }
            if (lopOffer.PBS_RSAP_HubZone_Waiver__c == 'I am a HUBZone SBC Offeror and do not waive the price evaluation preference') {
                hubZoneStr = 'I am a HUBZone SBC Offeror and do not waive the price evaluation preference';
            }
            if (lopOffer.PBS_RSAP_HubZone_Waiver__c == 'I am not a HUBZone SBC Offeror. This question does not apply to me') {
                hubZoneStr = 'I am not a HUBZone SBC Offeror. This question does not apply to me';
            }

        } else {
            isValidUser = true;
            lopOffer = new PBS_AAAP_Offer__c();
        }
    }

    public PageReference saveBuilding() {
        System.debug('in save method');
        draftMsgFlag = '';
        PageReference p = null;
        try {
            if (lopOffer.id != null) {
                if (hisString == 'Historic property within a historic district') {
                    lopOffer.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
                }
                if (hisString == 'Non-historic property or underdeveloped site within a historic district') {
                    lopOffer.PBS_RSAP_Historical_Property_Description__c = 'Non-historic property or underdeveloped site within a historic district';
                }
                if (hisString == 'Historic properties outside of historic district') {
                    lopOffer.PBS_RSAP_Historical_Property_Description__c = 'Historic properties outside of historic district';
                }
                if (hisString == 'Non-historic property') {
                    lopOffer.PBS_RSAP_Historical_Property_Description__c = 'Non-historic property';
                }
                if (hubZoneStr == 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference';
                }
                if (hubZoneStr == 'I am a HUBZone SBC Offeror and do not waive the price evaluation preference') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone SBC Offeror and do not waive the price evaluation preference';
                }
                if (hubZoneStr == 'I am not a HUBZone SBC Offeror. This question does not apply to me') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am not a HUBZone SBC Offeror. This question does not apply to me';
                }
                if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_WITHDRAWN) {
                    lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                }
                if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                    draftMsgFlag = 'true';
                }
                if(lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c == NULL){
                    lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c = 0;
                }
                if(lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c == NULL){
                    lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c = 0;
                }

                lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c = lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c;
                lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c = lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c;
                lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c = lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c;

                Decimal total = lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c + lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c + lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c;

                if (total != lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_GEN_PURPOSE_RENTABLE_SUM_MSG));
                    return null;
                }


                lopOffer.PBS_AAAP_Offeror__c = userDetail.ContactId;
                lopOffer.PBS_AAAP_Offeror_Primary_Phone_Number__c = userDetail.Contact.Phone;
                lopOffer.PBS_AAAP_Offeror_Email__c = userDetail.Contact.Email;
//SGanti 10/2021                
                //String areaType = lopOffer.PBS_AAAP_SITE_AREA_TYPE__c;
                //System.debug('*** areaType is in  save ' + areaType);
                
                if (lopOffer.PBS_AAAP_Energy_Star__c == 'No') {
                    lopOffer.PBS_AAAP_CERTIFICATION_DATE__c = null;
//SGanti added 10/2021                    
                    
                    if(lopOffer.PBS_RSAP_Energy_Star_Response_No__c != 'Statutory Exception') {
                        lopOffer.PBS_RSAP_Energy_Star_Meets_Exceptions__c = NULL;
                        lopOffer.PBS_AAAP_Energy_Star_Evaluation__c = NULL;
                    }
                    
                } else {
//SGanti added 10/2021                    
                    //lopOffer.PBS_AAAP_Energy_Star_Evaluation__c = NULL;
                    lopOffer.PBS_RSAP_Energy_Star_Response_No__c = NULL;
                    lopOffer.PBS_RSAP_Energy_Star_Meets_Exceptions__c = NULL;
                    lopOffer.PBS_AAAP_Energy_Star_Evaluation__c = NULL;
                }

                if (lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c != 'Yes') {
                    lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c = '';
                }

                try {
                    update lopOffer;
                    System.debug('*** after update lopOffer ***');
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
                    return p;
                }
            } else {
                lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
//SGanti 10/2021                
                //String areaType = lopOffer.PBS_AAAP_SITE_AREA_TYPE__c;
                //System.debug('*** areaType is ' + areaType);
//SGanti 10/2021                
                //Decimal siteSize = lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c;
                //System.debug('*** siteSize is ' + siteSize);
                if (hisString == 'Historic property within a historic district') {
                    lopOffer.PBS_RSAP_Historical_Property_Description__c = 'Historic property within a historic district';
                }
                if (hisString == 'Non-historic property or underdeveloped site within a historic district') {
                    lopOffer.PBS_RSAP_Historical_Property_Description__c = 'Non-historic property or underdeveloped site within a historic district';
                }
                if (hisString == 'Historic properties outside of historic district') {
                    lopOffer.PBS_RSAP_Historical_Property_Description__c = 'Historic properties outside of historic district';
                }
                if (hisString == 'Non-historic property') {
                    lopOffer.PBS_RSAP_Historical_Property_Description__c = 'Non-historic property';
                }
                if (hubZoneStr == 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference';
                }
                if (hubZoneStr == 'I am a HUBZone SBC Offeror and do not waive the price evaluation preference') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone SBC Offeror and do not waive the price evaluation preference';
                }
                if (hubZoneStr == 'I am not a HUBZone SBC Offeror. This question does not apply to me') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am not a HUBZone SBC Offeror. This question does not apply to me';
                }

                lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c = lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c;
                lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c = lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c;
                lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c = lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c;

                Decimal total = lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c + lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c + lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c;

                if (total != lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: ' + PBS_AAAP_GlobalConstants.LOP_GEN_PURPOSE_RENTABLE_SUM_MSG));
                    return null;
                }


                try {
                    insert lopOffer;
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
                    return p;
                }
            }
        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }

      //p = Page.PBS_LOP_Building;
      // J.Rogers 12/22/2022  SFWS-2105
        p = new PageReference('/RSAP/Building');
        p.getParameters().put('offerId', offerId);
        p.getParameters().put('draftMsg', draftMsgFlag);
            // p.setRedirect(true);
            // return p;   

        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Building', Label.LOP_Community_Base_URL+'RSAP-Building');
        System.debug('*****'+pageURLForRedirection);
        return null;
        // end SFWS-2105

    }

    public PageReference redirectToParking() {
        boolean errorflag = FALSE;
        if(lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c == NULL){
            lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c = 0;
        }
        if(lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c == NULL){
            lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c = 0;
        }
        if (lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c != 'Yes') {
            lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c = '';
        }
        if (lopOffer.PBS_AAAP_Building_Name__c == NULL || lopOffer.PBS_AAAP_Building_Name__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 1. Building Name is required.'));
        }
        if (lopOffer.PBS_AAAP_Street_Address__c == NULL || lopOffer.PBS_AAAP_Street_Address__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 2. Street Address is required.'));
        }
        if (lopOffer.PBS_AAAP_City__c == NULL || lopOffer.PBS_AAAP_City__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 3. City is required.'));
        }
        if (lopOffer.PBS_AAAP_State__c == '' || lopOffer.PBS_AAAP_State__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 4. State is required.'));
        }
        if (lopOffer.PBS_AAAP_ZipCode__c == NULL || lopOffer.PBS_AAAP_ZipCode__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 5. 9-Digit Zip Code is required.'));
        }
        if (lopOffer.PBS_AAAP_floors_Suites_in_Offered_Space__c == NULL || lopOffer.PBS_AAAP_floors_Suites_in_Offered_Space__c == 0) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 6. Number of floors is required.'));
        }
        if (lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == NULL || lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c == 0) {
            errorflag = TRUE;
//SGanti reworded error message 10/2021             
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 7. Total Rentable Square Feet (RSF) is required.'));
        }
        if (lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 7a. General Purpose (Office) is required.'));
        }
        if (lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 7b. Warehouse area is required.'));
        }
        if (lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 7c. Other area is required.'));
        }

        lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c = lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c;
        lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c = lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c;
        lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c = lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c == null ? 0.00 : lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c;

        Decimal total = lopOffer.PBS_AAAP_OFFICE_SPACE_RSF__c + lopOffer.PBS_AAAP_RETAIL_SPACE_RSF__c + lopOffer.PBS_AAAP_GARAGE_SPACE_RSF__c;

        if (total != lopOffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: ' + PBS_AAAP_GlobalConstants.LOP_GEN_PURPOSE_RENTABLE_SUM_MSG));
            errorflag = TRUE;
        }

//SGanti renumbered 10/2021        
        if (lopOffer.PBS_RSAP_Year_Built__c == NULL || lopOffer.PBS_RSAP_Year_Built__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 8. Building\'s age is required.'));
        }
//SGanti renumbered 10/2021  
//ramya added 07/2022

        if (lopOffer.PBS_AAAP_Approximate_Construction_Level__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 10. Approximate Level of construction is required.'));
        }
        
        if (lopOffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c == NULL || lopOffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 11. HVAC Operating hours are required.'));
        }
//SGanti renumbered 10/2021        
        
        if (lopOffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == NULL || lopOffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 11. HVAC Operating hours are required.'));
        }
//SGanti renumbered 10/2021        
        
        if (lopOffer.PBS_AAAP_FIRE_SAFETY_CERT__c == NULL || lopOffer.PBS_AAAP_FIRE_SAFETY_CERT__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 12. Fire Safety information is required.'));
        }
//SGanti renumbered 10/2021        
        
        if (lopOffer.PBS_RSAP_Accessibility_Standards_Met__c == NULL || lopOffer.PBS_RSAP_Accessibility_Standards_Met__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 13. Accessibility standards information is required.'));
        }        
        
//SGanti added 10/2021        
        if (lopOffer.PBS_AAAP_Asbestos__c == NULL || lopOffer.PBS_AAAP_Asbestos__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 14. Asbestos information is required.'));
        }
//SGanti renumbered 10/2021        
        
        if (lopOffer.PBS_RSAP_Flood_Plain_Declaration__c == NULL || lopOffer.PBS_RSAP_Flood_Plain_Declaration__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 15. Flood Plains information is required.'));
        }
//SGanti renumbered 10/2021        
        
        if (lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == NULL || lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 16. Seismic information is required.'));
        }
        if (lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'Yes' && (lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c == '' || lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c == NULL)) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 16a. Seismic declaration is required.'));
        }
      
//SGanti commented out 10/2021.        
        
       // if (hisString == NULL || hisString == '') {
       //     errorflag = TRUE;
       //     ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 15. Property historic information is required.'));
       // }

//SGanti commented out 10/2021.        
       // if (lopOffer.PBS_RSAP_Asbestos_Declaration__c == NULL || lopOffer.PBS_RSAP_Asbestos_Declaration__c == '') {
         //   errorflag = TRUE;
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 16. Asbestos declaration is required'));
        //}

        
//SGanti renumbered & reworded energy star error messages 10/2021        

        if (lopOffer.PBS_AAAP_Energy_Star__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 17. Energy Star response is required.'));
        }
        if (lopOffer.PBS_AAAP_Energy_Star__c == 'Yes' && lopOffer.PBS_AAAP_CERTIFICATION_DATE__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 17a. Energy Star certification date is required.'));
        }
        if (lopOffer.PBS_AAAP_Energy_Star__c == 'No' && lopOffer.PBS_RSAP_Energy_Star_Response_No__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 17a. Energy Star category is required.'));
        }
        if (lopOffer.PBS_AAAP_Energy_Star__c == 'No' && lopOffer.PBS_RSAP_Energy_Star_Response_No__c == 'Statutory Exception' && lopOffer.PBS_RSAP_Energy_Star_Meets_Exceptions__c ==NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 17a. Energy Star statutory exception information is required.'));
        }

//SGanti added historic building error messages - 10/2021

        if (lopOffer.PBS_RSAP_Building_is_a_historic_property__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 18. Historic building response is required.'));
        }
        if (lopOffer.PBS_RSAP_Bldg_within_a_historic_district__c == NULL) {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 19. Historic district response is required.'));
        }
        
        if (hubZoneStr == NULL || hubZoneStr == '') {
            errorflag = TRUE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Building Information Page: 20. HubZone information is required.'));
        }
        //boolean errorflag = PBS_AAAP_GlobalConstants.checkOfferBuildingValidations(lopOffer);
        System.debug('=======>>>>>>>>> error flag for checkOfferBuildingValidations **** ::: ' + errorflag + '  offerbuilding Id is ' + lopOffer.id);
        if (errorflag == true) {
            return null;
        }

        saveBuilding();
        String offerId = lopOffer.Id;

        PageReference p = new PageReference('/RSAP/SpacesAndParking');
        p.getParameters().put('offerId', offerId);

        if (draftMsgFlag == 'true') {
            p.getParameters().put('draftMsgFlag', 'true');
        }

        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }
            p.setRedirect(false);
            if(pageURL == NULL || pageURL == ''){
                pageURLForRedirection = p.getUrl();
                pageURLForRedirection = pageURLForRedirection.replace('/RSAP/SpacesAndParking', Label.LOP_Community_Base_URL+'RSAP-SpacesAndParking');
                p.setRedirect(false);
            } else {
                p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pageURL);
                System.debug('*****'+pageURLForRedirection);
               // pageURLForRedirection = p.getUrl();
             // pageURLForRedirection = pageURLForRedirection.replace('/RSAP/SpacesAndParking', Label.LOP_Community_Base_URL+'RSAP-SpacesAndParking');
                p.setRedirect(false);
                //return pr;
            }
            //return p;
            //
            
            return null;
            
    }

    public PageReference actionDeleteOffer() {
        //List<string> spaceidList;
        PageReference pref = null;

        if (lopOffer.Id != null) {
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT || lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
                delete lopOffer;   // Cascade delete - Deletes all Spaces and Othercosts associated with it.
                pref = new PageReference('/RSAP/PortalHome');
                //pref = Page.PBS_LOP_portalHome;
                pref.setRedirect(true);
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + lopOffer.PBS_AAAP_Offer_Status__c +
                        ', you can only delete a Draft offer');
                ApexPages.addMessage(myMsg);
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is not yet saved to perform the delete operation');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    public PageReference actionCancel() {
        PageReference pref = new PageReference('/RSAP/PortalHome');
        //PageReference pref = Page.PBS_LOP_PortalHome;
        pref.setRedirect(true);
        return pref;
    }

/*    public Boolean showEnergyStar = false;

    public PageReference displayEnergyStarText() {
        if (lopOffer.PBS_AAAP_Energy_Star__c == 'No') {
            showEnergyStar = true;
        } else {
            showEnergyStar = false;
        }

        return null;
    }   

    public boolean getShowEnergyStar() {
        if (lopOffer.PBS_AAAP_Energy_Star__c == 'No') {
            showEnergyStar = true;
        } else {
            showEnergyStar = false;
        }
        return showEnergyStar;
    }
*/

//SGanti added logic for energy star response = "No" on 10/2021.
              
    public List<SelectOption> getEnergyStarResponseNo() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('New construction', 'New construction.'));
        options.add(new SelectOption('Insufficient Occupancy', 'Existing building that cannot obtain label due to insufficient occupancy.'));
        options.add(new SelectOption('Statutory Exception', 'Meets one of the statutory exceptions below:'));
        return options;
    }

//SGanti added logic for energy star response = "No" ,"Statutory Exception" on 10/2021.               

    public List<SelectOption> getEnergyStarMeetsExceptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Agency Staying', 'The agency would remain in the Building it currently occupies.'));
        options.add(new SelectOption('Special Category', 'The Lease would be in a Building of historical, architectural, or cultural significance listed or eligible to be listed on the National Register of Historic Places.'));
        options.add(new SelectOption('10k or less', 'The Lease is for 10,000 RSF or less.'));
        return options;
    }    
//SGanti added logic for energy star response = "No" ,"statutory exceptions" "Cost effective or not sub question" on 10/2021.               

    public List<SelectOption> getEnergyStarCost() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Improvements declared', 'Cost effective improvements have been identified and are attached to this offer.'));
        options.add(new SelectOption('no effective improvements', 'There are no cost effective improvements. Supporting documentation is attached to this offer.'));
        return options;
    }      
    
    public List<SelectOption> getStates() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        options.add(new SelectOption('Alaska', 'Alaska'));
        options.add(new SelectOption('Alabama', 'Alabama'));
        options.add(new SelectOption('Arkansas', 'Arkansas'));
        options.add(new SelectOption('Arizona', 'Arizona'));
        options.add(new SelectOption('California', 'California'));
        options.add(new SelectOption('Colorado', 'Colorado'));
        options.add(new SelectOption('Connecticut', 'Connecticut'));
        options.add(new SelectOption('Delaware', 'Delaware'));
        options.add(new SelectOption('District of Columbia', 'District of Columbia'));
        options.add(new SelectOption('Florida', 'Florida'));
        options.add(new SelectOption('Georgia', 'Georgia'));
        options.add(new SelectOption('Hawaii', 'Hawaii'));
        options.add(new SelectOption('Iowa', 'Iowa'));
        options.add(new SelectOption('Idaho', 'Idaho'));
        options.add(new SelectOption('Illinois', 'Illinois'));
        options.add(new SelectOption('Indiana', 'Indiana'));
        options.add(new SelectOption('Kansas', 'Kansas'));
        options.add(new SelectOption('Kentucky', 'Kentucky'));
        options.add(new SelectOption('Louisiana', 'Louisiana'));
        options.add(new SelectOption('Massachusetts', 'Massachusetts'));
        options.add(new SelectOption('Maryland', 'Maryland'));
        options.add(new SelectOption('Maine', 'Maine'));
        options.add(new SelectOption('Michigan', 'Michigan'));
        options.add(new SelectOption('Minnesota', 'Minnesota'));
        options.add(new SelectOption('Missouri', 'Missouri'));
        options.add(new SelectOption('Mississippi', 'Mississippi'));
        options.add(new SelectOption('Montana', 'Montana'));
        options.add(new SelectOption('North Carolina', 'North Carolina'));
        options.add(new SelectOption('North Dakota', 'North Dakota'));
        options.add(new SelectOption('Nebraska', 'Nebraska'));
        options.add(new SelectOption('New Hampshire', 'New Hampshire'));
        options.add(new SelectOption('New Jersey', 'New Jersey'));
        options.add(new SelectOption('New Mexico', 'New Mexico'));
        options.add(new SelectOption('Nevada', 'Nevada'));
        options.add(new SelectOption('New York', 'New York'));
        options.add(new SelectOption('Ohio', 'Ohio'));
        options.add(new SelectOption('Oklahoma', 'Oklahoma'));
        options.add(new SelectOption('Oregon', 'Oregon'));
        options.add(new SelectOption('Pennsylvania', 'Pennsylvania'));
        options.add(new SelectOption('Rhode Island', 'Rhode Island'));
        options.add(new SelectOption('South Carolina', 'South Carolina'));
        options.add(new SelectOption('South Dakota', 'South Dakota'));
        options.add(new SelectOption('Tennessee', 'Tennessee'));
        options.add(new SelectOption('Texas', 'Texas'));
        options.add(new SelectOption('Utah', 'Utah'));
        options.add(new SelectOption('Virginia', 'Virginia'));
        options.add(new SelectOption('Vermont', 'Vermont'));
        options.add(new SelectOption('Washington', 'Washington'));
        options.add(new SelectOption('Wisconsin', 'Wisconsin'));
        options.add(new SelectOption('West Virginia','West Virginia'));
        options.add(new SelectOption('Wyoming', 'Wyoming'));
        options.add(new SelectOption('American Samoa', 'American Samoa'));

        options.add(new SelectOption('Federated States of Micronesia', 'Federated States of Micronesia'));
        options.add(new SelectOption('Guam', 'Guam'));
        options.add(new SelectOption('Northern Mariana Islands', 'Northern Mariana Islands'));
        options.add(new SelectOption('Puerto Rico', 'Puerto Rico'));
        options.add(new SelectOption('U.S. Virgin Islands', 'U.S. Virgin Islands'));
        options.add(new SelectOption('Republic of the Marshall Islands', 'Republic of the Marshall Islands'));
        options.add(new SelectOption('Republic of Palau', 'Republic of Palau'));
        options.add(new SelectOption('Midway Islands', 'Midway Islands'));
        return options;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }

    public List<SelectOption> getItems2() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }

    public List<SelectOption> getSiteSizeItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Square Feet', 'Square Feet'));
        options.add(new SelectOption('Acres', 'Acres'));
        return options;
    }
//SGanti commented out 10/2021. 
/*
    public List<SelectOption> getHistoricTierOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Historic property within a historic district', 'Historic property within a historic district.'));
        options.add(new SelectOption('Non-historic property or underdeveloped site within a historic district', 'Non-historic developed site or non-historic undeveloped site within a historic district.'));
        options.add(new SelectOption('Historic properties outside of historic district', 'Historic property outside of a historic district.'));
        //options.add(new SelectOption('Non-historic property', 'Non-historic property'));
        options.add(new SelectOption('Non-historic property', 'None of the above.'));
        return options;
    }
*/
//SGanti commented out 10/2021. 
/*
    public List<SelectOption> getAsbestosItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Contains no Asbestos-Containing Materials (ACM), or Contains ACM in a stable, solid matrix that is not damaged or subject to damage', 'contains no Asbestos-Containing Materials (ACM), or contains ACM in a stable, solid matrix that is not damaged or subject to damage.'));
        options.add(new SelectOption('Contains ACM not in a stable, solid matrix', 'contains ACM not in a stable, solid matrix.'));
        return options;
    }
*/
//SGanti added logic for Asbestos 10/2021
  
    public List<SelectOption> getAsbestos {
        get {
            List<SelectOption> asbestosOptions = new List<SelectOption>();
            Schema.DescribeFieldResult asbestosDescribe = PBS_AAAP_Offer__c.PBS_AAAP_Asbestos__c.getDescribe();
            List<Schema.PicklistEntry> asbestosPlE = asbestosDescribe.getPicklistValues();
            for( Schema.PicklistEntry obj : asbestosPlE) {
                asbestosOptions.add(new SelectOption(obj.getValue(), obj.getLabel()));
            } 
            return asbestosOptions;
        }  
        set;
        }
    public String[] getAsbestosItems { 
        get {
            List<String> selectedAsbestosItems = new List<String>();        
           List<SelectOption> options = this.getAsbestos;
            for(SelectOption objc : options) {
                if (this.lopOffer.PBS_AAAP_Asbestos__c !=null && this.lopOffer.PBS_AAAP_Asbestos__c.contains(objc.getValue()))
                    selectedAsbestosItems.add(objc.getValue());
            }
            return selectedAsbestosItems;
        }
        public set {
            String selectedCheckBox = '';
            for(String s : value) {
                if (selectedCheckBox == '') 
                    selectedCheckBox += s;
                else selectedCheckBox += ';' + s;
            }
            lopOffer.PBS_AAAP_Asbestos__c = selectedCheckBox;
        }
    }  

//SGanti added logic for accessibility items 10/2021.
 
    public List<SelectOption> getAccessibilityItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets', 'The Property meets the Lease accessibility standards.'));
        options.add(new SelectOption('Will meet', 'The Property will be improved to meet the Lease accessibility standards.'));
        options.add(new SelectOption('Does not meet', 'The Property does not meet the Lease accessibility standards and will not be upgraded.'));
        return options;
    }    

//SGanti reworded options on 10/2021.              
    
    public List<SelectOption> getSeismicOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }
    public List<SelectOption> getSeismicItems() {
        List<SelectOption> options = new List<SelectOption>();
//SGanti reworded options on 10/2021.              
        options.add(new SelectOption('Fully meets seismic requirements or meets an exemption under the RLP', 'The Building either fully meets RLP seismic requirements or meets an exemption.'));
        options.add(new SelectOption('Does not meet seismic requirements, but will be retrofitted to meet seismic requirements', 'The Building will be retrofitted to meet RLP seismic requirements it does not currently meet.'));
        options.add(new SelectOption('Will be constructed to meet seismic requirements', 'The Building will be constructed to meet RLP seismic requirements.'));
        options.add(new SelectOption('Will not meet seismic requirements', 'The Building will not meet RLP seismic requirements.'));
        return options;
    }
    
//SGanti reworded options on 10/2021.        
    
    public List<SelectOption> getFloodPlainItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('in a base (100-year) flood plain', 'The Property is in a base (100-year) floodplain.'));
        options.add(new SelectOption('in a 500-year flood plain', 'The Property is in a (500-year) floodplain.'));
        options.add(new SelectOption('Not in a flood plain', 'The Property is not in a floodplain.'));
        return options;
    }

//SGanti added options on 10/2021.                     
    public List<SelectOption> getFireProtectionItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets', 'The Property meets the Lease fire protection/life safety standards.'));
        options.add(new SelectOption('Will meet', 'The Property will be improved to meet the Lease fire protection/life safety standards.'));
        options.add(new SelectOption('Does not meet', 'The Property does not meet the Lease fire protection/life safety standards and will not be upgraded.'));
        return options;
    }
//Ramya added option for 10th question 2021/06/24
    public List<SelectOption> getConstructionLevelItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Improvements needed', 'Improvements to the existing Building will be required to meet the building shell requirements.'));
        options.add(new SelectOption('Already Meets', 'The Building already meets all the Lease shell requirements; no improvements are necessary.'));
        options.add(new SelectOption('New Construction', 'The requirements of the Lease will be satisfied through the construction of a new building.'));
        return options;
    }

    public List<SelectOption> getHubZoneItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference', 'I am a HUBZone SBC Offeror and I elect to waive the price evaluation preference.'));
        options.add(new SelectOption('I am a HUBZone SBC Offeror and do not waive the price evaluation preference', 'I am a HUBZone SBC Offeror and do not waive the price evaluation preference.'));
        options.add(new SelectOption('I am not a HUBZone SBC Offeror. This question does not apply to me', 'I am not a HUBZone SBC Offeror. This question does not apply to me.'));
        return options;
    }

    public void updateOfferDetails(){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        Integer len = Integer.valueOf(Label.PBS_AAAP_KeyLength);
        String randStr = '';

        // generating the random number
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }

        //updating user
        PBS_AAAP_Offer__c offerRec = new PBS_AAAP_Offer__c(id = offerID,
                PBS_AAAP_Session_Key__c = randStr);
        update offerRec;
    }
    
    /*Ramya added to add 10th question: Aproximate Construction Level Dropdown*/
    public PageReference aslToggleAction() {
        lopOffer.PBS_AAAP_Approximate_Construction_Level__c = selectedASL;

        return null;
    } 
    
    /*Ramya added to add 10th question: Area Type dropdown*/
    public PageReference areaTypeAction() {
        lopOffer.PBS_AAAP_SITE_AREA_TYPE__c = selectedAreaType;

        return null;
    } 

}